using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class ShowExhibit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["SelectedOccupation"] = "";
                if (Request.QueryString["AdvancedSearch"] != null)
                {
                    //Session["SelectedOccupation"] = Request.QueryString["AdvancedSearch"].Replace(" ", "+");
                    Session["SelectedOccupation"] = Request.QueryString["AdvancedSearch"];
                }
                else
                {
                    if (Request.QueryString["Title"] != null) { 
                        Session["SelectedOccupation"] = HttpUtility.UrlDecode(Request.QueryString["Title"].Replace("'", "\'"));
                    }
                }

                OccupationInformationControl.ExhibitID = Convert.ToInt32(Request["ID"]);
                OccupationInformationControl.IsReadOnly = true ;
            }
        }
    }
}