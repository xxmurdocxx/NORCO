<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="ArticulationReport.aspx.cs" Inherits="ems_app.modules.military.ArticulationReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Manage Articulations</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct pif.program_id, isnull(pif.program,'') + ' - ' + cast(isnull(pif.description,'') as varchar(20)) as 'program' from (select outline_id from Articulation where CollegeID = @CollegeID) Ac join tblProgramCourses pc on ac.outline_id = pc.outline_id join Program_IssuedForm pif on pc.program_id = pif.program_id where pif.status = 0 and pif.[college_id] = @CollegeID">
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
    <asp:SqlDataSource ID="sqlStages" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.Id as stage_id, r.RoleName as 'Description' from Stages s join ROLES r on s.RoleId = r.RoleID where s.CollegeId =  @CollegeID">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseMatches" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct ac.outline_id, s.RoleID, ac.id, ac.ArticulationType, ac. AceID, ac.ArticulationStatus, ac.ArticulationStage , ac.TeamRevd, case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Office Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes, ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.Exhibit, u.firstname + ', ' + u.lastname as 'FullName', cc.Occupation, cc.Title, case when mu.RoleID = @RoleID and s.[Order] > [dbo].[GetStageOrderByRoleId](@CollegeID,@RoleID) then 1 else 0 end 'checkUpdatedCurrentUser' from Articulation ac left outer join MostCurrentACEOccupation cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join tblusers u on ac.CreatedBy = u.userid left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id where ac.outline_id = @outline_id order by ac.ArticulationType, ac.AceID, ac.TeamRevd" >
        <SelectParameters>
            <asp:Parameter Name="outline_id" Type="Int32" />
            <asp:SessionParameter Name="RoleID" SessionField="RoleID" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseMatchesByRole" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct  ac.outline_id, s.RoleID, ac.id, ac.ArticulationType, ac. AceID, ac.ArticulationStatus, ac.ArticulationStage , ac.TeamRevd, case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Office Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes, ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.Exhibit, u.firstname + ', ' + u.lastname as 'FullName', cc.Occupation, cc.Title, case when mu.RoleID = @RoleID and s.[Order] > [dbo].[GetStageOrderByRoleId](@CollegeID,@RoleID) then 1 else 0 end 'checkUpdatedCurrentUser' from Articulation ac left outer join MostCurrentACEOccupation cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join tblusers u on ac.CreatedBy = u.userid left outer join TBLUSERS mu on ac.ModifiedBy = mu.UserID left outer join Stages s on ac.ArticulationStage = s.Id where ac.outline_id = @outline_id and s.RoleId = @RoleID and ac.articulationstatus = 1 order by ac.ArticulationType, ac.AceID, ac.TeamRevd" >
        <SelectParameters>
            <asp:Parameter Name="outline_id" Type="Int32" />
            <asp:SessionParameter Name="RoleID" SessionField="RoleID" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM LookupStatus"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  distinct 0 as 'ArticulationCount', 0 as 'DaysAwaiting', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title  FROM ( select outline_id from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id where cif.[college_id] = @CollegeID order by S.subject , cif.course_number">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesMost" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT   count(*) ArticulationCount, 0 as 'DaysAwaiting', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title  FROM ( select outline_id from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id where cif.[college_id] = @CollegeID group by ac.outline_id, cif.subject_id, S.subject , cif.course_number, cif.course_title order by 'ArticulationCount' desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesLess" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT   count(*) ArticulationCount, 0 as 'DaysAwaiting', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title  FROM ( select outline_id from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id where cif.[college_id] = @CollegeID group by ac.outline_id, cif.subject_id, S.subject , cif.course_number, cif.course_title order by 'ArticulationCount' asc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesAwaiting" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT distinct 0 ArticulationCount, ac.outline_id, 1 as 'articulation_type', max ( DATEDIFF(day, app.submission,GETDATE()) ) as 'DaysAwaiting', cif.subject_id, S.subject , cif.course_number, cif.course_title  FROM ( select outline_id from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id left outer join ( select outline_id,  max(SubmissionDate) submission from ArticulationApproval aa left outer join Stages s on aa.StageId = s.Id left outer join roles r on s.RoleId = r.RoleID where aa.Approved = 0 and r.ReviewArticulations = 1 group by outline_id ) app on ac.outline_id = app.outline_id   where cif.[college_id] = @CollegeID  group by ac.outline_id, cif.subject_id, S.subject , cif.course_number, cif.course_title order by 'DaysAwaiting' desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesByStage" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  distinct 0 as 'ArticulationCount', 0 as 'DaysAwaiting', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title FROM ( select outline_id, ArticulationStage, ArticulationStatus from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and ac.ArticulationStatus = 1 order by S.subject , cif.course_number">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:ControlParameter ControlID="hfStageID" PropertyName="Value" Name="StageID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesByStageMost" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  count(*) ArticulationCount, 0 as 'DaysAwaiting', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title FROM ( select outline_id, ArticulationStage, ArticulationStatus from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and ac.ArticulationStatus = 1 group by ac.outline_id, cif.subject_id, S.subject , cif.course_number, cif.course_title order by 'ArticulationCount' desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:ControlParameter ControlID="hfStageID" PropertyName="Value" Name="StageID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesByStageLess" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  count(*) ArticulationCount, 0 as 'DaysAwaiting', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title FROM ( select outline_id, ArticulationStage, ArticulationStatus from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and ac.ArticulationStatus = 1 group by ac.outline_id, cif.subject_id, S.subject , cif.course_number, cif.course_title order by 'ArticulationCount' asc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:ControlParameter ControlID="hfStageID" PropertyName="Value" Name="StageID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesByStageAwaiting" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  0 as 'ArticulationCount', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title, max ( DATEDIFF(day, app.submission,GETDATE()) ) as 'DaysAwaiting'  FROM ( select outline_id, ArticulationStage, ArticulationStatus from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id left outer join ( select outline_id,  max(SubmissionDate) submission from ArticulationApproval aa left outer join Stages s on aa.StageId = s.Id left outer join roles r on s.RoleId = r.RoleID where aa.Approved = 0 and r.ReviewArticulations = 1 group by outline_id ) app on ac.outline_id = app.outline_id where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and ac.ArticulationStatus = 1 group by ac.outline_id, cif.subject_id, S.subject , cif.course_number, cif.course_title order by 'DaysAwaiting' desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:ControlParameter ControlID="hfStageID" PropertyName="Value" Name="StageID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="sqlArticulationCoursesByReview" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  distinct 0 as 'ArticulationCount', 0 as 'DaysAwaiting', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title FROM ( select outline_id, ArticulationStage, ArticulationStatus from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id  where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and cif.subject_id in ( select SubjectID from UserSubjects where UserID = @UserID ) and ac.ArticulationStatus = 1">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            <asp:ControlParameter ControlID="hfStageID" PropertyName="Value" Name="StageID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesByReviewMost" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  count(*) ArticulationCount, 0 as 'DaysAwaiting', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title FROM ( select outline_id, ArticulationStage, ArticulationStatus from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id  where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and cif.subject_id in ( select SubjectID from UserSubjects where UserID = @UserID ) and ac.ArticulationStatus = 1 group by ac.outline_id, cif.subject_id, S.subject , cif.course_number, cif.course_title order by 'ArticulationCount' desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            <asp:ControlParameter ControlID="hfStageID" PropertyName="Value" Name="StageID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesByReviewLess" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  count(*) ArticulationCount, 0 as 'DaysAwaiting', ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title FROM ( select outline_id, ArticulationStage, ArticulationStatus from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id  where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and cif.subject_id in ( select SubjectID from UserSubjects where UserID = @UserID ) and ac.ArticulationStatus = 1 group by ac.outline_id, cif.subject_id, S.subject , cif.course_number, cif.course_title order by 'ArticulationCount' asc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            <asp:ControlParameter ControlID="hfStageID" PropertyName="Value" Name="StageID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCoursesByReviewAwaiting" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  0 ArticulationCount,  ac.outline_id, 1 as 'articulation_type', cif.subject_id, S.subject , cif.course_number, cif.course_title, max ( DATEDIFF(day, app.submission,GETDATE()) ) as 'DaysAwaiting' FROM ( select outline_id, ArticulationStage, ArticulationStatus from Articulation where CollegeID = @CollegeID ) ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id left outer join ( select outline_id,  max(SubmissionDate) submission from ArticulationApproval aa left outer join Stages s on aa.StageId = s.Id left outer join roles r on s.RoleId = r.RoleID where aa.Approved = 0 and r.ReviewArticulations = 1 group by outline_id ) app on ac.outline_id = app.outline_id where cif.[college_id] = @CollegeID and ac.ArticulationStage = @StageId and cif.subject_id in ( select SubjectID from UserSubjects where UserID = @UserID ) and ac.ArticulationStatus = 1 group by ac.outline_id, cif.subject_id, S.subject , cif.course_number, cif.course_title order by 'DaysAwaiting' desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            <asp:ControlParameter ControlID="hfStageID" PropertyName="Value" Name="StageID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <div class="container">
            <div class="col-sm-12 text-right" style="padding:5px;">
                <asp:HiddenField ID="hfStageID" runat="server" />
                <telerik:RadComboBox ID="rblSort" runat="server" AutoPostBack="true" Width="200px" OnSelectedIndexChanged="rblSort_SelectedIndexChanged" RenderMode="Lightweight" Label="Sort by ">
                    <Items>
                        <telerik:RadComboBoxItem Value="0" Text="" />
                        <telerik:RadComboBoxItem Value="1" Text="Most Articulations" />
                        <telerik:RadComboBoxItem Value="2" Text="Less Articulations" />
                        <telerik:RadComboBoxItem Value="3" Text="Most number of days awaiting to process" />
                    </Items>
                </telerik:RadComboBox>
            </div>
        </div>

        <telerik:RadGrid ID="rgByReview" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationCoursesByReview" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" AllowAutomaticUpdates="true" OnItemCommand="rgArticulationCourses_ItemCommand" RenderMode="Lightweight"  OnItemDataBound="rgArticulationCourses_ItemDataBound" OnDataBound="rgArticulationCourses_DataBound" OnDetailTableDataBind="rgArticulationCourses_DetailTableDataBind">
            <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="False"  />
                <ClientEvents />
            </ClientSettings>
            <ExportSettings HideStructureColumns="true">
            </ExportSettings>
            <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulationCoursesByReview" PageSize="12" DataKeyNames="outline_id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true"  HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true">
                <CommandItemTemplate>
                    <div class="commandItems">
                        <telerik:RadButton runat="server" CommandName="Expand" ID="btnExpand" ButtonType="StandardButton" Text="Expand/Collapse">
                            <ContentTemplate>
                                <i class='fa fa-expand'></i> Expand / Collapse
                            </ContentTemplate>
                        </telerik:RadButton>
                        <telerik:RadButton ID="btnAudit" runat="server" Text="Audit Trail" ButtonType="StandardButton" CommandName="Audit">
                            <ContentTemplate>
                                <i class='fa fa-history'></i> Audit Trail
                            </ContentTemplate>
                        </telerik:RadButton>
                        <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel">
                            <ContentTemplate>
                                <i class='fa fa-file-excel-o'></i> Export to Excel
                            </ContentTemplate>
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>
                <DetailTables>
                    <telerik:GridTableView Name="ChildGrid" DataKeyNames="id" DataSourceID="sqlCourseMatches" Width="100%" AllowMultiColumnSorting="true" runat="server" CommandItemDisplay="None" AllowFilteringByColumn="true" CommandItemSettings-ShowAddNewRecordButton="false" HeaderStyle-Font-Bold="true">
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="checkUpdatedCurrentUser" UniqueName="checkUpdatedCurrentUser" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                                <ItemTemplate>
                                    <asp:Label runat="server"  Visible="false" ID="lblcheckUpdatedCurrentUser" ToolTip="Revised" Text="<i class='fa fa-check-square'></i>" ForeColor="#006600" />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false">
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type"   Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataSourceID="sqlStatus" ListTextField="description" ListValueField="id" UniqueName="status_id" SortExpression="status_id" HeaderText="Status" DataField="status_id" AllowFiltering="false"  ItemStyle-Font-Size="15px" HeaderStyle-Width="60px" ReadOnly="true">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxStatus" DataSourceID="sqlStatus" DataTextField="description"
                                        DataValueField="id" Height="100px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("status_id").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="StatusIndexChanged2" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                        <script type="text/javascript">
                                            function StatusIndexChanged2(sender, args) {
                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("status_id", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridDropDownColumn DataSourceID="sqlStages" ListTextField="description" ListValueField="stage_id" UniqueName="stage_id" SortExpression="stage_id" HeaderText="Stage" DataField="stage_id" AllowFiltering="false"  ItemStyle-Font-Size="15px" HeaderStyle-Width="80px" ReadOnly="true">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxStage" DataSourceID="sqlStages" DataTextField="description"
                                        DataValueField="stage_id" Height="150px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("stage_id").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="StageIndexChanged2" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                        <script type="text/javascript">
                                            function StageIndexChanged2(sender, args) {
                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("stage_id", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="90px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px"  ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="190px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this course articulation ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                    </telerik:GridTableView>
                </DetailTables>
                <Columns>
                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject_id" UniqueName="subject_id" SortExpression="subject_id" HeaderText="Subject" DataField="subject_id" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px">
                        <FilterTemplate>
                            <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                DataValueField="subject_id" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject_id").CurrentFilterValue %>'
                                runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged2">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                                <script type="text/javascript">
                                    function SubjectIndexChanged2(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("subject_id", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px" >
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>

        <telerik:RadGrid ID="rgByStage" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationCoursesByStage" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" AllowAutomaticUpdates="true" OnItemCommand="rgArticulationCourses_ItemCommand" RenderMode="Lightweight"  OnItemDataBound="rgArticulationCourses_ItemDataBound" OnDataBound="rgArticulationCourses_DataBound" OnDetailTableDataBind="rgArticulationCourses_DetailTableDataBind">
            <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="False"  />
                <ClientEvents />
            </ClientSettings>
            <ExportSettings HideStructureColumns="true">
            </ExportSettings>
            <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulationCoursesByStage" PageSize="12" DataKeyNames="outline_id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true">
                <CommandItemTemplate>
                    <div class="commandItems">
                        <telerik:RadButton runat="server" CommandName="Expand" ID="btnExpand" ButtonType="StandardButton" Text="Expand/Collapse">
                            <ContentTemplate>
                                <i class='fa fa-expand'></i> Expand / Collapse
                            </ContentTemplate>
                        </telerik:RadButton>
                        <telerik:RadButton ID="btnAudit" runat="server" Text="Audit Trail" ButtonType="StandardButton" CommandName="Audit">
                            <ContentTemplate>
                                <i class='fa fa-history'></i> Audit Trail
                            </ContentTemplate>
                        </telerik:RadButton>
                        <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel">
                            <ContentTemplate>
                                <i class='fa fa-file-excel-o'></i> Export to Excel
                            </ContentTemplate>
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>
                <DetailTables>
                    <telerik:GridTableView Name="ChildGrid" DataKeyNames="id" DataSourceID="sqlCourseMatches" Width="100%" AllowMultiColumnSorting="true" runat="server" CommandItemDisplay="None" AllowFilteringByColumn="true" CommandItemSettings-ShowAddNewRecordButton="false" HeaderStyle-Font-Bold="true">
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="checkUpdatedCurrentUser" UniqueName="checkUpdatedCurrentUser" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                                <ItemTemplate>
                                    <asp:Label runat="server"  Visible="false" ID="lblcheckUpdatedCurrentUser" ToolTip="Revised" Text="<i class='fa fa-check-square'></i>" ForeColor="#006600" />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false">
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type"   Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataSourceID="sqlStatus" ListTextField="description" ListValueField="id" UniqueName="status_id" SortExpression="status_id" HeaderText="Status" DataField="status_id" AllowFiltering="false"  ItemStyle-Font-Size="15px" HeaderStyle-Width="60px" ReadOnly="true">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxStatus" DataSourceID="sqlStatus" DataTextField="description"
                                        DataValueField="id" Height="100px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("status_id").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="StatusIndexChanged3" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                        <script type="text/javascript">
                                            function StatusIndexChanged3(sender, args) {
                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("status_id", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridDropDownColumn DataSourceID="sqlStages" ListTextField="description" ListValueField="stage_id" UniqueName="stage_id" SortExpression="stage_id" HeaderText="Stage" DataField="stage_id" AllowFiltering="false"  ItemStyle-Font-Size="15px" HeaderStyle-Width="80px" ReadOnly="true">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxStage" DataSourceID="sqlStages" DataTextField="description"
                                        DataValueField="stage_id" Height="150px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("stage_id").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="StageIndexChanged3" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                        <script type="text/javascript">
                                            function StageIndexChanged3(sender, args) {
                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("stage_id", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="90px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px"  ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="190px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this course articulation ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                    </telerik:GridTableView>
                </DetailTables>
                <Columns>
                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject_id" UniqueName="subject_id" SortExpression="subject_id" HeaderText="Subject" DataField="subject_id" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px">
                        <FilterTemplate>
                            <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                DataValueField="subject_id" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject_id").CurrentFilterValue %>'
                                runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged3">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                                <script type="text/javascript">
                                    function SubjectIndexChanged3(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("subject_id", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px" >
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>

        <telerik:RadGrid ID="rgArticulationCourses" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationCourses" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" AllowAutomaticUpdates="true" OnItemCommand="rgArticulationCourses_ItemCommand" RenderMode="Lightweight"  OnItemDataBound="rgArticulationCourses_ItemDataBound" OnDataBound="rgArticulationCourses_DataBound" OnDetailTableDataBind="rgArticulationCourses_DetailTableDataBind">
            <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="False"  />
                <ClientEvents />
            </ClientSettings>
            <ExportSettings HideStructureColumns="true">
            </ExportSettings>
            <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulationCourses" PageSize="12" DataKeyNames="outline_id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true">
                <CommandItemTemplate>
                    <div class="commandItems">
                        <telerik:RadButton runat="server" CommandName="Expand" ID="btnExpand" ButtonType="StandardButton" Text="Expand/Collapse">
                            <ContentTemplate>
                                <i class='fa fa-expand'></i> Expand / Collapse
                            </ContentTemplate>
                        </telerik:RadButton>
                        <telerik:RadButton ID="btnAudit" runat="server" Text="Audit Trail" ButtonType="StandardButton" CommandName="Audit">
                            <ContentTemplate>
                                <i class='fa fa-history'></i> Audit Trail
                            </ContentTemplate>
                        </telerik:RadButton>
                        <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel">
                            <ContentTemplate>
                                <i class='fa fa-file-excel-o'></i> Export to Excel
                            </ContentTemplate>
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>
                <DetailTables>
                    <telerik:GridTableView Name="ChildGrid" DataKeyNames="id" DataSourceID="sqlCourseMatches" Width="100%" AllowMultiColumnSorting="true" runat="server" CommandItemDisplay="None" AllowFilteringByColumn="true" CommandItemSettings-ShowAddNewRecordButton="false" HeaderStyle-Font-Bold="true">
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="checkUpdatedCurrentUser" UniqueName="checkUpdatedCurrentUser" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                                <ItemTemplate>
                                    <asp:Label runat="server"  Visible="false" ID="lblcheckUpdatedCurrentUser" ToolTip="Revised" Text="<i class='fa fa-check-square'></i>" ForeColor="#006600" />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false">
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type"   Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataSourceID="sqlStatus" ListTextField="description" ListValueField="id" UniqueName="status_id" SortExpression="status_id" HeaderText="Status" DataField="status_id" AllowFiltering="true"  ItemStyle-Font-Size="15px" HeaderStyle-Width="60px" ReadOnly="true">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxStatus" DataSourceID="sqlStatus" DataTextField="description"
                                        DataValueField="id" Height="100px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("status_id").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="StatusIndexChanged" DropDownAutoWidth="Enabled">
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
                            <telerik:GridDropDownColumn DataSourceID="sqlStages" ListTextField="description" ListValueField="stage_id" UniqueName="stage_id" SortExpression="stage_id" HeaderText="Stage" DataField="stage_id" AllowFiltering="true"  ItemStyle-Font-Size="15px" HeaderStyle-Width="80px" ReadOnly="true">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxStage" DataSourceID="sqlStages" DataTextField="description"
                                        DataValueField="stage_id" Height="150px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("stage_id").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="StageIndexChanged" DropDownAutoWidth="Enabled">
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
                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="90px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px"  ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="190px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this course articulation ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                    </telerik:GridTableView>
                </DetailTables>
                <Columns>
                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject_id" UniqueName="subject_id" SortExpression="subject_id" HeaderText="Subject" DataField="subject_id" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px">
                        <FilterTemplate>
                            <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                DataValueField="subject_id" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject_id").CurrentFilterValue %>'
                                runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                                <script type="text/javascript">
                                    function SubjectIndexChanged(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("subject_id", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px" >
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <telerik:GridDropDownListColumnEditor ID="ceStatus" runat="server" DropDownStyle-Width="55px" DropDownStyle-Height="90px"></telerik:GridDropDownListColumnEditor>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }

    </script>
</asp:Content>
