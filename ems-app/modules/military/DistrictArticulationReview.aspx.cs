using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.military
{
    public partial class DistrictArticulationReview : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
        }

        protected void ToggleRowSelection(object sender, EventArgs e)
        {
            ((sender as CheckBox).NamingContainer as GridItem).Selected = (sender as CheckBox).Checked;
            bool checkHeader = true;
            foreach (GridDataItem dataItem in rgFacultyReview.MasterTableView.Items)
            {
                if (!(dataItem.FindControl("CheckBox1") as CheckBox).Checked)
                {
                    checkHeader = false;
                    break;
                }
            }
            GridHeaderItem headerItem = rgFacultyReview.MasterTableView.GetItems(GridItemType.Header)[0] as GridHeaderItem;
            (headerItem.FindControl("headerChkbox") as CheckBox).Checked = checkHeader;
        }
        protected void ToggleSelectedState(object sender, EventArgs e)
        {
            CheckBox headerCheckBox = (sender as CheckBox);
            foreach (GridDataItem dataItem in rgFacultyReview.MasterTableView.Items)
            {
                (dataItem.FindControl("CheckBox1") as CheckBox).Checked = headerCheckBox.Checked;
                dataItem.Selected = headerCheckBox.Checked;
            }
        }

        public void showAssignArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly)
        {
            if (isReadOnly)
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
            }

        }

        public void showAssignOccupationArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly)
        {
            if (isReadOnly)
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgFacultyReview_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;

            if (e.CommandName == "RowClick")
            {
                GridDataItem item = (GridDataItem)grid.MasterTableView.Items[grid.SelectedItems[0].ItemIndex];
                var vote_type = item["VoteType"].Text;
                if (vote_type == "Denied")
                {
                    //item.BackColor = System.Drawing.Color.LightPink;
                    item.ForeColor = System.Drawing.Color.Black;
                    item.Font.Bold = true;
                }
            }

            if (grid.SelectedItems.Count <= 0)
            {
                DisplayMessage(false, "Select an articulation");
            }
            else
            {
                if (e.CommandName == "Approved")
                {
                    foreach (GridDataItem item in grid.Items)
                    {
                        if ((item.FindControl("CheckBox1") as CheckBox).Checked)
                        {
                            norco_db.EnforceFacultyProccess(Convert.ToInt32(item["id"].Text), Convert.ToInt32(Session["CollegeID"]), item["subject"].Text, item["course_number"].Text, item["AceID"].Text, Convert.ToDateTime(item["TeamRevd"].Text),1, Convert.ToInt32(Session["UserID"]), null);
                        }
                    }
                    grid.DataBind();
                }
                if (e.CommandName == "Denied")
                {
                    pnlAddReason.Visible = true;
                    pnlAddReason.Focus();
                    rtbReason.Text = "";
                }
                if (e.CommandName == "ViewArticulation")
                {
                    if (e.Item.OwnerTableView.Name == "ParentGrid")
                    {
                        var outline_id = itemDetail["outline_id"].Text;
                        var articulation_id = itemDetail["ArticulationID"].Text;
                        var isSource = itemDetail["IsSource"].Text;

                        if (isSource == "False" && articulation_id == "0")
                        {
                            var sourceArticulation = norco_db.GetFacultyReviewSourceArticulation(itemDetail["subject"].Text, itemDetail["course_number"].Text, itemDetail["AceID"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text));
                            foreach (GetFacultyReviewSourceArticulationResult item in sourceArticulation)
                            {
                                outline_id = item.outline_id.ToString();
                                articulation_id = item.ArticulationID.ToString();
                            }
                        }

                        if (itemDetail["articulation_type"].Text == "1")
                        {
                            showAssignArticulation(Convert.ToInt32(articulation_id), Convert.ToInt32(outline_id), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), true);
                        }
                        else
                        {
                            showAssignOccupationArticulation(Convert.ToInt32(articulation_id), Convert.ToInt32(outline_id), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), true);
                        }
                    }
                }

            }
        }

        protected void rgFacultyReview_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var VoteType = dataBoundItem["VoteType"].Text;
                var IsSource = dataBoundItem["IsSource"].Text;
                CheckBox checkbox1 = e.Item.FindControl("CheckBox1") as CheckBox;
                checkbox1.Enabled = true;
                if (VoteType == "Submitted next stage" || IsSource == "True")
                {
                    checkbox1.Enabled = false;
                }
                var vote_type = dataBoundItem["VoteType"].Text;
                if (vote_type == "Denied")
                {
                    //dataBoundItem.BackColor = System.Drawing.Color.LightPink;
                    dataBoundItem.ForeColor = System.Drawing.Color.Black;
                    dataBoundItem.Font.Bold = true;
                }
            }
        }

        protected void rbCancel_Click(object sender, EventArgs e)
        {
            pnlAddReason.Visible = false;
            rtbReason.Text = "";
        }

        protected void rbDenied_Click(object sender, EventArgs e)
        {
            if (rgFacultyReview.SelectedItems.Count <= 0)
            {
                DisplayMessage(false, "Select an articulation");
            }
            else
            {
                foreach (GridDataItem item in rgFacultyReview.Items)
                {
                    if ((item.FindControl("CheckBox1") as CheckBox).Checked)
                    {
                        norco_db.EnforceFacultyProccess(Convert.ToInt32(item["id"].Text), Convert.ToInt32(Session["CollegeID"]), item["subject"].Text, item["course_number"].Text, item["AceID"].Text, Convert.ToDateTime(item["TeamRevd"].Text), 2, Convert.ToInt32(Session["UserID"]), rtbReason.Text);
                    }
                }
                rgFacultyReview.DataBind();
                pnlAddReason.Visible = false;
                rtbReason.Text = "";
            }
        }
    }


}