using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ems_app.modules.document
{
    /// <summary>
    /// Summary description for Download
    /// </summary>
    public class Download : IHttpHandler
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
            var dt = GlobalUtil.GetDataTableWithParameters("SELECT *, RIGHT(FileName, CHARINDEX('.', REVERSE(FileName)) - 1) AS Extension FROM ArticulationDocuments WHERE id = @ID", CommandType.Text, parameters);
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

        //public string GetFileExtension(string id)
        //{
        //    DataSet ds = new DataSet();
        //    string sql = $"SELECT RIGHT(FileName, CHARINDEX('.', REVERSE(FileName)) - 1) AS Extension FROM VeteranDocuments WHERE CHARINDEX('.', FileName) > 0 AND ID={id};";
        //    string extension = string.Empty;
        //    using (var adapter = new SqlDataAdapter(sql, ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
        //    {
        //        adapter.Fill(ds);

        //        if (ds.Tables[0].Rows.Count > 0)
        //        {
        //            DataRow dr = ds.Tables[0].Rows[0];
        //            extension = dr["Extension"].ToString();
        //        }
        //    }
        //    return extension;
        //}
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}