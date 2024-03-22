using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ITPI.JSTranscriptPDFReader.AzureComputerVision;
using ITPI.JSTranscriptPDFReader.Entities;

namespace ITPI.JSTranscriptPDFReader
{
    public class Utilities
    {
        public List<VeteranLevel> LoadVeteranLevels( )
        {
            VeteranLevel lvl;
            List<VeteranLevel> vetLevels = new List<VeteranLevel>();
            lvl = new VeteranLevel();
            vetLevels.Add(new VeteranLevel(1, "V", "Vocational"));
            vetLevels.Add(new VeteranLevel(2, "L", "Lower Division Baccalaureate/ Associate"));
            vetLevels.Add(new VeteranLevel(3, "U", "Upper Division Baccalaureate"));
            vetLevels.Add(new VeteranLevel(4, "G", "Graduate"));
            vetLevels.Add(new VeteranLevel(5, "E", "Continuing Education"));
            vetLevels.Add(new VeteranLevel(6, "D", "Developmental Credits"));
            vetLevels.Add(new VeteranLevel(7, "S", "Semester Hours"));
            vetLevels.Add(new VeteranLevel(8, "Q", "Quarter Hours"));
            vetLevels.Add(new VeteranLevel(9, "C", "Clock"));
            vetLevels.Add(new VeteranLevel(10, "N", "Continuing Education Units"));

            return vetLevels;
        }

        public static void PrintDebugLines(List<List<PdfElement>> infoLines,
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
            // Summary by line
            System.Diagnostics.Debug.WriteLine("///////////");

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
             
            // Summary by item
            System.Diagnostics.Debug.WriteLine("///////////////////////");

            foreach (List<PdfElement> line in aceLines)
            { 
                foreach (PdfElement sum in line)
                {
                    System.Diagnostics.Debug.WriteLine(string.Format("{0}, {1}, {2} ",
                        sum.PdfText, sum.TopPosition, Math.Round( sum.LeftPosition,3), Math.Round(sum.TopPosition,3))); 
                } 
            }

            System.Diagnostics.Debug.WriteLine("///////////");

        }

        public static void PrintVeterans(Veteran vet,
                                List<SummaryCourse> courses)
        {
            System.Diagnostics.Debug.WriteLine("*********************************************");
            System.Diagnostics.Debug.WriteLine("*********************************************");
            System.Diagnostics.Debug.WriteLine(
                    string.Format("{0} {1} {2} ", vet.LastName, vet.FirstName,
                        vet.BirthDate == null ? "Not found" : ((DateTime)vet.BirthDate).ToShortDateString()));

            foreach (SummaryCourse crs in courses)
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                System.Diagnostics.Debug.WriteLine(
                    string.Format("{0} / {1} / {2} / {3} ", crs.AceID, crs.CourseTitle, crs.CourseVersion, crs.CourseDate));
                System.Diagnostics.Debug.WriteLine(sb.ToString());
            }

            System.Diagnostics.Debug.WriteLine("*********************************************");
            System.Diagnostics.Debug.WriteLine("*********************************************");
        }



        public static void PrintFormattedVeterans(Veteran vet,
                                List<SummaryCourse> courses)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine(
               string.Format("{0}| {1}| {2}|||||||| ", vet.LastName, vet.FirstName,
                   vet.BirthDate == null ? "Not found" : ((DateTime)vet.BirthDate).ToShortDateString()));

            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("error in vet line:" + ex.Message);
            }

            foreach (SummaryCourse crs in courses)
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                try
                {
                    System.Diagnostics.Debug.WriteLine(
                string.Format("|||{0}|{1}|{2}|{3}|{4}| ", crs.AceID, crs.CourseTitle, crs.CourseNumber, crs.CourseVersion, crs.CourseDate == null ? "" : ((DateTime)crs.CourseDate).ToShortDateString()));

                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("error in course line: " + ex.Message);
                }

                foreach (CourseCreditRecommendation cred in crs.CreditRecommendations)
                {
                    try
                    {
                        System.Diagnostics.Debug.WriteLine(
                                               string.Format("||||||||{0}|{1}|{2}|", cred.Subject,  cred.Credit.ToString(),cred.Level));
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine(
                            ex.Message);
                    }

                }
            }

        }
        public static bool IsLikelySameLine(PdfElement lastElement, PdfElement thisElement, double htVariance)
        { 

            return Math.Abs(lastElement.TopPosition - thisElement.TopPosition) < htVariance &&
                    lastElement.LeftPosition < thisElement.LeftPosition;
        }
    }
}
