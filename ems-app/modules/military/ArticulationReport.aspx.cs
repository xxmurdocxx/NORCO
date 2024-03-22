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
    public partial class ArticulationReport : System.Web.UI.Page
    {

        NORCODataContext norco_db = new NORCODataContext();

        private Hashtable _ordersExpandedState;
        private Hashtable _selectedState;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //reset states
                this._ordersExpandedState = null;
                this.Session["_ordersExpandedState"] = null;
                this._selectedState = null;
                this.Session["_selectedState"] = null;

                hfStageID.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])).ToString();

                rgArticulationCourses.Visible = false;
                rgByStage.Visible = false;
                rgByReview.Visible = false;

                rgByReview.MasterTableView.HierarchyDefaultExpanded = true;
                rgByReview.MasterTableView.EnableHierarchyExpandAll = true;
                rgByReview.MasterTableView.GroupsDefaultExpanded = true;

                rgByStage.MasterTableView.HierarchyDefaultExpanded = true;
                rgByStage.MasterTableView.EnableHierarchyExpandAll = true;
                rgByStage.MasterTableView.GroupsDefaultExpanded = true;

                var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
                var firstStage = norco_db.GetMinimumStageId(Convert.ToInt32(Session["CollegeID"]));
                var lastStage = norco_db.GetMaximumStageId(Convert.ToInt32(Session["CollegeID"]));
                if ( Convert.ToBoolean(Session["reviewArticulations"]) )
                {
                    rgByReview.Visible = true;
                }
                if (Convert.ToBoolean(Session["isArticulationOfficer"]) || userStageID == lastStage )
                {
                    rgByStage.Visible = true;
                }
                if ( Convert.ToBoolean(Session["isAdministrator"]) || userStageID == firstStage)
                {
                    rgArticulationCourses.Visible = true;
                }

            }
        }

        private Hashtable ExpandedStates
        {
            get
            {
                if (this._ordersExpandedState == null)
                {
                    _ordersExpandedState = this.Session["_ordersExpandedState"] as Hashtable;
                    if (_ordersExpandedState == null)
                    {
                        _ordersExpandedState = new Hashtable();
                        this.Session["_ordersExpandedState"] = _ordersExpandedState;
                    }
                }

                return this._ordersExpandedState;
            }
        }

        //Clear the state for all expanded children if a parent item is collapsed
        private void ClearExpandedChildren(string parentHierarchicalIndex)
        {
            string[] indexes = new string[this.ExpandedStates.Keys.Count];
            this.ExpandedStates.Keys.CopyTo(indexes, 0);
            foreach (string index in indexes)
            {
                //all indexes of child items
                if (index.StartsWith(parentHierarchicalIndex + "_") ||
                    index.StartsWith(parentHierarchicalIndex + ":"))
                {
                    this.ExpandedStates.Remove(index);
                }
            }
        }

        private void ClearSelectedChildren(string parentHierarchicalIndex)
        {
            string[] indexes = new string[this.SelectedStates.Keys.Count];
            this.SelectedStates.Keys.CopyTo(indexes, 0);
            foreach (string index in indexes)
            {
                //all indexes of child items
                if (index.StartsWith(parentHierarchicalIndex + "_") ||
                    index.StartsWith(parentHierarchicalIndex + ":"))
                {
                    this.SelectedStates.Remove(index);
                }
            }
        }

        //Save/load selected states Hash from the session
        //this can also be implemented in the ViewState
        private Hashtable SelectedStates
        {
            get
            {
                if (this._selectedState == null)
                {
                    _selectedState = this.Session["_selectedState"] as Hashtable;
                    if (_selectedState == null)
                    {
                        _selectedState = new Hashtable();
                        this.Session["_selectedState"] = _selectedState;
                    }
                }

                return this._selectedState;
            }
        }

        protected void rgArticulationCourses_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            var outline_id = 0;
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "EditNotes")
            {
                if (e.Item.OwnerTableView.Name == "ChildGrid")
                {
                    if (itemDetail["articulation_type"].Text == "1")
                    {
                        showAssignArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
                    } else
                    {
                        showAssignOccupationArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
                    }
                    
                }
            }

            if (e.CommandName == "Expand")
            {
                if ( grid.MasterTableView.HierarchyDefaultExpanded == false )
                {
                    grid.MasterTableView.HierarchyDefaultExpanded = true;
                    foreach (GridDataItem item in grid.MasterTableView.Items)
                    {
                        item.Expanded = true;
                    }
                } else
                {
                    grid.MasterTableView.HierarchyDefaultExpanded = false;
                    foreach (GridDataItem item in grid.MasterTableView.Items)
                    {
                        item.Expanded = false;
                    }
                }
                grid.DataBind();
            }

            if (e.Item.OwnerTableView.Name == "ParentGrid")
            {
                //save the expanded/selected state in the session
                if (e.CommandName == RadGrid.ExpandCollapseCommandName)
                {
                    //Is the item about to be expanded or collapsed
                    if (!e.Item.Expanded)
                    {
                        //Save its unique index among all the items in the hierarchy
                        this.ExpandedStates[e.Item.ItemIndexHierarchical] = true;
                    }
                    else //collapsed
                    {
                        this.ExpandedStates.Remove(e.Item.ItemIndexHierarchical);
                        this.ClearSelectedChildren(e.Item.ItemIndexHierarchical);
                        this.ClearExpandedChildren(e.Item.ItemIndexHierarchical);
                    }
                }
                //Is the item about to be selected 
                else if (e.CommandName == RadGrid.SelectCommandName)
                {
                    //Save its unique index among all the items in the hierarchy
                    this.SelectedStates[e.Item.ItemIndexHierarchical] = true;
                }
                //Is the item about to be deselected 
                else if (e.CommandName == RadGrid.DeselectCommandName)
                {
                    this.SelectedStates.Remove(e.Item.ItemIndexHierarchical);
                }

                if (e.CommandName == "ExportToExcel")
                {
                    grid.ExportToExcel();
                }
                if (e.CommandName == "Audit")
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
                            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Audit.aspx?outline_id={0}", outline_id.ToString()), true, true, false, 700, 400));
                        }
                    }
                }

            }
        }

        public void showAssignArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd)
        {
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/AssignArticulation.aspx?articulationId={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()),true,true,false,1160,600));
        }

        public void showAssignOccupationArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd)
        {
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/AssignOccupationArticulation.aspx?articulationId={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()), true, true, false, 1160, 600));
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
            rgByStage.DataBind();
            rgByReview.DataBind();
        }

        protected void rgArticulationCourses_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ChildGrid" )
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int checkUpdatedCurrentUser = Convert.ToInt32(dataBoundItem["checkUpdatedCurrentUser"].Text);
                Label lblcheckUpdatedCurrentUser = e.Item.FindControl("lblcheckUpdatedCurrentUser") as Label;
                if (checkUpdatedCurrentUser == 1)
                {
                    lblcheckUpdatedCurrentUser.Visible = true;
                }
            }
        }

        protected void rgArticulationCourses_DataBound(object sender, EventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            //Expand all items using our custom storage
            string[] indexes = new string[this.ExpandedStates.Keys.Count];
            this.ExpandedStates.Keys.CopyTo(indexes, 0);

            ArrayList arr = new ArrayList(indexes);
            //Sort so we can guarantee that a parent item is expanded before any of 
            //its children
            arr.Sort();

            foreach (string key in arr)
            {
                bool value = (bool)this.ExpandedStates[key];
                if (value)
                {
                    grid.Items[key].Expanded = true;
                }
            }

            //Select all items using our custom storage
            indexes = new string[this.SelectedStates.Keys.Count];
            this.SelectedStates.Keys.CopyTo(indexes, 0);

            arr = new ArrayList(indexes);
            //Sort to ensure that a parent item is selected before any of its children
            arr.Sort();

            foreach (string key in arr)
            {
                bool value = (bool)this.SelectedStates[key];
                if (value)
                {
                    grid.Items[key].Selected = true;
                }
            }
        }

        protected void rblSort_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {

            var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
            var firstStage = norco_db.GetMinimumStageId(Convert.ToInt32(Session["CollegeID"]));
            var lastStage = norco_db.GetMaximumStageId(Convert.ToInt32(Session["CollegeID"]));

            if (Convert.ToBoolean(Session["reviewArticulations"]))
            {
                switch (rblSort.SelectedValue)
                {
                    case "0":
                        rgByReview.DataSourceID = "sqlArticulationCoursesByReview";
                        break;
                    case "1":
                        rgByReview.DataSourceID = "sqlArticulationCoursesByReviewMost";
                        break;
                    case "2":
                        rgByReview.DataSourceID = "sqlArticulationCoursesByReviewLess";
                        break;
                    case "3":
                        rgByReview.DataSourceID = "sqlArticulationCoursesByReviewAwaiting";
                        break;
                    default:
                        break;
                }
                rgByReview.DataBind();
            }
            if (Convert.ToBoolean(Session["isArticulationOfficer"]) || userStageID == lastStage)
            {
                switch (rblSort.SelectedValue)
                {
                    case "0":
                        rgByStage.DataSourceID = "sqlArticulationCoursesByStage";
                        break;
                    case "1":
                        rgByStage.DataSourceID = "sqlArticulationCoursesByStageMost";
                        break;
                    case "2":
                        rgByStage.DataSourceID = "sqlArticulationCoursesByStageLess";
                        break;
                    case "3":
                        rgByStage.DataSourceID = "sqlArticulationCoursesByStageAwaiting";
                        break;
                    default:
                        break;
                }
                rgByStage.DataBind();
            }
            if (Convert.ToBoolean(Session["isAdministrator"]) || userStageID == firstStage)
            {
                switch (rblSort.SelectedValue)
                {
                    case "0":
                        rgArticulationCourses.DataSourceID = "sqlArticulationCourses";
                        break;
                    case "1":
                        rgArticulationCourses.DataSourceID = "sqlArticulationCoursesMost";
                        break;
                    case "2":
                        rgArticulationCourses.DataSourceID = "sqlArticulationCoursesLess";
                        break;
                    case "3":
                        rgArticulationCourses.DataSourceID = "sqlArticulationCoursesAwaiting";
                        break;
                    default:
                        break;
                }
                rgArticulationCourses.DataBind();
            }

            
        }

        protected void rgArticulationCourses_DetailTableDataBind(object sender, GridDetailTableDataBindEventArgs e)
        {
            var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
            var lastStage = norco_db.GetMaximumStageId(Convert.ToInt32(Session["CollegeID"]));

            GridDataItem dataItem = (GridDataItem)e.DetailTableView.ParentItem;
            if (e.DetailTableView.Name == "ChildGrid")
            {
                if ( Convert.ToBoolean(Session["isArticulationOfficer"]) || userStageID == lastStage || Convert.ToBoolean(Session["reviewArticulations"]) )
                {
                    e.DetailTableView.DataSourceID = "sqlCourseMatchesByRole";
                }
            }
        }
    }
}