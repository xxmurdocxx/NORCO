using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class Login : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["username"] == "")
                {
                    Page.Form.DefaultFocus = Login1.FindControl("Username").ClientID;
                } else
                {
                    Login1.UserName = Request.QueryString["username"].ToString();
                    Page.Form.DefaultFocus = Login1.FindControl("Password").ClientID;
                }
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
        {
            try
            {
                var authUser = norco_db.ValidateUser(Login1.UserName, GlobalUtil.Encrypt(Login1.Password));
                if (authUser.Count() != 0)
                {
                    CheckBox rm = (CheckBox)Login1.FindControl("RememberMe");
                    HttpCookie Userinfo = new HttpCookie("Userinfo");
                    Response.Cookies.Remove("Userinfo");
                    Userinfo["Username"] = this.Login1.UserName.ToString();
                    Userinfo["RememberMe"] = "false";
                    Response.Cookies.Add(Userinfo);
                    if (rm.Checked)
                    {
                        DateTime dtExpiry = DateTime.Now.AddDays(15);
                        Response.Cookies["Userinfo"].Expires = dtExpiry;
                        Userinfo["RememberMe"] = "true";
                    }
                    else
                    {
                        DateTime dtExpiry = DateTime.Now.AddSeconds(1);
                        Response.Cookies["Userinfo"].Expires = dtExpiry;
                    }
                    FormsAuthentication.SetAuthCookie(Login1.UserName, true);
                    string userName = Login1.UserName;
                    var userData = norco_db.GetUserDataByUserName(userName, Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
                    foreach (GetUserDataByUserNameResult p in userData)
                    {
                        Session["UserID"] = p.UserID;
                        Session["LastName"] = p.LastName;
                        Session["FirstName"] = p.FirstName;
                        Session["UserName"] = p.UserName;
                        Session["CollegeID"] = p.CollegeID;
                        Session["College"] = p.College;
                        Session["RoleID"] = p.RoleID;
                        Session["RoleName"] = p.RoleName;
                        Session["StyleSheet"] = p.StyleSheet;
                        Session["isAdministrator"] = p.isAdministrator;
                        Session["reviewArticulations"] = p.reviewArticulations;
                        Session["isArticulationOfficer"] = p.isArticulationOfficer;
                        Session["PendingDataIntake"] = p.PendingDataIntake;
                        Session["UserStageID"] = norco_db.GetStageIDByRoleId(p.CollegeID, p.RoleID);
                    }
                    
                    ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
                }
                else
                {
                    Login1.FailureText = Resources.Messages.InvalidCredentials;
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(false, ex.ToString());
            }

        }
    }
}