using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class ShowCourseDetail : System.Web.UI.Page
    {

        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlDisableArticulate.Visible = false;
                CheckDisableArticulate();
            }
        }

        public void CheckDisableArticulate()
        {
            try
            {
                lblDisableArticulate.Visible = false;
                rbDisableArticulate.Visible = false;
                rbEnableArticulate.Visible = false;
                var check_have_articulations = norco_db.CheckCouseHaveArticulations(Convert.ToInt32(Request.QueryString["outline_id"]));

                if (check_have_articulations == false)
                {
                    var disable_articulate = norco_db.CheckIsDisabledForArticulate(Convert.ToInt32(Request.QueryString["outline_id"]));
                    if (disable_articulate == true)
                    {
                        rbEnableArticulate.Visible = true;
                        lblDisableArticulate.Visible = true;
                    }
                    else
                    {
                        rbDisableArticulate.Visible = true;
                    }
                    var course = norco_db.GetCourseInformation(Convert.ToInt32(Request.QueryString["outline_id"]));
                    foreach (GetCourseInformationResult item in course)
                    {
                        rtbRationale.Text = item.DisableArticulateRationale;
                    }
                }

            }
            catch (Exception x)
            {
                ShowError(x.Message);
            }

        }

        public void ShowError(string message)
        {
            lblDisableArticulate.Visible = true;
            lblDisableArticulate.Text = message;
        }

        public void SetEnableDisableArticulate()
        {
            try
            {
                norco_db.SetDisabledForArticulate(Convert.ToInt32(Request.QueryString["outline_id"]), rtbRationale.Text);
                CheckDisableArticulate();
            }
            catch (Exception x)
            {
                ShowError(x.Message);
            }
        }

        protected void rbDisableArticulate_Click(object sender, EventArgs e)
        {
            RadButton btn = (RadButton)sender;
            if (btn.ID == "rbEnableArticulate")
            {
                SetEnableDisableArticulate();
            }
            if (btn.ID == "rbDisableArticulate")
            {
                pnlDisableArticulate.Visible = true;
            }
        }

        protected void rbCancel_Click(object sender, EventArgs e)
        {
            pnlDisableArticulate.Visible = false;
        }

        protected void rbConfirm_Click(object sender, EventArgs e)
        {
            SetEnableDisableArticulate();
            pnlDisableArticulate.Visible = false;
        }
    }
}