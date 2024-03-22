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

namespace ems_app.modules.popups
{
    public partial class ShowCreditRecomendation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfVeteranID.Value = Request["VeteranID"].ToString();
                hfVeteranCreditRecommendationID.Value = Request["VeteranCreditRecommendationID"].ToString();
                hfAceID.Value = Request["AceID"].ToString();
                hfCreditRecommendation.Value = Request["CreditRecommendation"].ToString();
            }
        }

        protected void btnAddNA_Click(object sender, EventArgs e)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                connection.Open();
                foreach (GridDataItem item in radGroupNA.MasterTableView.Items)
                {
                    System.Web.UI.WebControls.CheckBox chkBoolean = item.FindControl("chkBoolean") as System.Web.UI.WebControls.CheckBox;
                    using (SqlCommand cmd = new SqlCommand("UPDATE [dbo].[VeteranCreditRecommendations] SET [DNA] = CAST(@NaValue AS BIT) WHERE [VeteranId] = @VeteranId AND [Id] = @id", connection))
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.Parameters.AddWithValue("@VeteranId", hfVeteranID.Value);
                        cmd.Parameters.AddWithValue("@id", item["ID"].Text);
                        cmd.Parameters.AddWithValue("@NaValue", chkBoolean.Checked ? 1 : 0); 
                        cmd.ExecuteNonQuery();
                    }
                }

            }

            RadWindowManager3.RadAlert("Not Applicable Credit Recommendations have been updated.", 330, 180, "", "onRadAlertClose");
        }

        protected void radGroupNA_ItemDataBound(object sender, GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;

                if (hfVeteranCreditRecommendationID.Value != "")
                {
                    if (dataBoundItem["ID"].Text == hfVeteranCreditRecommendationID.Value )
                    {
                        CheckBox checkBox = dataBoundItem.FindControl("chkBoolean") as CheckBox;
                        checkBox.Checked = true;
                        dataBoundItem.BackColor = System.Drawing.Color.LightSkyBlue;
                        dataBoundItem.Selected = true;
                    } else if ( dataBoundItem["AceID"].Text == hfAceID.Value && dataBoundItem["CreditRecommendation"].Text.ToUpper() == hfCreditRecommendation.Value.ToUpper() )
                    {
                        dataBoundItem.BackColor = System.Drawing.Color.LightSkyBlue;
                        dataBoundItem.Selected = true;
                    }
                }
                else if (dataBoundItem["AceID"].Text == hfAceID.Value && dataBoundItem["CreditRecommendation"].Text == hfCreditRecommendation.Value)
                {
                    CheckBox checkBox = dataBoundItem.FindControl("chkBoolean") as CheckBox;
                    checkBox.Checked = true;
                    dataBoundItem.BackColor = System.Drawing.Color.LightSkyBlue;
                    dataBoundItem.Selected = true; 
                }
            }
        }
    }
}