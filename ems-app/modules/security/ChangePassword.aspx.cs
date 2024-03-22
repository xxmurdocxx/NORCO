using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.security
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if ((HttpContext.Current.User.Identity.Name != null) && HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    String userName = User.Identity.Name;
                    var userData = norco_db.GetUserDataByUserName(userName, Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
                    foreach (GetUserDataByUserNameResult p in userData)
                    {
                        hfUserID.Value = p.UserID.ToString();
                        hfCryptPwd.Value = p.Password;
                    }
                }
            }          
        }

        protected void ChangePassword1_ChangingPassword(object sender, LoginCancelEventArgs e)
        {
            if (!ChangePassword1.CurrentPassword.Equals(ChangePassword1.NewPassword, StringComparison.CurrentCultureIgnoreCase))
            {
                String userName = User.Identity.Name;
                var updatePwd = norco_db.UpdatePassword(userName, GlobalUtil.Encrypt(ChangePassword1.NewPassword), GlobalUtil.Encrypt(ChangePassword1.CurrentPassword));
                var checkUser = 0;
                foreach (UpdatePasswordResult up in updatePwd)
                {
                    checkUser = Convert.ToInt32(up.CheckUser);
                }
                if (checkUser == 1)
                {
                    lblMessage.CssClass = "alert-success";
                    lblMessage.Text = Resources.Messages.PasswordUpdated;
                    Session["ChangedPassword"] = true;
                    Response.Redirect("/modules/dashboard/Default.aspx");
                }
                else
                {
                    lblMessage.CssClass = "alert-danger";
                    lblMessage.Text = Resources.Messages.PasswordMismatch;
                }
            }
            else
            {
                lblMessage.CssClass = "alert-danger";
                lblMessage.Text = Resources.Messages.PasswordEquals;
            }

            e.Cancel = true;
        }

        protected void ChangePassword1_CancelButtonClick(object sender, EventArgs e)
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

            FormsAuthentication.RedirectToLoginPage();
        }
    }
}