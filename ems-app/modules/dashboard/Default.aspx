<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ems_app.Default1" %>

<%@ Register Src="~/UserControls/UnknownOccupationsNotification.ascx" TagPrefix="uc" TagName="UnknownOccupations" %>
<%@ Register Src="../../UserControls/CollegeSummary.ascx" TagName="CollegeSummary" TagPrefix="uc2" %>
<%@ Register Src="~/UserControls/CollegeArticulationStats.ascx" TagPrefix="uc" TagName="CollegeArticulationStats" %>
<%@ Register Src="~/UserControls/QualifiedVetsButtons.ascx" TagPrefix="uc" TagName="QualifiedVetsButtons" %>
<%@ Register Src="~/UserControls/TopCollegeArticulations.ascx" TagPrefix="uc" TagName="TopCollegeArticulations" %>
<%@ Register Src="~/UserControls/CreateArticulationRecommendation.ascx" TagPrefix="uc" TagName="CreateArticulationByCriteria" %>
<%@ Register Src="~/UserControls/notifications/Messages.ascx" TagPrefix="uc8" TagName="NotificationMessages" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .RadGrid_Material .rgRow > td, .RadGrid_Material .rgAltRow > td, .RadGrid_Material .rgEditRow > td {
            padding: 5px !important;
        }

        #ctl00_ContentPlaceHolder1_rgArticulationCourses_rghcMenu_i10_HCFMRCMBFirstCond, #ctl00_ContentPlaceHolder1_rgArticulationCourses_rghcMenu_i10_HCFMRTBSecondCond_wrapper, #ctl00_ContentPlaceHolder1_rgArticulationCourses_rghcMenu_i10_HCFMRCMBSecondCond, .rgHCMShow, .rgHCMAnd {
            /*display:none !important;*/
        }

        #ctl00_ContentPlaceHolder1_rgArticulationCourses_rghcMenu_i10_HCFMRCMBSecondCond, .GridContextMenu_Material .rgHCMShow, .GridContextMenu_Material .rgHCMAnd, #ctl00_ContentPlaceHolder1_rgArticulationCourses_rghcMenu_i10_HCFMRTBSecondCond_wrapper {
            display: none !important;
        }
        .row-buttons a {
            display:block !important;
            width:max-content !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="appTitle" id="SystemTitle" runat="server"></p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlAudit" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct al.outline_id, s.subject + ' ' + cif.course_number + ' ' + cif.course_title as 'Course', (select max (LogTime) from ArticulationLog where outline_id = al.outline_id ) as logtime from ArticulationLog al left outer join Articulation ac on al.ArticulationID = ac.ArticulationID and al.ArticulationType = ac.ArticulationType  left outer join Course_IssuedForm cif on al.outline_id = cif.outline_id left outer join tblSubjects s on  cif.subject_id = s.subject_id where cif.college_id = @CollegeID and ( ac.CollegeID = @CollegeID ) order by [logtime] desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAuditBySubject" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct al.outline_id, s.subject + ' ' + cif.course_number + ' ' + cif.course_title as 'Course', (select max (LogTime) from ArticulationLog where outline_id = al.outline_id ) as logtime from ArticulationLog al left outer join Articulation ac on al.ArticulationID = ac.ArticulationID and al.ArticulationType = ac.ArticulationType left outer join Course_IssuedForm cif on al.outline_id = cif.outline_id left outer join tblSubjects s on  cif.subject_id = s.subject_id where cif.college_id = @CollegeID and cif.StageId = @StageId and cif.subject_id in ( select SubjectID from UserSubjects where UserID = @UserID ) and ( ac.CollegeID = @CollegeID ) order by [logtime] desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="StageId" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select r.RoleName from Stages s join ROLES r on s.RoleID = r.RoleID where s.CollegeID = @CollegeID order by s.[order]">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlLog" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select r1.RoleName as RoleName, al.id, al.outline_id, case when al.ArticulationType = 1 then 'Course' else 'Occupation' end ArticulationType, al.[event], ac.AceID , ac.TeamRevd, ac.Title, al.LogTime from ArticulationLog al left outer join Articulation ac on al.ArticulationID = ac.ArticulationID and al.ArticulationType = ac.ArticulationType join Course_IssuedForm cif on al.outline_id = cif.outline_id  left outer join Stages s1 on ac.ArticulationStage = s1.Id left outer join ROLES r1 on s1.RoleId = r1.RoleID where cif.college_id = @CollegeID and al.ArticulationID > 0 and al.outline_id = @outline_id order by al.LogTime desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:Parameter Name="outline_id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>


    <!-- start manage articulations datasources -->

    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct pif.program_id, isnull(pif.program,'') + ' - ' + cast(isnull(pif.description,'') as varchar(20)) as 'program' from (select outline_id, college_id from Articulation) Ac join tblProgramCourses pc on ac.outline_id = pc.outline_id join Program_IssuedForm pif on pc.program_id = pif.program_id where pif.status = 0 and pif.[college_id] = @CollegeID">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 1 as id, 'Course' as description union select 2 as id , 'Occupation' as description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStages" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.Id as stage_id, r.RoleName as 'Description' from Stages s join ROLES r on s.RoleId = r.RoleID  where s.CollegeId =  @CollegeID order by s.[Order]">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseMatches" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArticulationCourseMatches" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:Parameter Name="outline_id" Type="Int32" />
            <asp:SessionParameter Name="RoleID" SessionField="RoleID" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            <asp:ControlParameter Name="OrderBy" ControlID="rblSort" Type="String" DefaultValue="0" />
            <asp:Parameter Name="StageFilter" Type="Int32" DefaultValue="0" />
            <asp:Parameter Name="ArticulationMatrixFormat" Type="String" DefaultValue="HTML" />
            <asp:ControlParameter Name="ShowDenied" ControlID="hvShowDenied" PropertyName="Value" Type="Boolean" DefaultValue="False" />
            <asp:ControlParameter Name="AceIDs" ControlID="hfAceIDs" PropertyName="Value" Type="String" ConvertEmptyStringToNull="true" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM LookupStatus"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArticulationCourses" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:SessionParameter Name="Username" SessionField="UserName" Type="String" />
            <asp:SessionParameter Name="RoleID" SessionField="RoleID" Type="Int32" />
            <asp:ControlParameter Name="OrderBy" ControlID="rblSort" Type="String" DefaultValue="0" />
            <asp:Parameter Name="StageFilter" Type="Int32" DefaultValue="0" />
            <asp:SessionParameter Name="SelectedCollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:ControlParameter Name="ShowDenied" ControlID="hvShowDenied" PropertyName="Value" Type="Boolean" DefaultValue="False" />
            <asp:ControlParameter Name="AceIDs" ControlID="hfAceIDs" PropertyName="Value" Type="String" ConvertEmptyStringToNull="true" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!-- end manage articulations datasources -->

    <asp:SqlDataSource ID="sqlDontArsticulateCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  distinct 0 as 'ExistInOtherColleges' , ac.outline_id, [dbo].[GetCollegeExistsChecklist](ac.outline_id) as 'ExistCheckList', 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title FROM   Articulation  ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id   where cif.[college_id] = @CollegeID and ac.Articulate = 0 and ac.ArticulationStatus = 1  order by S.subject , cif.course_number">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:ControlParameter ControlID="hfStageID" PropertyName="Value" Name="StageID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlMainPublishedCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  distinct 0 as 'ExistInOtherColleges' , ac.outline_id, [dbo].[GetCollegeExistsChecklist](ac.outline_id) as 'ExistCheckList', 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title FROM  Articulation ac  LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id   where ac.CollegeID = @CollegeID and ac.ArticulationStatus = 2  order by S.subject , cif.course_number">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlPublishedCourseArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct 0 as checkUpdatedCurrentUser, [dbo].[GetLastSubmmited](ac.id, ac.ArticulationType) as LastSubmmited,ac.outline_id, s.RoleID, ac.id, ac.ArticulationID, ac.ArticulationType, ac. AceID, ac.articulate, ac.ArticulationStatus, ac.ArticulationStage , ac.TeamRevd, case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Officer Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes,  ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.VersionNumber Exhibit, u.firstname + ', ' + u.lastname as 'FullName', cc.Occupation, ac.Title, 0 as 'Document', [dbo].[GetArticulationMatrix](ac.id) 'Matrix' from Articulation ac left outer join AceExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join tblusers u on ac.CreatedBy = u.userid left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id where ac.outline_id = @outline_id and ac.ArticulationStatus = 2 and ac.articulate = 1 order by ac.ArticulationType, ac.AceID, ac.TeamRevd">
        <SelectParameters>
            <asp:Parameter Name="outline_id" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlDontArticulateArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct 0 as checkUpdatedCurrentUser, [dbo].[GetLastSubmmited](ac.id, ac.ArticulationType) as LastSubmmited,ac.outline_id, s.RoleID, ac.id, ac.ArticulationID, ac.ArticulationType, ac. AceID, ac.Articulate, ac.ArticulationStatus, ac.ArticulationStage , ac.TeamRevd, case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Officer Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes,  ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.VersionNumber Exhibit, u.firstname + ', ' + u.lastname as 'FullName', cc.Occupation,  cc.Title 'Title' , 0 as 'Document', [dbo].[GetArticulationMatrix](ac.id) 'Matrix' from Articulation ac left outer join AceExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join tblusers u on ac.CreatedBy = u.userid left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id where ac.outline_id = @outline_id and ac.Articulate = 0 order by ac.ArticulationType, ac.AceID, ac.TeamRevd">
        <SelectParameters>
            <asp:Parameter Name="outline_id" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" Modal="false"></telerik:RadWindowManager>
        <telerik:RadWindowManager RenderMode="Lightweight" ID="rwmTESReport" runat="server" EnableShadow="true">
            <Windows>
                <telerik:RadWindow RenderMode="Lightweight" ID="TESReportDialog" runat="server" Title="TES Report" Height="600px" Width="1100px" Modal="true" VisibleStatusbar="false">
                </telerik:RadWindow>
            </Windows>
        </telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <%--        <telerik:RadNotification RenderMode="Lightweight" ID="notification" runat="server" Title="Adopt Articulations" TitleIcon="info"
            VisibleOnPageLoad="true" AutoCloseDelay="0" ShowCloseButton="true" 
            Position="Center" Height="200" Width="550"
            EnableRoundedCorners="true" EnableShadow="true">
            <ContentTemplate>
                <div class="mt-4 mb-3 d-flex justify-content-center">
                    <p><strong>20 strong> Articulations are available to adopt from other colleges.</p>
                </div>
                <div class="d-flex justify-content-between w-75 m-auto" >
                    <telerik:RadButton ID="RadButton1" runat="server" Text="Adopt" PostBackUrl="~/modules/faculty/ArticulationsPendingToReview.aspx?adopt=True" NavigateUrl="~/modules/faculty/ArticulationsPendingToReview.aspx" Primary="true"></telerik:RadButton>
                    <telerik:RadButton ID="RadButton3" runat="server" Text="Dismiss"></telerik:RadButton>
                    <telerik:RadButton ID="RadButton2" runat="server" Text="Dont show me this again"></telerik:RadButton>
                </div>
            </ContentTemplate>
        </telerik:RadNotification>--%>
        <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" runat="server" />
        <input type="hidden" id="radGridClickedRowIndexAdopt" name="radGridClickedRowIndexAdopt" runat="server" />
        <input type="hidden" id="hvOutlineID" name="hvOutlineID" runat="server" />
        <input type="hidden" id="hvID" name="hvID" runat="server" />
        <input type="hidden" id="hvArticulationID" name="hvArticulationID" runat="server" />
        <input type="hidden" id="hvArticulationType" name="hvArticulationType" runat="server" />
        <input type="hidden" id="hvArticulationStage" name="hvArticulationStage" runat="server" />
        <input type="hidden" id="hvAceID" name="hvAceID" runat="server" />
        <input type="hidden" id="hvTeamRevd" name="hvTeamRevd" runat="server" />
        <input type="hidden" id="hvTitle" name="hvTitle" runat="server" />
        <input type="hidden" id="hvShowDenied" name="hvShowDenied" runat="server"  />
        <asp:HiddenField ID="hfLastStageID" runat="server" />
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                
                <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbMyArticulations" Width="100%" CssClass="mb-2">
                    <Items>
                        <telerik:RadPanelItem Text="Create Articulations" Expanded="true" EnableTheming="false" ToolTip="Begin your articulation process by selecting a course from your catalog (left) plus one or more credit recommendations (right) to perform a search of potential articulations. For added articulation accuracy, the credit recommendations shown by default are linked to the selected course TOP code" CssClass="bg-light">
                            <HeaderTemplate>
                                <div class="d-flex justify-content-between align-items-center bg-primary">
                                    <div class="col-3" style="font-weight: bold; color: #fff !important;">
                                        Create Articulations
                                    </div>
                                    <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                    </div>
                                    <div class="col-1">
                                        <a class="rpExpandable" style="color: #fff !important;">
                                            <span class="rpExpandHandle" style="color: #fff !important;"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                        </a>
                                    </div>
                                </div>
                            </HeaderTemplate>
                            <ContentTemplate>
                                <uc:CreateArticulationByCriteria runat="server" ID="CreateArticulationByCriteria" />
                            </ContentTemplate>
                        </telerik:RadPanelItem>
                    </Items>
                </telerik:RadPanelBar>

                <div class="row container-fluid">
                    <asp:HiddenField ID="hfCollege" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hfRoleID" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hfUserID" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hfUserName" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hfCollegeName" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hfWelcomePage" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hfSkipped" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hfSubjectFilter" runat="server" ClientIDMode="Static" Value="" />
                    <asp:HiddenField ID="hfCourseFilter" runat="server" ClientIDMode="Static" Value="" />
                    <asp:HiddenField ID="hfTitleFilter" runat="server" ClientIDMode="Static" Value="" />
                    <asp:HiddenField ID="hfShowDenied" runat="server" ClientIDMode="Static" Value="" />
                    <asp:HiddenField ID="hfAceIDs" runat="server" ClientIDMode="Static" Value="" />
                    <div class="row m-5 d-flex justify-content-center" id="panelVCRStaff" runat="server" visible="false">
                        <telerik:RadLinkButton CssClass="m-5" Primary="true" Width="200px" ID="rlbGoStudentIntake" runat="server" Text="Go to Student Intake" NavigateUrl="~/modules/military/StudentList.aspx"></telerik:RadLinkButton>
                    </div>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbMyNotifications" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="My Notifications" Expanded="true" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center bg-light">
                                        <div class="col-3" style="font-weight: bold;">
                                            <asp:Label ID="lblMyNotifications" runat="server"></asp:Label>
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
                                    <uc8:NotificationMessages runat="server" ID="MyMessages" />
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <div class="row container-fluid">
                        <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbCollegeArticulations" Width="100%" Enabled="false">
                            <Items>
                                <telerik:RadPanelItem Text="College Articulations Summary" Expanded="true" EnableTheming="false" ToolTip="Click here to collapse/expand this area" CssClass="bg-light">
                                    <HeaderTemplate>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="col-3">
                                                College Articulations Summary
                                            </div>
                                            <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                                <uc:QualifiedVetsButtons runat="server" ID="QualifiedVetsButtons" Visible="false" />
                                                <asp:LinkButton runat="server" OnClientClick="ShowTESReport();return false;" ToolTip="" ID="LinkBUtton2" Text='<i class="fa fa-file-text" aria-hidden="true"></i> TES' CssClass="btn btn-light" Width="140px" Visible="false"></asp:LinkButton>
                                                <asp:LinkButton runat="server" OnClientClick="ShowCollegeMetrics();return false;" ToolTip="" ID="LinkBUtton3" Text='<i class="fa fa-file-text" aria-hidden="true"></i> College Metrics' CssClass="btn btn-light" Width="250px" Visible="false"></asp:LinkButton>
                                                <asp:LinkButton runat="server" OnClientClick="ShowImplementedArticulations();return false;" ToolTip="" ID="lbImplementedArticulations" Text='<i class="fa fa-file-text" aria-hidden="true"></i> Implemented Articulations Report' CssClass="btn btn-light" Width="350px"></asp:LinkButton>
                                            </div>
                                            <div class="col-1">
                                                <a class="rpExpandable">
                                                    <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                                </a>
                                            </div>
                                        </div>
                                    </HeaderTemplate>
                                    <ContentTemplate>
                                        <div style="padding: 5px;">
                                            <div class="row">
                                                <uc:UnknownOccupations ID="UnknownOccupationsNotificationControl" runat="server" Visible="false"></uc:UnknownOccupations>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-8">
                                                    <uc:CollegeArticulationStats runat="server" ID="CollegeArticulationStats" />
                                                    <uc2:CollegeSummary ID="CollegeSummaryResults" runat="server" Visible="false" />
                                                </div>
                                                <div class="col-sm-4">
                                                    <uc:TopCollegeArticulations runat="server" ID="TopCollegeArticulations" />
                                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </telerik:RadPanelItem>
                            </Items>
                            <ExpandAnimation Type="None" />
                            <CollapseAnimation Type="None" />
                        </telerik:RadPanelBar>
                    </div>
                </div>
                <div id="pnlArticulationsInProcess" runat="server">
                <div class="row" style="margin-bottom: 5px;">
                    <div class="col-sm-4  d-flex justify-content-start align-items-center gap-3" style="padding: 10px;">
                        <telerik:RadLinkButton ID="rlbAdopt" runat="server" Primary="true" CssClass="btn btn-primary mt-1" NavigateUrl="~/modules/popups/AdoptArticulations.aspx"  Target="_blank" Text="Adopt Articulations" ToolTip="The Adopt Articulations feature allows MAP Evaluators to assume ownership of the articulations that have been made at other colleges using MAP. Once adoption takes place, you will be able to tailor the adoption according to your campus’ needs. These adoptions can be then processed through your campus’ workflow to further validate the articulations being made." Height="40px" Width="200px" ></telerik:RadLinkButton>
                        <telerik:RadLinkButton ID="rlbStudentIntake" runat="server" Primary="true" CssClass="btn btn-primary mt-1" NavigateUrl="~/modules/military/StudentList.aspx"  Target="_blank" Text="Student Intake" ToolTip="" Height="40px" Width="200px" ></telerik:RadLinkButton>
                    </div>
                    <div class="col-sm-8 text-right d-flex align-items-center justify-content-end gap-1" style="padding: 10px;">
                        <asp:HiddenField ID="hfStageID" runat="server" />                    
                            <telerik:RadLabel ID="rlShowDenied" runat="server" Text="View Only Denied Articulations">
                            </telerik:RadLabel>
                            <telerik:RadSwitch ID="rsShowDenied" runat="server" Width="65px"  AutoPostBack="true" Checked="false" OnCheckedChanged="rsShowDenied_CheckedChanged">
                                    <ToggleStates>
                                        <ToggleStateOn Text="Yes" Value="true" />
                                        <ToggleStateOff Text="No"  Value="false"/>
                                    </ToggleStates>
                                </telerik:RadSwitch>
                        
                       &nbsp;
                        <telerik:RadComboBox ID="rblSort" runat="server" AutoPostBack="true" Width="250px" OnSelectedIndexChanged="rblSort_SelectedIndexChanged" RenderMode="Lightweight" Label="Sort Articulations by: " DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Value="0" Text="Subject" />
                                <telerik:RadComboBoxItem Value="1" Text="Most Articulations" />
                                <telerik:RadComboBoxItem Value="2" Text="Least amount of Articulations" />
                                <telerik:RadComboBoxItem Value="3" Text="Most number of days awaiting to process" />
                                <telerik:RadComboBoxItem Value="4" Text="Last Submitted/Updated" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadComboBox ID="RadComboBoxStageFilter" runat="server" AutoPostBack="true" Width="25%" DataSourceID="sqlStages" DataTextField="description" DataValueField="stage_id" AppendDataBoundItems="true" OnSelectedIndexChanged="RadComboBoxStageFilter_SelectedIndexChanged" RenderMode="Lightweight" Label="Filter By Stage: " DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Value="0" Text="All" Selected="true" />
                            </Items>
                        </telerik:RadComboBox>
                    </div>
                </div>
                        <div class="row">
                            <div class="col-6">
                                <h2 style="background-color:#203864 !important; text-transform:uppercase; width:100%; color:white; font-size:14px; font-weight:bold; padding:10px; text-align:center;" >Articulations In Process</h2>
                            </div>
                            <div class="col-6">
                                <telerik:RadAutoCompleteBox ID="racbAceIDSearch" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="200" DropDownHeight="200" DataSourceID="sqlAdvancedSearch" DataTextField="FullDescription" EmptyMessage="Search Exhibit ID(s) within Articulations in Process" DataValueField="ID" ClientIDMode="Static" AllowCustomEntry="false" HighlightFirstMatch="true" Delimiter="," AutoPostBack="true" ToolTip="" CssClass="acbCriteria" BackColor="LightYellow" OnEntryAdded="racbAceIDSearch_Entry" OnEntryRemoved="racbAceIDSearch_Entry"></telerik:RadAutoCompleteBox>
                                <asp:SqlDataSource runat="server" ID="sqlAdvancedSearch" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="SELECT distinct e.ID,  CONCAT(e.AceID, ' ', e.Title, ' Version : ', e.Exhibit ) FullDescription FROM Articulation a join ACEExhibit E on a.ExhibitID = e.ID where a.Articulate = 1 and a.CollegeID = @CollegeID ORDER BY FullDescription" SelectCommandType="Text">
                                    <SelectParameters>
                                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>    
                            </div>
                        </div>
                        <telerik:RadGrid ID="rgArticulationCourses" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationCourses" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" AllowAutomaticUpdates="true" OnItemCommand="rgArticulationCourses_ItemCommand" RenderMode="Lightweight" OnItemDataBound="rgArticulationCourses_ItemDataBound" OnPreRender="gridInprocess_PreRender" FilterType="HeaderContext" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" OnFilterCheckListItemsRequested="rgArticulationCourses_FilterCheckListItemsRequested" AllowMultiRowSelection="true" Width="100%">
                            <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
                                <ClientEvents OnFilterMenuShowing="FilteringMenu"  />
                                <Scrolling UseStaticHeaders="true" ScrollHeight="550px"  AllowScroll="true" SaveScrollPosition="true"/>
                            </ClientSettings>
                            <ExportSettings HideStructureColumns="true" ExportOnlyData="True" OpenInNewWindow="True" IgnorePaging="True">
                            </ExportSettings>
                            <MasterTableView Width="100%" Name="ParentGrid" DataSourceID="sqlArticulationCourses" PageSize="12" DataKeyNames="outline_id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" HierarchyLoadMode="Client" HierarchyDefaultExpanded="true" GroupHeaderItemStyle-Font-Bold="true">
                                <PagerStyle PagerTextFormat="{4} {5} Course(s) in {1} page(s) " />
                                <CommandItemTemplate>
                                    <div class="commandItems">
                                        <telerik:RadButton runat="server" ID="btnMoveForward" ButtonType="StandardButton" Text="MoveForward" CommandName="MoveForward" ToolTip="Approve selected articulation(s)">
                                            <ContentTemplate>
                                                <i class='fa fa-send'></i><span class="txtMoveForward"> Approve</span>
                                            </ContentTemplate>
                                            <ConfirmSettings ConfirmText="Are you sure you want to Approve the selected articulations?" />
                                        </telerik:RadButton>
                                        <div style="display:none;">
                                        <telerik:RadButton runat="server" ID="btnReturn" OnClientClick="javascript:if(!confirm('Are you sure you want to Return this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Return" CommandName="Return" ToolTip="Return selected articulation(s)">
                                            <ContentTemplate>
                                                <i class='fa fa-hand-o-left'></i> Return
                                            </ContentTemplate>
                                            <ConfirmSettings ConfirmText="Are you sure you want to Return the selected articulations?" />
                                        </telerik:RadButton>
                                        </div>
                                        <telerik:RadButton runat="server" ID="btnDenied" OnClientClick="javascript:if(!confirm('Are you sure you want to Deny this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Deny" CommandName="Denied" ToolTip="Deny selected articulation(s)">
                                            <ContentTemplate>
                                                <i class='fa fa-ban'></i> Deny
                                            </ContentTemplate>
                                            <ConfirmSettings ConfirmText="Are you sure you want to Deny the selected articulations?" />
                                        </telerik:RadButton>
                                        <telerik:RadButton runat="server" ID="rbDelete" OnClientClick="javascript:if(!confirm('Are you sure you want to Delete this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Delete" CommandName="Delete" ToolTip="Delete selected articulation(s)">
                                            <ContentTemplate>
                                                <i class='fa fa-archive'></i> Delete
                                            </ContentTemplate>
                                            <ConfirmSettings ConfirmText="Are you sure you want to Delete the selected articulations?" />
                                        </telerik:RadButton>
                                        <telerik:RadButton runat="server" CommandName="Expand" ID="btnExpand" ButtonType="StandardButton" Text="Expand/Collapse" Visible="false">
                                            <ContentTemplate>
                                                <i class='fa fa-expand'></i> Expand / Collapse
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnAudit" runat="server" Text="Audit Trail" ButtonType="StandardButton" CommandName="Audit">
                                            <ContentTemplate>
                                                <i class='fa fa-history'></i> Course Record
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="false">
                                            <ContentTemplate>
                                                <i class='fa fa-file-excel-o'></i> Export to Excel
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnPrint" runat="server" Text="Print" ButtonType="StandardButton" CausesValidation="false" OnClientClicked="showArticulationsReport" AutoPostBack="false">
                                            <ContentTemplate>
                                                <i class='fa fa-print'></i> Print / Export
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnRefresh" runat="server" Text="Print" ButtonType="StandardButton" OnClientClicked="RefreshGridArticulationCourses">
                                            <ContentTemplate>
                                                <i class='fa fa-refresh'></i> Refresh
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                    </div>
                                </CommandItemTemplate>
                                <DetailTables>
                                    <telerik:GridTableView Name="ChildGrid" DataKeyNames="id" DataSourceID="sqlCourseMatches" Width="100%" AllowMultiColumnSorting="true" runat="server" CommandItemDisplay="None" AllowFilteringByColumn="true" CommandItemSettings-ShowAddNewRecordButton="false" HeaderStyle-Font-Bold="true" EnableHeaderContextFilterMenu="true" EnableHeaderContextMenu="true" AllowPaging="true" GroupLoadMode="Client" GroupsDefaultExpanded="true" HierarchyDefaultExpanded="true" GroupHeaderItemStyle-Font-Bold="true">
                                        
                                        <ParentTableRelation>
                                            <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                        </ParentTableRelation>
                                        <GroupByExpressions>
                                            <telerik:GridGroupByExpression>
                                                <SelectFields>
                                                    <telerik:GridGroupByField FieldAlias="ArtCriteria" FieldName="ArtCriteria"></telerik:GridGroupByField>
                                                </SelectFields>
                                                <GroupByFields>
                                                    <telerik:GridGroupByField FieldName="ArtCriteria" SortOrder="Ascending"></telerik:GridGroupByField>
                                                </GroupByFields>
                                            </telerik:GridGroupByExpression>
                                        </GroupByExpressions>
                                        <Columns>
                                            <telerik:GridClientSelectColumn UniqueName="selectCheckbox" HeaderStyle-Width="30px"></telerik:GridClientSelectColumn>
                                            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="75px" ReadOnly="true" AllowFiltering="false" EnableHeaderContextMenu="false" ItemStyle-CssClass="row-buttons">
                                                <ItemTemplate>
                                                    <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='View Details ' CssClass="d-block" />
                                                    <asp:LinkButton runat="server" ToolTip="Audit Trail" CommandName="Audit" ID="btnAuditTrail" Text='Audit Trail' CssClass="d-block" />
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="HaveDeniedArticulations" UniqueName="HaveDeniedArticulations" Display="false" Exportable="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="CollegeID" UniqueName="CollegeID" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false" Exportable="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false" Exportable="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridCheckBoxColumn DataField="checkUpdatedCurrentUser" DataType="System.Boolean" HeaderText="Revised" UniqueName="checkUpdatedCurrentUser" AllowFiltering="true" HeaderStyle-Width="75px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" EnableHeaderContextMenu="false" Display="false">
                                            </telerik:GridCheckBoxColumn>
                                            <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                            <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="75px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" EnableHeaderContextMenu="false">
                                            </telerik:GridDropDownColumn>
                                            <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false" Exportable="false" EnableHeaderContextMenu="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false" Exportable="false" EnableHeaderContextMenu="false"></telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false" Exportable="false" EnableHeaderContextMenu="false"></telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" Exportable="false" EnableHeaderContextMenu="false" HeaderStyle-Width="140px">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridDropDownColumn DataSourceID="sqlStatus" ListTextField="description" ListValueField="id" UniqueName="status_id" SortExpression="status_id" HeaderText="Status" DataField="status_id" AllowFiltering="true" HeaderStyle-Width="60px" ReadOnly="true" Display="false">
                                                <FilterTemplate>
                                                    <telerik:RadComboBox ID="RadComboBoxStatus" DataSourceID="sqlStatus" DataTextField="description"
                                                        DataValueField="id" Height="100px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("status_id").CurrentFilterValue %>'
                                                        runat="server" OnClientSelectedIndexChanged="StatusIndexChanged" DropDownAutoWidth="Enabled">
                                                        <Items>
                                                            <telerik:RadComboBoxItem Text="All" />
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                    <telerik:RadScriptBlock ID="RadScriptBlock222" runat="server">
                                                        <script type="text/javascript">
                                                            function StatusIndexChanged(sender, args) {
                                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                tableView.filter("status_id", args.get_item().get_value(), "EqualTo");
                                                            }
                                                        </script>
                                                    </telerik:RadScriptBlock>
                                                </FilterTemplate>
                                            </telerik:GridDropDownColumn>
                                            <telerik:GridDropDownColumn DataSourceID="sqlStages" ListTextField="description" ListValueField="stage_id" UniqueName="stage_id" SortExpression="stage_id" HeaderText="Stage" DataField="stage_id" AllowFiltering="false" HeaderStyle-Width="70px" ReadOnly="true" Display="false" ItemStyle-HorizontalAlign="Center">
                                                <FilterTemplate>
                                                    <telerik:RadComboBox ID="RadComboBoxStage" DataSourceID="sqlStages" DataTextField="description"
                                                        DataValueField="stage_id" Height="150px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("stage_id").CurrentFilterValue %>'
                                                        runat="server" OnClientSelectedIndexChanged="StageIndexChanged8756" DropDownAutoWidth="Enabled">
                                                        <Items>
                                                            <telerik:RadComboBoxItem Value="" Text="All" />
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                    <telerik:RadScriptBlock ID="RadScriptBlock1018" runat="server">
                                                        <script type="text/javascript">
                                                            function StageIndexChanged8756(sender, args) {
                                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                tableView.filter("stage_id", args.get_item().get_value(), "EqualTo");
                                                            }
                                                        </script>
                                                    </telerik:RadScriptBlock>
                                                </FilterTemplate>
                                            </telerik:GridDropDownColumn>
                                            <telerik:GridBoundColumn FilterCheckListEnableLoadOnDemand="true" SortExpression="ArtRole" HeaderText="Stage" DataField="ArtRole" UniqueName="ArtRole" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" EnableHeaderContextMenu="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="Exhibit ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" HeaderStyle-Width="110px" AutoPostBackOnFilter="true" HeaderStyle-HorizontalAlign="Center" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="Team Revd" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableRangeFiltering="true" EnableHeaderContextMenu="false">
                                                <ItemStyle HorizontalAlign="Center" />
                                            </telerik:GridDateTimeColumn>
                                            <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="90px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" EnableHeaderContextMenu="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="70px" ReadOnly="true" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true"  EnableHeaderContextMenu="false" ItemStyle-Wrap="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true" Display="false" EnableHeaderContextMenu="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes" HeaderStyle-Width="60px" EnableHeaderContextMenu="false">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                                                        <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                                                    </telerik:RadToolTip>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn SortExpression="ArtCriteria" HeaderText="Credit Recommendation" DataField="ArtCriteria" UniqueName="ArtCriteria" AllowFiltering="false" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Wrap="true" EnableHeaderContextMenu="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="Source" HeaderText="Source" DataField="Source" UniqueName="Source" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Wrap="false" EnableHeaderContextMenu="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="LastSubmmited" HeaderText="Last Submitted By" DataField="LastSubmmited" UniqueName="LastSubmmited" AllowFiltering="false" ReadOnly="true" HeaderStyle-Wrap="true" ItemStyle-Wrap="true" HeaderStyle-Width="100px" EnableHeaderContextMenu="false" ItemStyle-HorizontalAlign="Center">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridDateTimeColumn DataField="LastSubmittedOn" DataType="System.DateTime" FilterControlAltText="Filter LastSubmmitedOn column" HeaderText="Last Submitted On" SortExpression="LastSubmittedOn" UniqueName="LastSubmittedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="110px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" EnableHeaderContextMenu="false" HeaderStyle-HorizontalAlign="Center">
                                                <ItemStyle HorizontalAlign="Center" />
                                            </telerik:GridDateTimeColumn>
                                            <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="articulate" DataField="articulate" UniqueName="articulate" Display="false">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                    </telerik:GridTableView>
                                </DetailTables>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn FilterCheckListEnableLoadOnDemand="true" DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject_id" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" HeaderStyle-Width="90px">
                                        <FilterTemplate>
                                            <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                                DataValueField="subject" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged">
                                                <Items>
                                                    <telerik:RadComboBoxItem Text="All" />
                                                </Items>
                                            </telerik:RadComboBox>
                                            <telerik:RadScriptBlock ID="RadScriptBlock37" runat="server">
                                                <script type="text/javascript">
                                                    function SubjectIndexChanged(sender, args) {
                                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                        tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                    }
                                                </script>
                                            </telerik:RadScriptBlock>
                                        </FilterTemplate>
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" HeaderStyle-Wrap="false" DataField="course_number" UniqueName="course_number" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="105px" ItemStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo"  FilterControlWidth="50px" >
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="ExistCheckList" HeaderText="Shared Curriculum" UniqueName="ExistCheckList" DataField="ExistCheckList" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Width="80px" AllowFiltering="false" ShowFilterIcon="false" EnableHeaderContextMenu="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="UserList" HeaderText="Faculty Users" UniqueName="UserList" DataField="UserList" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Width="130px" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Staging" HeaderText="Staging" DataField="Staging" UniqueName="Staging" AllowFiltering="False" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Evaluator" HeaderText="Evaluator" DataField="Evaluator" UniqueName="Evaluator" AllowFiltering="False" ReadOnly="true" HeaderStyle-Width="100px" ItemStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Faculty" HeaderText="Faculty" DataField="Faculty" UniqueName="Faculty" AllowFiltering="False" ReadOnly="true" HeaderStyle-Width="100px" ItemStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Articulation" HeaderText="Articulation Officer" DataField="Articulation" UniqueName="Articulation" AllowFiltering="False" ReadOnly="true" HeaderStyle-Width="90px" ItemStyle-Font-Bold="true" HeaderStyle-Wrap="true" ItemStyle-HorizontalAlign="Center">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Implementation" HeaderText="Implemented" DataField="Implementation" UniqueName="Implementation" AllowFiltering="False" ReadOnly="true" HeaderStyle-Width="130px" ItemStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Published" HeaderText="Published" DataField="Published" UniqueName="Published" AllowFiltering="False" ReadOnly="true" HeaderStyle-Width="110px" ItemStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Total" HeaderText="Total" DataField="Total" UniqueName="Total" AllowFiltering="False" ReadOnly="true" HeaderStyle-Width="80px" ItemStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center">
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                </div>
                <telerik:RadNotification RenderMode="Lightweight" ID="rnDashboardNotification" runat="server" Text="" Position="Center" AutoCloseDelay="0" Width="400" Height="230" Title="Veteran Outreach" EnableRoundedCorners="true" >
                </telerik:RadNotification>
               <!-- User Story 769: Prevent the window from populating.
                   <telerik:RadNotification RenderMode="Lightweight" ID="rnFacultyUsers" runat="server" Title="NOTICE" TitleIcon="info"
                    VisibleOnPageLoad="false" AutoCloseDelay="0" ShowCloseButton="true" 
                    Position="Center" Height="200" Width="550"
                    EnableRoundedCorners="true" EnableShadow="true">
                    <ContentTemplate>                                                       
                        <div class="mt-4 mb-3 d-flex justify-content-center">
                            <p>One or more faculty members have no assigned subjects. Would you like to assign faculty subjects now?</p>
                        </div>
                        <div class="d-flex justify-content-between w-75 m-auto" >
                            <telerik:RadButton ID="RadButton1" runat="server" AutoPostBack="true" Text="Yes" PostBackUrl="~/modules/security/Users.aspx" NavigateUrl="~/modules/security/Users.aspx" Primary="true"></telerik:RadButton>
                            <telerik:RadButton ID="btnOk" runat="server" AutoPostBack="false" Text="Not Now" OnClientClicked="OnClientClicked" ></telerik:RadButton>
                        </div>
                    </ContentTemplate>
                </telerik:RadNotification> 
                 -->
            </div> 
        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">

        // Get all elements with "ARTICULATIONS WITHOUT CREDIT RECOMMENDATIONS" and change the font color to red
        var elements = document.querySelectorAll(".rgGroupHeader");
        elements.forEach(function (element) {
            var child = element.childNodes.item(2);
            if (child.textContent.indexOf("ARTICULATIONS WITHOUT CREDIT RECOMMENDATIONS") !== -1) {
                element.style.color = "red";
            }
        });

        window.addEventListener('load',
            function () {

                var welcome = document.getElementById('<%= hfWelcomePage.ClientID %>').value;
                var skipped = document.getElementById('<%= hfSkipped.ClientID %>').value;
                if (skipped == "False") {
                    if (welcome == "True") {
                        ShowWelcome();
                    }
                }
                var messageCount = document.getElementById('hvMessageCount').value;
                if (messageCount == 0) {
                    var panelbar = $find("<%= rpbMyNotifications.ClientID %>");
                    for (var i = 0; i < panelbar.get_allItems().length; i++) {
                        panelbar.get_allItems()[i].set_expanded(false);
                    }
                }
            }, false);

        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function RefreshGridArticulationCourses(sender, args) {
            location.reload(true);
        }
        function showArticulationsReport() {
            var order_by = $find('<%=rblSort.ClientID %>').get_selectedItem().get_value();
            console.log('order_by : ' + order_by);
            var college_id = $get('<%=hfCollege.ClientID %>').value;
            console.log('college_id : ' + college_id);
            var user_id = $get('<%=hfUserID.ClientID %>').value;
            console.log('user_id : ' + user_id);
            var college_name = $get('<%=hfCollegeName.ClientID %>').value;
            console.log('college_name : ' + college_name);
            var role_id = $get('<%=hfRoleID.ClientID %>').value;
            console.log('role_id : ' + role_id);
            var user_name = $get('<%=hfUserName.ClientID %>').value;
            console.log('user_name : ' + user_name);
            var subjectFilter = $get('<%=hfSubjectFilter.ClientID %>').value;
            console.log('subjectFilter : ' + subjectFilter);
            var courseFilter = $get('<%=hfCourseFilter.ClientID %>').value;
            console.log('courseFilter : ' + courseFilter);
            var titleFilter = $get('<%=hfTitleFilter.ClientID %>').value;
            console.log('titleFilter : ' + titleFilter);
            var stageFilter = $find('<%=RadComboBoxStageFilter.ClientID %>').get_selectedItem().get_value();
            console.log('stageFilter : ' + stageFilter);
            var showDenied = $get('<%=hfShowDenied.ClientID %>').value;
            console.log('showDenied : ' + showDenied);

            //var fesubjectFilter;
            //var fecourseFilter;
            //var fetitleFilter;
            //var filterExpressions = grid.get_masterTableView().get_filterExpressions();
            //var column;
            //var length = filterExpressions.length;
            //for (var i = 0; i < filterExpressions.length; i++) {
            //    column = filterExpressions[i].get_columnUniqueName();
            //    if (filterExpressions[i].get_columnUniqueName() == "subject") {
            //        fesubjectFilter = filterExpressions[i].get_fieldValue;
            //    }
            //    if (filterExpressions[i].get_columnUniqueName() == "course_number") {
            //        fecourseFilter = filterExpressions[i].get_fieldValue;
            //    }
            //    if (filterExpressions[i].get_columnUniqueName() == "course_title") {
            //        fetitleFilter = filterExpressions[i].get_fieldValue;
            //    }
            //}
            //alert('fesubjectFilter:' + fesubjectFilter + ' fecourseFilter:' + fecourseFilter + ' fetitleFilter:' + fetitleFilter);
            var url = "../reports/ArticulationsReport.aspx?CollegeID=" + college_id + "&UserID=" + user_id + "&RoleID=" + role_id + "&OrderBy=" + order_by + "&CollegeName=" + college_name + "&Username=" + user_name + "&SubjectFilter=" + subjectFilter + "&CourseFilter=" + courseFilter + "&TitleFilter=" + titleFilter + "&ShowDenied=" + showDenied + "&StageFilter=" + stageFilter;
            ShowArticulations(url, 1100, 670);
            //var url = "../reports/ArticulationsReport.aspx?CollegeID="+college_id+"&UserID="+user_id+"&RoleID="+role_id+"&OrderBy="+order_by+"&CollegeName="+college_name+"&Username="+user_name; 
        }
        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }
        function refreshInProcess() {
            location.reload(true);
        }
       //DevOps User Story 769: It was requested that the pop up notification be disabled.
       //function OnClientClicked(sender, args) {
       //     var notification = $find("<%=rnFacultyUsers.ClientID %>");  
       //     notification._close(true);
       // }
    </script>
</asp:Content>
