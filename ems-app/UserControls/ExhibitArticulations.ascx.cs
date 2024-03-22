using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.UserControls
{
    public partial class ExhibitArticulations : System.Web.UI.UserControl
    {
        int exhibitID = 0;
        public int ExhibitID
        {
            get
            {
                if (ViewState["ExhibitID"] != null)
                { exhibitID = Int32.Parse(ViewState["ExhibitID"].ToString()); };
                return exhibitID;
            }
            set { ViewState["ExhibitID"] = value; }
        }
 
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlCoursesArticulated.SelectParameters["ExhibitID"].DefaultValue = ExhibitID.ToString();
                sqlCoursesArticulated.DataBind();
            }
        }
        protected void rgCoursesArticulated_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "View")
            {
                showArticulation(Convert.ToInt32(itemDetail["ID"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), Convert.ToInt32(itemDetail["ExhibitID"].Text));
            }
        }

        public void RefreshData()
        {
            rgCoursesArticulated.DataBind();
        }
        protected void rgCoursesArticulated_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;

                LinkButton lbView = e.Item.FindControl("btnView") as LinkButton;
                lbView.Visible = false;
                if (dataBoundItem["ID"].Text != "0")
                {
                    lbView.Visible = true;
                }

            }
        }

        public void showArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, int ExhibitID)
        {
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
        }


    }
}