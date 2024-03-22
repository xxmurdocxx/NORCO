using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.reports
{
    public partial class DistrictArticulationReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    reportViewer1.ReportSource.Parameters.Add("CollegeID", Convert.ToInt32(Request["CollegeID"]));
                    reportViewer1.ReportSource.Parameters.Add("StageID", Convert.ToInt32(Request["StageID"]));
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