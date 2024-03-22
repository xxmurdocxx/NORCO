using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ems_app.Controllers
{
    public class Course
    {
        public static int CheckCourseIsElective(int outline_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckCourseIsElective] ({0});", outline_id);
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }
        public static int GetCourseIDByUnits(string units, int college_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select isnull( (select top 1 c.outline_id from Course_IssuedForm c join tblSubjects s on c.subject_id = s.subject_id join tblLookupUnits u on c.unit_id = u.unit_id where s.IsElective = 1 and cast(u.unit as decimal) = cast({units} as decimal)  and c.college_id = {college_id} and s.subject like 'CPL%'),0);";
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