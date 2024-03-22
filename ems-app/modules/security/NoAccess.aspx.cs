using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.security
{
    public partial class NoAccess : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRequestAccess_Click(object sender, EventArgs e)
        {
            try
            {
                var _subject = "New Access Request";
                var _body = string.Format("User {0} has requested access for {1}.", Session["FirstName"].ToString() + " " + Session["LastName"].ToString(), Session["RequestesResourcePage"].ToString() );
                var _from = GlobalUtil.ReadSetting("SystemNotificationEmail"); ;
                var _cc = GlobalUtil.ReadSetting("SystemNotificationEmail");
                var _isBodyHtml = true;
                var adminUsers = norco_db.GetAdminUsers(Convert.ToInt32(Session["CollegeID"]));
                foreach (GetAdminUsersResult item in adminUsers)
                {
                    GlobalUtil.SendEmail(_subject, _body, _from, item.Email, _cc, _isBodyHtml);
                }
            }
            catch (Exception ex)
            {
                lblUserMessage.Text = ex.ToString();
            }
        }
    }
}