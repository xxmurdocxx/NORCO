using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.military
{
    public partial class UnitsAwarded : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                rgUnitsAwarded.Rebind();
            }
        }

        protected void rcbPrograms_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlChildPrograms.SelectParameters["Program"].DefaultValue = SetSelectedIndexChange("rcbPrograms");
        }

        protected void rcbPrograms_PreRender(object sender, EventArgs e)
        {
            base.OnPreRender(e);
            if (!IsPostBack)
            {
                sqlChildPrograms.SelectParameters["Program"].DefaultValue = PreRenderComboBox("rcbPrograms");
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

        protected void rgUnitsAwarded_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ChildGridVeterans")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                string leadId = dataBoundItem["LeadId"].Text;
                string outline_id = dataBoundItem["outline_id"].Text;
                string program_id = dataBoundItem["program_id"].Text;
                string email = dataBoundItem["email"].Text;
                LinkButton btnPrintVeteranLetter = e.Item.FindControl("btnPrintVeteranLetter") as LinkButton;
                btnPrintVeteranLetter.OnClientClick = "javascript:ShowTemplate('" + leadId + "','1','" + email + "')";
                //btnPrintVeteranLetter.OnClientClick = "javascript:ShowVeteranLetterReport('" + leadId + "')";
                LinkButton btnEmailLetter = e.Item.FindControl("btnEmailLetter") as LinkButton;
                btnEmailLetter.OnClientClick = "javascript:ShowTemplate('" + leadId + "','1','" + email + "')";
                LinkButton btnPhoneScript = e.Item.FindControl("btnPhoneScript") as LinkButton;
                btnPhoneScript.OnClientClick = "javascript:ShowTemplate('" + leadId + "','2','" + email + "')";
            }
        }

        protected void rgUnitsAwarded_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.CommandName == "EditLead")
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
                            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Lead.aspx?LeadId={0}&VeteranId={1}", itemDetail["LeadId"].Text, itemDetail["VeteranId"].Text), true, true, false, 1100, 700));
                        }
                    }
                }
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }



    }
}