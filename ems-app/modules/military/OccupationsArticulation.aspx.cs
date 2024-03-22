using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.military
{
    public partial class OccupationsArticulation : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rblPerformArticulationBy.DataBind();
                rblPerformArticulationBy.SelectedValue = "course";
                pnlProgramCourses.Visible = false;
                if (Session["program_id"] != null)
                {
                    rcbPrograms.SelectedValue = Session["program_id"].ToString();
                    sqlRecommended.DataBind();
                    sqlRequired.DataBind();
                    rgRecommended.DataBind();
                    rgRequired.DataBind();
                    rgCollegeCourses.DataBind();
                    pnlProgramCourses.Visible = true;
                    panelCollegeCourses.Visible = false;
                }

            }
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

        protected void ProgramCourses_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ParentGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int outline_id = Convert.ToInt32(dataBoundItem["outline_id"].Text);
                Label btnShowMatches = e.Item.FindControl("btnShowMatches") as Label;

                int haveMatches = norco_db.CheckCollegeCourseHaveOccupations(outline_id,null,null,Convert.ToInt32(Session["CollegeID"]));
                if (haveMatches == 1)
                {
                    btnShowMatches.Visible = true;
                    btnShowMatches.ForeColor = System.Drawing.Color.DarkOliveGreen;
                }
                else
                {
                    btnShowMatches.ForeColor = System.Drawing.Color.Gray;
                }

                int isPublished = norco_db.CheckCourseIsPublished(outline_id);
                if (isPublished == 1)
                {
                    btnShowMatches.Visible = true;
                    btnShowMatches.ForeColor = System.Drawing.Color.Red;
                    btnShowMatches.ToolTip += Resources.Messages.TooltipStatusPublished;
                }

                Label lblArticulate = e.Item.FindControl("lblArticulate") as Label;
                int isArticulated = norco_db.CourseIsArticulated(outline_id);
                if (isArticulated == 1)
                {
                    lblArticulate.Visible = true;
                }
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

        protected void ACECourses_RowDrop(object sender, GridDragDropEventArgs e)
        {
            int outline_id = 0;
            int draggedRows = 0;
            int haveOccupations = 0;
            int isPublished = 0;
            Hashtable values = new Hashtable();
            string id = "";
            DateTime teamrevd = new DateTime();
            string title = "";

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
                                //isPublished = norco_db.CheckCourseIsPublished(outline_id);
                                //if (isPublished == 1)
                                //{
                                //    DisplayMessage(false, Resources.Messages.CannotDropItemArticulationPublished);
                                //    break;
                                //}
                                //else
                                //{
                                    if (draggedRows == 1)
                                    {
                                    haveOccupations = norco_db.CheckCollegeCourseHaveOccupations(outline_id, id, teamrevd, Convert.ToInt32(Session["CollegeID"]));
                                        if (haveOccupations == 1)
                                        {
                                            DisplayMessage(false, "Occupation already exist.");
                                        }
                                        else
                                        {
                                            showAssignOccupationArticulation(outline_id, id, title, teamrevd);
                                            break;
                                        }
                                    } else
                                    {
                                        norco_db.AddMultipleOccupationArticulation(outline_id, id, teamrevd, title, null, null, Convert.ToInt32(Session["UserID"].ToString()), Convert.ToInt32(Session["CollegeID"].ToString()));
                                    }
                                //}
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
                                string from = GlobalUtil.ReadSetting("SystemNotificationEmail");
                                GlobalUtil.NotifyNewArticulations(Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), outline_id, from);
                            }
                            catch (Exception ex)
                            {
                                DisplayMessage(true, ex.Message.ToString());
                            }
                        }
                        rgRecommended.DataBind();
                        rgRequired.DataBind();
                        rgACEOccupations.DataBind();
                        rgCollegeCourses.DataBind();
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

        public void showAssignOccupationArticulation(Int32 outline_id, String AceID, String Title, DateTime TeamRevd)
        {
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/AssignOccupationArticulation.aspx?outline_id={0}&AceID={1}&Title={2}&TeamRevd={3}", outline_id.ToString(), AceID, Title, TeamRevd.ToString()), true, true, false, 1000, 600));
        }


        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rcbPrograms_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Session["program_id"] = rcbPrograms.SelectedValue;
            sqlRecommended.DataBind();
            sqlRequired.DataBind();
            rgRecommended.DataBind();
            rgRequired.DataBind();
            pnlProgramCourses.Visible = true;
        }

        protected void rtbAttribute_TextChanged(object sender, EventArgs e)
        {
            SearchAttribute();
        }

        protected void rbSearchAttribute_Click(object sender, EventArgs e)
        {
            SearchAttribute();
        }

        public void SearchAttribute()
        {
            if (racAdvanceSearch.Text != "")
            {
                int existSmartKeyword = norco_db.CheckExistSmartKeyword(racAdvanceSearch.Text, 2);
                if (existSmartKeyword == 0)
                {
                    panelSmartKeys.Visible = true;
                }
                if (rchkSearchRecommendations.Checked == true)
                {
                    rgACEOccupations.DataSourceID = "sqlSearchRecommendations";
                    sqlSearchRecommendations.DataBind();
                } else
                {
                    rgACEOccupations.DataSourceID = "sqlSearchOccupationAttribute";
                    sqlSearchOccupationAttribute.DataBind();
                }
                rgACEOccupations.DataBind();
            }
            else
            {
                rgACEOccupations.DataSourceID = "sqlAllOccupations";
                sqlAllOccupations.DataBind();
            }
        }
        protected void rbClearAttribute_Click(object sender, EventArgs e)
        {
            rgACEOccupations.DataSourceID = "sqlAllOccupations";
            sqlAllOccupations.DataBind();
            racAdvanceSearch.Entries.Clear();
        }

        protected void rgACEOccupations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem &&  e.Item.OwnerTableView.Name == "ParentGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int occupationHaveCourses = Convert.ToInt32(dataBoundItem["HaveRelatedCourses"].Text);
                Label btnOccupationHaveCourses = e.Item.FindControl("btnOccupationHaveCourses") as Label;
                if (occupationHaveCourses == 1)
                {
                    btnOccupationHaveCourses.Style.Add("color", "#698637");
                }
                else
                {
                    btnOccupationHaveCourses.Visible=false;
                }
            }
        }


    public void HideExpandColumnRecursive(GridTableView tableView)
    {
        GridItem[] nestedViewItems = tableView.GetItems(GridItemType.NestedView);
        foreach (GridNestedViewItem nestedViewItem in nestedViewItems)
        {
            foreach (GridTableView nestedView in nestedViewItem.NestedTableViews)
            {
                if (nestedView.Items.Count == 0)
                {
                    TableCell cell = nestedView.ParentItem["ExpandColumn"];
                    cell.Controls[0].Visible = false;
                    cell.Text = "&nbsp";
                    nestedViewItem.Visible = false;
                }
                if (nestedView.HasDetailTables)
                {
                    HideExpandColumnRecursive(nestedView);
                }
            }
        }
    }
    protected void rgACEOccupations_PreRender(object sender, EventArgs e)
        {
            HideExpandColumnRecursive(rgACEOccupations.MasterTableView);
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            rgRecommended.DataBind();
            rgRequired.DataBind();
            rgACEOccupations.DataBind();
            rgCollegeCourses.DataBind();
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

        protected void rblPerformArticulationBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblPerformArticulationBy.SelectedValue == "program")
            {
                panelCollegeCourses.Visible = false;
                panelCollegePrograms.Visible = true;
            } else
            {
                panelCollegeCourses.Visible = true;
                panelCollegePrograms.Visible = false;
                Session["program_id"] = null;
            }
        }
    }
}