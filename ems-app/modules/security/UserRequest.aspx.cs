using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.security
{
    public partial class UserRequest : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
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

        protected void rgUserRequest_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            var user_request_id = Convert.ToInt32(itemDetail["Id"].Text);
            var userName = itemDetail["UserName"].Text;
            var roleID = itemDetail["role_id"].Text;
            if (e.CommandName == "Approve")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select a user request.");
                }
                else
                {
                    if (userName != "" && roleID != "")
                    {
                        norco_db.ApproveUserRequest(user_request_id);
                        rgUserRequest.DataBind();
                    } else
                    {
                        DisplayMessage(false, "Please update username and user role before approve this user request.");
                    }
                }
            }
        }
    }
}