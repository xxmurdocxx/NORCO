using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Security.AccessControl;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.settings
{
    public partial class Exhibits1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void rgExhibits_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            GridDataItem item = e.Item as GridDataItem;
            if (e.CommandName == RadGrid.ExportToExcelCommandName)
            {
                grid.ExportToExcel();
            }
            
            if (e.CommandName == "CreditRecommendations" || e.CommandName == "Delete")
                {
                    if (grid.SelectedItems.Count <= 0)
                    {
                    rnMessage.Text = "Please select an exhibit.";
                    rnMessage.Show();
                }
                    else
                    {
                    if (e.CommandName == "Delete")
                    {
                        int exists = Controllers.Exhibit.CheckExhibitHasArticulations(item["ID"].Text);
                        if (exists == 0)
                        {
                            Controllers.Exhibit.DeleteExhibit(Convert.ToInt32(item["ID"].Text));
                            rgExhibits.DataBind();
                            rnMessage.Text = "Exhibit deleted.";
                            rnMessage.Show();
                        }
                        else
                        {
                            rnMessage.Text = "Exhibit has related articulations.";
                            rnMessage.Show();
                        }
                    }

                    if (e.CommandName == "CreditRecommendations")
                    {
                        foreach (GridDataItem itemDetail in grid.Items)
                        {
                            if (itemDetail.Selected)
                            {
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../settings/CreditRecommendations.aspx?AceID={0}&TeamRevd={1}&StartDate={2}&EndDate={3}&AceType={4}&SourceID={5}&Title={6}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["StartDate"].Text, itemDetail["EndDate"].Text, itemDetail["AceTypeID"].Text, itemDetail["SourceIDKey"].Text, itemDetail["Title"].Text), true, true, false, 1200, 600));
                                }

                            }
                        }
                    }
            }
        }

        protected void rgExhibits_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = (GridDataItem)e.Item;
                LinkButton btnDel = e.Item.FindControl("btnDelete") as LinkButton;
                

                if (item["SourceIDKey"].Text == "1")
                {
                    btnDel.ToolTip = "ACE Exhibits Delete is not allowed.";
                    btnDel.Attributes.Add("disabled", "disabled");
                    btnDel.Enabled = false;

                    LinkButton btnEdit = e.Item.FindControl("btnEdit") as LinkButton;
                    btnEdit.Enabled = false;
                    btnEdit.ToolTip = "ACE Exhibits edits are not allowed. To view the ACE Exhibit details, please double-click on the ACE ID.";

                }
                else {
                    btnDel.Attributes.Add("onclick", "javascript:if(!confirm('Are you sure you want to remove this exhibit ?')){return false;}");
                }
            }
            if (e.Item.IsInEditMode && (e.Item is GridEditFormItem))
            {
                GridEditFormItem gridEditFormItem = (GridEditFormItem)e.Item;
                if ( !gridEditFormItem.OwnerTableView.IsItemInserted )
                {
                    TextBox ace_id = (TextBox)gridEditFormItem["AceID"].Controls[0];
                    ace_id.Enabled = false;
                    RadComboBox ace_type = (RadComboBox)gridEditFormItem["AceType"].Controls[0];
                    ace_type.Enabled = false;
                    RadComboBox source = (RadComboBox)gridEditFormItem["SourceID"].Controls[0];
                    if (source.SelectedValue == "1")
                    {
                        source.Enabled = false;
                        TextBox version_number = (TextBox)gridEditFormItem["VersionNumber"].Controls[0];
                        version_number.Enabled = false;
                        TextBox title = (TextBox)gridEditFormItem["Title"].Controls[0];
                        title.Enabled = false;
                        RadEditor exhibit_display = (RadEditor)gridEditFormItem["ExhibitDisplay"].Controls[0];
                        exhibit_display.Enabled = false;
                        exhibit_display.Height = Unit.Pixel(250); 
                        RadDatePicker team_revd = (RadDatePicker)gridEditFormItem["TeamRevd"].Controls[0];
                        team_revd.Enabled = false;
                        RadDatePicker start_date = (RadDatePicker)gridEditFormItem["StartDate"].Controls[0];
                        start_date.Enabled = false;
                        RadDatePicker end_date = (RadDatePicker)gridEditFormItem["EndDate"].Controls[0];
                        end_date.Enabled = false;
                    }
                }
            }
        }

        protected void rgExhibits_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
               GridEditableItem editedItem = e.Item as GridEditableItem;
                GridHTMLEditorColumnEditor editor = (GridHTMLEditorColumnEditor)editedItem.EditManager.GetColumnEditor("ExhibitDisplay");
                editor.Editor.Height = Unit.Pixel(250);
                editor.Editor.Width = Unit.Pixel(1000);
                //ElasticButton update = (ElasticButton)(editedItem["EditCommandColumn"].Controls[0]);
                //update.Enabled = false;
            }
        }

        protected void rgExhibits_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                GridEditableItem editedItem = e.Item as GridEditableItem;
                Hashtable InputValues = new Hashtable();
                e.Item.OwnerTableView.ExtractValuesFromItem(InputValues, editedItem);
                Controllers.Exhibit.UpdateExhibit(int.Parse(editedItem.GetDataKeyValue("ID").ToString()), InputValues["VersionNumber"].ToString(), Convert.ToDateTime(InputValues["TeamRevd"].ToString()), Convert.ToDateTime(InputValues["StartDate"].ToString()), Convert.ToDateTime(InputValues["EndDate"].ToString()), InputValues["Title"].ToString(), InputValues["ExhibitDisplay"].ToString());
                rgExhibits.DataBind();
            }
            catch (Exception ex)
            {
                rnMessage.Text = ex.ToString();
                rnMessage.Show();
            }

        }

        protected void rgExhibits_InsertCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                GridEditableItem editedItem = e.Item as GridEditableItem;
                Hashtable InputValues = new Hashtable();
                e.Item.OwnerTableView.ExtractValuesFromItem(InputValues, editedItem);

                DateTime importedONDate = new DateTime();
                importedONDate = DateTime.Now;

                var primero = Convert.ToInt32(InputValues["AceTypeID"]);
                var segundo = InputValues["AceID"].ToString();
                var tercero = Convert.ToDateTime(InputValues["StartDate"].ToString());
                var cuarto = Convert.ToDateTime(InputValues["EndDate"].ToString());
                var quinto = Convert.ToDateTime(InputValues["TeamRevd"].ToString());
                var sexto = InputValues["Title"].ToString();
                var setimo = InputValues["ExhibitDisplay"].ToString();
                var octavo = InputValues["VersionNumber"].ToString();
                var noveno = Convert.ToInt32(InputValues["SourceIDKey"]);

                var result = Controllers.Exhibit.AddExhibit(primero, segundo, tercero, cuarto, quinto, sexto, setimo, importedONDate, octavo, noveno);
                rgExhibits.DataBind();

                if (result == 0) {
                    rnMessage.Text = "Exhibit already exists!";
                } else {
                    rnMessage.Text = "Exhibit has been saved successfully!";
                }

                rnMessage.Show();
            }
            catch (Exception ex)
            {
                rnMessage.Text = ex.ToString();
                rnMessage.Show();
            }
        }
    }
}