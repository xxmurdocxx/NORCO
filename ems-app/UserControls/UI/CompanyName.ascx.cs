using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls.UI
{
    public partial class CompanyName : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblCompanyName.Text = GlobalUtil.ReadSetting("CompanyName");
                lblCompanyName.NavigateUrl = GlobalUtil.ReadSetting("CompanyUrl");
            }
        }
    }
}