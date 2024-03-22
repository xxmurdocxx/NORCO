using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Reporting;
using Telerik.Web.UI;

namespace ems_app.modules.security
{
    public partial class Users : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlSubjects.Visible = false;
                rcbSubjectsFilter.DataBind();
                hvFilterByFacultySubject.Value = "0";
                Session["ApplicationID"] = GlobalUtil.ReadSetting("AppID");
                //tbUserID.Style.Add("display", "none");
                setNewUser();
                foreach (RadComboBoxItem itm in rcbSubjectsFilter.Items)
                {
                    itm.Checked = true;
                }
                hvSelectedSubjects.Value = SetSelectedIndexChange("rcbSubjectsFilter").ToString();
                sqlUsers.DataBind();
                rgUsers.DataBind();
                toggleUserRoles(Convert.ToInt32(Session["UserID"]));


                if (Session["CollegeID"].ToString() != "1" )
                {
                    rchkSuperUser.Visible = false;
                    rchkDistrictAdministrator.Visible = false;
                } else
                {
                    if ((bool)Session["SuperUser"])
                    {
                        rchkSuperUser.Visible = true;
                        rchkDistrictAdministrator.Visible = true;
                    }
                    if ((bool)Session["DistrictAdministrator"])
                    {
                        rchkDistrictAdministrator.Visible = true;
                    }
                }
            }
        }

        public void ClearInputs()
        {
            rtFirstName.Text = "";
            rtLastName.Text = "";
            rtPassword.Text = "";
            rtUserName.Text = "";
            rtbEmail.Text = "";
            rchkAutomaticNotification.Checked = false;
            rchkWelcome.Checked = false;
            rchkSuperUser.Checked = false;
            rchkDistrictAdministrator.Checked = false;
            rchkActive.Checked = false;
        }
        protected void rgUsers_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {

            if (e.CommandName == "RowClick")
            {
                GridDataItem item = (GridDataItem)rgUsers.MasterTableView.Items[rgUsers.SelectedItems[0].ItemIndex];
                Int32 userID = Convert.ToInt32(item["UserID"].Text);
                var userData = norco_db.GetUserDataByID(userID);
                bool isFaculty = false;
                foreach (GetUserDataByIDResult p in userData)
                {
                    //tbUserID.Text = p.UserID.ToString();
                    rtFirstName.Text = p.FirstName;
                    rtLastName.Text = p.LastName;
                    rtUserName.Text = p.UserName;
                    rtbEmail.Text = p.Email;
                    rtPassword.TextMode = InputMode.SingleLine;
                    rtPassword.Text = GlobalUtil.Decrypt(p.Password);
                    rcbRoles.SelectedValue = p.RoleID.ToString();
                    isFaculty = Convert.ToBoolean(p.ReviewArticulations);
                    rchkAutomaticNotification.Checked = p.AutomaticNotify;
                    rchkWelcome.Checked = p.Welcome;
                    rchkSuperUser.Checked = p.SuperUser;
                    rchkDistrictAdministrator.Checked = p.DistrictAdministrator;
                    rchkActive.Visible = true;
                    rchkActive.Checked = GetActive(p.UserID);
                }
                pnlUserSubjects.Visible = false;
                if (isFaculty)
                {
                    pnlUserSubjects.Visible = true;
                }
                rbUpdate.Visible = true;
                rbSave.Visible = false;
                hfUserID.Value = userID.ToString() ;
                sqlUserSubjects.DataBind();

                toggleUserRoles(userID);
                lblUserMessage.Text = string.Empty;
                lblUserMessage.CssClass = string.Empty;
            }
        }

        protected void rbUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                var updUser = norco_db.UpdateUser(rtUserName.Text, GlobalUtil.Encrypt(rtPassword.Text), rtFirstName.Text, rtLastName.Text, rtbEmail.Text,  Convert.ToInt32(rcbRoles.SelectedValue), Convert.ToInt32(hfUserID.Value), rchkAutomaticNotification.Checked, rchkWelcome.Checked, rchkSuperUser.Checked, rchkDistrictAdministrator.Checked);
                if (updUser == 0)
                {
                    SetActiveUser(Convert.ToInt32(hfUserID.Value),(bool)rchkActive.Checked);
                    lblUserMessage.CssClass = "alert alert-success";
                    lblUserMessage.Text = Resources.Messages.UserUpdated;
                }
                else
                {
                    lblUserMessage.CssClass = "alert-warning";
                    lblUserMessage.Text = Resources.Messages.UserExist;
                }
                rgUserRoles.DataBind();
                rgUsers.DataBind();
            } 
            catch (Exception ex)
            {
                lblUserMessage.CssClass = "alert alert-warning";
                lblUserMessage.Text = "Error Message: " + ex.Message;
            }
        }

        protected void rbSave_Click(object sender, EventArgs e)
        {

            try
            {
                if (Session["CollegeID"] == null)
                {
                    lblUserMessage.CssClass = "alert alert-warning";
                    lblUserMessage.Text = "There was a problem creating a new user. Please log out of MAP and back in before trying again.";
                }
                else if (Convert.ToInt32(Session["CollegeID"]) == 0)
                {
                    lblUserMessage.CssClass = "alert alert-warning";
                    lblUserMessage.Text = "There was a problem creating a new user. Please log out of MAP and back in before trying again.";
                } 
                else
                {
                    var insertUser = norco_db.InsertUser(rtUserName.Text, GlobalUtil.Encrypt(rtPassword.Text), rtFirstName.Text, rtLastName.Text, rtbEmail.Text, Convert.ToInt32(rcbRoles.SelectedValue), Convert.ToInt32(Session["CollegeID"]), rchkAutomaticNotification.Checked, rchkWelcome.Checked, rchkSuperUser.Checked, rchkDistrictAdministrator.Checked);
                    if (insertUser > 0)
                    {
                        lblUserMessage.CssClass = "alert alert-success";
                        lblUserMessage.Text = Resources.Messages.UserInserted;

                        ClearInputs();
                        rgUsers.DataBind();
                    }
                    else
                    {
                        lblUserMessage.CssClass = "alert alert-warning";
                        lblUserMessage.Text = Resources.Messages.UserExist;
                    }
                }
                             
            }
            catch (Exception ex)
            {
                lblUserMessage.CssClass = "alert alert-warning";
                lblUserMessage.Text = "Error Message: " + ex.Message;
            }

        }

        protected void rbNewUser_Click(object sender, EventArgs e)
        {
            setNewUser();
        }

        public void setNewUser()
        {
            ClearInputs();
            rcbRoles.DataBind();
            rcbRoles.Focus();
            rbUpdate.Visible = false;
            rbSave.Visible = true;
            pnlUserSubjects.Visible = false;
            pnlUserRoles.Visible = false;
            rchkActive.Visible = false;
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

        public String SetSelectedIndexChange(string controlID)
        {
            RadComboBox listBox = (RadComboBox)FindControlRecursive(Page, controlID);
            int itemschecked = listBox.CheckedItems.Count;
            String[] DataFieldsArray = new String[itemschecked];
            var collection = listBox.CheckedItems;
            int i = 0;
            foreach (var item in collection)
            {
                String value = item.Value;
                DataFieldsArray[i] = value;
                i++;
            }
            return String.Join(",", DataFieldsArray);
        }

        protected void rcbFilterBySubject_CheckedChanged(object sender, EventArgs e)
        {
            pnlSubjects.Visible = false;
            hvFilterByFacultySubject.Value = "0";
            if (rcbFilterBySubject.Checked == true)
            {
                pnlSubjects.Visible = true;
                hvFilterByFacultySubject.Value = "1";
                hvSelectedSubjects.Value = SetSelectedIndexChange("rcbSubjectsFilter").ToString();
            }
            sqlUsers.DataBind();
            rgUsers.DataBind();
        }

        protected void rcbSubjectsFilter_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            hvSelectedSubjects.Value = SetSelectedIndexChange("rcbSubjectsFilter").ToString();
            sqlUsers.DataBind();
            rgUsers.DataBind();
        }

        private void toggleUserRoles(int userID)
        {
            pnlUserRoles.Visible = false;
            if (hfUserID.Value != "")
            {
                if (GlobalUtil.CheckMultipleRoleIsFaculty(userID)==1)
                {
                    pnlUserSubjects.Visible = true;
                }
                pnlUserRoles.Visible = true;
            }
        }

        protected void rgUsers_PreRender(object sender, EventArgs e)
        {
            if (rgUsers.IsExporting)
            {
                foreach (GridFilteringItem item in rgUsers.MasterTableView.GetItems(GridItemType.FilteringItem))
                {
                    item.Visible = false;
                }
            }
        }

        public static bool GetActive(int user_id)
        {
            bool exists = false;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"select Active from tblUsers where UserID = {user_id};";
                    exists = ((bool)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return exists;
        }

        private void SetActiveUser(int user_id, bool active)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                const string statement = "UPDATE [dbo].[tblUsers] SET [Active] = @Active WHERE UserID = @UserID";

                using (var cmd = new SqlCommand() { Connection = connection, CommandText = statement })
                {
                    cmd.Parameters.AddWithValue("@Active", active);
                    cmd.Parameters.AddWithValue("@UserID", user_id);

                    try
                    {
                        connection.Open();
                        int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());

                    }
                    catch (Exception ex)
                    {
                        throw;
                    }
                }
            }
        }

        protected void rsShowDisbled_CheckedChanged(object sender, EventArgs e)
        {
            if (rsShowDisbled.Checked == true)
            {
                hvShowDisabled.Value = rsShowDisbled.ToggleStates.ToggleStateOn.Value;
            }
            else
            {
                hvShowDisabled.Value = rsShowDisbled.ToggleStates.ToggleStateOff.Value;
            }
            rgUsers.DataBind();
        }

        protected void sqlUserRoles_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.Exception == null && e.AffectedRows > 0)
            {
                int id = (int)e.Command.Parameters["@InsertedID"].Value;
                pnlUserSubjects.Visible = false;
                if (GetRoleName(id) == "Faculty")
                {
                    pnlUserSubjects.Visible = true;
                }
                rgUserSubjects.DataBind();
            }
        }

        public static string GetRoleName(int role_user_id)
        {
            string result = string.Empty;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                SqlCommand cmd = connection.CreateCommand();
                connection.Open();
                try
                {
                    cmd.CommandText = $"SELECT r.RoleName FROM ROLES_USER ru JOIN ROLES R ON ru.RoleID = R.RoleID WHERE RoleUserID = {role_user_id};";
                    result = ((string)cmd.ExecuteScalar());
                }
                finally
                {
                    connection.Close();
                }
            }
            return result;
        }

    }
}