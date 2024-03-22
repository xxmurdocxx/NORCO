using Microsoft.VisualBasic.FileIO;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using Telerik.Web.UI;

namespace ems_app.modules.settings
{
    public partial class UpdateCid : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                var rsm = (RadScriptManager)Master.FindControl("RadScriptManager1");
                rsm.AsyncPostBackTimeout = 7200;
            }
            pnlError.Visible = false;
            pnlWarning.Visible = false;
            pnlSuccess.Visible = false;
        }

        protected void rauUploadFile_FileUploaded(object sender, Telerik.Web.UI.FileUploadedEventArgs e)
        {
            var rauUploadFile = (RadAsyncUpload)sender;
            if (rauUploadFile.UploadedFiles.Count == 0)
            {
                lblErrorMessage.Text = "No file was uploaded, please try again";
                return;
            }

            var file = ((FileUploadedEventArgs)e).File;
            string csvPath = Server.MapPath("~/UploadedFiles/") + file.GetNameWithoutExtension() + "_" + Guid.NewGuid().ToString("N") + file.GetExtension();
            file.SaveAs(csvPath);

            ProcessUpload(csvPath);
        }

        private void ProcessUpload(string csvPath)
        {
            try
            {
                Dictionary<string, int> columns = new Dictionary<string, int>();
                columns.Add("C-ID #", 0);
                columns.Add("C-ID Descriptor", 1);
                columns.Add("Institution", 2);
                columns.Add("Institution type", 3);
                columns.Add("Local Course Title(s)", 4);
                columns.Add("Local Dept. Name & Number", 5);
                columns.Add("Approval date", 6);
                columns.Add("COR effective term", 7);

                var notMatchedCourses = new List<string>();
                var notMatchedColleges = new List<string>();

                using (TextFieldParser parser = new TextFieldParser(csvPath, Encoding.UTF8))
                {
                    parser.TextFieldType = FieldType.Delimited;
                    parser.SetDelimiters(",");
                    
                    int i = 1;
                    while (!parser.EndOfData)
                    {
                        string[] cells = parser.ReadFields();
                        // validate header row
                        if (i == 1)
                        {
                            if (!ValidateHeaders(cells, columns.Keys.ToArray()))
                            {
                                lblErrorMessage.Text = "The file provided does not match the sample file format, please check the format and try again.";
                                pnlError.Visible = true;
                                return;
                            }
                            i++;
                            continue;
                        }

                        if (chkUpdateMasterCidList.Checked)
                        {
                            UpdateMasterCid(cells);
                        }
                        var masterCidId = GetMasterCid(cells[columns["C-ID #"]], cells[columns["Institution"]], cells[columns["Local Dept. Name & Number"]]);

                        if (masterCidId == 0)
                        {
                            lblErrorMessage.Text = "Unable to retrieve master CID id for CID " + cells[columns["C-ID #"]] + " (line " + i.ToString() + ")";
                            pnlError.Visible = true;
                            return;
                        }

                        var collegeNameSplit = cells[columns["Institution"]].Split(new string[] { " + " }, StringSplitOptions.None);
                        for (int j = 0; j <= collegeNameSplit.GetUpperBound(0); j++)
                        {
                            var collegeId = GetCollegeId(collegeNameSplit[j], out bool isInCohort);
                            if (collegeId == 0)
                            {
                                if (!notMatchedColleges.Contains(collegeNameSplit[j]))
                                {
                                    notMatchedColleges.Add(collegeNameSplit[j]);
                                }
                                continue;
                            }
                            else if (!isInCohort)
                            {
                                // skip colleges not in cohort since they will not have any courses loaded
                                continue;
                            }
                            var courseSplit = cells[columns["Local Dept. Name & Number"]].Split(new string[] { " + " }, StringSplitOptions.None);
                            for (int k = 0; k <= courseSplit.GetUpperBound(0); k++)
                            {
                                var issuedFormId = GetCourseIssuedFormId(courseSplit[k].Replace("  ", " "), collegeId);
                                if (issuedFormId == 0)
                                {
                                    if (!notMatchedCourses.Contains(collegeNameSplit[j] + " " + courseSplit[k]))
                                    { 
                                        notMatchedCourses.Add(collegeNameSplit[j] + " " + courseSplit[k]);
                                    }
                                    continue;
                                }

                                UpdateCidProperties(issuedFormId, masterCidId);
                            }
                        }

                        i++;
                    }
                }

                if (notMatchedColleges.Count > 0)
                {
                    lblWarningMessage.Text = "No updates were performed for the following colleges because they were not found in MAP:\r\n" + string.Join("\r\n", notMatchedColleges);
                    pnlWarning.Visible = true;
                }
                if (notMatchedCourses.Count > 0)
                {
                    lblWarningMessage.Text += "\r\nNo updates were performed for the following courses because they were not found in MAP:\r\n" + string.Join("\r\n", notMatchedCourses);
                    pnlWarning.Visible = true;
                }

                lblSuccessMessage.Text = "Your upload has completed.";
                pnlSuccess.Visible = true;
                File.Delete(csvPath);
            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = "The following error occurred: " + ex.Message;
                pnlError.Visible = true;
            }
        }


        private DataTable GetDataTable(string commandText, CommandType commandType, SqlParameter[] parameters)
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


        private int GetCourseIssuedFormId(string course, int collegeId)
        {
            int issuedFormId = 0;
            var courseSplit = course.Split(' ');
            if (courseSplit.GetUpperBound(0) == 1)
            {
                var subject = courseSplit[0].Trim();
                var courseNumber = courseSplit[1].Trim();

                var parameters = new SqlParameter[]
                {
                            new SqlParameter("@Subject", subject),
                            new SqlParameter("@CourseNumber", courseNumber),
                            new SqlParameter("@CollegeId", collegeId)
                };
                var sql = "SELECT IssuedFormID FROM Course_IssuedForm INNER JOIN tblSubjects ON Course_IssuedForm.subject_id = tblSubjects.subject_id WHERE tblSubjects.subject = @Subject AND Course_IssuedForm.course_number = @CourseNumber AND Course_IssuedForm.college_id = @CollegeId AND Course_IssuedForm.status = 0";
                var dt = GetDataTable(sql, CommandType.Text, parameters);
                if (dt.Rows.Count > 0)
                {
                    issuedFormId = (int)dt.Rows[0]["IssuedFormId"];
                }
            }
            return issuedFormId;
        }

        private int GetCollegeId(string collegeName, out bool isInCohort)
        {
            int collegeId = 0;
            isInCohort = false;

            var parameters = new SqlParameter[]
            {
                new SqlParameter("@College", collegeName),
            };
            var sql = "SELECT LookupColleges.CollegeID, MapCohort.COLLEGE_NAME AS CollegeNameCohort FROM LookupColleges LEFT OUTER JOIN MapCohort ON LookupColleges.College = MapCohort.COLLEGE_NAME WHERE LookupColleges.College = @College";
            var dt = GetDataTable(sql, CommandType.Text, parameters);
            if (dt.Rows.Count > 0)
            {
                collegeId = (int)dt.Rows[0]["CollegeID"];
                if (dt.Rows[0]["CollegeNameCohort"] != DBNull.Value)
                {
                    isInCohort = true;
                }
            }

            return collegeId;
        }

        private void UpdateMasterCid(string[] cells)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("@CID", cells[0]),
                new SqlParameter("@CID_Descriptor", cells[1]),
                new SqlParameter("@Institution", cells[2]),
                new SqlParameter("@Institution_type", cells[3]),
                new SqlParameter("@Local_Course_Title", cells[4]),
                new SqlParameter("@Local_Dept_Name_Number", cells[5]),
                new SqlParameter("@Approval_date", cells[6]),
                new SqlParameter("@COR_effective_term", cells[7])
            };
            GetDataTable("UpdateMasterCID", CommandType.StoredProcedure, parameters);
            
        }

        private int GetMasterCid(string cid, string institution, string course)
        {
            int masterCidId = 0;
            var parameters = new SqlParameter[]
            {
                new SqlParameter("@CID", cid),
                new SqlParameter("@Institution", institution),
                new SqlParameter("@Local_Dept_Name_Number", course)
            };
            var sql = "SELECT TOP 1 id FROM MASTER_CID WHERE[C-ID] = @CID AND Institution = @Institution AND Local_Dept_Name_Number = @Local_Dept_Name_Number ORDER BY RIGHT(COR_effective_term, 4) DESC";
            var dt = GetDataTable(sql, CommandType.Text, parameters);
            if (dt.Rows.Count > 0)
            {
                masterCidId = (int)dt.Rows[0]["id"];
            }
            return masterCidId;
        }

        private void UpdateCidProperties(int issuedFormId, int masterCidId)
        {
            var parameters = new SqlParameter[]
                {
                    new SqlParameter("@IssuedFormId", issuedFormId),
                    new SqlParameter("@MasterCidId", masterCidId),
                    new SqlParameter("@UserID", (int)Session["UserID"])
                };
            GetDataTable("UpdateCIDProperties", CommandType.StoredProcedure, parameters);
        }

        private bool ValidateHeaders(string[] headerCells, string[] headerColumnNames)
        {
            if (headerCells.GetUpperBound(0) < headerColumnNames.GetUpperBound(0))
            {
                return false;
            }
            for (int i = 0; i < headerColumnNames.Length; i++)
            {
                if (headerCells[i].ToLower() != headerColumnNames[i].ToLower())
                {
                    return false;
                }
            }
            return true;

        }
    }
}