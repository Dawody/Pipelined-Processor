using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace Assembler
{
    class Read
    {
        StreamReader read;
        public List<string> clearFile;

        public Read(string fileName)
        {
            read = new StreamReader(fileName);
            clearFile = new List<string>();
            Readfile();
        }
        public void Readfile()
        {
            string allFile = read.ReadToEnd();
            read.Close();
            allFile = allFile.ToLower();
            CleanTheFile(allFile);
        }
        void CleanTheFile(string file)
        {
            string[] temp = file.Split('\n');
            RemoveComments(ref temp);
            clearFile.AddRange(temp);
        }
        void RemoveComments(ref string[] file)
        {
            for (int i = 0; i < file.Length; i++)
            {
                if (file[i].Contains(';'))
                {
                    file[i] = file[i].Split(';')[0];
                }
                if (file[i].Contains('\r'))
                    file[i] = file[i].Split('\r')[0];
            }
        }
    }
}
