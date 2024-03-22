using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ems_app.modules.document
{
    /// <summary>
    /// Summary description for Download
    /// </summary>
    public class DownloadExhibit : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.Buffer = true;
            context.Response.Charset = "";
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            var parameters = new SqlParameter[]
                    {
                        new SqlParameter("@ID", context.Request.QueryString["ID"])
                    };
            var dt = GlobalUtil.GetDataTableWithParameters("SELECT *, RIGHT(FileName, CHARINDEX('.', REVERSE(FileName)) - 1) AS Extension FROM CPLExhibitDocuments WHERE id = @ID", CommandType.Text, parameters);
            Byte[] bytes = null;
            if (dt.Rows.Count > 0)
            {
                context.Response.ContentType = $"application/{dt.Rows[0]["Extension"].ToString()}";
                context.Response.AddHeader($"content-disposition", $"attachment;filename={ dt.Rows[0]["FileName"].ToString() }");
                bytes = (Byte[])dt.Rows[0]["BinaryData"];              
            }
            context.Response.BinaryWrite(bytes);
            context.Response.Flush();
            context.Response.End();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}