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
    public partial class Notifications : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        Dictionary<int, int> articulations = new Dictionary<int, int>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    if (Session["UserName"] != null)
                    { 
                    hvUserName.Value = Session["UserName"].ToString();
                    hvUserID.Value = Session["UserID"].ToString();
                    hvCollegeID.Value = Session["CollegeID"].ToString();
                    hvUserStageID.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])).ToString();
                    }
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

        protected void rgPendingToNotiify_ItemCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                RadGrid grid = (RadGrid)sender;
                GridDataItem itemDetail = e.Item as GridDataItem;


                if (e.CommandName == "Notify")
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
                        Session["articulationList"] = articulations;
                        var url = String.Format("../popups/Notify.aspx?Action=Notify&UserStageID={0}&UserName={1}&UserID={2}&CollegeID={3}", hvUserStageID.Value, hvUserName.Value, hvUserID.Value, hvCollegeID.Value);
                        RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 600, 600));
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            rgPendingToNotiify.DataBind();
        }

        protected void rgPendingToNotiify_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem )
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                Label lbl_articulate_notes = e.Item.FindControl("lblArticulationNotes") as Label;
                if (dataBoundItem["ArticulationNotes"].Text != "")
                {
                    lbl_articulate_notes.Visible = true;
                    lbl_articulate_notes.ToolTip = dataBoundItem["ArticulationNotes"].Text;
                }
            }
        }
    }
}