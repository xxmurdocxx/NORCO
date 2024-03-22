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

namespace ems_app.modules.military
{
    public partial class NewStudentDocuments : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfCollege.Value = Session["CollegeID"].ToString();
                hfUserID.Value = Session["UserID"].ToString();
                hfVeteranID.Value = Session["VeteranID"].ToString();
            }
        }

        protected void fuStudenteducationalbenefits_FileUploaded(object sender, FileUploadedEventArgs e)
        {
            using (Stream stream = e.File.InputStream)
            {
                byte[] fileByes = new byte[stream.Length];
                stream.Read(fileByes, 0, fileByes.Length);

                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    const string statement = "INSERT INTO [dbo].[VeteranDocuments] ([Filename],[BinaryData],[user_id],[VeteranID],[Field])" +
                                             " VALUES(@Filename, @BinaryData, @user_id, @VeteranID, @Field)";

                    using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
                    {
                        cmd.Parameters.AddWithValue("@FileName", e.File.FileName);
                        cmd.Parameters.Add("@BinaryData", SqlDbType.VarBinary, fileByes.Length).Value = fileByes;
                        cmd.Parameters.AddWithValue("@user_id", hfUserID.Value);
                        cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                        cmd.Parameters.AddWithValue("@Field", "student_educational_benefits");

                        try
                        {
                            connection.Open();

                            int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());

                        }
                        catch (Exception ex)
                        {
                            throw;
                        }
                    }
                }
            }
        }

        protected void fuStudentEducationalPlan_FileUploaded(object sender, FileUploadedEventArgs e)
        {
            using (Stream stream = e.File.InputStream)
            {
                byte[] fileByes = new byte[stream.Length];
                stream.Read(fileByes, 0, fileByes.Length);

                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    const string statement = "INSERT INTO [dbo].[VeteranDocuments] ([Filename],[BinaryData],[user_id],[VeteranID],[Field])" +
                                             " VALUES(@Filename, @BinaryData, @user_id, @VeteranID, @Field)";

                    using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
                    {
                        cmd.Parameters.AddWithValue("@FileName", e.File.FileName);
                        cmd.Parameters.Add("@BinaryData", SqlDbType.VarBinary, fileByes.Length).Value = fileByes;
                        cmd.Parameters.AddWithValue("@user_id", hfUserID.Value);
                        cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                        cmd.Parameters.AddWithValue("@Field", "student_educational_plan");

                        try
                        {
                            connection.Open();

                            int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());

                        }
                        catch (Exception ex)
                        {
                            throw;
                        }
                    }
                }
            }
        }

        protected void fuJoinsServicesTypeScript_FileUploaded(object sender, FileUploadedEventArgs e)
        {
            using (Stream stream = e.File.InputStream)
            {
                byte[] fileByes = new byte[stream.Length];
                stream.Read(fileByes, 0, fileByes.Length);

                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    const string statement = "INSERT INTO [dbo].[VeteranDocuments] ([Filename],[BinaryData],[user_id],[VeteranID],[Field])" +
                                             " VALUES(@Filename, @BinaryData, @user_id, @VeteranID, @Field)";

                    using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
                    {
                        cmd.Parameters.AddWithValue("@FileName", e.File.FileName);
                        cmd.Parameters.Add("@BinaryData", SqlDbType.VarBinary, fileByes.Length).Value = fileByes;
                        cmd.Parameters.AddWithValue("@user_id", hfUserID.Value);
                        cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                        cmd.Parameters.AddWithValue("@Field", "student_joint_services");

                        try
                        {
                            connection.Open();

                            int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());

                        }
                        catch (Exception ex)
                        {
                            throw;
                        }
                    }
                }
            }
        }

        protected void fuDD214_FileUploaded(object sender, FileUploadedEventArgs e)
        {
            using (Stream stream = e.File.InputStream)
            {
                byte[] fileByes = new byte[stream.Length];
                stream.Read(fileByes, 0, fileByes.Length);

                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    const string statement = "INSERT INTO [dbo].[VeteranDocuments] ([Filename],[BinaryData],[user_id],[VeteranID],[Field])" +
                                             " VALUES(@Filename, @BinaryData, @user_id, @VeteranID, @Field)";

                    using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
                    {
                        cmd.Parameters.AddWithValue("@FileName", e.File.FileName);
                        cmd.Parameters.Add("@BinaryData", SqlDbType.VarBinary, fileByes.Length).Value = fileByes;
                        cmd.Parameters.AddWithValue("@user_id", hfUserID.Value);
                        cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                        cmd.Parameters.AddWithValue("@Field", "student_dd214");

                        try
                        {
                            connection.Open();

                            int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());

                        }
                        catch (Exception ex)
                        {
                            throw;
                        }
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                const string statement = "UPDATE [dbo].[Veteran] SET [MapTotalCredits] = @MapTotalCredits WHERE id = @VeteranID";

                using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
                {
                    cmd.Parameters.AddWithValue("@MapTotalCredits", ddlMapTotal.SelectedValue);
                    cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);

                    try
                    {
                        connection.Open();
                        int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());

                    }
                    catch (Exception ex)
                    {
                        throw;
                    }
                }
            }

            Session["VeteranID"] = hfVeteranID.Value;
            Response.Redirect("../military/NewStudentSummary.aspx");
        }
    }
}