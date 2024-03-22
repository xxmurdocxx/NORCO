using DocumentFormat.OpenXml.Office.Drawing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class OtherCollegesArticulations : System.Web.UI.Page
    {

        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pageTitle.InnerText = string.Format("{0}-{1} {2}", Request.QueryString["subject"], Request.QueryString["course_number"], Request.QueryString["course_title"]);
                lblExists.Visible = false;
                if (Request.QueryString["exist"] != null)
                {
                    lblExists.Visible = true;
                }

                AdoptArticulationsViewer.AceID ="";
                AdoptArticulationsViewer.TeamRevd = "";
                AdoptArticulationsViewer.CollegeID = Convert.ToInt32(Session["CollegeID"]);
                AdoptArticulationsViewer.Subject = Request["subject"];
                AdoptArticulationsViewer.CourseNumber = Request["course_number"];
                AdoptArticulationsViewer.ByACEID = false;
                AdoptArticulationsViewer.ByCourseSubject = true;
                AdoptArticulationsViewer.ExcludeAdopted = true;
                AdoptArticulationsViewer.ExcludeDenied = true;
                AdoptArticulationsViewer.ExcludeArticulationOverYears = Convert.ToInt32(GlobalUtil.ReadSetting("ExcludeArticulationOverYears"));
                AdoptArticulationsViewer.RoleID = Convert.ToInt32(Session["RoleID"]);
                AdoptArticulationsViewer.UserName = Session["UserName"].ToString();
                AdoptArticulationsViewer.UserID = Convert.ToInt32(Session["UserID"]);
                AdoptArticulationsViewer.OnlyImplemented = true;
                AdoptArticulationsViewer.BySubjectCourseCIDNumber = false;
            }
        }

    }
}