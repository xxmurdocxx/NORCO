using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ems_app.Controllers
{
    public class VeteranEligibleCredits
    {
        public static int AddVeteranEligibleCredits(int veteran_id, string exhibit_id, int user_id, int outline_id, string criteria, int? unit_id, int sourceid, string note)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddVeteranEligibleCredits", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VeteranID", veteran_id);
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.Parameters.AddWithValue("@outline_id", outline_id);
                    cmd.Parameters.AddWithValue("@Criteria", criteria);
                    cmd.Parameters.AddWithValue("@unit_id", unit_id);
                    cmd.Parameters.AddWithValue("@sourceid", sourceid);
                    cmd.Parameters.AddWithValue("@note", note);
                    cmd.Parameters.Add("@Id", SqlDbType.Int);
                    cmd.Parameters["@Id"].Direction = ParameterDirection.Output;
                    cmd.ExecuteReader();
                    int id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
                    return id;
                }
            }
        }
        public static void DeleteVeteranEligibleCredit(string veteran_id, string exhibit_id, string outline_id, string criteria)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("DeleteVeteranEligibleCredits", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VeteranID", veteran_id);
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@OutlineID", outline_id);
                    cmd.Parameters.AddWithValue("@Criteria", criteria);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        public static void UpdateVeteranEligibleCreditUnits(string id, string unit_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UpdateVeteranEligibleCreditsUnits", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", id);
                    cmd.Parameters.AddWithValue("@unit_id", unit_id);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        public static int ExistsVeteranEligibleCredits(int veteran_id, string exhibit_id, int user_id, int outline_id, string criteria)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("ExistsVeteranEligibleCredits", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VeteranID", veteran_id);
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.Parameters.AddWithValue("@outline_id", outline_id);
                    cmd.Parameters.AddWithValue("@Criteria", criteria);
                    cmd.Parameters.Add("@Id", SqlDbType.Int);
                    cmd.Parameters["@Id"].Direction = ParameterDirection.Output;
                    cmd.ExecuteReader();
                    int id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
                    return id;
                }
            }
        }
    }
}