using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
//C:\intelFPGA_pro\17.0\Pipelined_Processor
namespace Assembler
{
    class Interpreter
    {
        public List<string> Binaries;
        public List<string> Binaries2;
        int flag_ldm_op=0;
        Read fileRead;
        Write writeFile;
        Write WriteFile2;

        public Interpreter()
        {
            Binaries = new List<string>(1024);
            Binaries2 = new List<string>(1024);
            for (int i = 0; i < 1024; i++)
            {
                Binaries2.Add("0000000000000000");
                Binaries.Add("0000000000000000");
            }

            writeFile = new Write();
            WriteFile2 = new Write();
        }

        public void Clear()
        {
            for (int i = 0; i <1024; i++)
            {
                Binaries[i] = "0000000000000000";
                Binaries2[i] = "0000000000000000";
            }
        }

        public int Convert(string text, ref string msgError)
        {
            
            Clear();
            fileRead = new Read(text);
            UInt16 address = 0;
            int i=0;
            try
            {
                for (i = 0; i < fileRead.clearFile.Count; i++)
                {
                    string Code = "";
                    string menmonic = fileRead.clearFile[i];
                    menmonic = menmonic.Trim();
                    if (menmonic == "")
                        continue;
                    List<string> datas = menmonic.Split(' ').ToList();
                    for (int j = 0; j < datas.Count; j++)
                    {
                        if (datas[j] == "")
                            datas.RemoveAt(j);
                    }

                    if (datas.Count == 2)
                    {
                        datas.AddRange(datas[1].Split(',').ToList());
                        datas.RemoveAt(1);
                    }
                    else if (datas.Count == 3)
                    {
                        datas[1] = datas[1].Split(',')[0];
                    }
                    else if (datas.Count == 4 && datas[2] == ",")
                    {
                        datas.RemoveAt(2);
                    }

                    string opcode = datas[0];

                    switch (opcode)
                    {
                        case "":
                            {
                                break;
                            }
                        case "nop":
                            {
                                Code = InstructionsOpcode.Nop;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected Operand";
                                    return i;
                                }
                                Code += "00000000000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "setc":
                            {
                                Code = InstructionsOpcode.SETC;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected Operand";
                                    return i;
                                }
                                Code += "00000000000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "shl":
                            {
                                Code = InstructionsOpcode.SHL;
                                if (datas.Count != 4)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                               
                                reg = FetchOperand(datas[3]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                int oper2 = System.Convert.ToInt32(datas[2]);
                                if (oper2 <= 1)
                                    Code += "000";
                                else if (oper2 <= 3)
                                    Code += "00";
                                else if (oper2 <= 7)
                                    Code += "0";
                                string sh = System.Convert.ToString(oper2, 2);
                                Code += sh;
                                Code += "0";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "shr":
                            {
                                Code = InstructionsOpcode.SHR;
                                if (datas.Count != 4)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                reg = FetchOperand(datas[3]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                int oper2 = System.Convert.ToInt32(datas[2]);
                                if (oper2 <= 1)
                                    Code += "000";
                                else if (oper2 <= 3)
                                    Code += "00";
                                else if (oper2 <= 7)
                                    Code += "0";
                                string sh = System.Convert.ToString(oper2, 2);
                                Code += sh;
                                Code += "0";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "interrupt":
                            {
                                Code = InstructionsOpcode.Interrupt;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected Operand";
                                    return i;
                                }
                                Code += "11100000000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "reset":
                            {
                                Code = InstructionsOpcode.Reset;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected Operand";
                                    return i;
                                }
                                Code += "00000000000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "clrc":
                            {
                                Code = InstructionsOpcode.CLRC;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected Operand";
                                    return i;
                                }
                                Code += "00000000000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "ldd":
                            {
                                Code = InstructionsOpcode.LDD;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                 Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: "+reg;
                                    return i;
                                }
                                else Code += "000";
                                Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                Code = "";
                                UInt32 oper2 = System.Convert.ToUInt32(datas[2]);
                                if(oper2<=1)
                                {
                                    Code += "000000000000000";
                                }
                                else if (oper2 <=3)
                                {
                                    Code += "00000000000000";
                                }
                                else if (oper2 <= 7)
                                {
                                    Code += "0000000000000";
                                }
                                else if (oper2 <= 15)
                                {
                                    Code += "000000000000";
                                }
                                else if (oper2 <= 31)
                                {
                                    Code += "00000000000";
                                }
                                else if (oper2 <= 63)
                                {
                                    Code += "0000000000";
                                }
                                else if (oper2 <= 127)
                                {
                                    Code += "000000000";
                                }
                                else if (oper2 <= 255)
                                {
                                    Code += "00000000";
                                }
                                else if (oper2 <= 511)
                                {
                                    Code += "0000000";
                                }
                                else if (oper2 <= 1023)
                                {
                                    Code += "000000";
                                }
                                if (oper2 >1023)
                                {
                                    msgError = "you exceed the limit of the memory. The memory is 1023 words only";
                                    return i;
                                }
                                string  ea = System.Convert.ToString(oper2, 2);
                               // ea = ea.PadLeft(10);
                                Code += ea;
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "std":
                            {
                                Code = InstructionsOpcode.STD;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                Code = "";
                                UInt32 oper2 = System.Convert.ToUInt32(datas[2]);
                                if (oper2 <= 1)
                                {
                                    Code += "000000000000000";
                                }
                                else if (oper2 <= 3)
                                {
                                    Code += "00000000000000";
                                }
                                else if (oper2 <= 7)
                                {
                                    Code += "0000000000000";
                                }
                                else if (oper2 <= 15)
                                {
                                    Code += "000000000000";
                                }
                                else if (oper2 <= 31)
                                {
                                    Code += "00000000000";
                                }
                                else if (oper2 <= 63)
                                {
                                    Code += "0000000000";
                                }
                                else if (oper2 <= 127)
                                {
                                    Code += "000000000";
                                }
                                else if (oper2 <= 255)
                                {
                                    Code += "00000000";
                                }
                                else if (oper2 <= 511)
                                {
                                    Code += "0000000";
                                }
                                else if (oper2 <= 1023)
                                {
                                    Code += "000000";
                                }
                                if (oper2 > 1023)
                                {
                                    msgError = "you exceed the limit of the memory. The memory is 1023 bytes only";
                                    return i;
                                }

                                string ea = System.Convert.ToString(oper2, 2);
                                //ea = ea.PadLeft(10, '0');
                                Code += ea;
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "ldm":
                            {
                                if(flag_ldm_op==1)
                                {
                                    Code += "0000000000000000";
                                    Binaries[address] = Code;
                                    address++;
                                    Code = "";
                                }
                                Code = "";
                                Code = InstructionsOpcode.LDM;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += "000";
                                Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                Code = "";
                                int oper2 = System.Convert.ToInt32(datas[2]);
                                if (oper2 <= 1)
                                {
                                    if (oper2 >= 0)
                                        Code += "000000000000000";
                                    else
                                        Code += "100000000000000";
                                }
                                else if (oper2 <= 3)
                                {
                                    if (oper2 >= 0)
                                    Code += "00000000000000";
                                    else
                                        Code += "10000000000000";

                                }
                                else if (oper2 <= 7)
                                {
                                    if (oper2 >= 0)
                                    Code += "0000000000000";
                                    else
                                        Code += "1000000000000";
                                }
                                else if (oper2 <= 15)
                                {
                                    if (oper2 >= 0)
                                    Code += "000000000000";
                                    else
                                        Code += "100000000000";
                                }
                                else if (oper2 <= 31)
                                {
                                    if (oper2 >= 0)
                                    Code += "00000000000";
                                    else
                                        Code += "10000000000";
                                }
                                else if (oper2 <= 63)
                                {
                                    if (oper2 >= 0)
                                    Code += "0000000000";
                                    else Code += "1000000000";
                                }
                                else if (oper2 <= 127)
                                {
                                    if (oper2 >= 0)
                                    Code += "000000000";
                                    else Code += "100000000";
                                }
                                else if (oper2 <= 255)
                                {
                                    if (oper2 >= 0)
                                    Code += "00000000";
                                    else Code += "10000000";
                                }
                                else if (oper2 <= 511)
                                {
                                    if (oper2 >= 0)
                                    Code += "0000000";
                                    else
                                        Code += "1000000";
                                }
                                else if (oper2 <= 1023)
                                {
                                    if (oper2 >= 0)
                                    Code += "000000";
                                    else Code += "100000";
                                }
                                else if (oper2 <= 2047)
                                {
                                    if (oper2 >= 0)
                                        Code += "00000";
                                    else Code += "10000";
                                }
                                else if (oper2 <= 4095)
                                {
                                    if (oper2 >= 0)
                                        Code += "0000";
                                    else Code += "1000";
                                }
                                else if (oper2 <= 8191)
                                {
                                    if (oper2 >= 0)
                                        Code += "000";
                                    else Code += "100";
                                }
                                else if (oper2 <= 16383)
                                {
                                    if (oper2 >= 0)
                                        Code += "00";
                                    else Code += "10";
                                }
                                else if (oper2 <= 32767)
                                {
                                    if (oper2 >= 0)
                                        Code += "0";
                                    else Code += "1";
                                }


                                if (oper2 > 65535 || oper2 < -32768)
                                {
                                    msgError = "The value couldn't be fit in one byte";
                                    return i;
                                }
                                string imm = System.Convert.ToString(oper2, 2);
                                
                                Code += imm;
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 1;
                                break;
                            }
                        case "add":
                            {
                                Code = InstructionsOpcode.ADD;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "sub":
                            {
                                Code = InstructionsOpcode.SUB;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "and":
                            {
                                Code = InstructionsOpcode.AND;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }

                        case "or":
                            {
                                Code = InstructionsOpcode.OR;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "not":
                            {
                                Code = InstructionsOpcode.NOT;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "inc":
                            {
                                Code = InstructionsOpcode.INC;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "dec":
                            {
                                Code = InstructionsOpcode.DEC;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "mul":
                            {
                                Code = InstructionsOpcode.MUL;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }

                        case "rlc":
                            {
                                Code = InstructionsOpcode.RLC;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "rrc":
                            {
                                Code = InstructionsOpcode.RRC;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "push":
                            {
                                Code = InstructionsOpcode.PUSH;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "111";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "pop":
                            {
                                Code = InstructionsOpcode.POP;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "111";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "out":
                            {
                                Code = InstructionsOpcode.OUT;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "in":
                            {
                                Code = InstructionsOpcode.IN;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "mov":
                            {
                                Code = InstructionsOpcode.MOV;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "jmp":
                            {
                                Code = InstructionsOpcode.JMP;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "jz":
                            {
                                Code = InstructionsOpcode.JZ;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "jn":
                            {
                                Code = InstructionsOpcode.JN;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "jc":
                            {
                                Code = InstructionsOpcode.JC;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "000";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "call":
                            {
                                Code = InstructionsOpcode.CALL;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "111";
                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "ret":
                            {
                                Code = InstructionsOpcode.RET;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "00011100000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                        case "rti":
                            {
                                Code = InstructionsOpcode.RTI;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                Code += "00011100000";

                                Binaries[address] = Code;
                                address++;
                                flag_ldm_op = 0;
                                break;
                            }
                         default:
                            {
                                Int32 Num;
                                if (opcode[0] == '.' && datas.Count == 1)
                                {
                                    UInt16 add = (UInt16)System.Convert.ToInt16(opcode.Substring(1));
                                    if (add > 1023)
                                    {
                                        msgError = "you exceed the limit of the memory. The memory is 1023 bytes only";
                                        return i;
                                    }
                                    else
                                    {
                                        address = add;
                                        break;
                                    }
                                }
                                else if (Int32.TryParse(opcode, out Num))
                                {                        
                                     if (Num > 65535 || Num < -32768)
                                    {
                                        msgError = "The value couldn't be fit in one word";
                                        return i;
                                    }
                                    else
                                    {
                                        Code = System.Convert.ToString(Num, 2); 
                                        if (Num >= 0)
                                            Code = Code.PadLeft(16, '0');
                                        else
                                            Code = Code.PadLeft(16, '1');
                                        Binaries2[address] = Code;
                                        address++;
                                        break;
                                    }
                                }
                                msgError = "Unknown Instruction "+ datas[0];
                                return i;                             
                                
                            }
                    }
                    if (address > 1023)
                    {
                        msgError = "you exceed the limit of the memory. The memory is 1023 bytes only";
                        return i; 
                    }
                }
                int index = text.LastIndexOf('.');
                string path = text.Substring(0, index+1);
                string path2 = text.Substring(0, index) +"ram" + ".mem";
                path += "mem";
                writeFile.WriteFile(path, Binaries);
                WriteFile2.WriteFile(path2, Binaries2);
                return -1;
            }
            catch(Exception exc)
            {
                return i;
            }

        }

        public string FetchOperand(string s)
        {
            if (s == "r0")
                return "001";
            else if(s == "r1")
                return "010";
            else if(s == "r2")
                return "011";
            else if(s == "r3")
                return "100";
            else if (s == "r4")
                return "101";
            else if (s == "r5")
                return "110";
            else if (s == "r6")
                return "111";
            else return "";
        }
    }
}
