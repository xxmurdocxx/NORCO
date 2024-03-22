using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class Audit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AuditTrailViewer.Visible = false;
                AuditTrailLogViewer.Visible = false;
                if (Request["ArticulationID"] != null)
                {
                    AuditTrailLogViewer.ArticulationId = Convert.ToInt32(Request["ArticulationID"]);
                    AuditTrailLogViewer.HideAceColumns = true;
                    AuditTrailLogViewer.Visible = true;
                } else
                {
                    AuditTrailViewer.AceID = Request["AceID"];
                    AuditTrailViewer.TeamRevd = Request["TeamRevd"];
                    AuditTrailViewer.OutlineID = Convert.ToInt32(Request["OutlineID"]);
                    AuditTrailViewer.HideAceColumns = false;
                    AuditTrailViewer.CollegeID = 0;
                    AuditTrailViewer.UserID = 0;
                    AuditTrailViewer.StageID = 0;
                    AuditTrailViewer.Visible = true;
                }

            }
        }
    }
}