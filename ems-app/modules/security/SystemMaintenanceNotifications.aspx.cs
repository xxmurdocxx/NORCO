using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ems_app.Common.models;
using System.Drawing;

namespace ems_app.modules.security
{
    public partial class SystemMaintenanceNotifications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hidSysMaintenanceNotificationsId.Value = String.Empty;

                
                ddlHoursPriorList.DataBind();
            }
        }

        // Add new notification
        protected void lblNewNotification_Click(object sender, EventArgs e)
        {
            rdpStartDate.Clear();
            rdpEndDate.Clear();
            ddlHoursPriorList.SelectedIndex = -1;
            rblImpact.SelectedIndex = 0;
            tbChangeDetails.Text = String.Empty;
            pnlPopupNotification.Visible = true;
            pnlNotificationDetail.Visible = false;
            pnlAddNewNotification.Visible = true;
            pnlFooter.Visible = true;

        }

        protected void rgNotifications_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                hidSysMaintenanceNotificationsId.Value = string.Empty;

                GridDataItem item = (GridDataItem)e.Item;
                var key = (Int32)item.GetDataKeyValue("SystemMaintenanceID");
                if (key <= 0)
                {
                    return;
                }
                var systemMaintenance = new SystemMaintenanceNotificationsDataAccess();

                switch (e.CommandName)
                {
                    case "EditNotification":
                        pnlAddNewNotification.Visible = false;
                        pnlPopupNotification.Visible = true;
                        pnlNotificationDetail.Visible = true;
                        pnlFooter.Visible = true;

                        var systemMaintenanceNotificationDataAccess = new SystemMaintenanceNotificationsDataAccess();
                        var dsSystemMaintenance = systemMaintenanceNotificationDataAccess.GetNotificationById(key);
                        hidSysMaintenanceNotificationsId.Value = dsSystemMaintenance?.Rows?[0]["SystemMaintenanceID"].ToString();
                        
                        // check if these can be null
                        rdpStartDateEdit.SelectedDate = (DateTime)dsSystemMaintenance?.Rows?[0]["MaintenanceStartDate"];
                        rdpEndDateEdit.SelectedDate = (DateTime)dsSystemMaintenance?.Rows?[0]["MaintenanceEndDate"];
                        ddlHourPriorEdit.SelectedValue = dsSystemMaintenance?.Rows?[0]["SystemMaintenanceNotificationHoursID_Prior"].ToString();
                        rblImpactEdit.SelectedValue = dsSystemMaintenance?.Rows?[0]["SystemMaintenanceMessageID"].ToString();

                        // Catch nulls and set labels
                        if (!string.IsNullOrEmpty(dsSystemMaintenance?.Rows[0]["ChangeDetails"]?.ToString()))
                        {
                            tbChangeDetailEdit.Text = dsSystemMaintenance?.Rows?[0]["ChangeDetails"].ToString();
                        }
                        else
                        {
                            tbChangeDetailEdit.Text = "";
                        }

                        if (!string.IsNullOrEmpty(dsSystemMaintenance?.Rows[0]["CreatedBy"]?.ToString()))
                        {
                            lblCreatedBy.Text = dsSystemMaintenance.Rows[0]["CreatedBy"]?.ToString() + "  " + dsSystemMaintenance.Rows[0]["CreatedDate"]?.ToString();
                        }
                        else
                        {
                            lblCreatedBy.Text = "N/A";
                        }

                        if (!string.IsNullOrEmpty(dsSystemMaintenance?.Rows[0]["ModifiedBy"]?.ToString()))
                        {
                            lblModifiedBy.Text = dsSystemMaintenance.Rows[0]["ModifiedBy"]?.ToString() + "  " + dsSystemMaintenance.Rows[0]["ModifiedDate"]?.ToString();
                        }
                        else
                        {
                            lblModifiedBy.Text = "N/A";
                        }

                        break;
                    case "DisableNotification":
                        systemMaintenance.DisableNotification(key);
                        hidSysMaintenanceNotificationsId.Value = key.ToString();
                        rgNotifications.Rebind();
                        break;

                }
            }
        }

        protected void btnSaveNewNotification_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                var college = Session["CollegeAbbreviation"]?.ToString();
                var userResult = Int32.TryParse(Session["UserID"]?.ToString(), out int userId);
                var startDate = (DateTime)rdpStartDate.SelectedDate;
                var endDate = (DateTime)rdpEndDate.SelectedDate;
                var hoursPriorResult = Int32.TryParse(ddlHoursPriorList.SelectedValue, out int hoursPriorId);
                var impactResult = Int32.TryParse(rblImpact.SelectedValue, out int impactId);
                var changeDetail = tbChangeDetails.Text.ToString();

                var systemMaintenanceNotification = new SystemMaintenanceNotificationsDataAccess();
                var sysMaintenance = new SystemMaintenanceNotification()
                {
                    College = college,
                    StartDate = startDate,
                    EndDate = endDate,
                    HoursPrior = hoursPriorId,
                    Impact = impactId,
                    ChangeDetails = changeDetail,
                    CreatedBy = userId
                };
                var result = systemMaintenanceNotification.SaveNotification(sysMaintenance);

                if (result?.Rows?.Count > 0)
                {
                    var sysMaintenanceNotificationResult = int.TryParse(result.Rows[0]["SystemMaintenanceId"].ToString(), out int sysMaintenanceNotificationId);
                    if (sysMaintenanceNotificationResult)
                        hidSysMaintenanceNotificationsId.Value = sysMaintenanceNotificationId.ToString();
                }

                DisplayReset();
            }
        }

        protected void btnSaveNotification_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                var updSysNotification = new SystemMaintenanceNotificationsDataAccess();
                var userResult = Int32.TryParse(Session["UserID"]?.ToString(), out int userId);
                var notificationIdResult = int.TryParse(hidSysMaintenanceNotificationsId.Value, out int notificationId);
                var hourPriorResult = int.TryParse(ddlHourPriorEdit.SelectedValue, out int hourPriorId);
                var impactResult = int.TryParse(rblImpactEdit.SelectedValue, out int impactId);

                if (notificationIdResult)
                {
                    var sysNotification = new SystemMaintenanceNotification()
                    {
                        NotificationID = notificationId,
                        StartDate = (DateTime)rdpStartDateEdit.SelectedDate,
                        EndDate = (DateTime)rdpEndDateEdit.SelectedDate,
                        HoursPrior = hourPriorId,
                        Impact = impactId,
                        ChangeDetails = tbChangeDetailEdit.Text,
                        ModifiedBy = userId
                    };

                    updSysNotification.UpdateNotification(sysNotification);
                    DisplayReset();
                }
            }
        }

        protected void btnCancelNotification_Click(object sender, EventArgs e)
        {
            DisplayReset();
        }

        private void DisplayReset()
        {
            pnlPopupNotification.Visible = false;
            pnlAddNewNotification.Visible = false;
            pnlNotificationDetail.Visible = false;
            pnlFooter.Visible = false;

            rgNotifications.DataBind();
        }

        protected void rgNotifications_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                var item = (GridDataItem)e.Item;
                var isNotificationEnabled = item.GetDataKeyValue("IsNotificationEnabled").ToString();
                
                if (isNotificationEnabled.Equals("Enable", StringComparison.CurrentCultureIgnoreCase))
                {
                    item.BackColor = Color.FromArgb(232, 238, 244);
                    item.ForeColor = Color.LightGray;
                }
                else
                {
                    
                }
            }
        }

        protected void lnkXPopupContainer_Click(object sender, EventArgs e)
        {
            pnlPopupNotification.Visible = false;
            pnlAddNewNotification.Visible = false;
            pnlNotificationDetail.Visible = false;
            pnlFooter.Visible = false;
        }

        protected void cvNotificationNew_ServerValidate(object source, ServerValidateEventArgs args)
        {
            cvNotificationNew.ErrorMessage = string.Empty;
            if (rdpEndDate.SelectedDate < rdpStartDate.SelectedDate)
            {
                cvNotificationNew.ErrorMessage = "End date must be set after Start date";
                args.IsValid = false;
            }
        }

        protected void cvNotificationEdit_ServerValidate(object source, ServerValidateEventArgs args)
        {
            cvNotificationEdit.ErrorMessage = string.Empty;
            if (rdpEndDateEdit.SelectedDate < rdpStartDateEdit.SelectedDate)
            {
                cvNotificationEdit.ErrorMessage = "End date must be set after Start date";
                args.IsValid = false;
            }
        }
    }
}