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
    public partial class Form3 : Form
    {
        public Form3()
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
        private OracleConnection conn3 = new OracleConnection(oradb);
        private void LoadData()
        {
            //OracleConnection conn = new OracleConnection(oradb);
            conn3.Open();
            OracleCommand cmd = new OracleCommand();
            cmd.Connection = conn3;
            cmd.CommandText = "SELECT * FROM DKMH";
            cmd.CommandType = CommandType.Text;
            //OracleDataReader dr = cmd.ExecuteReader();
            //dr.Read();
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

            OracleCommand cmd2 = new OracleCommand();
            cmd2.Connection = conn3;
            cmd2.CommandText = "SELECT * FROM KQMH WHERE MASV="+Form4.t_masv;
            //MessageBox.Show(cmd2.CommandText);
            cmd2.CommandType = CommandType.Text;
            //OracleDataReader dr = cmd.ExecuteReader();
            //dr.Read();
            //label1.Text = dr.GetString(0);

            DataSet dataset2 = new DataSet();
            using (OracleDataAdapter dataAdapter2 = new OracleDataAdapter())
            {
                dataAdapter2.SelectCommand = cmd2;
                dataAdapter2.Fill(dataset2);
            }
            dataGridView2.DataSource = dataset2.Tables[0].DefaultView;
            dataGridView2.Update();
            dataGridView2.Refresh();
        }

        private void Form3_Load(object sender, EventArgs e)
        {
            LoadData();
            label3.Text = Form4.t_hotensv;
            label1.Text = Form4.t_masv;
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Tạm thời chức năng này chưa hoàn thiện" + Environment.NewLine + "Mong bạn thông cảm   (╯︵╰,)");
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Filter()
        {

            string v_id;
            string v_monhoc;            

            if (string.IsNullOrEmpty(textBox1.Text) == true)
                v_id = "ID";
            else
                v_id = "'" + textBox1.Text + "'";

            if (string.IsNullOrEmpty(textBox2.Text) == true)
                v_monhoc = "MONHOC";
            else
                v_monhoc = "'" + textBox2.Text + "%"+"'";       

            //MessageBox.Show(v_masv+"--"+v_hoten + "--" +v_namhoc + "--" +v_kyhoc + "--" +v_khoahoc);
            OracleCommand filter_cmd = new OracleCommand();
            filter_cmd.Connection = conn3;

            filter_cmd.CommandText = "SELECT * FROM DKMH WHERE ID=" + v_id + " AND MONHOC LIKE" + v_monhoc;

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



        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
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
                    cell_id_value = "'" + dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString() + "'";

                    //MessageBox.Show(cell_id_value);
                    OracleCommand cmd = new OracleCommand();
                    cmd.Connection = conn3;
                    cmd.CommandText = "SELECT * FROM DKMH WHERE ID=" + cell_id_value;
                    cmd.CommandType = CommandType.Text;
                    //MessageBox.Show(cell_id_value);
                    //MessageBox.Show(cmd.CommandText);
                    DataSet dataset = new DataSet();
                    using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
                    {
                        dataAdapter.SelectCommand = cmd;
                        dataAdapter.Fill(dataset);
                    }
                    //MessageBox.Show(dataset.Tables[0].Rows.Count.ToString());                 
                    //MessageBox.Show(test);
                    textBox3.Text = dataset.Tables[0].Rows[0].ItemArray[0].ToString();
                    textBox4.Text = dataset.Tables[0].Rows[0].ItemArray[1].ToString();
                    textBox5.Text = dataset.Tables[0].Rows[0].ItemArray[2].ToString();
                    textBox7.Text = dataset.Tables[0].Rows[0].ItemArray[3].ToString();
                    textBox8.Text = dataset.Tables[0].Rows[0].ItemArray[4].ToString();
                    textBox9.Text = dataset.Tables[0].Rows[0].ItemArray[5].ToString();
                    textBox10.Text = dataset.Tables[0].Rows[0].ItemArray[6].ToString();
                    textBox11.Text = dataset.Tables[0].Rows[0].ItemArray[7].ToString();


                    OracleCommand cmd5 = new OracleCommand();
                    cmd5.Connection = conn3;
                    cmd5.CommandText = "SELECT CAPACITY FROM CLASSROOM WHERE BUILDING="+"'"+ textBox8.Text +"'"+" AND ROOM_NUMBER="+"'"+ textBox7.Text +"'";
                    cmd5.CommandType = CommandType.Text;
                    //MessageBox.Show(cell_id_value);
                    //MessageBox.Show(cmd5.CommandText);
                    DataSet dataset5 = new DataSet();
                    using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
                    {
                        dataAdapter.SelectCommand = cmd5;
                        dataAdapter.Fill(dataset5);
                    }
                    textBox12.Text = dataset5.Tables[0].Rows[0].ItemArray[0].ToString();



                    //Lay time_slot_id

                    OracleCommand cmdn = new OracleCommand();
                    cmdn.Connection = conn3;
                    cmdn.CommandText = "SELECT TIME_SLOT_ID FROM SECTION WHERE COURSE_ID=" + textBox3.Text;
                    cmdn.CommandType = CommandType.Text;
                    //MessageBox.Show(cell_id_value);
                    //MessageBox.Show(cmdn.CommandText);
                    DataSet datasetn = new DataSet();
                    using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
                    {
                        dataAdapter.SelectCommand = cmdn;
                        dataAdapter.Fill(datasetn);
                    }


                    string i_time_slot_id = datasetn.Tables[0].Rows[0].ItemArray[0].ToString();

                    // Lay thoi gian tu Time_Slot_ID Table
                    // Vi du lieu khong dung, nen phai loc mot so time_slot_id khong co. Damn!
                    string[] avai_time_slot_id = { "A", "B", "C", "D", "E", "F", "G", "H" };
                    if (avai_time_slot_id.Contains(i_time_slot_id))
                    {
                        OracleCommand cmdv = new OracleCommand();
                        cmdv.Connection = conn3;
                        cmdv.CommandText = "SELECT * FROM TIME_SLOT WHERE TIME_SLOT_ID=" + "'" + i_time_slot_id + "'";
                        cmdv.CommandType = CommandType.Text;
                        //MessageBox.Show(cell_id_value);
                        //MessageBox.Show(cmdv.CommandText);
                        DataSet datasetv = new DataSet();
                        using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
                        {
                            dataAdapter.SelectCommand = cmdv;
                            dataAdapter.Fill(datasetv);
                        }
                        string sectionhr = datasetv.Tables[0].Rows[0].ItemArray[2].ToString() + ":" +
                                                datasetv.Tables[0].Rows[0].ItemArray[3].ToString() + " - " +
                                                datasetv.Tables[0].Rows[0].ItemArray[4].ToString() + ":" +
                                                datasetv.Tables[0].Rows[0].ItemArray[5].ToString();
                        textBox6.Text = sectionhr;
                    }
                    else
                    {
                        textBox6.Text = "Chua sap xep lich";
                    }
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

        private void button2_Click(object sender, EventArgs e)
        {
            Filter();
        }
    }
}
