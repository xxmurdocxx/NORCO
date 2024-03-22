using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class UploadVeterans : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rcbCampaigns.DataBind();
                rcbCampaigns.SelectedValue = Request["CampaignId"];
            }
        }

        protected void btnImport_Click(object sender, EventArgs e)
        {
            if (rauUploadFile.UploadedFiles.Count > 0)
            {
                try
                {
                    String csvPath = "";
                    foreach (UploadedFile file in rauUploadFile.UploadedFiles)
                    {
                        csvPath = Server.MapPath("~/UploadedFiles/") + file.GetName(); ;
                        file.SaveAs(csvPath);
                    }
                    DataTable dt = new DataTable();
                    dt.Columns.AddRange(new DataColumn[] {
                new DataColumn("FirstName", typeof(string)),
                new DataColumn("MiddleName", typeof(string)),
                new DataColumn("LastName", typeof(string)),
                new DataColumn("BirthDate", typeof(DateTime)),
                new DataColumn("TermDate", typeof(DateTime)),
                new DataColumn("Email", typeof(string)),
                new DataColumn("Email1", typeof(string)),
                new DataColumn("Email2", typeof(string)),
                new DataColumn("OfficePhone", typeof(string)),
                new DataColumn("MobilePhone", typeof(string)),
                new DataColumn("HomePhone", typeof(string)),
                new DataColumn("SalutationID", typeof(int)),
                new DataColumn("StatusID", typeof(int)),
                new DataColumn("ServiceID", typeof(int)),
                new DataColumn("StreetAddress", typeof(string)),
                new DataColumn("City", typeof(string)),
                new DataColumn("State", typeof(string)),
                new DataColumn("ZipCode", typeof(string)),
                new DataColumn("Occupation", typeof(string))
                });
                    //Read the contents of CSV file.  
                    string csvData = File.ReadAllText(csvPath);
                    int r = 0;
                    //Execute a loop over the rows.  
                    foreach (string row in csvData.Split('\n'))
                    {
                        if (!string.IsNullOrEmpty(row) && r > 0)
                        {
                            dt.Rows.Add();
                            int i = 0;
                            //Execute a loop over the columns.  
                            foreach (string cell in row.Split(','))
                            {
                                dt.Rows[dt.Rows.Count - 1][i] = (cell == "NULL") ? "" : cell;
                                i++;
                            }
                        }
                        r++;
                    }
                    //Bind the DataTable.  
                    rgVeterans.DataSource = dt;
                    rgVeterans.DataBind();
                }
                catch (Exception ex)
                {
                    DisplayMessage(true, ex.Message.ToString());
                }

            } else
            {
                DisplayMessage(true, Resources.Messages.EmptyFile);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string FirstName, MiddleName, LastName, Email, Email1, Email2, OfficePhone, MobilePhone, HomePhone, StreetAddress, City, State, ZipCode, Occupation;
            DateTime? BirthDate, TermDate, CreatedOn;
            int SalutationID, StatusID, ServiceID, CampaignId, CreatedBy, CollegeID, LeadStatusId;
            CampaignId = Convert.ToInt32(rcbCampaigns.SelectedValue);
            CreatedBy = Convert.ToInt32(Session["UserID"]);
            CreatedOn = DateTime.Now;
            CollegeID = Convert.ToInt32(Session["CollegeID"]);
            LeadStatusId = Convert.ToInt32(GlobalUtil.ReadSetting("DefaultLeadStatusId"));
            if (rcbCampaigns.SelectedValue != "")
            {
                if (rgVeterans.MasterTableView.Items.Count > 0)
                {
                    try
                    {
                        foreach (GridDataItem item in rgVeterans.Items)
                        {
                            FirstName = (item["FirstName"].Text == "&nbsp;") ? "" : item["FirstName"].Text;
                            MiddleName = (item["MiddleName"].Text == "&nbsp;") ? "" : item["MiddleName"].Text;
                            LastName = (item["LastName"].Text == "&nbsp;") ? "" : item["LastName"].Text;
                            if (item["BirthDate"].Text == "&nbsp;")
                            {
                                BirthDate = null;
                            }
                            else
                            {
                                BirthDate = Convert.ToDateTime(item["BirthDate"].Text);
                            }
                            if (item["TermDate"].Text == "&nbsp;")
                            {
                                TermDate = null;
                            }
                            else
                            {
                                TermDate = Convert.ToDateTime(item["TermDate"].Text);
                            }
                            Email = (item["Email"].Text == "&nbsp;") ? "" : item["Email"].Text;
                            Email1 = (item["Email1"].Text == "&nbsp;") ? "" : item["Email1"].Text;
                            Email2 = (item["Email2"].Text == "&nbsp;") ? "" : item["Email2"].Text;
                            OfficePhone = (item["OfficePhone"].Text == "&nbsp;") ? "" : item["OfficePhone"].Text;
                            MobilePhone = (item["MobilePhone"].Text == "&nbsp;") ? "" : item["MobilePhone"].Text;
                            HomePhone = (item["HomePhone"].Text == "&nbsp;") ? "" : item["HomePhone"].Text;
                            SalutationID = (item["SalutationID"].Text == "&nbsp;") ? 0 : Convert.ToInt32(item["SalutationID"].Text);
                            StatusID = (item["StatusID"].Text == "&nbsp;") ? 0 : Convert.ToInt32(item["StatusID"].Text);
                            ServiceID = (item["ServiceID"].Text == "&nbsp;") ? 0 : Convert.ToInt32(item["ServiceID"].Text);
                            StreetAddress = (item["StreetAddress"].Text == "&nbsp;") ? "" : item["StreetAddress"].Text;
                            City = (item["City"].Text == "&nbsp;") ? "" : item["City"].Text;
                            State = (item["State"].Text == "&nbsp;") ? "" : item["State"].Text;
                            ZipCode = (item["ZipCode"].Text == "&nbsp;") ? "" : item["ZipCode"].Text;
                            Occupation = (item["Occupation"].Text == "&nbsp;") ? "" : item["Occupation"].Text;

                            norco_db.AddCampaignVeteran(CampaignId, FirstName, MiddleName, LastName, BirthDate, TermDate, Email, Email1, Email2, OfficePhone, MobilePhone, HomePhone, SalutationID, StatusID, ServiceID, StreetAddress, City, State, ZipCode, Occupation, CreatedBy, CreatedOn, CollegeID, LeadStatusId);
                        }
                        DisplayMessage(true, Resources.Messages.VeteransUploaded);
                    }
                    catch (Exception ex)
                    {
                        DisplayMessage(true, ex.Message.ToString());
                    }
                }
                else
                {
                    DisplayMessage(true, Resources.Messages.EmptyFile);
                }
            } else
            {
                DisplayMessage(true, "Please select a campaign.");
            }

        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rbXml_Click(object sender, EventArgs e)
        {
            if (rauUploadFile.UploadedFiles.Count > 0)
            {
                try
                {
                    String csvPath = "";
                    foreach (UploadedFile file in rauUploadFile.UploadedFiles)
                    {
                        csvPath = Server.MapPath("~/UploadedFiles/") + file.GetName(); ;
                        file.SaveAs(csvPath);
                    }
                    DataTable dt = new DataTable();
                    dt.Columns.AddRange(new DataColumn[] {
                new DataColumn("FirstName", typeof(string)),
                new DataColumn("MiddleName", typeof(string)),
                new DataColumn("LastName", typeof(string)),
                new DataColumn("BirthDate", typeof(DateTime)),
                new DataColumn("TermDate", typeof(DateTime)),
                new DataColumn("Email", typeof(string)),
                new DataColumn("Email1", typeof(string)),
                new DataColumn("Email2", typeof(string)),
                new DataColumn("OfficePhone", typeof(string)),
                new DataColumn("MobilePhone", typeof(string)),
                new DataColumn("HomePhone", typeof(string)),
                new DataColumn("SalutationID", typeof(int)),
                new DataColumn("StatusID", typeof(int)),
                new DataColumn("ServiceID", typeof(int)),
                new DataColumn("StreetAddress", typeof(string)),
                new DataColumn("City", typeof(string)),
                new DataColumn("State", typeof(string)),
                new DataColumn("ZipCode", typeof(string)),
                new DataColumn("Occupation", typeof(string))
                });
                    dt.ReadXml(csvPath);
                    //Bind the DataTable.  
                    rgVeterans.DataSource = dt;
                    rgVeterans.DataBind();
                }
                catch (Exception ex)
                {
                    DisplayMessage(true, ex.Message.ToString());
                }

            }
            else
            {
                DisplayMessage(true, Resources.Messages.EmptyFile);
            }
        }
    }
}