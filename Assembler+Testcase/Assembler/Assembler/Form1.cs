using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Assembler
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            converter = new Interpreter();
        }
        Interpreter converter;
        private void loadProgram_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            ofd.Multiselect = false;
            ofd.Filter = " ASM files (*.asm)|*.asm|Text files (*.txt)|*.txt| All files |*.*";
            ofd.CheckFileExists = true;
            ofd.CheckPathExists = true;
            ofd.InitialDirectory = System.IO.Directory.GetCurrentDirectory();
            ofd.ShowDialog();
            textBox6.Text = ofd.FileName;
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox6.Text.Length > 0)
            {
                string error = "";
                int line = converter.Convert(textBox6.Text, ref error);
                if(line == -1)
                    MessageBox.Show("operation done successfully~~~~~~~~~");
                else
                    MessageBox.Show("Error at line "+(line+1)+": "+ error);
            }
            else
            {
                MessageBox.Show("Please Select File");
            }
        }
    }
}
