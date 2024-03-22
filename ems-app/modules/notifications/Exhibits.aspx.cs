using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Drawing;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Collections;
using ems_app.UserControls;
using System.Reflection;
using System.Windows.Controls;
using DocumentFormat.OpenXml.Office2010.Excel;
using DocumentFormat.OpenXml.Wordprocessing;

namespace ems_app.modules.notifications
{
    public partial class Exhibits : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblTitle.Text = Request["Criteria"];


            }
        }

        protected void rptExhibits_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                int EXID = GetExhibitID(Convert.ToInt32(Request["CriteriaPackageID"]));
                string CPLEvidenceCompt = GetCPLEvidenceCompt(EXID);
                string CPLRuibric = GetCPLRubric(EXID, Convert.ToInt32(Session["CollegeID"]));
                string CPLExhiDoc = GetCPLExhibitDocument(EXID);

                Literal litCPLEvidenceCompt = e.Item.FindControl("litCPLEvidenceCompt") as Literal;

                if (litCPLEvidenceCompt != null)
                {
                    litCPLEvidenceCompt.Text = CPLEvidenceCompt;
                }

                Literal litCPLRubric = e.Item.FindControl("litCPLRubric") as Literal;

                if (litCPLRubric != null)
                {
                    litCPLRubric.Text = CPLRuibric;
                }

                Literal litCPLExhiDocuments = e.Item.FindControl("litCPLExhiDoc") as Literal;

                if (litCPLExhiDocuments != null)
                {
                    litCPLExhiDocuments.Text = CPLExhiDoc;
                }
                
            }
        }


        private int GetExhibitID(int criteriapackageID)
        {
            int result = 0;
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string sql_query = $"select ae.Title, ae.AceID, ae.ID as EhxibitID, CONVERT(VARCHAR(10),ae.TeamRevd,111) TeamRevd, concat(cast(FORMAT(ae.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(ae.EndDate, 'MM/yy') as varchar(7))) AS 'ExhibitDate', ae.ExhibitDisplay from CriteriaPackageArticulation cpa join Articulation a on cpa.ArticulationId = a.id join ACEExhibit ae on a.ExhibitID = ae.ID where cpa.PackageId = {criteriapackageID} order by a.LastSubmittedOn desc";

                SqlCommand command = new SqlCommand(sql_query, connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        result = (int)reader["EhxibitID"];
                    }
                }
                reader.Close();

            }
            return result;
        }


        private string GetCPLEvidenceCompt(int ExhibitID)
        {
            string result = "";
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string sql_query = $"SELECT * FROM [CPLEvidenceCompetency] EC inner join [CPLExhibitEvidence] EE ON EC.ExhibitEvidenceID = EE.ID WHERE EE.Active = 1 AND EC.ExhibitID = {ExhibitID}";

                SqlCommand command = new SqlCommand(sql_query, connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                result = " <div id=\"evidenceCompetency\" class='mt-4'><h2>Evidence of Competency</h2><br /></div>";
                if (reader.HasRows)
                {
                    result += "<table><tr style='background-color:#EEE; border: 1px solid #CCC;'><td style='border: 1px solid #CCC; padding: 20px 8px;'>Evidence of Competency</td><td style='border: 1px solid #CCC; padding: 2px 8px;'>Notes</td></tr>";
                    while (reader.Read())
                    {
                        result += "<tr style='border: 1px solid #CCC;'><td style='border: 1px solid #CCC; padding: 20px 8px;'>" + (string)reader["Description"] + "</td><td style='border: 1px solid #CCC; padding: 2px 8px;'>" + (string)reader["Notes"] + "</td></tr>";
                    }
                }
                else {
                    result += "<p> No records to display </p>";
                }
                reader.Close();

                result += "</table>";
                result += "</div>";
            }
            return result;
        }

        private string GetCPLRubric(int ExhibitID, int CollegeID) {
            string result = "";
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string sql_query = $"SELECT * FROM CPLRubric WHERE ExhibitID = {ExhibitID} AND CollegeID = {CollegeID}";

                SqlCommand command = new SqlCommand(sql_query, connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                result = " <div id=\"rubric\" class='mt-4'><h2>Rubric Items</h2><br /></div>";
                if (reader.HasRows)
                {
                    result += "<table><tr style='background-color:#EEE; border: 1px solid #CCC;'><td style='border: 1px solid #CCC; padding: 20px 8px;'>Rubric Item</td><td style='border: 1px solid #CCC; padding: 2px 8px;'>Score Range</td><td style='border: 1px solid #CCC; padding: 2px 8px;'>Min Score</td></tr>";
                    while (reader.Read())
                    {
                        result += "<tr style='border: 1px solid #CCC;'><td style='border: 1px solid #CCC; padding: 20px 8px;'>" + (string)reader["Rubric"] + "</td><td style='border: 1px solid #CCC; padding: 2px 8px; text-align:center;'>" + reader["ScoreRange"].ToString() + "</td><td style='border: 1px solid #CCC; padding: 2px 8px; text-align:center;'>" + reader["MinScore"].ToString() + "</td></tr>";
                    }
                }
                else
                {
                    result += "<p> No records to display </p>";
                }
                reader.Close();

                result += "</table>";
                result += "</div>";
            }
            return result;
        }

        private string GetCPLExhibitDocument(int ExhibitID)
        {
            string result = "";
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                string sql_query = $"SELECT ad.id, ad.filename, ad.filedescription, ad.binarydata, concat(u.firstname , ', ' , u.lastname ) as 'FullName', ad.CreatedBy \r\nFROM [CPLExhibitDocuments] ad left outer join tblusers u on ad.CreatedBy = u.userid  where (ad.CPLExhibitID = {ExhibitID})";

                SqlCommand command = new SqlCommand(sql_query, connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                result = " <div id=\"documents\" class='mt-4'><h2>Documents</h2><br /></div>";
                if (reader.HasRows)
                {
                    result += "<table><tr style='background-color:#EEE; border: 1px solid #CCC;'><td style='border: 1px solid #CCC; padding: 20px 8px;'>File Description</td><td style='border: 1px solid #CCC; padding: 2px 8px;'>Uploaded by</td></tr>";
                    while (reader.Read())
                    {
                        result += "<tr style='border: 1px solid #CCC;'><td style='border: 1px solid #CCC; padding: 20px 8px;'>" + (string)reader["filedescription"] + "</td><td style='border: 1px solid #CCC; padding: 2px 8px; text-align:center;'>" + (string)reader["FullName"] + "</td></tr>";
                    }
                }
                else
                {
                    result += "<p> No records to display </p>";
                }
                reader.Close();

                result += "</table>";
                result += "</div>";
            }
            return result;


        }


    }
}