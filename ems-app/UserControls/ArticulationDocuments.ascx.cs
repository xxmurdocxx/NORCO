using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.UserControls
{
    public partial class ArticulationDocuments : System.Web.UI.UserControl
    {
        NORCODataContext norco_db = new NORCODataContext();
        int fileId;
        byte[] fileData;
        string fileName;

        private int articulation_id = 0;
        private int user_id = 0;
        private bool read_only = false;

        public int ArticulationID
        {
            get { return articulation_id; }
            set { articulation_id = value; }
        }
        public int UserID
        {
            get { return user_id; }
            set { user_id = value; }
        }
        public bool ReadOnly
        {
            get { return read_only; }
            set { read_only = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfArticulationID.Value = ArticulationID.ToString();
                hfUserID.Value = UserID.ToString();
                rgArticulationDocs.DataBind();
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

        protected void sqlDocuments_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            fileId = (int)e.Command.Parameters["@InsertedID"].Value;
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [ArticulationDocuments] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
                UploadCollegeDocuments(fileId);
                Response.Redirect(Request.RawUrl);
            }
        }

        private void UploadCollegeDocuments(int documentID)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("CloneArticulationDocuments", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DocumentID", documentID);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void sqlDocuments_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [ArticulationDocuments] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
            }
            rgArticulationDocs.DataBind();
        }

        protected void rgArticulationDocs_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "Download")
            {
                GridDataItem viewItem = e.Item as GridDataItem;
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", $"window.open('/modules/popups/ConfirmDownload.aspx?ID={viewItem["id"].Text}&IsArticulation=true');", true);
            }
            if (e.CommandName == "Delete")
            {
                GridDataItem viewItem = e.Item as GridDataItem;
                DeleteDocument(Convert.ToInt32(viewItem["id"].Text), Convert.ToInt32(hfUserID.Value) );
                rgArticulationDocs.DataBind();
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "RefreshPage", "window.location.reload();", true);
                Response.Redirect(Request.RawUrl);
            }
            if (e.CommandName == RadGrid.UpdateCommandName || e.CommandName == RadGrid.PerformInsertCommandName)
            {
                GridEditableItem item = e.Item as GridEditableItem;

                if (!(item is GridEditFormInsertItem))
                {
                    fileId = (int)item.GetDataKeyValue("id");
                }

                var asyncUpload = item["AttachmentColumn"].Controls[0] as RadAsyncUpload;
                if (asyncUpload != null && asyncUpload.UploadedFiles.Count > 0 )
                {
                    var uploadedFile = asyncUpload.UploadedFiles[0];
                    if (uploadedFile.FileName.Contains("/") || uploadedFile.FileName.Contains("?") || uploadedFile.FileName.Contains("*") || uploadedFile.FileName.Contains("<") || uploadedFile.FileName.Contains(">") || uploadedFile.FileName.Contains(":") || uploadedFile.FileName.Contains("|") || uploadedFile.FileName.Contains("\\") || uploadedFile.FileName.Contains("\""))
                    {
                        e.Canceled = true;
                        item.FindControl("CancelButton").Parent.Controls.Add(new LiteralControl("<br/><b style='color:red;'>File contains special characters.</b>"));
                    } else
                    {
                        fileData = new byte[uploadedFile.ContentLength];
                        fileName = uploadedFile.FileName.Replace(",","_").Replace(";", "_");
                        using (Stream str = uploadedFile.InputStream)
                        {
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

        protected void rgArticulationDocs_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                ScriptManager.GetCurrent(Page).RegisterPostBackControl(item["AttachmentColumn"].Controls[0]);
                ScriptManager.GetCurrent(Page).RegisterPostBackControl(item["AttachmentColumnIcon"].Controls[0]); 
                ImageButton btnDelete = (ImageButton)item["DeleteColumn"].Controls[0];
                ImageButton btnEdit = (ImageButton)item["EditCommandColumn"].Controls[0];

                btnDelete.Enabled = false;
                btnEdit.Enabled = false;
                btnEdit.ToolTip = "You can not update this document.";
                btnDelete.ToolTip = "You can not delete this document";

                var createdBy = item["CreatedBy"].Text;

                if (createdBy == hfUserID.Value || Session["RoleName"].ToString() == "Ambassador" || Session["RoleName"].ToString() == "Evaluator")
                {
                    btnDelete.Enabled = true;
                    btnEdit.Enabled = true;
                    btnEdit.ToolTip = "Edit document";
                    btnDelete.ToolTip = "Delete document";
                }

                if (e.Item is GridDataItem)
                {
                    GridDataItem gridItem = e.Item as GridDataItem;
                    foreach (GridColumn column in rgArticulationDocs.MasterTableView.RenderColumns)
                    {
                        if (column.UniqueName == "AttachmentColumnIcon" )
                        {
                            ImageButton img = (ImageButton)gridItem[column.UniqueName].Controls[0];
                            img.ToolTip = "Click here to download this file";
                            gridItem[column.UniqueName].ToolTip = "Click here to download the file";
                        }
                        if (column.UniqueName == "AttachmentColumn")
                        {
                            LinkButton link = (LinkButton)gridItem[column.UniqueName].Controls[0];
                            link.ToolTip = "Click here to download file";
                            gridItem[column.UniqueName].ToolTip = "Click here to download the file";
                        }
                    }
                }

            }
        }

        protected void rgArticulationDocs_PreRender(object sender, EventArgs e)
        {
            if (ReadOnly)
            {
                rgArticulationDocs.MasterTableView.GetColumn("EditCommandColumn").Visible = false;
                rgArticulationDocs.MasterTableView.GetColumn("DeleteColumn").Visible = false;
                rgArticulationDocs.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                //GridCommandItem cmd = (GridCommandItem)rgArticulationDocs.MasterTableView.GetItems(GridItemType.CommandItem)[0];
                //cmd.Visible = false;
                rgArticulationDocs.Rebind();
            }
        }

        private void DeleteDocument(int id, int user_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("DeleteArticulationDocument", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.ExecuteNonQuery();
                }
            }
        }

    }
}