using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.settings
{
    public partial class CreditRecommendations : System.Web.UI.Page
    {
        NORCODataContext db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["SourceID"]=="1")
            {
                pnlAddCreditRecommendations.Enabled = false;
                rgCreditRecommendations.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
            }
            if (Request["AreaCredit"] != null)
            {
                sqlCourses.SelectParameters["CourseType"].DefaultValue = "2";
                sqlCourses.DataBind();
                rcbCourses.Label = "Area Credit : ";
                rcbCourses.EmptyMessage = "Select Area Credit...";
                rcbCourses.DataBind();
            }
        }

        protected void rgCreditRecommendations_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            try
            {

                if (e.CommandName == "Delete")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        rnMessage.Text = "Select a Credit Recommendation.";
                        rnMessage.Show();
                    }
                    else
                    {
                        if (e.CommandName == "Delete")
                        {
                            int exists = Controllers.Criteria.CheckCreditRecommendationHasArticulations(Convert.ToInt32(itemDetail["CriteriaID"].Text));
                            if (exists == 0)
                            {
                                Controllers.Criteria.DeleteCreditRecommendation(Convert.ToInt32(itemDetail["CriteriaID"].Text),true,true);
                                rgCreditRecommendations.DataBind();
                                rnMessage.Text = "Credit Recommendation deleted.";
                                rnMessage.Show();
                            }
                            else
                            {
                                rnMessage.Text = "Credit Recommendation has related articulations.";
                                rnMessage.Show();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                rnMessage.Text = ex.Message;
                rnMessage.Show();
            }
        }

        protected void rbAddCourses_Click(object sender, EventArgs e)
        {
            var sb = new StringBuilder();
            List<string> courses = new List<string>();
            var collection = rcbCourses.CheckedItems;
            if (collection.Count != 0)
            {
                foreach (var item in collection)
                {
                    courses.Add(item.Value);
                }
            }
            DataTable course_list = GetCoursesCreditRecommendations(string.Join(",",courses));
            sb.Append("<ul class=\"results\">");
            if (course_list != null)
            {
                if (course_list.Rows.Count > 0)
                {
                    foreach (DataRow row in course_list.Rows)
                    {
                        sb.Append("<li>" + row["CourseDescription"].ToString() + "</li>");
                    }
                }
            }
            sb.Append("</ul>");
            ltSelectedCourse.Text = sb.ToString();
            string script = "function f(){showWindow(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
        }
        public static DataTable GetCoursesCreditRecommendations(string courses)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetCoursesCreditRecommendations", conn);
                cmd.Parameters.Add("@Courses", SqlDbType.VarChar).Value = courses;
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }
            return myDataTable;
        }
        protected void rbAddCreditRecommendations_Click(object sender, EventArgs e)
        {
            try
            {
                int articulation_id = 0;
                int criteria_id = 0;
                var collection = rcbCourses.CheckedItems;
                var course_title = "";
                if (collection.Count != 0)
                {
                    foreach (var item in collection)
                    {
                        var articulationExists = Controllers.Articulation.CheckArticulationExists(Convert.ToInt32(item.Value), Request["AceID"], Convert.ToDateTime(Request["TeamRevd"]));
                        if (articulationExists == 0)
                        {
                            course_title = db.GetCourseTitle(Convert.ToInt32(item.Value), Convert.ToInt32(Session["CollegeID"]));
                            articulation_id = Controllers.Articulation.AddArticulation(Convert.ToInt32(item.Value), Request["AceID"], Convert.ToDateTime(Request["TeamRevd"]), course_title, "", "", "", "", Convert.ToInt32(Request["AceType"]), Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Session["CollegeID"]), false, 3, false,99999999);
                            DataTable course_list = GetCoursesCreditRecommendations(item.Value);
                            if (course_list != null)
                            {
                                if (course_list.Rows.Count > 0)
                                {
                                    foreach (DataRow row in course_list.Rows)
                                    {
                                        criteria_id = Controllers.Criteria.AddCreditRecommendation(Request["AceID"], Convert.ToInt32(Request["AceType"]), Convert.ToDateTime(Request["TeamRevd"]), Convert.ToDateTime(Request["StartDate"]), Convert.ToDateTime(Request["EndDate"]), row["CourseDescription"].ToString(), "", Convert.ToInt32(Request["SourceID"]));
                                        var artData = db.GetArticulationByID(articulation_id);
                                        foreach (GetArticulationByIDResult art in artData)
                                        {
                                            Controllers.Criteria.SaveCriteria(art.ArticulationID, Convert.ToInt32(art.ArticulationType), Convert.ToInt32(Session["UserID"]), "#FFFF66", "#000000", row["CourseDescription"].ToString(), 1, 1, criteria_id);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    rgCreditRecommendations.DataBind();
                    ClearCourses();
                    rnMessage.Text = "Credit Recommendation(s) added.";
                    rnMessage.Show();
                }
            }
            catch (Exception x)
            {
                rnMessage.Text = x.Message;
                rnMessage.Show();
            }
        }

        private void ClearCourses()
        {
            rcbCourses.ClearSelection();

            foreach (RadComboBoxItem item in rcbCourses.CheckedItems)
            {
                item.Checked = false;
            }

            rcbCourses.Focus();
        }
        protected void rbClear_Click(object sender, EventArgs e)
        {
            ClearCourses();
        }

        protected void rgCreditRecommendations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = (GridDataItem)e.Item;
                if (Request["SourceID"] == "1")
                {
                    ElasticButton edit = (ElasticButton)item["EditCommandColumn"].Controls[0];
                    edit.Enabled = false;
                    ElasticButton delete = (ElasticButton)item["DeleteColumn"].Controls[0];
                    delete.Enabled = false;
                }
            }
        }
    }
}