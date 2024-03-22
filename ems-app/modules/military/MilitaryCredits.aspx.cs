using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.military
{
    public partial class MilitaryCredits : System.Web.UI.Page
    {
        private double total;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfCollege.Value = Session["CollegeID"].ToString();
                hfVeteranID.Value = Session["VeteranID"].ToString();
                hCollegeName.InnerText += Session["College"].ToString();
                GetStudent(hfVeteranID.Value);
                total = 0;

                hfCourse.Value = GetDataCourse();
                hfOccupational.Value = GetDataOccupational();
                hfOccupationalElectives.Value = GetDataOccupationalElectives();
                hfTotal.Value = total.ToString();
                var url = $"'../reports/MilitaryCredits.aspx?VeteranID={hfVeteranID.Value}&CollegeID={hfCollege.Value}'";
                btnPrintMilitaryCredits.OnClientClick = $"javascript:OpenPopupWindow({url},1000,600,false)";

                GetStudentCredits();
                GetStatusStudent();
            }
        }

        private void GetStatusStudent()
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand("GetStudentStatus", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@collegeid", hfCollege.Value);
                command.Parameters.AddWithValue("@id", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    if (dt.Rows[0].ItemArray[8].ToString().Trim() == "1")
                    {
                        rlCPLStatus.Text += "Credits Applied to CPL Plan";
                    }
                }
            }
        }

        private void GetStudentCredits()
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand("GetStudentCredits", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@id", hfVeteranID.Value);
                command.Parameters.AddWithValue("@CollegeID", hfCollege.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;

                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rlAppliedCredits.Text = $"Applied Credits : {dt.Rows[0].ItemArray[1].ToString().Trim()}";
                }
            }
        }

        private void GetStudent(string id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                //SqlCommand command = new SqlCommand("SELECT [FirstName],[MiddleName],[LastName],[StudentID],[MobilePhone],[Email],[ServiceID] FROM [dbo].[Veteran] WHERE [id] = '" + id + "'", connection);
                SqlCommand command = new SqlCommand("SELECT V.id, [FirstName],[MiddleName],[LastName],[StudentID],[MobilePhone],[Email],[ServiceID], V.EducationalBenefits, EB.Description as 'educational benefits', (SELECT STRING_AGG(C.CPLTypeDescription, ', ') FROM VeteranCPLType VCT JOIN CPLType C ON VCT.CPLType = C.ID WHERE VeteranID = V.id AND VCT.Value = 1) as 'cpltype', (SELECT STRING_AGG(LM.CPLModeofLearningDescription, ', ') FROM VeteranLearningMode VLM JOIN CPLModeofLearning LM ON VLM.LearningMode = LM.ID WHERE VeteranID = V.id AND VLM.Value = 1) as 'LearningMode', LS.Description as 'branch', (SELECT STUFF((SELECT ',' + PIF.program FROM VeteranProgramStudy VPS JOIN Program_IssuedForm PIF ON VPS.ProgramStudy = PIF.program_id WHERE VPS.VeteranID = v.id FOR XML PATH('')) ,1,1,'')) AS program, ISNULL(V.TransferDestination,'') AS TransferDestination, V.MobilePhone, V.OriginID, VO.Description as 'origin', case VPG.LocalAAAS when 1 then 'LocalAAAS' else ' ' end + case VPG.ADT when 1 then ', ADT' else ' ' end + case VPG.CSU when 1 then ', CSU' else ' ' end + case VPG.UC when 1 then ', UC' else ' ' end + case VPG.Certificate when 1 then ', Certificate' else ' ' end + case VPG.CareerAdvancement when 1 then ', Career Advancement' else ' ' end + case VPG.Other when 1 then ', Other' else ' ' end AS programgoals, CS.Description AS 'cplstatus' FROM Veteran AS V LEFT JOIN EducationalBenefits EB ON V.EducationalBenefits = EB.ID LEFT JOIN LookupService LS ON V.ServiceID = LS.id LEFT JOIN VeteranOrigin VO ON V.OriginID = VO.ID LEFT JOIN VeteranProgramGoals VPG ON VPG.VeteranID = V.id LEFT JOIN CPLStatus CS ON V.CPLStatusID = CS.ID WHERE  V.id = '" + id + "'", connection);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    rlEmail.Text += dt.Rows[0].ItemArray[6].ToString().Trim();
                    rlCPLType.Text += dt.Rows[0].ItemArray[10].ToString().Trim();
                    rlLearningMode.Text += dt.Rows[0].ItemArray[11].ToString().Trim();
                    rlID.Text += dt.Rows[0].ItemArray[4].ToString().Trim();
                    rlBranch.Text += dt.Rows[0].ItemArray[12].ToString().Trim();
                    rlProgramStudy.Text += dt.Rows[0].ItemArray[12].ToString().Trim();
                    rlPhone.Text += dt.Rows[0].ItemArray[5].ToString().Trim();
                    rlCPLStatus.Text += dt.Rows[0].ItemArray[19].ToString().Trim();
                    rlname.Text += dt.Rows[0].ItemArray[1].ToString().Trim();
                    rlLastName.Text += dt.Rows[0].ItemArray[3].ToString().Trim();
                }
            }
        }

        private string GetDataCourse()
        {
            List<String> rows = new List<String>();
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string query = "SELECT DISTINCT a.AceID + ' ' + a.Title, u.unit , [subject] + '-' + course_number + ' ' + course_title, u.unit FROM VeteranACECourse as v \n" +
                               "INNER JOIN ACEExhibit as ae on ae.AceID = v.AceID \n" +
                               "INNER JOIN Articulation as a on a.aceid = ae.AceID and a.TeamRevd = ae.TeamRevd \n" +
                               "INNER JOIN Course_IssuedForm as c on c.outline_id = a.outline_id and c.status = 0 and c.college_id = 1 \n" +
                               "INNER JOIN tblSubjects as s on s.subject_id = c.subject_id \n" +
                               "INNER JOIN Stages as st on a.ArticulationStage = st.id and st.[Order] = 4 \n" +
                               "INNER JOIN tblLookupUnits u on c.unit_id = u.unit_id \n" +
                               "WHERE v.veteranid = @VeteranID and a.Articulate = 1";
                SqlCommand command = new SqlCommand(query, connection);

                command.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                foreach (DataRow dataRow in dt.Rows)
                {
                    rows.Add(string.Join(";", dataRow.ItemArray.Select(item => item.ToString())));
                    total += Convert.ToDouble(dataRow.ItemArray[3]);
                }
            }

            return string.Join("|", rows.Select(item => item.ToString()));
        }
        private string GetDataOccupational()
        {
            List<String> rows = new List<String>();
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string query = "SELECT DISTINCT a.AceID + ' ' + a.Title, u.unit , [subject] + '-' + course_number + ' ' + course_title, u.unit FROM VeteranOccupation as v \n" +
                               "INNER JOIN ACEExhibit as ae on ae.Occupation = v.OccupationCode \n" +
                               "INNER JOIN Articulation as a on a.aceid = ae.AceID \n" +
                               "INNER JOIN Course_IssuedForm as c on c.outline_id = a.outline_id and c.status = 0 and c.college_id = 1 \n" +
                               "INNER JOIN tblSubjects as s on s.subject_id = c.subject_id \n" + 
                               "INNER JOIN Stages as st on a.ArticulationStage = st.id and st.[Order] = 4 \n" +
                               "INNER JOIN tblLookupUnits u on c.unit_id = u.unit_id \n" +
                               "WHERE v.veteranid = @VeteranID and s.subject not in ('HES', 'CPL', 'MIL-SD', 'MIL-PE') and a.Articulate = 1";
                SqlCommand command = new SqlCommand(query, connection);

                command.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();
                
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                foreach (DataRow dataRow in dt.Rows)
                {
                    rows.Add(string.Join(";", dataRow.ItemArray.Select(item => item.ToString())));
                    total += Convert.ToDouble(dataRow.ItemArray[3].ToString());
                }
            }

            return string.Join("|", rows.Select(item => item.ToString()));
        }
        private string GetDataOccupationalElectives()
        {
            List<String> rows = new List<String>();
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string query = "SELECT DISTINCT a.AceID + ' ' + a.Title, u.unit , [subject] + '-' + course_number + ' ' + course_title, u.unit FROM VeteranOccupation as v \n" +
                               "INNER JOIN ACEExhibit as ae on ae.Occupation = v.OccupationCode \n" +
                               "INNER JOIN Articulation as a on a.aceid = ae.AceID \n" +
                               "INNER JOIN Course_IssuedForm as c on c.outline_id = a.outline_id and c.status = 0 and c.college_id = 1 \n" +
                               "INNER JOIN tblSubjects as s on s.subject_id = c.subject_id \n" +
                               "INNER JOIN Stages as st on a.ArticulationStage = st.id and st.[Order] = 4 \n" +
                               "INNER JOIN tblLookupUnits u on c.unit_id = u.unit_id \n" +
                               "WHERE v.veteranid = @VeteranID and s.subject in ('HES', 'CPL', 'MIL-SD', 'MIL-PE') and a.Articulate = 1";
                SqlCommand command = new SqlCommand(query, connection);

                command.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                foreach (DataRow dataRow in dt.Rows)
                {
                    rows.Add(string.Join(";", dataRow.ItemArray.Select(item => item.ToString())));
                    total += Convert.ToDouble(dataRow.ItemArray[3]);
                }
            }

            return string.Join("|", rows.Select(item => item.ToString()));
        }

        protected void rgApprovedCredits_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                Label label1 = (Label)dataBoundItem.FindControl("lblCPLStatus");
                string columnValue = dataBoundItem["DNA"].Text;

                // Set the label text based on the column value
                if (columnValue == "True")
                {
                    label1.Text = "Not Applicable (NA)";
                } else
                {
                    label1.Text = "";
                }
            }
        }


        protected void btnSendMail_Click(object sender, EventArgs e)
        {
            foreach (var item in txtSendEmail.Text.Split(';'))
            {
                if (!IsValidEmail(item))
                {
                    rnMessages.Text = "Invalid email : " + item;
                    rnMessages.Show();
                    return;
                }
            }

            var reportProcessor = new Telerik.Reporting.Processing.ReportProcessor();
            var deviceInfo = new System.Collections.Hashtable();
            var reportSource = new Telerik.Reporting.UriReportSource();

            reportSource.Uri = "reports\\MilitaryCredits.trdp";
            reportSource.Parameters.Add("CollegeID", hfCollege.Value);
            reportSource.Parameters.Add("VeteranID", hfVeteranID.Value);

            Telerik.Reporting.Processing.RenderingResult result = reportProcessor.RenderReport("PDF", reportSource, deviceInfo);

            if (!result.HasErrors)
            {
                Attachment att = new Attachment(new MemoryStream(result.DocumentBytes), "MilitaryCredits.pdf");
                if (GlobalUtil.SendEmail("Notification from MAP CPL Search", "<p>Attached is your Credit for Prior Learning Plan</p>", "mapadmin@mappingarticulatedpathways.org", txtSendEmail.Text, "", true, att))
                {
                    rnMessages.Text = "Email sent successfully";
                    rnMessages.Show();
                    txtSendEmail.Text = string.Empty;
                }
                else
                {
                    rnMessages.Text = "No Email was sent, there were problems";
                    rnMessages.Show();
                    txtSendEmail.Text = string.Empty;
                }
            }
            else
            {
                rnMessages.Text = "Problems with the pdf: " + result.Errors.FirstOrDefault().Message;
                rnMessages.Show();
                return;
            }

        }

        bool IsValidEmail(string email)
        {
            var trimmedEmail = email.Trim();

            if (trimmedEmail.EndsWith("."))
            {
                return false; // suggested by @TK-421
            }
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == trimmedEmail;
            }
            catch
            {
                return false;
            }
        }
    }
}