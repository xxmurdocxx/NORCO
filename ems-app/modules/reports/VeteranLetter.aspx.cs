namespace ems_app.modules.reports
{
    using System;
    using Telerik.ReportViewer.Html5.WebForms;

    public partial class VeteranLetter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    reportViewer1.ReportSource.Parameters.Add("Content", GlobalUtil.GenerateTemplateHTML(Convert.ToInt32(Request["LeadId"]), Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Request["TemplateType"]), Session["FirstName"].ToString() + " " + Session["LastName"].ToString()) );
                    reportViewer1.DataBind();
                    reportViewer1.ParametersAreaVisible = false;
                }
                catch (Exception ex)
                {
                    msg.InnerText =  ex.Message.ToString();
                }

            }
        }
    }
}