using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class CommunicationTemplates : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        private void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateTree(RadTreeView1.Nodes, 0);
                RadTreeView1.Nodes[0].Expanded = true;
                if (Request["TemplateType"] != null)
                {
                    try
                    {
                        var templates = norco_db.GetCommunicationTemplate(Convert.ToInt32(Request["TemplateType"]), Convert.ToInt32(Session["CollegeID"]));
                        foreach (GetCommunicationTemplateResult item in templates)
                        {
                            RadEditor1.Content = item.TemplateText;
                            hfTemplateType.Value = Request["TemplateType"];
                            hfTemplateID.Value = item.ID.ToString();
                            pageTitle.InnerHtml = item.Description;
                        }
                    }
                    catch (Exception ex)
                    {
                        DisplayMessage(true, ex.Message.ToString());
                    }
                }

            }
        }

        private void PopulateTree(RadTreeNodeCollection nodes, Int32 ParentID)
        {

            var _mainTreeNode = norco_db.GetReportExpressions(ParentID);
            foreach (GetReportExpressionsResult mainNode in _mainTreeNode)
            {
                RadTreeNode node = new RadTreeNode();
                node.Text = mainNode.Description;
                node.Value = mainNode.ShortCode;
                nodes.Add(node);
                PopulateTree(node.Nodes, Convert.ToInt32(mainNode.Id));
            }
        }

        protected void rbUpdateVeteranLetter_Click(object sender, EventArgs e)
        {
            try
            {
                norco_db.UpdateCommunicationTemplate(Convert.ToInt32(hfTemplateID.Value), Convert.ToInt32(Session["UserId"]), RadEditor1.Content);
                DisplayMessage(false,Resources.Messages.SuccessfullyUpdated);
            }
            catch (Exception ex)
            {
                DisplayMessage(true, ex.Message.ToString());
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