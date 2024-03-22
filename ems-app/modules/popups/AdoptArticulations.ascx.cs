using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.UserControls
{
    public partial class AdoptArticulations : System.Web.UI.UserControl
    {
        NORCODataContext norco_db = new NORCODataContext();
        Dictionary<int, int> articulations = new Dictionary<int, int>();

        private string ace_id = "";
        private string team_revd = "";
        private int college_id = 0;
        private string course_number = "";
        private string subject = "";
        private bool by_course_subject = false;
        private bool by_ace_id = false;
        private bool exclude_adopted = false;
        private bool exclude_denied = false;
        private int exclude_years = 0;
        private int role_id = 0;
        private string user_name = "";
        private int user_id = 0;
        private bool only_implemented = false;
        private bool subjectcourse_cidnumber = false;
        public int RoleID
        {
            get { return role_id; }
            set { role_id = value; }
        }
        public int UserID
        {
            get { return user_id; }
            set { user_id = value; }
        }
        public string UserName
        {
            get { return user_name; }
            set { user_name = value; }
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
        public string CourseNumber
        {
            get { return course_number; }
            set { course_number = value; }
        }
        public string Subject
        {
            get { return subject; }
            set { subject = value; }
        }
        public int CollegeID
        {
            get { return college_id; }
            set { college_id = value; }
        }
        public bool ByCourseSubject
        {
            get { return by_course_subject; }
            set { by_course_subject = value; }
        }
        public bool ByACEID
        {
            get { return by_ace_id; }
            set { by_ace_id = value; }
        }
        public bool ExcludeAdopted
        {
            get { return exclude_adopted; }
            set { exclude_adopted = value; }
        }

        public bool ExcludeDenied
        {
            get { return exclude_denied; }
            set { exclude_denied = value; }
        }
        public int ExcludeArticulationOverYears
        {
            get { return exclude_years; }
            set { exclude_years = value; }
        }

        public bool OnlyImplemented
        {
            get { return only_implemented; }
            set { only_implemented = value; }
        }

        public bool BySubjectCourseCIDNumber
        {
            get { return subjectcourse_cidnumber; }
            set { subjectcourse_cidnumber = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                if (ExcludeAdopted)
                {
                    rchkExcludeAdopted.Checked = true;
                }
                if (ExcludeDenied)
                {
                    rchkExcludeDenied.Checked = true;
                }
                rchkOnlyImplemented.Checked = false;
                if (OnlyImplemented)
                {
                    rchkOnlyImplemented.Checked = true;
                }

                rchkSubjectCourseCIDNumber.Checked = false;               
                if (BySubjectCourseCIDNumber)
                {
                    rchkSubjectCourseCIDNumber.Checked = true;
                }
                ToggleCID((bool)rchkSubjectCourseCIDNumber.Checked);

                hfAceID.Value = AceID;
                hfTeamRevd.Value = TeamRevd;
                hfCourseNumber.Value = CourseNumber;
                hfSubject.Value = Subject;
                hfByCourseSubject.Value = ByCourseSubject.ToString();
                hfByACEID.Value = ByACEID.ToString();
                hfExcludeAdopted.Value = ExcludeAdopted.ToString();
                hfExcludeDenied.Value = ExcludeDenied.ToString();
                hfOnlyImplemented.Value = OnlyImplemented.ToString();
                hfBySubjectCourseCIDNumber.Value = BySubjectCourseCIDNumber.ToString();
                
                hfExcludeArticulationOverYears.Value = ExcludeArticulationOverYears.ToString();

                sqlSubjects.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();

                hvUserStage.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(CollegeID), Convert.ToInt32(RoleID)).ToString(); ;
                hvUserName.Value = UserName;
                hvUserID.Value = UserID.ToString();
                hvCollegeID.Value = CollegeID.ToString();
                hvFirstStage.Value = norco_db.GetMinimumStageId(Convert.ToInt32(CollegeID)).ToString();

                setDataSource();
            }
        }

        private void ToggleCID(bool toggle)
        {
            rgOtherCollegeArticulations.MasterTableView.Columns.FindByUniqueName("CIDNumber").Display = toggle;
            rgOtherCollegeArticulations.MasterTableView.Columns.FindByUniqueName("Descriptor").Display = toggle;
            rgOtherCollegeArticulations.MasterTableView.Columns.FindByUniqueName("CourseCollege").Display = toggle;
        }

        protected void rgOtherCollegeArticulations_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "View" || e.CommandName == "ViewDocuments" || e.CommandName == "Adopt")
                {
                    ExecuteCommands(e.CommandName);
                }
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.ToString());
            }
        }

        protected void rgOtherCollegeArticulations_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridGroupHeaderItem)
            {
                GridGroupHeaderItem groupHeader = (GridGroupHeaderItem)e.Item;
                {
                    groupHeader.DataCell.Text = groupHeader.DataCell.Text.Split(':')[1].ToString();
                }
            }
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ParentGrid" && grid.ID == "rgOtherCollegeArticulations")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                Label lblLegend = e.Item.FindControl("lblLegend") as Label;
                lblLegend.BackColor = System.Drawing.Color.LightGreen;
                lblLegend.ToolTip = "Articulation(s) ready to adopt";
                var adopted = dataBoundItem["adopted"].Text;
                if (adopted == "True")
                {
                    CheckBox chkbx = (CheckBox)dataBoundItem["ClientSelectColumn"].Controls[0];
                    chkbx.Enabled = false;
                    lblLegend.BackColor = System.Drawing.Color.LightBlue;
                    lblLegend.ToolTip = "Articulation(s) already exists";
                }
                int documents = Convert.ToInt32(dataBoundItem["Document"].Text);
                LinkButton btnDocument = e.Item.FindControl("btnDocuments") as LinkButton;
                if (documents != 0)
                {
                    btnDocument.Visible = true;
                }
                var dont_articulate = dataBoundItem["Articulate"].Text;
                if (dont_articulate == "False")
                {
                    lblLegend.BackColor = System.Drawing.Color.LightPink;
                    lblLegend.ToolTip = "Denied Articulation(s)";
                }
            }

        }

        public void ConfirmAdopt(string articulation_list, int user_id, int college_id, int width, int height)
        {
            var url = String.Format("/modules/popups/ConfirmAdoptArticulation.aspx?ArticulationList={0}&UserID={1}&CollegeID={2}", articulation_list, user_id, college_id, width, height);
            RadWindowManagerAdp.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        protected void rcmAdoptArticulations_ItemClick(object sender, RadMenuEventArgs e)
        {
            try
            {
                ExecuteCommands(e.Item.Value);
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.ToString());
            }

        }

        public void ExecuteCommands(string command)
        {
            var user_stage_id = Convert.ToInt32(hvUserStage.Value);
            var user_name = hvUserName.Value;
            var user_id = Convert.ToInt32(hvUserID.Value);
            var college_id = Convert.ToInt32(hvCollegeID.Value);
            var firstStage = Convert.ToInt32(hvFirstStage.Value);

            try
            {
                if (rgOtherCollegeArticulations.SelectedItems.Count <= 0)
                {
                    DisplayMessagesControl.DisplayMessage(false, "Select an Articulation.");
                }
                else
                {
                    if (rgOtherCollegeArticulations.SelectedItems.Count > 1)
                    {
                        foreach (GridDataItem item in rgOtherCollegeArticulations.SelectedItems)
                        {
                            switch (command)
                            {
                                case "Adopt":
                                    articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                                    break;
                                case "View":
                                    DisplayMessagesControl.DisplayMessage(false, "You can review only one articulation");
                                    break;
                                case "ViewDocuments":
                                    DisplayMessagesControl.DisplayMessage(false, "You can review only one articulation");
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                    else
                    {
                        foreach (GridDataItem item in rgOtherCollegeArticulations.SelectedItems)
                        {
                            switch (command)
                            {
                                case "Adopt":
                                    articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                                    break;
                                case "View":
                                    showArticulation(Convert.ToInt32(item["id"].Text), Convert.ToInt32(item["ArticulationType"].Text), Convert.ToInt32(item["outline_id"].Text), item["AceID"].Text, item["Title"].Text, Convert.ToDateTime(item["TeamRevd"].Text), true, Convert.ToInt32(item["CollegeID"].Text), true, item["College"].Text, "NewTab", 0, 0, Convert.ToInt32(item["ExhibitID"].Text));
                                    break;
                                case "ViewDocuments":
                                    var url = String.Format("~/modules/popups/ArticulationDocuments.aspx?id={0}&ReadOnly=true", item["id"].Text);
                                    RadWindowManagerAdopt.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 900, 500));
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                    if (command == "Adopt")
                    {
                        ConfirmAdopt(string.Join(", ", articulations.Select(art => art.Key)), user_id, college_id, 800, 500);
                        rgOtherCollegeArticulations.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.ToString());
            }
        }

        public void showArticulation(int id, int articulation_type, int outline_id, string AceID, string Title, DateTime TeamRevd, bool isReadOnly, int otherCollegeID, bool adoptArticulation, string collegeName, string modalWindow, int width, int height, int ExhibitID)
        {
            var urlPage = "../popups/AssignOccupationArticulation.aspx";
            var readOnlyParameter = "";
            if (isReadOnly)
            {
                readOnlyParameter = "&isReadOnly=true";
            }
            if (modalWindow.Equals("NewTab"))
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("{0}?articulationID={1}&outline_id={2}&AceID={3}&Title={4}&TeamRevd={5}&NewWindow={6}&OtherCollegeID={7}&AdoptArticulation={8}&CollegeName={9}&ExhibitID={10}", urlPage, id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), readOnlyParameter, otherCollegeID.ToString(), isReadOnly, collegeName.ToString(), ExhibitID) + "');", true);
            }
            else
            if (modalWindow.Equals("Popup"))
            {
                var url = String.Format("{0}?articulationID={1}&outline_id={2}&AceID={3}&Title={4}&TeamRevd={5}&NewWindow={6}&OtherCollegeID={7}&AdoptArticulation=true&CollegeName={8}&ExhibitID={9}&ExhibitID={10}", urlPage, id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), readOnlyParameter, otherCollegeID.ToString(), collegeName.ToString(), ExhibitID);
                /*RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, width, height));*/
            }
        }

        private void setDataSource()
        {
            sqlOtherCollegeArticulations.SelectParameters["AceID"].DefaultValue = hfAceID.Value;
            sqlOtherCollegeArticulations.SelectParameters["AceID"].ConvertEmptyStringToNull = false;
            sqlOtherCollegeArticulations.SelectParameters["TeamRevd"].DefaultValue = hfTeamRevd.Value;
            sqlOtherCollegeArticulations.SelectParameters["TeamRevd"].ConvertEmptyStringToNull = false;
            sqlOtherCollegeArticulations.SelectParameters["CollegeID"].DefaultValue = hvCollegeID.Value;
            sqlOtherCollegeArticulations.SelectParameters["CourseNumber"].DefaultValue = hfCourseNumber.Value;
            sqlOtherCollegeArticulations.SelectParameters["CourseNumber"].ConvertEmptyStringToNull = false;
            sqlOtherCollegeArticulations.SelectParameters["Subject"].DefaultValue = hfSubject.Value;
            sqlOtherCollegeArticulations.SelectParameters["Subject"].ConvertEmptyStringToNull = false;
            sqlOtherCollegeArticulations.SelectParameters["ByCourseSubject"].DefaultValue = hfByCourseSubject.Value;
            sqlOtherCollegeArticulations.SelectParameters["ByACEID"].DefaultValue = hfByACEID.Value;
            sqlOtherCollegeArticulations.SelectParameters["ExcludeAdopted"].DefaultValue = rchkExcludeAdopted.Checked.ToString();
            sqlOtherCollegeArticulations.SelectParameters["ExcludeDenied"].DefaultValue = rchkExcludeDenied.Checked.ToString();
            sqlOtherCollegeArticulations.SelectParameters["ExcludeArticulationOverYears"].DefaultValue = hfExcludeArticulationOverYears.Value;
            sqlOtherCollegeArticulations.SelectParameters["OnlyImplemented"].DefaultValue = rchkOnlyImplemented.Checked.ToString();
            sqlOtherCollegeArticulations.SelectParameters["BySubjectCourseNumberorCIDNumber"].DefaultValue = rchkSubjectCourseCIDNumber.Checked.ToString();
            sqlOtherCollegeArticulations.DataBind();
            rgOtherCollegeArticulations.DataBind();
        }
        protected void rchkExcludeAdopted_CheckedChanged(object sender, EventArgs e)
        {
            setDataSource();
        }

        protected void rchkExcludeDenied_CheckedChanged(object sender, EventArgs e)
        {
            setDataSource();
        }

        protected void rchkOnlyImplemented_CheckedChanged(object sender, EventArgs e)
        {
            setDataSource();
        }

        protected void rchkSubjectCourseCIDNumber_CheckedChanged(object sender, EventArgs e)
        {
            setDataSource();
            ToggleCID((bool)rchkSubjectCourseCIDNumber.Checked);
        }
    }
}
 