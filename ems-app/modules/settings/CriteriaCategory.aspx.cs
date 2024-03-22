using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.settings
{
    public partial class CriteriaCategory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void rgCriteriaCategory_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                Label relatedComp = e.Item.FindControl("lblRelatedCompetencies") as Label;
                relatedComp.Visible = false;
                if (dataBoundItem["LearningOutcome"].Text != "" && dataBoundItem["LearningOutcome"].Text != "&nbsp;")
                {
                    relatedComp.Visible = true;
                    relatedComp.ToolTip = dataBoundItem["LearningOutcome"].Text;
                }
                Label relatedCourses = e.Item.FindControl("lblRelatedCourses") as Label;
                relatedCourses.Visible = false;
                if (dataBoundItem["CourseList"].Text != "&nbsp;")
                {
                    relatedCourses.Visible = true;
                    relatedCourses.ToolTip = dataBoundItem["CourseList"].Text;
                }
            }
            if (e.Item is GridFilteringItem)
            {
                GridFilteringItem item = e.Item as GridFilteringItem;
                ((item["SourceID"].Controls[0]) as TextBox).Text = ((item["SourceName"].Controls[0]) as TextBox).Text;
            }

        }

        protected void rgCriteriaCategory_BatchEditCommand(object sender, GridBatchEditingEventArgs e)
        {
            foreach (GridBatchEditingCommand command in e.Commands)
            {
                if (command.Type == GridBatchEditingCommandType.Update || command.Type == GridBatchEditingCommandType.Insert)
                {
                    Hashtable newValues = command.NewValues;
                    Hashtable oldValues = command.OldValues;
                    string criteriaDescription = newValues["CriteriaDescription"].ToString();
                    string doNotArticulate = newValues["DoNotArticulate"].ToString();
                    string topcode = newValues["topscode_id"].ToString();
                    string uniform = newValues["UniformCreditRecommendation"].ToString();
                    string units = newValues["Units"].ToString();
                    string SourceID = newValues["SourceID"].ToString();
                    try
                    {
                        UpdateCriteria(criteriaDescription, doNotArticulate, Session["UserID"].ToString(), topcode, uniform, units, SourceID);
                    }
                    catch (Exception ex)
                    {
                        
                    }
                }
            }
        }

        public void UpdateCriteria(string criteriaDescription, string doNotArticulate,  string userID, string topCode, string   uniform, string units, string SourceID)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("spCriteriaCategoriesInsertUpdate", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("CriteriaDescription", criteriaDescription);
            cmd.Parameters.AddWithValue("DoNotArticulate", doNotArticulate);
            cmd.Parameters.AddWithValue("UserID", userID);
            cmd.Parameters.AddWithValue("topscode_id", topCode);
            cmd.Parameters.AddWithValue("UniformCreditRecommendation", uniform);
            cmd.Parameters.AddWithValue("Units", units);
            cmd.Parameters.AddWithValue("SourceID", SourceID);
            cmd.ExecuteReader();
            conn.Close();
        }

        protected void rgCriteriaCategory_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == RadGrid.FilterCommandName)
            {
                Pair command = (Pair)e.CommandArgument;
                if (command.Second.ToString() == "SourceID")
                {
                    e.Canceled = true;
                    GridFilteringItem filter = (GridFilteringItem)e.Item;
                    ((filter["SourceName"].Controls[0]) as TextBox).Text = ((filter["SourceID"].Controls[0]) as TextBox).Text;
                    command.Second = "SourceName";
                    filter.FireCommandEvent("Filter", new Pair(command.First, "SourceName"));
                }
            }

        }
    }
}