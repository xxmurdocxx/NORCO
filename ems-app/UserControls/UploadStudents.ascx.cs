using Microsoft.VisualBasic.FileIO;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Telerik.Web.UI;
using static ems_app.modules.military.StudentList;

namespace ems_app.UserControls
{
    public partial class UploadStudents : System.Web.UI.UserControl
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlWarning.Visible = false;
            pnlSuccess.Visible = false;
            pnlUpload.Style["display"] = "block";
            //rauUploadFile.OnClientFileUploaded = "function(button, args){enableSubmitButton_" + this.ClientID + "(button, args, '" + btnSubmitUpload.ClientID + "');}";
            // set the async postback timeout to 60 minutes in case uploading the file takes a long time
            var rsm = (RadScriptManager)Page.Master.FindControl("RadScriptManager1");
            rsm.AsyncPostBackTimeout = 3600;
        }

        public event EventHandler FileUploaded;

        public string SampleFilePath
        {
            get
            {
                return lnkSampleFile.NavigateUrl;
            }
            set
            {
                lnkSampleFile.NavigateUrl = value;
            }
        }

        public string ErrorMessage
        {
            get
            {
                return lblErrorMessage.Text;
            }
            set
            {
                lblErrorMessage.Text = value;
                pnlError.Visible = true;
            }
        }

        public string WarningMessage
        {
            get
            {
                return lblWarningMessage.Text;
            }
            set
            {
                lblWarningMessage.Text = value;
                pnlWarning.Visible = true;
            }
        }

        public string SuccessMessage
        {
            get
            {
                return lblSuccessMessage.Text;
            }
            set
            {
                lblSuccessMessage.Text = value;
                pnlSuccess.Visible = true;
            }
        }


        public bool DeleteAndReplaceWarning
        {
            get
            {
                return pnlDeleteAndReplaceWarning.Visible;
            }
            set
            {
                pnlDeleteAndReplaceWarning.Visible = value;
            }
        }

        public bool ShowPanel
        {
            get
            {
                return pnlUpload.Visible;
            }
            set
            {
                pnlUpload.Visible = value;
            }
        }

        protected void radUpload_CheckedChanged(object sender, EventArgs e)
        {
            pnlEdit.Visible = false;
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


        protected void rauUploadFile_FileUploaded(object sender, Telerik.Web.UI.FileUploadedEventArgs e)
        {

        }

        protected void btnSubmitUpload_Click(object sender, EventArgs e)
        {
            if (rauUploadFile.UploadedFiles.Count == 0)
            {
                this.ErrorMessage = "No file was uploaded, please try again";
                return;
            }

            foreach (UploadedFile files in rauUploadFile.UploadedFiles)
            {
                try
                {
                    string csvPath = Server.MapPath("~/UploadedFiles/") + files.GetNameWithoutExtension() + "_" + Guid.NewGuid().ToString("N") + files.GetExtension();
                    files.SaveAs(csvPath);
                    var veteran_id = 0;
                    int student_added = 0;
                    int student_found = 0;
                    int exhibit_added = 0;
                    int exhibit_not_found = 0;

                    Dictionary<string, int> columns = new Dictionary<string, int>();
                    columns.Add("LastName", 0);
                    columns.Add("FirstName", 1);
                    columns.Add("StudentID", 2);
                    columns.Add("Email", 3);
                    columns.Add("Phone", 4);
                    columns.Add("Service", 5);
                    columns.Add("MAPID", 6);
                    columns.Add("CPLType", 7);

                    var notMatched = new StringBuilder();
                    using (TextFieldParser parser = new TextFieldParser(csvPath))
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
                                    ErrorMessage = "The file provided does not match the sample file format, please check the format and try again.";
                                    return;
                                }
                                i++;
                                continue;
                            }
                            var map_id = cells[columns["MAPID"]];
                            var email = cells[columns["Email"]];
                            var last_name = cells[columns["LastName"]];
                            var first_name = cells[columns["FirstName"]];
                            var student_id = cells[columns["StudentID"]];
                            var phone = cells[columns["Phone"]];
                            var cpl_type = cells[columns["CPLType"]];
                            var service = cells[columns["Service"]];
                            var lookup = new Common.models.GenericLookup();
                            var serviceID = lookup.GetServiceIDByDescription(service);
                            var notes = string.Empty;
                            DateTime? start_date = null;
                            DateTime? end_date = null;
                            if (last_name.Length > 0)

                            {
                                var veteran_exists = CheckVeteranAndIDExists(first_name, last_name, Convert.ToInt32(Session["CollegeID"]), student_id);
                                if (veteran_exists > 0)
                                {
                                    notes = "Student updated by batch upload (Name/StudentID match)";
                                }
                                else
                                {
                                    notes = "Student updated by batch upload (Name only match)";
                                    veteran_exists = CheckVeteranExists(first_name, last_name, Convert.ToInt32(Session["CollegeID"]));
                                }


                                if (veteran_exists == 0)
                                {
                                    veteran_id = AddVeteran(first_name, string.Empty, last_name, student_id, phone, email, serviceID == null ? 7 : serviceID, 1, cpl_type, null, Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["UserID"]), "Student created by batch upload.");
                                    student_added++;
                                    ExhibitInfo exhibitInfo = GetExhibitInfo(map_id, Convert.ToInt32(Session["CollegeID"]));

                                    if (exhibitInfo != null)
                                    {
                                        if (exhibitInfo.StartDate != "")
                                        {
                                            start_date = Convert.ToDateTime(exhibitInfo.StartDate);
                                        }
                                        if (exhibitInfo.EndDate != "")
                                        {
                                            end_date = Convert.ToDateTime(exhibitInfo.EndDate);
                                        }
                                        else
                                        {
                                            end_date = null;
                                        }
                                        var veteran_exhibit_exists = CheckVeteranExhibitExists(exhibitInfo.ExhibitID, veteran_id);
                                        if (veteran_exhibit_exists == 0)
                                        {
                                            AddVeteranExhibit(map_id, exhibitInfo.TeamRevd, start_date, start_date, veteran_id, exhibitInfo.ExhibitID, Convert.ToInt32(Session["CollegeID"]));
                                            exhibit_added++;
                                        }
                                    }
                                    else
                                    {
                                        exhibit_not_found++;
                                    }
                                }
                                else
                                {
                                    student_found++;
                                    UpdateVeteran(veteran_exists, phone, email, serviceID, student_id, notes, Convert.ToInt32(Session["UserID"]));
                                    ExhibitInfo exhibitInfo = GetExhibitInfo(map_id, Convert.ToInt32(Session["CollegeID"]));
                                    if (exhibitInfo != null)
                                    {
                                        if (exhibitInfo.StartDate != "")
                                        {
                                            start_date = Convert.ToDateTime(exhibitInfo.StartDate);
                                        }
                                        if (exhibitInfo.EndDate != "")
                                        {
                                            end_date = Convert.ToDateTime(exhibitInfo.EndDate);
                                        }
                                        else
                                        {
                                            end_date = null;
                                        }
                                        var veteran_exhibit_exists = CheckVeteranExhibitExists(exhibitInfo.ExhibitID, veteran_exists);
                                        if (veteran_exhibit_exists == 0)
                                        {
                                            AddVeteranExhibit(map_id, exhibitInfo.TeamRevd, start_date, start_date, veteran_exists, exhibitInfo.ExhibitID, Convert.ToInt32(Session["CollegeID"]));
                                            exhibit_added++;
                                        }
                                    }
                                    else
                                    {
                                        exhibit_not_found++;
                                    }
                                }
                            }


                            i++;
                        }
                    }
                    if (student_added > 0 || student_found > 0 || exhibit_added > 0 || exhibit_not_found > 0)
                    {
                        notMatched.AppendLine($"- {student_added} Students were added successfully");
                        notMatched.AppendLine($"- {student_found} Students already exists in MAP");
                        notMatched.AppendLine($"- {exhibit_added} Exhibits were added successfully");
                        notMatched.AppendLine($"- {exhibit_not_found} Exhibits were not added successfully");
                        WarningMessage = "<h3>Summary : </h3>" + notMatched.ToString();
                    }
                    SuccessMessage = "Your upload has completed.";
                    File.Delete(csvPath);
                    pnlUpload.Style["display"] = "none";
                }
                catch (Exception ex)
                {
                    ErrorMessage = "The following error occurred: " + ex.Message;
                }
            }
            FileUploaded(sender, e);
        }
    }
}