using System;
using System.Data;
using System.Data.SqlClient;
using ems_app.Common.infrastructure;

namespace ems_app.Common.models
{
    public class GenericLookup
    {
        public static DataTable GetList(string storedProcedure)
        {
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, null);
            return dtResult;
        }

        public static DataTable GetList(string storedProcedure, string parameter1Name, string parameter1Value)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter(parameter1Name, parameter1Value)
            };
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, parameters);
            return dtResult;
        }

        public static DataTable GetListWithDefault(string storedProcedure, string parameter1Name, string parameter1Value)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter(parameter1Name, parameter1Value)
            };
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, parameters);

            var dr = dtResult.NewRow();
            dr[0] = 0;
            dr[1] = "";
            dr[2] = "--";

            dtResult.Rows.InsertAt(dr, 0);

            return dtResult;
        }

        public static DataTable GetListWithDefault(string storedProcedure, string parameter1Name, string parameter1Value, string parameter2Name, string parameter2Value)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter(parameter1Name, parameter1Value),
                new SqlParameter(parameter2Name, parameter2Value)
            };
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, parameters);

            var dr = dtResult.NewRow();
            dr[0] = 0;
            dr[1] = "";
            dr[2] = "--";

            dtResult.Rows.InsertAt(dr, 0);

            return dtResult;
        }

        public static DataTable GetListWithDefault(string storedProcedure, string parameter1Name, string parameter1Value, string parameter2Name, string parameter2Value, string parameter3Name, string parameter3Value)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter(parameter1Name, parameter1Value),
                new SqlParameter(parameter2Name, parameter2Value),
                new SqlParameter(parameter3Name, parameter3Value)
            };
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, parameters);

            var dr = dtResult.NewRow();
            dr[0] = 0;
            dr[1] = "";
            dr[2] = "--";

            dtResult.Rows.InsertAt(dr, 0);

            return dtResult;
        }

        public static DataTable GetList(string storedProcedure, string parameter1Name, string parameter1Value, string parameter2Name, string parameter2Value)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter(parameter1Name, parameter1Value),
                new SqlParameter(parameter2Name, parameter2Value)
            };
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, parameters);
            return dtResult;
        }

        public static DataTable GetList(string storedProcedure, string parameter1Name, string parameter1Value, string parameter2Name, string parameter2Value, string parameter3Name, string parameter3Value)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter(parameter1Name, parameter1Value),
                new SqlParameter(parameter2Name, parameter2Value),
                new SqlParameter(parameter3Name, parameter3Value)
            };
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, parameters);
            return dtResult;
        }

        public static DataTable GetList(string storedProcedure, string parameter1Name, string parameter1Value, string parameter2Name, string parameter2Value, string parameter3Name, string parameter3Value, string parameter4Name, string parameter4Value)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter(parameter1Name, parameter1Value),
                new SqlParameter(parameter2Name, parameter2Value),
                new SqlParameter(parameter3Name, parameter3Value),
                new SqlParameter(parameter4Name, parameter4Value)
            };
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, parameters);
            return dtResult;
        }

        public static DataTable GetList(string storedProcedure, string parameter1Name, string parameter1Value, string parameter2Name, string parameter2Value, string parameter3Name, string parameter3Value, string parameter4Name, string parameter4Value, string parameter5Name, string parameter5Value)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter(parameter1Name, parameter1Value),
                new SqlParameter(parameter2Name, parameter2Value),
                new SqlParameter(parameter3Name, parameter3Value),
                new SqlParameter(parameter4Name, parameter4Value),
                new SqlParameter(parameter5Name, parameter5Value)
            };
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, parameters);
            return dtResult;
        }

        public static DataTable GetList(string storedProcedure, string parameter1Name, string parameter1Value, string parameter2Name, string parameter2Value, string parameter3Name, string parameter3Value, string parameter4Name, string parameter4Value, string parameter5Name, string parameter5Value, string parameter6Name, string parameter6Value)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter(parameter1Name, parameter1Value),
                new SqlParameter(parameter2Name, parameter2Value),
                new SqlParameter(parameter3Name, parameter3Value),
                new SqlParameter(parameter4Name, parameter4Value),
                new SqlParameter(parameter5Name, parameter5Value),
                new SqlParameter(parameter6Name, parameter6Value)
            };
            var dtResult = Database.ExecuteStoredProcedure(storedProcedure, parameters);
            return dtResult;
        }

        public static DataTable GetNumericList(decimal minValue, decimal maxValue, decimal step, string format)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("MinValue", minValue),
                new SqlParameter("MaxValue", maxValue),
                new SqlParameter("Step", step),
                new SqlParameter("Format", format)
            };
            var dtResult = Database.ExecuteStoredProcedure("spGetNumericList", parameters);
            return dtResult;
        }

        public DataTable GetCurrentSemester(string college)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("College", college)
            };
            var dtResult = Database.ExecuteStoredProcedure("GetCurrentSemester", parameters);
            return dtResult;
        }

        public DataTable GetWorkflowStatusNotifications(int userID, int workflowStatusID)
        {

            if (userID == 0)
            {
                return null;
            }

            var Parameters = new SqlParameter[]
            {
                new SqlParameter("@UserID", userID),
                new SqlParameter("@WorkflowStatusID", workflowStatusID)
            };
            var dtResult = Database.ExecuteStoredProcedure("spWorkflowStatus_GetWorkflowStatusNotifications", Parameters);
            return dtResult;
        }

        public int? GetServiceID(string code)
        {
            var Parameters = new SqlParameter[]
            {
                new SqlParameter("@Code", code),
            };

            var dtResult = Database.ExecuteStoredProcedure("spLookupService_GetServiceID", Parameters);
            if (dtResult.Rows.Count > 0)
                return Convert.ToInt32(dtResult?.Rows?[0]["ServiceID"].ToString());
            else
                return null;
        }

		public int? GetServiceIDByDescription(string description)
        {
            var Parameters = new SqlParameter[]
            {
                new SqlParameter("@Description", description),
            };

            var dtResult = Database.ExecuteStoredProcedure("spLookupService_GetServiceIDByDescription", Parameters);
            if (dtResult.Rows.Count > 0)
                return Convert.ToInt32(dtResult?.Rows?[0]["ServiceID"].ToString());
            else
                return null;
        } 
    }
}