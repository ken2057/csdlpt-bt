using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace bai2.Reports
{
    public partial class FormRpPX : Form
    {
        string connectionString;
        public FormRpPX(string connectionString)
        {
            InitializeComponent();
            this.connectionString = connectionString;
        }

        private void btnXem_Click(object sender, EventArgs e)
        {
            if(txtMaNV.Text == "")
            {
                MessageBox.Show("Nhập mã nhân viên");
                txtMaNV.Focus();
                return;
            }

            loadData();
        }

        private void loadData()
        {
            using (var conn = new SqlConnection(connectionString))
            using (var command = new SqlCommand("sp_get_phieuxuat_theoNV", conn)
            {
                CommandType = CommandType.StoredProcedure
            })
            {
                try
                {
                    conn.Open();

                    command.Parameters.AddWithValue("@manv", txtMaNV.Text);

                    //var rdr = command.ExecuteNonQuery(); // Sử dụng khi không trả về dữ liệu
                    var rdr = command.ExecuteReader(); // Sử dụng khi có trả về dữ liệu

                    List<Class.PHIEUXUAT> listPX = new List<Class.PHIEUXUAT>();
                    while (rdr.Read())
                    {
                        // dùng rdr["<tên cột>"] để lấy dữ liệu trả về từ sp
                        listPX.Add(new Class.PHIEUXUAT()
                        {
                            MANV = rdr["manv"].ToString(),
                            MAPX = rdr["mapx"].ToString(),
                            NGAYXUAT = DateTime.Parse(rdr["ngayxuat"].ToString()),
                            MAKH = rdr["makh"].ToString(),
                            LYDO = rdr["lydo"].ToString(),
                            MAKHO = rdr["makho"].ToString(),
                            MAVT = rdr["mavt"].ToString(),
                            SOLUONG = int.Parse(rdr["soluong"].ToString()),
                            DONGIA = int.Parse(rdr["dongia"].ToString())
                        });
                    }
                    Reports.RpPx RpPx = new Reports.RpPx();
                    RpPx.SetDataSource(listPX);
                    crystalReportViewer1.ReportSource = RpPx;
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Error");
                }
                finally
                {
                    conn.Close();
                }
            }
        }
    }
}
