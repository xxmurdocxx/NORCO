using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.settings
{
    public partial class Milestones : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    LoadMilestones();
                }
                catch (Exception ex)
                {
                    DisplayMessage(true, ex.ToString());
                }
            }
        }

        public void LoadMilestones()
        {
            try
            {
                var userData = norco_db.GetUserDataByUserName(HttpContext.Current.User.Identity.Name, Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
                var isAdministrator = false;
                foreach (GetUserDataByUserNameResult p in userData)
                {
                    hvCollegeID.Value = p.CollegeID.ToString();
                    rgMilestones.MasterTableView.GroupsDefaultExpanded = true;
                    if (p.AdminUser)
                    {
                        hvIsAdmin.Value = "1";
                        rgMilestones.MasterTableView.GroupsDefaultExpanded = false;
                    }
                    else
                    {
                        hvIsAdmin.Value = "0";
                        rgMilestones.MasterTableView.GroupByExpressions.Clear();
                    }
                    isAdministrator = p.isAdministrator;
                }
                if (isAdministrator)
                {
                    sqlMilestones.SelectParameters["college_id"].DefaultValue = hvCollegeID.Value;
                    sqlMilestones.SelectParameters["is_admin"].DefaultValue = hvIsAdmin.Value;
                    rgMilestones.DataBind();
                }
                else
                {
                    rgMilestones.Visible = false;
                }

            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, Telerik.Web.UI.AjaxRequestEventArgs e)
        {
            LoadMilestones();
            Response.Redirect(HttpContext.Current.Request.Url.ToString(), true);
        }


        protected void rgMilestones_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            rgMilestones.DataBind();
        }
    }
}