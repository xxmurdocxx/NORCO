using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.UserControls
{
    public partial class CollegeArticulationStats : System.Web.UI.UserControl
    {
        int collegeID = 0;
        public int CollegeID
        {
            get
            {
                if (ViewState["collegeID"] != null)
                { collegeID = Int32.Parse(ViewState["collegeID"].ToString()); };
                return collegeID;
            }
            set { ViewState["collegeID"] = value; }
        }

        public class Summary
        {
            public int OrderNumber { get; set; }
            public string RoleName { get; set; }
            public int CountNumber { get; set; }
            public string SummaryResults { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

                var summaryData = GetSummary(CollegeID);

                List<Summary> summaryResults = new List<Summary>();
                summaryResults = (from DataRow dr in summaryData.Rows
                               select new Summary()
                               {
                                   OrderNumber = Convert.ToInt32(dr["OrderNumber"]),
                                   RoleName = dr["RoleName"].ToString(),
                                   CountNumber = Convert.ToInt32(dr["CountNumber"]),
                                   SummaryResults = dr["SummaryResults"].ToString()
                               }).ToList();

                foreach (var item in summaryResults)
                {

                    HtmlButton btn = new HtmlButton();
                    btn.InnerText = string.Format("{0} {1}", item.CountNumber.ToString(), item.RoleName);
                    btn.Attributes["class"] = "tablinks";
                    btn.Attributes.Add("onmouseover", string.Format("openStage(event,'{0}');return false;",item.RoleName));

                    stageTabs.Controls.Add(btn);

                    HtmlGenericControl contentDiv = new HtmlGenericControl("DIV");
                    contentDiv.Attributes["class"] = "tabcontent";
                    contentDiv.InnerHtml = item.SummaryResults;
                    contentDiv.ID = item.RoleName;
                    contentDiv.ClientIDMode = ClientIDMode.Static;

                    if (item.OrderNumber != 1)
                    {
                        contentDiv.Attributes["style"] = "display:none;";
                    } else
                    {
                        btn.Attributes["class"] = "tablinks active";
                    }

                    this.Controls.Add(contentDiv);

                }

        }

        public DataTable GetSummary(int college_id)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetCollegeSummaryData", conn);
                cmd.Parameters.Add("@CollegeID", SqlDbType.Int).Value = college_id;
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }
            return myDataTable;
        }

    }
}