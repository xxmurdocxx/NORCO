using System;
using System.Collections.Generic;
using System.Linq;

using ITPI.JSTranscriptPDFReader.Entities; 

namespace ITPI.JSTranscriptPDFReader.Entities
{
    [Serializable]
    public class SummaryCourse : IComparable<SummaryCourse> 
    {
        public int Id { get; set; }
        public int VeteranID { get; set; }
        public string AceID { get; set; }
        public string Exhibit { get; set; }
        public int AceID_pk { get; set; }
        public string CourseNumber { get; set; }
        public string CourseVersion { get; set; }
        public string CourseTitle { get; set; }
        public DateTime? CourseDate { get; set; } 
        public List<CourseCreditRecommendation> CreditRecommendations { get; set; }
        public string JSTUploadErrorMessage { get; set; }
        public SummaryCourse ()
        {
            CreditRecommendations = new List<CourseCreditRecommendation>();
        }

        public int CompareTo(SummaryCourse other)
        {
            if (null == other)
                return 1;

            // string.Compare is safe when Id is null 
            return string.Compare(this.AceID, other.AceID);
        }
    }
}