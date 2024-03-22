using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace ems_app
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            Telerik.Reporting.Services.WebApi.ReportsControllerConfiguration.RegisterRoutes(System.Web.Http.GlobalConfiguration.Configuration);
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                string currentUrlAbsPath = HttpContext.Current.Request.Url.AbsolutePath;
                string currentUrlAbsUri = HttpContext.Current.Request.Url.AbsoluteUri;

                if (currentUrlAbsPath.EndsWith("EmailAccess_o.aspx", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect(currentUrlAbsUri);
                }
                else
                {
                    Response.Redirect("/modules/security/Login.aspx");
                }


                //Redirect to Login Page if Session is null & Expires     
                //Response.Redirect("/modules/security/Login.aspx");
                //Response.Redirect("/Down.htm");  //04 / 24 / 23
            }

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}