using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ems_app.modules.dashboard
{
    public partial class SuperUser : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                lblUserName.Text = Session["FirstName"] + " " + Session["LastName"];

                // reset user session variables back to configured college - we use LastOrDefault because on the login screen it loops through all users with the same username so it would always be set to the last record returned.
                var userData = norco_db.GetUserDataByUserName(Session["UserName"].ToString(), Convert.ToInt32(GlobalUtil.ReadSetting("AppID"))).LastOrDefault();
                Session["RoleID"] = userData.RoleID;
                Session["CollegeID"] = userData.CollegeID;
                Session["College"] = userData.College;
                Session["CollegeLogo"] = userData.CollegeLogo;

            }
        }

        protected void lbtnGoToCollege_Click(object sender, EventArgs e)
        {
            var lbtn = sender as LinkButton;
            var item = lbtn.NamingContainer as GridDataItem;
            int tmpRoleID = 0;

            tmpRoleID = GetRoleByCollege((int)item.GetDataKeyValue("CollegeID"), (string)Session["RoleName"]);
            if(tmpRoleID > 0)
            {
                Session["RoleID"] = tmpRoleID;
                Session["CollegeID"] = (int)item.GetDataKeyValue("CollegeID");
                Session["College"] = item.GetDataKeyValue("College").ToString();
                Session["CollegeLogo"] = item.GetDataKeyValue("CollegeLogo").ToString();
                Response.Redirect("~/modules/dashboard/Default.aspx", false);
            }
            else
            {
                lblError.Text = "Your role does not exist in selected college. Unable to go to college.";
                lblError.Visible = true;
            }
            
        }

        protected void rgCollegeList_PreRender(object sender, EventArgs e)
        {
            rgCollegeList.HierarchySettings.ExpandTooltip = "View Contacts";
        }

        public int GetRoleByCollege(int collegeID, string roleName)
        {
            int retRoleID = 0;
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetRoleByCollege", conn);
                cmd.Parameters.Add("@CollegeID", SqlDbType.Int).Value = collegeID;
                cmd.Parameters.Add("@RoleName", SqlDbType.VarChar).Value = roleName;
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(myDataTable);
                if(myDataTable.Rows.Count > 0)
                {
                    DataRow row = myDataTable.Rows[0];
                    retRoleID = (int)row["RoleID"];                   
                }  
            }
            finally
            {
                conn.Close();
            }
            return retRoleID;
        }

    }
}