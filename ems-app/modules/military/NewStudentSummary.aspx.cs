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
    public partial class NewStudentSummary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfCollege.Value = Session["CollegeID"].ToString();
                hfVeteranID.Value = Session["VeteranID"].ToString();
                GetDataVeteran();
                ddlJST.SelectedValue = ExistsJST(hfVeteranID.Value) ? "1" : "0";
                ddlDD214.SelectedValue = ExistsDD214(hfVeteranID.Value) ? "1" : "0";
                txtTotalCredits.Text = GetTotalCredits().ToString();
            }
        }

        private void GetDataVeteran()
        {
            List<String> rows = new List<String>();
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string query = "SELECT ISNULL(v.FirstName,'') + ' ' + ISNULL(v.MiddleName,'') + ' ' + ISNULL(v.LastName,'')  AS NAME, [CCCApplication], [ProgramStudy], [EducationalBenefits], [FinancialAide],[CounselingAppt],[Orientation],[Assessment] FROM Veteran as v where v.id = @VeteranID";
                SqlCommand command = new SqlCommand(query, connection);

                command.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                if(dt.Rows.Count > 0)
                {
                    txtName.Text = dt.Rows[0].ItemArray[0].ToString();
                    ddlApplication.SelectedValue = dt.Rows[0].ItemArray[1].ToString() == "True" ? "1" : "0";
                    if (dt.Rows[0].ItemArray[2].ToString() != "")
                    {
                        ddlProgram.SelectedValue = dt.Rows[0].ItemArray[2].ToString();
                    }
                    txtBenefits.Text = dt.Rows[0].ItemArray[3].ToString();
                    ddlFinancial.SelectedValue = dt.Rows[0].ItemArray[4].ToString() == "True" ? "1" : "0";
                    ddlConseling.SelectedValue = dt.Rows[0].ItemArray[5].ToString() == "True" ? "1" : "0";
                    ddlOrientation.SelectedValue = dt.Rows[0].ItemArray[6].ToString() == "True" ? "1" : "0";
                    ddlAssessment.SelectedValue = dt.Rows[0].ItemArray[7].ToString() == "True" ? "1" : "0";
                }
            }
        }
        private double GetTotalCredits()
        {
            double total = 0;
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string query = "SELECT a.AceID + ' ' + a.Title, u.unit , [subject] + '-' + course_number + ' ' + course_title, u.unit FROM VeteranACECourse as v \n" +
                               "INNER JOIN ACEExhibit as ae on ae.AceID = v.AceID \n" +
                               "INNER JOIN Articulation as a on a.aceid = ae.AceID and a.TeamRevd = ae.TeamRevd \n" +
                               "INNER JOIN Course_IssuedForm as c on c.outline_id = a.outline_id and c.status = 0 and c.college_id = 1 \n" +
                               "INNER JOIN tblSubjects as s on s.subject_id = c.subject_id \n" +
                               "INNER JOIN Stages as st on a.ArticulationStage = st.id and st.[Order] = 4 \n" +
                               "INNER JOIN tblLookupUnits u on c.unit_id = u.unit_id \n" +
                               "WHERE v.veteranid = @VeteranID";
                SqlCommand command = new SqlCommand(query, connection);

                command.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                foreach (DataRow dataRow in dt.Rows)
                {
                    total += Convert.ToDouble(dataRow.ItemArray[3]);
                }
            }

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string query = "SELECT a.AceID + ' ' + a.Title, u.unit , [subject] + '-' + course_number + ' ' + course_title, u.unit FROM VeteranOccupation as v \n" +
                               "INNER JOIN ACEExhibit as ae on ae.Occupation = v.OccupationCode \n" +
                               "INNER JOIN Articulation as a on a.aceid = ae.AceID \n" +
                               "INNER JOIN Course_IssuedForm as c on c.outline_id = a.outline_id and c.status = 0 and c.college_id = 1 \n" +
                               "INNER JOIN tblSubjects as s on s.subject_id = c.subject_id \n" +
                               "INNER JOIN Stages as st on a.ArticulationStage = st.id and st.[Order] = 4 \n" +
                               "INNER JOIN tblLookupUnits u on c.unit_id = u.unit_id \n" +
                               "WHERE v.veteranid = @VeteranID and s.subject not in ('HES', 'CPL', 'MIL-SD', 'MIL-PE')";
                SqlCommand command = new SqlCommand(query, connection);

                command.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                foreach (DataRow dataRow in dt.Rows)
                {
                    total += Convert.ToDouble(dataRow.ItemArray[3].ToString());
                }
            }

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string query = "SELECT a.AceID + ' ' + a.Title, u.unit , [subject] + '-' + course_number + ' ' + course_title, u.unit FROM VeteranOccupation as v \n" +
                               "INNER JOIN ACEExhibit as ae on ae.Occupation = v.OccupationCode \n" +
                               "INNER JOIN Articulation as a on a.aceid = ae.AceID \n" +
                               "INNER JOIN Course_IssuedForm as c on c.outline_id = a.outline_id and c.status = 0 and c.college_id = 1 \n" +
                               "INNER JOIN tblSubjects as s on s.subject_id = c.subject_id \n" +
                               "INNER JOIN Stages as st on a.ArticulationStage = st.id and st.[Order] = 4 \n" +
                               "INNER JOIN tblLookupUnits u on c.unit_id = u.unit_id \n" +
                               "WHERE v.veteranid = @VeteranID and s.subject in ('HES', 'CPL', 'MIL-SD', 'MIL-PE')";
                SqlCommand command = new SqlCommand(query, connection);

                command.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                foreach (DataRow dataRow in dt.Rows)
                {
                    total += Convert.ToDouble(dataRow.ItemArray[3]);
                }
            }

            return total;
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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                const string statement = "UPDATE [dbo].[Veteran] SET [CCCApplication] = @CCCApplication, [ProgramStudy] = @ProgramStudy, [EducationalBenefits] = @EducationalBenefits, [FinancialAide] = @FinancialAide, [CounselingAppt] = @CounselingAppt, [Orientation] = @Orientation, [Assessment] =@Assessment WHERE id = @VeteranID";

                using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
                {
                    cmd.Parameters.AddWithValue("@CCCApplication", ddlApplication.SelectedValue == "1" ? true : false);
                    cmd.Parameters.AddWithValue("@ProgramStudy", ddlProgram.SelectedValue);
                    cmd.Parameters.AddWithValue("@EducationalBenefits", txtBenefits.Text);
                    cmd.Parameters.AddWithValue("@FinancialAide", ddlFinancial.SelectedValue == "1" ? true : false);
                    cmd.Parameters.AddWithValue("@CounselingAppt", ddlConseling.SelectedValue == "1" ? true : false);
                    cmd.Parameters.AddWithValue("@Orientation", ddlOrientation.SelectedValue == "1" ? true : false);
                    cmd.Parameters.AddWithValue("@Assessment", ddlAssessment.SelectedValue == "1" ? true : false);
                    cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);

                    try
                    {
                        connection.Open();
                        int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());

                    }
                    catch (Exception ex)
                    {
                        throw;
                    }
                }
            }

            RadWindowManager1.RadAlert("Information saved successfully!", 400, 200, "Message", "callBackFn", "myAlertImage.png");
        }
    }
}