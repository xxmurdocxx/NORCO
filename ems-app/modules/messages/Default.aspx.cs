using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ems_app.Model;

namespace ems_app.modules.messages
{
    public partial class Default : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        Dictionary<int, int> articulations = new Dictionary<int, int>();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MyMessages.UserName = Session["UserName"].ToString();
                MyMessages.CollegeID = Convert.ToInt32(Session["CollegeID"]);
                MyMessages.UserID = Convert.ToInt32(Session["UserID"]);
                MyMessages.UserStageID = Convert.ToInt32(Session["UserStageID"]);
                MyMessages.FirstStage = (int)norco_db.GetMinimumStageId(Convert.ToInt32(Session["CollegeID"].ToString()));
                MyMessages.LastStage = (int)norco_db.GetMaximumStageId(Convert.ToInt32(Session["CollegeID"].ToString()));
                MyMessages.IsFaculty = Convert.ToBoolean(Session["reviewArticulations"].ToString());
            }
        }

   
    }
}