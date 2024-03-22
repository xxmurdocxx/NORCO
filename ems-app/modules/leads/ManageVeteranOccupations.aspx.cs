using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.leads
{
    public partial class ManageVeteranOccupations : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rlUpdateOptions.DataBind();
                rlUpdateOptions.SelectedValue = "1";
            }
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            rgVeteranLeads.DataBind();
            rgACEOccupations.DataBind();
        }

        protected void rgVeteranLeads_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "AddMOS")
            {
                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow("../popups/MOS.aspx", true, true, false, 800, 600));
            }
        }

        protected void rcbServices_PreRender(object sender, EventArgs e)
        {
            base.OnPreRender(e);
            if (!IsPostBack)
            {
                sqlAllOccupations.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbServices");
            }
        }

        protected void rcbServices_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlAllOccupations.SelectParameters["Service"].DefaultValue = SetSelectedIndexChange("rcbServices");
            rgACEOccupations.DataBind();
        }

        protected void rgACEOccupations_RowDrop(object sender, GridDragDropEventArgs e)
        {
            int draggedRows = 0;
            Hashtable values = new Hashtable();
            string occupation_id = "";
            if (e.DestDataItem != null)
            {
                if (e.DestinationTableView.OwnerGrid.ClientID == rgVeteranLeads.ClientID)
                {
                    if (rgVeteranLeads.SelectedItems.Count > 0)
                    {
                        foreach (GridDataItem draggedItem in e.DraggedItems)
                        {
                            draggedItem.ExtractValues(values);
                            occupation_id = (string)values["Occupation"];
                            draggedRows = e.DraggedItems.Count();

                            if (occupation_id != "")
                            {
                                if (draggedRows == 1)
                                {
                                    UpdateSelectedVeterans(occupation_id);
                                }
                            }
                        }
                        rgVeteranLeads.DataBind();
                    } else
                    {
                        DisplayMessage(false, "Please select a Veteran(s)");
                    }
                }
                else
                {
                    DisplayMessage(false, Resources.Messages.CantDropItem);
                }
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
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

        public void enableFields (bool active)
        {
            rtbOccupationCode.Enabled = active;
            rtbOccupationTitle.Enabled = active;
            rtbTeamRevd.Enabled = active;
            rcbService.Enabled = active;
        }

        protected void rbSave_Click(object sender, EventArgs e)
        {
            var aceid = string.Format("{0}-{1}-001", rcbService.SelectedValue, rtbOccupationCode.Text);
            var existOccupation = norco_db.CheckOccupationExist(rtbOccupationCode.Text);
            if (existOccupation == true)
            {
                DisplayMessage(false, "MOS already exist");
            } else
            {
                if (rgVeteranLeads.SelectedItems.Count > 0)
                {
                    if (hfAceID.Value != "")
                    {
                        UpdateSelectedVeterans(rtbOccupationCode.Text);
                    } else
                    {
                        var addOccupation = norco_db.AddNewACEOccupation(aceid, rtbTeamRevd.SelectedDate, rtbOccupationTitle.Text, rtbOccupationCode.Text, rcbService.SelectedValue);
                        var newOccupation = norco_db.GetOccupationById(addOccupation);
                        enableFields(false);
                        lblMessage.Visible = true;
                        lblMessage.Text = string.Format("MOS was created successfully with the ID : {0}", aceid);
                        hfAceID.Value = aceid;
                        foreach (GetOccupationByIdResult itemNew in newOccupation)
                        {
                            hfTeamRevd.Value = itemNew.TeamRevd.ToString();
                        }
                        UpdateSelectedVeterans(rtbOccupationCode.Text);
                    }
                    rgRecommendations.DataBind();
                    rgVeteranLeads.DataBind();
                    rgACEOccupations.DataBind();
                    pnlRecommendations.Visible = true;

                } else
                {
                    DisplayMessage(false, "Please select a Veteran(s)");
                }
            }
        }

        public void UpdateSelectedVeterans ( string new_occupation )
        {
            try
            {
                foreach (GridDataItem items in rgVeteranLeads.SelectedItems)
                {
                    if (rlUpdateOptions.SelectedValue == "1")
                    {
                        norco_db.UpdateVeteranOccupation(Convert.ToInt32(items["VeteranID"].Text), new_occupation, items["Occupation"].Text);
                    }
                    else
                    {
                        norco_db.UpdateVeteranOccupation(null, new_occupation, items["Occupation"].Text);
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(false, ex.ToString());
            }
        }

        protected void rgACEOccupations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.CommandName == "UpdateExistingMOS")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select an Occupation.");
                }
                else
                {
                    try
                    {
                        if (rgVeteranLeads.SelectedItems.Count > 0)
                        {
                            GridDataItem itemDetail = (GridDataItem)grid.MasterTableView.Items[grid.SelectedItems[0].ItemIndex];
                            UpdateSelectedVeterans(itemDetail["Occupation"].Text);
                            rgVeteranLeads.DataBind();
                            DisplayMessage(false, "Veterans Occupation(s) successfully updated.");
                        }
                        else
                        {
                            DisplayMessage(false, "Please select a veteran(s).");
                        }
                    }
                    catch (Exception ex)
                    {
                        DisplayMessage(false, ex.ToString());
                    }

                }
            }
        }
    }
}