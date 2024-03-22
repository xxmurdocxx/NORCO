using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class CourseInformation : System.Web.UI.UserControl
    {
        private int outline_id = 0;
        private int college_id = 0;

        public int OutlineID
        {
            get { return outline_id; }
            set { outline_id = value; }
        }

        public int CollegeID
        {
            get { return college_id; }
            set { college_id = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlCoursesDetails.SelectParameters["outline_id"].DefaultValue = OutlineID.ToString();
                sqlStudentLearningOutcome.SelectParameters["outline_id"].DefaultValue = OutlineID.ToString();
                sqlPrograms.SelectParameters["outline_id"].DefaultValue = OutlineID.ToString();
                sqlPrograms.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlCrossListingCourses.SelectParameters["outline_id"].DefaultValue = OutlineID.ToString();
            }
        }
    }
}