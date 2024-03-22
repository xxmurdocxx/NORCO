using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.academic
{
    public partial class Programs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgPrograms_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            if (e.CommandName == RadGrid.ExportToExcelCommandName)
            {
                grid.ExportToExcel();
            }
            if (e.CommandName == "PrintProgramAll")
            {
                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../reports/ProgramReport.aspx?print_type=all&college_id={0}", Session["CollegeID"].ToString() ), true, true, false, 1000, 600));
            }
            if (e.CommandName == "EditProgram" || e.CommandName == "PrintProgram" || e.CommandName == "PrintProgramShort" || e.CommandName == "EditRequirements")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, Resources.Messages.SelectProgram);
                }
                else
                {
                    foreach (GridDataItem itemDetail in grid.Items)
                    {
                        if (itemDetail.Selected)
                        {
                            if (e.CommandName == "EditProgram")
                            {
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Program.aspx?program_id={0}&program={1}", itemDetail["program_id"].Text, itemDetail["program"].Text), true, true, false, 1200, 600));
                            }
                            if (e.CommandName == "EditRequirements")
                            {
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../popups/Requirements.aspx?program_id={0}&program={1}", itemDetail["program_id"].Text, itemDetail["program"].Text + " - " + itemDetail["description"].Text), true, true, false, 1200, 600));
                            }
                            if (e.CommandName == "PrintProgram")
                            {
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../reports/ProgramReport.aspx?program_id={0}&print_type=full", itemDetail["program_id"].Text), true, true, false, 1000, 600));
                            }
                            if (e.CommandName == "PrintProgramShort")
                            {
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../reports/ProgramReport.aspx?program_id={0}&print_type=short", itemDetail["program_id"].Text), true, true, false, 1000, 600));
                            }

                        }
                    }
                }
            }
        }
    }
}