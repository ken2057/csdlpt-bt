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
    public partial class FormRpNV : Form
    {
        string connectionString;
        public FormRpNV(string connectionString)
        {
            InitializeComponent();
            this.connectionString = connectionString;
            loadData();
        }

        private void crystalReportViewer1_Load(object sender, EventArgs e)
        {
           
        }

        private void loadData()
        {
            using (var conn = new SqlConnection(connectionString))
            using (var command = new SqlCommand("sp_get_nhanvien", conn)
            {
                CommandType = CommandType.StoredProcedure
            })
            {
                try
                {
                    conn.Open();

                    //var rdr = command.ExecuteNonQuery(); // Sử dụng khi không trả về dữ liệu
                    var rdr = command.ExecuteReader(); // Sử dụng khi có trả về dữ liệu

                    List<Class.NHANVIEN> listNV = new List<Class.NHANVIEN>();
                    while (rdr.Read())
                    {
                        // dùng rdr["<tên cột>"] để lấy dữ liệu trả về từ sp
                        listNV.Add(new Class.NHANVIEN()
                        {
                            MANV = rdr["manv"].ToString(),
                            HOTENNV = rdr["hotennv"].ToString(),
                            NGAYSINH = DateTime.Parse(rdr["ngaysinh"].ToString()),
                            GIOITINH = bool.Parse(rdr["gioitinh"].ToString()),
                            DIACHI = rdr["diachi"].ToString(),
                            LOAINV = rdr["loainv"].ToString(),
                            NGAYVAOLAM = DateTime.Parse(rdr["ngayvaolam"].ToString()),
                            LUONGCB = int.Parse(rdr["luongcb"].ToString()),
                            GHICHU = rdr["ghichu"].ToString(),
                            MACN = rdr["macn"].ToString()
                        });
                    }
                    Reports.RpNV RpNV = new Reports.RpNV();
                    RpNV.SetDataSource(listNV);
                    crystalReportViewer1.ReportSource = RpNV;
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
