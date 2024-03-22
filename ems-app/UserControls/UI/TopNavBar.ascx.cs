using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using ems_app.Common.infrastructure;

namespace ems_app.UserControls.UI
{
    public partial class TopNavBar : System.Web.UI.UserControl
    {
        private string user_name = "";
        private string role_name = "";
        private string college = "";
        private int user_id;
         
        public string UserName
        {
            get { return user_name; }
            set { user_name = value; }
        }
        public string RoleName
        {
            get { return role_name; }
            set { role_name = value; }
        }
        public string College
        {
            get { return college; }
            set { college = value; }
        }
        public int UserID { get { return user_id; } set { user_id = value; } }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfUsername.Value = Session["FirstName"].ToString() + " " + Session["LastName"].ToString();
                hfApplicationID.Value = GlobalUtil.ReadSetting("AppID").ToString();
                lblUserName.Text = string.Format("{0} - {1}", hfUsername.Value, Session["RoleName"].ToString());
                lblRoleName.Text = Session["RoleName"].ToString();

                HtmlGenericControl spanPopup = new HtmlGenericControl("span");
                spanPopup.InnerText = "Logout";

                HtmlGenericControl i = new HtmlGenericControl("i");
                i.Attributes.Add("class", "fa fa-sign-out pull-right");

                linkMenuLogout.Controls.Add(i);
                linkMenuLogout.Controls.Add(spanPopup);

                pnlAvailableRoles.Visible = false;
                if (GlobalUtil.CheckMultipleRoles(Convert.ToInt32(Session["UserID"])) == 1)
                {
                    pnlAvailableRoles.Visible = true;
                }

                if (((bool)Session["SuperUser"] || (bool)Session["DistrictAdministrator"]) && !HttpContext.Current.Request.Url.AbsoluteUri.Contains("SuperUser.aspx"))
                {
                    litSuperUserMenuItem.Text = "<li><a class=\"dropdown-item\" href=\"../../modules/dashboard/SuperUser.aspx\">Choose Another College</a></li>";
                    litSuperUserMenuItem.Visible = true;
                }
                PotentialBlurb.Visible = false;
                if (Session["RoleName"].ToString() == "Ambassador" && Convert.ToInt32(GetPotentialUsersCount(Session["CollegeID"].ToString())) > 0 )
                {
                    PotentialBlurb.Visible = true;
                    PotentialBlurb.Attributes.Add("title", $"You have {GetPotentialUsersCount(Session["CollegeID"].ToString())} New Potential users. Click here to view.");
                    PotentialBlurbText.InnerText = GetPotentialUsersCount(Session["CollegeID"].ToString());
                }

                if (GlobalUtil.ReadSetting("IsTestEnvironment") == "1")     // QA or SANDBOX
                {
                    litTestEnvironmentDescription.Text = "<B>* " + GlobalUtil.ReadSetting("TestEnvironmentDescription") + " SITE *</B>&nbsp;&nbsp;&nbsp;&nbsp;";
                    hlkTickets.NavigateUrl = "../../modules/messages/Default.aspx"; // from existing code, not sure if needed
                }
                else          // PRODUCTION
                {
                    //litTestEnvironmentDescription.Text = "<i class='fa fa-cog' aria-hidden='true'></i> MAP Help Portal";
                    //litTestEnvironmentDescription.Text = "<i class='fa fa-cog' aria-hidden='true'></i>";
                    //hlkTickets.NavigateUrl = GlobalUtil.GetDatabaseSetting("HelpDeskURL");
                    hlkTickets.Target = "_blank";
                }
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

        private string GetPotentialUsersCount(string CollegeID)
        {
            string total = "";
            string queryString = $"select isnull(count(*),0) from veteran where PotentialStudent = 1 and CollegeID = {@CollegeID} ";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(queryString, conn);
                conn.Open();
                cmd.Parameters.Add(new SqlParameter("@VeteranID", CollegeID));
                var i = cmd.ExecuteScalar();
                if (i != null)
                    total = Convert.ToString(i);
            }

            return total;
        }

        protected void rcbRoles_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Session["RoleName"] = rcbRoles.SelectedItem.Text;
            Session["RoleID"] = rcbRoles.SelectedValue;
            //lblUserName.Text = string.Format("<strong>{0}</strong> - {1}", hfUsername.Value, rcbRoles.SelectedItem.Text);
            if (GlobalUtil.CheckMultipleRoleIsFaculty(Convert.ToInt32(Session["UserID"])) == 1)
            {
                Session["reviewArticulations"] = "true";
            }
            else
            {
                Session["reviewArticulations"] = "false";
            }
            if (Convert.ToBoolean(Session["SuperUser"]) == true && Session["RoleName"].ToString() == "Ambassador")
            {
                Response.Redirect("/modules/dashboard/SuperUser.aspx"); 
            } else
            {
                Response.Redirect(Request.RawUrl);
            }
        }

    }
}