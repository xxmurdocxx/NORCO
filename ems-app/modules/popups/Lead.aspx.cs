using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ITPI.JSTranscriptPDFReader.AzureComputerVision;

namespace ems_app.modules.popups
{
    public partial class Lead : System.Web.UI.Page
    {

        NORCODataContext norco_db = new NORCODataContext();
        int fileId;
        byte[] fileData;
        string fileName;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfVeteranID.Value = Request["VeteranID"];
            }
        }

        protected void sqlVeteranDocuments_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [VeteranDocuments] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
            }
            rgVeteranDocs.DataBind();
        }

        protected void sqlVeteranDocuments_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            fileId = (int)e.Command.Parameters["@InsertedID"].Value;
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [VeteranDocuments] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
            }
        }

        protected void rgVeteranDocs_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == RadGrid.UpdateCommandName || e.CommandName == RadGrid.PerformInsertCommandName)
            {
                GridEditableItem item = e.Item as GridEditableItem;

                if (!(item is GridEditFormInsertItem))

                {
                    fileId = (int)item.GetDataKeyValue("id");
                }
                //var asyncUpload = item["AttachmentColumn"].Controls[0] as RadAsyncUpload;
                //if (asyncUpload != null && asyncUpload.UploadedFiles.Count > 0)
                //{
                //    var uploadedFile = asyncUpload.UploadedFiles[0];
                //    fileData = new byte[uploadedFile.ContentLength];
                //    fileName = uploadedFile.FileName;
                //    using (Stream str = uploadedFile.InputStream)
                //    {
                //        //dt ************************************
                //        ITPI.JSTranscriptPDFReader.ImportProcess pdfreader = new ITPI.JSTranscriptPDFReader.ImportProcess();
                //        //pdfreader.ProcessPDFFileStream(str, fileName, false);
                //        List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs = pdfreader.SummaryCourseList;
                //        str.Position = 0;

                //        grdSummary.DataSource = crs;
                //        grdSummary.DataBind();

                //        LoadACECourses(crs);
                //        //dt  ************************************

                //        str.Read(fileData, 0, (int)uploadedFile.ContentLength);
                //    }
                //}

                var asyncUpload = item["AttachmentColumn"].Controls[0] as RadAsyncUpload;
                if (asyncUpload != null && asyncUpload.UploadedFiles.Count > 0)
                {
                    var uploadedFile = asyncUpload.UploadedFiles[0];
                    if (uploadedFile.FileName.Contains("/") || uploadedFile.FileName.Contains("?") || uploadedFile.FileName.Contains("*") || uploadedFile.FileName.Contains("<") || uploadedFile.FileName.Contains(">") || uploadedFile.FileName.Contains(":") || uploadedFile.FileName.Contains("|") || uploadedFile.FileName.Contains("\\") || uploadedFile.FileName.Contains("\""))
                    {
                        e.Canceled = true;
                        item.FindControl("CancelButton").Parent.Controls.Add(new LiteralControl("<br/><b style='color:red;'>File contains special characters.</b>"));
                    }
                    else
                    {
                        fileData = new byte[uploadedFile.ContentLength];
                        //fileName = uploadedFile.FileName;
                        fileName = uploadedFile.FileName.Replace(",", "_").Replace(";", "_");
                        using (Stream str = uploadedFile.InputStream)
                        {
                            //dt ************************************
                            ImportProcess pdfreader = new ImportProcess(GlobalUtil.ReadSetting("AzureCVEndpoint"), GlobalUtil.ReadSetting("AzureCVSubscriptionKey"));
                            ems_app.Utility.AsyncHelper.RunSync(() => pdfreader.Import(str));
                            //pdfreader.ProcessPDFFileStream(str, fileName, false);
                            List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs = pdfreader.SummaryCourseList;
                            //str.Position = 0;
                            if (string.IsNullOrEmpty(pdfreader.ErrorMessage))
                            {

                                crs = pdfreader.SummaryCourseList;
                            }

                                grdSummary.DataSource = crs;
                            grdSummary.DataBind();

                            LoadACECourses(crs);
                            //dt  ************************************

                            str.Read(fileData, 0, (int)uploadedFile.ContentLength);
                        }
                    }
                }
                else
                {
                    e.Canceled = true;
                    item.FindControl("CancelButton").Parent.Controls.Add(new LiteralControl("<br/><b style='color:red;'>No file uploaded. Action canceled.</b>"));
                }

            }
        }

        protected void rgVeteranDocs_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                ScriptManager.GetCurrent(Page).RegisterPostBackControl(item["AttachmentColumn"].Controls[0]);
            }
        }

        private void UpdateFileData(string command, int fileId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                using (SqlCommand comm = new SqlCommand(command, conn))
                {
                    if (fileData != null && fileData.Length > 0)
                    {
                        comm.Parameters.Add(new SqlParameter("id", fileId));
                        comm.Parameters.Add(new SqlParameter("BinaryData", fileData));
                        comm.Parameters.Add(new SqlParameter("FileName", fileName));
                        conn.Open();
                        comm.ExecuteNonQuery();
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

        protected void ToggleRowSelection(object sender, EventArgs e)
        {
            ((sender as CheckBox).NamingContainer as GridItem).Selected = (sender as CheckBox).Checked;
            bool checkHeader = true;
            foreach (GridDataItem dataItem in rgACECourseCatalog.MasterTableView.Items)
            {
                if (!(dataItem.FindControl("CheckBox1") as CheckBox).Checked)
                {
                    checkHeader = false;
                    break;
                }
            }
            GridHeaderItem headerItem = rgACECourseCatalog.MasterTableView.GetItems(GridItemType.Header)[0] as GridHeaderItem;
            (headerItem.FindControl("headerChkbox") as CheckBox).Checked = checkHeader;
        }

        protected void ToggleSelectedState(object sender, EventArgs e)
        {
            CheckBox headerCheckBox = (sender as CheckBox);
            foreach (GridDataItem dataItem in rgACECourseCatalog.MasterTableView.Items)
            {
                (dataItem.FindControl("CheckBox1") as CheckBox).Checked = headerCheckBox.Checked;
                dataItem.Selected = headerCheckBox.Checked;
            }
        }

        protected void rgACECourseCatalog_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            try
            {
                GridDataItem itemDetail = e.Item as GridDataItem;
                var ace_id = "";
                var coursenumber = "";
                var courseversion = "";
                DateTime teamrevd = new DateTime();
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Select an ACE course.");
                }
                else
                {
                    if (e.CommandName == "Add")
                    {
                        foreach (GridDataItem item in grid.Items)
                        {
                            if ((item.FindControl("CheckBox1") as CheckBox).Checked)
                            {
                                ace_id = item["AceID"].Text;
                                teamrevd = Convert.ToDateTime(item["TeamRevd"].Text);
                                norco_db.AddVeteranACECourse(ace_id, teamrevd, coursenumber,courseversion, Convert.ToInt32(Request.QueryString["VeteranID"]), Convert.ToInt32(Session["CollegeID"].ToString()));
                                rgACECourses.DataBind();
                                rgACECourseCatalog.DataBind();
                            }
                        }
                    }
                    if (e.CommandName == "ShowAceCourse")
                    {
                        var url = String.Format("../popups/ShowACECourseDetail.aspx?AceID={0}&TeamRevd={1}&Title={2}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Title"].Text);
                        RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, 900, 600));
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(false, ex.ToString());
            }
        }

        protected void rgVeteranOccupations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            try
            {
                GridDataItem itemDetail = e.Item as GridDataItem;
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Select an ACE course.");
                }
                else
                {
                    if (e.CommandName == "ShowAceOccupation")
                    {
                        var url = String.Format("../popups/ShowOccupation.aspx?AceID={0}&TeamRevd={1}&Occupation={2}&Title={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["OccupationCode"].Text, itemDetail["Title"].Text);
                        RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, 900, 600));
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(false, ex.ToString());
            }
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
                adapter.SelectCommand.Parameters.Add(new SqlParameter("@VeteranID", Convert.ToInt32(Request.QueryString["VeteranID"])));
                adapter.Fill(ds);
            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    norco_db.AddVeteranACECourse(dr["AceID"].ToString(), Convert.ToDateTime(dr["TeamRevd"].ToString()), dr["CourseNumber"].ToString(), dr["CourseVersion"].ToString(),
                            Convert.ToInt32(Request.QueryString["VeteranID"]),
                            Convert.ToInt32(Session["CollegeID"].ToString()));
                }
										
											  
            }
        }

    }
}