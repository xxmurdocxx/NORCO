using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ITPI.JSTranscriptPDFReader.AzureComputerVision;
using System.Drawing;
using DocumentFormat.OpenXml.Math;
using Telerik.Web.Design;
using DocumentFormat.OpenXml.Office2010.Excel;
using Telerik.Web.UI.Skins;
using Color = System.Drawing.Color;
using RadGrid = Telerik.Web.UI.RadGrid;
using RadLabel = Telerik.Web.UI.RadLabel;
using System.Web.UI.HtmlControls;
using DocumentFormat.OpenXml.Office.Word;
using Telerik.Web.UI.com.hisoftware.api2;
using System.ComponentModel;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Net.NetworkInformation;
using System.Net.Mail;
using Telerik.ReportViewer.Html5.WebForms;

namespace ems_app.modules.military
{
    public partial class Student : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        public bool exists { get; set; } = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                togglePanels(false);
                hfCollegeID.Value = Session["CollegeID"].ToString();
                hfUserID.Value = Session["UserID"].ToString();
                if (Request["VeteranID"] == null || Request["VeteranID"].ToString() == "0")
                {
                    hfVeteranID.Value = "";
                    btnNewStudent.Text = "Save to Proceed";
                    btnNewStudent.ToolTip = "Must fill required student information to move forward.";
                    student_status_section.Visible = false;
                }
                else
                {
                    togglePanels(true);
                    hfVeteranID.Value = Request["VeteranID"].ToString();
                    GetStudent(hfVeteranID.Value);
                    student_status_section.Visible = true;
                    GetStatusStudent();
                }
                //hfRowColor.Value = Color.LightYellow.Name;
            }
        }
        public void togglePanels(bool enable)
        {
            pnlStudentDocuments.Enabled = enable;
            pnlStudentSummary.Enabled = enable;
            pnlMilitaryCredits.Enabled = enable;
        }

        #region STUDENT STATUS INFORMATION
        private void GetStatusStudent()
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand("GetStudentStatus", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@collegeid", hfCollegeID.Value);
                command.Parameters.AddWithValue("@id", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;

                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    if (dt.Rows[0].ItemArray[0].ToString().Trim() == "1")
                    {
                        DataRow dr = dt.Rows[0];
                        if (dr["IsValidPDFFormat"].ToString() == "False")
                        {
                            divDocUpload.Style.Add("color", "yellow");
                            divDocUpload.Attributes.Add("class", "fa-solid fa-triangle-exclamation fa-2xl");
                            divDocUpload.Attributes.Add("title", "Image file uploaded");
                        }
                        else
                        {
                            divDocUpload.Style.Add("color", "green");
                            divDocUpload.Attributes.Add("class", "fa fa-check-circle fa-2xl");
                            divDocUpload.Attributes.Add("title", "File uploaded successfully");
                        }

                        //divDocUpload.Style.Add("color", "green");
                    }
                    else
                    {
                        divDocUpload.Style.Remove("color");
                    }
                    rlDocUpload.Text = dt.Rows[0].ItemArray[1].ToString();

                    if (dt.Rows[0].ItemArray[2].ToString().Trim() == "1")
                    {
                        hEdPlan.Value = "1";
                        divEdPlan.Style.Add("color", "green");
                    }
                    else
                    {
                        hEdPlan.Value = "0";
                        divEdPlan.Style.Remove("color");
                    }
                    rlEdPlan.Text = dt.Rows[0].ItemArray[3].ToString();

                    if (dt.Rows[0].ItemArray[4].ToString().Trim() == "1")
                    {
                        hGlobalCR.Value = "1";
                        divGlobalCR.Style.Add("color", "green");
                    }
                    else
                    {
                        hGlobalCR.Value = "0";
                        divGlobalCR.Style.Remove("color");
                    }
                    rlGlobalCR.Text = dt.Rows[0].ItemArray[5].ToString();

                    if (dt.Rows[0].ItemArray[6].ToString().Trim() == "1")
                    {
                        hAnalysis.Value = "1";
                        divAnalysis.Style.Add("color", "green");
                    }
                    else
                    {
                        hAnalysis.Value = "0";
                        divAnalysis.Style.Remove("color");
                    }
                    rlAnalysis.Text = dt.Rows[0].ItemArray[7].ToString();

                    if (dt.Rows[0].ItemArray[8].ToString().Trim() == "1")
                    {
                        hApplied.Value = "1";
                        divApplied.Style.Add("color", "green");
                    }
                    else
                    {
                        hApplied.Value = "0";
                        divApplied.Style.Remove("color");
                    }
                    rlApplied.Text = dt.Rows[0].ItemArray[9].ToString();

                    if (dt.Rows[0].ItemArray[10].ToString().Trim() == "1")
                    {
                        hCounselor.Value = "1";
                        divCounselor.Style.Add("color", "green");
                    }
                    else
                    {
                        hCounselor.Value = "0";
                        divCounselor.Style.Remove("color");
                    }
                    rlCounselor.Text = dt.Rows[0].ItemArray[11].ToString();

                    if (dt.Rows[0].ItemArray[12].ToString().Trim() == "1")
                    {
                        hStudent.Value = "1";
                        divStudent.Style.Add("color", "green");
                    }
                    else
                    {
                        hStudent.Value = "0";
                        divStudent.Style.Remove("color");
                    }
                    rlStudent.Text = dt.Rows[0].ItemArray[13].ToString();

                    if (dt.Rows[0].ItemArray[14].ToString().Trim() == "1")
                    {
                        hTranscribed.Value = "1";
                        divTranscribed.Style.Add("color", "green");
                    }
                    else
                    {
                        hTranscribed.Value = "0";
                        divTranscribed.Style.Remove("color");
                    }
                    rlTranscribed.Text = dt.Rows[0].ItemArray[15].ToString();
                }
            }
        }


        protected void btnEdPlan_Click(object sender, EventArgs e)
        {
            if (hEdPlan.Value == "0")
            {
                UpdateStudentStatus(2, 1);
                hEdPlan.Value = "1";
                divEdPlan.Style.Add("color", "green");
            }
            else
            {
                UpdateStudentStatus(2, 0);
                hEdPlan.Value = "0";
                divEdPlan.Style.Remove("color");
            }
        }
        protected void btnGlobalCR_Click(object sender, EventArgs e)
        {
            if (hGlobalCR.Value == "0")
            {
                UpdateStudentStatus(3, 1);
                hGlobalCR.Value = "1";
                divGlobalCR.Style.Add("color", "green");
            }
            else
            {
                UpdateStudentStatus(3, 0);
                hGlobalCR.Value = "0";
                divGlobalCR.Style.Remove("color");
            }
        }
        protected void btnAnalysis_Click(object sender, EventArgs e)
        {
            if (hAnalysis.Value == "0")

            {
                UpdateStudentStatus(4, 1);
                hAnalysis.Value = "1";
                divAnalysis.Style.Add("color", "green");
            }
            else
            {
                UpdateStudentStatus(4, 0);
                hAnalysis.Value = "0";
                divAnalysis.Style.Remove("color");
            }
        }
        protected void btnApplied_Click(object sender, EventArgs e)
        {
            if (hApplied.Value == "0")
            {
                UpdateStudentStatus(5, 1);
                hApplied.Value = "1";
                divApplied.Style.Add("color", "green");
            }
            else
            {
                UpdateStudentStatus(5, 0);
                hApplied.Value = "0";
                divApplied.Style.Remove("color");
            }
        }
        protected void btnCounselor_Click(object sender, EventArgs e)
        {
            if (hCounselor.Value == "0")
            {
                UpdateStudentStatus(6, 1);
                hCounselor.Value = "1";
                divCounselor.Style.Add("color", "green");
            }
            else
            {
                UpdateStudentStatus(6, 0);
                hCounselor.Value = "0";
                divCounselor.Style.Remove("color");
            }
        }
        protected void btnStudent_Click(object sender, EventArgs e)
        {
            if (hStudent.Value == "0")
            {
                UpdateStudentStatus(7, 1);
                hStudent.Value = "1";
                divStudent.Style.Add("color", "green");
            }
            else
            {
                UpdateStudentStatus(7, 0);
                hStudent.Value = "0";
                divStudent.Style.Remove("color");
            }
        }
        protected void btnTranscribed_Click(object sender, EventArgs e)
        {
            if (hTranscribed.Value == "0")
            {
                UpdateStudentStatus(8, 1);
                hTranscribed.Value = "1";
                divTranscribed.Style.Add("color", "green");
            }
            else
            {
                UpdateStudentStatus(8, 0);
                hTranscribed.Value = "0";
                divTranscribed.Style.Remove("color");
            }
        }
        private void UpdateStudentStatus(int nroStatus, int swStatus)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UpdateStudentStatus", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@collegeid", hfCollegeID.Value);
                    cmd.Parameters.AddWithValue("@nroStatus", nroStatus);
                    cmd.Parameters.AddWithValue("@swStatus", swStatus);
                    cmd.Parameters.AddWithValue("@upd_user", hfUserID.Value);
                    cmd.Parameters.AddWithValue("@ID", hfVeteranID.Value);
                    cmd.ExecuteNonQuery();
                }
            }
            GetStatusStudent();
        }
        #endregion

        #region STUDENT INFORMATION
        private void GetStudent(string id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                //Information veteran
                using (SqlCommand command = new SqlCommand("SELECT [FirstName],[MiddleName],[LastName],[StudentID],[MobilePhone],[Email],[ServiceID],[OriginID],[CPLStatusID],[TransferDestination],[StudentPlanNotes], [OptOut] FROM [dbo].[Veteran] WHERE [id] = '" + id + "'", connection))


                {
                    SqlDataAdapter adapter = new SqlDataAdapter();
                    adapter.SelectCommand = command;
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        txtFirstName.Text = dt.Rows[0].ItemArray[0].ToString().Trim();
                        hfFirstName.Value = txtFirstName.Text;
                        //txtMiddleName.Text = dt.Rows[0].ItemArray[1].ToString().Trim();
                        //hfMiddleName.Value = txtMiddleName.Text;
                        txtLastName.Text = dt.Rows[0].ItemArray[2].ToString().Trim();
                        hfLastName.Value = txtLastName.Text;
                        txtID.Text = dt.Rows[0].ItemArray[3].ToString().Trim();
                        hfidn.Value = txtID.Text;
                        txtPhone.Text = dt.Rows[0].ItemArray[4].ToString().Trim();
                        txtEmail.Text = dt.Rows[0].ItemArray[5].ToString().Trim();
                        hfEmail.Value = txtEmail.Text;
                        if (dt.Rows[0].ItemArray[6].ToString() != "")
                        {
                            ddlBranch.SelectedValue = dt.Rows[0].ItemArray[6].ToString().Trim();
                        }
                        rtbTransferDestination.Text = dt.Rows[0].ItemArray[9].ToString().Trim();
                        txtNotes.Text = dt.Rows[0].ItemArray[10].ToString().Trim();
                        rsbOptOut.Checked = Convert.ToBoolean(dt.Rows[0].ItemArray[11].ToString());
                        pnlMilitaryCredits.Visible = true;
                        if (rsbOptOut.Checked == true)
                        {
                            pnlMilitaryCredits.Visible = false;
                        }
                    }
                }
                //Program Goals
                using (SqlCommand command = new SqlCommand("SELECT * FROM [dbo].[VeteranProgramGoals] WHERE [VeteranID] = '" + id + "'", connection))
                {
                    SqlDataAdapter adapter = new SqlDataAdapter();
                    adapter.SelectCommand = command;
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        if (dt.Rows[0].ItemArray[1].ToString() == "True")
                        {
                            ddlGoals.Items[0].Checked = true;
                        }
                        if (dt.Rows[0].ItemArray[2].ToString() == "True")
                        {
                            ddlGoals.Items[1].Checked = true;
                        }
                        if (dt.Rows[0].ItemArray[3].ToString() == "True")
                        {
                            ddlGoals.Items[2].Checked = true;
                        }
                        if (dt.Rows[0].ItemArray[4].ToString() == "True")
                        {
                            ddlGoals.Items[3].Checked = true;
                        }
                        if (dt.Rows[0].ItemArray[5].ToString() == "True")
                        {
                            ddlGoals.Items[4].Checked = true;
                        }
                        if (dt.Rows[0].ItemArray[6].ToString() == "True")
                        {
                            ddlGoals.Items[5].Checked = true;
                        }
                        if (dt.Rows[0].ItemArray[7].ToString() == "True")
                        {
                            ddlGoals.Items[6].Checked = true;
                        }
                    }
                }
                //CPL Type
                using (SqlCommand command = new SqlCommand("SELECT [CPLType], [Value] FROM VeteranCPLType WHERE VeteranID = '" + id + "'", connection))
                {
                    SqlDataAdapter adapter = new SqlDataAdapter();
                    adapter.SelectCommand = command;
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        ddlCPLType.DataBind();
                        foreach (RadComboBoxItem item in ddlCPLType.Items)
                        {
                            if (dt.AsEnumerable().Any(x => x.Field<Int32>("CPLType").ToString() == item.Value && x.Field<bool>("Value") == true))
                            {
                                item.Checked = true;
                            }
                        }
                    }
                }

                //Program Study
                using (SqlCommand command = new SqlCommand("SELECT [VeteranID],[ProgramStudy],[Value] FROM [dbo].[VeteranProgramStudy] WHERE VeteranID = '" + id + "'", connection))
                {
                    SqlDataAdapter adapter = new SqlDataAdapter();
                    adapter.SelectCommand = command;

                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        ddlProgram.DataBind();
                        foreach (RadComboBoxItem item in ddlProgram.Items)
                        {
                            if (dt.AsEnumerable().Any(x => x.Field<Int32>("ProgramStudy").ToString() == item.Value && x.Field<bool>("Value") == true))
                            {
                                item.Checked = true;
                            }
                        }
                    }
                }
            }

        }

        protected void btnNewStudent_Click(object sender, EventArgs e)
        {
            try
            {
                lblErrorID.Visible = false;
                lblerrorEmail.Visible = false;

                //Validate if it's update or new veteran
                bool updated = hfVeteranID.Value == "" ? false : true;

                if (ExistName(txtFirstName.Text.Trim(), txtLastName.Text.Trim(), updated))
                {
                    //if have email, validate exist in system
                    if (txtEmail.Text == "")
                    {
                        RadWindowManager1.RadAlert("You must enter a email for the new student!", 400, 200, "Missing Email", "callBackFn", "myAlertImage.png");
                    }
                    else
                    {
                        if (ExistEmail(txtEmail.Text.Trim(), updated))
                        {
                            lblerrorEmail.Visible = true;
                        }
                        else
                        {
                            if (hfExistVeteran.Value == "")
                            {
                                RadWindowManager1.RadConfirm("There is an existing student with the same first name and last name! Do you want to proceed?", "confirmCallbackFn", 400, 200, null, "Confirm");
                                hfExistVeteran.Value = "1";
                            }
                            else
                            {
                                if (updated)
                                {
                                    Update();
                                }
                                else
                                {
                                    Save();
                                }
                            }
                        }
                    }
                }
                else
                {
                    if (ExistEmail(txtEmail.Text.Trim(), updated))


                    {
                        lblerrorEmail.Visible = true;
                    }
                    else
                    {
                        if (updated)
                        {
                            Update();
                        }
                        else
                        {
                            Save();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }
        private void Save()
        {
            int id = 0;

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                //Information veteran
                using (SqlCommand cmd = new SqlCommand("AddVeteran", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@FirstName", txtFirstName.Text == "" ? null : txtFirstName.Text.Trim()));

                    cmd.Parameters.Add(new SqlParameter("@LastName", txtLastName.Text == "" ? null : txtLastName.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@StudentID", txtID.Text == "" ? null : txtID.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@MobilePhone", txtPhone.Text == "" ? null : txtPhone.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@Email", txtEmail.Text == "" ? null : txtEmail.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@ServiceID", ddlBranch.SelectedValue == "" ? null : ddlBranch.SelectedValue));


                    cmd.Parameters.Add(new SqlParameter("@TransferDestination", rtbTransferDestination.Text == "" ? null : rtbTransferDestination.Text.Trim()));
                    cmd.Parameters.AddWithValue("@CollegeID", hfCollegeID.Value);
                    cmd.Parameters.AddWithValue("@CreatedBy", hfUserID.Value);
                    cmd.Parameters.AddWithValue("@Notes", txtNotes.Text.Trim());
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);

                    cmd.ExecuteNonQuery();

                    id = Convert.ToInt32(outParm.Value);
                    hfVeteranID.Value = id.ToString();
                    btnNewStudent.Text = "Save";
                    btnNewStudent.ToolTip = "";
                    hfFirstName.Value = txtFirstName.Text.Trim();
                    hfLastName.Value = txtLastName.Text.Trim();
                    hfEmail.Value = txtEmail.Text.Trim();
                }

                //Program goals
                using (SqlCommand cmd = new SqlCommand("AddVeteranProgramGoal", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    var collection = ddlGoals.CheckedItems;
                    cmd.Parameters.AddWithValue("@VeteranID", id);
                    cmd.Parameters.AddWithValue("@LocalAAAS", collection.Any(x => x.Value == "0"));
                    cmd.Parameters.AddWithValue("@ADT", collection.Any(x => x.Value == "1"));
                    cmd.Parameters.AddWithValue("@CSU", collection.Any(x => x.Value == "2"));
                    cmd.Parameters.AddWithValue("@UC", collection.Any(x => x.Value == "3"));
                    cmd.Parameters.AddWithValue("@Certificate", collection.Any(x => x.Value == "4"));
                    cmd.Parameters.AddWithValue("@Private", collection.Any(x => x.Value == "5"));
                    cmd.Parameters.AddWithValue("@CareerAdvancement", collection.Any(x => x.Value == "6"));
                    cmd.Parameters.AddWithValue("@Other", collection.Any(x => x.Value == "7"));
                    cmd.ExecuteNonQuery();
                }


                //CPL Type
                string ids = string.Empty;
                foreach (RadComboBoxItem item in ddlCPLType.CheckedItems)
                {
                    ids = ids + item.Value + ",";
                }
                if (ids.Length > 0)
                {
                    ids = ids.Substring(0, ids.Length - 1);
                }
                using (SqlCommand cmd = new SqlCommand("UpdateVeteranCPLType", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@CPLType", ids);
                    cmd.ExecuteNonQuery();
                }

                //Program study
                ids = string.Empty;
                foreach (RadComboBoxItem item in ddlProgram.CheckedItems)
                {
                    ids = ids + item.Value + ",";
                }
                if (ids.Length > 0)
                {
                    ids = ids.Substring(0, ids.Length - 1);
                }

                using (SqlCommand cmd = new SqlCommand("UpdateVeteranProgramStudy", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@ProgramStudy", ids);
                    cmd.ExecuteNonQuery();
                }

                togglePanels(true);

                rnStudent.Text = "Student updated successfully";
                rnStudent.Show();
            }

        }
        private void Update()
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("UpdateVeteran", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@FirstName", txtFirstName.Text == "" ? null : txtFirstName.Text.Trim()));

                    cmd.Parameters.Add(new SqlParameter("@LastName", txtLastName.Text == "" ? null : txtLastName.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@StudentID", txtID.Text == "" ? null : txtID.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@MobilePhone", txtPhone.Text == "" ? null : txtPhone.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@Email", txtEmail.Text == "" ? null : txtEmail.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@ServiceID", ddlBranch.SelectedValue == "" ? null : ddlBranch.SelectedValue));


                    cmd.Parameters.Add(new SqlParameter("@TransferDestination", rtbTransferDestination.Text == "" ? null : rtbTransferDestination.Text.Trim()));
                    cmd.Parameters.AddWithValue("@CollegeID", hfCollegeID.Value);
                    cmd.Parameters.AddWithValue("@UpdatedBy", hfUserID.Value);
                    cmd.Parameters.AddWithValue("@Notes", txtNotes.Text.Trim());
                    cmd.Parameters.AddWithValue("@ID", hfVeteranID.Value);

                    cmd.ExecuteNonQuery();
                    hfFirstName.Value = txtFirstName.Text.Trim();
                    hfLastName.Value = txtLastName.Text.Trim();
                    hfEmail.Value = txtEmail.Text.Trim();
                }

                using (SqlCommand cmd = new SqlCommand("UpdateveteranProgramGoal", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    var collection = ddlGoals.CheckedItems;
                    cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@LocalAAAS", collection.Any(x => x.Value == "0"));
                    cmd.Parameters.AddWithValue("@ADT", collection.Any(x => x.Value == "1"));
                    cmd.Parameters.AddWithValue("@CSU", collection.Any(x => x.Value == "2"));
                    cmd.Parameters.AddWithValue("@UC", collection.Any(x => x.Value == "3"));
                    cmd.Parameters.AddWithValue("@Certificate", collection.Any(x => x.Value == "4"));
                    cmd.Parameters.AddWithValue("@Private", collection.Any(x => x.Value == "5"));
                    cmd.Parameters.AddWithValue("@CareerAdvancement", collection.Any(x => x.Value == "6"));
                    cmd.Parameters.AddWithValue("@Other", collection.Any(x => x.Value == "7"));
                    cmd.ExecuteNonQuery();
                }

                string ids = string.Empty;

                foreach (RadComboBoxItem item in ddlCPLType.CheckedItems)
                {
                    ids = ids + item.Value + ",";
                }
                if (ids.Length > 0)
                {
                    ids = ids.Substring(0, ids.Length - 1);
                }
                using (SqlCommand cmd = new SqlCommand("UpdateVeteranCPLType", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@CPLType", ids);
                    cmd.ExecuteNonQuery();
                }

                ids = string.Empty;
                foreach (RadComboBoxItem item in ddlProgram.CheckedItems)
                {
                    ids = ids + item.Value + ",";
                }
                if (ids.Length > 0)
                {
                    ids = ids.Substring(0, ids.Length - 1);
                }
                using (SqlCommand cmd = new SqlCommand("UpdateVeteranProgramStudy", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@ProgramStudy", ids);
                    cmd.ExecuteNonQuery();
                }
            }


            rnStudent.Text = "Student updated successfully";
            if (exists)
            {
                rnStudent.Text += "<br>NOTICE : It looks like you are attempting to create a duplicate student record.";
            }
            rnStudent.Show();
        }
        private bool ExistEmail(string email, bool update)
        {
            bool result;
            string query;

            if (update)
            {
                if (email == hfEmail.Value)
                {
                    return false;
                }
                query = "SELECT TOP (1) * FROM [dbo].[Veteran] WHERE id <> " + hfVeteranID.Value + " AND  [Email] = '" + email + "' AND [CollegeID] = " + hfCollegeID.Value;
            }
            else
            {
                if (string.IsNullOrEmpty(txtEmail.Text))
                {
                    return false;
                }
                query = "SELECT TOP (1) * FROM [dbo].[Veteran] WHERE [Email] = '" + email + "' AND [CollegeID] = " + hfCollegeID.Value;
            }

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(query, connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    result = true;
                }
                else
                {
                    result = false;
                }
                reader.Close();
            }
            return result;
        }
        private bool ExistName(string firstName, string lastName, bool update)
        {
            bool result = false;
            string query;
            if (update)
            {
                if (firstName == hfFirstName.Value && lastName == hfLastName.Value)
                {
                    return false;
                }
                query = "SELECT TOP (1) * FROM [dbo].[Veteran] WHERE id <> " + hfVeteranID.Value + " AND TRIM([FirstName]) = '" + firstName + "' \n" +
                        "AND TRIM([LastName]) = '" + lastName + "' AND [CollegeID] = " + hfCollegeID.Value;
            }
            else
            {
                query = "SELECT TOP (1) * FROM [dbo].[Veteran] WHERE TRIM([FirstName]) = '" + firstName + "' \n" +
                        "AND TRIM([LastName]) = '" + lastName + "' AND [CollegeID] = " + hfCollegeID.Value;
            }



            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(query, connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    result = true;
                }
                else
                {
                    result = false;
                }
                reader.Close();
            }
            return result;
        }
        #endregion

        #region UPLOAD DOCUMENTS
        protected void btnUploadFire_Click(object sender, EventArgs e)
        {
            // Only event clic is for upload file
        }

        protected void rauDocuments_FileUploaded(object sender, FileUploadedEventArgs e)
        {
            if (htypeDocto.Value == "" || htypeDocto.Value == "0")
            {

                rnStudent.Text = "Select document type";
                rnStudent.Show();
            }
            else
            {
                try
                {
                    // File reading
                    using (Stream stream = e.File.InputStream)
                    {
                        List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs = new List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse>();
                        bool validPdfFormat = false;
                        // Identify if it is JST("1") or another type of file

                        if (htypeDocto.Value == "1")
                        {
                            TelerikPDF.Redaction pdf = new TelerikPDF.Redaction();
                            validPdfFormat = pdf.IsValidPDFFormat(stream);

                            bool jstLooksGood = false;
                            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                            {
                                ImportProcess pdfreader = new ImportProcess(GlobalUtil.ReadSetting("AzureCVEndpoint"), GlobalUtil.ReadSetting("AzureCVSubscriptionKey"));
                                ems_app.Utility.AsyncHelper.RunSync(() => pdfreader.Import(stream));
                                //List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs = pdfreader.SummaryCourseList;

                                string link = "<a style='color:blue' href='" + GlobalUtil.ReadSetting("JSTLink") + "' target='_blank'>here</a>";
                                rnStudent.Text = "";

                                // save records
                                if (string.IsNullOrEmpty(pdfreader.ErrorMessage))
                                {
                                    crs = pdfreader.SummaryCourseList;
                                    LoadACECourses(crs);
                                    LoadCreditRecommendations(crs);
                                    jstLooksGood = true;
                                    rnStudent.Text = $"<strong>JST File loaded successfully.</strong>";

                                    if (!validPdfFormat)
                                    {
                                        rnStudent.Text += $"<br/><br/><strong>JST file was an image file rather than an original PDF.</strong><br/>";
                                        rnStudent.Text += $" <br/><ul><li><span style='font-weight:bold; font-style:italic;'>IMPORTANT: Imaged JSTs may display the student’s Social Security Number and Date of Birth.</span></li>";
                                        rnStudent.Text += $" <li><span style='font-weight:bold; font-style:italic;'>NOTE: MAP redacts these data for original JST.pdf files, but does not do so for imaged files. Please note this for student privacy purposes.</span></li>";
                                        rnStudent.Text += $" <li>Image files cannot be reliably parsed and may result in incomplete or incorrect results.</li>";
                                        rnStudent.Text += $" <li>The file was uploaded and a caution icon " + $"<i class='fa-solid fa-triangle-exclamation' style='color:yellow'></i>" + " was added to Step 1 for the student.</li>";
                                        rnStudent.Text += $" <li>Please review JST and Student Information page and manually add missing credit recommendations if needed.</li></ul>";
                                        rnStudent.Text += $" <br/><strong>To ensure accuracy, we recommend that you obtain an original PDF version of the JST (" + link + ") and reupload the JST. </strong>";

                                    }
                                    rnStudent.Text += $" <br/><br/> Please review the successfully uploaded JST file and manually add missing Ace Exhibits to the Eligible Credits table using the <strong>Manually Add Exhibit</strong> button.";

                                }
                                else
                                {
                                    rnStudent.Text = $"<strong>JST File had an error and was not uploaded and a student profile was not created.</strong> - ERROR MESSAGE: " + pdfreader.ErrorMessage + $"<br/>";
                                    rnStudent.Text += $" <br/>There are two options for this student:";
                                    rnStudent.Text += $" <br/> 1.	Upload an another PDF version of the JST (see " + link + " to obtain a JST).";
                                    rnStudent.Text += $" <br/> 2.	Use the <strong>Manually Add Student</strong> button on the Student Log to manually create the student; Click on the pencil icon to edit the student record; Click <strong>Manually Add Exhibit</strong> to add the credit recommendations listed on the JST summary page.";
                                }

                                rnStudent.Show();
                            }
                            if (jstLooksGood)
                            {
                                exists = false;
                                using (Stream streamJST = e.File.InputStream)
                                {
                                    byte[] fileByes = new byte[streamJST.Length];
                                    streamJST.Position = 0;
                                    streamJST.Read(fileByes, 0, fileByes.Length);
                                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                                    {
                                        SqlCommand cmd = new SqlCommand("INSERT INTO [dbo].[VeteranDocuments] ([Filename],[FileDescription],[BinaryData],[user_id],[VeteranID],[Field],[DocumentTypeID],IsValidPdfFormat)" +
                                                             " VALUES(@Filename, @FileDescription, @BinaryData, @user_id, @VeteranID, @Field, @documenttypeid,@IsValidPdfFormat)", conn);

                                        conn.Open();
                                        cmd.Parameters.AddWithValue("@FileName", e.File.FileName.Replace(",", "_").Replace(";", "_"));
                                        cmd.Parameters.AddWithValue("@FileDescription", e.File.FileName.Replace(",", "_").Replace(";", "_"));
                                        cmd.Parameters.Add("@BinaryData", SqlDbType.VarBinary, fileByes.Length).Value = fileByes;
                                        cmd.Parameters.AddWithValue("@user_id", hfUserID.Value);
                                        cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                                        cmd.Parameters.AddWithValue("@Field", "student_joint_services");
                                        cmd.Parameters.AddWithValue("@documenttypeid", htypeDocto.Value);
                                        cmd.Parameters.AddWithValue("@IsValidPdfFormat", validPdfFormat);

                                        if (conn.State == ConnectionState.Open)
                                        {
                                            conn.Close();
                                        }
                                        conn.Open();

                                        if (Controllers.Veteran.CheckVeteranDocumentExists(Convert.ToInt32(hfVeteranID.Value), e.File.FileName.Replace(",", "_").Replace(";", "_"), e.File.FileName.Replace(",", "_").Replace(";", "_")) == 0)
                                        {
                                            int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());
                                            UpdateStudentStatus(1, 1);
                                            rlvDocuments.DataBind();
                                        }
                                        else
                                        {
                                            exists = true;
                                        }
                                        conn.Close();
                                    }

                                }
                            }
                            rgMilitaryCredits.DataBind();
                        }
                        else
                        {
                            byte[] fileByes = new byte[stream.Length];
                            stream.Read(fileByes, 0, fileByes.Length);


                            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                            {
                                const string statement = "INSERT INTO [dbo].[VeteranDocuments] ([Filename],[BinaryData],[user_id],[VeteranID],[Field],[DocumentTypeID])" +
                                                         " VALUES(@Filename, @BinaryData, @user_id, @VeteranID, @Field, @documenttypeid)";

                                using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
                                {
                                    cmd.Parameters.AddWithValue("@FileName", e.File.FileName.Replace(",", "_").Replace(";", "_"));
                                    cmd.Parameters.Add("@BinaryData", SqlDbType.VarBinary, fileByes.Length).Value = fileByes;
                                    cmd.Parameters.AddWithValue("@user_id", hfUserID.Value);
                                    cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                                    cmd.Parameters.AddWithValue("@Field", "student_dd214");
                                    cmd.Parameters.AddWithValue("@documenttypeid", htypeDocto.Value);

                                    connection.Open();

                                    int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());
                                    UpdateStudentStatus(1, 1);
                                    rlvDocuments.DataBind();
                                }
                            }
                        }
                    }
                    htypeDocto.Value = "";
                }
                catch (Exception ex)
                {
                    rnStudent.Text = ex.ToString();
                    rnStudent.Show();
                }
            }
        }

        private void LoadACECourses(List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs)
        {
            DateTime teamrevd = System.DateTime.Now;
            string ids = "";
            //string sql = "SELECT AceID, TeamRevd = MAX(TeamRevd) " +
            //        "FROM AceExhibit acc " +
            //        "WHERE AceID not in ( select AceID from VeteranACECourse where VeteranId = @VeteranID ) " +
            //        "AND   AceID in ({0}) " +
            //        "GROUP BY AceID ";

            DataSet ds = new DataSet();
            //string aceFilter = "  (AE.AceID ='{0}' AND '{1}' BETWEEN ae.StartDate and ae.EndDate) ";
            string aceFilter = "  (AE.AceID ='{0}' AND AE.TeamRevd = (SELECT TeamRevd FROM DBO.fn_GetAceIDbyCourseDate('{0}', '{1}', '{2}')) ) ";
            string aceWhereClause = "";

            string sql = "SELECT AceID = IDs.value,  ae.StartDate, ae.EndDate, " +
                 " TeamRevd = CASE WHEN ae.TeamRevd IS NULL THEN AEMAX.TeamRevd ELSE ae.TeamRevd END, " +
                 " UsingMaxTeamRevd = CASE WHEN ae.TeamRevd IS NULL THEN 1 ELSE 0 END " +
                 " FROM   STRING_split('{0}', ',') IDs " +
                 " LEFT JOIN AceExhibit AE ON IDs.value = AE.AceID AND ( {1} ) " +
                 " LEFT JOIN " +
                 "  (SELECT AceID, TeamRevd = MAX(TeamRevd) FROM AceExhibit GROUP BY AceID) AEMAX  ON IDs.value = AEMAx.AceID " +
                 " WHERE IDs.value not in (select AceID from VeteranACECourse where VeteranId = @VeteranID ) ";


            foreach (ITPI.JSTranscriptPDFReader.Entities.SummaryCourse c in crs)
            {
                if (c.CourseDate != null || Convert.ToString(c.CourseDate) != "")
                {
                    ids += (ids.Length != 0 ? "," : "") + string.Format("{0}", c.AceID);

                    aceWhereClause += aceWhereClause.Length > 0 ? " OR " : "";
                    aceWhereClause += string.Format(aceFilter, c.AceID, c.CourseDate, c.CourseVersion);

                    UpdateAceIDbyCourseDate(c);

                    UpdateVeteranAceCourse(c.AceID, c.CourseDate, c.CourseNumber, c.CourseVersion, Convert.ToInt32(hfVeteranID.Value), Convert.ToInt32(Session["CollegeID"].ToString()));

                    //UpdateVeteranAceCourse(c.AceID, c.CourseDate, c.CourseNumber, c.CourseVersion, Convert.ToInt32(hfVeteranID.Value), Convert.ToInt32(Session["CollegeID"].ToString()));
                }
            }

            sql = string.Format(sql, ids, aceWhereClause);



            using (var adapter = new SqlDataAdapter(sql,
                ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                adapter.SelectCommand.Parameters.Add(new SqlParameter("@VeteranID", hfVeteranID.Value));
                adapter.Fill(ds);
            }

            //if (ds.Tables[0].Rows.Count > 0)
            //{
            //    foreach (DataRow dr in ds.Tables[0].Rows)
            //    {
            //        norco_db.AddVeteranACECourse(dr["AceID"].ToString(), Convert.ToDateTime(dr["TeamRevd"].ToString()), dr["CourseNumber"].ToString(), dr["CourseVersion"].ToString(),
            //        Convert.ToInt32(hfVeteranID.Value),
            //        Convert.ToInt32(Session["CollegeID"].ToString()));
            //    }
            //}
        }

        public static void UpdateAceIDbyCourseDate(ITPI.JSTranscriptPDFReader.Entities.SummaryCourse c)
        {
            DataSet ds = new DataSet();
            string sql = $"select * from fn_GetAceIDbyCourseDate('{c.AceID}','{c.CourseDate}','{c.CourseVersion}');";

            using (var adapter = new SqlDataAdapter(sql, ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                adapter.Fill(ds);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    c.CourseDate = Convert.ToDateTime(dr["TeamRevd"].ToString());
                    c.CourseVersion = dr["VersionNumber"].ToString();
                }
            }
        }

        //public static string GetAceIDbyCourseDate(string _AceID, string _TeamRevDate)
        //{
        //    string result = "";
        //    using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
        //    {
        //        SqlCommand cmd = connection.CreateCommand();
        //        connection.Open();
        //        try
        //        {
        //            cmd.CommandText = $"select TeamRevd from (select TeamRevd from fn_GetAceIDbyCourseDate('{_AceID}','{_TeamRevDate}')) A;";
        //            //result = ((string)cmd.ExecuteScalar());
        //            result = cmd.ExecuteScalar().ToString();
        //        }
        //        finally
        //        {
        //            connection.Close();
        //        }
        //    }
        //    return result;
        //}

        private void UpdateVeteranAceCourse(string AceID, DateTime? TeamRevd, string CourseNumber, string CourseVersion, int VeteranID, int CollegeID)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddVeteranACECourse", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@AceID", AceID);
                    cmd.Parameters.AddWithValue("@TeamRevd", TeamRevd);
                    cmd.Parameters.AddWithValue("@CourseNumber", CourseNumber);
                    cmd.Parameters.AddWithValue("@CourseVersion", CourseVersion);
                    cmd.Parameters.AddWithValue("@VeteranID", VeteranID);
                    cmd.Parameters.AddWithValue("@CollegeID", CollegeID);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        private void LoadCreditRecommendations(List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> cred)
        {
            var credit_recommendation = "";
            foreach (ITPI.JSTranscriptPDFReader.Entities.SummaryCourse c in cred)
            {
                if (c.CreditRecommendations != null)
                {
                    foreach (var item in c.CreditRecommendations)
                    {


                        //if (item.Credit == 0)
                        //{
                        //    credit_recommendation = "";
                        //}
                        //else 
                        if (item.Credit == 1)
                        {
                            credit_recommendation = string.Format("{0} hour in {1}", item.Credit, item.Subject);
                        }
                        else
                        {
                            credit_recommendation = string.Format("{0} hours in {1}", item.Credit, item.Subject);
                        }

                        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                        {
                            SqlCommand cmd = new SqlCommand("INSERT INTO VeteranCreditRecommendations" +
                            "([VeteranId], [AceID],[TeamRevd],[CreditRecommendation],[MilitaryCourseNumber],[CourseVersion],[Level]) " +
                            "VALUES (@VeteranId, @AceID, @TeamRevd, @CreditRecommendation, @CourseNumber, @CourseVersion, @Level) ", conn);

                            conn.Open();

                            cmd.Parameters.AddWithValue("@VeteranId", hfVeteranID.Value);
                            cmd.Parameters.AddWithValue("@AceID", c.AceID);
                            cmd.Parameters.AddWithValue("@TeamRevd", GetTeamRevd(Convert.ToInt32(hfVeteranID.Value), c.AceID));
                            cmd.Parameters.AddWithValue("@CreditRecommendation", credit_recommendation);
                            cmd.Parameters.AddWithValue("@CourseNumber", c.CourseNumber);
                            cmd.Parameters.AddWithValue("@CourseVersion", c.CourseVersion);
                            cmd.Parameters.AddWithValue("@Level", item.Level);
                            int count = cmd.ExecuteNonQuery();
                        }
                    }
                }

            }
        }
        private DateTime GetTeamRevd(int VeteranID, string AceID)
        {
            DateTime TeamRevd = System.DateTime.Now;
            string queryString = $"SELECT distinct TeamRevd FROM VeteranACECourse WHERE VeteranID = {@VeteranID} AND AceID = '{@AceID}' ";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(queryString, conn);
                conn.Open();
                cmd.Parameters.Add(new SqlParameter("@VeteranID", VeteranID));
                cmd.Parameters.Add(new SqlParameter("@AceID", AceID));
                var i = cmd.ExecuteScalar();
                if (i != null)
                    TeamRevd = (DateTime)i;
            }

            return TeamRevd;
        }
        #endregion

        #region ELIGIBLE CREDITS

        protected void rgMilitaryCredits_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                RadTextBox rtbCreditRec = (RadTextBox)dataBoundItem.FindControl("rtbCreditRecommendation") as RadTextBox;
                rtbCreditRec.Visible = false;
                RadLabel rlCreditRec = (RadLabel)dataBoundItem.FindControl("rlCreditRecommendations") as RadLabel;
                rlCreditRec.Visible = false;

                HyperLink hp = (HyperLink)dataBoundItem.FindControl("hlExhibit");
                hp.Text = dataBoundItem["AceExhibit"].Text;
                hp.NavigateUrl = "";
                hp.Attributes.Add("onclick", "event.stopPropagation();");
                if (dataBoundItem["AceID"].Text != "")
                {
                    hp.Attributes.Remove("onclick");
                    hp.NavigateUrl = $"javascript:showExhibitInfo('{dataBoundItem["AceExhibitID"].Text}','{dataBoundItem["Criteria"].Text}')";
                }

                if (dataBoundItem["outline_id"].Text != "0")
                {
                    rlCreditRec.Visible = true;
                }
                else
                {
                    if (dataBoundItem["ExistOtherColleges"].Text == "1")
                    {
                        //btnAdopt.Visible = true;
                    }
                    if (dataBoundItem["Criteria"].Text == "")
                    {
                        rtbCreditRec.Visible = true;
                    }
                    else
                    {
                        rlCreditRec.Visible = true;
                    }
                }
                if (dataBoundItem["Elective"].Text == "1")
                {
                    dataBoundItem.BackColor = Color.LightCyan;
                }
                else
                {
                    if (dataBoundItem["AceID"].Text != hfAceID.Value)
                    {
                        hfAceID.Value = dataBoundItem["AceID"].Text;
                    }
                }
                if (dataBoundItem["CourseType"].Text == "2")
                {
                    dataBoundItem.BackColor = Color.Honeydew;
                }

                Telerik.Web.UI.RadDropDownList ddlAction = (Telerik.Web.UI.RadDropDownList)dataBoundItem.FindControl("ddlAction");
                if (dataBoundItem["DNA"].Text == "True")
                {
                    if (ddlAction != null)
                    {
                        ddlAction.Items.Remove(ddlAction.Items[8]);
                        ddlAction.Items.Remove(ddlAction.Items[7]);
                        ddlAction.Items.Remove(ddlAction.Items[6]);
                        ddlAction.Items.Remove(ddlAction.Items[5]);
                        ddlAction.Items.Remove(ddlAction.Items[4]);
                        ddlAction.Items.Remove(ddlAction.Items[3]);
                        ddlAction.Items.Remove(ddlAction.Items[2]);
                        ddlAction.Items.Remove(ddlAction.Items[1]);
                    }

                    HtmlControl divImplementation = (HtmlControl)dataBoundItem.FindControl("divImplementation");
                    HtmlControl divOther = (HtmlControl)dataBoundItem.FindControl("divOther");
                    HtmlControl divNull = (HtmlControl)dataBoundItem.FindControl("divNull");
                    HtmlControl divNA = (HtmlControl)dataBoundItem.FindControl("divNA");


                    if (divImplementation != null)
                        divImplementation.Style.Add("Display", "none");
                    if (divOther != null)
                        divOther.Style.Add("Display", "none");
                    if (divNull != null)
                        divNull.Style.Add("Display", "none");
                }
                else
                {
                    if (ddlAction != null && ddlAction.Items.Count > 9)
                    {
                        ddlAction.Items.Remove(ddlAction.Items[9]);
                    }
                    HtmlControl divImplementation = (HtmlControl)dataBoundItem.FindControl("divImplementation");
                    HtmlControl divOther = (HtmlControl)dataBoundItem.FindControl("divOther");
                    HtmlControl divNull = (HtmlControl)dataBoundItem.FindControl("divNull");
                    HtmlControl divNA = (HtmlControl)dataBoundItem.FindControl("divNA");
                    if (dataBoundItem["RoleName"].Text == "Implementation" || dataBoundItem["CourseType"].Text == "Elective credit" || dataBoundItem["CourseType"].Text == "Default Area E Credit")
                    {
                        if (divOther != null)
                            divOther.Style.Add("Display", "none");
                        if (divNull != null)
                            divNull.Style.Add("Display", "none");
                        if (divNA != null)
                            divNA.Style.Add("Display", "none");
                    }
                    else if (dataBoundItem["RoleName"].Text == "DO NOT ARTICULATE")
                    {
                        if (divImplementation != null)
                            divImplementation.Style.Add("Display", "none");
                        if (divOther != null)
                            divOther.Style.Add("Display", "none");
                        if (divNull != null)
                            divNull.Style.Add("Display", "none");
                    }
                    else if (dataBoundItem["RoleName"].Text == "&nbsp;")
                    {
                        if (ddlAction != null && ddlAction.Items.Count >= 9)
                        {
                            ddlAction.Items.Remove(ddlAction.Items[8]);
                        }

                        if (divImplementation != null)
                            divImplementation.Style.Add("Display", "none");
                        if (divOther != null)
                            divOther.Style.Add("Display", "none");
                        if (divNA != null)
                            divNA.Style.Add("Display", "none");
                    }
                    else
                    {
                        if (divImplementation != null)
                            divImplementation.Style.Add("Display", "none");
                        if (divNull != null)
                            divNull.Style.Add("Display", "none");
                        if (divNA != null)
                            divNA.Style.Add("Display", "none");
                    }
                }


                if (dataBoundItem["Course"].Text == "&nbsp;")
                {
                    if (ddlAction != null && ddlAction.Items.Count >= 7)
                    {
                        ddlAction.Items.Remove(ddlAction.Items[7]);
                    }
                }

                if (dataBoundItem["CourseType"].Text != "Elective credit")
                {
                    if (ddlAction != null && ddlAction.Items.Count >= 5)
                    {
                        ddlAction.Items.Remove(ddlAction.Items[5]);
                    }
                }
                else
                {
                    if (ddlAction != null && ddlAction.Items.Count >= 6)
                    {
                        ddlAction.Items.Remove(ddlAction.Items[6]);
                        ddlAction.Items.Remove(ddlAction.Items[4]);
                        ddlAction.Items.Remove(ddlAction.Items[3]);
                        ddlAction.Items.Remove(ddlAction.Items[2]);
                    }
                }

                if (((DataRowView)e.Item.DataItem)["Notes"].ToString() != "")
                {
                    HtmlControl divNotes = (HtmlControl)dataBoundItem.FindControl("divNotes");
                    if (divNotes != null)
                        divNotes.Style.Remove("Display");

                }
                if (ddlAction != null && ddlAction.Items.Count > 3)
                {
                    ddlAction.Items.Remove(ddlAction.Items[1]);
                }
                if (dataBoundItem["AceID"].Text == "")
                {
                    if (ddlAction != null && ddlAction.Items.Count >= 5)
                    {
                        ddlAction.Items.Remove(ddlAction.Items[5]);
                        ddlAction.Items.Remove(ddlAction.Items[3]);
                        ddlAction.Items.Remove(ddlAction.Items[2]);
                        ddlAction.Items.Remove(ddlAction.Items[1]);
                    }
                }

            }

        }
        protected void rgMilitaryCredits_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            try
            {

                if (e.CommandName == "ViewCPLPlan")
                {
                    Session["VeteranID"] = hfVeteranID.Value;
                    ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('../military/MilitaryCredits.aspx')", true);
                }
                if (e.CommandName == "ViewJST")
                {
                    string id = string.Empty;
                    string script = string.Empty;
                    using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                    {
                        var parameters = new SqlParameter[]
                        {
                            new SqlParameter("@VeteranID", hfVeteranID.Value),
                        };

                        DataTable dt = GlobalUtil.GetDataTableWithParameters("SELECT TOP (1) [id] FROM [dbo].[VeteranDocuments] WHERE [VeteranID] = @VeteranID AND [Field] = 'student_joint_services' ORDER BY [id] DESC", CommandType.Text, parameters);
                        if (dt.Rows.Count > 0)
                        {
                            id = dt.Rows[0].ItemArray[0].ToString();
                            script = "javascript:window.open('/modules/popups/ConfirmDownload.aspx?ID=" + id + "')";
                        }
                    }

                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                }
                if (e.CommandName == "Refresh")
                {
                    rgMilitaryCredits.Rebind();
                }
                if (e.CommandName == "Exhibit")
                {
                    string script = "function f(){$find(\"" + modalExhibit.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Print", script, true);
                }
                if (e.CommandName == "NewExhibit")
                {
                    string script = "javascript:window.open('/modules/cpl/exhibitList.aspx')";
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Exhibit", script, true);
                }
            }
            catch (Exception ex)
            {
                rnElegibleCredits.Text = ex.ToString();
                rnElegibleCredits.Show();
            }
        }
        protected void btnAddAceExhibit_Click(object sender, EventArgs e)

        {
            try

            {
                for (int i = 0; i < racbAceExhibit.Entries.Count; i++)

                {
                    using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))

                    {
                        connection.Open();
                        using (SqlCommand cmd = new SqlCommand("AddVeteranAceExhibit", connection))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;

                            cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                            cmd.Parameters.AddWithValue("@AceExhibitID", racbAceExhibit.Entries[i].Value.Trim().Split('|')[0]);
                            cmd.Parameters.AddWithValue("@CriteriaID", racbAceExhibit.Entries[i].Value.Trim().Split('|')[1]);
                            cmd.Parameters.AddWithValue("@CollegeID", Session["CollegeID"]);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                rgVeteranOccupations.DataBind();
                rgMilitaryCredits.DataBind();
                racbAceExhibit.Entries.Clear();
            }
            catch (Exception ex)
            {
                String message = ex.Message;
            }

        }
        protected void sqlVeteranOccupations_Deleted(object sender, SqlDataSourceStatusEventArgs e)

        {
            rgMilitaryCredits.Rebind();
        }
        protected void ddlAction_SelectedIndexChanged(object sender, DropDownListEventArgs e)
        {
            if (e.Value != null)
            {
                Telerik.Web.UI.RadDropDownList list = sender as Telerik.Web.UI.RadDropDownList;
                GridDataItem item = (GridDataItem)list.NamingContainer;
                string script = string.Empty;
                int outline_id = 0;
                switch (e.Value)
                {
                    case "1": // Apply Credit
                        outline_id = item["outline_id"].Text == "" ? 0 : Convert.ToInt32(item["outline_id"].Text);
                        if (item["Units"].Text != "0.0" && item["StageOrder"].Text == "4")
                        {
                            var result = AddElegibleCredit(Convert.ToInt32(hfVeteranID.Value), Convert.ToInt32(item["id"].Text), Convert.ToInt32(item["AceExhibitID"].Text), Convert.ToInt32(Session["UserID"].ToString()), Convert.ToInt32(outline_id), item["Criteria"].Text, 0);
                            if (result < 0)
                            {
                                rnElegibleCredits.Text = "Credits already applied.";
                                rnElegibleCredits.Show();
                            }
                            else
                            {

                                rnElegibleCredits.Text = "Success! You have applied the course credits for the selected exhibit.";
                                rnElegibleCredits.Show();
                            }
                        }
                        else
                        {
                            if (item["Elective"].Text == "1" || item["Elective"].Text == "2")
                            {
                                var result = 0;
                                if (item["Elective"].Text == "1")
                                {
                                    result = AddElegibleCredit(Convert.ToInt32(hfVeteranID.Value), Convert.ToInt32(item["id"].Text), Convert.ToInt32(item["AceExhibitID"].Text), Convert.ToInt32(Session["UserID"].ToString()), Convert.ToInt32(outline_id), item["Criteria"].Text, 0);
                                }
                                else
                                {
                                    result = AddElegibleCredit(Convert.ToInt32(hfVeteranID.Value), Convert.ToInt32(item["id"].Text), Convert.ToInt32(item["AceExhibitID"].Text), Convert.ToInt32(Session["UserID"].ToString()), Convert.ToInt32(outline_id), item["Criteria"].Text, Convert.ToInt32(item["VeteranEligibleID"].Text));
                                }

                                if (result < 0)
                                {
                                    rnElegibleCredits.Text = "Credits already applied.";
                                    rnElegibleCredits.Show();
                                }
                                else
                                {

                                    rnElegibleCredits.Text = "Success! You have applied the elective credit for the selected exhibit.";
                                    rnElegibleCredits.Show();
                                }
                            }
                            else
                            {
                                rnElegibleCredits.Text = "Sorry, the articulation you are looking to apply has not yet gone through the full approval process. Please apply this articulation once it is Implemented.";
                                rnElegibleCredits.Show();
                            }
                        }
                        break;
                    case "2": // Articulate as course
                        Session["outline_id"] = null;
                        if (CheckCreditRecommendationExists(item["Criteria"].Text) != 0)
                        {
                            RadTextBox rtbCreditRec = (RadTextBox)item.FindControl("rtbCreditRecommendation") as RadTextBox;
                            if (item["outline_id"].Text != "0")
                            {
                                var url = $"../popups/CreateArticulation.aspx?AceID={item["AceID"].Text}&OutlineID=0&TeamRevd={Convert.ToDateTime(item["TeamRevd"].Text).ToString("yyyy-MM-dd HH:mm:ss")}&Title={item["Title"].Text}&CreditRecommendations={item["Criteria"].Text}&ArticulationType={item["ArticulationType"].Text}&SourceID=8";
                                modalPopup.NavigateUrl = url;
                                script = "function f(){$find(\"" + modalPopup.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                            }
                            else
                            {
                                Session["SelectedCourse"] = "";
                                Session["SelectedCourseText"] = "";
                                if (rtbCreditRec.Visible)
                                {
                                    Session["SelectedCriteria"] = rtbCreditRec.Text.Replace(",", "|");
                                }
                                else
                                {
                                    Session["SelectedCriteria"] = item["Criteria2"].Text;
                                }
                                Session["SelectedCriteriaText"] = rtbCreditRec.Text;
                                Session["SelectedAceID"] = item["AceExhibitID"].Text;
                                modalPopup.NavigateUrl = "~/modules/popups/CreditRecommendations.aspx?SourceID=8";
                                script = "function f(){$find(\"" + modalPopup.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                            }

                        }
                        else
                        {


                            rnElegibleCredits.Text = "Course Articulation is not available for credit recommendations not identified within the ACE Military Guide.";
                            rnElegibleCredits.Show();
                        }

                        break;
                    case "3": // Articulate as area
                        if (item["outline_id"].Text != "0")
                        {
                            var url = $"../popups/CreateArticulation.aspx?AceID={item["AceID"].Text}&OutlineID=0&TeamRevd={Convert.ToDateTime(item["TeamRevd"].Text).ToString("yyyy-MM-dd HH:mm:ss")}&Title={item["Title"].Text}&CreditRecommendations={item["Criteria"].Text}&ArticulationType={item["ArticulationType"].Text}&SourceID=8";
                            url += "&AreaCredit=true";
                            modalPopup.NavigateUrl = url;
                            script = "function f(){$find(\"" + modalPopup.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                        }
                        else
                        {
                            RadTextBox rtbCreditRec2 = (RadTextBox)item.FindControl("rtbCreditRecommendation") as RadTextBox;
                            var criteria = rtbCreditRec2.Text.Replace(",", "|");
                            var unit = new String(criteria.TakeWhile(Char.IsDigit).ToArray());
                            Session["criteria"] = criteria;
                            Session["outline_id"] = Controllers.Course.GetCourseIDByUnits(unit, Convert.ToInt32(Session["CollegeID"]));





                            Session["AceExhibitID"] = item["AceExhibitID"].Text;
                            Session["VeteranID"] = hfVeteranID.Value;

                            Session["SelectedCourse"] = "";
                            Session["SelectedCourseText"] = "";
                            if (rtbCreditRec2.Visible)
                            {
                                Session["SelectedCriteria"] = rtbCreditRec2.Text.Replace(",", "|");
                            }
                            else
                            {
                                Session["SelectedCriteria"] = item["Criteria2"].Text;
                            }
                            Session["SelectedCriteriaText"] = rtbCreditRec2.Text;
                            Session["SelectedAceID"] = item["AceExhibitID"].Text;
                            modalPopup.NavigateUrl = "~/modules/popups/CreditRecommendations.aspx?SourceID=8&AreaCredit=true";
                            script = "function f(){$find(\"" + modalPopup.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                        }
                        break;
                    case "4": // Articulate as elective
                        hfCriteria.Value = item["Criteria"].Text;
                        hfExhibitID.Value = item["AceExhibitID"].Text;
                        hfExhibitText.Value = item["AceExhibit"].Text;
                        hfUnits.Value = new String(item["Criteria"].Text.TakeWhile(Char.IsDigit).ToArray());
                        rbcUnits.DataBind();
                        script = "function f(){$find(\"" + modalElectiveUnits.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                        break;
                    case "5": // Delete elective
                        hfExhibitID.Value = item["AceExhibitID"].Text;
                        hfOutlineID.Value = item["outline_id"].Text;
                        hfCriteria.Value = item["Criteria"].Text;
                        script = "function f(){$find(\"" + modalConfirmReverseElective.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                        break;
                    case "6": // Not Applicable
                        hfJSTOrder.Value = item["JSTOrder"].Text;
                        hfAceID2.Value = item["AceID"].Text;
                        hfTeamRevd.Value = Convert.ToDateTime(item["TeamRevd"].Text).ToString("yyyy-MM-dd HH:mm:ss");
                        hfCriteria.Value = item["Criteria"].Text;
                        script = "function f(){$find(\"" + modalNA.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                        break;
                    case "7": // View Articulate
                        showArticulation(Convert.ToInt32(item["id"].Text), Convert.ToInt32(item["ArticulationType"].Text), Convert.ToInt32(item["outline_id"].Text), item["AceID"].Text, item["Title"].Text, Convert.ToDateTime(item["TeamRevd"].Text));
                        break;
                    case "8": // Add/Edit Notes
                        hfJSTOrder.Value = item["JSTOrder"].Text;
                        using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                        {
                            var parameters = new SqlParameter[]
                            {
                                new SqlParameter("@VeteranID", hfVeteranID.Value),
                                new SqlParameter("@id", hfJSTOrder.Value),
                            };

                            DataTable dt = GlobalUtil.GetDataTableWithParameters("SELECT [Notes] FROM [dbo].[VeteranCreditRecommendations] WHERE [VeteranId] = @VeteranID AND [Id] = @id", CommandType.Text, parameters);
                            if (dt.Rows.Count > 0)
                            {
                                txtNotes2.Text = dt.Rows[0].ItemArray[0].ToString();
                            }
                        }
                        script = "function f(){$find(\"" + modalNotes.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                        break;
                    case "9": // No Applicable
                        hfJSTOrder.Value = item["JSTOrder"].Text;
                        hfAceID2.Value = item["AceID"].Text;
                        hfTeamRevd.Value = Convert.ToDateTime(item["TeamRevd"].Text).ToString("yyyy-MM-dd HH:mm:ss");
                        hfCriteria.Value = item["Criteria"].Text;
                        script = "function f(){$find(\"" + modalApplicable.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                        break;
                    default:
                        break;
                }
            }
            rgMilitaryCredits.Rebind();
        }

        #region Action funtions
        public void showArticulation(int id, int articulation_type, int outline_id, string AceID, string Title, DateTime TeamRevd)
        {
            if (articulation_type == 1)

            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString("yyyy-MM-dd HH:mm:ss")) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString("yyyy-MM-dd HH:mm:ss")) + "');", true);
            }
        }
        public static int CheckCreditRecommendationExists(string credit_recommendation)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select [dbo].[CheckCreditRecommendationExists] ('{credit_recommendation}');";
                    result = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }
        protected int AddElegibleCredit(int veteran_id, int articulation_id, int ace_exibit_id, int user_id, int outline_id, string criteria, int area_e_global_credit_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {

                connection.Open();
                using (SqlCommand cmd = new SqlCommand("ApplyEligibleCredits", connection))

                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VeteranID", veteran_id);
                    cmd.Parameters.AddWithValue("@ArticulationID", articulation_id);
                    cmd.Parameters.AddWithValue("@AceExhibitID", ace_exibit_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.Parameters.AddWithValue("@outline_id", outline_id);
                    cmd.Parameters.AddWithValue("@Criteria", criteria);
                    cmd.Parameters.AddWithValue("@DefaultAreaEGlobalCreditID", area_e_global_credit_id);
                    cmd.Parameters.Add("@Id", SqlDbType.Int);
                    cmd.Parameters["@Id"].Direction = ParameterDirection.Output;
                    cmd.ExecuteReader();
                    int id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
                    return id;
                }
            }

        }

        protected void btnInsertNotes_Click(object sender, EventArgs e)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE [dbo].[VeteranCreditRecommendations] SET [Notes] = @Notes WHERE [VeteranId] = @VeteranId AND [Id] = @id", connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@VeteranId", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@id", hfJSTOrder.Value);
                    cmd.Parameters.AddWithValue("@Notes", txtNotes2.Text.Trim());
                    cmd.ExecuteNonQuery();
                }
            }
            rgMilitaryCredits.Rebind();
        }

        protected void btnNAAll_Click(object sender, EventArgs e)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("INSERT INTO [dbo].[CollegeNACreditRecommentations] ([AceID],[TeamRevd],[Criteria],[CollegeID]) VALUES (@AceID, @TeamRevd, @Criteria, @CollegeID)", connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@AceID", hfAceID2.Value);
                    cmd.Parameters.AddWithValue("@TeamRevd", Convert.ToDateTime(hfTeamRevd.Value));
                    cmd.Parameters.AddWithValue("@Criteria", hfCriteria.Value);
                    cmd.Parameters.AddWithValue("@CollegeID", hfCollegeID.Value);
                    cmd.ExecuteNonQuery();
                }
            }
            rgMilitaryCredits.Rebind();
        }

        protected void btnNAOnlyOne_Click(object sender, EventArgs e)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE [dbo].[VeteranCreditRecommendations] SET [DNA] = CAST(1 AS BIT) WHERE [VeteranId] = @VeteranId AND [Id] = @id", connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@VeteranId", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@id", hfJSTOrder.Value);
                    cmd.ExecuteNonQuery();
                }
            }
            rgMilitaryCredits.Rebind();
        }
        protected void btnApplicableAll_Click(object sender, EventArgs e)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand(" DELETE FROM [dbo].[CollegeNACreditRecommentations] WHERE [AceID] = @AceID AND [TeamRevd] = @TeamRevd AND [Criteria] = @Criteria AND [CollegeID] = @CollegeID", connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@AceID", hfAceID2.Value);
                    cmd.Parameters.AddWithValue("@TeamRevd", Convert.ToDateTime(hfTeamRevd.Value));
                    cmd.Parameters.AddWithValue("@Criteria", hfCriteria.Value);
                    cmd.Parameters.AddWithValue("@CollegeID", hfCollegeID.Value);
                    cmd.ExecuteNonQuery();
                }

                using (SqlCommand cmd = new SqlCommand("UPDATE [dbo].[VeteranCreditRecommendations] SET [DNA] = NULL WHERE [VeteranId] = @VeteranId AND [Id] = @id", connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@VeteranId", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@id", hfJSTOrder.Value);
                    cmd.ExecuteNonQuery();
                }
            }
            rgMilitaryCredits.Rebind();
        }

        protected void btnApplicableOnlyOne_Click(object sender, EventArgs e)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))


            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE [dbo].[VeteranCreditRecommendations] SET [DNA] = CAST(0 AS BIT) WHERE [VeteranId] = @VeteranId AND [Id] = @id", connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@VeteranId", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@id", hfJSTOrder.Value);
                    cmd.ExecuteNonQuery();
                }
            }
            rgMilitaryCredits.Rebind();
        }

        protected void btnReverseElective_Click(object sender, EventArgs e)
        {
            try
            {
                Controllers.VeteranEligibleCredits.DeleteVeteranEligibleCredit(hfVeteranID.Value, hfExhibitID.Value, hfOutlineID.Value, hfCriteria.Value);
                rgMilitaryCredits.Rebind();
                rnElegibleCredits.Text = "Eligible credits were reversed";
                rnElegibleCredits.Show();
            }
            catch (Exception ex)
            {
                rnElegibleCredits.Text = ex.Message;
                rnElegibleCredits.Show();
            }
        }
        protected void btnDeleteExhibit_Click(object sender, EventArgs e)
        {
            sqlVeteranOccupations.Delete();
            rgVeteranOccupations.Rebind();
        }
        #endregion
        #endregion

        #region OBSOLETE METHODS
        public Color ToggleColor(Color color)
        {
            Color col = new Color();
            if (color == Color.AliceBlue)
            {
                col = Color.White;
            }
            else
            {
                col = Color.AliceBlue;
            }
            return col;
        }
        protected void rgVeteranDocs_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                ScriptManager.GetCurrent(Page).RegisterPostBackControl(item["AttachmentColumn"].Controls[0]);
            }
        }
        private void UpdateStudentSummary()
        {
            //using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            //{
            //    const string statement = "UPDATE [dbo].[Veteran] SET [ProgramStudy] = @ProgramStudy, [EducationalBenefits] = @EducationalBenefits, [FinancialAide] = @FinancialAide, [CounselingAppt] = @CounselingAppt, [Orientation] = @Orientation, [Assessment] =@Assessment, [Notes] = @Notes WHERE id = @VeteranID";

            //    using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
            //    {
            //        cmd.Parameters.AddWithValue("@ProgramStudy", ddlProgram.SelectedValue);
            //        //cmd.Parameters.AddWithValue("@EducationalBenefits", rcbEducationalBenefits.SelectedValue);
            //        cmd.Parameters.AddWithValue("@FinancialAide", ddlFinancial.SelectedValue == "1" ? true : false);
            //        cmd.Parameters.AddWithValue("@CounselingAppt", ddlConseling.SelectedValue == "1" ? true : false);
            //        cmd.Parameters.AddWithValue("@Orientation", ddlOrientation.SelectedValue == "1" ? true : false);
            //        cmd.Parameters.AddWithValue("@Assessment", ddlAssessment.SelectedValue == "1" ? true : false);
            //        cmd.Parameters.AddWithValue("@Notes", reNotes.Content);
            //        cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);

            //        try
            //        {
            //            connection.Open();
            //            int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());

            //        }
            //        catch (Exception ex)
            //        {
            //            throw;
            //        }
            //    }
            //}
        }
        private void GetStudentSummary()
        {
            List<String> rows = new List<String>();
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string query = "SELECT ISNULL(v.FirstName,'') + ' ' + ISNULL(v.MiddleName,'') + ' ' + ISNULL(v.LastName,'')  AS NAME, [CCCApplication], [ProgramStudy], [EducationalBenefits], [FinancialAide],[CounselingAppt],[Orientation],[Assessment],[Notes] FROM Veteran as v where v.id = @VeteranID";
                SqlCommand command = new SqlCommand(query, connection);

                command.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    txtName.Text = dt.Rows[0].ItemArray[0].ToString();
                    if (dt.Rows[0].ItemArray[2].ToString() != "")
                    {
                        //ddlProgram.SelectedValue = dt.Rows[0].ItemArray[2].ToString();
                    }
                    //if (dt.Rows[0].ItemArray[3].ToString() != "")
                    //{
                    //    rcbEducationalBenefits.SelectedValue = dt.Rows[0].ItemArray[3].ToString();
                    //}
                    ddlFinancial.SelectedValue = dt.Rows[0].ItemArray[4].ToString() == "True" ? "1" : "0";
                    ddlConseling.SelectedValue = dt.Rows[0].ItemArray[5].ToString() == "True" ? "1" : "0";
                    ddlOrientation.SelectedValue = dt.Rows[0].ItemArray[6].ToString() == "True" ? "1" : "0";
                    ddlAssessment.SelectedValue = dt.Rows[0].ItemArray[7].ToString() == "True" ? "1" : "0";
                    reNotes.Content = dt.Rows[0].ItemArray[8].ToString();
                }
            }
        }
        private bool ExistID(string id, bool update)
        {
            bool result;
            if (update && hfidn.Value == id)
            {
                result = false;
            }
            else
            {
                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    SqlCommand command = new SqlCommand("SELECT TOP (1) * FROM [dbo].[Veteran] WHERE [StudentID] = '" + id + "'", connection);
                    connection.Open();

                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.HasRows)
                    {
                        result = true;
                    }
                    else
                    {
                        result = false;
                    }
                    reader.Close();
                }
            }
            return result;
        }
        private bool ExistsDD214(string id)
        {
            bool result;
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand("SELECT id FROM [VeteranDocuments] WHERE [VeteranID] = " + id + " AND [Field] = 'student_dd214'", connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    result = true;
                }
                else
                {
                    result = false;
                }
                reader.Close();
            }

            return result;
        }
        private bool ExistsJST(string id)
        {
            bool result;
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand("SELECT id FROM [VeteranDocuments] WHERE [VeteranID] = " + id + " AND [Field] = 'student_joint_services'", connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    result = true;
                }
                else
                {
                    result = false;
                }
                reader.Close();
            }

            return result;
        }
        protected void rgSelected_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                if (dataBoundItem["ArticulationID"].Text == "0" && dataBoundItem["id"].Text != "0" && dataBoundItem["DefaultAreaEGlobalCreditID"].Text == "")
                {
                    dataBoundItem.BackColor = System.Drawing.Color.LightCyan;
                }
                HyperLink hp = (HyperLink)dataBoundItem.FindControl("hlExhibit");
                if (hp != null)
                {
                    hp.Text = dataBoundItem["AceExhibit"].Text;
                    hp.NavigateUrl = "";
                    hp.Attributes.Add("onclick", "event.stopPropagation();");
                    if (dataBoundItem["AceID"].Text != "")
                    {
                        hp.Attributes.Remove("onclick");
                        hp.NavigateUrl = $"javascript:showExhibitInfo('{dataBoundItem["ExhibitID"].Text}','{dataBoundItem["Criteria"].Text}')";
                    }
                }
            }
        }
        protected void rgSelected_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            try
            {
                if (e.CommandName == RadGrid.ExportToExcelCommandName)
                {
                    grid.ExportToExcel();
                }
                if (e.CommandName == "DeleteRow")
                {
                    GridDataItem itemDetail = e.Item as GridDataItem;
                    DeleteElegibleCredit(Convert.ToInt32(itemDetail["id"].Text));
                    rgSelected.Rebind();
                }
                if (e.CommandName == "Delete")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        rnElegibleCredits.Text = "Select an Articulation.";
                        rnElegibleCredits.Show();
                    }
                    else
                    {
                        if (e.CommandName == "Delete")
                        {
                            foreach (GridDataItem item in grid.SelectedItems)
                            {
                                DeleteElegibleCredit(Convert.ToInt32(item["id"].Text));
                            }
                            rgSelected.Rebind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                rnElegibleCredits.Text = ex.ToString();
                rnElegibleCredits.Show();
            }
        }
        protected void DeleteElegibleCredit(int id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("DeleteElegibleCredits", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = "DELETE FROM [dbo].[VeteranDocuments] WHERE [id] = @id";
                    cmd.Parameters.AddWithValue("@id", btn.CommandArgument);
                    cmd.ExecuteScalar();
                }
                finally
                {
                    connection.Close();
                }
            }
            rlvDocuments.DataBind();
        }
        protected void btnElectiveUnits_Click(object sender, EventArgs e)
        {
            var creds = hfCriteria.Value.ToString().Split(',').Length;
            if (creds > 0)
            {
                foreach (string credit_recommendation in hfCriteria.Value.ToString().Split(','))
                {
                    var units = new String(credit_recommendation.TakeWhile(Char.IsDigit).ToArray());
                    //hfUnits.Value = units;

                    if (GlobalUtil.IsNumeric(units))
                    {
                        var outline_id = Controllers.Course.GetCourseIDByUnits(units, Convert.ToInt32(Session["CollegeID"]));

                        if (Controllers.Course.CheckCourseIsElective(outline_id) != 1)
                        {
                            rnElegibleCredits.Text = "You can only add elective courses";
                            rnElegibleCredits.Show();
                        }
                        else
                        {
                            //var unit_id = rbcUnits.SelectedValue == "" ? "0" : rbcUnits.SelectedValue;
                            var unit_id = "0";
                            if (rbcUnits.SelectedValue == "")
                            {
                                rbcUnits.DataBind();
                                unit_id = rbcUnits.Items.Count > 0 ? rbcUnits.Items[0].Value : "0";
                            }
                            else
                            {
                                unit_id = rbcUnits.SelectedValue;
                            }
                            //
                            var result = Controllers.VeteranEligibleCredits.AddVeteranEligibleCredits(Convert.ToInt32(hfVeteranID.Value), hfExhibitID.Value, Convert.ToInt32(Session["UserID"].ToString()), outline_id, credit_recommendation, Convert.ToInt32(unit_id), 8);
                            if (result == -1)
                            {
                                rnElegibleCredits.Text = "Eligible credits already exists";
                                rnElegibleCredits.Show();
                            }
                            else
                            {
                                var course_description = "";
                                var course_data = norco_db.GetCourseInformation(outline_id);
                                foreach (var course in course_data)
                                {
                                    course_description = $"{course.subject}-{course.course_number} {course.course_title}";
                                }
                                rnElegibleCredits.Text = $"Success! You have created an elective and applied for the selected exhibit that is ready to be applied. <b>{course_description} - {hfExhibitText.Value}</b>";
                                rnElegibleCredits.Show();
                                rgMilitaryCredits.DataBind();
                            }
                        }
                    }
                }
            }
        }
        #endregion

        protected void UpdateOptOut(bool opt_out)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE [dbo].[Veteran] SET [OptOut] = @OptOut WHERE [Id] = @VeteranId", connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@VeteranId", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@OptOut", opt_out);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        protected void rsbOptOut_CheckedChanged(object sender, EventArgs e)
        {
            pnlMilitaryCredits.Visible = true;
            if (rsbOptOut.Checked == true)
            {
                pnlMilitaryCredits.Visible = false;
            }
            UpdateOptOut((bool)rsbOptOut.Checked);
        }
    }
}