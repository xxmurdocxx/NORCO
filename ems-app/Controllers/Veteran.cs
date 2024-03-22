using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Telerik.Web.UI;

namespace ems_app.Controllers
{
    public class Veteran
    {
        public static int CheckVeteranDocumentExists(int veteran_id, string file_name, string file_description)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select [dbo].[CheckVeteranDocumentExists] ({veteran_id},'{file_name}','{file_description}');";
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