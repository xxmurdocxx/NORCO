using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.reports
{
    public partial class ViewProgram : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    reportViewer1.ReportSource.Parameters.Add("program_id", Convert.ToInt32(Request["program_id"]));
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