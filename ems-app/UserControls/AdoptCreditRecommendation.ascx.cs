using DocumentFormat.OpenXml.Office2010.Excel;
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

namespace ems_app.UserControls
{
    public partial class AdoptCreditRecommendation : System.Web.UI.UserControl
    {
        NORCODataContext norco_db = new NORCODataContext();
        List<int> articulations = new List<int>();

        private int college_id = 0;
        private bool exclude_years = false;
        private int role_id = 0;
        private string user_name = "";
        private int user_id = 0;
        private bool only_implemented = false;
        private bool subjectcourse_cidnumber = false;
		private bool show_all = false;
        private string ace_id = "";
        public int RoleID
        {
            get { return role_id; }
            set { role_id = value; }
        }
        public int UserID
        {
            get { return user_id; }
            set { user_id = value; }
        }
        public string UserName
        {
            get { return user_name; }
            set { user_name = value; }
        }
        public int CollegeID
        {
            get { return college_id; }
            set { college_id = value; }
        }
        public bool ExcludeArticulationOverYears
        {
            get { return exclude_years; }
            set { exclude_years = value; }
        }

        public bool OnlyImplemented
        {
            get { return only_implemented; }
            set { only_implemented = value; }
        }

        public bool BySubjectCourseCIDNumber
        {
            get { return subjectcourse_cidnumber; }
            set { subjectcourse_cidnumber = value; }
        }
		public bool ShowAll
        {
            get { return show_all; }
            set { show_all = value; }
        }
        public string AceID
        {
            get { return ace_id; }
            set { ace_id = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rchkExcludeOverYears.Checked = ExcludeArticulationOverYears;
				rchkShowAll.Checked = true;						   

                rchkOnlyImplemented.Checked = false;
                if (OnlyImplemented)
                {
                    rchkOnlyImplemented.Checked = true;
                }

                rchkOnlyImplemented.Checked = false;
                if (OnlyImplemented)
                {
                    rchkOnlyImplemented.Checked = true;
                }

                rchkSubjectCourseCIDNumber.Checked = false;
                if (BySubjectCourseCIDNumber)
                {
                    rchkSubjectCourseCIDNumber.Checked = true;
                }

				ToggleCID(true);
                //if (BySubjectCourseCIDNumber || (bool)rchkShowAll.Checked )
                //{

                //}
                //ToggleCID((bool)rchkSubjectCourseCIDNumber.Checked);

                hfOnlyImplemented.Value = OnlyImplemented.ToString();
                hfBySubjectCourseCIDNumber.Value = BySubjectCourseCIDNumber.ToString();

                rchkExcludeOverYears.Text += string.Format(" {0} years.", GlobalUtil.ReadSetting("ExcludeArticulationOverYears"));
                if (ExcludeArticulationOverYears)
                {
                    hfExcludeArticulationOverYears.Value = GlobalUtil.ReadSetting("ExcludeArticulationOverYears");
                } else
                {
                    hfExcludeArticulationOverYears.Value = "200";
                }

                sqlSubjects.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlColleges.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();

                hvUserStage.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(CollegeID), Convert.ToInt32(RoleID)).ToString(); ;
                hvUserName.Value = UserName;
                hvUserID.Value = UserID.ToString();
                hvCollegeID.Value = CollegeID.ToString();

                if (AceID != null)
                {
                    //racbAdvancedSearch.Entries.Insert(0, new AutoCompleteBoxEntry(AceID));
                    hfAceID.Value = AceID;
                }

                setDataSource();
                setDataSourceSearch();
                setDataSourceACEID();
            }
        }

        private void ToggleCID(bool toggle)
        {
            rgOtherCollegeArticulations.MasterTableView.Columns.FindByUniqueName("CIDNumber").Display = toggle;
            rgOtherCollegeArticulations.MasterTableView.Columns.FindByUniqueName("Descriptor").Display = toggle;
            rgOtherCollegeArticulations.MasterTableView.Columns.FindByUniqueName("CourseCollege").Display = toggle;
        }

        protected void rgOtherCollegeArticulations_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "View" || e.CommandName == "Adopt")
                {
                    ExecuteCommands(e.CommandName);
                }
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.ToString());
            }
        }

        protected void rgOtherCollegeArticulations_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridGroupHeaderItem)
            {
                GridGroupHeaderItem groupHeader = (GridGroupHeaderItem)e.Item;
                {
                    groupHeader.DataCell.Text = groupHeader.DataCell.Text.Split(':')[1].ToString();
                }
            }
            if (e.Item is GridDataItem)
            {
                GridDataItem gridItem = e.Item as GridDataItem;
                gridItem.ToolTip = "Click here to Adopt or View the Articulations for this Credit Recommendation";
            }
        }

        public void ConfirmAdopt(string articulation_list, int user_id, int college_id, int width, int height, string exclude, string subject_cid, string only_implemented)
        {
            string url;
            url = String.Format("/modules/popups/ConfirmAdoptCreditRecommendations.aspx?ArticulationList={0}&UserID={1}&CollegeID={2}&Exclude={3}&SubjectCID={4}&OnlyImplemented={5}", articulation_list, user_id, college_id, exclude, subject_cid, only_implemented);
            RadWindowManagerAdp.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        protected void rcmAdoptArticulations_ItemClick(object sender, RadMenuEventArgs e)
        {
            try
            {
                ExecuteCommands(e.Item.Value);
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.ToString());
            }

        }

        public void ExecuteCommands(string command)
        {
            var user_id = Convert.ToInt32(hvUserID.Value);
            var college_id = Convert.ToInt32(hvCollegeID.Value);

            try
            {
                if (rgOtherCollegeArticulations.SelectedItems.Count <= 0)
                {
                    DisplayMessagesControl.DisplayMessage(false, "Select an Articulation.");
                }
                else
                {
                    if (rgOtherCollegeArticulations.SelectedItems.Count > 1)
                    {
                        foreach (GridDataItem item in rgOtherCollegeArticulations.SelectedItems)
                        {
                            switch (command)
                            {
                                case "Adopt":
                                    DataTable selectedArticulations = GlobalUtil.GetSelectedArticulations(Convert.ToInt32(Session["CollegeID"].ToString()), Convert.ToInt32(item["outline_id"].Text), item["SelectedCriteria"].Text, (bool)rchkOnlyImplemented.Checked, (bool)rchkSubjectCourseCIDNumber.Checked, Convert.ToInt32(hfExcludeArticulationOverYears.Value));
                                    if (selectedArticulations != null)
                                    {
                                        if (selectedArticulations.Rows.Count > 0)
                                        {
                                            foreach (DataRow row in selectedArticulations.Rows)
                                            {
                                                articulations.Add(Convert.ToInt32(row["id"].ToString()));
                                            }
                                        }
                                    }
                                    break;
                                case "View":
                                    DisplayMessagesControl.DisplayMessage(false, "You can review only one articulation");
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                    else
                    {
                        foreach (GridDataItem item in rgOtherCollegeArticulations.SelectedItems)
                        {
                            switch (command)
                            {
                                case "Adopt":
                                    DataTable selectedArticulations = GlobalUtil.GetSelectedArticulations(Convert.ToInt32(Session["CollegeID"].ToString()), Convert.ToInt32(item["outline_id"].Text), item["SelectedCriteria"].Text, (bool)rchkOnlyImplemented.Checked, (bool)rchkSubjectCourseCIDNumber.Checked, Convert.ToInt32(hfExcludeArticulationOverYears.Value));

                                    if (selectedArticulations != null)
                                    {
                                        if (selectedArticulations.Rows.Count > 0)
                                        {
                                            foreach (DataRow row in selectedArticulations.Rows)
                                            {
                                                articulations.Add(Convert.ToInt32(row["id"].ToString()));
                                            }
                                        }
                                    }
                                    break;
                                case "View":
                                    showArticulations(item["SelectedCriteria"].Text, Convert.ToInt32(item["outline_id"].Text), 800,400);
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                    if (command == "Adopt")
                    {
                       ConfirmAdopt(string.Join(",", articulations), user_id, college_id, 1100, 650, hfExcludeArticulationOverYears.Value, rchkSubjectCourseCIDNumber.Checked.ToString(), rchkOnlyImplemented.Checked.ToString());
                        rgOtherCollegeArticulations.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessagesControl.DisplayMessage(true, ex.ToString());
            }
        }
		// Lines 267-289 Commented on 3/16/22 per Beto's latest version ***
        //public static DataTable GetSelectedArticulations(int college_id, int outline_id, string selected_criteria, bool only_implemented, bool subject_course_cidnumber, int exclude_years)
        //{
        //    DataTable myDataTable = new DataTable();
        //    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
        //    conn.Open();
        //    try
        //    {
        //        SqlCommand cmd = new SqlCommand("GetAdoptCreditRecommendationArticulations", conn);
        //        cmd.Parameters.Add("@CollegeID", SqlDbType.Int).Value = college_id;
        //        cmd.Parameters.Add("@outline_id", SqlDbType.Int).Value = outline_id;
        //        cmd.Parameters.Add("@selected_criteria", SqlDbType.VarChar).Value = selected_criteria;
        //        cmd.Parameters.Add("@OnlyImplemented", SqlDbType.Bit).Value = only_implemented;
        //        cmd.Parameters.Add("@BySubjectCourseNumberorCIDNumber", SqlDbType.Bit).Value = subject_course_cidnumber;
        //       cmd.Parameters.Add("@ExcludeArticulationOverYears", SqlDbType.Int).Value = exclude_years;
        //        cmd.CommandType = CommandType.StoredProcedure;
        //        SqlDataAdapter adp = new SqlDataAdapter(cmd);
        //        adp.Fill(myDataTable);
        //    }
        //    finally
        //    {
        //        conn.Close();
        //    }
        //    return myDataTable;
        //}

        //public void showArticulations(string selected_criteria, int outline_id, int width, int height)
        //{
        //    var urlPage = "/modules/popups/AdoptCreditRecommendationArticulations.aspx";
        //    var url = String.Format("{0}?selected_criteria={1}&outline_id={2}", urlPage, selected_criteria.ToString(), outline_id.ToString());
        //    RadWindowManagerAdopt.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, width, height));
        //}

        public void showArticulations(string selected_criteria, int outline_id, int width, int height)
        {
            var urlPage = "/modules/popups/AdoptCreditRecommendationArticulations.aspx";
            var url = String.Format("{0}?selected_criteria={1}&outline_id={2}&exclude={3}&subject_cid={4}&only_implemented={5}", urlPage, selected_criteria.ToString(), outline_id.ToString(), hfExcludeArticulationOverYears.Value, rchkSubjectCourseCIDNumber.Checked.ToString(), rchkOnlyImplemented.Checked.ToString());
            RadWindowManagerAdopt.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, width, height));
        }

        private void setDataSource()
        {
            sqlOtherCollegeArticulations.SelectParameters["CollegeID"].DefaultValue = hvCollegeID.Value;
            sqlOtherCollegeArticulations.SelectParameters["ExcludeArticulationOverYears"].DefaultValue = hfExcludeArticulationOverYears.Value;
            sqlOtherCollegeArticulations.SelectParameters["OnlyImplemented"].DefaultValue = rchkOnlyImplemented.Checked.ToString();
            sqlOtherCollegeArticulations.SelectParameters["BySubjectCourseNumberorCIDNumber"].DefaultValue = rchkSubjectCourseCIDNumber.Checked.ToString();
			sqlOtherCollegeArticulations.SelectParameters["ShowAll"].DefaultValue = rchkShowAll.Checked.ToString();
            sqlOtherCollegeArticulations.SelectParameters["CreditRecommendation"].DefaultValue = hfCreditRecommendation.Value;
            sqlOtherCollegeArticulations.SelectParameters["AceIDs"].DefaultValue = hfAceID.Value;
            sqlOtherCollegeArticulations.DataBind();
            rgOtherCollegeArticulations.DataBind();
        }

        private void setDataSourceSearch()
        {
            sqlCriteria.SelectParameters["CollegeID"].DefaultValue = hvCollegeID.Value;
            sqlCriteria.SelectParameters["ExcludeArticulationOverYears"].DefaultValue = hfExcludeArticulationOverYears.Value;
            sqlCriteria.SelectParameters["OnlyImplemented"].DefaultValue = rchkOnlyImplemented.Checked.ToString();
            sqlCriteria.SelectParameters["BySubjectCourseNumberorCIDNumber"].DefaultValue = rchkSubjectCourseCIDNumber.Checked.ToString();
            sqlCriteria.SelectParameters["ShowAll"].DefaultValue = rchkShowAll.Checked.ToString();
            sqlCriteria.SelectParameters["CreditRecommendation"].DefaultValue = hfCreditRecommendation.Value;
            sqlCriteria.SelectParameters["AceIDs"].DefaultValue = hfAceID.Value;
            sqlCriteria.DataBind();
        }
        private void setDataSourceACEID()
        {
            sqlAdvancedSearch.SelectParameters["CollegeID"].DefaultValue = hvCollegeID.Value;
            sqlAdvancedSearch.SelectParameters["ExcludeArticulationOverYears"].DefaultValue = hfExcludeArticulationOverYears.Value;
            sqlAdvancedSearch.SelectParameters["OnlyImplemented"].DefaultValue = rchkOnlyImplemented.Checked.ToString();
            sqlAdvancedSearch.SelectParameters["BySubjectCourseNumberorCIDNumber"].DefaultValue = rchkSubjectCourseCIDNumber.Checked.ToString();
            sqlAdvancedSearch.SelectParameters["ShowAll"].DefaultValue = rchkShowAll.Checked.ToString();
            sqlAdvancedSearch.DataBind();
        }

        protected void rchkOnlyImplemented_CheckedChanged(object sender, EventArgs e)
        {
            setDataSource();
            setDataSourceSearch();
            setDataSourceACEID();
        }

        protected void rchkSubjectCourseCIDNumber_CheckedChanged(object sender, EventArgs e)
        {
            setDataSource();
            setDataSourceSearch();
            setDataSourceACEID();
            //ToggleCID((bool)rchkSubjectCourseCIDNumber.Checked);
        }

        protected void rchkExcludeOverYears_CheckedChanged(object sender, EventArgs e)
        {
            if ((bool)rchkExcludeOverYears.Checked)
            {
                hfExcludeArticulationOverYears.Value = GlobalUtil.ReadSetting("ExcludeArticulationOverYears");
            }
            else
            {
                hfExcludeArticulationOverYears.Value = "200";
            }
        }
		 protected void rchkShowAll_CheckedChanged(object sender, EventArgs e)
        {
            setDataSource();
            setDataSourceSearch();
            setDataSourceACEID();
            //ToggleCID(true);
        }

        protected void rbSearch_Click(object sender, EventArgs e)
        {
            List<string> creditRecommendations = new List<string>();
            List<string> aceIDs = new List<string>();
            hfCreditRecommendation.Value = "";
            hfAceID.Value = "";
            if (cboAdvancedSearch.CheckedItems.Count > 0)
            {
                foreach (RadComboBoxItem item in cboAdvancedSearch.CheckedItems)
                {
                    aceIDs.Add(item.Value.Trim());
                }
                aceIDs.Distinct().ToList();
                hfAceID.Value = string.Join("|", aceIDs);
            }
            if (cboCriteria.CheckedItems.Count > 0)
            {
                foreach (RadComboBoxItem item in cboCriteria.CheckedItems)
                {
                    creditRecommendations.Add(item.Value.Trim());
                }
                creditRecommendations.Distinct().ToList();
                hfCreditRecommendation.Value = string.Join("|", creditRecommendations);
            }
            setDataSource();
        }

        protected void rbClear_Click(object sender, EventArgs e)
        {
            hfAceID.Value = "";
            hfCreditRecommendation.Value = "";
            cboAdvancedSearch.ClearCheckedItems();
            cboAdvancedSearch.Text = String.Empty;
            cboCriteria.ClearCheckedItems();
            cboCriteria.Text = String.Empty;
            setDataSource();
            setDataSourceSearch();
            setDataSourceACEID();
        }

        protected void btnExcel_Click(object sender, EventArgs e)
        {
            //setup properties for the data export
            rgOtherCollegeArticulations.ExportSettings.ExportOnlyData = true;
            rgOtherCollegeArticulations.ExportSettings.OpenInNewWindow = true;
            rgOtherCollegeArticulations.ExportSettings.IgnorePaging = true;
            rgOtherCollegeArticulations.ExportSettings.HideNonDataBoundColumns = true;
            rgOtherCollegeArticulations.ExportSettings.UseItemStyles = false;
            foreach (GridGroupHeaderItem groupItem in rgOtherCollegeArticulations.MasterTableView.GetItems(GridItemType.GroupHeader))
            {
                groupItem.Visible = false;
            }
            rgOtherCollegeArticulations.MasterTableView.ExportToExcel();
        }

        protected void rgArticulations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem )
            {
                GridDataItem item = e.Item as GridDataItem;
                HyperLink hp = (HyperLink)item.FindControl("hlExhibit");
                hp.NavigateUrl = $"javascript:showExhibitInfo('{item["ExhibitID"].Text}','{item["SelectedCriteria"].Text}')";
                hp.Text = item["Title"].Text;
                HyperLink hpAceID = (HyperLink)item.FindControl("hlAceExhibit");
                hpAceID.NavigateUrl = $"javascript:showExhibitInfo('{item["ExhibitID"].Text}','{item["SelectedCriteria"].Text}')";
                hpAceID.Text = item["AceID"].Text;
            }
        }

    }
}