using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.ReportViewer.Html5.WebForms;

namespace ems_app.modules.reports
{
    public partial class CPLExhibits1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                reportViewer1.ReportSource.Parameters.Add("CollegeID", Convert.ToInt32(Request["CollegeID"]));
                reportViewer1.ReportSource.Parameters.Add("ExhibitID", Convert.ToInt32(Request["ExhibitID"]));
                reportViewer1.DataBind();
                reportViewer1.ParametersAreaVisible = false;
                reportViewer1.ViewMode = ViewMode.PrintPreview;
                reportViewer1.ScaleMode = ScaleMode.FitPageWidth;
            }
            catch (Exception ex)
            {
                msg.InnerText = ex.Message.ToString();
            }
        }
    }
}