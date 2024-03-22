using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class QualifiedVetsButtons : System.Web.UI.UserControl
    {
        public int CollegeID { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
                hfCollegeID.Value = CollegeID.ToString();
        }
    }
}