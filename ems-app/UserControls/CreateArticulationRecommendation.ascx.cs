using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ems_app.Controllers;
using System.Web.UI.HtmlControls;

namespace ems_app.UserControls
{
    public partial class CreateArticulationRecommendation : System.Web.UI.UserControl
    {
        int collegeID = 0;
        NORCODataContext db = new NORCODataContext();
        List<string> criteria = new List<string>();
        List<string> criteriaBadges = new List<string>();
        List<string> aceIDs = new List<string>();
        public int CollegeID
        {
            get
            {
                if (ViewState["collegeID"] != null)
                { collegeID = Int32.Parse(ViewState["collegeID"].ToString()); };
                return collegeID;
            }
            set { ViewState["collegeID"] = value; }
            
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            divAdvancedSearch.Visible = true;
            modalPopup.Modal = true;
            if (!IsPostBack)
            {
                sqlCourses.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlCriteria.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlCourses.DataBind();
                validationMessages(false);
            }
        }
        protected void rbClear_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        protected void validationMessages(bool show)
        {
            lblCourse.Visible = show;
            lblCreditRecommendation.Visible = show;
            lblAdvancedSearch.Visible = show;
        }

        public void updateCriteriaList()
        {
            criteria.Clear();
            criteriaBadges.Clear();
            for (int i = 0; i < racbCriteria.Entries.Count; i++)
            {
                criteria.Add(racbCriteria.Entries[i].Value.Trim());
                criteriaBadges.Add(string.Format("<span class='badge badge-secondary p-1 m-1'>{0}</span>", racbCriteria.Entries[i].Value));
            }
            for (int i = 0; i < racbAdvancedSearch.Entries.Count; i++)
            {
                criteria.Add(racbAdvancedSearch.Entries[i].Value.Trim().Substring(racbAdvancedSearch.Entries[i].Value.Trim().LastIndexOf("-")+1));
                criteriaBadges.Add(string.Format("<span class='badge badge-secondary p-1 m-1'>{0}</span>", racbAdvancedSearch.Entries[i].Value.Trim().Substring(racbAdvancedSearch.Entries[i].Value.Trim().LastIndexOf("-")+1)));
                aceIDs.Add(string.Concat(racbAdvancedSearch.Entries[i].Value.TakeWhile((c) => c != '-')));
            }
            criteria.Distinct().ToList();
        }

        protected void rbCreate_Click(object sender, EventArgs e)
        {
            Session["VeteranEligibleCredits"] = null;
            if (db.GetStageOrderByRoleId(Convert.ToInt32(Session["CollegeID"].ToString()),Convert.ToInt32(Session["RoleID"].ToString())) > 1)
            {
                rnCreateCreditRecommendation.Text = string.Format("Oops! It looks like you are trying to create an articulation in the {0} stage. To move forward, please toggle your role to Evaluator or contact your MAP Ambassador to further adjust your assigned role(s).",Session["RoleName"].ToString());
                rnCreateCreditRecommendation.Show();
            }
            else
            {
                //divAdvancedSearch.Visible = (bool)rchkkAdvancedSearch.Checked;
                validationMessages(false);
                if (rcbCourses.SelectedValue == "" || (racbCriteria.Entries.Count == 0 && racbAdvancedSearch.Entries.Count == 0))
                {
                    if (rcbCourses.SelectedValue == "")
                    {
                        lblCourse.Visible = true;
                    }
                    if (racbCriteria.Entries.Count == 0 || racbAdvancedSearch.Entries.Count == 0)
                    {
                        if (racbCriteria.Entries.Count == 0)
                        {
                            lblCreditRecommendation.Visible = true;
                        }
                        if (racbAdvancedSearch.Entries.Count == 0)
                        {
                            lblAdvancedSearch.Visible = true;
                        }
                    }
                    //if (racbAdvancedSearch.Entries.Count == 0 && rchkkAdvancedSearch.Checked == true)
                    //{
                    // lblAdvancedSearch.Visible = true;
                    //}
                }
                else
                {
                    updateCriteriaList();
                    Session["SelectedCourse"] = rcbCourses.SelectedValue;
                    Session["SelectedCourseText"] = rcbCourses.SelectedItem.Text;
                    Session["SelectedCriteria"] = string.Join("|", criteria);
                    Session["SelectedCriteriaText"] = string.Join("|", criteriaBadges);
                    Session["SelectedAceID"] = string.Join(",", aceIDs);
                    Session["SelectedConditionText"] = rcbCondition.SelectedItem.Text;
                    if (racbCriteria.Entries.Count > 1)
                    {
                        Session["CreditRecommendationsCount"] = racbCriteria.Entries.Count;
                        Session["SelectedCondition"] = rcbCondition.SelectedValue;
                    }
                    else
                    {
                        Session["CreditRecommendationsCount"] = 1 ;
                        Session["SelectedCondition"] = "1";
                    }
                    string script = "function f(){$find(\"" + modalPopup.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                }
            }
        }

        private void ResetForm()
        {
            rcbCourses.ClearSelection();
            racbCriteria.Entries.Clear();
            racbAdvancedSearch.Entries.Clear();
           // pnlCreditRecommendations.Enabled = false;
            //pnlSelectedCourseInfo.Visible = false;
            rchkkAdvancedSearch.Checked = false;
            //divAdvancedSearch.Visible = (bool)rchkkAdvancedSearch.Checked;
        }

        protected void rcbCourses_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            //divAdvancedSearch.Visible = (bool)rchkkAdvancedSearch.Checked;
            pnlCreditRecommendations.Enabled = false;
            pnlSelectedCourseInfo.Visible = false;
            if (rcbCourses.SelectedValue != "")
            {
                pnlCreditRecommendations.Enabled = true;
                DataTable selectedCourse = GlobalUtil.GetCourseInformation(Convert.ToInt32(rcbCourses.SelectedValue));
                if (selectedCourse != null)
                {
                    if (selectedCourse.Rows.Count > 0)
                    {
                        foreach (DataRow row in selectedCourse.Rows)
                        {
                            var top_code = row["_TopsCode"].ToString() != "" ? row["_TopsCode"].ToString() : "N/A";
                            var cid_number = row["_CIDNumber"].ToString() != "" ? string.Format("{0} {1}", row["_CIDNumber"].ToString(), row["_CIDTitle"].ToString() ) : "N/A";
                            rlSelectedCourse.Text = string.Format("<b>Taxonomy of Programs (TOP) Code :</b> {0}  &nbsp;&nbsp;-&nbsp;&nbsp;  <b>C-ID Number :</b> {1}", top_code, cid_number);
                        }
                        pnlSelectedCourseInfo.Visible = true;
                    }
                }            
            }
            lblCourse.Visible = false;
        }

        protected void rchkkAdvancedSearch_CheckedChanged(object sender, EventArgs e)
        {
            divAdvancedSearch.Visible = (bool)rchkkAdvancedSearch.Checked;
        }
    }
}