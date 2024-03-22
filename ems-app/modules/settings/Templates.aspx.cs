using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.settings
{
    public partial class Templates : System.Web.UI.Page
    {
        private void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgTemplates_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.CommandName == "EditTemplate")
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
                            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/CommunicationTemplates.aspx?TemplateType={0}", itemDetail["TypeID"].Text), true, true, false, 1100, 650));
                        }
                    }
                }
            }
        }
    }
}