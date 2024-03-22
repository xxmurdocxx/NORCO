using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class EmailVeteranLetter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rptProgramCourses.DataBind();
                int Total = 0;
                foreach (RepeaterItem ri in rptProgramCourses.Items)
                {
                    Label units = ri.FindControl("lblUnits") as Label;
                    if (units.Text != "")
                    {
                        Total += Convert.ToInt32(units.Text);
                    }
                }

                lblTotalValue.Text = "Total Units : " + Total.ToString();
                
            }

        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rbEmail_Click(object sender, EventArgs e)
        {
            if (Request["email"] != null)
            {
                var sb = new StringBuilder();
                mailContent.RenderControl(new HtmlTextWriter(new StringWriter(sb)));
                string _content = sb.ToString();
                try
                {

                    // EMAIL Notification
                    string to = Request["email"];
                    string subjectText = Resources.Messages.VeteranLetterSubject;
                    string from = GlobalUtil.ReadSetting("SystemNotificationEmail");

                    var senEmail = GlobalUtil.SendEmail(subjectText, _content, from, to, "acgl2015@gmail.com", true);
                    if (senEmail)
                    {
                        DisplayMessage(true, Resources.Messages.EmailSent);
                    }
                    else
                    {
                        DisplayMessage(true, Resources.Messages.EmailProblemsSendingMessage);
                    }
                }
                catch (Exception ex)
                {
                    DisplayMessage(true, ex.Message.ToString());
                }
            } else
            {
                DisplayMessage(true, Resources.Messages.NoEmailFound);
            }

        }

    }
}