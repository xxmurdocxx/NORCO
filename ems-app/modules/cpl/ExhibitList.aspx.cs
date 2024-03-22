using DocumentFormat.OpenXml.Office2010.Excel;
using ems_app.modules.military;
using ems_app.UserControls;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO.Packaging;
using System.Linq;
using System.Security.Policy;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.cpl
{
    public partial class ExhibitList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rcbColleges.DataBind();
                hfCollegeID.Value = Session["CollegeID"].ToString();
                rcbColleges.SelectedValue = Session["CollegeID"].ToString();
            }
        }
         
        protected void rgCPLExhibits_ItemCommand(object sender, GridCommandEventArgs e)
        {
            try
            {

                RadGrid grid = (RadGrid)sender;
                GridDataItem itemDetail = e.Item as GridDataItem;

                if (e.CommandName == "EditExhibit")
                {
                    var url = $"Exhibits.aspx?ID={itemDetail["ID"].Text}";
                    hfSelectedExhibitID.Value = itemDetail["ID"].Text;
                    hfSelectedAceID.Value = itemDetail["AceID"].Text;
                    rbViewExhibit.NavigateUrl = $"{url}&ReadOnly=True";

                    if (CheckExhibitHaveArticulations(itemDetail["ID"].Text, Session["CollegeID"].ToString()) == 0)
                    {
                        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "popup", $"window.open('{url}','_blank')", true);
                    }
                    else
                    {
                        if (Convert.ToBoolean(Session["SuperUser"]) == true && Session["RoleName"].ToString() == "Ambassador")
                        {
                            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "popup", $"window.open('{url}','_blank')", true);
                        } else
                        {
                            string script = "function f(){$find(\"" + rw_customConfirm.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                        }
                    }
                }
                //if (e.CommandName == RadGrid.ExpandCollapseCommandName)
                //{
                //    ExhibitArticulations uc = (ExhibitArticulations)((GridDataItem)e.Item).ChildItem.FindControl("ExhibitArticulations");
                //    uc.ExhibitID = Convert.ToInt32(itemDetail["ID"].Text);
                //    uc.DataBind();
                //    uc.RefreshData();
                //}
                if (e.CommandName == "View")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
                    var url = $"Exhibits.aspx?ID={itemDetail["ID"].Text}&ReadOnly=True";
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "popup", $"window.open('{url}','_blank')", true);
                }
                if (e.CommandName == "Delete")
                {
                    rbDelete.Visible = false;
                    confirmText.Text = "This Exhibit have existing articulations.";
                    if (CheckExhibitHaveArticulations(itemDetail["ID"].Text, Session["CollegeID"].ToString()) == 0)
                    {
                        confirmText.Text = "Are you sure you want to delete this Exhibit ?";
                        hfSelectedExhibitID.Value = itemDetail["ID"].Text;
                        hfSelectedAceID.Value = itemDetail["AceID"].Text;
                        rbDelete.Visible = true;
                    }
                    string script = "function f(){$find(\"" + rwConfirmDelete.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                }
                if (e.CommandName == "Clone")
                {
                    hfSelectedExhibitID.Value = itemDetail["ID"].Text;
                    hfSelectedAceID.Value = itemDetail["AceID"].Text;
                    string script = "function f(){$find(\"" + rwConfirmClone.ClientID + "\").show(); Sys.Application.remove_load(f);}Sys.Application.add_load(f);";
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script, true);
                }
                if (e.CommandName == "ExportToExcel")
                {
                    grid.ExportToExcel();
                }
            }
            catch (Exception msg)
            {
                rnMessage.Text = msg.Message;
                rnMessage.Title = "Error";
                rnMessage.Show();
            }

        }

        protected void rgCPLExhibits_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                LinkButton btnClone = e.Item.FindControl("btnClone") as LinkButton;
                LinkButton btnView = e.Item.FindControl("btnView") as LinkButton;
                LinkButton btnEdit = e.Item.FindControl("btnEdit") as LinkButton;
                LinkButton btnDelete = e.Item.FindControl("btnDelete") as LinkButton;
                LinkButton btnPrint = e.Item.FindControl("btnPrint") as LinkButton;
                btnClone.Visible = false;
                btnView.Visible = false;
                if (dataBoundItem["CollegeID"].Text != Session["CollegeID"].ToString())
                {
                    btnClone.Visible = false;
                    btnView.Visible = true;
                    btnEdit.Visible = false;
                    btnDelete.Visible = false;
                }
                btnClone.Enabled = false;

                int id = Convert.ToInt32(dataBoundItem["ID"].Text);
                var url = $"'../reports/CPLExhibits.aspx?ExhibitID={id}&CollegeID={hfCollegeID.Value}'";
                btnPrint.OnClientClick = $"javascript:OpenPopupWindow({url},1000,600,false)";
                GridNestedViewItem nestedViewItem = (GridNestedViewItem)dataBoundItem.ChildItem;
                if (nestedViewItem != null)
                {
                    ExhibitArticulations uc = (ExhibitArticulations)nestedViewItem.FindControl("ExhibitArticulations");
                    if (uc != null)
                    {
                        uc.ExhibitID = Convert.ToInt32(id);
                    }
                }
            }
            //if (e.Item is GridNestedViewItem)
            //{
            //    Label id = (Label)((GridNestedViewItem)e.Item).FindControl("lblID");
            //    ExhibitArticulations uc = (ExhibitArticulations)((GridNestedViewItem)e.Item).FindControl("ExhibitArticulations");
            //    uc.ExhibitID = Convert.ToInt32(id.Text);
            //    uc.DataBind();
            //}
        }

        protected void rbConfirmNewVersion_OK_Click(object sender, EventArgs e)
        {
            try
            {
                var id = CreateCPLExhibitNewVersion(hfSelectedExhibitID.Value, Session["UserID"].ToString());
                rnMessage.Title = "Exhibit New Version";
                if (id == 0)
                {
                    rnLiteral.Text = $"Exhibit already exists.";
                }
                else
                {
                    rnLiteral.Text = $"A New Version for Exhibit {hfSelectedAceID.Value} successfully created.";
                    HyperLink lnkExhibit = new HyperLink();
                    lnkExhibit.Text = $"Click here to view New Version Exhibit";
                    lnkExhibit.NavigateUrl = $"Exhibits.aspx?ID={id}";
                    lnkExhibit.Target = "_blank";
                    rnMessage.ContentContainer.Controls.Add(lnkExhibit);
                    rgCPLExhibits.DataBind();
                }
                rnMessage.Show();
            }
            catch (Exception msg)
            {
                rnMessage.Text = msg.Message;
                rnMessage.Title = "Error";
                rnMessage.Show();
            }

        }

        protected void rbConfirmRevision_OK_Click(object sender, EventArgs e)
        {
            try
            {
                var id = CreateCPLExhibitRevision(hfSelectedExhibitID.Value, Session["UserID"].ToString());
                rnMessage.Title = "Exhibit Revision";
                if (id == 0)
                {
                    rnLiteral.Text = $"Exhibit already exists.";
                }
                else
                {
                    rnLiteral.Text = $"A revision for Exhibit {hfSelectedAceID.Value} successfully created.";
                    HyperLink lnkExhibit = new HyperLink();
                    lnkExhibit.Text = $"Click here to view revised Exhibit";
                    lnkExhibit.NavigateUrl = $"Exhibits.aspx?ID={id}";
                    lnkExhibit.Target = "_blank";
                    rnMessage.ContentContainer.Controls.Add(lnkExhibit);
                    rgCPLExhibits.DataBind();
                }
                rnMessage.Show();
            }
            catch (Exception msg)
            {
                rnMessage.Text = msg.Message;
                rnMessage.Title = "Error";
                rnMessage.Show();
            }
        }

        public static int CheckExhibitHaveArticulations(string ExhibitID, string CollegeID)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select isnull(count(*),0) from Articulation where ExhibitID = {ExhibitID} and CollegeID = {CollegeID};";
                    result = (int)cmd.ExecuteScalar();
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }

        private static int CloneCPLExhibit(string exhibit_id, string user_id, string college_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("CloneCPLExhibit", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    cmd.Parameters.AddWithValue("@CollegeID", college_id);
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);
                    cmd.ExecuteNonQuery();

                    return Convert.ToInt32(outParm.Value);
                }
            }
        }

        private void DeleteCPLExhibit(string exhibit_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("DeleteExhibit", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ID", exhibit_id);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private static int CreateCPLExhibitRevision(string exhibit_id, string user_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("CreateCPLExhibitRevision", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);
                    cmd.ExecuteNonQuery();

                    return Convert.ToInt32(outParm.Value);
                }
            }
        }

        private static int CreateCPLExhibitNewVersion(string exhibit_id, string user_id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("CreateCPLExhibitNewVersion", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitID", exhibit_id);
                    cmd.Parameters.AddWithValue("@UserID", user_id);
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);
                    cmd.ExecuteNonQuery();

                    return Convert.ToInt32(outParm.Value);
                }
            }
        }

        protected void rbDelete_Click(object sender, EventArgs e)
        {
            DeleteCPLExhibit(hfSelectedExhibitID.Value);
            rgCPLExhibits.DataBind();
            rnLiteral.Text = $"Exhibit {hfSelectedAceID.Value} successfully deleted.";
            rnMessage.Title = "Delete Exhibit";
            rnMessage.Show();
        }

        protected void rbClone_Click(object sender, EventArgs e)
        {
            var id = CloneCPLExhibit(hfSelectedExhibitID.Value, Session["UserID"].ToString(), Session["CollegeID"].ToString());
            rnMessage.Title = "Clone Exhibit";
            if (id == 0)
            {
                rnLiteral.Text = $"Exhibit already exists.";
            }
            else
            {
                rnLiteral.Text = $"Exhibit {hfSelectedAceID.Value} successfully cloned.";
                HyperLink lnkClonedExhibit = new HyperLink();
                lnkClonedExhibit.Text = $"Click here to view cloned Exhibit";
                lnkClonedExhibit.NavigateUrl = $"Exhibits.aspx?ID={id}";
                lnkClonedExhibit.Target = "_blank";
                rnMessage.ContentContainer.Controls.Add(lnkClonedExhibit);
                rgCPLExhibits.DataBind();
            }
            rnMessage.Show();
        }

        protected void rgCreditRecommendations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "StudentIntake")
            {
                Session["SelectedCreditRecommendation"] = itemDetail["Criteria"].Text;
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../military/StudentList.aspx") + "');", true);
            }
        }

        protected void sqlExhibits_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.CommandTimeout = 720;
        }

        protected void rcbCollaborative_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            hvCollaborative.Value = SetSelectedIndexChange("rcbCollaborative").ToString();
            sqlExhibits.DataBind();
            rgCPLExhibits.DataBind();
        }
        private Control FindControlRecursive(Control rootControl, string controlID)
        {
            if (rootControl.ID == controlID) return rootControl;

            foreach (Control controlToSearch in rootControl.Controls)
            {
                Control controlToReturn = FindControlRecursive(controlToSearch, controlID);
                if (controlToReturn != null) return controlToReturn;
            }
            return null;
        }

        public String SetSelectedIndexChange(string controlID)
        {
            RadComboBox listBox = (RadComboBox)FindControlRecursive(Page, controlID);
            int itemschecked = listBox.CheckedItems.Count;
            String[] DataFieldsArray = new String[itemschecked];
            var collection = listBox.CheckedItems;
            int i = 0;
            foreach (var item in collection)
            {
                String value = item.Value;
                DataFieldsArray[i] = value;
                i++;
            }
            return String.Join(",", DataFieldsArray);
        }

        protected void rgCoursesArticulated_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "View")
            {
                showArticulation(Convert.ToInt32(itemDetail["ID"].Text), Convert.ToInt32(itemDetail["outline_id"].Text), itemDetail["AceID"].Text, itemDetail["Title"].Text, Convert.ToDateTime(itemDetail["TeamRevd"].Text), Convert.ToInt32(itemDetail["ExhibitID"].Text));
            }
        }

        protected void rgCoursesArticulated_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;

                LinkButton lbView = e.Item.FindControl("btnView") as LinkButton;
                lbView.Visible = false;
                if (dataBoundItem["ID"].Text != "0")
                {
                    lbView.Visible = true;
                }

            }
        }

        public void showArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, int ExhibitID)
        {
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
        }

    }
}