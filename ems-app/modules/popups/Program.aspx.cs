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
    public partial class Program : System.Web.UI.Page
    {
        NORCODataContext norco_db = new NORCODataContext();
        int fileId;
        byte[] fileData;
        string fileName;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ClearInputs(Page.Controls);
                programTitle.InnerText = Request["program"];
                rtProgramTitle.Focus();
                if (Request["program_id"] != null)
                {
                    var getProgramIssuedForm = norco_db.GetProgramInfo(Convert.ToInt32(Request["program_id"]));
                    var issuedFormId = 0;
                    foreach (GetProgramInfoResult program in getProgramIssuedForm)
                    {
                        issuedFormId = program.IssuedFormID;
                    }
                    getProgramInformation(issuedFormId);
                    hfProgramID.Value = Request["program_id"];
                    hfIssuedFormId.Value = issuedFormId.ToString();
                }
                //EnableCourseToolTips();
                //Populate Additional Resource if dont have any data
                //norco_db.sp_additional_resources(null, Convert.ToInt32(Session["ProgramID"]));
            }
        }

        public void ClearInputs(ControlCollection ctrls)
        {
            foreach (Control ctrl in ctrls)
            {
                if (ctrl is TextBox)
                    ((TextBox)ctrl).Text = string.Empty;
                if (ctrl is RadNumericTextBox)
                    ((RadNumericTextBox)ctrl).Text = string.Empty;
                if (ctrl is RadEditor)
                    ((RadEditor)ctrl).Content = string.Empty;
                if (ctrl is DropDownList )
                    ((DropDownList)ctrl).DataBind();
                if (ctrl is RadioButtonList)
                    ((RadioButtonList)ctrl).DataBind();
                if (ctrl is RadComboBox)
                    ((RadComboBox)ctrl).DataBind();
            }
        }
        private void DisplayMessage(bool isError, string text)
        {
            Label label = (isError) ? this.Label1 : this.Label2;
            label.Text = text;
            RadToolTip1.Show();
        }

        protected void showTooltip_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)(sender);
            var propertyName = btn.CommandName;
            var linkID = btn.ID;
            RadToolTip2.TargetControlID = linkID;
            var toolTip = norco_db.GetTooltip(propertyName);
            foreach (GetTooltipResult p in toolTip)
            {
                DisplayTooltip(p.PropertyDescription, p.PropertyToolTip);  
            }
            
        }

        private void DisplayTooltip(string textTitle, string textContent)
        {
            Label label3 = this.Label3;
            Label label4 = this.Label4;
            label3.Text = textTitle;
            label4.Text = textContent;
            RadToolTip2.Show();
        }

        private void GetControlList<T>(ControlCollection controlCollection, List<T> resultCollection)
       where T : Control
        {
            foreach (Control control in controlCollection)
            {
                if (control is T)
                    resultCollection.Add((T)control);

                if (control.HasControls())
                    GetControlList(control.Controls, resultCollection);
            }
        }

        public void EnableCourseToolTips()
        {
            var commandName = "";
            var validationGroup = "";
            List<LinkButton> allControls = new List<LinkButton>();
            GetControlList<LinkButton>(Page.Controls, allControls);
            foreach (var childControl in allControls)
            {
                commandName = childControl.CommandName;
                validationGroup = childControl.ValidationGroup;
                if (commandName != null && validationGroup == "ToolTips")
                {
                    childControl.Visible = BubbleVisibility(commandName, "Tooltip");
                }
            }
        }
        public bool BubbleVisibility(string propertyName, string type)
        {
            if ((propertyName == null || propertyName == ""))
            {
                return false;
            }
            else
            {
                int tooltipIsActive = norco_db.GetPropertyVisibility(propertyName, type);
                if (tooltipIsActive == 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        private void getProgramInformation(int issuedFormId)
        {


            //rtProgramTitle.Text = norco_db.GetPropertyValue(issuedFormId,"ProgramTitle");
            //if (!norco_db.GetPropertyValue(issuedFormId, "TopCode").Equals("")) { ddlTopsCode.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "TopCode"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "SessionName").Equals("")) { rcbSeason.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "SessionName"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "AcademicYear").Equals("")) { rcbYear.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "AcademicYear"); }
            //rtbCIPCode.Text = norco_db.GetPropertyValue(issuedFormId, "CIPCode");
            //rtbSOCCode.Text = norco_db.GetPropertyValue(issuedFormId, "SOCCode");
            //if (!norco_db.GetPropertyValue(issuedFormId, "ProgramType").Equals("")) { rcbProgramType.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "ProgramType"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "CDCPEligibilityCategory").Equals("")) { rblCDCP.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "CDCPEligibilityCategory"); }
            //reEssentialMisision.Content = norco_db.GetPropertyValue(issuedFormId, "EssentialMisision");
            //if (!norco_db.GetPropertyValue(issuedFormId, "ProgramGoal").Equals("")) { rcbProgramGoal.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "ProgramGoal"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "DevelopedSLO").Equals("")) { rbDevelopedSLO.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "DevelopedSLO"); }
            //reDevelopedSLO.Content = norco_db.GetPropertyValue(issuedFormId, "DevelopedSLODescription");
            //reSampleProgramLevel.Content = norco_db.GetPropertyValue(issuedFormId, "SampleProgramLevel");
            //if (!norco_db.GetPropertyValue(issuedFormId, "MinimumUnits").Equals("")) { rntbMinimumUnits.Value = Convert.ToDouble(norco_db.GetPropertyValue(issuedFormId, "MinimumUnits")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "MaximumUnits").Equals("")) { rntbMaximumUnits.Value = Convert.ToDouble(norco_db.GetPropertyValue(issuedFormId, "MaximumUnits")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "MinimumUnitsDegree").Equals("")) { rntbMinimumUnitsDegree.Value = Convert.ToDouble(norco_db.GetPropertyValue(issuedFormId, "MinimumUnitsDegree")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "MaximumUnitsDegree").Equals("")) { rntbMaximumUnitsDegree.Value = Convert.ToDouble(norco_db.GetPropertyValue(issuedFormId, "MaximumUnitsDegree")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "AnnualCompleters").Equals("")) { rntbAnnualCompleters.Value = Convert.ToInt32(norco_db.GetPropertyValue(issuedFormId, "AnnualCompleters")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "AnualLaborDemand").Equals("")) { rntbAnualLaborDemand.Value = Convert.ToInt32(norco_db.GetPropertyValue(issuedFormId, "AnualLaborDemand")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "CTEApprovalDate").Equals("")) { rdpCTEApprovalDate.SelectedDate = Convert.ToDateTime(norco_db.GetPropertyValue(issuedFormId, "CTEApprovalDate")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "EquipmentRequired").Equals("")) { rntbEquipmentRequired.Value = Convert.ToInt32(norco_db.GetPropertyValue(issuedFormId, "EquipmentRequired")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "RemoledFacilities").Equals("")) { rntbRemoledFacilities.Value = Convert.ToInt32(norco_db.GetPropertyValue(issuedFormId, "RemoledFacilities")); }

            //if (!norco_db.GetPropertyValue(issuedFormId, "LibraryAcquisitions").Equals("")) { rntbLibraryAcquisitions.Value = Convert.ToInt32(norco_db.GetPropertyValue(issuedFormId, "LibraryAcquisitions")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "GainfulEmployment").Equals("")) { rblGainfulEmployment.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "GainfulEmployment"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "Apprenticeship").Equals("")) { rblApprenticeship.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "Apprenticeship"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "DistanceEducation").Equals("")) { rblDistanceEducation.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "DistanceEducation"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "BoardApprovalDate").Equals("")) { rdpBoardApprovalDate.SelectedDate = Convert.ToDateTime(norco_db.GetPropertyValue(issuedFormId, "BoardApprovalDate")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "FacultyWorkload").Equals("")) { rntbFacultyWorkload.Value = Convert.ToDouble(norco_db.GetPropertyValue(issuedFormId, "FacultyWorkload")); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "FacultyPositions").Equals("")) { rntbFacultyPositions.Value = Convert.ToInt32(norco_db.GetPropertyValue(issuedFormId, "FacultyPositions")); }
            //reCatalogDescription.Content = norco_db.GetPropertyValue(issuedFormId, "CatalogDescription");
            //reOpportunityThreats.Content = norco_db.GetPropertyValue(issuedFormId, "OpportunityThreats");
            //reMasterPlanning.Content = norco_db.GetPropertyValue(issuedFormId, "MasterPlanning");
            //reProgramCost.Content = norco_db.GetPropertyValue(issuedFormId, "ProgramCost");
            //if (!norco_db.GetPropertyValue(issuedFormId, "AdditionalEquipment").Equals("")) { rblAdditionalEquipment.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "AdditionalEquipment"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "AdditionalMaterials").Equals("")) { rblAdditionalMaterials.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "AdditionalMaterials"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "AdditionalTravel").Equals("")) { rblAdditionalTravel.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "AdditionalTravel"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "AdditionalLibrary").Equals("")) { rblAdditionalLibrary.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "AdditionalLibrary"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "AdditionalSoftware").Equals("")) { rblAdditionalSoftware.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "AdditionalSoftware"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "SectionOfferings").Equals("")) { rblSectionOfferings.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "SectionOfferings"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "ModificationFacilities").Equals("")) { rblModificationFacilities.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "ModificationFacilities"); }
            //reSectionOfferingsDescription.Content = norco_db.GetPropertyValue(issuedFormId, "SectionOfferingsDescription");
            //if (!norco_db.GetPropertyValue(issuedFormId, "IncreaseTotalStudents").Equals("")) { rblIncreaseTotalStudents.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "IncreaseTotalStudents"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "IncreaseTotalStudentsNumber").Equals("")) { rntbIncreaseTotalStudents.Value = Convert.ToInt32(norco_db.GetPropertyValue(issuedFormId, "IncreaseTotalStudentsNumber")); }
            //rePlanNeededResources.Content = norco_db.GetPropertyValue(issuedFormId, "PlanNeededResources");
            //if (!norco_db.GetPropertyValue(issuedFormId, "EnrollmentFulfillNeed").Equals("")) { rblEnrollmentFulfillNeed.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "EnrollmentFulfillNeed"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "ExpectedAnnualCompleters").Equals("")) { rntbExpectedAnnualCompleters.Value = Convert.ToInt32(norco_db.GetPropertyValue(issuedFormId, "ExpectedAnnualCompleters")); }
            //reEnrollmentChanges.Content = norco_db.GetPropertyValue(issuedFormId, "EnrollmentChanges");
            //reInternalDemandDetails.Content = norco_db.GetPropertyValue(issuedFormId, "InternalDemandDetails");
            //reRelatedProgramsOffer.Content = norco_db.GetPropertyValue(issuedFormId, "RelatedProgramsOffer");

            //if (!norco_db.GetPropertyValue(issuedFormId, "EstablishNewDireccion").Equals("")) { rlbEstablishNewDireccion.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "EstablishNewDireccion"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "FulfillCurrentNeed").Equals("")) { rblFulfillCurrentNeed.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "FulfillCurrentNeed"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "CommonSharedCourses").Equals("")) { rblCommonSharedCourses.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "CommonSharedCourses"); }
            //reDescribeShareResources.Content = norco_db.GetPropertyValue(issuedFormId, "DescribeShareResources");
            //if (!norco_db.GetPropertyValue(issuedFormId, "FaceToFace").Equals("")) { rblFaceToFace.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "FaceToFace"); }
            //reFaceToFaceDescription.Content = norco_db.GetPropertyValue(issuedFormId, "FaceToFaceDescription");
            //if (!norco_db.GetPropertyValue(issuedFormId, "OfferedOnline").Equals("")) { rblOfferedOnline.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "OfferedOnline"); }
            //reOfferedOnlineDescription.Content = norco_db.GetPropertyValue(issuedFormId, "OfferedOnlineDescription");
            //if (!norco_db.GetPropertyValue(issuedFormId, "Department").Equals("")) { rcbDepartment.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "Department"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "Division").Equals("")) { rcbDivision.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "Division"); }
            //if (!norco_db.GetPropertyValue(issuedFormId, "Discipline").Equals("")) { rcbDiscipline.SelectedValue = norco_db.GetPropertyValue(issuedFormId, "Discipline"); }
            var queryProps = from issued in norco_db.IssuedFormProperties
                             where issued.UnitID == "WebCMS"
                             where issued.IssuedFormID == issuedFormId
                             select issued;
            foreach (var a in queryProps)
            {
                if (a.PropertyName == "ProgramTitle") { rtProgramTitle.Text = a.PropertyValue; }
                if (a.PropertyName == "TopCode") { if (a.PropertyValue != "") { ddlTopsCode.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "SessionName") { if (a.PropertyValue != "") { rcbSeason.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "AcademicYear") { if (a.PropertyValue != "") { rcbYear.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "CIPCode") { rtbCIPCode.Text = a.PropertyValue; }
                if (a.PropertyName == "SOCCode") { rtbSOCCode.Text = a.PropertyValue; }
                if (a.PropertyName == "ProgramType") { if (a.PropertyValue != "") { rcbProgramType.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "CDCPEligibilityCategory") { if (a.PropertyValue != "") { rblCDCP.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "ProgramGoal") { if (a.PropertyValue != "") { rcbProgramGoal.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "EssentialMisision") { reEssentialMisision.Content = a.PropertyValue; }
                if (a.PropertyName == "DevelopedSLO") { if (a.PropertyValue != "") { rbDevelopedSLO.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "DevelopedSLODescription") { reDevelopedSLO.Content = a.PropertyValue; }
                if (a.PropertyName == "SampleProgramLevel") { reSampleProgramLevel.Content = a.PropertyValue; }
                if (a.PropertyName == "MinimumUnits") { if (a.PropertyValue != "") { rntbMinimumUnits.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "MaximumUnits") { if (a.PropertyValue != "") { rntbMaximumUnits.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "MinimumUnitsDegree") { if (a.PropertyValue != "") { rntbMinimumUnitsDegree.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "MaximumUnitsDegree") { if (a.PropertyValue != "") { rntbMaximumUnitsDegree.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "AnnualCompleters") { if (a.PropertyValue != "") { rntbAnnualCompleters.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "AnualLaborDemand") { if (a.PropertyValue != "") { rntbAnualLaborDemand.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "CTEApprovalDate") { if (a.PropertyValue != "") { rdpCTEApprovalDate.SelectedDate = Convert.ToDateTime(a.PropertyValue); } }
                if (a.PropertyName == "EquipmentRequired") { if (a.PropertyValue != "") { rntbEquipmentRequired.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "RemoledFacilities") { if (a.PropertyValue != "") { rntbRemoledFacilities.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "LibraryAcquisitions") { if (a.PropertyValue != "") { rntbLibraryAcquisitions.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "GainfulEmployment") { if (a.PropertyValue != "") { rblGainfulEmployment.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "Apprenticeship") { if (a.PropertyValue != "") { rblApprenticeship.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "DistanceEducation") { if (a.PropertyValue != "") { rblDistanceEducation.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "BoardApprovalDate") { if (a.PropertyValue != "") { rdpBoardApprovalDate.SelectedDate = Convert.ToDateTime(a.PropertyValue); } }
                if (a.PropertyName == "FacultyWorkload") { if (a.PropertyValue != "") { rntbFacultyWorkload.Value = Convert.ToDouble(a.PropertyValue); } }
                if (a.PropertyName == "FacultyPositions") { if (a.PropertyValue != "") { rntbFacultyPositions.Value = Convert.ToInt32(a.PropertyValue); } }
                if (a.PropertyName == "CatalogDescription") { reCatalogDescription.Content = a.PropertyValue; }
                if (a.PropertyName == "OpportunityThreats") { reOpportunityThreats.Content = a.PropertyValue; }
                if (a.PropertyName == "MasterPlanning") { reMasterPlanning.Content = a.PropertyValue; }
                if (a.PropertyName == "ProgramCost") { reProgramCost.Content = a.PropertyValue; }
                if (a.PropertyName == "AdditionalEquipment") { if (a.PropertyValue != "") { rblAdditionalEquipment.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "AdditionalMaterials") { if (a.PropertyValue != "") { rblAdditionalMaterials.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "AdditionalTravel") { if (a.PropertyValue != "") { rblAdditionalTravel.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "AdditionalLibrary") { if (a.PropertyValue != "") { rblAdditionalLibrary.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "AdditionalSoftware") { if (a.PropertyValue != "") { rblAdditionalSoftware.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "SectionOfferings") { if (a.PropertyValue != "") { rblSectionOfferings.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "ModificationFacilities") { if (a.PropertyValue != "") { rblModificationFacilities.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "SectionOfferingsDescription") { reSectionOfferingsDescription.Content = a.PropertyValue; }
                if (a.PropertyName == "IncreaseTotalStudents") { if (a.PropertyValue != "") { rblIncreaseTotalStudents.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "IncreaseTotalStudentsNumber") { if (a.PropertyValue != "") { rntbIncreaseTotalStudents.Value = Convert.ToInt32(a.PropertyValue); } }
                if (a.PropertyName == "PlanNeededResources") { rePlanNeededResources.Content = a.PropertyValue; }
                if (a.PropertyName == "EnrollmentFulfillNeed") { if (a.PropertyValue != "") { rblEnrollmentFulfillNeed.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "ExpectedAnnualCompleters") { if (a.PropertyValue != "") { rntbExpectedAnnualCompleters.Value = Convert.ToInt32(a.PropertyValue); } }
                if (a.PropertyName == "EnrollmentChanges") { reEnrollmentChanges.Content = a.PropertyValue; }
                if (a.PropertyName == "InternalDemandDetails") { reInternalDemandDetails.Content = a.PropertyValue; }
                if (a.PropertyName == "RelatedProgramsOffer") { reRelatedProgramsOffer.Content = a.PropertyValue; }
                if (a.PropertyName == "EstablishNewDireccion") { if (a.PropertyValue != "") { rlbEstablishNewDireccion.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "FulfillCurrentNeed") { if (a.PropertyValue != "") { rblFulfillCurrentNeed.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "CommonSharedCourses") { if (a.PropertyValue != "") { rblCommonSharedCourses.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "FaceToFace") { if (a.PropertyValue != "") { rblFaceToFace.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "DescribeShareResources") { reDescribeShareResources.Content = a.PropertyValue; }
                if (a.PropertyName == "FaceToFaceDescription") { reFaceToFaceDescription.Content = a.PropertyValue; }
                if (a.PropertyName == "OfferedOnline") { if (a.PropertyValue != "") { rblOfferedOnline.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "OfferedOnlineDescription") { reOfferedOnlineDescription.Content = a.PropertyValue; }
                if (a.PropertyName == "Department") { if (a.PropertyValue != "") { rcbDepartment.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "Division") { if (a.PropertyValue != "") { rcbDivision.SelectedValue = a.PropertyValue; } }
                if (a.PropertyName == "Discipline") { if (a.PropertyValue != "") { rcbDiscipline.SelectedValue = a.PropertyValue; } }
            }
        }

        private void UpdateFileData(string command, int fileId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NORCOConnectionString"].ConnectionString))
            {
                using (SqlCommand comm = new SqlCommand(command, conn))
                {
                    if (fileData != null && fileData.Length > 0)
                    {
                        comm.Parameters.Add(new SqlParameter("id", fileId));
                        comm.Parameters.Add(new SqlParameter("BinaryData", fileData));
                        comm.Parameters.Add(new SqlParameter("FileName", fileName));
                        conn.Open();
                        comm.ExecuteNonQuery();
                    }
                }
            }
        }

        protected void sqlDocuments_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [Documents] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
            }
            rgJustificationDocs.DataBind();
        }
        protected void sqlDocuments_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            fileId = (int)e.Command.Parameters["@InsertedID"].Value;
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [Documents] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
            }
        }
        protected void rgTransferDocuments_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == RadGrid.UpdateCommandName || e.CommandName == RadGrid.PerformInsertCommandName)
            {
                GridEditableItem item = e.Item as GridEditableItem;

                if (!(item is GridEditFormInsertItem))
                {
                    fileId = (int)item.GetDataKeyValue("id");
                }
                var asyncUpload = item["AttachmentColumn"].Controls[0] as RadAsyncUpload;
                if (asyncUpload != null && asyncUpload.UploadedFiles.Count > 0)
                {
                    var uploadedFile = asyncUpload.UploadedFiles[0];
                    if (uploadedFile.FileName.Contains("/") || uploadedFile.FileName.Contains("?") || uploadedFile.FileName.Contains("*") || uploadedFile.FileName.Contains("<") || uploadedFile.FileName.Contains(">") || uploadedFile.FileName.Contains(":") || uploadedFile.FileName.Contains("|") || uploadedFile.FileName.Contains("\\") || uploadedFile.FileName.Contains("\""))
                    {
                        e.Canceled = true;
                        item.FindControl("CancelButton").Parent.Controls.Add(new LiteralControl("<br/><b style='color:red;'>File contains special characters.</b>"));
                    }
                    else
                    {
                        fileData = new byte[uploadedFile.ContentLength];
                        fileName = uploadedFile.FileName.Replace(",", "_").Replace(";", "_");
                        using (Stream str = uploadedFile.InputStream)
                        {
                            str.Read(fileData, 0, (int)uploadedFile.ContentLength);
                        }
                    }
                }
            }
        }
        protected void rgTransferDocuments_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                ScriptManager.GetCurrent(Page).RegisterPostBackControl(item["AttachmentColumn"].Controls[0]);
            }
        }
        protected void sqlTransferDocuments_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            fileId = (int)e.Command.Parameters["@InsertedID"].Value;
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [TransferDocuments] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
            }
        }
        protected void sqlTransferDocuments_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (fileData != null && fileData.Length > 0)
            {
                UpdateFileData("UPDATE [TransferDocuments] SET [BinaryData] = @BinaryData, [FileName] = @FileName WHERE [id] = @id", fileId);
            }
            rgTransferDocuments.DataBind();
        }

        protected void rgJustificationDocs_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                ScriptManager.GetCurrent(Page).RegisterPostBackControl(item["AttachmentColumn"].Controls[0]);
            }
        }
        protected void rgJustificationDocs_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == RadGrid.UpdateCommandName || e.CommandName == RadGrid.PerformInsertCommandName)
            {
                GridEditableItem item = e.Item as GridEditableItem;

                if (!(item is GridEditFormInsertItem))
                {
                    fileId = (int)item.GetDataKeyValue("id");
                }
                var asyncUpload = item["AttachmentColumn"].Controls[0] as RadAsyncUpload;
                if (asyncUpload != null && asyncUpload.UploadedFiles.Count > 0)
                {
                    var uploadedFile = asyncUpload.UploadedFiles[0];
                    fileData = new byte[uploadedFile.ContentLength];
                    fileName = uploadedFile.FileName;
                    using (Stream str = uploadedFile.InputStream)
                    {
                        str.Read(fileData, 0, (int)uploadedFile.ContentLength);
                    }
                }
            }
        }

        public string validateData()
        {
            var errorMessage = "";
            var errorsFound = 0;

            if (rtProgramTitle.Text == "")
            {
                errorMessage = errorMessage + "- Provide a Program Title.<br>";
                errorsFound = errorsFound + 1;
            }
            //if (rtbCIPCode.Text == "")
            //{
            //    errorMessage = errorMessage + "- Provide a CIP Code.<br>";
            //    errorsFound = errorsFound + 1;
            //}
            //if (rtbSOCCode.Text == "")
            //{
            //    errorMessage = errorMessage + "- Provide a SOC Code.<br>";
            //    errorsFound = errorsFound + 1;
            //}
            //if (rcbProgramGoal.SelectedValue == "")
            //{
            //    errorMessage = errorMessage + "- Select a Program Goal.<br>";
            //    errorsFound = errorsFound + 1;
            //}

            if (errorsFound > 0)
            {
                errorMessage = "Error(s) found :<br><br>" + errorMessage + "<br>";

            }
            else
            {
                errorMessage = "No Errors found.<br><br>";
            }

            return errorMessage;
        }

        protected void rbSave_Click(object sender, EventArgs e)
        {
            var errorMessage = validateData();
            var issuedFormId = 0;
            if (hfProgramID.Value != "")
            {
                issuedFormId = Convert.ToInt32(hfIssuedFormId.Value);
                norco_db.UpdateProgram(Convert.ToInt32(hfProgramID.Value), 0, null, rtProgramTitle.Text, null, Convert.ToInt32(rcbDivision.SelectedValue), issuedFormId, "", Convert.ToInt32(rcbProgramGoal.SelectedValue), null, null, "0", Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["UserId"]));
            }
            else
            {
                issuedFormId = norco_db.UpdateBusinessUnits("WebCMS");
                var NewProgram = norco_db.UpdateProgram(null, 0, null, rtProgramTitle.Text, null, Convert.ToInt32(rcbDivision.SelectedValue), issuedFormId, "", Convert.ToInt32(rcbProgramGoal.SelectedValue), null, null, "0", Convert.ToInt32(Session["CollegeID"]), Convert.ToInt32(Session["UserId"]));
                foreach (UpdateProgramResult p in NewProgram)
                {
                    if (p.ProgramID != null) { hfProgramID.Value = p.ProgramID.ToString(); }
                }
                hfIssuedFormId.Value = issuedFormId.ToString();
                setProgramRequirements(Convert.ToInt32(hfProgramID.Value), Convert.ToInt32(Session["UserId"]));
            }
            updateProgramProperties(Convert.ToInt32(Session["UserId"]), issuedFormId, "WebCMS");
            DisplayMessage(false, errorMessage + "Program information was succesfully updated.");
        }

        public void updateProgramProperties(int UserId, int IssueFormID, string unitID)
        {
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "ProgramTitle", rtProgramTitle.Text);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "Department", rcbDepartment.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "TopCode", ddlTopsCode.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "CDCPEligibilityCategory", rblCDCP.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "EssentialMisision", reEssentialMisision.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "Discipline", rcbDiscipline.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "Division", rcbDivision.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "SessionName", rcbSeason.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "AcademicYear", rcbYear.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "CIPCode", rtbCIPCode.Text);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "SOCCode", rtbSOCCode.Text);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "ProgramType", rcbProgramType.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "ProgramGoal", rcbProgramGoal.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "DevelopedSLO", rbDevelopedSLO.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "DevelopedSLODescription", reDevelopedSLO.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "SampleProgramLevel", reSampleProgramLevel.Content);
            //norco_db.UpdateProperties(UserId,unitID, IssueFormID, "MinimumUnits", rntbMinimumUnits.Value.ToString());
            //norco_db.UpdateProperties(UserId,unitID, IssueFormID, "MaximumUnits", rntbMaximumUnits.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "MinimumUnitsDegree", rntbMinimumUnitsDegree.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "MaximumUnitsDegree", rntbMaximumUnitsDegree.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "AnnualCompleters", rntbAnnualCompleters.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "AnualLaborDemand", rntbAnualLaborDemand.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "CTEApprovalDate", rdpCTEApprovalDate.SelectedDate.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "EquipmentRequired", rntbEquipmentRequired.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "RemoledFacilities", rntbRemoledFacilities.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "LibraryAcquisitions", rntbLibraryAcquisitions.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "GainfulEmployment", rblGainfulEmployment.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "Apprenticeship", rblApprenticeship.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "DistanceEducation", rblDistanceEducation.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "BoardApprovalDate", rdpBoardApprovalDate.SelectedDate.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "FacultyWorkload", rntbFacultyWorkload.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "FacultyPositions", rntbFacultyPositions.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "CatalogDescription", reCatalogDescription.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "OpportunityThreats", reOpportunityThreats.Content);

            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "MasterPlanning", reMasterPlanning.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "ProgramCost", reProgramCost.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "AdditionalEquipment", rblAdditionalEquipment.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "AdditionalMaterials", rblAdditionalMaterials.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "ModificationFacilities", rblModificationFacilities.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "AdditionalTravel", rblAdditionalTravel.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "AdditionalLibrary", rblAdditionalLibrary.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "AdditionalSoftware", rblAdditionalSoftware.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "SectionOfferings", rblSectionOfferings.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "SectionOfferingsDescription", reSectionOfferingsDescription.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "IncreaseTotalStudents", rblIncreaseTotalStudents.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "IncreaseTotalStudentsNumber", rntbIncreaseTotalStudents.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "PlanNeededResources", rePlanNeededResources.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "EnrollmentFulfillNeed", rblEnrollmentFulfillNeed.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "ExpectedAnnualCompleters", rntbExpectedAnnualCompleters.Value.ToString());
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "EnrollmentChanges", reEnrollmentChanges.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "InternalDemandDetails", reInternalDemandDetails.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "RelatedProgramsOffer", reRelatedProgramsOffer.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "EstablishNewDireccion", rlbEstablishNewDireccion.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "FulfillCurrentNeed", rblFulfillCurrentNeed.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "CommonSharedCourses", rblCommonSharedCourses.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "DescribeShareResources", reDescribeShareResources.Content);

            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "FaceToFace", rblFaceToFace.SelectedValue);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "OfferedOnline", rblOfferedOnline.SelectedValue);

            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "FaceToFaceDescription", reFaceToFaceDescription.Content);
            norco_db.UpdateProperties(UserId, unitID, IssueFormID, "OfferedOnlineDescription", reOfferedOnlineDescription.Content);
        }

        public void setProgramRequirements(Int32 tempProgramID, Int32 _userId)
        {
            norco_db.addProgramGroup(tempProgramID, 1, 0, 1, 0, "REQUIRED COURSES WITHOUT OPTIONS", _userId);
            norco_db.addProgramGroup(tempProgramID, 1, 1, 1, 0, "REQUIRED COURSES WITH OPTIONS", _userId);
            var loopSem = -1;
            var tmpSemDescription = "";
            var programcourse_id = 0;
            var qSemesters = from sem in norco_db.tblLookupSemesters
                             orderby sem.iorder
                             select new { sem };
            foreach (var s in qSemesters)
            {
                loopSem = loopSem + 1;
                tmpSemDescription = s.sem.description;
                var newGroup = norco_db.addProgramGroup(tempProgramID, 3, loopSem, 1, 0, tmpSemDescription, _userId);
                foreach (addProgramGroupResult group in newGroup)
                {
                    programcourse_id = (int)group.ProgramCourseID;
                }
                loopSem += 1;
                norco_db.addProgramGroup(tempProgramID, 3, loopSem, 2, programcourse_id, "Required", _userId);
                loopSem += 1;
                norco_db.addProgramGroup(tempProgramID, 3, loopSem, 2, programcourse_id, "Required (Options)", _userId);
                loopSem += 1;
                norco_db.addProgramGroup(tempProgramID, 3, loopSem, 2, programcourse_id, "Elective", _userId);
            }
        }

    }
}