using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.Data;					   
using Telerik.Web.UI;

namespace ems_app.modules.military
{
    public partial class Articulate : System.Web.UI.Page
    {


        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rcbServices.DataBind();
                rcbLocationService.DataBind();
                rcbCriteriaService.DataBind();
                rcbOccupations.DataBind();
                if (Session["program_id"] != null)
                {
                    rcbPrograms.SelectedValue = Session["program_id"].ToString();
                    sqlRecommended.DataBind();
                    sqlRequired.DataBind();
                    rgRecommended.DataBind();
                    rgRequired.DataBind();
                    rgCollegeCourses.DataBind();
                }
                //Set ExcludeArticulationOverYears hidden value from web.config file
                //hfExcludeArticulationOverYears.Value = GlobalUtil.ReadSetting("ExcludeArticulationOverYears");
                hfExcludeArticulationOverYears.Value = "200";
                rchkExcludeYears.Checked = false;
                rcbExcludeCredRecommendations.Checked = true;
                rchkExcludeYears.Text += string.Format(" {0} years.", GlobalUtil.ReadSetting("ExcludeArticulationOverYears"));
                hfAdvancedSarch.Value = "";
                hfACECourseAdvancedSearch.Value = "";
                hfCollegeID.Value = Session["CollegeID"].ToString();
                //Set Search recommendation as true by default for Occupations
                rchkSearchRecommendationsOcc.Checked = true;
                rchkSearchRecommendations.Checked = true;

                sqlACECourses.SelectParameters["CollegeID"].DefaultValue = hfCollegeID.Value;
                sqlACECourses.SelectParameters["occupation"].DefaultValue = "";
                sqlACECourses.SelectParameters["occupation"].ConvertEmptyStringToNull = false;
                sqlACECourses.SelectParameters["SearchRecommendations"].DefaultValue = rchkSearchRecommendations.Checked.ToString();
                sqlACECourses.SelectParameters["attribute"].DefaultValue = "";
                sqlACECourses.SelectParameters["attribute"].ConvertEmptyStringToNull = false;
                sqlACECourses.SelectParameters["ExcludeArticulationOverYears"].DefaultValue = hfExcludeArticulationOverYears.Value;
                sqlACECourses.DataBind();
                rgACECourses.DataBind();

                sqlAllOccupations.SelectParameters["CollegeID"].DefaultValue = hfCollegeID.Value;
                sqlAllOccupations.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbServices");
                sqlAllOccupations.SelectParameters["SearchRecommendations"].DefaultValue = rchkSearchRecommendationsOcc.Checked.ToString();
                sqlAllOccupations.SelectParameters["attribute"].DefaultValue = hfAdvancedSarch.Value;
                sqlAllOccupations.SelectParameters["attribute"].ConvertEmptyStringToNull = false;
                sqlAllOccupations.SelectParameters["ExcludeArticulationOverYears"].DefaultValue = hfExcludeArticulationOverYears.Value;
                sqlAllOccupations.SelectParameters["Occupation"].DefaultValue = null;
                if (Request.QueryString["Occupation"] != null)
                {
                    sqlAllOccupations.SelectParameters["Occupation"].DefaultValue = Request.QueryString["Occupation"];
                }
                sqlAllOccupations.DataBind();
                rgACEOccupations.DataBind();

                sqlLocationList.SelectParameters["Location"].DefaultValue = "";
                sqlLocationList.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbLocationService");
                sqlLocationList.SelectParameters["ExcludeArticulationOverYears"].DefaultValue = hfExcludeArticulationOverYears.Value;
                sqlLocationList.DataBind();
                rgLocations.DataBind();

                //sqlCriteriaDisciplines.SelectParameters["SubjectList"].DefaultValue = "";
                //sqlCriteriaDisciplines.DataBind();
                //rgCriteria.DataBind();
            }
        }

        protected string courseDescription(GridDataItem dataItem)
        {
            var courseTitle = DataBinder.Eval(dataItem.DataItem, "course_title");
            var cGroup = (int)DataBinder.Eval(dataItem.DataItem, "c_group");
            var outlineID = (int)DataBinder.Eval(dataItem.DataItem, "outline_id");
            var groupName = DataBinder.Eval(dataItem.DataItem, "group_desc");
            int required = (int)DataBinder.Eval(dataItem.DataItem, "required");
            var groupTotal = DataBinder.Eval(dataItem.DataItem, "group_total");
            var groupDescription = "";
            var tabx1 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            var tabx2 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            if (courseTitle != null)
            {
                if (groupName.ToString() == "")
                {
                    if (required == 2)
                    {
                        if (cGroup > 0 && outlineID > 0)
                        {
                            return tabx1 + courseTitle.ToString();
                        }
                    }
                    if (required == 1)
                    {
                        if (cGroup > 0 && outlineID > 0)
                        {
                            return tabx1 + courseTitle.ToString();
                        }
                    }
                    if (required == 3 && (cGroup > 0 && outlineID > 0))
                    {
                        return tabx2 + courseTitle.ToString();
                    }
                    else
                    {
                        return courseTitle.ToString();
                    }
                }
                else
                {
                    if (required == 3)
                    {
                        groupDescription = "<b>" + groupName.ToString() + " - Total Units : " + groupTotal.ToString() + "</b>";
                        if (cGroup > 0 && outlineID == 0)
                        {
                            groupDescription = tabx1 + groupDescription;
                        }
                        else if (cGroup > 0 && outlineID > 0)
                        {
                            groupDescription = tabx2 + groupDescription;
                        }
                        return groupDescription;
                    }
                    else
                    {
                        return "<b>" + groupName.ToString() + "</b>";
                    }
                }
            }
            else
            {
                return "";
            }
        }

        protected void rgACEOccupations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && ( e.Item.OwnerTableView.Name == "ParentGrid" ) )
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int occupationHaveCourses = Convert.ToInt32(dataBoundItem["HaveRelatedCourses"].Text);
                Label btnOccupationHaveCourses = e.Item.FindControl("btnOccupationHaveCourses") as Label;
                if (occupationHaveCourses > 0)
                {
                    btnOccupationHaveCourses.Style.Add("color", "#698637");
                }
                else
                {
                    btnOccupationHaveCourses.Visible = false;
                }
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
            if (e.Item is GridDataItem && ( e.Item.OwnerTableView.Name == "ChildGrid") )
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                Label lbl_dont_articulate = e.Item.FindControl("lblArticulate") as Label;
                var dont_articulate = dataBoundItem["Articulate"].Text;
                if (dont_articulate == "False")
                {
                    lbl_dont_articulate.Visible = true;
                    //dataBoundItem.BackColor = System.Drawing.Color.LightPink;
                    dataBoundItem.ForeColor = System.Drawing.Color.Black;
                    dataBoundItem.Font.Bold = true;
                    lbl_dont_articulate.ToolTip = dataBoundItem["DeniedComments"].Text;
                }
                dataBoundItem.ToolTip = string.Format("This articulation is on {0} stage.", dataBoundItem["RoleName"].Text);
            }
        }

        public void SearchAttribute()
        {
            hfACECourseAdvancedSearch.Value = racACECourseAttribute.Text;
            if (racACECourseAttribute.Text != "")
            {
                int existSmartKeyword = norco_db.CheckExistSmartKeyword(racACECourseAttribute.Text, 2);
                if (existSmartKeyword == 0)
                {
                    panelSmartKeys.Visible = true;
                }
            }
            sqlACECourses.DataBind();
            rgACECourses.DataBind();
        }


        protected void rtbAttribute_TextChanged(object sender, EventArgs e)
        {
            SearchAttribute();
        }

        protected void rbSearchAttribute_Click(object sender, EventArgs e)
        {
            SearchAttribute();
        }

        protected void rbClearAttribute_Click(object sender, EventArgs e)
        {
            sqlACECourses.DataBind();
            racACECourseAttribute.Entries.Clear();
            rgACECourses.DataBind();
            rcbOccupations.ClearSelection();
            rtbAttribute.Text = "";
        }

        protected void rtbOccAttribute_TextChanged(object sender, EventArgs e)
        {
            SearchOccAttribute();
        }

        protected void rbSearchOccAttribute_Click(object sender, EventArgs e)
        {
            SearchOccAttribute();
        }


        public void SearchOccAttribute()
        {
            hfAdvancedSarch.Value = racAdvanceSearch.Text;
            if (racAdvanceSearch.Text != "")
            {
                int existSmartKeyword = norco_db.CheckExistSmartKeyword(racAdvanceSearch.Text, 2);
                if (existSmartKeyword == 0)
                {
                    panelSmartKeys.Visible = true;
                }
            }
            sqlAllOccupations.DataBind();
            rgACEOccupations.DataBind();
        }
        protected void rbClearOccAttribute_Click(object sender, EventArgs e)
        {
            sqlAllOccupations.SelectParameters["Occupation"].DefaultValue = null;
            hfAdvancedSarch.Value = "";
            sqlAllOccupations.DataBind();
            racAdvanceSearch.Entries.Clear();
            rgACEOccupations.DataBind();
        }

        protected void rcbMatchingFactor_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (selectedRowValue.Text == "")
            {
                GetSimilarities(Convert.ToInt32(rcbPrograms.SelectedValue), Convert.ToInt32(rcbMatchingFactor.SelectedValue), Convert.ToInt32(rcbAttribute.SelectedValue), null);
            }
            else
            {
                GetSimilarities(null, Convert.ToInt32(rcbMatchingFactor.SelectedValue), Convert.ToInt32(rcbAttribute.SelectedValue), Convert.ToInt32(selectedRowValue.Text));
            }
        }

        protected void rbAddSmartKeyword_Click(object sender, EventArgs e)
        {
            try
            {
                norco_db.AddSmartKeyword(racAdvanceSearch.Text, 2);
                panelSmartKeys.Visible = false;
                sqlSmartKeywords.DataBind();
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
            }
        }

        protected void rbCancelSkartKeyword_Click(object sender, EventArgs e)
        {
            panelSmartKeys.Visible = false;
        }

        protected void rcbServices_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlAllOccupations.SelectParameters["Service"].DefaultValue = SetSelectedIndexChange("rcbServices");
        }

        public String PreRenderComboBox(string controlID)
        {
            RadComboBox listBox = (RadComboBox)FindControlRecursive(Page, controlID);
            var data = "";
            foreach (RadComboBoxItem itm in listBox.Items)
            {
                itm.Checked = true;

                int itemschecked = listBox.CheckedItems.Count;
                String[] DataFieldsArray = new String[itemschecked];
                var collection = listBox.CheckedItems;
                int i = 0;
                foreach (var item in collection)
                {
                    String value = item.Value;
                    DataFieldsArray[i] = value;
                    i++;
                }
                data = String.Join(",", DataFieldsArray);
            }
            return data;
        }

        private Control FindControlRecursive(Control rootControl, string controlID)
        {
            if (rootControl.ID == controlID) return rootControl;

            foreach (Control controlToSearch in rootControl.Controls)
            {
                Control controlToReturn = FindControlRecursive(controlToSearch, controlID);
                if (controlToReturn != null) return controlToReturn;
            }
            return null;
        }

        public String SetSelectedIndexChange(string controlID)
        {
            RadComboBox listBox = (RadComboBox)FindControlRecursive(Page, controlID);
            int itemschecked = listBox.CheckedItems.Count;
            String[] DataFieldsArray = new String[itemschecked];
            var collection = listBox.CheckedItems;
            int i = 0;
            foreach (var item in collection)
            {
                String value = item.Value;
                DataFieldsArray[i] = value;
                i++;
            }
            return String.Join(",", DataFieldsArray);
        }

        protected void rcbServices_PreRender(object sender, EventArgs e)
        {
            base.OnPreRender(e);
            if (!IsPostBack)
            {
                sqlAllOccupations.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbServices");
            }
        }

        protected void rgSimilarities_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ParentGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int HaveArticulatedCourses = Convert.ToInt32(dataBoundItem["HaveArticulatedCourses"].Text);
                Label btnHaveArticulatedCourses = e.Item.FindControl("btnHaveArticulatedCourses") as Label;
                if (HaveArticulatedCourses == 1)
                {
                    btnHaveArticulatedCourses.Style.Add("color", "#698637");
                }
                else
                {
                    btnHaveArticulatedCourses.Visible = false;
                }
            }
        }

        protected void ACEOccupations_RowDrop(object sender, GridDragDropEventArgs e)
        {
            int outline_id = 0;
            int draggedRows = 0;
            int haveOccupations = 0;
            int isPublished = 0;
            Hashtable values = new Hashtable();
            string id = "";
            DateTime teamrevd = new DateTime();
            string title = "";
            var subject = "";
            var units = 0.0;
            var course_number = "";
            var course_title = "";

            if (e.DestDataItem != null)
            {
                if (e.DestinationTableView.OwnerGrid.ClientID == rgRequired.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgRecommended.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgCollegeCourses.ClientID)
                {
                    if (e.DestDataItem != null)
                    {
                        foreach (GridDataItem draggedItem in e.DraggedItems)
                        {
                            draggedItem.ExtractValues(values);
                            id = (string)values["AceID"];
                            teamrevd = Convert.ToDateTime((string)values["TeamRevd"]);
                            title = (string)values["Title"];
                            draggedRows = e.DraggedItems.Count();

                            outline_id = (int)e.DestDataItem.GetDataKeyValue("outline_id");
                            if (outline_id > 0)
                            {
                                var course = norco_db.GetCourseInformation(outline_id);
                                foreach (GetCourseInformationResult item in course)
                                {
                                    subject = item.subject;
                                    course_number = item.course_number;
                                    units = Convert.ToDouble(item._Units);
                                    course_title = item.course_title;
                                }
                                var existOtherColleges = norco_db.CheckArticulationExistOtherColleges(Convert.ToInt32(Session["CollegeID"]), subject, course_number, id, teamrevd);
                                if (existOtherColleges == true)
                                {
                                    //DisplayMessage(false, "Articulation exist in other colleges, please contact Faculty");
                                    var url = String.Format("../popups/OtherCollegesArticulations.aspx?subject={0}&course_number={1}&course_title={2}&college_id={3}&AceID={4}&TeamRevd={5}&exist=true", subject, course_number, course_title, Session["CollegeID"].ToString(),id,teamrevd);
                                    //ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + url + "');", true);
                                    RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 1000, 600));
                                }
                                else
                                {
                                    //if ( units <= Convert.ToDouble(GlobalUtil.ReadSetting("MinimunUnitsToArticulate")) )
                                    if (norco_db.CheckIsDisabledForArticulate(outline_id) == true )
                                    {
                                        DisplayMessage(false, GlobalUtil.ReadSetting("DisableArticulateMessage") );
                                    }
                                    else
                                    {
                                        if (draggedRows == 1)
                                        {
                                            haveOccupations = norco_db.CheckCollegeCourseHaveOccupations(outline_id, id, teamrevd, Convert.ToInt32(Session["CollegeID"]));
                                            if (haveOccupations == 1)
                                            {
                                                DisplayMessage(false, "Occupation already exist.");
                                            }
                                            else
                                            {
                                                showNewAssignOccupationArticulation(outline_id, id, title, teamrevd,2);
                                                break;
                                            }
                                        }
                                        else
                                        {
                                            norco_db.AddMultipleOccupationArticulation(outline_id, id, teamrevd, title, null, null, Convert.ToInt32(Session["UserID"].ToString()), Convert.ToInt32(Session["CollegeID"].ToString()));
                                        }
                                    }
                                }
                            }
                            else
                            {
                                DisplayMessage(false, Resources.Messages.CantDropItem);
                            }
                        }
                        if (draggedRows > 1)
                        {
                            try
                            {
                                // EMAIL Notification
                                //string from = GlobalUtil.ReadSetting("SystemNotificationEmail");
                                //GlobalUtil.NotifyNewArticulations(Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), outline_id, from);
                            }
                            catch (Exception ex)
                            {
                                DisplayMessage(true, ex.Message.ToString());
                            }
                        }
                        rgRecommended.DataBind();
                        rgRequired.DataBind();
                        rgCollegeCourses.DataBind();
                        rgACEOccupations.DataBind();
                        rgACECourses.DataBind();
                    }
                    else
                    {
                        DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
                    }
                }
                else
                {
                    DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
                }
            }
        }

        protected void ACECourses_RowDrop(object sender, GridDragDropEventArgs e)
        {
            int outline_id = 0;
            GridDataItem dataItem = e.DraggedItems[0];
            Hashtable values = new Hashtable();
            dataItem.ExtractValues(values);
            string id = (string)values["AceID"];
            string title = (string)values["Title"];
            DateTime teamrevd = Convert.ToDateTime((string)values["TeamRevd"]);
            var subject = "";
            var course_number = "";
            var units = 0.0;
            var course_title = "";

            if (e.DestDataItem != null)
            {
                if (e.DestinationTableView.OwnerGrid.ClientID == rgRequired.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgRecommended.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgCollegeCourses.ClientID)
                {
                    if (e.DestDataItem != null)
                    {
                        if (e.DestinationTableView.OwnerGrid.ClientID == rgCollegeCourses.ClientID)
                        {
                            outline_id = (int)e.DestDataItem.GetDataKeyValue("outline_id");
                        }
                        else
                        {
                            outline_id = norco_db.GetCourseArticulationOutlineID((int)e.DestDataItem.GetDataKeyValue("programcourse_id"));
                        }

                        if (outline_id > 0)
                        {
                            var course = norco_db.GetCourseInformation(outline_id);
                            foreach (GetCourseInformationResult item in course)
                            {
                                subject = item.subject;
                                course_number = item.course_number;
                                units = Convert.ToDouble(item._Units);
                            }
                            var existOtherColleges = norco_db.CheckArticulationExistOtherColleges( Convert.ToInt32(Session["CollegeID"]), subject,course_number,id,teamrevd);
                            if (existOtherColleges == true)
                            {
                                //DisplayMessage(false, "Articulation exist in other colleges, please contact Faculty");
                                var url = String.Format("../popups/OtherCollegesArticulations.aspx?subject={0}&course_number={1}&course_title={2}&college_id={3}&AceID={4}&TeamRevd={5}&exist=true", subject, course_number, course_title, Session["CollegeID"].ToString(), id, teamrevd);
                                //ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + url + "');", true);
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 1000, 600));
                            }
                            else
                            {
                                //if ( units <= Convert.ToDouble(GlobalUtil.ReadSetting("MinimunUnitsToArticulate")) )
                                if (norco_db.CheckIsDisabledForArticulate(outline_id) == true)
                                {
                                    DisplayMessage(false, GlobalUtil.ReadSetting("DisableArticulateMessage"));
                                }
                                else
                                {
                                    int exist = norco_db.CheckExistArticulation(outline_id, id, teamrevd);
                                    if (exist == 0)
                                    {
                                        showNewAssignArticulation(outline_id, id, title, teamrevd,1);
                                    }
                                    else
                                    {
                                        DisplayMessage(false, Resources.Messages.ArticulationExist);
                                    }
                                }
                            }
                        }
                        else
                        {
                            DisplayMessage(false, Resources.Messages.CantDropItem);
                        }
                    }
                    rgRecommended.DataBind();
                    rgRequired.DataBind();
                    rgCollegeCourses.DataBind();
                    rgACEOccupations.DataBind();
                    rgACECourses.DataBind();
                }
                else
                {
                    DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
                }
            }
            else
            {
                DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
            }
        }

        public void sendEmailNewArticulation(Int32 outline_id)
        {
            try
            {
                // EMAIL Notification
                GlobalUtil.NotifyNewArticulations(Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), outline_id, GlobalUtil.ReadSetting("SystemNotificationEmail"));
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
            }
        }

        public void showNewAssignArticulation(Int32 outline_id, String AceID, String Title, DateTime TeamRevd, int SourceID)
        {
            try
            {
                var articulationId = 0;
                articulationId = Controllers.Articulation.AddArticulation(outline_id, AceID, TeamRevd, Title, "", "", "", "",  1, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]),false,SourceID,false,9999999);
                //var crossListing = norco_db.GetCrossListingCourses(outline_id);
                //foreach (GetCrossListingCoursesResult item in crossListing)
                //{
                //    var exist = norco_db.GetCrossListingNoArticulations(item.outline_id, AceID, TeamRevd, 1, 1);
                //    if (exist == false)
                //    {
                //        Controllers.Articulation.AddArticulation(item.outline_id, AceID, TeamRevd, Title, "", "", "", "", 1, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]),false);
                //    }
                //}
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "ArticulationCreated();window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", articulationId , outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
                // Disable send email when creating new articulations -- 29Oct2019
                //sendEmailNewArticulation(outline_id);
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
            }
        }

        public void showNewAssignOccupationArticulation(Int32 outline_id, String AceID, String Title, DateTime TeamRevd, int SourceID)
        {
            try
            {
                var articulationId = 0;
                articulationId = Controllers.Articulation.AddArticulation(outline_id, AceID, TeamRevd, Title, "", "", "", "", 2, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]),false,SourceID,false,9999999);
                //if Cross Listing courses exists
                //var crossListing = norco_db.GetCrossListingCourses(outline_id);
                //foreach (GetCrossListingCoursesResult item in crossListing)
                //{
                //    var exist = norco_db.GetCrossListingNoArticulations(item.outline_id, AceID, TeamRevd, 2, 1);
                //    if (exist == false)
                //    {
                //        Controllers.Articulation.AddArticulation(item.outline_id, AceID, TeamRevd, Title, "", "", "", "", 2, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]),false);
                //    }
                //}
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "ArticulationCreated();window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", articulationId.ToString() , outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
                // Disable send email when creating new articulations -- 29Oct2019
                //sendEmailNewArticulation(outline_id);
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
            }
        }

        public void showAssignArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd)
        {
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
        }

        public void showAssignOccupationArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd)
        {
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
        }

        protected void rgACECourses_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ParentGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int HaveArticulatedCourses = Convert.ToInt32(dataBoundItem["HaveArticulatedCourses"].Text);
                Label btnHaveArticulatedCourses = e.Item.FindControl("btnHaveArticulatedCourses") as Label;
                if (HaveArticulatedCourses == 1)
                {
                    btnHaveArticulatedCourses.Style.Add("color", "#698637");
                }
                else
                {
                    btnHaveArticulatedCourses.Visible = false;
                }
                int haveDeniedArticulations = Convert.ToInt32(dataBoundItem["HaveDeniedArticulations"].Text);
                LinkButton btnHaveDeniedArticulations = e.Item.FindControl("btnHaveDeniedArticulations") as LinkButton;
                btnHaveDeniedArticulations.Visible = false;
                if (haveDeniedArticulations > 0)
                {
                    btnHaveDeniedArticulations.Visible = true;
                    btnHaveDeniedArticulations.Style.Add("color", "#ff0000");
                }
            }

            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ChildGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                Label lbl_dont_articulate = e.Item.FindControl("lblArticulate") as Label;
                var dont_articulate = dataBoundItem["Articulate"].Text;
                if (dont_articulate == "False")
                {
                    lbl_dont_articulate.Visible = true;
                    //dataBoundItem.BackColor = System.Drawing.Color.LightPink;
                    dataBoundItem.ForeColor = System.Drawing.Color.Black;
                    dataBoundItem.Font.Bold = true;
                    lbl_dont_articulate.ToolTip = dataBoundItem["DeniedComments"].Text;
                }
                dataBoundItem.ToolTip = string.Format("This articulation is on {0} stage.", dataBoundItem["RoleName"].Text);
            }

        }

        protected void rcbAttribute_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (selectedRowValue.Text == "")
            {
                GetSimilarities(Convert.ToInt32(rcbPrograms.SelectedValue), Convert.ToInt32(rcbMatchingFactor.SelectedValue), Convert.ToInt32(rcbAttribute.SelectedValue), null);
            }
            else
            {
                GetSimilarities(null, Convert.ToInt32(rcbMatchingFactor.SelectedValue), Convert.ToInt32(rcbAttribute.SelectedValue), Convert.ToInt32(selectedRowValue.Text));
            }
        }

        protected void rcheckSimilarPrograms_CheckedChanged(object sender, EventArgs e)
        {
            pnlSimilar.Visible = false;
            if (rcheckSimilarPrograms.Checked == true)
            {
                if (rcbPrograms.SelectedValue != "")
                {
                    if (Convert.ToInt32(rcbPrograms.SelectedValue) > 0)
                    {
                        GetSimilarities(Convert.ToInt32(rcbPrograms.SelectedValue), Convert.ToInt32(rcbMatchingFactor.SelectedValue), Convert.ToInt32(rcbAttribute.SelectedValue), null);
                        pnlSimilar.Visible = true;
                        pnlACECatalog.Visible = false;
                    }
                }
                else
                {
                    DisplayMessage(true, "First select a program.");
                    rcheckSimilarPrograms.Checked = false;
                }
            }
            else
            {
                pnlACECatalog.Visible = true;
            }
        }


        protected void rcbPrograms_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            GetSimilarities(Convert.ToInt32(rcbPrograms.SelectedValue), Convert.ToInt32(rcbMatchingFactor.SelectedValue), Convert.ToInt32(rcbAttribute.SelectedValue), null);
            selectedRowValue.Text = "";
        }


        protected void ProgramCourses_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item.OwnerTableView.Name == "ChildGrid")
            {
                if (e.CommandName == "EditNotes" || e.CommandName == "EditOccupations")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, Resources.Messages.SelectCourse);
                    }
                    else
                    {
                        GridDataItem itemDetail = (GridDataItem)e.Item;
                        if (itemDetail.OwnerTableView.Name == "ChildGrid")
                            {
                                if (itemDetail.Selected)
                                {
                                    if (e.CommandName == "EditNotes")
                                    {
                                        if (itemDetail["TypeDescription"].Text == "Course")
                                        {
                                            showAssignArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
                                        } else
                                        {
                                            showAssignOccupationArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
                                        }

                                    }
                                    if (e.CommandName == "EditOccupations")
                                    {
                                        RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/ShowOccupations.aspx?AceID={0}&TeamRevd={1}&Title={2}&Exhibit={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Title"].Text, itemDetail["Exhibit"].Text), true, true, false, 1000, 600));
                                    }
                                }
                            }
                    }
                }
            }
            if (e.Item.OwnerTableView.Name == "ParentGrid")
            {
                if (e.CommandName == "OtherCollegesArticulations")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, Resources.Messages.SelectCourse);
                    }
                    else
                    {
                        GridDataItem item = (GridDataItem)grid.MasterTableView.Items[grid.SelectedItems[0].ItemIndex];
                        string subject = item["subject"].Text;
                        string course_number = item["course_number"].Text;
                        string course_title = item["course_title"].Text;
                        var url = String.Format("../popups/OtherCollegesArticulations.aspx?subject={0}&course_number={1}&course_title={2}&college_id={3}", subject, course_number, course_title, Session["CollegeID"].ToString());

                        //ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + url + "');", true);
                        RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 1000, 600));
                    }
                }
            }
        }


        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void ProgramCourses_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ParentGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                LinkButton btnOtherCollegeArticulations = e.Item.FindControl("btnOtherCollegeArticulations") as LinkButton;
                int exist = Convert.ToInt32(dataBoundItem["ExistInOtherColleges"].Text);
                string subject = dataBoundItem["subject"].Text;
                string course_number = dataBoundItem["course_number"].Text;
                btnOtherCollegeArticulations.Visible = false;
                if (exist == 1)
                {
                    btnOtherCollegeArticulations.Visible = true;
                }
                int outline_id = Convert.ToInt32(dataBoundItem["outline_id"].Text);
                //
                Label lbl_DisableArticulate = e.Item.FindControl("lblDisableArticulate") as Label;
                var disable_articulate = dataBoundItem["DisableArticulate"].Text;
                if (disable_articulate == "True")
                {
                    lbl_DisableArticulate.Visible = true;
                    lbl_DisableArticulate.ToolTip = string.Format("<b>Rationale :</b><br>{0}", dataBoundItem["DisableArticulateRationale"].Text);
                }
                Label lbl_CrossListingCourses = e.Item.FindControl("lblCrossListing") as Label;
                var cross_listing_courses = dataBoundItem["CrossListingCourses"].Text;
                if (cross_listing_courses != "0")
                {
                    lbl_CrossListingCourses.Visible = true;
                    lbl_CrossListingCourses.ToolTip = string.Format("<b>Cross Listing Courses :</b><br><br>{0}", dataBoundItem["CrossListingCourses"].Text);
                }
            }
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ChildGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int outline_id = Convert.ToInt32(dataBoundItem["outline_id"].Text);
                int haveOccupations = Convert.ToInt32(dataBoundItem["HaveOccupations"].Text);
                LinkButton btnHaveOccuppations = e.Item.FindControl("btnHaveOccupations") as LinkButton;
                btnHaveOccuppations.Visible = false;
                if (dataBoundItem["TypeDescription"].Text == "Course")
                {
                    btnHaveOccuppations.Visible = true;
                    if (haveOccupations == 1)
                    {
                        btnHaveOccuppations.CssClass = "haveOccupations";
                        btnHaveOccuppations.Style.Add("color", "#ffffff");
                        btnHaveOccuppations.ForeColor = System.Drawing.Color.White;
                        btnHaveOccuppations.BackColor = System.Drawing.Color.LightGreen;
                    }
                    else
                    {
                        btnHaveOccuppations.ToolTip = "Course without related occupations. Click here to assign occupation codes.";
                    }
                }

                LinkButton btnEditNotes = e.Item.FindControl("btnEditNotes") as LinkButton;
                //int isPublished = norco_db.CheckCourseIsPublished(outline_id);
                int isPublished = Convert.ToInt32(dataBoundItem["checkIsPublished"].Text);
                if (isPublished == 1)
                {
                    btnEditNotes.Enabled = false;
                }

                Label lbl_dont_articulate = e.Item.FindControl("lblArticulate") as Label;
                var dont_articulate = dataBoundItem["Articulate"].Text;
                if (dont_articulate == "False")
                {
                    lbl_dont_articulate.Visible = true;
                    //dataBoundItem.BackColor = System.Drawing.Color.LightPink;
                    dataBoundItem.ForeColor = System.Drawing.Color.Black;
                    dataBoundItem.Font.Bold = true;
                    lbl_dont_articulate.ToolTip = dataBoundItem["DeniedComments"].Text;
                }

                dataBoundItem.ToolTip = string.Format("This articulation is on {0} stage.", dataBoundItem["RoleName"].Text);
            }
            
        }


        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            rgRecommended.DataBind();
            rgRequired.DataBind();
            rgCollegeCourses.DataBind();
            rgACEOccupations.DataBind();
            rgACECourses.DataBind();
        }

        public void GetSimilarities(int? program_id, int matching_factor, int attribute_type, int? outline_id)
        {
            if (attribute_type == 1)
            {
                rgSimilarities.DataSourceID = "sqlCourseSimilarities";
                sqlCourseSimilarities.SelectParameters["AceCourseIDList"].DefaultValue = GlobalUtil.FindSimilarities(program_id, matching_factor, attribute_type, outline_id);
            }
            else
            {
                rgSimilarities.DataSourceID = "sqlCourseSimilaritiesByDetail";
                sqlCourseSimilaritiesByDetail.SelectParameters["AceCourseIDList"].DefaultValue = GlobalUtil.FindSimilarities(program_id, matching_factor, attribute_type, outline_id);
            }
            rgSimilarities.DataBind();
            rgSimilarities.Rebind();
            Session["program_id"] = rcbPrograms.SelectedValue;
            pnlProgramCourses.Visible = true;
        }

        protected void rgACEOccupations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            
            if (e.CommandName == "ExportToExcel")
            {
                grid.ExportToExcel();
            }
            if (e.CommandName == "AdoptArticulations")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select an item");
                }
                else
                {
                    GridDataItem itemDetail = e.Item as GridDataItem;
                    var AceID = itemDetail["AceID"].Text;
                    var TeamRevd = itemDetail["TeamRevd"].Text;
                    var CollegeID = Session["CollegeID"].ToString();
                    var url = String.Format("../popups/AdoptArticulations.aspx?CollegeID={0}&AceID={1}&TeamRevd={2}", CollegeID, AceID, TeamRevd);
                    RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 1200, 650));
                }
            }
            if (e.CommandName == "EditNotes")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, Resources.Messages.SelectCourse);
                }
                else
                {
                    GridDataItem itemDetail = (GridDataItem)e.Item;
                    if (itemDetail.OwnerTableView.Name == "ChildGrid")
                    {
                        if (itemDetail.Selected)
                        {
                            if (e.CommandName == "EditNotes")
                            {
                                if (itemDetail["TypeDescription"].Text == "Course")
                                {
                                    showAssignArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
                                }
                                else
                                {
                                    showAssignOccupationArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
                                }

                            }
                        }
                    }
                }
            }
        }

        protected void rchkSearchRecommendationsOcc_CheckedChanged(object sender, EventArgs e)
        {
            SearchOccAttribute();
        }

        protected void rchkExcludeYears_CheckedChanged(object sender, EventArgs e)
        {
            if (rchkExcludeYears.Checked == true)
            {
                hfExcludeArticulationOverYears.Value = GlobalUtil.ReadSetting("ExcludeArticulationOverYears");
            } else
            {
                hfExcludeArticulationOverYears.Value = "200";
            }
        }

        protected void rbCriteria_Click(object sender, EventArgs e)
        {
            var criteria_list = racbCriteria.Text.TrimEnd(',');
            //sqlCriteriaDisciplines.SelectParameters["SubjectList"].DefaultValue = criteria_list;
            sqlCriteriaDisciplines.DataBind();
			GetGroupCriteriaByDiscipline.DataBind();
            GetCriteriaByDiscipline.DataBind();
            //sqlCriteriaDisciplines.SelectParameters["SubjectList"].DefaultValue = criteria_list;
            //sqlCriteriaDisciplines.DataBind();			
            rgCriteria.DataBind();
			rgCriteria.MasterTableView.HierarchyDefaultExpanded = true;
            rgCriteria.MasterTableView.DetailTables[0].HierarchyDefaultExpanded = true;
            rgCriteria.Rebind();
		}
		
        protected void rbClearCriteria_Click(object sender, EventArgs e)
        {
            racbCriteria.Entries.Clear();
            racbRecCriteria.Entries.Clear();
            GetCriteriaByDiscipline.DataBind();
            GetGroupCriteriaByDiscipline.DataBind();
            sqlCriteriaDisciplines.DataBind();
            //sqlCriteriaDisciplines.SelectParameters["SubjectList"].DefaultValue = "";
            //sqlCriteriaDisciplines.DataBind();
            rgCriteria.DataBind();
            rgCriteria.MasterTableView.HierarchyDefaultExpanded = false;
            rgCriteria.MasterTableView.DetailTables[0].HierarchyDefaultExpanded = false;
            rgCriteria.Rebind();	
        }

        protected void rbLocationSearch_Click(object sender, EventArgs e)
        {
            var location_list = racLocations.Text.TrimEnd(';');
            sqlLocationList.SelectParameters["Location"].DefaultValue = location_list;
            sqlLocationList.SelectParameters["ExcludeArticulationOverYears"].DefaultValue = hfExcludeArticulationOverYears.Value;
            sqlLocationList.DataBind();
            rgLocations.MasterTableView.AllowPaging = false;
            rgLocations.Rebind();
            int count = rgLocations.MasterTableView.Items.Count;
            rgLocations.MasterTableView.AllowPaging = true;
            rgLocations.Rebind();
            if (count == 0)
            {
                DisplayMessage(false, "Please note that this is not a conclusive list of MAP military branch locations. We apologize for the inconvenience, as more locations are being added daily. Please continue your search within the ACE Courses, ACE Occupations or Recommendation Criteria functions.");
            }
        }

        protected void rbLocationClear_Click(object sender, EventArgs e)
        {
            racLocations.Entries.Clear();
            sqlLocationList.SelectParameters["Location"].DefaultValue = "";
            sqlLocationList.DataBind();
            rgLocations.DataBind();
        }

        protected void rgLocations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && (e.Item.OwnerTableView.Name == "ParentGrid" || e.Item.OwnerTableView.Name == "ParentCriteria" || e.Item.OwnerTableView.Name == "ParentGroup"))
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int record_count = Convert.ToInt32(dataBoundItem["RecordCount"].Text);
                Label badgeCount = e.Item.FindControl("badgeRelatedCourses") as Label;
                if (record_count > 0)
                {
                    badgeCount.Text = record_count.ToString();
                    if (e.Item.OwnerTableView.Name == "ParentCriteria")
                    {
                        badgeCount.ToolTip = string.Format("{0} Original ACE Credit Recommendation found in ACE Catalog.", record_count.ToString());
                    } else
                    {
                        badgeCount.ToolTip = string.Format("{0} Records found.", record_count.ToString());
                    }            
                }
                else
                {
                    badgeCount.Visible = false;
                }
            }

            if (e.Item is GridDataItem && (e.Item.OwnerTableView.Name == "ParentCourses"))
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int occupationHaveCourses = Convert.ToInt32(dataBoundItem["HaveRelatedCourses"].Text);
                Label badgeCount = e.Item.FindControl("badgeCoursesCount") as Label;
                if (occupationHaveCourses > 0)
                {
                    badgeCount.Text = occupationHaveCourses.ToString();
                    badgeCount.Style.Add("background-color", "cadetblue !important");
                    badgeCount.ToolTip = string.Format("{0} Related Articulation(s).", occupationHaveCourses.ToString());
                }
                else
                {
                    badgeCount.Visible = false;
                }
            }
            if (e.Item is GridDataItem && (e.Item.OwnerTableView.Name == "ChildGridArticulations"))
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                Label lbl_dont_articulate = e.Item.FindControl("lblArticulate") as Label;
                var dont_articulate = dataBoundItem["Articulate"].Text;
                if (dont_articulate == "False")
                {
                    lbl_dont_articulate.Visible = true;
                    //dataBoundItem.BackColor = System.Drawing.Color.LightPink;
                    dataBoundItem.ForeColor = System.Drawing.Color.Black;
                    dataBoundItem.Font.Bold = true;
                    lbl_dont_articulate.ToolTip = dataBoundItem["DeniedComments"].Text;
                }
                dataBoundItem.ToolTip = string.Format("This articulation is on {0} stage.", dataBoundItem["RoleName"].Text);
            }
        }

        protected void rgLocations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.CommandName == "EditNotes")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, Resources.Messages.SelectCourse);
                }
                else
                {
                    GridDataItem itemDetail = (GridDataItem)e.Item;
                    if (itemDetail.OwnerTableView.Name == "ChildGridArticulations")
                    {
                        if (itemDetail.Selected)
                        {
                            if (e.CommandName == "EditNotes")
                            {
                                if (itemDetail["TypeDescription"].Text == "Course")
                                {
                                    showAssignArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
                                }
                                else
                                {
                                    showAssignOccupationArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
                                }

                            }
                        }
                    }
                }
            }
        }

        protected void rgLocations_RowDrop(object sender, GridDragDropEventArgs e)
        {
            int outline_id = 0;
            int draggedRows = 0;
            Hashtable values = new Hashtable();
            string id = "";
            DateTime teamrevd = new DateTime();
            string title = "";
            string entity = "";
            var subject = "";
            var units = 0.0;
            var course_number = "";
            var course_title = "";
            int created_articulations = 0;

            if (e.DestDataItem != null)
            {
                if (e.DestinationTableView.OwnerGrid.ClientID == rgRequired.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgRecommended.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgCollegeCourses.ClientID)
                {
                    if (e.DestDataItem != null)
                    {
                        foreach (GridDataItem draggedItem in e.DraggedItems)
                        {
                            draggedItem.ExtractValues(values);
                            id = (string)values["AceID"];
                            teamrevd = Convert.ToDateTime((string)values["TeamRevd"]);
                            title = (string)values["Title"];
                            entity = (string)values["EntityType"];
                            draggedRows = e.DraggedItems.Count();

                            outline_id = (int)e.DestDataItem.GetDataKeyValue("outline_id");
                            if (outline_id > 0)
                            {
                                var course = norco_db.GetCourseInformation(outline_id);
                                foreach (GetCourseInformationResult item in course)
                                {
                                    subject = item.subject;
                                    course_number = item.course_number;
                                    units = Convert.ToDouble(item._Units);
                                    course_title = item.course_title;
                                }
                                var existOtherColleges = norco_db.CheckArticulationExistOtherColleges(Convert.ToInt32(Session["CollegeID"]), subject, course_number, id, teamrevd);
                                if (existOtherColleges == true)
                                {
                                    //norco_db.CloneOtherCollegeArticulation(idToClone, Session["CollegeID"].ToString(), Session["CollegeID"].ToString(), Session["UserID"].ToString(), subject, course_number);
                                }
                                else
                                {
                                    if (norco_db.CheckIsDisabledForArticulate(outline_id) == true)
                                    {
                                        DisplayMessage(false, GlobalUtil.ReadSetting("DisableArticulateMessage"));
                                    }
                                    else
                                    {
                                        if (draggedRows == 1)
                                        {
                                            int exist = norco_db.CheckExistArticulation(outline_id, id, teamrevd);
                                            if (exist == 0)
                                            {
                                                if (entity == "1")
                                                {
                                                    showNewAssignArticulation(outline_id, id, title, teamrevd, 4);
                                                } else
                                                {
                                                    showNewAssignOccupationArticulation(outline_id, id, title, teamrevd, 4);
                                                }
                                            }
                                        }
                                        else
                                        {
                                            int exist = norco_db.CheckExistArticulation(outline_id, id, teamrevd);
                                            if (exist == 0)
                                            {
                                                if (entity == "1")
                                                {
                                                    Controllers.Articulation.AddArticulation(outline_id, id, teamrevd, title, "", "", "", "", 1, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false, 4,false,999999);
                                                    created_articulations += 1;
                                                }
                                                else
                                                {
                                                    Controllers.Articulation.AddArticulation(outline_id, id, teamrevd, title, "", "", "", "", 2, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false, 4,false,99999999);
                                                    created_articulations += 1;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else
                            {
                                DisplayMessage(false, Resources.Messages.CantDropItem);
                            }
                        }
                        if (created_articulations > 1)
                        {
                            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "ArticulationCreated();", true);
                        }
                        rgRecommended.DataBind();
                        rgRequired.DataBind();
                        rgCollegeCourses.DataBind();
                        rgACEOccupations.DataBind();
                        rgACECourses.DataBind();
                        rgLocations.DataBind();
                    }
                    else
                    {
                        DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
                    }
                }
                else
                {
                    DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
                }
            }
        }

        protected void rcbLocationService_PreRender(object sender, EventArgs e)
        {
            base.OnPreRender(e);
            if (!IsPostBack)
            {
                sqlLocationList.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbLocationService");
            }
        }

        protected void rcbLocationService_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlLocationList.SelectParameters["Service"].DefaultValue = SetSelectedIndexChange("rcbLocationService");
        }

        protected void rgCriteria_RowDrop(object sender, GridDragDropEventArgs e)
        {
            int outline_id = 0;
            int draggedRows = 0;
            Hashtable values = new Hashtable();
            string id = "";
            DateTime teamrevd = new DateTime();
            string title = "";
            string entity = "";
			string criteria = "";
            string criteria_description = "";			 
            var subject = "";
            var units = 0.0;
            var course_number = "";
            var course_title = "";
            int created_articulations = 0;

            if (e.DestDataItem != null)
            {
                if (e.DestinationTableView.OwnerGrid.ClientID == rgRequired.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgRecommended.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgCollegeCourses.ClientID)
                {
                    if (e.DestDataItem != null)
                    {
                        foreach (GridDataItem draggedItem in e.DraggedItems)
                        {
                            draggedItem.ExtractValues(values);
                            id = (string)values["AceID"];
                            teamrevd = Convert.ToDateTime((string)values["TeamRevd"]);
                            title = (string)values["Title"];
                            entity = (string)values["EntityType"];
                            draggedRows = e.DraggedItems.Count();
							criteria = (string)values["Criteria"];
                            criteria_description = (string)values["CriteriaDescription"];
							
                            outline_id = (int)e.DestDataItem.GetDataKeyValue("outline_id");
                            if (outline_id > 0)
                            {
                                // Normal Procedure												   
                                var course = norco_db.GetCourseInformation(outline_id);
                                foreach (GetCourseInformationResult item in course)
                                {
                                    subject = item.subject;
                                    course_number = item.course_number;
                                    units = Convert.ToDouble(item._Units);
                                    course_title = item.course_title;
                                }

                                if (criteria != "" && criteria_description != "")
                                {
                                    var articulationId = 0;
                                    var data = norco_db.GetACEDataByCriteria(Convert.ToInt32(Session["CollegeID"]), criteria, criteria_description);
                                    foreach (GetACEDataByCriteriaResult item in data)
                                    {
                                        int exist = norco_db.CheckExistArticulation(outline_id, item.AceID, item.TeamRevd);
                                        if (exist == 0)
                                        {

                                            articulationId = Controllers.Articulation.AddArticulation(outline_id, item.AceID, Convert.ToDateTime(item.TeamRevd), item.Title, "", "", "", "", Convert.ToInt32(item.EntityType), Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false, 3,false,9999999);
                                            var artData = norco_db.GetArticulationByID(articulationId);
                                            foreach (GetArticulationByIDResult art in artData)
                                            {
                                                Controllers.Criteria.SaveCriteria(art.ArticulationID, Convert.ToInt32(item.EntityType), Convert.ToInt32(Session["UserID"]), "", "", criteria, 1, 1, Convert.ToInt32(item.ID));
                                            }
                                        }
                                    }
                                    if (articulationId == 0)
                                    {
                                        DisplayMessage(true, "Articulations could not be created with the selected criteria");
                                    }
                                    else
                                    {
                                        ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "ArticulationCreated();", true);
                                    }
                                    
                                }
                                else
                                {

                                    var existOtherColleges = norco_db.CheckArticulationExistOtherColleges(Convert.ToInt32(Session["CollegeID"]), subject, course_number, id, teamrevd);
                                    if (existOtherColleges == true)
                                    {
                                        //norco_db.CloneOtherCollegeArticulation(idToClone, Session["CollegeID"].ToString(), Session["CollegeID"].ToString(), Session["UserID"].ToString(), subject, course_number);
                                    }
                                    else
                                    {
                                        if (norco_db.CheckIsDisabledForArticulate(outline_id) == true)
                                        {
                                            DisplayMessage(false, GlobalUtil.ReadSetting("DisableArticulateMessage"));
														   
											 
																  
												 
																												  
												 
													
												 
																															
												 
											 
                                        }
                                        else
                                        {
                                            if (draggedRows == 1)
														   
                                            {
                                                int exist = norco_db.CheckExistArticulation(outline_id, id, teamrevd);
                                                if (exist == 0)
                                                {
                                                    if (entity == "1")
                                                    {
                                                        showNewAssignArticulation(outline_id, id, title, teamrevd, 3);
                                                    }
                                                    else
                                                    {
                                                        showNewAssignOccupationArticulation(outline_id, id, title, teamrevd, 3);
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                int exist = norco_db.CheckExistArticulation(outline_id, id, teamrevd);
                                                if (exist == 0)
                                                {
                                                    if (entity == "1")
                                                    {
                                                        Controllers.Articulation.AddArticulation(outline_id, id, teamrevd, title, "", "", "", "", 1, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false, 3,false,999999);
                                                        created_articulations += 1;
                                                    }
                                                    else
                                                    {
                                                        Controllers.Articulation.AddArticulation(outline_id, id, teamrevd, title, "", "", "", "", 2, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false, 3,false,9999999);
                                                        created_articulations += 1;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else
                            {
                                DisplayMessage(false, Resources.Messages.CantDropItem);
                            }
                        }
                        if (created_articulations > 1)
                        {
                            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "ArticulationCreated();", true);
                        }
                        rgRecommended.DataBind();
                        rgRequired.DataBind();
                        rgCollegeCourses.DataBind();
                        rgACEOccupations.DataBind();
                        rgACECourses.DataBind();
                        rgCriteria.DataBind();
                    }
                    else
                    {
                        DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
                    }
                }
                else
                {
                    DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
                }
            }
        }

        protected void racACECourseAttribute_TextChanged(object sender, AutoCompleteTextEventArgs e)
        {
            SearchAttribute();
        }


    }
}