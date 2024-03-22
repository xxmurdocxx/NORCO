using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Configuration;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class Feedback : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void rbSave_Click(object sender, EventArgs e)
        {
            try
            {
                norco_db.AddFeedback(Convert.ToInt32(txtFeedbackType.Text), rtbDetails.Text, Session["ResourcePage"].ToString(), Convert.ToInt32(Session["UserID"]));
                DisplayMessage(false, Resources.Messages.FeedbackThanks);

                // EMAIL Notification
                string to = "";
                string bodyMessage = "";
                string subjectText = Resources.Messages.FeedbackSubjectEmail;
                string from = GlobalUtil.ReadSetting("FeedbackNotificationEmail");
                bodyMessage = Resources.Messages.FeedbackBodyMessage;
                var userData = norco_db.GetUserDataByID(Convert.ToInt32(Session["UserID"]));
                foreach (GetUserDataByIDResult p in userData)
                {
                    to = p.Email;
                }
                var senEmail = GlobalUtil.SendEmail(subjectText, bodyMessage, from, to, from, true);
                if (senEmail)
                {
                    RadAjaxManager1.ResponseScripts.Add("CloseModal();");
                } else
                {
                    DisplayMessage(true, Resources.Messages.EmailProblemsSendingMessage);
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
            }

        }
        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void btn_Click(object sender, EventArgs e)
        {
            RadButton btn = (RadButton)sender;
            txtFeedbackType.Text = btn.Value;
        }

    }
}