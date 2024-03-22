using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.UserControls
{
    public partial class DisplayMessages : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void DisplayMessage(bool IsError, string Message)
        {
            Label label = (IsError) ? this.Label1 : this.Label2;
            label.Text = Message;
            RadToolTip1.Show();
        }

    }
}