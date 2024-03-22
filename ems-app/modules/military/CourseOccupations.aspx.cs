using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.military
{
    public partial class CourseOccupations : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfExcludeArticulationOverYears.Value = GlobalUtil.ReadSetting("ExcludeArticulationOverYears");
                rchkExcludeYears.Checked = true;
                rchkExcludeYears.Text += string.Format(" {0} years.", GlobalUtil.ReadSetting("ExcludeArticulationOverYears"));
            }
        }


        protected void clearOccupationLabel (object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            //lblSelectedOccupation.Text = "";
        }


        protected void rcbServices_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlCourseOccupations.SelectParameters["Service"].DefaultValue = SetSelectedIndexChange("rcbServices");
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

        protected void rcbServices_PreRender(object sender, EventArgs e)
        {
            base.OnPreRender(e);
            if (!IsPostBack)
            {
                sqlCourseOccupations.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbServices");
            }
        }

        protected void rchkExcludeYears_CheckedChanged(object sender, EventArgs e)
        {
            if (rchkExcludeYears.Checked == true)
            {
                hfExcludeArticulationOverYears.Value = GlobalUtil.ReadSetting("ExcludeArticulationOverYears");
            }
            else
            {
                hfExcludeArticulationOverYears.Value = "200";
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgCourseOccupations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            try
            {
                GridDataItem itemDetail = e.Item as GridDataItem;
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Select an ACE occupation.");
                }
                else
                {
                    if (e.CommandName == "ShowAceOccupation")
                    {
                        var url = String.Format("../popups/ShowOccupation.aspx?AceID={0}&TeamRevd={1}&Occupation={2}&Title={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Occupation"].Text, itemDetail["Title"].Text);
                        RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, 900, 600));
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(false, ex.ToString());
            }
        }
    }
}