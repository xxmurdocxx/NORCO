using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.reports
{
    public partial class ArticulationsReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    string subjectFilter = Request["SubjectFilter"];
                    string courseFilter = Request["CourseFilter"];
                    string titleFilter = Request["TitleFilter"];
                    int stageFilter = Convert.ToInt32(Request["StageFilter"]);
                    bool showDenied = Convert.ToBoolean(Request["ShowDenied"]);
                    //segment.Cmb_Id_Parent == 0 ? null : (int?)segment.Cmb_Id_Parent
                    reportViewer1.ReportSource.Identifier = "Articulations.trdp";
                    reportViewer1.ReportSource.Parameters.Add("Username", Request["Username"]);
                    reportViewer1.ReportSource.Parameters.Add("OrderBy", Request["OrderBy"]);
                    reportViewer1.ReportSource.Parameters.Add("CollegeID", Convert.ToInt32(Request["CollegeID"]));
                    reportViewer1.ReportSource.Parameters.Add("UserID", Convert.ToInt32(Request["UserID"]));
                    reportViewer1.ReportSource.Parameters.Add("RoleID", Convert.ToInt32(Request["RoleID"]));
                    reportViewer1.ReportSource.Parameters.Add("CollegeName", Request["CollegeName"]);
                    reportViewer1.ReportSource.Parameters.Add("SubjectFilter", subjectFilter == string.Empty ? null : subjectFilter);
                    reportViewer1.ReportSource.Parameters.Add("CourseFilter", courseFilter == string.Empty ? null : "%" + courseFilter + "%");
                    reportViewer1.ReportSource.Parameters.Add("TitleFilter", titleFilter == string.Empty ? null : "%" + titleFilter + "%");
                    reportViewer1.ReportSource.Parameters.Add("StageFilter", stageFilter);
                    reportViewer1.ReportSource.Parameters.Add("ShowDenied", showDenied);
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