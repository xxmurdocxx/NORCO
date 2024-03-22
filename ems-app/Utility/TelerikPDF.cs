using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Telerik.Windows.Documents.Fixed.FormatProviders.Pdf;
using Telerik.Windows.Documents.Fixed.Model;
using Telerik.Windows.Documents.Fixed.Model.Annotations;
using Telerik.Windows.Documents.Fixed.Model.ColorSpaces;
using Telerik.Windows.Documents.Fixed.Model.Editing;
using Telerik.Windows.Documents.Fixed.Model.Text;


namespace TelerikPDF
{
    public class Redaction
    {
        private string _ssnRegexPattern = @"\d{3}-\d{2}-\d{4}";
        public Boolean DebugMode { get; set; }
        public string FilePath { get; set; }
        public string ResultFolder { get; set; }
        public string SSN { get; set; }
        public string ErrorMessage { get; set; }
        public string SSNMask { get { return "XXXXXXXXXXX"; } }
        private RadFixedDocument PdfDocument { get; set; }
        private Stream InputStream { get; set; }
        public Stream OutputStream { get; set; }

        public Redaction()
        {
        }

        /// <summary>
        /// IF an image, the PDFDocument.Pages each contain only 2 Content instances. 
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
        public Boolean IsValidPDFFormat(Stream fileStream)
        {
            int maxPageContent = 0;

            this.ErrorMessage = "";
            this.InputStream = fileStream;

            OpenDocumentFromStream();

            foreach (var page in this.PdfDocument.Pages)
            {
                if (page.Content.Count > maxPageContent)
                {
                    maxPageContent = page.Content.Count;
                }
            }

            //reset pointer to beginning
            fileStream.Seek(0, SeekOrigin.Begin);

            return (maxPageContent > 5);

        }

        public int IsValidPDFFormatForScan(Stream fileStream)
        {
            int maxPageContent = 0;
            int transcriptCount = 0;
            bool foundName = false;
            bool foundSSL = false;
            this.ErrorMessage = "";
            this.InputStream = fileStream;
            var myRegex = new Regex(_ssnRegexPattern, RegexOptions.IgnoreCase);

            OpenDocumentFromStream();

            foreach (var page in this.PdfDocument.Pages)
            {
                if (page.Content.Count > maxPageContent)
                {
                    maxPageContent = page.Content.Count;
                }

                foreach (var item in page.Content.ToList())
                {
                    TextFragment fragment = item as TextFragment;
                    if (fragment != null)
                    {
                        if (fragment.Text.ToString().ToLower() == "name:")
                        {
                            foundName = true;
                        }
                        var matchSSN = myRegex.Match(fragment.Text.Trim()).ToString();
                        if (matchSSN != "")
                        {
                            foundSSL = true;
                        }
                        //scan for multi JST's instead of SSL
                        if (fragment.Text.ToString().ToLower() == "military courses")
                        {
                            transcriptCount++;
                        }
                    }
                }
            }
            //reset pointer to beginning
            fileStream.Seek(0, SeekOrigin.Begin);

            if (foundName)
            {
                if (foundSSL)
                    return 2;
                else
                    return 3;
            }
            else if (maxPageContent > 5)
                return 1;
            else
                return 0;
        }

        public bool ProcessStreamAndSave(Stream fileStream, List<string> creditRecommendations)
        {
            this.ErrorMessage = "";
            this.InputStream = fileStream;

            OpenDocumentFromStream();

            if (ErrorMessage == "")
                PrepareDoc(creditRecommendations);

            if (ErrorMessage == "")
                PrepareOutputStream();

            return this.ErrorMessage == "";
        }

        public bool ProcessStreamAndSave(Stream fileStream, List<string> creditRecommendations, int firstPage, int lastPage)
        {
            this.ErrorMessage = "";
            this.InputStream = fileStream;

            OpenDocumentFromStream();

            if (ErrorMessage == "")
                PrepareDoc(creditRecommendations, firstPage, lastPage);

            if (ErrorMessage == "")
                PrepareOutputStream(firstPage, lastPage);

            return this.ErrorMessage == "";
        }

        public Boolean ProcessFileAndSave(string filePath, string resultFolder, List<string> creditRecommendations)
        {
            this.FilePath = filePath;
            this.ResultFolder = resultFolder;
            this.ErrorMessage = "";

            OpenDocumentFromFile();

            if (ErrorMessage == "")
                PrepareDoc(creditRecommendations);

            if (ErrorMessage == "")
                WriteFile();

            return ErrorMessage == "";
        }

        private void OpenDocumentFromFile()
        {
            var provider = new PdfFormatProvider();
            var file = File.ReadAllBytes(this.FilePath);

            try
            {
                this.PdfDocument = provider.Import(file);
            }
            catch (Exception ex)
            {
                this.ErrorMessage = string.Format("Error opening file: {0}", ex.Message);
            }
        }

        private void OpenDocumentFromStream()
        {
            var provider = new PdfFormatProvider();

            try
            {
                this.PdfDocument = provider.Import(this.InputStream);
            }
            catch (Exception ex)
            {
                this.ErrorMessage = string.Format("Error opening stream: {0}", ex.Message);
            }
        }

        private void PrepareOutputStream()
        {
            var provider = new PdfFormatProvider();
            try
            {

                var x = provider.Export(this.PdfDocument);
                this.OutputStream = new MemoryStream(x);
                 
            }
            catch (Exception ex)
            {
                this.ErrorMessage = string.Format("Error writing stream: {0}", ex.Message);
            }
        }

        private void PrepareOutputStream(int firstPage, int lastPage)
        {
            var provider = new PdfFormatProvider();
            try
            {
                RadFixedDocument outputDocument = new RadFixedDocument();
                RadFixedPage page;
                for (int i = 0; i < lastPage - firstPage + 1; i++)
                {
                    page = this.PdfDocument.Pages[firstPage - 1];
                    this.PdfDocument.Pages.Remove(page);
                    outputDocument.Pages.Add(page);
                }
                var x = provider.Export(outputDocument);
                this.OutputStream = new MemoryStream(x);

            }
            catch (Exception ex)
            {
                this.ErrorMessage = string.Format("Error writing stream: {0}", ex.Message);
            }
        }
        private void WriteFile()
        {
            var provider = new PdfFormatProvider();
            try
            {
                File.WriteAllBytes(string.Format(@"{0}\{1}", this.ResultFolder,
                    Path.GetFileName(this.FilePath)), provider.Export(this.PdfDocument));
            }
            catch (Exception ex)
            {
                this.ErrorMessage = string.Format("Error writing file: {0}", ex.Message);
            }
        }

        private void PrepareDoc(List<string> creditRecommendations, int firstPage, int lastPage)
        {
            var provider = new PdfFormatProvider();
            List<Annotation> widgetsToremove = new List<Annotation>();

            this.SSN = "";

            var myRegex = new Regex(_ssnRegexPattern, RegexOptions.IgnoreCase);

            try
            {
                for (int i = firstPage - 1; i < lastPage; i++)
                {
                    RadFixedPage page = this.PdfDocument.Pages[i];
                    //foreach (var page in this.PdfDocument.Pages)
                    //{
                    foreach (var item in page.Content.ToList())
                    {
                        TextFragment fragment = item as TextFragment;
                        if (fragment != null)
                        {
                            if (DebugMode)
                            {
                                Console.WriteLine(string.Format("{0}   {1} {2}", fragment.Text,
                                    fragment.Position.Matrix.OffsetY.ToString(), fragment.Position.Matrix.OffsetX.ToString()));
                            }

                            // Look for SSN format
                            if (myRegex.Match(fragment.Text.Trim()).ToString().Length > 0)
                            {
                                if (this.SSN == "")
                                {
                                    this.SSN = myRegex.Match(fragment.Text.Trim()).ToString();
                                }
                                // Redact this one
                                fragment.Text = this.SSNMask;

                            }
                            else if (fragment.Text.ToString().ToLower() == "date of birth:")
                            {
                                DrawRectagle(page, fragment);
                            }

                            MarkCreditRec(page, fragment, creditRecommendations);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessage = string.Format("Error in PDF file format: {0}", ex.Message);
            }
        }
        
        
        private void PrepareDoc(List<string> creditRecommendations)
        {
            var provider = new PdfFormatProvider();
            List<Annotation> widgetsToremove = new List<Annotation>();

            this.SSN = "";

            var myRegex = new Regex(_ssnRegexPattern, RegexOptions.IgnoreCase);

            try
            {
                foreach (var page in this.PdfDocument.Pages)
                {
                    foreach (var item in page.Content.ToList())
                    {
                        TextFragment fragment = item as TextFragment;
                        if (fragment != null)
                        {
                            if (DebugMode)
                            {
                                Console.WriteLine(string.Format("{0}   {1} {2}", fragment.Text,
                                    fragment.Position.Matrix.OffsetY.ToString(), fragment.Position.Matrix.OffsetX.ToString()));
                            }

                            // Look for SSN format
                            if (myRegex.Match(fragment.Text.Trim()).ToString().Length > 0)
                            {
                                if (this.SSN == "")
                                {
                                    this.SSN = myRegex.Match(fragment.Text.Trim()).ToString();
                                }
                                // Redact this one
                                fragment.Text = this.SSNMask;

                            }
                            else if (fragment.Text.ToString().ToLower() == "date of birth:")
                            {
                                DrawRectagle(page, fragment);
                            }

                            MarkCreditRec(page, fragment, creditRecommendations);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessage = string.Format("Error in PDF file format: {0}", ex.Message);
            }
        }

        private void DrawRectagle(RadFixedPage page, TextFragment fragment)
        {
            var editor = new FixedContentEditor(page);
            var xPos = fragment.Position.Matrix.OffsetX;
            var yPos = fragment.Position.Matrix.OffsetY;

            var rect = new Telerik.Documents.Primitives.Rect(xPos, yPos, 150, 20); 
            // var rect = new Telerik.Documents.Primitives.Rect(xPos, yPos - fragment.FontSize, 150, 20);
            editor.DrawRectangle(rect);
        }

        private void DrawBullet(RadFixedPage page, TextFragment fragment)
        {
            var editor = new FixedContentEditor(page);
            var xPos = fragment.Position.Matrix.OffsetX - 5;
            var yPos = fragment.Position.Matrix.OffsetY - 5;

            editor.SaveGraphicProperties();
            editor.GraphicProperties.IsFilled = true;
            editor.GraphicProperties.FillColor = new RgbColor(0, 255, 100);
            editor.GraphicProperties.IsStroked = false;
            var rect = new Telerik.Documents.Primitives.Rect(xPos, yPos, 150, 20);
            editor.DrawCircle(new Telerik.Documents.Primitives.Point(xPos, yPos), 4);
            editor.RestoreGraphicProperties();
        }

        private void MarkCreditRec(RadFixedPage page, TextFragment fragment, List<string> creditRecommendations)
        {
            if (fragment.Text.Length < 30)
            {
                if (creditRecommendations.Contains(fragment.Text))
                {
                        DrawBullet(page, fragment);
                }
                else if (fragment.Text.ToLower().StartsWith("credit is not recommended"))
                {
                    DrawBullet(page, fragment);
                }
            }
            else if (creditRecommendations.Any(e => e.StartsWith(fragment.Text)))
            {
                DrawBullet(page, fragment);
            }
            else if (fragment.Text.ToLower().StartsWith("credit is not recommended"))
            {
                DrawBullet(page, fragment);
            }
        }

    }
}
