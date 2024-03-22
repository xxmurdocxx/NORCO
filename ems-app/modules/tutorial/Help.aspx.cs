using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.tutorial
{
    public partial class Help : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            quizTitle.InnerText = string.Format("What did you learn today? This is a quiz for {0} [{1}]", Session["FirstName"] + " " + Session["LastName"], Session["RoleName"] );
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, Telerik.Web.UI.AjaxRequestEventArgs e)
        {
            rgSurveys.DataBind();
        }

        protected void rgSurveys_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            GridDataItem itemDetail = e.Item as GridDataItem;
            if (e.CommandName == "TakeQuiz")
            {
                try
                {
                    norco_db.TakeQuiz(Convert.ToInt32(Session["UserID"]), Convert.ToInt32(itemDetail["SurveyID"].Text));
                    showQuiz(Convert.ToInt32(itemDetail["SurveyID"].Text));
                }
                catch (Exception ex)
                {
                    DisplayMessage(false, ex.ToString());
                }
            }
            if (e.CommandName == "QuizResults")
            {
                try
                {
                    showQuizReport(Convert.ToInt32(itemDetail["SurveyID"].Text));
                }
                catch (Exception ex)
                {
                    DisplayMessage(false, ex.ToString());
                }
            }
        }

        public void showQuiz(Int32 SurveyID)
        {
            RadWindowManager1.Windows.Add( GlobalUtil.CreateRadWindow( String.Format("../popups/Quiz.aspx?SurveyID={0}", SurveyID.ToString() ), true, true, false, 800, 600 ) );
        }

        public void showQuizReport(Int32 SurveyID)
        {
            RadWindowManager1.Windows.Add(GlobalUtil.CreateRadWindow(String.Format("../reports/QuizReport.aspx?SurveyID={0}&UserID={1}", SurveyID.ToString(), Session["UserID"].ToString()), true, true, false, 800, 600));
        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void rgSurveys_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem )
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var completed = dataBoundItem["Completed"].Text;

                if (completed == "True")
                {
                    LinkButton button = e.Item.FindControl("btnResultsQuiz") as LinkButton;
                    button.Visible = true;
                    LinkButton button2 = e.Item.FindControl("btnTakeQuiz") as LinkButton;
                    button2.Visible = false;
                }
            }

        }
    }
}