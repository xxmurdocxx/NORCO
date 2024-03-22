using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class UnknownOccupationsNotification : System.Web.UI.UserControl
    {
        NORCODataContext norco_db = new NORCODataContext();
        private bool is_administrator = false;

        public bool isAdministrator
        {
            get { return is_administrator; }
            set { is_administrator = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                unknownNotification.Visible = false;
                if (isAdministrator)
                {
                    unknownNotification.Visible = true;
                    var unknownOccupations = norco_db.CountUnknownOccupations(Convert.ToInt32(Session["CollegeID"]));
                    unknownText.InnerHtml = "Currently there are : <br/>";
                    foreach (CountUnknownOccupationsResult item in unknownOccupations)
                    {
                        unknownText.InnerHtml += string.Format("- {1} {0} ", item.ResultType, item.ResultsCount);
                    }
                    unknownText.InnerHtml += "To review these MOS's please <a href='/modules/leads/ManageVeteranOccupations.aspx'>follow this link.</a>";
                }
            }

        }
    }
}