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
using ems_app.modules.popups;
using System.IO;
using System.Text;
using Telerik.Web.UI.com.hisoftware.api2;

namespace ems_app.modules.users
{
    public partial class EmailAccess : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Init(object sender, EventArgs e)
        {

        }
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {

                string MessageID = Decrypt(Request["MessageID"]);
                string Action = Decrypt(Request["Action"]);
                string user = Decrypt(Request["AceID"]);
                string TeamRevd = Decrypt(Request["TeamRevd"]);
                string ActionTaken = Decrypt(Request["ActionTaken"]);

                var authUser = CheckPassword(user, TeamRevd);
                if (authUser == 1)
                {
                    var userData = norco_db.GetUserDataByUserName(user, Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));

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


                    FormsAuthentication.SetAuthCookie(user, false);
                    string host = GlobalUtil.GetDatabaseSetting("SiteName");
                    string url = "";
                    string href = "";
                    string url_parameters = "";
                    //string host = "http://localhost:49573";
                    if (Action == "ViewExhi")
                    {
                        //string Criteria = Decrypt(Request["TeamRevd"]);
                        //string CriteriaPackageID = Decrypt(Request["ActionTaken"]);
                        string Criteria = Request["Criteria"];
                        string CriteriaPackageID = Request["CriteriaPackageID"];

                        url = $"{host}/modules/Notifications/Exhibits.aspx?Criteria={Criteria}&CriteriaPackageID={CriteriaPackageID}";
                        
                        //string urlhref = $"{host}modules/Notifications/Exhibits.aspx?Criteria={reader.GetString(0)}&CriteriaPackageID={criteria_package_id}";
                        href = $"{url}";
                    }
                    else {
                        //string url = $"{host}/modules/Notifications/Confirm_o.aspx";
                        url = $"{host}/modules/Notifications/Confirm_o.aspx";
                        url_parameters = $"&MessageID={Encrypt(MessageID)}&AceID={Encrypt(user)}&TeamRevd={Encrypt(TeamRevd)}&ActionTaken={Encrypt(ActionTaken)}";
                        href = $"{url}?Action=" + Encrypt(Action) + $"{url_parameters}";
                    }

                    Response.Redirect(href);

                }
                else
                {
                    //if (authUser == -1)
                    //{
                    //    //Login1.FailureText = Resources.Messages.InvalidCredentials;
                    //}
                    //else
                    //{
                    //    //Login1.FailureText = "<a href='mailto:mapadmin@mappingarticulatedpathways.org' style='font-weight:normal;color:darkblue !important;'>Your account has been deactivated. If you feel this is an error, please contact MAP Support.</a>";
                    //}
                }


            }
        }
        private string Decrypt(string cipherText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            cipherText = cipherText.Replace(" ", "+");
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }

        public static string Encrypt(string clearText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6E, 0x20, 0x4D, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = System.Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
        {
            ////var authUser = norco_db.ValidateUser(Login1.UserName,  GlobalUtil.Encrypt(Login1.Password));
            //var authUser = CheckPassword(Login1.UserName, GlobalUtil.Encrypt(Login1.Password));
            //if (authUser == 1)
            //{
            //    //User Information
            //    var userData = norco_db.GetUserDataByUserName(Login1.UserName, Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
            //    foreach (GetUserDataByUserNameResult p in userData)
            //    {
            //        Session["UserID"] = p.UserID;
            //        Session["LastName"] = p.LastName;
            //        Session["FirstName"] = p.FirstName;
            //        Session["UserName"] = p.UserName;
            //        Session["CollegeID"] = p.CollegeID;
            //        Session["College"] = p.College;
            //        Session["CollegeAbbreviation"] = GetCollegeAbbreviation(Convert.ToInt32(p.CollegeID));
            //        Session["RoleID"] = p.RoleID;
            //        Session["RoleName"] = p.RoleName;
            //        Session["StyleSheet"] = p.StyleSheet;
            //        Session["isAdministrator"] = p.isAdministrator;
            //        Session["reviewArticulations"] = p.reviewArticulations;
            //        Session["isArticulationOfficer"] = p.isArticulationOfficer;
            //        Session["PendingDataIntake"] = p.PendingDataIntake;
            //        Session["UserStageID"] = norco_db.GetStageIDByRoleId(p.CollegeID, p.RoleID);
            //        Session["UserStageOrder"] = norco_db.GetStageOrderByRoleId(p.CollegeID, p.RoleID);
            //        Session["CollegeLogo"] = p.CollegeLogo;
            //        Session["OnBoarding"] = p.Welcome.ToString();
            //        Session["SuperUser"] = p.SuperUser ?? false;
            //        Session["DistrictAdministrator"] = p.DistrictAdministrator ?? false;
            //        Session["ChangedPassword"] = CheckChangedPassword((int)p.UserID);
            //        Session["SystemNotificationUpdate"] = true;
            //        Session["SystemNotificationAlert"] = true;
            //    }
            //    // 04-30-23
            //    //if (Session["UserID"].ToString() != "1")
            //    //{
            //    //    Response.Redirect("~/Down.htm");
            //    //};
            //    if ((bool)Session["SuperUser"] || (bool)Session["DistrictAdministrator"])
            //    {
            //        FormsAuthentication.SetAuthCookie(Login1.UserName, false);
            //        Response.Redirect("~/modules/dashboard/SuperUser.aspx");
            //    }
            //    else
            //    {
            //        FormsAuthentication.RedirectFromLoginPage(Login1.UserName, false);
            //    }

            //}
            //else
            //{
            //    if (authUser == -1)
            //    {
            //        Login1.FailureText = Resources.Messages.InvalidCredentials;
            //    } else {
            //        Login1.FailureText = "<a href='mailto:mapadmin@mappingarticulatedpathways.org' style='font-weight:normal;color:darkblue !important;'>Your account has been deactivated. If you feel this is an error, please contact MAP Support.</a>";
            //    }
            //}
        }


        protected void btnSend_Click(object sender, EventArgs e)
        {
            //try
            //{
            //    var getPwd = norco_db.RememberPasswordByEmail(rtbUsername.Text);
            //    var pwd = "";
            //    lblRememberPassword.Style.Add("color", "#ff0000");
            //    foreach (RememberPasswordByEmailResult item in getPwd)
            //    {
            //        pwd = item.Password;
            //    }
            //    if (pwd == "NotFound")
            //    {
            //        lblRememberPassword.Text = "Email not found in database.";
            //    }
            //    else
            //    {
            //        var decryptedPwd = GlobalUtil.Decrypt(pwd);
            //        var _subject = "Recover your password";
            //        var _body = GetUser(rtbUsername.Text);
            //        var _from = GlobalUtil.ReadSetting("SystemNotificationEmail"); ;
            //        var _to = rtbUsername.Text;
            //        var _cc = GlobalUtil.ReadSetting("SystemNotificationEmail");
            //        var _isBodyHtml = true;
            //        GlobalUtil.SendEmail(_subject, _body, _from, _to, _cc, _isBodyHtml);
            //        lblRememberPassword.Text = string.Format("<p>Your password has been successfully sent to {0}</p>", rtbUsername.Text.ToString());
            //        lblRememberPassword.Style.Add("color", "#000000");
            //        lblRememberPassword.Style.Add("font-weight", "bold");
            //        lblRememberPassword.Style.Add("width", "100% !important");
            //        lblRememberPassword.Style.Add("display", "flex");
            //    }
            //}
            //catch (Exception ex)
            //{
            //    lblRememberPassword.Text = ex.ToString();
            //}
            //lblRememberPassword.Visible = true;
        }

        private static string GetUser(string email)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(string.Format("SELECT [UserName],[Password] FROM [dbo].[TBLUSERS] WHERE [Email] = '{0}'",email), connection);
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = command;
                connection.Open();
                var _body = "";
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    var decryptedPwd = GlobalUtil.Decrypt(dt.Rows[0].ItemArray[1].ToString().Trim());
                    var siteName = GlobalUtil.GetDatabaseSetting("SiteName");
                    //_body = "Your Username is: " + dt.Rows[0].ItemArray[0].ToString().Trim() + "<br /> Your Password is: " + decryptedPwd + "<br /> <a href='" + siteName + "/modules/security/Login.aspx'>Click here to Sign into MAP";
                    _body = $"Your Username is: {dt.Rows[0].ItemArray[0].ToString().Trim()}<br /> Your Password is: {decryptedPwd}<br /> <a href='{siteName}/modules/security/Login.aspx'>Click here to Sign into MAP";
                }
                return _body;
            }
        }

        //protected void btnCancel_Click(object sender, EventArgs e)
        //{
        //    divForgotPassword.Visible = false;
        //    lblRememberPassword.Visible = false;
        //}

        //protected void btnForgotPassword_Click(object sender, EventArgs e)
        //{
        //    divForgotPassword.Visible = true;
        //    divNewUser.Visible = false;
        //    rtbUsername.Text = "";
        //    rtbUsername.Focus();
        //}

        //protected void btnNewUser_Click(object sender, EventArgs e)
        //{
        //    divNewUser.Visible = true;
        //    divForgotPassword.Visible = false;
        //    lblUserMessage.Text = "";
        //}

        //protected void btnCancelUser_Click(object sender, EventArgs e)
        //{
        //    divNewUser.Visible = false;
        //    lblUserMessage.Text = "";
        //}

        protected void btnRequestUser_Click(object sender, EventArgs e)
        {
            //try
            //{
            //    int exist = Convert.ToInt32(norco_db.CheckUserRequestByEmail(rtbEmail.Text));
            //    lblUserMessage.Style.Add("color", "#ff0000");
            //    if (exist == 1)
            //    {
            //        lblUserMessage.Text = "Email already registered";
            //    } else
            //    {
            //        norco_db.AddUserRequest("", GlobalUtil.Encrypt(rtPassword.Text), rtFirstName.Text, rtLastName.Text, rtbEmail.Text, Convert.ToInt32(ddlCollege.SelectedValue),false, "", Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
            //        lblUserMessage.Style.Add("color", "#00ff00");
            //        lblUserMessage.Text = "User request success";
            //        try
            //        {
            //            var _subject = "New User Request";
            //            var _body = string.Format("User {0} has requested access for {1}.", rtFirstName.Text + ' ' + rtLastName.Text, GlobalUtil.ReadSetting("AppName") );
            //            var _from = GlobalUtil.ReadSetting("SystemNotificationEmail"); ;
            //            var _to = GlobalUtil.ReadSetting("NewRequestNotificationEmails");
            //            var _isBodyHtml = true;
            //            //var adminUsers = norco_db.GetAdminUsers(Convert.ToInt32(ddlCollege.SelectedValue));
            //            //foreach (GetAdminUsersResult item in adminUsers)
            //            //{
            //            //    GlobalUtil.SendEmail(_subject, _body, _from, item.Email, _cc, _isBodyHtml);
            //            //}
            //            GlobalUtil.SendEmail(_subject, _body, _from, _to, _to, _isBodyHtml);
            //        }
            //        catch (Exception ex)
            //        {
            //            lblUserMessage.Text = ex.ToString();
            //        }
            //        rtFirstName.Text = "";
            //        rtLastName.Text = "";
            //        rtPassword.Text = "";
            //        rtConfirmPassword.Text = "";
            //        rtbEmail.Text = "";
            //        ddlCollege.SelectedValue = "";
            //    }
            //    lblUserMessage.Visible = true;
            //}
            //catch (Exception ex)
            //{
            //    lblUserMessage.Text = ex.ToString();
            //}
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