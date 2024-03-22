using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

using ITPI.JSTranscriptPDFReader.Entities;

namespace ITPI.JSTranscriptPDFReader.AzureComputerVision
{
    public class PdfToVeteranEntities
    {
        public List<List<List<PdfElement>>> InfoLines { get; set; }
        public List<List<List<PdfElement>>> MilitaryCourseLines { get; set; }
        public List<List<List<PdfElement>>> SummaryLines { get; set; }

        public string ErrorMessage { get; set; }

        public List<Veteran> CurrentVeterans { get; set; }
        public List<VeteranLevel> VeteranLevels { get; set; }
        public List<List<SummaryCourse>> SummaryCourseLists { get; set; }

        public PdfToVeteranEntities(List<Veteran> currentVeterans,
                                    List<List<List<PdfElement>>> infoLines,
                                    List<List<List<PdfElement>>> mltryCourseLines,
                                    List<List<List<PdfElement>>> sumLines)
        {
            CurrentVeterans = currentVeterans;
            InfoLines = infoLines;
            MilitaryCourseLines = mltryCourseLines;
            SummaryLines = sumLines;
        }

        public bool Process()
        {
            try
            {
                Utilities util = new Utilities();
                this.VeteranLevels = util.LoadVeteranLevels();
                
                SetVeterans();
                SetCourses();
                //CheckCoursesAndCredits();   // ** REMOVED
                
                return true;
            }
            catch (Exception ex)
            {
                this.ErrorMessage = ex.Message;
                return false;
            }
        }

        private void SetVeterans()
        {
            string[] name;
            string collegeName;
            int vetIndex = 0;

            foreach (List<List<PdfElement>> vetInfoLines in InfoLines)
            {
                foreach (List<PdfElement> line in vetInfoLines)
                {
                    if (line[0].PdfText.ToLower() == "name:")
                    {
                        name = line[1].PdfText.Split(' ');
                        if (name.Length > 0)
                        {
                            if (name.Count() == 3)
                            { 
                            CurrentVeterans[vetIndex].LastName = name[0].Replace(",", "");
                            CurrentVeterans[vetIndex].FirstName = name[1];
                            CurrentVeterans[vetIndex].MiddleName = name[2];
                            }
                            else
                            {
                                CurrentVeterans[vetIndex].LastName = name[0].Replace(",", "");
                                CurrentVeterans[vetIndex].FirstName = name[1];
                            }
                        }

                        if (line.Count == 3)
                        {
                            collegeName = line[2].PdfText;

                            CurrentVeterans[vetIndex].TranscriptCollegeName =
                                collegeName.IndexOf("(") > 0
                                    ? collegeName.Substring(0, line[2].PdfText.IndexOf("(") - 1) : collegeName;
                        }
                    }
                    if (line[0].PdfText.ToLower() == "rank:")
                    {
                        if (line[1].PdfText.Length != 0)
                        {
                            if (Regex.IsMatch(line[1].PdfText.Substring(0, 1), @"^[a-zA-Z]+$")) // must be a letter to limit mistakes (ssn, address)
                                CurrentVeterans[vetIndex].Rank = line[1].PdfText;
                            else
                                CurrentVeterans[vetIndex].Rank = "";
                        }

                    }
                    //if (DateTime.TryParse(birthDt, out dtCheck))
                    //    CurrentVeteran.BirthDate = dtCheck;
                    
                }
                vetIndex++;
            }
        }

        private void SetCourses()
        {
            SummaryCourse crs;
            DateTime dtCheck;
            int intCheck;
            int vetIndex = 0;
            //For debugging
            //PrintSummaryLines(); 
            SummaryCourseLists = new List<List<SummaryCourse>>();
            List<SummaryCourse> SummaryCourseList;


            foreach (List<List<PdfElement>> vetSummaryLines in SummaryLines)
            {
                SummaryCourseList = new List<SummaryCourse>();

                for (int i = 0; i < vetSummaryLines.Count - 1; i++)
                {
                    List<PdfElement> line = vetSummaryLines[i];
                    try
                    {
					    // GET LINE 1 - ACEID, COURSENUMBER, COURSETITLE, COURSEDATE
                        if (line[0].PdfText.Length < 25 && // eliminate extra lines  
                                           line[0].LeftPosition < 1 &&  //ACE tends to be around 0.4
                                           line[0].PdfText.Contains("-"))   // ACE Ids
                        {
                            crs = new SummaryCourse();
                            crs.AceID = line[0].PdfText;

                            //get branch of service abbrev from ACEID
                            if (string.IsNullOrEmpty(CurrentVeterans[vetIndex].Branch))
                                CurrentVeterans[vetIndex].Branch = crs.AceID.Substring(0, crs.AceID.IndexOf("-"));

                            crs.CourseNumber = line[1].PdfText;
                            crs.CourseTitle = "";
                            if (line.Count > 2)
                            {
                                crs.CourseTitle = line[2].PdfText.Length > 5 ? line[2].PdfText : "";
                            }
                            //If Course Title is blank, it may be on the previous line
                            if (string.IsNullOrEmpty(crs.CourseTitle))
                            {
                                foreach (PdfElement elem in vetSummaryLines[i - 1])
                                {
                                    if (vetSummaryLines[i - 1].Count() <= 2 &&
                                        elem.LeftPosition >= 2.55 &&
                                        elem.LeftPosition <= 2.75 &&
                                        Math.Abs(line[0].TopPosition - elem.TopPosition) < .2) // check if the offset is close
                                    {
                                        crs.CourseTitle += string.Format(" {0}", elem.PdfText);
                                    }
                                }
                            }

                            if (crs.CourseTitle.Length == 0 || crs.CourseTitle.Length > 25) // Course Title is still blank or if the title is long and might wrap
                            {
                                // The next line might continue the Title
                                foreach (PdfElement elem in vetSummaryLines[i + 1])
                                {
                                    if (vetSummaryLines[i + 1].Count() <= 2 &&  // Credit Rec contains 3 elements
                                        elem.LeftPosition >= 2.6 &&
                                        elem.LeftPosition <= 2.75 &&
                                        Math.Abs(line[0].TopPosition - elem.TopPosition) < .2) // check if the offset is close)
                                    {
                                        crs.CourseTitle += string.Format(" {0}", elem.PdfText);
                                    }
                                }
                            }
                            if (line.Count > 3)
                            {
                                if (DateTime.TryParse(line[3].PdfText, out dtCheck))
                                    crs.CourseDate = dtCheck;
                                else
                                {
                                    crs.JSTUploadErrorMessage = "Problem with this ACE - Course Date.";
                                }
                            }
                            else
                            {
                                //CHECK FOR SPECIAL CASE: COURSEDATE IS MISSING AND INCLUDED IN TITLE
                                if (line.Count == 3 && crs.CourseTitle.Length > 50 && !crs.CourseDate.HasValue)
                                {
                                    var tmpDate = crs.CourseTitle.Substring(crs.CourseTitle.Length - 11);
                                    if (DateTime.TryParse(tmpDate, out dtCheck))
                                    {
                                        crs.CourseDate = dtCheck;
                                        crs.CourseTitle = crs.CourseTitle.Substring(0, crs.CourseTitle.Length - 12);
                                    }
                                    else
                                        crs.JSTUploadErrorMessage = "Problem with a Credit Recommendation in this ACE - missing text or line alignment.";
                                }
                                else
                                    crs.JSTUploadErrorMessage = "Problem with a Credit Recommendation in this ACE - missing text or line alignment.";
                            }

                            crs.CourseVersion = GetCourseVersionFromMilitaryCourseSection(crs.AceID, vetIndex);

                            SummaryCourseList.Add(crs);
                        }
                        else
                        {
						    // GET LINE 2+ - SUBJECT, CREDIT, LEVEL
                            // CASE 1 (BAD) MISSED CREDIT VALUE. LEVEL=L -> CREATE DUMMY     **DOESN'T FIRE FOR OTHER LEVELS**
                            // DT 2023-01-13
                            // special case - parser didn't "see" the credit in the summary section, so "L" is the 2nd item, where it expects the credit
                            // add a "dummy" credit rec and bypass the rest of the logic.
                            // REMOVED DUMMY LINE 5/1/23
                            //if (line.Count == 2 &&
                            //    line[0].LeftPosition > 2.6315 && line[0].LeftPosition < 2.75 &&  //02-08-23 to capture cr positioned at Left:2.6316 (Mora)
                            //    line[1].PdfText == "L" &&
                            //   !int.TryParse(line[1].PdfText, out intCheck))
                            //{
                            //    this.SummaryCourseList.LastOrDefault().CreditRecommendations.Add
                            //         (new CourseCreditRecommendation(line[0].PdfText, 3, "L"));
                            //}

						    // CASE 2 (BAD) LEVEL MISSING ON PDF -> CREATE DUMMY        **NEEDED - THIS SHOULD SAVE ZERO CREDIT WITH NO LEVEL																												 
                            // DT 2023-04-06
                            // special case - no Level on PDF, but has a credit
                            // add a "dummy" credit rec 
                            if (line.Count == 2 && 
                               line[0].LeftPosition > 2.6315 && line[0].LeftPosition < 2.75 &&  //02-08-23 to capture cr positioned at Left:2.6316 (Mora)
                           
                               int.TryParse(line[1].PdfText, out intCheck))
                            {

                                // Is the next line a continuation?
                                string rec = line[0].PdfText;

                                for (int n = 1; n < vetSummaryLines.Count - 1; i++)
                                {
                                    List<PdfElement> nextline = vetSummaryLines[i + 1];

                                    if (nextline[0].LeftPosition > 2.6315 && nextline[0].LeftPosition < 2.75 &&
                                        nextline.Count == 1)
                                    {
                                        rec += " " + nextline[0].PdfText;
                                    }
                                    else
                                    {
                                        break;
                                    }
                                }  
                             
                                SummaryCourseList.LastOrDefault().CreditRecommendations.Add
                                     (new CourseCreditRecommendation(rec, intCheck, "L"));
                            }
						    // CREDIT CORRECTION - CREDIT=I -> CHANGE I TO 1
                            // 02-08-2023  to edit alpha credit  (Mora)
                            if (line.Count >= 3 &&
                               line[1].LeftPosition > 5.9960 && line[0].LeftPosition < 6.4 &&
                               line[1].PdfText == "I")
                            {
                                line[1].PdfText = "1";
                            }
						    // CREDIT CORRECTION - CREDIT MISSING -> SET TO 9 - **REMOVED
                            // 02-08-2023
                            // DT 2023-01-13
                            if (line.Count >= 3 &&
                                !int.TryParse(line[1].PdfText, out intCheck) &&
                                VeteranLevels.Exists(x => x.Code == line[2].PdfText))   //02/03/23 coming next to add these veteran levels?
                            {
                                //this is a credit rec with missing credit - put 9 
                                //line[1].PdfText = "99";
                            }
						    // CASE 3 (GOOD)
                            if (line.Count >= 3 &&
                                line[0].LeftPosition > 2.6
                                && int.TryParse(line[1].PdfText, out intCheck))
                            {
							    // SUBJECT - CHECK FOR WRAPPING -> GET ADDITIONAL SUBJECT LINES
                                // The next line might continue the Subject
                                if (line[0].Width > 1.4) // See if the credit subject is long and might wrap
                                {
                                    // add additional loops for continued lines 
                                    var j = 1;
                                    while (vetSummaryLines[i + j].Count() <= 2)
                                    {
                                        foreach (PdfElement elem in vetSummaryLines[i + j])
                                        {
                                            if (elem.LeftPosition >= 2.6 &&
                                                elem.LeftPosition <= 2.75)
                                            {
                                                line[0].PdfText += string.Format(" {0}", elem.PdfText);
                                            }
                                        }
                                        j += 1;
                                    }
                                    //foreach (PdfElement elem in vetSummaryLines[i + 1])
                                    //{
                                    //    if (vetSummaryLines[i + 1].Count() <= 2 &&
                                    //        elem.LeftPosition >= 2.6 &&
                                    //        elem.LeftPosition <= 2.75 &&
                                    //        Math.Abs(line[0].TopPosition - elem.TopPosition) < .2) // check if the offset is close)
                                    //    {
                                    //        line[0].PdfText += string.Format(" {0}", elem.PdfText);
                                    //    }
                                    //}
                                }

                                    // This is a credit recommendation
                                    if (SummaryCourseList.Count > 0)
                                {
								    // CASE 3.1 (GOOD) - LEVEL LENGTH < 2 -> SAVE RECORD
                                    // if (Convert.ToInt16(line[1].PdfText) > 0 &&     **** 01/16/23 To Include 0 Recommended Credit*****
                                    if (//Convert.ToInt16(line[1].PdfText) > 0 &&
                                        line[2].PdfText.Length < 2) // add code to check for value =  V L U or G ? 2/9/23
                                    {
                                        // DT 2023-04-06

                                        // Is the next line a continuation? 
                                        string rec = line[0].PdfText;

                                        //for (int n = 2; n < vetSummaryLines.Count - 1; i++)  // dt 04/20     ** FIX ME - N = 2
                                        //{
                                        //    List<PdfElement> nextline = vetSummaryLines[i + n];

                                        //    if (nextline[0].LeftPosition > 2.6315 && nextline[0].LeftPosition < 2.75 &&
                                        //        nextline.Count == 1)
                                        //    {
                                        //        rec += " " + nextline[0].PdfText;
                                        //    }
                                        //    else
                                        //    {
                                        //        break;
                                        //    }
                                        //}
                                        //
                                        SummaryCourseList.LastOrDefault().CreditRecommendations.Add
                                        (new CourseCreditRecommendation(rec, Convert.ToInt16(line[1].PdfText), line[2].PdfText));
                                    }
								    // CASE 3.2 (BAD) - LEVEL LENGTH > 2 -> DUMMY RECORD
                                    // PC 2023-01-16
                                    // New special case - parser found SOC Course Category Code  instead if credit level "L" in the 2nd item
                                    // add a "dummy" credit Level and bypass the rest of the logic.
                                    else
                                    {
                                        if (line[2].PdfText.Length > 2 &&
                                            line[0].LeftPosition > 2.65 && line[0].LeftPosition < 2.75 &&
                                            line[2].PdfText != "L")
                                        {
                                            SummaryCourseList.LastOrDefault().CreditRecommendations.Add
                                                 (new CourseCreditRecommendation(line[0].PdfText, Convert.ToInt16(line[1].PdfText), "L"));
                                        }
                                    }
                                    // PC 2023-01-16
                                }
                            }
                            else
                            {   // CASE 4 (GOOD)  **WRAPPED COURSE NUMBER IN LINE 0
                                // SUBJECT - CHECK FOR WRAPPING -> GET ADDITIONAL SUBJECT LINES      
                                // 02-09-2023 when military course is in line(0)
                                if (line.Count > 1)
                                { 
                                    if (line[1].Width > 1.4) // See if the credit subject is long and might wrap
                                    {
                                        foreach (PdfElement elem in vetSummaryLines[i + 1])
                                        {
                                            if (vetSummaryLines[i + 1].Count() <= 2 &&
                                                elem.LeftPosition >= 2.6 &&
                                                elem.LeftPosition <= 2.75 &&
                                                Math.Abs(line[1].TopPosition - elem.TopPosition) < .2) // check if the offset is close)
                                            {
                                                line[1].PdfText += string.Format(" {0}", elem.PdfText);
                                            }
                                        }
                                    }
                                }
                                // This is a credit recommendation
                                if (SummaryCourseList.Count > 0 && line.Count >= 4)
                                {
								    // CASE 4.1 (GOOD) - LEVEL LENGTH < 2 -> SAVE RECORD
                                    // if (Convert.ToInt16(line[1].PdfText) > 0 &&     **** 01/16/23 To Include 0 Recommended Credit*****
                                    if (//Convert.ToInt16(line[1].PdfText) > 0 &&
                                        line.Count >= 3 &&
                                        line[3].PdfText.Length < 2) // add code to check for value =  V L U or G ? 2/9/23
                                    {

                                        SummaryCourseList.LastOrDefault().CreditRecommendations.Add
                                        (new CourseCreditRecommendation(line[1].PdfText, Convert.ToInt16(line[2].PdfText), line[3].PdfText));
                                    }
								    // CASE 4.2 (BAD) - LEVEL LENGTH > 2 -> DUMMY RECORD
                                    // PC 2023-01-16
                                    // New special case - parser found SOC Course Category Code  instead if credit level "L" in the 2nd item
                                    // add a "dummy" credit Level and bypass the rest of the logic.
                                    else
                                    {
                                        if (line[3].PdfText.Length > 2 &&
                                            line[1].LeftPosition > 2.65 && line[1].LeftPosition < 2.75 &&
                                            line[3].PdfText != "L")
                                        {
                                            SummaryCourseList.LastOrDefault().CreditRecommendations.Add
                                             (new CourseCreditRecommendation(line[1].PdfText, Convert.ToInt16(line[2].PdfText), "L"));
                                        }
                                    }
                                }
                            }
                                // 02-09-2023
                            }
                    }
                    catch (Exception ex)
                    {
                        this.ErrorMessage = ex.Message;
                    }
                }
                SummaryCourseLists.Add(SummaryCourseList);
                vetIndex++;
            }
        }

        /// <summary>   
        /// After parsing the courses and credits from the Summary section, try again against the Military Course section   **REMOVED
        /// 
        /// </summary>

        //private void CheckCoursesAndCredits()
        //{
        //    try
        //    {
        //        for (int i = 0; i < MilitaryCourseLines.Count; i++)
        //        {
        //            List<PdfElement> line = MilitaryCourseLines[i];

        //            if (line.Count > 2 &&
        //                line[1].PdfText.Contains("-"))
        //            {
        //                string[] arr = line[1].PdfText.ToUpper().Split(' ');
        //                string aceid = arr[0].Trim();
        //                SummaryCourse crs = SummaryCourseList.Find(x => x.AceID == aceid);
        //                if (crs != null)
        //                {
        //                    while (i < MilitaryCourseLines.Count - 1  )
        //                    {
        //                        i++;

        //                        line = MilitaryCourseLines[i];
        //                        if (line.Count == 3)
        //                        {
        //                            //sometimes the cred text comes back like this = ". First Aid" or "· First Aid" or "Commenity" (due to handwritting
        //                            if (!crs.CreditRecommendations.Exists(x => x.Criteria == line[0].PdfText.Replace(".", "").Replace("·", "").Replace("Commenity", "Community").Trim()))
        //                            {
        //                                int chk = 0;
        //                                if (int.TryParse(line[1].PdfText.Replace("I", "1").Replace("SH", "").Trim(), out chk))
        //                                    {
        //                                    // Commented out due to adding extra cr to exhibit (mora aceid ar-2201-0399)
        //                                    //crs.CreditRecommendations.Add(
        //                                    //    new CourseCreditRecommendation(
        //                                    //        line[0].PdfText.Replace(".", "").Replace("·", "").Trim(),
        //                                    //        chk,
        //                                    //        line[2].PdfText));
        //                                }
        //                            }
        //                        }
        //                        else
        //                        {
        //                            break;
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        this.ErrorMessage = ex.Message;
        //    }
        //}


        private string GetCourseVersionFromMilitaryCourseSection(string aceID, int vetIndex)
        {
            string version = "";
            string[] arr;

            if (MilitaryCourseLines.Count > vetIndex)
            {
                // The pdf parser pulls the ACEID / Version as "AR-1728-0194 V02" in the Military Course section
                foreach (List<PdfElement> line in MilitaryCourseLines[vetIndex])
                {
                    if (line.Count > 1)
                    {
                        if (line[1].PdfText.StartsWith(aceID))
                        {
                            arr = line[1].PdfText.ToUpper().Split(' ');
                            if (arr.Length > 0)
                            {
                                foreach (string s in arr)
                                {
                                    if (s.StartsWith("V"))
                                    {
                                        version = s;
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }

            return version;

        }


        private void PrintSummaryLines()
        {
            Debug.WriteLine("======================SUMMARY=========================");
            Debug.WriteLine("======================SUMMARY=========================");
            Debug.WriteLine("======================SUMMARY=========================");
            foreach (List<List<PdfElement>> vetSummaryLines in SummaryLines)
            {
                for (int i = 0; i < vetSummaryLines.Count - 1; i++)
                {
                    Debug.WriteLine("----------Line----------------");
                    List<PdfElement> line = vetSummaryLines[i];

                    if (line[0].PdfText.Contains("-") && line[0].LeftPosition < .5)
                        Debug.WriteLine("     ======== ACE ========================");

                    foreach (PdfElement elem in line)
                    {
                        Debug.WriteLine(string.Format(" Left: {0} / Top: {1} Height: {2}  / Width: {3} Text:{4} ",
                           elem.LeftPosition, elem.TopPosition, elem.Height, elem.Width, elem.PdfText));
                    }
                }
            }

            Debug.WriteLine("======================SUMMARY=========================");
            Debug.WriteLine("======================SUMMARY=========================");
            Debug.WriteLine("======================SUMMARY=========================");
        }
    }
}
