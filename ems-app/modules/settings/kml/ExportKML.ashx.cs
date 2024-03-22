using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Xml;

namespace ems_app.modules.settings.kml
{
    /// <summary>
    /// Summary description for ExportKML
    /// </summary>
    public class ExportKML : IHttpHandler
    {
        const string itpi_website_url = @"https://learn.mappingarticulatedpathways.org/";
        const string veteran_search_tool_url = @"https://veteransmapsearch.azurewebsites.net/default.aspx";
        public class Placemark
        {
            public string CollegeID { get; set; }
            public string College { get; set; }
            public string CollegeWebsite { get; set; }
            public string VeteranServices { get; set; }
            public string LogoUrl { get; set; }
            public string Coordinates { get; set; }
            public string ApprovedArticulations { get; set; }
            public string TotalCourses { get; set; }
            public string TotalPrograms { get; set; }
        }

        public class MilitaryBase
        {
            public int id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public string Coordinates { get; set; }
        }
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/vnd.google-earth.kml+xml";
            context.Response.AddHeader("Content-Disposition", "attachment; filename=ITPIGoogleEarthPlacemarks.kml");

            XmlTextWriter kml = new XmlTextWriter(context.Response.OutputStream, System.Text.Encoding.UTF8);

            kml.Formatting = Formatting.Indented;
            kml.Indentation = 3;

            kml.WriteStartDocument();

            kml.WriteStartElement("kml", "http://www.opengis.net/kml/2.2");
            kml.WriteStartElement("Document");

            kml.WriteElementString("name", "MAP Locations");
            kml.WriteElementString("description", "Identify which military branches are the closest to your institution to efficiently tailor your articulation process!");           
            kml.WriteElementString("visibility", "1");
            kml.WriteElementString("open", "1");

            kml.WriteStartElement("Style");
            kml.WriteAttributeString("id", "collegePlacemark");
            kml.WriteStartElement("IconStyle");
            kml.WriteElementString("color", "ff2dc0fb");
            kml.WriteStartElement("Icon");
            kml.WriteElementString("href", "http://maps.google.com/mapfiles/kml/paddle/grn-blank.png");
            kml.WriteEndElement();
            kml.WriteEndElement();
            kml.WriteEndElement();

            kml.WriteStartElement("Style");
            kml.WriteAttributeString("id", "militaryPlacemark");
            kml.WriteStartElement("IconStyle");
            kml.WriteElementString("color", "ff2dc0fb");
            kml.WriteStartElement("Icon");
            kml.WriteElementString("href", "http://maps.google.com/mapfiles/kml/paddle/orange-stars.png");
            kml.WriteEndElement();
            kml.WriteEndElement();
            kml.WriteEndElement();

            var collegeData = GetCollegePlacemarks();
            List<Placemark> collegekResults = new List<Placemark>();
            collegekResults = (from DataRow dr in collegeData.Rows
                               select new Placemark()
                               {
                                   CollegeID = dr["collegeid"].ToString(),
                                   College = dr["college"].ToString(),
                                   CollegeWebsite = dr["collegewebsite"].ToString(),
                                   VeteranServices = dr["veteranservices"].ToString(),
                                   LogoUrl = dr["logourl"].ToString(),
                                   Coordinates = dr["coordinates"].ToString(),
                                   ApprovedArticulations = dr["ApprovedArticulations"].ToString(),
                                   TotalCourses = dr["TotalCourses"].ToString(),
                                   TotalPrograms = dr["TotalPrograms"].ToString()
                               }).ToList();

            foreach (var item in collegekResults)
            {
                kml.WriteStartElement("Placemark");
                kml.WriteAttributeString("id", item.CollegeID);
                kml.WriteElementString("name", item.College);
                kml.WriteElementString("styleUrl", "#collegePlacemark");
                kml.WriteElementString("description", string.Format("<img src='{0}' width='200'/><h1>{1}</h1><p>Total Approved Articulations : {2}</p><p>Total Courses : {3}</p><p>Total Programs of Study : {4}</p><p><a href='{5}'>Veterans Search Tool</a></p><p><a href='{6}'>MAP Webite</a></p><p>Veterans | <a href='{7}'>{8}</a></p><p>Information Last Updated : {9}</p>", item.LogoUrl, item.College, item.ApprovedArticulations,item.TotalCourses,item.TotalPrograms,veteran_search_tool_url, itpi_website_url, item.VeteranServices, item.College, DateTime.Now.Date.ToString("MM/dd/yyyy")));

                kml.WriteStartElement("Point");
                kml.WriteAttributeString("id", string.Format("{0}_point",item.CollegeID));
                kml.WriteElementString("coordinates", item.Coordinates);

                kml.WriteEndElement(); // <Point>
                kml.WriteEndElement(); // <Placemark>
            }

            var militaryBaseData = GetMilitaryBasePlacemarks();
            List<MilitaryBase> militaryBaseResults = new List<MilitaryBase>();
            militaryBaseResults = (from DataRow dr in militaryBaseData.Rows
                               select new MilitaryBase()
                               {
                                   id = Convert.ToInt32(dr["id"]),
                                   Name = dr["name"].ToString(),
                                   Description = dr["Description"].ToString(),
                                   Coordinates = dr["coordinates"].ToString(),
                               }).ToList();

            foreach (var item in militaryBaseResults)
            {
                kml.WriteStartElement("Placemark");
                kml.WriteAttributeString("id", string.Format("mb_{0}",item.id));
                kml.WriteElementString("name", item.Name);
                kml.WriteElementString("styleUrl", "#militaryPlacemark");
                kml.WriteElementString("description", item.Description);

                kml.WriteStartElement("Point");
                kml.WriteAttributeString("id", string.Format("{0}_point", string.Format("mb_{0}", item.id)));
                kml.WriteElementString("coordinates", item.Coordinates);

                kml.WriteEndElement(); // <Point>
                kml.WriteEndElement(); // <Placemark>
            }

            kml.WriteEndElement();
            kml.WriteEndDocument(); // <kml>
            kml.Close();

        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public DataTable GetCollegePlacemarks()
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetCollegePlacemarks", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }
            return myDataTable;
        }

        public DataTable GetMilitaryBasePlacemarks()
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetMilitaryBasePlacemarks", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }
            return myDataTable;
        }

    }
}