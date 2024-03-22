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

namespace ems_app.modules.settings
{
    public partial class UpdateData : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        int fileId;
        byte[] fileData;
        string fileName;

        protected void Page_Load(object sender, EventArgs e)
        {
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

        protected void sqlDataIntakeDocuments_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            fileId = (int)e.Command.Parameters["@InsertedID"].Value;
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [DataIntakeDocuments] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
            }
        }

        protected void sqlDataIntakeDocuments_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [DataIntakeDocuments] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
            }
            rgDataIntakeDocuments.DataBind();
        }

        protected void rgDataIntakeDocuments_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            if (e.CommandName == RadGrid.UpdateCommandName || e.CommandName == RadGrid.PerformInsertCommandName)
            {
                GridEditableItem item = e.Item as GridEditableItem;

                if (!(item is GridEditFormInsertItem))
                {
                    fileId = (int)item.GetDataKeyValue("id");
                }
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
                        fileName = uploadedFile.FileName.Replace(",", "_").Replace(";", "_");
                        using (Stream str = uploadedFile.InputStream)
                        {
                            str.Read(fileData, 0, (int)uploadedFile.ContentLength);
                        }
                    }
                }
            }
        }

        protected void rgDataIntakeDocuments_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                ScriptManager.GetCurrent(Page).RegisterPostBackControl(item["AttachmentColumn"].Controls[0]);
            }
        }
    }
}