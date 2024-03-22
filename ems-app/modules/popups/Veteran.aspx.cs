using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class Veteran : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void rgVeteranOccupations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            rgRelatedCourses.SelectedIndexes.Clear();
        }
    }
}