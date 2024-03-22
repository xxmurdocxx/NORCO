using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class ChangeUserRole : System.Web.UI.UserControl
    {
        NORCODataContext norco_db = new NORCODataContext();
        public int CollegeID { get; set; }
        public int ApplicationID { get; set; }
        public int UserID { get; set; }
        public int RoleID { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlUserAvailableRoles.SelectParameters["UserID"].DefaultValue = UserID.ToString();
                sqlUserAvailableRoles.SelectParameters["RoleID"].DefaultValue = RoleID.ToString();
                sqlUserAvailableRoles.SelectParameters["ApplicationID"].DefaultValue = ApplicationID.ToString();
                sqlUserAvailableRoles.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlUserAvailableRoles.DataBind();
                rcbRoles.DataBind();
            }
        }

        protected void rcbRoles_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Session["RoleName"] = rcbRoles.SelectedItem.Text;
            Session["RoleID"] = rcbRoles.SelectedValue;
            if (GlobalUtil.CheckMultipleRoleIsFaculty(Convert.ToInt32(Session["UserID"])) == 1)
            {
                Session["reviewArticulations"] = "true";
            }
            else
            {
                Session["reviewArticulations"] = "false";
            }
            Response.Redirect(Request.RawUrl);
        }
    }
}