using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.military
{
    public partial class AssignOccupations : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, Telerik.Web.UI.AjaxRequestEventArgs e)
        {
            rgACECourses.DataBind();
        }


        protected void rgACECourses_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && e.Item.OwnerTableView.Name == "ParentGrid")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                int haveOccupations = Convert.ToInt32(dataBoundItem["HaveOccupations"].Text);
                string AceId = dataBoundItem["AceID"].Text;
                string TeamRevd = dataBoundItem["TeamRevd"].Text;
                string Title = dataBoundItem["Title"].Text;
                string AdvancedSearch = rtbAttribute.Text;
                LinkButton btnHaveOccuppations = e.Item.FindControl("btnHaveOccupations") as LinkButton;
                if (haveOccupations == 1)
                {
                    btnHaveOccuppations.BackColor = System.Drawing.Color.LightGreen;
                }
                else
                {
                    btnHaveOccuppations.ToolTip = "Course without related occupations";
                }
                LinkButton btnViewCourseDetails = e.Item.FindControl("btnViewCourseDetails") as LinkButton;
                btnViewCourseDetails.OnClientClick = "javascript:ShowACECourseDetail('" + AceId + "','" + TeamRevd + "','" + Title + "','" + AdvancedSearch + "')";
                btnHaveOccuppations.OnClientClick = "javascript:ShowACECourseOccupations('" + AceId + "','" + TeamRevd + "','" + Title + "','" + AdvancedSearch + "')";
            }
        }

        protected void rcbServices_PreRender(object sender, EventArgs e)
        {
            base.OnPreRender(e);
            if (!IsPostBack)
            {
                sqlACECourses.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbServices");
                sqlACECoursesSearch.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbServices");
            }
        }

        protected void rcbServices_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            sqlACECourses.SelectParameters["Service"].DefaultValue = SetSelectedIndexChange("rcbServices");
            sqlACECoursesSearch.SelectParameters["Service"].DefaultValue = PreRenderComboBox("rcbServices");
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

        protected void rbSearchAttribute_Click(object sender, EventArgs e)
        {
            SearchAttribute();
        }

        protected void rbClearAttribute_Click(object sender, EventArgs e)
        {
            rgACECourses.DataSourceID = "sqlACECourses";
            sqlACECourses.DataBind();
            rtbAttribute.Text = "";
        }

        protected void rtbAttribute_TextChanged(object sender, EventArgs e)
        {
            SearchAttribute();
        }

        public void SearchAttribute()
        {
            if (rtbAttribute.Text != "")
            {
                    rgACECourses.DataSourceID = "sqlACECoursesSearch";
                    sqlACECoursesSearch.DataBind();
            }
        }

        protected void rgACECourses_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item.OwnerTableView.Name == "ParentGrid")
            {
                if (e.CommandName == "EditOccupations")
                {
                    GridDataItem itemDetail = e.Item as GridDataItem;
                    RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/ShowOccupations.aspx?AceID={0}&TeamRevd={1}&Title={2}&Exhibit={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Title"].Text, itemDetail["Exhibit"].Text), true, true, false, 1000, 600));
                }
            }
        }
    }
}