using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.military
{
    public partial class ACECatalogSearch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rcbColleges.DataBind();
                hfCollegeID.Value = Session["CollegeID"].ToString();
                rcbColleges.SelectedValue = Session["CollegeID"].ToString();
                var collegeId = Session["CollegeID"].ToString();
                var districtId = GetCollegeDistrictID(collegeId);
                hfDistrictID.Value = districtId.ToString();

            }
        }

        protected void rgArticulationCourses_FilterCheckListItemsRequested(object sender, GridFilterCheckListItemsRequestedEventArgs e)
        {
            string DataField = (e.Column as IGridDataColumn).GetActiveDataField();
            string query = "";
            if (DataField == "subject")
            {
                query = string.Format("select s.subject from tblSubjects s where s.college_id = {0} order by s.subject", Session["CollegeID"].ToString());
            }
            if (DataField == "ArtRole")
            {
                query = string.Format("select r.RoleName as 'ArtRole' from Stages s join ROLES r on s.RoleId = r.RoleID where s.CollegeId = {0}", Session["CollegeID"].ToString());
            }

            e.ListBox.DataSource = GetDataTable(query);
            e.ListBox.DataKeyField = DataField;
            e.ListBox.DataTextField = DataField;
            e.ListBox.DataValueField = DataField;
            e.ListBox.DataBind();
        }

        public DataTable GetDataTable(string query)
        {
            DataTable myDataTable = new DataTable();

            String ConnString = ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString;
            SqlConnection conn = new SqlConnection(ConnString);
            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = new SqlCommand(query, conn);

            conn.Open();
            try
            {
                adapter.Fill(myDataTable);
            }
            finally
            {
                conn.Close();
            }

            return myDataTable;
        }

        protected void rgArticulationCourses_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;

            if (e.CommandName == RadGrid.FilterCommandName)
            {
                Pair filterPair = (Pair)e.CommandArgument;
                string columnUniqueName = filterPair.Second.ToString();

                if (columnUniqueName == "subject")
                {
                    hfSubjectFilter.Value = rgArticulationCourses.MasterTableView.Columns.FindByUniqueName("subject").CurrentFilterValue;
                }
                if (columnUniqueName == "course_number")
                {
                    hfCourseFilter.Value = rgArticulationCourses.MasterTableView.Columns.FindByUniqueName("course_number").CurrentFilterValue;
                }
                if (columnUniqueName == "course_title")
                {
                    hfTitleFilter.Value = rgArticulationCourses.MasterTableView.Columns.FindByUniqueName("course_title").CurrentFilterValue;
                }



            }



            if (e.CommandName == "HeaderContextMenuFilter")
            {
                List<string> subjectList = new List<string>();
                foreach (GridColumn column in grid.MasterTableView.RenderColumns.Where(x => x.SupportsFiltering()))
                {
                    if (column.UniqueName == "subject")
                    {
                        string[] subjectItems = column.ListOfFilterValues;
                        if (subjectItems != null)
                        {
                            foreach (string Str in subjectItems)
                            {
                                subjectList.Add(Str);
                            }
                            hfSubjectFilter.Value = string.Join(",", subjectList);
                        }
                    }
                }


            }
        }

        protected void rbClear_Click(object sender, EventArgs e)
        {;
            racbAceExhibit.Entries.Clear();
            racbACECriteria.Entries.Clear();
            hfACEIds.Value = "";
            hfCriteriaIds.Value = "";
            rgArticulationCourses.DataBind();
        }

        protected void rbSearch_Click(object sender, EventArgs e)
        {
            
            AutoCompleteBoxEntryCollection ACEIdCollection = racbAceExhibit.Entries;
            List<string> ACEIdsEntriesText = (from AutoCompleteBoxEntry entry in ACEIdCollection
                                        select entry.Value).ToList();
            hfACEIds.Value = string.Join(",", ACEIdsEntriesText);
            AutoCompleteBoxEntryCollection CriteriaIdCollection = racbACECriteria.Entries;
            List<string> CriteriaIdsEntriesText = (from AutoCompleteBoxEntry entry in CriteriaIdCollection
                                                   select entry.Value).ToList();
            hfCriteriaIds.Value = string.Join(",", CriteriaIdsEntriesText);
        }

        protected void rgArticulationCourses_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            //if (e.Item is GridCommandItem )
            //{
            //    GridCommandItem cmditem = (GridCommandItem)e.Item;
            //    RadButton print_button = (RadButton)cmditem.FindControl("btnPrint");
            //    var url = string.Format("../reports/ArticulationsReport.aspx?CollegeID={0}?UserID={1}?RoleID={2}?OrderBy={3}?CollegeName={4}?Username={5}", Session["CollegeID"].ToString(), Session["UserID"].ToString(), Session["RoleID"].ToString(), rblSort.SelectedValue, Session["CollegeName"].ToString(), Session["UserName"].ToString()); 
            //    print_button.OnClientClicked = string.Format("ShowArticulations({0},100,650);",url);
            //}
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;

                Label lbl_articulate_notes = e.Item.FindControl("lblArticulationNotes") as Label;
                lbl_articulate_notes.Visible = false;
                if (dataBoundItem["ArticulationNotes"].Text != "" && dataBoundItem["ArticulationNotes"].Text != "&nbsp;")
                {
                    lbl_articulate_notes.Visible = true;
                    lbl_articulate_notes.ToolTip = dataBoundItem["ArticulationNotes"].Text;
                }
            }
        }

        protected void btnEditNotes_Click(object sender, EventArgs e)
        {
            var lbtn = sender as LinkButton;
            var item = lbtn.NamingContainer as GridDataItem;
            if (item["articulation_type"].Text == "1")
            {
                showAssignOccupationArticulation(Convert.ToInt32(item["id"].Text), Convert.ToInt32(item["outline_id"].Text), item["AceID"].Text, item["Title"].Text, Convert.ToDateTime(item["TeamRevd"].Text), false, Convert.ToInt32(item["ExhibitID"].Text));
            }
            else
            {
                showAssignOccupationArticulation(Convert.ToInt32(item["id"].Text), Convert.ToInt32(item["outline_id"].Text), item["AceID"].Text, item["Title"].Text, Convert.ToDateTime(item["TeamRevd"].Text), false, Convert.ToInt32(item["ExhibitID"].Text));
            }
        }


        public void showAssignOccupationArticulation(int id, Int32 outline_id, String AceID, String Title, DateTime TeamRevd, bool isReadOnly, int ExhibitID)
        {
            if (isReadOnly)
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&isReadOnly=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../popups/AssignOccupationArticulation.aspx?articulationID={0}&outline_id={1}&AceID={2}&Title={3}&TeamRevd={4}&NewWindow=true&ExhibitID={5}", id.ToString(), outline_id.ToString(), AceID, Title.Replace("'", ""), TeamRevd.ToString(), ExhibitID) + "');", true);
            }
        }

        public static int GetCollegeDistrictID(string CollegeID)
        {
            int districtId = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select distinct DistrictID from tblDistrictCollege where CollegeID = {CollegeID};";
                    districtId = (int)cmd.ExecuteScalar();
                }
                finally
                {
                    connection.Close();
                }
            }
            return districtId;
        }


    }
}