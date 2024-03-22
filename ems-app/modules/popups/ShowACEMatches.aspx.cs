using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class ShowACEMatches : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void rgArticulationCourses_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;
            if (e.CommandName == "ShowACEDEtail")
            {
                String AceID = item["AceID"].Text;
                showACEDetails(AceID);
            }
            Int32 outline_id = Convert.ToInt32(item["outline_id"].Text);
            if (e.CommandName == "ViewCourse")
            {
                showCourseDetails(outline_id);
            }
        }
        public void showCourseDetails(Int32 outline_id)
        {
            RadWindow windowCD = new RadWindow();
            windowCD.NavigateUrl = "../popups/ShowCourseDetail.aspx?outline_id=" + outline_id.ToString();
            windowCD.VisibleOnPageLoad = true;
            windowCD.Modal = true;
            windowCD.VisibleStatusbar = false;
            windowCD.ID = "RadWindowCD";
            windowCD.Width = 700;
            windowCD.Height = 400;
            RadWindowManager1.Windows.Add(windowCD);
        }

        public void showACEDetails(String AceID)
        {
            RadWindow windowACD = new RadWindow();
            windowACD.NavigateUrl = "../popups/ShowACECourseDetail.aspx?AceID=" + AceID;
            windowACD.VisibleOnPageLoad = true;
            windowACD.Modal = true;
            windowACD.VisibleStatusbar = false;
            windowACD.ID = "RadWindowACD";
            windowACD.Width = 700;
            windowACD.Height = 400;
            RadWindowManager1.Windows.Add(windowACD);
        }

    }
}