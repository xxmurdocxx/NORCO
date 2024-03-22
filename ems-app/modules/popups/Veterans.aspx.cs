using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ITPI.JSTranscriptPDFReader.AzureComputerVision;

namespace ems_app.modules.popups
{
    public partial class Veterans : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext(); 

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request["CampaignID"] != null)
                {
                    hfCampaignID.Value = Request["CampaignID"].ToString();
                    popupHeader.InnerHtml = string.Format("Campaign : {0}", Request["CampaignDescription"].ToString());

                    lblUploadDisclosure.Text = GetTemplate();
                }
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgVeteran_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            var lead_id = 0;
            if (e.CommandName == "EditVeteran")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select a Veteran");
                }
                else
                {
                    foreach (GridDataItem itemDetail in grid.Items)
                    {
                        if (itemDetail.Selected)
                        {
                            //RadWindowManager111.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Lead.aspx?LeadId={0}&VeteranId={1}", itemDetail["LeadId"].Text, itemDetail["id"].Text), true, true, false, 1300, 650));
                            lead_id = (int)norco_db.GetLeadIDByCampaign(Convert.ToInt32(itemDetail["id"].Text), Convert.ToInt32(hfCampaignID.Value));
                            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/Lead.aspx?LeadId={0}&VeteranId={1}", lead_id, itemDetail["id"].Text) + "');", true);
                        }
                    }
                }
            }
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            rgVeteran.DataBind();
        }

        protected void btnCompleteUpload_Click(object sender, EventArgs e)
        {
            //ITPI.JSTranscriptPDFReader.AzureComputerVision.ImportProcess pdfreader;
            byte[] fileData;
            string fileName;
            int veteranid = 0;
            try
            {
                if (AsyncUpload1.UploadedFiles.Count > 0)
                {
                    foreach (UploadedFile uploadedFile in AsyncUpload1.UploadedFiles)
                    {
                        fileData = new byte[uploadedFile.ContentLength];
                        fileName = uploadedFile.FileName;
                        using (Stream str = uploadedFile.InputStream)
                        {
                            //pdfreader = new ITPI.JSTranscriptPDFReader.AzureComputerVision.ImportProcess();
                            //pdfreader.ProcessPDFFileStream(str, fileName, false);
                            ImportProcess pdfreader = new ImportProcess(GlobalUtil.ReadSetting("AzureCVEndpoint"), GlobalUtil.ReadSetting("AzureCVSubscriptionKey"));
                            ems_app.Utility.AsyncHelper.RunSync(() => pdfreader.Import(str));
                            //pdfreader.ProcessPDFFileStream(str, fileName, false);
                            List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs = pdfreader.SummaryCourseList;
                            //str.Position = 0;
                            if (string.IsNullOrEmpty(pdfreader.ErrorMessage))
                            {

                                crs = pdfreader.SummaryCourseList;
                                hfVeteranID.Value = AddVeteran(pdfreader).ToString();
                            //}
                            //if (string.IsNullOrEmpty(pdfreader.ErrorMessage))
                            //{
                            //    List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs = pdfreader.SummaryCourseList;
                            //    str.Position = 0;

                            //   hfVeteranID.Value = AddVeteran(pdfreader).ToString();

                                LoadACECourses(crs);
                                
                                str.Read(fileData, 0, (int)uploadedFile.ContentLength);
                                AddVeteranDoc(fileName, "Initial Upload", fileData);
                            }
                            else
                            {
                            //    ShowMessage(pdfreader.ErrorInvalidPDFFormat, pdfreader.ErrorNoSummarySection);
                           // ShowMessage("")
                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message);
            }
        }

        private void ShowMessage(List<string> errInvalidFormat, List<string> errorNoSummary)
        {
            if (errInvalidFormat.Count != 0)
            {
                DisplayMessage(true, "Not loaded, invalid PDF Format: " + String.Join(",", errInvalidFormat.Select(s => "'" + s + "'")));
            }

            if (errorNoSummary.Count != 0)
            {
                DisplayMessage(true, "Not loaded, PDF has no Summary Section: " + String.Join(",", errorNoSummary.Select(s => "'" + s + "'")));
            }
        }

        private int AddVeteran(ImportProcess pdfreader)
        {
            int id = 0;

            id = GetVeteranId(pdfreader.CurrentVeteran.LastName, (DateTime)pdfreader.CurrentVeteran.BirthDate);

            if (id > 0)
            {
                hfVeteranID.Value = id.ToString(); 
                sqlVeteran2.UpdateParameters["id"].DefaultValue = hfVeteranID.Value;
                sqlVeteran2.UpdateParameters["CampaignID"].DefaultValue = hfCampaignID.Value;

                sqlVeteran2.Update();
            } 
            else
            {
                sqlVeteran.InsertParameters["CampaignID"].DefaultValue = hfCampaignID.Value;
                sqlVeteran.InsertParameters["FirstName"].DefaultValue = pdfreader.CurrentVeteran.FirstName;
                sqlVeteran.InsertParameters["LastName"].DefaultValue = pdfreader.CurrentVeteran.LastName;
                sqlVeteran.InsertParameters["Rank"].DefaultValue = pdfreader.CurrentVeteran.Rank;
                sqlVeteran.InsertParameters["BirthDate"].DefaultValue = ((DateTime)pdfreader.CurrentVeteran.BirthDate).ToShortDateString();
                sqlVeteran.InsertParameters["CollegeID"].DefaultValue = Session["CollegeID"].ToString();

                int result = sqlVeteran.Insert(); 

            }
            return id;
        }

        private void LoadACECourses(List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs)
        {
            DateTime teamrevd = System.DateTime.Now;
            string ids = "";
            //string sql = "SELECT AceID, TeamRevd = MAX(TeamRevd) " +
            //        "FROM AceExhibit acc " +
            //        "WHERE AceID not in ( select AceID from VeteranACECourse where VeteranId = @VeteranID ) " +
            //        "AND   AceID in ({0}) " +
            //        "GROUP BY AceID ";

            DataSet ds = new DataSet();
            string aceFilter = "  (AE.AceID ='{0}' AND '{1}' BETWEEN ae.StartDate and ae.EndDate) ";
            string aceWhereClause = "";

            string sql = "SELECT AceID = IDs.value,  ae.StartDate, ae.EndDate, " +
                 " TeamRevd = CASE WHEN ae.TeamRevd IS NULL THEN AEMAX.TeamRevd ELSE ae.TeamRevd END, " +
                 " UsingMaxTeamRevd = CASE WHEN ae.TeamRevd IS NULL THEN 1 ELSE 0 END " +
                 " FROM   STRING_split('{0}', ',') IDs " +
                 " LEFT JOIN AceExhibit AE ON IDs.value = AE.AceID AND ( {1} ) " +
                 " LEFT JOIN " +
                 "  (SELECT AceID, TeamRevd = MAX(TeamRevd) FROM AceExhibit GROUP BY AceID) AEMAX  ON IDs.value = AEMAx.AceID " +
                 " WHERE IDs.value not in (select AceID from VeteranACECourse where VeteranId = @VeteranID ) ";


            foreach (ITPI.JSTranscriptPDFReader.Entities.SummaryCourse c in crs)
            {
                ids += (ids.Length != 0 ? "," : "") + string.Format("{0}", c.AceID);

                aceWhereClause += aceWhereClause.Length > 0 ? " OR " : "";
                aceWhereClause += string.Format(aceFilter, c.AceID, c.CourseDate, c.CourseNumber, c.CourseVersion);
            }

            sql = string.Format(sql, ids, aceWhereClause);


            using (var adapter = new SqlDataAdapter(sql,
                ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                adapter.SelectCommand.Parameters.Add(new SqlParameter("@VeteranID", hfVeteranID.Value));
                adapter.Fill(ds);
            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    norco_db.AddVeteranACECourse(dr["AceID"].ToString(), Convert.ToDateTime(dr["TeamRevd"].ToString()), dr["CourseNumber"].ToString(), dr["CourseVersion"].ToString(),
                            Convert.ToInt32(hfVeteranID.Value),
                            Convert.ToInt32(Session["CollegeID"].ToString()));
                }
            }
        }

        private int GetVeteranId(string lastName, DateTime birthDate)
        {
            int id = 0;
            string queryString = "SELECT id FROM Veteran " +
              " WHERE LastName = @LastName" +
              " AND BirthDate = @BirthDate ";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(queryString, conn);
                conn.Open();
                cmd.Parameters.Add(new SqlParameter("@LastName", lastName));
                cmd.Parameters.Add(new SqlParameter("@BirthDate", birthDate));

                var i = cmd.ExecuteScalar();
                if (i != null)
                    id = (Int32)i;
            }

            return id;
        }

        private void AddVeteranDoc(string fileName, string fileDescription, byte[] fileData)
        {
            if (!VeteranDocExists(Convert.ToInt32(hfVeteranID.Value), fileName))
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO VeteranDocuments" +
                    "([FileName], [FileDescription], [BinaryData], [VeteranID], [user_id]) " +
                    "VALUES(@FileName, @FileDescription, @BinaryData, @VeteranID, @user_id) ", conn);

                    conn.Open();

                    cmd.Parameters.Add("@FileName", SqlDbType.VarChar, 50).Value = fileName;
                    cmd.Parameters.Add("@FileDescription", SqlDbType.VarChar, 50).Value = fileName;
                    cmd.Parameters.AddWithValue("BinaryData", fileData);
                    cmd.Parameters.Add("@VeteranID", SqlDbType.Int).Value = hfVeteranID.Value;
                    cmd.Parameters.Add("@user_id", SqlDbType.Int).Value = Session["UserID"];
                    int count = cmd.ExecuteNonQuery();
                }
            }
        }

        private bool VeteranDocExists(int veteranID, string fileName)
        {
            bool exists = false;
            string queryString = "SELECT count(*) FROM VeteranDocuments" +
              " WHERE VeteranID = @VeteranID " +
              " AND FileName = @FileName";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(queryString, conn);
                conn.Open();

                cmd.Parameters.Add(new SqlParameter("@VeteranID", veteranID));
                cmd.Parameters.Add(new SqlParameter("@FileName", fileName));

                exists = (int)cmd.ExecuteScalar() > 0;
            }

            return exists;
        }
        private string GetTemplate()
        {
            string queryString = "SELECT TemplateText FROM Templates WHERE Description = @Description AND CollegeID = @CollegeID ";
            string result = "Template Not Found";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(queryString, conn);
                conn.Open();

                cmd.Parameters.Add(new SqlParameter("@CollegeID", Session["CollegeID"].ToString()));
                cmd.Parameters.Add(new SqlParameter("@Description", "Transcript Disclosure"));
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    result = reader[0].ToString();
                }
            }

            return result; 
        }

        protected void sqlVeteran_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        { 
            hfVeteranID.Value =  e.Command.Parameters["@NewID"].Value.ToString(); 
        }
    }
}