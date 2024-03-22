using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.military
{
    public partial class NewStudent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfCollege.Value = Session["CollegeID"].ToString();
                hfUserID.Value = Session["UserID"].ToString();

                if (Request.UrlReferrer.AbsoluteUri.Contains("NewStudentDocuments.aspx"))
                {
                    if (Session["VeteranID"] != null)
                    {
                        hfVeteranID.Value = Session["VeteranID"].ToString();
                        GetStudent(hfVeteranID.Value);
                        GetReason(hfVeteranID.Value);
                    }
                }
                else if (Request.UrlReferrer.AbsoluteUri.Contains("StudentList.aspx"))
                {
                    if (Session["EditStudent"] != null)
                    {
                        if (Session["EditStudent"].ToString() == "True")
                        {
                            if (Session["VeteranID"] != null)
                            {
                                hfVeteranID.Value = Session["VeteranID"].ToString();
                                GetStudent(hfVeteranID.Value);
                                GetReason(hfVeteranID.Value);
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

                bool updated = hfVeteranID.Value == "" ? false : true;

                if (ExistID(txtID.Text.Trim(), updated))
                {
                    lblErrorID.Visible = true;
                }
                else if (ExistEmail(txtEmail.Text.Trim(), updated))
                {
                    lblerrorEmail.Visible = true;
                }
                else if (ExistName(txtFirstName.Text, txtMiddleName.Text, txtLastName.Text, updated))
                {
                    if (txtID.Text == "")
                    {
                        RadWindowManager1.RadAlert("You must enter a student ID for the new student!", 400, 200, "Missing ID", "callBackFn", "myAlertImage.png");
                    }
                    else
                    {
                        RadWindowManager1.RadConfirm("There is an existing student with the same first name and last name!, Do you want to proceed?", "confirmCallbackFn", 400, 200, null, "Confirm");
                    }
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
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            bool updated = hfVeteranID.Value == "" ? false : true;

            if (updated)
            {
                Update();
            }
            else
            {
                Save();
            }
        }

        private void GetStudent(string id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand("SELECT [FirstName],[MiddleName],[LastName],[StudentID],[MobilePhone],[Email],[ServiceID] FROM [dbo].[Veteran] WHERE [id] = '" + id + "'", connection);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    txtFirstName.Text = dt.Rows[0].ItemArray[0].ToString().Trim();
                    hfFirstName.Value = txtFirstName.Text;
                    txtMiddleName.Text = dt.Rows[0].ItemArray[1].ToString().Trim();
                    hfMiddleName.Value = txtMiddleName.Text;
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
                }
            }
        }
        private void GetReason(string id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand("SELECT * FROM [dbo].[tblLookupReason] WHERE [VeteranID] = '" + id + "'", connection);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    if (dt.Rows[0].ItemArray[1].ToString() == "True")
                    {
                        ckblReason.Items[0].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[2].ToString() == "True")
                    {
                        ckblReason.Items[1].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[3].ToString() == "True")
                    {
                        ckblReason.Items[2].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[4].ToString() == "True")
                    {
                        ckblReason.Items[3].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[5].ToString() == "True")
                    {
                        ckblReason.Items[4].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[6].ToString() == "True")
                    {
                        ckblReason.Items[5].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[7].ToString() == "True")
                    {
                        ckblReason.Items[6].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[8].ToString() == "True")
                    {
                        ckblReason.Items[7].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[9].ToString() == "True")
                    {
                        ckblReason.Items[8].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[10].ToString() == "True")
                    {
                        ckblReason.Items[9].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[11].ToString() == "True")
                    {
                        ckblReason.Items[10].Selected = true;
                    }
                    if (dt.Rows[0].ItemArray[12].ToString() == "True")
                    {
                        ckblReason.Items[11].Selected = true;
                        txtOtherDescription.Enabled = true;
                        txtOtherDescription.Text = dt.Rows[0].ItemArray[13].ToString();
                    }
                }
            }
        }
        private void Save()
        {
            int id = 0;

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("AddVeteran", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@FirstName", txtFirstName.Text == "" ? null : txtFirstName.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@MiddleName", txtMiddleName.Text == "" ? null : txtMiddleName.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@LastName", txtLastName.Text == "" ? null : txtLastName.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@StudentID", txtID.Text == "" ? null : txtID.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@MobilePhone", txtPhone.Text == "" ? null : txtPhone.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@Email", txtEmail.Text == "" ? null : txtEmail.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@ServiceID", ddlBranch.SelectedValue == "" ? null : ddlBranch.SelectedValue));
                    cmd.Parameters.AddWithValue("@CollegeID", hfCollege.Value);
                    cmd.Parameters.AddWithValue("@CreatedBy", hfCollege.Value);
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);

                    cmd.ExecuteNonQuery();

                    id = Convert.ToInt32(outParm.Value);
                }

                using (SqlCommand cmd = new SqlCommand("AddReason", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@VeteranID", id);
                    cmd.Parameters.AddWithValue("@CounselingAppointment", ckblReason.SelectedValues.Contains("0"));
                    cmd.Parameters.AddWithValue("@GeneralInquiry", ckblReason.SelectedValues.Contains("1"));
                    cmd.Parameters.AddWithValue("@SubmitVISOR", ckblReason.SelectedValues.Contains("2"));
                    cmd.Parameters.AddWithValue("@EducationalBenefitsInquiry", ckblReason.SelectedValues.Contains("3"));
                    cmd.Parameters.AddWithValue("@MilitarArticulationPlataform", ckblReason.SelectedValues.Contains("4"));
                    cmd.Parameters.AddWithValue("@HealthServices", ckblReason.SelectedValues.Contains("5"));
                    cmd.Parameters.AddWithValue("@Tutoring", ckblReason.SelectedValues.Contains("6"));
                    cmd.Parameters.AddWithValue("@SchoolSuppliesMaterials", ckblReason.SelectedValues.Contains("7"));
                    cmd.Parameters.AddWithValue("@ComputerPrinter", ckblReason.SelectedValues.Contains("8"));
                    cmd.Parameters.AddWithValue("@HomeworkStudy", ckblReason.SelectedValues.Contains("9"));
                    cmd.Parameters.AddWithValue("@Recreation", ckblReason.SelectedValues.Contains("10"));
                    cmd.Parameters.AddWithValue("@Others", ckblReason.SelectedValues.Contains("11"));
                    cmd.Parameters.AddWithValue("@OtherDescription", ckblReason.SelectedValues.Contains("11") ? txtOtherDescription.Text.Trim() : string.Empty);
                    cmd.ExecuteNonQuery();
                }
            }

            Session["VeteranID"] = id;
            Response.Redirect("../military/NewStudentDocuments.aspx");
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
                    cmd.Parameters.Add(new SqlParameter("@MiddleName", txtMiddleName.Text == "" ? null : txtMiddleName.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@LastName", txtLastName.Text == "" ? null : txtLastName.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@StudentID", txtID.Text == "" ? null : txtID.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@MobilePhone", txtPhone.Text == "" ? null : txtPhone.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@Email", txtEmail.Text == "" ? null : txtEmail.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@ServiceID", ddlBranch.SelectedValue == "" ? null : ddlBranch.SelectedValue));
                    cmd.Parameters.AddWithValue("@CollegeID", hfCollege.Value);
                    cmd.Parameters.AddWithValue("@UpdatedBy", hfCollege.Value);
                    cmd.Parameters.AddWithValue("@ID", hfVeteranID.Value);

                    cmd.ExecuteNonQuery();
                }

                using (SqlCommand cmd = new SqlCommand("UpdateReason", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                    cmd.Parameters.AddWithValue("@CounselingAppointment", ckblReason.SelectedValues.Contains("0"));
                    cmd.Parameters.AddWithValue("@GeneralInquiry", ckblReason.SelectedValues.Contains("1"));
                    cmd.Parameters.AddWithValue("@SubmitVISOR", ckblReason.SelectedValues.Contains("2"));
                    cmd.Parameters.AddWithValue("@EducationalBenefitsInquiry", ckblReason.SelectedValues.Contains("3"));
                    cmd.Parameters.AddWithValue("@MilitarArticulationPlataform", ckblReason.SelectedValues.Contains("4"));
                    cmd.Parameters.AddWithValue("@HealthServices", ckblReason.SelectedValues.Contains("5"));
                    cmd.Parameters.AddWithValue("@Tutoring", ckblReason.SelectedValues.Contains("6"));
                    cmd.Parameters.AddWithValue("@SchoolSuppliesMaterials", ckblReason.SelectedValues.Contains("7"));
                    cmd.Parameters.AddWithValue("@ComputerPrinter", ckblReason.SelectedValues.Contains("8"));
                    cmd.Parameters.AddWithValue("@HomeworkStudy", ckblReason.SelectedValues.Contains("9"));
                    cmd.Parameters.AddWithValue("@Recreation", ckblReason.SelectedValues.Contains("10"));
                    cmd.Parameters.AddWithValue("@Others", ckblReason.SelectedValues.Contains("11"));
                    cmd.Parameters.AddWithValue("@OtherDescription", ckblReason.SelectedValues.Contains("11") ? txtOtherDescription.Text.Trim() : string.Empty);
                    cmd.ExecuteNonQuery();
                }
            }

            Session["VeteranID"] = hfVeteranID.Value;
            Response.Redirect("../military/NewStudentDocuments.aspx");
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
        private bool ExistEmail(string email, bool update)
        {
            bool result;
            if (update && hfEmail.Value == email)
            {
                result = false;
            }
            else
            {
                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    SqlCommand command = new SqlCommand("SELECT TOP (1) * FROM [dbo].[Veteran] WHERE [Email] = '" + email + "'", connection);
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
        private bool ExistName(string firstName, string middleName, string lastName, bool update)
        {
            bool result;
            if (update && hfFirstName.Value == firstName && hfMiddleName.Value == middleName && hfLastName.Value == lastName)
            {
                result = false;
            }
            else
            {
                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    SqlCommand command = new SqlCommand("SELECT TOP (1) * FROM [dbo].[Veteran] WHERE TRIM([FirstName]) = '" + firstName + "' \n" +
                                                        " AND TRIM([MiddleName]) = '" + middleName + "' AND TRIM([LastName]) = '" + lastName + "'", connection);
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
    }
}