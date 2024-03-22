using ems_app.Model;
using ems_app.modules.settings;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ems_app.Controllers;
using DocumentFormat.OpenXml.Office2010.Excel;

namespace ems_app.modules.popups
{
    public partial class Notify : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    Dictionary<int, int> articulations = (Dictionary<int, int>)Session["articulationList"];
                    var articulation_list = string.Join(", ", articulations.Select(art => art.Key));
                    List<string> course_list = new List<string>();
                    var articulationStageID = 0;
                    foreach (var p in articulations)
                    {
                        var id = Convert.ToInt32(p.Key);
                        var outline_id = 0;
                        var articulation_type = 0;
                        var subject = "";
                        var course_number = "";
                        var course_title = "";
                        var articulation = norco_db.GetArticulationByID(id);
                        foreach (GetArticulationByIDResult item in articulation)
                        {
                            outline_id = item.outline_id;
                            articulation_type = Convert.ToInt32(item.ArticulationType);
                            var course_info = norco_db.GetCourseInformation(item.outline_id);
                            var type = articulation_type == 1 ? "Course" : "Occupation";
                            // ls - use the articulation stage to calculate the next and previous stage; using the user's stage was not working properly if the user was acting as an ambassador. This assumes all articulations in a package will be in the same stage.
                            articulationStageID = item.ArticulationStage ?? 0;
                            foreach (GetCourseInformationResult course in course_info)
                            {
                                subject = course.subject;
                                course_number = course.course_number;
                                course_title = course.course_title;
                                course_list.Add(string.Format("{0} {1}",subject, course_number));
                            }
                        }
                    }
                    sqlCriteria.SelectParameters["Articulations"].DefaultValue = articulation_list;
                    sqlCriteria.DataBind();
                    rcbCreditRecs.DataBind();
                    sqlArticulations.SelectParameters["Articulations"].DefaultValue = articulation_list;
                    sqlArticulations.DataBind();
                    rgArticulations.DataBind();

                    var user_id = Convert.ToInt32(Request.QueryString["UserID"].ToString());
                    var college_id = Convert.ToInt32(Request.QueryString["CollegeID"].ToString());
                    var user_stage_id = Convert.ToInt32(Request.QueryString["UserStageID"].ToString());
                    var criteria_list = Request.QueryString["Criteria"] != null ? Request.QueryString["Criteria"].ToString() : "";
                    var package_courses = Request.QueryString["CriteriaPackageCourses"] != null ? Request.QueryString["CriteriaPackageCourses"].ToString() : "";
                    var firstStage = norco_db.GetMinimumStageId(college_id);
                    if (articulationStageID == 0 || Request["CreatePackage"] != null)
                    {
                        articulationStageID = firstStage ?? 0;
                    }
                    //ls var previousStageID = Convert.ToInt32(norco_db.GetPreviousNextStageId(college_id, norco_db.GetStageIDByRoleId(college_id, Convert.ToInt32(Session["RoleID"])), -1));
                    var previousStageID = Convert.ToInt32(norco_db.GetPreviousNextStageId(college_id, articulationStageID, -1));
                    if (previousStageID == 0)
                    {
                        previousStageID = firstStage ?? 0;
                    }
                    //var nextStageID = Convert.ToInt32(norco_db.GetPreviousNextStageId(college_id, user_stage_id, 1));
                    //var nextStageID = Convert.ToInt32(norco_db.GetStageToBeNotified(college_id, user_stage_id));
                    //ls var nextStageID = Convert.ToInt32(norco_db.GetStageToBeNotified(college_id, norco_db.GetStageIDByRoleId(college_id, Convert.ToInt32(Session["RoleID"]))));
                    var nextStageID = Convert.ToInt32(norco_db.GetStageToBeNotified(college_id, articulationStageID));
                    var stageData = norco_db.GetStageDataByID(college_id, user_stage_id);
                    var minimum_stage_id = norco_db.GetMinimumStageId(college_id);
                    var action = Request.QueryString["Action"].ToString();
                    var courseListString = string.Join(" - ", course_list.Distinct());
                    // store some values for using when the user submits
                    ViewState["PreviousStageID"] = previousStageID;
                    ViewState["NextStageID"] = nextStageID;
                    ViewState["WaitingForApproval"] = false;
                    ViewState["DistrictWorkflow"] = false;
                    ViewState["DeniedMoveForward"] = false;
                    
                    foreach (var p in articulations)
                    {
                        var id = 0;
                        var totalCourses = 0;
                        var totalApproved = 0;
                        var stageID = 0;
                        var order = 0;
                        var totalDenied = 0;
                        id = Convert.ToInt32(p.Key);
                        DataTable dtArticulationWorkFlowStatus = GetArticulationWorkflowStatus(id);
                        if (dtArticulationWorkFlowStatus != null)
                        {
                            if (dtArticulationWorkFlowStatus.Rows.Count > 0)
                            {
                                foreach (DataRow row in dtArticulationWorkFlowStatus.Rows)
                                {
                                    totalApproved = row["TotalApproved"] != DBNull.Value ? Convert.ToInt32(row["TotalApproved"]) : 0;
                                    totalCourses = row["TotalCourses"] != DBNull.Value ? Convert.ToInt32(row["TotalCourses"]) : 0;
                                    order = row["Order"] != DBNull.Value ? Convert.ToInt32(row["Order"]) : 0;
                                    stageID = row["StageID"] != DBNull.Value ? Convert.ToInt32(row["StageID"]) : 0;
                                    totalDenied = row["TotalDenied"] != DBNull.Value ? Convert.ToInt32(row["TotalDenied"]) : 0;
                                }
                            }
                        }

                        // ls - when moving forward, approval has not happened yet, so we need to add one to the count for it to be accurate.  When package is first created, it starts as totalApproved = 1.
                        if (action == "MoveForward")
                        {
                            totalApproved += 1;
                        }
                        else if (action == "Denied")
                        {
                            totalDenied += 1;
                        }

                        //CAST(@actionCount AS FLOAT) / CAST(@articulationCount AS FLOAT) >= 0.5 AND @actionCount < @articulationCount
                        if (totalCourses > 1 && totalApproved < totalCourses && order == 1)
                        {
                            //if ( (totalApproved / totalCourses) >= 0.5 && totalApproved < totalCourses )
                            //{

                            //} else
                            //{
                            EvalutorWorkflow((int)stageID);
                            //}
                        }
                        
                        ViewState["NextOrder"] = order + 1;
                        if (totalCourses > 1)
                        {
                            ViewState["DistrictWorkflow"] = true;
                            if ((totalApproved + totalDenied) < totalCourses)
                            {
                                // we need to stay on the same stage until majority rule automatically approves, or if all colleges approve manually
                                nextStageID = Convert.ToInt32(norco_db.GetStageIDByRoleId(college_id, Convert.ToInt32(Session["RoleID"])));
                                ViewState["NextStageID"] = nextStageID;
                                if (action == "CriteriaPackage" && totalApproved > 1)
                                {
                                    // when the package is first created, we need to send the first notification; after that, we need to wait
                                    ViewState["WaitingForApproval"] = true;
                                    ViewState["NextOrder"] = order;
                                }
                                else if (action == "MoveForward" || action == "Denied")
                                {
                                    // we need to wait
                                    ViewState["WaitingForApproval"] = true;
                                    ViewState["NextOrder"] = order;
                                }
                            }
                        }
                        
                        if (action == "Denied")
                        {
                            if (!(bool)ViewState["WaitingForApproval"])
                            {
                                // if the majority denied, or it's a single college workflow, it needs to go back to the first stage
                                if (totalDenied > totalApproved || !(bool)ViewState["DistrictWorkflow"])
                                {
                                    ViewState["NextStageID"] = firstStage ?? 0;
                                    ViewState["NextOrder"] = 1;
                                }
                                else
                                {
                                    ViewState["DeniedMoveForward"] = true;
                                }
                            }
                            
                        }
                    }

                    if (Request["AutoAdopt"]=="True" &&  Convert.ToInt32(Request["TotalCoursesInDistrict"]) > 1)
                    {
                        EvalutorWorkflow((int)minimum_stage_id);
                    }
                    InitializeNotificationCheckboxes();
                    // Check if faculty is reviewing articulation then enable district faculty checkbox to notify them
                    //if (Session["reviewArticulations"].ToString() == "True")
                    //{
                    //    rchkDistrictFaculty.Enabled = true;
                    //    rchkDistrictEvaluators.Checked = true;
                    //    rlFacultyNotification.Visible = true;
                    //    rlFacultyNotification.Text = "* If this course is only offered at one college in the district, then approved or denied articulation will be sent to the college Articulation Officer; otherwise, a discipline faculty member from at least two of the colleges must review and approved (or deny) the proposed articulation. District Faculty reviewers will respond withing 15 working days and no response will indicate approval of submitted Articulation.";
                    //    rlFacultyNotification.CssClass = "alert alert-warning";
                    //}
                    if (course_list.Count == 1)
                    {
                        string myString = course_list[0].ToString();
                        char[] delimiterChars = { ' ' };
                        string[] course_items = myString.Split(delimiterChars);

                        string subject = course_items[0];
                        string course_number = course_items[1];

                        var totalCoursesDistrict = GetTotalCoursesInDistrict(college_id, subject, course_number);
                        hvTotalCoursesDistrict.Value = GetTotalCoursesInDistrict(college_id, subject, course_number).ToString();

                        if (Request["CreatePackage"] == null)
                        {
                            rchkDistrictEvaluators.Checked = false;
                        }
                        
                        if (totalCoursesDistrict == 1)
                        {
                            pnlCheckboxes.Style.Add("display", "none");
                        }
                        else
                        {
                            rchkDistrictFaculty.Style.Add("display", "none");
                        }
                    }
                    if (Request["Action"]== "Return")
                    {
                        rlStage.Text = norco_db.GetRoleNameByStageId(previousStageID);
                        rcbStages.SelectedValue = previousStageID.ToString();
                        rcbStages.DataBind();
                    }
                    if (Request["AreaCredit"] != null)
                    {
                        rlStage.Text = "";
                        var ao_stage_id = GetAOStageID(Convert.ToInt32(Session["CollegeID"]));
                        foreach (RadComboBoxItem item in rcbStages.Items)
                        {
                            item.Enabled = false;
                            if (item.Value == ao_stage_id.ToString())
                            {
                                item.Checked = true;
                            }
                        }
                    }
                    foreach (RadComboBoxItem item in rcbStages.Items)
                    {
                        if (item.Value == user_stage_id.ToString())
                        {
                            item.Enabled = false;
                        }
                        if (Request.QueryString["Action"].ToString() == "Denied")
                        {
                            if (item.Value == firstStage.ToString())
                            {
                                item.Checked = true;
                            }
                        }
                        else
                        {
                            if (Request.QueryString["Action"].ToString() == "Return")
                            {
                                if (item.Value == previousStageID.ToString())
                                {
                                    item.Checked = true;
                                }
                            }
                            else
                            if (item.Value == nextStageID.ToString())
                            {
                                item.Checked = true;
                            }
                        }
                    }
                    List<string> creditList = new List<string>();

                    GridTableView CreditRecommendationTbl = rgArticulations.MasterTableView;
                    foreach (GridDataItem crItem in CreditRecommendationTbl.Items)
                    {
                        creditList.Add(crItem["SelectedCriteria"].Text);
                    }

                    rtbNotes.EmptyMessage = "Notes added to this field are applied to each exhibit within the Articulation Package and viewable in the Articulation Details Screen.";
                    rtbSignature.EmptyMessage = "Electronic signature required, enter first and last name here";

                    reComments.Content = "Please review articulation package<br/>";
                    if (Request["Action"] == "CriteriaPackage")
                    {
                        reComments.Content += $"Course : {package_courses} <br>Credit Recommendation : {criteria_list}";
                    }
                    else
                    {
                        reComments.Content += $"Articulation Package - Course : {courseListString} - Credit Recommendation : {String.Join(",", creditList)}";
                    }

                    hvStageIDToNotify.Value = previousStageID.ToString();
                    switch (Request.QueryString["Action"].ToString())
                    {
                        case "Return":
                            headerAction.InnerText = "Thank you for returning these articulations. Please return to the previous stage approver and check recipients to notify.";
                            rtbSubject.Text = string.Format("Return articulation(s) {0}", courseListString);
                            pnlCheckboxes.Visible = false;
                            break;
                        case "Denied":
                            if ((bool)ViewState["WaitingForApproval"])
                            {
                                WaitingForApprovalDisplay();
                            }
                            else if ((bool)ViewState["DeniedMoveForward"])
                            {
                                rlStage.Text = norco_db.GetRoleNameByStageId(nextStageID);
                            }
                            else
                            {
                                rlStage.Text = norco_db.GetRoleNameByStageId(firstStage);
                            }
                            
                            if ((bool)ViewState["DeniedMoveForward"])
                            {
                                headerAction.InnerText = "The articulation package(s) was successfully denied, but will move forward to the next stage due to majority rule.";
                                rtbSubject.Text = $"REVIEW articulation package associated with course {courseListString}";
                            }
                            else
                            {
                                headerAction.InnerText = "The articulation package(s) was successfully denied. Please add notes or justifications for this choice/action.";
                                rtbSubject.Text = $"Articulation Package associated with course {courseListString} is DENIED";
                                //if (Request["Subject"] != null)
                                //{
                                //    rtbSubject.Text = $"DENIED {Request["Subject"]} ";
                                //}

                                if (Request["Action"] == "CriteriaPackage")
                                {
                                    reComments.Content = $"The Articulation Package has been DENIED - Course : {package_courses} - Credit Recommendation : {criteria_list}";
                                }
                                else
                                {
                                    reComments.Content = $"The Articulation Package has been DENIED - Course : {courseListString} - Credit Recommendation : {String.Join(",", creditList)}";
                                }
                            }
                            pnlCreditRecommendations.Visible = true;
                            break;
                        case "Archive":
                            headerAction.InnerText = "Thank you for archiving these articulations. Please add any related.";
                            rtbSubject.Text = string.Format("Archive articulation(s) {0}", courseListString);
                            break;
                        case "MoveForward":
                            if ((bool)ViewState["WaitingForApproval"])
                            {
                                WaitingForApprovalDisplay();
                            }
                            else
                            {
                                rlStage.Text = norco_db.GetRoleNameByStageId(nextStageID);
                            }
                            headerAction.InnerText = "Thank you for approving these articulations. Please forward to the next stage approver and check recipients to notify.";
                            hvStageIDToNotify.Value = nextStageID.ToString();
                            //if (Request["CriteriaPackageID"]!=null && Request["CriteriaPackageID"].ToString() != "0")
                            //{
                            //    rtbSubject.Text = GetMessageSubject(Convert.ToInt32(Request["CriteriaPackageID"]));
                            //} 
                            //else
                            //{
                            //    rtbSubject.Text = string.Format("Approve articulation(s) {0}", String.Join(" - ", course_list.Distinct()));
                            //}
                            rtbSubject.Text = $"REVIEW articulation package associated with course {courseListString}";
                            break;
                        case "Adopt":
                            headerAction.InnerText = "Thank you for adopting these articulations.";
                            rtbSubject.Text = string.Format("Adopt articulation(s) {0}", courseListString);
                            break;
                        case "Revise":
                            headerAction.InnerText = "Thank you for revising these articulations.";
                            rtbNotes.EmptyMessage = "Please add any notes or justifications for the revision.";
                            rtbSubject.Text = $"Revise { Request["Subject"] } ";
                            break;
                        case "CriteriaPackage":
                            if (Request["AreaCredit"] == null) { 
                                rlStage.Text = norco_db.GetRoleNameByStageId(nextStageID);
                                if (Request["CreatePackage"] != null && Convert.ToInt32(Request["TotalCoursesInDistrict"]) > 1)
                                    {
                                        rlStage.Text = "Evaluator";
                                    }                               
                                    labelNotes.Text = "Add notes to articulation package: ";
                                    headerAction.InnerText = "Thank you for creating these articulations. Please add any related notes and notify the next stage approver.";
                                    if (Request["AreaCredit"] != null)
                                    {
                                        rtbSubject.Text = $"REVIEW Area Credit: {courseListString}";
                                    } else
                                    {
                                        rtbSubject.Text = $"REVIEW Articulation Package associated with course {courseListString}";
                                    }
                            }
                            else if (Request["AreaCredit"] != null)
                            {
                                rlStage.Text = norco_db.GetRoleNameByStageId(GetAOStageID(Convert.ToInt32(Session["CollegeID"])));
                                
                                labelNotes.Text = "Add notes to articulation package: ";
                                headerAction.InnerText = "Thank you for creating these articulations. Please add any related notes and notify the next stage approver.";
                                if (Request["AreaCredit"] != null)
                                {
                                    rtbSubject.Text = $"REVIEW Area Credit: {courseListString}";
                                }
                                else
                                {
                                    rtbSubject.Text = $"REVIEW Articulation Package associated with course {courseListString}";
                                }
                            }
                            break;

                        default:
                            hvStageIDToNotify.Value = nextStageID.ToString();
                            break;
                    }
                    pnlCheckboxes.Visible = false;

                    //if (CheckCollegeBelongsDistrict(college_id) == 1)
                    //{
                    //    pnlCheckboxes.Visible = true;
                    //}
                    if (Request["Notes"] != null)
                    {
                        reComments.Content = Request["Notes"];
                    }

                    //if (GetArticulationsRoleID(articulation_list) != Convert.ToInt32(Session["RoleID"]) )
                    //{
                    //    rbSubmit.Enabled = false;
                    //    rnMessage.Text = "The selected articulation(s) do not belong to your assigned Role";
                    //    rnMessage.Show();
                    //}

                    if (norco_db.GetStageOrderByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])) > 1 )
                    {
                        divUploadDocument.Style["display"] = "none";
                    }

                    hvSubjectCC.Value = $"The Articulation Package associated with course {courseListString} is now in the { rlStage.Text } stage";
                }
                catch (Exception ex)
                {
                    DisplayMessage(true, ex.ToString());
                }

            }
        }

        public static int GetTotalCoursesInDistrict(int collegeId, string subject, string courseNumber)
        {
            const string connectionString = "NORCOConnectionString";
            int total = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings[connectionString].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = "select [dbo].[GetTotalCourseInDistrict] (@collegeId, @subject, @course_number);";
                    cmd.Parameters.AddWithValue("@CollegeID", collegeId);
                    cmd.Parameters.AddWithValue("@subject", subject);
                    cmd.Parameters.AddWithValue("@course_number", courseNumber);
                    total = (int)cmd.ExecuteScalar();
                }
                catch (SqlException ex)
                {
                    throw ex;
                }
            }
            return total;
        }

        public static int GetArticulationsRoleID(string articulations)
        {
            const string connectionString = "NORCOConnectionString";
            int roleID = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings[connectionString].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = "select [dbo].[GetArticulationsRoleID] (@articulations);";
                    cmd.Parameters.AddWithValue("@articulations", articulations);
                    roleID = (int)cmd.ExecuteScalar();
                }
                catch (SqlException ex)
                {
                    throw ex;
                }
            }
            return roleID;
        }

        public void EvalutorWorkflow(int stageID)
        {
            pnlRecipients.Visible = false;
            rchkDistrictEvaluators.Checked = true;
            rchkDistrictFaculty.Visible = false;
            //rcbStages.SelectedValue = minimum_stage_id.ToString();
            rcbStages.SelectedValue = stageID.ToString();
            //ls - rlStage.Text = "Evaluator";
        }
        

        private void InitializeNotificationCheckboxes()
        {
            try
            {
                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@CollegeId", (int)Session["CollegeId"])
                };
                var sql = "SELECT ISNULL(AutoAdoptArticulations, 0) AS AutoAdoptArticulations, ISNULL(AllowFacultyNotifications, 0) AS AllowFacultyNotifications FROM LookupColleges WHERE CollegeID = @CollegeId";
                var dt = GetDataTable(sql, CommandType.Text, parameters);
                if (dt.Rows.Count > 0)
                {
                    var checkedItems = rcbStages.CheckedItems;
                    if (checkedItems.Count != 0)
                    {
                    }
                    foreach (var item in checkedItems)
                    {
                        //if (item.Text == "Evaluator" && (bool)dt.Rows[0]["AutoAdoptArticulations"])
                        //{
                        //    rchkDistrictEvaluators.Checked = true;
                        //}
                        if (item.Text == "Faculty" && (bool)dt.Rows[0]["AllowFacultyNotifications"])
                        {
                            rchkDistrictFaculty.Checked = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
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

        private static int CheckCollegeBelongsDistrict(int college_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckCollegeBelongsDistrict] ({0});", college_id);
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        private static int GetAOStageID(int college_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select s.id from stages s where s.[Order] = 3 and s.CollegeID = {college_id};";
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        private static string GetMessageSubject(int criteria_package_id)
        {
            var subject = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select top 1 subject from Messages where CriteriaPackageId = {criteria_package_id} order by MessageID;";
                    subject = cmd.ExecuteScalar().ToString();
                }
                finally
                {
                    connection.Close();
                }
            }
            return subject;
        }

        private static int GetCriteriaPackageID(int id_articulaction) 
        {
            int cpi = 0;

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select ISNULL(MAX(CPA.PackageId), 0) from Articulation a inner join CriteriaPackageArticulation CPA ON a.id = CPA.ArticulationId WHERE a.id = {id_articulaction}";
                    cpi = (int)cmd.ExecuteScalar();
                }
                finally
                {
                    connection.Close();
                }
            }
            return cpi;
        }

        public string getNextPreviousStage(int college_id, int stage_id)
        {
            var stage_description = "";
            var stage = norco_db.GetStageDataByID(college_id, stage_id);
            foreach (GetStageDataByIDResult item in stage)
            {
                stage_description = item.RoleName;
            }
            return stage_description;
        }


        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rbSubmit_Click(object sender, EventArgs e)
        {
            try {
                var stage_notify = 0;
                var action = Request.QueryString["Action"];
                if (action == "Revise" && rcbCreditRecs.SelectedValue == "")
                {
                    DisplayMessage(true, "Please select a credit recommendation.");
                    return;
                }
                if (rtbSignature.Text == "")
                {
                    DisplayMessage(true, "Please add a signature.");
                    return;
                }
                var user = "";
                var user_id = Convert.ToInt32(Request.QueryString["UserID"].ToString());
                var college_id = Convert.ToInt32(Request.QueryString["CollegeID"].ToString());
                var user_stage_id = Convert.ToInt32(Request.QueryString["UserStageID"].ToString());
                var criteria_list = Request.QueryString["Criteria"] != null ? Request.QueryString["Criteria"].ToString() : "";
                //ls var previousStageID = Convert.ToInt32(norco_db.GetPreviousNextStageId(college_id, norco_db.GetStageIDByRoleId(college_id, Convert.ToInt32(Session["RoleID"])), -1));
                var previousStageID = (int)ViewState["PreviousStageID"];
                //var nextStageID = Convert.ToInt32(norco_db.GetPreviousNextStageId(college_id, user_stage_id, 1));
                var firstStage = norco_db.GetMinimumStageId(college_id);
                //var nextStageID = Convert.ToInt32(norco_db.GetStageToBeNotified(college_id, user_stage_id));
                // ls var nextStageID = Convert.ToInt32(norco_db.GetStageToBeNotified(college_id, norco_db.GetStageIDByRoleId(college_id, Convert.ToInt32(Session["RoleID"]))));
                var nextStageID = (int)ViewState["NextStageID"];
                var stageData = norco_db.GetStageDataByID(college_id, user_stage_id);
                var minimum_stage_id = norco_db.GetMinimumStageId(college_id);
                
                var message =  "";
                Dictionary<int,int> articulations = (Dictionary<int, int>)Session["articulationList"];
                var notify_articulation_list = string.Join(", ", articulations.Select(art => art.Key));

                var articulation_list = string.Join(", ", articulations.Select(art => art.Key));
                var from = GlobalUtil.ReadSetting("SystemNotificationEmail");
                var facultyReviewUrl = string.Format("{0}{1}", GlobalUtil.GetAppUrl(), GlobalUtil.ReadSetting("FacultyReviewUrl")); ;
                var selectedStages = "";
                var package_courses = Request.QueryString["CriteriaPackageCourses"] != null ? Request.QueryString["CriteriaPackageCourses"].ToString() : "";
                var package_criteria_id = Request.QueryString["CriteriaPackageID"] != null ? Request.QueryString["CriteriaPackageID"].ToString() : "0";

                if (articulations.Count == 1)
                {
                    foreach (var p in articulations)
                    {
                        var IdArt = Convert.ToInt32(p.Key);
                        package_criteria_id = GetCriteriaPackageID(IdArt).ToString();
                    }

                }
                else { }

                foreach (var p in articulations)
                {
                    var id = Convert.ToInt32(p.Key);
                    var other_college_id = Convert.ToInt32(p.Value);
                    var outline_id = 0;
                    var articulation_id = 0;
                    var articulation_type = 0;
                    var articulation_stage = 0;
                    var ace_id = "";
                    var team_revd = new DateTime();
                    var title = "";
                    var subject = "";
                    var course_number = "";
                    var course_title = "";
                    var type = articulation_type == 1 ? "Course" : "Occupation";
                    var occupation = "";
                    var credit_recommendation = "";
                    message = reComments.Content;

                    var articulation = norco_db.GetArticulationByID(id);
                    foreach (GetArticulationByIDResult item in articulation)
                    {
                        outline_id = item.outline_id;
                        articulation_id = item.ArticulationID;
                        articulation_type = Convert.ToInt32(item.ArticulationType);
                        articulation_stage = Convert.ToInt32(item.ArticulationStage);
                        ace_id = item.AceID;
                        team_revd = Convert.ToDateTime(item.TeamRevd);
                        title = item.Title;
                        occupation = item.Occupation;
                        credit_recommendation = item.Criteria;
                        var course_info = norco_db.GetCourseInformation(outline_id);
                        foreach (GetCourseInformationResult course in course_info)
                        {
                            subject = course.subject;
                            course_number = course.course_number;
                            course_title = course.course_title;
                        }
                    }
                    if (action == "CriteriaPackage")
                    {
                        stage_notify = nextStageID;
                        if (Request["CreatePackage"] == null)
                        {
                            Controllers.Articulation.ApprovalArticulationWorkflow(id, 1, user_id, "", Convert.ToInt32(Session["RoleID"]), false);
                        }
                        //GlobalUtil.SubmitArticulation(id, user_id, "", college_id, 0, outline_id, 1, articulation_id, articulation_type, ace_id, team_revd, title);
                        
                    }
                    switch (action)
                    {
                        case "MoveForward":
                            stage_notify = nextStageID;
                            //GlobalUtil.SubmitArticulation(id, user_id, "", college_id, 0, outline_id, 1, articulation_id, articulation_type, ace_id, team_revd, title);
                            //TODO : ONLY IF EXISTS IN MORE THAN ONE COLLEGE
                            //SharedCurriculumMessages(message, user_id, from, mailSubject, action, Convert.ToInt32(package_criteria_id), package_courses, rcbCreditRecs.SelectedValue == "" ? "" : rcbCreditRecs.SelectedValue, id);
                            Controllers.Articulation.UpdateArticulationNotes(id, rtbNotes.Text, rtbSignature.Text);
                            if (rtbSignature.Text != "")
                            {
                                Controllers.Articulation.ApprovalArticulationWorkflow(id, 1, user_id, rtbSignature.Text, Convert.ToInt32(Session["RoleID"]), false);
                            }
                            else {
                                Controllers.Articulation.ApprovalArticulationWorkflow(id, 1, user_id, "", Convert.ToInt32(Session["RoleID"]), false);
                            }
                            
                            break;
                        case "Return":
                            stage_notify = previousStageID;
                            //previousStageID = Convert.ToInt32(norco_db.GetPreviousNextStageId(college_id, articulation_stage, -1));
                            //GlobalUtil.SubmitArticulation(id, user_id, "", college_id, previousStageID, outline_id, -1, articulation_id, articulation_type, ace_id, team_revd, title);
                            Controllers.Articulation.ApprovalArticulationWorkflow(id, -1, user_id, "", Convert.ToInt32(Session["RoleID"]), false);
                            break;
                        case "Denied":
                            if ((bool)ViewState["DeniedMoveForward"])
                            {
                                stage_notify = nextStageID;
                            }
                            else
                            {
                                stage_notify = firstStage ?? 0;
                            }
                            //norco_db.DontArticulate(articulation_id, articulation_type, user_id);
                            user = $"{Session["RoleName"].ToString()} from {Session["College"].ToString()}";
                            if (rcbCreditRecs.SelectedItem != null)
                            {
                                message += $"</br></br>{user} has proposed the following Credit Recommendation : <strong>{rcbCreditRecs.SelectedItem.Text}</strong></br>";
                            }
                            //Controllers.Articulation.ApprovalArticulationWorkflow(id, 0, user_id, "");
                            //ls DenyArticulation(id, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["RoleID"]));
                            if (rtbSignature.Text != "")
                            {
                                Controllers.Articulation.ApprovalArticulationWorkflow(id, 0, user_id, rtbSignature.Text, Convert.ToInt32(Session["RoleID"]), (bool)ViewState["DeniedMoveForward"]);
                            }
                            else
                            {
                                Controllers.Articulation.ApprovalArticulationWorkflow(id, 0, user_id, "", Convert.ToInt32(Session["RoleID"]), (bool)ViewState["DeniedMoveForward"]);
                            }
                            //Controllers.Articulation.ApprovalArticulationWorkflow(id, 0, user_id, "", Convert.ToInt32(Session["RoleID"]), (bool)ViewState["DeniedMoveForward"]);
                            break;
                        case "Archive":
                            norco_db.ArchiveArticulation(articulation_id, articulation_type, user_id);
                            break;
                        case "Notify":
                            norco_db.FacultyReviewFlagToBeNotified(id);
                            break;
                        case "Adopt":
                            stage_notify = nextStageID;
                            //norco_db.CloneOtherCollegeArticulation(id, other_college_id, college_id, user_id, subject, course_number);
                            break;
                        case "Revise":
                            Controllers.Articulation.ApprovalArticulationWorkflow(id, 3, user_id, "", Convert.ToInt32(Session["RoleID"]), false);
                             user = $"{Session["RoleName"].ToString()} from {Session["College"].ToString()}";
                            message += $"</br></br>{user} has proposed the following Credit Recommendation : <strong>{rcbCreditRecs.SelectedItem.Text}</strong></br>";
                            break;
                        default:
                            break;
                    }
                    // Upload documents
                    UploadDocuments(id, user_id, Convert.ToInt32(Session["RoleID"]));
                    // Append message to articulation notes
                    if (action != "MoveForward"  ) {
                        if (Request["CreatePackage"] != null && hvTotalCoursesDistrict.Value == "1")
                        {
                            UpdateEvaluatorNotes(id, rtbNotes.Text);
                        }
                        else
                        {
                            Controllers.Articulation.UpdateArticulationNotes(id, rtbNotes.Text, rtbSignature.Text);
                        }                   
                    }
                    if (rtbNotes.Text != string.Empty)
                    {
                        Controllers.Articulation.CreateArticulationLog(id, user_id, $"Articulation Notes Added by {Session["FirstName"]} {Session["LastName"]} - {Session["College"]}");
                    }
                    /* SEND NOTIFICATIONS WHEN ADOPT ARTICULATIONS */
                    if (action=="Adopt")
                    {
                        /* CREATE PACKAGE */
                        var package_id = Criteria.AddCriteriaPackage(outline_id.ToString(), credit_recommendation, Convert.ToInt32(Session["UserID"]));
                        var criteria_package_id = Criteria.AddCriteriaPackagereditRecommendation(package_id,credit_recommendation, 1, Convert.ToInt32(Session["UserID"]));
                        Criteria.AddCriteriaPackageArticulation(package_id, id, Convert.ToInt32(Session["UserID"]), criteria_package_id);
                        /* CREATE PACKAGE */
                        System.Data.Linq.ISingleResult<FacultyReviewGetEmailsResult> reviewEmailsAdopt = null;
                        if (!(bool)ViewState["WaitingForApproval"])
                        {
                            if (action == "Denied" && !(bool)ViewState["DeniedMoveForward"])
                            {
                                if ((bool)ViewState["DistrictWorkflow"])
                                {
                                    reviewEmailsAdopt = norco_db.FacultyReviewGetEmails(id.ToString(), college_id, firstStage.ToString(), true, rchkIEDRCEvaluators.Checked, rchkDistrictFaculty.Checked, rchkIEDRCFaculty.Checked, false, false, true);
                                }
                                else
                                {
                                    reviewEmailsAdopt = norco_db.FacultyReviewGetEmails(id.ToString(), college_id, firstStage.ToString(), false, false, false, false, false, false, true);
                                }
                            }
                            else
                            {
                                var districtFaculty = false;
                                var districtArticulation = false;
                                if ((bool)ViewState["DistrictWorkflow"])
                                {
                                    switch ((int)ViewState["NextOrder"])
                                    {
                                        case 2: // faculty stage
                                            districtFaculty = true;
                                            break;
                                        case 3: // articulation officer stage
                                            districtArticulation = true;
                                            break;
                                    }
                                }
                                reviewEmailsAdopt = norco_db.FacultyReviewGetEmails(id.ToString(), college_id, stage_notify.ToString(), rchkDistrictEvaluators.Checked, rchkIEDRCEvaluators.Checked, districtFaculty, rchkIEDRCFaculty.Checked, districtArticulation, false, false);
                            }
                        }


                        if (reviewEmailsAdopt != null)
                        {
                            foreach (FacultyReviewGetEmailsResult item in reviewEmailsAdopt)
                            {
                                string mailSubject;
                                if ((bool)item.IsCC)
                                {
                                    mailSubject = hvSubjectCC.Value;
                                }
                                else
                                {
                                    mailSubject = rtbSubject.Text;
                                }
                                var messageAction = action;
                                if ((bool)ViewState["DeniedMoveForward"])
                                {
                                    messageAction = "MoveForward";
                                }
                                Message.SendMessage(message, Convert.ToInt32(Session["UserID"]), from, (int)item.userid, item.email, mailSubject, id.ToString(), messageAction, Convert.ToInt32(package_id), outline_id.ToString(), rcbCreditRecs.SelectedValue == "" ? "" : rcbCreditRecs.SelectedValue, Convert.ToInt32(Session["RoleID"]), item.ToRoleID ?? 0, item.IsCC);

                                //if (IsEmailNotifActive((int)Session["CollegeId"]))
                                //{
                                //    int emails = EmailProgram.Send_Email_Notif((int)Session["CollegeId"]);
                                //}
                                
                            }
                        }
                    }
                    /* SEND NOTIFICATIONS WHEN ADOPT ARTICULATIONS */
                }



                List<int> checkValues = new List<int>();
                foreach (RadComboBoxItem checkeditem in rcbStages.CheckedItems)
                {
                    checkValues.Add(Convert.ToInt32(checkeditem.Value)); 
                }
                selectedStages = String.Join(",", checkValues);

                if (action  == "Revise")
                {
                    AddProposedCRArticulations(articulation_list, rcbCreditRecs.SelectedValue);
                }

                System.Data.Linq.ISingleResult<FacultyReviewGetEmailsResult> reviewEmails = null;
                if (!(bool)ViewState["WaitingForApproval"])
                {
                    if (action == "Denied" && !(bool)ViewState["DeniedMoveForward"])
                    {
                        if ((bool)ViewState["DistrictWorkflow"])
                        {
                            reviewEmails = norco_db.FacultyReviewGetEmails(articulation_list, college_id, firstStage.ToString(), true, rchkIEDRCEvaluators.Checked, rchkDistrictFaculty.Checked, rchkIEDRCFaculty.Checked, false, false, true);
                        }
                        else
                        {
                            reviewEmails = norco_db.FacultyReviewGetEmails(articulation_list, college_id, firstStage.ToString(), false, false, false, false, false, false, true);
                        }
                    }
                    else
                    {
                        var districtFaculty = false;
                        var districtArticulation = false;
                        if ((bool)ViewState["DistrictWorkflow"])
                        {
                            switch ((int)ViewState["NextOrder"])
                            {
                                case 2: // faculty stage
                                    districtFaculty = true;
                                    break;
                                case 3: // articulation officer stage
                                    districtArticulation = true;
                                    break;
                            }
                        }
                        reviewEmails = norco_db.FacultyReviewGetEmails(articulation_list, college_id, stage_notify.ToString(), rchkDistrictEvaluators.Checked, rchkIEDRCEvaluators.Checked, districtFaculty, rchkIEDRCFaculty.Checked, districtArticulation, false, false);
                    }
                }
                    

                if (reviewEmails != null)
                {
                    foreach (FacultyReviewGetEmailsResult item in reviewEmails)
                    {
                        string mailSubject;
                        if ((bool)item.IsCC)
                        {
                            mailSubject = hvSubjectCC.Value;
                        }
                        else
                        {
                            mailSubject = rtbSubject.Text;
                        }
                        //GlobalUtil.SendEmail(mailSubject, message, from, item.email, from, true);
                        if (item.userid != Convert.ToInt32(Session["UserID"]))
                        {
                            if ((Request["AutoAdopt"] == "True" && Convert.ToInt32(Request["TotalCoursesInDistrict"]) > 1) || action == "Revise" || (bool)ViewState["DistrictWorkflow"])
                            {
                                notify_articulation_list = GetAutoAdoptedArticulationsList(articulation_list, (int)item.userid);
                            }
                            var messageAction = action;
                            if ((bool)ViewState["DeniedMoveForward"])
                            {
                                messageAction = "MoveForward";
                            }
                            if (action != "Adopt")
                            {
                                Message.SendMessage(message, Convert.ToInt32(Session["UserID"]), from, (int)item.userid, item.email, mailSubject, notify_articulation_list, messageAction, Convert.ToInt32(package_criteria_id), package_courses, rcbCreditRecs.SelectedValue == "" ? "" : rcbCreditRecs.SelectedValue, Convert.ToInt32(Session["RoleID"]), item.ToRoleID ?? 0, item.IsCC);
                            }
                        }
                        else
                        {
                            if(item.ToRoleID != Convert.ToInt32(Session["RoleID"]))
                                {
                                if ((Request["AutoAdopt"] == "True" && Convert.ToInt32(Request["TotalCoursesInDistrict"]) > 1) || action == "Revise" || (bool)ViewState["DistrictWorkflow"])
                                {
                                    notify_articulation_list = GetAutoAdoptedArticulationsList(articulation_list, (int)item.userid);
                                }
                                var messageAction = action;
                                if ((bool)ViewState["DeniedMoveForward"])
                                {
                                    messageAction = "MoveForward";
                                }
                                if (action!="Adopt")
                                {
                                    Message.SendMessage(message, Convert.ToInt32(Session["UserID"]), from, (int)item.userid, item.email, mailSubject, notify_articulation_list, messageAction, Convert.ToInt32(package_criteria_id), package_courses, rcbCreditRecs.SelectedValue == "" ? "" : rcbCreditRecs.SelectedValue, Convert.ToInt32(Session["RoleID"]), item.ToRoleID ?? 0, item.IsCC);
                                }
                            }
                        }
                    }
                }

                if (Request["MessageID"] != null)
                {
                    SetTookAction(Convert.ToInt32(Session["RoleID"]), Convert.ToInt32(Request["MessageID"]), null);
                }
                else
                {
                    SetTookAction(Convert.ToInt32(Session["RoleID"]), null, articulation_list);
                }

                if (IsEmailNotifActive((int)Session["CollegeId"]))
                {
                    int emails = EmailProgram.Send_Email_Notif((int)Session["CollegeId"]);
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }
        }

        private void SetTookAction(int selectedRoleID, int? message_id, string articulationList)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("SetTookAction", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SelectedRoleID", selectedRoleID);
                    cmd.Parameters.AddWithValue("@MessageID", message_id);
                    cmd.Parameters.AddWithValue("@ArticulationList", articulationList);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        
        

        private void SharedCurriculumMessages(string message, int from_user_id, string from_email, string email_subject, string email_action, int criteria_package_id, string criteria_package_courses, string proposed_cr, int articulation_id )
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("SharedCurriculumMessages", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Message", message);
                    cmd.Parameters.AddWithValue("@FromUserID", from_user_id);
                    cmd.Parameters.AddWithValue("@FromEmail", from_email);
                    cmd.Parameters.AddWithValue("@EmailSubject", email_subject);
                    cmd.Parameters.AddWithValue("@EmailAction", email_action);
                    cmd.Parameters.AddWithValue("@CriteriaPackageID", criteria_package_id);
                    cmd.Parameters.AddWithValue("@CriteriaPackageCourses", criteria_package_courses);
                    cmd.Parameters.AddWithValue("@ProposedCR", proposed_cr);
                    cmd.Parameters.AddWithValue("@ArticulationID", articulation_id);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private int UploadDocuments(int articulation_id, int user_id, int role_id)
        {
            var uploadResult = 0;
            foreach (UploadedFile file in AsyncUpload1.UploadedFiles)
            {
                byte[] bytes = new byte[file.ContentLength];
                file.InputStream.Read(bytes, 0, bytes.Length);
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                    {
                        conn.Open();
                        using (SqlCommand comm = new SqlCommand("UpdateDocuments", conn))
                        {
                            comm.CommandType = CommandType.StoredProcedure;
                            comm.Parameters.Add(new SqlParameter("FileName", file.GetName()));
                            comm.Parameters.Add(new SqlParameter("FileDescription", file.GetName()));
                            comm.Parameters.Add(new SqlParameter("BinaryData", bytes));
                            comm.Parameters.Add(new SqlParameter("ArticulationID", articulation_id));
                            comm.Parameters.Add(new SqlParameter("UserID", user_id));
                            comm.Parameters.Add(new SqlParameter("RoleID", role_id));
                            comm.ExecuteReader();
                        }
                    }
                    uploadResult = 1;
                }
                catch (Exception x)
                {
                    uploadResult = 0;
                }
            }
            return uploadResult;
        }
        private void UpdateArticulationNotes(int id, string notes)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UpdateArticulationNotes", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ArticulationID", id);
                    cmd.Parameters.AddWithValue("@Notes", notes);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void AddProposedCRArticulations(string list, string credit_recommendation)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddProposedCRArticulations", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@List", list);
                    cmd.Parameters.AddWithValue("@CreditRecommendation", credit_recommendation);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateEvaluatorNotes(int id, string notes)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE [dbo].[Articulation] SET [Notes] = @Notes WHERE Id = @Id", connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.Parameters.AddWithValue("@Notes", notes);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void DenyArticulation(int id, int user_id, int role_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("DenyArticulation", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ArticulationId", id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.Parameters.AddWithValue("@RoleID", role_id);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        public static string GetAutoAdoptedArticulationsList(string list, int user_id)
        {
            const string connectionString = "NORCOConnectionString";
            string total = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings[connectionString].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = "select [dbo].[GetAutoAdoptedArticulationsList] (@List, @UserID);";
                    cmd.Parameters.AddWithValue("@List", list);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    total = cmd.ExecuteScalar().ToString();
                }
                catch (SqlException ex)
                {
                    throw ex;
                }
            }
            return total;
        }
        public static DataTable GetArticulationWorkflowStatus(int id)
        {
            DataTable myDataTable = new DataTable();
            const string connectionString = "NORCOConnectionString";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings[connectionString].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = "SELECT * FROM [dbo].[fn_ArticulationWorkflowStatus](@id);";
                    cmd.Parameters.AddWithValue("@Id", id);
                    SqlDataAdapter adp = new SqlDataAdapter(cmd);
                    adp.Fill(myDataTable);
                }
                finally
                {
                    connection.Close();
                }
            }
            return myDataTable;
        }

        protected void rgArticulations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridGroupHeaderItem)
            {
                GridGroupHeaderItem groupHeader = (GridGroupHeaderItem)e.Item;
                {
                    groupHeader.DataCell.Text = groupHeader.DataCell.Text.Split(':')[1].ToString();
                }
            }
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                HyperLink hp = (HyperLink)item.FindControl("hlExhibit");
                hp.NavigateUrl = $"javascript:showExhibitInfo('{item["ExhibitID"].Text}','{item["SelectedCriteria"].Text}')";
                hp.Text = item["AceID"].Text;
            }
        }

        protected void rgArticulations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "EditNotes")
            {
                showAssignOccupationArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), false, Convert.ToInt32(itemDetail["ExhibitID"].Text));
            }
            
        }

        public void showAssignOccupationArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly, int ExhibitID)
        {
            if (isReadOnly)
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
            }
        }

        private void WaitingForApprovalDisplay()
        {
            rlStage.Text = "N/A - Waiting for Majority Approval";
            rlNotes.Visible = false;
            rtbSubject.Visible = false;
            reComments.Visible = false;
        }

        private bool IsEmailNotifActive(int collegid)
        {
            bool result = false;
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand($"SELECT ISNULL(AllowEmailNotificationTrigger, 0) AS AllowEmailNotificationTrigger from LookupColleges where CollegeID = {collegid}", connection);
                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        if ((bool)reader["AllowEmailNotificationTrigger"])
                        {
                            result = true;
                        }
                    }
                }
                reader.Close();
            }
            return result;
        }
    }
}