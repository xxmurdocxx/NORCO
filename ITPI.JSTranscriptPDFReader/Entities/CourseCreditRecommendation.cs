using System;
using System.Collections.Generic;
using System.Linq;

using ITPI.JSTranscriptPDFReader.Entities; 

namespace ITPI.JSTranscriptPDFReader.Entities
{
    [Serializable]
    public class CourseCreditRecommendation
    {
        public string Criteria { get; set; }
        public string Subject { get; set; }
        public double Credit { get; set; } 
        public string Level { get; set; }
        public bool IsArticulated { get; set; }


        public CourseCreditRecommendation()
        { 
        }

        public CourseCreditRecommendation(string subj, double cred, string lvl )
        {
            Subject = subj;
            Criteria = subj;
            //if (Criteria == "Personal Community Health")
            //{
            //    Credit = cred / cred;
            //}
            //else
            //{
            //    if (Criteria == "Physical Conditioning")
            //    {
            //        Credit = cred - 1;
            //    }
            //    else
            //    { 
            //    Credit = cred;
            //    }
            //}
            Credit = cred;
            Level = lvl;
            IsArticulated = false;
        }
        public CourseCreditRecommendation(string subj, double cred, string lvl, bool articulated)
        {
            Subject = subj;
            Criteria = subj;
            Credit = cred;
            Level = lvl;
            IsArticulated = articulated;
        }
    }
}