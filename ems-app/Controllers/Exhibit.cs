using DocumentFormat.OpenXml.Bibliography;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Security.AccessControl;
using System.Web;
using Telerik.Windows.Documents.Spreadsheet.Expressions.Functions;

namespace ems_app.Controllers
{
    public class Exhibit
    {
        public static void DeleteExhibit(int id)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("DeleteExhibit", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("ID", id);
            cmd.ExecuteReader();
            conn.Close();
        }
        /*
         * 			  @VersionNumber char(3),
			  @TeamRevd datetime,
			  @StartDate datetime,
			  @EndDate datetime,
              @Title varchar(max),
			  @ExhibitDisplay varchar(max)
    */
        public static void UpdateExhibit(int id, string version_number, DateTime team_revd, DateTime start_date, DateTime end_date , string title , string exhibit_display )
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("UpdateAceExhibit", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("ID", id);
            cmd.Parameters.AddWithValue("VersionNumber", version_number);
            cmd.Parameters.AddWithValue("TeamRevd", team_revd);
            cmd.Parameters.AddWithValue("StartDate", start_date);
            cmd.Parameters.AddWithValue("EndDate", end_date);
            cmd.Parameters.AddWithValue("Title", title);
            cmd.Parameters.AddWithValue("ExhibitDisplay", exhibit_display);
            cmd.ExecuteReader();
            conn.Close();
        }

        public static int CheckExhibitHasArticulations(string exhibit_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select [dbo].[CheckExhibitHasArticulations] ({exhibit_id});";
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        public static int AddExhibit(int aceType, string aceID, DateTime startDate, DateTime endDate, DateTime teamRevd, string title, string exhibitDisplay, DateTime importedOn, string versionNumber, int sourceID)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddExhibit", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@AceType", aceType));
                    cmd.Parameters.Add(new SqlParameter("@AceID", aceID));
                    cmd.Parameters.Add(new SqlParameter("@StartDate", startDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    cmd.Parameters.Add(new SqlParameter("@TeamRevd", teamRevd));
                    cmd.Parameters.Add(new SqlParameter("@Title", title));
                    cmd.Parameters.Add(new SqlParameter("@ExhibitDisplay", exhibitDisplay));
                    cmd.Parameters.Add(new SqlParameter("@ImportedOn", importedOn));
                    cmd.Parameters.Add(new SqlParameter("@VersionNumber", versionNumber));
                    cmd.Parameters.Add(new SqlParameter("@SourceID", sourceID));

                    //cmd.Parameters.AddWithValue("@UserID", user_id);
                    //cmd.Parameters.AddWithValue("@CollegeID", college_id);
                    //cmd.Parameters.AddWithValue("@haveAdditionalCriteria", have_additional_criteria);
                    //cmd.Parameters.AddWithValue("@SourceID", source_id);
                    //cmd.Parameters.AddWithValue("@Implemented", implemented);
                    //cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);

                    cmd.Parameters.Add("@id", SqlDbType.Int);
                    cmd.Parameters["@id"].Direction = ParameterDirection.Output;
                    cmd.ExecuteReader();
                    //int id = Convert.ToInt32(cmd.Parameters["@id"].Value);
                    int id = (int) cmd.Parameters["@id"].Value;
                    return id;
                }
            }
        }

    }
}