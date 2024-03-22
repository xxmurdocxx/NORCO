using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class GroupInfo : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var rs = norco_db.GetProgramGroupUnits(Convert.ToInt32(Request["ProgramCourseID"]));
                foreach (GetProgramGroupUnitsResult p in rs)
                {
                    rtbHeading.Text = p.group_desc;
                    rntbMinUnits.Value = p.group_units_min;
                    rntbMaxUnits.Value = p.group_units_max;
                }
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rbSave_Click(object sender, EventArgs e)
        {

            norco_db.UpdateProgramGroupUnits(Convert.ToInt32(Request["ProgramCourseID"]), rtbHeading.Text, Convert.ToInt32(rntbMinUnits.Value), Convert.ToInt32(rntbMaxUnits.Value), Convert.ToInt32(Session["UserId"]));
            DisplayMessage(false, "Group information updated.");

        }
    }
}