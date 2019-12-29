namespace bai2
{
    partial class FormMenu
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnNV = new System.Windows.Forms.Button();
            this.btnKH = new System.Windows.Forms.Button();
            this.btnPN = new System.Windows.Forms.Button();
            this.btnPX = new System.Windows.Forms.Button();
            this.btnRpNV = new System.Windows.Forms.Button();
            this.btnRpPX = new System.Windows.Forms.Button();
            this.btnRrPN = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnNV
            // 
            this.btnNV.Location = new System.Drawing.Point(197, 71);
            this.btnNV.Name = "btnNV";
            this.btnNV.Size = new System.Drawing.Size(75, 23);
            this.btnNV.TabIndex = 0;
            this.btnNV.Text = "Nhân viên";
            this.btnNV.UseVisualStyleBackColor = true;
            this.btnNV.Click += new System.EventHandler(this.btnNV_Click);
            // 
            // btnKH
            // 
            this.btnKH.Location = new System.Drawing.Point(316, 71);
            this.btnKH.Name = "btnKH";
            this.btnKH.Size = new System.Drawing.Size(75, 23);
            this.btnKH.TabIndex = 1;
            this.btnKH.Text = "Khách hàng";
            this.btnKH.UseVisualStyleBackColor = true;
            this.btnKH.Click += new System.EventHandler(this.button2_Click);
            // 
            // btnPN
            // 
            this.btnPN.Location = new System.Drawing.Point(197, 128);
            this.btnPN.Name = "btnPN";
            this.btnPN.Size = new System.Drawing.Size(75, 23);
            this.btnPN.TabIndex = 2;
            this.btnPN.Text = "Phiếu nhập";
            this.btnPN.UseVisualStyleBackColor = true;
            this.btnPN.Click += new System.EventHandler(this.btnPN_Click);
            // 
            // btnPX
            // 
            this.btnPX.Location = new System.Drawing.Point(316, 128);
            this.btnPX.Name = "btnPX";
            this.btnPX.Size = new System.Drawing.Size(75, 23);
            this.btnPX.TabIndex = 3;
            this.btnPX.Text = "Phiếu xuất";
            this.btnPX.UseVisualStyleBackColor = true;
            this.btnPX.Click += new System.EventHandler(this.btnPX_Click);
            // 
            // btnRpNV
            // 
            this.btnRpNV.Location = new System.Drawing.Point(184, 233);
            this.btnRpNV.Name = "btnRpNV";
            this.btnRpNV.Size = new System.Drawing.Size(75, 61);
            this.btnRpNV.TabIndex = 4;
            this.btnRpNV.Text = "Báo cáo nhân viên";
            this.btnRpNV.UseVisualStyleBackColor = true;
            this.btnRpNV.Click += new System.EventHandler(this.btnRpNV_Click);
            // 
            // btnRpPX
            // 
            this.btnRpPX.Location = new System.Drawing.Point(292, 233);
            this.btnRpPX.Name = "btnRpPX";
            this.btnRpPX.Size = new System.Drawing.Size(75, 64);
            this.btnRpPX.TabIndex = 5;
            this.btnRpPX.Text = "Báo cáo phiếu xuất";
            this.btnRpPX.UseVisualStyleBackColor = true;
            this.btnRpPX.Click += new System.EventHandler(this.btnRpPX_Click);
            // 
            // btnRrPN
            // 
            this.btnRrPN.Location = new System.Drawing.Point(398, 233);
            this.btnRrPN.Name = "btnRrPN";
            this.btnRrPN.Size = new System.Drawing.Size(75, 61);
            this.btnRrPN.TabIndex = 6;
            this.btnRrPN.Text = "Báo cáo phiếu nhập";
            this.btnRrPN.UseVisualStyleBackColor = true;
            this.btnRrPN.Click += new System.EventHandler(this.button3_Click);
            // 
            // FormMenu
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.btnRrPN);
            this.Controls.Add(this.btnRpPX);
            this.Controls.Add(this.btnRpNV);
            this.Controls.Add(this.btnPX);
            this.Controls.Add(this.btnPN);
            this.Controls.Add(this.btnKH);
            this.Controls.Add(this.btnNV);
            this.Name = "FormMenu";
            this.Text = "Danh mục";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnNV;
        private System.Windows.Forms.Button btnKH;
        private System.Windows.Forms.Button btnPN;
        private System.Windows.Forms.Button btnPX;
        private System.Windows.Forms.Button btnRpNV;
        private System.Windows.Forms.Button btnRpPX;
        private System.Windows.Forms.Button btnRrPN;
    }
}