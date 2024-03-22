using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Math;
using DocumentFormat.OpenXml.Office2010.Excel;
using ems_app.Controllers;
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

namespace ems_app.modules.popups
{
    public partial class ExcludeArticulationCourses : System.Web.UI.Page
    {
        NORCODataContext db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfVeteranCreditRecommendationID.Value = Request["VeteranCreditRecommendationID"];
                rlCreditRecommendation.Text = $"Credit Recommendation : {Request["CreditRecommendation"]}" ;
                sqlExcludedArticulationCourses.DataBind();
            }
        }

        public static int CheckArticulationCourseExcluded(string veteran_credit_recommendation_id, string articulation_id)
        {
            int result = 0;
            {
                using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    SqlCommand cmd = connection.CreateCommand();
                    connection.Open();
                    try
                    {
                        cmd.CommandText = $"select [dbo].[CheckArticulationCourseExcluded] ({veteran_credit_recommendation_id},{articulation_id});";
                        result = ((int)cmd.ExecuteScalar());
                    }
                    finally
                    {
                        connection.Close();
                    }
                }
                return result;
            }
        }

        protected void rgExcludeArticulatedCourses_PreRender(object sender, EventArgs e)
        {
            foreach (GridDataItem dataItem in this.rgExcludeArticulatedCourses.MasterTableView.Items)
            {
                if (CheckArticulationCourseExcluded(dataItem["VeteranCreditRecommendationID"].Text, dataItem["ArticulationID"].Text) == 0)
                {
                    dataItem.Selected = true;
                }
            }
        }
        protected static int UpdateExcludedArticulations(string veteran_credit_recommendation_id, string articulation_id, string user_id, bool value)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UpdateExcludedArticulations", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VeteranCreditRecommendationID", veteran_credit_recommendation_id);
                    cmd.Parameters.AddWithValue("@ArticulationID", articulation_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.Parameters.AddWithValue("@value", value);
                    var outParm = new SqlParameter("@Result", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);
                    cmd.ExecuteNonQuery();
                    return Convert.ToInt32(outParm.Value);
                }
            }
        }

        protected void rgExcludeArticulatedCourses_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            try
            {
                if (e.CommandName == "Exclude")
                {
                    rnMessage.Text = "<p>The following articulated courses have been included / excluded : </p>";
                    foreach (GridDataItem item in grid.Items)
                    {
                        var result = UpdateExcludedArticulations(item["VeteranCreditRecommendationID"].Text, item["ArticulationID"].Text, Session["UserID"].ToString(), item.Selected);
                        if (result == 1)
                        {
                            rnMessage.Text += $"<p class='alert alert-success'>{item["subject"].Text} {item["course_number"].Text} - {item["course_title"].Text} has been Included.</p>";
                        }
                        else if (result == -1)
                        {
                            rnMessage.Text += $"<p class='alert alert-danger'>{item["subject"].Text} {item["course_number"].Text} - {item["course_title"].Text} has been Excluded.</p>";              
                        }
                        rnMessage.Show();
                    }
                }
                if (e.CommandName == "Delete")
                {
                    rnMessage.Text = "<p>The following articulated courses have been deleted : </p>";
                    foreach (GridDataItem item in grid.SelectedItems)
                    {
                        if (item["RoleName"].Text == "Implementation")
                        {
                            rnMessage.Text += $"<p class='alert alert-warning'>{item["subject"].Text} {item["course_number"].Text} - {item["course_title"].Text} could not be deleted because is in Implementation stage.</p>";
                        } else {
                            if (Session["RoleName"].ToString() == "Evaluator" || Convert.ToBoolean(Session["SuperUser"]) == true || Convert.ToBoolean(Session["isAdministrator"]) == true || Session["RoleName"].ToString() == "Ambassador")
                            {
                                GlobalUtil.DeleteArticulation(Convert.ToInt32(item["ArticulationID"].Text), Convert.ToInt32(Session["UserID"]));
                                rnMessage.Text += $"<p class='alert alert-info'>{item["subject"].Text} {item["course_number"].Text} - {item["course_title"].Text} has been deleted.</p>";
                            }
                        }
                    }
                    rnMessage.Show();
                    rgExcludeArticulatedCourses.DataBind();
                }
            }
            catch (Exception x)
            {
                rnMessage.Text = x.ToString();
                rnMessage.Show();
            }
        }

    }
}