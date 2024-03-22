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
    public partial class ShowTemplate : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    Image1.ImageUrl = string.Format("~/Common/images/{0}",Session["CollegeLogo"].ToString());
                    Session["TemplateDescription"] = "";
                    var templateInfo = norco_db.GetCommunicationTemplate(Convert.ToInt32(Request["TemplateType"]), Convert.ToInt32(Session["CollegeID"]));
                    foreach (GetCommunicationTemplateResult item in templateInfo)
                    {
                        Session["TemplateDescription"] = item.Description;
                    }
                    templateContent.InnerHtml = GlobalUtil.GenerateTemplateHTML(Convert.ToInt32(Request["LeadId"]), Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Request["TemplateType"]), Session["FirstName"].ToString() + " " + Session["LastName"].ToString());
                }
                    catch (Exception ex)
                {
                    DisplayMessage(true, ex.Message.ToString());
                }
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
                templateContent.RenderControl(new HtmlTextWriter(new StringWriter(sb)));
                string _content = sb.ToString();
                try
                {
                    // EMAIL Notification
                    string to = Request["email"];
                    string subjectText = Session["TemplateDescription"].ToString();
                    string from = GlobalUtil.ReadSetting("SystemNotificationEmail");

                    var senEmail = GlobalUtil.SendEmail(subjectText, _content, from, to, from, true);
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
            }
            else
            {
                DisplayMessage(true, Resources.Messages.NoEmailFound);
            }

        }
    }
}