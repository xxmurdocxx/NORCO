using DocumentFormat.OpenXml.Office2016.Excel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class ConfirmDownload : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
               
            }
        }
        protected void Login_Click(object sender, EventArgs e)
        {
            if ((HttpContext.Current.User.Identity.Name != null) && HttpContext.Current.User.Identity.IsAuthenticated)
            {
                var authUser = norco_db.ValidateUser(HttpContext.Current.User.Identity.Name, GlobalUtil.Encrypt(Password.Text));
                if (authUser.Count() != 0)
                {
                    showPassword.Visible = false;
                    rlbDownload.Visible = true;
                    string isArticulation = string.IsNullOrEmpty(Request["IsArticulation"]) ? "false" : Request["IsArticulation"];
                    if (isArticulation=="true")
                    {
                        rlbDownload.NavigateUrl = $"/modules/document/Download.ashx?ID={Request["ID"]}"; 
                    } else {
                        rlbDownload.NavigateUrl = $"/modules/Veteran/Download.ashx?ID={Request["ID"]}";
                    }

                }
                else
                {
                    rnMessage.Text = "Invalid password";
                    rnMessage.Show();
                }
            }
        }

        protected void rbDownload_Click(object sender, EventArgs e)
        {
            string isArticulation = string.IsNullOrEmpty(Request["IsArticulation"]) ? "false" : Request["IsArticulation"];
            if (isArticulation == "true")
            {
                Response.Redirect($"/modules/document/Download.ashx?ID={Request["ID"]}");
            }
            else
            {
                Response.Redirect($"/modules/Veteran/Download.ashx?ID={Request["ID"]}");
            }
            
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "CloseWindow", "setTimeout(function(){ var ww = window.open(window.location, '_self'); ww.close(); }, 1500);", true);
        }
    }
}