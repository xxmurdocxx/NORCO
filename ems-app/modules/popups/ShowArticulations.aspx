<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowArticulations.aspx.cs" Inherits="ems_app.modules.popups.ShowArticulations" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>College Articulations</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet"/>
    <style>
        .RadGrid .rgSelectedRow td {
            background: none !important;
        }
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">

        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" Modal="false"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <asp:SqlDataSource ID="sqlStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM LookupStatus"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct cif.subject_id, s.subject from (select outline_id, CollegeID from Articulation where CollegeID = @CollegeID) Ac join Course_IssuedForm cif on ac.outline_id = cif.outline_id and ac.CollegeID = cif.college_id join tblSubjects s on cif.subject_id = s.subject_id and cif.college_id = s.college_id where cif.college_id = @CollegeID order by s.subject">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlArticulationType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from ArticulationType"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlStages" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.Id, r.RoleName as 'Description' from Stages s join ROLES r on s.RoleId = r.RoleID where s.CollegeId =  @CollegeID">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlCourseMatches" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct isnull((select distinct ArticulationID from ArticulationDocuments  where ArticulationID = ac.id ),0) as Document, case when ac.ArticulationType = 1 then 'Course' else 'Occupation' end as 'TypeDescription', cc.Occupation, ac.id, ac.AceID, ac.TeamRevd, ac.ArticulationType, ac.outline_id, ac.Notes, ac.ArticulationStatus, ac.Articulate, ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.Exhibit, u.firstname + ', ' + u.lastname as 'FullName', case when mu.RoleID = @RoleID and s.[Order] > [dbo].[GetStageOrderByRoleId](@CollegeID,@RoleID) then 1 else 0 end 'checkUpdatedCurrentUser', case when ac.Articulate = 0 then concat( 'This articulation has been denied.<br><br> <b>Rationale :</b> <br><br>',case when len(ac.Notes) > 5 then Concat('Evaluator Notes : ', ac.Notes,'<br>') else '' end , case when len(ac.Justification) > 5 then Concat('Faculty Notes : ', ac.Justification,'<br>') else '' end , case when len(ac.ArticulationOfficerNotes) > 5 then Concat('Articulation Officer Notes : ', ac.ArticulationOfficerNotes,'<br>') else '' end ) else '' end as DeniedComments,  concat(cast(FORMAT(cc.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(cc.EndDate, 'MM/yy') as varchar(7))) as 'ExhibitDate', cc.StartDate, cc.EndDate, col.College, cc.Title, sub.[subject], cif.course_number, cif.course_title, [dbo].[GetArticulationMatrix](ac.id) 'Matrix' from Articulation ac left outer join ACEExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd   inner join tblusers u on ac.createdby = u.userid  left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id left outer join LookupColleges col on ac.CollegeID = col.collegeID left outer join Course_IssuedForm cif on ac.outline_id = cif.outline_id left outer join tblSubjects sub on cif.subject_id = sub.subject_id  where ac.outline_id = @outline_id and ac.ArticulationStage = @StageId and ac.ArticulationStatus = 1  order by ac.id">
                <SelectParameters>
                    <asp:Parameter Name="outline_id" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:QueryStringParameter Name="RoleID" QueryStringField="RoleID" Type="Int32" />
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlCourseMatchesPublished" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct isnull((select distinct ArticulationID from ArticulationDocuments  where ArticulationID = ac.id ),0) as Document, case when ac.ArticulationType = 1 then 'Course' else 'Occupation' end as 'TypeDescription', cc.Occupation, ac.id, ac.AceID, ac.TeamRevd, ac.ArticulationType, ac.outline_id, ac.Notes, ac.ArticulationStatus, ac.Articulate, ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.Exhibit, u.firstname + ', ' + u.lastname as 'FullName',  case when ac.Articulate = 0 then concat( 'This articulation has been denied.<br><br> <b>Rationale :</b> <br><br>',case when len(ac.Notes) > 5 then Concat('Evaluator Notes : ', ac.Notes,'<br>') else '' end , case when len(ac.Justification) > 5 then Concat('Faculty Notes : ', ac.Justification,'<br>') else '' end , case when len(ac.ArticulationOfficerNotes) > 5 then Concat('Articulation Officer Notes : ', ac.ArticulationOfficerNotes,'<br>') else '' end ) else '' end as DeniedComments, concat(cast(FORMAT(cc.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(cc.EndDate, 'MM/yy') as varchar(7)))  as 'ExhibitDate', cc.StartDate, cc.EndDate, col.College, cc.Title, sub.[subject], cif.course_number, cif.course_title, [dbo].[GetArticulationMatrix](ac.id) 'Matrix'  from Articulation ac left outer join AceExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd inner join tblusers u on ac.createdby = u.userid  left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id left outer join LookupColleges col on ac.CollegeID = col.collegeID left outer join Course_IssuedForm cif on ac.outline_id = cif.outline_id left outer join tblSubjects sub on cif.subject_id = sub.subject_id  where ac.outline_id = @outline_id  and ac.ArticulationStatus = 2  and ac.articulate <> 0  order by ac.id">
                <SelectParameters>
                    <asp:Parameter Name="outline_id" Type="Int32" />
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqlPublishedArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetInprocessPublishedArticulations" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:Parameter Name="articulate" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="status" Type="Int32" DefaultValue="2" />
                    <asp:Parameter Name="sorder" Type="Int32" DefaultValue="4" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlArticulationCoursesByStage" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetInprocessPublishedArticulations" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:Parameter Name="articulate" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="status" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="sorder" Type="Int32" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlDeniedArticulationCoursesByStage" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetInprocessPublishedArticulations" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:Parameter Name="articulate" Type="Int32" DefaultValue="0" />
                    <asp:Parameter Name="status" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="sorder" Type="Int32" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlArticulationCoursesByStageMost" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetInprocessPublishedArticulations" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:Parameter Name="articulate" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="status" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="sorder" Type="Int32" DefaultValue="1" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlDeniedArticulationCoursesByStageMost" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetInprocessPublishedArticulations" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:Parameter Name="articulate" Type="Int32" DefaultValue="0" />
                    <asp:Parameter Name="status" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="sorder" Type="Int32" DefaultValue="1" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlArticulationCoursesByStageLess" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetInprocessPublishedArticulations" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:Parameter Name="articulate" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="status" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="sorder" Type="Int32" DefaultValue="2" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlDeniedArticulationCoursesByStageLess" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetInprocessPublishedArticulations" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:Parameter Name="articulate" Type="Int32" DefaultValue="0" />
                    <asp:Parameter Name="status" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="sorder" Type="Int32" DefaultValue="2" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlArticulationCoursesByStageAwaiting" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetInprocessPublishedArticulations" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:Parameter Name="articulate" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="status" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="sorder" Type="Int32" DefaultValue="3" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlDeniedArticulationCoursesByStageAwaiting" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetInprocessPublishedArticulations" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                    <asp:Parameter Name="articulate" Type="Int32" DefaultValue="0" />
                    <asp:Parameter Name="status" Type="Int32" DefaultValue="1" />
                    <asp:Parameter Name="sorder" Type="Int32" DefaultValue="3" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlQualifiedVets" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct  vpo.Occupation,  v.LastName + ', ' + FirstName + ' ' + Coalesce(MiddleName,' ') as 'FullName', vl.OccupationCode as Occupation, Coalesce(Title,'Unknown') as Title from ( select distinct vl.LeadOutcomeID, vl.LeadStatusId, vl.ID, vl.CampaignID, vl.active, vo.OccupationCode, vo.VeteranId, vo.CollegeId from VeteranOccupation vo left outer join VeteranLead vl on vo.VeteranID = vl.VeteranId union select distinct vl.LeadOutcomeID, vl.LeadStatusId, vl.ID, vl.CampaignID, vl.active, v.Occupation, vl.VeteranID, c.CollegeID from VeteranLead vl left outer join Veteran v on vl.VeteranID = v.id join Campaign c on vl.CampaignID = c.ID ) vl left outer join Veteran v on vl.VeteranId = v.id left outer join View_MostCurrentOccupation moc on vl.OccupationCode = moc.occupation left outer join ( select * from ViewPublishedOccupations where college_id = @CollegeID) vpo on vl.OccupationCode = vpo.Occupation left outer join Campaign c on vl.CampaignID = c.ID  where VL.ACTIVE = 1 AND c.CampaignStatus = 1 AND vpo.Occupation is not null">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqlCourseArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct isnull((select distinct ArticulationID from ArticulationDocuments  where ArticulationID = ac.id ),0) as Document, case when ac.Articulate = 0 then 'Denied' else 'In Process' end as 'Articulate', ac.id, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, cc.Title, ac.TeamRevd,  u.firstname + ', ' + u.lastname as 'FullName', ac.CreatedOn, sub.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'FullCourse', sub.subject, cif.course_number,  concat(cast(FORMAT(cc.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(cc.EndDate, 'MM/yy') as varchar(7)))  ExhibitDate, cc.StartDate, cc.EndDate, dbo.CheckArticulationExistInCollege(@CollegeID, sub.subject, cif.course_number, ac.AceID, ac.TeamRevd) as adopted, col.College, [dbo].[GetArticulationMatrix](ac.id) 'Matrix'  from Articulation ac left outer join ACEExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd inner join tblusers u on ac.createdby = u.userid  left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id left outer join Course_IssuedForm cif on ac.outline_id = cif.outline_id left outer join tblsubjects sub on cif.subject_id = sub.subject_id left outer join LookupColleges col on ac.CollegeID = col.collegeID  where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and ac.ArticulationStatus = 1 and ac.articulate = 1 and ac.ArticulationType = 1 order by ac.CreatedOn desc">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqlDeniedCourseArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct isnull((select distinct ArticulationID from ArticulationDocuments  where ArticulationID = ac.id ),0) as Document, ac.Articulate, case when ac.Articulate = 0 then concat( 'This articulation has been denied.<br><br> <b>Rationale :</b><br><br>',case when len(ac.Notes) > 5 then Concat('Evaluator Notes : ', ac.Notes,'<br>') else '' end , case when len(ac.Justification) > 5 then Concat('Faculty Notes : ', ac.Justification,'<br>') else '' end , case when len(ac.ArticulationOfficerNotes) > 5 then Concat('Articulation Officer Notes : ', ac.ArticulationOfficerNotes,'<br>') else '' end ) else '' end as DeniedComments, ac.id, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, ac.Title, ac.TeamRevd,  u.firstname + ', ' + u.lastname as 'FullName', ac.CreatedOn, sub.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'FullCourse', sub.subject, cif.course_number,  concat(cast(FORMAT(cc.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(cc.EndDate, 'MM/yy') as varchar(7)))  ExhibitDate, cc.StartDate, cc.EndDate, col.College, [dbo].[GetArticulationMatrix](ac.id) 'Matrix'  from Articulation ac left outer join ACEExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd inner join tblusers u on ac.createdby = u.userid  left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id left outer join Course_IssuedForm cif on ac.outline_id = cif.outline_id left outer join tblsubjects sub on cif.subject_id = sub.subject_id left outer join LookupColleges col on ac.CollegeID = col.collegeID   where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and ac.ArticulationStatus = 1 and ac.articulate = 0 and ac.ArticulationType = 1 order by ac.CreatedOn desc">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqlOccupationArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select isnull((select distinct ArticulationID from ArticulationDocuments  where ArticulationID = ac.id ),0) as Document,  case when ac.Articulate = 0 then 'Denied' else 'In Process' end as 'Articulate', ac.id, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, cc.Title, ac.TeamRevd,  u.firstname + ', ' + u.lastname as 'FullName', ac.CreatedOn, cc.Occupation, cc.Title as 'Title', sub.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'FullCourse', sub.subject, cif.course_number,  concat(cast(FORMAT(cc.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(cc.EndDate, 'MM/yy') as varchar(7)))  ExhibitDate, cc.StartDate, cc.EndDate, dbo.CheckArticulationExistInCollege(@CollegeID, sub.subject, cif.course_number, ac.AceID, ac.TeamRevd ) adopted, col.College, [dbo].[GetArticulationMatrix](ac.id) 'Matrix' from Articulation ac left outer join ACEExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join tblusers u on ac.CreatedBy = u.userid left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id left outer join Course_IssuedForm cif on ac.outline_id = cif.outline_id  left outer join tblsubjects sub on cif.subject_id = sub.subject_id left outer join LookupColleges col on ac.CollegeID = col.collegeID where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and ac.ArticulationStatus = 1 and ac.articulate = 1 and ac.articulationtype = 2  order by ac.CreatedOn desc">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqlOccupationDeniedArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct isnull((select distinct ArticulationID from ArticulationDocuments  where ArticulationID = ac.id ),0) as Document, ac.Articulate, case when ac.Articulate = 0 then concat( 'This articulation has been denied.<br><br> <b>Rationale :</b><br><br>',case when len(ac.Notes) > 5 then Concat('Evaluator Notes : ', ac.Notes,'<br>') else '' end , case when len(ac.Justification) > 5 then Concat('Faculty Notes : ', ac.Justification,'<br>') else '' end , case when len(ac.ArticulationOfficerNotes) > 5 then Concat('Articulation Officer Notes : ', ac.ArticulationOfficerNotes,'<br>') else '' end ) else '' end as DeniedComments, ac.id, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, ac.Title, ac.TeamRevd,  u.firstname + ', ' + u.lastname as 'FullName', ac.CreatedOn, cc.Occupation, cc.Title as 'Title', sub.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'FullCourse', sub.subject, cif.course_number,  concat(cast(FORMAT(cc.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(cc.EndDate, 'MM/yy') as varchar(7)))  ExhibitDate, cc.StartDate, cc.EndDate, col.College, col.College, [dbo].[GetArticulationMatrix](ac.id) 'Matrix' from Articulation ac left outer join ACEExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join tblusers u on ac.CreatedBy = u.userid left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id left outer join Course_IssuedForm cif on ac.outline_id = cif.outline_id  left outer join tblsubjects sub on cif.subject_id = sub.subject_id left outer join LookupColleges col on ac.CollegeID = col.collegeID  where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and ac.ArticulationStatus = 1 and ac.articulationtype = 2 and ac.articulate = 0 order by ac.CreatedOn desc">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                    <asp:ControlParameter Name="StageId" ControlID="hvStageID" PropertyName="Value" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqlPublishedArticulationsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select a.* from ( select distinct isnull((select distinct ArticulationID from ArticulationDocuments  where ArticulationID = ac.id ),0) as Document, case when ac.ArticulationType = 1 then 'Course'  else 'Occupation' end as Type, ac.ArticulationStage, ac.id, ac.outline_id, ac.AceID, cc.Exhibit, ac.Title, ac.TeamRevd,  u.firstname + ', ' + u.lastname as 'FullName', ac.CreatedOn, sub.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'FullCourse', cc.Occupation, col.College, [dbo].[GetArticulationMatrix](ac.id) 'Matrix'  from Articulation ac left outer join ACEExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join tblusers u on ac.CreatedBy = u.userid left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id left outer join Course_IssuedForm cif on ac.outline_id = cif.outline_id left outer join tblsubjects sub on cif.subject_id = sub.subject_id left outer join LookupColleges col on ac.CollegeID = col.collegeID where cif.[college_id] = @CollegeID  and  ac.ArticulationStatus = 2 ) a   where  a.ArticulationStage = (select ID from Stages where CollegeId = @CollegeID and [order] = ( select max([order]) from stages where CollegeId = @CollegeID ) ) order by a.CreatedOn desc">
                <SelectParameters>
                    <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:HiddenField ID="hvStageID" runat="server" />
            <div style="padding: 15px !important;">
                <div class="row">
                    <div class="col-sm-8">
                        <h2 id="pageTitle" runat="server"></h2>
                    </div>
                    <div class="col-sm-4 text-right">
                        <div class="container" id="pnlOrderBy" runat="server">
                            <div class="col-sm-12 text-right" style="padding: 5px;">
                                <telerik:RadComboBox ID="rblSort" runat="server" AutoPostBack="true" Width="200px" OnSelectedIndexChanged="rblSort_SelectedIndexChanged" RenderMode="Lightweight" Label="Sort by ">
                                    <Items>
                                        <telerik:RadComboBoxItem Value="0" Text="Subject" />
                                        <telerik:RadComboBoxItem Value="1" Text="Most Articulations" />
                                        <telerik:RadComboBoxItem Value="2" Text="Least amount of Articulations" />
                                        <telerik:RadComboBoxItem Value="3" Text="Most number of days awaiting to process" />
                                    </Items>
                                </telerik:RadComboBox>
                            </div>
                        </div>
                    </div>
                </div>

                <telerik:RadGrid ID="rgPublishedArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlPublishedArticulationsDetail" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true" OnItemCommand="rgArticulations_ItemCommand" OnItemDataBound="rgArticulations_ItemDataBound" OnPreRender="grid_PreRender">
                    <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                        <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                        <ClientEvents />
                    </ClientSettings>
                    <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" FileName="PublishedArticulations" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left" >
                    </ExportSettings>
                    <MasterTableView Name="ParentGrid" DataSourceID="sqlPublishedArticulationsDetail" PageSize="12" DataKeyNames="id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true"  HeaderStyle-Font-Bold="true">
                        <CommandItemTemplate>
                            <div class="commandItems">
                                <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                    <ContentTemplate>
                                        <i class='fa fa-file-excel-o'></i> Export to Excel
                                    </ContentTemplate>
                                </telerik:RadButton>
                            </div>
                        </CommandItemTemplate>
                        <Columns>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square fa-lg" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false" Exportable="false"></telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                <ItemTemplate>
                                    <asp:LinkButton Visible="false" runat="server" ToolTip="Uploaded Articulation Documents" CommandName="ViewDocuments" ID="btnDocuments" Text='<i class="fa fa-file-text fa-lg" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false" Exportable="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Type" UniqueName="Type" SortExpression="Type" AllowFiltering="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" SortExpression="TeamRevd" AllowFiltering="true" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Occupation" UniqueName="Occupation" SortExpression="Occupation" AllowFiltering="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="FullCourse" HeaderText="Articulated to Course" DataField="FullCourse" UniqueName="FullCourse" AllowFiltering="true" ReadOnly="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                            </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="College" UniqueName="College" Display="false">
                                        </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>

                <asp:Panel ID="pnlArticulations" runat="server">
                    <telerik:RadTabStrip runat="server" ID="rtsArticulations" MultiPageID="RadMultiPage3" SelectedIndex="0" Width="99%" Height="50px" ShowBaseLine="false" RenderMode="Lightweight">
                        <Tabs>
                            <telerik:RadTab Text="Articulations In process" ToolTip="" Selected="True">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Denied Articulations" ToolTip="">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage runat="server" ID="RadMultiPage3" SelectedIndex="0" Width="99%" RenderMode="Lightweight">
                        <telerik:RadPageView runat="server" ID="RadPageView5" Width="100%">
                            <telerik:RadGrid ID="rgArticulationCourses" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationCoursesByStage" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true" OnItemCommand="rgArticulations_ItemCommand" OnItemDataBound="rgArticulationCourses_ItemDataBound" OnPreRender="grid_PreRender">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
                                    <ClientEvents />
                                </ClientSettings>
                                <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                                </ExportSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulationCoursesByStage" PageSize="12" DataKeyNames="outline_id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" HierarchyDefaultExpanded="true" HierarchyLoadMode="Client" EnableHierarchyExpandAll="true"  ShowFooter="false" ShowGroupFooter="false">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                            <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                                <ContentTemplate>
                                                    <i class='fa fa-file-excel-o'></i> Export to Excel
                                                </ContentTemplate>
                                            </telerik:RadButton>
                                        </div>
                                    </CommandItemTemplate>
                                    <DetailTables>
                                        <telerik:GridTableView Name="ChildGrid" DataKeyNames="id" DataSourceID="sqlCourseMatches" Width="100%" AllowMultiColumnSorting="true" runat="server" CommandItemDisplay="None" AllowFilteringByColumn="true" CommandItemSettings-ShowAddNewRecordButton="false" HeaderStyle-Font-Bold="true" >
                                            <ParentTableRelation>
                                                <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                            </ParentTableRelation>
                                            <Columns>
                                                <telerik:GridTemplateColumn AllowFiltering="false" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                        <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                            <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                        </telerik:RadToolTip>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square fa-lg" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:LinkButton Visible="false" runat="server" ToolTip="Uploaded Articulation Documents" CommandName="ViewDocuments" ID="btnDocuments" Text='<i class="fa fa-file-text fa-lg" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" >
                                                </telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" Display="false" Exportable="false">
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataSourceID="sqlStatus" ListTextField="description" ListValueField="id" UniqueName="status_id" SortExpression="status_id" HeaderText="Status" DataField="status_id" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="70px" ReadOnly="true" Display="false" Exportable="false">
                                                    <FilterTemplate>
                                                        <telerik:RadComboBox ID="RadComboBoxStatus" DataSourceID="sqlStatus" DataTextField="description"
                                                            DataValueField="id" Height="100px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("status_id").CurrentFilterValue %>'
                                                            runat="server" OnClientSelectedIndexChanged="StatusIndexChanged">
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="All" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                        <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                                            <script type="text/javascript">
                                                                function StatusIndexChanged(sender, args) {
                                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                    tableView.filter("status_id", args.get_item().get_value(), "EqualTo");
                                                                }
                                                            </script>
                                                        </telerik:RadScriptBlock>
                                                    </FilterTemplate>
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn SortExpression="subject" HeaderText="subject" DataField="subject" UniqueName="subject" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Exportable="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Exportable="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px" Exportable="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="TypeDescription" UniqueName="TypeDescription" HeaderText="Type" SortExpression="TypeDescription" AllowFiltering="false" >
                                                </telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataSourceID="sqlStages" ListTextField="description" ListValueField="id" UniqueName="stage_id" SortExpression="stage_id" HeaderText="Stage" DataField="stage_id" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="90px" ReadOnly="true">
                                                    <FilterTemplate>
                                                        <telerik:RadComboBox ID="RadComboBoxStage" DataSourceID="sqlStages" DataTextField="description"
                                                            DataValueField="id" Height="150px" Width="140px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("stage_id").CurrentFilterValue %>'
                                                            runat="server" OnClientSelectedIndexChanged="StageIndexChanged">
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="All" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                        <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                                            <script type="text/javascript">
                                                                function StageIndexChanged(sender, args) {
                                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                    tableView.filter("stage_id", args.get_item().get_value(), "EqualTo");
                                                                }
                                                            </script>
                                                        </telerik:RadScriptBlock>
                                                    </FilterTemplate>
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="110px" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation Code" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Title" HeaderText="ACE Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="290px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Notes" HeaderText="Notes" DataField="Notes" UniqueName="Notes" AllowFiltering="false" ReadOnly="true" Display="false">
                                                </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes" Exportable="false">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip101" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                                                    <%# DataBinder.Eval(Container, "DataItem.Notes") %>
                                                    </telerik:RadToolTip>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="College" UniqueName="College" Display="false" Exportable="false">
                                        </telerik:GridBoundColumn>
                                            </Columns>
                                        </telerik:GridTableView>
                                    </DetailTables>
                                    <Columns>
                                        <telerik:GridBoundColumn SortExpression="ExistCheckList" HeaderText="Shared Curriculum" UniqueName="ExistCheckList" DataField="ExistCheckList" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px"  AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px" Exportable="false">
                                            <FilterTemplate>
                                                <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                                    DataValueField="subject" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                    runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged2">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="All" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                                <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                                                    <script type="text/javascript">
                                                        function SubjectIndexChanged2(sender, args) {
                                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                            tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                        }
                                                    </script>
                                                </telerik:RadScriptBlock>
                                            </FilterTemplate>
                                        </telerik:GridDropDownColumn>
                                        <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"   Exportable="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                            <telerik:RadGrid ID="rgPublishedCourses" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlPublishedArticulations" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true" OnItemCommand="rgArticulations_ItemCommand" OnItemDataBound="rgArticulationCourses_ItemDataBound" OnPreRender="grid_PreRender">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
                                    <ClientEvents />
                                </ClientSettings>
                                <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                                </ExportSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlPublishedArticulations" PageSize="12" DataKeyNames="outline_id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" HierarchyDefaultExpanded="true" HierarchyLoadMode="Client" EnableHierarchyExpandAll="true" ShowFooter="false" ShowGroupFooter="false">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                            <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                                <ContentTemplate>
                                                    <i class='fa fa-file-excel-o'></i> Export to Excel
                                                </ContentTemplate>
                                            </telerik:RadButton>
                                        </div>
                                    </CommandItemTemplate>
                                    <DetailTables>
                                        <telerik:GridTableView Name="ChildGrid" DataKeyNames="id" DataSourceID="sqlCourseMatchesPublished" Width="100%" AllowMultiColumnSorting="true" runat="server" CommandItemDisplay="None" AllowFilteringByColumn="true" CommandItemSettings-ShowAddNewRecordButton="false" HeaderStyle-Font-Bold="true" >
                                            <ParentTableRelation>
                                                <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                            </ParentTableRelation>
                                            <Columns>
                                                <telerik:GridTemplateColumn AllowFiltering="false" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                        <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip99" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                            <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                        </telerik:RadToolTip>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square fa-lg" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:LinkButton Visible="false" runat="server" ToolTip="Uploaded Articulation Documents" CommandName="ViewDocuments" ID="btnDocuments" Text='<i class="fa fa-file-text fa-lg" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" >
                                                </telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" Display="false" Exportable="false">
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataSourceID="sqlStatus" ListTextField="description" ListValueField="id" UniqueName="status_id" SortExpression="status_id" HeaderText="Status" DataField="status_id" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="70px" ReadOnly="true" Display="false" Exportable="false">
                                                    <FilterTemplate>
                                                        <telerik:RadComboBox ID="RadComboBoxStatus" DataSourceID="sqlStatus" DataTextField="description"
                                                            DataValueField="id" Height="100px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("status_id").CurrentFilterValue %>'
                                                            runat="server" OnClientSelectedIndexChanged="StatusIndexChanged">
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="All" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                        <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                                            <script type="text/javascript">
                                                                function StatusIndexChanged(sender, args) {
                                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                    tableView.filter("status_id", args.get_item().get_value(), "EqualTo");
                                                                }
                                                            </script>
                                                        </telerik:RadScriptBlock>
                                                    </FilterTemplate>
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn SortExpression="subject" HeaderText="subject" DataField="subject" UniqueName="subject" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Exportable="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Exportable="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px" Exportable="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="TypeDescription" UniqueName="TypeDescription" HeaderText="Type" SortExpression="TypeDescription"  AllowFiltering="false" >
                                                </telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataSourceID="sqlStages" ListTextField="description" ListValueField="id" UniqueName="stage_id" SortExpression="stage_id" HeaderText="Stage" DataField="stage_id" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="90px" ReadOnly="true">
                                                    <FilterTemplate>
                                                        <telerik:RadComboBox ID="RadComboBoxStage" DataSourceID="sqlStages" DataTextField="description"
                                                            DataValueField="id" Height="150px" Width="140px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("stage_id").CurrentFilterValue %>'
                                                            runat="server" OnClientSelectedIndexChanged="StageIndexChanged">
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="All" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                        <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                                            <script type="text/javascript">
                                                                function StageIndexChanged(sender, args) {
                                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                    tableView.filter("stage_id", args.get_item().get_value(), "EqualTo");
                                                                }
                                                            </script>
                                                        </telerik:RadScriptBlock>
                                                    </FilterTemplate>
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="110px" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" >
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation Code" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Title" HeaderText="ACE Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="290px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Notes" HeaderText="Notes" DataField="Notes" UniqueName="Notes" AllowFiltering="false" ReadOnly="true" Display="false">
                                                </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes" Exportable="false">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip33" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                                                    <%# DataBinder.Eval(Container, "DataItem.Notes") %>
                                                    </telerik:RadToolTip>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="College" UniqueName="College" Display="false" Exportable="false">
                                        </telerik:GridBoundColumn>
                                            </Columns>
                                        </telerik:GridTableView>
                                    </DetailTables>
                                    <Columns>
                                        <telerik:GridBoundColumn SortExpression="ExistCheckList" HeaderText="Shared Curriculum" UniqueName="ExistCheckList" DataField="ExistCheckList" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px"  AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px" Exportable="false">
                                            <FilterTemplate>
                                                <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                                    DataValueField="subject" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                    runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged2">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="All" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                                <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                                                    <script type="text/javascript">
                                                        function SubjectIndexChanged2(sender, args) {
                                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                            tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                        }
                                                    </script>
                                                </telerik:RadScriptBlock>
                                            </FilterTemplate>
                                        </telerik:GridDropDownColumn>
                                        <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px" Exportable="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="RadPageView6" Width="100%">
                            <telerik:RadGrid ID="rgDeniedArticulationCourses" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlDeniedArticulationCoursesByStage" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true" OnItemCommand="rgArticulations_ItemCommand" OnItemDataBound="rgArticulationCourses_ItemDataBound" OnPreRender="grid_PreRender">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
                                    <ClientEvents />
                                </ClientSettings>
                                <ExportSettings HideStructureColumns="true"  IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                                </ExportSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlDeniedArticulationCoursesByStage" PageSize="12" DataKeyNames="outline_id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" ItemStyle-BackColor="#ffb6c1" AlternatingItemStyle-BackColor="#ffb6c1" HeaderStyle-Font-Bold="true" HierarchyDefaultExpanded="true" HierarchyLoadMode="Client" EnableHierarchyExpandAll="true" ShowFooter="false" ShowGroupFooter="false">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                            <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                                <ContentTemplate>
                                                    <i class='fa fa-file-excel-o'></i> Export to Excel
                                                </ContentTemplate>
                                            </telerik:RadButton>
                                        </div>
                                    </CommandItemTemplate>
                                    <DetailTables>
                                        <telerik:GridTableView Name="ChildGrid" DataKeyNames="id" DataSourceID="sqlCourseMatches" Width="100%" AllowMultiColumnSorting="true" runat="server" CommandItemDisplay="None" AllowFilteringByColumn="true" CommandItemSettings-ShowAddNewRecordButton="false" HeaderStyle-Font-Bold="true" >
                                            <ParentTableRelation>
                                                <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                            </ParentTableRelation>
                                            <Columns>
                                                <telerik:GridTemplateColumn AllowFiltering="false" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                        <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip16551" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                            <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                        </telerik:RadToolTip>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false" >
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square fa-lg" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:LinkButton Visible="false" runat="server" ToolTip="Uploaded Articulation Documents" CommandName="ViewDocuments" ID="btnDocuments" Text='<i class="fa fa-file-text fa-lg" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" Display="false" Exportable="false">
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" >
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataSourceID="sqlStatus" ListTextField="description" ListValueField="id" UniqueName="status_id" SortExpression="status_id" HeaderText="Status" DataField="status_id" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="70px" ReadOnly="true" Display="false" Exportable="false">
                                                    <FilterTemplate>
                                                        <telerik:RadComboBox ID="RadComboBoxStatus" DataSourceID="sqlStatus" DataTextField="description"
                                                            DataValueField="id" Height="100px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("status_id").CurrentFilterValue %>'
                                                            runat="server" OnClientSelectedIndexChanged="StatusIndexChanged">
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="All" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                        <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                                            <script type="text/javascript">
                                                                function StatusIndexChanged(sender, args) {
                                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                    tableView.filter("status_id", args.get_item().get_value(), "EqualTo");
                                                                }
                                                            </script>
                                                        </telerik:RadScriptBlock>
                                                    </FilterTemplate>
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn SortExpression="subject" HeaderText="subject" DataField="subject" UniqueName="subject" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Exportable="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Exportable="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px" Exportable="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="TypeDescription" UniqueName="TypeDescription" HeaderText="Type" SortExpression="TypeDescription"  AllowFiltering="false" >
                                                </telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataSourceID="sqlStages" ListTextField="description" ListValueField="id" UniqueName="stage_id" SortExpression="stage_id" HeaderText="Stage" DataField="stage_id" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="90px" ReadOnly="true">
                                                    <FilterTemplate>
                                                        <telerik:RadComboBox ID="RadComboBoxStage" DataSourceID="sqlStages" DataTextField="description"
                                                            DataValueField="id" Height="150px" Width="140px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("stage_id").CurrentFilterValue %>'
                                                            runat="server" OnClientSelectedIndexChanged="StageIndexChanged">
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="All" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                        <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                                            <script type="text/javascript">
                                                                function StageIndexChanged(sender, args) {
                                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                    tableView.filter("stage_id", args.get_item().get_value(), "EqualTo");
                                                                }
                                                            </script>
                                                        </telerik:RadScriptBlock>
                                                    </FilterTemplate>
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="110px" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation Code" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Title" HeaderText="ACE Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="290px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Notes" HeaderText="Notes" DataField="Notes" UniqueName="Notes" AllowFiltering="false" ReadOnly="true" Display="false">
                                                </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes" Exportable="false">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip55" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                                                    <%# DataBinder.Eval(Container, "DataItem.Notes") %>
                                                    </telerik:RadToolTip>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="College" UniqueName="College" Display="false" Exportable="false">
                                        </telerik:GridBoundColumn>
                                            </Columns>
                                        </telerik:GridTableView>
                                    </DetailTables>
                                    <Columns>
                                        <telerik:GridBoundColumn SortExpression="ExistCheckList" HeaderText="Shared Curriculum" UniqueName="ExistCheckList" DataField="ExistCheckList" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px"  AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px" Exportable="false">
                                            <FilterTemplate>
                                                <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                                    DataValueField="subject" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                    runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="All" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                                <telerik:RadScriptBlock ID="RadScriptBlock333" runat="server">
                                                    <script type="text/javascript">
                                                        function SubjectIndexChanged(sender, args) {
                                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                            tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                        }
                                                    </script>
                                                </telerik:RadScriptBlock>
                                            </FilterTemplate>
                                        </telerik:GridDropDownColumn>
                                        <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px" Exportable="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </asp:Panel>


                <asp:Panel ID="pnlOccupations" runat="server">
                    <telerik:RadTabStrip runat="server" ID="rtsOccupations" MultiPageID="RadMultiPage1" SelectedIndex="0" Width="99%" Height="50px" ShowBaseLine="false" RenderMode="Lightweight">
                        <Tabs>
                            <telerik:RadTab Text="Articulations In process" ToolTip="" Selected="True">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Denied Articulations" ToolTip="">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage runat="server" ID="RadMultiPage1" SelectedIndex="0" Width="99%" RenderMode="Lightweight">
                        <telerik:RadPageView runat="server" ID="RadPageView1" Width="100%">
                            <telerik:RadGrid ID="rgOccupations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOccupationArticulations" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true" OnItemCommand="rgArticulations_ItemCommand" OnItemDataBound="rgArticulations_ItemDataBound" OnPreRender="grid_PreRender">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                                    <ClientEvents />
                                </ClientSettings>
                                <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                                </ExportSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlOccupationArticulations" PageSize="12" DataKeyNames="id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                            <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                                <ContentTemplate>
                                                    <i class='fa fa-file-excel-o'></i> Export to Excel
                                                </ContentTemplate>
                                            </telerik:RadButton>
                                        </div>
                                    </CommandItemTemplate>
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:LinkButton Visible="false" runat="server" ToolTip="Uploaded Articulation Documents" CommandName="ViewDocuments" ID="btnDocuments" Text='<i class="fa fa-file-text fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false">
                                        </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" >
                                            </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" SortExpression="TeamRevd" AllowFiltering="true" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation Code" DataField="Occupation" UniqueName="Occupation" AllowFiltering="true" ReadOnly="true" FilterControlWidth="50px" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="Occupation Description" DataField="Title" UniqueName="Title" AllowFiltering="true" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Subject" HeaderText="Subject" DataField="Subject" UniqueName="Subject" AllowFiltering="true" FilterControlWidth="50px" HeaderStyle-Width="60px">
                                        </telerik:GridBoundColumn>
                                       <telerik:GridBoundColumn SortExpression="Course_number" HeaderText="Course Number" DataField="Course_number" UniqueName="Course_number" AllowFiltering="true" FilterControlWidth="50px" HeaderStyle-Width="60px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullCourse" HeaderText="Articulated to Course" DataField="FullCourse" UniqueName="FullCourse" AllowFiltering="true" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="adopted" UniqueName="adopted" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="College" UniqueName="College" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="RadPageView2" Width="100%">
                            <telerik:RadGrid ID="rgDeniedOccupations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOccupationDeniedArticulations" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true" OnItemCommand="rgArticulations_ItemCommand" OnItemDataBound="rgDeniedOccupations_ItemDataBound" OnPreRender="grid_PreRender">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                                    <ClientEvents />
                                </ClientSettings>
                                <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                                </ExportSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlOccupationDeniedArticulations" PageSize="12" DataKeyNames="id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" ItemStyle-BackColor="#ffb6c1" AlternatingItemStyle-BackColor="#ffb6c1" HeaderStyle-Font-Bold="true">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                            <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                                <ContentTemplate>
                                                    <i class='fa fa-file-excel-o'></i> Export to Excel
                                                </ContentTemplate>
                                            </telerik:RadButton>
                                        </div>
                                    </CommandItemTemplate>
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip99" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                    <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                </telerik:RadToolTip>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:LinkButton Visible="false" runat="server" ToolTip="Uploaded Articulation Documents" CommandName="ViewDocuments" ID="btnDocuments" Text='<i class="fa fa-file-text fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" >
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" SortExpression="TeamRevd" AllowFiltering="true" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation Code" DataField="Occupation" UniqueName="Occupation" AllowFiltering="true" ReadOnly="true" FilterControlWidth="50px" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="Occupation Description" DataField="Title" UniqueName="Title" AllowFiltering="true" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Subject" HeaderText="Subject" DataField="Subject" UniqueName="Subject" AllowFiltering="true" FilterControlWidth="50px" HeaderStyle-Width="60px">
                                        </telerik:GridBoundColumn>
                                       <telerik:GridBoundColumn SortExpression="Course_number" HeaderText="Course Number" DataField="Course_number" UniqueName="Course_number" AllowFiltering="true" FilterControlWidth="50px" HeaderStyle-Width="60px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullCourse" HeaderText="Articulated to Course" DataField="FullCourse" UniqueName="FullCourse" AllowFiltering="true" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="College" UniqueName="College" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </asp:Panel>

                <asp:Panel ID="pnlCourses" runat="server">
                    <telerik:RadTabStrip runat="server" ID="rtsCourses" MultiPageID="RadMultiPage2" SelectedIndex="0" Width="99%" Height="50px" ShowBaseLine="false" RenderMode="Lightweight">
                        <Tabs>
                            <telerik:RadTab Text="Articulations In process" ToolTip="" Selected="True">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Denied Articulations" ToolTip="">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage runat="server" ID="RadMultiPage2" SelectedIndex="0" Width="99%" RenderMode="Lightweight">
                        <telerik:RadPageView runat="server" ID="RadPageView3" Width="100%">
                            <telerik:RadGrid ID="rgArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlCourseArticulations" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true" OnItemCommand="rgArticulations_ItemCommand" OnItemDataBound="rgArticulations_ItemDataBound" OnPreRender="grid_PreRender">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                                    <ClientEvents />
                                </ClientSettings>
                                <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                                </ExportSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlCourseArticulations" PageSize="12" DataKeyNames="id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                            <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                                <ContentTemplate>
                                                    <i class='fa fa-file-excel-o'></i> Export to Excel
                                                </ContentTemplate>
                                            </telerik:RadButton>
                                        </div>
                                    </CommandItemTemplate>
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:LinkButton Visible="false" runat="server" ToolTip="Uploaded Articulation Documents" CommandName="ViewDocuments" ID="btnDocuments" Text='<i class="fa fa-file-text fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" >
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" SortExpression="TeamRevd" AllowFiltering="true" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="ACE Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Subject" HeaderText="Subject" DataField="Subject" UniqueName="Subject" AllowFiltering="true" FilterControlWidth="50px" HeaderStyle-Width="60px">
                                        </telerik:GridBoundColumn>
                                       <telerik:GridBoundColumn SortExpression="Course_number" HeaderText="Course Number" DataField="Course_number" UniqueName="Course_number" AllowFiltering="true" FilterControlWidth="50px" HeaderStyle-Width="60px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullCourse" HeaderText="Articulated to Course" DataField="FullCourse" UniqueName="FullCourse" AllowFiltering="true" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="adopted" UniqueName="adopted" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="College" UniqueName="College" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="RadPageView4" Width="100%">
                            <telerik:RadGrid ID="rgDeniedArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlDeniedCourseArticulations" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true" OnItemCommand="rgArticulations_ItemCommand" OnItemDataBound="rgDeniedOccupations_ItemDataBound" OnPreRender="grid_PreRender">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                                    <ClientEvents />
                                </ClientSettings>
                                <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                                </ExportSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlDeniedCourseArticulations" PageSize="12" DataKeyNames="id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" ItemStyle-BackColor="#ffb6c1" AlternatingItemStyle-BackColor="#ffb6c1" HeaderStyle-Font-Bold="true">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                            <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                                <ContentTemplate>
                                                    <i class='fa fa-file-excel-o'></i> Export to Excel
                                                </ContentTemplate>
                                            </telerik:RadButton>
                                        </div>
                                    </CommandItemTemplate>
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip9999" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                    <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                </telerik:RadToolTip>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false" Exportable="false"></telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:LinkButton Visible="false" runat="server" ToolTip="Uploaded Articulation Documents" CommandName="ViewDocuments" ID="btnDocuments" Text='<i class="fa fa-file-text fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" >
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" SortExpression="TeamRevd" AllowFiltering="true" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="ACE Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Subject" HeaderText="Subject" DataField="Subject" UniqueName="Subject" AllowFiltering="true" FilterControlWidth="50px" HeaderStyle-Width="60px" >
                                        </telerik:GridBoundColumn>
                                       <telerik:GridBoundColumn SortExpression="Course_number" HeaderText="Course Number" DataField="Course_number" UniqueName="Course_number" AllowFiltering="true" FilterControlWidth="50px" HeaderStyle-Width="60px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullCourse" HeaderText="Articulated to Course" DataField="FullCourse" UniqueName="FullCourse" AllowFiltering="true" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="true" ReadOnly="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="College" UniqueName="College" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </asp:Panel>

                <telerik:RadGrid ID="rgVeteranLeads" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlQualifiedVets" Width="100%" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" OnPreRender="grid_PreRender">
                    <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                    <ExportSettings FileName="VeteransLeadsReport" ExportOnlyData="True" IgnorePaging="True" Excel-DefaultCellAlignment="Left">
                    </ExportSettings>
                    <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" AllowKeyboardNavigation="true" Resizing-AllowColumnResize="true">
                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                    </ClientSettings>
                    <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlQualifiedVets" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="Top" NoMasterRecordsText="No records to display" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" Name="ParentGrid">

                        <CommandItemTemplate>
                            <div class="commandItems">
                                <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                    <ContentTemplate>
                                        <i class='fa fa-file-excel-o'></i> Export to Excel
                                    </ContentTemplate>
                                </telerik:RadButton>
                            </div>
                        </CommandItemTemplate>

                        <Columns>
                            <telerik:GridBoundColumn DataField="FullName" FilterControlAltText="Filter FullName column" HeaderText="Veteran" SortExpression="FullName" UniqueName="FullName" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ItemStyle-Wrap="false" />
                            <telerik:GridBoundColumn DataField="Occupation" UniqueName="Occupation" HeaderText="Occupation Code" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="90px" ItemStyle-Width="75px" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Title" UniqueName="Title" HeaderText="Occupation Title" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="340px" ItemStyle-Width="110px" FilterControlWidth="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-Wrap="false">
                            </telerik:GridBoundColumn>
                        </Columns>
                        <NoRecordsTemplate>
                            <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                &nbsp;No items to view
                            </div>
                        </NoRecordsTemplate>
                    </MasterTableView>
                </telerik:RadGrid>

            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
        <script type="text/javascript">

            function onRequestStart(sender, args) {
                if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                    args.set_enableAjax(false);
                    document.forms[0].target = "_blank";
                }
            }
        </script>
</body>
</html>




