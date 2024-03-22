using System;
using System.Collections.Generic;
using System.Linq;

namespace ITPI.JSTranscriptPDFReader.Entities
{
    [Serializable]
    public class VeteranLevel
    {
        public int LevelId { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }

        public VeteranLevel()
        {
        }
        public VeteranLevel(int lvlID, string cd, string descr)
        {
            this.LevelId = lvlID;
            this.Code = cd;
            this.Description = descr;
        }
    }
}