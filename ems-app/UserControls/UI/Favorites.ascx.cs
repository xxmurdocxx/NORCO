using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls.UI
{
    public partial class Favorites : System.Web.UI.UserControl
    {
        private int user_id = 0;

        public int UserID
        {
            get { return user_id; }
            set { user_id = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlFavorites.SelectParameters["UserID"].DefaultValue = UserID.ToString();
            }
        }
    }
}