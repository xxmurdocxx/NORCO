using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app
{
    public partial class Refactor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GenericControls.SetSelectedItem(rblRecommendations, "1,2");
            }
        }

        protected void RadButton1_Click(object sender, EventArgs e)
        {
            var test = GenericControls.GetSelectedItemText(rblRecommendations);
            lblTest.Text = test;
        }
    }
}