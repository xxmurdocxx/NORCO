using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class ShowACECourseDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["AdvancedSearch"] != null)
                {
                    Session["SelectedCourseTitle"] = string.Join(" ", Request.QueryString["AdvancedSearch"].ToString());
                } else
                {
                    Session["SelectedCourseTitle"] = string.Join(" ", Request.QueryString["Title"].ToString());
                }
                hfAdvancedSearch.Value = Session["SelectedCourseTitle"].ToString();
            }
        }
    }
}