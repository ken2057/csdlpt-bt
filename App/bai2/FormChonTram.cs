using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace bai2
{
    public partial class FormChonTram : Form
    {
        public FormChonTram()
        {
            InitializeComponent();
        }

        private void btnTram1_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLVT_TRAM_1"].ConnectionString;
            createForm(connectionString);
        }

        private void btnTram2_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QLVT_TRAM_2"].ConnectionString;
            createForm(connectionString);
        }

        private void createForm(string connectionString)
        {
            FormMenu f = new FormMenu(connectionString);
            f.ShowDialog();
        }

       

    }
}
