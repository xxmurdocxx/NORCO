using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.military
{
    public partial class AdoptArticulation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AdoptCreditRecommendation.CollegeID = Convert.ToInt32(Session["CollegeID"]);
                AdoptCreditRecommendation.ExcludeArticulationOverYears = false;
                AdoptCreditRecommendation.RoleID = Convert.ToInt32(Session["RoleID"]);
                AdoptCreditRecommendation.UserName = Session["UserName"].ToString();
                AdoptCreditRecommendation.UserID = Convert.ToInt32(Session["UserID"]);
                AdoptCreditRecommendation.ShowAll = false;
               
                if (AdoptCreditRecommendation.CollegeID > 3)
                {
                    AdoptCreditRecommendation.OnlyImplemented = true;
                    AdoptCreditRecommendation.BySubjectCourseCIDNumber = true;
                }
                else
                {
                    AdoptCreditRecommendation.OnlyImplemented = false;
                    AdoptCreditRecommendation.BySubjectCourseCIDNumber = false;
                }
                AdoptCreditRecommendation.AceID = null;
                if (Request["SetAceID"] != null)
                {
                    AdoptCreditRecommendation.AceID = Request["SetAceID"].ToString();
                }
            }
        }
    }
}