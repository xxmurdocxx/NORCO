using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ITPI.JSTranscriptPDFReader.AzureComputerVision;

namespace ems_app.modules.veteran
{
    public partial class Veterans : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void rgVeterans_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.CommandName == "EditLead" || e.CommandName == "PrintVeteranLetter" || e.CommandName == "AddArticulation" || e.CommandName == "VeteranArticulations" || e.CommandName == "ViewMilitarCredits")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select a veteran");
                }
                else
                {
                    GridDataItem itemDetail = (GridDataItem)e.Item;
                    if (itemDetail.Selected)
                    {
                        if (e.CommandName == "EditLead")
                        {
                            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", String.Format("EditVeteranLead({0},{1});", itemDetail["LeadId"].Text, itemDetail["id"].Text), true); 
                        }
                        if (e.CommandName == "PrintVeteranLetter")
                        {
                            var url = String.Format("PrintVeteranLetter({0},{1});", itemDetail["LeadId"].Text, "");
                            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", url, true);
                        }
                        if (e.CommandName == "AddArticulation")
                        {
                            if (GlobalUtil.CheckOccupationCodeExists(itemDetail["OccupationCode"].Text))
                            {
                                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../military/Articulate.aspx?Occupation={0}", itemDetail["OccupationCode"].Text) + "');", true);
                            } else
                            {
                                DisplayMessage(false, "Occupation Code not found");
                            }
                            
                        }
                        if (e.CommandName == "VeteranArticulations")
                        {
                            if (GlobalUtil.CheckOccupationCodeExists(itemDetail["OccupationCode"].Text))
                            {
                                var url = String.Format("../popups/VeteranArticulations.aspx?Occupation={0}&CollegeID={1}&VeteranID={2}", itemDetail["OccupationCode"].Text, Session["CollegeID"].ToString(), itemDetail["id"].Text);
                                //ShowArticulations(url, 1100, 670);
                                //RadWindowManager11.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, 900, 600));
                                //ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/VeteranArticulations.aspx?Occupation={0}&CollegeID={1}&VeteranID={2}", itemDetail["OccupationCode"].Text, Session["CollegeID"].ToString(), itemDetail["id"].Text) + "');", true);
                                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "ShowArticulations('" + url + "',1100,700);", true);
                            }
                            else
                            {
                                DisplayMessage(false, "Occupation Code not found");
                            }

                        }
						if (e.CommandName == "ViewMilitarCredits")
                        {
                            Session["VeteranID"] = itemDetail["id"].Text;
                            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('../military/MilitaryCredits.aspx')", true);
                        } 
                    }
                }
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgVeterans_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {

        }

        protected void btnCompleteUpload_Click(object sender, EventArgs e)
        {
            //ImportProcess pdfreader;
            //byte[] fileData;
            //string fileName;
            try
            {
                if (AsyncUpload1.UploadedFiles.Count > 0)
                {
                    //foreach (UploadedFile uploadedFile in AsyncUpload1.UploadedFiles)
                    //{
                    //    fileData = new byte[uploadedFile.ContentLength];
                    //    fileName = uploadedFile.FileName;
                    //    using (Stream str = uploadedFile.InputStream)
                    //    {
                    //        pdfreader = new ITPI.JSTranscriptPDFReader.ImportProcess();
                    //        pdfreader.ProcessPDFFileStream(str, fileName, false);
                    //        if (string.IsNullOrEmpty(pdfreader.ErrorMessage))
                    //        {
                    //            List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs = pdfreader.SummaryCourseList;
                    //            str.Position = 0;

                    //            AddVeteran(pdfreader);
                    //            LoadACECourses(crs);

                    //            str.Read(fileData, 0, (int)uploadedFile.ContentLength);
                    //            AddVeteranDoc(fileName, "Initial Upload", fileData);
                    //        }
                    //        else
                    //        {
                    //            //ShowMessage(pdfreader.ErrorInvalidPDFFormat, pdfreader.ErrorNoSummarySection);
                    //        }
                    //    }
                    //}
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

        private void AddVeteran(ImportProcess pdfreader)
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
        }

        private void LoadACECourses(List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs)
        {
            DateTime teamrevd = System.DateTime.Now;
            string ids = "";
            string sql = "SELECT AceID, TeamRevd = MAX(TeamRevd) " +
                    "FROM AceExhibit acc " +
                    "WHERE AceID not in ( select AceID from VeteranACECourse where VeteranId = @VeteranID ) " +
                    "AND   AceID in ({0}) " +
                    "GROUP BY AceID ";
            DataSet ds = new DataSet();

            foreach (ITPI.JSTranscriptPDFReader.Entities.SummaryCourse c in crs)
            {
                ids += (ids.Length != 0 ? ", " : "") + string.Format("'{0}'", c.AceID);
                ;
                //string.Format("'{0} {1}'", c.AceID, c.CourseVersion.Replace("0", ""));
            }

            sql = string.Format(sql, ids);

            using (var adapter = new SqlDataAdapter(sql,
                ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                adapter.SelectCommand.Parameters.Add(new SqlParameter("@VeteranID", Convert.ToInt32(hfVeteranID.Value)));
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
    }
}