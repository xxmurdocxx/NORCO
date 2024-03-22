using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class Eligibility : System.Web.UI.UserControl
    {
        private string ace_id = "";
        private string team_revd = "";
        private int articulation_stage = 0;
        private int outline_id = 0;

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

        public int ArticulationStage
        {
            get { return articulation_stage; }
            set { articulation_stage = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlEligibility.SelectParameters["AceID"].DefaultValue = AceID;
                sqlEligibility.SelectParameters["TeamRevd"].DefaultValue = TeamRevd; 
                sqlEligibility.SelectParameters["OutlineID"].DefaultValue = OutlineID.ToString();
                sqlEligibility.SelectParameters["ArticulationStage"].DefaultValue = ArticulationStage.ToString();
            }
        }
    }
}