using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.UserControls
{
    public partial class CollegeSummary : System.Web.UI.UserControl
    {
        NORCODataContext norco_db = new NORCODataContext();
        private int College_id = 0;

        public int CollegeID
        {
            get { return College_id; }
            set { College_id = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlDistrictColleges.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlDistrictColleges.DataBind();
                rcbColleges.SelectedValue = CollegeID.ToString();
                UpdateSummary(CollegeID);
            }
        }

        public void UpdateSummary(int college_id)
        {
            var summary = norco_db.GetCollegeSummary(college_id);
            foreach (GetCollegeSummaryResult item in summary)
            {
                divCollegeSummary.InnerHtml = item.Summary;
            }
        }

        protected void rcbColleges_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            UpdateSummary(Convert.ToInt32(rcbColleges.SelectedValue));
        }


    }
}