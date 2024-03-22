using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Office2016.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.DynamicData;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.notifications
{
    public partial class Confirm : System.Web.UI.Page
    {
        Dictionary<int, int> articulations = new Dictionary<int, int>();
        NORCODataContext norco_db = new NORCODataContext(); 
        public static DataTable GetMessage(int message_id)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetMessage", conn);
                cmd.Parameters.Add("@MessageID", SqlDbType.Int).Value = message_id;
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

        public static DataTable GetUserDataByID(int user_id)
        {
            DataTable myDataTable = new DataTable();
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString);
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("GetUserDataByID", conn);
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = user_id;
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
        protected void Page_Load(object sender, EventArgs e)
        {
            string MessageID = Decrypt(Request["MessageID"]);
            string Action = Decrypt(Request["Action"]);
            string AceID = Decrypt(Request["AceID"]);
            string TeamRevd = Decrypt(Request["TeamRevd"]);
            string ActionTaken = Decrypt(Request["ActionTaken"]);

            if (!IsPostBack)
            {
                var authUser = norco_db.ValidateUser(Decrypt(Request["AceID"]), Decrypt(Request["TeamRevd"]));
                if (authUser.Count() != 0)
                {
                    var userData = norco_db.GetUserDataByUserName(Decrypt(Request["AceID"]), 1);
                    foreach (GetUserDataByUserNameResult p in userData)
                    {
                        Session["UserID"] = p.UserID;
                        Session["LastName"] = p.LastName;
                        Session["FirstName"] = p.FirstName;
                        Session["UserName"] = p.UserName;
                        Session["CollegeID"] = p.CollegeID;
                        Session["College"] = p.College;
                        Session["RoleID"] = p.RoleID;
                        Session["RoleName"] = p.RoleName;
                        Session["StyleSheet"] = p.StyleSheet;
                        Session["isAdministrator"] = p.isAdministrator;
                        Session["reviewArticulations"] = p.reviewArticulations;
                        Session["isArticulationOfficer"] = p.isArticulationOfficer;
                        Session["PendingDataIntake"] = p.PendingDataIntake;
                        Session["UserStageID"] = norco_db.GetStageIDByRoleId(p.CollegeID, p.RoleID);
                        Session["CollegeLogo"] = p.CollegeLogo;
                        Session["OnBoarding"] = p.Welcome.ToString();
                        Session["SuperUser"] = p.SuperUser ?? false;
                        Session["DistrictAdministrator"] = p.DistrictAdministrator ?? false;
                        FormsAuthentication.SetAuthCookie(p.UserName, false);
                    }
                }
                if (Decrypt(Request["ActionTaken"]) != "CriteriaPackage")
                {
                    LeftPane.Visible = false;
                    rgFacultyReviewArticulations.MasterTableView.GetColumn("subject").Display = true;
                    rgFacultyReviewArticulations.MasterTableView.GetColumn("course_number").Display = true;
                    rgFacultyReviewArticulations.MasterTableView.GetColumn("course_title").Display = true;
                }
                DataTable messages = GetMessage(Convert.ToInt32(Decrypt(Request["MessageID"])));
                if (messages != null)
                {
                    if (messages.Rows.Count > 0)
                    {
                        foreach (DataRow row in messages.Rows)
                        {
                            hfOutlineID.Value = row["outline_id"].ToString();
                            hfArticulations.Value = row["Articulations"].ToString();
                            hfUserID.Value = row["ToUserID"].ToString();
                            hvFromUserCollegeID.Value = row["FromUserCollegeID"].ToString();
                            lblTitle.InnerText = row["Subject"].ToString();
                        }
                    }
                }
                DataTable user = GetUserDataByID(Convert.ToInt32(hfUserID.Value));
                if (user != null)
                {
                    if (user.Rows.Count > 0)
                    {
                        foreach (DataRow row in user.Rows)
                        {
                            hvUserName.Value = row["UserName"].ToString();
                            hvUserStage.Value = norco_db.GetStageIDByRoleId(Convert.ToInt32(row["CollegeID"].ToString()), Convert.ToInt32(row["RoleID"].ToString())).ToString() ;
                            hvCollegeID.Value = row["CollegeID"].ToString();                            
                        }
                    }
                }
                hvFirstStage.Value = norco_db.GetMinimumStageId(Convert.ToInt32(hvCollegeID.Value)).ToString();
                hvLastStage.Value = norco_db.GetMaximumStageId(Convert.ToInt32(hvCollegeID.Value)).ToString();
                lConfirmText.Visible = false;
                rbAction.Visible = false;
                rtbNotes.Visible = false;
                if (Decrypt(Request["Action"])!="View")
                {
                    rgFacultyReviewArticulations.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                    switch (Decrypt(Request["Action"]))
                    {
                        case "Approve":
                            lConfirmText.Text = "The approval of the selected credit recommendation articulation(s) has been performed successfuly.";
                            break;
                        case "Deny":
                            lConfirmText.Text = "The denial of the selected credit recommendation articulation(s) has been performed successfuly.";
                            break;
                        default:
                            break;
                    }
                    rtbNotes.Visible = true;
                    rbAction.Visible = true;
                    rbAction.Text = Decrypt(Request["Action"]);
                    lConfirmText.Visible = false;
                } 
            }
            rgFacultyReviewArticulations.DataBind();
            int total_rows = rgFacultyReviewArticulations.MasterTableView.Items.Count;
            if (total_rows.ToString() == hvDisabledArticulationsCount.Value)
            {
                rbAction.Enabled = false;
            }
            
        }


        protected void rgFacultyReviewArticulations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem itemDetail = e.Item as GridDataItem;
            try
            {
                var user_stage_id = Convert.ToInt32(hvUserStage.Value);
                var user_name = hvUserName.Value;
                var user_id = Convert.ToInt32(hfUserID.Value);
                var college_id = Convert.ToInt32(hvCollegeID.Value);

                if (e.CommandName == "MoveForward" || e.CommandName == "Return" || e.CommandName == "Denied" || e.CommandName == "Archive" || e.CommandName == "Adopt")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                        DisplayMessage(false, "Select an Articulation.");
                    }
                    else
                    {
                        foreach (GridDataItem item in grid.SelectedItems)
                        {
                            articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                            if (e.CommandName == "Denied")
                            {
                                if (item["ArticulationStatus"].Text != "2")
                                {
                                    try
                                    {
                                        norco_db.DontArticulate(Convert.ToInt32(item["ArticulationID"].Text), Convert.ToInt32(item["articulation_type"].Text), Convert.ToInt32(hfUserID.Value));
                                    }
                                    catch (Exception ex)
                                    {
                                        DisplayMessage(true, ex.ToString());
                                    }
                                }
                            }
                        }
                        Session["articulationList"] = articulations;
                        switch (e.CommandName)
                        {
                            case "MoveForward":
                                NotifyPopup("MoveForward", hvUserStage.Value, hvUserName.Value, hfUserID.Value, hvCollegeID.Value, 800, 600);
                                break;
                            case "Return":
                                NotifyPopup("Return", hvUserStage.Value, hvUserName.Value, hfUserID.Value, hvCollegeID.Value, 800, 600);
                                break;
                            //case "Denied":
                            //    NotifyPopup("Denied", user_stage_id, user_name, user_id, college_id, 800, 600);
                            //    break;
                            case "Archive":
                                NotifyPopup("Archive", hvUserStage.Value, hvUserName.Value, hfUserID.Value, hvCollegeID.Value, 800, 600);
                                break;
                            case "Adopt":
                                ConfirmAdopt(string.Join(", ", articulations.Select(art => art.Key)), user_id, college_id, 800, 600);
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }
        }

        protected void rgFacultyReviewArticulations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            lblMessages.InnerHtml = "<i class='fa fa-exclamation - triangle' aria-hidden='true'></i> ";
            lblMessages.InnerHtml = string.Concat(lblMessages.InnerHtml, string.Format("Note: the disabled (grey out) articulations require no action because they are either notifications only or you already took action", hfActionTaken.Value));
            var is_disable = false;

           
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridDataItem && grid.ID == "rgFacultyReviewArticulations")
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var articulation_stage = dataBoundItem["ArticulationStage"].Text;
                var course_exist = dataBoundItem["CourseExists"].Text;
                var articulation_exist = dataBoundItem["ArticulationExists"].Text;
                HyperLink hp = (HyperLink)dataBoundItem.FindControl("hlExhibit");
                HyperLink hpAceID = (HyperLink)dataBoundItem.FindControl("hlAceIDExhibit");
                hp.NavigateUrl = $"javascript:showExhibit('{dataBoundItem["EntityType"].Text}','{dataBoundItem["AceID"].Text}','{dataBoundItem["TeamRevd"].Text}','{dataBoundItem["SelectedCriteria"].Text}','{dataBoundItem["StartDate"].Text}','{dataBoundItem["EndDate"].Text}','{dataBoundItem["Title"].Text}')";
                hp.Text = dataBoundItem["Title"].Text;
                hpAceID.NavigateUrl = $"javascript:showExhibit('{dataBoundItem["EntityType"].Text}','{dataBoundItem["AceID"].Text}','{dataBoundItem["TeamRevd"].Text}','{dataBoundItem["SelectedCriteria"].Text}','{dataBoundItem["StartDate"].Text}','{dataBoundItem["EndDate"].Text}','{dataBoundItem["Title"].Text}')";
                hpAceID.Text = dataBoundItem["AceID"].Text;

                if (hvCollegeID.Value != hvFromUserCollegeID.Value)
                {
                    if (course_exist == "False" || articulation_exist == "True")
                    {
                        CheckBox chkbx = (CheckBox)dataBoundItem["ClientSelectColumn"].Controls[0];
                        chkbx.Enabled = false;
                        dataBoundItem.SelectableMode = GridItemSelectableMode.None;
                        dataBoundItem.ToolTip = "This course either does not exist in your college or the articulation has been already created.";
                        lblMessages.Style.Add("display", "block");
                        is_disable = true;
                    }
                }
                else
                {
                    if (hvUserStage.Value != articulation_stage)
                    {
                        CheckBox chkbx = (CheckBox)dataBoundItem["ClientSelectColumn"].Controls[0];
                        chkbx.Enabled = false;
                        dataBoundItem.SelectableMode = GridItemSelectableMode.None;
                        dataBoundItem.ToolTip = "You have already processed this articulation.";
                        lblMessages.Style.Add("display", "block");
                        is_disable = true;
                    }
                    else
                    {
                        if (hvCriteriaPackageID.Value != "0")
                        {
                            CheckBox chkbx = (CheckBox)dataBoundItem["ClientSelectColumn"].Controls[0];
                            dataBoundItem.Selected = true;
                            //chkbx.Enabled = false;
                            chkbx.Checked = true;
                        }
                    }
                }
                if (is_disable == true)
                {
                    hvDisabledArticulationsCount.Value = (Convert.ToInt32(hvDisabledArticulationsCount.Value) + 1).ToString();
                }
            }
            if (e.Item is GridCommandItem && grid.ID == "rgFacultyReviewArticulations")
            {
                GridCommandItem cmditem = (GridCommandItem)e.Item;
                RadButton adopt_button = (RadButton)cmditem.FindControl("btnAdopt");
                RadButton approve_button = (RadButton)cmditem.FindControl("btnMoveForward");
                RadButton deny_button = (RadButton)cmditem.FindControl("btnDenied");
                RadButton return_button = (RadButton)cmditem.FindControl("btnReturn");
                RadButton archive_button = (RadButton)cmditem.FindControl("btnArchive");

                string Action = Decrypt(Request["Action"]);
                if (Action == "View") {
                    approve_button.Visible = false;
                    deny_button.Visible = false;
                    return_button.Visible = false;
                }
                

                if (hvUserStage.Value == hvFirstStage.Value)
                {
                    return_button.Visible = false;
                    deny_button.Visible = false;
                }
                if (hvUserStage.Value == hvLastStage.Value)
                {
                    approve_button.Visible = false;
                }
                adopt_button.Visible = false;
                if (hvCollegeID.Value != hvFromUserCollegeID.Value)
                {
                    adopt_button.Visible = true;
                    return_button.Visible = false;
                    deny_button.Visible = false;
                    approve_button.Visible = false;
                    archive_button.Visible = false;
                }
                if (hvCriteriaPackageID.Value != "0")
                {
                    adopt_button.Visible = false;
                }
            }
        }
        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }
        public void NotifyPopup(string action, string user_stage_id, string user_name, string user_id, string college_id, int width, int height)
        {
            var url = String.Format("/modules/popups/Notify.aspx?Action={0}&UserStageID={1}&UserName={2}&UserID={3}&CollegeID={4}&Notes={5}", action, user_stage_id, user_name, user_id, college_id, rtbNotes.Text);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        public void ConfirmDeny(string articulation_list, int width, int height)
        {
            var url = String.Format("/modules/popups/ConfirmDenyArticulation.aspx?ArticulationList={0}", articulation_list, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        public void ConfirmAdopt(string articulation_list, int user_id, int college_id, int width, int height)
        {
            var url = String.Format("/modules/popups/ConfirmAdoptArticulation.aspx?ArticulationList={0}&UserID={1}&CollegeID={2}", articulation_list, user_id, college_id, width, height);
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, true, false, width, height));
        }

        public void showArticulation(int id, int articulation_type, int outline_id, string AceID, string Title, DateTime TeamRevd, bool isReadOnly, int otherCollegeID, bool adoptArticulation, string collegeName, string modalWindow, int width, int height, int ExhibitID)
        {
            var urlPage = "/modules/popups/AssignOccupationArticulation.aspx";
            var readOnlyParameter = "";
            if (isReadOnly)
            {
                readOnlyParameter = "&isReadOnly=true";
            }
            if (modalWindow.Equals("NewTab"))
            {
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("{0}?articulationID={1}&outline_id={2}&AceID={3}&Title={4}&TeamRevd={5}&NewWindow=true{6}&OtherCollegeID={7}&AdoptArticulation={8}&CollegeName={9}", urlPage, id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), readOnlyParameter, otherCollegeID.ToString(), adoptArticulation.ToString(), collegeName.ToString()) + "');", true);
            }
            else
            if (modalWindow.Equals("Popup"))
            {
                var url = String.Format("{0}?articulationID={1}&outline_id={2}&AceID={3}&Title={4}&TeamRevd={5}&NewWindow=true{6}&OtherCollegeID={7}&AdoptArticulation={8}&CollegeName={9}", urlPage, id.ToString(), outline_id.ToString(), AceID, Title, TeamRevd.ToString(), readOnlyParameter, otherCollegeID.ToString(), adoptArticulation.ToString(), collegeName.ToString());
                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, width, height));
            }
        }
        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;
            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);
            var user_stage_id = Convert.ToInt32(hvUserStage.Value);
            var user_name = hvUserName.Value;
            var user_id = Convert.ToInt32(hfUserID.Value);
            var college_id = Convert.ToInt32(hvCollegeID.Value);
            var id = Convert.ToInt32(hvID.Value);
            var outline_id = Convert.ToInt32(hvOutlineID.Value);
            var team_revd = Convert.ToDateTime(hvTeamRevd.Value);
            var articulation_type = Convert.ToInt32(hvArticulationType.Value);
            var exhibit_id = Convert.ToInt32(hvExhibitID.Value);
            foreach (GridDataItem item in rgFacultyReviewArticulations.SelectedItems)
            {
                articulations.Add(Convert.ToInt32(item["id"].Text), 0);
            }
            Session["articulationList"] = articulations;
            try
            {
                switch (e.Item.Text)
                {
                    case "Edit":
                        showArticulation(id, articulation_type, outline_id, hvAceID.Value, hvTitle.Value, team_revd, false, 0, false, "", "NewTab", 0, 0, exhibit_id);
                        break;
                    case "View":
                        showArticulation(id, articulation_type, outline_id, hvAceID.Value, hvTitle.Value, team_revd, true, 0, false, "", "NewTab", 0, 0, exhibit_id);
                        break;
                    case "Adopt":
                        ConfirmAdopt(string.Join(", ", articulations.Select(art => art.Key)), user_id, college_id, 800, 600);
                        break;
                    default:
                        //articulations.Add(id,0);
                        NotifyPopup(e.Item.Value, user_stage_id.ToString(), user_name, user_id.ToString(), college_id.ToString(), 800, 600);
                        break;
                }
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.ToString());
            }
        }

        protected void rgFacultyReviewArticulations_PreRender(object sender, EventArgs e)
        {
            hvDisabledArticulationsCount.Value = "0";
            rgFacultyReviewArticulations.MasterTableView.GetColumn("ArticulationCollege").Visible = false;
            rgFacultyReviewArticulations.MasterTableView.GetColumn("course_title").Visible = true;
            if (hvCollegeID.Value != hvFromUserCollegeID.Value)
            {
                rgFacultyReviewArticulations.MasterTableView.GetColumn("ArticulationCollege").Visible = true;
                rgFacultyReviewArticulations.MasterTableView.GetColumn("course_title").Visible = false;
            }
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, Telerik.Web.UI.AjaxRequestEventArgs e)
        {
            rgFacultyReviewArticulations.DataBind();
        }

        protected void rbClose_Click(object sender, EventArgs e)
        {
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Close", "window.close()", true);
        }

        private string Decrypt(string cipherText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            cipherText = cipherText.Replace(" ", "+");
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }

        protected void rbAction_Click(object sender, EventArgs e)
        {
            if (rgFacultyReviewArticulations.SelectedItems.Count <= 0)
            {
                DisplayMessage(false, "Select an Articulation.");
            }
            else
            {
                foreach (GridDataItem item in rgFacultyReviewArticulations.SelectedItems)
                {
                    if (Decrypt(Request["Action"]) == "Deny")
                    {
                        if (item["ArticulationStatus"].Text != "2")
                        {
                            articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                        }
                    } else
                    {
                        articulations.Add(Convert.ToInt32(item["id"].Text), 0);
                    }
                }
                Session["articulationList"] = articulations;
                switch (Decrypt(Request["Action"]))
                {
                    case "Approve":
                        NotifyPopup("MoveForward", hvUserStage.Value, hvUserName.Value, hfUserID.Value, hvCollegeID.Value, 800, 600);
                        break;
                    case "Return":
                        NotifyPopup("Return", hvUserStage.Value, hvUserName.Value, hfUserID.Value, hvCollegeID.Value, 800, 600);
                        break;
                    case "Deny":
                        ConfirmDeny(string.Join(", ", articulations.Select(art => art.Key)), 800, 600);
                        break;
                    default:
                        break;
                }
            }
        }
    }
}