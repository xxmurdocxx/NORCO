using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class Welcome : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblUserFirstName.Text = Session["FirstName"].ToString() + " " + Session["LastName"].ToString();
            }
        }

        protected void rbDontShow_Click(object sender, EventArgs e)
        {
            try
            {
                norco_db.UpdateUserWelcome(Convert.ToInt32(Session["UserID"]));
                RadAjaxManager1.ResponseScripts.Add("CloseModal();");
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
            }
        }

        protected void rbSkip_Click(object sender, EventArgs e)
        {
            try
            {
                Session["Skipped"] = "True";
                RadAjaxManager1.ResponseScripts.Add("CloseModal();");
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

    }
}