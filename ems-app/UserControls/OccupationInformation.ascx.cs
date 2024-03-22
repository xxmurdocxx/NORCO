using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class OccupationInformation : System.Web.UI.UserControl
    {
        private string ace_id = "";
        private string team_revd = "";
        private int articulation_id = 0;
        private int articulation_type = 0;

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

        public int ArticulationID
        {
            get { return articulation_id; }
            set { articulation_id = value; }
        }

        public int ArticulationType
        {
            get { return articulation_type; }
            set { articulation_type = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlACEOccupationHeader.SelectParameters["AceID"].DefaultValue = AceID.ToString();
                sqlACEOccupationHeader.SelectParameters["TeamRevd"].DefaultValue = TeamRevd.ToString();
                sqlHighlightedRecommendations.SelectParameters["AceID"].DefaultValue = AceID.ToString();
                sqlHighlightedRecommendations.SelectParameters["TeamRevd"].DefaultValue = TeamRevd.ToString();
                sqlHighlightedRecommendations.SelectParameters["ArticulationID"].DefaultValue = ArticulationID.ToString();
                sqlHighlightedRecommendations.SelectParameters["ArticulationType"].DefaultValue = ArticulationType.ToString();
            }
        }
    }
}