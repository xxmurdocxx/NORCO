using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.IO;

namespace ems_app.UserControls
{
    public partial class ExhibitInformation : System.Web.UI.UserControl
    {
        private int _exhibit_id = 0;

        public int ExhibitID
        {
            get {
                if (ViewState["ExhibitID"] != null)
                { _exhibit_id = Int32.Parse(ViewState["ExhibitID"].ToString()); };
                return _exhibit_id;
            }
            set { ViewState["ExhibitID"] = value; }
        }
        public bool IsReadOnly
        {
            get { return ViewState["IsReadOnly"] as bool? ?? false; }
            set { ViewState["IsReadOnly"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlHighlightedCurrentVersion.SelectParameters["ExhibitID"].DefaultValue = ExhibitID.ToString();
                sqlRubricItems.SelectParameters["ExhibitID"].DefaultValue = ExhibitID.ToString();
                sqlCPLEvidenceCompetency.SelectParameters["ExhibitID"].DefaultValue = ExhibitID.ToString();
                sqlCreditRecommendations.SelectParameters["ExhibitID"].DefaultValue = ExhibitID.ToString();
                sqlDocuments.SelectParameters["ExhibitID"].DefaultValue = ExhibitID.ToString();
                if (IsReadOnly)
                {
                    rgRubricItems.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                    rgRubricItems.MasterTableView.GetColumn("DeleteColumn").Display = false;
                    rgRubricItems.MasterTableView.EditMode = GridEditMode.InPlace;
                    rgEvidenceCompetency.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                    rgEvidenceCompetency.MasterTableView.GetColumn("DeleteColumn").Display = false;
                    rgEvidenceCompetency.MasterTableView.EditMode = GridEditMode.InPlace;
                    rgCreditRecommendations.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                    rgCreditRecommendations.MasterTableView.GetColumn("DeleteColumn").Display = false;
                    rgCreditRecommendations.MasterTableView.EditMode = GridEditMode.InPlace;
                    rgCreditRecommendations.MasterTableView.GetColumn("Notes").ItemStyle.BackColor = System.Drawing.Color.White;
                    rgCPLExhibitDocs.MasterTableView.CommandItemDisplay = GridCommandItemDisplay.None;
                    rgCPLExhibitDocs.MasterTableView.GetColumn("DeleteColumn").Display = false;
                    rgCPLExhibitDocs.MasterTableView.EditMode = GridEditMode.InPlace;
                    divUpload.Visible = false;
                }
            }
        }
        protected void rgRubricItems_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                TextBox txt = (TextBox)item["Rubric"].Controls[0];
                txt.Width = Unit.Pixel(500);
                txt.BackColor = System.Drawing.Color.LightYellow;
                RadNumericTextBox score = (RadNumericTextBox)item["ScoreRange"].Controls[0];
                score.Width = Unit.Pixel(100);
                score.BackColor = System.Drawing.Color.LightYellow;
                RadNumericTextBox minScore = (RadNumericTextBox)item["MinScore"].Controls[0];
                minScore.Width = Unit.Pixel(100);
                minScore.BackColor = System.Drawing.Color.LightYellow;
            }
        }
        protected void rgEvidenceCompetency_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                TextBox txt = (TextBox)item["Notes"].Controls[0];
                txt.Width = Unit.Pixel(500);
                txt.Attributes.Add("placeholder", "Add notes here");
                txt.BackColor = System.Drawing.Color.LightYellow;
                RadComboBox combo = (RadComboBox)item["ExhibitEvidenceID"].Controls[0];
                combo.Width = Unit.Pixel(525);
                combo.BackColor = System.Drawing.Color.LightYellow;
                CheckBox check = (CheckBox)item["ActiveCurrent"].Controls[0];
                check.LabelAttributes.Add("background-color", "yellow");
                check.BackColor = System.Drawing.Color.LightYellow;
            }
        }
        public static int DeleteCreditRecommendation(string criteria_id)
        {
            int id = 0;

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("DeleteCPLCreditRecommendation", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@CriteriaID", criteria_id));
                    var outParm = new SqlParameter("@ID", SqlDbType.Int);
                    outParm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParm);

                    cmd.ExecuteNonQuery();

                    id = Convert.ToInt32(outParm.Value);
                }
                return id;
            }
        }
        protected void rgCreditRecommendations_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                RadEditor txt = (RadEditor)item["Notes"].Controls[0];
                txt.Width = Unit.Pixel(500);
                txt.BackColor = System.Drawing.Color.LightYellow;
                txt.Attributes.Add("placeholder", "Enter any detail that might be used for this credit recommendation");
                TextBox criteria = (TextBox)item["Criteria"].Controls[0];
                criteria.Width = Unit.Pixel(500);
                criteria.BackColor = System.Drawing.Color.LightYellow;
            }
        }
        protected void rgCreditRecommendations_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem viewItem = e.Item as GridDataItem;
            if (e.CommandName == "Delete")
            {
                var id = viewItem["CriteriaID"].Text;
                var result = DeleteCreditRecommendation(id);
                if (result == 0)
                {
                    rnLiteral.Text = "There are articulations related to this Credit Recommendation.";
                }
                else
                {
                    rnLiteral.Text = $"Credit Recommendation successfully deleted.";
                }
                rnMessage.Show();
            }
            if (e.CommandName == "StudentIntake")
            {
                Session["SelectedCreditRecommendation"] = viewItem["Criteria"].Text;
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('" + String.Format("../military/StudentList.aspx") + "');", true);
            }
        }

        protected void rgCPLExhibitDocs_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem viewItem = e.Item as GridDataItem;
            if (e.CommandName == "Delete")
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM [CPLExhibitDocuments] WHERE id = @id", conn);
                    conn.Open();
                    cmd.Parameters.AddWithValue("@id", viewItem["id"].Text);
                    try
                    {
                        if (conn.State == ConnectionState.Open)
                        {
                            conn.Close();
                        }
                        conn.Open();
                        cmd.ExecuteScalar();
                        rgCPLExhibitDocs.DataBind();
                        RadWindowManager1.RadAlert("Document deleted", 330, 180, "Delete document", null);
                    }
                    catch (Exception ex)
                    {
                        RadWindowManager1.RadAlert(ex.Message, 330, 180, "Alert", null);
                        Console.WriteLine(ex.Message);
                    }
                    conn.Close();
                }
            }
            if (e.CommandName == "Download")
            {
                var id = viewItem["id"].Text;
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", $"window.open('/modules/popups/ConfirmDownloadExhibit.aspx?ID={id}');", true);
            }
        }
        protected void btnComplete_Click(object sender, EventArgs e)
        {
            try
            {
                if (AsyncUpload1.UploadedFiles.Count > 0)
                {
                    foreach (UploadedFile uploadedFile in AsyncUpload1.UploadedFiles)
                    {
                        using (Stream stream = uploadedFile.InputStream)
                        {
                            byte[] fileBytes = new byte[stream.Length];
                            stream.Read(fileBytes, 0, Convert.ToInt32(stream.Length));

                            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
                            {
                                SqlCommand cmd = new SqlCommand("INSERT INTO [CPLExhibitDocuments] ([FileName], [FileDescription],  [BinaryData], [CPLExhibitID], [CreatedBy]) VALUES (@FileName, @FileDescription, @BinaryData, @CPLExhibitID, @UserID)", conn);
                                conn.Open();
                                cmd.Parameters.AddWithValue("@FileName", uploadedFile.FileName.Replace(",", "_").Replace(";", "_"));
                                cmd.Parameters.AddWithValue("@FileDescription", uploadedFile.FileName.Replace(",", "_").Replace(";", "_"));
                                cmd.Parameters.Add("@BinaryData", SqlDbType.VarBinary, fileBytes.Length).Value = fileBytes;
                                cmd.Parameters.AddWithValue("@CPLExhibitID", ExhibitID);
                                cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                                try
                                {
                                    if (conn.State == ConnectionState.Open)
                                    {
                                        conn.Close();
                                    }
                                    conn.Open();
                                    int NewIdentifier = Convert.ToInt32(cmd.ExecuteScalar());
                                    rgCPLExhibitDocs.DataBind();
                                    RadWindowManager1.RadAlert("Upload completed", 330, 180, "Upload document", null);
                                }
                                catch (Exception ex)
                                {
                                    RadWindowManager1.RadAlert(ex.Message, 330, 180, "Alert", null);
                                    Console.WriteLine(ex.Message);
                                }
                                conn.Close();
                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

    }
}