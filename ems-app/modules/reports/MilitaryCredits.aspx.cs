using DocumentFormat.OpenXml.Office2010.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.ReportViewer.Html5.WebForms;

namespace ems_app.modules.reports
{
    public partial class MilitaryCredits : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                reportViewer1.ReportSource.Parameters.Add("CollegeID", Convert.ToInt32(Request["CollegeID"]));
                reportViewer1.ReportSource.Parameters.Add("VeteranID", Convert.ToInt32(Request["VeteranID"]));
                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    connection.Open();

                    //Information veteran
                    using (SqlCommand command = new SqlCommand("SELECT [College] FROM [LookupColleges] WHERE [CollegeID] = " + Request["CollegeID"], connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter();
                        adapter.SelectCommand = command;

                        System.Data.DataTable dt = new System.Data.DataTable();
                        adapter.Fill(dt);
                        if (dt.Rows.Count > 0)
                        {
                            reportViewer1.ReportSource.Parameters.Add("CollegeName", dt.Rows[0].ItemArray[0].ToString().Trim());
                        }
                    }
                }

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