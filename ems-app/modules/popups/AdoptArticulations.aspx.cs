using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class AdoptArticulatons : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AdoptArticulationsViewer.Visible = false;
                AdoptCreditRecommendationViewer.Visible = false;
                if (Request["AceID"]!=null)
                {
                    AdoptArticulationsViewer.Visible = true;
                    AdoptArticulationsViewer.AceID = Request["AceID"];
                    AdoptArticulationsViewer.TeamRevd = Request["TeamRevd"];
                    AdoptArticulationsViewer.CollegeID = Convert.ToInt32(Request["CollegeID"]);
                    AdoptArticulationsViewer.Subject = "";
                    AdoptArticulationsViewer.CourseNumber = "";
                    AdoptArticulationsViewer.ByACEID = true;
                    AdoptArticulationsViewer.ByCourseSubject = false;
                    AdoptArticulationsViewer.ExcludeAdopted = true;
                    AdoptArticulationsViewer.ExcludeDenied = false;
                    AdoptArticulationsViewer.ExcludeArticulationOverYears = Convert.ToInt32(GlobalUtil.ReadSetting("ExcludeArticulationOverYears"));
                    AdoptArticulationsViewer.RoleID = Convert.ToInt32(Session["RoleID"]);
                    AdoptArticulationsViewer.UserName = Session["UserName"].ToString();
                    AdoptArticulationsViewer.UserID = Convert.ToInt32(Session["UserID"]);
                    AdoptArticulationsViewer.OnlyImplemented = true;
                } else
                {
                    AdoptCreditRecommendationViewer.Visible = true;
                    AdoptCreditRecommendationViewer.CollegeID = Convert.ToInt32(Session["CollegeID"]);
                    AdoptCreditRecommendationViewer.ExcludeArticulationOverYears = false;
                    AdoptCreditRecommendationViewer.RoleID = Convert.ToInt32(Session["RoleID"]);
                    AdoptCreditRecommendationViewer.UserName = Session["UserName"].ToString();
                    AdoptCreditRecommendationViewer.UserID = Convert.ToInt32(Session["UserID"]);
                    AdoptCreditRecommendationViewer.ShowAll = false;
                    AdoptCreditRecommendationViewer.BySubjectCourseCIDNumber = false;
                    AdoptCreditRecommendationViewer.AceID = null;
                    if (Request["SetAceID"] != null)
                    {
                        AdoptCreditRecommendationViewer.AceID = Request["SetAceID"].ToString();
                    }
                    AdoptCreditRecommendationViewer.OnlyImplemented = true;
                }
                
            }
        }
    }
}