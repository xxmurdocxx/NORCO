using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class VeteranArticulations : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["CollegeID"] != null && Request.QueryString["VeteranID"] != null && Request.QueryString["Occupation"] != null)
            {
                ucVeteranArticulations.CollegeID = Convert.ToInt32(Request.QueryString["CollegeID"]);
                ucVeteranArticulations.VeteranID = Convert.ToInt32(Request.QueryString["VeteranID"]);
                ucVeteranArticulations.Occupation = Request.QueryString["Occupation"];
            }
        }
    }
}