using System;
using System.Collections.Generic;
using System.Linq;

namespace ITPI.JSTranscriptPDFReader.Entities
{
    [Serializable]
    public class Veteran
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Branch { get; set; }
        public string TranscriptCollegeName { get; set; }
        public DateTime? BirthDate { get; set; }
        public DateTime? TermDate { get; set; }
        public string Email { get; set; }
        public string Email1 { get; set; }
        public string Email2 { get; set; }
        public string OfficePhone { get; set; }
        public string MobilePhone { get; set; }
        public string HomePhone { get; set; }
        public int? SalutationID { get; set; }
        public int? StatusID { get; set; }
        public int ServiceID { get; set; }
        public string StreetAddress { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }
        public string Occupation { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? CreatedOn { get; set; }
        public int UpdatedBy { get; set; }
        public DateTime? UpdatedOn { get; set; }
        public string RESULT_CD { get; set; }
        public string DNC_FLG { get; set; }
        public string WARN_FLG { get; set; }
        public string EMAIL_OPTOUT { get; set; }
        public int? CityId { get; set; }
        public string Rank { get; set; }
        public int? LevelID { get; set; }
        public string Status { get; set; }
        public int JSTFirstPage { get; set; }
        public int JSTLastPage { get; set; }
    }

}