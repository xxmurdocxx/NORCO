using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Math;								  
using DocumentFormat.OpenXml.Wordprocessing;
using ems_app.Controllers;
using ems_app.modules.military;
using ems_app.modules.popups;
using ems_app.modules.users;
using Microsoft.VisualBasic.FileIO;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Interop;
using Telerik.Pdf;
using Telerik.Web.UI;
using Telerik.Web.UI.com.hisoftware.api2;
using Telerik.Windows.Documents.Spreadsheet.Expressions.Functions;

namespace ems_app.modules.settings
{
    public partial class Ambassador : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        private bool _readOnly = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["RoleName"].ToString() != "Ambassador")
            {
                _readOnly = true;
            }

            if (!IsPostBack)
            {
                rpbPrograms.CollapseAllItems();
                rpbSLOs.CollapseAllItems();
                rpbCrossListed.CollapseAllItems();
                DataTable dtAdditionalInformation = GlobalUtil.GetAdditionalInformation(Session["College"].ToString());
                if (dtAdditionalInformation != null)
                {
                    if (dtAdditionalInformation.Rows.Count > 0)
                    {
                        foreach (DataRow row in dtAdditionalInformation.Rows)
                        {
                            rtbPrimaryContact.Text = row["PRIMARY_CONTACT"].ToString();
                            rtbPrimaryContactEmail.Text = row["PRIMARY_CONTACT_EMAIL"].ToString();
                            rtbLeadEvaluator.Text = row["LEAD_EVALUATOR"].ToString();
                            rtbLeadEvaluatorEmail.Text = row["LEAD_EVALUATOR_EMAIL"].ToString();
                            rtbArticulationOfficer.Text = row["ARTICULATION_OFFICER"].ToString();
                            rtbArticulationOfficerEmail.Text = row["ARTICULATION_OFFICER_EMAIL"].ToString();
                            rtbAcademicSenatePresident.Text = row["ACADEMIC_SENATE_PRESIDENT"].ToString();
                            rtbAcademicSenatePresidentEmail.Text = row["ACADEMIC_SENATE_PRESIDENT_EMAIL"].ToString();
                            rtbFacultyLead.Text = row["FACULTY_LEAD"].ToString();
                            rtbFacultyLeadEmail.Text = row["FACULTY_LEAD_EMAIL"].ToString();
                            rtbSchoolCertifyngOfficial.Text = row["SCHOOL_CERTIFYING_OFFICIAL"].ToString();
                            rtbVeteranSchgoolCertifying.Text = row["VETERAN_SCHOOL_CERTIFYING_OFFICIAL_EMAIL"].ToString();
                            rtbVRCOfficial.Text = row["VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION"].ToString();
                            rtbVRCOfficialEmail.Text = row["VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION_EMAIL"].ToString();
                            rtbVPAA.Text = row["VPAA"].ToString();
                            rtbVPAAEmail.Text = row["VPAA_EMAIL"].ToString();
                            rtbLeadManager.Text = row["LEAD_MANAGER"].ToString();
                            rtbLeadManagerEmail.Text = row["LEAD_MANAGER_EMAIL"].ToString();
                            rtbCEO.Text = row["CEO"].ToString();
                            rtbCEOEmail.Text = row["CEO_EMAIL"].ToString();
                            rtbITContact.Text = row["IT_CONTACT"].ToString();
                            rtbITContactEmail.Text = row["IT_CONTACT_EMAIL"].ToString();
                            rtbStatus.Text = row["STATUS"].ToString();
                            rtbVeterans.Text = row["VETERANS"].ToString();
                            rtbVPSS.Text = row["VPSS"].ToString();
                            rtbVPSSEmail.Text = row["VPSS_EMAIL"].ToString();
                        }
                    }
                }

                
                rsTooltips.Checked = bool.Parse(Session["OnBoarding"].ToString());

                ViewState["ContactInfoSaved"] = false;

                InitializeCollegeLevelCheckboxes();
                InitializeChkEmailBatchNotif();
                InitializeChkEmailNotifTrigger();
                toggleSharedCurriculum(chkSharedCurriculum.Checked);
                togglePnlSendEmailButton(chckAllowEmailNotif.Checked);
                ducCourses.SampleFilePath = "~/Common/sampleFiles/CoursesSample.csv?v=3";
                ducSLOs.SampleFilePath = "~/Common/sampleFiles/StudentLearningOutcomesSample.csv?v=0";
                ducSLOs.EditChoiceVisible = false;
                ducSLOs.DeleteAndReplaceWarning = true;
                ducCrossListed.SampleFilePath = "~/Common/sampleFiles/CrossListedFamiliesSample.csv?v=0";
                ducCrossListed.EditChoiceVisible = false;
                ducCrossListed.DeleteAndReplaceWarning = true;
                ducExistingArticulations.SampleFilePath = "~/Common/sampleFiles/ExistingArticulationsSample.csv?v=1";
                ducExistingArticulations.EditChoiceVisible = false;
                ducPrograms.SampleFilePath = "~/Common/sampleFiles/ProgramsSample.csv?v=0";

                if (_readOnly)
                {
                    MakeFormReadOnly();
                }
            }
        }

        public void clearFields()
        {

        }

        public DataTable GetAmbassadorSetup(int college_id)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetAmbassadorSetup", conn);
                cmd.Parameters.Add("@CollegeID", SqlDbType.Int).Value = college_id;
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }
            return myDataTable;
        }

        public void UpdateAdditionalInformation()
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("UpdateMAPCohort", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("CollegeName", Session["College"].ToString());
            cmd.Parameters.AddWithValue("PrimaryContact", rtbPrimaryContact.Text);
            cmd.Parameters.AddWithValue("PrimaryContactEmail", rtbPrimaryContactEmail.Text);
            cmd.Parameters.AddWithValue("LeadEvaluator", rtbLeadEvaluator.Text);
            cmd.Parameters.AddWithValue("LeadEvaluatorEmail", rtbLeadEvaluatorEmail.Text);
            cmd.Parameters.AddWithValue("ArticulationOfficer", rtbArticulationOfficer.Text);
            cmd.Parameters.AddWithValue("ArticulationOfficerEmail", rtbArticulationOfficerEmail.Text);
            cmd.Parameters.AddWithValue("AcademicSenatePresident", rtbAcademicSenatePresident.Text);
            cmd.Parameters.AddWithValue("AcademicSenatePresidentEmail", rtbAcademicSenatePresidentEmail.Text);
            cmd.Parameters.AddWithValue("FacultyLead", rtbFacultyLead.Text);
            cmd.Parameters.AddWithValue("FacultyLeadEmail", rtbFacultyLeadEmail.Text);
            cmd.Parameters.AddWithValue("SchoolCertifyingOfficial", rtbSchoolCertifyngOfficial.Text);
            cmd.Parameters.AddWithValue("VeteranSchoolCertifyingOfficialEmail", rtbVeteranSchgoolCertifying.Text);
            cmd.Parameters.AddWithValue("VRCOfficialFromMAPCohortApplication", rtbVRCOfficial.Text);
            cmd.Parameters.AddWithValue("VRCOfficialFromMAPCohortApplicationEmail", rtbVRCOfficialEmail.Text);
            cmd.Parameters.AddWithValue("VPAA", rtbVPAA.Text);
            cmd.Parameters.AddWithValue("VPAAEmail", rtbVPAAEmail.Text);
            cmd.Parameters.AddWithValue("LeadManager", rtbLeadManager.Text);
            cmd.Parameters.AddWithValue("LeadManagerEmail", rtbLeadManagerEmail.Text);
            cmd.Parameters.AddWithValue("CEO", rtbCEO.Text);
            cmd.Parameters.AddWithValue("CEOEmail", rtbCEOEmail.Text);
            cmd.Parameters.AddWithValue("ITContact", rtbITContact.Text);
            cmd.Parameters.AddWithValue("ITContactEmail", rtbITContactEmail.Text);
            cmd.Parameters.AddWithValue("Status", rtbStatus.Text);
            cmd.Parameters.AddWithValue("IEDRC", "");
            cmd.Parameters.AddWithValue("Veterans", rtbVeterans.Text);
            cmd.Parameters.AddWithValue("VPSS", rtbVPSS.Text);
            cmd.Parameters.AddWithValue("VPSSEmail", rtbVPSSEmail.Text);
            cmd.ExecuteReader();
            conn.Close();
        }

        protected void RadWizard1_ActiveStepChanged(object sender, EventArgs e)
        {
            int activeStepIndex = (sender as RadWizard).ActiveStep.Index;

            if (activeStepIndex == 0)
            {
                ViewState["ContactInfoSaved"] = false;
            }
            else if (!(bool)ViewState["ContactInfoSaved"])
            {
                try
                {
                    UpdateAdditionalInformation();
                    ViewState["ContactInfoSaved"] = true;
                }
                catch (Exception ex)
                {
                    HandleException(ex);
                }
            }
            
            ConfigureSelfGuidedTrainingToolForStep(activeStepIndex);
            
        }

        

        protected void rbBack_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.RawUrl);
        }

        public void ShowNotification(string _title, string _msg)
        {
            RadNotification1.Title = _title;
            RadNotification1.Text = _msg;
            RadNotification1.Show();
        }

        //Added by Pedro B. 04/13/2023
        //Modified by Pedro B. /20/2023
        protected void rbSend_Noti_Click(object sender, EventArgs e)
        {
            int emails = EmailProgram.Send_Email_Notif((int)Session["CollegeId"]);

            if (emails != -1)
            {
                if (emails > 0)
                {
                    ShowNotification("Success message!", "Your email message was sent successfully.");
                }
                else
                {
                    ShowNotification("Info message!", "You don't have any pending messages to send.");
                }
            }
            else
            {
                ShowNotification("Error message!", "It was not possible to send the email message. Please contact the system administrator.");
            }
        }
        protected void rgPrograms_BatchEditCommand(object sender, GridBatchEditingEventArgs e)
        {
            foreach (GridBatchEditingCommand command in e.Commands)
            {
                if ((command.Type == GridBatchEditingCommandType.Update))
                {
                    Hashtable newValues = command.NewValues;
                    Hashtable oldValues = command.OldValues;
                    int issuedFormId = (int)newValues["issuedformid"];
                    string programDescription = newValues["ProgramDescription"].ToString();

                    try
                    {
                        UpdateProgram(issuedFormId, programDescription, (int)Session["UserID"]);
                    }
                    catch (Exception ex)
                    {
                        HandleException(ex);
                    }
                }
            }
        }
        public void UpdateCourse(int outlineID, string catalogDescription, int userID)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("UpdateAmbassadorCourses", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("outline_id", outlineID);
            cmd.Parameters.AddWithValue("CatalogDescription", catalogDescription);
            cmd.Parameters.AddWithValue("UserID", userID);
            cmd.ExecuteReader();
            conn.Close();
        }

        public void UpdateProgram(int issuedFormId, string programDescription, int userID)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("UpdateAmbassadorProgram", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("issuedformid", issuedFormId);
            cmd.Parameters.AddWithValue("ProgramDescription", programDescription);
            cmd.Parameters.AddWithValue("UserID", userID);
            cmd.ExecuteReader();
            conn.Close();
        }

        protected void ducCourses_FileUploaded(object sender, EventArgs e)
        {
            try
            {
                var file = ((FileUploadedEventArgs)e).File;
                string csvPath = Server.MapPath("~/UploadedFiles/") + file.GetNameWithoutExtension() + "_" + Guid.NewGuid().ToString("N") + file.GetExtension();
                file.SaveAs(csvPath);

                Dictionary<string, int> columns = new Dictionary<string, int>();
                columns.Add("Course", 0);
                columns.Add("Course Description", 1);

                var notMatched = new StringBuilder();

                using (TextFieldParser parser = new TextFieldParser(csvPath))
                {
                    parser.TextFieldType = FieldType.Delimited;
                    parser.SetDelimiters(",");
                    int i = 1;
                    while (!parser.EndOfData)
                    {
                        string[] cells = parser.ReadFields();
                        // validate header row
                        if (i == 1)
                        {
                            if (!ValidateHeaders(cells, columns.Keys.ToArray()))
                            {
                                ducCourses.ErrorMessage = "The file provided does not match the sample file format, please check the format and try again.";
                                return;
                            }
                            i++;
                            continue;
                        }
                        var course = cells[columns["Course"]];
                        var outlineId = GetCourseOutlineId(course);
                        if (outlineId == 0)
                        {
                            notMatched.AppendLine(course);
                        }
                        else
                        {
                            var description = cells[columns["Course Description"]];
                            UpdateCourse(outlineId, description, (int)Session["UserID"]);
                        }
                        i++;
                    }
                }

                if (notMatched.Length > 0)
                {
                    ducCourses.WarningMessage = "No updates were performed for the following courses because they were not found in MAP: " + notMatched.ToString();
                }

                ucCourseEdit.Rebind();
                ducCourses.SuccessMessage = "Your upload has completed.  You may view the updated data on the left.";
                File.Delete(csvPath);
            }
            catch (Exception ex)
            {
                ducCourses.ErrorMessage = "The following error occurred: " + ex.Message;
            }
        }

        protected void ducSLOs_FileUploaded(object sender, EventArgs e)
        {
            try
            {
                var file = ((FileUploadedEventArgs)e).File;
                string csvPath = Server.MapPath("~/UploadedFiles/") + file.GetNameWithoutExtension() + "_" + Guid.NewGuid().ToString("N") + file.GetExtension();
                file.SaveAs(csvPath);

                Dictionary<string, int> columns = new Dictionary<string, int>();
                columns.Add("Course", 0);
                columns.Add("SLO Description", 1);
                columns.Add("Order", 2);

                var notMatched = new StringBuilder();

                using (TextFieldParser parser = new TextFieldParser(csvPath))
                {
                    parser.TextFieldType = FieldType.Delimited;
                    parser.SetDelimiters(",");
                    int i = 1;
                    var deleteAll = true;
                    while (!parser.EndOfData)
                    {
                        string[] cells = parser.ReadFields();
                        // validate header row
                        if (i == 1)
                        {
                            if (!ValidateHeaders(cells, columns.Keys.ToArray()))
                            {
                                ducSLOs.ErrorMessage = "The file provided does not match the sample file format, please check the format and try again.";
                                return;
                            }
                            i++;
                            continue;
                        }
                        var course = cells[columns["Course"]];
                        var outlineId = GetCourseOutlineId(course);
                        if (outlineId == 0)
                        {
                            notMatched.AppendLine(course);
                        }
                        else
                        {
                            var description = cells[columns["SLO Description"]];
                            var sorder = cells[columns["Order"]];
                            int order;
                            int.TryParse(sorder, out order);
                            var parameters = new SqlParameter[]
                            {
                            new SqlParameter("@OutlineId", outlineId),
                            new SqlParameter("@SLODescription", description),
                            new SqlParameter("@Order", order),
                            new SqlParameter("@UserId", (int)Session["UserID"]),
                            new SqlParameter("@CollegeId", (int)Session["CollegeId"]),
                            new SqlParameter("@DeleteAllForCollege", deleteAll)
                            };
                            GetDataTable("LoadAmbassadorStudentLearningOutcome", CommandType.StoredProcedure, parameters);
                            deleteAll = false;
                        }
                        i++;
                    }
                }

                if (notMatched.Length > 0)
                {
                    ducSLOs.WarningMessage = "No updates were performed for the following courses because they were not found in MAP: " + notMatched.ToString();
                }

                rgSLOs.Rebind();
                ducSLOs.SuccessMessage = "Your upload has completed.  You may view the updated data on the left.";
                File.Delete(csvPath);
            }
            catch (Exception ex)
            {
                ducSLOs.ErrorMessage = "The following error occurred: " + ex.Message;
            }
        }

        protected void ducCrossListed_FileUploaded(object sender, EventArgs e)
        {
            try
            {
                var file = ((FileUploadedEventArgs)e).File;
                string csvPath = Server.MapPath("~/UploadedFiles/") + file.GetNameWithoutExtension() + "_" + Guid.NewGuid().ToString("N") + file.GetExtension();
                file.SaveAs(csvPath);

                Dictionary<string, int> columns = new Dictionary<string, int>();
                columns.Add("Parent Course", 0);
                columns.Add("Cross Listed Course", 1);
                columns.Add("Order", 2);

                var notMatched = new StringBuilder();

                using (TextFieldParser parser = new TextFieldParser(csvPath))
                {
                    parser.TextFieldType = FieldType.Delimited;
                    parser.SetDelimiters(",");
                    int i = 1;
                    var deleteAll = true;
                    while (!parser.EndOfData)
                    {
                        string[] cells = parser.ReadFields();
                        // validate header row
                        if (i == 1)
                        {
                            if (!ValidateHeaders(cells, columns.Keys.ToArray()))
                            {
                                ducCrossListed.ErrorMessage = "The file provided does not match the sample file format, please check the format and try again.";
                                return;
                            }
                            i++;
                            continue;
                        }
                        var parentCourse = cells[columns["Parent Course"]];
                        var parentOutlineId = GetCourseOutlineId(parentCourse);
                        var childCourse = cells[columns["Cross Listed Course"]];
                        var childOutlineId = GetCourseOutlineId(childCourse);
                        if (parentOutlineId == 0 || childOutlineId == 0)
                        {
                            if (parentOutlineId == 0)
                            {
                                notMatched.AppendLine(parentCourse);
                            }
                            if (childOutlineId == 0)
                            {
                                notMatched.AppendLine(childCourse);
                            }
                        }
                        else
                        {
                            var sorder = cells[columns["Order"]];
                            int order;
                            int.TryParse(sorder, out order);
                            var parameters = new SqlParameter[]
                            {
                            new SqlParameter("@ParentOutlineId", parentOutlineId),
                            new SqlParameter("@ChildOutlineId", childOutlineId),
                            new SqlParameter("@Order", order),
                            new SqlParameter("@CollegeId", (int)Session["CollegeId"]),
                            new SqlParameter("@DeleteAllForCollege", deleteAll)
                            };
                            GetDataTable("LoadAmbassadorCrossListing", CommandType.StoredProcedure, parameters);
                            deleteAll = false;
                        }
                        i++;
                    }
                }

                if (notMatched.Length > 0)
                {
                    ducCrossListed.WarningMessage = "No updates were performed for the following courses because they were not found in MAP: " + notMatched.ToString();
                }

                rgCrossListed.Rebind();
                ducCrossListed.SuccessMessage = "Your upload has completed.  You may view the updated data on the left.";
                File.Delete(csvPath);
            }
            catch (Exception ex)
            {
                ducCrossListed.ErrorMessage = "The following error occurred: " + ex.Message;
            }
        }

        protected void ducExistingArticulations_FileUploaded(object sender, EventArgs e)
        {
            try
            {
                var file = ((FileUploadedEventArgs)e).File;
                string csvPath = Server.MapPath("~/UploadedFiles/") + file.GetNameWithoutExtension() + "_" + Guid.NewGuid().ToString("N") + file.GetExtension();
                file.SaveAs(csvPath);

                Dictionary<string, int> columns = new Dictionary<string, int>();
                columns.Add("Course", 0);
                columns.Add("ACE ID", 1);
                columns.Add("Team Reviewed Date", 2);
                columns.Add("Credit Recommendation(s)", 3);
                columns.Add("Notes", 4);

                var notMatchedCourses = new StringBuilder();
                var notMatchedAceIds = new StringBuilder();

                using (TextFieldParser parser = new TextFieldParser(csvPath))
                {
                    parser.TextFieldType = FieldType.Delimited;
                    parser.SetDelimiters(",");
                    int i = 1;
                    while (!parser.EndOfData)
                    {
                        string[] cells = parser.ReadFields();
                        // validate header row
                        if (i == 1)
                        {
                            if (!ValidateHeaders(cells, columns.Keys.ToArray()))
                            {
                                ducExistingArticulations.ErrorMessage = "The file provided does not match the sample file format, please check the format and try again.";
                                return;
                            }
                            i++;
                            continue;
                        }
                        var course = cells[columns["Course"]];
                        var outlineId = GetCourseOutlineId(course);
                        var aceId = cells[columns["ACE ID"]];
                        var sdate = cells[columns["Team Reviewed Date"]];
                        DateTime teamRevisionDate;
                        int aceExhibitId = 0;
                        if (DateTime.TryParse(sdate, out teamRevisionDate))
                        {
                            aceExhibitId = GetAceExhibitId(aceId, teamRevisionDate);
                        }

                        if (outlineId == 0 || aceExhibitId == 0)
                        {
                            if (outlineId == 0)
                            {
                                notMatchedCourses.AppendLine(course);
                            }
                            if (aceExhibitId == 0)
                            {
                                notMatchedAceIds.AppendLine(aceId + " (" + cells[columns["Team Reviewed Date"]] + ")");
                            }
                        }
                        else
                        {
                            string creditRecommendations = cells[columns["Credit Recommendation(s)"]];
                            string notes = cells[columns["Notes"]];
                            var parameters = new SqlParameter[]
                            {
                            new SqlParameter("@outline_id", outlineId),
                            new SqlParameter("@AceID", aceId),
                            new SqlParameter("@TeamRevd", teamRevisionDate),
                            new SqlParameter("@notes", notes),
                            new SqlParameter("@recommendation", creditRecommendations),
                            new SqlParameter("@UserId", (int)Session["UserID"]),
                            new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                            };
                            GetDataTable("AddArticulationFromCohort", CommandType.StoredProcedure, parameters);
                        }
                        i++;
                    }
                }

                if (notMatchedCourses.Length > 0)
                {
                    ducExistingArticulations.WarningMessage = "No updates were performed for the following courses because they were not found in MAP: " + notMatchedCourses.ToString();
                }
                if (notMatchedAceIds.Length > 0)
                {
                    ducExistingArticulations.WarningMessage += "\r\nNo updates were performed for the following ACE IDs because they were not found in MAP: " + notMatchedAceIds.ToString();
                }

                rgExistingArticulations.Rebind();
                ducExistingArticulations.SuccessMessage = "Your upload has completed.  You may view the updated data on the left.  The MAP team will review your submission and contact you if more information is required.";
                File.Delete(csvPath);
            }
            catch (Exception ex)
            {
                ducExistingArticulations.ErrorMessage = "The following error occurred: " + ex.Message;
            }
        }

        protected void ducPrograms_FileUploaded(object sender, EventArgs e)
        {
            try
            {
                var file = ((FileUploadedEventArgs)e).File;
                string csvPath = Server.MapPath("~/UploadedFiles/") + file.GetNameWithoutExtension() + "_" + Guid.NewGuid().ToString("N") + file.GetExtension();
                file.SaveAs(csvPath);

                Dictionary<string, int> columns = new Dictionary<string, int>();
                columns.Add("Program of Study", 0);
                columns.Add("Program Description", 1);

                var notMatched = new StringBuilder();

                using (TextFieldParser parser = new TextFieldParser(csvPath))
                {
                    parser.TextFieldType = FieldType.Delimited;
                    parser.SetDelimiters(",");
                    int i = 1;
                    while (!parser.EndOfData)
                    {
                        string[] cells = parser.ReadFields();
                        // validate header row
                        if (i == 1)
                        {
                            if (!ValidateHeaders(cells, columns.Keys.ToArray()))
                            {
                                ducPrograms.ErrorMessage = "The file provided does not match the sample file format, please check the format and try again.";
                                return;
                            }
                            i++;
                            continue;
                        }
                        var programOfStudy = cells[columns["Program of Study"]];
                        var issuedFormId = GetProgramIssuedFormId(programOfStudy);
                        if (issuedFormId == 0)
                        {
                            notMatched.AppendLine(programOfStudy);
                        }
                        else
                        {
                            var description = cells[columns["Program Description"]];
                            UpdateProgram(issuedFormId, description, (int)Session["UserID"]);
                        }
                        i++;
                    }
                }

                if (notMatched.Length > 0)
                {
                    ducPrograms.WarningMessage = "No updates were performed for the following programs of study because they were not found in MAP: " + notMatched.ToString();
                }

                rgPrograms.Rebind();
                ducPrograms.SuccessMessage = "Your upload has completed.  You may view the updated data on the left.";
                File.Delete(csvPath);
            }
            catch (Exception ex)
            {
                ducPrograms.ErrorMessage = "The following error occurred: " + ex.Message;
            }
        }


        private DataTable GetDataTable(string commandText, CommandType commandType, SqlParameter[] parameters)
        {
            ConvertNullToDbNull(parameters);
            DataTable dataTable = new DataTable();
            string connectionString = ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString;
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = commandType;
                    cmd.CommandText = commandText;
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dataTable);
                    }
                }
            }
            return dataTable;
        }

        private static void ConvertNullToDbNull(SqlParameter[] parameters)
        {
            if (parameters == null)
            {
                return;
            }
            foreach (SqlParameter p in parameters)
            {
                if (p.Value == null)
                {
                    p.Value = DBNull.Value;
                }
            }
        }

        protected void rsTooltips_CheckedChanged(object sender, EventArgs e)
        {
            var userId = (int)Session["UserID"];
            // this will toggle the welcome setting based on its current setting
            norco_db.UpdateUserWelcome(userId);
            // refresh the UI from the DB in case they get out of sync
            var userData = norco_db.GetUserDataByID(userId).FirstOrDefault();
            rsTooltips.Checked = userData.Welcome;
            Session["OnBoarding"] = userData.Welcome.ToString();
            if (rsTooltips.Checked ?? false)
            {
                ConfigureSelfGuidedTrainingToolForStep(RadWizard1.ActiveStep.Index);
            }
        }

        private bool ValidateHeaders(string[] headerCells, string[] headerColumnNames)
        {
            if (headerCells.GetUpperBound(0) < headerColumnNames.GetUpperBound(0))
            {
                return false;
            }
            for(int i = 0; i < headerColumnNames.Length; i++)
            {
                if (headerCells[i].ToLower() != headerColumnNames[i].ToLower())
                {
                    return false;
                }
            }
            return true;
        }

        private int GetCourseOutlineId(string course)
        {
            int outlineId = 0;
            var courseSplit = course.Split(' ');
            if (courseSplit.GetUpperBound(0) == 1)
            {
                var subject = courseSplit[0].Trim();
                var courseNumber = courseSplit[1].Trim();

                var parameters = new SqlParameter[]
                {
                            new SqlParameter("@Subject", subject),
                            new SqlParameter("@CourseNumber", courseNumber),
                            new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var dt = GetDataTable("GetCourseOutlineId", CommandType.StoredProcedure, parameters);
                if (dt.Rows.Count > 0)
                {
                    outlineId = (int)dt.Rows[0]["outline_id"];
                }
            }
            return outlineId;
        }

        private int GetAceExhibitId(string aceId, DateTime teamRevisionDate)
        {
            int aceExhibitId = 0;

            var parameters = new SqlParameter[]
            {
                new SqlParameter("@AceID", aceId),
                new SqlParameter("@TeamRevd", teamRevisionDate),
            };
            var sql = "SELECT ID FROM ACEExhibit WHERE AceID = @AceID AND TeamRevd = @TeamRevd";
            var dt = GetDataTable(sql, CommandType.Text, parameters);
            if (dt.Rows.Count > 0)
            {
                aceExhibitId = (int)dt.Rows[0]["ID"];
            }
            
            return aceExhibitId;
        }

        private int GetProgramIssuedFormId(string programOfStudy)
        {
            int issuedFormId = 0;
            
            var parameters = new SqlParameter[]
            {
                new SqlParameter("@Program", programOfStudy),
                new SqlParameter("@CollegeId", (int)Session["CollegeId"])
            };
            var sql = "SELECT issuedformid FROM Program_IssuedForm WHERE program = @Program AND college_id = @CollegeId AND status = 0";
            var dt = GetDataTable(sql, CommandType.Text, parameters);
            if (dt.Rows.Count > 0)
            {
                issuedFormId = (int)dt.Rows[0]["issuedformid"];
            }
            return issuedFormId;
        }

        protected void chkAutoApproveByMajority_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@AutoApproveByMajority", chkAutoApproveByMajority.Checked),
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "UPDATE LookupColleges SET AutoApproveByMajority = @AutoApproveByMajority WHERE CollegeID = @CollegeId";
                GetDataTable(sql, CommandType.Text, parameters);
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            
        }

        protected void chkAutoPublish_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@AutoPublish", chkAutoApproveByMajority.Checked),
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "UPDATE LookupColleges SET AutoPublish = @AutoPublish WHERE CollegeID = @CollegeId";
                GetDataTable(sql, CommandType.Text, parameters);
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
            
        }

        protected void chkSetAllowEmailNoti_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@AutoPublish", chckAllowEmailNotif.Checked),
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "UPDATE LookupColleges SET AllowEmailFacultyNotification = @AutoPublish WHERE CollegeID = @CollegeId";
                GetDataTable(sql, CommandType.Text, parameters);

                togglePnlSendEmailButton(chckAllowEmailNotif.Checked);

            }
            catch (Exception ex)
            {
                HandleException(ex);
            }

        }

        protected void chkSetAllowEmailNotiTrig_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@AutoPublish", chckAllowEmailNotif.Checked),
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "UPDATE LookupColleges SET AllowEmailNotificationTrigger = @AutoPublish WHERE CollegeID = @CollegeId";
                GetDataTable(sql, CommandType.Text, parameters);

            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
        }


        protected void chkSharedCurriculum_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@SharedCurriculum", chkSharedCurriculum.Checked),
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "";
                if (chkSharedCurriculum.Checked)
                {
                    sql = "UPDATE LookupColleges SET SharedCurriculum = @SharedCurriculum WHERE CollegeID = @CollegeId";
                } else
                {
                    sql = "UPDATE LookupColleges SET SharedCurriculum = 0, AllowFacultyNotifications = 0, AutoAdoptArticulations = 0, AutoApproveByMajority = 0 WHERE CollegeID = @CollegeId";
                }
                GetDataTable(sql, CommandType.Text, parameters);
                InitializeCollegeLevelCheckboxes();
                toggleSharedCurriculum(chkSharedCurriculum.Checked);
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
        }

        private void toggleSharedCurriculum(bool toggle)
        {
            pnlSharedCurriculum.Visible = toggle;
        }

        private void togglePnlSendEmailButton(bool toggle)
        {
            pnlSendEmailButton.Visible = toggle;
        }


        private void InitializeCollegeLevelCheckboxes()
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "SELECT ISNULL(AutoApproveByMajority, 0) AS AutoApproveByMajority, ISNULL(AutoPublish, 0) AS AutoPublish, ISNULL(SharedCurriculum, 0) AS SharedCurriculum, ISNULL(AutoAdoptArticulations, 0) AS AutoAdoptArticulations, ISNULL(AllowFacultyNotifications, 0) AS AllowFacultyNotifications FROM LookupColleges WHERE CollegeID = @CollegeId";
                var dt = GetDataTable(sql, CommandType.Text, parameters);
                if (dt.Rows.Count > 0)
                {
                    chkAutoApproveByMajority.Checked = (bool)dt.Rows[0]["AutoApproveByMajority"];
                    chkAutoPublish.Checked = (bool)dt.Rows[0]["AutoPublish"];
                    chkSharedCurriculum.Checked = (bool)dt.Rows[0]["SharedCurriculum"];
                    chkAutoAdoptArticulations.Checked = (bool)dt.Rows[0]["AutoAdoptArticulations"];
                    chkAllowFacultyNotifications.Checked = (bool)dt.Rows[0]["AllowFacultyNotifications"];
                }
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
        }

        private void InitializeChkEmailBatchNotif()
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "SELECT ISNULL(AllowEmailFacultyNotification, 0) AS AllowEmailFacultyNotification from LookupColleges where CollegeID = @CollegeId";
                var dt = GetDataTable(sql, CommandType.Text, parameters);
                if (dt.Rows.Count > 0)
                {
                    chckAllowEmailNotif.Checked = (bool)dt.Rows[0]["AllowEmailFacultyNotification"];
                }

            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
        }

        private void InitializeChkEmailNotifTrigger()
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "SELECT ISNULL(AllowEmailNotificationTrigger, 0) AS AllowEmailNotificationTrigger from LookupColleges where CollegeID = @CollegeId";
                var dt = GetDataTable(sql, CommandType.Text, parameters);
                if (dt.Rows.Count > 0)
                {
                    chckAllowEmailNotifTriggered.Checked = (bool)dt.Rows[0]["AllowEmailNotificationTrigger"];
                }

            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
        }


        private void HandleException(Exception ex)
        {
            lblMessage.Text = ex.ToString();
            pnlMessage.Visible = true;
        }

        private void ConfigureSelfGuidedTrainingToolForStep(int activeStepIndex)
        {
            if (rsTooltips.Checked == true)
            {
                switch (activeStepIndex)
                {
                    case 0:
                        ScriptManager.RegisterStartupScript(Page, typeof(Page), "AdditionalInformation", "AdditionalInformation();", true);
                        break;
                    case 1:
                        ScriptManager.RegisterStartupScript(Page, typeof(Page), "WorkflowConfiguration", "Workflow();", true);
                        break;
                    case 2:
                        ScriptManager.RegisterStartupScript(Page, typeof(Page), "DataUpload", "DataUpload();", true);
                        break;
                    case 3:
                        ScriptManager.RegisterStartupScript(Page, typeof(Page), "Resources", "Resources();", true);
                        break;
                    default:
                        break;
                }
            }
        }

        private void MakeFormReadOnly()
        {
            pnlAdditionalContacts.Enabled = false;
            chkAutoApproveByMajority.Enabled = false;
            chkAutoPublish.Enabled = false;
            chkSharedCurriculum.Enabled = false;
            rgWorkflow.MasterTableView.CommandItemSettings.ShowSaveChangesButton = false;
            rgWorkflow.MasterTableView.CommandItemSettings.ShowCancelChangesButton = false;
            ucCourseEdit.ReadOnly = true;
            ducCourses.Visible = false;
            ducSLOs.Visible = false;
            ducCrossListed.Visible = false;
            ducExistingArticulations.Visible = false;
            rgPrograms.MasterTableView.CommandItemSettings.ShowSaveChangesButton = false;
            rgPrograms.MasterTableView.CommandItemSettings.ShowCancelChangesButton = false;
            ducPrograms.Visible = false;


        }

        protected void chkAutoAdoptArticulations_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@AutoAdoptArticulations", chkAutoAdoptArticulations.Checked),
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "UPDATE LookupColleges SET AutoAdoptArticulations = @AutoAdoptArticulations WHERE CollegeID = @CollegeId";
                GetDataTable(sql, CommandType.Text, parameters);
            }
            catch (Exception ex)
            {
                HandleException(ex); 
            }
        }

        protected void chkAllowFacultyNotifications_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@AllowFacultyNotifications", chkAllowFacultyNotifications.Checked),
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "UPDATE LookupColleges SET AllowFacultyNotifications = @AllowFacultyNotifications WHERE CollegeID = @CollegeId";
                GetDataTable(sql, CommandType.Text, parameters);
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
        }
        protected void rcbAreaCreditType_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            GridEditableItem editedItem = (o as RadComboBox).NamingContainer as GridEditableItem;

            RadComboBox Combo = o as RadComboBox;
            RadComboBox coursesCombo = editedItem["CourseName"].FindControl("rcbCourses") as RadComboBox;

            coursesCombo.DataSource = LoadCourses(Session["CollegeID"].ToString(),e.Value);
            coursesCombo.DataBind();
        }
        protected DataTable LoadCourses(string CollegeID, string AreaCreditTypeID)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetAreaCreditCourses", conn);
                cmd.Parameters.AddWithValue("@CollegeID", CollegeID);
                cmd.Parameters.AddWithValue("@AreaCreditTypeID", AreaCreditTypeID);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }
            return myDataTable;
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                GridEditableItem editedItem = e.Item as GridEditableItem;

                if (e.Item.OwnerTableView.IsItemInserted)
                {
                    RadComboBox areaCombo = editedItem.FindControl("rcbAreaCreditType") as RadComboBox;
                    RadComboBox coursesCombo = editedItem.FindControl("rcbCourses") as RadComboBox;
                    coursesCombo.DataSource = LoadCourses(Session["CollegeID"].ToString(),areaCombo.SelectedValue);
                    coursesCombo.DataBind();
                }
                else
                {
                    DataRowView dataSourceRow = (DataRowView)e.Item.DataItem;
                    RadComboBox areaCombo = editedItem.FindControl("rcbAreaCreditType") as RadComboBox;
                    RadComboBox coursesCombo = editedItem.FindControl("rcbCourses") as RadComboBox;
                    coursesCombo.DataSource = LoadCourses(Session["CollegeID"].ToString(), areaCombo.SelectedValue);
                    coursesCombo.DataBind();
                    coursesCombo.SelectedValue = dataSourceRow["Outline_id"].ToString();
                }
            }
        }

        protected void RadGrid1_UpdateCommand(object source, GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            string ID = editedItem.OwnerTableView.DataKeyValues[editedItem.ItemIndex]["ID"].ToString();
            string area_credit = ((RadComboBox)(editedItem["AreaCreditType"].FindControl("rcbAreaCreditType"))).SelectedValue;
            string outline_id = ((RadComboBox)(editedItem["CourseName"].FindControl("rcbCourses"))).SelectedValue;
            string area = ((RadTextBox)(editedItem["Area"].FindControl("txtArea"))).Text;
            string title = ((RadTextBox)(editedItem["Title"].FindControl("txtTitle"))).Text;
            string min_unit = (editedItem["Min_Unit_id"].Controls[0] as RadComboBox).SelectedValue;
            string max_unit = (editedItem["Max_Unit_id"].Controls[0] as RadComboBox).SelectedValue;
            string transcript_code = (editedItem["TranscriptCode"].Controls[0] as TextBox).Text;
            string link = (editedItem["Link"].Controls[0] as TextBox).Text;
            string notes = (editedItem["Notes"].Controls[0] as TextBox).Text;
            string cpl_units = string.IsNullOrEmpty((editedItem["CPLUnitLimit"].Controls[0] as TextBox).Text) ? "0" : (editedItem["CPLUnitLimit"].Controls[0] as TextBox).Text;
            bool waive_area = (bool)(editedItem["WaiveAreaERequirement"].Controls[0] as System.Web.UI.WebControls.CheckBox).Checked;
            string query = $"Update DefaultAreaEGlobalCredit SET Area='{area}', Title='{title}', AreaCreditTypeID={area_credit}, Outline_id={outline_id}, Min_Unit_id = {min_unit}, Max_Unit_id = {max_unit}, TranscriptCode = '{transcript_code}', Link = '{link}', Notes = '{notes}', CPLUnitLimit = {cpl_units}, WaiveAreaERequirement = '{waive_area}' Where ID={ID}";

            sqlDefaultAreaEGlobalCredit.UpdateCommand = query;
            sqlDefaultAreaEGlobalCredit.Update();
        }
        protected void RadGrid1_InsertCommand(object source, GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            string area_credit = ((RadComboBox)(editedItem["AreaCreditType"].FindControl("rcbAreaCreditType"))).SelectedValue;
            string outline_id = ((RadComboBox)(editedItem["CourseName"].FindControl("rcbCourses"))).SelectedValue;
            string area = ((RadTextBox)(editedItem["Area"].FindControl("txtArea"))).Text;
            string title = ((RadTextBox)(editedItem["Title"].FindControl("txtTitle"))).Text;
            string min_unit = (editedItem["Min_Unit_id"].Controls[0] as RadComboBox).SelectedValue;
            string max_unit = (editedItem["Max_Unit_id"].Controls[0] as RadComboBox).SelectedValue;
            string transcript_code = (editedItem["TranscriptCode"].Controls[0] as TextBox).Text;
            string link = (editedItem["Link"].Controls[0] as TextBox).Text;
            string notes = (editedItem["Notes"].Controls[0] as TextBox).Text;
            string cpl_units = string.IsNullOrEmpty((editedItem["CPLUnitLimit"].Controls[0] as TextBox).Text) ? "0" : (editedItem["CPLUnitLimit"].Controls[0] as TextBox).Text;
            bool waive_area = (bool)(editedItem["WaiveAreaERequirement"].Controls[0] as System.Web.UI.WebControls.CheckBox).Checked;
            string query = $"INSERT INTO DefaultAreaEGlobalCredit (Area, Title, AreaCreditTypeID, Outline_id, Min_Unit_id, Max_Unit_id, TranscriptCode, Link, Notes, CPLUnitLimit, WaiveAreaERequirement, CollegeID) VALUES ('{area}', '{title}', {area_credit}, {outline_id}, {min_unit},{max_unit}, '{transcript_code}', '{link}', '{notes}', {cpl_units}, '{waive_area}',{System.Convert.ToInt32(Session["CollegeID"])})";


            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                const string statement = "INSERT INTO DefaultAreaEGlobalCredit (Area, Title, AreaCreditTypeID, Outline_id, Min_Unit_id, Max_Unit_id, TranscriptCode, Link, Notes, CPLUnitLimit, WaiveAreaERequirement, CollegeID) VALUES (@Area, @Title, @AreaCredit, @OutlineID, @MinUnit, @MaxUnit, @TranscriptCode, @Link, @Notes, @CPLUnits, @WaiveArea,@CollegeID)";

                using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
                {
                    cmd.Parameters.AddWithValue("@Area", area);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@AreaCredit", area_credit);
                    cmd.Parameters.AddWithValue("@OutlineID", outline_id);
                    cmd.Parameters.AddWithValue("@MinUnit", min_unit);
                    cmd.Parameters.AddWithValue("@MaxUnit", max_unit);
                    cmd.Parameters.AddWithValue("@TranscriptCode", transcript_code);
                    cmd.Parameters.AddWithValue("@Link", link);
                    cmd.Parameters.AddWithValue("@Notes", notes);
                    cmd.Parameters.AddWithValue("@CPLUnits", cpl_units);
                    cmd.Parameters.AddWithValue("@WaiveArea", waive_area);
                    cmd.Parameters.AddWithValue("@CollegeID", System.Convert.ToInt32(Session["CollegeID"].ToString()));
                    try
                    {
                        connection.Open();
                        cmd.ExecuteScalar();
                    }
                    catch (Exception ex)
                    {
                        throw;
                    }
                }
            }
            //sqlDefaultAreaEGlobalCredit.InsertCommand = query;
            //sqlDefaultAreaEGlobalCredit.Insert();


        }

        protected void rgWorkflow_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = (GridDataItem)e.Item;
                System.Web.UI.WebControls.CheckBox checkbox = (System.Web.UI.WebControls.CheckBox)item.FindControl("CheckBox1");
                string columnValue = item["Stage"].Text;
                checkbox.Text = columnValue;
            }
        }


        class CreditRecommendation
        {

        public static string GetNumberLink(string cadena, string urlhr)
        {
            string[] partes = cadena.Split(new string[] { "<b><u>", "</u></b>" }, StringSplitOptions.None);
            string parte1 = partes[0];
            string parte2 = partes[1];
            string parte3 = partes[2];
            return parte1 + "<b><a href='" + urlhr + "'>"+ parte2 + "</a></b>" + parte3;
        }

        public static string GetArticulations(int collegeid, int message_id, string action_taken, string articulations, string username, string password, string subject, string db_connection, bool tookaction)
        {
            string ArticulationList = "";
            string style_button = "text-align:center; display:flex;justify-content:center;color:#000;font-size:13px !important;margin:3px;padding:8px;text-decoration:none;font-weight:700;border-radius:5px;cursor:pointer;";
            string style_button_grey = "text-align:center;display:flex;color:#f8f8f8;font-size:13px !important;margin:3px;padding:8px;text-decoration:none;font-weight:700;border-radius:5px;cursor:pointer;";
            string style_cell = "padding:5px; color:#000;";
            //string host = "http://localhost:49573";
                //string host = "https://maptrainingplatformv2.azurewebsites.net/";

              string host = GlobalUtil.GetDatabaseSetting("SiteName");
                //string host = "https://militaryarticulationplatformweb.azurewebsites.net/";
                //string url = $"{host}modules/Notifications/Confirm_o.aspx";
              string url = $"{host}/modules/Notifications/EmailAccess_o.aspx";
                //string url = $"{host}/modules/security/Login.aspx";

                string url_parameters = $"&MessageID={Security.Encrypt(message_id.ToString())}&AceID={Security.Encrypt(username)}&TeamRevd={Security.Encrypt(password)}&ActionTaken={Security.Encrypt(action_taken)}";

                int messageID = 0;
                int cpID = 0;
                string criteria_text = "";
                string sql_2 = "";
               

                using (SqlConnection connection = new SqlConnection(db_connection))
                {
                    connection.Open();

                    sql_2 = $"SELECT m.MessageID, m.CriteriaPackageID, cp.Criteria FROM [Messages] m JOIN TBLUSERS u1 ON m.FromUserID = u1.UserID JOIN TBLUSERS u2 ON M.ToUserID = u2.UserID JOIN ROLES S ON u1.RoleID = S.RoleID LEFT OUTER JOIN CriteriaPackage CP ON m.CriteriaPackageID = CP.Id JOIN Stages S2 ON U2.RoleID = S2.RoleId WHERE u2.CollegeID = {collegeid} and m.Articulations = '{articulations}' And m.tookaction = 1 AND (Criteria is not null) AND  (m.CriteriaPackageId <>0 OR m.CriteriaPackageId is not null) AND cast(M.Received as date) >= cast(dbo.ReturnPSTDate(GETDATE() - 0) as date)";
                    
                    using (SqlCommand command_2 = new SqlCommand(sql_2, connection))
                    {
                        SqlDataReader reader_2 = command_2.ExecuteReader();
                        if (reader_2.HasRows)
                        {
                            while (reader_2.Read())
                            {
                                messageID = (int)reader_2["MessageID"];
                                cpID = (int)reader_2["CriteriaPackageID"];
                                criteria_text = (string)reader_2["Criteria"];
                            }
                            
                        }
                        reader_2.Close();
                    }

                    //    sql_2 = $"select distinct aa.id, concat(s.subject, '-', c.course_number, ' ', course_title, ' ', u.unit, ' Unit(s)') 'Course', ISNULL(STUFF((SELECT ',' + Criteria FROM ACEExhibitCriteria a join Articulation b on a.CriteriaID = b.CriteriaID where b.id = aa.id FOR XML PATH('')), 1, 1, ''),'') CreditRecommendations, concat(aa.AceID, ' ', FORMAT(aa.TeamRevd, 'MM/dd/yyyy '), ' ', aa.Title) Exhibit from articulation aa join Course_IssuedForm c on aa.outline_id = c.outline_id join tblSubjects s on c.subject_id = s.subject_id join tblLookupUnits u on c.unit_id = u.unit_id where aa.id in ( select value from dbo.fn_Split('{articulations}',',') )";
                    string sql = $"select count(aa.id) as total, concat(s.subject, '-', c.course_number, ' ', course_title, ' ', u.unit, ' Unit(s)') 'Course', isnull((SELECT distinct Criteria FROM ACEExhibitCriteria a join Articulation b on a.CriteriaID = b.CriteriaID where b.id in (select value from dbo.fn_Split('{articulations}', ',') )), '') CreditRecommendations, concat('This credit recommendation occurs in <b><u>', count(aa.id), '</u></b> Exhibit(s) course(s)') Exhibit from articulation aa join Course_IssuedForm c on aa.outline_id = c.outline_id join tblSubjects s on c.subject_id = s.subject_id join tblLookupUnits u on c.unit_id = u.unit_id where aa.id in (select value from dbo.fn_Split('{articulations}', ',') ) group by s.subject, c.course_number, course_title, u.unit";


                    using (SqlCommand command = new SqlCommand(sql, connection))
                    {
                        SqlDataReader reader = command.ExecuteReader();
                        ArticulationList += $"<h3><b style='color:#000;'>{subject}</b></h3>";
                        while (reader.Read())
                        {

                            //ArticulationList += $"<label><b>{(string)reader["Course"]}</b></label>";
                            ArticulationList += "<table class='styled-table' width='90%'><tbody>";
                            //ArticulationList += $"<tr style='background-color:#F7F7F7;'><td width='20%' style='{style_cell}'><div style='display:flex;'><a class='btn' style='background-color:#76D7C4;{style_button}' href='{url}?Action=" + Security.Encrypt("Approve") + $"{url_parameters}'>Approve</a><a style='background-color:#F7DC6F;{style_button}' href='{url}?Action=" + Security.Encrypt("Return") + $"{url_parameters}'>Return</a><a style='background-color:#F5B7B1;{style_button}' href='{url}?Action=" + Security.Encrypt("Deny") + $"{url_parameters}'>Deny</a></div></td>";

                            if (tookaction)
                            {
                                string style_gray = "#B2B2B2";
                                ArticulationList += $"<tr style='background-color:#F7F7F7;'><td width='20%' style='{style_cell}'><div style='display:flex;'><a class='btn' style='background-color:#76D7C4;{style_button}' href='javascript:;'>Approve</a><a style='background-color:#F5B7B1;{style_button_grey}' href='javascript:;'>Deny</a></div></td>";
                            }
                            else
                            {
                                string style_gray = "#76D7C4";
                                ArticulationList += $"<tr style='background-color:#F7F7F7;'><td width='20%' style='{style_cell}'><div style='display:flex;'><a class='btn' style='background-color:{style_gray};{style_button}' href='{url}?Action=" + Security.Encrypt("Approve") + $"{url_parameters}'>Approve</a><a style='background-color:#F5B7B1;{style_button}' href='{url}?Action=" + Security.Encrypt("Deny") + $"{url_parameters}'>Deny</a></div></td>";
                            }

                            string urlhref = $"{host}/modules/Notifications/EmailAccess_o.aspx?Action=" + Security.Encrypt("ViewExhi") + $"&Criteria={criteria_text}&CriteriaPackageID={cpID}" + $"{url_parameters}";

                            string occur = (string)reader["Exhibit"];
                            string numLink = GetNumberLink(occur, urlhref);

                            ArticulationList += $"<td width='30%' style='color:#000;text-align:center;{style_cell}'>{(string)reader["CreditRecommendations"]}</td>";
                            ArticulationList += $"<td width='30%' style='color:#000;text-align:center;{style_cell}'>{numLink}</td>";
                            ArticulationList += $"<td width='10%' style='{style_cell}'><a href='{urlhref}' style='{style_button}'>View Exhibits</a></td>";
                            ArticulationList += $"<td width='10%' style='{style_cell}'><a href='{url}?Action=" + Security.Encrypt("View") + $"{url_parameters}' style='width:80px;{style_button}'>View Details</a></td>";
                            ArticulationList += $"<td width='10%' style='{style_cell}'><input type='text' name='txtMsgRecipient' style='font-size:12px;'></td></tr>";
                            ArticulationList += "</tbody></table>";


                        }
                    }
                }
                return ArticulationList;
            }
		public static string GetPackage(int criteria_package_id, int message_id, string action_taken, string username, string password, string subject, string db_connection, bool tookaction)
        {
            string CriteriaPackage = "";
            string style_button = "text-align:center;display:flex;color:#000;font-size:13px !important;margin:3px;padding:8px;text-decoration:none;font-weight:700;border-radius:5px;cursor:pointer;";
            string style_link = "text-align:center;display:flex;color:#203864;font-size:13px !important;margin:3px;padding:8px;text-decoration:underline;font-weight:700;border-radius:5px;cursor:pointer;";
                string style_button_grey = "text-align:center;display:flex;color:#f8f8f8;font-size:13px !important;margin:3px;padding:8px;text-decoration:none;font-weight:700;border-radius:5px;cursor:pointer;";
            string style_cell = "padding:5px; color:#000;";
            //string host = "http://localhost:49573";
                //string host = "https://maptrainingplatformv2.azurewebsites.net/";
                //string host = "https://militaryarticulationplatformweb.azurewebsites.net/";
                string host = GlobalUtil.GetDatabaseSetting("SiteName");

                //string url = $"{host}modules/Notifications/Confirm_o.aspx";
                string url = $"{host}/modules/Notifications/EmailAccess_o.aspx";
                //string url = $"{host}/modules/security/Login.aspx";

                //string url = $"{host}modules/popups/AssignOccupationArticulation.aspx";
                string url_parameters = $"&MessageID={Security.Encrypt(message_id.ToString())}&AceID={Security.Encrypt(username)}&TeamRevd={Security.Encrypt(password)}&ActionTaken={Security.Encrypt(action_taken)}";

                
                using (SqlConnection connection = new SqlConnection(db_connection))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("GetCriteriaPackage", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("CriteriaPackageID", criteria_package_id);
                SqlDataReader reader = command.ExecuteReader();
                //CriteriaPackage += $"<h3><b style='color:#000;'>{subject}</b></h3>";
                
                    while (reader.Read())
                    {
                        string encryptedCriteria = Security.Encrypt(reader.GetString(0));
                        //CriteriaPackage += $"<label><b>{(string)reader["Course"]}</b></label>";
                        CriteriaPackage += "<table class='styled-table' width='90%'><tbody>";
                        //CriteriaPackage += $"<tr style='background-color:#F7F7F7;'><td width='20%' style='{style_cell}'><div style='display:flex;'><a style='background-color:#76D7C4;{style_button}' href='{url}?Action=" + Security.Encrypt("Approve") + $"{url_parameters}'>Approve</a><a style='background-color:#F7DC6F;{style_button}' href='{url}?Action=" + Security.Encrypt("Return") + $"{url_parameters}'>Return</a><a style='background-color:#F5B7B1;{style_button}' href='{url}?Action=" + Security.Encrypt("Deny") + $"{url_parameters}'>Deny</a></div></td>";

                        if (tookaction)
                        {
                            string style_gray = "#B2B2B2";
                            CriteriaPackage += $"<tr style='background-color:#F7F7F7;'><td width='20%' style='{style_cell}'><div style='display:flex;'><a style='background-color:{style_gray};{style_button_grey}' href='javascript:;'>Approve</a><a style='background-color:{style_gray};{style_button_grey}' href='javascript:;'>Deny</a></div></td>";
                        }
                        else {
                            string style_gray = "#76D7C4";

                            CriteriaPackage += $"<tr style='background-color:#F7F7F7;'><td width='20%' style='{style_cell}'><div style='display:flex;'><a style='background-color:{style_gray};{style_button}' href='{url}?Action=" + Security.Encrypt("Approve") + $"&Criteria={encryptedCriteria}" + $"{url_parameters}'>Approve</a><a style='background-color:#F5B7B1;{style_button}' href='{url}?Action=" + Security.Encrypt("Deny") + $"&Criteria={encryptedCriteria}" + $"{url_parameters}'>Deny</a></div></td>";                        
                        }

                        CriteriaPackage += $"<td width='20%' style='{style_cell}'>{(string)reader["Course2"]}</td>";

                        string occur = (string)reader["Ocurrences"];
                        //string urlhref = $"{host}/modules/Notifications/Exhibits.aspx?Criteria={reader.GetString(0)}&CriteriaPackageID={criteria_package_id}";
                        string urlhref = $"{host}/modules/Notifications/EmailAccess_o.aspx?Action=" + Security.Encrypt("ViewExhi") + $"&Criteria={reader.GetString(0)}&CriteriaPackageID={criteria_package_id}" + $"{url_parameters}";
                        
                        //string numLink = GetNumberLink(occur, urlhref);
                        //CriteriaPackage += $"<td width='30%' style='{style_cell}'>{numLink}</td>";
                        
                        //CriteriaPackage += $"<td width='10%' style='{style_cell}'><a href='{host}modules/Notifications/Exhibits.aspx?Criteria={reader.GetString(0)}&CriteriaPackageID={criteria_package_id}' style='{style_link}'>View Exhibit</a></td>";

                        //CriteriaPackage += $"<td width='10%' style='{style_cell}'><a href='{urlhref}' style='{style_link}'>View Exhibit</a></td>";

                        //CriteriaPackage += $"<td width='10%' style='{style_cell}'><a href='{url}?Action=" + Security.Encrypt("View") + $"{url_parameters}' style='{style_link}'>View Details</a></td></tr>";

                        CriteriaPackage += $"<td width='10%' style='{style_cell}'><a href='{url}?Action=" + Security.Encrypt("View") + $"&Criteria={encryptedCriteria}" + $"{url_parameters}' style='{style_link}'>View Details</a></td>";
                        CriteriaPackage += $"<td width='10%' style='{style_cell}'><input type='text' name='txtMsgRecipient' style='font-size:12px;'></td></tr>";
                        
                        CriteriaPackage += "</tbody></table>";
					 
                    }
                    reader.Close();

                }
                return CriteriaPackage;
            }							   
        }
		class Exhibit
        {
            public static string GetTopExhibits(string criteria, string db_connection)
			{
                string sb = "";
                sb += $"<h1>{criteria}</h1>";
                string sql = $"select top(3) ae.ExhibitDisplay from (select distinct AceID, TeamRevd, StartDate, EndDate, Criteria from ACEExhibitCriteria) aec join ACEExhibit ae on aec.AceID = ae.AceID and aec.TeamRevd = ae.TeamRevd and aec.StartDate = ae.StartDate and aec.EndDate = ae.EndDate where trim(aec.Criteria) = trim('{criteria}') order by aec.EndDate desc";
                using (SqlConnection connection = new SqlConnection(db_connection))
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand(sql, connection);
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        sb += $"{(string)reader["ExhibitDisplay"]}";
                    }
                    reader.Close();
                }
                return sb;
            }
        }
        //class Report
        //{
        //    public static byte[] ToPDF(StringBuilder sb)
        //    {
        //        var style = new StyleSheet();
        //        style.LoadTagStyle("h1", "size", "13px");
        //        style.LoadTagStyle("h2", "size", "13px");
        //        style.LoadTagStyle("body", "size", "11px");
        //        style.LoadTagStyle("span", "size", "11px");
        //        style.LoadTagStyle("p", "size", "11px");
        //        StringReader sr = new StringReader(sb.ToString());
        //        Document pdfDoc = new Document(PageSize.A4, 30f, 30f, 30f, 30f);
        //        HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
        //        htmlparser.SetStyleSheet(style);
        //        using (MemoryStream memoryStream = new MemoryStream())
        //        {
        //            PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);
        //            pdfDoc.Open();

        //            htmlparser.Parse(sr);
        //            pdfDoc.Close();

        //            byte[] bytes = memoryStream.ToArray();
        //            memoryStream.Close();

        //            return bytes;
        //        }
        //    }
        //}

        class Security
        {
            public static string Encrypt(string clearText)
            {
                string EncryptionKey = "MAKV2SPBNI99212";
                byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
                using (Aes encryptor = Aes.Create())
                {
                    Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6E, 0x20, 0x4D, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                    encryptor.Key = pdb.GetBytes(32);
                    encryptor.IV = pdb.GetBytes(16);
                    using (MemoryStream ms = new MemoryStream())
                    {
                        using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                        {
                            cs.Write(clearBytes, 0, clearBytes.Length);
                            cs.Close();
                        }
                        clearText = System.Convert.ToBase64String(ms.ToArray());
                    }
                }
                return clearText;
            }
        }

    }
}
