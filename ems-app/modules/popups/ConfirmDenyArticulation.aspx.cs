using DocumentFormat.OpenXml.Office2010.Excel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class ConfirmDenyArticulation : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request["Notes"] != null)
                {
                    rtbNotes.Text = Request["Notes"];
                }
                var articulation_list = Request.QueryString["ArticulationList"].ToString();
                List<int> articulations = articulation_list.Split(',').Select(x => int.Parse(x.Trim())).ToList();
                sqlArticulations.SelectParameters["Articulations"].DefaultValue = articulation_list;
                sqlArticulations.DataBind();
                rgArticulations.DataBind();
            }
        }

        protected void rbProceed_Click(object sender, EventArgs e)
        {
            try
            {
                var articulation_list = Request.QueryString["ArticulationList"].ToString();
                List<int> articulations = articulation_list.Split(',').Select(x => int.Parse(x.Trim())).ToList();
                if (articulations.Count() > 0)
                {
                    foreach (var articulation in articulations)
                    {
                        var articulation_info = norco_db.GetArticulationByID(articulation);
                        foreach (GetArticulationByIDResult art in articulation_info)
                        {
                            if (art.ArticulationStatus != 2)
                            {
                                norco_db.DontArticulate(art.ArticulationID, art.ArticulationType, Convert.ToInt32(Session["UserID"]));
                                //norco_db.UpdateArticulationNotes(art.id, rtbNotes.Text);
                                Controllers.Articulation.UpdateArticulationNotes(art.id, rtbNotes.Text, "");
                            }
                        }
                    }
                    rnMessage.Title = "Deny Articulation";
                    rnMessage.Text = "Articulation(s) successfully denied!";
                    rnMessage.Show();
                    ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
                }
            }
            catch (Exception ex)
            {
                rnMessage.Title = "Deny Articulation";
                rnMessage.Text = ex.ToString();
                rnMessage.Show();
            }
        }
    }
}