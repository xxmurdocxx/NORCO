using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class OtherOccupationsHaveCriteria : System.Web.UI.Page
    {

        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request["ArticulationType"] == "1")
                {
                    popupTitle.InnerText = "Other Courses have this criteria";
                }
                if (Request["ArticulationType"] == "2")
                {
                    popupTitle.InnerText = "Other Occupations have this criteria";
                }
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgOccupations_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.CommandName == "AddAllOccupations")
            {
                grid.AllowPaging = false;
                grid.Rebind();
                foreach (GridDataItem itemDetail in grid.Items)
                {
                    try
                    {
                        var articulationId = 0;
                        if (Request["ArticulationType"] == "1")
                        {
                            articulationId = Controllers.Articulation.AddArticulation(Convert.ToInt32(Request["outline_id"]), itemDetail["AceID"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), itemDetail["Title"].Text, "", "", "", "", 1, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]),false,6,false,99999999);
                        }
                        if (Request["ArticulationType"] == "2")
                        {
                            articulationId = Controllers.Articulation.AddArticulation(Convert.ToInt32(Request["outline_id"]), itemDetail["AceID"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), itemDetail["Title"].Text, "", "", "", "", 2, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]),false,6,false,999999999);
                        }
                        //var addCriteria = norco_db.AddArticulationCriteria(articulationId, Convert.ToInt32(Request["ArticulationType"]), Convert.ToInt32(Session["UserID"]), Session["BackColor"].ToString(), Session["ForeColor"].ToString(), Request["Criteria"], 1);
                        //Copy Criteria
                        norco_db.CopyArticulationCriteria(Convert.ToInt32(Request["ArticulationID"]), Convert.ToInt32(Request["ArticulationType"]), articulationId, Convert.ToInt32(Session["UserID"]));
                    }
                    catch (Exception ex)
                    {
                        DisplayMessage(false, ex.ToString());
                    }
                }
                grid.AllowPaging = true;
                DisplayMessage(false, "Articulations were created successfully");
                grid.DataBind();
            }

            if (e.CommandName == "AddOccupation")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please check to add selected occupation(s).");
                }
                else
                {
                    try
                    {
                        foreach (GridDataItem items in grid.SelectedItems)
                        {
                            var articulationId = 0;
                            if (Request["ArticulationType"] == "1")
                            {
                                articulationId = Controllers.Articulation.AddArticulation(Convert.ToInt32(Request["outline_id"]), items["AceID"].Text, Convert.ToDateTime(items["TeamRevd"].Text), items["Title"].Text, "", "", "", "", 1, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false,6,false,999999);
                            }
                            if (Request["ArticulationType"] == "2")
                            {
                                articulationId = Controllers.Articulation.AddArticulation(Convert.ToInt32(Request["outline_id"]), items["AceID"].Text, Convert.ToDateTime(items["TeamRevd"].Text), items["Title"].Text, "", "", "", "", 2, Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false,6,false,9999999);
                            }
                            //var addCriteria = norco_db.AddArticulationCriteria(articulationId, Convert.ToInt32(Request["ArticulationType"]), Convert.ToInt32(Session["UserID"]), Session["BackColor"].ToString(), Session["ForeColor"].ToString(), Request["Criteria"], 1);
                            //Copy criteria
                            norco_db.CopyArticulationCriteria(Convert.ToInt32(Request["ArticulationID"]), Convert.ToInt32(Request["ArticulationType"]), articulationId, Convert.ToInt32(Session["UserID"]));
                        }
                        //foreach (GridDataItem itemDetail in grid.Items)
                        //{
                        //    if ((itemDetail.FindControl("CheckBox1") as CheckBox).Checked)
                        //    {
                                
                        //    }
                        //}
                        DisplayMessage(false, "Articulations were created successfully");
                        grid.DataBind();
                    }
                    catch (Exception ex)
                    {
                        DisplayMessage(false, ex.ToString());
                    }
                }
            }
        }

        protected void rgOccupations_PreRender(object sender, EventArgs e)
        {
            if (Request["ArticulationType"] == "1")
            {
                rgOccupations.MasterTableView.GetColumn("Occupation").Visible = false;
            }
            //if (Request["ArticulationType"] == "2")
            //{
            //    rgOccupations.MasterTableView.GetColumn("GrandPrix").Visible = false;
            //}
            rgOccupations.Rebind();
        }

        protected void rgOccupations_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridCommandItem)
            {
                GridCommandItem commandItem = e.Item as GridCommandItem;
                RadButton button1 = commandItem.FindControl("btnAddOccupation") as RadButton;
                RadButton button2 = commandItem.FindControl("btnAddAllOccupations") as RadButton;
                if (Request["ArticulationType"] == "1")
                {
                    button1.Text = " Add selected courses";
                    button2.Text = " Add all courses";
                    button1.ToolTip = "Check to add selected courses.";
                    button2.ToolTip = "Add all courses.";
                }
                if (Request["ArticulationType"] == "2")
                {
                    button1.Text = " Add selected occupations";
                    button2.Text = " Add all occupations";
                    button1.ToolTip = "Check to add selected occupations.";
                    button2.ToolTip = "Add all occupations.";
                }
            }
        }
    }
}