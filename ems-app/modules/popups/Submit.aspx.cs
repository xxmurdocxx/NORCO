using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class Submit : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request["Direction"] == "-1")
                {
                    pnlPrevious.Visible = true;
                }
                hfCurrentStageID.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])).ToString();
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rbSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                var outline_id = Convert.ToInt32(Request["outline_id"]);
                var user_id = Convert.ToInt32(Session["UserId"]);
                var direction = Convert.ToInt32(Request["Direction"]);
                var info = reAdditionalInfo.Content;
                var college_id = Convert.ToInt32(Session["CollegeId"]);
                var new_stage_id = 0;
                if (rcbPreviousStage.SelectedValue != "")
                {
                    new_stage_id = Convert.ToInt32(rcbPreviousStage.SelectedValue);
                }
                var course = norco_db.GetCourseTitle(outline_id, college_id);
                string from = GlobalUtil.ReadSetting("SystemNotificationEmail");
                string subject = string.Format("MAP Articulation for  {0} is in your Inbox", course);

                DisplayMessage(false, "Succesfully submitted.");
                rbSubmit.Enabled = false;
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
            }
        }
    }
}