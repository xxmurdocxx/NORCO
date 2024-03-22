using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class ShowArticulations : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rgVeteranLeads.Visible = false;
                rgPublishedArticulations.Visible = false;
                pnlArticulations.Visible = false;
                pnlOccupations.Visible = false;
                pnlCourses.Visible = false;
                rgPublishedCourses.Visible = false;

                pageTitle.InnerHtml = Request["Title"];
                pnlOrderBy.Visible = false;



                if (Request["Order"] != null)
                {
                    hvStageID.Value = norco_db.GetStageIDByOrder( Convert.ToInt32(Request["CollegeID"]), Convert.ToInt32(Request["Order"])).ToString();
                }

                if (Request["Type"] != null)
                {
                    if (Request["Type"] == "1") //
                    {
                        pnlOrderBy.Visible = true;
                        pnlArticulations.Visible = true;
                    }
                    if (Request["Type"] == "2") //published
                    {
                        //rgArticulationCourses.DataSourceID = "sqlPublishedArticulations";
                        pnlArticulations.Visible = true;
                        //rgArticulationCourses.DataBind();
                        rgArticulationCourses.Visible = false;
                        rgPublishedCourses.Visible = true;
                        rtsArticulations.Tabs[0].Visible = false;
                        rtsArticulations.Tabs[1].Visible = false;
                    }
                    if (Request["Type"] == "3") // qualified vets
                    {
                        rgVeteranLeads.Visible = true;
                    }
                    if (Request["Type"] == "5") //published
                    {
                        rgPublishedArticulations.Visible = true;
                    }
                    if (Request["Type"] == "4")
                    {
                        if (Request["StatsType"]== "ACE Course(s)")
                        {
                            pnlCourses.Visible = true;
                        }
                        if (Request["StatsType"] == "ACE Occupation(s)")
                        {
                            pnlOccupations.Visible = true;
                        }
                        if (Request["StatsType"] == "Courses")
                        {
                            pnlOrderBy.Visible = true;
                            pnlArticulations.Visible = true;
                        }
                    }
                }
                
            }
        }

        protected void rblSort_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            switch (rblSort.SelectedValue)
            {
                case "0":
                    rgArticulationCourses.DataSourceID = "sqlArticulationCoursesByStage";
                    rgDeniedArticulationCourses.DataSourceID = "sqlDeniedArticulationCoursesByStage";
                    break;
                case "1":
                    rgArticulationCourses.DataSourceID = "sqlArticulationCoursesByStageMost";
                    rgDeniedArticulationCourses.DataSourceID = "sqlDeniedArticulationCoursesByStageMost";
                    break;
                case "2":
                    rgArticulationCourses.DataSourceID = "sqlArticulationCoursesByStageLess";
                    rgDeniedArticulationCourses.DataSourceID = "sqlDeniedArticulationCoursesByStageLess";
                    break;
                case "3":
                    rgArticulationCourses.DataSourceID = "sqlArticulationCoursesByStageAwaiting";
                    rgDeniedArticulationCourses.DataSourceID = "sqlDeniedArticulationCoursesByStageAwaiting";
                    break;
                default:
                    break;
            }
        }

        protected void rgArticulations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            var isReadOnly = false;
            if (e.CommandName == "EditNotes")
            {
                if (Session["CollegeID"].ToString() != Request["CollegeID"])
                {
                    isReadOnly = true;
                }
                if (itemDetail["articulation_type"].Text == "1")
                {

                        showAssignArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), isReadOnly, itemDetail["College"].Text);

                }
                else
                {

                        showAssignOccupationArticulation(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), isReadOnly, itemDetail["College"].Text);
                        
                }
            }

            if (e.CommandName == "ViewDocuments")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select an articulation");
                }
                else
                {
                    var id = itemDetail["id"].Text;
                    var url = String.Format("../popups/ArticulationDocuments.aspx?id={0}", id);
                    RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 900, 500));
                }
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }


        public void showAssignArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly, string collegeName)
        {
            var adoptParameter = "";
            var otherCollegeIDParameter = "";
            if (isReadOnly)
            {
                if (Session["CollegeID"].ToString() != Request["CollegeID"])
                {
                    adoptParameter = "&AdoptArticulation=true";
                    otherCollegeIDParameter = string.Format("&OtherCollegeID={0}&CollegeName={1}", Request["CollegeID"], collegeName);
                } 
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true{5}{6}", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), adoptParameter, otherCollegeIDParameter) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
            }

        }

        public void showAssignOccupationArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly, string collegeName)
        {
            var adoptParameter = "";
            var otherCollegeIDParameter = "";
            if (isReadOnly)
            {
                if (Session["CollegeID"].ToString() != Request["CollegeID"])
                {
                    adoptParameter = "&AdoptArticulation=true";
                    otherCollegeIDParameter = string.Format("&OtherCollegeID={0}&CollegeName={1}", Request["CollegeID"], collegeName);
                }
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true{5}{6}", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), adoptParameter, otherCollegeIDParameter) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
            }
        }

        protected void rgArticulations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && (e.Item.OwnerTableView.Name == "ParentGrid" ))
            {

                GridDataItem dataBoundItem = e.Item as GridDataItem;

                int documents = Convert.ToInt32(dataBoundItem["Document"].Text);
                LinkButton btnDocument = e.Item.FindControl("btnDocuments") as LinkButton;
                if (documents != 0)
                {
                    btnDocument.Visible = true;
                }

                //dataBoundItem.BackColor = System.Drawing.Color.LightGreen;
                //var adopted = dataBoundItem["adopted"].Text;
                //if (adopted == "True")
                //{
                //    dataBoundItem.BackColor = System.Drawing.Color.LightBlue;
                //}
            }
        }

        protected void rgArticulationCourses_ItemDataBound(object sender, GridItemEventArgs e)
        {

            if (e.Item is GridDataItem && (e.Item.OwnerTableView.Name == "ChildGrid" || e.Item.OwnerTableView.Name == "ChildGridOccupations") )
            {

                GridDataItem dataBoundItem = e.Item as GridDataItem;

                int documents = Convert.ToInt32(dataBoundItem["Document"].Text);
                LinkButton btnDocument = e.Item.FindControl("btnDocuments") as LinkButton;
                if (documents != 0)
                {
                    btnDocument.Visible = true;
                }

                Label lbl_articulate_notes = e.Item.FindControl("lblArticulationNotes") as Label;
                lbl_articulate_notes.Visible = false;
                if (dataBoundItem["Notes"].Text != "" && dataBoundItem["Notes"].Text != "&nbsp;")
                {
                    lbl_articulate_notes.Visible = true;
                    lbl_articulate_notes.ToolTip = dataBoundItem["Notes"].Text;
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
            }
        }

        protected void rgDeniedOccupations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem )
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;

                int documents = Convert.ToInt32(dataBoundItem["Document"].Text);
                LinkButton btnDocument = e.Item.FindControl("btnDocuments") as LinkButton;
                if (documents != 0)
                {
                    btnDocument.Visible = true;
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
            }
        }

        protected void grid_PreRender(object sender, EventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (grid.IsExporting)
            {
                foreach (GridFilteringItem item in grid.MasterTableView.GetItems(GridItemType.FilteringItem))
                {
                    item.Visible = false;
                }
            }
        }
    }
}