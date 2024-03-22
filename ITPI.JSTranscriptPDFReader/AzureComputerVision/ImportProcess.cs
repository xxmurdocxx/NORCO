using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

using Microsoft.Azure.CognitiveServices.Vision.ComputerVision;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision.Models;
using ITPI.JSTranscriptPDFReader.Entities;

namespace ITPI.JSTranscriptPDFReader.AzureComputerVision
{
    public class ImportProcess
    {
        // This is to allow for variance in Y position in case the same line is not aligned
        private const double VARIANCE_HEIGHT_FOR_SAMELINE = .2;  

        public bool IsDebugMode { get; set; }

        string AzureSubscriptionKey { get; set; }
        string AzureEndPoint { get; set; }

        public List<string> ErrorMessage { get; set; }

        public int TranscriptCount { get; set; }

        public string BirthDate { get; set; }

        public List<List<List<PdfElement>>> InfoLines { get; set; }
        public List<List<List<PdfElement>>> MilitaryCourseLines { get; set; }
        public List<List<List<PdfElement>>> SummaryLines { get; set; }

        public List<Veteran> CurrentVeterans { get; set; }
        public List<VeteranLevel> VeteranLevels { get; set; }
        public List<List<SummaryCourse>> SummaryCourseLists { get; set; }

        public ImportProcess(string cvEndpoint, string cvSubscriptionKey)
        {
            AzureEndPoint = cvEndpoint;
            AzureSubscriptionKey = cvSubscriptionKey;
        }

        public async Task Import(Stream fs)
        {
            ComputerVisionClient _client = new
                         ComputerVisionClient(new ApiKeyServiceClientCredentials(AzureSubscriptionKey))
            { Endpoint = AzureEndPoint };

            try
            {
                System.Net.ServicePointManager.SecurityProtocol |=
                    System.Net.SecurityProtocolType.Tls11 | System.Net.SecurityProtocolType.Tls12;

                fs.Seek(0, SeekOrigin.Begin);

                // Read text from URL
                var textHeaders = await _client.ReadInStreamAsync(fs);

                // After the request, get the operation location (operation ID)
                string operationLocation = textHeaders.OperationLocation;
                System.Threading.Thread.Sleep(500);

                // <snippet_extract_response>
                // Retrieve the URI where the recognized text will be stored from the Operation-Location header.
                // We only need the ID and not the full URL
                const int numberOfCharsInOperationId = 36;
                string operationId = operationLocation.Substring(operationLocation.Length - numberOfCharsInOperationId);

                // Extract the text
                ReadOperationResult results;
                do
                {
                    results = await _client.GetReadResultAsync(Guid.Parse(operationId));
                }
                while ((results.Status == OperationStatusCodes.Running ||
                    results.Status == OperationStatusCodes.NotStarted));

                TranscriptCount = 0;
                ParseJST(results);

                ErrorMessage = new List<string>();
                int vetIndex = 0;

                //foreach (List<SummaryCourse> vetSummaryCourseList in SummaryCourseLists)
                //{
                //    if (vetSummaryCourseList.Count == 0)
                //    {
                //        ErrorMessage.Add("Your JST doesn't contain a Summary section.");
                //    }
                //    else
                //    {
                //        ErrorMessage.Add(string.Empty);
                //    }
                //}

                foreach (Veteran vetCurrentVeterans in CurrentVeterans)
                {
                    if (vetCurrentVeterans.LastName == null)
                    {
                        ErrorMessage.Add("Couldn't find the Current Veteran's name.");
                    }
                    else if (SummaryCourseLists.Count > vetIndex)
                    {
                        if (SummaryCourseLists[vetIndex].Count == 0)
                        {
                            ErrorMessage.Add("Your JST doesn't contain a Summary section.");
                        }
                        else
                        {
                            ErrorMessage.Add(string.Empty);
                        }
                    }
                    else
                    {
                        ErrorMessage.Add(string.Empty);
                    }
                    vetIndex++;
                }
            }

            catch (Exception ex)
            {
                ErrorMessage.Add(ex.Message);
            }
        }

        private void ParseJST(ReadOperationResult results)
        {
            var textUrlFileResults = results.AnalyzeResult.ReadResults;
            string vetLastName = "";
            bool militaryCoursesStarted = false;
            bool militaryCoursesEnded = false;
            bool summaryStarted = false;
            bool summaryEnded = false;

            PdfElement lastElem = new PdfElement(new double?[] { 999, 9, 9, 9, 9, 9, 9, 9 }, "");

            DateTime dtCheck;
            int pageNumber = 0;

            PdfElement pdfElem;
            List<PdfElement> pdfLine = new List<PdfElement>();
            Line line;
            InfoLines = new List<List<List<PdfElement>>>();
            MilitaryCourseLines = new List<List<List<PdfElement>>>();
            SummaryLines = new List<List<List<PdfElement>>>();
            CurrentVeterans = new List<Veteran>();
            List<List<PdfElement>> InfoLine = new List<List<PdfElement>>();
            List<List<PdfElement>> MilitaryCourseLine = new List<List<PdfElement>>();
            List<List<PdfElement>> SummaryLine = new List<List<PdfElement>>();
            Veteran CurrentVeteran = new Veteran();

            foreach (ReadResult page in textUrlFileResults)
            {
                pageNumber++;
                //sort each page by line top down. sometimes it comes back in the wrong order, affecting the building of the lines`
                IList<Line> srt = page.Lines;

                IEnumerable<Line> sortedEnum = srt;//.OrderBy(x => Convert.ToDouble( x.BoundingBox[1]))
                                                   //  .ThenBy(y =>Convert.ToDouble( y.BoundingBox[0]));
                IList<Line> sortedList = sortedEnum.ToList();


                //for (int idx = 0; idx < page.Lines.Count; idx++)
                for (int idx = 0; idx < sortedList.Count; idx++)
                {
                    
                    // line = page.Lines[idx];
                    line = sortedList[idx];

                    //debugging only
                    PdfElement pdfTest = new PdfElement(line.BoundingBox, line.Text);
                    System.Diagnostics.Debug.WriteLine(string.Format("----- {0} {1} {2}", pdfTest.TopPosition, pdfTest.LeftPosition, pdfTest.PdfText));


                    switch (line.Text)
                    {
                        case "TRANSCRIPT":  //reset counters for next veteran
                            TranscriptCount = TranscriptCount + 1;
                            militaryCoursesStarted = false;
                            militaryCoursesEnded = false;
                            summaryStarted = false;
                            summaryEnded = false;
                            vetLastName = "";
                            if (TranscriptCount > 1)
                            {
                                CurrentVeteran.JSTLastPage = pageNumber - 1;
                                InfoLines.Add(InfoLine);
                                MilitaryCourseLines.Add(MilitaryCourseLine);
                                SummaryLines.Add(SummaryLine);
                                CurrentVeterans.Add(CurrentVeteran);    // add after birthdate found in summary
                            }
                            InfoLine = new List<List<PdfElement>>();
                            MilitaryCourseLine = new List<List<PdfElement>>();
                            SummaryLine = new List<List<PdfElement>>();
                            CurrentVeteran = new Veteran();
                            CurrentVeteran.JSTFirstPage = pageNumber;
                            CurrentVeteran.JSTLastPage = 0;
                            break;
                        
                        case "Military Courses":
                            militaryCoursesStarted = true;
                            //InfoLines.Add(InfoLine);
                            break;
                        case "Military Experience":
                        case "College Level Test Scores":
                        case "Other Learning Experiences":
                        case "END OF TRANSCRIPT":
                            militaryCoursesEnded = true;
                            break;
                        case "SUMMARY":
                            summaryStarted = true;
                            //MilitaryCourseLines.Add(MilitaryCourseLine);
                            break;
                        case "EDUCATION":
                            summaryEnded = true;
                            //SummaryLines.Add(SummaryLine);
                            //CurrentVeterans.Add(CurrentVeteran);    // add after birthdate found in summary
                            break;
                        
                    }

                    // Personal Info
                    if (!militaryCoursesStarted && !summaryStarted)
                    {
                        pdfElem = new PdfElement(line.BoundingBox, line.Text);

                        if (Utilities.IsLikelySameLine(lastElem, pdfElem, VARIANCE_HEIGHT_FOR_SAMELINE)) // Continue on the same line
                        {
                            pdfLine.Add(pdfElem);
                        }
                        else
                        {                                 // Finish the last line and start a new line
                            if (pdfLine.Count > 1)
                            {
                                if (pdfLine[0].LeftPosition < 1 &&  //info starts on the far left - around 0.4
                                    pdfLine[0].PdfText.Contains("Name:") ||
                                    pdfLine[0].PdfText.Contains("Rank:")
                                )
                                {
                                    if (pdfLine[0].PdfText.Contains("Name:"))
                                    {  //Sometimes this segment also contains the full name (usually just "Name:")
                                        if (pdfLine[0].PdfText.Contains(","))
                                        {
                                            // save last name to pull birthdate from summary section
                                            vetLastName = pdfLine[0].PdfText.ToLower().Substring(0,
                                                    pdfLine[0].PdfText.IndexOf(','));
                                        }
                                        else
                                        {
                                            // save last name to pull birthdate from summary section  
                                            if (pdfLine[1].PdfText.Contains(","))
                                            {
                                                vetLastName = pdfLine[1].PdfText.ToLower().Substring(0,
                                                    pdfLine[1].PdfText.IndexOf(','));
                                            }
                                        }
                                    }
                                }                            
                                InfoLine.Add(pdfLine);
                            }


                            pdfLine = new List<PdfElement>();
                            pdfLine.Add(pdfElem);
                        }

                        lastElem = pdfElem;
                    }

                    //
                    // Military Courses
                    //
                    if (militaryCoursesStarted && !militaryCoursesEnded)
                    {
                        pdfElem = new PdfElement(line.BoundingBox, line.Text);

                        if (Utilities.IsLikelySameLine(lastElem, pdfElem, VARIANCE_HEIGHT_FOR_SAMELINE))
                        {
                            pdfLine.Add(pdfElem);
                        }
                        else
                        {
                            if ((pdfLine.Count > 2 &&
                                pdfLine[0].LeftPosition < 1 &&  //codes tends to be around 0.4
                                pdfLine[1].PdfText.Contains("-")) ||
                                (pdfLine.Count == 3 &&  //credit line
                                    pdfLine[0].LeftPosition > 1.3 && pdfLine[0].LeftPosition < 1.6)
                                )
                                // Code
                                MilitaryCourseLine.Add(pdfLine);

                            pdfLine = new List<PdfElement>();
                            pdfLine.Add(pdfElem);
                        }
                        lastElem = pdfElem;
                    }
                    //
                    // Summary
                    //
                    if (summaryStarted && !summaryEnded)
                    { 
                        pdfElem = new PdfElement(line.BoundingBox, line.Text);

                        if (line.Text == "MC-0501-0003")
                        {
                        }

                        var x = lastElem.PdfText;
                        var y = pdfElem.PdfText;
                        var i = Math.Abs(lastElem.LeftPosition - pdfElem.LeftPosition);

                        if (Utilities.IsLikelySameLine(lastElem, pdfElem, VARIANCE_HEIGHT_FOR_SAMELINE) && 
                            Math.Abs(lastElem.LeftPosition - pdfElem.LeftPosition) > .1) // 2023-04-06 - on top of each other ( cred continuation )
                        {
                            // This element is still being appended to the current line
                            pdfLine.Add(pdfElem);
                        }
                        else
                        {
                            if (pdfLine.Count > 2 &
                                pdfLine[0].PdfText.ToLower().StartsWith(vetLastName))
                            {
                                if (DateTime.TryParse(pdfLine[2].PdfText, out dtCheck))
                                    BirthDate = dtCheck.ToShortDateString();
                                else
                                {
                                    if (pdfLine.Count > 3)
                                    {
                                        if (DateTime.TryParse(pdfLine[2].PdfText + " " + pdfLine[3].PdfText, out dtCheck)) {
                                            CurrentVeteran.BirthDate = dtCheck;
                                        }
                                    }
                                }
                            }
                            
                            SummaryLine.Add(pdfLine);

                            pdfLine = new List<PdfElement>();
                            pdfLine.Add(pdfElem);
                        }

                        lastElem = pdfElem;
                       
                    }
                    //}
                }
            }

            if (CurrentVeteran.JSTLastPage == 0)
            {
                CurrentVeteran.JSTLastPage = pageNumber;
                InfoLines.Add(InfoLine);
                MilitaryCourseLines.Add(MilitaryCourseLine);
                SummaryLines.Add(SummaryLine);
                CurrentVeterans.Add(CurrentVeteran);    // add after birthdate found in summary
            }
                

            PdfToVeteranEntities pdfToVet = new PdfToVeteranEntities(CurrentVeterans, InfoLines, MilitaryCourseLines, SummaryLines);

            //pdfToVet.Process(BirthDate);
            pdfToVet.Process();
            CurrentVeterans = pdfToVet.CurrentVeterans;
            SummaryCourseLists = pdfToVet.SummaryCourseLists;


            //Utilities.PrintDebugLines(InfoLines,
            //                      MilitaryCourseLines,
            //                     SummaryLines);


            //Utilities.PrintFormattedVeterans(CurrentVeteran,
            //                      SummaryCourseList);
        }
 
    }
}
