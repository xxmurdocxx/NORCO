using System;
using System.Collections.Generic;
using System.Linq;

using ITPI.JSTranscriptPDFReader.Entities; 

namespace ITPI.JSTranscriptPDFReader.Entities
{
    public class CourseCreditRecommendations
    {
        public string Subject { get; set; }
        public int Credit { get; set; } 
        public string Level { get; set; } 
        

        public CourseCreditRecommendations()
        { 
        }
        public CourseCreditRecommendations(string subj, int cred, string lvl)
        {
            Subject = subj;
            Credit = cred;
            Level = lvl;
        }
    }
}