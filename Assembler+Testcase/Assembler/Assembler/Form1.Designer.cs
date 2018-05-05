namespace Assembler
{
    partial class Form1
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
            this.textBox6 = new System.Windows.Forms.TextBox();
            this.loadProgram = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // textBox6
            // 
            this.textBox6.Location = new System.Drawing.Point(79, 31);
            this.textBox6.Name = "textBox6";
            this.textBox6.Size = new System.Drawing.Size(361, 20);
            this.textBox6.TabIndex = 20;
            // 
            // loadProgram
            // 
            this.loadProgram.Location = new System.Drawing.Point(472, 29);
            this.loadProgram.Name = "loadProgram";
            this.loadProgram.Size = new System.Drawing.Size(96, 23);
            this.loadProgram.TabIndex = 19;
            this.loadProgram.Text = "Browse";
            this.loadProgram.UseVisualStyleBackColor = true;
            this.loadProgram.Click += new System.EventHandler(this.loadProgram_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 34);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(48, 13);
            this.label1.TabIndex = 21;
            this.label1.Text = "File Path";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(246, 66);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(96, 23);
            this.button1.TabIndex = 22;
            this.button1.Text = "Complie";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(596, 101);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBox6);
            this.Controls.Add(this.loadProgram);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Assembler V1.0";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBox6;
        private System.Windows.Forms.Button loadProgram;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button button1;
    }
}

