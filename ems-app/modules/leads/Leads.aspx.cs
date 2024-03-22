using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.leads
{
    public partial class Leads : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hvExcludeArticulationOverYears.Value = GlobalUtil.ReadSetting("ExcludeArticulationOverYears");
                rgVeteranLeads.MasterTableView.GetColumn("Units").Display = false;
                sqlVeteranLeads.DataBind();
                rgVeteranLeads.DataBind();
                pnlProgramSelection.Visible = false;
                pnlArticulations.Visible = false;
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgCampaigns_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.CommandName == "RowClick")
            {
                pnlProgramSelection.Visible = true;
                pnlArticulations.Visible = false;
                GridDataItem item = (GridDataItem)e.Item;
                hfCampaignID.Value = item["Id"].Text;
                hfCampaignDescription.Value = item["Description"].Text;
                Session["ReturnCampaignID"] = item["Id"].Text;
                sqlVeteranLeads.SelectParameters["Exhibits"].DefaultValue = "";
                sqlVeteranLeads.DataBind();
                rgVeteranLeads.DataBind();
            }
            if (e.CommandName == "AddCampaign")
            {
                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Campaign.aspx"), true, true, false, 800, 500));
            }
            if (e.CommandName == "Upload" || e.CommandName == "EditCampaign")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, Resources.Messages.SelectCampaign);
                }
                else
                {
                    foreach (GridDataItem itemDetail in grid.Items)
                    {
                        if (itemDetail.Selected)
                        {
                            if (e.CommandName == "Upload")
                            {
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/UploadVeterans.aspx?CampaignID={0}", itemDetail["Id"].Text), true, true, false, 1100, 600));
                            }
                            if (e.CommandName == "EditCampaign")
                            {
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Campaign.aspx?CampaignId={0}", itemDetail["Id"].Text), true, true, false, 800, 500));
                                rgCampaigns.Rebind();
                            }
                        }
                    }
                }
            }
            //rgCampaigns.Rebind();
        }

        protected void rgVeteranLeads_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.CommandName == "RowClick")
            {
                pnlArticulations.Visible = false;
                GridDataItem item = (GridDataItem)e.Item;
                sqlArticulationsByOccupationCode.SelectParameters["Occupation"].DefaultValue = item["Occupation"].Text;
                sqlArticulationsByOccupationCode.SelectParameters["VeteranID"].DefaultValue = item["VeteranID"].Text;
                OccupationCodeTitle.InnerHtml = string.Format("Articulation(s) for Occupation Code {0}", item["Occupation"].Text);
                rgArticulations.DataBind();
                rgArticulations.MasterTableView.AllowPaging = false;
                rgArticulations.Rebind();
                if (rgArticulations.MasterTableView.Items.Count > 0)
                {
                    pnlArticulations.Visible = true;
                }
                rgArticulations.MasterTableView.AllowPaging = true;
                rgArticulations.Rebind();            
            }
            if (e.CommandName == "ExportToExcel")
            {
                grid.ExportToExcel();
            }
            if (e.CommandName == "AddVeterans")
            {
                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Veterans.aspx?CampaignID={0}&CampaignDescription={1}", hfCampaignID.Value, hfCampaignDescription.Value), true, true, false, 1290, 650));
            }
            if (e.CommandName == "FlagToBeContacted")
            {
                foreach (GridDataItem itemDetail in grid.Items)
                {
                    norco_db.FlagToBeContacted(Convert.ToInt32(itemDetail["Id"].Text));
                }
                grid.DataBind();
            }
            if (e.CommandName == "EditLead" || e.CommandName == "PrintVeteranLetter" || e.CommandName == "DeleteVeteran" || e.CommandName=="ShowOccupation" || e.CommandName == "AddArticulation")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select a veteran");
                }
                else
                {
                    foreach (GridDataItem itemDetail in grid.Items)
                    {
                        if (itemDetail.Selected)
                        {
                            if (e.CommandName == "EditLead")
                            {
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Lead.aspx?LeadId={0}&VeteranId={1}", itemDetail["Id"].Text, itemDetail["VeteranId"].Text), true, true, false, 1300, 750));
                            }
                            if (e.CommandName == "DeleteVeteran")
                            {
                                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                                {
                                    using (SqlCommand comm = new SqlCommand("DELETE FROM [VeteranLead] WHERE [ID] = @LeadID", conn))
                                    {
                                            comm.Parameters.Add(new SqlParameter("LeadID", itemDetail["Id"].Text));
                                            conn.Open();
                                            comm.ExecuteNonQuery();
                                    }
                                }
                                rgVeteranLeads.DataBind();
                            }
                            if (e.CommandName == "PrintVeteranLetter")
                            {
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/ShowTemplate.aspx?TemplateType=1&LeadId={0}&email={1}", itemDetail["Id"].Text, itemDetail["Email"].Text), true, true, false, 1100, 650));
                            }
                            if (e.CommandName == "ShowOccupation")
                            {
                                if (itemDetail["OccupationTitle"].Text != "Unknown")
                                {
                                    var url = String.Format("../popups/ShowOccupation.aspx?AceID={0}&TeamRevd={1}&Occupation={2}&Title={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Occupation"].Text, itemDetail["OccupationTitle"].Text);
                                    RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, 900, 600));
                                }
                                
                            }
                            if (e.CommandName == "AddArticulation")
                            {
                                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../military/Articulate.aspx?Occupation={0}", itemDetail["Occupation"].Text) + "');", true);
                            }
                        }
                    }
                }
            }
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            hfCampaignID.Value = Session["ReturnCampaignID"].ToString();
            sqlCampaigns.DataBind();
            sqlVeteranLeads.SelectParameters["CampaignID"].DefaultValue = hfCampaignID.Value;
            sqlVeteranLeads.SelectParameters["CollegeID"].DefaultValue = Session["CollegeID"].ToString();
            sqlVeteranLeads.DataBind();
            rgCampaigns.DataBind();
            rgVeteranLeads.DataBind();
            foreach (GridDataItem item in rgCampaigns.MasterTableView.Items)
            {
                if (item["Id"].Text == Session["ReturnCampaignID"].ToString())
                {
                    item.Selected = true;
                }
            }
        }

        protected void rgCampaigns_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.IsInEditMode && (e.Item is GridEditFormItem))
            {
                GridEditFormItem gridEditFormItem = (GridEditFormItem)e.Item;
                RadEditor radEditor = (RadEditor)gridEditFormItem["Notes"].Controls[0];
                radEditor.ContentAreaCssFile = "~/Common/css/Editor.css";
                radEditor.BackColor = System.Drawing.Color.White;

            }
        }

        protected void rgVeteranLeads_ItemDataBound(object sender, GridItemEventArgs e)
        {
            //if (e.Item is GridDataItem) // bind the intended column cells
            //{
            //    GridDataItem dataBoundItem = e.Item as GridDataItem;
            //    string isPublished = dataBoundItem["OccupationIsPublished"].Text;
            //    if (isPublished == "True")
            //    {
            //        dataBoundItem["Occupation"].ForeColor = System.Drawing.Color.White;
            //        dataBoundItem["OccupationTitle"].ForeColor = System.Drawing.Color.White;
            //        dataBoundItem["Occupation"].BackColor = System.Drawing.Color.Green;
            //        dataBoundItem["OccupationTitle"].BackColor = System.Drawing.Color.Green;
            //        dataBoundItem["Occupation"].ToolTip = "Occupation Published";
            //        dataBoundItem["OccupationTitle"].ToolTip = "Occupation Published";
            //    }
            //}

            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridDataItem )
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var OccupationTitle = dataBoundItem["OccupationTitle"].Text;
                LinkButton showOccupation = e.Item.FindControl("lnkShowOccupation") as LinkButton;
                if (OccupationTitle == "Unknown")
                {
                    showOccupation.Visible = false;
                }
            }
        }

        protected void rcbPrograms_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlVeteranLeadsByProgram.SelectParameters["Program"].DefaultValue = SetSelectedIndexChange("rcbPrograms");
            if (rcbPrograms.CheckedItems.Count > 1)
            {
                var sb = new StringBuilder();
                var collection = rcbPrograms.CheckedItems;

                    sb.Append("<h3>Selected programs : </h3><ul>");

                    foreach (var item in collection)
                        sb.Append("<li>" + item.Text + "</li>");

                    sb.Append("</ul>");

                    divSelectedPrograms.InnerHtml = sb.ToString();
            } else
            {
                divSelectedPrograms.InnerHtml = "";
            }
            lblTotalVeterans.Text = string.Format("Total Veterans : {0}", norco_db.CountVeteransInSelectedPrograms(Convert.ToInt32(Session["CollegeID"].ToString()), Convert.ToInt32(hfCampaignID.Value), SetSelectedIndexChange("rcbPrograms")).ToString() );
            lblTotalUnits.Text = string.Format("Total Units : {0}", norco_db.SumVeteransUnitsInSelectedPrograms(Convert.ToInt32(Session["CollegeID"].ToString()), SetSelectedIndexChange("rcbPrograms")).ToString() );
            pnlProgramsResult.Visible = true;
        }

        protected void rcbPrograms_PreRender(object sender, EventArgs e)
        {
            base.OnPreRender(e);
            if (!IsPostBack)
            {
                sqlVeteranLeadsByProgram.SelectParameters["Program"].DefaultValue = PreRenderComboBox("rcbPrograms");
            }
        }

        protected void rcbFilterByPrograms_CheckedChanged(object sender, EventArgs e)
        {
            pnlPrograms.Visible = false;
            pnlProgramsResult.Visible = false;
            if (rcbFilterByPrograms.Checked == true)
            {
                pnlPrograms.Visible = true;
                rgVeteranLeads.MasterTableView.GetColumn("Units").Display = true;
                rgVeteranLeads.DataSourceID = "sqlVeteranLeadsByProgram";
                rgVeteranLeads.DataBind();

            } else
            {
                rgVeteranLeads.MasterTableView.GetColumn("Units").Display = false;
                rgVeteranLeads.DataSourceID = "sqlVeteranLeads";
                rgVeteranLeads.DataBind();
                
                divSelectedPrograms.InnerHtml = "";
                lblTotalUnits.Text = "";
                lblTotalVeterans.Text = "";
                rcbPrograms.ClearSelection();
            }
        }

        public String PreRenderComboBox(string controlID)
        {
            RadComboBox listBox = (RadComboBox)FindControlRecursive(Page, controlID);
            var data = "";
            foreach (RadComboBoxItem itm in listBox.Items)
            {
                itm.Checked = true;

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
                data = String.Join(",", DataFieldsArray);
            }
            return data;
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

        protected void rgArticulations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                if (grid.ID == "rgFacultyReviewArticulations")
                {
                    int haveDeniedArticulations = Convert.ToInt32(dataBoundItem["HaveDeniedArticulations"].Text);
                    LinkButton btnHaveDeniedArticulations = e.Item.FindControl("btnHaveDeniedArticulations") as LinkButton;
                    btnHaveDeniedArticulations.Visible = false;
                    if (haveDeniedArticulations > 0)
                    {
                        btnHaveDeniedArticulations.Visible = true;
                        btnHaveDeniedArticulations.Style.Add("color", "#ff0000");
                    }
                }
            }
        }

        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);
            var id = Convert.ToInt32(hvID.Value);
            var outline_id = Convert.ToInt32(hvOutlineID.Value);
            var team_revd = Convert.ToDateTime(hvTeamRevd.Value);
            var articulation_type = Convert.ToInt32(hvArticulationType.Value);
            try
            {
                switch (e.Item.Text)
                {
                    case "Edit":
                        showArticulation(id, articulation_type, outline_id, hvAceID.Value, hvTitle.Value, team_revd, false, 0, false, "", "NewTab", 0, 0);
                        break;
                    case "View":
                        showArticulation(id, articulation_type, outline_id, hvAceID.Value, hvTitle.Value, team_revd, true, 0, false, "", "NewTab", 0, 0);
                        break;
                    default:
                        break;
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }

        }
        protected void rgArticulations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            var url = "";
            if (e.CommandName == "ShowACEExhibit")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select an articulation");
                }
                else
                {
                    foreach (GridDataItem itemDetail in grid.Items)
                    {
                        if (itemDetail.Selected)
                        {
                            if (e.CommandName == "ShowACEExhibit")
                            {
                                if (itemDetail["ArticulationTypeName"].Text == "Occupation")
                                {
                                    url = String.Format("../popups/ShowOccupation.aspx?AceID={0}&TeamRevd={1}&Occupation={2}&Title={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Occupation"].Text, itemDetail["Title"].Text);
                                } else
                                {
                                    url = String.Format("../popups/ShowACECourseDetail.aspx?AceID={0}&TeamRevd={1}&Occupation={2}&Title={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Occupation"].Text, itemDetail["Title"].Text);
                                }
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, 900, 600));
                            }
                        }
                    }
                }
            }

        }

        public void showArticulation(int id, int articulation_type, int outline_id, string AceID, string Title, DateTime TeamRevd, bool isReadOnly, int otherCollegeID, bool adoptArticulation, string collegeName, string modalWindow, int width, int height)
        {
            var urlPage = "../popups/AssignArticulation.aspx";
            var readOnlyParameter = "";
            if (isReadOnly)
            {
                readOnlyParameter = "&isReadOnly=true";
            }

            if (articulation_type == 2)
            {
                urlPage = "../popups/AssignOccupationArticulation.aspx";
            }
            if (modalWindow.Equals("NewTab"))
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("{0}?articulationID={1}&outline_id={2}&AceID={3}&Title={4}&TeamRevd={5}&NewWindow=true{6}&OtherCollegeID={7}&AdoptArticulation={8}&CollegeName={9}", urlPage, id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), readOnlyParameter, otherCollegeID.ToString(), adoptArticulation.ToString(), collegeName.ToString()) + "');", true);
            }
            else
            if (modalWindow.Equals("Popup"))
            {
                var url = String.Format("{0}?articulationID={1}&outline_id={2}&AceID={3}&Title={4}&TeamRevd={5}&NewWindow=true{6}&OtherCollegeID={7}&AdoptArticulation={8}&CollegeName={9}", urlPage, id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), readOnlyParameter, otherCollegeID.ToString(), adoptArticulation.ToString(), collegeName.ToString());
                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, width, height));
            }
        }

        protected void rbExhibitSearch_Click(object sender, EventArgs e)
        {
            var texts = new List<string>();
            foreach (AutoCompleteBoxEntry entry in racbAceExhibit.Entries)
            {
                texts.Add(entry.Value);
            }
            var exhibits = string.Join(",", texts);
            sqlVeteranLeads.SelectParameters["CampaignID"].DefaultValue = hfCampaignID.Value;
            sqlVeteranLeads.SelectParameters["CollegeID"].DefaultValue = Session["CollegeID"].ToString();
            sqlVeteranLeads.SelectParameters["Exhibits"].DefaultValue = exhibits;
            sqlVeteranLeads.DataBind();
            rgVeteranLeads.DataBind();
        }

        protected void rbExhibitSearchClear_Click(object sender, EventArgs e)
        {
            racbAceExhibit.Entries.Clear();
            sqlVeteranLeads.SelectParameters["Exhibits"].DefaultValue = "";
            sqlVeteranLeads.DataBind();
            rgVeteranLeads.DataBind();
        }
    }
}