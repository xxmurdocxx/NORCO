using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class ExhibitInformation : System.Web.UI.UserControl
    {
        private int exhibit_id = 0;

        public int ExhibitID
        {
            get { return exhibit_id; }
            set { exhibit_id = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlHighlightedCurrentVersion.SelectParameters["ExhibitID"].DefaultValue = ExhibitID.ToString();
            }
        }
    }
}