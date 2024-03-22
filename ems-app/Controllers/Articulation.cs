using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ems_app.Controllers
{
    public class Articulation
    {
        public static int AddArticulation(int outline_id,string ace_id, DateTime team_revd, string title, string notes, string justification, string articulation_officer_notes, string recommendation, int articulation_type, int user_id, int college_id, bool have_additional_criteria, int source_id, bool implemented, int exhibit_id )
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddArticulation", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@outline_id", outline_id));
                    cmd.Parameters.Add(new SqlParameter("@AceID", ace_id));
                    cmd.Parameters.Add(new SqlParameter("@TeamRevd", team_revd));
                    cmd.Parameters.Add(new SqlParameter("@Title", title));
                    cmd.Parameters.Add(new SqlParameter("@notes", notes));
                    cmd.Parameters.Add(new SqlParameter("@Justification", justification));
                    cmd.Parameters.Add(new SqlParameter("@ArticulationOfficerNotes", articulation_officer_notes));
                    cmd.Parameters.Add(new SqlParameter("@recommendation", recommendation));
                    cmd.Parameters.Add(new SqlParameter("@ArticulationType", articulation_type));
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.Parameters.AddWithValue("@CollegeID", college_id);
                    cmd.Parameters.AddWithValue("@haveAdditionalCriteria", have_additional_criteria);
                    cmd.Parameters.AddWithValue("@SourceID", source_id);
                    cmd.Parameters.AddWithValue("@Implemented", implemented);
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.Add("@Id", SqlDbType.Int);
                    cmd.Parameters["@Id"].Direction = ParameterDirection.Output;
                    cmd.ExecuteReader();
                    int id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
                    return id;
                }
            }
        }

        public static int AddArticulation(int outline_id, string ace_id, DateTime team_revd, string title, string notes, string justification, string articulation_officer_notes, string recommendation, int articulation_type, int user_id, int college_id, bool have_additional_criteria, int source_id, bool implemented, int exhibit_id, string criteria, string criteriaID)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddArticulationStudent", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@outline_id", outline_id));
                    cmd.Parameters.Add(new SqlParameter("@AceID", ace_id));
                    cmd.Parameters.Add(new SqlParameter("@TeamRevd", team_revd));
                    cmd.Parameters.Add(new SqlParameter("@Title", title));
                    cmd.Parameters.Add(new SqlParameter("@notes", notes));
                    cmd.Parameters.Add(new SqlParameter("@Justification", justification));
                    cmd.Parameters.Add(new SqlParameter("@ArticulationOfficerNotes", articulation_officer_notes));
                    cmd.Parameters.Add(new SqlParameter("@recommendation", recommendation));
                    cmd.Parameters.Add(new SqlParameter("@ArticulationType", articulation_type));
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.Parameters.AddWithValue("@CollegeID", college_id);
                    cmd.Parameters.AddWithValue("@haveAdditionalCriteria", have_additional_criteria);
                    cmd.Parameters.AddWithValue("@SourceID", source_id);
                    cmd.Parameters.AddWithValue("@Implemented", implemented);
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@Criteria", criteria);
                    cmd.Parameters.AddWithValue("@CriteriaID", criteriaID);
                    cmd.Parameters.Add("@Id", SqlDbType.Int);
                    cmd.Parameters["@Id"].Direction = ParameterDirection.Output;
                    cmd.ExecuteReader();
                    int id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
                    return id;
                }
            }
        }

        public static int AddNewArticulation(int package_id, int outline_id, string ace_id, DateTime team_revd, string title, string notes, string justification, string articulation_officer_notes, string recommendation, int articulation_type, int user_id, int college_id, bool have_additional_criteria, int source_id, bool implemented, int exhibit_id, int criteria_id, string credit_recommendation, string file_name, string file_description, byte[] binary_data, int role_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("sp_AddArticulationCReditReccommendation", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@package_id", package_id));
                    cmd.Parameters.Add(new SqlParameter("@outline_id", outline_id));
                    cmd.Parameters.Add(new SqlParameter("@AceID", ace_id));
                    cmd.Parameters.Add(new SqlParameter("@TeamRevd", team_revd));
                    cmd.Parameters.Add(new SqlParameter("@Title", title));
                    cmd.Parameters.Add(new SqlParameter("@notes", notes));
                    cmd.Parameters.Add(new SqlParameter("@Justification", justification));
                    cmd.Parameters.Add(new SqlParameter("@ArticulationOfficerNotes", articulation_officer_notes));
                    cmd.Parameters.Add(new SqlParameter("@recommendation", recommendation));
                    cmd.Parameters.Add(new SqlParameter("@ArticulationType", articulation_type));
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.Parameters.AddWithValue("@CollegeID", college_id);
                    cmd.Parameters.AddWithValue("@haveAdditionalCriteria", have_additional_criteria);
                    cmd.Parameters.AddWithValue("@SourceID", source_id);
                    cmd.Parameters.AddWithValue("@Implemented", implemented);
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@CriteriaID", criteria_id);
                    cmd.Parameters.AddWithValue("@CreditRecommendation", credit_recommendation);
                    cmd.Parameters.Add(new SqlParameter("FileName", file_name));
                    cmd.Parameters.Add(new SqlParameter("FileDescription", file_description));
                    cmd.Parameters.Add(new SqlParameter("BinaryData", binary_data ));
                    cmd.Parameters.Add(new SqlParameter("RoleID", role_id));
                    cmd.Parameters.Add("@Id", SqlDbType.Int);
                    cmd.Parameters["@Id"].Direction = ParameterDirection.Output;
                    cmd.ExecuteNonQuery();
                    int id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
                    return id;
                }
            }
        }

        public static void AutoAdoptArticulations(int id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AutoAdoptArticulations", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@Id", id));
                   cmd.ExecuteReader();
                }
            }
        }

        //UpdateArticulationNotes
        public static void UpdateArticulationNotes(int articulation_id, string notes, string signature)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UpdateArticulationNotes", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@ArticulationID", articulation_id));
                    cmd.Parameters.Add(new SqlParameter("@Notes", notes));
                    cmd.Parameters.Add(new SqlParameter("@Signature", signature));
                    cmd.ExecuteReader();
                }
            }
        }

        public static void CreateArticulationLog(int articulation_id, int user_id, string info)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("CreateArticulationLog", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@Articulation_ID", articulation_id));
                    cmd.Parameters.Add(new SqlParameter("@UserID", user_id));
                    cmd.Parameters.Add(new SqlParameter("@info", info));
                    cmd.ExecuteReader();
                }
            }
        }

        public static void ApprovalArticulationWorkflow(int articulation_id, int direction, int user_id,  string info, int role_id, bool deniedMoveForward)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("NewApprovalArticulationWorkflow", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@ArticulationID", articulation_id));
                    cmd.Parameters.Add(new SqlParameter("@Direction", direction));
                    cmd.Parameters.Add(new SqlParameter("@UserId", user_id));
                    cmd.Parameters.Add(new SqlParameter("@Info", info));
                    cmd.Parameters.Add(new SqlParameter("@RoleID", role_id));
                    cmd.Parameters.Add(new SqlParameter("@Notify", false));
                    cmd.Parameters.Add(new SqlParameter("@DeniedMoveForward", deniedMoveForward));
                    cmd.ExecuteReader();
                }
            }
        }

        public static void UpdateArticulation(int Id, string Notes, string Justification, string AONotes, string recommendation, int UserID, bool HaveAdditionalCriteria, bool Implemented, int ExhibitID)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("sp_UpdateArticulation", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@Id", Id));
                    cmd.Parameters.Add(new SqlParameter("@notes", Notes));
                    cmd.Parameters.Add(new SqlParameter("@Justification", Justification));
                    cmd.Parameters.Add(new SqlParameter("@ArticulationOfficerNotes", AONotes));
                    cmd.Parameters.Add(new SqlParameter("@recommendation", recommendation));
                    cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                    cmd.Parameters.Add(new SqlParameter("@haveAdditionalCriteria", HaveAdditionalCriteria));
                    cmd.Parameters.Add(new SqlParameter("@Implemented", Implemented));
                    cmd.Parameters.Add(new SqlParameter("@ExhibitID", ExhibitID));
                    cmd.ExecuteReader();
                }
            }
        }

        public static int CheckArticulationExists(int outline_id, string ace_id, DateTime team_revd)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {

                connection.Open();
                using (SqlCommand cmd = new SqlCommand("CheckExistArticulation", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@outline_id", outline_id));
                    cmd.Parameters.Add(new SqlParameter("@AceID", ace_id));
                    cmd.Parameters.Add(new SqlParameter("@TeamRevd", team_revd));

                    // @ReturnVal could be any name
                    var returnParameter = cmd.Parameters.Add("@ReturnVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;

                    cmd.ExecuteNonQuery();
                    exists = ((int)returnParameter.Value);
                }
            }
            return exists;
        }

        public static int GetMostRecentArtExistsOtherColleges(int college_id, string subject, string course_number, int exhibit_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[fn_GetMostRecentArtExistsOtherColleges] ({0},'{1}','{2}',{3});", college_id, subject, course_number, exhibit_id);
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