using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using ITPI.JSTranscriptPDFReader.AzureComputerVision;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using DocumentFormat.OpenXml.Bibliography;
using System.Web.UI.HtmlControls;
using DocumentFormat.OpenXml.Wordprocessing;
using CheckBox = System.Web.UI.WebControls.CheckBox;
using GridColumn = Telerik.Web.UI.GridColumn;
using Microsoft.VisualBasic.FileIO;
using static ems_app.modules.military.VeteranManagement;
using System.Text;


namespace ems_app.modules.military
{
    public partial class StudentList : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        int _VeteranID = 0;
        public class ExhibitInfo
        {
            public int ExhibitID { get; set; }
            public string AceID { get; set; }
            public DateTime TeamRevd { get; set; }
            public String StartDate { get; set; }
            public String EndDate { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
			if (!IsPostBack)
            {
                Session["PotentialStudent"] = 0;
                Session["CPLSearchUpload"] = 0;
                //Session["_CreditRecommendation"] = string.Empty;
                ucUploadStudents.SampleFilePath = "~/Common/sampleFiles/Students.csv?v=0";
                ucUploadStudents.DeleteAndReplaceWarning = false;
                pnlUpload.Style["display"] = "none";
                rbCloseUpload.Visible = false;
            } 
        }

        protected void rgStudents_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.CommandName == "btnEditStudent")
            {
                GridDataItem itemDetail = (GridDataItem)e.Item;
                Session["VeteranID"] = itemDetail["id"].Text;
                Session["EditStudent"] = "True";
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", string.Format("window.open('../military/Student.aspx?VeteranID={0}')", itemDetail["id"].Text), true);
            }
            if (e.CommandName == "ViewMilitarCredits")
            {
                GridDataItem itemDetail = (GridDataItem)e.Item;
                Session["VeteranID"] = itemDetail["id"].Text;
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('../military/MilitaryCredits.aspx')", true);
            }
            /* if (e.CommandName == "NewStudent")
            {
                Session["EditStudent"] = "False";
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('../military/Student.aspx')", true);
            }
            */
            if (e.CommandName == "UpdateStatus")
            {
                GridDataItem itemDetail = (GridDataItem)e.Item;
                switch (e.CommandArgument)
                {
                    case "EdPlan":
                        UpdateStudentStatus(Session["CollegeID"].ToString(), Session["UserID"].ToString(),"2", itemDetail["EdPlan"].Text=="True"?"0":"1", itemDetail["id"].Text);
                        break;
                    case "Analysis":
                        UpdateStudentStatus(Session["CollegeID"].ToString(), Session["UserID"].ToString(), "4", itemDetail["Analysis"].Text == "True" ? "0" : "1", itemDetail["id"].Text);
                        break;
                    case "Counselor":
                        UpdateStudentStatus(Session["CollegeID"].ToString(), Session["UserID"].ToString(), "6", itemDetail["Counselor"].Text == "True" ? "0" : "1", itemDetail["id"].Text);
                        break;
                    case "Student":
                        UpdateStudentStatus(Session["CollegeID"].ToString(), Session["UserID"].ToString(), "7", itemDetail["Student"].Text == "True" ? "0" : "1", itemDetail["id"].Text);
                        break;
                    case "Transcribed":
                        UpdateStudentStatus(Session["CollegeID"].ToString(), Session["UserID"].ToString(), "8", itemDetail["Transcribed"].Text == "True" ? "0" : "1", itemDetail["id"].Text);
                        break;
                    case "GlobalCR":
                        UpdateStudentStatus(Session["CollegeID"].ToString(), Session["UserID"].ToString(), "3", itemDetail["GlobalCR"].Text == "True" ? "0" : "1", itemDetail["id"].Text);
                        break;
                    case "Applied":
                        UpdateStudentStatus(Session["CollegeID"].ToString(), Session["UserID"].ToString(), "5", itemDetail["Applied"].Text == "True" ? "0" : "1", itemDetail["id"].Text);
                        break;
                    default:
                        break;
                }
                rgStudents.Rebind();
												   
            }
        }

        protected void rbScanJST_Click(object sender, EventArgs e)
        {

            //for each veteranID
            var dt = GlobalUtil.GetDataTable("SELECT id FROM Veteran order by id");
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)

                {
                    var VeteranID = dt.Rows[i].ItemArray[0].ToString();
                    var parameters = new SqlParameter[]
                    {
                        new SqlParameter("@VeteranID", VeteranID)
                    };

                    var dt2 = GlobalUtil.GetDataTableWithParameters("SELECT * FROM [dbo].[VeteranDocuments] WHERE [VeteranID] = @VeteranID AND [Field] = 'student_joint_services' ORDER BY [id] DESC", CommandType.Text, parameters);


                    if (dt2.Rows.Count > 0)
                    {
                        byte[] fileBytes = (byte[])dt2.Rows[0]["BinaryData"];
                        var VeteranDocumentID = (int)dt2.Rows[0]["id"];
                        Stream outStream = new MemoryStream(fileBytes);
                        TelerikPDF.Redaction pdf = new TelerikPDF.Redaction();

                        var valid = pdf.IsValidPDFFormatForScan(outStream);
                        switch (valid)
                        {
                            case 0:
                                //image file, update valid PDF flag in veteran document table = false
                                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                                {
                                    SqlCommand cmd = new SqlCommand("UPDATE VeteranDocuments SET IsValidPdfFormat = 0 WHERE id = @VeteranDocumentID", conn);
                                    conn.Open();

                                    cmd.Parameters.Add("@VeteranDocumentID", SqlDbType.Int).Value = VeteranDocumentID;
                                    cmd.ExecuteNonQuery();
                                }
                                break;
                            case 1:
                                //unreadable, update valid PDF flag in veteran document table = false
                                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                                {
                                    SqlCommand cmd = new SqlCommand("UPDATE VeteranDocuments SET IsValidPdfFormat = 0 WHERE id = @VeteranDocumentID", conn);
                                    conn.Open();

                                    cmd.Parameters.Add("@VeteranDocumentID", SqlDbType.Int).Value = VeteranDocumentID;
                                    cmd.ExecuteNonQuery();
                                }
                                break;
                            case 2:
                                //found SSN, update valid PDF flag in veteran document table = false
                                //or multiple JST's in PDF(depending on scan)
                                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                                {
                                    SqlCommand cmd = new SqlCommand("UPDATE VeteranDocuments SET IsValidPdfFormat = 0 WHERE id = @VeteranDocumentID", conn);
                                    conn.Open();

                                    cmd.Parameters.Add("@VeteranDocumentID", SqlDbType.Int).Value = VeteranDocumentID;
                                    cmd.ExecuteNonQuery();
                                }
                                break;
                            case 3:
                                //OK update valid PDF flag in veteran document table = true
                                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                                {
                                    SqlCommand cmd = new SqlCommand("UPDATE VeteranDocuments SET IsValidPdfFormat = 1 WHERE id = @VeteranDocumentID", conn);
                                    conn.Open();

                                    cmd.Parameters.Add("@VeteranDocumentID", SqlDbType.Int).Value = VeteranDocumentID;
                                    cmd.ExecuteNonQuery();
                                }
                                break;


                        }

                    }
                }


            }
        }


        protected void btnCompleteUpload_Click(object sender, EventArgs e)
        {
            //COMMENTED STUDENT INTAKE
            int JstUploadCount = 0;
            int JstProcessCount = 0;
            int JstErrorCount = 0;

            bool exist = false;
            string msg = "";
            List<string> images = new List<string>(); // 2022-11-28
            List<string> errors = new List<string>(); // 2022-11-28
            List<string> veteransWithImages = new List<string>();
            List<string> veteransWithMultipleJSTs = new List<string>();
            List<string> veteransWithErrors = new List<string>();
            List<string> veteransSuccessful = new List<string>();
            List<string> unreadable = new List<string>();
            List<string> veteransWithUnreadablePDF = new List<string>();

            TelerikPDF.Redaction pdf = new TelerikPDF.Redaction();
            List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs = new List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse>();
            try
            {
                if (AsyncUpload1.UploadedFiles.Count > 0)
                {
                    bool validPdfFormat = false;
                    bool readablePDF = false;
                    bool redactedSSN = false;
                    bool jstLooksGood = false;

                    foreach (UploadedFile uploadedFile in AsyncUpload1.UploadedFiles)
                    {
                        using (Stream streamJST = uploadedFile.InputStream)
                        {
                            // First check for an image. If it's an image, we can't redact it so we need to ask what the user wants to do.
                            // The challenge is that the user may upload a mix of images and pdfs, so we need to decide how to handle these.
                            var valid = pdf.IsValidPDFFormatForScan(streamJST);
                            switch (valid)
                            {
                                case 0:
                                    jstLooksGood = false;
                                    validPdfFormat = false;
                                    readablePDF = false;
                                    redactedSSN = false;
                                    break;
                                case 1:
                                    jstLooksGood = false;
                                    validPdfFormat = true;
                                    readablePDF = false;
                                    redactedSSN = false;
                                    break;
                                case 2:
                                    jstLooksGood = true;
                                    validPdfFormat = true;
                                    readablePDF = true;
                                    redactedSSN = false;
                                    break;
                                case 3:
                                    jstLooksGood = true;
                                    validPdfFormat = true;
                                    readablePDF = true;
                                    redactedSSN = true;
                                    break;
                            }

                            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                            {
                                try
                                {
                                    int vetIndex = 0;

                                    ImportProcess pdfreader = new ImportProcess(GlobalUtil.ReadSetting("AzureCVEndpoint"), GlobalUtil.ReadSetting("AzureCVSubscriptionKey"));
                                    ems_app.Utility.AsyncHelper.RunSync(() => pdfreader.Import(streamJST));

                                    foreach (ITPI.JSTranscriptPDFReader.Entities.Veteran veteran in pdfreader.CurrentVeterans)
                                    { 
                                        // save records, parse images but collect names of veterans with image JST's
                                        if (!validPdfFormat)
                                        {
                                            images.Add(uploadedFile.GetName());
                                            veteransWithImages.Add(veteran.LastName + ", " + veteran.FirstName + " (Filename: " + uploadedFile.GetName() + ")");
                                        }
                                        else if (!readablePDF)
                                        {
                                            unreadable.Add(uploadedFile.GetName());
                                            veteransWithUnreadablePDF.Add(veteran.LastName + ", " + veteran.FirstName + " (Filename: " + uploadedFile.GetName() + ")");
                                        }
                                        if (pdfreader.TranscriptCount > 1)
                                        {
                                            veteransWithMultipleJSTs.Add(veteran.LastName + ", " + veteran.FirstName + " (Filename: " + uploadedFile.GetName() + ")");
                                        }
                                        if(pdfreader.ErrorMessage.Count > vetIndex)
                                        {
                                            if (string.IsNullOrEmpty(pdfreader.ErrorMessage[vetIndex]))
                                            {
                                                if (pdfreader.SummaryCourseLists.Count > vetIndex)
                                                {
                                                    crs = pdfreader.SummaryCourseLists[vetIndex];
                                                    AddVeteran(veteran, jstLooksGood);
                                                    LoadACECourses(crs);
                                                    LoadCreditRecommendations(crs);

                                                    JstProcessCount += 1;
                                                    veteransSuccessful.Add(veteran.LastName + ", " + veteran.FirstName + " (Filename: " + uploadedFile.GetName() + ")");

                                                    if (jstLooksGood)   // save JST
                                                    {
                                                        using (Stream stream = uploadedFile.InputStream)
                                                        {
                                                            byte[] fileByes;
                                                            Stream outStream;
                                                            // Load the credit recs into a string List<> once for faster lookups
                                                            // and to pass into TelerikPDF without needing a reference to our entities
                                                            List<string> creditRecommendations = new List<string>();

                                                            foreach (ITPI.JSTranscriptPDFReader.Entities.SummaryCourse cr in crs)
                                                            {
                                                                foreach (ITPI.JSTranscriptPDFReader.Entities.CourseCreditRecommendation rec in cr.CreditRecommendations)
                                                                {
                                                                    creditRecommendations.Add(rec.Criteria);
                                                                }
                                                            }

                                                            if (pdf.ProcessStreamAndSave(stream, creditRecommendations, veteran.JSTFirstPage, veteran.JSTLastPage))
                                                            {
                                                                outStream = pdf.OutputStream;
                                                                fileByes = new byte[outStream.Length];
                                                            }
                                                            else
                                                            {
                                                                outStream = stream;
                                                                fileByes = new byte[stream.Length];
                                                            }

                                                            string fileName;
                                                            if (pdfreader.TranscriptCount > 1)
                                                            {
                                                                fileName = $"{veteran.FirstName} {veteran.MiddleName} {veteran.LastName}{uploadedFile.GetExtension()}";
                                                            }
                                                            else
                                                            {
                                                                fileName = uploadedFile.FileName.Replace(",", "_").Replace(";", "_");
                                                            }

                                                            outStream.Position = 0;
                                                            outStream.Read(fileByes, 0, fileByes.Length);
                                                            // NEXT 2 LINES COMMENTED OUT TO MATCH DAVE'S VERSION 10/21/22
                                                            //stream.Position = 0;
                                                            //stream.Read(fileByes, 0, fileByes.Length);
                                                            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                                                            {
                                                                SqlCommand cmd = new SqlCommand("INSERT INTO [dbo].[VeteranDocuments] ([Filename],[FileDescription],[BinaryData],[user_id],[VeteranID],[Field])" +
                                                                                        " VALUES(@Filename, @FileDescription, @BinaryData, @user_id, @VeteranID, @Field)", conn);
                                                                conn.Open();
                                                                cmd.Parameters.AddWithValue("@FileName", fileName);
                                                                cmd.Parameters.AddWithValue("@FileDescription", fileName);
                                                                cmd.Parameters.Add("@BinaryData", SqlDbType.VarBinary, fileByes.Length).Value = fileByes;
                                                                cmd.Parameters.AddWithValue("@user_id", Session["UserID"].ToString());
                                                                //cmd.Parameters.AddWithValue("@VeteranID", hfVeteranID.Value);
                                                                cmd.Parameters.AddWithValue("@VeteranID", _VeteranID);
                                                                cmd.Parameters.AddWithValue("@Field", "student_joint_services");

                                                                try
                                                                {
                                                                    if (conn.State == ConnectionState.Open)
                                                                    {
                                                                        conn.Close();
                                                                    }
                                                                    conn.Open();
                                                                    if (Controllers.Veteran.CheckVeteranDocumentExists(_VeteranID, fileName, fileName) == 0)
                                                                    {
                                                                        int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());
                                                                        JstUploadCount += 1;
                                                                    }
                                                                    else
                                                                    {
                                                                        exist = true;
                                                                    }
                                                                }
                                                                catch (Exception ex)
                                                                {

                                                                }
                                                                conn.Close();

                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                JstErrorCount += 1;
                                                veteransWithErrors.Add(veteran.LastName + ", " + veteran.FirstName + " (Filename: " + uploadedFile.GetName() + $") - ERROR MESSAGE: " + pdfreader.ErrorMessage);
                                            }

                                        vetIndex++;
                                        }
                                    }
                                }
                                catch (Exception ex)
                                {
                                    JstErrorCount += 1;
                                    //2022-08-24 DISPLAY ERROR MESSAGE IF UPLOAD DID NOT WORK SUCCESSFULLY
                                    //DisplayMessage(false, string.Format("Oops! It looks as though the JST you are attempting to upload has no summary page. Please upload the summary page or manually load the exhibit IDs within the student record!", Jstcount.ToString()));
                                }
                            }
                        }
                    }


                    string link = "<a style='color:blue' href='" + GlobalUtil.ReadSetting("JSTLink") + "' target='_blank'>here</a>";
                    rnStudentIntake.Text = "";
                    rgStudents.DataBind();

                    if (JstProcessCount > 0)
                    {
                        rnStudentIntake.Text = $" <strong> {JstProcessCount.ToString()} JST File information was loaded successfully.</strong><br/>" +
                        $"{string.Join(";<br/> ", veteransSuccessful)}";
                    }

                    if (JstErrorCount > 0)
                    {
                        if (JstErrorCount == 1)
                        {
                            rnStudentIntake.Text += $"<br/><br/> <strong> {JstErrorCount.ToString()} JST File had an error and was not uploaded and a student profile was not created.</strong><br/> " +
                            $"{string.Join(";<br/> ", veteransWithErrors)}" + $"<br/>";
                            rnStudentIntake.Text += $" <br/>There are two options for this student:";
                            rnStudentIntake.Text += $" <br/> 1.	Upload an another PDF version of the JST (see " + link + " to obtain a JST).";
                            rnStudentIntake.Text += $" <br/> 2.	Use the <strong>Manually Add Student</strong> button on the Student Log to manually create the student; Click on the pencil icon to edit the student record; Click <strong>Manually Add Exhibit</strong> to add the credit recommendations listed on the JST summary page.";

                        }
                        else
                        {
                            rnStudentIntake.Text += $"<br/><br/> <strong> {JstErrorCount.ToString()} JST Files had errors and were not uploaded and student profiles were not created.</strong><br/> " +
                            $"{string.Join(";<br/> ", veteransWithErrors)}" + $"<br/>";
                            rnStudentIntake.Text += $" <br/>There are two options for these students:";
                            rnStudentIntake.Text += $" <br/> 1.	Upload other PDF versions of the JST's (see " + link + " to obtain a JST).";
                            rnStudentIntake.Text += $" <br/> 2.	Use the <strong>Manually Add Student</strong> button on the Student Log to manually create the students; Click on the pencil icon to edit the student records; Click <strong>Manually Add Exhibit</strong> to add the credit recommendations listed on the JST summary pages.";
                        }

                    }

                    if (images.Count > 0)
                    {
                        if (images.Count == 1)
                        {
                            rnStudentIntake.Text += $" <br/><br/><strong> {images.Count.ToString()} JST file was an image file rather than an original PDF.</strong><br/>" +
                            $"{string.Join(";<br/> ", veteransWithImages)}" + $"<br/>";
                            rnStudentIntake.Text += $" <br/><ul><li><span style='font-weight:bold; font-style:italic;'>IMPORTANT: The student was created and the credit recommendations were uploaded but the JST was not uploaded.</span></li>";
                            rnStudentIntake.Text += $" <li><span style='font-weight:bold; font-style:italic;'>NOTE: MAP redacts student’s Social Security Number and Date of Birth for original JST.pdf files, but does not do so for imaged files. Please note this for student privacy purposes.</span></li>";
                            //rnStudentIntake.Text += $" <li>Image files cannot be reliably parsed and may result in incomplete or incorrect results.</li>";
                            //rnStudentIntake.Text += $" <li>The file was uploaded and a caution icon " + $"<i class='fa-solid fa-triangle-exclamation' style='color:yellow'></i>" + " was added to Step 1 for the student.</li>";
                            rnStudentIntake.Text += $" <li>Please review JST and Student Information page and manually add missing credit recommendations if needed.</li></ul>";
                            rnStudentIntake.Text += $" <br/><strong>To ensure accuracy, we recommend that you obtain an original PDF version of the JST (" + link + ") and reupload the JST. </strong>";
                        }
                        else
                        {
                            rnStudentIntake.Text += $" <br/><br/><strong> {images.Count.ToString()} JST Files were image files rather than original PDF's.</strong><br/>" +
                            $"{string.Join(";<br/> ", veteransWithImages)}" + $"<br/>";
                            rnStudentIntake.Text += $" <br/><ul><li><span style='font-weight:bold; font-style:italic;'>IMPORTANT: The students were created and the credit recommendations were uploaded but the JST's were not uploaded.</span></li>";
                            rnStudentIntake.Text += $" <li><span style='font-weight:bold; font-style:italic;'>NOTE: MAP redacts student’s Social Security Number and Date of Birth for original JST.pdf files, but does not do so for imaged files. Please note this for student privacy purposes.</span></li>";
                            //rnStudentIntake.Text += $" <li>Image files cannot be reliably parsed and may result in incomplete or incorrect results.</li>";
                            //rnStudentIntake.Text += $" <li>The files were uploaded and caution icons " + $"<i class='fa-solid fa-triangle-exclamation' style='color:yellow'></i>" + " were added to Step 1 for the students.</li>";
                            rnStudentIntake.Text += $" <li>Please review JSTs and Student Information pages and manually add missing credit recommendations if needed.</li></ul>";
                            rnStudentIntake.Text += $" <br/><strong>To ensure accuracy, we recommend that you obtain an original PDF version of the JST's (" + link + ") and reupload the JST's. </strong>";
                        }
                    }                    
                    if (unreadable.Count > 0)
                    {
                        if (unreadable.Count == 1)
                        {
                            rnStudentIntake.Text += $" <br/><br/><strong> {unreadable.Count.ToString()} JST file could not be redacted.</strong><br/>" +
                            $"{string.Join(";<br/> ", veteransWithUnreadablePDF)}" + $"<br/>";
                            rnStudentIntake.Text += $" <br/><ul><li><span style='font-weight:bold; font-style:italic;'>IMPORTANT: The student was created and the credit recommendations were uploaded but the JST was not uploaded.</span></li>";
                            rnStudentIntake.Text += $" <li><span style='font-weight:bold; font-style:italic;'>NOTE: MAP redacts student’s Social Security Number and Date of Birth for original JST.pdf files. Please note this for student privacy purposes.</span></li>";
                            rnStudentIntake.Text += $" <li>Please review JST and Student Information page and manually add missing credit recommendations if needed.</li></ul>";
                            rnStudentIntake.Text += $" <br/><strong>To ensure accuracy, we recommend that you obtain an original PDF version of the JST (" + link + ") and reupload the JST. </strong>";
                        }
                        else
                        {
                            rnStudentIntake.Text += $" <br/><br/><strong> {unreadable.Count.ToString()} JST file could not be redacted.</strong><br/>" +
                            $"{string.Join(";<br/> ", veteransWithUnreadablePDF)}" + $"<br/>";
                            rnStudentIntake.Text += $" <br/><ul><li><span style='font-weight:bold; font-style:italic;'>IMPORTANT: The students were created and the credit recommendations were uploaded but the JST's were not uploaded.</span></li>";
                            rnStudentIntake.Text += $" <li><span style='font-weight:bold; font-style:italic;'>NOTE: MAP redacts student’s Social Security Number and Date of Birth for original JST.pdf files. Please note this for student privacy purposes.</span></li>";
                            rnStudentIntake.Text += $" <li>Please review JST and Student Information page and manually add missing credit recommendations if needed.</li></ul>";
                            rnStudentIntake.Text += $" <br/><strong>To ensure accuracy, we recommend that you obtain an original PDF version of the JST (" + link + ") and reupload the JST. </strong>";
                        }
                    }

                    if (veteransWithMultipleJSTs.Count > 0)
                    {
                        rnStudentIntake.Text += $" <br/><br/><span style='font-weight:bold; color:red;'>Warning: </span>Multiple JST files were identified in PDF.<br/>" +
                        $"{string.Join(";<br/> ", veteransWithMultipleJSTs)}" + $"<br/>";
                        rnStudentIntake.Text += $" <br/><ul><li><span style='font-weight:bold; color:red;'>Important: </span>The JST's were split and saved to each veterans profile.</li></ul>";
                        rnStudentIntake.Text += $" <br/><strong>To ensure accuracy, we recommend that you obtain an original PDF version of the JST (" + link + ") and reupload the JST. </strong>";
                    }

                    if (JstProcessCount > 0)
                    {
                        rnStudentIntake.Text += $" <br/><br/> Please review all successfully uploaded JST files and manually add missing Ace Exhibits to the Eligible Credits table using the <strong>Manually Add Exhibit</strong> button.";
                    }

                    // 2022-11-28 - I'm not sure why this is here below. Maybe you don't have it in your code.

                    //{
                    //    msg += "It looks like you are attempting to create a duplicate student record.";   
                    //}   
                    rgStudents.Rebind();
                    rgCreditRecommendations.Rebind();
                    rnStudentIntake.Show();
                }
                loadingDiv.Style["display"] = "none";

            }
            catch (Exception ex)
            {
                rnStudentIntake.Text = ex.Message;
                rnStudentIntake.Show();
            }
        }


        private void LoadCreditRecommendations(List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> cred)
        { 
            var credit_recommendation = "";
            foreach (ITPI.JSTranscriptPDFReader.Entities.SummaryCourse c in cred)
            {
                if (c.CreditRecommendations != null)
																					 
                {
                    foreach (var item in c.CreditRecommendations)
                    {

                    // 02/01/23 if credit = 0 need to show credit recommendation text coming from JST
                        //if (item.Credit == 0)
                        //{
                        //    credit_recommendation = "";
                        //}
                        //else 
                        if (item.Credit == 1)
                        {
                            credit_recommendation = string.Format("{0} hour in {1}", item.Credit, item.Subject);
                        }
                        else
                        {
                            credit_recommendation = string.Format("{0} hours in {1}", item.Credit, item.Subject);
                        }

                        //check if credit recommendation exists
                        var veteran_cr_exists = CheckVeteranCreditRecommendationsExists(_VeteranID, c.AceID, credit_recommendation, c.CourseNumber, item.Level);
                        if (veteran_cr_exists == 0)	 
                        {
                            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                            {
                                SqlCommand cmd = new SqlCommand("INSERT INTO VeteranCreditRecommendations" +
                                "([VeteranId], [AceID],[TeamRevd],[CreditRecommendation],[MilitaryCourseNumber],[CourseVersion],[Level]) " +
                                "VALUES (@VeteranId, @AceID, @TeamRevd, @CreditRecommendation, @CourseNumber, @CourseVersion, @Level) ", conn);
                                // Added on 10/7/22 - to replace previous SqlCommand

                                conn.Open();

                                cmd.Parameters.AddWithValue("@VeteranId", _VeteranID);
                                cmd.Parameters.AddWithValue("@AceID", c.AceID);
                                cmd.Parameters.AddWithValue("@TeamRevd", GetTeamRevd(Convert.ToInt32(_VeteranID), c.AceID));
                                cmd.Parameters.AddWithValue("@CreditRecommendation", credit_recommendation);
                                cmd.Parameters.AddWithValue("@CourseNumber", c.CourseNumber);
                                cmd.Parameters.AddWithValue("@CourseVersion", c.CourseVersion);
                                cmd.Parameters.AddWithValue("@Level", item.Level);
                                int count = cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
        }

		public static int CheckVeteranCreditRecommendationsExists(int veteranID, string aceID, string creditRecommendation, string courseNumber, string level)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"SELECT CASE WHEN EXISTS (SELECT * FROM VeteranCreditRecommendations WHERE VeteranId = {veteranID} AND AceID = '{aceID}' AND CreditRecommendation = '{creditRecommendation}'  AND MilitaryCourseNumber = '{courseNumber}'  AND Level = '{level}') THEN 1 ELSE 0 END AS Result;";
                    result = (int)cmd.ExecuteScalar();
                }
                finally
                {
                    connection.Close();
                }


            }
            return result;
        }
        private void AddVeteranDoc(string fileName, string fileDescription, byte[] fileData)
        {
            if (!VeteranDocExists(_VeteranID, fileName))
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO VeteranDocuments" +
                    "([FileName], [FileDescription], [BinaryData], [VeteranID], [user_id], [Field]) " +
                    "VALUES(@FileName, @FileDescription, @BinaryData, @VeteranID, @user_id, 'student_joint_services') ", conn);

                    conn.Open();

                    cmd.Parameters.Add("@FileName", SqlDbType.VarChar, 50).Value = fileName;
                    cmd.Parameters.Add("@FileDescription", SqlDbType.VarChar, 50).Value = fileName;
                    cmd.Parameters.AddWithValue("BinaryData", fileData);
                    cmd.Parameters.Add("@VeteranID", SqlDbType.Int).Value = _VeteranID;
                    cmd.Parameters.Add("@user_id", SqlDbType.Int).Value = Session["UserID"];
                    int count = cmd.ExecuteNonQuery();
                }
            }
        }
         private bool VeteranDocExists(int veteranID, string fileName)
        {
            bool exists = false;
            string queryString = "SELECT count(*) FROM VeteranDocuments" +
              " WHERE VeteranID = @VeteranID " +
              " AND FileName = @FileName";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(queryString, conn);
                conn.Open();

                cmd.Parameters.Add(new SqlParameter("@VeteranID", veteranID));
                cmd.Parameters.Add(new SqlParameter("@FileName", fileName));

                exists = (int)cmd.ExecuteScalar() > 0;
            }

            return exists;
        }
        private void ShowMessage(List<string> errInvalidFormat, List<string> errorNoSummary)
        {
            if (errInvalidFormat.Count != 0)
            {
                rnStudentIntake.Text = $"Not loaded, invalid PDF Format: {String.Join(",", errInvalidFormat.Select(s => "'" + s + "'"))}";
                rnStudentIntake.Show();
            }

            if (errorNoSummary.Count != 0)
            {
                rnStudentIntake.Text = $"Not loaded, PDF has no Summary Section: {String.Join(",", errorNoSummary.Select(s => "'" + s + "'"))}";
                rnStudentIntake.Show();
            }
        }

        private void AddVeteran(ITPI.JSTranscriptPDFReader.Entities.Veteran veteran, bool jstLooksGood)
        {
            int id = 0;
            DateTime dtBirthDate;

            dtBirthDate = new DateTime(2021, 1, 1);   //DEFAULT DATE! 

            if (veteran.BirthDate != null) {
                dtBirthDate = (DateTime)veteran.BirthDate;
                id = GetVeteranId(veteran.LastName, veteran.FirstName, dtBirthDate, Convert.ToInt32(Session["CollegeID"].ToString()));

            }
            else
            {
                id = CheckVeteranExists(veteran.FirstName, veteran.LastName, Convert.ToInt32(Session["CollegeID"]));
            }

            var lookup = new Common.models.GenericLookup();
            var serviceID = lookup.GetServiceID(veteran.Branch);

            if (id > 0)
            {
               _VeteranID = id;
                sqlVeteran2.UpdateParameters["id"].DefaultValue = _VeteranID.ToString();
                sqlVeteran2.UpdateParameters["CampaignID"].DefaultValue = hfCampaignID.Value;
                sqlVeteran2.UpdateParameters["IsValidPDFFormat"].DefaultValue = jstLooksGood.ToString();

                sqlVeteran2.Update();
            }
            else
            {
                
                sqlVeteran.InsertParameters["CampaignID"].DefaultValue = hfCampaignID.Value;
                sqlVeteran.InsertParameters["FirstName"].DefaultValue = veteran.FirstName;
                sqlVeteran.InsertParameters["LastName"].DefaultValue = veteran.LastName;
                sqlVeteran.InsertParameters["Rank"].DefaultValue = veteran.Rank;
                sqlVeteran.InsertParameters["IsValidPDFFormat"].DefaultValue = jstLooksGood.ToString();

                if (veteran.BirthDate != null)
                {
                    sqlVeteran.InsertParameters["BirthDate"].DefaultValue = ((DateTime)veteran.BirthDate).ToShortDateString();
                }
                else
                {
                    veteran.BirthDate = new DateTime(2021, 01, 01);
                    sqlVeteran.InsertParameters["BirthDate"].DefaultValue = "01/01/2021";
                }
                //sqlVeteran.InsertParameters["BirthDate"].DefaultValue = dtBirthDate.ToShortDateString();
                if (Session["CollegeID"].ToString() != null)
                { 
                    sqlVeteran.InsertParameters["CollegeID"].DefaultValue = Session["CollegeID"].ToString();
                }
                else
                {
                    sqlVeteran.InsertParameters["CollegeID"].DefaultValue = "1";
                }

                sqlVeteran.InsertParameters["ServiceID"].DefaultValue = serviceID == null ? "" : serviceID.ToString();

                int result = sqlVeteran.Insert();
                _VeteranID = GetVeteranId(veteran.LastName, veteran.FirstName, dtBirthDate, Convert.ToInt32(Session["CollegeID"].ToString()));
            }
        }

        
        private DateTime GetTeamRevd(int VeteranID, string AceID)
        {
            DateTime TeamRevd = System.DateTime.Now;
            string queryString = $"SELECT distinct TeamRevd FROM VeteranACECourse WHERE VeteranID = {@VeteranID} AND AceID = '{@AceID}' ";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(queryString, conn);
                conn.Open();
                cmd.Parameters.Add(new SqlParameter("@VeteranID", VeteranID));
                cmd.Parameters.Add(new SqlParameter("@AceID", AceID));
                var i = cmd.ExecuteScalar();
                if (i != null)
                    TeamRevd = (DateTime)i;
            }

            return TeamRevd;
        }

        private int GetVeteranId(string lastName, string FirstName,  DateTime birthDate, int collegeID)
        {
            int id = 0;
            string queryString = "SELECT id FROM Veteran " +
              " WHERE LastName = @LastName" +
              " AND FirstName = @FirstName " +
              " AND BirthDate = @BirthDate " +
              " AND CollegeID = @CollegeID ";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(queryString, conn);
                conn.Open();
                cmd.Parameters.Add(new SqlParameter("@LastName", lastName));
                cmd.Parameters.Add(new SqlParameter("@FirstName", FirstName));
                cmd.Parameters.Add(new SqlParameter("@BirthDate", birthDate));
                cmd.Parameters.Add(new SqlParameter("@CollegeID", collegeID));
                var i = cmd.ExecuteScalar();
                if (i != null)
                    id = (Int32)i;
            }

            return id;
        }

        private void LoadACECourses(List<ITPI.JSTranscriptPDFReader.Entities.SummaryCourse> crs)
        {
            foreach (ITPI.JSTranscriptPDFReader.Entities.SummaryCourse c in crs)
            {
                if (c.CourseDate != null || Convert.ToString(c.CourseDate) != "")
                {
                    UpdateAceIDbyCourseDate(c);
                    UpdateVeteranAceCourse(c.AceID, c.CourseDate, c.CourseNumber, c.CourseVersion, _VeteranID, Convert.ToInt32(Session["CollegeID"].ToString()));
                }
            }
        }
        public static void UpdateAceIDbyCourseDate(ITPI.JSTranscriptPDFReader.Entities.SummaryCourse c)
        {
            DataSet ds = new DataSet();
            string sql = $"select * from fn_GetAceIDbyCourseDate('{c.AceID}','{c.CourseDate}','{c.CourseVersion}');";

            using (var adapter = new SqlDataAdapter(sql, ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                adapter.Fill(ds);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    c.CourseDate = Convert.ToDateTime(dr["TeamRevd"].ToString());
                    c.CourseVersion = dr["VersionNumber"].ToString();
                }
            }
						  
        }

        //public static string GetAceIDbyCourseDate(string _AceID, string _TeamRevDate, string _CourseVersion)
        //{
        //    string result = "";
        //    using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
        //    {
        //        SqlCommand cmd = connection.CreateCommand();
        //        connection.Open();
        //        try
        //        {
        //            cmd.CommandText = $"select TeamRevd from (select TeamRevd from fn_GetAceIDbyCourseDate('{_AceID}','{_TeamRevDate}','{_CourseVersion}')) A;";
        //            //result = ((string)cmd.ExecuteScalar());
        //            result = cmd.ExecuteScalar().ToString();
        //        }
        //        finally
        //        {
        //            connection.Close();
        //        }
        //    }
        //    return result;
        //}

        private void UpdateVeteranAceCourse(string AceID, DateTime? TeamRevd, string CourseNumber, string CourseVersion, int VeteranID, int CollegeID)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddVeteranACECourse", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@AceID", AceID);
                    cmd.Parameters.AddWithValue("@TeamRevd", TeamRevd);
                    cmd.Parameters.AddWithValue("@CourseNumber", CourseNumber);
                    cmd.Parameters.AddWithValue("@CourseVersion", CourseVersion);
                    cmd.Parameters.AddWithValue("@VeteranID", VeteranID);
                    cmd.Parameters.AddWithValue("@CollegeID", CollegeID);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void rgStudents_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridFilteringItem)
            {
                GridFilteringItem filteringItem = (GridFilteringItem)e.Item;
                DropDownList ddl = filteringItem.FindControl("RadComboBoxCPLType") as DropDownList;

                if (ddl != null)
                {
                    ddl.SelectedValue = hfCPLType.Value;
                }
            }
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                CheckBox chk = (CheckBox)dataItem["PotentialStudent"].Controls[0];
                LinkButton lk = (LinkButton)dataItem.FindControl("btnPublicUpload");
                if (lk != null)
                    lk.Visible = chk.Checked;

                HtmlControl divDocUpload = (HtmlControl)dataItem.FindControl("divDocUpload");
                if (divDocUpload != null)
                {
                    if (((DataRowView)e.Item.DataItem)["DocUpload"].ToString() == "True")
                    {
                        if (((DataRowView)e.Item.DataItem)["NeedsFurtherReview"].ToString() == "True")
                        {
                            divDocUpload.Style.Add("color", "orange");
                            divDocUpload.Attributes.Add("class", "fa fa-check-circle fa-2xl");
                            divDocUpload.Attributes.Add("title", "Needs further review");
                        }
                        else
                        {
                            divDocUpload.Style.Add("color", "green");
                            divDocUpload.Attributes.Add("class", "fa fa-check-circle fa-2xl");
                            divDocUpload.Attributes.Add("title", "File uploaded successfully");
                        }
                    }
                    else if (((DataRowView)e.Item.DataItem)["IsValidPDFFormat"].ToString() == "False")
                    {
                        divDocUpload.Style.Add("color", "orange");
                        divDocUpload.Attributes.Add("class", "fa-solid fa-triangle-exclamation fa-2xl");
                        divDocUpload.Attributes.Add("title", "Warning: Please note that Student Credit Recommendations have been Successfully uploaded and saved. The student JST file was unable to be saved due to Personal Identification Information not being redacted or multiple veteran's information on the PDF.. ");
                    }
                    else
                    {
                        divDocUpload.Attributes.Add("class", "fa fa-check-circle fa-2xl");
                        divDocUpload.Attributes.Add("title", "No file uploaded");
                    }
                }

                if (((DataRowView)e.Item.DataItem)["EdPlan"].ToString() == "True")
                {
                    HtmlGenericControl myITag = (HtmlGenericControl)dataItem.FindControl("linkIconEdPlan");
                    myITag?.Style.Add("color", "green");
                }
                if (((DataRowView)e.Item.DataItem)["Analysis"].ToString() == "True")
                {
                    HtmlGenericControl myITag = (HtmlGenericControl)dataItem.FindControl("linkIconAnalysis");
                    myITag?.Style.Add("color", "green");
                }
                if (((DataRowView)e.Item.DataItem)["Counselor"].ToString() == "True")
                {
                    HtmlGenericControl myITag = (HtmlGenericControl)dataItem.FindControl("linkIconCounselor");
                    myITag?.Style.Add("color", "green");
                }
                if (((DataRowView)e.Item.DataItem)["Student"].ToString() == "True")
                {
                    HtmlGenericControl myITag = (HtmlGenericControl)dataItem.FindControl("linkIconStudent");
                    myITag?.Style.Add("color", "green");
                }
                if (((DataRowView)e.Item.DataItem)["Transcribed"].ToString() == "True")
                {
                    HtmlGenericControl myITag = (HtmlGenericControl)dataItem.FindControl("linkIconTranscribed");
                    myITag?.Style.Add("color", "green");
                }
            }
        }

        protected void rsShowPotential_CheckedChanged(object sender, EventArgs e)
        {
            if (rsPotential.Checked == true)
            {
                Session["PotentialStudent"] = 1; // Set the @PotentialStudent parm to 1 - Get all students and potential students
                Session["CPLSearchUpload"] = 1;  // Set the @CPLSearchUpload parm to 1 - Get all students and potential students
   
            }
            else
            {
                Session["PotentialStudent"] = 0; // Set the @PotentialStudent parm to 0 - Get all students Only - No potential students
                Session["CPLSearchUpload"] = 0;  // Set the @CPLSearchUpload parm to 0 - Get all students Only - No potential students

            }

            sqlVeteran.DataBind();

        }

		protected void rgCreditRecommendations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.CommandName == "RowClick")
            {
                GridDataItem itemDetail = (GridDataItem)e.Item;
                Session["SelectedCreditRecommendation"] = itemDetail["CreditRecommendation"].Text;
                sqlVeteran.DataBind();
                rgStudents.DataBind();
            }
        }

        protected void rbClear_Click(object sender, EventArgs e)
        {
            Session["SelectedCreditRecommendation"] = string.Empty;
            Session["PotentialStudent"] = 0; 
            Session["CPLSearchUpload"] = 0;
            //sqlVeteran.SelectParameters["CollegeID"].DefaultValue = Session["CollegeID"].ToString();
            //sqlVeteran.SelectParameters["_PotentialStudent"].DefaultValue = Session["PotentialStudent"].ToString();
            //sqlVeteran.SelectParameters["_CPLSearchUpload"].DefaultValue = Session["CPLSearchUpload"].ToString();
            //sqlVeteran.SelectParameters["_CreditRecommendation"].DefaultValue = string.Empty;
            sqlVeteran.DataBind();
            rgStudents.DataBind();
            rgCreditRecommendations.MasterTableView.ClearSelectedItems();
        }

        //BATCH UPLOAD
        public static int CheckVeteranExists(string first_name, string last_name,  int college_id)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"SELECT CASE WHEN EXISTS (SELECT id FROM Veteran WHERE FirstName = @FirstName AND LastName = @LastName AND CollegeID = @CollegeID) THEN (SELECT id FROM Veteran WHERE FirstName = @FirstName AND LastName = @LastName AND CollegeID = @CollegeID) ELSE 0 END AS Result;";
                    cmd.Parameters.AddWithValue("@FirstName", first_name);
                    cmd.Parameters.AddWithValue("@LastName", last_name);
                    cmd.Parameters.AddWithValue("@CollegeID", college_id);
					result = (int)cmd.ExecuteScalar();
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }

        public static int CheckVeteranAndIDExists(string first_name, string last_name, int college_id, string studentID)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"SELECT CASE WHEN EXISTS (SELECT id FROM Veteran WHERE FirstName = @FirstName AND LastName = @LastName AND CollegeID = @CollegeID AND StudentID = @StudentID) THEN (SELECT id FROM Veteran WHERE FirstName = @FirstName AND LastName = @LastName AND CollegeID = @CollegeID AND StudentID = @StudentID) ELSE 0 END AS Result;";
                    cmd.Parameters.AddWithValue("@FirstName", first_name);
                    cmd.Parameters.AddWithValue("@LastName", last_name);
                    cmd.Parameters.AddWithValue("@CollegeID", college_id);
                    cmd.Parameters.AddWithValue("@StudentID", studentID);		 
                    result = (int)cmd.ExecuteScalar();
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }

        public static int CheckVeteranExhibitExists(int exhibit_id, int veteran_id)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"SELECT CASE WHEN EXISTS (SELECT * FROM VeteranACECourse WHERE VeteranId = {veteran_id} AND ExhibitID = {exhibit_id}) THEN 1 ELSE 0 END AS Result;";
                    result = (int)cmd.ExecuteScalar();
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }

        public static ExhibitInfo GetExhibitInfo(string map_id, int college_id)
        {
            ExhibitInfo result = null;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    //cmd.CommandText = $"SELECT TOP 1 ID, AceID, TeamRevd, ISNULL(convert(varchar(20),StartDate,120),'') StartDate, ISNULL(convert(varchar(20),EndDate,120),'') EndDate FROM ACEExhibit WHERE AceID = '{map_id}' AND ( CollegeID IS NULL OR CollegeID = {college_id} ) ORDER BY EndDate DESC;";
                    cmd.CommandText = $"SELECT TOP 1 ID, AceID, TeamRevd, ISNULL(convert(varchar(20),StartDate,120),'') StartDate, ISNULL(convert(varchar(20),EndDate,120),'') EndDate FROM ACEExhibit WHERE AceID = '{map_id}' AND Status = 0 ORDER BY StartDate DESC;";
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            if (reader.HasRows)
                            {
                                result = new ExhibitInfo
                                {
                                    ExhibitID = reader.GetInt32(0),
                                    AceID = reader.GetString(1),
                                    TeamRevd = reader.GetDateTime(2),
                                    StartDate = reader.GetString(3),
                                    EndDate = reader.GetString(4)
                                };
                            }
                        } 
                    }
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }


        public static int GetExhibitID(string map_id, int college_id)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"SELECT TOP 1 ISNULL(ID,0) FROM ACEExhibit WHERE AceID = '{map_id}' AND ( CollegeID IS NULL OR CollegeID = {college_id} ) ORDER BY EndDate DESC;";
                    result = (int)cmd.ExecuteScalar();
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }
        public static int AddVeteran(string first_name, string middle_name, string last_name, string student_id, string mobile_phone, string email, int? service_id, int origin_id, string cpl_status, string transfer_destination, int college_id, int created_by, string notes)
        {
            int id = 0;
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddVeteran", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@FirstName", first_name));
                    cmd.Parameters.Add(new SqlParameter("@MiddleName", middle_name));
                    cmd.Parameters.Add(new SqlParameter("@LastName", last_name));
                    cmd.Parameters.Add(new SqlParameter("@StudentID", student_id));
                    cmd.Parameters.Add(new SqlParameter("@MobilePhone", mobile_phone));
                    cmd.Parameters.Add(new SqlParameter("@Email", email));
                    cmd.Parameters.Add(new SqlParameter("@ServiceID", service_id));
                    cmd.Parameters.Add(new SqlParameter("@OriginID", origin_id));
                    cmd.Parameters.Add(new SqlParameter("@CPLStatusID", cpl_status));
                    cmd.Parameters.Add(new SqlParameter("@TransferDestination", transfer_destination));
                    cmd.Parameters.Add(new SqlParameter("@CollegeID", college_id));
                    cmd.Parameters.Add(new SqlParameter("@CreatedBy", created_by));
                    cmd.Parameters.Add(new SqlParameter("@Notes", notes));
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);
                    cmd.ExecuteNonQuery();
                    id = Convert.ToInt32(outParm.Value);
                }
                return id;
            }
        }
        public static int AddVeteranExhibit(string map_id, DateTime teamr_revd, DateTime? start_date, DateTime? end_date, int veteran_id, int exhibit_id, int college_id)
        {
            int id = 0;
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddVeteranACECourseManually", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@AceID", map_id));
                    cmd.Parameters.Add(new SqlParameter("@TeamRevd", teamr_revd));
                    cmd.Parameters.Add(new SqlParameter("@StartDate", start_date));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", end_date));
                    cmd.Parameters.Add(new SqlParameter("@VeteranID", veteran_id));
                    cmd.Parameters.Add(new SqlParameter("@ExhibitID", exhibit_id));
                    cmd.Parameters.Add(new SqlParameter("@CollegeID", college_id));
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);
                    cmd.ExecuteNonQuery();
                    id = Convert.ToInt32(outParm.Value);
                }
                return id;
            }
        }
        public static void UpdateVeteran(int veteran_id, string mobile_phone, string email, int? service_id, string student_id, string notes, int updatedBy)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UpdateVeteranFromBatch", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@VeteranID", veteran_id));
                    cmd.Parameters.Add(new SqlParameter("@MobilePhone", mobile_phone));
                    cmd.Parameters.Add(new SqlParameter("@Email", email));
                    cmd.Parameters.Add(new SqlParameter("@ServiceID", service_id));
                    cmd.Parameters.Add(new SqlParameter("@StudentID", student_id));
                    cmd.Parameters.Add(new SqlParameter("@Notes", notes));
                    cmd.Parameters.Add(new SqlParameter("@UpdatedBy", updatedBy));
                    cmd.ExecuteNonQuery();
                }
            }
        }
        protected void UploadStudents_FileUploaded(object sender, EventArgs e)
        {
                rgStudents.DataBind();
        }

        protected void rbUpload_Click(object sender, EventArgs e)
        {
            pnlUpload.Style["display"] = "block";
            rbCloseUpload.Visible = true;
            ucUploadStudents.ShowPanel = true;
            //string script = "function f(){$find(\"" + rw_customConfirm.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
            //ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
        }

        protected void rbCloseUpload_Click(object sender, EventArgs e)
        {
            pnlUpload.Style["display"] = "none";
            rbCloseUpload.Visible = false;
        }
        //BATCH UPLOAD

        protected void ddlCreditType_SelectedIndexChanged(object sender, EventArgs e)
        {
            RadComboBox ddl = (RadComboBox)sender;
            string selectedValue = ddl.SelectedValue;

            if (selectedValue == "%") // If "All" is selected
            {
                hfCPLType.Value = string.Empty;
            }
            else
            {
                hfCPLType.Value = selectedValue;
            }
            sqlVeteran.DataBind();
        }

        protected void ddlLearningMode_SelectedIndexChanged(object sender, EventArgs e)
        {
            RadComboBox ddl = (RadComboBox)sender;
            string selectedValue = ddl.SelectedValue;

            if (selectedValue == "%") // If "All" is selected
            {
                hfLearningMode.Value = string.Empty;
            }
            else
            {
                hfLearningMode.Value = selectedValue;
            }
            sqlVeteran.DataBind();
        }

        protected void rsChange_CheckedChanged(object sender, EventArgs e)
        {
            RadSwitch changedSwitch = (RadSwitch)sender;
            string switchId = changedSwitch.ID;
            Boolean isChecked = (bool)changedSwitch.Checked;
            switch (switchId)
            {
                case "rsUploaded":
                    _Uploaded.Value = isChecked.ToString();
                    break;
                case "rsEdPlan":
                    _EdPlan.Value = isChecked.ToString();
                    break;
                case "rsAnalysis":
                    _Analysis.Value = isChecked.ToString();
                    break;
                case "rsCounselor":
                    _Counselor.Value = isChecked.ToString();
                    break;
                case "rsStudent":
                    _Student.Value = isChecked.ToString();
                    break;
                case "rsTranscribed":
                    _Transcribed.Value = isChecked.ToString();
                    break;
                default:
                    break;
            }
            rgStudents.DataBind();
        }

        private void UpdateStudentStatus( string college_id, string user_id, string nroStatus, string swStatus, string veteran_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("UpdateStudentStatus", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@collegeid", college_id);
                    cmd.Parameters.AddWithValue("@nroStatus", nroStatus);
                    cmd.Parameters.AddWithValue("@swStatus", swStatus);
                    cmd.Parameters.AddWithValue("@upd_user", user_id);
                    cmd.Parameters.AddWithValue("@ID", veteran_id);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void sqlVeteran_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.CommandTimeout = 60;
        }
    }
}