namespace bai2
{
    partial class FormChonTram
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
            this.btnTram1 = new System.Windows.Forms.Button();
            this.btnTram2 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnTram1
            // 
            this.btnTram1.Location = new System.Drawing.Point(307, 79);
            this.btnTram1.Name = "btnTram1";
            this.btnTram1.Size = new System.Drawing.Size(161, 73);
            this.btnTram1.TabIndex = 0;
            this.btnTram1.Text = "Trạm 1 - TPHCM";
            this.btnTram1.UseMnemonic = false;
            this.btnTram1.UseVisualStyleBackColor = true;
            this.btnTram1.Click += new System.EventHandler(this.btnTram1_Click);
            // 
            // btnTram2
            // 
            this.btnTram2.Location = new System.Drawing.Point(307, 222);
            this.btnTram2.Name = "btnTram2";
            this.btnTram2.Size = new System.Drawing.Size(161, 66);
            this.btnTram2.TabIndex = 1;
            this.btnTram2.Text = "Trạm 2 - HN";
            this.btnTram2.UseVisualStyleBackColor = true;
            this.btnTram2.Click += new System.EventHandler(this.btnTram2_Click);
            // 
            // FormChonTram
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.btnTram2);
            this.Controls.Add(this.btnTram1);
            this.Name = "FormChonTram";
            this.Text = "Chọn trạm";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnTram1;
        private System.Windows.Forms.Button btnTram2;
    }
}