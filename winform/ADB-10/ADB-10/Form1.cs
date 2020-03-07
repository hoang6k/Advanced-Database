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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void tabPage1_Click(object sender, EventArgs e)
        {

        }


        private const string oradb = "User Id=hoang6k;Password=dota2;Data Source="
                + "(DESCRIPTION ="
                + "(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))"
                + "(CONNECT_DATA ="
                + "(SERVER = DEDICATED)"
                + "(SERVICE_NAME = XE)"
                + ")"
                + ");";
        private OracleConnection conn = new OracleConnection(oradb);
        //private OracleConnection connect = new OracleConnection(oradb);
        private void LoadData()
        {          
            //OracleConnection conn = new OracleConnection(oradb);
            conn.Open();
            OracleCommand cmd = new OracleCommand();
            cmd.Connection = conn;
            cmd.CommandText = "SELECT * FROM vw_bai2";
            cmd.CommandType = CommandType.Text;
            OracleDataReader dr = cmd.ExecuteReader();
            dr.Read();
            //label1.Text = dr.GetString(0);

            DataSet dataset = new DataSet();
            using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
            {
                dataAdapter.SelectCommand = cmd;
                dataAdapter.Fill(dataset);
            }

            dataGridView1.DataSource = dataset.Tables[0].DefaultView;
            dataGridView1.Update();
            dataGridView1.Refresh();

            dataGridView2.DataSource = dataset.Tables[0].DefaultView;
            dataGridView2.Update();
            dataGridView2.Refresh();

            //conn.Dispose();


        }

        private void Filter()
        {

            string v_masv;
            string v_hoten;
            string v_namhoc;
            string v_kyhoc;
            string v_khoahoc;

            if (string.IsNullOrEmpty(textBox1.Text) == true)
                v_masv = "MASV";
            else
                v_masv = "'" + textBox1.Text + "'";

            if (string.IsNullOrEmpty(textBox2.Text) == true)
                v_hoten = "HOTENSV";
            else
                v_hoten = "'"+textBox2.Text+"'";

            if (string.IsNullOrEmpty(textBox3.Text) == true)
                v_namhoc = "NAMHOC";
            else
                v_namhoc = textBox3.Text;

            if (string.IsNullOrEmpty(textBox4.Text) == true)
                v_kyhoc = "KYHOC";
            else
                v_kyhoc = "'" + textBox4.Text + "'";

            if (string.IsNullOrEmpty(textBox5.Text) == true)
                v_khoahoc = "KHOAHOC";
            else
                v_khoahoc = "'" + textBox5.Text + "'";

            //MessageBox.Show(v_masv+"--"+v_hoten + "--" +v_namhoc + "--" +v_kyhoc + "--" +v_khoahoc);
            OracleCommand filter_cmd = new OracleCommand();
            filter_cmd.Connection = conn;

            filter_cmd.CommandText = "SELECT * FROM vw_bai2 WHERE MASV=" + v_masv 
                                    + " AND " + "HOTENSV=" + v_hoten
                                    + " AND " + "NAMHOC=" + v_namhoc
                                    + " AND " + "KYHOC=" + v_kyhoc 
                                    + " AND " + "KHOAHOC=" + v_khoahoc ;

            //MessageBox.Show(filter_cmd.CommandText);
            filter_cmd.CommandType = CommandType.Text;

            DataSet dataset = new DataSet();
            using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
            {
                dataAdapter.SelectCommand = filter_cmd;
                dataAdapter.Fill(dataset);
            }

            dataGridView1.DataSource = dataset.Tables[0].DefaultView;
            dataGridView1.Update();
            dataGridView1.Refresh();

        }

        private void RefreshFilter()
        {
            textBox1.Text = "";
            textBox2.Text = "";
            textBox3.Text = "";
            textBox4.Text = "";
            textBox5.Text = "";
            OracleCommand cmd = new OracleCommand();
            cmd.Connection = conn;
            cmd.CommandText = "SELECT * FROM vw_bai2";
            cmd.CommandType = CommandType.Text;

            DataSet dataset = new DataSet();
            using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
            {
                dataAdapter.SelectCommand = cmd;
                dataAdapter.Fill(dataset);
            }

            dataGridView1.DataSource = dataset.Tables[0].DefaultView;
            dataGridView1.Update();
            dataGridView1.Refresh();           

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Filter();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            RefreshFilter();
            //MessageBox.Show(comboBox1.Text);
        }


        private void button3_Click(object sender, EventArgs e)
        {
            //MessageBox.Show("Cảnh báo: Khi thêm sinh viên, tích lũy tín chỉ sẽ tự động điền 0");
            //AddRecord();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
        }


        private string temp_masv="";
        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try { 
                //MessageBox.Show("RowIndex:  "+e.RowIndex.ToString() + Environment.NewLine + "ColumnIndex:  "+e.ColumnIndex.ToString()
                //                +Environment.NewLine + dataGridView1.Rows[e.RowIndex].Cells[e.ColumnIndex].Value.ToString());

                string cell_id_value;
                if (e.RowIndex < 0)
                {
                    MessageBox.Show("Khong duoc chon vao cot");
                    cell_id_value = "ID";
                }
                else if (string.IsNullOrEmpty(dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString()) == false)
                {
                    cell_id_value = "'"+ dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString()+"'";

                    //MessageBox.Show(cell_id_value);
                    OracleCommand cmd = new OracleCommand();
                    cmd.Connection = conn;
                    cmd.CommandText = "SELECT * FROM STUDENT WHERE ID=" + cell_id_value;
                    cmd.CommandType = CommandType.Text;
                    //MessageBox.Show(cmd.CommandText);
                    DataSet dataset = new DataSet();
                    using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
                    {
                        dataAdapter.SelectCommand = cmd;
                        dataAdapter.Fill(dataset);
                    }
                    //MessageBox.Show(dataset.Tables[0].Rows.Count.ToString());
                    string test = "";
                    for (int i = 0; i < 4; i++)
                    {
                        test += dataset.Tables[0].Rows[0].ItemArray[i].ToString();
                    }
                    //MessageBox.Show(test);
                    temp_masv = cell_id_value;
                }
                else
                {
                    cell_id_value = "ID";
                }
                    // Pass Cell data vao TextBox
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }


        }

        private void button4_Click(object sender, EventArgs e)
        {
           // EditRecord();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            //RemoveRecord();
        }

        private void button6_Click(object sender, EventArgs e)
        {            
            Form2 f2 = new Form2();
            f2.Show();
            //conn.Close();
        }

        private void dataGridView2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Filter2()
        {

            string v_field = comboBox1.Text;
            string v_value;
            if (v_field == "NAMHOC")
            {
                v_value = textBox6.Text;
            }
            else
            {
                v_value = "'" + textBox6.Text + "'";
            }     
             
                //MessageBox.Show(v_masv+"--"+v_hoten + "--" +v_namhoc + "--" +v_kyhoc + "--" +v_khoahoc);
            OracleCommand filter_cmd = new OracleCommand();
            filter_cmd.Connection = conn;

            filter_cmd.CommandText = "SELECT * FROM vw_bai2 WHERE " + v_field + "=" + v_value;

            //MessageBox.Show(filter_cmd.CommandText);
                filter_cmd.CommandType = CommandType.Text;

            DataSet dataset = new DataSet();
                using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
                {
                    dataAdapter.SelectCommand = filter_cmd;
                    dataAdapter.Fill(dataset);
                }

            dataGridView2.DataSource = dataset.Tables[0].DefaultView;
            dataGridView2.Update();
            dataGridView2.Refresh();
        }

        private void button4_Click_1(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(comboBox1.Text) == true)
            {
                MessageBox.Show("Khong duoc de trong bo loc");
            }
            else
            {
                Filter2();
            }
            
        }
        private void RefreshFilter2()
        {
            textBox1.Text = "";
            textBox2.Text = "";
            textBox3.Text = "";
            textBox4.Text = "";
            textBox5.Text = "";
            OracleCommand cmd = new OracleCommand();
            cmd.Connection = conn;
            cmd.CommandText = "SELECT * FROM vw_bai2";
            cmd.CommandType = CommandType.Text;

            DataSet dataset = new DataSet();
            using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
            {
                dataAdapter.SelectCommand = cmd;
                dataAdapter.Fill(dataset);
            }

            dataGridView2.DataSource = dataset.Tables[0].DefaultView;
            dataGridView2.Update();
            dataGridView2.Refresh();

        }
        private void button3_Click_1(object sender, EventArgs e)
        {
            RefreshFilter2();
        }

        private void button5_Click_1(object sender, EventArgs e)
        {
            Form4 f4 = new Form4();
            f4.Show();
        }
    }
}
