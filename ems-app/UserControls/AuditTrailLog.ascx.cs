using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class AuditTrailLog : System.Web.UI.UserControl
    {

        private int articulation_id = 0;
        private bool hide_ace_columns = false;
        public int ArticulationId
        {
            get { return articulation_id; }
            set { articulation_id = value; }
        }

        public bool HideAceColumns
        {
            get { return hide_ace_columns; }
            set { hide_ace_columns = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfArticulationID.Value = ArticulationId.ToString();
            }
        }
        protected void rgAuditTrail_PreRender(object sender, EventArgs e)
        {
            if (HideAceColumns)
            {
                rgAuditTrail.MasterTableView.GetColumn("Course").Visible = false;
                rgAuditTrail.MasterTableView.GetColumn("ArticulationType").Visible = false;
                rgAuditTrail.MasterTableView.GetColumn("AceID").Visible = false;
                rgAuditTrail.MasterTableView.GetColumn("TeamRevd").Visible = false;
                rgAuditTrail.MasterTableView.GetColumn("Title").Visible = false;
                rgAuditTrail.Rebind();
            }
        }
    }
}