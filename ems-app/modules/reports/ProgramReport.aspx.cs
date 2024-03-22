namespace ems_app.modules.reports
{
    using System;
    using Telerik.ReportViewer.Html5.WebForms;

    public partial class ProgramReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    switch (Request["print_type"])
                    {
                        case "all":
                            reportViewer1.ReportSource.Identifier = "AllProgramsShortVersion.trdp";
                            reportViewer1.ReportSource.Parameters.Add("college_id", Convert.ToInt32(Session["CollegeID"]));
                            break;
                        case "short":
                            reportViewer1.ReportSource.Identifier = "ProgramShortVersion.trdp";
                            reportViewer1.ReportSource.Parameters.Add("program_id", Convert.ToInt32(Request["program_id"]));
                            break;
                        case "full":
                            reportViewer1.ReportSource.Identifier = "ProgramReport.trdp";
                            reportViewer1.ReportSource.Parameters.Add("program_id", Convert.ToInt32(Request["program_id"]));
                            break;
                    }
                    reportViewer1.DataBind();
                    reportViewer1.ParametersAreaVisible = false;
                }
                catch (Exception ex)
                {
                    msg.InnerText = ex.Message.ToString();
                }

            }
        }
    }
}