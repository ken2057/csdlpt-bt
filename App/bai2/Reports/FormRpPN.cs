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
    public partial class FormRpPN : Form
    {
        string connectionString;
        public FormRpPN(string connectionString)
        {
            InitializeComponent();
            this.connectionString = connectionString;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (txtMaNCC.Text == "")
            {
                MessageBox.Show("Nhập mã NCC");
                txtMaNCC.Focus();
                return;
            }

            loadData();
        }

        private void loadData()
        {
            using (var conn = new SqlConnection(connectionString))
            using (var command = new SqlCommand("sp_get_phieunhap_theoNCC", conn)
            {
                CommandType = CommandType.StoredProcedure
            })
            {
                try
                {
                    conn.Open();

                    command.Parameters.AddWithValue("@mancc", txtMaNCC.Text);

                    //var rdr = command.ExecuteNonQuery(); // Sử dụng khi không trả về dữ liệu
                    var rdr = command.ExecuteReader(); // Sử dụng khi có trả về dữ liệu

                    List<Class.PHIEUNHAP> listPN = new List<Class.PHIEUNHAP>();
                    while (rdr.Read())
                    {
                        // dùng rdr["<tên cột>"] để lấy dữ liệu trả về từ sp
                        listPN.Add(new Class.PHIEUNHAP()
                        {
                            MANV = rdr["manv"].ToString(),
                            MAPN = rdr["MAPN"].ToString(),
                            NGAYNHAP = DateTime.Parse(rdr["NGAYNHAP"].ToString()),
                            MANCC = rdr["MANCC"].ToString(),
                            LYDO = rdr["lydo"].ToString(),
                            MAKHO = rdr["makho"].ToString(),
                            MAVT = rdr["mavt"].ToString(),
                            SOLUONG = int.Parse(rdr["soluong"].ToString()),
                            DONGIA = int.Parse(rdr["dongia"].ToString())
                        });
                    }
                    Reports.RpPN RpPN = new Reports.RpPN();
                    RpPN.SetDataSource(listPN);
                    crystalReportViewer1.ReportSource = RpPN;
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
