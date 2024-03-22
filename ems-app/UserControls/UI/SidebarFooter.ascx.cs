using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace ems_app.UserControls.UI
{
    public partial class SidebarFooter : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                linkTopLogout.Attributes.Add("data-toggle", "tooltip");
                linkTopLogout.Attributes.Add("data-placement", "top");
                linkTopLogout.Attributes.Add("title", "Logout");

                HtmlGenericControl spanLogout = new HtmlGenericControl("span");
                spanLogout.Attributes.Add("class", "glyphicon glyphicon-off");
                spanLogout.Attributes.Add("aria-hidden", "true");

                linkTopLogout.Controls.Add(spanLogout);

                HtmlGenericControl spanPopup = new HtmlGenericControl("span");
                spanPopup.InnerText = "Logout";

                HtmlGenericControl i = new HtmlGenericControl("i");
                i.Attributes.Add("class", "fa fa-sign-out pull-right");

            }
        }

        protected void linkTopLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();

            HttpCookie cookie1 = new HttpCookie(FormsAuthentication.FormsCookieName, "");
            cookie1.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie1);

            SessionStateSection sessionStateSection = (SessionStateSection)WebConfigurationManager.GetSection("system.web/sessionState");
            HttpCookie cookie2 = new HttpCookie(sessionStateSection.CookieName, "");
            cookie2.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie2);

            Response.Redirect(GlobalUtil.ReadSetting("RedirectLoginPage"));
        }

    }
}