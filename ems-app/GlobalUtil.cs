using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.IO;
using System.Text;
using System.Data;
using System.Configuration;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Net;
using System.Data.SqlClient;
using ems_app.Common.infrastructure;

namespace ems_app
{
    public class GlobalUtil
    {
        private static string ConnectionString = ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString;
        public string Between(string Text, string FirstString, string LastString)
        {
            string STR = Text;
            string STRFirst = FirstString;
            string STRLast = LastString;
            string FinalString;
            int Pos1 = STR.IndexOf(FirstString) + FirstString.Length;
            int Pos2 = STR.IndexOf(LastString);
            FinalString = STR.Substring(Pos1, Pos2 - Pos1);
            return FinalString;
        }

        public static string getRandColor()
        {
            Random rnd = new Random();
            string hexOutput = String.Format("{0:X}", rnd.Next(0, 0xFFFFFF));
            while (hexOutput.Length < 6)
                hexOutput = "0" + hexOutput;
            return "#" + hexOutput;
        }

        public static System.Drawing.Color getRandColorName()
        {
            Random rand = new Random();
            int r = rand.Next(256);
            int g = rand.Next(256);
            int b = rand.Next(256);
            System.Drawing.Color col = System.Drawing.Color.FromArgb(r, g, b);
            return col;
        }

        public static String SetSelectedIndexChangeControl(RadComboBox controlID)
        {
            RadComboBox listBox = controlID;
            int itemschecked = listBox.CheckedItems.Count;
            String[] DataFieldsArray = new String[itemschecked];
            var collection = listBox.CheckedItems;
            int i = 0;
            foreach (var item in collection)
            {
                String value = item.Value;
                DataFieldsArray[i] = value;
                i++;
            }
            return String.Join(",", DataFieldsArray);
        }

        public static String PreRenderComboBoxControl(RadComboBox controlID)
        {
            RadComboBox listBox = controlID;
            var data = "";
            foreach (RadComboBoxItem itm in listBox.Items)
            {
                itm.Checked = true;

                int itemschecked = listBox.CheckedItems.Count;
                String[] DataFieldsArray = new String[itemschecked];
                var collection = listBox.CheckedItems;
                int i = 0;
                foreach (var item in collection)
                {
                    String value = item.Value;
                    DataFieldsArray[i] = value;
                    i++;
                }
                data = String.Join(",", DataFieldsArray);
            }
            return data;
        }

        public static bool HaveAccessUrl( string url, int roleID)
        {
            NORCODataContext norco_db = new NORCODataContext();
            bool haveAccess = Convert.ToBoolean(norco_db.HaveAccesURL(url, roleID));
            return haveAccess;
        }

        public static string GenerateTemplateHTML(int LeadId, int College, int TemplateType, string FullName)
        {
            NORCODataContext norco_db = new NORCODataContext();
            Dictionary<string, string> leadInformation = new Dictionary<string, string>();
            var leadInfo = norco_db.GetLeadInformation(LeadId, College);
            string collegeName = "";
            string templateText = "";
            var template = norco_db.GetCommunicationTemplate(TemplateType, College);
            foreach (GetCommunicationTemplateResult item in template)
            {
                templateText = item.TemplateText;
            }

            foreach (GetLeadInformationResult item in leadInfo)
            {
                leadInformation.Add("FullName", item.FullName);
                leadInformation.Add("FirstName", item.FirstName);
                leadInformation.Add("LastName", item.LastName);
                leadInformation.Add("Service", item.Service);
                leadInformation.Add("College", item.College);
                leadInformation.Add("OccupationCode", item.OccupationCode);
                leadInformation.Add("OccupationDescription", item.OccupationDescription);
                templateText = templateText.Replace("{Recommendations}", GenerateRecommendationList(LeadId, College));
                templateText = templateText.Replace("{ExhibitList}", GenerateExhibitList(LeadId, College));
                collegeName = item.College;
            }

            DataTable dtAdditionalInformation = GetAdditionalInformation(collegeName);
            if (dtAdditionalInformation != null)
            {
                if (dtAdditionalInformation.Rows.Count > 0)
                {
                    foreach (DataRow row in dtAdditionalInformation.Rows)
                    {
                        templateText = templateText.Replace("{VetSpecialistName}", row["VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION"].ToString());
                        templateText = templateText.Replace("{VetSpecialistPhone}", row["VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION_PHONE"].ToString());
                        templateText = templateText.Replace("{VetSpecialistEmail}", row["VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION_EMAIL"].ToString());
                    }
                }
            }

            templateText = templateText.Replace("{VeteranFullName}", leadInformation["FullName"]);
            templateText = templateText.Replace("{VeteranFirstName}", leadInformation["FirstName"]);
            templateText = templateText.Replace("{VeteranLastName}", leadInformation["LastName"]);
            templateText = templateText.Replace("{ServiceName}", leadInformation["Service"]);
            templateText = templateText.Replace("{CollegeName}", leadInformation["College"]);
            templateText = templateText.Replace("{UserName}", FullName);
            templateText = templateText.Replace("{OccupationCode}", leadInformation["OccupationCode"]);
            templateText = templateText.Replace("{OccupationDescription}", leadInformation["OccupationDescription"]);
            templateText = templateText.Replace("{ProgramCourses}", GenerateProgramCoursesHTML(LeadId, College));
            return templateText;
        }

        public static string GenerateRecomendationsHTML(string AceID, string TeamRevd, int LeadID)
        {
            var templateText = "";
            NORCODataContext norco_db = new NORCODataContext();

            var recommendations = norco_db.GetRecommendations(AceID, TeamRevd, LeadID);

            foreach (GetRecommendationsResult items in recommendations)
            {
                if (items.Column1 == "")
                {
                    templateText += "No recommendation(s) found.";
                } else
                {
                    templateText += "<table class='tableRecommendations'><tr style='font-weight:bold;'><td>Recommendations</td></tr>";
                    templateText += "<tr>";
                    templateText += String.Format("<td>{0}</td>", items.Column1);
                    templateText += "</tr>";
                    templateText += "</table>";
                }
            }
            return templateText;
        }

        public static DataTable GetAdditionalInformation(string college_name)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetMAPCohort", conn);
                cmd.Parameters.Add("@CollegeName", SqlDbType.VarChar).Value = college_name;
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
		public static DataTable GetCourseInformation(int outline_id)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("PCCCourseDataSelect", conn);
                cmd.Parameters.Add("@outline_id", SqlDbType.Int).Value = outline_id;
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

        public static string GenerateExhibitList(int LeadID, int CollegeID)
        {
            var templateText = "";
            NORCODataContext norco_db = new NORCODataContext();

            var exhibits = norco_db.GetVeteranLeadAceExhibits(LeadID,CollegeID);
            templateText += "<table class='tableExhibits'><tr style='font-weight:bold;'><td>Type</td><td>ACE ID</td><td>Team Revd</td><td>Title</td></tr>";

            foreach (GetVeteranLeadAceExhibitsResult items in exhibits)
            {
                    templateText += "<tr>";
                    templateText += String.Format("<td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td>", items.ACEType, items.AceID, items.TeamRevd, items.Title);
                    templateText += "</tr>";
            }

            templateText += "</table>";
            return templateText;
        }

        public static string GenerateRecommendationList(int LeadID, int CollegeID)
        {
            var templateText = "";
            NORCODataContext norco_db = new NORCODataContext();

            var exhibits = norco_db.GetVeteranLeadRecommendationCriteria(LeadID, CollegeID);
            templateText += "<table class='tableCriteria'>";

            foreach (GetVeteranLeadRecommendationCriteriaResult items in exhibits)
            {
                templateText += "<tr>";
                templateText += String.Format("<td>{0}</td>", items.Criteria);
                templateText += "</tr>";
            }

            templateText += "</table>";
            return templateText;
        }

        public static string GenerateProgramCoursesHTML(int LeadId, int CollegeID)
        {
            NORCODataContext norco_db = new NORCODataContext();
            string templateText = "";
            double totalUnits = 0;
            var courseList = norco_db.GetProgramCourses(LeadId, CollegeID).ToList();
            if (courseList.Count > 0 )
            {
                //templateText = "<table class='tableProgramCourses'><tr style='font-weight:bold;'><td>Program of Study</td><td>Course Title</td><td>Units</td></tr>";
                //templateText = "<table class='tableProgramCourses'><tr style='font-weight:bold;'><td>Course Title</td><td>MCR Code</td><td>Units</td></tr>";
                templateText = "<table class='tableProgramCourses'><tr style='font-weight:bold;'><td>Course Title</td><td style='text-align:center;'>Units</td></tr>";
                foreach (GetProgramCoursesResult item in courseList)
                {
                    templateText += "<tr>";
                    //templateText += String.Format("<td>{0}</td>", item.program);
                    templateText += String.Format("<td>{0}</td>", item.CourseTitle);
                    //templateText += String.Format("<td>{0}</td>", item.PublishedCode);
                    templateText += String.Format("<td style='text-align:center;'>{0}</td>", item.vunits);
                    templateText += "</tr>";
                    totalUnits += Convert.ToDouble(item.vunits);
                }
                templateText += String.Format("<tr style='font-weight:bold;'><td colspan='1' style='text-align:right;'>Total Units : </td><td style='text-align:center;'>{0}</td></tr></table>", string.Format("{0:F1}", totalUnits )  );
            } else
            {
                templateText += Resources.Messages.NoRecordsFound;
            }
            return templateText;
        }

        public static int HaveArticulationCourses ( string AceID, DateTime TeamRevd, int CollegeID)
        {
            NORCODataContext norco_db = new NORCODataContext();
            Int32 _haveArticulations = 0;
            var _records = norco_db.CourseHaveArticulation(AceID, TeamRevd, CollegeID);
            foreach (CourseHaveArticulationResult ha in _records)
            {
                _haveArticulations = Convert.ToInt32(ha.Exist);
            }
            return _haveArticulations;
        }

        public static int HaveOccupations(string AceID, DateTime TeamRevd)
        {
            NORCODataContext norco_db = new NORCODataContext();
            Int32 _haveOccupations = 0;
            var _records = norco_db.CourseHaveOccupations(AceID, TeamRevd);
            foreach (CourseHaveOccupationsResult ha in _records)
            {
                _haveOccupations = Convert.ToInt32(ha.Exist);
            }
            return _haveOccupations;
        }

        public static string FindSimilarities(int? program_id, int matching_factor, int compareType, int? outline_id )
        {
            NORCODataContext norco_db = new NORCODataContext();
            List<string> wordsToRemove = "and of for to the or by".Split(' ').ToList();
            string coursesString = "";
            if (program_id != null)
            {
                coursesString = norco_db.GetProgramCoursesString(program_id) ?? "";
            } else
            {
                coursesString = norco_db.GetCourseString(outline_id) ?? "";
            }
            if (coursesString.Length > 0)
            {
                string result = string.Join(" ", coursesString.Split(' ').Distinct());
                result = string.Join(" ", result.Split(' ').Except(wordsToRemove));
                string[] courseWords = result.Split(' ');
                string[] aceCourseWords = null;
                List<string> AceCourseIDList = new List<string>();

                var aceCourses = norco_db.GetAceCourses(compareType);

                foreach (GetAceCoursesResult a in aceCourses)
                {
                    aceCourseWords = a.title.Split(' ');
                    var matches = courseWords.Intersect(aceCourseWords).Count();
                    if (matches > 0)
                    {
                        switch (matching_factor)
                        {
                            case 1:
                                if (matches >= 1)
                                {
                                    AceCourseIDList.Add(a.id.ToString());
                                }
                                break;
                            case 2:
                                if (matches >= 2)
                                {
                                    AceCourseIDList.Add(a.id.ToString());
                                }
                                break;
                            case 3:
                                if (matches >= 3)
                                {
                                    AceCourseIDList.Add(a.id.ToString());
                                }
                                break;
                            default:
                                break;
                        }

                    }
                }

                return String.Join(",", AceCourseIDList);
            }
            else
            {
                return "";
            }

        }

        public static RadWindow CreateRadWindow(string _navigateUrl, bool _visibleOnPageLoad, bool _modal, bool _visibleStatusBar, int _width, int _height)
        {
            RadWindow window1 = new RadWindow();
            Random rand = new Random();
            window1.NavigateUrl = _navigateUrl;
            window1.VisibleOnPageLoad = _visibleOnPageLoad;
            window1.Modal = _modal;
            window1.VisibleStatusbar = _visibleStatusBar;
            window1.ID = string.Format("RadWindow{0}", rand.Next(100,100000)) ;
            window1.Width = _width;
            window1.Height = _height;
            window1.CenterIfModal = true;
            return window1;
        }
        public static bool IsNumeric(string s)
        {
            foreach (char c in s)
            {
                if (!char.IsDigit(c) && c != '.')
                {
                    return false;
                }
            }

            return true;
        }

        public static HtmlLink CreateCssLink(string cssFilePath, string media)
        {
            var link = new HtmlLink();
            link.Attributes.Add("type", "text/css");
            link.Attributes.Add("rel", "stylesheet");
            link.Href = link.ResolveUrl(cssFilePath);
            if (string.IsNullOrEmpty(media))
            {
                media = "all";
            }

            link.Attributes.Add("media", media);
            return link;
        }

        public static string ReadSetting(string key)
        {
            var appSettings = ConfigurationManager.AppSettings;
            return appSettings[key] ?? string.Empty;
        }

        public static string GetDatabaseSetting(string settingName)
        {
            var settingValue = "";
            var result = Database.ExecuteStoredProcedure("spSetting_GetSetting", new SqlParameter[] { new SqlParameter("Name", settingName) });
            if (result.Rows.Count > 0)
            {
                settingValue = result.Rows[0]["Value"].ToString();
            }
            return settingValue;
        }

        public static bool SendEmail(string _subject, string _body, string _from, string _to, string _cc, bool _isBodyHtml)
        {
            MailMessage msg = new MailMessage();
            msg.From = new MailAddress(_from);
            msg.To.Add(_to);
            msg.CC.Add(_cc);
            msg.Subject = _subject;
            msg.Body = _body;
            msg.IsBodyHtml = _isBodyHtml;
            //SmtpClient client = new SmtpClient();
            //client.Port = Convert.ToInt32(GlobalUtil.ReadSetting("EmailPort"));
            //System.Net.NetworkCredential basicAuthenticationInfo = new System.Net.NetworkCredential(GlobalUtil.ReadSetting("NetworkCredentialUser"), GlobalUtil.Decrypt(GlobalUtil.ReadSetting("NetworkCredentialPassword")));
            //client.Host = GlobalUtil.ReadSetting("EmailHost");
            ////client.UseDefaultCredentials = true;
            ////client.Credentials = basicAuthenticationInfo;
            //client.EnableSsl = false;
            var smtpClient = new SmtpClient("usm105.siteground.biz")
            {
                Port = Convert.ToInt32(GlobalUtil.ReadSetting("EmailPort")),
                Credentials = new NetworkCredential("mapadmin@mappingarticulatedpathways.org", "KTpIvIRFAWFH0+B4//LFIj9TK/JRSh240gQ8OeAFMR0="),
                EnableSsl = false,
            };
            
            try
            {
                //client.Send(msg);
                smtpClient.Send(msg);
                return true;
            }
            catch (Exception ex)
            {
                var mes = ex.ToString();
                return false;
            }
        }

        public static bool SendEmail(string _subject, string _body, string _from, string _to, string _cc, bool _isBodyHtml, Attachment attachment)
        {
            MailMessage msg = new MailMessage();
            msg.From = new MailAddress(_from);
            msg.To.Add(_to.Replace(';',','));
            if (!String.IsNullOrWhiteSpace(_cc))
            {
                msg.CC.Add(_cc);
            }
            msg.Subject = _subject;
            msg.Body = _body;
            msg.IsBodyHtml = _isBodyHtml;
            msg.Attachments.Add(attachment);
            var smtpClient = new SmtpClient("usm105.siteground.biz")
            {
                Port = Convert.ToInt32(GlobalUtil.ReadSetting("EmailPort")),
                Credentials = new NetworkCredential("mapadmin@mappingarticulatedpathways.org", "KTpIvIRFAWFH0+B4//LFIj9TK/JRSh240gQ8OeAFMR0="),
                EnableSsl = false,
            };

            try
            {
                //client.Send(msg);
                smtpClient.Send(msg);
                return true;
            }
            catch (Exception ex)
            {
                var mes = ex.ToString();
                return false;
            }
        }

        public static string GetAppUrl()
        {
            var oRequest = System.Web.HttpContext.Current.Request;
            return oRequest.Url.GetLeftPart(System.UriPartial.Authority)
                + System.Web.VirtualPathUtility.ToAbsolute("~/");

        }

        public static void NotifyNewArticulations(int UserID, int CollegeID, int outline_id, string from )
        {
            // Generic email when adding new articulation
            NORCODataContext norco_db = new NORCODataContext();
            string subject = "New Articulations";
            var courseTitle = norco_db.GetCourseTitle(outline_id, CollegeID);
            var content =  String.Format("New articulation(s) were added to {0}", courseTitle);
            var userData = norco_db.GetUserDataByID(UserID);
            var userEmail = "";
            foreach (GetUserDataByIDResult item in userData)
            {
                userEmail = item.Email;
            }
            //GlobalUtil.SendEmail(subject, content, GlobalUtil.ReadSetting("SystemNotificationEmail"), userEmail, from, true);
        }

        public static void NotifyToFacultyArticulations(int UserID, int CollegeID, int outline_id, string from)
        {
            // Faculty users get a notification when a new articulation is added
            NORCODataContext norco_db = new NORCODataContext();
            string subject = "New Articulations to Review";
            var courseTitle = norco_db.GetCourseTitle(outline_id, CollegeID);
            var reviewArticulationUrl = norco_db.GetReviewArticulationUrl(Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
            var content = "";
            var url = "";
            var reviewUsers = norco_db.GetReviewArticulationUsers(outline_id, CollegeID);
            foreach (GetReviewArticulationUsersResult item in reviewUsers)
            {
                url = string.Format("{0}?username={1}", reviewArticulationUrl, item.UserName);
                content = String.Format("New articulation(s) were added to {0} <br><br>Please follow this link to revise the articulation that are due for you to review : <br><br> {1}{2}", courseTitle, GetAppUrl(), url);
                //GlobalUtil.SendEmail(subject, content, from, item.Email, from, true);
            }
        }

        //public static void NotifySubmitArticulation(int Direction, int CollegeID, string EventDescription, int StageId, string Subject, string From, int outline_id, int articulation_id, int articulation_type, string AceID, DateTime TeamRevd, string Title)
        //{
        //    NORCODataContext norco_db = new NORCODataContext();
        //    var UserCanReviewArticulations = 0;
        //    var courseTitle = norco_db.GetCourseTitle(outline_id, CollegeID);
        //    //var reviewArticulationUrl = norco_db.GetReviewArticulationUrl(Convert.ToInt32(GlobalUtil.ReadSetting("AppID")));
        //    var reviewArticulationUrl = "";
        //    if (articulation_type == 1)
        //    {
        //        reviewArticulationUrl = string.Format("modules/popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true",articulation_id, outline_id, AceID, Title, TeamRevd.ToString());
        //    } else
        //    {
        //        reviewArticulationUrl = string.Format("modules/popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", articulation_id, outline_id, AceID, Title, TeamRevd.ToString());
        //    }
        //    //
        //    var content = "";
        //    var url = "";
        //    UserCanReviewArticulations = norco_db.UserCanReviewArticulations(StageId);
        //    if (UserCanReviewArticulations == 1)
        //    {
        //        //398-405 lines uncommented to test email...
        //        Subject = "New Articulations to Review";
        //        var reviewUsers = norco_db.GetReviewArticulationUsers(outline_id, CollegeID);
        //        foreach (GetReviewArticulationUsersResult item in reviewUsers)
        //        {
        //            url = string.Format("{0}/modules/security/Login.aspx?ReturnUrl={1}{2}?username={3}", GetAppUrl(), GetAppUrl(), HttpUtility.UrlEncode(reviewArticulationUrl), item.UserName);
        //            content = String.Format("New articulation(s) were added to {0} <br><br>Please follow this link to revise the articulation that are due for you to review : <br><br> <a href='{1}'>Click here to open Articulation.</a>", courseTitle, url);
        //            //GlobalUtil.SendEmail(Subject, content, From, item.Email, From, true);
        //        }
        //    }
        //    else
        //    {
        //        var users = norco_db.GetUsersByStageID(CollegeID, StageId, outline_id);
        //        foreach (GetUsersByStageIDResult item in users)
        //        {
        //            //GlobalUtil.SendEmail(Subject, EventDescription, From, item.Email, From, true);
        //        }
        //    }

        //}

        public static void NotifyFacultyReview( int CollegeID, int StageId, string Subject, string From, int outline_id, string Title)
        {
            NORCODataContext norco_db = new NORCODataContext();
            var courseTitle = norco_db.GetCourseTitle(outline_id, CollegeID);
            var reviewArticulationUrl = norco_db.GetFacultyReviewArticulationUrl(StageId, CollegeID);
            var content = "";
            var url = "";
            Subject = "Faculty District Review";
            var reviewUsers = norco_db.GetFacultyDistrictReviewUsers(outline_id);
            foreach (GetFacultyDistrictReviewUsersResult item in reviewUsers)
            {
                url = string.Format("{0}?username={1}", reviewArticulationUrl, item.UserName);
                content = String.Format("New articulation(s) were added to {0} <br><br>Please follow this link to revise the articulation that are due for you to review : <br><br> <a href='{1}{2}'>Click here to open Articulation.</a>", courseTitle, GetAppUrl(), url);
                //GlobalUtil.SendEmail(Subject, content, From, item.Email, From, true);
            }
        }

        public static void NotifyOnPublish(string EventDescription, string Subject, string From, int outline_id, int user_id, int college_id, int action)
        {
            NORCODataContext norco_db = new NORCODataContext();
            var users = norco_db.GetUsersNotifyWhenPublish(outline_id, college_id, user_id, action);
            foreach (GetUsersNotifyWhenPublishResult item in users)
            {
                //GlobalUtil.SendEmail(Subject, EventDescription, From, item.Email, From, true);
            }
        }

        public static int CheckArticulationIsPendingApprovalWorkflow(int ArticulationID, int ArticulationType)
        {
            int pending = 0;
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckArticulationIsPendingApprovalWorkflow] ({0},{1});", ArticulationID, ArticulationType);
                    pending = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return pending;
        }
        public static int CheckMultipleRoles(int UserID)
        {
            int pending = 0;
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckMultipleRoles] ({0});", UserID);
                    pending = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return pending;
        }

        public static int CheckMultipleRoleIsFaculty(int UserID)
        {
            int pending = 0;
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckMultipleRoleIsFaculty] ({0});", UserID);
                    pending = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return pending;
        }

        public static DataTable GetDataTable(string query)
        {
            DataTable myDataTable = new DataTable();

            String ConnString = ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString;
            SqlConnection conn = new SqlConnection(ConnString);
            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = new SqlCommand(query, conn);

            conn.Open();
            try
            {
                adapter.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }

            return myDataTable;
        }

        private static void ConvertNullToDbNull(SqlParameter[] parameters)
        {
            if (parameters == null)
            {
                return;
            }
            foreach (SqlParameter p in parameters)
            {
                if (p.Value == null)
                {
                    p.Value = DBNull.Value;
                }
            }
        }
        public static DataTable GetDataTableWithParameters(string commandText, CommandType commandType, SqlParameter[] parameters)
        {
            ConvertNullToDbNull(parameters);
            DataTable dataTable = new DataTable();
            string connectionString = ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString;
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = commandType;
                    cmd.CommandText = commandText;
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dataTable);
                    }
                }
            }
            return dataTable;
        }
        public static bool CheckOccupationCodeExists(string occupation_code)
        {
            bool exists = false;
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckOccupationExist] ('{0}');", occupation_code);
                    exists = ((bool)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        public static int SubmitArticulation (int id, int user_id, string info, int college_id, int previous_stage, int outline_id, int direction, int articulation_id, int articulation_type, string AceID, DateTime TeamRevd, string Title)
        {
            NORCODataContext norco_db = new NORCODataContext();
            var currentStageID = 0;
            int createdBy = 0;
            var stageData = norco_db.GetArticulationByID(id);
            foreach (GetArticulationByIDResult item in stageData)
            {
                currentStageID = Convert.ToInt32(item.ArticulationStage);
            }
            var firstStage = norco_db.GetMinimumStageId(college_id);
            var new_stage_id = 0;
            if (previous_stage != 0)
            {
                new_stage_id = previous_stage;
            }
            var course = norco_db.GetCourseTitle(outline_id, college_id);
            var articulation_title = norco_db.GetArticulationTitle(articulation_id, articulation_type);
            string from = GlobalUtil.ReadSetting("SystemNotificationEmail");
            string subject = string.Format("MAP Articulation for  {0} / {1}  is in your Inbox", course, articulation_title);
            try
            {
                var submitted = norco_db.ApprovalArticulationWorkflow(outline_id, user_id, direction, info, college_id, new_stage_id, articulation_id, articulation_type);
                //var submitted = norco_db.MoveStage(outline_id, user_id, direction, info, college_id, new_stage_id, articulation_id, articulation_type);
                //foreach (MoveStageResult item in submitted)
                //{
                    //var stageIsFacultyReview = norco_db.CheckStageIsFacultyDistrictReview(new_stage_id);
                    //if (stageIsFacultyReview == true)
                    //{
                    //    GlobalUtil.NotifyFacultyReview( college_id, currentStageID, subject, from, outline_id,Title);
                    //} else
                    //{
                       // GlobalUtil.NotifySubmitArticulation(Convert.ToInt32(item.Direction), college_id, item.Event, Convert.ToInt32(item.NewStageId), subject, from, outline_id, articulation_id, articulation_type, AceID, TeamRevd, Title);
                    //}
                //}

                return 1;
            }
            catch (Exception ex)
            {
                return 0;
            }

        }

        public static DataTable GetSelectedArticulations(int college_id, int outline_id, string selected_criteria, bool only_implemented, bool subject_course_cidnumber, int exclude_years)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetAdoptCreditRecommendationArticulations", conn);
                cmd.Parameters.Add("@CollegeID", SqlDbType.Int).Value = college_id;
                cmd.Parameters.Add("@outline_id", SqlDbType.Int).Value = outline_id;
                cmd.Parameters.Add("@selected_criteria", SqlDbType.VarChar).Value = selected_criteria;
                cmd.Parameters.Add("@OnlyImplemented", SqlDbType.Bit).Value = only_implemented;
                cmd.Parameters.Add("@BySubjectCourseNumberorCIDNumber", SqlDbType.Bit).Value = subject_course_cidnumber;
                cmd.Parameters.Add("@ExcludeArticulationOverYears", SqlDbType.Int).Value = exclude_years;
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

        public static DataTable GetAdoptSelectedArticulations(string articulations)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetSelectedAdoptCreditRecommendationArticulations", conn);
                cmd.Parameters.Add("@Articulations", SqlDbType.VarChar).Value = articulations;
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

        public static void DeleteArticulation(int id, int user_id)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("spDeleteArticulation", conn);
                cmd.Parameters.Add("@ID", SqlDbType.Int).Value = id;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = user_id;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
            }
        }


public static bool CheckCourseExistsInCollege(int college_id, string subject, string course_number, string cid_number)
        {
            bool exists = false;
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckCourseExistsInCollege] ({0},'{1}','{2}','{3}');", college_id, subject, course_number, cid_number);
                    exists = ((bool)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }
        public static string Encrypt(string clearText)
        {
            string EncryptionKey = "ITKV2SPPII99212";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        public static string Decrypt(string cipherText)
        {
            string EncryptionKey = "ITKV2SPPII99212";
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }

    }
}