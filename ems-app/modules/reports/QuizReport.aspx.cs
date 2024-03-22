using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.reports
{
    public partial class QuizReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                reportViewer1.ReportSource.Identifier = "QuizReport.trdp";
                reportViewer1.ReportSource.Parameters.Add("user_id", Convert.ToInt32(Request["UserID"]));
                reportViewer1.ReportSource.Parameters.Add("survey_id", Convert.ToInt32(Request["SurveyID"]));
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