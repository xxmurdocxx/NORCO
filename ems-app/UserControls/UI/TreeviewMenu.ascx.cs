using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.UserControls.UI
{
    public partial class TreeviewMenu : System.Web.UI.UserControl
    {
        NORCODataContext norco_db = new NORCODataContext();


        private int role_id = 0;
        private int college_id = 0;
        private int application_id = 0;
        private int user_id = 0;

        public int RoleID
        {
            get { return role_id; }
            set { role_id = value; }
        }
        public int CollegeID
        {
            get { return college_id; }
            set { college_id = value; }
        }
        public int ApplicationID
        {
            get { return application_id; }
            set { application_id = value; }
        }
        public int UserID
        {
            get { return user_id; }
            set { user_id = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlMenu.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlMenu.SelectParameters["RoleID"].DefaultValue = RoleID.ToString();
                sqlMenu.SelectParameters["ApplicationID"].DefaultValue = ApplicationID.ToString();
                sqlMenu.SelectParameters["UserID"].DefaultValue = UserID.ToString();
                hfUserID.Value = UserID.ToString();
            }
        }

        protected void rtvMenu_ContextMenuItemClick(object sender, RadTreeViewContextMenuEventArgs e)
        {
            RadTreeNode clickedNode = e.Node;
            switch (e.MenuItem.Value)
            {
                case "Add":
                    if (clickedNode.NavigateUrl != "")
                    {
                        norco_db.UpdateFavorite(Convert.ToInt32(hfUserID.Value), Convert.ToInt32(clickedNode.Value));
                        sqlMenu.DataBind();
                        rtvMenu.DataBind();
                        Response.Redirect(Request.RawUrl);
                    }
                    break;
            }
        }

    }
}