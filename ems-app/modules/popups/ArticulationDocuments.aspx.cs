using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class ArticulationDocuments : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ArticulationDocumentsViewer.UserID = Convert.ToInt32(Session["UserID"]);
                ArticulationDocumentsViewer.ArticulationID = Convert.ToInt32(Request.QueryString["id"]);
                ArticulationDocumentsViewer.ReadOnly = false;
                if (Request.QueryString["ReadOnly"] != null)
                {
                    if (Convert.ToBoolean(Request.QueryString["ReadOnly"]))
                    {
                        ArticulationDocumentsViewer.ReadOnly = true;
                    }
                }
            }
        }

    }
}