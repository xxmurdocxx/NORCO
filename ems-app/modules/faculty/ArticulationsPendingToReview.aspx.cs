using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.faculty
{
    public partial class ArticulationsPendingToReview : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        Dictionary<int, int> articulations = new Dictionary<int, int>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    if (Request.QueryString["adopt"] == "True" )
                    {
                        RadTabStrip1.SelectedIndex = 4;
                        RadPageView4.Selected = true;
                    }

                    hvExcludeArticulationOverYears.Value = GlobalUtil.ReadSetting("ExcludeArticulationOverYears");
                    hvUserName.Value = Session["UserName"].ToString();
                    hvCollegeID.Value = Session["CollegeID"].ToString();
                    hvUserID.Value = Session["UserID"].ToString();
                    hvUserStage.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])).ToString();
                    hvFirstStage.Value = norco_db.GetMinimumStageId(Convert.ToInt32(Session["CollegeID"])).ToString();
                    hvLastStage.Value = norco_db.GetMaximumStageId(Convert.ToInt32(Session["CollegeID"])).ToString();
                    hvUserStageOrder.Value = norco_db.GetStageOrderByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])).ToString();

                    LoadFacultyReview();

                    sqlFacultyReviewArticulations.DataBind();
                }
                catch (Exception ex)
                {
                    DisplayMessage(true, ex.ToString());
                }
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        public void LoadFacultyReview()
        {
            try
            {
                hvAppID.Value = GlobalUtil.ReadSetting("AppID");

                rgFacultyReviewArticulations.DataBind();
                rgDeniedArticulations.DataBind();
                rgUserLog.DataBind();
                rgArchivedArticulations.DataBind();

                // Load Adopt Articulations control

                AdoptArticulationsViewer.AceID = "";
                AdoptArticulationsViewer.TeamRevd = "";
                AdoptArticulationsViewer.CollegeID = Convert.ToInt32(Session["CollegeID"]);
                AdoptArticulationsViewer.Subject = "";
                AdoptArticulationsViewer.CourseNumber = "";
                AdoptArticulationsViewer.ByACEID = false;
                AdoptArticulationsViewer.ByCourseSubject = false;
                AdoptArticulationsViewer.ExcludeAdopted = true;
                AdoptArticulationsViewer.ExcludeDenied = true;
                AdoptArticulationsViewer.ExcludeArticulationOverYears = Convert.ToInt32(GlobalUtil.ReadSetting("ExcludeArticulationOverYears"));
                AdoptArticulationsViewer.RoleID = Convert.ToInt32(Session["RoleID"]);
                AdoptArticulationsViewer.UserName = Session["UserName"].ToString();
                AdoptArticulationsViewer.UserID = Convert.ToInt32(Session["UserID"]);
                AdoptArticulationsViewer.OnlyImplemented = false;
                AdoptArticulationsViewer.BySubjectCourseCIDNumber = false;
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }
        }

        public void NotifyPopup(string action, int user_stage_id, string user_name, int user_id, int college_id, int width, int height)
        {
            var url = String.Format("../popups/Notify.aspx?Action={0}&UserStageID={1}&UserName={2}&UserID={3}&CollegeID={4}", action, user_stage_id, user_name, user_id, college_id, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, Telerik.Web.UI.AjaxRequestEventArgs e)
        {
            LoadFacultyReview();
        }

        protected void rgFacultyReviewArticulations_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            try
            {
                var user_stage_id = Convert.ToInt32(hvUserStage.Value);
                var user_name = hvUserName.Value;
                var user_id = Convert.ToInt32(hvUserID.Value);
                var college_id = Convert.ToInt32(hvCollegeID.Value);

                if (e.CommandName == "MoveForward" || e.CommandName == "Return" || e.CommandName == "Denied" || e.CommandName == "Archive" || e.CommandName == "ShowAcePopup" || e.CommandName == "Delete")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Select an Articulation.");
                    }
                    else
                    {

                        if (grid.ID == "rgFacultyReviewArticulations")
                        {

                            foreach (GridDataItem item in grid.SelectedItems)
                            {
                                articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                            }
                            if (e.CommandName == "Denied")
                            {
                                ConfirmDeny(string.Join(", ", articulations.Select(art => art.Key)), 1100, 700);
                            }
                        }
                        Session["articulationList"] = articulations;
                        switch (e.CommandName)
                        {
                            case "MoveForward":
                                NotifyPopup("MoveForward", user_stage_id, user_name, user_id, college_id, 1100, 700);
                                break;
                            case "Return":
                                NotifyPopup("Return", user_stage_id, user_name, user_id, college_id, 1100, 700);
                                break;
                            case "Delete":
                                if (grid.ID == "rgFacultyReviewArticulations")
                                {
                                    foreach (GridDataItem item in grid.SelectedItems)
                                    {
                                        var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
                                        if (Convert.ToInt32(item["ArticulationStage"].Text) == userStageID)
                                        {
                                            GlobalUtil.DeleteArticulation(Convert.ToInt32(item["id"].Text), Convert.ToInt32(Session["UserID"]));
                                        }
                                    }
                                }
                                rgFacultyReviewArticulations.DataBind();
                                break;
                            case "Archive":
                                NotifyPopup("Archive", user_stage_id, user_name, user_id, college_id, 1100, 700);
                                break;
                            case "ShowAcePopup":
                                var url = "";
                                if (itemDetail["ArticulationType"].Text == "1")
                                {
                                    url = String.Format("../popups/ShowACECourseDetail.aspx?AceID={0}&TeamRevd={1}&Title={2}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Title"].Text);

                                } else
                                {
                                    url = String.Format("../popups/ShowOccupation.aspx?AceID={0}&TeamRevd={1}&Occupation={2}&Title={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Occupation"].Text, itemDetail["Title"].Text);
                                }
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, 900, 700));
                                break;
                            default:
                                break;
                        }
                    }
                }

                if (e.CommandName == "ViewAdoptedArticulation" && grid.ID == "rgOtherCollegeArticulations")
                {
                    showArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["ArticulationType"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), true, Convert.ToInt32(itemDetail["CollegeID"].Text), true, itemDetail["College"].Text, "NewTab", 0, 0, Convert.ToInt32(itemDetail["ExhibitID"].Text));
                }

                if (e.CommandName == "AdoptArticulations")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Please select an item");
                    }
                    else
                    {
                        var AceID = itemDetail["AceID"].Text;
                        var TeamRevd = itemDetail["TeamRevd"].Text;
                        var CollegeID = Session["CollegeID"].ToString();
                        var url = String.Format("../popups/AdoptArticulations.aspx?CollegeID={0}&AceID={1}&TeamRevd={2}", CollegeID, AceID, TeamRevd);
                        RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 1200, 650));
                    }
                }


            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
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
            Session["articulationList"] = articulations;
            var user_stage_id = Convert.ToInt32(hvUserStage.Value);
            var user_name = hvUserName.Value;
            var user_id = Convert.ToInt32(hvUserID.Value);
            var college_id = Convert.ToInt32(hvCollegeID.Value);
            var id = Convert.ToInt32(hvID.Value);
            var outline_id = Convert.ToInt32(hvOutlineID.Value);
            var team_revd = Convert.ToDateTime(hvTeamRevd.Value);
            var articulation_type = Convert.ToInt32(hvArticulationType.Value);
            var exhibit_id = Convert.ToInt32(hvExhibitID.Value);
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
                    case "Deny":
                        foreach (GridDataItem item in rgFacultyReviewArticulations.SelectedItems)
                        {
                            articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                        }
                        ConfirmDeny(string.Join(", ", articulations.Select(art => art.Key)), 1100, 700);
                        break;
                    case "Delete":
                            foreach (GridDataItem item in rgFacultyReviewArticulations.SelectedItems)
                            {
                                var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
                                if (Convert.ToInt32(item["ArticulationStage"].Text) == userStageID)
                                {
                                    GlobalUtil.DeleteArticulation(Convert.ToInt32(item["id"].Text), Convert.ToInt32(Session["UserID"]));
                                }
                            }
                            rgFacultyReviewArticulations.DataBind();
                        break;
                    default:
                        foreach (GridDataItem item in rgFacultyReviewArticulations.SelectedItems)
                        {
                            articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                        }
                        //articulations.Add(id,0);
                        NotifyPopup(e.Item.Value, user_stage_id, user_name, user_id, college_id, 1100, 700);
                        break;
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }

        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();

            HttpCookie cookie1 = new HttpCookie(FormsAuthentication.FormsCookieName, "");
            cookie1.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie1);

            SessionStateSection sessionStateSection = (SessionStateSection)WebConfigurationManager.GetSection("system.web/sessionState");
            HttpCookie cookie2 = new HttpCookie(sessionStateSection.CookieName, "");
            cookie2.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie2);
            Response.Redirect("ArticulaTionsPendingToReview.aspx");
        }

        protected void rgFacultyReviewArticulations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridCommandItem && grid.ID == "rgFacultyReviewArticulations")
            {
                GridCommandItem cmditem = (GridCommandItem)e.Item;
                if (hvUserStage.Value == hvFirstStage.Value)
                {
                    RadButton return_button = (RadButton)cmditem.FindControl("btnReturn");
                    return_button.Enabled = false;
                }
                if (hvUserStage.Value == hvLastStage.Value)
                {
                    RadButton approve_button = (RadButton)cmditem.FindControl("btnMoveForward");
                    approve_button.Enabled = false;
                }
            }
            if (e.Item is GridDataItem && (grid.ID == "rgDeniedArticulations"))
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var dont_articulate = dataBoundItem["Articulate"].Text;
                if (dont_articulate == "False")
                {
                    //dataBoundItem.BackColor = System.Drawing.Color.LightPink;
                    dataBoundItem.ForeColor = System.Drawing.Color.Black;
                }
            }
            if (e.Item is GridDataItem && (grid.ID == "rgFacultyReviewArticulations" || grid.ID == "rgDeniedArticulations" || grid.ID == "rgArchivedArticulations"))
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                Label lbl_articulate_notes = e.Item.FindControl("lblArticulationNotes") as Label;
                if (dataBoundItem["ArticulationNotes"].Text != "")
                {
                    lbl_articulate_notes.Visible = true;
                    lbl_articulate_notes.ToolTip = dataBoundItem["ArticulationNotes"].Text;
                }

                if (grid.ID == "rgFacultyReviewArticulations")
                {
                    //grid.MasterTableView.GetColumn("CreatedOn").Display = false;
                    //grid.MasterTableView.GetColumn("LastSubmitted").Display = false;
                    //if (hvUserStage.Value == hvFirstStage.Value)
                    //{
                    //    grid.MasterTableView.GetColumn("CreatedOn").Display = true;
                    //}
                    //else
                    //{
                    //    grid.MasterTableView.GetColumn("LastSubmitted").Display = true;
                    //}
                    int haveDeniedArticulations = Convert.ToInt32(dataBoundItem["HaveDeniedArticulations"].Text);
                    int ArticulationsInOtherColleges = Convert.ToInt32(dataBoundItem["ArticulationsInOtherColleges"].Text);
                    LinkButton btnHaveDeniedArticulations = e.Item.FindControl("btnHaveDeniedArticulations") as LinkButton;
                    LinkButton btnArticulationsInOtherColleges = e.Item.FindControl("btnArticulationsInOtherColleges") as LinkButton;
                    btnHaveDeniedArticulations.Visible = false;
                    btnArticulationsInOtherColleges.Visible = false;
                    if (haveDeniedArticulations > 0)
                    {
                        btnHaveDeniedArticulations.Visible = true;
                        btnHaveDeniedArticulations.Style.Add("color", "#ff0000");
                    }
                    else
                    {
                        if (ArticulationsInOtherColleges > 0)
                        {
                            btnArticulationsInOtherColleges.Visible = true;
                        }
                    }
                }

            }
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ParentGrid" && grid.ID == "rgOtherCollegeArticulations")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                dataBoundItem.BackColor = System.Drawing.Color.LightGreen;
                var adopted = dataBoundItem["adopted"].Text;
                if (adopted == "True")
                {
                    CheckBox chkbx = (CheckBox)dataBoundItem["ClientSelectColumn"].Controls[0];
                    chkbx.Enabled = false;
                    dataBoundItem.BackColor = System.Drawing.Color.LightBlue;
                }
                var dont_articulate = dataBoundItem["Articulate"].Text;
                if (dont_articulate == "False")
                {
                    //dataBoundItem.BackColor = System.Drawing.Color.LightPink;
                    dataBoundItem.ForeColor = System.Drawing.Color.Black;
                }
            }
        }

        protected void rbHomepage_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/modules/dashboard/Default.aspx");
        }

        public void ConfirmDeny(string articulation_list, int width, int height)
        {
            var url = String.Format("/modules/popups/ConfirmDenyArticulation.aspx?ArticulationList={0}", articulation_list, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        protected void rgDeniedArticulations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "ViewArticulation")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select an articulation.");
                }
                else
                {
                    showArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["ArticulationType"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), false, 0, false, "", "NewTab", 0, 0, Convert.ToInt32(itemDetail["ExhibitID"].Text));
                }
            }
            if (e.CommandName == "DontArticulate")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select an articulation.");
                }
                else
                {
                    if (itemDetail["ArticulationStatus"].Text == "2")
                    {
                        DisplayMessage(true, Resources.Messages.CannotModifyArticulationPublished);
                    }
                    else
                    {
                        try
                        {
                            norco_db.DontArticulate(Convert.ToInt32(itemDetail["ArticulationID"].Text), Convert.ToInt32(itemDetail["ArticulationType"].Text), Convert.ToInt32(Session["UserID"]));
                            rgDeniedArticulations.DataBind();
                        }
                        catch (Exception ex)
                        {
                            DisplayMessage(true, ex.ToString());
                        }
                    }
                }
            }
        }

        protected void rgArchivedArticulations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            try
            {
                var user_stage_id = Convert.ToInt32(hvUserStage.Value);
                var user_name = hvUserName.Value;
                var user_id = Convert.ToInt32(hvUserID.Value);
                var college_id = Convert.ToInt32(hvCollegeID.Value);

                if (e.CommandName == "Archive")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Select an Articulation.");
                    }
                    else
                    {
                        foreach (GridDataItem item in grid.SelectedItems)
                        {
                            if (grid.ID == "rgArchivedArticulations")
                            {
                                articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                            }
                        }
                        Session["articulationList"] = articulations;
                        switch (e.CommandName)
                        {
                            case "Archive":
                                NotifyPopup("Archive", user_stage_id, user_name, user_id, college_id, 1100, 700);
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

        protected void rgUserLog_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "ViewArticulation")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select an articulation.");
                }
                else
                {
                    showArticulation(Convert.ToInt32(itemDetail["Id"].Text), Convert.ToInt32(itemDetail["articulation_type"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), false, 0, false, "", "NewTab", 0, 0, Convert.ToInt32(itemDetail["ExhibitID"].Text));
                }
            }
        }
    }
}