using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using System.Security.Cryptography;
using System.Web.Configuration;
using Telerik.Web.UI;

namespace ems_app.Common.templates
{
    public partial class publicTemplate : System.Web.UI.MasterPage
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    if ((HttpContext.Current.User.Identity.Name == null) || !HttpContext.Current.User.Identity.IsAuthenticated || Session["UserName"] == null)
                    {
                        var url = "";
                        if (Request.QueryString["UserName"] == null)
                        {
                            url = String.Format("~/modules/popups/Login.aspx?username={0}", "");
                        }
                        else
                        {
                            url = String.Format("~/modules/popups/Login.aspx?username={0}", Request.QueryString["UserName"].ToString());
                        }
                        rwmFeedback.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, 300, 300));
                    }
                    else
                    {

                        LoadUserInfo();

                    }
                }
                catch (Exception ex)
                {
                    //DisplayMessage(true, ex.ToString());
                }
            }
        }

        public void LoadUserInfo()
        {
            //User Information
            string userName = HttpContext.Current.User.Identity.Name;
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
            }
            //College Style Sheet
            phCollegeStyleSheet.Controls.Add(GlobalUtil.CreateCssLink(Session["StyleSheet"].ToString(), "all"));
            //App-College Information 
            pageTitle.InnerHtml = GlobalUtil.ReadSetting("AppName");
            Session["ResourcePage"] = Request.Url.LocalPath.ToString();

            TopNavBarMenu.UserName = Session["FirstName"].ToString() + " " + Session["LastName"].ToString();
            TopNavBarMenu.RoleName = Session["RoleName"].ToString();
            TopNavBarMenu.College = Session["College"].ToString();

            //Set Treeview parameters
            MAPTreeviewMenu.CollegeID = Convert.ToInt32(Session["CollegeID"]);
            MAPTreeviewMenu.RoleID = Convert.ToInt32(Session["RoleID"]);
            MAPTreeviewMenu.ApplicationID = Convert.ToInt32(GlobalUtil.ReadSetting("AppID"));
            MAPTreeviewMenu.UserID = Convert.ToInt32(Session["UserID"]);

        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            LoadUserInfo();
            Response.Redirect(HttpContext.Current.Request.Url.ToString(), true);
        }
    }
}