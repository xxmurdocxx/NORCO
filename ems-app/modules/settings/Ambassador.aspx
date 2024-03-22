<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Ambassador.aspx.cs" Inherits="ems_app.modules.settings.Ambassador" %>

<%@ Register Src="~/UserControls/DataUpdateChoice.ascx" TagPrefix="uc" TagName="DataUploadChoice" %>
<%@ Register Src="~/UserControls/CourseEdit.ascx" TagPrefix="uc" TagName="CourseEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/intro.js/4.3.0/introjs.min.css" rel="stylesheet" />
    <style>
        .RadWizard .rwzContent {
            overflow: hidden !important;
        }

        .introjs-tooltip {
            max-width: fit-content !important;
            max-width: fit-content !important;
            min-width: 450px !important;
        }

        .introjs-tooltiptext {
            font-size: 14px !important;
        }

        .RadToolTip.rtRoundedCorner .rtContent {
            margin-right: 20px;
        }

        .SignUpImageMargin {
            margin-top: 200px;
        }

        .rbShowAll {
            padding: 5px !important;
        }

        .checkboxStage label {
            display: none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" id="SystemTitle" runat="server">MAP Ambassador</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hfAmbassadorSetupID" runat="server" />
    <div class="row d-flex justify-content-end">
        <telerik:RadLabel ID="RadLabel1" runat="server" Text="Show Tooltips" Width="100px"></telerik:RadLabel>
        <telerik:RadSwitch ID="rsTooltips" runat="server" Width="65px" AutoPostBack="true" Checked="true" OnCheckedChanged="rsTooltips_CheckedChanged">
            <ToggleStates>
                <ToggleStateOn Text="Yes" />
                <ToggleStateOff Text="No" />
            </ToggleStates>
        </telerik:RadSwitch>
    </div>
    <telerik:RadWizard RenderMode="Lightweight" ID="RadWizard1" runat="server" Width="100%" Skin="Material" OnActiveStepChanged="RadWizard1_ActiveStepChanged">
        <WizardSteps>
            <telerik:RadWizardStep Title="Contact Log" StepType="Start" CssClass="additional-information">
                <asp:Panel runat="server" ID="pnlAdditionalContacts" CssClass="row">
                    <div class="col-4">
                        <fieldset class="map-workflow">
                            <h2 id="legendMapWorkflow" style="font-size: 18px !important; padding: 10px 0;" runat="server">MAP Workflow <span style="font-size: 13px !important;"><i class='fa fa-question-circle'></i></span></h2>
                            <telerik:RadToolTip ManualClose="true" ID="RadToolTip1" TargetControlID="legendMapWorkflow" runat="server" Text="The workflow consists of users who have an active role assignment within MAP.  This list can help keep record of the primary user in each role. There are 5 user types to which a person can be assigned: Ambassador, Evaluator, Faculty, Articulation Officer, Implementation. Multiple people can be placed in each role. To assign user roles, visit the User module under Settings within the Main Menu." Width="500px"></telerik:RadToolTip>
                            <div class="row">
                                <div class="col-3 d-flex align-items-end">
                                    <label>MAP Ambassador (Yourself)</label>
                                </div>
                                <div class="col-9">
                                    <telerik:RadTextBox ID="rtbLeadManager" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconMAPAmbassador" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttMAPAMbassador" TargetControlID="iconMAPAmbassador" runat="server" Text="The MAP Ambassador is the lead for the college MAP team. This role serves as the main point of contact with the statewide MAP Initiative Team and coordinator for the local college team. This role develops general knowledge of all MAP designated roles and tasks. The MAP Ambassador stays in contact with MAP Initiative Team to discuss updates, plans, training opportunities, and generate new ideas to maximize CPL for students." Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-3 d-flex align-items-end">
                                    <label>MAP Ambassador Email</label>
                                </div>
                                <div class="col-9">
                                    <telerik:RadTextBox ID="rtbLeadManagerEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-3 d-flex align-items-end">
                                    <label>Evaluator</label>
                                </div>
                                <div class="col-9">
                                    <telerik:RadTextBox ID="rtbLeadEvaluator" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconEvaluator" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttEvaluator" TargetControlID="iconEvaluator" runat="server" Text="Not all colleges have an Evaluator assigned to this role. Some rely on a counselor, articulation officer, or A&R staff for this function. Whether it is an evaluator or counselor or otherwise, the role plays a key part in the success of the MAP process. The Evaluator relies on their expertise in creating equivalencies to use MAP to link (or map) college courses with the appropriate credit recommendations. In MAP, these linkages are called Articulation Recommendations (ARs). Once an AR is created, it is automatically forwarded in the approval queue to the next approver (faculty in most cases)." Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-3 d-flex align-items-end">
                                    <label>Evaluator Email</label>
                                </div>
                                <div class="col-9">
                                    <telerik:RadTextBox ID="rtbLeadEvaluatorEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-3 d-flex align-items-end">
                                    <label>Faculty Lead</label>
                                </div>
                                <div class="col-9">
                                    <telerik:RadTextBox ID="rtbFacultyLead" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconFaculty" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttFaculty" TargetControlID="iconFaculty" runat="server" Text="Not all colleges will have a MAP Faculty Lead assigned to this role. Instead, some colleges may divide the responsibilities among several Faculty Discipline Approvers.  Whether it is a MAP Faculty Lead or otherwise, the role is vitally important to ensure academic integrity of the approval process. The MAP Faculty Lead works with colleagues from a variety of disciplines to help them understand the MAP approval process for Military Credit for Prior Learning (MilCPL) and other Credit for Prior Learning (CPL). The overall goal is to build understanding and support for MilCPL and CPL while assisting faculty approvers to complete (or adopt) articulations for all possible courses at the college. " Width="500px">
                                    </telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-3 d-flex align-items-end">
                                    <label>Faculty Lead Email</label>
                                </div>
                                <div class="col-9">
                                    <telerik:RadTextBox ID="rtbFacultyLeadEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-3 d-flex align-items-end">
                                    <label>Articulation Officer</label>
                                </div>
                                <div class="col-9">
                                    <telerik:RadTextBox ID="rtbArticulationOfficer" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconArticulationOfficer" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttArticulationOffier" TargetControlID="iconArticulationOfficer" runat="server" Text="Not all colleges have an Articulation Officer assigned to this role. Some colleges may choose to bypass this step in the 4-tier approval process; others may assign a counselor to add notes to articulation decisions in MAP.  Whether it is an articulation officer or a counselor or otherwise, the role is important to ensure that all transfer considerations are noted on approved articulations. The Articulation Officer reviews faculty approved articulations and adds notes or considerations with respect to transferability of the articulated credit. These notes are available to counselors and evaluators as they apply CPL to student records." Width="500px">
                                    </telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-3 d-flex align-items-end">
                                    <label>Articulation Officer Email</label>
                                </div>
                                <div class="col-9">
                                    <telerik:RadTextBox ID="rtbArticulationOfficerEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                    <div class="col-4">
                        <fieldset class="veterans-resources">
                            <h2 id="legendVeteranResource" style="font-size: 18px !important; padding: 10px 0;" runat="server">Veterans Resource <span style="font-size: 13px !important;"><i class='fa fa-question-circle'></i></span></h2>
                            <telerik:RadToolTip ManualClose="true" ID="RadToolTip2" TargetControlID="legendVeteranResource" runat="server" Text="These representatives are the heart of military CPL at your campus. These contacts know the veteran student population and understand the skill sets they possess upon enrollment. Regarding articulation, these MAP team members are a vital resource in translating military learning to course credits." Width="500px"></telerik:RadToolTip>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>VPAA</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbVPAA" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconVPAA" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttVPAA" TargetControlID="iconVPAA" runat="server" Text="The Vice President of Academic Affairs may or may not serve as the MAP Ambassador. Nevertheless, the VPAA plays a vital role in providing support and advocacy for CPL collegewide. If articulations are included in the Curriculum Committee consent agenda approval process, the VPAA may facilitate this. This role facilitates the appointment process for the various MAP roles and often makes determinations concerning funding from a variety of sources (SEA, SWF, HEERF, Grants, Foundation Grants) to support articulation activities." Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>VPAA Email</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbVPAAEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>School Certifying Official</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbSchoolCertifyngOfficial" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconSchoolCert" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttSchoolCert" TargetControlID="iconSchoolCert" runat="server" Text="The School Certifying Official (SCO) will be responsible for all VA related matters that include certifying veterans utilizing educational benefits. SCO will provide general information on educational benefits and Credit for Prior Learning (CPL). The overall goal is to recruit and retain veterans by introducing MAP and utilizing outreach methods. " Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>School Certifying Official Email</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbVeteranSchgoolCertifying" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>Veteran Rep/Counselor</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbVRCOfficial" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconVetRep" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttVetRep" TargetControlID="iconVetRep" runat="server" Text="The JST Recipient will be notified when a potential student performs a search from the public <a href='https://veteransmapsearch.azurewebsites.net/default.aspx' target='_blank' style='text-decoration:underline;'>MAP Search Tool</a>. This user will require access to JST records within the Student Intake and should therefore be assigned the Ambassador or Evaluator role. This person should work closely with the veteran population on your campus (i.e. Veterans Counselor or School Certifying Official)." Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>Veteran Rep Email</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbVRCOfficialEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                        </fieldset>

                    </div>
                    <div class="col-4">
                        <fieldset class="institution-contacts">
                            <h2 id="legendInstitutionContacts" style="font-size: 18px !important; padding: 10px 0;" runat="server">Institution Contacts <span style="font-size: 13px !important;"><i class='fa fa-question-circle'></i></span></h2>
                            <telerik:RadToolTip ManualClose="true" ID="RadToolTip3" TargetControlID="legendInstitutionContacts" runat="server" Text="Individuals who may not necessarily have an active role in using the MAP Application but are part of the MAP Team at their college to promote CPL for their institution. Some roles within the institution contacts may need view access only to keep track of the CPL credits being awarded at their institutions." Width="500px"></telerik:RadToolTip>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>Primary Contact</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbPrimaryContact" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconPrimaryContact" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttPrimaryContact" TargetControlID="iconPrimaryContact" runat="server" Text="This role serves as the primary point of contact with the MAP Leadership Team. Most often, the MAP Ambassador serves in this role. The primary contact forwards communications and information to college team members as needed and serves as a single point of contact between the colleges and the MAP." Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>Primary Contact Email</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbPrimaryContactEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>Academic Senate President</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbAcademicSenatePresident" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconAcademicSenate" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttAcademicSenate" TargetControlID="iconAcademicSenate" runat="server" Text="The Academic Senate President plays a critical role in ensuring that policies and procedures associated with CPL are maintained at the college and district. MAP is unique in that it fundamentally relies on faculty for support and approval of CPL at the college. This is in alignment with participatory governance and 10+1. The Senate President sets the campus tone concerning the equitable acceptance of CPL at the college. Because not all faculty are familiar with the benefits of CPL for adult learners, nor the positive equity impact of CPL, we rely on the Senate leadership to educate and advocate for CPL among faculty colleagues." Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>Academic Senate President Email</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbAcademicSenatePresidentEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>College President</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbCEO" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconCollegePresident" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttCollegePresident" TargetControlID="iconCollegePresident" runat="server" Text="The President/CEO supports the MAP Initiative vision to maximize CPL for veteran and other students by facilitating policy and procedure changes needed to advance CPL both locally and statewide." Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>College President Email</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbCEOEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>Curriculum Specialist</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbITContact" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconCurriculumSpecialist" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttCurriculumSpecialist" TargetControlID="iconCurriculumSpecialist" runat="server" Text="The IT Contact is important during the initial configuration of MAP at the college. Because MAP can be used without additional course and program data (in vanilla form), the IT Contact may not be needed. For colleges that wish to include more complete course and program data (Course descriptions, SLOs, Courses in Programs, Cross Listed Course data, etc.), the It Contact will provide institution’s API integration or upload flat (csv) files directly into MAP.  Beyond providing periodic updates, IT Contact will have little to no responsibilities.  " Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>Curriculum Specialist Email</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbITContactEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
			                <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>VPSS</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbVPSS" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                    <asp:Label runat="server" ID="iconVPSS" Text="<i class='fa fa-question-circle'></i>" />
                                    <telerik:RadToolTip ManualClose="true" ID="rttVPSS" TargetControlID="iconVPSS" runat="server" Text="The Vice President of Student Services (VPSS) plays a vital role in providing support and advocacy for CPL collegewide. The VPSS often oversees important CPL areas such as the Veterans Resource Center, Counseling, A&amp;R, and outreach. This role facilitates the appointment process for the various MAP roles (evaluator, counselor, articulation officer) and often makes determinations concerning funding from a variety of sources to support CPL activities." Width="500px"></telerik:RadToolTip>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4 d-flex align-items-end">
                                    <label>VPSS Email</label>
                                </div>
                                <div class="col-8">
                                    <telerik:RadTextBox ID="rtbVPSSEmail" runat="server" Width="90%" CssClass="mt-1 mb-1"></telerik:RadTextBox>
                                </div>
                            </div>
                            <telerik:RadTextBox ID="rtbStatus" runat="server" Visible="false" Label="Status" Width="90%" CssClass="mt-1 mb-1" Display="false"></telerik:RadTextBox>
                            <telerik:RadTextBox ID="rtbVeterans" runat="server" Visible="false" Label="Veterans" Width="90%" CssClass="mt-1 mb-1" Display="false"></telerik:RadTextBox>
                        </fieldset>

                    </div>
                </asp:Panel>
            </telerik:RadWizardStep>
            <telerik:RadWizardStep Title="Set Up Workflow/Users" CssClass="workflow-configuration">
                <div class="row">
                    <div class="col-12">
                        <asp:SqlDataSource ID="sqlWorkflow" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.id, r.RoleName, s.BypassStage, r.RoleDescription, s.AutoApprovalNumberOfDays, sat.ApprovalTypeDescription from Stages s left outer join ROLES r on s.RoleId = r.RoleID left outer join StageApprovalType sat on s.EnforceApproval = sat.EnforceApproval and isnull(s.AutoApprovalNumberOfDays, 0) = isnull(sat.AutoApprovalNumberOfDays, 0) where s.CollegeId = @CollegeID order by s.[Order]" UpdateCommand="UPDATE Stages SET BypassStage = @BypassStage, EnforceApproval = case when @AutoApprovalNumberOfDays > 0 then 0 else 1 end, AutoApprovalNumberOfDays = @AutoApprovalNumberOfDays WHERE id=@id">
                            <SelectParameters>
                                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="id" Type="Int32" />
                                <asp:Parameter Name="BypassStage" Type="Boolean" />
                                <asp:Parameter Name="AutoApprovalNumberOfDays" Type="Int32" />
                            </UpdateParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="sqlStageApprovalType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select AutoApprovalNumberOfDays, ApprovalTypeDescription from StageApprovalType order by ID"></asp:SqlDataSource>
                        <p>
                            <asp:CheckBox runat="server" ID="chkSharedCurriculum" AutoPostBack="true" OnCheckedChanged="chkSharedCurriculum_CheckedChanged" />
                            Check here if you have a shared curriculum within any other college within your district?
                        </p>
                        <asp:Panel ID="pnlSharedCurriculum" runat="server">
                            <p style="margin-left: 20px;">
                                <asp:CheckBox runat="server" ID="chkAutoApproveByMajority" AutoPostBack="true" OnCheckedChanged="chkAutoApproveByMajority_CheckedChanged" />
                                If your college is part of a district and a majority (50+1%) of campuses within your district approves an articulation, it can be automatically moved forward at your college. Check this box to apply this rule.
                            </p>
                            <p style="margin-left: 20px;">
                                <asp:CheckBox runat="server" ID="chkAutoAdoptArticulations" AutoPostBack="true" OnCheckedChanged="chkAutoAdoptArticulations_CheckedChanged" />
                                Auto-Adopt Articulations from sister college and get notification mail
                            </p>
                            <p style="margin-left: 20px;">
                                <asp:CheckBox runat="server" ID="chkAllowFacultyNotifications" AutoPostBack="true" OnCheckedChanged="chkAllowFacultyNotifications_CheckedChanged" />
                                Allow Faculty Notification where Faculty of sister college gets notified
                            </p>
                        </asp:Panel>
                        
                            <div style="display:none;">
                                <p>
                            <asp:CheckBox runat="server" ID="chkAutoPublish" AutoPostBack="true" OnCheckedChanged="chkAutoPublish_CheckedChanged" />
                            Finalized articulations should be published during the final, or Implementation, stage within MAP. Ambassadors can customize the option to “Publish” articulations automatically as they reach the final implementation stage. Check this box to enable the automatic publish feature.</p>
                            </div>
                        
                        <p>
                            <asp:CheckBox runat="server" ID="chckAllowEmailNotif" AutoPostBack="true" OnCheckedChanged="chkSetAllowEmailNoti_CheckedChanged" />
                            Allow Email Batch Notification
                        </p>
                        <p>
                            <asp:CheckBox runat="server" ID="chckAllowEmailNotifTriggered" AutoPostBack="true" OnCheckedChanged="chkSetAllowEmailNotiTrig_CheckedChanged" />
                            Allow Email Notification Triggered by Approve or Deny
                        </p>
                        <asp:Panel ID="pnlSendEmailButton" runat="server">
                            <p>
                                <telerik:RadButton ID="RadButton1" runat="server" Text="Send Email Batch Notifications Now" Width="180px" Primary="true" OnClick="rbSend_Noti_Click" AutoPostBack="true" CssClass="m-3"></telerik:RadButton>
                            </p>
                        </asp:Panel>


                        <%--                        <telerik:RadNotification ID="RadNotification1" runat="server" EnableRoundedCorners="true" Width="400px" Height="120px"
                            Skin="Web20" Position="Center" OffsetY="50" AutoCloseDelay="5000">
                        </telerik:RadNotification>--%>

                        <telerik:RadNotification ID="RadNotification1" runat="server" EnableRoundedCorners="true" Width="400px" Height="120px" Position="Center" OffsetY="50" AutoCloseDelay="5000">
                        </telerik:RadNotification>


                        <telerik:RadGrid ID="rgWorkflow" runat="server" CellSpacing="-1" DataSourceID="sqlWorkflow" Width="100%" AllowAutomaticUpdates="true" PageSize="20" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" AllowFilteringByColumn="false" OnItemDataBound="rgWorkflow_ItemDataBound">
                            <GroupingSettings CaseSensitive="false" />
                            <ExportSettings IgnorePaging="true" ExportOnlyData="true">
                            </ExportSettings>
                            <ClientSettings>
                                <Selecting AllowRowSelect="True" />
                            </ClientSettings>
                            <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlWorkflow" DataKeyNames="id" CommandItemDisplay="Top" EditMode="Batch" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel">
                                <NoRecordsTemplate>
                                    <p>No records to display</p>
                                </NoRecordsTemplate>
                                <BatchEditingSettings EditType="Cell" />
                                <Columns>
                                    <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="RoleName" HeaderText="Approval Stage" DataField="RoleName" UniqueName="Stage" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="190px" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="false" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="RoleDescription" HeaderText="Description" DataField="RoleDescription" UniqueName="RoleDescription" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="300px" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="false" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn DataField="AutoApprovalNumberOfDays" DataType="System.Int32" HeaderText="No Approval Needed" HeaderStyle-Width="250px" ItemStyle-HorizontalAlign="Left" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="workflow-noapprovalneeded" Display="false">
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="lblApprovalType" Text='<%# Eval("ApprovalTypeDescription") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList runat="server" ID="ddlApprovalType" DataSourceID="sqlStageApprovalType" DataValueField="AutoApprovalNumberOfDays" DataTextField="ApprovalTypeDescription"></telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridTemplateColumn DataField="BypassStage" DataType="System.Boolean" HeaderText="Bypass Stage" UniqueName="BypassStage" HeaderStyle-Width="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="workflow-bypassstage">
                                        <ItemTemplate>
                                            <asp:CheckBox runat="server" ID="CheckBox1" Text='Test' Enabled="true" Checked='<%# Convert.ToBoolean(Eval("BypassStage")) %>' onclick="checkBoxClick(this, event);" CssClass="checkboxStage" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:CheckBox runat="server" ID="CheckBox2" />
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
                    <div class="col-12 text-right">
                        <telerik:RadLinkButton ID="RadLinkButton1" runat="server" Text="Add Users" Font-Bold="true" NavigateUrl="~/modules/security/Users.aspx" Target="_blank" CssClass="add-users"></telerik:RadLinkButton>
                        <telerik:RadLinkButton ID="RadLinkButton2" runat="server" Text="Configure Veteran Letter Template" Font-Bold="true" NavigateUrl="~/modules/settings/Templates.aspx" Target="_blank" CssClass="VeteranLetter" Visible="false"></telerik:RadLinkButton>
                    </div>
                </div>
            </telerik:RadWizardStep>
            <telerik:RadWizardStep Title="College Data" ValidationGroup="CollegeSetup" CausesValidation="true" CssClass="college-setup">
                <div class="row">

                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbMyNotifications" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Course Catalog" Expanded="true" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center bg-light">
                                        <div class="col-3">
                                            Catalog Description
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <div class="row">
                                        <div class="col-8">
                                            <uc:CourseEdit runat="server" ID="ucCourseEdit"></uc:CourseEdit>
                                        </div>
                                        <div class="col-4">
                                            <uc:DataUploadChoice runat="server" ID="ducCourses" OnFileUploaded="ducCourses_FileUploaded"></uc:DataUploadChoice>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <asp:SqlDataSource ID="sqlSLO" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select SU.[subject], CIF.course_number, CONCAT(SU.[subject], ' ', CIF.course_number) as Course,  SLODescription, SLOSorder,dbo.[udf_ExpandDigits](course_number, 5, '0') as CourseNbr from StudentLearningOutcome S LEFT OUTER JOIN Course_IssuedForm CIF ON S.outline_id = CIF.outline_id LEFT OUTER JOIN tblSubjects SU ON CIF.subject_id = SU.subject_id WHERE CIF.college_id = @CollegeID order by SU.Subject, dbo.[udf_ExpandDigits](course_number, 5, '0'), SLOSorder">
                        <SelectParameters>
                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbSLOs" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Course Student Learning Outcomes" Expanded="true" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center bg-light">
                                        <div class="col-3">
                                            Course Student Learning Outcomes
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <div class="row">
                                        <div class="col-8">
                                            <telerik:RadGrid ID="rgSLOs" runat="server" CellSpacing="-1" DataSourceID="sqlSLO" Width="100%" PageSize="20" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" AllowFilteringByColumn="false">
                                                <GroupingSettings CaseSensitive="false" />
                                                <ExportSettings IgnorePaging="true" ExportOnlyData="true">
                                                </ExportSettings>
                                                <ClientSettings>
                                                    <Selecting AllowRowSelect="True" />
                                                    <ClientEvents />
                                                </ClientSettings>
                                                <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlSLO" CommandItemDisplay="Top" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel">
                                                    <NoRecordsTemplate>
                                                        <p>No records to display</p>
                                                    </NoRecordsTemplate>
                                                    <BatchEditingSettings EditType="Cell" />
                                                    <Columns>
                                                        <telerik:GridBoundColumn SortExpression="subject" HeaderText="Subject" DataField="subject" UniqueName="subject" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="Course" HeaderText="Course" DataField="Course" UniqueName="Course" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="SLODescription" HeaderText="SLO Description" DataField="SLODescription" UniqueName="SLODescription" HeaderStyle-Width="300px" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="SLOSorder" HeaderText="Order" DataField="SLOSorder" UniqueName="SLOSorder" HeaderStyle-Width="60px" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridBoundColumn>
                                                    </Columns>
                                                </MasterTableView>
                                            </telerik:RadGrid>
                                        </div>
                                        <div class="col-4">
                                            <uc:DataUploadChoice runat="server" ID="ducSLOs" OnFileUploaded="ducSLOs_FileUploaded"></uc:DataUploadChoice>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <asp:SqlDataSource ID="sqlCrossListed" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select SU.subject, CIF.course_number, CONCAT(SU.subject, ' ', CIF.course_number) AS ParentCourse, CHSU.subject child_subject, CHCIF.course_number child_course_number, CONCAT(CHSU.subject, ' ', CHCIF.course_number) AS ChildCourse, CL.iOrder from CrossListing CL LEFT OUTER JOIN Course_IssuedForm CIF ON CL.outline_id = CIF.outline_id LEFT OUTER JOIN tblSubjects SU ON CIF.subject_id = SU.subject_id  LEFT OUTER JOIN Course_IssuedForm CHCIF ON CL.child_outline_id = CHCIF.outline_id LEFT OUTER JOIN tblSubjects CHSU ON CHCIF.subject_id = CHSU.subject_id WHERE CL.collegeid = @CollegeID ORDER BY ParentCourse, ChildCourse">
                        <SelectParameters>
                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbCrossListed" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Course Cross Listed Families" Expanded="true" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center bg-light">
                                        <div class="col-3">
                                            Course Cross Listed Families
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <div class="row">
                                        <div class="col-8">
                                            <telerik:RadGrid ID="rgCrossListed" runat="server" CellSpacing="-1" DataSourceID="sqlCrossListed" Width="100%" PageSize="20" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" AllowFilteringByColumn="false">
                                                <GroupingSettings CaseSensitive="false" />
                                                <ExportSettings IgnorePaging="true" ExportOnlyData="true">
                                                </ExportSettings>
                                                <ClientSettings>
                                                    <Selecting AllowRowSelect="True" />
                                                    <ClientEvents />
                                                </ClientSettings>
                                                <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlCrossListed" CommandItemDisplay="Top" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel">
                                                    <NoRecordsTemplate>
                                                        <p>No records to display</p>
                                                    </NoRecordsTemplate>
                                                    <BatchEditingSettings EditType="Cell" />
                                                    <ColumnGroups>
                                                        <telerik:GridColumnGroup HeaderText="Parent" Name="Parent" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridColumnGroup>
                                                        <telerik:GridColumnGroup HeaderText="Child" Name="Child" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridColumnGroup>
                                                    </ColumnGroups>
                                                    <Columns>
                                                        <telerik:GridBoundColumn SortExpression="subject" HeaderText="Subject" DataField="subject" UniqueName="subject" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ColumnGroupName="Parent" HeaderTooltip="Dept. Name (CB00)" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ColumnGroupName="Parent" HeaderTooltip="Dept. # (CB01A)" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="ParentCourse" HeaderText="Course" DataField="ParentCourse" UniqueName="ParentCourse" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ColumnGroupName="Parent" ReadOnly="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="child_subject" HeaderText="Subject" DataField="child_subject" UniqueName="child_subject" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ColumnGroupName="Child" HeaderTooltip="Dept. Name (CB00)" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="child_course_number" HeaderText="Course Number" DataField="child_course_number" UniqueName="child_course_number" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ColumnGroupName="Child" HeaderTooltip="Dept. # (CB01A)" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="ChildCourse" HeaderText="Course" DataField="ChildCourse" UniqueName="ChildCourse" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ColumnGroupName="Child" ReadOnly="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="iOrder" HeaderText="Order" DataField="iOrder" UniqueName="iOrder" HeaderStyle-Width="60px" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridBoundColumn>
                                                    </Columns>
                                                </MasterTableView>
                                            </telerik:RadGrid>
                                        </div>
                                        <div class="col-4">
                                            <uc:DataUploadChoice runat="server" ID="ducCrossListed" OnFileUploaded="ducCrossListed_FileUploaded"></uc:DataUploadChoice>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbDefaultAreaE" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Default Area E Global Credit" Expanded="false" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center bg-light">
                                        <div class="col-3">
                                            Default Area Credit
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <asp:SqlDataSource ID="sqlCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select c.outline_id, CONCAT(s.subject, ' ', c.course_number, ' ', c.course_title, ' - Units : ', u.unit) Description from Course_IssuedForm c join tblSubjects s on c.subject_id = s.subject_id join tblLookupUnits u on c.unit_id = u.unit_id  where c.CourseType = 1 and c.[status] = 0 and c.college_id = @CollegeID order by s.subject, c.course_number">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select unit_id, CAST(unit AS decimal(18, 1)) AS unit, default_value, college_id, secondary_key from tblLookupUnits order by unit"></asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlAreaCreditType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from AreaCreditType"></asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlDefaultAreaEGlobalCredit" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ac.ID, ac.CollegeID, ac.Area, ac.Min_Unit_id, ac.Max_Unit_id, ac.WaiveAreaERequirement, ac.AreaCreditTypeID, ac.Title, ac.TranscriptCode, ac.Link, ac.Notes, ac.CPLUnitLimit, ac.Outline_id, act.AreaCreditType, concat(s.subject,'-',c.course_number,' ',c.course_title) 'CourseName' from DefaultAreaEGlobalCredit ac left outer join AreaCreditType act on ac.AreaCreditTypeID = act.AreaCreditTypeID left outer join Course_IssuedForm c on ac.Outline_id = c.outline_id left outer join tblSubjects s on c.subject_id = s.subject_id where CollegeID = @CollegeID" DeleteCommand="DELETE FROM DefaultAreaEGlobalCredit WHERE ID = @ID" UpdateCommand="UPDATE [dbo].[DefaultAreaEGlobalCredit] SET [Area] = @Area ,[Min_Unit_id] = @Min_Unit_id ,[Max_Unit_id] = @Max_Unit_id ,[WaiveAreaERequirement] = @WaiveAreaERequirement ,[AreaCreditTypeID] = @AreaCreditTypeID ,[Title] = @Title ,[TranscriptCode] = @TranscriptCode ,[Link] = @Link ,[Notes] = @Notes ,[CPLUnitLimit] = @CPLUnitLimit ,[Outline_id] = @Outline_id WHERE ID = @ID" InsertCommand="INSERT INTO [dbo].[DefaultAreaEGlobalCredit] ([CollegeID] ,[Area] ,[Min_Unit_id] ,[Max_Unit_id] ,[WaiveAreaERequirement] ,[AreaCreditTypeID] ,[Title] ,[TranscriptCode] ,[Link] ,[Notes] ,[CPLUnitLimit] ,[Outline_id]) VALUES (@CollegeID ,@Area ,@Min_Unit_id ,@Max_Unit_id ,@WaiveAreaERequirement ,@AreaCreditTypeID ,@Title ,@TranscriptCode ,@Link ,@Notes ,@CPLUnitLimit ,@Outline_id)">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                                        </SelectParameters>
                                        <InsertParameters>
                                            <asp:Parameter Name="Area" Type="String" />
                                            <asp:Parameter Name="Min_Unit_id" Type="Int32" />
                                            <asp:Parameter Name="Max_Unit_id" Type="Int32" />
                                            <asp:Parameter Name="WaiveAreaERequirement" Type="Boolean" />
                                            <asp:Parameter Name="AreaCreditTypeID" Type="Int32" />
                                            <asp:Parameter Name="Title" Type="String" />
                                            <asp:Parameter Name="TranscriptCode" Type="String" />
                                            <asp:Parameter Name="Link" Type="String" />
                                            <asp:Parameter Name="Notes" Type="String" />
                                            <asp:Parameter Name="Outline_id" Type="Int32" />
                                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                                        </InsertParameters>
                                        <UpdateParameters>
                                            <asp:Parameter Name="Area" Type="String" />
                                            <asp:Parameter Name="Min_Unit_id" Type="Int32" />
                                            <asp:Parameter Name="Max_Unit_id" Type="Int32" />
                                            <asp:Parameter Name="WaiveAreaERequirement" Type="Boolean" />
                                            <asp:Parameter Name="AreaCreditTypeID" Type="Int32" />
                                            <asp:Parameter Name="Title" Type="String" />
                                            <asp:Parameter Name="TranscriptCode" Type="String" />
                                            <asp:Parameter Name="Link" Type="String" />
                                            <asp:Parameter Name="Notes" Type="String" />
                                            <asp:Parameter Name="Outline_id" Type="Int32" />
                                            <asp:Parameter Name="ID" Type="Int32" />
                                        </UpdateParameters>
                                        <DeleteParameters>
                                            <asp:Parameter Name="ID" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>
                                    <div class="row">
                                        <telerik:RadGrid ID="rgDefaultAreaEGlobalCredit" runat="server" CellSpacing="-1" DataSourceID="sqlDefaultAreaEGlobalCredit" Width="100%" AllowAutomaticUpdates="true" AllowAutomaticInserts="true" AllowAutomaticDeletes="true" PageSize="20" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" Visible="false">
                                            <GroupingSettings CaseSensitive="false" />
                                            <ExportSettings IgnorePaging="true" ExportOnlyData="true">
                                            </ExportSettings>
                                            <ClientSettings>
                                                <Selecting AllowRowSelect="True" />
                                            </ClientSettings>
                                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="sqlDefaultAreaEGlobalCredit" CommandItemDisplay="Top" EditMode="Batch" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="true" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel">
                                                <NoRecordsTemplate>
                                                    <p>No records to display</p>
                                                </NoRecordsTemplate>
                                                <BatchEditingSettings EditType="Cell" />
                                                <Columns>
                                                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="Area" HeaderText="Area" UniqueName="Area" DataField="Area" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="30px" HeaderStyle-Width="80px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridDropDownColumn DataSourceID="sqlUnits" ListTextField="unit" ListValueField="unit_id" UniqueName="Min_Unit_id" SortExpression="Min_Unit_id" HeaderText="Min Units" DataField="Min_Unit_id" AllowFiltering="true" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center">
                                                    </telerik:GridDropDownColumn>
                                                    <telerik:GridDropDownColumn DataSourceID="sqlUnits" ListTextField="unit" ListValueField="unit_id" UniqueName="Max_Unit_id" SortExpression="Max_Unit_id" HeaderText="Max Units" DataField="Max_Unit_id" AllowFiltering="true" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center">
                                                    </telerik:GridDropDownColumn>
                                                    <telerik:GridDropDownColumn DataSourceID="sqlAreaCreditType" ListTextField="AreaCreditType" ListValueField="AreaCreditTypeID" UniqueName="AreaCreditTypeID" SortExpression="AreaCreditTypeID" HeaderText="Area Credit Type" DataField="AreaCreditTypeID" AllowFiltering="true" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center">
                                                    </telerik:GridDropDownColumn>
                                                    <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" UniqueName="Title" DataField="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" HeaderStyle-Width="200px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridDropDownColumn DataSourceID="sqlCourses" ListTextField="Description" ListValueField="outline_id" UniqueName="Outline_id" SortExpression="Outline_id" HeaderText="Course" DataField="Outline_id" AllowFiltering="true" HeaderStyle-Width="300px">
                                                    </telerik:GridDropDownColumn>
                                                    <telerik:GridBoundColumn SortExpression="TranscriptCode" HeaderText="Transcript Code" UniqueName="TranscriptCode" DataField="TranscriptCode" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="100px" HeaderStyle-Width="80px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="Link" HeaderText="Link" UniqueName="Link" DataField="Link" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="100px" HeaderStyle-Width="80px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="Notes" HeaderText="Notes" UniqueName="Notes" DataField="Notes" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="100px" HeaderStyle-Width="80px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="CPLUnitLimit" HeaderText="CPL Unit Limit" UniqueName="CPLUnitLimit" DataField="CPLUnitLimit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px" HeaderStyle-Width="80px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridCheckBoxColumn DataField="WaiveAreaERequirement" DataType="System.Boolean" HeaderText="Waive Area E Requirement" UniqueName="WaiveAreaERequirement" AllowFiltering="true" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo">
                                                    </telerik:GridCheckBoxColumn>
                                                </Columns>
                                            </MasterTableView>
                                        </telerik:RadGrid>
                                        <telerik:RadGrid ID="RadGrid1" runat="server" AllowPaging="True"
                                            AllowSorting="True" AutoGenerateEditColumn="True"
                                            DataSourceID="sqlDefaultAreaEGlobalCredit" GridLines="None"
                                            AllowAutomaticDeletes="true"
                                            OnUpdateCommand="RadGrid1_UpdateCommand"
                                            OnItemDataBound="RadGrid1_ItemDataBound"
                                            OnInsertCommand="RadGrid1_InsertCommand">
                                            <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlDefaultAreaEGlobalCredit"
                                                DataKeyNames="ID" CommandItemDisplay="Top">
                                                <Columns>
                                                    <telerik:GridTemplateColumn DataField="Area" HeaderText="Area" UniqueName="Area">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("Area") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <telerik:RadTextBox ID="txtArea" runat="server" Text='<%# Bind("Area") %>'
                                                                EmptyMessage="Please enter Area" MaxLength="50">
                                                            </telerik:RadTextBox>
                                                        </EditItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridDropDownColumn DataSourceID="sqlUnits" ListTextField="unit" ListValueField="unit_id" UniqueName="Min_Unit_id" SortExpression="Min_Unit_id" HeaderText="Min Units" DataField="Min_Unit_id" AllowFiltering="true" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center">
                                                    </telerik:GridDropDownColumn>
                                                    <telerik:GridDropDownColumn DataSourceID="sqlUnits" ListTextField="unit" ListValueField="unit_id" UniqueName="Max_Unit_id" SortExpression="Max_Unit_id" HeaderText="Max Units" DataField="Max_Unit_id" AllowFiltering="true" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center">
                                                    </telerik:GridDropDownColumn>
                                                    <telerik:GridTemplateColumn DataField="Title" HeaderText="Title" UniqueName="Title">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <telerik:RadTextBox ID="txtTitle" runat="server" Text='<%# Bind("Title") %>'
                                                                EmptyMessage="Please enter Title" MaxLength="50">
                                                            </telerik:RadTextBox>
                                                        </EditItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridTemplateColumn DataField="AreaCreditType" HeaderText="Area Credit Type" UniqueName="AreaCreditType">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("AreaCreditType") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <telerik:RadComboBox ID="rcbAreaCreditType" Width="200px" DropDownAutoWidth="Enabled" AppendDataBoundItems="true"
                                                                runat="server"
                                                                AutoPostBack="true"
                                                                DataSourceID="sqlAreaCreditType"
                                                                DataTextField="AreaCreditType"
                                                                DataValueField="AreaCreditTypeID"
                                                                SelectedValue='<%# Eval("AreaCreditTypeID") %>'
                                                                OnSelectedIndexChanged="rcbAreaCreditType_SelectedIndexChanged">
                                                                <Items>
                                                                    <telerik:RadComboBoxItem Text="" Value="0" />
                                                                </Items>
                                                            </telerik:RadComboBox>
                                                        </EditItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridTemplateColumn DataField="CourseName" HeaderText="Course" UniqueName="CourseName">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("CourseName") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <telerik:RadComboBox ID="rcbCourses" Width="600px" DropDownAutoWidth="Enabled" AppendDataBoundItems="true"
                                                                runat="server"
                                                                DataTextField="Description"
                                                                DataValueField="outline_id">
                                                                <Items>
                                                                    <telerik:RadComboBoxItem Text="" Value="0" />
                                                                </Items>
                                                            </telerik:RadComboBox>
                                                        </EditItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn SortExpression="TranscriptCode" HeaderText="Transcript Code" UniqueName="TranscriptCode" DataField="TranscriptCode" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="100px" HeaderStyle-Width="80px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="Link" HeaderText="Link" UniqueName="Link" DataField="Link" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="100px" HeaderStyle-Width="80px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="Notes" HeaderText="Notes" UniqueName="Notes" DataField="Notes" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="100px" HeaderStyle-Width="80px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="CPLUnitLimit" HeaderText="CPL Unit Limit" UniqueName="CPLUnitLimit" DataField="CPLUnitLimit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px" HeaderStyle-Width="80px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridCheckBoxColumn DataField="WaiveAreaERequirement" DataType="System.Boolean" HeaderText="Waive Area E Requirement" UniqueName="WaiveAreaERequirement" AllowFiltering="true" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo">
                                                    </telerik:GridCheckBoxColumn>
                                                    <telerik:GridButtonColumn ConfirmText="Are you sure you want to delete this item?"
                                                        ConfirmDialogType="RadWindow"
                                                        ConfirmTitle="Delete"
                                                        ButtonType="FontIconButton" HeaderText="Delete"
                                                        CommandName="Delete" Text="" UniqueName="DeleteColumn">
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </telerik:GridButtonColumn>
                                                </Columns>
                                            </MasterTableView>
                                        </telerik:RadGrid>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <asp:SqlDataSource ID="sqlExistingArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetAmbassadorExistingArticulationList" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbExistingArticulations" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Existing Articulations" Expanded="false" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center bg-light">
                                        <div class="col-3">
                                            Existing Articulations
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <div class="row">
                                        <div class="col-8">
                                            <telerik:RadGrid ID="rgExistingArticulations" runat="server" CellSpacing="-1" DataSourceID="sqlExistingArticulations" Width="100%" PageSize="20" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" AllowFilteringByColumn="false">
                                                <GroupingSettings CaseSensitive="false" />
                                                <ExportSettings IgnorePaging="true" ExportOnlyData="true">
                                                </ExportSettings>
                                                <ClientSettings>
                                                    <Selecting AllowRowSelect="True" />
                                                    <ClientEvents />
                                                </ClientSettings>
                                                <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlExistingArticulations" CommandItemDisplay="Top" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel">
                                                    <NoRecordsTemplate>
                                                        <p>No records to display</p>
                                                    </NoRecordsTemplate>
                                                    <BatchEditingSettings EditType="Cell" />
                                                    <Columns>
                                                        <telerik:GridBoundColumn SortExpression="subject" HeaderText="Subject" DataField="subject" UniqueName="subject" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="Course" HeaderText="Course" DataField="Course" UniqueName="Course" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="150px" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="TeamRevd" HeaderText="Team Reviewed" DataField="TeamRevd" UniqueName="TeamRevd" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" DataType="System.DateTime" DataFormatString="{0:MM/dd/yyyy}">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="Notes" HeaderText="Notes" DataField="Notes" UniqueName="Notes" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridBoundColumn>
                                                    </Columns>
                                                </MasterTableView>
                                            </telerik:RadGrid>
                                        </div>
                                        <div class="col-4">
                                            <uc:DataUploadChoice runat="server" ID="ducExistingArticulations" OnFileUploaded="ducExistingArticulations_FileUploaded"></uc:DataUploadChoice>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetAmbassadorProgramList" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbPrograms" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Program Description" Expanded="true" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center bg-light">
                                        <div class="col-3">
                                            Program Description
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <div class="row">
                                        <div class="col-8">
                                            <telerik:RadGrid ID="rgPrograms" runat="server" CellSpacing="-1" DataSourceID="sqlPrograms" Width="100%" PageSize="20" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" AllowFilteringByColumn="false" AllowAutomaticUpdates="true" OnBatchEditCommand="rgPrograms_BatchEditCommand">
                                                <GroupingSettings CaseSensitive="false" />
                                                <ExportSettings IgnorePaging="true" ExportOnlyData="true">
                                                </ExportSettings>
                                                <ClientSettings>
                                                    <Selecting AllowRowSelect="True" />
                                                    <ClientEvents />
                                                </ClientSettings>
                                                <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlPrograms" CommandItemDisplay="Top" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel" EditMode="Batch">
                                                    <NoRecordsTemplate>
                                                        <p>No records to display</p>
                                                    </NoRecordsTemplate>
                                                    <BatchEditingSettings EditType="Cell" />
                                                    <Columns>
                                                        <telerik:GridBoundColumn DataField="issuedformid" UniqueName="issuedformid" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="ProgramOfStudy" HeaderText="Program of Study" DataField="ProgramOfStudy" UniqueName="ProgramOfStudy" HeaderStyle-Width="150px" HeaderStyle-Font-Bold="true" HeaderTooltip="Title" ReadOnly="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="DegreeType" HeaderText="Degree Type" DataField="DegreeType" UniqueName="DegreeType" HeaderStyle-Width="150px" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="ProgramDescription" HeaderText="Program Description" DataField="ProgramDescription" UniqueName="ProgramDescription" HeaderStyle-Width="370px" HeaderStyle-Font-Bold="true" ItemStyle-BackColor="#FFFFE0">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="AcademicProgram" HeaderText="Academic Program" DataField="AcademicProgram" UniqueName="AcademicProgram" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                                        </telerik:GridBoundColumn>
                                                    </Columns>
                                                </MasterTableView>
                                            </telerik:RadGrid>
                                        </div>
                                        <div class="col-4">
                                            <uc:DataUploadChoice runat="server" ID="ducPrograms" OnFileUploaded="ducPrograms_FileUploaded"></uc:DataUploadChoice>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>

                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbProgramLearningOutcomes" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Program Learning Outcomes" Expanded="false" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center bg-light">
                                        <div class="col-3">
                                            Program Learning Outcomes (Optional)
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <div class="row">
                                        <div class="col-8">
                                            <b>If you require this data to be updated, please submit a ticket through the MAP Portal here: </b><a href="http://help.militaryarticulationplatform.org/support/home" target="_blank" class="link-primary">Support: Military Articulation Platform (MAP) Portal</a>.
                                        </div>
                                        <div class="col-4">
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbProgramRequirements" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Program Requirements" Expanded="false" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center bg-light">
                                        <div class="col-3">
                                            Program Requirements (Optional)
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <div class="row">
                                        <div class="col-8">
                                            <b>If you require this data to be updated, please submit a ticket through the MAP Portal here: </b><a href="http://help.militaryarticulationplatform.org/support/home" target="_blank" class="link-primary">Support: Military Articulation Platform (MAP) Portal</a>.
                                        </div>
                                        <div class="col-4">
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                </div>
            </telerik:RadWizardStep>

            <telerik:RadWizardStep runat="server" StepType="Complete" CssClass="complete">
                <p>MAP Cohort 2022 registration form completed.</p>
                <telerik:RadButton ID="rbBack" runat="server" Text="Back" Width="120px" Primary="true" OnClick="rbBack_Click" AutoPostBack="true" CssClass="m-3"></telerik:RadButton>
            </telerik:RadWizardStep>
        </WizardSteps>
    </telerik:RadWizard>
    <div class="row">
        <div class="col-md-12">
            <br />
            <br />
            <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/intro.js/4.3.0/intro.min.js" type="text/javascript"></script>
    <script src="../../Common/js/onboarding/Ambassador.js?v=16" type="text/javascript"></script>
    <script>
        function checkBoxClick(sender, args) {

            var initialValue = sender.checked;
            console.log(initialValue);

            if (initialValue) {
                if (confirm("You are attempting to bypass " + sender.nextSibling.innerHTML + " approval. Are you sure you want to remove " + sender.nextSibling.innerHTML + " from your workflow?")) {

                    var grid = $find("<%= rgWorkflow.ClientID %>");
                    var masterTableView = grid.get_masterTableView();
                    var batchEditingManager = grid.get_batchEditingManager();
                    var parentCell = $telerik.$(sender).closest("td")[0];
                    var initialValue = sender.checked;
                    sender.checked = !sender.checked;

                    batchEditingManager.changeCellValue(parentCell, initialValue);


                } else {

                    sender.checked = false;
                }

            }


        }
    </script>
</asp:Content>
