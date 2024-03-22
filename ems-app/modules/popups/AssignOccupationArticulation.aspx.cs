using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Drawing;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Collections;

namespace ems_app.modules.popups
{
    public partial class AssignOccupationArticulation : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        Dictionary<int, int> articulations = new Dictionary<int, int>();

        private void disableButtons()
        {
            rbAssign.Enabled = false;
            rbDelete.Enabled = false;
            //rbDontArticulate.Enabled = false;
            //rbArchive.Enabled = false;
            btnSubmit.Enabled = false;
            btnReturn.Enabled = false;
            btnPublish.Enabled = false;

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Deleted"] != null)
                {
                    if (Session["Deleted"].ToString() == "true")
                    {
                        Response.Redirect("Close.aspx");
                    }                  
                }
                tbID.Text = Request.QueryString["articulationId"];
                hvOutlineID.Value = Request.QueryString["outline_id"];
                hvUserStageID.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"])).ToString();
                hvUserID.Value = Session["UserID"].ToString();
                hvCollegeID.Value = Session["CollegeID"].ToString();
                hvFirstStage.Value = norco_db.GetMinimumStageId(Convert.ToInt32(Session["CollegeID"])).ToString();
                hvLastStage.Value = norco_db.GetMaximumStageId(Convert.ToInt32(Session["CollegeID"])).ToString();
                hvOutlineID.Value = Request.QueryString["outline_id"];
                hvAceID.Value = Request.QueryString["AceID"];
                hvTitle.Value = Request.QueryString["Title"];
                hvTeamRevd.Value = Request.QueryString["TeamRevd"];
                hvFrom.Value = GlobalUtil.ReadSetting("SystemNotificationEmail");
                hvCourse.Value = norco_db.GetCourseTitle(Convert.ToInt32(hvOutlineID.Value), null);
                hvArticulationType.Value = "2";
                hvExhibitID.Value = Request.QueryString["ExhibitID"];

                hvIsArticulationOfficer.Value = Session["isArticulationOfficer"].ToString();
                hvReviewArticulations.Value = Session["reviewArticulations"].ToString();

                var course_info = norco_db.GetCourseInformation(Convert.ToInt32(hvOutlineID.Value));
                foreach (GetCourseInformationResult item in course_info)
                {
                    hvSubject.Value = item.subject;
                    hvCourseNumber.Value = item.course_number;
                }

                LoadArticulation();
                hvUserArticulationStage.Value = hvArticulationStage.Value;

                CourseInformationControl.OutlineID = Convert.ToInt32(hvOutlineID.Value);
                CourseInformationControl.CollegeID = Convert.ToInt32(hvCollegeID.Value);

                OccupationInformationControl.ExhibitID = Convert.ToInt32(Request["ExhibitID"]);
                OccupationInformationControl.IsReadOnly = true;

                ArticulationDocumentsViewer.UserID = Convert.ToInt32(Session["UserID"]);
                ArticulationDocumentsViewer.ArticulationID = Convert.ToInt32(Request.QueryString["articulationId"]);
                ArticulationDocumentsViewer.ReadOnly = false;
                //01-18-23 
                AuditTrailViewer.ArticulationId = Convert.ToInt32(Request.QueryString["articulationId"]);
                //01-18-23 AuditTrailViewer.AceID = hvAceID.Value;
                //01-18-23 AuditTrailViewer.TeamRevd = hvTeamRevd.Value;
                //01-18-23 AuditTrailViewer.OutlineID = Convert.ToInt32(hvOutlineID.Value);
                AuditTrailViewer.HideAceColumns = true;
                //01-18-23 AuditTrailViewer.CollegeID = 0;
                //01-18-23 AuditTrailViewer.UserID = 0;
                //01-18-23 AuditTrailViewer.StageID = 0;

                if (Request.QueryString["isReadOnly"] != null)
                {
                    rbArchive.Enabled = false;
                    //rbDontArticulate.Enabled = false;
                    disableButtons();
                    if (Convert.ToBoolean(Request.QueryString["isReadOnly"]))
                    {
                        ArticulationDocumentsViewer.ReadOnly = true;
                    }
                }

                bool existNotes = (bool)norco_db.CheckArticulationExistOtherColleges(Convert.ToInt32(Session["CollegeID"]), hvSubject.Value, hvCourseNumber.Value, hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value));
                if (existNotes)
                {
                    OtherCollegesNotes.Subject = hvSubject.Value;
                    OtherCollegesNotes.CourseNumber = hvCourseNumber.Value;
                    OtherCollegesNotes.ExhibitID = hvExhibitID.Value;
                    OtherCollegesNotes.CriteriaID = hvCriteriaID.Value;
                    OtherCollegesNotes.CollegeID = Convert.ToInt32(hvCollegeID.Value);
                    pnlOtherCollegesNotes.Visible = true;
                }

                rbAdoptArticulation.Visible = false;
                lblCollegeToAdopt.Visible = true;
                if (Request.QueryString["AdoptArticulation"] != null )
                {
                    if (Convert.ToBoolean(Request.QueryString["AdoptArticulation"]))
                    {
                        rbArchive.Enabled = false;
                        rbDontArticulate.Enabled = false;
                        //var existSubject = norco_db.CheckSubjectExistInCollege(Convert.ToInt32(Request.QueryString["OtherCollegeID"]), hvSubject.Value, hvCourseNumber.Value);
                        var existSubject = norco_db.CheckSubjectExistInCollege(Convert.ToInt32(Session["CollegeID"]), hvSubject.Value, hvCourseNumber.Value);
                        if (existSubject == true)
                        {
                            var exist = norco_db.CheckArticulationExistInCollege(Convert.ToInt32(Session["CollegeID"]), hvSubject.Value, hvCourseNumber.Value, hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value));
                            if (exist == false)
                            {
                                rbAdoptArticulation.Visible = true;
                                rbAdoptArticulation.ToolTip = string.Format("Adopt articulation from {0}", Request.QueryString["CollegeName"]);
                                hvOtherCollegeID.Value = Request.QueryString["OtherCollegeID"];
                            }
                            else
                            {
                                lblAdopt.Visible = false;
                                //lblAdopt.Text = "Articulation already exist.";
                            }
                        }
                        else
                        {
                            lblAdopt.Visible = true;
                            lblAdopt.Text = "Course does not exist.";
                        }
                        lblCollegeToAdopt.InnerText = string.Format("College : {0} ", Request.QueryString["CollegeName"]);
                    } else
                    {
                        lblCollegeToAdopt.InnerText = string.Format("College : {0} ", Session["College"].ToString());
                    }
                } else
                {
                    lblCollegeToAdopt.InnerText = string.Format("College : {0} ", Session["College"].ToString());
                }

                lblArticulationTitle.InnerText =  hvCourse.Value;
                lblExhibit.InnerText = $"{hvAceID.Value} {hvTitle.Value}";

                //EligibilityControl.AceID = hvAceID.Value;
                //EligibilityControl.TeamRevd = hvTeamRevd.Value;
                //EligibilityControl.ArticulationStage = Convert.ToInt32(hvUserStageID.Value);
                //EligibilityControl.OutlineID = Convert.ToInt32(tbID.Text);
                reAssignNotes.Enabled = false;
                reJustification.Enabled = false;
                reArticulationOfficer.Enabled = false;
                rbDelete.Visible= false;
                if ((Convert.ToBoolean(Session["isAdministrator"]) == true || Convert.ToBoolean(Session["SuperUser"]) == true) ||
                        Session["RoleName"].ToString() == "Evaluator" ||
                        Convert.ToBoolean(Session["SuperUser"]) == true ||
                        Session["RoleName"].ToString() == "Ambassador")
                {
                    rbDelete.Visible = true;
                    rbDelete.Enabled = true;
                }
            }
            if (Session["RoleName"].ToString() == "Ambassador" || Session["RoleName"].ToString() == "Evaluator")
            {
                reAssignNotes.Enabled = true;
                rbSaveEvaluatorNotes.Visible= true;
                reJustification.Enabled = true;
                RadButton1.Visible= true;
                reArticulationOfficer.Enabled= true;
                RadButton2.Visible= true;
                ArticulationDocumentsViewer.ReadOnly = false;
                rbAssign.Visible= true;
                rbAssign.Enabled= true;
            }
        }

        public void AssignArticulation()
        {
            try
            {
                Controllers.Articulation.UpdateArticulation(Convert.ToInt32(hvId.Value),  reAssignNotes.Content, reJustification.Content, reArticulationOfficer.Content, "",Convert.ToInt32(hvUserID.Value),  false,false,0);
                DisplayMessagesControl.DisplayMessage(false, Resources.Messages.SuccessfullyUpdated);
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.Message.ToString());
            }
            LoadArticulation();
        }


        protected void LoadArticulation()
        {
            rbDontArticulate.Enabled = true;
            rbArchive.Enabled = true;
            btnSubmit.Enabled = true;
            var articulation = norco_db.GetArticulationByID(Convert.ToInt32(tbID.Text));
            foreach (GetArticulationByIDResult item in articulation)
            {
                hvId.Value = item.id.ToString();
                hvArticulationID.Value = item.ArticulationID.ToString();
                reAssignNotes.Content = item.Notes;
                reJustification.Content = item.Justification;
                reArticulationOfficer.Content = item.ArticulationOfficerNotes;
                hvArticulationStage.Value = item.ArticulationStage.ToString();
                hvArticulationStatus.Value = item.ArticulationStatus.ToString();
                hvArticulate.Value = item.Articulate.ToString();
                hvRoleName.Value = norco_db.GetRoleNameByStageId(item.ArticulationStage);
                

            }
            DataTable dtArticulaiton = GetArticulationByID(Convert.ToInt32(tbID.Text));
            if (dtArticulaiton != null)
            {
                if (dtArticulaiton.Rows.Count > 0)
                {
                    foreach (DataRow row in dtArticulaiton.Rows)
                    {
                        hvCriteriaID.Value = row["CriteriaID"].ToString();
                    }
                }
            }
            rbAssign.Text = Resources.Messages.AsignButtonTextOnSave;
            rbDelete.Enabled = true;

            if (tbID.Text != "")
            {
                // 9Jan2019 - Alberto Gandarillas : Disable buttons where current user stage is not equal the stage of articulation reviewed.
                if (hvUserStageID.Value != hvArticulationStage.Value)
                {
                    disableButtons();
                    rbDontArticulate.Enabled = false;
                    rbArchive.Enabled = false;
                } else
                {
                    rbDontArticulate.Enabled = true;
                    //Check if faculty review district, disable move forward if already approved.
                    var stageData = norco_db.GetStageDataByID(Convert.ToInt32(hvCollegeID.Value), Convert.ToInt32(hvArticulationStage.Value));
                    foreach (GetStageDataByIDResult item in stageData)
                    {
                        hvEnforceFacultyReview.Value = item.EnforceFacultyReview.ToString();
                    }
                    if (hvEnforceFacultyReview.Value == "True")
                    {
                        if (norco_db.CheckFacultyReviewSubmitted(Convert.ToInt32(tbID.Text), 2) == true)
                        {
                            btnSubmit.Enabled = false;
                        }
                        else
                        {
                            btnSubmit.ToolTip = "Move forward for Faculty Review";
                        }
                    }
                }

                //if (hvArticulate.Value == "True" && hvUserStageID.Value == hvArticulationStage.Value ) 
                if (hvArticulationStatus.Value != "2")
                {
                    if (hvArticulate.Value == "True" )
                    {
                        rbDontArticulate.Text = "Deny";
                    }
                    else
                    {
                        rbDontArticulate.Text = "Reverse articulation";
                    }
                } 

                switch (hvArticulationStatus.Value)
                {
                    case "1":
                        rbArchive.Text = "Archive";
                        break;
                    case "2":
                        pnlNotes.Enabled = false;
                        rbArchive.Enabled = false;
                        disableButtons();
                        break;
                    case "3":
                        rbArchive.Text = "Reverse Archive";
                        disableButtons();
                        break;
                    default:
                        break;
                }

                lblDenied.Visible = false;
                lblArchived.Visible = false;
                lblAdopt.Visible = false;

                if (hvArticulate.Value == "False")
                {
                    lblDenied.Visible = true;
                    btnSubmit.Enabled = false;
                }

                if (hvArticulationStatus.Value == "3")
                {
                    lblArchived.Visible = true;
                }

                // If is first Stage User logged in, then disable Return button 
                if (hvUserStageID.Value == hvFirstStage.Value)
                {
                    btnReturn.Enabled = false;
                }
                // If is last Stage User logged in, then disable Submit button / enable publish button
                if (hvUserStageID.Value == hvLastStage.Value)
                {
                    btnSubmit.Enabled = false;
                    if (hvArticulationStage.Value == hvLastStage.Value)
                    {
                        btnPublish.Enabled = true;
                    }
                }
                if (Convert.ToBoolean(Session["isAdministrator"]))
                {
                    btnReturn.Enabled = false;
                    btnSubmit.Enabled = false;
                    btnPublish.Enabled = false;
                }



                //RadGrid rgEligibility = (RadGrid)EligibilityControl.FindControl("rgEligibility");
                //rgEligibility.Enabled = false;
                //if (Convert.ToBoolean(Session["isArticulationOfficer"]))
                //{
                //    rgEligibility.Enabled = true;
                //}

                if (Convert.ToBoolean(Session["reviewArticulations"]) )
                {
                    if (GlobalUtil.CheckArticulationIsPendingApprovalWorkflow(Convert.ToInt32(hvArticulationID.Value), Convert.ToInt32(hvArticulationType.Value)) == 1)
                    {
                        disableButtons();
                    }
                }

            }
            else
            {
                rbDontArticulate.Visible = false;
                rbArchive.Visible = false;
            }

            AuditTrailViewer.DataBind();
        }


        protected void rbAssign_Click(object sender, EventArgs e)
        {

            AssignArticulation();
            LoadArticulation();
            Response.Redirect(Request.RawUrl);
            //If Evaluator, submit to Faculty
            //if (hvUserStageID.Value == hvFirstStage.Value)
            //{
            //    Submit(1);
            //}
        }

        protected void rbDelete_Click(object sender, EventArgs e)
        {
            try
            {
                if ((Convert.ToBoolean(Session["isAdministrator"]) == true || Convert.ToBoolean(Session["SuperUser"]) == true) ||
                        Session["RoleName"].ToString() == "Evaluator" ||
                        Convert.ToBoolean(Session["SuperUser"]) == true ||
                        Session["RoleName"].ToString() == "Ambassador")
                {
                    GlobalUtil.DeleteArticulation(Convert.ToInt32(hvId.Value), Convert.ToInt32(Session["UserID"]));
                }
            }
            catch (Exception ex1)
            {
                DisplayMessagesControl.DisplayMessage(true, ex1.Message.ToString());
                throw;
            }
        }

        public void DoNotArticulate()
        {
            if (hvArticulationStatus.Value == "2")
            {
                DisplayMessagesControl.DisplayMessage(true, Resources.Messages.CannotModifyArticulationPublished);
            }
            else
            {
                string subject = string.Format("Course {0} Dont Articulate", hvCourse.Value);
                try
                {
                    //AssignArticulation();
                    norco_db.DontArticulate(Convert.ToInt32(hvArticulationID.Value), 2, Convert.ToInt32(Session["UserID"]));
                    //GlobalUtil.NotifyOnPublish("Dont Articulate", subject, hvFrom.Value, Convert.ToInt32(hvOutlineID.Value), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), 2);
                    DisplayMessagesControl.DisplayMessage(true, Resources.Messages.DoNotArticulateStatusUpdated);
                    LoadArticulation();
                }
                catch (Exception ex)
                {
                    DisplayMessagesControl.DisplayMessage(true, ex.ToString());
                }
            }
        }

        protected void rbDontArticulate_Click(object sender, EventArgs e)
        {
            try
            {
                DoNotArticulate();
            }
            catch (Exception ex1)
            {
                DisplayMessagesControl.DisplayMessage(true, ex1.Message.ToString());
                throw;
            }
        }

        public void Archive()
        {
            if (hvArticulationStatus.Value == "2")
            {
                DisplayMessagesControl.DisplayMessage(true,"Can not archive this articulation");
            }
            else
            {
                try
                {
                    AssignArticulation();
                    norco_db.ArchiveArticulation(Convert.ToInt32(hvArticulationID.Value), 2, Convert.ToInt32(Session["UserID"]));
                    DisplayMessagesControl.DisplayMessage(true, "Articulation has been archived");
                    LoadArticulation();
                }
                catch (Exception ex)
                {
                    DisplayMessagesControl.DisplayMessage(true, ex.ToString());
                }
            }
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

        public string GetSelectedItemText(string controlID)
        {
            RadListBox listBox = (RadListBox)FindControlRecursive(Page, controlID);
            string[] checkedItems = new string[100];
            if (listBox != null)
            {
                for (int idx = 0; idx < listBox.Items.Count; idx++)
                {
                    if (listBox.Items[idx].Checked == true)
                    {
                        checkedItems[idx] = listBox.Items[idx].Value;
                    }

                }
            }
            return string.Join(",", checkedItems.Where(x => !string.IsNullOrEmpty(x)).ToArray());
        }

        public void SetSelectedItem(string controlID, string text)
        {
            RadListBox listBox = (RadListBox)FindControlRecursive(Page, controlID);
            string[] selectedValues = text.Split(',');
            foreach (string selectedValue in selectedValues)
            {
                for (int idx1 = 0; idx1 < listBox.Items.Count; idx1++)
                {
                    RadListBoxItem li = listBox.Items[idx1];
                    if (li.Value.Equals(selectedValue))
                    {
                        li.Checked = true;
                    }
                }
            }
        }

       
        protected void btnPublish_Click(object sender, EventArgs e)
        {
            string subject = string.Format("Course {0} was published", hvCourse.Value);
            var message = "Course successfuly published.";
            var publishCode = norco_db.GetUniquePublishedCode(Convert.ToInt32(hvOutlineID.Value));

            try
            {
                norco_db.PublishArticulation(Convert.ToInt32(tbID.Text), 2, Convert.ToInt32(hvOutlineID.Value), publishCode, Convert.ToInt32(hvUserID.Value));
                var isPublished = norco_db.CourseIsPublished(Convert.ToInt32(hvOutlineID.Value));
                if (isPublished == true)
                {
                    message = string.Format("{0} Published Code for {1} is {2}", message, hvCourse.Value, publishCode);
                }
                GlobalUtil.NotifyOnPublish(message, subject, hvFrom.Value, Convert.ToInt32(hvOutlineID.Value), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), 1);
                DisplayMessagesControl.DisplayMessage(true, "Articulation published.");
                LoadArticulation();
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.ToString());
            }
        }

        protected void btnReturn_Click(object sender, EventArgs e)
        {
            pnlPrevious.Visible = true;
        }

        protected void Submit(int direction)
        {
            var isEvaluator = false;
            if (hvUserStageID.Value == hvFirstStage.Value)
            {
                isEvaluator = true;
            }
            if (hvUserStageID.Value != hvArticulationStage.Value)
            {
                DisplayMessagesControl.DisplayMessage(true, "Cannot submit or return this course.");
            }
            else
            {
                if (hvArticulationStatus.Value != "2")
                {
                    try
                    {
                        // Update articulation before submitting
                        var addArticulation = Controllers.Articulation.AddArticulation(Convert.ToInt32(hvOutlineID.Value), hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value), hvTitle.Value, reAssignNotes.Content, reJustification.Content, reArticulationOfficer.Content, "", 2, Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value),false,2,false,999999);


                            var previous = rcbPreviousStage.SelectedValue == "" ? 0 : Convert.ToInt32(rcbPreviousStage.SelectedValue);
                            var submit = GlobalUtil.SubmitArticulation(Convert.ToInt32(tbID.Text), Convert.ToInt32(hvUserID.Value), "", Convert.ToInt32(hvCollegeID.Value), previous, Convert.ToInt32(hvOutlineID.Value), direction, Convert.ToInt32(hvArticulationID.Value), 2, hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value), hvTitle.Value);
                            if (submit == 1)
                            {
                                DisplayMessagesControl.DisplayMessage(true, "Articulation submitted.");
                                LoadArticulation();
                            }
                            else
                            {
                                DisplayMessagesControl.DisplayMessage(true, "Problems submitting articulation.");
                            }
                        

                    }
                    catch (Exception ex)
                    {
                        DisplayMessagesControl.DisplayMessage(true, ex.ToString());
                    }

                }
                else
                {
                    DisplayMessagesControl.DisplayMessage(true, "Cannot submit published articulations.");
                }
            }
        }

        public void NotifyPopup(string action, int user_stage_id, string user_name, int user_id, int college_id, int width, int height)
        {
            var url = String.Format("../popups/Notify.aspx?Action={0}&UserStageID={1}&UserName={2}&UserID={3}&CollegeID={4}", action, user_stage_id, user_name, user_id, college_id, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            //var result = ValidateHaveCriteria();
            //if (result != 1)
            //{
            //}
            //if (hvUserStageID.Value == hvFirstStage.Value)
            //{
            //    Submit(1);
            //    LoadArticulation();
            //    ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "CloseWindow();", true);
            //}
            //else
            //{
            //    articulations.Add(Convert.ToInt32(tbID.Text), 0);
            //    Session["articulationList"] = articulations;
            //    NotifyPopup("MoveForward", Convert.ToInt32(hvUserStageID.Value), Session["UserName"].ToString(), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), 600, 600);
            //}

            articulations.Add(Convert.ToInt32(tbID.Text), 0);
            Session["articulationList"] = articulations;
            NotifyPopup("MoveForward", Convert.ToInt32(hvUserStageID.Value), Session["UserName"].ToString(), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), 600, 600);

        }

        protected void rbSubmitPrevious_Click(object sender, EventArgs e)
        {
            Submit(-1);
            pnlPrevious.Visible = false;
            LoadArticulation();
        }

        protected void rbCancel_Click(object sender, EventArgs e)
        {
            pnlPrevious.Visible = false;
        }


        protected void rgOtherRecommendations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var RecommendationIsChecked = dataBoundItem["RecommendationIsChecked"].Text;

                CheckBox checkbox1 = e.Item.FindControl("CheckBox1") as CheckBox;

                if (RecommendationIsChecked == "True" )
                {
                    checkbox1.Checked = true;
                } 

            }
        }

        protected void rgCriteria_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem gridItem = e.Item as GridDataItem;
                Color col = ColorTranslator.FromHtml(gridItem["Backcolor"].Text);
                Color colFont = ColorTranslator.FromHtml(gridItem["Fontcolor"].Text);
                gridItem["Criteria"].BackColor = col;
                gridItem["Criteria"].ForeColor = colFont;
            }
        }



        protected void rptCriteriaTypes_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                System.Web.UI.HtmlControls.HtmlGenericControl div = e.Item.FindControl("DivLegend") as System.Web.UI.HtmlControls.HtmlGenericControl;
                string color = (string)DataBinder.Eval(e.Item.DataItem, "Backcolor");
                div.Attributes.CssStyle.Add("background-color", color);
            }
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            LoadArticulation();
        }



        public void showAssignArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly)
        {
            var adoptParameter = "";
            var otherCollegeIDParameter = "";
            if (isReadOnly)
            {
                if (Session["CollegeID"].ToString() != Request["CollegeID"])
                {
                    adoptParameter = "&AdoptArticulation=true";
                    otherCollegeIDParameter = string.Format("&OtherCollegeID={0}", Request["CollegeID"]);
                }
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true{5}{6}", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), adoptParameter, otherCollegeIDParameter) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
            }

        }

        public void ConfirmAdopt(string articulation_list, int user_id, int college_id, int width, int height)
        {
            var url = String.Format("../popups/ConfirmAdoptArticulation.aspx?ArticulationList={0}&UserID={1}&CollegeID={2}", articulation_list, user_id, college_id, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        protected void rbAdoptArticulation_Click(object sender, EventArgs e)
        {
            try
            {
                ConfirmAdopt(tbID.Text, Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), 600, 300);
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(false, ex.Message.ToString());
            }
}

        protected void rbArchive_Click(object sender, EventArgs e)
        {
            try
            {
                Archive();
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(false, ex.Message.ToString());
            }
        }

        public static DataTable GetArticulationByID(int articulation_id)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetArticulationByID", conn);
                cmd.Parameters.Add(new SqlParameter("@ArticulationID", articulation_id));
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                adp.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }
            return myDataTable;
        }
        
    }
}