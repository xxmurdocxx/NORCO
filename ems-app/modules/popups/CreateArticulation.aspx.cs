using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Data;

namespace ems_app.modules.popups
{
    public partial class CreateArticulation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hvCollegeID.Value = Session["CollegeID"].ToString();
                hvUserID.Value = Session["UserID"].ToString();
                //hvUnits.Value = Request["Units"].ToString();
                if (Request["OutlineID"].ToString() != "0")
                {
                    hvOutlineID.Value = Request["OutlineID"].ToString();
                    rcbCourses.SelectedValue = Request["OutlineID"].ToString();
                }
                if (Request["AreaCredit"] != null)
                {
                    sqlCourses.SelectParameters["CourseType"].DefaultValue = "2";
                    sqlCourses.DataBind();
                    rcbCourses.Label = "Area Credit : ";
                    rcbCourses.EmptyMessage = "Select Area Credit...";
                    rcbCourses.DataBind();
                    pnlDisclaimer.Visible = true;
                }
            }
        }

        protected void rbCreate_Click(object sender, EventArgs e)
        {
            int articulation_id = 0;
            int exhibit = 99;
            string outline = hvOutlineID.Value == String.Empty ? rcbCourses.SelectedValue : hvOutlineID.Value;
            var articulationExists = Controllers.Articulation.CheckArticulationExists(Convert.ToInt32(outline), Request["AceID"].ToString(), Convert.ToDateTime(Request["TeamRevd"].ToString()));
            if (articulationExists == 0)
            {
                try
                {
                    if (Session["AceExhibitID"] != null)
                    {
                        if (Session["AceExhibitID"].ToString() != "")
                        {
                            exhibit = Convert.ToInt32(Session["AceExhibitID"].ToString());
                        }
                    }
                    articulation_id = Controllers.Articulation.AddArticulation(Convert.ToInt32(rcbCourses.SelectedValue), Request["AceID"].ToString(), Convert.ToDateTime(Request["TeamRevd"].ToString()), Request["Title"].ToString(), "", "", "", "", Convert.ToInt32(Request["ArticulationType"].ToString()), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), false, Convert.ToInt32(Request["SourceID"].ToString()), false, exhibit, Session["Criteria"].ToString(), Session["CriteriaID"].ToString());
                    rnMessage.Text = "Articulation has been created.";
                    rnMessage.Show();
                    ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
                }
                catch (Exception ex)
                {
                    rnMessage.Text = ex.Message;
                    rnMessage.Show();
                }
            }
            else
            {
                rnMessage.Text = "Articulation already exists.";
                rnMessage.Show();
            }
        }
    }
}