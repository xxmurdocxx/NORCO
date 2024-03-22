using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ems_app.Common.models
{
    public class SystemMaintenanceNotification
	{ 
		public int NotificationID { get; set; }

		public string College { get; set; }
    
		public DateTime StartDate { get; set; }

		public DateTime EndDate { get; set; }

		public int HoursPrior { get; set; }

		public int Impact { get; set; }

		public string ChangeDetails { get; set; }

		public int CreatedBy { get; set; }

		public DateTime CreatedDate { get; set; }

		public int ModifiedBy { get; set; }

		public DateTime ModifiedDate { get; set; }
	}
}