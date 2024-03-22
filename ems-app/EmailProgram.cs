using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Web;
using ems_app.Controllers;
using System.Data.SqlClient;
using System.Text;
using System.Data;
using System.IO;
using System.Security.Cryptography;
using ems_app.modules.settings;
using System.Configuration;
using DocumentFormat.OpenXml.Vml.Spreadsheet;

namespace ems_app
{
    public class EmailProgram
    {
        public static string dbConnectionString = ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString;
        public static int emails = 0;

        public static int Send_Email_Notif(int college_ID)
        {

            string dbConnection = dbConnectionString;
            string systemNotificationEmail = "mapadmin@mappingarticulatedpathways.org";
            string networkCredentialPassword = "KTpIvIRFAWFH0+B4//LFIj9TK/JRSh240gQ8OeAFMR0=";
            string emailHost = "usm105.siteground.biz";

            var smtpClient = new SmtpClient(emailHost)
            {
                Port = 2525,
                Credentials = new NetworkCredential(systemNotificationEmail, networkCredentialPassword),
                EnableSsl = false,
            };

            try
            {

                string sqlColleges = $"select count(*) as totalrows from LookupColleges where CollegeID = {college_ID} AND AllowEmailFacultyNotification = 1";

                using (SqlConnection connectionMainColleges = new SqlConnection(dbConnection))
                {
                    connectionMainColleges.Open();
                    SqlCommand commandMain1 = new SqlCommand(sqlColleges, connectionMainColleges);
                    SqlDataReader readerMain1 = commandMain1.ExecuteReader();
                    readerMain1.Read();

                    int numrows = (int)readerMain1["totalrows"];

                    if (numrows == 1)
                    {
                        string sql = $"SELECT DISTINCT M.ToUserID, CONCAT(s.RoleName, ' ', u1.FirstName,' ',u1.LastName) AS 'FromUser', CONCAT(u2.FirstName,' ',u2.LastName) AS 'ToUser', ISNULL(STUFF((SELECT ',' + Subject FROM (select s.SubjectName as 'Subject' FROM UserSubjects us LEFT OUTER JOIN tblSubjects s ON us.SubjectID = s.subject_id WHERE us.UserID = m.ToUserID) usr  FOR XML PATH('') ), 1, 1, ''),'')  as 'Subjects', m.Email, m.tookaction, S2.[Order] FROM [Messages] m JOIN TBLUSERS u1 ON m.FromUserID = u1.UserID JOIN TBLUSERS u2 ON M.ToUserID = u2.UserID JOIN ROLES S ON u1.RoleID = S.RoleID LEFT OUTER JOIN CriteriaPackage CP ON m.CriteriaPackageID = CP.Id JOIN Stages S2 ON U2.RoleID = S2.RoleId WHERE u2.collegeid = {college_ID} and M.IsRead = 0 AND m.Deleted = 0 AND (m.IsSent = 0 OR m.IsSent is null) AND cast(M.Received as date) >= cast(dbo.ReturnPSTDate(GETDATE()-0) as date)";

                        using (SqlConnection connectionMain = new SqlConnection(dbConnection))
                        {

                            connectionMain.Open();
                            SqlCommand commandMain = new SqlCommand(sql, connectionMain);
                            SqlDataReader readerMain = commandMain.ExecuteReader();
                            MailMessage msg = new MailMessage();
                            msg.From = new MailAddress(systemNotificationEmail);
                            msg.IsBodyHtml = true;
                            string html_body = "";
                            string subject_txt_0 = "";
                            string subject_txt = "";
                            int yy = 0;
                            int order_role = 0;
                            List<int> messageIds = new List<int>();

                            if (readerMain.HasRows)
                            {

                                while (readerMain.Read())
                                {
                                    bool tookAction = readerMain.GetBoolean(readerMain.GetOrdinal("tookaction"));
                                    order_role = (int)readerMain["Order"];
                                    string action_email = (!tookAction) ? "approved" : "created";

                                    subject_txt = (string)readerMain["Subjects"];

                                    if ((string)readerMain["Subjects"] != "")
                                    {
                                        subject_txt_0 = $"You are listed as the designated discipline expert for <b>{subject_txt}</b>.";
                                    }

                                    if (!tookAction)
                                    {
                                        if (order_role != 1)
                                        {
                                            if (order_role == 2)
                                            {
                                                html_body += $"<div style='color:#000;'><p>Dear {(string)readerMain["ToUser"]},</p>" +
                                                             $"<p style='color:#000;'>The articulation recommendations below were submitted for your consideration by {(string)readerMain["FromUser"]}.{subject_txt_0}</p>" +
                                                             $"<p style='color:#000;'>Please determine if the course matches the credit recommendation(s) listed within the exhibit(s).</p></div>";
                                            }

                                            if (order_role == 3)
                                            {
                                                html_body += $"<div style='color:#000;'><p>Dear {(string)readerMain["ToUser"]},</p>" +
                                                             $"<p style='color:#000;'>The articulation recommendations below were submitted for your consideration by {(string)readerMain["FromUser"]}.</p>" +
                                                             $"<p style='color:#000;'>Please determine if the course matches the credit recommendation(s) listed within the exhibit(s).</p></div>";
                                            }
                                        }
                                        else
                                        {
                                            html_body += $"<div style='color:#000;'><p>Dear {(string)readerMain["ToUser"]},</p>" +
                                                         $"<p style='color:#000;'>There has been action taken on your MAP platform.</p>" +
                                                         $"<p style='color:#000;'>View updates below:</p></div>";
                                        }


                                        using (SqlConnection connection = new SqlConnection(dbConnection))
                                        {
                                            connection.Open();
                                            string sql2 = "";
                                            sql2 = $"SELECT m.[Subject], m.CriteriaPackageID, isnull(cp.Criteria,'') Criteria, m.ToUserID, M.MessageID, m.ActionTaken, m.Articulations, m.Email, u2.UserName, u2.[Password], m.tookaction, m.body  FROM [Messages] m JOIN TBLUSERS u1 ON m.FromUserID = u1.UserID JOIN TBLUSERS u2 ON M.ToUserID = u2.UserID JOIN ROLES S ON u1.RoleID = S.RoleID LEFT OUTER JOIN CriteriaPackage CP ON m.CriteriaPackageID = CP.Id JOIN Stages S2 ON U2.RoleID = S2.RoleId  WHERE u2.CollegeID = {college_ID} and M.ToUserID = {(int)readerMain["ToUserID"]} AND (M.CriteriaPackageId <>0 OR M.CriteriaPackageId is not null) AND m.Deleted = 0 AND (m.IsSent = 0 OR m.IsSent is null) AND cast(M.Received as date) >= cast(dbo.ReturnPSTDate(GETDATE() - 0) as date)";


                                            using (SqlCommand command = new SqlCommand(sql2, connection))
                                            {
                                                using (SqlDataReader reader = command.ExecuteReader())
                                                {
                                                    while (reader.Read())
                                                    {
                                                        bool tookAction2 = reader.GetBoolean(reader.GetOrdinal("tookaction"));

                                                        if (reader["ActionTaken"] != DBNull.Value)
                                                        {
                                                            if ((string)reader["ActionTaken"] == "CriteriaPackage")
                                                            {
                                                                html_body += $"{CreditRecommendation.GetPackage((string)reader["body"], (int)reader["CriteriaPackageID"], (int)reader["MessageID"], (string)reader["ActionTaken"], (string)reader["UserName"], (string)reader["Password"], (string)reader["Subject"], dbConnection, tookAction2)}";
                                                            }
                                                            else
                                                            {
                                                               //if ((string)reader["ActionTaken"] != "Denied")
                                                               // {
                                                                    int cpi = (int)reader["CriteriaPackageID"];
                                                                    html_body += $"{CreditRecommendation.GetArticulations((string)reader["body"], college_ID, (int)reader["MessageID"], (string)reader["ActionTaken"], (string)reader["Articulations"], (string)reader["UserName"], (string)reader["Password"], (string)reader["Subject"], dbConnection, tookAction2, cpi)}";
                                                                //}
                                                            }

                                                            if ((string)reader["ActionTaken"] == "CriteriaPackage")
                                                            {
                                                                StringBuilder sb = new StringBuilder();
                                                                sb.Append($"{Exhibit.GetTopExhibits((string)reader["Criteria"], dbConnection)}");
                                                                //msg.Attachments.Add(new Attachment(new MemoryStream(Report.ToPDF(sb)), $"{(string)reader["Criteria"]}.pdf"));
                                                            }


                                                        }
                                                        else
                                                        {
                                                            string response = "False";
                                                        }

                                                        if (!reader.IsDBNull(reader.GetOrdinal("MessageID")))
                                                        {
                                                            int messageId = reader.GetInt32(reader.GetOrdinal("MessageID"));
                                                            messageIds.Add(messageId);
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        if (order_role != 1)
                                        {
                                            html_body += "<div class='instructions' style='font-size:13px;color:#FF0000;margin-top:120px;'><p>If you forward this message the recipient will have access to take action on your behalf. Please advise any recipients to add notes including their name and title. For questions or assistance, please contact your campus MAP Ambassador.</p></div>";
                                        }

                                        msg.Body = html_body;
                                        msg.Subject = "MAP Notifications - Articulation(s) pending to review";
                                        //msg.To.Add("Pedro.Campos@theinfotechpartners.com");
                                        msg.To.Add((string)readerMain["Email"]);
                                        //msg.To.Add("pedro.bernal@theinfotechpartners.com");


                                        try
                                        {
                                            smtpClient.Send(msg);
                                            foreach (int messageId in messageIds)
                                            {
                                                SetIsSentMessage(messageId);
                                            }
                                            CreateArticulationLog(college_ID);
                                            emails++;
                                        }
                                        catch (SmtpException ex)
                                        {
                                            emails = -1;
                                        }

                                        msg.Body = "";
                                        html_body = "";
                                        msg.To.Clear();
                                        Console.WriteLine("Message sent successfully!");
                                    }
                                }
                            }
                            else
                            {

                            }
                            readerMain.Close();
                        }
                    }
                    else
                    {

                    }
                }
            }
            catch (Exception ex)
            {
                var mes = ex.ToString();
                Console.WriteLine(ex);
                emails = -2;
            }

            return emails;
        }
        public static void CreateArticulationLog(int college_ID)
        {
            string dbConnection = dbConnectionString;
            string sqlColleges = $"SELECT DISTINCT m.ToUserID, CONCAT(u2.FirstName,' ',u2.LastName) AS 'ToUser', S2.[Order], m.Articulations FROM [Messages] m JOIN TBLUSERS u1 ON m.FromUserID = u1.UserID JOIN TBLUSERS u2 ON M.ToUserID = u2.UserID JOIN ROLES S ON u1.RoleID = S.RoleID LEFT OUTER JOIN CriteriaPackage CP ON m.CriteriaPackageID = CP.Id JOIN Stages S2 ON U2.RoleID = S2.RoleId WHERE u2.collegeid = {college_ID} and M.IsRead = 0 AND m.Deleted = 0 AND (m.IsSent = 0 OR m.IsSent is null) AND cast(M.Received as date) >= cast(dbo.ReturnPSTDate(GETDATE()-0) as date)";
            using (SqlConnection connectionMainColleges = new SqlConnection(dbConnection))
            {
                connectionMainColleges.Open();
                SqlCommand commandMain1 = new SqlCommand(sqlColleges, connectionMainColleges);
                SqlDataReader readerMain1 = commandMain1.ExecuteReader();
                //List<DataItemArticulation> transformedList = new List<DataItemArticulation>();
                if (readerMain1.HasRows)
                {
                    while (readerMain1.Read())
                    {
                        string ArticulationItems = (string)readerMain1["Articulations"];
                        var articulations = ArticulationItems.Split(',');
                        int larts = articulations.Length;
                        foreach (string articulation in articulations)
                        {
                            //InsertArticulationLog((int)readerMain1["ToUserID"], (string)readerMain1["ToUser"], (int)readerMain1["Order"], articulation.TO );
                            if (int.TryParse(articulation, out int articulationInt))
                            {
                                InsertArticulationLog((int)readerMain1["ToUserID"], (string)readerMain1["ToUser"], (int)readerMain1["Order"], articulationInt);
                            }
                        }
                    }
                }
            }
        }

        public static void InsertArticulationLog(int ToUserID, string ToUser, int Order, int Articulation_ID)
        {
            string sqlColleges = $"SELECT * FROM ArticulationLog WHERE UserID={ToUserID} AND Articulation_ID={Articulation_ID} AND Info like '%articulation was submitted to%'";
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            SqlCommand commandMain1 = new SqlCommand(sqlColleges, conn);
            SqlDataReader readerMain1 = commandMain1.ExecuteReader();
            readerMain1.Read();

            if (!readerMain1.HasRows)
            {
                SqlConnection conn2 = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
                conn2.Open();
                SqlCommand cmd = new SqlCommand("CreateArticulationLog", conn2);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("Articulation_ID", Articulation_ID);
                cmd.Parameters.AddWithValue("UserID", ToUserID);
                cmd.Parameters.AddWithValue("info", "Articulation was submitted to " + ToUser);
                cmd.ExecuteReader();
                conn2.Close();
            }
            conn.Close();
        }

        public static void SetIsSentMessage(int msgid)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE [dbo].[Messages] SET IsSent = 1 WHERE MessageID = @Id", connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@Id", msgid);
                    cmd.ExecuteNonQuery();
                }
            }
        }

    }


    public class NotificacionEventArgs : EventArgs
    {
        public string Titulo { get; set; }
        public string Mensaje { get; set; }

        public NotificacionEventArgs(string titulo, string mensaje)
        {
            Titulo = titulo;
            Mensaje = mensaje;
        }
    }
    class CreditRecommendation
    {

        public static string GetNumberLink(string cadena, string urlhr)
        {
            string[] partes = cadena.Split(new string[] { "<b><u>", "</u></b>" }, StringSplitOptions.None);
            string parte1 = partes[0];
            string parte2 = partes[1];
            string parte3 = partes[2];
            return parte1 + "<b><a href='" + urlhr + "'>" + parte2 + "</a></b>" + parte3;
        }

        private static string GetCourses(int cpi)
        {
            //int cpi = 0;
            string courses2 = "";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    //cmd.CommandText = $"select CPA.PackageId from Articulation a inner join CriteriaPackageArticulation CPA ON a.id = CPA.ArticulationId WHERE a.id = {id_articulaction}";
                    //cpi = (int)cmd.ExecuteScalar();

                    SqlCommand command = new SqlCommand("GetCriteriaPackage", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("CriteriaPackageID", cpi);
                    SqlDataReader reader = command.ExecuteReader();
                    reader.Read();
                    courses2 = (string)reader["Course2"];
                }
                finally
                {
                    connection.Close();
                }
            }
            return courses2;
        }

        public static string GetArticulations(string msgrecipient, int collegeid, int message_id, string action_taken, string articulations, string username, string password, string subject, string db_connection, bool tookaction, int cpi)
        {
            string ArticulationList = "";
            string style_button = "text-align:center; display:flex;justify-content:center;color:#000;font-size:13px !important;margin:3px;padding:8px;text-decoration:none;font-weight:700;border-radius:5px;cursor:pointer;";
            string style_button_grey = "text-align:center;display:flex;color:#f8f8f8;font-size:13px !important;margin:3px;padding:8px;text-decoration:none;font-weight:700;border-radius:5px;cursor:pointer;";
            string style_cell = "padding:5px; color:#000;";
            //string host = "http://localhost:49573";
            //string host = "https://maptrainingplatformv2.azurewebsites.net/";

            string host = GlobalUtil.GetDatabaseSetting("SiteName");
            //string host = "https://militaryarticulationplatformweb.azurewebsites.net/";
            //string url = $"{host}modules/Notifications/Confirm_o.aspx";
            string url = $"{host}/modules/Notifications/EmailAccess_o.aspx";
            //string url = $"{host}/modules/security/Login.aspx";

            string url_parameters = $"&MessageID={Security.Encrypt(message_id.ToString())}&AceID={Security.Encrypt(username)}&TeamRevd={Security.Encrypt(password)}&ActionTaken={Security.Encrypt(action_taken)}";

            int messageID = 0;
            int cpID = 0;
            string criteria_text = "";
            string sql_2 = "";
            string courses = "";


            using (SqlConnection connection = new SqlConnection(db_connection))
            {
                connection.Open();

                sql_2 = $"SELECT m.MessageID, m.CriteriaPackageID, cp.Criteria FROM [Messages] m JOIN TBLUSERS u1 ON m.FromUserID = u1.UserID JOIN TBLUSERS u2 ON M.ToUserID = u2.UserID JOIN ROLES S ON u1.RoleID = S.RoleID LEFT OUTER JOIN CriteriaPackage CP ON m.CriteriaPackageID = CP.Id JOIN Stages S2 ON U2.RoleID = S2.RoleId WHERE u2.CollegeID = {collegeid} and m.Articulations = '{articulations}' And m.tookaction = 1 AND (Criteria is not null) AND  (m.CriteriaPackageId <>0 OR m.CriteriaPackageId is not null) AND cast(M.Received as date) >= cast(dbo.ReturnPSTDate(GETDATE() - 0) as date)";

                using (SqlCommand command_2 = new SqlCommand(sql_2, connection))
                {
                    SqlDataReader reader_2 = command_2.ExecuteReader();
                    if (reader_2.HasRows)
                    {
                        while (reader_2.Read())
                        {
                            messageID = (int)reader_2["MessageID"];
                            cpID = (int)reader_2["CriteriaPackageID"];
                            criteria_text = (string)reader_2["Criteria"];
                        }

                    }
                    reader_2.Close();
                }

                //    sql_2 = $"select distinct aa.id, concat(s.subject, '-', c.course_number, ' ', course_title, ' ', u.unit, ' Unit(s)') 'Course', ISNULL(STUFF((SELECT ',' + Criteria FROM ACEExhibitCriteria a join Articulation b on a.CriteriaID = b.CriteriaID where b.id = aa.id FOR XML PATH('')), 1, 1, ''),'') CreditRecommendations, concat(aa.AceID, ' ', FORMAT(aa.TeamRevd, 'MM/dd/yyyy '), ' ', aa.Title) Exhibit from articulation aa join Course_IssuedForm c on aa.outline_id = c.outline_id join tblSubjects s on c.subject_id = s.subject_id join tblLookupUnits u on c.unit_id = u.unit_id where aa.id in ( select value from dbo.fn_Split('{articulations}',',') )";
                string sql = $"select count(aa.id) as total, concat(s.subject, '-', c.course_number, ' ', course_title, ' ', u.unit, ' Unit(s)') 'Course', isnull((SELECT distinct Criteria FROM ACEExhibitCriteria a join Articulation b on a.CriteriaID = b.CriteriaID where b.id in (select value from dbo.fn_Split('{articulations}', ',') )), '') CreditRecommendations, concat('This credit recommendation occurs in <b><u>', count(aa.id), '</u></b> Exhibit(s) course(s)') Exhibit from articulation aa join Course_IssuedForm c on aa.outline_id = c.outline_id join tblSubjects s on c.subject_id = s.subject_id join tblLookupUnits u on c.unit_id = u.unit_id where aa.id in (select value from dbo.fn_Split('{articulations}', ',') ) group by s.subject, c.course_number, course_title, u.unit";


                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    SqlDataReader reader = command.ExecuteReader();
                    //ArticulationList += $"<h3><b style='color:#000;'>{subject}</b></h3>";
                    while (reader.Read())
                    {

                        //ArticulationList += $"<label><b>{(string)reader["Course"]}</b></label>";
                        ArticulationList += "<table class='styled-table' width='100%'><tbody>";
                        //ArticulationList += $"<tr style='background-color:#F7F7F7;'><td width='20%' style='{style_cell}'><div style='display:flex;'><a class='btn' style='background-color:#76D7C4;{style_button}' href='{url}?Action=" + Security.Encrypt("Approve") + $"{url_parameters}'>Approve</a><a style='background-color:#F7DC6F;{style_button}' href='{url}?Action=" + Security.Encrypt("Return") + $"{url_parameters}'>Return</a><a style='background-color:#F5B7B1;{style_button}' href='{url}?Action=" + Security.Encrypt("Deny") + $"{url_parameters}'>Deny</a></div></td>";

                        string urlhref = url + $"?Action=" + Security.Encrypt("View") + $"&Criteria={Security.Encrypt(criteria_text)}&CriteriaPackageID={Security.Encrypt(cpID.ToString())}" + $"{url_parameters}";

                        if (tookaction)
                        {
                            string style_gray = "#B2B2B2";
                            ArticulationList += $"<tr style='background-color:#F7F7F7;'><td width='15%' style='{style_cell}'><div style='display:flex;'><a class='btn' style='background-color:#76D7C4;{style_button}' href='javascript:;'>Approve</a><a style='background-color:#F5B7B1;{style_button_grey}' href='javascript:;'>Deny</a></div></td>";
                        }
                        else
                        {
                            string style_gray = "#76D7C4";
                            ArticulationList += $"<tr style='background-color:#F7F7F7;'><td width='15%' style='{style_cell}'><div style='display:flex;'><a class='btn' style='background-color:{style_gray};{style_button}' href='{url}?Action=" + Security.Encrypt("Approve") + $"&Criteria={Security.Encrypt(criteria_text)}&CriteriaPackageID={Security.Encrypt(cpID.ToString())}" + $"{url_parameters}'>Approve</a><a style='background-color:#F5B7B1;{style_button}' href='{url}?Action=" + Security.Encrypt("Deny") + $"&Criteria={Security.Encrypt(criteria_text)}&CriteriaPackageID={Security.Encrypt(cpID.ToString())}" + $"{url_parameters}'>Deny</a></div></td>";
                        }

                        

                        string occur = (string)reader["Exhibit"];
                        string numLink = GetNumberLink(occur, urlhref);

                        courses = GetCourses(cpi);

                        //ArticulationList += $"<td width='30%' style='color:#000;text-align:center;{style_cell}'>{(string)reader["CreditRecommendations"]}</td>";
                        ArticulationList += $"<td width='30%' style='color:#000;text-align:center;{style_cell}'>{courses}</td>";
                        ArticulationList += $"<td width='30%' style='color:#000;text-align:center;{style_cell}'>{(string)reader["CreditRecommendations"]}</td>";
                        //ArticulationList += $"<td width='30%' style='color:#000;text-align:center;{style_cell}'>{numLink}</td>";
                        //ArticulationList += $"<td width='10%' style='{style_cell}'><a href='{urlhref}' style='{style_button}'>View Exhibits</a></td>";
                        ArticulationList += $"<td width='10%' style='{style_cell}'><a href='{urlhref}' style='width:80px;{style_button}'>View Details</a></td>";

                        //ArticulationList += $"<td width='10%' style='{style_cell}'>" + $"<label for='txtMsgRecipient'><b>Message from Sender:</b></label>" + $"<textarea name='txtMsgRecipient' id='txtMsgRecipient' readonly disabled style='color: #000; border: none; width: 300px; resize: none !important; user-select: none; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none;' rows='4'>" + $"{msgrecipient.Replace("<br />", " ")}" + $"</textarea>" + $"</td></tr>";
                        
                        ArticulationList += $"<td width='10%' style='{style_cell}'>" + $"<label for='txtMsgRecipient'><b>Message from Sender:</b></label>" + $"<div style='color: #000; border: none; width: 300px;'>" + $"{msgrecipient.Replace("<br />", " ")}" + $"</div>" + $"</td></tr>";

                        //ArticulationList += $"<td width='10%' style='{style_cell}'><input type='text' name='txtMsgRecipient' style='font-size:12px; color: #2233AA; background-color: #CCC; width: 200px; pointer-events: none; user-select: none;' value='{msgrecipient.Replace("<br />", " ")}' readonly disabled></td></tr>";
                        ArticulationList += "</tbody></table>";

                        
                    }
                }
            }
            return ArticulationList;
        }
        public static string GetPackage(string msgrecipient, int criteria_package_id, int message_id, string action_taken, string username, string password, string subject, string db_connection, bool tookaction)
        {
            string CriteriaPackage = "";
            string style_button = "text-align:center;display:flex;color:#000;font-size:13px !important;margin:3px;padding:8px;text-decoration:none;font-weight:700;border-radius:5px;cursor:pointer;";
            string style_link = "text-align:center;display:flex;color:#203864;font-size:13px !important;margin:3px;padding:8px;text-decoration:underline;font-weight:700;border-radius:5px;cursor:pointer;";
            string style_button_grey = "text-align:center;display:flex;color:#f8f8f8;font-size:13px !important;margin:3px;padding:8px;text-decoration:none;font-weight:700;border-radius:5px;cursor:pointer;";
            string style_cell = "padding:5px; color:#000;";
            //string host = "http://localhost:49573";
            //string host = "https://maptrainingplatformv2.azurewebsites.net/";
            //string host = "https://militaryarticulationplatformweb.azurewebsites.net/";
            string host = GlobalUtil.GetDatabaseSetting("SiteName");

            //string url = $"{host}modules/Notifications/Confirm_o.aspx";
            string url = $"{host}/modules/Notifications/EmailAccess_o.aspx";
            //string url = $"{host}/modules/security/Login.aspx";

            //string url = $"{host}modules/popups/AssignOccupationArticulation.aspx";
            string url_parameters = $"&MessageID={Security.Encrypt(message_id.ToString())}&AceID={Security.Encrypt(username)}&TeamRevd={Security.Encrypt(password)}&ActionTaken={Security.Encrypt(action_taken)}";


            using (SqlConnection connection = new SqlConnection(db_connection))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("GetCriteriaPackage", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("CriteriaPackageID", criteria_package_id);
                SqlDataReader reader = command.ExecuteReader();
                //CriteriaPackage += $"<h3><b style='color:#000;'>{subject}</b></h3>";

                while (reader.Read())
                {
                    string encryptedCriteria = Security.Encrypt(reader.GetString(0));
                    CriteriaPackage += "<table class='styled-table' width='100%'><tbody>";

                    if (tookaction)
                    {
                        string style_gray = "#B2B2B2";
                        CriteriaPackage += $"<tr style='background-color:#F7F7F7;'><td width='15%' style='{style_cell}'><div style='display:flex;'><a style='background-color:{style_gray};{style_button_grey}' href='javascript:;'>Approve</a><a style='background-color:{style_gray};{style_button_grey}' href='javascript:;'>Deny</a></div></td>";
                    }
                    else
                    {
                        string style_gray = "#76D7C4";

                        CriteriaPackage += $"<tr style='background-color:#F7F7F7;'><td width='15%' style='{style_cell}'><div style='display:flex;'><a style='background-color:{style_gray};{style_button}' href='{url}?Action=" + Security.Encrypt("Approve") + $"&Criteria={encryptedCriteria}" + $"{url_parameters}'>Approve</a><a style='background-color:#F5B7B1;{style_button}' href='{url}?Action=" + Security.Encrypt("Deny") + $"&Criteria={encryptedCriteria}" + $"{url_parameters}'>Deny</a></div></td>";
                    }
                    
                    CriteriaPackage += $"<td width='20%' style='{style_cell}'>{(string)reader["Course2"]}</td>";
                    CriteriaPackage += $"<td width='30%' style='color:#000;text-align:center;{style_cell}'>{(string)reader["Criteria"]}</td>";

                    string occur = (string)reader["Ocurrences"];
                    //string urlhref = $"{host}/modules/Notifications/Exhibits.aspx?Criteria={reader.GetString(0)}&CriteriaPackageID={criteria_package_id}";
                    string urlhref = $"{host}/modules/Notifications/EmailAccess_o.aspx?Action=" + Security.Encrypt("ViewExhi") + $"&Criteria={reader.GetString(0)}&CriteriaPackageID={criteria_package_id}" + $"{url_parameters}";

                    //string numLink = GetNumberLink(occur, urlhref);
                    //CriteriaPackage += $"<td width='30%' style='{style_cell}'>{numLink}</td>";

                    //CriteriaPackage += $"<td width='10%' style='{style_cell}'><a href='{host}modules/Notifications/Exhibits.aspx?Criteria={reader.GetString(0)}&CriteriaPackageID={criteria_package_id}' style='{style_link}'>View Exhibit</a></td>";

                    //CriteriaPackage += $"<td width='10%' style='{style_cell}'><a href='{urlhref}' style='{style_link}'>View Exhibit</a></td>";

                    //CriteriaPackage += $"<td width='10%' style='{style_cell}'><a href='{url}?Action=" + Security.Encrypt("View") + $"{url_parameters}' style='{style_link}'>View Details</a></td></tr>";

                    CriteriaPackage += $"<td width='10%' style='{style_cell}'><a href='{url}?Action=" + Security.Encrypt("View") + $"&Criteria={encryptedCriteria}" + $"{url_parameters}' style='{style_link}'>View Details</a></td>";

                    //CriteriaPackage += $"<td width='10%' style='{style_cell}'>" + $"<label for='txtMsgRecipient'><b>Message from Sender:</b></label>" + $"<textarea name='txtMsgRecipient' readonly disabled style='color: #000; border: none; width: 300px; resize: none !important; user-select: none; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none;' rows='4'>" + $"{msgrecipient.Replace("<br />", " ")}" + $"</textarea>" + $"</td></tr>";

                    CriteriaPackage += $"<td width='10%' style='{style_cell}'>" + $"<label for='txtMsgRecipient'><b>Message from Sender:</b></label>" + $"<div style='color: #000; border: none; width: 300px;'>" + $"{msgrecipient.Replace("<br />", " ")}" + $"</div>" + $"</td></tr>";

                    //CriteriaPackage += $"<td width='10%' style='{style_cell}'><input type='text' name='txtMsgRecipient' style='font-size:12px; color: #2233AA; background-color: #CCC; width: 200px; pointer-events: none; user-select: none;' value='{msgrecipient.Replace("<br />", " ")}' readonly disabled></td></tr>";

                    CriteriaPackage += "</tbody></table>";

                }
                reader.Close();

            }
            return CriteriaPackage;
        }
    }

    class Exhibit
    {
        public static string GetTopExhibits(string criteria, string db_connection)
        {
            string sb = "";
            sb += $"<h1>{criteria}</h1>";
            string sql = $"select top(3) ae.ExhibitDisplay from (select distinct AceID, TeamRevd, StartDate, EndDate, Criteria from ACEExhibitCriteria) aec join ACEExhibit ae on aec.AceID = ae.AceID and aec.TeamRevd = ae.TeamRevd and aec.StartDate = ae.StartDate and aec.EndDate = ae.EndDate where trim(aec.Criteria) = trim('{criteria}') order by aec.EndDate desc";
            using (SqlConnection connection = new SqlConnection(db_connection))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sql, connection);
                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    sb += $"{(string)reader["ExhibitDisplay"]}";
                }
                reader.Close();
            }
            return sb;
        }
    }

    class Security
    {
        public static string Encrypt(string clearText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6E, 0x20, 0x4D, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = System.Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }
    }


}