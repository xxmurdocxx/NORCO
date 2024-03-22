using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class TopCollegeArticulations : System.Web.UI.UserControl
    {
        int topNumber = 0;
        int onlyPublished = 0;
        public int TopNumber
        {
            get
            {
                if (ViewState["topNumber"] != null)
                { topNumber = Int32.Parse(ViewState["topNumber"].ToString()); };
                return topNumber;
            }
            set { ViewState["topNumber"] = value; }
        }
        public int OnlyPublished
        {
            get
            {
                if (ViewState["onlyPublished"] != null)
                { topNumber = Int32.Parse(ViewState["onlyPublished"].ToString()); };
                return onlyPublished;
            }
            set { ViewState["onlyPublished"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlTopCollegesArticulations.SelectParameters["TopNumber"].DefaultValue = TopNumber.ToString();
                sqlTopCollegesArticulations.SelectParameters["OnlyPublished"].DefaultValue = OnlyPublished.ToString();
            }
        }
    }
}