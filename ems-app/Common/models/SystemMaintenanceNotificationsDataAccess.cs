using ems_app.Common.infrastructure;
using System.Data;
using System.Data.SqlClient;

namespace ems_app.Common.models
{
    public class SystemMaintenanceNotificationsDataAccess
    {
        public SqlParameter[] Parameters { get; private set; }
        public DataTable GetNotificationById(int notificationId)
        {
            if (notificationId == 0)
            {
                return null;
            }
            Parameters = new SqlParameter[]
            {
                new SqlParameter("@NotificationID", notificationId)
            };
            var dtResult = Database.ExecuteStoredProcedure("spSystemMaintenance_GetNotificationById", Parameters);
            return dtResult;
        }

        public void DisableNotification(int notificationId)
        {
            Parameters = new SqlParameter[]
            {
                new SqlParameter("@NotificationID", notificationId)
            };
            Database.ExecuteStoredProcedure("spSystemMaintenance_EnableDisable", Parameters);
        }

        public DataTable SaveNotification(SystemMaintenanceNotification sysMaintenance)
        {
            Parameters = new SqlParameter[]
            {
                new SqlParameter("@College", sysMaintenance.College),
                new SqlParameter("@StartDate", sysMaintenance.StartDate),
                new SqlParameter("@EndDate", sysMaintenance.EndDate),
                new SqlParameter("@HoursPrior", sysMaintenance.HoursPrior),
                new SqlParameter("@Impact", sysMaintenance.Impact),
                new SqlParameter("@ChangeDetails", sysMaintenance.ChangeDetails),
                new SqlParameter("@CreatedBy", sysMaintenance.CreatedBy)
            };

            return Database.ExecuteStoredProcedure("spSystemMaintenance_Insert", Parameters);
        }

        public void UpdateNotification(SystemMaintenanceNotification sysMaintenance)
        {
            if (sysMaintenance.NotificationID == 0)
            {
                return;
            }

            Parameters = new SqlParameter[]
            {
                new SqlParameter("@NotificationID", sysMaintenance.NotificationID),
                new SqlParameter("@StartDate", sysMaintenance.StartDate),
                new SqlParameter("@EndDate", sysMaintenance.EndDate),
                new SqlParameter("@HourPrior", sysMaintenance.HoursPrior),
                new SqlParameter("@Impact", sysMaintenance.Impact),
                new SqlParameter("@ChangeDetails", sysMaintenance.ChangeDetails),
                new SqlParameter("@ModifiedBy", sysMaintenance.ModifiedBy)
            };

            Database.ExecuteStoredProcedure("spSystemMaintenance_UpdateNotification", Parameters);
        }


    }
}