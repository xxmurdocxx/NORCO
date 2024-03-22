using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Security.Cryptography;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Security.Policy;
using ems_app.Common.infrastructure;
using Telerik.Barcode;

namespace ems_app.modules.users
{
    public partial class Login : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Init(object sender, EventArgs e)
        {

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Remove(".ASPXAUTH");
            Session.Remove("ASP.NET_SessionId");
            Session.Remove("_csrf");

            if (!IsPostBack)
            {         
                this.Page.Title = GlobalUtil.ReadSetting("AppName");
                lblAppName.Text = GlobalUtil.ReadSetting("AppName");
                lblBussinesName.Text = GlobalUtil.ReadSetting("BusinessName");

                TextBox tb = (TextBox)Login1.FindControl("UserName");

                if (Request["username"] != null)
                {
                    tb.Text = Request["username"].ToString();
                    Page.Form.DefaultFocus = Login1.FindControl("Password").ClientID;
                }
                divForgotPassword.Visible = false;
                divNewUser.Visible = false;
            }


           //  rnSystemNotification.Show();

        }

        protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
        {
            //var authUser = norco_db.ValidateUser(Login1.UserName,  GlobalUtil.Encrypt(Login1.Password));
            var authUser = CheckPassword(Login1.UserName, GlobalUtil.Encrypt(Login1.Password));
            if (authUser == 1)
            {
                //User Information
                var userData = norco_db.GetUserDataByUserName(Login1.UserName, Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
                foreach (GetUserDataByUserNameResult p in userData)
                {
                    Session["UserID"] = p.UserID;
                    Session["LastName"] = p.LastName;
                    Session["FirstName"] = p.FirstName;
                    Session["UserName"] = p.UserName;
                    Session["CollegeID"] = p.CollegeID;
                    Session["College"] = p.College;
                    Session["CollegeAbbreviation"] = GetCollegeAbbreviation(Convert.ToInt32(p.CollegeID));
                    Session["RoleID"] = p.RoleID;
                    Session["RoleName"] = p.RoleName;
                    Session["StyleSheet"] = p.StyleSheet;
                    Session["isAdministrator"] = p.isAdministrator;
                    Session["reviewArticulations"] = p.reviewArticulations;
                    Session["isArticulationOfficer"] = p.isArticulationOfficer;
                    Session["PendingDataIntake"] = p.PendingDataIntake;
                    Session["UserStageID"] = norco_db.GetStageIDByRoleId(p.CollegeID, p.RoleID);
                    Session["UserStageOrder"] = norco_db.GetStageOrderByRoleId(p.CollegeID, p.RoleID);
                    Session["CollegeLogo"] = p.CollegeLogo;
                    Session["OnBoarding"] = p.Welcome.ToString();
                    Session["SuperUser"] = p.SuperUser ?? false;
                    Session["DistrictAdministrator"] = p.DistrictAdministrator ?? false;
                    Session["ChangedPassword"] = CheckChangedPassword((int)p.UserID);
                    Session["SystemNotificationUpdate"] = true;
                    Session["SystemNotificationAlert"] = true;
                }
                // 04-30-23
                //if (Session["UserID"].ToString() != "1")
                //{
                //    Response.Redirect("~/Down.htm");
                //};
                if ((bool)Session["SuperUser"] || (bool)Session["DistrictAdministrator"])
                {
                    FormsAuthentication.SetAuthCookie(Login1.UserName, false);
                    Response.Redirect("~/modules/dashboard/SuperUser.aspx");
                }
                else
                {
                    FormsAuthentication.RedirectFromLoginPage(Login1.UserName, false);
                }
                
            }
            else
            {
                if (authUser == -1)
                {
                    Login1.FailureText = Resources.Messages.InvalidCredentials;
                } else {
                    Login1.FailureText = "<a href='mailto:mapadmin@mappingarticulatedpathways.org' style='font-weight:normal;color:darkblue !important;'>Your account has been deactivated. If you feel this is an error, please contact MAP Support.</a>";
                }
            }
        }


        protected void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                var getPwd = norco_db.RememberPasswordByEmail(rtbUsername.Text);
                var pwd = "";
                lblRememberPassword.Style.Add("color", "#ff0000");
                foreach (RememberPasswordByEmailResult item in getPwd)
                {
                    pwd = item.Password;
                }
                if (pwd == "NotFound")
                {
                    lblRememberPassword.Text = "Email not found in database.";
                }
                else
                {
                    var decryptedPwd = GlobalUtil.Decrypt(pwd);
                    var _subject = "Recover your password";
                    var _body = GetUser(rtbUsername.Text);
                    var _from = GlobalUtil.ReadSetting("SystemNotificationEmail"); ;
                    var _to = rtbUsername.Text;
                    var _cc = GlobalUtil.ReadSetting("SystemNotificationEmail");
                    var _isBodyHtml = true;
                    if (GlobalUtil.SendEmail(_subject, _body, _from, _to, _cc, _isBodyHtml))
                    {
                        lblRememberPassword.Text = string.Format("<p>Your password has been successfully sent to {0}</p>", rtbUsername.Text.ToString());
                        lblRememberPassword.Style.Add("color", "#000000");
                    } else
                    {
                        lblRememberPassword.Text = "<p>There was a problem sending the email.</p>";
                        lblRememberPassword.Style.Add("color", "red");
                    }
                    lblRememberPassword.Style.Add("font-weight", "bold");
                    lblRememberPassword.Style.Add("width", "100% !important");
                    lblRememberPassword.Style.Add("display", "flex");
                }
            }
            catch (Exception ex)
            {
                lblRememberPassword.Text = ex.ToString();
            }
            lblRememberPassword.Visible = true;
        }

        private static string GetUser(string email)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(string.Format("SELECT U.[UserName],U.[Password],C.College,R.RoleName FROM [dbo].[TBLUSERS] U LEFT JOIN LookupColleges C ON U.CollegeID = C.CollegeID LEFT OUTER JOIN ROLES R ON U.RoleID = R.RoleID WHERE U.[Email] = '{0}'", email), connection);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();
                var _body = "";
                var decryptedPwd = String.Empty;
                var siteName = String.Empty;
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        decryptedPwd = GlobalUtil.Decrypt(row["Password"].ToString().Trim());
                        //siteName = GlobalUtil.GetDatabaseSetting("SiteName");
                        siteName = HttpContext.Current.Request.Url.Host;
                        //_body = "Your Username is: " + dt.Rows[0].ItemArray[0].ToString().Trim() + "<br /> Your Password is: " + decryptedPwd + "<br /> <a href='" + siteName + "/modules/security/Login.aspx'>Click here to Sign into MAP";
                        _body += $"<p>College : {row["College"].ToString().Trim()}</p><p>Role : {row["RoleName"].ToString().Trim()}</p><p>Username : {row["UserName"].ToString().Trim()}</p><p>Password : {decryptedPwd}</p>";
                    }
                }
                _body += $"<br /> <a href='{siteName}/modules/security/Login.aspx'>Click here to Sign into MAP</a>";
                return _body;
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            divForgotPassword.Visible = false;
            lblRememberPassword.Visible = false;
        }

        protected void btnForgotPassword_Click(object sender, EventArgs e)
        {
            divForgotPassword.Visible = true;
            divNewUser.Visible = false;
            rtbUsername.Text = "";
            rtbUsername.Focus();
        }

        protected void btnNewUser_Click(object sender, EventArgs e)
        {
            divNewUser.Visible = true;
            divForgotPassword.Visible = false;
            lblUserMessage.Text = "";
        }

        protected void btnCancelUser_Click(object sender, EventArgs e)
        {
            divNewUser.Visible = false;
            lblUserMessage.Text = "";
        }

        protected void btnRequestUser_Click(object sender, EventArgs e)
        {
            try
            {
                int exist = Convert.ToInt32(norco_db.CheckUserRequestByEmail(rtbEmail.Text));
                lblUserMessage.Style.Add("color", "#ff0000");
                if (exist == 1)
                {
                    lblUserMessage.Text = "Email already registered";
                } else
                {
                    norco_db.AddUserRequest("", GlobalUtil.Encrypt(rtPassword.Text), rtFirstName.Text, rtLastName.Text, rtbEmail.Text, Convert.ToInt32(ddlCollege.SelectedValue),false, "", Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
                    lblUserMessage.Style.Add("color", "#00ff00");
                    lblUserMessage.Text = "User request success";
                    try
                    {
                        var _subject = "New User Request";
                        var _body = string.Format("User {0} has requested access for {1}.", rtFirstName.Text + ' ' + rtLastName.Text, GlobalUtil.ReadSetting("AppName") );
                        var _from = GlobalUtil.ReadSetting("SystemNotificationEmail"); ;
                        var _to = GlobalUtil.ReadSetting("NewRequestNotificationEmails");
                        var _isBodyHtml = true;
                        //var adminUsers = norco_db.GetAdminUsers(Convert.ToInt32(ddlCollege.SelectedValue));
                        //foreach (GetAdminUsersResult item in adminUsers)
                        //{
                        //    GlobalUtil.SendEmail(_subject, _body, _from, item.Email, _cc, _isBodyHtml);
                        //}
                        GlobalUtil.SendEmail(_subject, _body, _from, _to, _to, _isBodyHtml);
                    }
                    catch (Exception ex)
                    {
                        lblUserMessage.Text = ex.ToString();
                    }
                    rtFirstName.Text = "";
                    rtLastName.Text = "";
                    rtPassword.Text = "";
                    rtConfirmPassword.Text = "";
                    rtbEmail.Text = "";
                    ddlCollege.SelectedValue = "";
                }
                lblUserMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblUserMessage.Text = ex.ToString();
            }
        }

        public static bool CheckChangedPassword(int user_id)
        {
            bool exists = false;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select [dbo].[CheckPasswordChanged] ({user_id});";
                    exists = ((bool)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }
        
        public static int CheckPassword(string user_name, string pwd)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select [dbo].[CheckPassword] ('{user_name}','{pwd}');";
                    result = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }
        public static string GetCollegeAbbreviation(int collegeid)
        {

            string result = string.Empty;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select [CollegeAbbreviation] from LookupColleges where collegeid =  {collegeid};";
                    result = ((string)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }
    }
}