using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ems_app.modules.popups
{
    public partial class Quiz : System.Web.UI.Page
    {

        NORCODataContext norco_db = new NORCODataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            var surveyID = Convert.ToInt32(Request["SurveyID"]);

            var isCompleted = norco_db.CheckSurveyIsCompleted(surveyID, Convert.ToInt32(Session["UserID"]));

            if (isCompleted == false)
            {
                getQuiz(surveyID);
            } else
            {
                DisplayMessage(false, "Quiz completed.");
            }
        }

        public void getQuiz(int surveyID)
        {
            var surveyResults = norco_db.GetSurvey(surveyID);
            foreach (GetSurveyResult survey in surveyResults)
            {
                quizTitle.InnerText = survey.Name;
                WelcomeMessage.InnerText = survey.WelcomeMessage;
                ExitMessage.InnerText = survey.ExitMessage;
            }

            var questions = norco_db.GetSurveyQuestions(surveyID);
            Table tbl = new Table();
            tbl.Width = Unit.Percentage(100);
            TableRow tr;
            TableCell tc;
            RadioButtonList rbl;
            foreach (GetSurveyQuestionsResult item in questions)
            {
                tr = new TableRow();
                tc = new TableCell();
                tc.Text = item.Text;
                tc.Attributes.Add("id", item.QuestionID.ToString());
                tr.Cells.Add(tc);
                tbl.Rows.Add(tr);

                tr = new TableRow();
                tc = new TableCell();

                rbl = new RadioButtonList();
                rbl.ID = "rbl_" + item.QuestionID;
                var choices = norco_db.GetQuestionChoices(item.QuestionID);
                foreach (GetQuestionChoicesResult choice in choices)
                {
                    rbl.Items.Add(new ListItem(choice.Text, choice.Value.ToString()));
                }

                var responseValue = norco_db.GetResponseValue(item.QuestionID, Convert.ToInt32(Session["UserID"]), surveyID);

                if (responseValue != null)
                {
                    if (responseValue != 0)
                    {
                        rbl.Items.FindByValue(responseValue.ToString()).Selected = true;
                    }
                }

                tc.Controls.Add(rbl);
                tr.Cells.Add(tc);
                tbl.Rows.Add(tr);
            }
            pnlSurvey.Controls.Add(tbl);
        }

        public void saveQuiz()
        {
            var question_id = 0;
            var response_value = 0;
            var surveyID = Convert.ToInt32(Request["SurveyID"]);

            foreach (Control ctr in pnlSurvey.Controls)
            {
                if (ctr is Table)
                {
                    Table tbl = ctr as Table;
                    foreach (TableRow tr in tbl.Rows)
                    {
                        TableCell tc = tr.Cells[0];
                        foreach (Control ctrc in tc.Controls)
                        {
                            if (ctrc is RadioButtonList)
                            {
                                response_value = 0;
                                question_id = Convert.ToInt32((ctrc as RadioButtonList).ID.Replace("rbl_", ""));
                                if (!string.IsNullOrEmpty((ctrc as RadioButtonList).SelectedValue))
                                {
                                    response_value = Convert.ToInt32((ctrc as RadioButtonList).SelectedValue);
                                }
                                norco_db.UpdateQuestion(question_id, response_value, Convert.ToInt32(Session["UserID"]), surveyID);
                            }
                        }
                    }

                }
            }
        }

        protected void rbSave_Click(object sender, EventArgs e)
        {
            try
            {
                saveQuiz();
                DisplayMessage(false, "Quiz saved.");
            }
            catch (Exception ex)
            {
                DisplayMessage(false, ex.ToString());
            }
        }

        protected void rbFinish_Click(object sender, EventArgs e)
        {
            try
            {
                saveQuiz();
                norco_db.FinishQuiz(Convert.ToInt32(Session["UserID"]), Convert.ToInt32(Request["SurveyID"]));
                RadAjaxManager1.ResponseScripts.Add("CloseModal();");
            }
            catch (Exception ex)
            {
                DisplayMessage( false, ex.ToString() );
            }

        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

    }
}