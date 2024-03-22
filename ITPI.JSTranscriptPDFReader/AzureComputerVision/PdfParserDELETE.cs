using System;
using System.Collections.Generic;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision.Models;
using System.Threading.Tasks;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Threading;
using System.Linq;
//https://docs.microsoft.com/en-us/azure/cognitive-services/computer-vision/quickstarts-sdk/client-library?tabs=visual-studio&pivots=programming-language-csharp#read-printed-and-handwritten-text

namespace ITPI.JSTranscriptPDFReader.AzureComputerVision
{
    public class PdfParserDELETE
    {
       ComputerVisionClient _client;

        public string ErrorMessage { get; set; }
        public string BirthDate { get; set; }

        public List<List<PdfElement>> InfoLines { get; set; }
        public List<List<PdfElement>> MilitaryCourseLines { get; set; }
        public List<List<PdfElement>> SummaryLines { get; set; }


        public PdfParserDELETE()
        {
            InfoLines = new List<List<PdfElement>>();
            MilitaryCourseLines = new List<List<PdfElement>>();
            SummaryLines = new List<List<PdfElement>>();
        }

        public bool Authenticate(string subscriptionKey, string endPoint)
        {
            try
            {
                _client = new
                    ComputerVisionClient(new ApiKeyServiceClientCredentials(subscriptionKey))
                { Endpoint = endPoint };
                return true;
            }
            catch (Exception ex)
            {
                ErrorMessage = ex.Message;
                return false;
            }

        }
        public async Task ReadFileStream(Stream fs, string subscriptionKey, string endPoint)
        {
            try
            {
                _client = new
                    ComputerVisionClient(new ApiKeyServiceClientCredentials(subscriptionKey))
                { Endpoint = endPoint };

                // Read text from URL
                var textHeaders =   await  _client.ReadInStreamAsync(fs);

                // After the request, get the operation location (operation ID)
                string operationLocation = textHeaders.OperationLocation;
                Thread.Sleep(2000);

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


                ParseJST(results);

            }
            catch (Exception ex)
            {
                 ErrorMessage = ex.Message;
            }
        }

        private void ParseJST(ReadOperationResult results)
        {
            var textUrlFileResults = results.AnalyzeResult.ReadResults;
            string vetLastName = "";
            bool militaryCoursesStarted = false;
            bool militaryCoursesEnded = false;
            bool summaryStarted = false;
            double lastPos = 999;
            DateTime dtCheck; 

            PdfElement pdfElem;
            List<PdfElement> pdfLine = new List<PdfElement>();

            foreach (ReadResult page in textUrlFileResults)
            {
                foreach (Line line in page.Lines)
                {
                    switch (line.Text.ToLower())
                    {
                        case "military courses":
                            militaryCoursesStarted = true;
                            break;
                        case "college level test scores":
                        case "end of transcript":
                        case "military experience":
                        case "other learning experiences":
                            militaryCoursesEnded = true;
                            break;
                        case "summary":
                            summaryStarted = true;
                            break;
                    }
                    // Personal Info
                    if (!militaryCoursesStarted && !summaryStarted)
                    {
                        pdfElem = new PdfElement(Convert.ToDouble(line.BoundingBox[0]), line.Text);

                        if (pdfElem.PdfPosition > lastPos)  // Continue on the same line
                        {
                            pdfLine.Add(pdfElem);
                        }
                        else
                        {                                 // Finish the last line and start a new line
                            if (pdfLine.Count > 1)
                            {
                                if (pdfLine[0].PdfPosition < 1 &&  //info starts on the far left - around 0.4
                                    pdfLine[0].PdfText.Contains("Name:") ||
                                    pdfLine[0].PdfText.Contains("Rank:")
                                )
                                {
                                    if (pdfLine[0].PdfText.Contains("Name:"))
                                        // save last name to pull birthdate from summary section
                                        vetLastName = pdfLine[1].PdfText.ToLower().Substring(0,
                                                pdfLine[1].PdfText.IndexOf(','));
                                }

                                InfoLines.Add(pdfLine);
                            }


                            pdfLine = new List<PdfElement>();
                            pdfLine.Add(pdfElem);
                        }
                        lastPos = pdfElem.PdfPosition;
                    }
                    //
                    // Military Courses
                    //
                    if (militaryCoursesStarted && !militaryCoursesEnded)
                    {
                        pdfElem = new PdfElement(Convert.ToDouble(line.BoundingBox[0]), line.Text);

                        if (pdfElem.PdfPosition > lastPos)
                        {
                            pdfLine.Add(pdfElem);
                        }
                        else
                        {
                            if (pdfLine.Count > 2 &&
                                pdfLine[0].PdfPosition < 1 &&  //codes tends to be around 0.4
                                pdfLine[1].PdfText.Contains("-")) // Code
                                MilitaryCourseLines.Add(pdfLine);

                            pdfLine = new List<PdfElement>();
                            pdfLine.Add(pdfElem);
                        }
                        lastPos = pdfElem.PdfPosition;
                    }
                    //
                    // Summary
                    //
                    if (summaryStarted)
                    {
                        pdfElem = new PdfElement(Convert.ToDouble(line.BoundingBox[0]), line.Text);

                        if (pdfElem.PdfPosition > lastPos)
                        {
                            pdfLine.Add(pdfElem);
                        }
                        else
                        {
                            if (pdfLine.Count > 2 &
                               pdfLine[0].PdfText.ToLower().StartsWith(vetLastName))
                            { 
                                if (DateTime.TryParse(pdfLine[2].PdfText, out dtCheck))
                                    BirthDate = pdfLine[2].PdfText;
                            }

                            if (pdfLine.Count > 2 &&
                                pdfLine[0].PdfText.Length < 25 && // eliminate extra lines
                                pdfLine[0].PdfPosition < 1 &&  //ACE tends to be around 0.4
                                pdfLine[0].PdfText.Contains("-")   // ACE Ids
                                 )
                                SummaryLines.Add(pdfLine);

                            pdfLine = new List<PdfElement>();
                            pdfLine.Add(pdfElem);
                        }
                        lastPos = pdfElem.PdfPosition;
                    }
                }
            }

            PrintDebugLines(InfoLines, MilitaryCourseLines, SummaryLines);
        }

        private void PrintDebugLines(List<List<PdfElement>> infoLines,
                                     List<List<PdfElement>> mcLines,
                                     List<List<PdfElement>> aceLines)
        {
            foreach (List<PdfElement> line in infoLines)
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("info = ");
                foreach (PdfElement sum in line)
                {
                    sb.Append(sum.PdfText + " : ");
                }
                System.Diagnostics.Debug.WriteLine(sb.ToString());

            }

            foreach (List<PdfElement> line in mcLines)
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("mc = ");
                foreach (PdfElement sum in line)
                {
                    sb.Append(sum.PdfText + " : ");
                }
                System.Diagnostics.Debug.WriteLine(sb.ToString());

            }
            foreach (List<PdfElement> line in aceLines)
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("summary: ");
                foreach (PdfElement sum in line)
                {
                    sb.Append(sum.PdfText + " : ");
                }
                System.Diagnostics.Debug.WriteLine(sb.ToString());

            }
        }
    }
}
