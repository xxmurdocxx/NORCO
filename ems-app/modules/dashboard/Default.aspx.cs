using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app
{
    public partial class Default1 : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        Dictionary<int, int> articulations = new Dictionary<int, int>();
        List<string> AceIDList = new List<string>();

        private Hashtable _ordersExpandedState;
        private Hashtable _selectedState;

        protected void Page_Load(object sender, EventArgs e)
        {
            //Set College Summary User Control
            CollegeSummaryResults.CollegeID = Convert.ToInt32(Session["CollegeID"]);
            QualifiedVetsButtons.CollegeID = Convert.ToInt32(Session["CollegeID"]);
            TopCollegeArticulations.TopNumber = 5;
            TopCollegeArticulations.OnlyPublished = 0;
            MyMessages.UserName = Session["UserName"].ToString();
            MyMessages.CollegeID = Convert.ToInt32(Session["CollegeID"]);
            MyMessages.UserID = Convert.ToInt32(Session["UserID"]);
            MyMessages.UserStageID = Convert.ToInt32(Session["UserStageID"]);
            MyMessages.FirstStage = (int)norco_db.GetMinimumStageId(Convert.ToInt32(Session["CollegeID"].ToString()));
            MyMessages.LastStage = (int)norco_db.GetMaximumStageId(Convert.ToInt32(Session["CollegeID"].ToString()));
            MyMessages.IsFaculty = Convert.ToBoolean(Session["reviewArticulations"].ToString());
            rpbCollegeArticulations.CollapseAllItems();
            lblMyNotifications.Text = string.Format("{0} Notifications", Session["RoleName"].ToString());

            if (!IsPostBack)
            {
                //User Information
                SystemTitle.InnerText = GlobalUtil.ReadSetting("AppName");
                CreateArticulationByCriteria.CollegeID = Convert.ToInt32(Session["CollegeID"]);

                hvShowDenied.Value = "false";

                hfCollege.Value = Session["CollegeID"].ToString();
                hfUserID.Value = Session["UserID"].ToString();
                hfRoleID.Value = Session["RoleID"].ToString();
                hfCollegeName.Value = Session["College"].ToString();
                hfUserName.Value = Session["UserName"].ToString();
                hfWelcomePage.Value = norco_db.CheckUserWelcomePage(Convert.ToInt32(Session["UserID"])).ToString();
                hfShowDenied.Value = "false";

                if (Session["Skipped"] != null)
                {
                    hfSkipped.Value = Session["Skipped"].ToString();
                }

				//if (Session["RoleName"].ToString() == "Ambassador")
				//{
				//    if (CheckFacultyUsersHaveSubjects(Convert.ToInt32(hfCollege.Value)) == 1)
				//    {
				//        rnFacultyUsers.Show();
				//    }
				//}  It was requested that the pop up notification be disabled, DevOps User Story 769.

				if (Convert.ToBoolean(Session["PendingDataIntake"]) == true)
                {
                    Response.Redirect("/modules/settings/DownloadTemplates.aspx");
                }
                else
                {

                    //Check if faculty review district, redirect to Enforce district review URL
                    //var isEnforceFaculty = norco_db.CheckIsFacultyDistrictReview(Convert.ToInt32(Session["RoleID"]));
                    //if (isEnforceFaculty == true)
                    //{
                    //    var havePendingReview = norco_db.HavePendingFacultyDistrictReview(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["UserID"]));
                    //    if (havePendingReview == true)
                    //    {
                    //        var stage_id = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
                    //        Response.Redirect(norco_db.GetFacultyReviewArticulationUrl(stage_id, Convert.ToInt32(Session["CollegeID"])));
                    //    }
                    //}

                    UnknownOccupationsNotificationControl.isAdministrator = Convert.ToBoolean(Session["isAdministrator"]);
                    CollegeArticulationStats.CollegeID = Convert.ToInt32(Session["CollegeID"]);

                    //manage articulations
                    //reset states
                    this._ordersExpandedState = null;
                    this.Session["_ordersExpandedState"] = null;
                    this._selectedState = null;
                    this.Session["_selectedState"] = null;

                    hfStageID.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])).ToString();

                    var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
                    var firstStage = norco_db.GetMinimumStageId(Convert.ToInt32(Session["CollegeID"]));
                    var lastStage = norco_db.GetMaximumStageId(Convert.ToInt32(Session["CollegeID"]));
                    hfLastStageID.Value = norco_db.GetMaximumStageId(Convert.ToInt32(Session["CollegeID"])).ToString();

                    lbImplementedArticulations.Visible = false;
                    rpbCollegeArticulations.Visible = false;

                    if (IsVRCStaff(Session["RoleID"].ToString()))
                    {
                        //rpbMyArticulations.Visible = false;
                        rpbMyNotifications.Visible = false;
                        //rpbCollegeArticulations.Visible = false;
                        panelVCRStaff.Visible = true;
                        //rlbAdopt.Visible = false;
                        rlbStudentIntake.Visible = true;
                        pnlArticulationsInProcess.Visible = false;
                        //rgArticulationCourses.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                        //rgArticulationCourses.Rebind();
                    }

                    if (Convert.ToBoolean(Session["isAdministrator"]) == true || Convert.ToBoolean(Session["SuperUser"]) == true || Session["RoleName"].ToString() == "Ambassador" || Session["RoleName"].ToString() == "Evaluator")
                    {
                        lbImplementedArticulations.Visible = true;
                        rpbCollegeArticulations.Visible = true;
                    }

                        RadComboBoxStageFilter.DataBind();
                    sqlArticulationCourses.SelectParameters["ShowDenied"].DefaultValue = hfShowDenied.Value;
                    if ( Convert.ToBoolean(Session["isAdministrator"]) == true || Convert.ToBoolean(Session["SuperUser"]) == true)
                    {
                        RadComboBoxStageFilter.SelectedValue = "0";
                        sqlArticulationCourses.SelectParameters["StageFilter"].DefaultValue = firstStage.ToString();
                        sqlCourseMatches.SelectParameters["StageFilter"].DefaultValue = firstStage.ToString();
                    } else
                    {
                        RadComboBoxStageFilter.SelectedValue = userStageID.ToString();
                        sqlArticulationCourses.SelectParameters["StageFilter"].DefaultValue = userStageID.ToString();
                        sqlCourseMatches.SelectParameters["StageFilter"].DefaultValue = userStageID.ToString();
                    }
                    sqlArticulationCourses.SelectParameters["StageFilter"].DefaultValue = RadComboBoxStageFilter.SelectedValue;
                    sqlCourseMatches.SelectParameters["StageFilter"].DefaultValue = RadComboBoxStageFilter.SelectedValue;
                    sqlArticulationCourses.DataBind();
                    rgArticulationCourses.DataBind();

                    rlbAdopt.Enabled = false;
                    rlbAdopt.Primary = false;

                    rpbMyArticulations.Visible = false;
                    if (Convert.ToBoolean(Session["isAdministrator"]) == true || Convert.ToBoolean(Session["SuperUser"]) == true || Session["RoleName"].ToString() == "Ambassador")
                    {
                        if (norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])) == firstStage || Convert.ToBoolean(Session["SuperUser"]) == true || Session["RoleName"].ToString() == "Ambassador")
                        {
                            rlbAdopt.Enabled = true;
                            rlbAdopt.Primary = true;
                            rpbMyArticulations.Visible = true;
                            rlbAdopt.Visible = true;
                            rlbStudentIntake.Enabled = true;
                        } else { 
                        rpbMyArticulations.Visible = false;
                            rlbAdopt.Visible = false;
                            rlbStudentIntake.Visible = false;
                        }
                    }
                    else if (norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])) == firstStage)
                    {
                        rlbAdopt.Enabled = true;
                        rlbAdopt.Primary = true;
                        rpbMyArticulations.Visible = true;
                        rlbAdopt.Visible = true;
                        rlbStudentIntake.Visible = true;
                    }
                    else
                    {
                        rpbMyArticulations.Visible = false;
                        rlbAdopt.Visible = false;
                        rlbStudentIntake.Visible = false;
                    }
                    sqlArticulationCourses.DataBind();
                    rgArticulationCourses.DataBind();
                    if (userStageID == lastStage)
                    {
                        EnableCommandItemButton("btnMoveForward",false);
                    }

                    EnableArticulationInProcessButtons(Convert.ToInt32(RadComboBoxStageFilter.SelectedValue), (int)norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])));


                    GridCommandItem cmdItem = (GridCommandItem)rgArticulationCourses.MasterTableView.GetItems(GridItemType.CommandItem)[0];
                    RadButton btnDelete = (RadButton)cmdItem.FindControl("rbDelete");
                    RadButton btnDenied = (RadButton)cmdItem.FindControl("btnDenied");
                    
                    //<---- Added by Pedro Bernal - 10_01_2024
                    RadButton btnMoveForward = (RadButton)cmdItem.FindControl("btnMoveForward");
                    RadButton btnReturn = (RadButton)cmdItem.FindControl("btnReturn");
                    int collegID = (int)Session["CollegeID"];
                    int userID = (int)Session["UserID"];
                    if (IsOnlyAmbassador(userID, collegID))
                    {
                        btnMoveForward.Visible = false;
                        btnDenied.Visible = false;
                    }
                    // Added by Pedro Bernal - 10_01_2024 //------>

                    //btnDelete.Visible = false;
                    btnDelete.Enabled = false;
                    if ((Convert.ToBoolean(Session["isAdministrator"]) == true || Convert.ToBoolean(Session["SuperUser"]) == true) ||
                        Session["RoleName"].ToString() == "Evaluator" || 
                        Session["RoleName"].ToString() == "Ambassador")
                    {
                        //btnDelete.Visible = true;
                        btnDelete.Enabled = true;

                    }
                    RadButton return_button = (RadButton)cmdItem.FindControl("btnReturn");
                    return_button.Visible = false;
                    RadButton approve_button = (RadButton)cmdItem.FindControl("btnMoveForward");
                    if (norco_db.GetStageOrderByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])) == 4)
                    {
                        approve_button.Visible = false;
                    }
                    if (RadComboBoxStageFilter.SelectedValue == "0" && (Session["RoleName"].ToString() == "Faculty" || Session["RoleName"].ToString() == "Articulation Officer" || Session["RoleName"].ToString() == "Implementation"))
                    {
                        btnDelete.Visible = false;
                    }
                }
            }
        }

        private void EnableCommandItemButton(string btn,bool toggle)
        {
            GridCommandItem cmdItem = (GridCommandItem)rgArticulationCourses.MasterTableView.GetItems(GridItemType.CommandItem)[0];
            RadButton button = (RadButton)cmdItem.FindControl(btn);
            button.Enabled = toggle;
        }

        public void NotifyPopup(string action, int user_stage_id, string user_name, int user_id, int college_id, int width, int height)
        {
            var url = String.Format("/modules/popups/Notify.aspx?Action={0}&UserStageID={1}&UserName={2}&UserID={3}&CollegeID={4}", action, user_stage_id, user_name, user_id, college_id, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }
        public void ConfirmDeny(string articulation_list, int width, int height)
        {
            var url = String.Format("/modules/popups/ConfirmDenyArticulation.aspx?ArticulationList={0}", articulation_list, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        protected void rgArticulationCourses_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            var outline_id = 0;
            var AceID = "";
            var TeamRevd = "";

            try
            {
                var user_stage_id = Convert.ToInt32(Session["UserStageID"].ToString());
                var user_name = hfUserName.Value;
                var user_id = Convert.ToInt32(hfUserID.Value);
                var college_id = Convert.ToInt32(hfCollege.Value);
                articulations.Clear();

                if (e.CommandName == "MoveForward" || e.CommandName == "Return" || e.CommandName == "Denied" || e.CommandName == "Archive" || e.CommandName == "Delete")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Select an Articulation.");
                    }
                    else
                    {

                        foreach (GridDataItem item in grid.SelectedItems)
                        {
                            articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                        }
                        //if (e.CommandName == "Denied")
                        //{
                        //    ConfirmDeny(string.Join(", ", articulations.Select(art => art.Key)), 1000, 700);
                        //    NotifyPopup("MoveForward", user_stage_id, user_name, user_id, college_id, 1000, 700);
                        //}
                        if (e.CommandName == "Delete")
                        {
                            var firstStage = norco_db.GetMinimumStageId(Convert.ToInt32(Session["CollegeID"]));
                            var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
                            foreach (GridDataItem item in grid.SelectedItems)
                            { 
                                if (Session["RoleName"].ToString() == "Evaluator" || Convert.ToBoolean(Session["SuperUser"]) == true || Convert.ToBoolean(Session["isAdministrator"]) == true || Session["RoleName"].ToString() == "Ambassador")
                                {
                                    GlobalUtil.DeleteArticulation(Convert.ToInt32(item["id"].Text), Convert.ToInt32(Session["UserID"]));
                                }
                            }
							rgArticulationCourses.DataBind();								 
                            DisplayMessage(false, "Articulation successfully deleted");
                            Response.Redirect(Request.RawUrl);
                        }

                        Session["articulationList"] = articulations;
                        switch (e.CommandName)
                        {
                            case "MoveForward":
                                NotifyPopup("MoveForward", user_stage_id, user_name, user_id, college_id, 1000, 700);
                                break;
                            case "Return":
                                NotifyPopup("Return", user_stage_id, user_name, user_id, college_id, 1000, 700);
                                break;
                            case "Denied":
                                NotifyPopup("Denied", user_stage_id, user_name, user_id, college_id, 800, 600);
                                break;
                            case "Archive":
                                NotifyPopup("Archive", user_stage_id, user_name, user_id, college_id, 1000, 700);
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

            if (e.CommandName == RadGrid.FilterCommandName)
            {
                Pair filterPair = (Pair)e.CommandArgument;
                string columnUniqueName = filterPair.Second.ToString();
                //TextBox filterBox = (e.Item as GridFilteringItem)[filterPair.Second.ToString()].Controls[0] as TextBox;
                //string filterValue = filterBox.Text;

                if (columnUniqueName == "subject")
                {
                    hfSubjectFilter.Value = rgArticulationCourses.MasterTableView.Columns.FindByUniqueName("subject").CurrentFilterValue;
                }
                if (columnUniqueName == "course_number")
                {
                    //hfCourseFilter.Value = filterValue;
                    hfCourseFilter.Value = rgArticulationCourses.MasterTableView.Columns.FindByUniqueName("course_number").CurrentFilterValue;
                }
                if (columnUniqueName == "course_title")
                {
                    //hfTitleFilter.Value = filterValue;
                    hfTitleFilter.Value = rgArticulationCourses.MasterTableView.Columns.FindByUniqueName("course_title").CurrentFilterValue;
                }
            }

            if (e.CommandName == "HeaderContextMenuFilter")
            {
                List<string> subjectList = new List<string>();
                foreach (GridColumn column in grid.MasterTableView.RenderColumns.Where(x => x.SupportsFiltering()))
                {
                    if (column.UniqueName == "subject")
                    {
                        string[] subjectItems = column.ListOfFilterValues;
                        if (subjectItems != null)
                        {
                            foreach (string Str in subjectItems)
                            {
                                subjectList.Add(Str);
                            }
                            hfSubjectFilter.Value = string.Join(",", subjectList);
                        }
                    }
                }
            }

            if (e.CommandName == "Archive")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select an articulation.");
                }
                else
                {
                    if (e.Item.OwnerTableView.Name == "ChildGrid")
                    {
                        var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
                        if (userStageID == Convert.ToInt32(itemDetail["ArticulationStage"].Text) && Convert.ToInt32(itemDetail["ArticulationStatus"].Text) != 2)
                        {
                            try
                            {
                                if (e.CommandName == "Archive")
                                {
                                    norco_db.ArchiveArticulation(Convert.ToInt32(itemDetail["ArticulationID"].Text), Convert.ToInt32(itemDetail["articulation_type"].Text), Convert.ToInt32(Session["UserID"]));
                                    DisplayMessage(false, "Articulation successfully archived");
                                }
                                grid.DataBind();
                            }
                            catch (Exception ex)
                            {
                                DisplayMessage(false, ex.ToString());
                            }
                        }
                        else
                        {
                                DisplayMessage(false, "You can not archive this articulation");
                        }

                    }
                }

            }
            if (e.CommandName == "AdoptArticulations")
            {
                if (e.Item.OwnerTableView.Name == "ChildGrid")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Please select an articulation");
                    }
                    else
                    {
                        AceID = itemDetail["AceID"].Text;
                        TeamRevd = itemDetail["TeamRevd"].Text;
                        var CollegeID = Session["CollegeID"].ToString();
                        var url = String.Format("../popups/AdoptArticulations.aspx?CollegeID={0}&AceID={1}&TeamRevd={2}", CollegeID, AceID, TeamRevd);
                        RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 1200, 650));                     
                    }
                }
            }

            if (e.CommandName == "EditNotes")
            {
                if (e.Item.OwnerTableView.Name == "ChildGrid")
                {
                    if (itemDetail["articulation_type"].Text == "1")
                    {
                        showAssignArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), false, Convert.ToInt32(itemDetail["ExhibitID"].Text));
                    }
                    else
                    {
                        showAssignOccupationArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), false, Convert.ToInt32(itemDetail["ExhibitID"].Text));
                    }
                }
            }

            if (e.CommandName == "DontArticulate")
            {
                if (e.Item.OwnerTableView.Name == "ChildGrid")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Please select an articulation.");
                    }
                   else
                    {
                        foreach (GridDataItem item in grid.SelectedItems)
                        {
                            articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                        }
                        ConfirmDeny(string.Join(", ", articulations.Select(art => art.Key)), 1000, 700);
                   }
                }
            }


            if (e.CommandName == "ExportToExcel")
            {
                grid.MasterTableView.ExportToExcel();
            }
            if (e.CommandName == "Audit")
            {
                if (e.Item.OwnerTableView.Name == "ParentGrid")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Please select a course.");
                    }
                    else
                    {
                        GridDataItem item = (GridDataItem)grid.MasterTableView.Items[grid.SelectedItems[0].ItemIndex];
                        outline_id = Convert.ToInt32(item["outline_id"].Text);
                        if (e.CommandName == "Audit")
                        {
                            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Audit.aspx?OutlineID={0}&AceID=&TeamRevd=", outline_id.ToString()), true, true, false, 900, 600));
                        }
                    }
                }
                if (e.Item.OwnerTableView.Name == "ChildGrid")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Please select an articulation.");
                    }
                    else
                    {
                        outline_id = Convert.ToInt32(itemDetail["outline_id"].Text);
                        AceID = itemDetail["AceID"].Text;
                        TeamRevd = itemDetail["TeamRevd"].Text;
                        if (e.CommandName == "Audit")
                        {
                            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow($"../popups/Audit.aspx?ArticulationID={itemDetail["id"].Text}", true, true, false, 900, 600));
                        }
                    }
                }
            }
            //RecentUserActivity.DataBind();
            //grid.DataBind(); Commented on 4/25/22
        }

        public void DeleteArticulations()
        {
            foreach (GridDataItem item in rgArticulationCourses.SelectedItems)
            {
                var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
                if (Convert.ToInt32(item["ArticulationStage"].Text) == userStageID)
                {
                    GlobalUtil.DeleteArticulation(Convert.ToInt32(item["id"].Text), Convert.ToInt32(Session["UserID"]));
                }
            }
			rgArticulationCourses.DataBind();								 
            DisplayMessage(false, "Articulation successfully deleted");
            rgArticulationCourses.DataBind();
        }

        public void showAssignArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly, int ExhibitID)
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

        public void showAssignOccupationArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly, int ExhibitID)
        {
            if (isReadOnly)
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'",""), TeamRevd.ToString(), ExhibitID) + "');", true);
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            rgArticulationCourses.DataBind();
        }

        protected void rgArticulationCourses_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.Item is GridGroupHeaderItem)
            {
                GridGroupHeaderItem groupHeader = (GridGroupHeaderItem)e.Item;
                {
                    groupHeader.DataCell.Text = groupHeader.DataCell.Text.Split(':')[1].ToString();
                }
            }
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ChildGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
    
                Label lbl_articulate_notes = e.Item.FindControl("lblArticulationNotes") as Label;
                lbl_articulate_notes.Visible = false;
                if (dataBoundItem["ArticulationNotes"].Text != "" && dataBoundItem["ArticulationNotes"].Text != "&nbsp;")
                {
                    lbl_articulate_notes.Visible = true;
                    lbl_articulate_notes.ToolTip = dataBoundItem["ArticulationNotes"].Text;
                }
                if (e.Item is GridDataItem && (grid.ID == "rgArticulationCourses"))
                {
                    var dont_articulate = dataBoundItem["articulate"].Text;
                    if (dont_articulate == "False")
                    {
                        //dataBoundItem.BackColor = System.Drawing.Color.LightPink;
                        dataBoundItem.ForeColor = System.Drawing.Color.Black;
                    }
                }
            }
            //if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ParentGrid")
            //{
            //    GridDataItem dataBoundItem = e.Item as GridDataItem;
            //    var ExistInOtherColleges = dataBoundItem["ExistInOtherColleges"].Text;
            //    Label lblExistOtherColleges = e.Item.FindControl("lblExistOtherColleges") as Label;
            //    if (ExistInOtherColleges == "1")
            //    {
            //        lblExistOtherColleges.Visible = true;
            //    }
            //}
        }


        protected void rblSort_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlArticulationCourses.SelectParameters["OrderBy"].DefaultValue = rblSort.SelectedValue;
            rgArticulationCourses.DataBind();
        }

        protected void RadComboBoxStageFilter_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlArticulationCourses.SelectParameters["StageFilter"].DefaultValue = RadComboBoxStageFilter.SelectedValue;
            sqlCourseMatches.SelectParameters["StageFilter"].DefaultValue = RadComboBoxStageFilter.SelectedValue;
            sqlArticulationCourses.DataBind();
            rgArticulationCourses.DataBind();
            if (hfStageID.Value != hfLastStageID.Value)
            {
                if (RadComboBoxStageFilter.SelectedValue == "4")
                {
                    EnableCommandItemButton("btnMoveForward", false);
                }
                else
                {
                    EnableCommandItemButton("btnMoveForward", true);
                }
            } else
            {
                EnableCommandItemButton("btnMoveForward", false);
            }
            EnableArticulationInProcessButtons(Convert.ToInt32(RadComboBoxStageFilter.SelectedValue), (int)norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])));

			GridCommandItem cmdItem = (GridCommandItem)rgArticulationCourses.MasterTableView.GetItems(GridItemType.CommandItem)[0];
            RadButton btnDelete = (RadButton)cmdItem.FindControl("rbDelete");
            if (RadComboBoxStageFilter.SelectedItem.Text == "Faculty" || RadComboBoxStageFilter.SelectedItem.Text == "Articulation Officer" || RadComboBoxStageFilter.SelectedItem.Text == "Implementation")
            {
               // GridCommandItem cmdItem = (GridCommandItem)rgArticulationCourses.MasterTableView.GetItems(GridItemType.CommandItem)[0];
                //RadButton btnDelete = (RadButton)cmdItem.FindControl("rbDelete");
                btnDelete.Enabled = false;

                if ((Convert.ToBoolean(Session["isAdministrator"]) == true || Convert.ToBoolean(Session["SuperUser"]) == true) ||
                        Session["RoleName"].ToString() == "Evaluator" ||
                        Convert.ToBoolean(Session["SuperUser"]) == true ||
                        Session["RoleName"].ToString() == "Ambassador")
                {

                    btnDelete.Enabled = true;

                }

            }
            
			if (RadComboBoxStageFilter.SelectedValue == "0" && (Session["RoleName"].ToString() == "Faculty" || Session["RoleName"].ToString() == "Articulation Officer" || Session["RoleName"].ToString() == "Implementation"))
            {
                btnDelete.Visible = false;
            }
			
        }

        private void EnableArticulationInProcessButtons(int selectedStage, int userStageID)
        {
            if (selectedStage != userStageID)
            {
                EnableCommandItemButton("btnMoveForward", false);
                EnableCommandItemButton("btnReturn", false);
                EnableCommandItemButton("btnDenied", false);
                //EnableCommandItemButton("rbDelete", false);
            } else
            {
                if (selectedStage != 0)
                { 
                    EnableCommandItemButton("btnMoveForward", true);
                    EnableCommandItemButton("btnReturn", false);
                    EnableCommandItemButton("btnDenied", true);
                    // EnableCommandItemButton("rbDelete", false);
                }
            }
        }

        protected void rgArticulations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "EditNotes")
            {
                if (itemDetail["articulation_type"].Text == "1")
                {
                    showAssignArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), false, Convert.ToInt32(itemDetail["ExhibitID"].Text));
                }
                else
                {
                    showAssignOccupationArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), false, Convert.ToInt32(itemDetail["ExhibitID"].Text));
                }
            }

        }

        protected void gridInprocess_PreRender(object sender, EventArgs e)
        {
            //RadGrid grid = (RadGrid)sender;
            //GridCommandItem cmdItem = (GridCommandItem)grid.MasterTableView.GetItems(GridItemType.CommandItem)[0];
            //RadButton excelButton = (RadButton)cmdItem.FindControl("btnExcel");
            //excelButton.ToolTip = "Please Click on the Expand/Collapse button first! All detail rows MUST be expanded to be exported into Excel.";
        }

        protected void rgArticulationCourses_FilterCheckListItemsRequested(object sender, GridFilterCheckListItemsRequestedEventArgs e)
        {
            string DataField = (e.Column as IGridDataColumn).GetActiveDataField();
            string query = "";
            if (DataField == "subject")
            {
                query = string.Format("select s.subject from tblSubjects s where s.college_id = {0} order by s.subject", Session["CollegeID"].ToString());
            }
            if (DataField == "ArtRole")
            {
                query = string.Format("select r.RoleName as 'ArtRole' from Stages s join ROLES r on s.RoleId = r.RoleID where s.CollegeId = {0}", Session["CollegeID"].ToString());
            }

            e.ListBox.DataSource = GetDataTable(query);
            e.ListBox.DataKeyField = DataField;
            e.ListBox.DataTextField = DataField;
            e.ListBox.DataValueField = DataField;
            e.ListBox.DataBind();
        }

        public DataTable GetDataTable(string query)
        {
            DataTable myDataTable = new DataTable();

            String ConnString = ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString;
            SqlConnection conn = new SqlConnection(ConnString);
            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = new SqlCommand(query, conn);

            conn.Open();
            try
            {
                adapter.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }

            return myDataTable;
        }

        protected void rsShowDenied_CheckedChanged(object sender, EventArgs e)
        {
            if (rsShowDenied.Checked == true)
            {
                hvShowDenied.Value = rsShowDenied.ToggleStates.ToggleStateOn.Value;
            }
            else
            {
                hvShowDenied.Value = rsShowDenied.ToggleStates.ToggleStateOff.Value;
            }
            RadComboBoxStageFilter.SelectedValue = "0";
            sqlArticulationCourses.SelectParameters["StageFilter"].DefaultValue = "0";
            sqlCourseMatches.SelectParameters["StageFilter"].DefaultValue = "0";
            sqlArticulationCourses.DataBind();
            sqlCourseMatches.DataBind();
            rgArticulationCourses.DataBind();
            if (hfStageID.Value != hfLastStageID.Value)
            {
                EnableCommandItemButton("btnMoveForward", true);
            } else
            {
                EnableCommandItemButton("btnMoveForward", false);
            }
        }


        protected void btnDontArticulate_Click(object sender, EventArgs e)
        {
            var lbtn = sender as LinkButton;
            var item = lbtn.NamingContainer as GridDataItem;
            var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
            if (userStageID == Convert.ToInt32(item["ArticulationStage"].Text) && Convert.ToInt32(item["ArticulationStatus"].Text) != 2)
            {
                articulations.Clear();
                articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                ConfirmDeny(string.Join(", ", articulations.Select(art => art.Key)), 1000, 700);
            }
        }

        protected void racbAceIDSearch_Entry(object sender, AutoCompleteEntryEventArgs e)
        {
            UpdateAceIDTokens();
        }

        public void UpdateAceIDTokens()
        {
            AceIDList.Clear();
            for (int i = 0; i < racbAceIDSearch.Entries.Count; i++)
            {
                AceIDList.Add(racbAceIDSearch.Entries[i].Value.Trim());
            }
            AceIDList.Distinct().ToList();
            hfAceIDs.Value = string.Join(",", AceIDList);
            RefreshArticulationInprocess();
        }

        public void RefreshArticulationInprocess()
        {
            var a1 = sqlArticulationCourses.SelectParameters["Username"];
            var a2 = sqlArticulationCourses.SelectParameters["RoleID"];
            var a3 = sqlArticulationCourses.SelectParameters["OrderBy"];
            var a4 = sqlArticulationCourses.SelectParameters["StageFilter"];
            var a5 = sqlArticulationCourses.SelectParameters["SelectedCollegeID"];
            var a6 = sqlArticulationCourses.SelectParameters["ShowDenied"];
            var a7 = sqlArticulationCourses.SelectParameters["AceIDs"];
            sqlCourseMatches.DataBind();
            sqlArticulationCourses.DataBind();
            rgArticulationCourses.DataBind();
        }


        public static int CheckFacultyUsersHaveSubjects(int college_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select [dbo].[CheckFacultyUsersHaveSubjects] ({college_id});";
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        public static int CheckEnableApprovalWorkflow(int college_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"SELECT[dbo].[CheckEnableApprovalWorkflow] ({college_id});";
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        private bool IsVRCStaff(string role_id)
        {
            bool result = false;
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand($"SELECT TOP (1) * FROM [dbo].[ROLES] WHERE [RoleID] = {role_id} and VRCStaff = 1", connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    result = true;
                }
                reader.Close();
            }
            return result;
        }

        private bool IsOnlyAmbassador(int userid, int collegid)
        {
            bool result = false;
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand($"select count(ru.RoleID) as total_roles from ROLES_USER ru inner join [dbo].[ROLES] r ON ru.RoleID = r.RoleID  where UserID = {userid} AND (r.RoleName in ('Evaluator', 'Faculty', 'Articulation Officer', 'Implementation'))", connection);
                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        if ((int)reader["total_roles"] == 0)
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