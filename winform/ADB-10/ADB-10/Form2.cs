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
    public partial class Form2 : Form
    {
        private string current_masv = "";
        public Form2()
        {
            InitializeComponent();
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            LoadData2();
        }

        private const string oradb = "User Id=hoang6k;Password=dota2;Data Source="
                + "(DESCRIPTION ="
                + "(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))"
                + "(CONNECT_DATA ="
                + "(SERVER = DEDICATED)"
                + "(SERVICE_NAME = XE)"
                + ")"
                + ");";
        private OracleConnection conn2 = new OracleConnection(oradb);
        //private OracleConnection connect = new OracleConnection(oradb);
        private void LoadData2()
        {
            //OracleConnection conn = new OracleConnection(oradb);
            conn2.Open();
            OracleCommand cmd = new OracleCommand();
            cmd.Connection = conn2;
            cmd.CommandText = "SELECT ID AS MASV, NAME AS HOTENSV, DEPT_NAME AS KHOAVIEN, TOT_CRED AS TICHLUY FROM STUDENT ORDER BY NAME";
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

            //conn.Dispose();
        }

        private void Filter()
        {
            try
            {
                string v2_masv;


                if (string.IsNullOrEmpty(textBox1.Text) == true)
                    v2_masv = "ID";
                else
                    v2_masv = "'" + textBox1.Text + "'";

                //MessageBox.Show(v_masv+"--"+v_hoten + "--" +v_namhoc + "--" +v_kyhoc + "--" +v_khoahoc);
                OracleCommand filter_cmd = new OracleCommand();
                filter_cmd.Connection = conn2;

                filter_cmd.CommandText = "SELECT ID AS MASV, NAME AS HOTENSV, DEPT_NAME AS KHOAVIEN, TOT_CRED AS TICHLUY FROM STUDENT WHERE ID=" + v2_masv;
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
                if (dataset.Tables[0].Rows.Count > 0)
                { 
                    textBox6.Text = dataset.Tables[0].Rows[0].ItemArray[0].ToString();
                    textBox7.Text = dataset.Tables[0].Rows[0].ItemArray[1].ToString();
                    comboBox1.Text = dataset.Tables[0].Rows[0].ItemArray[2].ToString();
                    textBox9.Text = dataset.Tables[0].Rows[0].ItemArray[3].ToString();
                }
                else
                {
                    textBox6.Text = "";
                    textBox7.Text = "";
                    comboBox1.Text = "All";
                    textBox9.Text = "";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
            
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
                    cmd.Connection = conn2;
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
                    //MessageBox.Show(test);
                    textBox6.Text = dataset.Tables[0].Rows[0].ItemArray[0].ToString();
                    textBox7.Text = dataset.Tables[0].Rows[0].ItemArray[1].ToString();
                    comboBox1.Text = dataset.Tables[0].Rows[0].ItemArray[2].ToString();
                    textBox9.Text = dataset.Tables[0].Rows[0].ItemArray[3].ToString();
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
        private void button1_Click(object sender, EventArgs e)
        {
            Filter();
            current_masv = "'"+ textBox6.Text + "'";
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
        private void AddRecord()
        {
            try
            {
                string i_masv;
                string i_hotensv;
                string i_khoavien;
                //string[] dept_name_array = {}

                if (string.IsNullOrEmpty(textBox6.Text) == true && string.IsNullOrEmpty(textBox7.Text) == true)
                {
                    MessageBox.Show("Khong duoc de trong Ma Sinh Vien va Ho Ten Sinh Vien");
                }
                else
                {
                    i_masv = "'" + textBox6.Text + "'";
                    i_hotensv = "'" + textBox7.Text + "'";
                    i_khoavien = "'" + comboBox1.Text + "'";
                   
                    textBox9.Text = "0";
                    textBox9.Enabled = false;

                    // Check trung ID

                    OracleCommand cmd = new OracleCommand();
                    cmd.Connection = conn2;
                    cmd.CommandText = "SELECT ID FROM STUDENT WHERE ID=" + i_masv;
                    cmd.CommandType = CommandType.Text;
                    //MessageBox.Show(cmd.CommandText);
                    DataSet dataset = new DataSet();
                    using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
                    {
                        dataAdapter.SelectCommand = cmd;
                        dataAdapter.Fill(dataset);
                    }

                    string id_checked;
                    //MessageBox.Show(dataset.Tables[0].Rows.Count.ToString());
                    if (dataset.Tables[0].Rows.Count == 0)
                    {
                        id_checked = "";
                    }
                    else
                    {
                        id_checked = "'" + dataset.Tables[0].Rows[0]["ID"].ToString() + "'";
                    }

                    //MessageBox.Show(i_masv + Environment.NewLine + id_checked);
                    if (id_checked == i_masv)
                    {
                        MessageBox.Show("Ma so sinh vien khong duoc trung nhau");
                    }
                    else
                    {
                        //MessageBox.Show("CHECK");
                        OracleCommand insert_cmd = new OracleCommand();
                        insert_cmd.Connection = conn2;
                        insert_cmd.CommandText = "INSERT INTO STUDENT (ID,NAME,DEPT_NAME,TOT_CRED) VALUES (" + i_masv + "," + i_hotensv + "," + i_khoavien + ",0)";
                        insert_cmd.CommandType = CommandType.Text;

                        //MessageBox.Show(insert_cmd.CommandText);
                        insert_cmd.ExecuteNonQuery();
                        MessageBox.Show("Them sinh vien thanh cong");
                    }
                    textBox9.Enabled = true;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }



        }

        private void button3_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Default value of Tin chi tich luy when adding = 0. Cannot change!");
            AddRecord();
        }
        // Uncommend exec update sql
        
        private void EditRecord()
        {
            try
            {
                #region DECLARE
                string i_masv;
                string i_hotensv;
                string i_khoavien;
                string i_totcred;
                //string[] dept_name_array = {}

                if (string.IsNullOrEmpty(textBox6.Text) == true && string.IsNullOrEmpty(textBox7.Text) == true)
                {
                    MessageBox.Show("Khong duoc de trong Ma Sinh Vien va Ho Ten Sinh Vien");
                }
                else
                {
                    i_masv = "'" + textBox6.Text + "'";
                    i_hotensv = "'" + textBox7.Text + "'";
                    i_totcred = textBox9.Text;
                    i_khoavien = "'" + comboBox1.Text + "'";
                    
                    #endregion
                    // Check trung ID

                    if (i_masv == current_masv) // ID truoc va sau khi dien form update giong nhau >> Khong bi trung >> Tien hanh Update
                    {
                        OracleCommand update_cmd = new OracleCommand();
                        update_cmd.Connection = conn2;
                        update_cmd.CommandText = "UPDATE STUDENT SET ID=" + i_masv + " ,NAME=" + i_hotensv + " ,DEPT_NAME=" + i_khoavien + " ,TOT_CRED=" + i_totcred + "WHERE ID=" + i_masv;
                        update_cmd.CommandType = CommandType.Text;
                        //MessageBox.Show(update_cmd.CommandText + Environment.NewLine + "i_masv  :"+i_masv + Environment.NewLine + "current_masv" + current_masv);
                        update_cmd.ExecuteNonQuery();
                        MessageBox.Show("Chinh sua sinh vien thanh cong. Search lai de kiem tra ket qua!");
                    }
                    else
                    {
                        OracleCommand cmd = new OracleCommand();
                        cmd.Connection = conn2;
                        cmd.CommandText = "SELECT ID FROM STUDENT WHERE ID=" + i_masv;
                        cmd.CommandType = CommandType.Text;
                        //MessageBox.Show(cmd.CommandText);
                        DataSet dataset = new DataSet();
                        using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
                        {
                            dataAdapter.SelectCommand = cmd;
                            dataAdapter.Fill(dataset);
                        }
                        if (dataset.Tables[0].Rows.Count == 0) // Khong co rows nao >> Khong co ID nao duoc select ra >> Khong trung >> Tien hanh Update
                        {
                            OracleCommand update_cmd = new OracleCommand();
                            update_cmd.Connection = conn2;
                            update_cmd.CommandText = "UPDATE STUDENT SET ID=" + i_masv + " ,NAME=" + i_hotensv + " ,DEPT_NAME=" + i_khoavien + " ,TOT_CRED=" + i_totcred + "WHERE ID=" + i_masv;
                            update_cmd.CommandType = CommandType.Text;

                            //MessageBox.Show(update_cmd.CommandText);
                            update_cmd.ExecuteNonQuery();
                            MessageBox.Show("Chinh sua sinh vien thanh cong. Search lai de kiem tra ket qua!");
                        }
                        else
                        {
                            MessageBox.Show("Ma sinh vien moi trung voi sinh vien khac");
                            //MessageBox.Show("i_masv  :" + i_masv + Environment.NewLine + "current_masv" + current_masv);
                        }
                    }

                    // temp_masv >> id cua sinh vien tai cell duoc click vao
                    // i_masv >> id cua sinh vien tai textbox                
                    //Code block ve Update                  
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }


        }

        private void button4_Click(object sender, EventArgs e)
        {
            EditRecord();
        }
        
        private void RemoveRecord()
        {
           try
           {
               MessageBox.Show("Chu y: Khi xoa theo tin chi tich luy, se xoa tat ca sinh vien" + Environment.NewLine + "          co tin chi tich luy < thong tin can nhap");
               #region DECLARE
               string i_masv;
               string i_hotensv;
               string i_khoavien;
               string i_totcred;
               if (string.IsNullOrEmpty(textBox6.Text) == true)
                   i_masv = "ID";
               else
                   i_masv = "'" + textBox6.Text + "'";

               if (string.IsNullOrEmpty(textBox7.Text) == true)
                   i_hotensv = "NAME";
               else
                   i_hotensv = "'" + textBox7.Text + "'";
               if (string.IsNullOrEmpty(textBox9.Text) == true)
                   i_totcred = "999";
               else
                   i_totcred = textBox9.Text;

               switch (comboBox1.Text)
               {
                   case "":
                       i_khoavien = "DEPT_NAME";
                       comboBox1.Text = "All";
                       break;                  
                   case "All":
                       i_khoavien = "DEPT_NAME";
                       break;
                   default:
                       i_khoavien = "'" + comboBox1.Text + "'";
                       break;
               }
               #endregion

               if (i_totcred == "TOT_CRED") // Phong chong xoa tat ca bang STUDENT
               {
                   MessageBox.Show("SQL Injection warning" + Environment.NewLine + "Ban dang co y do xau   凸( ͡° ͜ʖ ͡°)凸");
                   i_totcred = "-1";
               }

               //Kiem tra
               OracleCommand cmd = new OracleCommand();
               cmd.Connection = conn2;
               cmd.CommandText = "SELECT ID FROM STUDENT WHERE ID=" + i_masv + " AND NAME=" + i_hotensv + " AND DEPT_NAME= " + i_khoavien + " AND TOT_CRED =" + i_totcred;
               cmd.CommandType = CommandType.Text;
               MessageBox.Show(cmd.CommandText);
               DataSet dataset = new DataSet();
               using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
               {
                   dataAdapter.SelectCommand = cmd;
                   dataAdapter.Fill(dataset);
               }
               MessageBox.Show(dataset.Tables[0].Rows.Count.ToString());
               if (dataset.Tables[0].Rows.Count == 0)
               {
                   MessageBox.Show("Sinh vien(s) nay khong ton tai trong he thong");
               }
               else
               {
                   OracleCommand delete_cmd = new OracleCommand();
                   delete_cmd.Connection = conn2;
                   delete_cmd.CommandText = "DELETE FROM STUDENT WHERE ID=" + i_masv + " AND NAME=" + i_hotensv + " AND DEPT_NAME= " + i_khoavien + " AND TOT_CRED =" + i_totcred;
                   delete_cmd.CommandType = CommandType.Text;
                   MessageBox.Show(delete_cmd.CommandText);
                   delete_cmd.ExecuteNonQuery();
                   MessageBox.Show("Xoa sinh vien thanh cong");
               }
           }
           catch (Exception ex)
           {
               MessageBox.Show(ex.Message.ToString());
           }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            RemoveRecord();
        }
    }
}
