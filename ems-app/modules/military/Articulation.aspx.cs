using System;
using System.Collections;
using System.Collections.Specialized;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.military
{
    public partial class Articulation : System.Web.UI.Page
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
                        foreach (GridDataItem itemDetail in grid.Items)
                        {
                            if (itemDetail.OwnerTableView.Name == "ChildGrid")
                            {
                                if (itemDetail.Selected)
                                {
                                    if (e.CommandName == "EditNotes")
                                    {
                                        showAssignArticulation(Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
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
                    if (e.CommandName == "NoArticulate" || e.CommandName == "SimilarCourses")
                    {
                        if (grid.SelectedItems.Count <= 0)
                        {
                            DisplayMessage(false, Resources.Messages.SelectCourse);
                        }
                        else
                        {
                            GridDataItem item = (GridDataItem)grid.MasterTableView.Items[grid.SelectedItems[0].ItemIndex];
                            Int32 outline_id = Convert.ToInt32(item["outline_id"].Text);
                            if (outline_id > 0)
                            {
                                if (e.CommandName == "NoArticulate")
                                {
                                    int isPublished = norco_db.CheckCourseIsPublished(outline_id);
                                    if (isPublished == 1)
                                    {
                                        DisplayMessage(false, Resources.Messages.DeleteNoArticulate);
                                    }
                                    else
                                    {
                                        //norco_db.DontArticulate(outline_id);
                                        grid.DataBind();
                                    }
                                }
                                if (e.CommandName == "SimilarCourses")
                                {
                                    if (rcheckSimilarPrograms.Checked == true)
                                    {
                                        GetSimilarities(null, Convert.ToInt32(rcbMatchingFactor.SelectedValue), Convert.ToInt32(rcbAttribute.SelectedValue), outline_id);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        protected void ProgramCourses_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ChildGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int outline_id = Convert.ToInt32(dataBoundItem["outline_id"].Text);
                int haveOccupations = Convert.ToInt32(dataBoundItem["HaveOccupations"].Text);
                LinkButton btnHaveOccuppations = e.Item.FindControl("btnHaveOccupations") as LinkButton;
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
                LinkButton btnEditNotes = e.Item.FindControl("btnEditNotes") as LinkButton;
                int isPublished = norco_db.CheckCourseIsPublished(outline_id);
                if (isPublished == 1)
                {
                    btnEditNotes.Enabled = false;
                }
            }

            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ParentGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int outline_id = Convert.ToInt32(dataBoundItem["outline_id"].Text);
                Label btnShowMatches = e.Item.FindControl("btnShowMatches") as Label;

                int haveMatches = norco_db.MatchACECourses(outline_id);
                if ( haveMatches == 1 )
                {
                    btnShowMatches.Visible = true;
                    btnShowMatches.ForeColor = System.Drawing.Color.DarkOliveGreen;
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

        public void showAssignArticulation(Int32 outline_id, String AceID, String Title, DateTime TeamRevd)
        {
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/AssignArticulation.aspx?outline_id={0}&AceID={1}&Title={2}&TeamRevd={3}", outline_id.ToString(), AceID, Title, TeamRevd.ToString()), true, true, false, 1000, 600));
        }

        protected void ACECourses_RowDrop(object sender, GridDragDropEventArgs e)
        {
            GridDataItem dataItem = e.DraggedItems[0];
            Hashtable values = new Hashtable();
            dataItem.ExtractValues(values);
            string id = (string)values["AceID"];
            string title = (string)values["Title"];
            DateTime teamrevd = Convert.ToDateTime((string)values["TeamRevd"]);

            int outline_id = 0;
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
                            //int isPublished = norco_db.CheckCourseIsPublished(outline_id);
                            //if (isPublished == 1)
                            //{
                            //    DisplayMessage(false, Resources.Messages.CannotDropItemArticulationPublished);
                            //}
                            //else
                            //{
                                int exist = norco_db.CheckExistArticulation(outline_id, id, teamrevd);
                                if (exist == 0)
                                {
                                    showAssignArticulation(outline_id, id, title, teamrevd);
                                }
                                else
                                {
                                    DisplayMessage(false, Resources.Messages.ArticulationExist);
                                }
                            //}
                        }
                        else
                        {
                            DisplayMessage(false, Resources.Messages.CantDropItem);
                        }
                    }
                    rgRecommended.DataBind();
                    rgRequired.DataBind();
                    rgCollegeCourses.DataBind();
                }
                else
                {
                    DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
                }
            } else
            {
                DisplayMessage(false, Resources.Messages.DropItemInsideProgramCourses);
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rcbPrograms_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            GetSimilarities(Convert.ToInt32(rcbPrograms.SelectedValue), Convert.ToInt32(rcbMatchingFactor.SelectedValue), Convert.ToInt32(rcbAttribute.SelectedValue), null);
            selectedRowValue.Text = "";
        }

        public void GetSimilarities(int? program_id, int matching_factor, int attribute_type, int? outline_id)
        {
            if (attribute_type == 1)
            {
                rgSimilarities.DataSourceID = "sqlCourseSimilarities";
                sqlCourseSimilarities.SelectParameters["AceCourseIDList"].DefaultValue = GlobalUtil.FindSimilarities( program_id, matching_factor,attribute_type, outline_id);
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


        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            rgRequired.DataBind();
            rgRecommended.DataBind();
            rgACECourses.DataBind();
            rgSimilarities.DataBind();
            rgCollegeCourses.DataBind();
        }

        public void SearchAttribute()
        {
            if (rtbAttribute.Text != "")
            {
                if (rcbOccupations.SelectedValue != "")
                {
                    rgACECourses.DataSourceID = "sqlSearchOccupationAttribute";
                    sqlSearchOccupationAttribute.DataBind();
                } else
                {
                    if (rchkSearchRecommendations.Checked == true)
                    {
                        rgACECourses.DataSourceID = "sqlSearchRecommendations";
                        sqlACECoursesSearch.DataBind();
                    }
                    else
                    {
                        rgACECourses.DataSourceID = "sqlACECoursesSearch";
                        sqlACECoursesSearch.DataBind();
                    }

                }
            }
            else
            {
                if (rcbOccupations.SelectedValue != "")
                {
                    rgACECourses.DataSourceID = "sqlSearchOccupation";
                    sqlSearchOccupation.DataBind();
                } else
                {
                    rgACECourses.DataSourceID = "sqlACECoursesSearch";
                    sqlACECoursesSearch.DataBind();
                }
            }
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
            rgACECourses.DataSourceID = "sqlACECourses";
            sqlACECourses.DataBind();
            rcbOccupations.ClearSelection();
            rtbAttribute.Text = "";
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

        protected void rcheckSimilarPrograms_CheckedChanged(object sender, EventArgs e)
        {
            pnlSimilar.Visible = false;
            if (rcheckSimilarPrograms.Checked ==  true)
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

        protected void rcbOccupations_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (rcbOccupations.SelectedValue != "")
            {
                if (rtbAttribute.Text == "")
                {
                    rgACECourses.DataSourceID = "sqlSearchOccupation";
                    sqlSearchOccupation.DataBind();
                } else
                {
                    rgACECourses.DataSourceID = "sqlSearchOccupationAttribute";
                    sqlSearchOccupationAttribute.DataBind();
                }
            }
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

        protected void rgACECourses_PreRender(object sender, EventArgs e)
        {
            HideExpandColumnRecursive(rgACECourses.MasterTableView);
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

        protected void rgSimilarities_PreRender(object sender, EventArgs e)
        {
            HideExpandColumnRecursive(rgSimilarities.MasterTableView);
        }

        protected void rblPerformArticulationBy_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (rblPerformArticulationBy.SelectedValue == "program")
            {
                panelCollegeCourses.Visible = false;
                panelCollegePrograms.Visible = true;
            }
            else
            {
                panelCollegeCourses.Visible = true;
                panelCollegePrograms.Visible = false;
                Session["program_id"] = null;
            }
        }

    }
}