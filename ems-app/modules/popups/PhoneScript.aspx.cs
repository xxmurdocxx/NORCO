using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class PhoneScript : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rptProgramCourses.DataBind();
                int Total = 0;
                foreach (RepeaterItem ri in rptProgramCourses.Items)
                {
                    Label units = ri.FindControl("lblUnits") as Label;
                    if (units.Text != "")
                    {
                        Total += Convert.ToInt32(units.Text);
                    }
                }

                lblTotalValue.Text = "Total Units : " + Total.ToString();

            }
        }
    }
}