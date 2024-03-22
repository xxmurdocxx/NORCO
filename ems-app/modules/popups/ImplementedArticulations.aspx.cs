using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class ImplementedArticulations : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void grid_PreRender(object sender, EventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (grid.IsExporting)
            {
                foreach (GridFilteringItem item in grid.MasterTableView.GetItems(GridItemType.FilteringItem))
                {
                    item.Visible = false;
                }
            }
        }
    }
}