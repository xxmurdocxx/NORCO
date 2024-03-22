using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.security
{
    public partial class Profile : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                String userName = User.Identity.Name;
                var userData = norco_db.GetUserDataByUserName(userName, Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
                foreach (GetUserDataByUserNameResult p in userData)
                {
                    rtFirstName.Text = p.FirstName;
                    rtLastName.Text = p.LastName;
                    rtUserName.Text = p.UserName;
                    rtbEmail.Text = p.Email;
                    rcbRoles.SelectedValue = p.RoleID.ToString();
                    rchkAutomaticNotification.Checked = p.AutomaticNotify;
                    rchkWelcome.Checked = p.Welcome;
                    hfUserID.Value = p.UserID.ToString();
                    hfCryptPwd.Value = p.Password;
                }
                hfOnBoarding.Value = Session["OnBOarding"].ToString();
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

        protected void rbUpdate_Click(object sender, EventArgs e)
        {
            var updUser = norco_db.UpdateUser(rtUserName.Text, hfCryptPwd.Value, rtFirstName.Text, rtLastName.Text, rtbEmail.Text, Convert.ToInt32(rcbRoles.SelectedValue), Convert.ToInt32(hfUserID.Value), rchkAutomaticNotification.Checked, rchkWelcome.Checked, (bool?)Session["SuperUser"], (bool?)Session["DistrictAdministrator"]);
            Session["OnBoarding"] = rchkWelcome.Checked;
            lblUserMessage.CssClass = "alert-success";
            lblUserMessage.Text = Resources.Messages.UserUpdated;
        }
    }
}