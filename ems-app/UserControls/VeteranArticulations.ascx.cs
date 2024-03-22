using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.UserControls
{
    public partial class VeteranArticulations : System.Web.UI.UserControl
    {
        public int CollegeID { get; set; }
        public int VeteranID { get; set; }
        public string Occupation { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                sqlArticulationsByOccupationCode.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlArticulationsByOccupationCode.SelectParameters["VeteranID"].DefaultValue = VeteranID.ToString();
                sqlArticulationsByOccupationCode.SelectParameters["Occupation"].DefaultValue = Occupation.ToString();
                sqlArticulationsByOccupationCode.DataBind();
                sqlSubjects.SelectParameters["CollegeID"].DefaultValue = CollegeID.ToString();
                sqlSubjects.DataBind();
                rgArticulations.DataBind();
            }
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgArticulations_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;
            var url = "";
            if (e.CommandName == "ShowACEExhibit")
            {
                if (grid.SelectedItems.Count <= 0)
                {
                    DisplayMessage(false, "Please select an articulation");
                }
                else
                {
                    foreach (GridDataItem itemDetail in grid.Items)
                    {
                        if (itemDetail.Selected)
                        {
                            if (e.CommandName == "ShowACEExhibit")
                            {
                                if (itemDetail["ArticulationTypeName"].Text == "Occupation")
                                {
                                    url = String.Format("~/modules/popups/ShowOccupation.aspx?AceID={0}&TeamRevd={1}&Occupation={2}&Title={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Occupation"].Text, itemDetail["Title"].Text);
                                }
                                else
                                {
                                    url = String.Format("~/modules/popups/ShowACECourseDetail.aspx?AceID={0}&TeamRevd={1}&Occupation={2}&Title={3}", itemDetail["AceID"].Text, itemDetail["TeamRevd"].Text, itemDetail["Occupation"].Text, itemDetail["Title"].Text);
                                }
                                RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(url, true, false, false, 900, 600));
                            }
                        }
                    }
                }
            }
        }

        protected void rgArticulations_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            RadGrid grid = (RadGrid)sender;

            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                if (grid.ID == "rgFacultyReviewArticulations")
                {
                    int haveDeniedArticulations = Convert.ToInt32(dataBoundItem["HaveDeniedArticulations"].Text);
                    LinkButton btnHaveDeniedArticulations = e.Item.FindControl("btnHaveDeniedArticulations") as LinkButton;
                    btnHaveDeniedArticulations.Visible = false;
                    if (haveDeniedArticulations > 0)
                    {
                        btnHaveDeniedArticulations.Visible = true;
                        btnHaveDeniedArticulations.Style.Add("color", "#ff0000");
                    }
                }
            }
        }
    }
}