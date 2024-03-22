using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{


    public partial class ConfirmAdoptArticulation : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hvCollegeID.Value = Request.QueryString["CollegeID"].ToString();
                hvUserID.Value = Request.QueryString["UserID"].ToString();
                hvUserStage.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"].ToString()), Convert.ToInt32(Session["RoleID"].ToString())).ToString();
                var articulation_list = Request.QueryString["ArticulationList"].ToString();
                List<int> articulations = articulation_list.Split(',').Select(x => int.Parse(x.Trim())).ToList();
                if (articulations.Count() > 1)
                {
                    rlMsg.Text = string.Format("Which stage would you like to adopt these articulations.");
                } else
                {
                    rlMsg.Text = string.Format("Which stage would you like to adopt this articulation.");
                }
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
                            var checkExist = norco_db.CheckArticulationExistInCollege(Convert.ToInt32(hvCollegeID.Value), art.subject, art.course_number, art.AceID, Convert.ToDateTime(art.TeamRevd));
                            if (checkExist == false)
                            {
                                norco_db.CloneOtherCollegeArticulation(Convert.ToInt32(articulation), art.CollegeID, Convert.ToInt32(hvCollegeID.Value), Convert.ToInt32(hvUserID.Value), art.subject, art.course_number, Convert.ToInt32(rcbStages.SelectedValue),art.CIDNumber,null);
                            }
                        }
                    }
                    DisableAdopt();
                    rnMessage.Title = "Adopt Articulation";
                    rnMessage.Text = "Articulation(s) successfully adopted!";
                    rnMessage.Show();
                    //ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('../faculty/ArticulaTionsPendingToReview.aspx','_self');", true);
                    //ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
                }
                //else
                //{
                //    if (articulations.Count() == 1)
                //    {
                //        var articulation_info = norco_db.GetArticulationByID(Convert.ToInt32(articulation_list));
                //        foreach (GetArticulationByIDResult art in articulation_info)
                //        {
                //            var checkExist = norco_db.CheckArticulationExistInCollege(Convert.ToInt32(hvCollegeID.Value), art.subject, art.course_number, art.AceID, Convert.ToDateTime(art.TeamRevd));
                //            if (checkExist == false)
                //            {
                //                //var adopted = norco_db.CloneOtherCollegeArticulation(Convert.ToInt32(articulation_list), art.CollegeID, Convert.ToInt32(hvCollegeID.Value), Convert.ToInt32(hvUserID.Value), art.subject, art.course_number, Convert.ToInt32(rcbStages.SelectedValue));
                //                //foreach (CloneOtherCollegeArticulationResult item in adopted)
                //                //{
                //                //    newArticulationID = Convert.ToInt32(item.ArticulationID);
                //                //}
                //                //var new_articulation = norco_db.GetArticulationByID(newArticulationID);
                //                //foreach (GetArticulationByIDResult new_art in new_articulation)
                //                //{
                //                //    showArticulation(new_art.id, (int)new_art.ArticulationType, new_art.outline_id, new_art.AceID, new_art.Title, (DateTime)new_art.TeamRevd, false, (int)new_art.CollegeID, true, Session["College"].ToString(), "NewTab", 0, 0);
                //                //    ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
                //                //}
                //            } else
                //            {
                //                DisplayMessage(false,"Articualation already exists.");
                //            }
                //        }
                //        DisableAdopt();
                //    }
                //}

                //NOTIFY
                Dictionary<int, int> articulationsToNotify = new Dictionary<int, int>();
                if (rgArticulations.SelectedItems.Count > 0)
                {
                    foreach (GridDataItem item in rgArticulations.SelectedItems)
                    {
                        articulationsToNotify.Add(Convert.ToInt32(item["id"].Text),0);
                    }
                    Session["articulationList"] = articulationsToNotify;
                    NotifyPopup("Adopt", Convert.ToInt32(hvUserStage.Value), Session["UserName"].ToString(), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), 800, 600);
                } else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "close", "CloseModal();", true);
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(false,ex.ToString());
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        public void NotifyPopup(string action, int user_stage_id, string user_name, int user_id, int college_id, int width, int height)
        {
            var url = String.Format("../popups/Notify.aspx?Action={0}&UserStageID={1}&UserName={2}&UserID={3}&CollegeID={4}", action, user_stage_id, user_name, user_id, college_id, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        public void DisableAdopt()
        {
            rcbStages.Enabled = false;
            rbProceed.Enabled = false;
            rbCancel.Text = "Close";
        }


        public void showArticulation(int id, int articulation_type, int outline_id, string AceID, string Title, DateTime TeamRevd, bool isReadOnly, int otherCollegeID, bool adoptArticulation, string collegeName, string modalWindow, int width, int height)
        {
            var urlPage = "../popups/AssignArticulation.aspx";
            var readOnlyParameter = "";
            if (isReadOnly)
            {
                readOnlyParameter = "&isReadOnly=true";
            }
            if (articulation_type == 2)
            {
                urlPage = "../popups/AssignOccupationArticulation.aspx";
            }
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("{0}?articulationID={1}&outline_id={2}&AceID={3}&Title={4}&TeamRevd={5}&NewWindow={6}&OtherCollegeID={7}&AdoptArticulation={8}&CollegeName={9}", urlPage, id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), readOnlyParameter, otherCollegeID.ToString(), isReadOnly, collegeName.ToString()) + "');closeRadWindow();", true);
        }

    }
}