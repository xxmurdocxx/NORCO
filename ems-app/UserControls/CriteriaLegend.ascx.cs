using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class CriteriaLegend : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void rptCriteriaTypes_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                System.Web.UI.HtmlControls.HtmlGenericControl div = e.Item.FindControl("DivLegend") as System.Web.UI.HtmlControls.HtmlGenericControl;
                string color = (string)DataBinder.Eval(e.Item.DataItem, "Backcolor");
                div.Attributes.CssStyle.Add("background-color", color);
            }
        }
    }
}