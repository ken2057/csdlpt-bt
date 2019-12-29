using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace bai2
{
    public partial class FormMenu : Form
    {
        string connectionString;
        public FormMenu(string connectionString)
        {
            InitializeComponent();
            this.connectionString = connectionString;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            dgvKHACHHANG f = new dgvKHACHHANG(connectionString);
            f.ShowDialog();
        }

        private void btnNV_Click(object sender, EventArgs e)
        {
            NHANVIEN f = new NHANVIEN(connectionString);
            f.ShowDialog();
        }

        private void btnPN_Click(object sender, EventArgs e)
        {
            formPHIEUNHAP f = new formPHIEUNHAP(connectionString);
            f.ShowDialog();
        }

        private void btnPX_Click(object sender, EventArgs e)
        {
            formPHIEUXUAT f = new formPHIEUXUAT(connectionString);
            f.ShowDialog();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Reports.FormRpPN f = new Reports.FormRpPN(connectionString);
            f.ShowDialog();
        }

        private void btnRpPX_Click(object sender, EventArgs e)
        {
            Reports.FormRpPX f = new Reports.FormRpPX(connectionString);
            f.ShowDialog();
        }

        private void btnRpNV_Click(object sender, EventArgs e)
        {
            Reports.FormRpNV f = new Reports.FormRpNV(connectionString);
            f.ShowDialog();
        }
    }
}
