using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class CriteriaPackage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfSelectedCourse.Value = Request["outline_id"].ToString();
                hfSelectedCriteria.Value = Request["criteria"].ToString();
            }
        }

        protected void rgPackages_PreRender(object sender, EventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (!Page.IsPostBack)
            {
                if (grid.MasterTableView.Items.Count > 0)
                {
                    GridItem item = grid.MasterTableView.Items[0];
                    item.Selected = true;
                }
            }
        }
    }
}