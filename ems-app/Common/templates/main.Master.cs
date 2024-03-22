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
using System.Data.SqlClient;
using System.Configuration;
//using System.Data.Entity;
using System.Data;
using System.Text.RegularExpressions;
using ems_app.Common.infrastructure;

namespace ems_app.Common.templates
{
    public partial class main : System.Web.UI.MasterPage
    {
        NORCODataContext norco_db = new NORCODataContext();

        public static bool CheckPasswordChanged(int user_id)
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
        protected void Page_Load(object sender, EventArgs e)
        {
			ViewState.Add("SystemMaintenanceID", new List<int>());																			
            if (!IsPostBack)
            {
                if ((HttpContext.Current.User.Identity.Name != null) && HttpContext.Current.User.Identity.IsAuthenticated)
                {

                    //College Style Sheet
                    //phCollegeStyleSheet.Controls.Add(GlobalUtil.CreateCssLink(Session["StyleSheet"].ToString(), "all"));
                    //App-College Information 
                    pageTitle.InnerHtml = GlobalUtil.ReadSetting("AppName");
                    Session["ResourcePage"] = Request.Url.LocalPath.ToString();

                    CollegeName.InnerText = Session["College"].ToString();

                    TopNavBarMenu.UserName = Session["FirstName"].ToString() + " " + Session["LastName"].ToString();
                    TopNavBarMenu.RoleName = Session["RoleName"].ToString();
                    TopNavBarMenu.College = Session["College"].ToString();
                    TopNavBarMenu.UserID = Convert.ToInt32(Session["UserID"].ToString());

                    //Check if user have acces to resource
                    //var haveAcess = GlobalUtil.HaveAccessUrl(Session["ResourcePage"].ToString(), Convert.ToInt32(Session["RoleID"]));
                    //if (haveAcess == false)
                    //{
                    //    if (!Session["ResourcePage"].ToString().Contains("NoAccess.aspx"))
                    //    {
                    //        Session["RequestesResourcePage"] = Session["ResourcePage"].ToString();
                    //        Response.Redirect("/modules/security/NoAccess.aspx");
                    //    }
                    //}
                    //Set Treeview parameters
                    MAPTreeviewMenu.CollegeID = Convert.ToInt32(Session["CollegeID"]);
                    MAPTreeviewMenu.RoleID = Convert.ToInt32(Session["RoleID"]);
                    MAPTreeviewMenu.ApplicationID = Convert.ToInt32(GlobalUtil.ReadSetting("AppID"));
                    MAPTreeviewMenu.UserID = Convert.ToInt32(Session["UserID"]);

                    //Get and display notifications
                    if (rgSystemAlerts.Items.Count > 0)
                    {
                        pnlRgAlerts.Visible = true;
                    }
                    ShowNotifications(Convert.ToInt32(Session["UserID"]));
                    //hfUserStageOrder.Value = Session["UserStageOrder"].ToString();
                    hfUserStageOrder.Value = norco_db.GetStageOrderByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])).ToString();

                    if (Convert.ToBoolean(Session["ChangedPassword"]) == false)
                    {
                        Response.Redirect("~/modules/security/ChangePassword.aspx");
                    }
                }
                else
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
            else
            {
                // get and display notifications on postback
                ShowNotifications(Convert.ToInt32(Session["UserID"]));
            }
        }
        private void DisplayUpdates(DataTable updates)
        {
            if (updates.Rows.Count == 0)
            {
                return;
            }

            pnlUpdates.Visible = true;
        }

        protected void lbUpdates_Click(object sender, EventArgs e)
        {
            pnlDisplayUpdates.Visible = true;
        }

        private DataTable GetNotificationsPast(int userID)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("@UserID", userID)
            };












            var dt = Database.ExecuteStoredProcedure("spSystemMaintenance_ListPastForUser", parameters);

            return dt;
        }


        private void InsertUserDismiss(int userID, int sysMaintenanceID, int noticeType)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("@UserID", userID),
                new SqlParameter("@SystemMaintenanceID", sysMaintenanceID),
                new SqlParameter("@NoticeType", noticeType)
            };

            Database.ExecuteStoredProcedure("spSystemMaintenance_InsertUserDismiss", parameters);
        }

        private void ShowNotifications(int userID)
        {
            if ((bool)Session["SystemNotificationUpdate"])
            {
                var sysMaintenancePrior = GetNotificationsPast(userID);
                DisplayUpdates(sysMaintenancePrior);
            }
        }

        protected void rgUpdates_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.Item is GridDataItem)
            {

                switch (e.CommandName)
                {
                    case "DismissUpdate":
                        GridDataItem item = (GridDataItem)e.Item;
                        int sysMaintenanceID = (Int32)item.GetDataKeyValue("SystemMaintenanceID");
                        var userIDResult = Int32.TryParse(Session["UserID"].ToString(), out int userID);
                        InsertUserDismiss(userID, sysMaintenanceID, 2);

                        rgUpdates.DataBind();

                        break;
                }
            }
        }

        protected void lnkXPopupContainer_Click(object sender, EventArgs e)
        {
            pnlDisplayUpdates.Visible = false;
        }

        protected void lbDismissAlert_Click(object sender, EventArgs e)
        {
            Session["SystemNotificationAlert"] = false;
            pnlRgAlerts.Visible = false;
        }


        protected void lbDismissUpdate_Click(object sender, EventArgs e)
        {
            Session["SystemNotificationUpdate"] = false;
            pnlUpdates.Visible = false;
        }

        protected void rgSystemAlerts_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                switch (e.CommandName)
                {
                    case "DismissAlert":
                        GridDataItem item = (GridDataItem)e.Item;
                        int systemMaintenanceID = (Int32)item.GetDataKeyValue("NotificationID");
                        var userIDResult = Int32.TryParse(Session["UserID"].ToString(), out int userID);
                        InsertUserDismiss(userID, systemMaintenanceID, 1);

                        rgSystemAlerts.DataBind();

                        break;
                }
            }
        }

        protected void rgSystemAlerts_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem gridItem = e.Item as GridDataItem;
                foreach (GridColumn column in rgSystemAlerts.MasterTableView.RenderColumns)
                {
                    if (column.UniqueName == "InfoIcon")
                    {
                        var changeDetail = gridItem.GetDataKeyValue("ChangeDetails");
                        gridItem[column.UniqueName].ToolTip = changeDetail.ToString();
                    }
                }
            }
        }

        protected void rgSystemAlerts_PreRender(object sender, EventArgs e)
        {
            if (rgSystemAlerts.Items.Count > 0 && (bool)Session["SystemNotificationAlert"])
            {
                pnlRgAlerts.Visible = true;
            }
            else
            {
                pnlRgAlerts.Visible = false;
            }
        }



    }
}