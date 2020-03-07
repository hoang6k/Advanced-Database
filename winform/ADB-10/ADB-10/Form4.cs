using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace ADB_10
{
    public partial class Form4 : Form
    {
        public Form4()
        {
            InitializeComponent();
        }
        private const string oradb = "User Id=hoang6k;Password=dota2;Data Source="
                + "(DESCRIPTION ="
                + "(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))"
                + "(CONNECT_DATA ="
                + "(SERVER = DEDICATED)"
                + "(SERVICE_NAME = XE)"
                + ")"
                + ");";
        private OracleConnection conn4 = new OracleConnection(oradb);
        private void button1_Click(object sender, EventArgs e)
        {
            if(string.IsNullOrEmpty(textBox1.Text) == true)
            {
                MessageBox.Show("Khong duoc de trong");
            }
            else
            {
                //conn.Dispose();
                conn4.Open();
                string ii_masv = "'" + textBox1.Text + "'";
                OracleCommand cmd4 = new OracleCommand();
                cmd4.Connection = conn4;
                cmd4.CommandText = "SELECT NAME FROM STUDENT WHERE ID=" + ii_masv;
                cmd4.CommandType = CommandType.Text;

                DataSet dataset = new DataSet();
                using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
                {
                    dataAdapter.SelectCommand = cmd4;
                    dataAdapter.Fill(dataset);
                }
                

                if (dataset.Tables[0].Rows.Count <= 0)
                {
                    //MessageBox.Show("Nhap sai MASV");
                    label2.Text = "Nhập sai";
                    //this.Close();         
                }
                else
                {
                    t_hotensv = dataset.Tables[0].Rows[0].ItemArray[0].ToString();
                    t_masv = textBox1.Text;               
                    Form3 f3 = new Form3();
                    f3.Show();
                    this.Close();                
                }
                conn4.Close();
            }
            
        }
        public static string t_masv;
        public static string t_hotensv;
        private void Form4_Load(object sender, EventArgs e)
        {

        }
    }
}
