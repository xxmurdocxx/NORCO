
using DocumentFormat.OpenXml.Drawing;
using DocumentFormat.OpenXml.Office2010.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.IO.Pipes;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.cpl
{
    public partial class Exhibits : System.Web.UI.Page
    {
        int fileId;
        byte[] fileData;
        string fileName;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState["NewAceID"] = "";
                hfCollegeID.Value = Session["CollegeID"].ToString();
                rcbCPLType.DataBind();
                rcbSourceCode.DataBind();
                rcbModelLearning.DataBind();
                if (Request["ID"] != null)
                {
                    hfExhibitID.Value = Request["ID"];
                    ShowExhibit(Request["ID"]);
                    if (Request["success"] != null)
                    {
                        rnLiteral.Text = $"CPL Exhibit {rtAceID.Text} Successfully saved.";
                        rnMessage.Show();
                    }
                    if (Request["ReadOnly"] != null)
                    {
                        if (Request["ReadOnly"] == "True")
                        {
                            showReadOnly();
                            if (hfCollegeID.Value != hfExhibitCollegeID.Value)
                            {
                                rcbCollaborative.Enabled = false;
                                rtCollaborativeNotes.Enabled = false;
                                rcbCPLType.Enabled = false;
                                rcbModelLearning.Enabled = false;
                                rcbStatus.Enabled = false;
                                rtbTeamRevd.Enabled = false;
                                rtUniformTitle.Enabled = false;
                                rtStartDate.Enabled = false;
                                rtEndDate.Enabled = false;
                                rtEstimatedHours.Enabled = false;
                                rtbNotes.Enabled = false;
                                rtbRevisedBy.Enabled = false;
                                rbUpdate.Enabled = false;
                                divUpload.Disabled = true;
                                AsyncUpload1.Enabled = false;
                                rtbNotes.BackColor = System.Drawing.Color.White;
                                rtbRevisedBy.BackColor = System.Drawing.Color.White;
                                rgRubricItems.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                                rgRubricItems.MasterTableView.GetColumn("DeleteColumn").Display = false;
                                rgRubricItems.MasterTableView.EditMode = GridEditMode.InPlace;
                                rgEvidenceCompetency.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                                rgEvidenceCompetency.MasterTableView.GetColumn("DeleteColumn").Display = false;
                                rgEvidenceCompetency.MasterTableView.EditMode = GridEditMode.InPlace;
                                rgCPLExhibitDocs.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                                rgCPLExhibitDocs.MasterTableView.GetColumn("DeleteColumn").Display = false;
                                rgCPLExhibitDocs.MasterTableView.EditMode = GridEditMode.InPlace;
                            }
                        }
                    }
                    if (Session["RoleName"].ToString() == "Ambassador" && hfCollegeID.Value == hfExhibitCollegeID.Value)
                    {
                        divCPLStatus.Style["display"] = "block";
                    }
                    if ( Convert.ToBoolean(Session["SuperUser"]) == true )
                    {
                        ShowSuperUser();
                    }
                }
                else
                {
                    pnlExhibit.Visible = false;
                    rtAceID.Visible = false;
                    rtVersion.Visible = false;
                    rtRevision.Visible = false;
                    NewExhibit();
                }
            }
        }

        private void showReadOnly()
        {
            rtArticulatedAt.BackColor = System.Drawing.Color.White;
            rtOrigin.BackColor = System.Drawing.Color.White;
            rtEstimatedHours.BackColor = System.Drawing.Color.White;
            rcbSourceCode.BackColor = System.Drawing.Color.White;
            rcbCPLType.BackColor = System.Drawing.Color.White;
            rcbModelLearning.BackColor = System.Drawing.Color.White;
            rtUniformTitle.BackColor = System.Drawing.Color.White;
            rtStartDate.DateInput.BackColor = System.Drawing.Color.White;
            rtEndDate.DateInput.BackColor = System.Drawing.Color.White;
            rtRevision.BackColor = System.Drawing.Color.White;
            rtVersion.BackColor = System.Drawing.Color.White;
            rtbTeamRevd.DateInput.BackColor = System.Drawing.Color.White;
            rtAceID.BackColor = System.Drawing.Color.White;
            rcbCourses.BackColor = System.Drawing.Color.White;
            rcbCollaborative.BackColor = System.Drawing.Color.White;
            rtCollaborativeNotes.BackColor = System.Drawing.Color.White;

            rcbSourceCode.Enabled = false;
            rcbCPLType.Enabled = false;
            rcbModelLearning.Enabled = false;
            rtbTeamRevd.Enabled = false;
            rtEstimatedHours.Enabled = false;
            rtStartDate.Enabled = false;
            rtEndDate.Enabled = false;
            rtAceID.Enabled = false;
            rbAddCourses.Enabled = false;
            rcbCourses.Enabled = false;
            rbClear.Enabled = false;
            rcbCollaborative.Enabled = false;
            rtCollaborativeNotes.Enabled = false;

            rgCreditRecommendations.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
            rgCreditRecommendations.MasterTableView.GetColumn("DeleteColumn").Display = false;
            rgCreditRecommendations.MasterTableView.EditMode = GridEditMode.InPlace;

            rgCreditRecommendations.MasterTableView.GetColumn("Notes").ItemStyle.BackColor = System.Drawing.Color.White;
            rgEvidenceCompetency.MasterTableView.GetColumn("Notes").ItemStyle.BackColor = System.Drawing.Color.LightYellow;
            rgEvidenceCompetency.MasterTableView.GetColumn("ExhibitEvidenceID").ItemStyle.BackColor = System.Drawing.Color.LightYellow;

            rgRubricItems.MasterTableView.GetColumn("Rubric").ItemStyle.BackColor = System.Drawing.Color.LightYellow;
            rgRubricItems.MasterTableView.GetColumn("ScoreRange").ItemStyle.BackColor = System.Drawing.Color.LightYellow;
            rgRubricItems.MasterTableView.GetColumn("MinScore").ItemStyle.BackColor = System.Drawing.Color.LightYellow;

        }

        private void ShowSuperUser()
        {
            rtEstimatedHours.BackColor = System.Drawing.Color.LightYellow;
            rcbCPLType.BackColor = System.Drawing.Color.LightYellow;
            rcbModelLearning.BackColor = System.Drawing.Color.LightYellow;
            rtUniformTitle.BackColor = System.Drawing.Color.LightYellow;
            rtStartDate.DateInput.BackColor = System.Drawing.Color.LightYellow;
            rtEndDate.DateInput.BackColor = System.Drawing.Color.LightYellow;
            rtbTeamRevd.DateInput.BackColor = System.Drawing.Color.LightYellow;
            rcbCourses.BackColor = System.Drawing.Color.LightYellow;
            rcbCollaborative.BackColor = System.Drawing.Color.LightYellow;
            rtCollaborativeNotes.BackColor = System.Drawing.Color.LightYellow;
            rcbStatus.BackColor = System.Drawing.Color.LightYellow;

            rcbCPLType.Enabled = true;
            rcbModelLearning.Enabled = true;
            rtbTeamRevd.Enabled = true;
            rtEstimatedHours.Enabled = true;
            rtStartDate.Enabled = true;
            rtUniformTitle.Enabled = true;
            rtEndDate.Enabled = true;
            rbAddCourses.Enabled = true;
            rcbCourses.Enabled = true;
            rbClear.Enabled = true;
            rcbCollaborative.Enabled = true;
            rtCollaborativeNotes.Enabled = true;
            divCPLStatus.Style["display"] = "block";
        }
        private void ShowExhibit(string id)
        {
            GetExhibit(id);
            pnlExhibit.Visible = true;
            rtEstimatedHours.Enabled = true;
            rtUniformTitle.Enabled = false;
            rtbNotes.Enabled = true;
            rtbRevisedBy.Enabled = true;
            rtVersion.Visible = true;
            rtAceID.Visible = true;
            rtVersion.Visible = true;
            rtRevision.Visible = true;
            rtbTeamRevd.Enabled = false;
            rtStartDate.Enabled = false;
            rtEndDate.Enabled = false;
            rcbCollaborative.Enabled = true;
            rtCollaborativeNotes.Enabled = true;
            rtStartDate.DateInput.BackColor = System.Drawing.Color.White;
            rtEndDate.DateInput.BackColor = System.Drawing.Color.White;
            rlExhibitID.Visible = false;
            var url = $"'../reports/CPLExhibits.aspx?ExhibitID={hfExhibitID.Value}&CollegeID={hfCollegeID.Value}'";
            btnPrintExhibit.OnClientClick = $"javascript:OpenPopupWindow({url},1000,600,false)";
            rbUpdate.CausesValidation = false;
            rbUpdate.ConfirmSettings.ConfirmText = "Are you sure you want to update the information for this Exhibit ?";
            rgCreditRecommendations.MasterTableView.GetColumn("Notes").ItemStyle.BackColor = System.Drawing.Color.LightYellow;
            divCPLStatus.Style["display"] = "none";
        }

        private void NewExhibit()
        {
            hfExhibitID.Value = "0";
            rcbSourceCode.SelectedValue = "4";
            rbUpdate.ConfirmSettings.ConfirmText = "Are you sure all the information for this Exhibit is correct?";
            hfUserID.Value = Session["UserID"].ToString();
            rtbTeamRevd.SelectedDate = DateTime.Now;
            rtStartDate.SelectedDate = DateTime.Now;
            rtEndDate.SelectedDate = null;
            rtVersion.Text = "1";
            rtRevision.Text = "001";
            btnPrintExhibit.Visible = false;
            rtEstimatedHours.BackColor = System.Drawing.Color.LightYellow;
            rcbSourceCode.BackColor = System.Drawing.Color.LightYellow;
            rcbCPLType.BackColor = System.Drawing.Color.LightYellow;
            rcbModelLearning.BackColor = System.Drawing.Color.LightYellow;
            rtUniformTitle.BackColor = System.Drawing.Color.LightYellow;
            rcbCollaborative.BackColor = System.Drawing.Color.LightYellow;
            rtCollaborativeNotes.BackColor = System.Drawing.Color.LightYellow;
            rtStartDate.DateInput.BackColor = System.Drawing.Color.LightYellow;
            rtEndDate.DateInput.BackColor = System.Drawing.Color.LightYellow;
            rtRevision.BackColor = System.Drawing.Color.LightYellow;
            rtVersion.BackColor = System.Drawing.Color.LightYellow;
            rtbTeamRevd.DateInput.BackColor = System.Drawing.Color.LightYellow;
            rtAceID.BackColor = System.Drawing.Color.LightYellow;
            rcbCourses.BackColor = System.Drawing.Color.LightYellow;
            rcbSourceCode.CssClass = "dropdownLightYellow";
            rcbCPLType.CssClass = "dropdownLightYellow";
            rcbModelLearning.CssClass = "dropdownLightYellow";
            rcbCollaborative.CssClass = "dropdownLightYellow";
            divCPLStatus.Style["display"] = "none";
        }

        public static DataTable GetCoursesCreditRecommendations(string courses)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetCoursesCreditRecommendations", conn);
                cmd.Parameters.Add("@Courses", SqlDbType.VarChar).Value = courses;
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

        protected void rbAddCourses_Click(object sender, EventArgs e)
        {
            List<string> courses = new List<string>();
            var collection = rcbCourses.CheckedItems;
            if (collection.Count != 0)
            {
                foreach (var item in collection)
                {
                    courses.Add(item.Value);
                }
            }
            DataTable course_list = GetCoursesCreditRecommendations(string.Join(",", courses));
            if (course_list != null)
            {
                if (course_list.Rows.Count > 0)
                {
                    foreach (DataRow row in course_list.Rows)
                    {
                        var result = AddCreditRecommendation(hfExhibitID.Value, row["outline_id"].ToString(), row["CourseDescription"].ToString(), "", hfUserID.Value);
                        if (result == 0)
                        {
                            rnLiteral.Text = "Credit Recommendation already exists.";
                        }
                        else
                        {
                            rnLiteral.Text = $"Credit Recommendation was added to exhibit {hfAceID.Value}.";
                        }
                        rnMessage.Show();
                    }
                }
            }
            rgCreditRecommendations.DataBind();
            ExhibitArticulations.RefreshData();
            ClearCourses();
        }

        public static int AddCreditRecommendation(string exhibit_id, string outline_id, string criteria, string notes, string created_by)
        {
            int id = 0;

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("AddCPLCreditRecommendation", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@ExhibitID", exhibit_id));
                    cmd.Parameters.Add(new SqlParameter("@OutlineID", outline_id));
                    cmd.Parameters.Add(new SqlParameter("@Criteria", criteria));
                    cmd.Parameters.Add(new SqlParameter("@Notes", notes));
                    cmd.Parameters.Add(new SqlParameter("@CreatedBy", created_by));
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);

                    cmd.ExecuteNonQuery();

                    id = Convert.ToInt32(outParm.Value);
                }
                return id;
            }
        }

        public static int DeleteCreditRecommendation(string criteria_id)
        {
            int id = 0;

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("DeleteCPLCreditRecommendation", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@CriteriaID", criteria_id));
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);

                    cmd.ExecuteNonQuery();

                    id = Convert.ToInt32(outParm.Value);
                }
                return id;
            }
        }

        protected void rbClear_Click(object sender, EventArgs e)
        {
            ClearCourses();
        }

        private void ClearCourses()
        {
            rcbCourses.ClearSelection();

            foreach (RadComboBoxItem item in rcbCourses.CheckedItems)
            {
                item.Checked = false;
            }

            rcbCourses.Focus();
        }

        private void GetExhibit(string id)
        {
            DataTable dtExhibit = GetCPLExhibit(id);
            if (dtExhibit != null)
            {
                if (dtExhibit.Rows.Count > 0)
                {
                    foreach (DataRow row in dtExhibit.Rows)
                    {
                        hfAceID.Value = row["AceID"].ToString();
                        ViewState["NewAceID"] = row["AceID"].ToString();
                        rtAceID.Text = row["AceID"].ToString();
                        rtOrigin.Text = row["College"].ToString();
                        rtUniformTitle.Text = row["Title"].ToString();
                        rtArticulatedAt.Text = row["ArticulatedAt"].ToString();
                        rtbNotes.Text = row["Notes"].ToString();
                        rtbRevisedBy.Text = row["RevisedBy"].ToString();
                        rcbStatus.SelectedValue = row["Status"].ToString();
                        rcbSourceCode.SelectedValue = row["SourceID"].ToString();
                        rcbCPLType.SelectedValue = row["CPLType"].ToString();
                        rcbModelLearning.SelectedValue = row["ModelOfLearning"].ToString();
                        rtbTeamRevd.SelectedDate = Convert.ToDateTime(row["TeamRevd"].ToString());
                        rtCollaborativeNotes.Text = row["CollaborativeNotes"].ToString();
                        rtStartDate.SelectedDate = Convert.ToDateTime(row["StartDate"].ToString());
                        if (row["EndDate"].ToString() != "")
                        {
                            rtEndDate.SelectedDate = Convert.ToDateTime(row["EndDate"].ToString());
                        }
                        rtEstimatedHours.Text = row["EstimatedUnits"].ToString();
                        rtVersion.Text = row["VersionNumber"].ToString();
                        rtRevision.Text = row["Revision"].ToString();
                        hfExhibitCollegeID.Value = row["CollegeID"].ToString();
                        if (row["ArticulatedAt"].ToString() != "0")
                        {
                            rcbCPLType.Enabled = false;
                            rcbModelLearning.Enabled = false;
                            rcbSourceCode.Enabled = false;
                        }
                        rtbLastUpdated.Text = row["LastUpdated"].ToString();
                        ExhibitArticulations.ExhibitID = Convert.ToInt32(id);
                        using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                        {
                            using (SqlCommand command = new SqlCommand("SELECT [CollaborativeID], [Value] FROM CPLExhibitCollaborative WHERE ExhibitID = '" + id + "'", connection))
                            {
                                SqlDataAdapter adapter = new SqlDataAdapter();
                                adapter.SelectCommand = command;
                                DataTable dt = new DataTable();
                                adapter.Fill(dt);
                                if (dt.Rows.Count > 0)
                                {
                                    rcbCollaborative.DataBind();
                                    foreach (RadComboBoxItem item in rcbCollaborative.Items)
                                    {
                                        if (dt.AsEnumerable().Any(x => x.Field<Int32>("CollaborativeID").ToString() == item.Value && x.Field<bool>("Value") == true))
                                        {
                                            item.Checked = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        private static DataTable GetCPLExhibit(string id)
        {
            DataTable dt = new DataTable();
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand($"SELECT E.*, dbo.CapitalizeWords(C.College) College, ( SELECT dbo.CapitalizeWords(STRING_AGG(ART.College, ', ')) FROM ( SELECT DISTINCT COL.College FROM VeteranACECourse A JOIN LookupColleges COL ON A.CollegeID = COL.CollegeID WHERE A.ExhibitID = E.ID ) ART) ArticulatedAt , (SELECT ISNULL(COUNT(*),0) FROM Articulation A JOIN LookupColleges COL ON A.CollegeID = COL.CollegeID WHERE A.ExhibitID = E.ID) ArticulationCount, CASE WHEN E.UpdatedBy IS NULL THEN CONCAT(U1.FirstName,' ', U1.LastName) ELSE CONCAT(U1.FirstName,' ', U1.LastName) END LastUpdated FROM [dbo].[ACEExhibit] E LEFT OUTER JOIN LookupColleges C ON E.CollegeID = C.CollegeID  LEFT OUTER JOIN TBLUSERS U1 ON E.CreatedBy = U1.UserID LEFT OUTER JOIN TBLUSERS U2 ON E.UpdatedBy = U2.UserID WHERE [id] = '{id}'", connection);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();
                try
                {
                    adapter.Fill(dt);
                }
                finally
                {
                    connection.Close();
                }
                return dt;

            }
        }

        public void Save()
        {
            int id = 0;

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("AddCPLExhibit", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@AceID", ViewState["NewAceID"].ToString() == "" ? null : ViewState["NewAceID"]));
                    cmd.Parameters.Add(new SqlParameter("@TeamRevd", rtbTeamRevd.SelectedDate.ToString() == "" ? null : rtbTeamRevd.SelectedDate.ToString()));
                    cmd.Parameters.Add(new SqlParameter("@StartDate", rtStartDate.SelectedDate.ToString() == "" ? null : rtStartDate.SelectedDate.ToString()));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", rtEndDate.SelectedDate.ToString() == "" ? null : rtEndDate.SelectedDate.ToString()));
                    cmd.Parameters.Add(new SqlParameter("@CPLType", rcbCPLType.SelectedValue == "" ? null : rcbCPLType.SelectedValue));
                    cmd.Parameters.Add(new SqlParameter("@ModelLearning", rcbModelLearning.SelectedValue == "" ? null : rcbModelLearning.SelectedValue));
                    cmd.Parameters.Add(new SqlParameter("@Title", rtUniformTitle.Text == "" ? null : rtUniformTitle.Text));
                    cmd.Parameters.Add(new SqlParameter("@VersionNumber", rtVersion.Text == "" ? null : rtVersion.Text));
                    cmd.Parameters.Add(new SqlParameter("@Revision", rtRevision.Text == "" ? null : rtRevision.Text));
                    cmd.Parameters.Add(new SqlParameter("@EstimatedUnits", rtEstimatedHours.Text == "" ? null : rtEstimatedHours.Text.Trim()));
                    cmd.Parameters.Add(new SqlParameter("@Notes", rtbNotes.Text == "" ? null : rtbNotes.Text));
                    cmd.Parameters.AddWithValue("@CreatedBy", hfUserID.Value);
                    cmd.Parameters.AddWithValue("@CollegeID", hfCollegeID.Value);
                    cmd.Parameters.AddWithValue("@SourceID", rcbSourceCode.SelectedValue == "" ? null : rcbSourceCode.SelectedValue);
                    cmd.Parameters.AddWithValue("@CollaborativeNotes", rtCollaborativeNotes.Text == "" ? null : rtCollaborativeNotes.Text);
                    cmd.Parameters.AddWithValue("@RevisedBy", rtbRevisedBy.Text == "" ? null : rtbRevisedBy.Text);
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);

                    cmd.ExecuteNonQuery();

                    id = Convert.ToInt32(outParm.Value);
                }
                hfExhibitID.Value = id.ToString();              
            }
        }

        private void UpdateCollaborative()
        {
            string ids = string.Empty;
            foreach (RadComboBoxItem item in rcbCollaborative.CheckedItems)
            {
                ids = ids + item.Value + ",";
            }
            if (ids.Length > 0)
            {
                ids = ids.Substring(0, ids.Length - 1);
            }
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("UpdateCPLCollaborative", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitID", hfExhibitID.Value);
                    cmd.Parameters.AddWithValue("@CollaborativeIDs", ids);
                    cmd.ExecuteNonQuery();
                }
            }
        }


        private int UpdateCPLExhibit()
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("UpdateCPLExhibit", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@ID", hfExhibitID.Value == "" ? null : hfExhibitID.Value));
                    if (ViewState["NewAceID"].ToString() == hfAceID.Value)
                    {
                        cmd.Parameters.Add(new SqlParameter("@AceID",  hfAceID.Value));
                    } else
                    {
                        cmd.Parameters.Add(new SqlParameter("@AceID", ViewState["NewAceID"]));
                    }                    
                    cmd.Parameters.Add(new SqlParameter("@TeamRevd", rtbTeamRevd.SelectedDate.ToString() == "" ? null : rtbTeamRevd.SelectedDate.ToString()));
                    cmd.Parameters.Add(new SqlParameter("@StartDate", rtStartDate.SelectedDate.ToString() == "" ? null : rtStartDate.SelectedDate.ToString()));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", rtEndDate.SelectedDate.ToString() == "" ? null : rtEndDate.SelectedDate.ToString()));
                    cmd.Parameters.Add(new SqlParameter("@CPLType", rcbCPLType.SelectedValue == "" ? null : rcbCPLType.SelectedValue));
                    cmd.Parameters.Add(new SqlParameter("@ModelLearning", rcbModelLearning.SelectedValue == "" ? null : rcbModelLearning.SelectedValue));
                    cmd.Parameters.Add(new SqlParameter("@Title", rtUniformTitle.Text == "" ? null : rtUniformTitle.Text));
                    cmd.Parameters.Add(new SqlParameter("@EstimatedUnits", rtEstimatedHours.Text == "" ? null : rtEstimatedHours.Text));
                    cmd.Parameters.Add(new SqlParameter("@Notes", rtbNotes.Text == "" ? null : rtbNotes.Text));
                    cmd.Parameters.AddWithValue("@UpdatedBy", hfUserID.Value);
                    cmd.Parameters.AddWithValue("@SourceID", rcbSourceCode.SelectedValue == "" ? null : rcbSourceCode.SelectedValue);
                    cmd.Parameters.AddWithValue("@CollaborativeNotes", rtCollaborativeNotes.Text == "" ? null : rtCollaborativeNotes.Text);
                    cmd.Parameters.AddWithValue("@CollegeID", hfCollegeID.Value);
                    cmd.Parameters.AddWithValue("@RevisedBy", rtbRevisedBy.Text == "" ? null : rtbRevisedBy.Text);
                    cmd.Parameters.AddWithValue("@Status", rcbStatus.SelectedValue == "" ? null : rcbStatus.SelectedValue);
                    var outParm = new SqlParameter("@Output", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);
                    cmd.ExecuteNonQuery();

                    return Convert.ToInt32(outParm.Value);
                }
            }
        }

        private void SaveChanges()
        {
            if (hfExhibitID.Value == "0")
            {
                GenerateExhibitID();
                Save();
                if (hfExhibitID.Value == "-1")
                {
                    rnLiteral.Text = $"MAP Exhibit {ViewState["NewAceID"]} already exists. Please adjust Type/Learning Mode or Exhibit Title.";
                    rnMessage.Show();
                }
                else
                {
                    UpdateCollaborative();
                    Response.Redirect($"Exhibits.aspx?ID={hfExhibitID.Value}&success=true");
                }
            }
            else
            {
                ViewState["ExhibitFound"] = UpdateCPLExhibit().ToString();
                UpdateCollaborative();
                if (ViewState["ExhibitFound"].ToString() == "0")
                {
                    rgCreditRecommendations.DataBind();
                    rgRubricItems.DataBind();
                    rgEvidenceCompetency.DataBind();
                    rnLiteral.Text = "CPL Exhibit Successfully Updated.";
                    rnMessage.Show();
                }
                else
                {
                    var url = $"Exhibits.aspx?ID={ViewState["ExhibitFound"]}";
                    rbViewExhibit.NavigateUrl = $"{url}&ReadOnly=True";
                    string script = "function f(){$find(\"" + rw_customConfirm.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                }
            }
        }
        protected void rbUpdate_Click(object sender, EventArgs e)
        {
            SaveChanges();
        }

        protected void rgCreditRecommendations_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            GetExhibit(hfExhibitID.Value);
        }


        protected void rgCPLExhibitDocs_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem viewItem = e.Item as GridDataItem;
            if (e.CommandName == "Delete")
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM [CPLExhibitDocuments] WHERE id = @id", conn);
                    conn.Open();
                    cmd.Parameters.AddWithValue("@id", viewItem["id"].Text);
                    try
                    {
                        if (conn.State == ConnectionState.Open)
                        {
                            conn.Close();
                        }
                        conn.Open();
                        cmd.ExecuteScalar();
                        rgCPLExhibitDocs.DataBind();
                        RadWindowManager1.RadAlert("Document deleted", 330, 180, "Delete document", null);
                    }
                    catch (Exception ex)
                    {
                        RadWindowManager1.RadAlert(ex.Message, 330, 180, "Alert", null);
                        Console.WriteLine(ex.Message);
                    }
                    conn.Close();
                }
            }
            if (e.CommandName == "Download")
            {
                var id = viewItem["id"].Text;
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", $"window.open('/modules/popups/ConfirmDownloadExhibit.aspx?ID={id}');", true);
            }
        }


        protected void btnComplete_Click(object sender, EventArgs e)
        {
            try
            {
                if (AsyncUpload1.UploadedFiles.Count > 0)
                {
                    foreach (UploadedFile uploadedFile in AsyncUpload1.UploadedFiles)
                    {
                        using (Stream stream = uploadedFile.InputStream)
                        {
                            byte[] fileBytes = new byte[stream.Length];
                            stream.Read(fileBytes, 0, Convert.ToInt32(stream.Length));

                            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                            {
                                SqlCommand cmd = new SqlCommand("INSERT INTO [CPLExhibitDocuments] ([FileName], [FileDescription],  [BinaryData], [CPLExhibitID], [CreatedBy]) VALUES (@FileName, @FileDescription, @BinaryData, @CPLExhibitID, @UserID)", conn);
                                conn.Open();
                                cmd.Parameters.AddWithValue("@FileName", uploadedFile.FileName.Replace(",", "_").Replace(";", "_"));
                                cmd.Parameters.AddWithValue("@FileDescription", uploadedFile.FileName.Replace(",", "_").Replace(";", "_"));
                                cmd.Parameters.Add("@BinaryData", SqlDbType.VarBinary, fileBytes.Length).Value = fileBytes;
                                cmd.Parameters.AddWithValue("@CPLExhibitID", hfExhibitID.Value);
                                cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                                try
                                {
                                    if (conn.State == ConnectionState.Open)
                                    {
                                        conn.Close();
                                    }
                                    conn.Open();
                                    int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());
                                    rgCPLExhibitDocs.DataBind();
                                    RadWindowManager1.RadAlert("Upload completed", 330, 180, "Upload document", null);
                                }
                                catch (Exception ex)
                                {
                                    RadWindowManager1.RadAlert(ex.Message, 330, 180, "Alert", null);
                                    Console.WriteLine(ex.Message);
                                }
                                conn.Close();
                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
        public static string GetModeofLearningCode(int id)
        {
            string result = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select ModeofLearningCode from CPLModeofLearning where id = {id};";
                    result = cmd.ExecuteScalar().ToString();
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }

        public static string GetCPLTypeCode(int id)
        {
            string result = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select CPLTypeCode from CPLType where id = {id};";
                    result = cmd.ExecuteScalar().ToString();
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }

        public static string GetSourceCode(int id)
        {
            string result = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select SourceCode from ACEExhibitSource where id = {id};";
                    result = cmd.ExecuteScalar().ToString();
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }

        public void CreateExhibitID(string initials, int version, bool createNewVersion)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select AceID, VersionNumber, Revision from  dbo.CreateCPLExhibitID('{initials}', {version}, {createNewVersion});";
                    // Execute the query and read the results
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            // Retrieve the values of the three columns
                            ViewState["NewAceID"] = reader.GetString(0);
                            ViewState["VersionNumber"] = reader.GetString(1);
                            ViewState["Revision"] = reader.GetString(2);
                        }
                    }
                }
                finally
                {
                    connection.Close();
                }
            }
        }

        protected void rgCreditRecommendations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem viewItem = e.Item as GridDataItem;
            if (e.CommandName == "Delete")
            {
                var id = viewItem["CriteriaID"].Text;
                var result = DeleteCreditRecommendation(id);
                if (result == 0)
                {
                    rnLiteral.Text = "There are articulations related to this Credit Recommendation.";
                }
                else
                {
                    rnLiteral.Text = $"Credit Recommendation successfully deleted.";
                }
                rnMessage.Show();
            }
            if (e.CommandName == "StudentIntake")
            {
                Session["SelectedCreditRecommendation"] = viewItem["Criteria"].Text;
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../military/StudentList.aspx") + "');", true);
            }
        }

        private void GenerateExhibitID ()
        {
            var result = rtUniformTitle.Text.Length > 0 ? rtUniformTitle.Text.Split(' ').Select(y => y[0]).ToList() : null;
            var title_code = "";
            if (result != null)
            {
                title_code = result.Count > 3 ? String.Join("", result).Substring(0, 4).ToUpper() : String.Join("", result).Substring(0, result.Count).ToUpper();
            }
            var source = rcbSourceCode.SelectedValue == "" ? "" : GetSourceCode(Convert.ToInt32(rcbSourceCode.SelectedValue)).ToUpper();
            var type = rcbCPLType.SelectedValue == "" ? "" : GetCPLTypeCode(Convert.ToInt32(rcbCPLType.SelectedValue)).ToUpper();
            var learning = rcbModelLearning.SelectedValue == "" ? "" : GetModeofLearningCode(Convert.ToInt32(rcbModelLearning.SelectedValue)).ToUpper();
            rlExhibitID.Text = $"{source}{type}{learning}-{title_code}-1-001";
            rtAceID.Text = $"{source}{type}{learning}-{title_code}-1-001";
            ViewState["NewAceID"] = $"{source}{type}{learning}-{title_code}-1-001";
        }
        protected void ExhibitID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            GenerateExhibitID();
        }

        protected void rtUniformTitle_TextChanged(object sender, EventArgs e)
        {
            GenerateExhibitID();
            SaveChanges();
        }

        

        public void showArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, int ExhibitID)
        {
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
        }

        private static int CreateCPLExhibitNewVersion(string exhibit_id, string user_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("CreateCPLExhibitNewVersion", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);
                    cmd.ExecuteNonQuery();

                    return Convert.ToInt32(outParm.Value);
                }
            }
        }

        private static int CreateCPLExhibitRevision(string exhibit_id, string user_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("CreateCPLExhibitRevision", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);
                    cmd.ExecuteNonQuery();

                    return Convert.ToInt32(outParm.Value);
                }
            }
        }

        protected void rbConfirmNewVersion_OK_Click(object sender, EventArgs e)
        {
            try
            {
                var id = CreateCPLExhibitNewVersion(ViewState["ExhibitFound"].ToString(), Session["UserID"].ToString());
                rnMessage.Title = "Exhibit New Version";
                if (id == 0)
                {
                    rnLiteral.Text = $"Exhibit already exists. Please adjust Type/Learning Mode or Exhibit Title.";
                }
                else
                {
                    rnLiteral.Text = $"A New Version for Exhibit {ViewState["NewAceID"]} successfully created.";
                    HyperLink lnkExhibit = new HyperLink();
                    lnkExhibit.Text = $"Click here to view New Version Exhibit";
                    lnkExhibit.NavigateUrl = $"Exhibits.aspx?ID={id}";
                    lnkExhibit.Target = "_blank";
                    rnMessage.ContentContainer.Controls.Add(lnkExhibit);
                }
                rnMessage.Show();
            }
            catch (Exception msg)
            {
                rnLiteral.Text = msg.Message;
                rnMessage.Title = "Error";
                rnMessage.Show();
            }
        }

        protected void rbConfirmRevision_OK_Click(object sender, EventArgs e)
        {
            try
            {
                var id = CreateCPLExhibitRevision(ViewState["ExhibitFound"].ToString(), Session["UserID"].ToString());
                rnMessage.Title = "Exhibit Revision";
                if (id == 0)
                {
                    rnLiteral.Text = $"Exhibit already exists. Please adjust Type/Learning Mode or Exhibit Title.";
                }
                else
                {
                    rnLiteral.Text = $"A revision for Exhibit {ViewState["NewAceID"]} successfully created.";
                    HyperLink lnkExhibit = new HyperLink();
                    lnkExhibit.Text = $"Click here to view revised Exhibit";
                    lnkExhibit.NavigateUrl = $"Exhibits.aspx?ID={id}";
                    lnkExhibit.Target = "_blank";
                    rnMessage.ContentContainer.Controls.Add(lnkExhibit);
                }
                rnMessage.Show();
            }
            catch (Exception msg)
            {
                rnLiteral.Text = msg.Message;
                rnMessage.Title = "Error";
                rnMessage.Show();
            }
        }
        protected void rgCreditRecommendations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                RadEditor txt = (RadEditor)item["Notes"].Controls[0];
                txt.Width = Unit.Pixel(500);
                txt.BackColor = System.Drawing.Color.LightYellow;
                txt.Attributes.Add("placeholder", "Enter any detail that might be used for this credit recommendation");
                TextBox criteria = (TextBox)item["Criteria"].Controls[0];
                criteria.Width = Unit.Pixel(500);
                criteria.BackColor = System.Drawing.Color.LightYellow;
            }
        }

        protected void rgEvidenceCompetency_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                TextBox txt = (TextBox)item["Notes"].Controls[0];
                txt.Width = Unit.Pixel(500);
                txt.Attributes.Add("placeholder", "Add notes here");
                txt.BackColor = System.Drawing.Color.LightYellow;
                RadComboBox combo = (RadComboBox)item["ExhibitEvidenceID"].Controls[0];
                combo.Width = Unit.Pixel(525);
                combo.BackColor = System.Drawing.Color.LightYellow;
                CheckBox check = (CheckBox)item["ActiveCurrent"].Controls[0];
                check.LabelAttributes.Add("background-color", "yellow");
                check.BackColor = System.Drawing.Color.LightYellow;
            }
        }

        protected void rgRubricItems_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                TextBox txt = (TextBox)item["Rubric"].Controls[0];
                txt.Width = Unit.Pixel(500);
                txt.BackColor = System.Drawing.Color.LightYellow;
                RadNumericTextBox score = (RadNumericTextBox)item["ScoreRange"].Controls[0];
                score.Width = Unit.Pixel(100);
                score.BackColor = System.Drawing.Color.LightYellow;
                RadNumericTextBox minScore = (RadNumericTextBox)item["MinScore"].Controls[0];
                minScore.Width = Unit.Pixel(100);
                minScore.BackColor = System.Drawing.Color.LightYellow;
            }
        }
    }
}