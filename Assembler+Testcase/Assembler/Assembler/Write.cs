using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Assembler
{
    class Write
    {
        StreamWriter Iwriter;
        const string DEFAULT_TEXT = "//format=mti addressradix=d dataradix=b version=1.0 wordsperline=1";

        public void WriteFile(string TextPath, List<string> data)
        {
            Iwriter = new StreamWriter(TextPath);
            Iwriter.WriteLine(DEFAULT_TEXT);
            int i;
            for ( i = 0; i <= 9; i++)
            {
                    Iwriter.WriteLine("  "+ i +": "+data[i]);
            }
            for ( i = 10; i <= 99; i++)
            {
                    Iwriter.WriteLine(" " + i + ": " + data[i]);
            }
            for (i = 100; i <= 255; i++)
            {
                    Iwriter.WriteLine( i + ": " + data[i]);
            }
            Iwriter.Close();
        }
    }
}
