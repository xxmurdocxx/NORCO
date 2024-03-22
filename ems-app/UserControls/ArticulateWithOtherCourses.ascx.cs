using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.UserControls
{
    public partial class ArticulateWithOtherCourses : System.Web.UI.UserControl
    {
        NORCODataContext norco_db = new NORCODataContext();

        private int articulation_id = 0;
        private int articulation_type = 0;
        private string ace_id = "";
        private string team_revd = "";
        private int college_id = 0;
        private string title = "";
        private int outline_id = 0;
        private int user_id = 0;
        private int user_stage_id = 0;
        private string evaluator_notes = "";
        private string faculty_notes = "";
        private string articulation_officer_notes = "";

        public int ArticulationID
        {
            get { return articulation_id; }
            set { articulation_id = value; }
        }
        public int ArticulationType
        {
            get { return articulation_type; }
            set { articulation_type = value; }
        }
        public string AceID
        {
            get { return ace_id; }
            set { ace_id = value; }
        }
        public string TeamRevd
        {
            get { return team_revd; }
            set { team_revd = value; }
        }
        public string Title
        {
            get { return title; }
            set { title = value; }
        }
        public int OutlineID
        {
            get { return outline_id; }
            set { outline_id = value; }
        }
        public int CollegeID
        {
            get { return college_id; }
            set { college_id = value; }
        }
        public int UserID
        {
            get { return user_id; }
            set { user_id = value; }
        }
        public int UserStageID
        {
            get { return user_stage_id; }
            set { user_stage_id = value; }
        }
        public string EvaluatorNotes
        {
            get { return evaluator_notes; }
            set { evaluator_notes = value; }
        }
        public string FacultyNotes
        {
            get { return faculty_notes; }
            set { faculty_notes = value; }
        }
        public string ArticulationOfficerNotes
        {
            get { return articulation_officer_notes; }
            set { articulation_officer_notes = value; }
        }

        public bool SetEnabled
        {
            set { 
                rgCourseCatalog.Enabled = value;
                rgOtherCourses.Enabled = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfID.Value = ArticulationID.ToString();
                hfArticulationType.Value = ArticulationType.ToString();
                hfAceID.Value = AceID;
                hfTeamRevd.Value = TeamRevd;
                hfTitle.Value = Title;
                hfCollegeID.Value = CollegeID.ToString();
                hfUserID.Value = UserID.ToString();
                hfUserStageID.Value = UserStageID.ToString();
                hfEvaluatorNotes.Value = EvaluatorNotes;
                hfFacultyNotes.Value = FacultyNotes;
                hfArticulationOfficerNotes.Value = ArticulationOfficerNotes;

                sqlSubjects.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();

                ldsView_CoursesSearchResults.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                ldsView_CoursesSearchResults.SelectParameters["outline_id"].DefaultValue = OutlineID.ToString();
                ldsView_CoursesSearchResults.SelectParameters["AceID"].DefaultValue = AceID;
                ldsView_CoursesSearchResults.SelectParameters["TeamRevd"].DefaultValue = TeamRevd;

                sqlOtherCourses.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlOtherCourses.SelectParameters["outline_id"].DefaultValue = OutlineID.ToString();
                sqlOtherCourses.SelectParameters["AceID"].DefaultValue = AceID;
                sqlOtherCourses.SelectParameters["TeamRevd"].DefaultValue = TeamRevd;
            }
        }
        protected void rgOtherCourses_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.CommandName == "MoveForward")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessagesControl.DisplayMessage(false, "Select a course.");
                }
                else
                {
                    foreach (GridDataItem item in grid.SelectedItems)
                    {
                        GlobalUtil.SubmitArticulation(Convert.ToInt32(hfID.Value), Convert.ToInt32(hfUserID.Value), "", Convert.ToInt32(hfCollegeID.Value), 0, Convert.ToInt32(item["outline_id"].Text), 1, Convert.ToInt32(item["ArticulationID"].Text), Convert.ToInt32(item["ArticulationType"].Text), hfAceID.Value, Convert.ToDateTime(hfTeamRevd.Value), hfTitle.Value);
                    }
                    grid.DataBind();
                }
            }
            if (e.CommandName == "OtherCollegesArticulations")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessagesControl.DisplayMessage(false, Resources.Messages.SelectCourse);
                }
                else
                {
                    GridDataItem item = (GridDataItem)grid.MasterTableView.Items[grid.SelectedItems[0].ItemIndex];
                    string subject = item["subject"].Text;
                    string course_number = item["course_number"].Text;
                    string course_title = item["course_title"].Text;
                    var url = String.Format("~/modules/popups/OtherCollegesArticulations.aspx?subject={0}&course_number={1}&course_title={2}&college_id={3}", subject, course_number, course_title, Session["CollegeID"].ToString());

                    //ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + url + "');", true);
                    RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 1000, 600));
                }
            }
        }

        protected void rgCourseCatalog_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            var outline_id = 0;
            var haveOccupations = 0;
            if (e.CommandName == "Articulate")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessagesControl.DisplayMessage(false, "Select a course.");
                }
                else
                {
                    foreach (GridDataItem item in grid.SelectedItems)
                    {
                        outline_id = Convert.ToInt32(item["outline_id"].Text);
                        var existOtherColleges = norco_db.CheckArticulationExistOtherColleges(Convert.ToInt32(hfCollegeID.Value), item["subject"].Text, item["course_number"].Text, hfAceID.Value, Convert.ToDateTime(hfTeamRevd.Value));
                        if (existOtherColleges == true)
                        {
                            DisplayMessagesControl.DisplayMessage(false, "Articulation exist in other colleges, please contact Faculty");
                        }
                        else
                        {
                            haveOccupations = norco_db.CheckCollegeCourseHaveOccupations(outline_id, hfAceID.Value, Convert.ToDateTime(hfTeamRevd.Value), Convert.ToInt32(hfCollegeID.Value));
                            if (haveOccupations == 1)
                            {
                                DisplayMessagesControl.DisplayMessage(false, "Occupation already exist.");
                            }
                            else
                            {
                                var articulationId = 0;
                                articulationId = Controllers.Articulation.AddArticulation(outline_id, hfAceID.Value, Convert.ToDateTime(hfTeamRevd.Value), item["course_title"].Text, hfEvaluatorNotes.Value, hfFacultyNotes.Value, hfArticulationOfficerNotes.Value, "", Convert.ToInt32(hfArticulationType.Value), Convert.ToInt32(hfUserID.Value), Convert.ToInt32(hfCollegeID.Value), false,5,false,99999999);
                                //if Cross Listing courses exists
                                //var crossListing = norco_db.GetCrossListingCourses(outline_id);
                                //foreach (GetCrossListingCoursesResult cl in crossListing)
                                //{
                                //    var exist = norco_db.GetCrossListingNoArticulations(cl.outline_id, hfAceID.Value, Convert.ToDateTime(hfTeamRevd.Value), Convert.ToInt32(hfArticulationType.Value), Convert.ToInt32(hfCollegeID.Value));
                                //    if (exist == false)
                                //    {
                                //        Controllers.Articulation.AddArticulation(cl.outline_id, hfAceID.Value, Convert.ToDateTime(hfTeamRevd.Value), item["course_title"].Text, hfEvaluatorNotes.Value, hfFacultyNotes.Value, hfArticulationOfficerNotes.Value, "", Convert.ToInt32(hfArticulationType.Value), Convert.ToInt32(hfUserID.Value), Convert.ToInt32(hfCollegeID.Value), false);
                                //    }
                                //}
                            }
                        }
                    }
                    ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "ArticulationCreated();", true);
                    grid.DataBind();
                    rgOtherCourses.DataBind();
                }
            }

            if (e.CommandName == "OtherCollegesArticulations")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessagesControl.DisplayMessage(false, Resources.Messages.SelectCourse);
                }
                else
                {
                    GridDataItem item = (GridDataItem)grid.MasterTableView.Items[grid.SelectedItems[0].ItemIndex];
                    string subject = item["subject"].Text;
                    string course_number = item["course_number"].Text;
                    string course_title = item["course_title"].Text;
                    var url = String.Format("~/modules/popups/OtherCollegesArticulations.aspx?subject={0}&course_number={1}&course_title={2}&college_id={3}", subject, course_number, course_title, Session["CollegeID"].ToString());

                    //ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + url + "');", true);
                    RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 1000, 600));
                }
            }

        }


        protected void rgOtherCourses_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var courseArticulationStage = dataBoundItem["ArticulationStage"].Text;
                CheckBox checkbox1 = (CheckBox)dataBoundItem["ClientSelectColumn"].Controls[0];
                checkbox1.Enabled = true;
                if (courseArticulationStage != hfUserStageID.Value)
                {
                    checkbox1.Enabled = false;
                }
                var dont_articulate = dataBoundItem["Articulate"].Text;
                if (dont_articulate == "False")
                {
                    //dataBoundItem.BackColor = System.Drawing.Color.LightPink;
                    dataBoundItem.ForeColor = System.Drawing.Color.Black;
                }
                LinkButton btnOtherCollegeArticulations = e.Item.FindControl("btnOtherCollegeArticulations") as LinkButton;
                bool exist = Convert.ToBoolean(dataBoundItem["ExistInOtherColleges"].Text);
                btnOtherCollegeArticulations.Visible = false;
                if (exist)
                {
                    btnOtherCollegeArticulations.Visible = true;
                }
            }
        }

        protected void rgCourseCatalog_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                LinkButton btnOtherCollegeArticulations = e.Item.FindControl("btnOtherCollegeArticulations") as LinkButton;
                bool exist = Convert.ToBoolean(dataBoundItem["ExistInOtherColleges"].Text);
                btnOtherCollegeArticulations.Visible = false;
                if (exist)
                {
                    btnOtherCollegeArticulations.Visible = true;
                }
            }
        }
    }
}