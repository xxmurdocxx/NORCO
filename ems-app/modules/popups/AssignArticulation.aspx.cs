using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class AssignArticulation : System.Web.UI.Page
    {

        NORCODataContext norco_db = new NORCODataContext();

        Dictionary<int, int> articulations = new Dictionary<int, int>();

        private void disableButtons()
        {
            rbAssign.Enabled = false;
            rbDelete.Enabled = false;
            rbSaveFacultyNotes.Enabled = false;
            rbSaveEvaluatorNotes.Enabled = false;
            rbSaveARticulationNotes.Enabled = false;
            //rbDontArticulate.Enabled = false;
            rbArchive.Enabled = false;
            btnSubmit.Enabled = false;
            rgOtherRecommendations.Enabled = false;
            rgEligibility.Enabled = false;
            btnReturn.Enabled = false;
            btnPublish.Enabled = false;
            ArticulateWithOtherCourses1.SetEnabled = false;
            rbSaveARticulationNotes.Enabled = false;
            rbSaveEvaluatorNotes.Enabled = false;
            rbSaveFacultyNotes.Enabled = false;
            rchkOverrideRecommendation.Enabled = false;
            reArticulationOfficer.Enabled = false;
            reAssignNotes.Enabled = false;
            reJustification.Enabled = false;

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

                hvIsArticulationOfficer.Value = Session["isArticulationOfficer"].ToString();
                hvReviewArticulations.Value = Session["reviewArticulations"].ToString();

                var course_info = norco_db.GetCourseInformation(Convert.ToInt32(hvOutlineID.Value));
                foreach (GetCourseInformationResult item in course_info)
                {
                    hvSubject.Value = item.subject;
                    hvCourseNumber.Value = item.course_number;
                }

                rblRecommendations.DataBind();

                LoadArticulation();
                hvUserArticulationStage.Value = hvArticulationStage.Value;
                rgOtherRecommendations.DataBind();

                if (Request["NewWindow"] != null)
                {
                    rbOpendInNewWindow.Visible = false;
                }

                ArticulationDocumentsViewer.UserID = Convert.ToInt32(Session["UserID"]);
                ArticulationDocumentsViewer.ArticulationID = Convert.ToInt32(Request.QueryString["articulationId"]);
                ArticulationDocumentsViewer.ReadOnly = false;

                AuditTrailViewer.AceID = hvAceID.Value;
                AuditTrailViewer.TeamRevd = hvTeamRevd.Value;
                AuditTrailViewer.OutlineID = Convert.ToInt32(hvOutlineID.Value);
                AuditTrailViewer.HideAceColumns = true;
                AuditTrailViewer.CollegeID = 0;
                AuditTrailViewer.UserID = 0;
                AuditTrailViewer.StageID = 0;

                ArticulateWithOtherCourses1.ArticulationID = Convert.ToInt32(Request.QueryString["articulationId"]);
                ArticulateWithOtherCourses1.ArticulationType = 1;
                ArticulateWithOtherCourses1.AceID = hvAceID.Value;
                ArticulateWithOtherCourses1.TeamRevd = hvTeamRevd.Value;
                ArticulateWithOtherCourses1.CollegeID = Convert.ToInt32(hvCollegeID.Value);
                ArticulateWithOtherCourses1.Title = hvTitle.Value;
                ArticulateWithOtherCourses1.OutlineID = Convert.ToInt32(hvOutlineID.Value);
                ArticulateWithOtherCourses1.UserID = Convert.ToInt32(hvUserID.Value);
                ArticulateWithOtherCourses1.UserStageID = Convert.ToInt32(hvUserStageID.Value);
                ArticulateWithOtherCourses1.EvaluatorNotes = reAssignNotes.Content;
                ArticulateWithOtherCourses1.FacultyNotes = reJustification.Content;
                ArticulateWithOtherCourses1.ArticulationOfficerNotes = reArticulationOfficer.Content;

                if (Request.QueryString["isReadOnly"] != null)
                {
                    rbArchive.Enabled = false;
                    disableButtons();
                    if (Convert.ToBoolean(Request.QueryString["isReadOnly"]))
                    {
                        ArticulationDocumentsViewer.ReadOnly = true;
                    }
                }

                bool existNotes = (bool)norco_db.CheckArticulationExistOtherColleges(Convert.ToInt32(Session["CollegeID"]), hvSubject.Value, hvCourseNumber.Value, hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value));
                if (existNotes)
                {
                    //OtherCollegesNotes.Subject = hvSubject.Value;
                    //OtherCollegesNotes.CourseNumber = hvCourseNumber.Value;
                    //OtherCollegesNotes.AceID = hvAceID.Value;
                    //OtherCollegesNotes.TeamRevd = hvTeamRevd.Value;
                    //OtherCollegesNotes.CollegeID = Convert.ToInt32(hvCollegeID.Value);
                    pnlOtherCollegesNotes.Visible = true;
                }

                rbAdoptArticulation.Visible = false;
                lblCollegeToAdopt.Visible = true;

                if (Request.QueryString["AdoptArticulation"] != null)
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
                                rbAdoptArticulation.Enabled = false;
                            }
                        }
                        else
                        {
                            rbAdoptArticulation.Enabled = false;
                            lblAdopt.Visible = true;
                            lblAdopt.Text = "Course does not exist.";
                        }
                        lblCollegeToAdopt.InnerText = string.Format("College : {0} ", Request.QueryString["CollegeName"]);
                        DisableCriteria();
                    }
                    else
                    {
                        lblCollegeToAdopt.InnerText = string.Format("College : {0} ", Session["College"].ToString());
                    }

                }
                else
                {
                    lblCollegeToAdopt.InnerText = string.Format("College : {0} ", Session["College"].ToString());
                }

                lblArticulationTitle.InnerText = string.Format("{0} - {1} {2}", hvCourse.Value, hvAceID.Value, hvTitle.Value);

                //pnlCriteria.Visible = false;
                //if (tbID.Text != "")
                //{
                //    pnlCriteria.Visible = true;
                //}

                rgAdditionalCriteria.MasterTableView.AllowPaging = false;
                rgAdditionalCriteria.Rebind();
                var rowCountAddCriteria = rgAdditionalCriteria.MasterTableView.Items.Count;
                rgAdditionalCriteria.MasterTableView.AllowPaging = true;
                rgAdditionalCriteria.Rebind();

                if (rowCountAddCriteria > 0)
                {
                    rchkAdditionalCriteria.Checked = true;
                    pnlAdditionalCriteria.Visible = true;
                }
            }
        }

        public  int ValidateHaveCriteria()
        {
            var result = 0;
            var rowCountCriteria = rgCriteria.MasterTableView.Items.Count;
            var rowCountAddCriteria = rgAdditionalCriteria.MasterTableView.Items.Count;
            if (rowCountCriteria == 0 && rowCountAddCriteria == 0)
            {
                result = 1;
                DisplayMessagesControl.DisplayMessage(false, "Please add at least one highlighted criteria to move this/these articulation(s) forward.");
            }
            return result;
        }

        public void DisableCriteria()
        {
            pnlCriteria.Enabled = false;
            rgCriteria.Enabled = false;
            rbClearCriteria.Enabled = false;
            rbAddCriteria.Enabled = false;
            rcbCriteriaList.Enabled = false;
            rgCriteria.MasterTableView.GetColumn("TemplateColumn").Display = false;
        }

        protected void LoadArticulation()
        {
            rbDontArticulate.Enabled = true;
            rbArchive.Enabled = true;
            btnSubmit.Enabled = true;
            rblRecommendations.Enabled = false;
            pnlOtherRecommedations.Enabled = false;

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
                if (item.Recommendation != null)
                {
                    if (item.Recommendation != "")
                    {
                        SetSelectedItem("rblRecommendations", item.Recommendation.Trim().Replace(" ", string.Empty));
                        hfRecommendations.Value = item.Recommendation.Trim().Replace(" ", string.Empty);
                    }
                }
            }
            rbAssign.Text = Resources.Messages.AsignButtonTextOnSave;
            rbDelete.Enabled = true;

            // If is first Stage User logged in, then disable recommendations 
            if (hvUserStageID.Value == hvFirstStage.Value)
            {
                rblRecommendations.Enabled = false;
            }
            if (tbID.Text != "")
            {

                // 9Jan2019 - Alberto Gandarillas : Disable buttons where current user stage is not equal the stage of articulation reviewed.
                if (hvUserStageID.Value != hvArticulationStage.Value)
                {
                    disableButtons();
                    rbDontArticulate.Enabled = false;
                    rbArchive.Enabled = false;
                }
                else
                {
                    btnSubmit.Enabled = true;
                    rbDontArticulate.Enabled = true;
                    rbAssign.Enabled = true;
                    rbSaveFacultyNotes.Enabled = true;
                    rbSaveEvaluatorNotes.Enabled = true;
                    rbSaveARticulationNotes.Enabled = true;
                    rbAddCriteria.Enabled = true;
                    ArticulateWithOtherCourses1.SetEnabled = true;
                    rchkOverrideRecommendation.Enabled = true;

                    //Check if faculty review district, disable move forward if already approved.
                    var stageData = norco_db.GetStageDataByID(Convert.ToInt32(hvCollegeID.Value), Convert.ToInt32(hvArticulationStage.Value));
                    foreach (GetStageDataByIDResult item in stageData)
                    {
                        hvEnforceFacultyReview.Value = item.EnforceFacultyReview.ToString();
                    } 
                    if (hvEnforceFacultyReview.Value == "True")
                    {
                        if (norco_db.CheckFacultyReviewSubmitted(Convert.ToInt32(hvArticulationID.Value), 2) == true)
                        {
                            btnSubmit.Enabled = false;
                        }
                        else
                        {
                            btnSubmit.ToolTip = "Move forward for Faculty District Review";
                        }
                    }
                }

                //if (hvArticulate.Value == "True" && hvUserStageID.Value == hvArticulationStage.Value ) 
                if (hvArticulationStatus.Value != "2")
                {
                    if (hvArticulate.Value == "True")
                    {
                        rbDontArticulate.Text = "Do not articulate";
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
                        DisableCriteria();
                        break;
                    case "3":
                        rbArchive.Text = "Reverse Archive";
                        disableButtons();
                        DisableCriteria();
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

                rgEligibility.Enabled = false;
                if (Convert.ToBoolean(Session["isArticulationOfficer"]))
                {
                    rgEligibility.Enabled = true;
                }

                if (Convert.ToBoolean(Session["reviewArticulations"]) || Convert.ToBoolean(Session["isArticulationOfficer"]))
                {
                    rgOtherRecommendations.DataBind();
                    pnlOtherRecommedations.Enabled = true;
                    rblRecommendations.Enabled = false;
                }
                if (Convert.ToBoolean(Session["reviewArticulations"]))
                {
                    if (GlobalUtil.CheckArticulationIsPendingApprovalWorkflow(Convert.ToInt32(hvArticulationID.Value), Convert.ToInt32(hvArticulationType.Value)) == 1)
                    {
                        disableButtons();
                    }
                }

            } else
            {
                rbDontArticulate.Visible = false;
            }

            AuditTrailViewer.DataBind();

        }

        protected void rbAssign_Click(object sender, EventArgs e)
        {
            try
            {
                Controllers.Articulation.AddArticulation(Convert.ToInt32(hvOutlineID.Value), hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value), hvTitle.Value, reAssignNotes.Content, reJustification.Content,  reArticulationOfficer.Content, hfRecommendations.Value, Convert.ToInt32(rcbArticulationType.SelectedValue),  Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), true,1,false,99999999);
                DisplayMessage(false, Resources.Messages.SuccessfullyUpdated);
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
            }
            LoadArticulation();
            Response.Redirect(Request.RawUrl);
            ////If Evaluator, submit to Faculty
            //if (hvUserStageID.Value == hvFirstStage.Value)
            //{
            //    Submit(1);
            //}
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rbDelete_Click(object sender, EventArgs e)
        {
            try
            {
                if (tbID.Text != "")
                {
                    int isPublished = norco_db.CheckCourseIsPublished(Convert.ToInt32(Request.QueryString["outline_id"]));
                    var userStageID = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["RoleID"]));
                    if (isPublished == 1)
                    {
                        DisplayMessagesControl.DisplayMessage(false, Resources.Messages.DeleteNoArticulate);
                    }
                    else
                    {
                        if (userStageID == Convert.ToInt32(hvArticulationStage.Value))
                        {
                            GlobalUtil.DeleteArticulation(Convert.ToInt32(hvId.Value), Convert.ToInt32(Session["UserID"]));
                            Session["Deleted"] = "true";
                            disableButtons();
                            DisplayMessagesControl.DisplayMessage(false, Resources.Messages.ArticulationSuccessfullyDeleted);
                            
                        }
                    }
                }
            }
            catch (Exception ex1)
            {
                DisplayMessage(true, ex1.Message.ToString());
                throw;
            }
        }

        public void DoNotArticulate()
        {
            if (hvArticulationStatus.Value == "2")
            {
                DisplayMessage(true, Resources.Messages.CannotModifyArticulationPublished);
            }
            else
            {
                string subject = string.Format("Course {0} Dont Articulate", hvCourse.Value);
                try
                {
                    //Controllers.Articulation.AddArticulation(Convert.ToInt32(hvOutlineID.Value), hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value), hvTitle.Value, reAssignNotes.Content, reJustification.Content,  reArticulationOfficer.Content, hfRecommendations.Value, Convert.ToInt32(rcbArticulationType.SelectedValue), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), true,1);
                    norco_db.DontArticulate(Convert.ToInt32(hvArticulationID.Value), 1, Convert.ToInt32(Session["UserID"]));
                    GlobalUtil.NotifyOnPublish("Dont Articulate", subject, hvFrom.Value, Convert.ToInt32(hvOutlineID.Value), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), 2);
                    DisplayMessage(true, Resources.Messages.DoNotArticulateStatusUpdated);
                    LoadArticulation();
                }
                catch (Exception ex)
                {
                    DisplayMessage(true, ex.ToString());
                }
            }
        }


        protected void rbDontArticulate_Click(object sender, EventArgs e)
        {
            try
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
            catch (Exception ex1)
            {
                DisplayMessage(true, ex1.Message.ToString());
                throw;
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

        protected void ToggleRowSelection(object sender, EventArgs e)
        {
            ((sender as CheckBox).NamingContainer as GridItem).Selected = (sender as CheckBox).Checked;
            bool checkHeader = true;
            foreach (GridDataItem dataItem in rgOtherRecommendations.MasterTableView.Items)
            {
                if (!(dataItem.FindControl("CheckBox1") as CheckBox).Checked)
                {
                    checkHeader = false;
                    break;
                }
            }
            GridHeaderItem headerItem = rgOtherRecommendations.MasterTableView.GetItems(GridItemType.Header)[0] as GridHeaderItem;
            (headerItem.FindControl("headerChkbox") as CheckBox).Checked = checkHeader;
        }
        protected void ToggleSelectedState(object sender, EventArgs e)
        {
            CheckBox headerCheckBox = (sender as CheckBox);
            foreach (GridDataItem dataItem in rgOtherRecommendations.MasterTableView.Items)
            {
                (dataItem.FindControl("CheckBox1") as CheckBox).Checked = headerCheckBox.Checked;
                dataItem.Selected = headerCheckBox.Checked;
            }
        }

        protected void rchkOverrideRecommendation_CheckedChanged(object sender, EventArgs e)
        {
            if (rchkOverrideRecommendation.Checked == true)
            {
                rblRecommendations.Enabled = true;
            }
            else
            {
                rblRecommendations.Enabled = false;
            }
        }

        protected void btnPublish_Click(object sender, EventArgs e)
        {
            string subject = string.Format("Course {0} was published", hvCourse.Value);
            var message = "Course successfuly published.";
            var publishCode = norco_db.GetUniquePublishedCode(Convert.ToInt32(hvOutlineID.Value));

            try
            {
                norco_db.PublishArticulation(Convert.ToInt32(tbID.Text), 1, Convert.ToInt32(hvOutlineID.Value), publishCode, Convert.ToInt32(hvUserID.Value));
                var isPublished = norco_db.CourseIsPublished(Convert.ToInt32(hvOutlineID.Value));
                if (isPublished == true)
                {
                    message = string.Format("{0} Published Code for {1} is {2}", message, hvCourse.Value, publishCode);
                }
                GlobalUtil.NotifyOnPublish(message, subject, hvFrom.Value, Convert.ToInt32(hvOutlineID.Value), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), 1);
                DisplayMessage(true, "Articulation published.");
                LoadArticulation();
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
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
                DisplayMessage(true, "Cannot submit or return this course.");
            } else
            {
                if (hvArticulationStatus.Value != "2")
                {
                    try
                    {
                        // Update articulation before submitting
                        var addArticulation = Controllers.Articulation.AddArticulation(Convert.ToInt32(hvOutlineID.Value), hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value), hvTitle.Value, reAssignNotes.Content, reJustification.Content, reArticulationOfficer.Content, hfRecommendations.Value, 1, Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value),false,1,false,9999999);

                        var previous = rcbPreviousStage.SelectedValue == "" ? 0 : Convert.ToInt32(rcbPreviousStage.SelectedValue);
                        var submit = GlobalUtil.SubmitArticulation(Convert.ToInt32(tbID.Text),Convert.ToInt32(hvUserID.Value), "", Convert.ToInt32(hvCollegeID.Value), previous, Convert.ToInt32(hvOutlineID.Value), direction, Convert.ToInt32(hvArticulationID.Value), 1, hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value), hvTitle.Value);
                        if (submit == 1)
                        {
                            DisplayMessage(true, "Articulation submitted.");
                            rgOtherRecommendations.DataBind();
                        }
                        else
                        {
                            DisplayMessage(true, "Problems submitting articulation.");
                        }
                    }
                    catch (Exception ex)
                    {
                        DisplayMessage(true, ex.ToString());
                    }

                }
                else
                {
                    DisplayMessage(true, "Cannot submit published articulations.");
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


        protected void rgOtherRecommendations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;
            if (e.CommandName == "UpdateOther")
            {
                foreach (GridDataItem itemDetail in rgOtherRecommendations.Items)
                {
                    var isChecked = false;
                    if ((itemDetail.FindControl("CheckBox1") as CheckBox).Checked)
                    {
                        isChecked = true;
                    }
                    norco_db.UpdateCourseRecommendation(Convert.ToInt32(itemDetail["RecommendationID"].Text), isChecked.ToString(), Convert.ToInt32(itemDetail["ID"].Text));
                }
                rgOtherRecommendations.DataBind();
                sqlRecommendations.DataBind();
                rblRecommendations.DataBind();
            }

            if (e.CommandName == "MoveAll")
            {
                var result = ValidateHaveCriteria();
                if (result != 1)
                {
                    pnlConfirmMoveAllRecommendations.Visible = true;
                    pnlConfirmMoveAllRecommendations.Focus();
                }
            }

            if (rgOtherRecommendations.SelectedItems.Count <= 0)
            {
                if (e.CommandName == "MoveForward")
                {
                    DisplayMessage(false, "Please select an articulation.");
                }
            }
            else
            {
                if (e.CommandName == "MoveForward")
                {
                    var result = ValidateHaveCriteria();
                    if (result != 1)
                    {
                        GridDataItem itemDetail = (GridDataItem)rgOtherRecommendations.MasterTableView.Items[rgOtherRecommendations.SelectedItems[0].ItemIndex];
                        GlobalUtil.SubmitArticulation(Convert.ToInt32(itemDetail["ID"].Text), Convert.ToInt32(hvUserID.Value), "", Convert.ToInt32(hvCollegeID.Value), 0, Convert.ToInt32(hvOutlineID.Value), 1, Convert.ToInt32(itemDetail["ArticulationID"].Text), 1, hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value), hvTitle.Value);
                        rgOtherRecommendations.DataBind();
                        LoadArticulation();
                    }
                }
            }
        }

        protected void rgOtherRecommendations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var recommendationID = dataBoundItem["RecommendationID"].Text;
                var recommendationIDs = dataBoundItem["RecommendationIDs"].Text;
                var RecommendationIsChecked = dataBoundItem["RecommendationIsChecked"].Text;

                CheckBox checkbox1 = e.Item.FindControl("CheckBox1") as CheckBox;

                if (RecommendationIsChecked == "True")
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

        protected void rbAddCriteria_Click(object sender, EventArgs e)
        {
            try
            {

                RadButton btn = (RadButton)sender;
                var criteria_type = Convert.ToInt32(btn.CommandArgument);
                var result = 0;
                var color = "";
                var foreColor = GlobalUtil.ReadSetting("MainCriteriaForeColor");
                var rowCount = 0;
                var selectedCriteria = 0;
                if (criteria_type == 1)
                {
                    //color = ColorTranslator.ToHtml(rcpColor.SelectedColor);
                    color = GlobalUtil.ReadSetting("MainCriteriaBackColor");
                    rowCount = rgCriteria.MasterTableView.Items.Count;
                    var criteriaVal = 0;
                    var evalCriteria = rcbCriteriaList.SelectedValue;
                    if (evalCriteria != "")
                    {
                        criteriaVal = Convert.ToInt32(evalCriteria);
                    }
                    selectedCriteria = Convert.ToInt32(rcbCriteriaCondition.SelectedValue);
                    if (rowCount == 0)
                    {
                        selectedCriteria = 1;
                    }
                    if (selectedCriteria != 3)
                    {
                        //Save criteria
                        result = Controllers.Criteria.SaveCriteria(Convert.ToInt32(hvArticulationID.Value), 1, Convert.ToInt32(Session["UserID"]), color, foreColor, rcbCriteriaList.Text, selectedCriteria, 1, criteriaVal);
                        //Save criteria for other articulations
                        Controllers.Criteria.SaveOtherCriteria(Convert.ToInt32(tbID.Text), 1, Convert.ToInt32(Session["UserID"]), color, foreColor, rcbCriteriaList.Text, selectedCriteria, 1, criteriaVal);
                    }
                    else
                    {
                        DisplayMessagesControl.DisplayMessage(false, "Select first a condition");
                    }
                }
                else
                {
                    color = GlobalUtil.ReadSetting("AdditionalCriteriaBackColor");
                    foreColor = GlobalUtil.ReadSetting("AdditionalCriteriaForeColor");
                    rowCount = rgAdditionalCriteria.MasterTableView.Items.Count;
                    selectedCriteria = 3;
                    //Save additional criteria
                    result = Controllers.Criteria.SaveCriteria(Convert.ToInt32(hvArticulationID.Value), 1, Convert.ToInt32(Session["UserID"]), color, foreColor, rtbAdditionalCriteria.Text.Trim(), selectedCriteria, 2, 0);
                }

                if (result > 0)
                {
                    DisplayMessagesControl.DisplayMessage(false, "Criteria Successfully added");
                    //Reset criteria text
                    if (criteria_type == 1)
                    {
                        //rtbCriteria.Text = "";
                        //rtbCriteria.Focus();
                        rcbCriteriaList.DataBind();
                        rcbCriteriaList.ClearSelection();
                        rcbCriteriaList.Focus();
                        rgCriteria.DataBind();
                    }
                    else
                    {
                        rtbAdditionalCriteria.Text = "";
                        rtbAdditionalCriteria.Focus();
                        rgAdditionalCriteria.DataBind();
                    }
                    AuditTrailViewer.DataBind();
                }
                else
                {
                    if (result == 0)
                    {
                        DisplayMessagesControl.DisplayMessage(false, "Criteria already exist");
                    }
                    else
                    {
                        DisplayMessagesControl.DisplayMessage(false, "Criteria not found");
                    }
                }

                rgCriteria.DataBind();
                Repeater4.DataBind();
                rptCurrentVerion.DataBind();
                rblRecommendations.DataBind();
                rgOtherRecommendations.DataBind();
                LoadArticulation();
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                DisplayMessage(false, ex.ToString());
            }

        }

        protected void rgCriteria_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;
            if (e.CommandName == "Delete")
            {
                try
                {
                    norco_db.DeleteArticulationCriteria(Convert.ToInt32(item["CriteriaID"].Text), Convert.ToInt32(hvOutlineID.Value), Convert.ToInt32(Session["UserID"]));
                    rgCriteria.DataBind();
                    rblRecommendations.DataBind();
                    rgOtherRecommendations.DataBind();
                    AuditTrailViewer.DataBind();
                    Repeater4.DataBind();
                    DisplayMessage(false, "Criteria successfully deleted");
                    Response.Redirect(Request.RawUrl);
                }
                catch (Exception ex)
                {
                    DisplayMessage(false, ex.ToString());
                }
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

        protected void rbMoveAll_Click(object sender, EventArgs e)
        {
            var AceID = "";
            var TeamRevd = "";
            foreach (GridDataItem itemDetail in rgOtherRecommendations.Items)
            {
                if (AceID != itemDetail["AceID"].Text || TeamRevd != itemDetail["TeamRevd"].Text)
                {
                    GlobalUtil.SubmitArticulation(Convert.ToInt32(itemDetail["ID"].Text), Convert.ToInt32(hvUserID.Value), "", Convert.ToInt32(hvCollegeID.Value), 0, Convert.ToInt32(hvOutlineID.Value), 1, Convert.ToInt32(itemDetail["ArticulationID"].Text), 1, hvAceID.Value, Convert.ToDateTime(hvTeamRevd.Value), hvTitle.Value);
                }
                AceID = itemDetail["AceID"].Text;
                TeamRevd = itemDetail["TeamRevd"].Text;
            }
            rgOtherRecommendations.DataBind();
            LoadArticulation();
            pnlConfirmMoveAllRecommendations.Visible = false;
        }

        protected void rbCancelMoveAll_Click(object sender, EventArgs e)
        {
            pnlConfirmMoveAllRecommendations.Visible = false;
        }



        protected void rbAddOthersCriteria_Click(object sender, EventArgs e)
        {
            if (rcbCriteriaList.SelectedValue != "")
            {
                //Save criteria
                var result = Controllers.Criteria.SaveCriteria(Convert.ToInt32(hvArticulationID.Value), 1, Convert.ToInt32(Session["UserID"]), GlobalUtil.ReadSetting("MainCriteriaBackColor"), GlobalUtil.ReadSetting("MainCriteriaForeColor"), rcbCriteriaList.Text, 1, 1, Convert.ToInt32(rcbCriteriaList.SelectedValue));
                //Save criteria for other articulations
                Controllers.Criteria.SaveOtherCriteria(Convert.ToInt32(tbID.Text), 1, Convert.ToInt32(Session["UserID"]), GlobalUtil.ReadSetting("MainCriteriaBackColor"), GlobalUtil.ReadSetting("MainCriteriaForeColor"), rcbCriteriaList.Text, 1, 1, Convert.ToInt32(rcbCriteriaList.SelectedValue));
            }
            rgCriteria.DataBind();
            var rowCount = rgCriteria.MasterTableView.Items.Count;
            if (rowCount > 0)
            {
                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/OtherOccupationsHaveCriteria.aspx?ArticulationID={0}&ArticulationType={1}&outline_id={2}&CollegeID={3}", hvArticulationID.Value, "1", hvOutlineID.Value, hvCollegeID.Value), true, true, false, 1000, 600));
            }
            else
            {
                DisplayMessagesControl.DisplayMessage(false, "Please add at least one highlighted criteria to move this/these articulation(s) forward.");
            }
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

        public void showAssignOccupationArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly)
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
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true{5}{6}", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), adoptParameter, otherCollegeIDParameter) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true", id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString()) + "');", true);
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
                //    var isReadOnly = false;
                //    var newArticulationID = 0;
                //    var adopted = norco_db.CloneOtherCollegeArticulation(Convert.ToInt32(tbID.Text), Convert.ToInt32(hvOtherCollegeID.Value), Convert.ToInt32(hvCollegeID.Value), Convert.ToInt32(hvUserID.Value), hvSubject.Value, hvCourseNumber.Value);
                //    rbAdoptArticulation.Enabled = false;
                //    foreach (CloneOtherCollegeArticulationResult item in adopted)
                //    {
                //        newArticulationID = Convert.ToInt32(item.ArticulationID);
                //    }
                //    var articulation = norco_db.GetArticulationByID(newArticulationID);
                //    foreach (GetArticulationByIDResult item in articulation)
                //    {
                //        if (hvUserStageID.Value != hvFirstStage.Value)
                //        {
                //            isReadOnly = true;
                //        }
                //        if (item.ArticulationType == 1)
                //        {
                //            showAssignArticulation(Convert.ToInt32(item.id), Convert.ToInt32(item.outline_id), item.AceID, item.Title, Convert.ToDateTime(item.TeamRevd), isReadOnly);
                //        }
                //        else
                //        {
                //            showAssignOccupationArticulation(Convert.ToInt32(item.id), Convert.ToInt32(item.outline_id), item.AceID, item.Title, Convert.ToDateTime(item.TeamRevd), isReadOnly);
                //        }
                //    }
                //    ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "ArticulationCreated();", true);
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(false, ex.Message.ToString());
            }
}
        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            rgCriteria.DataBind();
            rgOtherRecommendations.DataBind();
            LoadArticulation();
        }

        public void Archive()
        {
            if (hvArticulationStatus.Value == "2")
            {
                DisplayMessagesControl.DisplayMessage(true, "Can not archive this articulation");
            }
            else
            {
                try
                {
                    norco_db.ArchiveArticulation(Convert.ToInt32(hvArticulationID.Value), 1, Convert.ToInt32(Session["UserID"]));
                    DisplayMessagesControl.DisplayMessage(true, "Articulation has been archived");
                    LoadArticulation();
                }
                catch (Exception ex)
                {
                    DisplayMessagesControl.DisplayMessage(true, ex.ToString());
                }
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
    }
}