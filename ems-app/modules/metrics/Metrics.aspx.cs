using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.metrics
{
    public partial class Metrics : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GridSortExpression sortExpr = new GridSortExpression();
                sortExpr.FieldName = "COLLEGE";
                sortExpr.SortOrder = GridSortOrder.Ascending;
                //Add sort expression, which will sort against first column
                rgCollegeMetrics.MasterTableView.SortExpressions.AddSortExpression(sortExpr);
            }
        }
    }
}