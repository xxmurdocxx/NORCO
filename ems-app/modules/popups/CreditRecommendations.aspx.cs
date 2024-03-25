using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Office2010.Excel;
using ems_app.Controllers;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class CreditRecommendations : System.Web.UI.Page
    {
        NORCODataContext db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfSelectedCourse.Value = Session["SelectedCourse"].ToString();
                hfSelectedCriteria.Value = Session["SelectedCriteria"].ToString();
                hfAdvancedSarch.Value = Session["SelectedCriteria"].ToString();
                hfACECourseAdvancedSearch.Value = Session["SelectedCriteria"].ToString();
                //hfAceExhibitID.Value = Session["SelectedAceExhibitID"].ToString() ; //Added on 10/18/23 to use proper exhibit version number when highlighting in lightblue  ** PC **
                CheckCriteriaHaveArticulations();
                rlExclude.Text += string.Format(" {0} years.", GlobalUtil.ReadSetting("ExcludeArticulationOverYears"));
                hfExcludeArticulationOverYears.Value = "200";
                toggleCourse();
                // Added on 03-13-23 to check for null value (coming from student intake where value will always be a single cr)

                if (Session["CreditRecommendationsCount"] != null)  // not set when coming from SI

                {
                    if ((int)Session["CreditRecommendationsCount"] > 1)
                    {
                        rlSelectedCRiteria.Text = $"Credit Recommendations : {Session["SelectedCriteriaText"].ToString().Replace("|", Session["SelectedConditionText"].ToString())}";
                    } else
                    {
                        rlSelectedCRiteria.Text = $"Credit Recommendation : {Session["SelectedCriteriaText"].ToString()}";
                    }
                }
                else
                {
                    Session["CreditRecommendationCount"] = 1;
                    Session["SelectedCriteriaText"] = Session["SelectedCriteria"].ToString();
                    rlSelectedCRiteria.Text = $"Credit Recommendation : {Session["SelectedCriteriaText"].ToString()}";
                }

                //GridTableViewRow row = new GridTableViewRow();

                //RadGrid1.row.AddNewRow();

                // Establecer el contenido de las celdas de la fila
                //row.Cells.Add(new GridTableCell(""));
                //row.Cells.Add(new GridTableCell(""));
                //row.Cells.Add(new GridTableCell(""));

                //ChildGridDetails.InsertTableRow(row, 0);

                if (Request["AreaCredit"] != null)
                {
                    sqlCourses.SelectParameters["CourseType"].DefaultValue = "2";
                    sqlCourses.DataBind();
                    rcbCourses.Label = "Area Credit : ";
                    rcbCourses.EmptyMessage = "Select Area Credit...";
                    rcbCourses.DataBind();
                    pnlDisclaimer.Visible = true;
                }
            }
        }

        public void toggleCourse()
        {
            if (hfSelectedCourse.Value == "")
            {
                pnlSelectCourse.Visible = true;
                rcbCourses.SelectedValue = "";
            }
            else
            {
                pnlSelectCourse.Visible = false;
                rcbCourses.SelectedValue = hfSelectedCourse.Value;
            }
        }
        public void CheckCriteriaHaveArticulations()
        {
            //If criteria have articulations show message
            pnlCriteriaPackage.Visible = false;
            var criteriaHasArticulations = CheckCriteriaHasArticulations(hfSelectedCourse.Value, hfSelectedCriteria.Value);
            if (criteriaHasArticulations > 0)
            {
                pnlCriteriaPackage.Visible = true;
                ArticulationTitle.InnerHtml = string.Format("<strong>{0} Articulations</strong> between <strong>{1}</strong> and {2} already exists.", criteriaHasArticulations.ToString(), string.Join("", Session["SelectedCourseText"].ToString()), string.Join("|", Session["SelectedCriteriaText"].ToString()));
            }
            //If available articulations show message
            //DataView dv = (DataView)sqlCreditRecommendations.Select(DataSourceSelectArguments.Empty);
            //if (dv.Count > 0)
            //{
            //    ArticulationTitle.InnerHtml += " The ACE Courses/Occupations below have not been articulated. Make your selections in addition notes and supporting documentation can be attached (this is optional). Click finish when you are done.";
            //}
        }

        private void ResetForm()
        {
            rtbNotes.Text = "";
            tbSelectedItems.Text = "0";
        }

        private static int CheckCriteriaHasArticulations(string courses_list, string criteria_list)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckCriteriaHasArticulations] ('{0}','{1}');", courses_list, criteria_list);
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        private static int CheckArticulationExists(int outline_id, int exhibit_id, int criteria_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select [dbo].[CheckArticulationExist] ({outline_id},{exhibit_id},{criteria_id});";
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        private static int CheckArticulationCriteriaExists(int outline_id, string ace_id, DateTime team_revd, string criteria)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckArticulationCriteriaExist] ({0},'{1}','{2}','{3}');", outline_id, ace_id, team_revd, criteria);
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        protected void rbClear_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        public bool ValidateSelection() {
            bool isValid = true;
            if (rgCreditRecommendations.SelectedItems.Count > 0)
            {
                GridTableView CreditRecommendationTbl = rgCreditRecommendations.MasterTableView;
                foreach (GridDataItem crItem in CreditRecommendationTbl.Items)
                {
                    if (crItem.HasChildItems)
                    {
                        GridTableView ExhibitsTbl = crItem.ChildItem.NestedTableViews[0];
                        bool hasSelectedExhibit = false;

                        foreach (GridDataItem exhibitItem in ExhibitsTbl.Items)
                        {
                            if (exhibitItem.Selected)
                            {
                                hasSelectedExhibit = true;
                                break;
                            }
                        }

                        if (!hasSelectedExhibit)
                        {
                            isValid = false;
                            crItem.Selected = true;
                        }
                        else
                        {
                            crItem.Selected = false;
                        }
                    }
                }
            } else
            {
                isValid = false;
            }
            return isValid;
        }

        protected void rbFinish_Click(object sender, EventArgs e)
        {
            try
            {
                Dictionary<int, int> articulations = new Dictionary<int, int>();
                List<int> articulationList = new List<int>();
                
                var articulation_id = 0;
                var subject = "";
                var units = 0.0;
                var course_number = "";
                var course_title = "";
                int package_id = 0;
                int total_courses = 0;
                bool auto_adopt = false;
                var file_name = "";
                var file_description = "";
                byte[] bytes = null;
                var criteria_package_id = 0;
                var criteria = "";

                if (db.CheckIsDisabledForArticulate(Convert.ToInt32(hfSelectedCourse.Value)) == false)
                {
                    //Get additional course information
                    var course = db.GetCourseInformation(Convert.ToInt32(hfSelectedCourse.Value));
                    foreach (GetCourseInformationResult item in course)
                    {
                        subject = item.subject;
                        course_number = item.course_number;
                        units = Convert.ToDouble(item._Units);
                        course_title = item.course_title;
                    }
                    total_courses = GetTotalCoursesInDistrict(Convert.ToInt32(Session["CollegeID"]), subject, course_number);
                    if (rgCreditRecommendations.SelectedItems.Count > 0)
                    {
                        if (ValidateSelection())
                        {
                            //Create Criteria Package
                            package_id = Criteria.AddCriteriaPackage(hfSelectedCourse.Value, hfSelectedCriteria.Value, Convert.ToInt32(Session["UserID"]));
                            GridTableView CreditRecommendationTbl = rgCreditRecommendations.MasterTableView;
                            foreach (GridDataItem crItem in CreditRecommendationTbl.Items)
                            {
                                if (crItem.HasChildItems)
                                {
                                    RadComboBox combo = (RadComboBox)crItem.FindControl("rcbCondition");
                                    //Created selected criteria
                                    criteria_package_id = Criteria.AddCriteriaPackagereditRecommendation(package_id, crItem["Criteria"].Text, Convert.ToInt32(combo.SelectedValue), Convert.ToInt32(Session["UserID"]));
                                    GridTableView ExhibitsTbl = crItem.ChildItem.NestedTableViews[0];
                                    foreach (GridDataItem exhibitItem in ExhibitsTbl.Items)
                                    {
                                        if (exhibitItem.Selected)
                                        {
                                            var articulationExists = CheckArticulationExists(Convert.ToInt32(hfSelectedCourse.Value), Convert.ToInt32(exhibitItem["ExhibitID"].Text), Convert.ToInt32(exhibitItem["CriteriaID"].Text));
                                            if (articulationExists == 0)
                                            {
                                                if (Session["outline_id"] != null && Session["VeteranID"] != null)
                                                {
                                                    var id = Controllers.VeteranEligibleCredits.AddVeteranEligibleCredits(Convert.ToInt32(Session["VeteranID"]), Session["AceExhibitID"].ToString(), Convert.ToInt32(Session["UserID"].ToString()), Convert.ToInt32(hfSelectedCourse.Value),  Session["criteria"].ToString(), Convert.ToInt32(hfUnitsID.Value), 9, "");
                                                }
                                                articulation_id = Controllers.Articulation.AddNewArticulation(package_id, Convert.ToInt32(hfSelectedCourse.Value), exhibitItem["AceID"].Text, Convert.ToDateTime(exhibitItem["TeamRevd"].Text), exhibitItem["Title"].Text, rtbNotes.Text, "", "", "", Convert.ToInt32(exhibitItem["AceType"].Text), Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false, Convert.ToInt32(Request["SourceID"].ToString()), false, Convert.ToInt32(exhibitItem["ExhibitID"].Text), Convert.ToInt32(exhibitItem["CriteriaID"].Text), exhibitItem["Criteria"].Text, file_name, file_description, bytes, Convert.ToInt32(Session["RoleID"]));
                                                articulations.Add(articulation_id, 0);
                                                Controllers.Articulation.CreateArticulationLog(articulation_id, Convert.ToInt32(Session["UserID"]), $"Articulation Created by {Session["RoleName"]}");
                                                // Add articulation to Criteria Pckage
                                                Criteria.AddCriteriaPackageArticulation(package_id, articulation_id, Convert.ToInt32(Session["UserID"]), criteria_package_id);
                                            }
                                        }
                                    }
                                }
                            }
                            ResetForm();
                            rnMessage.Text = "<p>All articulations for these Credit Recommendations have been created.</p>";
                            if (CheckAutoAdoptArticulations(Convert.ToInt32(Session["CollegeID"])) && articulations != null && total_courses > 1)
                            {
                                auto_adopt = true;
                                rnMessage.Height = Unit.Pixel(200);
                                rnMessage.Text += "<p>The sisters colleges articulations have been updated accordingly.</p>";
                            }
                            rnMessage.Show();
                            Session["articulationList"] = articulations;
                            //todo: show course description fater package id
                            var selectedCondition = string.Empty;
                            if (Session["SelectedConditionText"] != null)
                            {
                                selectedCondition = Session["SelectedConditionText"].ToString();
                            }
                            NotifyPopup("CriteriaPackage", Convert.ToInt32(Session["UserStageID"]), Session["UserName"].ToString(), Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), 1000, 700, package_id, Session["SelectedCourseText"].ToString(), Session["SelectedCriteria"].ToString().Replace("|", $" {selectedCondition} "), auto_adopt, total_courses);
                            if (package_id != 0)
                            {
                                AutoAdoptCriteriaPackage(package_id);
                            }
                        }
                        else
                        {
                            rnMessage.Text = "Please select at least one Exhibit per Credit Recommendation";
                            rnMessage.Show();
                        }
                    } // End have selected rows
                    else
                    {
                        rnMessage.Text = "Please select at least one Exhibit";
                        rnMessage.Show();
                    }
                }

                //if (rgCreditRecommendations.SelectedItems.Count > 0)
                //{
                //    if (db.CheckIsDisabledForArticulate(Convert.ToInt32(hfSelectedCourse.Value)) == false)
                //    {
                //        //Create Criteria Package
                //        package_id = Criteria.AddCriteriaPackage(hfSelectedCourse.Value, hfSelectedCriteria.Value, Convert.ToInt32(Session["UserID"]));
                //        //Get additional course information
                //        var course = db.GetCourseInformation(Convert.ToInt32(hfSelectedCourse.Value));
                //        foreach (GetCourseInformationResult item in course)
                //        {
                //            subject = item.subject;
                //            course_number = item.course_number;
                //            units = Convert.ToDouble(item._Units);
                //            course_title = item.course_title;
                //        }
                //        total_courses = GetTotalCoursesInDistrict(Convert.ToInt32(Session["CollegeID"]), subject, course_number);
                //        foreach (GridDataItem item in rgCreditRecommendations.SelectedItems)
                //        {
                //            if (criteria != item["Criteria"].Text)
                //            {
                //                criteria = item["Criteria"].Text;
                //                //Created selected criteria
                //                criteria_package_id = Criteria.AddCriteriaPackagereditRecommendation(package_id, item["Criteria"].Text, Convert.ToInt32(item["Condition"].Text), Convert.ToInt32(Session["UserID"]));
                //            }
                //            var articulationExists = CheckArticulationExists(Convert.ToInt32(hfSelectedCourse.Value), Convert.ToInt32(item["ExhibitID"].Text), Convert.ToInt32(item["CriteriaID"].Text));
                //            if (articulationExists == 0)
                //            {
                //                articulation_id = Controllers.Articulation.AddNewArticulation(Convert.ToInt32(hfSelectedCourse.Value), item["AceID"].Text, Convert.ToDateTime(item["TeamRevd"].Text), item["Title"].Text, rtbNotes.Text, "", "", "", Convert.ToInt32(item["AceType"].Text), Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false, Convert.ToInt32(Request["SourceID"].ToString()), false, Convert.ToInt32(item["ExhibitID"].Text), Convert.ToInt32(item["CriteriaID"].Text), item["Criteria"].Text, file_name, file_description, bytes);
                //                articulations.Add(articulation_id, 0);

                //                // Add articulation to CRiteria Pckage
                //                Criteria.AddCriteriaPackageArticulation(package_id, articulation_id, Convert.ToInt32(Session["UserID"]), criteria_package_id);
                //            }
                //        }
                        
                //    }
                //    ResetForm();
                //    rnMessage.Text = "<p>All articulations for these Credit Recommendations have been created.</p>";
                //    if (CheckAutoAdoptArticulations(Convert.ToInt32(Session["CollegeID"])) && articulations != null && total_courses > 1)
                //    {
                //        auto_adopt = true;
                //        rnMessage.Height = Unit.Pixel(200);
                //        rnMessage.Text += "<p>The sisters colleges articulations have been updated accordingly.</p>";
                //    }                      
                //    rnMessage.Show();
                //    Session["articulationList"] = articulations;
                //    //todo: show course description fater package id
                //    NotifyPopup("CriteriaPackage", Convert.ToInt32(Session["UserStageID"]), Session["UserName"].ToString(), Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), 1000, 700, package_id, Session["SelectedCourseText"].ToString(), string.Join(",", hfSelectedCriteria.Value), auto_adopt, total_courses);
                //    //ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
                //}
                //else
                //{
                //    rnMessage.Text = "Please select at least one ACE Occupation/Course";
                //    rnMessage.Show();
                //}
                //if (package_id != 0)
                //{
                //    AutoAdoptCriteriaPackage(package_id);
                //}
            }
            catch (Exception x)
            {
                rnMessage.Text = x.Message;
                rnMessage.Show();
            }
        }

        public static void AutoAdoptCriteriaPackage(int package_id)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("AutoAdoptCriteriaPackage", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("PackageId", package_id);
            cmd.ExecuteReader();
            conn.Close();
        }

        public void NotifyPopup(string action, int user_stage_id, string user_name, int user_id, int college_id, int width, int height, int criteriaPackageID, string criteriaPackageCourses, string criteria, bool auto_adopt, int total_courses_district)
        {
            string url = $"/modules/popups/Notify.aspx?Action={action}&UserStageID={user_stage_id}&UserName={user_name}&UserID={user_id}&CollegeID={college_id}&CriteriaPackageID={criteriaPackageID}&CriteriaPackageCourses={criteriaPackageCourses}&Criteria={criteria}&AutoAdopt={auto_adopt}&TotalCoursesInDistrict={total_courses_district}&CreatePackage=true";
            if (Request["AreaCredit"] != null)
            {
                url += "&AreaCredit=true";
            }
                RadWindowManager2.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        public void AdoptPopup(string action, int user_stage_id, string user_name, int user_id, int college_id, int width, int height, int criteriaPackageID, string criteriaPackageCourses, string criteria)
        {
            string url = String.Format("/modules/popups/Notify.aspx?Action={0}&UserStageID={1}&UserName={2}&UserID={3}&CollegeID={4}&CriteriaPackageID={5}&CriteriaPackageCourses={6}&Criteria={7}", action, user_stage_id, user_name, user_id, college_id, criteriaPackageID, criteriaPackageCourses, criteria);
            RadWindowManager2.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        protected void rbClose_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
        }

        private int UploadDocuments(int articulation_id, int user_id)
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
                        using (SqlCommand comm = new SqlCommand("INSERT INTO [ArticulationDocuments] ([FileName], [FileDescription],  [BinaryData], [ArticulationID], [CreatedBy]) VALUES (@FileName, @FileDescription, @BinaryData, @ArticulationID, @UserID)", conn))
                        {
                            comm.Parameters.Add(new SqlParameter("FileName", file.GetName()));
                            comm.Parameters.Add(new SqlParameter("FileDescription", file.GetName()));
                            comm.Parameters.Add(new SqlParameter("BinaryData", bytes));
                            comm.Parameters.Add(new SqlParameter("ArticulationID", articulation_id));
                            comm.Parameters.Add(new SqlParameter("UserID", user_id));
                            conn.Open();
                            comm.ExecuteNonQuery();
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

        protected void rgCreditRecommendations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (Session["SelectedAceID"] != null || Session["SelectedAceExhibitID"] != null) 
            {
                List<string> aceIDs = new List<string>(Session["SelectedAceID"].ToString().Split(','));
                if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ChildGridDetails")
                {
                    GridDataItem item = e.Item as GridDataItem;
                    HyperLink hp = (HyperLink)item.FindControl("hlExhibit");
                    hp.NavigateUrl = $"javascript:showExhibitInfo('{item["ExhibitID"].Text}','{item["SelectedCriteria"].Text}')";
                    hp.Text = item["Title"].Text;
                    if (Session["SelectedAceExhibitID"] != null)
                    {
                        if (Session["SelectedAceExhibitID"].ToString() != String.Empty)
                        {
                            if (item["ExhibitID"].Text == Session["SelectedAceExhibitID"].ToString() && aceIDs.Count == 1) 
                            {
                                item.BackColor = System.Drawing.Color.LightSkyBlue;
                                item.Selected = true;
                                tbSelectedItems.Text = "1";
                                return;
                            }
                        }
                        else
                        {
                            if (Session["SelectedAceID"] != null)
                            {
                                foreach (var aceID in aceIDs)
                                {
                                    if (Request["AreaCredit"] != null)
                                    {
                                        if (item["AceID"].Text == aceID)
                                        {
                                            item.BackColor = System.Drawing.Color.LightSkyBlue;
                                            item.Selected = true;
                                            tbSelectedItems.Text = "1";
                                        }
                                        else
                                        {
                                            item.Display = false;
                                        }
                                    }
                                    else
                                    {
                                        if (item["AceID"].Text == aceID)
                                        {
                                            item.BackColor = System.Drawing.Color.LightSkyBlue;
                                            item.Selected = true;
                                            tbSelectedItems.Text = "1";
                                        }
                                    }

                                }
                            }
                        }
                    }
                   
                }
            }

        }
        public void EditCreditRecommendationPopup(string outline_id, string criteria, int width, int height)
        {
            string url = String.Format("/modules/popups/CriteriaPackage.aspx?outline_id={0}&criteria={1}", outline_id, criteria);
            RadWindowManager2.Windows.Clear();
            RadWindowManager2.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }
        protected void rbEditCriteriaPackage_Click(object sender, EventArgs e)
        {
            EditCreditRecommendationPopup(hfSelectedCourse.Value, hfSelectedCriteria.Value, 1000, 600);
        }

        public class Articulation
        {
            public string AceID { get; set; }
            public string Subject { get; set; }
            public string CourseNumber { get; set; }
            public DateTime TeamRevd { get; set; }
        }

        protected void rsExclude_CheckedChanged(object sender, EventArgs e)
        {
            if (rsExclude.Checked == true)
            {
                hfExcludeArticulationOverYears.Value = GlobalUtil.ReadSetting("ExcludeArticulationOverYears");
            }
            else
            {
                hfExcludeArticulationOverYears.Value = "200";
            }
        }

        protected void rcbCourses_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            hfSelectedCourse.Value = rcbCourses.SelectedValue;
            Session["SelectedCourseText"] = rcbCourses.SelectedItem.Text;

        }

        private bool CheckAutoAdoptArticulations(int college_id)
        {
            var adopt = false;
            try
            {

                var parameters = new SqlParameter[]
                {
                    new SqlParameter("@CollegeId", college_id)
                };
                var sql = "SELECT ISNULL(AutoAdoptArticulations, 0) AS AutoAdoptArticulations, ISNULL(AllowFacultyNotifications, 0) AS AllowFacultyNotifications FROM LookupColleges WHERE CollegeID = @CollegeId";
                var dt = GetDataTable(sql, CommandType.Text, parameters);
                if (dt.Rows.Count > 0)
                {
                    adopt = (bool)dt.Rows[0]["AutoAdoptArticulations"];
                }
            }
            catch (Exception ex)
            {
               
            }
            return adopt;
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

        protected void rgCreditRecommendations_PreRender(object sender, EventArgs e)
        {
            if (Request["AreaCredit"] != null)
            {
                rgCreditRecommendations.MasterTableView.GetColumn("Occurances").Visible = false;
                rgCreditRecommendations.Rebind();
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
        protected void rptCourseDetails_ItemDataBound(object sender, RepeaterItemEventArgs e)

        {
            if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                hfUnits.Value = drv.Row["_Units"].ToString();
                RadComboBox cbox = (RadComboBox)e.Item.FindControl("rbcUnits");
                cbox.DataBind();
                if (Session["outline_id"] == null)
                {
                    cbox.Enabled = false;
                }
                hfUnitsID.Value = cbox.SelectedValue;
            }
        }

        protected void rbcUnits_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            hfUnitsID.Value = e.Value;
        }
    }
}