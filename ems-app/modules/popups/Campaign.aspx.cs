using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class Campaign : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        private void disableButtons()
        {
            rbAddUpdate.Enabled = false;
            rbDelete.Enabled = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request["CampaignId"] != null)
                {
                    Int32 id = Convert.ToInt32(Request["CampaignId"]);
                    var campaigns = norco_db.GetCampaign(id);
                    foreach (GetCampaignResult item in campaigns)
                    {
                        hfId.Value = item.ID.ToString();
                        rtbDescription.Text = item.Description;
                        reNotes.Content = item.Notes;
                        rcbSemester.SelectedValue = item.SemesterID.ToString();
                        rcbStatus.SelectedValue = item.CampaignStatus.ToString();
                    }
                    rbAddUpdate.Text = "Update";
                    rbDelete.Enabled = true;
                }
                else
                {
                    rtbDescription.Text = "";
                    reNotes.Content = "";
                    rbAddUpdate.Text = "Save";
                    rbDelete.Enabled = false;
                }
            }
        }
        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rbAddUpdate_Click(object sender, EventArgs e)
        {
            saveCampaign();
        }

        public void saveCampaign()
        {
            var campignID = 0;
            if (hfId.Value != "")
            {
                campignID = Convert.ToInt32(hfId.Value);
            }
            var addCampaign = norco_db.AddCampaign(campignID, rtbDescription.Text, Convert.ToInt32(rcbStatus.SelectedValue), reNotes.Content, Convert.ToInt32(rcbSemester.SelectedValue), Convert.ToInt32(Session["UserID"].ToString()), Convert.ToInt32(Session["CollegeID"].ToString()));

            if (addCampaign == 0)
            {
                DisplayMessage(false, Resources.Messages.SuccessfullyUpdated);
            }
            else
            {
                DisplayMessage(false, "Campaign successfully saved");
                rbAddUpdate.Text = "Update";
                hfId.Value = addCampaign.ToString();
            }
            Session["ReturnCampaignID"] = hfId.Value;
            ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
        }


        protected void rbDelete_Click(object sender, EventArgs e)
        {
            try
            {
                if (hfId.Value != "")
                {
                        norco_db.DeleteCampaign(Convert.ToInt32(hfId.Value));
                        disableButtons();
                        DisplayMessage(false, "Campaign successfully deleted");
                }
            }
            catch (Exception ex1)
            {
                DisplayMessage(true, ex1.Message.ToString());
                throw;
            }
        }

        private Control FindControlRecursive(Control rootControl, string controlID)
        {
            if (rootControl.ID == controlID) return rootControl;

            foreach (Control controlToSearch in rootControl.Controls)
            {
                Control controlToReturn = FindControlRecursive(controlToSearch, controlID);
                if (controlToReturn != null) return controlToReturn;
            }
            return null;
        }

        protected void btnAddCity_Click(object sender, EventArgs e)
        {
            saveCampaign();
            if (rcbCities.SelectedValue != "")
            {
                var addCampaignCity = norco_db.AddCampaignCity(Convert.ToInt32(hfId.Value), Convert.ToInt32(rcbCities.SelectedValue));

                if (addCampaignCity == 0)
                {
                    DisplayMessage(false, "City already exist");
                }
                else
                {
                    DisplayMessage(false, "City successfully saved");
                    rgCampaignCities.DataBind();
                }
            } else
            {
                DisplayMessage(false, "Select a city");
            }

        }
    }
}