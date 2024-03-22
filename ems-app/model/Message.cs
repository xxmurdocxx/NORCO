using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using DocumentFormat.OpenXml.ExtendedProperties;
using DocumentFormat.OpenXml.Office2010.Excel;
using Telerik.Windows.Documents.Spreadsheet.Expressions.Functions;

namespace ems_app.Model
{
    public class Message
    {

        private int message_id = 0;
        private string body = "";
        private int from_user_id = 0;
        private string from = "";
        private int to_user_id = 0;
        private string email = "";
        private string subject = "";
        private string articulations = "";
        private string action = "";
        int MessageID
        {
            get { return message_id; }
            set { message_id = value; }
        }
        string Body
        {
            get { return body; }
            set { body = value; }
        }
        int FromUserID
        {
            get { return from_user_id; }
            set { from_user_id = value; }
        }
        string From
        {
            get { return from; }
            set { from = value; }
        }
        int ToUserID
        {
            get { return to_user_id; }
            set { to_user_id = value; }
        }
        string Email
        {
            get { return email; }
            set { email = value; }
        }
        string Subject
        {
            get { return subject; }
            set { subject = value; }
        }
        string Articulations
        {
            get { return articulations; }
            set { articulations = value; }
        }
        string Action
        {
            get { return action; }
            set { action = value; }
        }
        //public static bool SendMessage(string body, int from_user_id, string from, int to_user_id, string email, string subject, string articulations, string action, int criteriaPackageID, string criteriaPackageCourses )
        //{
        //    try
        //    {
        //        NORCODataContext norco_db = new NORCODataContext();
        //        norco_db.SendMessage(body, from_user_id, from, to_user_id, email, subject, articulations, action, criteriaPackageID, criteriaPackageCourses);
        //    }
        //    catch (Exception e)
        //    {
        //        //Log error here
        //        return false;
        //    }

        //    return true;
        //}
        
        public static void SendMessage(string body, int from_user_id, string from, int to_user_id, string email, string subject, string articulations, string action, int criteriaPackageID, string criteriaPackageCourses, string proposed_cr, int fromRoleID, int toRoleID, bool isCC)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("SendMessage", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Body", body);
                    cmd.Parameters.AddWithValue("@FromUserID", from_user_id);
                    cmd.Parameters.AddWithValue("@From", from);
                    cmd.Parameters.AddWithValue("@ToUserID", to_user_id);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Subject", subject);
                    cmd.Parameters.AddWithValue("@Articulations", articulations);
                    cmd.Parameters.AddWithValue("@Action", action);
                    cmd.Parameters.AddWithValue("@CriteriaPackageID", criteriaPackageID);
                    cmd.Parameters.AddWithValue("@CriteriaPackageCourses", criteriaPackageID);
                    cmd.Parameters.AddWithValue("@ProposedCR", proposed_cr);
                    cmd.Parameters.AddWithValue("@FromRoleID", fromRoleID);
                    cmd.Parameters.AddWithValue("@ToRoleID", toRoleID);
                    cmd.Parameters.AddWithValue("@IsCC", isCC);
                    cmd.ExecuteNonQuery();
                }
            }
        }

 //       @Body[nvarchar] (max),
	//@FromUserID int,
	//@From[nvarchar] (256),
	//@ToUserID[int],
	//@Email[nvarchar] (256),
	//@Subject[nvarchar] (max),
	//@Articulations[varchar] (200),
	//@Action[varchar] (20),
	//@CriteriaPackageID int,	@CriteriaPackageCourses VARCHAR(MAX),
	//@ProposedCR int

        public static bool DeleteMessage(int message_id)
        {
            try
            {
                NORCODataContext norco_db = new NORCODataContext();
                norco_db.DeleteMessage(message_id);
            }
            catch (Exception e)
            {
                //Log error here
                return false;
            }

            return true;
        }
        public static bool SetMessageAsReaded(int message_id)
        {
            try
            {
                NORCODataContext norco_db = new NORCODataContext();
                norco_db.SetMessageAsReaded(message_id);
            }
            catch (Exception e)
            {
                //Log error here
                return false;
            }

            return true;
        }
    }
}
 