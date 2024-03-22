using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ems_app.Model;
using System.Configuration;
using System.Data.SqlClient;

namespace ems_app.UserControls.notifications
{
    public partial class Messages : System.Web.UI.UserControl
    {
        public int UserID { get; set; }
        public int UserStageID { get; set; }
        public string UserName { get; set; }
        public int CollegeID { get; set; }
        public int FirstStage { get; set; }
        public int LastStage { get; set; }
        public bool IsFaculty { get; set; }

        NORCODataContext norco_db = new NORCODataContext();
        Dictionary<int, int> articulations = new Dictionary<int, int>();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfUserID.Value = UserID.ToString();
                hvUserStage.Value = UserStageID.ToString();
                hvUserName.Value = UserName.ToString();
                hvCollegeID.Value = CollegeID.ToString();
                hvFirstStage.Value = FirstStage.ToString();
                hvLastStage.Value = LastStage.ToString();
                hvDisabledArticulationsCount.Value = "0";
                if (IsFaculty == true)
                {
                    pnlSubject.Visible = true;
                }
                hfDeleted.Value = "false";
                hfReviewed.Value = "false";
                hfSent.Value = "false";
            }
        }
        protected void rcmMessages_ItemClick(object sender, Telerik.Web.UI.RadMenuEventArgs e)
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
            RadTab selectedTab = rtbMessages.SelectedTab;

            rgFacultyReviewArticulations.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.Top;
            var message_id = 0;
            try
            {
                if (rgMessages.SelectedItems.Count <= 0)
                {
                    DisplayMessagesControl.DisplayMessage(false, "Select a Message.");
                }
                else
                {

                    foreach (GridDataItem item in rgMessages.SelectedItems)
                    {
                        message_id = Convert.ToInt32(item["MessageID"].Text);
                        switch (command)
                        {
                            case "View":
                                pnlArticulations.Visible = false;
                                if (item["IsRead"].Text == "False" && selectedTab.Text == "Inbox" )
                                {
                                    Message.SetMessageAsReaded(message_id);
                                }
                                hfMessageID.Value = message_id.ToString();
                                hfActionTaken.Value = item["ActionTaken"].Text;
                                hvFromUserCollegeID.Value = item["FromUserCollegeID"].Text;
                                hvFromUserStageID.Value = item["FromUserStageID"].Text;
                                hvCriteriaPackageID.Value = "0";
                                pnlCriteriaPackage.Visible = false;
                                hfSubject.Value = item["Subject"].Text;
                                hvMessageSharedCourseCount.Value = GetMessageSharedCourse(message_id);
                                if (item["ProposedCR"].Text != "0" && hvMessageSharedCourseCount.Value != "0" )
                                {
                                    hvProposedCR.Value = item["ProposedCR"].Text;
                                    pnlCreditRecommendation.Visible = true;
                                    rgFacultyReviewArticulations.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                                    lblMessages.Visible = false;
                                }

                                if (item["CriteriaPackageID"].Text != "0")
                                {
                                    rlCourses.Text = item["CriteriaPackageCourses"].Text.Replace(",", "<br/>");
                                    rlCriteria.Text = item["Criteria"].Text.Replace(",", "<br/>");
                                    pnlCriteriaPackage.Visible = false;
                                    hvCriteriaPackageID.Value = item["CriteriaPackageID"].Text;
                                    GridGroupByField field = new GridGroupByField();
                                    field.FieldName = "SelectedCriteria";
                                    field.HeaderText = "Credit Recommendation";
                                    GridGroupByExpression ex = new GridGroupByExpression();
                                    ex.GroupByFields.Add(field);
                                    ex.SelectFields.Add(field);
                                    rgFacultyReviewArticulations.MasterTableView.GroupByExpressions.Add(ex);
                                    rgFacultyReviewArticulations.Rebind();
                                } else
                                {
                                    for (int i = 0; i < rgFacultyReviewArticulations.MasterTableView.GroupByExpressions.Count - 1; i++)
                                    {
                                        rgFacultyReviewArticulations.MasterTableView.GroupByExpressions.RemoveAt(i);
                                    }
                                    rgFacultyReviewArticulations.Rebind();
                                    rgFacultyReviewArticulations.MasterTableView.GroupByExpressions.Clear();
                                    rgFacultyReviewArticulations.Rebind();
                                }
                                if (item["Articulations"].Text != "" || item["Articulations"].Text != "&nbsp;")
                                {
                                    lblMessages.Style.Add("display", "none");
                                    pnlArticulations.Visible = true;
                                    rgFacultyReviewArticulations.Visible = true;
                                    sqlFacultyReviewArticulations.SelectParameters["Articulations"].DefaultValue = item["Articulations"].Text;
                                    rgFacultyReviewArticulations.DataBind();
                                    hvDisabledArticulationsCount.Value = "0";
                                    rgFacultyReviewArticulations.MasterTableView.AllowPaging = false;
                                    rgFacultyReviewArticulations.Rebind();
                                    if (hvDisabledArticulationsCount.Value == rgFacultyReviewArticulations.Items.Count.ToString())
                                    {
                                        rgFacultyReviewArticulations.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                                    }
                                    rgFacultyReviewArticulations.MasterTableView.AllowPaging = true;
                                    rgFacultyReviewArticulations.Rebind();
                                }
                                if (item["TookAction"].Text == "True" || selectedTab.Text != "Inbox" || item["IsCC"].Text == "True")
                                {
                                    GridCommandItem cmdItem = (GridCommandItem)rgFacultyReviewArticulations.MasterTableView.GetItems(GridItemType.CommandItem)[0];
                                    RadButton btnAdopt = (RadButton)cmdItem.FindControl("btnAdopt");
                                    RadButton btnMoveForward = (RadButton)cmdItem.FindControl("btnMoveForward");
                                    RadButton btnReturn = (RadButton)cmdItem.FindControl("btnReturn");
                                    RadButton btnDenied = (RadButton)cmdItem.FindControl("btnDenied");
                                    RadButton btnRevise = (RadButton)cmdItem.FindControl("btnRevise");
                                    RadButton btnArchive = (RadButton)cmdItem.FindControl("btnArchive");
                                    btnAdopt.Enabled = false;
                                    btnMoveForward.Enabled = false;
                                    btnReturn.Enabled = false;
                                    btnDenied.Enabled = false;
                                    btnRevise.Enabled = false;
                                    btnArchive.Enabled = false;
                                }
                                sqlMessage.DataBind();
                                rptMessage.DataBind();
                                break;
                            case "Read":
                                Message.SetMessageAsReaded(message_id);
                                break;
                            case "Delete":
                                Message.DeleteMessage(message_id);
                                break;
                            default:
                                break;
                        }
                    }
                    rgMessages.DataBind();
                    rgMessages.Rebind();
                }
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.ToString());
            }
        }

        protected void rgMessages_ItemCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "Read" || e.CommandName == "Delete" || e.CommandName == "View")
                {
                    ExecuteCommands(e.CommandName);
                }
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.ToString());
            }
        }

        protected void rgMessages_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            RadTab selectedTab = rtbMessages.SelectedTab;
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var adopted = dataBoundItem["IsRead"].Text;
                if (adopted == "False")
                {
                    dataBoundItem.Font.Bold = true;
                }
                if (selectedTab.Text != "Inbox")
                {
                    dataBoundItem.Font.Bold = false;
                }
            }
        }

        protected void rgFacultyReviewArticulations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            try
            {
                var user_stage_id = Convert.ToInt32(hvUserStage.Value);
                var user_name = hvUserName.Value;
                var user_id = Convert.ToInt32(hfUserID.Value);
                var college_id = Convert.ToInt32(hvCollegeID.Value);

                if (e.CommandName == "MoveForward" || e.CommandName == "Return" || e.CommandName == "Denied" || e.CommandName == "Archive" || e.CommandName == "Adopt" || e.CommandName == "Revise")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Select an Articulation.");
                    }
                    else
                    {
                        //foreach (GridDataItem item in grid.SelectedItems)
                        //{
                        //    articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                        //    if (e.CommandName == "Denied")
                        //    {
                        //        if (item["ArticulationStatus"].Text != "2")
                        //        {
                        //            try
                        //            {
                        //                norco_db.DontArticulate(Convert.ToInt32(item["ArticulationID"].Text), Convert.ToInt32(item["ArticulationType"].Text), Convert.ToInt32(Session["UserID"]));
                        //            }
                        //            catch (Exception ex)
                        //            {
                        //                DisplayMessage(true, ex.ToString());
                        //            }
                        //        }
                        //    }
                        //}
                        foreach (GridDataItem item in rgFacultyReviewArticulations.SelectedItems)
                        {
                            articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                        }
                        Session["articulationList"] = articulations;
                        switch (e.CommandName)
                        {
                            case "MoveForward":
                                NotifyPopup("MoveForward", user_stage_id, user_name, user_id, college_id, 1000, 700, Convert.ToInt32(hvCriteriaPackageID.Value), hfSubject.Value, hfMessageID.Value);
                                break;
                            case "Return":
                                NotifyPopup("Return", user_stage_id, user_name, user_id, college_id, 1000, 700, Convert.ToInt32(hvCriteriaPackageID.Value), hfSubject.Value, hfMessageID.Value);
                                break;
                            case "Denied":
                                NotifyPopup("Denied", user_stage_id, user_name, user_id, college_id, 1000, 700, Convert.ToInt32(hvCriteriaPackageID.Value), hfSubject.Value, hfMessageID.Value);
                                break;
                            case "Archive":
                                NotifyPopup("Archive", user_stage_id, user_name, user_id, college_id, 1000, 700, Convert.ToInt32(hvCriteriaPackageID.Value), hfSubject.Value, hfMessageID.Value);
                                break;
                            case "Revise":
                                NotifyPopup("Revise", user_stage_id, user_name, user_id, college_id, 1000, 700, Convert.ToInt32(hvCriteriaPackageID.Value), hfSubject.Value, hfMessageID.Value);
                                break;
                            case "Adopt":
                                ConfirmAdopt(string.Join(", ", articulations.Select(art => art.Key)), user_id, college_id, 1000, 700);
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }
        }

        protected void rgFacultyReviewArticulations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            lblMessages.InnerHtml = "<i class='fa fa-exclamation - triangle' aria-hidden='true'></i> ";
            lblMessages.InnerHtml = string.Concat(lblMessages.InnerHtml, string.Format("Note: the disabled (grey out) articulations require no action because they are either notifications only or you already took action", hfActionTaken.Value));
            var is_disable = false;

            RadGrid grid = (RadGrid)sender;

            if (e.Item is GridGroupHeaderItem)
            {
                GridGroupHeaderItem groupHeader = (GridGroupHeaderItem)e.Item;
                {
                    groupHeader.DataCell.Text = groupHeader.DataCell.Text.Split(':')[1].ToString();
                }
            }
            if (e.Item is GridHeaderItem)
            {
                CheckBox chkbx = (CheckBox)(e.Item as GridHeaderItem)["ClientSelectColumn"].Controls[0];
                chkbx.Enabled = false;
            }
            if (e.Item is GridDataItem && grid.ID == "rgFacultyReviewArticulations")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var articulation_stage = dataBoundItem["ArticulationStage"].Text;
                var course_exist = dataBoundItem["CourseExists"].Text;
                var articulation_exist = dataBoundItem["ArticulationExists"].Text;
                HyperLink hp = (HyperLink)dataBoundItem.FindControl("hlExhibit");
                hp.Text = dataBoundItem["AceID"].Text;
                hp.NavigateUrl = $"javascript:showExhibitInfo('{dataBoundItem["ExhibitID"].Text}','{dataBoundItem["SelectedCriteria"].Text}')";
                //if (course_exist == "False")
                //{
                //    CheckBox chkbx = (CheckBox)dataBoundItem["ClientSelectColumn"].Controls[0];
                //    chkbx.Enabled = false;
                //    dataBoundItem.SelectableMode = GridItemSelectableMode.None;
                //    dataBoundItem.ToolTip = "This course either does not exist in your college or the articulation has been already created.";
                //    lblMessages.Style.Add("display", "block");
                //    is_disable = true;
                //}
                //if (hvUserStage.Value != articulation_stage)
                //{
                //    CheckBox chkbx = (CheckBox)dataBoundItem["ClientSelectColumn"].Controls[0];
                //    chkbx.Enabled = false;
                //    dataBoundItem.SelectableMode = GridItemSelectableMode.None;
                //    dataBoundItem.ToolTip = "You have already processed this articulation.";
                //    lblMessages.Style.Add("display", "block");
                //    is_disable = true;
                //}
                if (hvUserStage.Value == articulation_stage)
                {
                    rgFacultyReviewArticulations.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.Top;
                }
                //if (hvCriteriaPackageID.Value != "0" || hvProposedCR.Value != "" )
                //{
                    CheckBox chkbx = (CheckBox)dataBoundItem["ClientSelectColumn"].Controls[0];
                    dataBoundItem.Selected = true;
                    chkbx.Enabled = false;
                    chkbx.Checked = true;
                //}
                if (is_disable == true)
                {
                    hvDisabledArticulationsCount.Value = (Convert.ToInt32(hvDisabledArticulationsCount.Value) + 1).ToString();
                }

            }
            if (e.Item is GridCommandItem && grid.ID == "rgFacultyReviewArticulations")
            {
                GridCommandItem cmditem = (GridCommandItem)e.Item;
                RadButton adopt_button = (RadButton)cmditem.FindControl("btnAdopt");
                RadButton approve_button = (RadButton)cmditem.FindControl("btnMoveForward");
                RadButton deny_button = (RadButton)cmditem.FindControl("btnDenied");
                RadButton return_button = (RadButton)cmditem.FindControl("btnReturn");
                RadButton archive_button = (RadButton)cmditem.FindControl("btnArchive");
                RadButton revise_button = (RadButton)cmditem.FindControl("btnRevise");
                adopt_button.Visible = false;
                return_button.Visible = false;
                deny_button.Visible = true;
                approve_button.Visible = true;
                archive_button.Visible = false;
                if (hvUserStage.Value == hvFirstStage.Value)
                {
                    return_button.Visible = false;
                    //deny_button.Visible = false;
                }
                if (hvUserStage.Value == hvLastStage.Value)
                {
                    approve_button.Visible = false;
                }
                if (Convert.ToInt32(hvMessageSharedCourseCount.Value) > 1)
                {
                    return_button.Visible = false;
                }
                {

                }
                if (hfActionTaken.Value=="Adopt")
                {
                    adopt_button.Visible = true;
                }
                if (hvCriteriaPackageID.Value != "0")
                {
                    adopt_button.Visible = false;
                    archive_button.Visible = false;
                }
                else
                {
                    //if (hvCollegeID.Value != hvFromUserCollegeID.Value)
                    //{
                    //    return_button.Visible = false;
                    //    deny_button.Visible = false;
                    //    approve_button.Visible = false;
                    //    archive_button.Visible = false;
                    //}
                }
            }
        }
        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }
        public void NotifyPopup(string action, int user_stage_id, string user_name, int user_id, int college_id, int width, int height, int criteria_package_id, string subject, string message_id)
        {
            var url = $"/modules/popups/Notify.aspx?Action={action}&UserStageID={user_stage_id}&UserName={user_name}&UserID={user_id}&CollegeID={college_id}&CriteriaPackageID={criteria_package_id}&Subject={subject}&MessageID={message_id}";
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        public void ConfirmAdopt(string articulation_list, int user_id, int college_id, int width, int height)
        {
            var url = String.Format("/modules/popups/ConfirmAdoptArticulation.aspx?ArticulationList={0}&UserID={1}&CollegeID={2}", articulation_list, user_id, college_id, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        public void showArticulation(int id, int articulation_type, int outline_id, string AceID, string Title, DateTime TeamRevd, bool isReadOnly, int otherCollegeID, bool adoptArticulation, string collegeName, string modalWindow, int width, int height, int ExhibitID)
        {
            var urlPage = "/modules/popups/AssignOccupationArticulation.aspx";
            var readOnlyParameter = "";
            if (isReadOnly)
            {
                readOnlyParameter = "&isReadOnly=true";
            }

            //if (articulation_type == 2)
            //{
            //    urlPage = "/modules/popups/AssignOccupationArticulation.aspx";
            //}
            if (modalWindow.Equals("NewTab"))
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("{0}?articulationID={1}&outline_id={2}&AceID={3}&Title={4}&TeamRevd={5}&NewWindow=true{6}&OtherCollegeID={7}&AdoptArticulation={8}&CollegeName={9}&ExhibitID={10}", urlPage, id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), readOnlyParameter, otherCollegeID.ToString(), adoptArticulation.ToString(), collegeName.ToString(), ExhibitID) + "');", true);
            }
            else
            if (modalWindow.Equals("Popup"))
            {
                var url = String.Format("{0}?articulationID={1}&outline_id={2}&AceID={3}&Title={4}&TeamRevd={5}&NewWindow=true{6}&OtherCollegeID={7}&AdoptArticulation={8}&CollegeName={9}&ExhibitID={10}", urlPage, id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), readOnlyParameter, otherCollegeID.ToString(), adoptArticulation.ToString(), collegeName.ToString(), ExhibitID);
                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, width, height));
            }
        }
        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);
            var user_stage_id = Convert.ToInt32(hvUserStage.Value);
            var user_name = hvUserName.Value;
            var user_id = Convert.ToInt32(hfUserID.Value);
            var college_id = Convert.ToInt32(hvCollegeID.Value);
            var id = Convert.ToInt32(hvID.Value);
            var outline_id = Convert.ToInt32(hvOutlineID.Value);
            var team_revd = Convert.ToDateTime(hvTeamRevd.Value);
            var articulation_type = Convert.ToInt32(hvArticulationType.Value);
			var exhibit_id = Convert.ToInt32(hvExhibitID.Value);													
            foreach (GridDataItem item in rgFacultyReviewArticulations.SelectedItems)
            {
                articulations.Add(Convert.ToInt32(item["id"].Text), 0);
            }
            Session["articulationList"] = articulations;
            try
            {
                switch (e.Item.Text)
                {
                    case "Edit":
                        showArticulation(id, articulation_type, outline_id, hvAceID.Value, hvTitle.Value, team_revd, false, 0, false, "", "NewTab", 0, 0, exhibit_id);
                        break;
                    case "View":
                        showArticulation(id, articulation_type, outline_id, hvAceID.Value, hvTitle.Value, team_revd, true, 0, false, "", "NewTab", 0, 0, exhibit_id);
                        break;
                    case "Adopt":
                        ConfirmAdopt(string.Join(", ", articulations.Select(art => art.Key)), user_id, college_id, 800, 600);
                        break;
                    default:
                        //articulations.Add(id,0);
                        NotifyPopup(e.Item.Value, user_stage_id, user_name, user_id, college_id, 800, 600, Convert.ToInt32(hvCriteriaPackageID.Value), hfSubject.Value, hfMessageID.Value);
                        break;
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }
        }

        protected void rgFacultyReviewArticulations_PreRender(object sender, EventArgs e)
        {
            hvDisabledArticulationsCount.Value = "0";
            rgFacultyReviewArticulations.MasterTableView.GetColumn("ArticulationCollege").Visible = false;
            rgFacultyReviewArticulations.MasterTableView.GetColumn("course_title").Visible = true;
            if (hvCollegeID.Value != hvFromUserCollegeID.Value)
            {
                rgFacultyReviewArticulations.MasterTableView.GetColumn("ArticulationCollege").Visible = true;
                rgFacultyReviewArticulations.MasterTableView.GetColumn("course_title").Visible = false;
            }
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, Telerik.Web.UI.AjaxRequestEventArgs e)
        {
            rgFacultyReviewArticulations.DataBind();
        }

        protected void rtbMessages_TabClick(object sender, RadTabStripEventArgs e)
        {
            Telerik.Web.UI.RadTab TabClicked = e.Tab;
            Label1.Text = TabClicked.Value;
            rgMessages.Enabled = true;
            rcmMessages.Enabled = true;
            rcmMessages.FindItemByValue("Delete").Enabled = true;
            rgMessages.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.Top;
            switch (TabClicked.Value)
            {
                case "inbox":
                    hfDeleted.Value = "false";
                    hfSent.Value = "false";
                    hfReviewed.Value = "false";
                    rgMessages.MasterTableView.Columns.FindByUniqueName("FromUser").Visible = true;
                    rgMessages.MasterTableView.Columns.FindByUniqueName("ToUser").Visible = false;
                    break;
                case "deleted":
                    hfDeleted.Value = "true";
                    hfSent.Value = "false";
                    hfReviewed.Value = "false";
                    rcmMessages.FindItemByValue("Delete").Enabled = false;
                    break;
                case "reviewed":
                    hfDeleted.Value = "false";
                    hfSent.Value = "false";
                    hfReviewed.Value = "true";
                    break;
                case "sent":
                    hfDeleted.Value = "false";
                    hfSent.Value = "true";
                    hfReviewed.Value = "false";
                    rcmMessages.FindItemByValue("Read").Enabled = false;
                    rgMessages.MasterTableView.Columns.FindByUniqueName("FromUser").Visible = false;
                    rgMessages.MasterTableView.Columns.FindByUniqueName("ToUser").Visible = true;
                    /*rgMessages.Enabled = false;
                    rgMessages.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                    rcmMessages.Enabled = false;*/
                    break;
                default:
                    break;
            }
            sqlMessages.DataBind();
            rgMessages.DataBind();
        }

        protected void rgMessages_PreRender(object sender, EventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (!Page.IsPostBack)
            {
                //if (grid.MasterTableView.Items.Count > 0)
                //{
                //    GridItem item = grid.MasterTableView.Items[0];
                //    hvMessageCount.Value = grid.MasterTableView.Items.Count.ToString();
                //    item.Selected = true;
                //    item.FireCommandEvent("View", string.Empty);
                //} 
            }
        }

        protected void rbSearchMessages_Click(object sender, EventArgs e)
        {
            string AceIds = string.Empty;
            if (racbAdvancedSearchMessages.Entries.Count > 0)
            {
                foreach (AutoCompleteBoxEntry item in racbAdvancedSearchMessages.Entries)
                {
                    AceIds += item.Value + "|";
                }
            }
            hfAceIds.Value = AceIds;
            rgMessages.Rebind();
        }
        
        public static string GetProposedCR(int criteria_id)
        {
            string criteria = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select Criteria from ACEExhibitCriteria where CriteriaID = {criteria_id};";
                    criteria = cmd.ExecuteScalar().ToString();
                }
                finally
                {
                    connection.Close();
                }
            }
            return criteria;
        }

        public static string GetMessageSharedCourse(int message_id)
        {
            string count = "";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"SELECT [dbo].[GetMessageSharedCourse] ({message_id}) ;";
                    count = cmd.ExecuteScalar().ToString();
                }
                finally
                {
                    connection.Close();
                }
            }
            return count;
        }

        protected void rgFacultyReviewArticulations_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridCommandItem)
            {
                if (hfActionTaken.Value == "Revise")
                {
                    GridCommandItem commandItem = e.Item as GridCommandItem;
                    RadButton button = commandItem.FindControl("btnRevise") as RadButton;
                    button.Visible = false;
                }             
            }
        }

        public void RevisePanel(bool show, string title, bool show_message, string message)
        {
            pnlCreditRecommendation.Visible = show;
            lblMessages.Visible = show_message;
            lblMessages.InnerText = message;
            rnMessageNotifications.Title = title;
            rnMessageNotifications.Text = message;
            rnMessageNotifications.Show();
        }

        protected void btnAgree_Click(object sender, EventArgs e)
        {
            foreach (GridDataItem item in rgFacultyReviewArticulations.SelectedItems)
            {
                //Controllers.Articulation.ApprovalArticulationWorkflow(Convert.ToInt32(item["id"].Text), 3, UserID, "");
            }
            RevisePanel(false, "Revise", true, "Agree confimation text");
        }

        protected void btnDisagree_Click(object sender, EventArgs e)
        {
            foreach (GridDataItem item in rgFacultyReviewArticulations.SelectedItems)
            {
                //Controllers.Articulation.ApprovalArticulationWorkflow(Convert.ToInt32(item["id"].Text), 4, UserID, "");
            }
            RevisePanel(false, "Revise", true, "Disagree confimation text");
        }
    }
}