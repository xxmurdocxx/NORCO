using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class ConfirmAdoptCreditRecommendations : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        List<int> articulations = new List<int>();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hvCollegeID.Value = Request.QueryString["CollegeID"].ToString();
                hvUserID.Value = Request.QueryString["UserID"].ToString();
                hvUserStage.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(Session["CollegeID"].ToString()), Convert.ToInt32(Session["RoleID"].ToString())).ToString();
                hfExcludeArticulationOverYears.Value = Request.QueryString["Exclude"].ToString();
                hfBySubjectCourseCIDNumber.Value = Request.QueryString["SubjectCID"].ToString();
                hfOnlyImplemented.Value = Request.QueryString["OnlyImplemented"].ToString();

                var articulation_list = Request.QueryString["ArticulationList"].ToString();
                List<int> articulations = articulation_list.Split(',').Select(x => int.Parse(x.Trim())).ToList();
                hfArticulations.Value = string.Join(", ",articulations);
                sqlArticulations.SelectParameters["Articulations"].DefaultValue = articulation_list;
                sqlArticulations.DataBind();
                rgArticulations.DataBind();
            }
        }

        protected void rbProceed_Click(object sender, EventArgs e)
        {
            try
            {
                int counter = 0;
                Label _outline_id = new Label();
                Label _subject = new Label();
                Label _course_number = new Label();
                Label _cid_number = new Label();
                Label _selected_criteria = new Label();
                RadComboBox combobox = new RadComboBox();
                foreach (GridDataItem item in rgArticulations.MasterTableView.Items)
                {
                    GridNestedViewItem nestedItem = (GridNestedViewItem)item.ChildItem;
                    combobox = (RadComboBox)nestedItem.FindControl("rcbCourses");
                    if (CheckArticulationExists(Convert.ToInt32(combobox.SelectedValue), Convert.ToInt32(item["ExhibitID"].Text), Convert.ToInt32(item["CriteriaID"].Text)) == 1)
                    {
                        counter++;
                    }
                }
                if (counter == 0)
                {
                    DataTable selectedArticulations = GlobalUtil.GetAdoptSelectedArticulations(hfArticulations.Value);
                    if (selectedArticulations != null)
                    {
                        if (selectedArticulations.Rows.Count > 0)
                        {
                            foreach (DataRow row in selectedArticulations.Rows)
                            {
                                try
                                {
                                    foreach (GridDataItem item in rgArticulations.MasterTableView.Items)
                                    {
                                        GridNestedViewItem nestedItem = (GridNestedViewItem)item.ChildItem;
                                        combobox = (RadComboBox)nestedItem.FindControl("rcbCourses");
                                        _outline_id = (Label)nestedItem.FindControl("lblOutline");
                                        _subject = (Label)nestedItem.FindControl("lblSubject");
                                        _course_number = (Label)nestedItem.FindControl("lblCourseNumber");
                                        _cid_number = (Label)nestedItem.FindControl("lblCIDNumber");
                                        _selected_criteria = (Label)nestedItem.FindControl("lblSelectedCriteria");
                                        if (_outline_id.Text == row["outline_id"].ToString())
                                        {
                                            var adopted = norco_db.CloneOtherCollegeArticulation(Convert.ToInt32(row["id"].ToString()), Convert.ToInt32(row["CollegeID"].ToString()), Convert.ToInt32(Session["CollegeID"].ToString()), Convert.ToInt32(hvUserID.Value), _subject.Text, _course_number.Text, Convert.ToInt32(rcbStages.SelectedValue), _cid_number.Text, Convert.ToInt32(combobox.SelectedValue));
                                            foreach (CloneOtherCollegeArticulationResult adopt in adopted)
                                            {
                                                articulations.Add(Convert.ToInt32(adopt.ArticulationID.ToString()));
                                            }
                                            break;
                                        }
                                    }
                                }
                                catch (Exception ex)
                                {
                                    DisplayMessage(false, ex.ToString());
                                }
                                //if (combobox.Visible)
                                //{
                                //}
                                //else
                                //{
                                //    norco_db.CloneOtherCollegeArticulation(Convert.ToInt32(row["id"].ToString()), Convert.ToInt32(row["CollegeID"].ToString()), Convert.ToInt32(Session["CollegeID"].ToString()), Convert.ToInt32(hvUserID.Value), _subject.Text, _course_number.Text, Convert.ToInt32(rcbStages.SelectedValue), _cid_number.Text, Convert.ToInt32(_outline_id.Text));
                                //}
                            }
                        }
                    }

                    //NOTIFY
                    Dictionary<int, int> arts = (from x in articulations
                                                 select x).Distinct().ToDictionary(x => x, x => x);
                    Session["articulationList"] = arts;
                    NotifyPopup("Adopt", Convert.ToInt32(hvUserStage.Value), Session["UserName"].ToString(), Convert.ToInt32(hvUserID.Value), Convert.ToInt32(hvCollegeID.Value), 1000, 700);
                }
                else
                {
                    rnMessage.Show();
                }



                //if (articulations.Count() > 0)
                //{
                //    foreach (var articulation in articulations)
                //    {
                //        var articulation_info = norco_db.GetArticulationByID(articulation);
                //        foreach (GetArticulationByIDResult art in articulation_info)
                //        {
                //            var checkExist = norco_db.CheckArticulationExistInCollege(Convert.ToInt32(hvCollegeID.Value), art.subject, art.course_number, art.AceID, Convert.ToDateTime(art.TeamRevd));
                //            if (checkExist == false)
                //            {
                //                //norco_db.CloneOtherCollegeArticulation(Convert.ToInt32(articulation), art.CollegeID, Convert.ToInt32(hvCollegeID.Value), Convert.ToInt32(hvUserID.Value), art.subject, art.course_number, Convert.ToInt32(rcbStages.SelectedValue));
                //            }
                //        }
                //    }
                //    DisableAdopt();
                //    rnMessage.Title = "Adopt Articulation";
                //    rnMessage.Text = "Articulation(s) successfully adopted!";
                //    rnMessage.Show();
                //}
            }
            catch (Exception ex)
            {
                DisplayMessage(false, ex.ToString());
            }
        }

        public static int CheckArticulationExists(int outline_id, int exhibit_id, int criteria_id)
        {
            int exists = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = string.Format("select [dbo].[CheckArticulationExist] ({0},'{1}','{2}');", outline_id, exhibit_id, criteria_id);
                    exists = ((int)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
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

        protected void rgArticulations_PreRender(object sender, EventArgs e)
        {
            foreach (GridEditFormItem editItem in rgArticulations.MasterTableView.GetItems(GridItemType.EditFormItem))
            {
                foreach (GridDataItem item in rgArticulations.MasterTableView.Items)
                {
                    if (!item.Expanded)
                    {
                        GridNestedViewItem nestedItem = (GridNestedViewItem)item.ChildItem;
                        RadComboBox combobox = (RadComboBox)nestedItem.FindControl("rcbCourses");
                        combobox.DataSourceID = "sqlCourses";
                        combobox.DataTextField = "CourseDescription";
                        combobox.DataValueField = "outline_id";
                    }
                }
                HideExpandColumnRecursive(rgArticulations.MasterTableView);
            }
        }

        public void HideExpandColumnRecursive(GridTableView tableView)
        {
            GridItem[] nestedViewItems = tableView.GetItems(GridItemType.NestedView);
            foreach (GridNestedViewItem nestedViewItem in nestedViewItems)

            {
                foreach (GridTableView nestedView in nestedViewItem.NestedTableViews)
                {
                    TableCell cell = nestedView.ParentItem["ExpandColumn"];
                    cell.Controls[0].Visible = false;
                    cell.Text = "&nbsp";
                    nestedViewItem.Visible = false;

                }
            }
        }

        protected void rgArticulations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridGroupHeaderItem)
            {
                GridGroupHeaderItem groupHeader = (GridGroupHeaderItem)e.Item;
                {
                    groupHeader.DataCell.Text = groupHeader.DataCell.Text.Split(':')[1].ToString();
                }
            }
            string subject;
            string course_number;
            string cid_number;
            bool exists = false;
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                subject = dataBoundItem["subject"].Text;
                course_number = dataBoundItem["course_number"].Text;
                cid_number = dataBoundItem["CIDNumber"].Text;
                exists = GlobalUtil.CheckCourseExistsInCollege(Convert.ToInt32(Session["CollegeID"]), subject, course_number, cid_number);
                if (!exists)
                {
                    //dataBoundItem.BackColor = System.Drawing.Color.LightYellow;
                }
            }
            if (e.Item is GridNestedViewItem)
            {
                GridNestedViewItem nestedItem = (GridNestedViewItem)e.Item;
                RadComboBox rcb = (RadComboBox)nestedItem.FindControl("rcbCourses");
                Label lbl_subject = (Label)nestedItem.FindControl("lblSubject");
                Label lbl_course_number = (Label)nestedItem.FindControl("lblCourseNumber");
                Label lbl_cid_number = (Label)nestedItem.FindControl("lblCIDNumber");
                Label lbl_outline_id = (Label)nestedItem.FindControl("lblOutlineIDCollege");
                //if (GlobalUtil.CheckCourseExistsInCollege(Convert.ToInt32(Session["CollegeID"]), lbl_subject.Text, lbl_course_number.Text, lbl_cid_number.Text))
                //{
                //    rcb.SelectedValue = lbl_outline_id.Text;
                //} 
                //rcb.Visible = !GlobalUtil.CheckCourseExistsInCollege(Convert.ToInt32(Session["CollegeID"]), lbl_subject.Text, lbl_course_number.Text, lbl_cid_number.Text);
            }
        }

        protected void rgArticulations_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridGroupHeaderItem)
            {
                (e.Item as GridGroupHeaderItem).Cells[0].Controls.Clear();
            }
        }
    }
}