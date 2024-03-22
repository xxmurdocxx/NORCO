using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class ShowOccupations : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                courseTitle.InnerText = String.Format("Related Occupations for {0} - {1}", Request["Exhibit"], Request["Title"]);
            }
        }


        protected void rcbServices_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlAllOccupations.SelectParameters["Service"].DefaultValue = SetSelectedIndexChange("rcbServices");
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
                sqlAllOccupations.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbServices");
            }
        }

        protected void rgACEOccupations_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.CommandName == "AddOccupation")
            {
                foreach (GridDataItem itemDetail in grid.Items)
                {
                    if ((itemDetail.FindControl("CheckBox1") as CheckBox).Checked)
                    {
                        norco_db.AddOccupations(Request["AceID"], Convert.ToDateTime(Request["TeamRevd"]), itemDetail["Occupation"].Text);
                    }
                }
                grid.DataBind();
                rgCourseOccupations.DataBind();
                rgACEOccupations.DataBind();
            }
        }

        protected void ToggleRowSelection(object sender, EventArgs e)
        {
            ((sender as CheckBox).NamingContainer as GridItem).Selected = (sender as CheckBox).Checked;
            bool checkHeader = true;
            foreach (GridDataItem dataItem in rgACEOccupations.MasterTableView.Items)
            {
                if (!(dataItem.FindControl("CheckBox1") as CheckBox).Checked)
                {
                    checkHeader = false;
                    break;
                }
            }
            GridHeaderItem headerItem = rgACEOccupations.MasterTableView.GetItems(GridItemType.Header)[0] as GridHeaderItem;
            (headerItem.FindControl("headerChkbox") as CheckBox).Checked = checkHeader;
        }
        protected void ToggleSelectedState(object sender, EventArgs e)
        {
            CheckBox headerCheckBox = (sender as CheckBox);
            foreach (GridDataItem dataItem in rgACEOccupations.MasterTableView.Items)
            {
                (dataItem.FindControl("CheckBox1") as CheckBox).Checked = headerCheckBox.Checked;
                dataItem.Selected = headerCheckBox.Checked;
            }
        }

    }
}