using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.UserControls.students
{
    public partial class MilitaryCredits : System.Web.UI.UserControl
    {
        private int college_id = 0;
        private int veteran_id = 0;

        public int CollegeID
        {
            get { return college_id; }
            set { college_id = value; }
        }
        public int VeteranID
        {
            get { return veteran_id; }
            set { veteran_id = value; }
        }
        public bool DisableControl { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfCollege.Value = CollegeID.ToString();
                hfVeteranID.Value = VeteranID.ToString();

                this.pnlMilitaryCredits.Enabled = !DisableControl;

                sqlMilitaryCredits.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlMilitaryCredits.SelectParameters["VeteranID"].DefaultValue = VeteranID.ToString();
                sqlMilitaryCredits.DataBind();
                sqlSelected.SelectParameters["VeteranID"].DefaultValue = hfVeteranID.Value;
                sqlSelected.DataBind();
            }
        }

        protected void AddElegibleCredit(int veteran_id, int articulation_id, int ace_exibit_id, int user_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("AddElegibleCredits", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@VeteranID", veteran_id);
                    cmd.Parameters.AddWithValue("@ArticulationID", articulation_id);
                    cmd.Parameters.AddWithValue("@AceExhibitID", ace_exibit_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        protected void DeleteElegibleCredit(int id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand("DeleteElegibleCredits", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        public void showArticulation(int id, int articulation_type, int outline_id, string AceID, string Title, DateTime TeamRevd, int ExhibitID)
        {
            if (articulation_type == 1)
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
            }

        }
        protected void rgMilitaryCredits_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            try
            {
                if (e.CommandName == "Delete" || e.CommandName == "Apply" || e.CommandName == "View")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        rnElegibleCredits.Text = "Select an Articulation.";
                        rnElegibleCredits.Show();
                    }
                    else
                    {
                        if (e.CommandName == "View")
                        {
                            foreach (GridDataItem item in grid.SelectedItems)
                            {
                                showArticulation(Convert.ToInt32(item["id"].Text), Convert.ToInt32(item["ArticulationType"].Text), Convert.ToInt32(item["outline_id"].Text), item["AceID"].Text, item["Title"].Text, Convert.ToDateTime(item["TeamRevd"].Text), Convert.ToInt32(item["AceExhibitID"].Text));
                            }
                            
                        }
                        if (e.CommandName == "Delete")
                        {
                            foreach (GridDataItem item in grid.SelectedItems)
                            {
                                DeleteElegibleCredit(Convert.ToInt32(item["id"].Text));
                            }
                        }
                        if (e.CommandName == "Apply")
                        {
                            foreach (GridDataItem item in grid.SelectedItems)
                            {
                                AddElegibleCredit(Convert.ToInt32(hfVeteranID.Value), Convert.ToInt32(item["id"].Text), Convert.ToInt32(item["AceExhibitID"].Text), Convert.ToInt32(Session["UserID"].ToString()));
                            }
                        }
                        sqlSelected.SelectParameters["VeteranID"].DefaultValue = hfVeteranID.Value;
                        sqlSelected.DataBind();
                        rgSelected.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                rnElegibleCredits.Text = ex.ToString();
                rnElegibleCredits.Show();
            }
        }
    }
}