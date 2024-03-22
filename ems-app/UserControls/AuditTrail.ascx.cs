using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class AuditTrail : System.Web.UI.UserControl
    {
        /*

 @CollegeID int,
 @UserID int,
 @StageID int
        */
        private string ace_id = "";
        private string team_revd = "";
        private int outline_id = 0;
        private bool hide_ace_columns = false;
        private int college_id = 0;
        private int user_id = 0;
        private int stage_id = 0;
        public int OutlineID
        {
            get { return outline_id; }
            set { outline_id = value; }
        }
        public string AceID
        {
            get { return ace_id; }
            set { ace_id = value; }
        }
        public string TeamRevd
        {
            get { return team_revd; }
            set { team_revd = value; }
        }
        public bool HideAceColumns
        {
            get { return hide_ace_columns; }
            set { hide_ace_columns = value; }
        }
        public int CollegeID
        {
            get { return college_id; }
            set { college_id = value; }
        }
        public int UserID
        {
            get { return user_id; }
            set { user_id = value; }
        }
        public int StageID
        {
            get { return stage_id; }
            set { stage_id = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlAudit.SelectParameters["AceID"].DefaultValue = AceID;
                sqlAudit.SelectParameters["AceID"].ConvertEmptyStringToNull = false;
                sqlAudit.SelectParameters["TeamRevd"].DefaultValue = TeamRevd;
                sqlAudit.SelectParameters["TeamRevd"].ConvertEmptyStringToNull = false;
                sqlAudit.SelectParameters["OutlineID"].DefaultValue = OutlineID.ToString();
                sqlAudit.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlAudit.SelectParameters["UserID"].DefaultValue = UserID.ToString();
                sqlAudit.SelectParameters["StageID"].DefaultValue = StageID.ToString();
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