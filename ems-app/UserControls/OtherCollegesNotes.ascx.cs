using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class OtherCollegesNotes : System.Web.UI.UserControl
    {
        private string subject = "";
        private string course_number = "";
        private string exhibit_id = "";
        private string criteria_id = "";
        private int college_id = 0;
        public string Subject
        {
            get { return subject; }
            set { subject = value; }
        }
        public string CourseNumber
        {
            get { return course_number; }
            set { course_number = value; }
        }
        public string ExhibitID
        {
            get { return exhibit_id; }
            set { exhibit_id = value; }
        }
        public string CriteriaID
        {
            get { return criteria_id; }
            set { criteria_id = value; }
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
                hfSubject.Value = Subject;
                hfCourseNumber.Value = CourseNumber;
                hfExhibitID.Value = ExhibitID;
                hfCriteriaID.Value = CriteriaID;
                hfCollegeID.Value = CollegeID.ToString();
                rgNotes.DataBind();
            }
        }
    }
}