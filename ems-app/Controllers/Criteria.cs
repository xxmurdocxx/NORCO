using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ems_app.Controllers
{
    public class Criteria
    {
        
        public static int SaveCriteria(int articulation_id, int articulation_type, int user_id, string back_color, string fore_color, string criteria, int criteria_condition, int criteria_type, int catalog_criteria_id)
        {
            NORCODataContext norco_db = new NORCODataContext();
            //Save criteria
            var result = 0;
            var addCriteria = norco_db.AddArticulationCriteria(articulation_id, articulation_type, user_id, back_color, fore_color, criteria, criteria_condition, criteria_type, catalog_criteria_id);
            foreach (AddArticulationCriteriaResult item in addCriteria)
            {
                result = Convert.ToInt32(item.Column1);
            }
            return result;
        }

        public static int SaveOtherCriteria(int articulation_id, int articulation_type, int user_id, string back_color, string fore_color, string criteria, int criteria_condition, int criteria_type, int catalog_criteria_id)
        {
            NORCODataContext norco_db = new NORCODataContext();
            //Save criteria
            var result = 0;
            var addOtherCriteria = norco_db.AddOtherArticulationCriteria(articulation_id, articulation_type, user_id, back_color, fore_color, criteria, criteria_condition, criteria_type, catalog_criteria_id);
            return result;
        }

        public static int AddCriteriaPackage (string outline_id, string criteria, int user_id)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("AddCriteriaPackage", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("OutlineID", outline_id);
            cmd.Parameters.AddWithValue("Criteria", criteria);
            cmd.Parameters.AddWithValue("UserID", user_id);
            cmd.Parameters.Add("@PackageInserted", SqlDbType.Int);
            cmd.Parameters["@PackageInserted"].Direction = ParameterDirection.Output;
            cmd.ExecuteReader();
            int id = Convert.ToInt32(cmd.Parameters["@PackageInserted"].Value);
            conn.Close();
            return id;
        }

        public static int AddCriteriaPackagereditRecommendation(int package_id, string criteria, int condition, int user_id)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("AddCriteriaPackageCriteria", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("PackageID", package_id);
            cmd.Parameters.AddWithValue("Criteria", criteria);
            cmd.Parameters.AddWithValue("Condition", condition);
            cmd.Parameters.AddWithValue("UserID", user_id);
            cmd.Parameters.Add("@Id", SqlDbType.Int);
            cmd.Parameters["@Id"].Direction = ParameterDirection.Output;
            cmd.ExecuteReader();
            int id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
            conn.Close();
            return id;
        }

        public static void AddCriteriaPackageArticulation(int package_id, int articulation_id, int user_id, int criteria_package_id)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("AddCriteriaPackageArticulation", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("PackageId", package_id);
            cmd.Parameters.AddWithValue("ArticulationID", articulation_id);
            cmd.Parameters.AddWithValue("CriteriaPackageID", criteria_package_id);
            cmd.Parameters.AddWithValue("UserID", user_id);
            cmd.ExecuteReader();
            conn.Close();
        }

        public static int AddCreditRecommendation(string ace_id, int ace_type, DateTime team_revd, DateTime start_date, DateTime end_date, string criteria, string criteria_description, int source_id)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("AddCreditRecommendation", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("AceID", ace_id);
            cmd.Parameters.AddWithValue("AceType", ace_type);
            cmd.Parameters.AddWithValue("TeamRevd", team_revd);
            cmd.Parameters.AddWithValue("StartDate", start_date);
            cmd.Parameters.AddWithValue("EndDate", end_date);
            cmd.Parameters.AddWithValue("Criteria", criteria);
            cmd.Parameters.AddWithValue("CriteriaDescription", criteria_description);
            cmd.Parameters.AddWithValue("SourceID", source_id);
            cmd.Parameters.Add("@Id", SqlDbType.Int);
            cmd.Parameters["@Id"].Direction = ParameterDirection.Output;
            cmd.ExecuteReader();
            int id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
            conn.Close();
            return id;
        }

        public static void DeleteCreditRecommendation(int criteria_id, bool delete_credit_recommendation, bool delete_articulation)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand cmd = new SqlCommand("DeleteCreditRecommendation", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("CriteriaID", criteria_id);
            cmd.Parameters.AddWithValue("DeleteCreditRecommendation", delete_credit_recommendation);
            cmd.Parameters.AddWithValue("DeleteArticulation", delete_articulation);
            cmd.ExecuteReader();
            conn.Close();
        }

        public static int CheckCreditRecommendationHasArticulations(int criteria_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckCreditRecommendationHasArticulations] ({0});", criteria_id);
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }
        public static int CheckCriteriaHasArticulations(string courses, string criteria)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select [dbo].[CheckCriteriaHasArticulations] ('{courses}','{criteria}');";
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

    }
}