using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Text;

namespace ems_app.Common.infrastructure
{
    public static class Database
    {
        public static DataTable ExecuteStoredProcedure(string storedProcedureName, SqlParameter[] parameters)
        {
            return ExecuteStoredProcedure(storedProcedureName, parameters, 300);
        }

        public static DataTable ExecuteStoredProcedure(string storedProcedureName, SqlParameter[] parameters, int commandTimeoutSeconds)
        {
#if DEBUG
            Debug.WriteLine(string.Format("EXEC {0} {1}", storedProcedureName, GetParameterList(parameters)));
            var sw = new Stopwatch();
            sw.Start();
#endif
            ConvertNullToDbNull(parameters);
            DataTable dataTable = new DataTable();
            string connectionString = ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString;
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = storedProcedureName;
                    cmd.CommandTimeout = commandTimeoutSeconds;
                    if (parameters != null )
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dataTable);
                    }
                }
            }

#if DEBUG
            sw.Stop();
            Debug.WriteLine("Execution time: " + sw.ElapsedMilliseconds);
#endif
            return dataTable;
        }

        public static Object GetParameterValue(SqlParameter[] parameters, string parameterName)
        {
            var parameter = Array.Find(parameters, p => p.ParameterName == parameterName);
            if (parameter == null)
            {
                return null;
            }
            return parameter.Value;
        }

        public static void ConvertEmptyStringToDbNull(SqlParameter[] parameters)
        {
            if (parameters == null)
            {
                return;
            }
            foreach (SqlParameter p in parameters)
            {
                if (p.DbType == DbType.String && p.Value != null && p.Value.ToString() == "")
                {
                    p.Value = DBNull.Value;
                }
            }
        }

        private static void ConvertNullToDbNull(SqlParameter[] parameters)
        {
            if (parameters == null)
            {
                return;
            }
            foreach (SqlParameter p in parameters)
            {
                if (p.Value == null)
                {
                    p.Value = DBNull.Value;
                }
            }
        }

        private static string GetParameterList(SqlParameter[] parameters)
        {
            if (parameters == null)
            {
                return "";
            }

            var output = new StringBuilder();
            foreach (SqlParameter p in parameters)
            {
                if (p.Value == null)
                {
                    output.AppendFormat("{0} = NULL, ", p.ParameterName);
                }
                else
                {
                    output.AppendFormat("{0} = '{1}', ", p.ParameterName, p.Value);
                }
            }
            output.Remove(output.Length - 2, 2);
            return output.ToString();
        }
        
    }
}