using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ems_app.modules.popups
{
    public partial class Requirements : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();

        public class FillGroup
        {
            string _groupName;

            public string GroupName
            {
                get { return _groupName; }
                set { _groupName = value; }
            }

            public FillGroup(string groupName)
            {
                _groupName = groupName;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                programTitle.InnerText = Request["program"];
                if (Request["program_id"] != null)
                {
                    var getProgramIssuedForm = norco_db.GetProgramInfo(Convert.ToInt32(Request["program_id"]));
                    var issuedFormId = 0;
                    foreach (GetProgramInfoResult program in getProgramIssuedForm)
                    {
                        issuedFormId = program.IssuedFormID;
                    }
                    hfProgramID.Value = Request["program_id"];
                    hfIssuedFormId.Value = issuedFormId.ToString();

                    //Validation Checklist
                    rblDeegreeProgramChecklist.DataBind();
                    rblIGECTTransferChecklist.DataBind();
                    rblCSUTransferChecklist.DataBind();
                    var ci = norco_db.GetValidationChecklist(Convert.ToInt32(hfProgramID.Value));
                    foreach (GetValidationChecklistResult item in ci)
                    {
                        if (item.DegreeProgram != "")
                        {
                            GenericControls.SetSelectedItem(rblDeegreeProgramChecklist, item.DegreeProgram);
                        }
                        if (item.CSUTransfer != "")
                        {
                            GenericControls.SetSelectedItem(rblCSUTransferChecklist, item.CSUTransfer);
                        }
                        if (item.IGETCTransfer != "")
                        {
                            GenericControls.SetSelectedItem(rblIGECTTransferChecklist, item.IGETCTransfer);
                        }
                    }

                }
            }
        }


        /* PROGRAM REQUIREMENTS */

        protected void rgCourseCatalog_RowDrop(object sender, Telerik.Web.UI.GridDragDropEventArgs e)
        {
            GridDataItem dataItem = e.DraggedItems[0];

            Hashtable values = new Hashtable();
            dataItem.ExtractValues(values);

            int programId = Convert.ToInt32(hfProgramID.Value);
            string courseNumber = (string)values["course_number"];
            int subjectID = Convert.ToInt32(values["subject_id"]);
            int IssuedFormID = Convert.ToInt32(values["IssuedFormID"]);
            int outlineID = Convert.ToInt32(values["outline_id"]);
            int c_group = 0;
            int iorder = 0;
            string groupDesc = "";

            int programcourse_id = 0;
            int required = 0;
            int countDestGrid = 0;
            int destinationIndex = -1;
            int oldIndex = 0;
            int subGroup = 0;
            int destOutlineID = 0;
            if (e.DestinationTableView.OwnerGrid.ClientID == rgRequired.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgRecommended.ClientID)
            {

                if (e.DestinationTableView.OwnerGrid.ClientID == rgRequired.ClientID)
                {
                    required = 1;
                    countDestGrid = (int)rgRequired.Items.Count;
                }
                if (e.DestinationTableView.OwnerGrid.ClientID == rgRecommended.ClientID)
                {
                    required = 2;
                    countDestGrid = (int)rgRecommended.Items.Count;
                }

                if (e.DestDataItem != null)
                {
                    programcourse_id = (int)e.DestDataItem.GetDataKeyValue("programcourse_id");

                    //var queryProps = from pp in norco_db.tblProgramCourses
                    //                 where pp.programcourse_id == programcourse_id
                    //                 select new {
                    //                     c_group = pp.c_group.Equals(null) ? 0: pp.c_group,
                    //                     group_desc = pp.group_desc.Equals(null) ? "" : pp.group_desc
                    //                 };
                    //foreach (var a in queryProps)
                    //{
                    //    c_group = a.c_group;
                    //    groupDesc = a.group_desc;
                    //}
                    var groupInfo = norco_db.GetGroupInfo(programcourse_id);
                    foreach (GetGroupInfoResult item in groupInfo)
                    {
                        c_group = item.c_group;
                        groupDesc = item.group_desc;
                    }
                    destinationIndex = getOrder(programcourse_id);
                    oldIndex = destinationIndex;
                    subGroup = getSubGroup(programcourse_id);
                    destOutlineID = getDestOutlineID(programcourse_id);
                    if (destinationIndex > -1)
                    {
                        if (e.DropPosition == GridItemDropPosition.Above)
                        {
                            if (destinationIndex > 0)
                            {
                                destinationIndex -= 1;
                            }
                            else if (destinationIndex == 0)
                            {
                                oldIndex = -1;
                            }
                        }
                        if (e.DropPosition == GridItemDropPosition.Below)
                        {
                            destinationIndex += 1;
                        }
                        norco_db.ReorderProgramMatrix(programId, oldIndex, required); // reorder courses
                        if (c_group == 0 && destOutlineID == 0)
                        {
                            if (e.DropPosition == GridItemDropPosition.Below)
                            {
                                norco_db.AddProgramCourse(programId, subjectID, IssuedFormID, courseNumber, required, destinationIndex, 0, 0, programcourse_id, "", "", 0, 0);
                            }
                            else
                            {
                                if (required != 1)
                                {
                                    norco_db.AddProgramCourse(programId, subjectID, IssuedFormID, courseNumber, required, destinationIndex, 0, 0, 0, "", "", 0, 0);
                                }
                            }
                        }
                        else if (c_group == 0 && destOutlineID > 0)
                        {
                            norco_db.AddProgramCourse(programId, subjectID, IssuedFormID, courseNumber, required, destinationIndex, 0, 0, 0, "", "", 0, 0);
                        }
                        else if (c_group > 0 && destOutlineID > 0)
                        {
                            norco_db.AddProgramCourse(programId, subjectID, IssuedFormID, courseNumber, required, destinationIndex, 0, 0, c_group, "", "", 0, 0);
                        }
                        else if (c_group > 0 && destOutlineID == 0)
                        {
                            norco_db.AddProgramCourse(programId, subjectID, IssuedFormID, courseNumber, required, destinationIndex, 0, 0, programcourse_id, "", "", 0, 0);
                        }
                    }
                }
                else
                {
                    if (countDestGrid == 0)
                    {
                        var NewCourse = norco_db.AddProgramCourse(programId, subjectID, IssuedFormID, courseNumber, required, 0, 0, 0, 0, "", "", 0, 0);
                    }
                }
                // Show Pre Requsites
                string reqsMessage = "";
                var queryReqs = from pp in norco_db.Requisites
                                where pp.outline_id == outlineID
                                orderby pp.iorder
                                select new { pp };

                foreach (var a in queryReqs)
                {
                    reqsMessage = reqsMessage + a.pp.course_name + "</br>";
                }
                if (reqsMessage != "")
                {
                    reqsMessage = "Pre - requisites found : <br/>" + reqsMessage;
                    DisplayMessage(false, reqsMessage);
                }

                rgRequired.DataBind();
                rgRecommended.DataBind();
            }
            else
            {
                DisplayMessage(false, "Drop the item inside Required, Other or Recommended courses boxes.");
            }

        }
        protected void rgRequired_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;
            if (e.CommandName == "Delete")
            {
                if (item["programcourse_id"].Text != null)
                {
                    var programCourseID = Convert.ToInt32(item["programcourse_id"].Text);
                    norco_db.DeleteEditOutline(programCourseID, Convert.ToInt32(Session["UserId"]));
                    rgRequired.DataBind();
                }
            }
        }
        protected void rbAddGroup_Click(object sender, EventArgs e)
        {
            if (rtbGroupName.Text != null)
            {
                List<FillGroup> ProgramGroups = new List<FillGroup>();
                ProgramGroups.Add(new FillGroup(rtbGroupName.Text));
                rgGroups.DataSource = ProgramGroups;
                rgGroups.Rebind();
            }
        }
        protected void rgGroups_RowDrop(object sender, GridDragDropEventArgs e)
        {
            GridDataItem dataItem = e.DraggedItems[0];

            Hashtable values = new Hashtable();
            dataItem.ExtractValues(values);

            int programId = Convert.ToInt32(hfProgramID.Value);
            string _groupName = (string)values["groupName"];

            int programcourse_id = 0;
            int required = 0;
            int countDestGrid = 0;
            int destinationIndex = -1;
            int oldIndex = 0;

            if (e.DestinationTableView.OwnerGrid.ClientID == rgRequired.ClientID || e.DestinationTableView.OwnerGrid.ClientID == rgRecommended.ClientID)
            {

                if (e.DestinationTableView.OwnerGrid.ClientID == rgRequired.ClientID)
                {
                    required = 1;
                    countDestGrid = (int)rgRequired.Items.Count;
                }
                if (e.DestinationTableView.OwnerGrid.ClientID == rgRecommended.ClientID)
                {
                    required = 2;
                    countDestGrid = (int)rgRecommended.Items.Count;
                }

                if (e.DestDataItem != null)
                {
                    programcourse_id = (int)e.DestDataItem.GetDataKeyValue("programcourse_id");
                    destinationIndex = getOrder(programcourse_id);
                    oldIndex = destinationIndex;
                    var c_group = 0;
                    var queryProps = from pp in norco_db.tblProgramCourses
                                     where pp.programcourse_id == programcourse_id
                                     select new { pp };
                    foreach (var a in queryProps)
                    {
                        if (a.pp.c_group != null)
                        {
                            c_group = Convert.ToInt32(a.pp.c_group);
                        }
                    }
                    var subGroup = getSubGroup(programcourse_id);
                    var destOutlineID = getDestOutlineID(programcourse_id);

                    if (destinationIndex > -1)
                    {
                        if (e.DropPosition == GridItemDropPosition.Above)
                        {
                            if (destinationIndex > 0)
                            {
                                destinationIndex -= 1;
                            }
                            else if (destinationIndex == 0)
                            {
                                oldIndex = -1;
                            }
                        }
                        if (e.DropPosition == GridItemDropPosition.Below)
                        {
                            destinationIndex += 1;
                        }
                        norco_db.ReorderProgramMatrix(programId, oldIndex, required); // reorder courses
                        if (required == 1)
                        {
                            norco_db.addProgramGroup(programId, required, destinationIndex, 0, c_group, _groupName, Convert.ToInt32(Session["UserId"]));
                        }
                        else if (required == 2)
                        {
                            norco_db.addProgramGroup(programId, required, destinationIndex, 0, 0, _groupName, Convert.ToInt32(Session["UserId"]));
                        }
                        else if (required == 3)
                        {
                            if (subGroup != 1)
                            {
                                if (c_group > 0 && destOutlineID == 0)
                                {
                                    if (e.DropPosition == GridItemDropPosition.Below)
                                    {
                                        norco_db.addProgramGroup(programId, required, destinationIndex, 3, programcourse_id, _groupName, Convert.ToInt32(Session["UserId"]));
                                    }
                                    else
                                    {
                                        DisplayMessage(false, "You cant drop items here.");
                                    }
                                }
                                else if (c_group > 0 && destOutlineID > 0)
                                {
                                    norco_db.addProgramGroup(programId, required, destinationIndex, 3, c_group, _groupName, Convert.ToInt32(Session["UserId"]));
                                }
                            }
                        }
                    }
                }
                else
                {
                    if (countDestGrid == 0)
                    {
                        var NewCourse = norco_db.addProgramGroup(programId, required, 0, 0, 0, _groupName, Convert.ToInt32(Session["UserId"]));
                    }
                }

                rgRequired.DataBind();
                rgRecommended.DataBind();
            }
            else
            {
                DisplayMessage(false, "Drop the item inside Required, Other or Recommended courses boxes.");
            }

        }

        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        public Int32 getOrder(Int32 id)
        {
            var order = norco_db.ProgramCourseOrder(id);
            var iorder = 0;
            foreach (ProgramCourseOrderResult p in order)
            {
                iorder = (int)p.iorder;
            }
            return iorder;
        }

        public Int32 getSubGroup(Int32 id)
        {

            int isuborder = 0;

            var programCourses = norco_db.GetGroupInfo(id);
            foreach (GetGroupInfoResult item in programCourses)
            {
                isuborder = item.isuborder;
            }
            return isuborder;
        }

        public Int32 getDestOutlineID(Int32 id)
        {

            int outlineID = 0;

            var programCourses = norco_db.GetGroupInfo(id);
            foreach (GetGroupInfoResult item in programCourses)
            {
                outlineID = item.outline_id;
            }
            return outlineID;
        }

        protected void rgRecommended_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;
            if (e.CommandName == "Delete")
            {
                if (item["programcourse_id"].Text != null)
                {
                    var programCourseID = Convert.ToInt32(item["programcourse_id"].Text);
                    norco_db.DeleteEditOutline(programCourseID, Convert.ToInt32(Session["UserId"]));
                    rgRecommended.DataBind();
                }
            }
        }



        protected string courseDescription(GridDataItem dataItem)
        {
            var courseTitle = DataBinder.Eval(dataItem.DataItem, "course_title");
            var cGroup = (int)DataBinder.Eval(dataItem.DataItem, "c_group");
            var outlineID = (int)DataBinder.Eval(dataItem.DataItem, "outline_id");
            var groupName = DataBinder.Eval(dataItem.DataItem, "group_desc");
            int required = (int)DataBinder.Eval(dataItem.DataItem, "required");
            var groupTotal = DataBinder.Eval(dataItem.DataItem, "group_total");
            var groupDescription = "";
            var tabx1 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            var tabx2 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            if (courseTitle != null)
            {
                if (groupName == "")
                {
                    if (required == 2)
                    {
                        if (cGroup > 0 && outlineID > 0)
                        {
                            return tabx1 + courseTitle.ToString();
                        }
                    }
                    if (required == 1)
                    {
                        if (cGroup > 0 && outlineID > 0)
                        {
                            return tabx1 + courseTitle.ToString();
                        }
                    }
                    if (required == 3 && (cGroup > 0 && outlineID > 0))
                    {
                        return tabx2 + courseTitle.ToString();
                    }
                    else
                    {
                        return courseTitle.ToString();
                    }
                }
                else
                {
                    if (required == 3)
                    {
                        groupDescription = "<b>" + groupName.ToString() + " - Total Units : " + groupTotal.ToString() + "</b>";
                        if (cGroup > 0 && outlineID == 0)
                        {
                            groupDescription = tabx1 + groupDescription;
                        }
                        else if (cGroup > 0 && outlineID > 0)
                        {
                            groupDescription = tabx2 + groupDescription;
                        }
                        return groupDescription;
                    }
                    else
                    {
                        return "<b>" + groupName.ToString() + "</b>";
                    }
                }
            }
            else
            {
                return "";
            }
        }

        protected void rgRequired_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var groupDesc = dataBoundItem["group_desc"].Text;
                var c_group = dataBoundItem["c_group"].Text;
                var prereq_total = dataBoundItem["prereq_total"].Text;
                
                LinkButton btnEditGroup = e.Item.FindControl("btnEditGroup") as LinkButton;
                LinkButton btnShowPreRequisites = e.Item.FindControl("btnShowPreRequisites") as LinkButton;
                if (groupDesc != "&nbsp;")
                {
                    btnEditGroup.Visible = true;
                    dataBoundItem.ToolTip = "Drag and drop courses to this group";
                    var programcourse_id = dataBoundItem["programcourse_id"].Text;
                    btnEditGroup.OnClientClick = String.Format("javascript:ShowGroupInfo('{0}')", programcourse_id.ToString());
                }
                
                LinkButton btnViewCourse = e.Item.FindControl("btnViewCourse") as LinkButton;
                var outline_id = dataBoundItem["outline_id"].Text;
                btnViewCourse.OnClientClick = String.Format("javascript:ShowCourseInfo('{0}')", outline_id.ToString());

                if (Convert.ToInt32(prereq_total) > 0)
                {
                    btnShowPreRequisites.Visible = true;
                }

            }
        }
        protected void rgRecommended_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                var groupDesc = dataBoundItem["group_desc"].Text;
                var prereq_total = dataBoundItem["prereq_total"].Text;
                LinkButton btnEditGroup = e.Item.FindControl("btnEditGroup") as LinkButton;
                LinkButton btnShowPreRequisites = e.Item.FindControl("btnShowPreRequisites") as LinkButton;
                if (groupDesc != "&nbsp;")
                {
                    btnEditGroup.Visible = true;
                    dataBoundItem.ToolTip = "Add here a tooltip description";
                    var programcourse_id = dataBoundItem["programcourse_id"].Text;
                    btnEditGroup.OnClientClick = String.Format("javascript:ShowGroupInfo('{0}')", programcourse_id.ToString());
                }
                LinkButton btnViewCourse = e.Item.FindControl("btnViewCourse") as LinkButton;
                var outline_id = dataBoundItem["outline_id"].Text;
                btnViewCourse.OnClientClick = String.Format("javascript:ShowCourseInfo('{0}')", outline_id.ToString());
                if (Convert.ToInt32(prereq_total) > 0)
                {
                    btnShowPreRequisites.Visible = true;
                }
            }
        }

        public void createSemestersGroups(Int32 programId, Int32 destinationIndex, Int32 oldIndex, Int32 required, Int32 programcourse_id, String _groupName, Int32 _userId)
        {
            norco_db.ReorderProgramMatrix(programId, oldIndex, required);
            norco_db.addProgramGroup(programId, required, destinationIndex, 1, 0, _groupName, _userId);
            norco_db.ReorderProgramMatrix(programId, destinationIndex, required);
            destinationIndex += 1;
            norco_db.addProgramGroup(programId, required, destinationIndex, 2, programcourse_id, "Required", _userId);
            norco_db.ReorderProgramMatrix(programId, destinationIndex, required);
            destinationIndex += 1;
            norco_db.addProgramGroup(programId, required, destinationIndex, 2, programcourse_id, "Required (Options)", _userId);
            norco_db.ReorderProgramMatrix(programId, destinationIndex, required);
            destinationIndex += 1;
            norco_db.addProgramGroup(programId, required, destinationIndex, 2, programcourse_id, "Elective", _userId);
        }

        protected void RadAjaxPanel1_AjaxRequest(object sender, AjaxRequestEventArgs e)
        {
            rgRequired.DataBind();
            rgRecommended.DataBind();
        }

        protected void rgSchedule_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;
            if (e.CommandName == "Delete")
            {
                if (item["programcourse_id"].Text != null)
                {
                    var programCourseID = Convert.ToInt32(item["programcourse_id"].Text);
                    norco_db.DeleteEditOutline(programCourseID, Convert.ToInt32(Session["UserId"]));
                    rgRecommended.DataBind();
                    rgProgramMatrix.DataBind();
                }
            }
        }

        protected void rbUpdateChecklist_Click(object sender, EventArgs e)
        {
            try
            {
                norco_db.UpdateValidationCheckList(Convert.ToInt32(hfProgramID.Value), GenericControls.GetSelectedItemText(rblDeegreeProgramChecklist), GenericControls.GetSelectedItemText(rblCSUTransferChecklist), GenericControls.GetSelectedItemText(rblIGECTTransferChecklist), Convert.ToInt32(Session["UserID"]));
                DisplayMessage(false, "Validation checklist successfully updated.");
            }
            catch (Exception ex)
            {
                DisplayMessage(false, ex.ToString());
            }
        }

        protected void rgElectives_RowDrop(object sender, GridDragDropEventArgs e)
        {
            GridDataItem dataItem = e.DraggedItems[0];
            Hashtable values = new Hashtable();
            dataItem.ExtractValues(values);
            int programId = Convert.ToInt32(hfProgramID.Value);
            int outlineID = Convert.ToInt32(values["id"]);
            int c_group = 0;
            string groupDesc = "";
            int programcourse_id = 0;
            int required = 3;
            int destinationIndex = -1;
            int oldIndex = 0;
            int subGroup = 0;
            int destOutlineID = 0;
            if (e.DestinationTableView.OwnerGrid.ClientID == rgSchedule.ClientID)
            {
                if (e.DestDataItem != null)
                {
                    programcourse_id = (int)e.DestDataItem.GetDataKeyValue("programcourse_id");

                    var queryProps = from pp in norco_db.tblProgramCourses
                                     where pp.programcourse_id == programcourse_id
                                     select new { pp };
                    foreach (var a in queryProps)
                    {
                        if (a.pp.c_group != null)
                        {
                            c_group = Convert.ToInt32(a.pp.c_group);
                        }
                        groupDesc = a.pp.group_desc;
                    }
                    destinationIndex = getOrder(programcourse_id);
                    oldIndex = destinationIndex;
                    subGroup = getSubGroup(programcourse_id);
                    destOutlineID = getDestOutlineID(programcourse_id);
                    if (destinationIndex > -1)
                    {
                        if (subGroup != 1)
                        {
                            if (e.DropPosition == GridItemDropPosition.Above)
                            {
                                if (destinationIndex > 0)
                                {
                                    destinationIndex -= 1;
                                }
                                else if (destinationIndex == 0)
                                {
                                    oldIndex = -1;
                                }
                            }
                            if (e.DropPosition == GridItemDropPosition.Below)
                            {
                                destinationIndex += 1;
                            }
                            norco_db.ReorderProgramMatrix(programId, oldIndex, required); // reorder courses
                            if (c_group > 0 && destOutlineID == 0)
                            {
                                if (e.DropPosition == GridItemDropPosition.Below)
                                {
                                    var NewCourse = norco_db.AddProgramSchedule(programId, outlineID, required, destinationIndex, programcourse_id, "", true);
                                }
                                else
                                {
                                    DisplayMessage(false, "You cant drop items here.");
                                }
                            }
                            else if (c_group > 0 && destOutlineID > 0)
                            {
                                var NewCourse = norco_db.AddProgramSchedule(programId, outlineID, required, destinationIndex, c_group, "", true);
                            }
                        }
                    }
                }
                else
                {
                    norco_db.AddProgramSchedule(programId, outlineID, required, 1, programcourse_id, "", true);
                }
                rgProgramMatrix.DataBind();
                rgSchedule.DataBind();
            }
            else
            {
                DisplayMessage(false, "Drop the item inside Required, Other or Recommended courses boxes.");
            }
        }

        protected void rgSemesters_RowDrop(object sender, GridDragDropEventArgs e)
        {
            GridDataItem dataItem = e.DraggedItems[0];
            Hashtable values = new Hashtable();
            dataItem.ExtractValues(values);
            int programId = Convert.ToInt32(hfProgramID.Value);
            string _groupName = (string)values["description"];
            int programcourse_id = 0;
            int required = 3;
            int countDestGrid = 0;
            int destinationIndex = -1;
            int oldIndex = 0;
            int subGroup = 0;
            if (e.DestinationTableView.OwnerGrid.ClientID == rgSchedule.ClientID)
            {
                countDestGrid = (int)rgSchedule.Items.Count;

                if (e.DestDataItem != null)
                {
                    programcourse_id = (int)e.DestDataItem.GetDataKeyValue("programcourse_id");
                    destinationIndex = getOrder(programcourse_id);
                    subGroup = getSubGroup(programcourse_id);
                    countDestGrid = rgSchedule.Items.Count - 1;
                    oldIndex = destinationIndex;
                    if (subGroup == 1) // is Main Group
                    {
                        if (destinationIndex > -1)
                        {
                            if (e.DropPosition == GridItemDropPosition.Above)
                            {
                                if (destinationIndex > 0)
                                {
                                    destinationIndex -= 1;
                                }
                                else if (destinationIndex == 0)
                                {
                                    oldIndex = -1;
                                }
                                createSemestersGroups(programId, destinationIndex, oldIndex, required, programcourse_id, _groupName, Convert.ToInt32(Session["UserId"]));
                            }
                            if (e.DropPosition == GridItemDropPosition.Below)
                            {
                                if (destinationIndex == countDestGrid) // this is the last record, can add semester
                                {
                                    destinationIndex += 1;
                                    createSemestersGroups(programId, destinationIndex, oldIndex, required, programcourse_id, _groupName, Convert.ToInt32(Session["UserId"]));
                                }
                                else
                                {
                                    DisplayMessage(false, "You cant drop items here.");
                                }
                            }

                        }
                    }
                    else // you cant drop items here
                    {
                        if (e.DropPosition == GridItemDropPosition.Below)
                        {
                            if (destinationIndex == countDestGrid) // this is the last record, can add semester
                            {
                                destinationIndex += 1;
                                createSemestersGroups(programId, destinationIndex, oldIndex, required, programcourse_id, _groupName, Convert.ToInt32(Session["UserId"]));
                            }
                            else
                            {
                                DisplayMessage(false, "You cant drop items here.");
                            }
                        }
                        else
                        {
                            DisplayMessage(false, "You cant drop items here.");
                        }
                    }
                }
                else
                {
                    if (countDestGrid == 0)
                    {
                        createSemestersGroups(programId, destinationIndex, oldIndex, required, programcourse_id, _groupName, Convert.ToInt32(Session["UserId"]));
                    }
                }
                rgSchedule.DataBind();
            }
            else
            {
                DisplayMessage(false, "You cant drop items here.");
            }
        }

        protected void rgProgramMatrix_RowDrop(object sender, GridDragDropEventArgs e)
        {
            GridDataItem dataItem = e.DraggedItems[0];
            Hashtable values = new Hashtable();
            dataItem.ExtractValues(values);
            int programId = Convert.ToInt32(hfProgramID.Value);
            int outlineID = Convert.ToInt32(values["outline_id"]);
            int c_group = 0;
            string groupDesc = "";
            int programcourse_id = 0;
            int required = 3;
            int destinationIndex = -1;
            int oldIndex = 0;
            int subGroup = 0;
            int destOutlineID = 0;
            if (e.DestinationTableView.OwnerGrid.ClientID == rgSchedule.ClientID)
            {
                if (e.DestDataItem != null)
                {
                    programcourse_id = (int)e.DestDataItem.GetDataKeyValue("programcourse_id");

                    var queryProps = from pp in norco_db.tblProgramCourses
                                     where pp.programcourse_id == programcourse_id
                                     select new { pp };
                    foreach (var a in queryProps)
                    {
                        if (a.pp.c_group != null)
                        {
                            c_group = Convert.ToInt32(a.pp.c_group);
                        }
                        groupDesc = a.pp.group_desc;
                    }
                    destinationIndex = getOrder(programcourse_id);
                    oldIndex = destinationIndex;
                    subGroup = getSubGroup(programcourse_id);
                    destOutlineID = getDestOutlineID(programcourse_id);
                    if (destinationIndex > -1)
                    {
                        if (subGroup != 1)
                        {
                            if (e.DropPosition == GridItemDropPosition.Above)
                            {
                                if (destinationIndex > 0)
                                {
                                    destinationIndex -= 1;
                                }
                                else if (destinationIndex == 0)
                                {
                                    oldIndex = -1;
                                }
                            }
                            if (e.DropPosition == GridItemDropPosition.Below)
                            {
                                destinationIndex += 1;
                            }
                            norco_db.ReorderProgramMatrix(programId, oldIndex, required); // reorder courses
                            if (c_group > 0 && destOutlineID == 0)
                            {
                                if (e.DropPosition == GridItemDropPosition.Below)
                                {
                                    var NewCourse = norco_db.AddProgramSchedule(programId, outlineID, required, destinationIndex, programcourse_id, "", false);
                                }
                                else
                                {
                                    DisplayMessage(false, "You cant drop items here.");
                                }
                            }
                            else if (c_group > 0 && destOutlineID > 0)
                            {
                                var NewCourse = norco_db.AddProgramSchedule(programId, outlineID, required, destinationIndex, c_group, "", false);
                            }
                        }
                    }
                }
                else
                {
                    norco_db.AddProgramSchedule(programId, outlineID, required, 1, programcourse_id, "", false);
                }
                rgProgramMatrix.DataBind();
                rgSchedule.DataBind();
            }
            else
            {
                DisplayMessage(false, "Drop the item inside Required, Other or Recommended courses boxes.");
            }
        }

        protected void rgSchedule_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem dataBoundItem = e.Item as GridDataItem;
                LinkButton btnViewCourse = e.Item.FindControl("btnViewCourse") as LinkButton;
                var outline_id = dataBoundItem["outline_id"].Text;
                btnViewCourse.OnClientClick = String.Format("javascript:ShowCourseInfo('{0}')", outline_id.ToString());
            }
        }
    }
}