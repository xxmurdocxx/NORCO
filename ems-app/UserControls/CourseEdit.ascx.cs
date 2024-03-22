using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Text;
using Telerik.Web.UI;

namespace ems_app.UserControls
{
    public partial class CourseEdit : System.Web.UI.UserControl
    {
        private bool _readOnly;

        protected void Page_Load(object sender, EventArgs e)
        {
            rgCourses.MasterTableView.CommandItemSettings.ShowAddNewRecordButton = false;
        }

        public bool ReadOnly
        {
            get
            {
                return _readOnly;
            }
            set
            {
                _readOnly = value;
                if (_readOnly)
                {
                    rgCourses.MasterTableView.CommandItemSettings.ShowAddNewRecordButton = false;
                    rgCourses.MasterTableView.CommandItemSettings.ShowSaveChangesButton = false;
                    rgCourses.MasterTableView.CommandItemSettings.ShowCancelChangesButton = false;
                }
                else
                {
                    rgCourses.MasterTableView.CommandItemSettings.ShowAddNewRecordButton = true;
                    rgCourses.MasterTableView.CommandItemSettings.ShowSaveChangesButton = true;
                    rgCourses.MasterTableView.CommandItemSettings.ShowCancelChangesButton = true;
                }
            }
        }

        public void Rebind()
        {
            rgCourses.Rebind();
        }

        protected void radCourseFilter_CheckedChanged(object sender, EventArgs e)
        {
            if (radCourseFilterAll.Checked)
            {
                sqlCourses.SelectParameters["FilterStatus"].DefaultValue = "-1";
                rgCourses.MasterTableView.CommandItemSettings.ShowAddNewRecordButton = false;
            }
            else if (radCourseFilterOfficial.Checked)
            {
                sqlCourses.SelectParameters["FilterStatus"].DefaultValue = "0";
                rgCourses.MasterTableView.CommandItemSettings.ShowAddNewRecordButton = false;
            }
            else if (radCourseFilterElective.Checked)
            {
                sqlCourses.SelectParameters["FilterStatus"].DefaultValue = "1";
                rgCourses.MasterTableView.CommandItemSettings.ShowAddNewRecordButton = true;
            }
            else if (radCourseFilterAreaCredit.Checked)
            {
                sqlCourses.SelectParameters["FilterStatus"].DefaultValue = "2";
                rgCourses.MasterTableView.CommandItemSettings.ShowAddNewRecordButton = true;
            }
            rgCourses.Rebind();
        }

        protected void rgCourses_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                //var courseStatus = (Byte)dataItem.GetDataKeyValue("status"); Elective courses will be filtered by subject
                var courseStatus = (string)dataItem.GetDataKeyValue("subject");
                var courseType = (int)dataItem.GetDataKeyValue("CourseType");
                // if this is an elective course created by the user, all fields are editable
                //if (courseStatus == 1)
                if (courseStatus == "RCCD GE-A" | courseStatus == "RCCD GE-B1" | courseStatus == "RCCD GE-B2" | courseStatus == "RCCD GE-C" | courseStatus == "RCCD GE-D1" | courseStatus == "RCCD GE-D2" | courseStatus == "RCCD MATH" | courseStatus == "MIL-PE" | courseStatus == "MIL-HES" | courseStatus == "CPL" | courseStatus == "MIL-SD")
                    {
                    dataItem["subject_id"].BackColor = Color.LightYellow;
                    dataItem["course_number"].BackColor = Color.LightYellow;
                    dataItem["course_title"].BackColor = Color.LightYellow;
                    dataItem["unit_id"].BackColor = Color.LightYellow;
                    dataItem["CatalogDescription"].BackColor = Color.LightYellow;
                    dataItem["topscode_id"].BackColor = Color.LightYellow;
                    dataItem["comments"].BackColor = Color.LightYellow;
                }
                else
                {
                    dataItem["CatalogDescription"].BackColor = Color.LightYellow;
                }
                if (courseType == 2)
                {
                    dataItem["unit_id"].BackColor = Color.LightYellow;
                }
            }
        }


        protected void rgCourses_BatchEditCommand(object sender, GridBatchEditingEventArgs e)
        {
            lblError.Text = "";
            pnlError.Visible = false;

            var existingCourses = new StringBuilder();
            foreach (GridBatchEditingCommand command in e.Commands)
            {
                Hashtable newValues = command.NewValues;
                Hashtable oldValues = command.OldValues;

                int collegeId = (int)Session["CollegeID"];
                int userId = (int)Session["UserID"];

                int subjectId = (int)newValues["subject_id"];
                string courseNumber = newValues["course_number"]?.ToString();
                string courseTitle = newValues["course_title"]?.ToString();
                int? unitId = GetNullableInt(newValues["unit_id"]);
                string comments = newValues["comments"]?.ToString();
                string catalogDescription = newValues["CatalogDescription"]?.ToString();
                int? topsCodeId = GetNullableInt(newValues["topscode_id"]);
                
                if (command.Type == GridBatchEditingCommandType.Insert)
                {
                    var existingCourseName = CourseExists(collegeId, subjectId, courseNumber);
                    if (existingCourseName != null)
                    {
                        existingCourses.AppendLine(existingCourseName);
                    }
                    else
                    {
                        InsertCourse(collegeId, userId, subjectId, courseNumber, courseTitle, unitId, comments, catalogDescription, topsCodeId);
                    }
                }
                else if (command.Type == GridBatchEditingCommandType.Update)
                {
                    int outlineId = (int)newValues["outline_id"];
                    
                    int subjectIdOld = (int)oldValues["subject_id"];
                    string courseNumberOld = oldValues["course_number"].ToString();

                    var skipUpdate = false;
                    if (subjectIdOld != subjectId || courseNumberOld != courseNumber)
                    {
                        var existingCourseName = CourseExists(collegeId, subjectId, courseNumber);
                        if (existingCourseName != null)
                        {
                            existingCourses.AppendLine(existingCourseName);
                            skipUpdate = true;
                        }
                    }
                    if (!skipUpdate)
                    {
                        UpdateCourse(outlineId, subjectId, courseNumber, courseTitle, unitId, comments, catalogDescription, topsCodeId, userId);
                    }
                }
            }

            if (existingCourses.Length > 0)
            {
                lblError.Text = "The following courses were not updated because it would create a duplicate course:\r\n" + existingCourses.ToString();
                pnlError.Visible = true;
            }

            rgCourses.Rebind();
        }

        private string CourseExists(int collegeId, int subjectId, string courseNumber)
        {
            string courseName = null;
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand("CheckCourseExists", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("CollegeID", collegeId));
                    cmd.Parameters.Add(new SqlParameter("subject_id", subjectId));
                    cmd.Parameters.Add(new SqlParameter("course_number", courseNumber));
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            courseName = dr["CourseName"].ToString();
                        }
                    }
                }
            }

            return courseName;
        }

        private void InsertCourse(int collegeId, int userId, int subjectId, string courseNumber, string courseTitle, int? unitId, string comments, string catalogDescription, int? topsCodeId)
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand("InsertCourse", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("subject_id", subjectId));
                    cmd.Parameters.Add(new SqlParameter("course_number", courseNumber));
                    cmd.Parameters.Add(new SqlParameter("course_title", courseTitle));
                    cmd.Parameters.Add(new SqlParameter("unit_id", unitId));
                    cmd.Parameters.Add(new SqlParameter("comments", comments));
                    cmd.Parameters.Add(new SqlParameter("college_id", collegeId));
                    cmd.Parameters.Add(new SqlParameter("author_user_id", userId));
                    cmd.Parameters.Add(new SqlParameter("CatalogDescription", catalogDescription));
                    cmd.Parameters.Add(new SqlParameter("topscode_id", topsCodeId));
                    ConvertNullToDbNull(cmd.Parameters);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateCourse(int outlineId, int subjectId, string courseNumber, string courseTitle, int? unitId, string comments, string catalogDescription, int? topsCodeId, int userId)
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand("UpdateCourse", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("outline_id", outlineId));
                    cmd.Parameters.Add(new SqlParameter("subject_id", subjectId));
                    cmd.Parameters.Add(new SqlParameter("course_number", courseNumber));
                    cmd.Parameters.Add(new SqlParameter("course_title", courseTitle));
                    cmd.Parameters.Add(new SqlParameter("unit_id", unitId));
                    cmd.Parameters.Add(new SqlParameter("comments", comments));
                    cmd.Parameters.Add(new SqlParameter("CatalogDescription", catalogDescription));
                    cmd.Parameters.Add(new SqlParameter("topscode_id", topsCodeId));
                    cmd.Parameters.Add(new SqlParameter("UserID", userId));
                    ConvertNullToDbNull(cmd.Parameters);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private static void ConvertNullToDbNull(SqlParameterCollection parameters)
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

        private static int? GetNullableInt(object value)
        {
            if (value == null)
            {
                return null;
            }
            else
            {
                if (int.TryParse(value.ToString(), out int i))
                {
                    return i;
                }
                return null;
            }
        }
        

        private static void DisplayParameters(DbParameterCollection parameters)
        {
            foreach (DbParameter p in parameters)
            {
                Debug.WriteLine("{0} / {1} / {2}",
                    p.ParameterName, p.Value ?? "", p.GetType().Name);
            }
        }

        

        
    }
}