<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Articulate.aspx.cs" Inherits="ems_app.modules.military.Articulate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .badgeCoursesCountColor, .badge  {
            background-color: cadetblue !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Articulation</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- occupations data sources -->
    <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from OccupationService order by Description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSmartKeywords" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select keyword from SmartKeywords where KeywordType = 2 order by Keyword"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAllOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetOccupations" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfCollegeID" DbType="Int32" Name="CollegeID" PropertyName="Value" />
            <asp:ControlParameter ControlID="hfAdvancedSarch" DbType="String" Name="attribute" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="false" />
            <asp:ControlParameter ControlID="rchkSearchRecommendationsOcc" Name="SearchRecommendations" PropertyName="Checked" DbType="Byte" />
            <asp:ControlParameter ControlID="hfExcludeArticulationOverYears" DbType="Int32" Name="ExcludeArticulationOverYears" PropertyName="Value" />
            <asp:Parameter DbType="String" Name="Service" />
            <asp:Parameter DbType="String" Name="Occupation" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOccupationCollegeCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'course_title', cif.outline_id, cco.[AceID], cco.[TeamRevd], case when cco.Articulate = 0 then concat( 'This articulation has been denied.<br><br> <b>Rationale :</b> <br><br>',case when len(cco.Notes) > 5 then Concat('Evaluator Notes : ', cco.Notes,'<br>') else '' end , case when len(cco.Justification) > 5 then Concat('Faculty Notes : ', cco.Justification,'<br>') else '' end , case when len(cco.ArticulationOfficerNotes) > 5 then Concat('Articulation Officer Notes : ', cco.ArticulationOfficerNotes,'<br>') else '' end ) else '' end as DeniedComments, cco.Articulate, cco.id, cco.AceID, cco.TeamRevd, ocu.Title, r.RoleName  from Articulation cco join Course_IssuedForm cif on cco.outline_id = cif.outline_id left outer join tblSubjects s on cif.subject_id = s.subject_id left outer join AceExhibit ocu on cco.AceID = ocu.AceID and cco.TeamRevd = ocu.TeamRevd left outer join Stages st on cco.ArticulationStage = st.id left outer join Roles r on st.RoleID = r.RoleID where cco.[AceID] = @AceID  and cco.[TeamRevd] = @TeamRevd and cif.[college_id] = @CollegeID and cco.ArticulationType = 2 and cco.ArticulationStatus <> 3">
        <SelectParameters>
            <asp:Parameter Name="AceID" Type="String" />
            <asp:Parameter Name="TeamRevd" Type="DateTime" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <!-- end: occupatoins data sources -->
    <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct ao.Occupation, CONCAT(TRIM(ao.Occupation) , ' - ' , ao.Title) as Title from AceExhibit ao inner join ( SELECT Occupation, max(AceID) as AceID FROM AceExhibit aoc group by Occupation ) a02 on ao.AceID = a02.AceID order by ao.Occupation"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct program_id, isnull(program,'') + ' - ' + cast(isnull(description,'') as varchar(20)) as 'program' from Program_IssuedForm where status = 0 and [college_id] = @CollegeID order by program">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlACECourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetAceCoursesCatalog" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfCollegeID" DbType="Int32" Name="CollegeID" PropertyName="Value" />
            <asp:ControlParameter ControlID="racACECourseAttribute" DbType="String" Name="attribute" PropertyName="Text" DefaultValue="" ConvertEmptyStringToNull="false" />
            <asp:ControlParameter ControlID="rchkSearchRecommendations" Name="SearchRecommendations" PropertyName="Checked" DbType="Byte" />
            <asp:ControlParameter ControlID="hfExcludeArticulationOverYears" DbType="Int32" Name="ExcludeArticulationOverYears" PropertyName="Value" />
            <asp:ControlParameter DbType="String" Name="occupation" ControlID="rcbOccupations" PropertyName="SelectedValue" DefaultValue="" ConvertEmptyStringToNull="false" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlRequired" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select CAST(isnull(cif.ExistInOtherColleges,0) AS int) as 'ExistInOtherColleges',pm.*, cif.HasImplementedArticulations as 'IsPublished', cif.HasArticulations as 'HaveArticulations', cond.ConditionSymbol, cif.DisableArticulate, cif.DisableArticulateRationale, [dbo].[GetCrossListingCoursesHTMLTable] (pm.outline_id) 'CrossListingCourses' from View_ProgramMatrix pm left outer join tblLookupConditions cond on pm.condition = cond.id left outer join Course_IssuedForm cif on pm.outline_id = cif.outline_id left outer join tblSubjects s on cif.subject_id = s.subject_id  WHERE (pm.[program_id] = @program_id and pm.[required] = @required) ORDER BY pm.iorder">
        <SelectParameters>
            <asp:Parameter Name="required" DefaultValue="1" Type="Int32" />
            <asp:ControlParameter ControlID="rcbPrograms" Name="program_id" PropertyName="SelectedValue" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAceArticulationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'course_title', cco.[AceID], cco.[TeamRevd], cif.[outline_id], case when cco.Articulate = 0 then concat( 'This articulation has been denied.<br><br> <b>Rationale :</b> <br><br>',case when len(cco.Notes) > 5 then Concat('Evaluator Notes : ', cco.Notes,'<br>') else '' end , case when len(cco.Justification) > 5 then Concat('Faculty Notes : ', cco.Justification,'<br>') else '' end , case when len(cco.ArticulationOfficerNotes) > 5 then Concat('Articulation Officer Notes : ', cco.ArticulationOfficerNotes,'<br>') else '' end ) else '' end as DeniedComments, cco.Articulate, cco.id, cco.AceID, cco.TeamRevd, ocu.Title, r.RoleName, 'Course' as TypeDescription  from Articulation cco join Course_IssuedForm cif on cco.outline_id = cif.outline_id left outer join tblSubjects s on cif.subject_id = s.subject_id left outer join AceExhibit ocu on cco.AceID = ocu.AceID and cco.TeamRevd = ocu.TeamRevd left outer join Stages st on cco.ArticulationStage = st.id left outer join Roles r on st.RoleID = r.RoleID where cco.[AceID] = @AceID  and cco.[TeamRevd] = @TeamRevd and cif.[college_id] = @CollegeID and cco.ArticulationType = 1 and cco.ArticulationStatus <> 3">
        <SelectParameters>
            <asp:Parameter Name="AceID" Type="String" />
            <asp:Parameter Name="TeamRevd" Type="DateTime" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlCollegeCourseMatches" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select cc.VersionNumber Exhibit, ac.outline_id, ac. AceID, ac.TeamRevd, ac.id, ac.ArticulationType, case when ac.ArticulationType = 1 then 'Course' else 'Occupation' end as TypeDescription,  cc.Title, 0 as 'HaveOccupations', case when ac.ArticulationStatus = 2 then 1 else 0 end IsPublished, cc.Occupation, ac.Articulate, case when ac.Articulate = 0 then concat( 'This articulation has been denied.<br><br> <b>Rationale :</b> <br><br>',case when len(ac.Notes) > 5 then Concat('Evaluator Notes : ', ac.Notes,'<br>') else '' end , case when len(ac.Justification) > 5 then Concat('Faculty Notes : ', ac.Justification,'<br>') else '' end , case when len(ac.ArticulationOfficerNotes) > 5 then Concat('Articulation Officer Notes : ', ac.ArticulationOfficerNotes,'<br>') else '' end ) else '' end as DeniedComments, r.RoleName from Articulation ac left outer join ACEExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join Stages s on ac.ArticulationStage = s.id left outer join Roles r on s.RoleID = r.RoleID where ac.[outline_id] = @outline_id and ac.ArticulationStatus <> 3 order by ac.ArticulationType, ac.title">
        <SelectParameters>
            <asp:Parameter Name="outline_id" Type="Int32" />

        </SelectParameters>
    </asp:SqlDataSource>


    <asp:SqlDataSource ID="sqlRecommended" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select CAST(isnull(cif.ExistInOtherColleges,0) AS int) as 'ExistInOtherColleges',pm.*, cif.HasImplementedArticulations as 'IsPublished', cif.HasArticulations as 'HaveArticulations', cond.ConditionSymbol, cif.DisableArticulate, cif.DisableArticulateRationale, [dbo].[GetCrossListingCoursesHTMLTable] (pm.outline_id) 'CrossListingCourses' from View_ProgramMatrix pm left outer join tblLookupConditions cond on pm.condition = cond.id left outer join Course_IssuedForm cif on pm.outline_id = cif.outline_id left outer join tblSubjects s on cif.subject_id = s.subject_id  WHERE (pm.[program_id] = @program_id and pm.[required] = @required) ORDER BY pm.iorder">
        <SelectParameters>
            <asp:Parameter Name="required" DefaultValue="2" Type="Int32" />
            <asp:ControlParameter ControlID="rcbPrograms" Name="program_id" PropertyName="SelectedValue" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseSimilarities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select acc.* , dbo.HaveArticulatedCourses(acc.AceID, acc.TeamRevd, @CollegeID) as 'HaveArticulatedCourses' from AceCourseCatalog acc where acc.[ID] IN (select value from fn_split(@AceCourseIDList,','))  order by acc.title">
        <SelectParameters>
            <asp:Parameter DbType="String" Name="AceCourseIDList" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseSimilaritiesByDetail" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct cc.AceID,cc.Exhibit,cc.TeamRevd,cc.Title, dbo.HaveArticulatedCourses(cc.AceID, cc.TeamRevd, @CollegeID) as 'HaveArticulatedCourses' from AceCatalogDetail cd join AceCourseCatalog cc on cd.aceid = cc.aceid and cd.teamrevd = cc.teamrevd  where cd.[ID] IN (select value from fn_split(@AceCourseIDList,','))  order by cc.title">
        <SelectParameters>
            <asp:Parameter DbType="String" Name="AceCourseIDList" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlPerformArticulationBy" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 'program' as id, 'Programs of Study ' as 'Type' union select 'course' as id, 'Catalog Courses ' as 'Type' "></asp:SqlDataSource>
    <!-- Prototype -->
    <%--   <asp:SqlDataSource ID="sqlArticulateBy" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 'occupation' as id, 'ACE Occupation Code' as 'Type' union select 'course' as id, 'ACE Course' as 'Type'"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="sqlArticulateBy" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 'occupation' as id, 'ACE Occupation Code' as 'Type' union select 'course' as id, 'ACE Course' as 'Type' union select 'criteria' as id, 'Recommendation Criteria' as 'Type' union select 'location' as id, 'Location' as 'Type' order by 'Type'"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCollegeCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="GetCollegeCourses">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct subject from tblSubjects where college_id = @CollegeID order by subject">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'course_title', cco.[AceID], cco.[TeamRevd], cco.Title , cif.[outline_id], case when cco.Articulate = 0 then concat( 'This articulation has been denied.<br><br> <b>Rationale :</b> <br><br>',case when len(cco.Notes) > 5 then Concat('Evaluator Notes : ', cco.Notes,'<br>') else '' end , case when len(cco.Justification) > 5 then Concat('Faculty Notes : ', cco.Justification,'<br>') else '' end , case when len(cco.ArticulationOfficerNotes) > 5 then Concat('Articulation Officer Notes : ', cco.ArticulationOfficerNotes,'<br>') else '' end ) else '' end as DeniedComments, cco.Articulate, cco.id, cco.AceID, cco.TeamRevd,  r.RoleName, case when cco.ArticulationType = 1 then 'Course' else 'Occupation' end as TypeDescription  from Articulation cco join Course_IssuedForm cif on cco.outline_id = cif.outline_id left outer join tblSubjects s on cif.subject_id = s.subject_id left outer join Stages st on cco.ArticulationStage = st.id left outer join Roles r on st.RoleID = r.RoleID where cco.[AceID] = @AceID  and cco.[TeamRevd] = @TeamRevd and cif.[college_id] = @CollegeID and cco.ArticulationStatus <> 3">
        <SelectParameters>
            <asp:Parameter Name="AceID" DbType="String" />
            <asp:Parameter Name="TeamRevd" DbType="DateTime" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" DbType="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
        <telerik:RadWindowManager ID="RadWindowManager1" RenderMode="Lightweight" ShowContentDuringLoad="true" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="150px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomCenter" ManualClose="true" Animation="Fade" HideEvent="ManualClose" AutoCloseDelay="7000">
            <p id="divMsgs" runat="server" class="text-center">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <div id="divArticulationCreated" class="ArticulationCreated" style="display: none;">
            <p style="color: #fff; font-weight: bold;">
                <i class="fa fa-check-circle-o fa-5x" aria-hidden="true"></i>Articulation successfully created!
            </p>
        </div>
        <div style="display: none !important;">
            <telerik:RadTextBox ID="selectedRowValue" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
            <telerik:RadTextBox ID="selectedCourseTitle" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
        </div>
        <asp:HiddenField ID="hfExcludeArticulationOverYears" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hfCollegeID" runat="server" ClientIDMode="Static" />
        <div class="row">
            <div class="col-md-6 col-xs-12">
                <telerik:RadTabStrip runat="server" ID="rtsCoursesPrograms" MultiPageID="rmpCoursesProgram" SelectedIndex="0" Width="100%" Height="50px" ShowBaseLine="false" RenderMode="Lightweight" AutoPostBack="true">
                    <Tabs>
                        <telerik:RadTab Text="Catalog Courses" Value="Courses" ToolTip="" Selected="True">
                        </telerik:RadTab>
                        <telerik:RadTab Text="Programs of Study" Value="Programs" ToolTip="">
                        </telerik:RadTab>
                    </Tabs>
                </telerik:RadTabStrip>
                <telerik:RadMultiPage runat="server" ID="rmpCoursesProgram" SelectedIndex="0" Width="99%" RenderMode="Lightweight" RenderSelectedPageOnly="true">
                    <telerik:RadPageView runat="server" ID="rpvCourses" Width="100%">
                        <asp:Panel ID="panelCollegeCourses" runat="server" ClientIDMode="Static">
                            <telerik:RadGrid ID="rgCollegeCourses" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlCollegeCourses" AutoGenerateColumns="False" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" OnItemDataBound="ProgramCourses_ItemDataBound" HeaderStyle-Font-Bold="true" RenderMode="Lightweight" AllowFilteringByColumn="true" EnableHeaderContextMenu="true" OnItemCommand="ProgramCourses_ItemCommand" AllowPaging="true" PageSize="50">
                                <GroupingSettings CaseSensitive="false" />
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                    <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                                    <ClientEvents OnRowDblClick="RowDblClick" OnRowSelected="selectedRowNorco" OnFilterMenuShowing="FilterMenuShowing"></ClientEvents>
                                </ClientSettings>
                                <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                <MasterTableView Name="ParentGrid" DataKeyNames="outline_id" DataSourceID="sqlCollegeCourses" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="true" EnableHierarchyExpandAll="true"   HeaderStyle-Font-Bold="true" AllowMultiColumnSorting="true" AutoGenerateColumns="false">
                                    <DetailTables>
                                        <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlCollegeCourseMatches" Width="100%"
                                            runat="server" DataKeyNames="outline_id" AllowFilteringByColumn="false">
                                            <ParentTableRelation>
                                                <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                            </ParentTableRelation>
                                            <Columns>
                                                <telerik:GridTemplateColumn>
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                        <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                            <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                        </telerik:RadToolTip>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" CommandName="EditOccupations" ToolTip="This course has related occupation codes. Click here to view/update occupation codes." ID="btnHaveOccupations" Text='<i class="fa fa-wrench" ForeColor="White" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="HaveOccupations" DataType="System.Boolean" UniqueName="HaveOccupations" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="IsPublished" UniqueName="checkIsPublished" DataType="System.Boolean" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="TypeDescription" HeaderText="Type" DataField="TypeDescription" UniqueName="TypeDescription" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="AceID" HeaderStyle-Width="100px" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Exhibit" HeaderStyle-Width="110px" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" HeaderStyle-Font-Bold="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="id" DataField="id" UniqueName="id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="EntityType" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="RoleName" UniqueName="RoleName" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                            </Columns>
                                        </telerik:GridTableView>
                                    </DetailTables>
                                    <Columns>
                                        <telerik:GridTemplateColumn HeaderStyle-Width="20px" AllowFiltering="false">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ToolTip="This course has been disabled for articulation." Visible="false" ID="lblDisableArticulate" Text="<i class='fa fa-exclamation-triangle'></i>" />
                                                <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblDisableArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                    <%# DataBinder.Eval(Container, "DataItem.DisableArticulateRationale") %>
                                                </telerik:RadToolTip>
                                                <asp:LinkButton runat="server" CommandName="OtherCollegesArticulations" ToolTip="This course has been articulated in another college." ID="btnOtherCollegeArticulations" Text='<i class="fa fa-university" aria-hidden="true"></i>' />
                                                <!-- Cross Listing Courses -->
                                                <asp:Label runat="server" ToolTip="This course has cross listing courses." Visible="false" ID="lblCrossListing" Text="<i class='fa fa-exclamation-triangle'></i>" />
                                                <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTipCrossListing" runat="server" TargetControlID="lblCrossListing" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                    <%# DataBinder.Eval(Container, "DataItem.CrossListingCourses") %>
                                                </telerik:RadToolTip>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="DisableArticulate" UniqueName="DisableArticulate" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="DisableArticulateRationale" UniqueName="DisableArticulateRationale" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="CrossListingCourses" EmptyDataText="" UniqueName="CrossListingCourses" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="labelExistInOtherColleges" UniqueName="labelExistInOtherColleges" AllowFiltering="false" HeaderStyle-Width="20px" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="labelIsPublished" UniqueName="labelIsPublished" AllowFiltering="false" HeaderStyle-Width="20px" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ExistInOtherColleges" UniqueName="ExistInOtherColleges" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridCheckBoxColumn DataField="HaveArticulations" UniqueName="FilterHaveArticulations" DataType="System.Boolean" HeaderText="Articulated Courses" AllowFiltering="true" HeaderStyle-Width="40px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" FilterControlToolTip="Filter Only Articulated Courses" AutoPostBackOnFilter="true">
                                        </telerik:GridCheckBoxColumn>
                                        <telerik:GridCheckBoxColumn DataField="IsPublished" UniqueName="IsPublished" DataType="System.Boolean" HeaderText="Implemented Courses" AllowFiltering="true" HeaderStyle-Width="40px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" FilterControlToolTip="Filter Only Approved and Implemented Courses" AutoPostBackOnFilter="true">
                                        </telerik:GridCheckBoxColumn>
                                        <%--                                <telerik:GridBoundColumn DataField="HaveArticulations" UniqueName="HaveArticulations" DataType="System.Boolean" Display="false" >
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="IsPublished" UniqueName="checkIsPublished" DataType="System.Boolean" Display="false" >
                                </telerik:GridBoundColumn>--%>
                                        <telerik:GridBoundColumn UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="55px" FilterControlToolTip="Filter by Subject/Discipline">
                                            <FilterTemplate>
                                                <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                                    DataValueField="subject" MaxHeight="200px" Width="50px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                    runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged" Font-Size="7px" DropDownAutoWidth="Enabled">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="All" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                                <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                                    <script type="text/javascript">
                                                        function SubjectIndexChanged(sender, args) {
                                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                            tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                        }
                                                    </script>
                                                </telerik:RadScriptBlock>
                                            </FilterTemplate>
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Number" SortExpression="course_number" UniqueName="course_number" ReadOnly="true" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlToolTip="Filter By Course Number">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title" ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="100px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlToolTip="Filter By Course Title">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="unit" FilterControlAltText="Filter unit column" HeaderText="Units" SortExpression="unit" UniqueName="unit" ReadOnly="true" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlToolTip="Filter By Units">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="3" UniqueName="EntityType" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                    <NoRecordsTemplate>
                                        <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                            &nbsp;No items to view
                                        </div>
                                    </NoRecordsTemplate>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </asp:Panel>
                    </telerik:RadPageView>
                    <telerik:RadPageView runat="server" ID="rpvPrograms" Width="100%">
                        <asp:Panel ID="panelCollegePrograms" runat="server" ClientIDMode="Static">
                            <telerik:RadComboBox RenderMode="Lightweight" ID="rcbPrograms" AllowCustomText="true" runat="server" Width="100%" Height="400px"
                                DataSourceID="sqlPrograms" DataValueField="program_id" DataTextField="program" EmptyMessage="Search for programs..." Filter="Contains" AutoPostBack="true" OnSelectedIndexChanged="rcbPrograms_SelectedIndexChanged">
                            </telerik:RadComboBox>
                            <asp:Panel ID="pnlProgramCourses" runat="server">
                                <%-- COURSES FOR THE MAJOR --%>
                                <h3 style="margin-top: 6px; margin-bottom: 2px;">Required Courses</h3>
                                <telerik:RadGrid ID="rgRequired" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlRequired" AutoGenerateColumns="False" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" OnItemCommand="ProgramCourses_ItemCommand" OnItemDataBound="ProgramCourses_ItemDataBound" HeaderStyle-Font-Bold="true" RenderMode="Lightweight">
                                    <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                                        <ClientEvents OnRowDblClick="RowDblClick" OnRowSelected="selectedRowNorco" OnFilterMenuShowing="FilterMenuShowing"></ClientEvents>
                                    </ClientSettings>
                                    <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                    <MasterTableView Name="ParentGrid" DataKeyNames="outline_id" DataSourceID="sqlRequired" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="true" EnableHierarchyExpandAll="true"   HeaderStyle-Font-Bold="true" AllowMultiColumnSorting="true">
                                        <DetailTables>
                                            <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlCollegeCourseMatches" Width="100%"
                                                runat="server" DataKeyNames="id">
                                                <ParentTableRelation>
                                                    <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                                </ParentTableRelation>
                                                <Columns>
                                                    <telerik:GridTemplateColumn>
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                            <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip111" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                                <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                            </telerik:RadToolTip>
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" CommandName="EditOccupations" ToolTip="This course has related occupation codes. Click here to view/update occupation codes." ID="btnHaveOccupations" Text='<i class="fa fa-wrench" ForeColor="White" aria-hidden="true"></i>' />
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn DataField="HaveOccupations" DataType="System.Boolean" UniqueName="HaveOccupations" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="IsPublished" UniqueName="checkIsPublished" DataType="System.Boolean" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="TypeDescription" HeaderText="Type" DataField="TypeDescription" UniqueName="TypeDescription" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="AceID" HeaderStyle-Width="100px" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="Exhibit" HeaderStyle-Width="110px" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" HeaderStyle-Font-Bold="true" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="id" DataField="id" UniqueName="id" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="EntityType" Display="false">
                                                    </telerik:GridBoundColumn>
                                                </Columns>
                                            </telerik:GridTableView>
                                        </DetailTables>
                                        <Columns>
                                            <telerik:GridTemplateColumn HeaderStyle-Width="20px" AllowFiltering="false">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ToolTip="This course has been disabled for articulation." Visible="false" ID="lblDisableArticulate" Text="<i class='fa fa-exclamation-triangle'></i>" />
                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblDisableArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                        <%# DataBinder.Eval(Container, "DataItem.DisableArticulateRationale") %>
                                                    </telerik:RadToolTip>
                                                    <asp:LinkButton runat="server" CommandName="OtherCollegesArticulations" ToolTip="This course has been articulated in another college." ID="btnOtherCollegeArticulations" Text='<i class="fa fa-university" aria-hidden="true"></i>' />
                                                    <!-- Cross Listing Courses -->
                                                    <asp:Label runat="server" ToolTip="This course has cross listing courses." Visible="false" ID="lblCrossListing" Text="<i class='fa fa-exclamation-triangle'></i>" />
                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTipCrossListing" runat="server" TargetControlID="lblCrossListing" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                        <%# DataBinder.Eval(Container, "DataItem.CrossListingCourses") %>
                                                    </telerik:RadToolTip>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="CrossListingCourses" EmptyDataText="" UniqueName="CrossListingCourses" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="DisableArticulate" UniqueName="DisableArticulate" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="DisableArticulateRationale" UniqueName="DisableArticulateRationale" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ToolTip="Have Related Articulations" ID="btnShowMatches" Text='<i class="fa fa-check-square" aria-hidden="true"></i>' Visible="false" />
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="ExistInOtherColleges" UniqueName="ExistInOtherColleges" Display="false"></telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="HaveArticulations" UniqueName="HaveArticulations" DataType="System.Boolean" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="IsPublished" UniqueName="checkIsPublished" DataType="System.Boolean" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="programcourse_id" DataType="System.Int32" FilterControlAltText="Filter programcourse_id column" HeaderText="programcourse_id" ReadOnly="True" SortExpression="programcourse_id" UniqueName="programcourse_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="ConditionSymbol" DataType="System.Int32" FilterControlAltText="Filter ConditionSymbol column" HeaderText="And/Or" SortExpression="ConditionSymbol" UniqueName="ConditionSymbol" ItemStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="iorder" DataType="System.Int32" FilterControlAltText="Filter iorder column" HeaderText="iorder" SortExpression="iorder" UniqueName="iorder" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" ReadOnly="true" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Number" SortExpression="course_number" UniqueName="course_number" ReadOnly="true" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn HeaderStyle-Width="400px" ItemStyle-Width="400px">
                                                <HeaderTemplate>
                                                    Course Title  
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#courseDescription(((GridDataItem) Container)) %>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="group_desc" FilterControlAltText="Filter group_desc column" HeaderText="group_desc" SortExpression="group_desc" UniqueName="group_desc" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="c_group" FilterControlAltText="Filter c_group column" HeaderText="c_group" SortExpression="c_group" UniqueName="c_group" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="prereq_total" FilterControlAltText="Filter prereq_total column" HeaderText="prereq_total" SortExpression="prereq_total" UniqueName="prereq_total" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridNumericColumn DataField="vunits" DataType="System.Double" FilterControlAltText="Filter vunits column" HeaderText="Units" SortExpression="vunits" UniqueName="vunits" MinValue="0" ColumnEditorID="ceUnits" ReadOnly="true">
                                            </telerik:GridNumericColumn>
                                            <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="3" UniqueName="EntityType" Display="false">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                        <NoRecordsTemplate>
                                            <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                                &nbsp;No items to view
                                            </div>
                                        </NoRecordsTemplate>
                                    </MasterTableView>
                                </telerik:RadGrid>
                                <br />
                                <h3 style="margin-top: 6px; margin-bottom: 2px;">Restricted Elective</h3>
                                <telerik:RadGrid ID="rgRecommended" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlRecommended" AutoGenerateColumns="False" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" OnItemCommand="ProgramCourses_ItemCommand" OnItemDataBound="ProgramCourses_ItemDataBound" RenderMode="Lightweight">
                                    <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                                        <ClientEvents OnRowDblClick="RowDblClick" OnRowSelected="selectedRowNorco" OnFilterMenuShowing="FilterMenuShowing"></ClientEvents>
                                    </ClientSettings>
                                    <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                    <MasterTableView Name="ParentGrid" DataKeyNames="outline_id" DataSourceID="sqlRecommended" EnableNoRecordsTemplate="true" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="true" EnableHierarchyExpandAll="true"   AllowMultiColumnSorting="true">
                                        <DetailTables>
                                            <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlCollegeCourseMatches" Width="100%"
                                                runat="server" DataKeyNames="id">
                                                <ParentTableRelation>
                                                    <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                                </ParentTableRelation>
                                                <Columns>
                                                    <telerik:GridTemplateColumn>
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                            <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip1111" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                                <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                            </telerik:RadToolTip>
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" CommandName="EditOccupations" ToolTip="This course has related occupation codes. Click here to view/update occupation codes." ID="btnHaveOccupations" Text='<i class="fa fa-wrench" ForeColor="White" aria-hidden="true"></i>' />
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn DataField="HaveOccupations" DataType="System.Boolean" UniqueName="HaveOccupations" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="IsPublished" UniqueName="checkIsPublished" DataType="System.Boolean" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="TypeDescription" HeaderText="Type" DataField="TypeDescription" UniqueName="TypeDescription" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="AceID" HeaderStyle-Width="100px" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="Exhibit" HeaderStyle-Width="120px" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" HeaderStyle-Font-Bold="true" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn SortExpression="id" DataField="id" UniqueName="id" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="EntityType" Display="false">
                                                    </telerik:GridBoundColumn>
                                                </Columns>
                                            </telerik:GridTableView>
                                        </DetailTables>
                                        <Columns>
                                            <telerik:GridTemplateColumn HeaderStyle-Width="20px" AllowFiltering="false">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ToolTip="This course has been disabled for articulation." Visible="false" ID="lblDisableArticulate" Text="<i class='fa fa-exclamation-triangle'></i>" />
                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblDisableArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                        <%# DataBinder.Eval(Container, "DataItem.DisableArticulateRationale") %>
                                                    </telerik:RadToolTip>
                                                    <asp:LinkButton runat="server" CommandName="OtherCollegesArticulations" ToolTip="This course has been articulated in another college." ID="btnOtherCollegeArticulations" Text='<i class="fa fa-university" aria-hidden="true"></i>' />
                                                    <!-- Cross Listing Courses -->
                                                    <asp:Label runat="server" ToolTip="This course has cross listing courses." Visible="false" ID="lblCrossListing" Text="<i class='fa fa-exclamation-triangle'></i>" />
                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTipCrossListing" runat="server" TargetControlID="lblCrossListing" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                        <%# DataBinder.Eval(Container, "DataItem.CrossListingCourses") %>
                                                    </telerik:RadToolTip>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="CrossListingCourses" EmptyDataText="" UniqueName="CrossListingCourses" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="DisableArticulate" UniqueName="DisableArticulate" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="DisableArticulateRationale" UniqueName="DisableArticulateRationale" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                    <asp:Label runat="server" ToolTip="Have Related Articuilations" ID="btnShowMatches" Text='<i class="fa fa-check-square" aria-hidden="true"></i>' Visible="false" />
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="ExistInOtherColleges" UniqueName="ExistInOtherColleges" Display="false"></telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="HaveArticulations" UniqueName="HaveArticulations" DataType="System.Boolean" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="IsPublished" UniqueName="checkIsPublished" DataType="System.Boolean" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="programcourse_id" DataType="System.Int32" FilterControlAltText="Filter programcourse_id column" HeaderText="programcourse_id" ReadOnly="True" SortExpression="programcourse_id" UniqueName="programcourse_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="ConditionSymbol" DataType="System.Int32" FilterControlAltText="Filter ConditionSymbol column" HeaderText="And/Or" SortExpression="ConditionSymbol" UniqueName="ConditionSymbol" HeaderStyle-Width="55px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="iorder" DataType="System.Int32" FilterControlAltText="Filter iorder column" HeaderText="iorder" SortExpression="iorder" UniqueName="iorder" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" ReadOnly="true" HeaderStyle-Width="50px" HeaderStyle-Font-Bold="true" FilterControlToolTip="Enter Subject or Discipline Code to Filter By Subject">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Number" SortExpression="course_number" UniqueName="course_number" ReadOnly="true" HeaderStyle-Width="62px" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title" HeaderStyle-Width="118px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn>
                                                <HeaderTemplate>
                                                    Course Title  
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#courseDescription(((GridDataItem) Container)) %>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="group_desc" FilterControlAltText="Filter group_desc column" HeaderText="group_desc" SortExpression="group_desc" UniqueName="group_desc" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="c_group" FilterControlAltText="Filter c_group column" HeaderText="c_group" SortExpression="c_group" UniqueName="c_group" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="prereq_total" FilterControlAltText="Filter prereq_total column" HeaderText="prereq_total" SortExpression="prereq_total" UniqueName="prereq_total" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridNumericColumn DataField="vunits" DataType="System.Double" FilterControlAltText="Filter vunits column" HeaderText="Units" SortExpression="vunits" UniqueName="vunits" HeaderStyle-Width="70px" MinValue="0" ColumnEditorID="ceUnits" ReadOnly="true" HeaderStyle-Font-Bold="true">
                                            </telerik:GridNumericColumn>
                                            <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="3" UniqueName="EntityType" Display="false">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                        <NoRecordsTemplate>
                                            <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                                &nbsp;No items to view
                                            </div>
                                        </NoRecordsTemplate>
                                    </MasterTableView>
                                </telerik:RadGrid>
                                <%-- COURSES FOR THE MAJOR --%>
                            </asp:Panel>
                        </asp:Panel>
                    </telerik:RadPageView>
                </telerik:RadMultiPage>



            </div>
            <div class="ACEContainer col-md-6 col-xs-12">
                <div class="ACEViews" style="margin-top: 0px;">
                    <telerik:RadTabStrip runat="server" ID="rtsArticulateBy" MultiPageID="rmpArticulateBy" SelectedIndex="3" Width="100%" Height="50px" ShowBaseLine="false" RenderMode="Lightweight">
                        <Tabs>
                            <telerik:RadTab Text="ACE Courses" Value="Course" ToolTip="Articulate by ACE Courses">
                            </telerik:RadTab>
                            <telerik:RadTab Text="ACE Occupations" Value="Occupation" ToolTip="Articulate by ACE Occupations" Selected="true">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Locations" Value="Location" ToolTip="Articulate by Locations">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Recommendation Criteria" Value="Criteria" ToolTip="Articulate by Recommendation Criteria" Visible="false" >
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <div class="row">
                        <div class="col-sm-6">
                        </div>
                        <div class="col-sm-6 text-right">
                            <telerik:RadCheckBox ID="rchkExcludeYears" AutoPostBack="true" runat="server" Text="Exclude articulations over" OnCheckedChanged="rchkExcludeYears_CheckedChanged"></telerik:RadCheckBox>
                        </div>
                    </div>
                    <telerik:RadMultiPage runat="server" ID="rmpArticulateBy" SelectedIndex="1" Width="99%" RenderMode="Lightweight">
                        <telerik:RadPageView runat="server" ID="rpvACECourse" Width="100%">
                            <asp:Panel ID="pnlACECourse" runat="server">
                                <div class="row" style="margin-top: 0px;">
                                    <div class="col-sm-4">
                                        <telerik:RadCheckBox ID="rcheckSimilarPrograms" runat="server" Text="Show Similar Courses" AutoPostBack="true" OnCheckedChanged="rcheckSimilarPrograms_CheckedChanged" Font-Bold="True" ToolTip="If it is unchecked, the Entire ACE Course Catalog is Shown"></telerik:RadCheckBox>
                                    </div>
                                    <div class="col-sm-8">
                                        <telerik:RadCheckBox ID="rchkSearchRecommendations" Font-Bold="true" AutoPostBack="true" runat="server" Text="Search Recommendations"></telerik:RadCheckBox>
                                    </div>
                                </div>
                                <asp:Panel ID="pnlSimilar" runat="server" Visible="false">
                                    <div class="row" style="margin: 10px 0 40px 0;">
                                        <div class="col-sm-7">
                                            <p>Matching Attribute</p>
                                            <telerik:RadComboBox ID="rcbAttribute" runat="server" Width="100%" OnSelectedIndexChanged="rcbAttribute_SelectedIndexChanged" AutoPostBack="true">
                                                <Items>
                                                    <telerik:RadComboBoxItem runat="server" Selected="true" Value="1" Text="Course Title" />
                                                    <telerik:RadComboBoxItem runat="server" Value="2" Text="Course Detail" />
                                                </Items>
                                            </telerik:RadComboBox>
                                        </div>
                                        <div class="col-sm-5">
                                            <p>Matching Factor : </p>
                                            <telerik:RadComboBox ID="rcbMatchingFactor" runat="server" Width="90%" AutoPostBack="true" OnSelectedIndexChanged="rcbMatchingFactor_SelectedIndexChanged">
                                                <Items>
                                                    <telerik:RadComboBoxItem runat="server" Value="1" Text="Weak" />
                                                    <telerik:RadComboBoxItem runat="server" Value="2" Text="Average" />
                                                    <telerik:RadComboBoxItem runat="server" Value="3" Text="Strong" />
                                                </Items>
                                            </telerik:RadComboBox>
                                            <asp:LinkButton ID="lbHelp" runat="server" CausesValidation="false"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                            <telerik:RadToolTip RenderMode="Lightweight" ID="rttHelp" runat="server" TargetControlID="lbHelp" ShowEvent="OnMouseOver" Position="BottomCenter" RelativeTo="Element">
                                                <p><strong>Weak : </strong>Found at least 30% or more.</p>
                                                <p><strong>Average : </strong>Found at least 60% or more.</p>
                                                <p><strong>Strong : </strong>Highest match.</p>
                                            </telerik:RadToolTip>
                                        </div>
                                    </div>
                                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="RadPanelBar1" Width="100%" ExpandMode="MultipleExpandedItems" Font-Bold="False">
                                        <Items>
                                            <telerik:RadPanelItem Expanded="True" Text="ACE - Similar Course Content Found">
                                                <ContentTemplate>
                                                    <div class="padding-panels">
                                                        <telerik:RadGrid ID="rgSimilarities" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlCourseSimilarities" Width="100%" GroupingSettings-CaseSensitive="false" OnRowDrop="ACECourses_RowDrop" RenderMode="Lightweight" EnableHeaderContextMenu="true" OnItemDataBound="rgSimilarities_ItemDataBound">
                                                            <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                                            <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                                                <ClientEvents OnRowDblClick="RowDblClick" OnRowDragStarted="OnRowDragStarted" OnRowDropped="OnRowDropped" OnFilterMenuShowing="FilterMenuShowing"></ClientEvents>
                                                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                                            </ClientSettings>
                                                            <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlCourseSimilarities" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="None" AllowMultiColumnSorting="true" Name="ParentGrid" HierarchyLoadMode="ServerBind" DataKeyNames="AceID,TeamRevd" PageSize="7">
                                                                <DetailTables>
                                                                    <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlAceArticulationCourses" Width="100%" runat="server" DataKeyNames="AceID,TeamRevd" AllowFilteringByColumn="false" ShowHeader="false" AutoGenerateColumns="false">
                                                                        <ParentTableRelation>
                                                                            <telerik:GridRelationFields DetailKeyField="AceID" MasterKeyField="AceID"></telerik:GridRelationFields>
                                                                            <telerik:GridRelationFields DetailKeyField="TeamRevd" MasterKeyField="TeamRevd"></telerik:GridRelationFields>
                                                                        </ParentTableRelation>
                                                                        <Columns>
                                                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>
                                                                            <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" HeaderStyle-Font-Bold="true">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="3" UniqueName="EntityType" Display="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="RoleName" UniqueName="RoleName" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="TypeDescription" UniqueName="TypeDescription" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                        </Columns>
                                                                    </telerik:GridTableView>
                                                                </DetailTables>
                                                                <Columns>
                                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                                        <ItemTemplate>
                                                                            <asp:Label runat="server" ToolTip="This course has related articulations(s)." ID="btnHaveArticulatedCourses" Text='<i class="fa fa-indent" aria-hidden="true"></i>' CausesValidation="false" />
                                                                        </ItemTemplate>
                                                                    </telerik:GridTemplateColumn>
                                                                    <telerik:GridBoundColumn DataField="HaveArticulatedCourses" DataType="System.Boolean" UniqueName="HaveArticulatedCourses" Display="false">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="ACE ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="65px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" HeaderText="Team Rev Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" FilterControlAltText="Filter Title column" HeaderText="ACE Title" SortExpression="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="150px" HeaderStyle-Font-Bold="true">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="1" UniqueName="EntityType" Display="false">
                                                                    </telerik:GridBoundColumn>
                                                                </Columns>
                                                                <NoRecordsTemplate>
                                                                    <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                                                        &nbsp;No items to view
                                                                    </div>
                                                                </NoRecordsTemplate>
                                                            </MasterTableView>
                                                        </telerik:RadGrid>
                                                        <p>* ACE ( American Council on Education )</p>
                                                    </div>
                                                </ContentTemplate>
                                            </telerik:RadPanelItem>
                                        </Items>
                                    </telerik:RadPanelBar>


                                </asp:Panel>
                                <asp:Panel ID="pnlACECatalog" runat="server">
                                    <div class="row" style="margin: 0px 0 0px 0;">
                                        <div class="col-sm-4">
                                            <label><strong>Advanced Search :</strong> </label>
                                        </div>
                                        <div class="col-sm-4">
                                            <telerik:RadTextBox ID="rtbAttribute" Visible="false" Width="150px" runat="server" OnTextChanged="rtbAttribute_TextChanged" AutoPostBack="true" ClientIDMode="Static"></telerik:RadTextBox>
                                            <telerik:RadAutoCompleteBox ID="racACECourseAttribute" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Single" MinFilterLength="3" MaxResultCount="20" OnTextChanged="racACECourseAttribute_TextChanged" AutoPostBack="true" DropDownHeight="200" DataSourceID="sqlSmartKeywords" DataTextField="keyword" EmptyMessage="Advanced search..." DataValueField="keyword" OnClientEntryAdding="OnClientEntryAddingHandler" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true">
                                            </telerik:RadAutoCompleteBox>
                                            <asp:HiddenField ID="hfACECourseAdvancedSearch" runat="server" ClientIDMode="Static" />
                                        </div>
                                        <div class="col-sm-4">
                                            <telerik:RadButton RenderMode="Lightweight" ID="rbSearchAttribute" runat="server" ToolTip="Search ACE Catalog" OnClick="rbSearchAttribute_Click">
                                                <Icon PrimaryIconCssClass="rbSearch"></Icon>
                                            </telerik:RadButton>
                                            <telerik:RadButton RenderMode="Lightweight" ID="rbClearAttribute" runat="server" ToolTip="Clear Search Criteria" OnClick="rbClearAttribute_Click">
                                                <Icon PrimaryIconCssClass="rbCancel"></Icon>
                                            </telerik:RadButton>
                                        </div>
                                    </div>
                                    <div class="row" style="margin: 2px 0 10px 0;">
                                        <div class="col-sm-4" style="margin-bottom: 0px;">
                                            <label><strong>Occupation : </strong></label>
                                        </div>
                                        <div class="col-sm-8" style="margin-bottom: 0px;">
                                            <telerik:RadComboBox RenderMode="Lightweight" ID="rcbOccupations" runat="server" Width="350px" Height="400px" AllowCustomText="true" Filter="Contains" DataSourceID="sqlOccupations" DataValueField="occupation" DataTextField="title" AutoPostBack="true" DropDownAutoWidth="Enabled" AppendDataBoundItems="true">
                                                <Items>
                                                    <telerik:RadComboBoxItem Value="" Text="Select an occupation" />
                                                </Items>
                                            </telerik:RadComboBox>
                                        </div>
                                    </div>

                                    <telerik:RadGrid ID="rgACECourses" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlACECourses" Width="100%" GroupingSettings-CaseSensitive="false" OnRowDrop="ACECourses_RowDrop" RenderMode="Lightweight" EnableHeaderContextMenu="true" OnItemDataBound="rgACECourses_ItemDataBound" ClientSettings-Scrolling-AllowScroll="true" Height="460px" OnItemCommand="rgACEOccupations_ItemCommand" EnableHierarchyExpandAll="true">
                                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                        <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                            <ClientEvents OnRowDblClick="RowDblClick" OnRowDragStarted="OnRowDragStarted" OnRowDropped="OnRowDropped" OnFilterMenuShowing="FilterMenuShowing"></ClientEvents>
                                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                        </ClientSettings>
                                        <ExportSettings HideStructureColumns="true" ExportOnlyData="True" OpenInNewWindow="True" IgnorePaging="True">
                                        </ExportSettings>
                                        <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlACECourses" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="Top" AllowMultiColumnSorting="true" Name="ParentGrid" HierarchyDefaultExpanded="true" DataKeyNames="AceID,TeamRevd" PageSize="7">
                                            <CommandItemTemplate>
                                                <div class="commandItems">
                                                    <telerik:RadButton ID="btnExcel" runat="server" Text=" Print" ButtonType="StandardButton" CommandName="ExportToExcel" OnClientClicking="ExportConfirm" ToolTip="Click here to export filtered ACE Course list and their related articulations (This might take a few minutes.)">
                                                        <ContentTemplate>
                                                            <i class='fa fa-file-excel-o'></i>Export to Excel
                                                        </ContentTemplate>
                                                    </telerik:RadButton>
                                                </div>
                                            </CommandItemTemplate>
                                            <DetailTables>
                                                <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlAceArticulationCourses" Width="100%" runat="server" DataKeyNames="AceID,TeamRevd" AllowFilteringByColumn="false" ShowHeader="false" AutoGenerateColumns="false">
                                                    <ParentTableRelation>
                                                        <telerik:GridRelationFields DetailKeyField="AceID" MasterKeyField="AceID"></telerik:GridRelationFields>
                                                        <telerik:GridRelationFields DetailKeyField="TeamRevd" MasterKeyField="TeamRevd"></telerik:GridRelationFields>
                                                    </ParentTableRelation>
                                                    <Columns>
                                                        <telerik:GridTemplateColumn Exportable="false">
                                                            <ItemTemplate>
                                                                <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                                <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip22" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                                    <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                                </telerik:RadToolTip>
                                                            </ItemTemplate>
                                                        </telerik:GridTemplateColumn>
                                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                            <ItemTemplate>
                                                                <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                                            </ItemTemplate>
                                                        </telerik:GridTemplateColumn>
                                                        <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="3" UniqueName="EntityType" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="RoleName" UniqueName="RoleName" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="TypeDescription" UniqueName="TypeDescription" Display="false" Exportable="false">
                                                        </telerik:GridBoundColumn>
                                                    </Columns>
                                                </telerik:GridTableView>
                                            </DetailTables>
                                            <Columns>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ToolTip="This course has related articulations(s)." ID="btnHaveArticulatedCourses" Text='<i class="fa fa-indent" aria-hidden="true"></i>' CausesValidation="false" />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="HaveArticulatedCourses" DataType="System.Boolean" UniqueName="HaveArticulatedCourses" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:LinkButton Visible="false" runat="server" ToolTip="This course have denied articulation(s) in other colleges." CommandName="AdoptArticulations" ID="btnHaveDeniedArticulations" Text='<i class="fa fa-ban" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="HaveDeniedArticulations" UniqueName="HaveDeniedArticulations" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false">
                                                    <ItemTemplate>
                                                        <asp:LinkButton Visible="false" runat="server" ToolTip="This course have articulation(s) in other colleges." CommandName="AdoptArticulations" ID="btnArticulationsInOtherColleges" Text='<i class="fa fa-university" aria-hidden="true"></i>' />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="ArticulationsInOtherColleges" UniqueName="ArticulationsInOtherColleges" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="ACE ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="65px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" HeaderText="Team Rev Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Title" UniqueName="Title" FilterControlAltText="Filter Title column" HeaderText="ACE Title" SortExpression="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="150px" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="1" UniqueName="EntityType" Display="false" Exportable="false">
                                                </telerik:GridBoundColumn>
                                            </Columns>
                                            <NoRecordsTemplate>
                                                <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                                    &nbsp;No items to view
                                                </div>
                                            </NoRecordsTemplate>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                    <p>* ACE ( American Council on Education )</p>

                                </asp:Panel>
                            </asp:Panel>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="rpvACEOccupation" Width="100%">
                            <asp:Panel ID="pnlOccupations" runat="server">
                                <div class="row">
                                    <div class="col-sm-4">
                                        <h3 style="font-weight: bold; margin-top: 10px;">ACE Occupation Codes</h3>
                                    </div>
                                    <div class="col-sm-8" style="font-weight: bold; margin-top: 5px;">
                                        Service :
                                <asp:Label ID="draggedRows" runat="server"></asp:Label>
                                        <telerik:RadComboBox ID="rcbServices" runat="server" DataSourceID="sqlServices" DataTextField="description" DataValueField="Code" AutoPostBack="true" CheckBoxes="true" Width="200px" AppendDataBoundItems="true" EnableCheckAllItemsCheckBox="true" OnPreRender="rcbServices_PreRender" OnSelectedIndexChanged="rcbServices_SelectedIndexChanged" RenderMode="Lightweight" DropDownAutoWidth="Enabled">
                                        </telerik:RadComboBox>
                                    </div>
                                </div>
                                <div class="row" style="margin: 10px 0 10px 0;">
                                    <div class="col-sm-4">
                                        <telerik:RadAutoCompleteBox ID="racAdvanceSearch" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Single" MinFilterLength="3" MaxResultCount="20" OnTextChanged="rtbOccAttribute_TextChanged" AutoPostBack="true" DropDownHeight="200" DataSourceID="sqlSmartKeywords" DataTextField="keyword" EmptyMessage="Advanced search..." DataValueField="keyword" OnClientEntryAdding="OnClientEntryAddingHandler" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true">
                                        </telerik:RadAutoCompleteBox>
                                        <asp:HiddenField ID="hfAdvancedSarch" runat="server" ClientIDMode="Static" />
                                    </div>
                                    <div class="col-sm-4">
                                        <telerik:RadCheckBox ID="rchkSearchRecommendationsOcc" AutoPostBack="true" runat="server" Text="Search Recommendations" OnCheckedChanged="rchkSearchRecommendationsOcc_CheckedChanged"></telerik:RadCheckBox>
                                    </div>
                                    <div class="col-sm-4">
                                        <telerik:RadButton RenderMode="Lightweight" ID="rbSearchOccAttribute" runat="server" ToolTip="Search ACE Catalog" Width="50px" OnClick="rbSearchOccAttribute_Click" AutoPostBack="true" ValidationGroup="AdvancedSearchOccupation" ClientIDMode="Static">
                                            <Icon PrimaryIconCssClass="rbSearch"></Icon>
                                        </telerik:RadButton>
                                        <telerik:RadButton RenderMode="Lightweight" ID="rbClearOccAttribute" runat="server" ToolTip="Clear Search Criteria" Width="50px" OnClick="rbClearOccAttribute_Click">
                                            <Icon PrimaryIconCssClass="rbCancel"></Icon>
                                        </telerik:RadButton>
                                    </div>
                                </div>
                                <asp:Panel ID="panelSmartKeys" runat="server" Visible="false">
                                    <div class="panel-heading">Smart Keywords</div>
                                    <div class="panel-body">
                                        <div class="col-sm-6">
                                            Would you like to add this search keyword to Smart Keyword database ?
                                        </div>
                                        <div class="col-sm-6">
                                            <telerik:RadButton RenderMode="Lightweight" ID="rbAddSmartKeyword" runat="server" Text="Add Smart Keyword" OnClick="rbAddSmartKeyword_Click">
                                                <Icon PrimaryIconCssClass="rbAdd"></Icon>
                                            </telerik:RadButton>
                                            <telerik:RadButton RenderMode="Lightweight" ID="rbCancelSkartKeyword" runat="server" Text="Cancel" OnClick="rbCancelSkartKeyword_Click">
                                                <Icon PrimaryIconCssClass="rbCancel"></Icon>
                                            </telerik:RadButton>
                                        </div>
                                    </div>
                                </asp:Panel>
                                <div class="row">
                                    <div class="col-sm-12 col-md-12" style="height: 440px;">
                                        <telerik:RadGrid ID="rgACEOccupations" runat="server" AllowFilteringByColumn="True" AllowPaging="true" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlAllOccupations" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" OnRowDrop="ACEOccupations_RowDrop" OnItemDataBound="rgACEOccupations_ItemDataBound" AllowMultiRowSelection="true" ClientSettings-Scrolling-AllowScroll="true" Height="460px" EnableHierarchyExpandAll="true" OnItemCommand="rgACEOccupations_ItemCommand">
                                            <GroupingSettings CaseSensitive="false" />
                                            <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                                <ClientEvents OnRowDblClick="RowDblClick" OnRowDragStarted="OnRowDragStarted" OnRowDropped="OnRowDropped" OnFilterMenuShowing="FilterMenuShowing"></ClientEvents>
                                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                            </ClientSettings>
                                            <ExportSettings HideStructureColumns="true" ExportOnlyData="True" OpenInNewWindow="True" IgnorePaging="True">
                                            </ExportSettings>
                                            <MasterTableView DataKeyNames="AceID,TeamRevd" DataSourceID="sqlAllOccupations" CommandItemDisplay="Top" AllowMultiColumnSorting="true" Name="ParentGrid" HeaderStyle-Font-Bold="true" PageSize="50" HierarchyDefaultExpanded="true">
                                                <CommandItemTemplate>
                                                    <div class="commandItems">
                                                        <telerik:RadButton ID="btnExcel" runat="server" Text=" Print" ButtonType="StandardButton" CommandName="ExportToExcel" OnClientClicking="ExportConfirm" ToolTip="Click here to export filtered ACE Occupations list and their related articulations (This might take a few minutes.)">
                                                            <ContentTemplate>
                                                                <i class='fa fa-file-excel-o'></i>Export to Excel
                                                            </ContentTemplate>
                                                        </telerik:RadButton>
                                                    </div>
                                                </CommandItemTemplate>
                                                <DetailTables>
                                                    <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="true" DataSourceID="sqlOccupationCollegeCourses" Width="100%" runat="server" DataKeyNames="AceID,TeamRevd" AllowFilteringByColumn="false" ShowHeader="false">
                                                        <ParentTableRelation>
                                                            <telerik:GridRelationFields DetailKeyField="AceID" MasterKeyField="AceID"></telerik:GridRelationFields>
                                                            <telerik:GridRelationFields DetailKeyField="TeamRevd" MasterKeyField="TeamRevd"></telerik:GridRelationFields>
                                                        </ParentTableRelation>
                                                        <Columns>
                                                            <telerik:GridTemplateColumn Exportable="false">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip22" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                                        <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                                    </telerik:RadToolTip>
                                                                </ItemTemplate>
                                                            </telerik:GridTemplateColumn>
                                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                                                </ItemTemplate>
                                                            </telerik:GridTemplateColumn>
                                                            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="RoleName" UniqueName="RoleName" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" HeaderStyle-Font-Bold="true">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="3" UniqueName="EntityType" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn EmptyDataText="Occupations" UniqueName="TypeDescription" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                        </Columns>
                                                    </telerik:GridTableView>
                                                </DetailTables>
                                                <CommandItemSettings ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                                                <Columns>
                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ToolTip="This occupation have related course(s)." ID="btnOccupationHaveCourses" Text='<i class="fa fa-book" aria-hidden="true"></i>' CausesValidation="false" />
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn DataField="HaveRelatedCourses" UniqueName="HaveRelatedCourses" Display="false" Exportable="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false">
                                                        <ItemTemplate>
                                                            <asp:LinkButton Visible="false" runat="server" ToolTip="This occupation have denied articulation(s) in other colleges." CommandName="AdoptArticulations" ID="btnHaveDeniedArticulations" Text='<i class="fa fa-ban" aria-hidden="true"></i>' />
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn DataField="HaveDeniedArticulations" UniqueName="HaveDeniedArticulations" Display="false" Exportable="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false">
                                                        <ItemTemplate>
                                                            <asp:LinkButton Visible="false" runat="server" ToolTip="This occupation have articulation(s) in other colleges." CommandName="AdoptArticulations" ID="btnArticulationsInOtherColleges" Text='<i class="fa fa-university" aria-hidden="true"></i>' />
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn DataField="ArticulationsInOtherColleges" UniqueName="ArticulationsInOtherColleges" Display="false" Exportable="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="Occupation" FilterControlAltText="Filter Occupation column" HeaderText="Occ. Code" SortExpression="Occupation" UniqueName="Occupation" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="40px" HeaderStyle-Width="30px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="Title" FilterControlAltText="Filter Title column" HeaderText="Occupation" SortExpression="Title" UniqueName="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="Ace ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Exhibit" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="40px" FilterControlWidth="50px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridDateTimeColumn DataField="TeamRevd" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="90px" FilterControlToolTip="Search by TeamRevd" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" Display="True">
                                                        <HeaderStyle Width="100px" />
                                                    </telerik:GridDateTimeColumn>
                                                    <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="2" UniqueName="EntityType" Display="false" Exportable="false">
                                                    </telerik:GridBoundColumn>
                                                </Columns>
                                            </MasterTableView>
                                        </telerik:RadGrid>
                                    </div>
                                </div>

                            </asp:Panel>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="rpvLocation" Width="100%">
                            <asp:Panel ID="pnlLocation" runat="server">
                                <asp:SqlDataSource ID="sqlService" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select code, [description] from LookupService"></asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlLocations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT DISTINCT [Location] FROM ACEExhibitLocation ORDER BY [Location]"></asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlLocationList" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetLocation" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                                    <SelectParameters>
                                        <asp:Parameter DbType="String" Name="Location" DefaultValue="" ConvertEmptyStringToNull="false" />
                                        <asp:Parameter DbType="String" Name="Service" />
                                        <asp:ControlParameter ControlID="hfExcludeArticulationOverYears" DbType="Int32" Name="ExcludeArticulationOverYears" PropertyName="Value" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlLocationDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT distinct  el.AceID, el.TeamRevd, el.Location, 'Course' as 'TypeDescription', c.Title  AS 'Title', 1 as 'EntityType', (select isnull(count(*),0) from Articulation where  ArticulationStatus <> 3 and CollegeID = @CollegeID and AceID = c.AceID and TeamRevd = c.TeamRevd) as 'HaveRelatedCourses', c.StartDate, c.EndDate FROM  AceExhibitLocation el left outer join AceExhibit c on el.AceID = c.AceID and el.TeamRevd = c.TeamRevd  WHERE el.Location = @Location and el.TeamRevd > DATEADD(year,-@ExcludeArticulationOverYears,getdate()) order by el.AceID">
                                    <SelectParameters>
                                        <asp:Parameter DbType="String" Name="Location" DefaultValue="" ConvertEmptyStringToNull="false" />
                                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" DbType="Int32" />
                                        <asp:ControlParameter ControlID="hfExcludeArticulationOverYears" DbType="Int32" Name="ExcludeArticulationOverYears" PropertyName="Value" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <telerik:RadAutoCompleteBox ID="racLocations" runat="server" Width="420px" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="20" DropDownHeight="200" DataSourceID="sqlLocations" DataTextField="Location" EmptyMessage="Advanced search..." DataValueField="Location" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true" Delimiter=";">
                                </telerik:RadAutoCompleteBox>
                                <telerik:RadComboBox ID="rcbLocationService" runat="server" DataSourceID="sqlService" DataTextField="description" DataValueField="Code" AutoPostBack="true" CheckBoxes="true" Width="150px" AppendDataBoundItems="true" EnableCheckAllItemsCheckBox="true" OnPreRender="rcbLocationService_PreRender" OnSelectedIndexChanged="rcbLocationService_SelectedIndexChanged" RenderMode="Lightweight" DropDownAutoWidth="Enabled">
                                </telerik:RadComboBox>
                                <telerik:RadButton ID="rbLocationSearch" runat="server" Text="Search" OnClick="rbLocationSearch_Click"></telerik:RadButton>
                                <telerik:RadButton ID="rbLocationClear" runat="server" Text="Clear" OnClick="rbLocationClear_Click"></telerik:RadButton>
                                <telerik:RadGrid ID="rgLocations" runat="server" AllowFilteringByColumn="True" AllowPaging="true" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlLocationList" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" AllowMultiRowSelection="true" ClientSettings-Scrolling-AllowScroll="true" Height="660px" EnableHierarchyExpandAll="true" HeaderStyle-Font-Bold="true" OnItemDataBound="rgLocations_ItemDataBound" OnItemCommand="rgLocations_ItemCommand" OnRowDrop="rgLocations_RowDrop">
                                    <GroupingSettings CaseSensitive="false" />
                                    <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                        <ClientEvents OnRowDblClick="RowDblClick"></ClientEvents>
                                        <Scrolling AllowScroll="True" UseStaticHeaders="true" />
                                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                    </ClientSettings>
                                    <ExportSettings HideStructureColumns="true" ExportOnlyData="True" OpenInNewWindow="True" IgnorePaging="True">
                                    </ExportSettings>
                                    <MasterTableView DataKeyNames="Location" DataSourceID="sqlLocationList" CommandItemDisplay="Top" AllowMultiColumnSorting="true" Name="ParentGrid" HeaderStyle-Font-Bold="true" PageSize="50" HierarchyDefaultExpanded="true">
                                        <CommandItemTemplate>
                                            <div class="commandItems">
                                                <telerik:RadButton ID="btnExcel" runat="server" Text=" Print" ButtonType="StandardButton" CommandName="ExportToExcel" OnClientClicking="ExportConfirm" ToolTip="Click here to export filtered ACE Occupations list and their related articulations (This might take a few minutes.)">
                                                    <ContentTemplate>
                                                        <i class='fa fa-file-excel-o'></i>Export to Excel
                                                    </ContentTemplate>
                                                </telerik:RadButton>
                                            </div>
                                        </CommandItemTemplate>
                                        <DetailTables>
                                            <telerik:GridTableView Name="ParentCourses" EnableHierarchyExpandAll="true" DataSourceID="sqlLocationDetails" Width="100%" runat="server" DataKeyNames="Location,AceID,TeamRevd" AllowFilteringByColumn="false">
                                                <ParentTableRelation>
                                                    <telerik:GridRelationFields DetailKeyField="Location" MasterKeyField="Location"></telerik:GridRelationFields>
                                                </ParentTableRelation>
                                                <DetailTables>
                                                    <telerik:GridTableView Name="ChildGridArticulations" DataSourceID="sqlArticulationDetails" Width="100%" runat="server" DataKeyNames="AceID,TeamRevd" AllowFilteringByColumn="false" ShowHeader="false" AutoGenerateColumns="false">
                                                        <ParentTableRelation>
                                                            <telerik:GridRelationFields DetailKeyField="AceID" MasterKeyField="AceID"></telerik:GridRelationFields>
                                                            <telerik:GridRelationFields DetailKeyField="TeamRevd" MasterKeyField="TeamRevd"></telerik:GridRelationFields>
                                                        </ParentTableRelation>
                                                        <Columns>
                                                            <telerik:GridTemplateColumn Exportable="false" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip22" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                                        <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                                    </telerik:RadToolTip>
                                                                </ItemTemplate>
                                                            </telerik:GridTemplateColumn>
                                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                                                </ItemTemplate>
                                                            </telerik:GridTemplateColumn>
                                                            <telerik:GridBoundColumn SortExpression="TypeDescription" HeaderText="Type" DataField="TypeDescription" UniqueName="TypeDescription" HeaderStyle-Font-Bold="true" ItemStyle-Width="100px">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="Title" UniqueName="Title" HeaderText="Title" HeaderStyle-Width="50px" Display="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="RoleName" UniqueName="RoleName" Display="false" Exportable="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" HeaderStyle-Font-Bold="true">
                                                            </telerik:GridBoundColumn>
                                                        </Columns>
                                                    </telerik:GridTableView>
                                                </DetailTables>
                                                <Columns>
                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" ItemStyle-Width="10px" Exportable="false">
                                                        <ItemTemplate>
                                                            <asp:Label CssClass="badge" runat="server" ID="badgeCoursesCount"></asp:Label>
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn DataField="HaveRelatedCourses" UniqueName="HaveRelatedCourses" Display="false" Exportable="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="Location" UniqueName="Location" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="TypeDescription" UniqueName="TypeDescription" HeaderText="Type" HeaderStyle-Width="50px" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" HeaderText="Ace ID" HeaderStyle-Width="100px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" HeaderText="Team Revd" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Width="90px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Start Date" HeaderStyle-Width="90px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText="End Date" HeaderStyle-Width="90px">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" HeaderText="Title">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="EntityType" UniqueName="EntityType" Display="false" Exportable="false">
                                                    </telerik:GridBoundColumn>
                                                </Columns>
                                            </telerik:GridTableView>
                                        </DetailTables>
                                        <CommandItemSettings ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                                        <Columns>
                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="60px" ItemStyle-Width="10px" Display="false" Exportable="false">
                                                <ItemTemplate>
                                                    <asp:Label CssClass="badge" runat="server" ID="badgeRelatedCourses"></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="RecordCount" UniqueName="RecordCount" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Location" FilterControlAltText="Filter Location column" HeaderText="Location" SortExpression="Location" UniqueName="Location" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="300px" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                            </asp:Panel>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="rpvCriteria" Width="100%">
                            <asp:Panel ID="pnlCriteria" runat="server">
                                <asp:SqlDataSource ID="sqlCriteriaService" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct SUBSTRING(AceID,1,CHARINDEX('-',AceID)-1) as 'code', SUBSTRING(AceID,1,CHARINDEX('-',AceID)-1) as 'description' from ACEExhibitCriteria "></asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT DISTINCT CriteriaCategory FROM AceExhibitCriteria ORDER BY CriteriaCategory"></asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlDisciplines" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="spSubjectsListByCollege" SelectCommandType="StoredProcedure">
                                    <SelectParameters>
                                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:SqlDataSource ID="GetGroupCriteriaByDiscipline" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetGroupCriteriaByDiscipline" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                                    <SelectParameters>
                                        <asp:Parameter DbType="Int32" Name="SubjectID" DefaultValue="" ConvertEmptyStringToNull="false" />
                                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                                        <asp:ControlParameter ControlID="rcbExcludeCredRecommendations" DbType="Boolean" Name="ExcludeCredRecommendations" PropertyName="Checked" />
										<asp:ControlParameter ControlID="racbRecCriteria" DbType="String" Name="Criteria" PropertyName="Text" DefaultValue="" ConvertEmptyStringToNull="false" />																																						 
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:SqlDataSource ID="GetCriteriaByDiscipline" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetCriteriaByDiscipline" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                                    <SelectParameters>
                                        <asp:Parameter DbType="Int32" Name="SubjectID" DefaultValue="" ConvertEmptyStringToNull="false" />
                                        <asp:Parameter DbType="String" Name="CriteriaDescription" DefaultValue="" ConvertEmptyStringToNull="false" />
                                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                                        <asp:ControlParameter ControlID="rcbExcludeCredRecommendations" DbType="Boolean" Name="ExcludeCredRecommendations" PropertyName="Checked" />
										<asp:ControlParameter ControlID="racbRecCriteria" DbType="String" Name="Criteria" PropertyName="Text" DefaultValue="" ConvertEmptyStringToNull="false" />																																						 
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlCriteriaDisciplines" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetCriteriaDisciplines" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                                    <SelectParameters>
                                        
                                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
										<asp:ControlParameter ControlID="racbRecCriteria" DbType="String" Name="Criteria" PropertyName="Text" DefaultValue="" ConvertEmptyStringToNull="false" />																																						 
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlCriteriaDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT distinct C.AceID, C.TeamRevd, C.Criteria, C.CriteriaDescription, CASE WHEN ae.AceType = 1 THEN 'Course' ELSE 'Occupation' END AS 'TypeDescription', ae.Title, ae.AceType as 'EntityType', (select isnull(count(*),0) from Articulation where  ArticulationStatus <> 3 and CollegeID = @CollegeID and AceID = c.AceID and TeamRevd = c.TeamRevd) as 'HaveRelatedCourses', ae.StartDate, ae.EndDate  FROM ACEExhibitCriteria C LEFT OUTER JOIN AceExhibit ae ON C.AceID = ae.AceID AND C.TeamRevd = ae.TeamRevd LEFT OUTER JOIN CriteriaCategory CC ON C.CriteriaCategory = C.CriteriaDescription AND C.Criteria = CC.Criteria WHERE C.Criteria = @Criteria and C.CriteriaDescription = @CriteriaDescription AND isnull(cc.DoNotArticulate,0) <> @ExcludeCredRecommendations  order by c.AceID">
                                    <SelectParameters>
                                        <asp:Parameter DbType="String" Name="Criteria" />
                                        <asp:Parameter DbType="String" Name="CriteriaDescription" />
                                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" DbType="Int32" />
                                        <asp:ControlParameter ControlID="hfExcludeArticulationOverYears" DbType="Int32" Name="ExcludeArticulationOverYears" PropertyName="Value" />
                                        <asp:ControlParameter ControlID="rcbExcludeCredRecommendations" DbType="Boolean" Name="ExcludeCredRecommendations" PropertyName="Checked" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <telerik:RadAutoCompleteBox ID="racbRecCriteria" runat="server" Width="350px" Filter="Contains" TextSettings-SelectionMode="Single" MinFilterLength="3" MaxResultCount="20" DropDownHeight="200" DataSourceID="sqlRecCriteria" DataTextField="Criteria" EmptyMessage="Advanced search..." DataValueField="Criteria" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true" >
                                </telerik:RadAutoCompleteBox>
								<asp:SqlDataSource ID="sqlRecCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT DISTINCT Criteria FROM AceExhibitCriteria ORDER BY Criteria"></asp:SqlDataSource>																																																							   
                                <div style="display: none;">
								<telerik:RadAutoCompleteBox ID="racbCriteria" runat="server" Width="350px" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="20" DropDownHeight="200" DataSourceID="sqlDisciplines" DataTextField="SubjectName" EmptyMessage="Advanced search..." DataValueField="subject_id" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true" Delimiter=",">
                                </telerik:RadAutoCompleteBox>	 
                                    <telerik:RadComboBox ID="rcbCriteriaService" runat="server" DataSourceID="sqlCriteriaService" DataTextField="description" DataValueField="Code" AutoPostBack="true" CheckBoxes="true" Width="150px" AppendDataBoundItems="true" EnableCheckAllItemsCheckBox="true" RenderMode="Lightweight" DropDownAutoWidth="Enabled">
                                    </telerik:RadComboBox>
                                </div>
                                <telerik:RadButton ID="rbCriteria" runat="server" Text="Search" OnClick="rbCriteria_Click"></telerik:RadButton>
                                <telerik:RadButton ID="rbClearCriteria" runat="server" Text="Clear" OnClick="rbClearCriteria_Click"></telerik:RadButton>
                                <telerik:RadCheckBox ID="rcbExcludeCredRecommendations" AutoPostBack="true" runat="server" Text="Exclude Credit Recommendations"></telerik:RadCheckBox>
                                <telerik:RadGrid ID="rgCriteria" runat="server" AllowFilteringByColumn="True" AllowPaging="true" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlCriteriaDisciplines" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" AllowMultiRowSelection="true" ClientSettings-Scrolling-AllowScroll="true" Height="660px" HeaderStyle-Font-Bold="true" OnItemCommand="rgLocations_ItemCommand" OnItemDataBound="rgLocations_ItemDataBound" OnRowDrop="rgCriteria_RowDrop" GroupPanel-Font-Bold="true" GroupHeaderItemStyle-Font-Bold="true" Visible="false">
                                    <GroupingSettings CaseSensitive="false" />
                                    <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                        <ClientEvents OnRowDblClick="RowDblClick"></ClientEvents>
                                        <Scrolling AllowScroll="True" UseStaticHeaders="true" />
                                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                    </ClientSettings>
                                    <ExportSettings HideStructureColumns="true" ExportOnlyData="True" OpenInNewWindow="True" IgnorePaging="True">
                                    </ExportSettings>
                                    <MasterTableView DataKeyNames="SubjectID" DataSourceID="sqlCriteriaDisciplines" CommandItemDisplay="Top" AllowMultiColumnSorting="true" Name="ParentGrid" HeaderStyle-Font-Bold="true" PageSize="50">
                                        <CommandItemTemplate>
                                            <div class="commandItems">
                                                <telerik:RadButton ID="btnExcel" runat="server" Text=" Print" ButtonType="StandardButton" CommandName="ExportToExcel" OnClientClicking="ExportConfirm" ToolTip="Click here to export filtered ACE Occupations list and their related articulations (This might take a few minutes.)">
                                                    <ContentTemplate>
                                                        <i class='fa fa-file-excel-o'></i>Export to Excel
                                                    </ContentTemplate>
                                                </telerik:RadButton>
                                            </div>
                                        </CommandItemTemplate>
                                        <CommandItemSettings ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                                        <DetailTables>
                                            <telerik:GridTableView Name="ParentGroup" DataSourceID="GetGroupCriteriaByDiscipline" DataKeyNames="SubjectID,CriteriaDescription" Width="100%" runat="server">
                                                <ParentTableRelation>
                                                    <telerik:GridRelationFields DetailKeyField="SubjectID" MasterKeyField="SubjectID" />
                                                </ParentTableRelation>
                                                <DetailTables>
                                                    <telerik:GridTableView Name="ParentCriteria" DataSourceID="GetCriteriaByDiscipline" DataKeyNames="CriteriaDescription,Criteria" Width="100%" runat="server">
                                                        <ParentTableRelation>
                                                            <telerik:GridRelationFields DetailKeyField="SubjectID" MasterKeyField="SubjectID" />
                                                            <telerik:GridRelationFields DetailKeyField="CriteriaDescription" MasterKeyField="CriteriaDescription"></telerik:GridRelationFields>
                                                        </ParentTableRelation>
                                                        <DetailTables>
                                                            <telerik:GridTableView Name="ParentCourses" EnableHierarchyExpandAll="true" DataSourceID="sqlCriteriaDetails" Width="100%" runat="server" DataKeyNames="CriteriaDescription,Criteria,AceID,TeamRevd" AllowFilteringByColumn="false">
                                                                <ParentTableRelation>
                                                                    <telerik:GridRelationFields DetailKeyField="CriteriaDescription" MasterKeyField="CriteriaDescription"></telerik:GridRelationFields>
                                                                    <telerik:GridRelationFields DetailKeyField="Criteria" MasterKeyField="Criteria"></telerik:GridRelationFields>
                                                                </ParentTableRelation>
                                                                <DetailTables>
                                                                    <telerik:GridTableView Name="ChildGridArticulations" DataSourceID="sqlArticulationDetails" Width="100%" runat="server" DataKeyNames="AceID,TeamRevd" AllowFilteringByColumn="false" ShowHeader="false" AutoGenerateColumns="false">
                                                                        <ParentTableRelation>
                                                                            <telerik:GridRelationFields DetailKeyField="AceID" MasterKeyField="AceID"></telerik:GridRelationFields>
                                                                            <telerik:GridRelationFields DetailKeyField="TeamRevd" MasterKeyField="TeamRevd"></telerik:GridRelationFields>
                                                                        </ParentTableRelation>
                                                                        <Columns>
                                                                            <telerik:GridTemplateColumn Exportable="false" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                                                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip22" runat="server" TargetControlID="lblArticulate" Width="150px" RelativeTo="Element" Position="MiddleRight" ManualClose="true">
                                                                                        <%# DataBinder.Eval(Container, "DataItem.DeniedComments") %>
                                                                                    </telerik:RadToolTip>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>
                                                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>
                                                                            <telerik:GridBoundColumn SortExpression="TypeDescription" HeaderText="Type" DataField="TypeDescription" UniqueName="TypeDescription" HeaderStyle-Font-Bold="true" ItemStyle-Width="100px">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="Title" UniqueName="Title" HeaderText="Title" HeaderStyle-Width="50px" Display="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="DeniedComments" UniqueName="DeniedComments" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="RoleName" UniqueName="RoleName" Display="false" Exportable="false">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" HeaderStyle-Font-Bold="true">
                                                                            </telerik:GridBoundColumn>
                                                                        </Columns>
                                                                    </telerik:GridTableView>
                                                                </DetailTables>
                                                                <Columns>
                                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" ItemStyle-Width="10px" Exportable="false">
                                                                        <ItemTemplate>
                                                                            <asp:Label CssClass="badge badgeCoursesCountColor" runat="server" ID="badgeCoursesCount"></asp:Label>
                                                                        </ItemTemplate>
                                                                    </telerik:GridTemplateColumn>
                                                                    <telerik:GridBoundColumn DataField="HaveRelatedCourses" UniqueName="HaveRelatedCourses" Display="false" Exportable="false">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="Criteria" UniqueName="Criteria" Display="false">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="TypeDescription" UniqueName="TypeDescription" HeaderText="Type">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" HeaderText="Ace ID">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Team Revd">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Start Date">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}" HeaderText="End Date">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" HeaderText="Title">
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn DataField="EntityType" UniqueName="EntityType" Display="false" Exportable="false">
                                                                    </telerik:GridBoundColumn>
                                                                </Columns>
                                                            </telerik:GridTableView>
                                                        </DetailTables>
                                                        <Columns>
                                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="40px" ItemStyle-Width="10px" Display="true" Exportable="false">
                                                                <ItemTemplate>
                                                                    <asp:Label CssClass="badge" runat="server" ID="badgeRelatedCourses"></asp:Label>
                                                                </ItemTemplate>
                                                            </telerik:GridTemplateColumn>
                                                            <telerik:GridBoundColumn DataField="RecordCount" UniqueName="RecordCount" Display="false" AllowFiltering="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="CriteriaDescription" FilterControlAltText="Filter CriteriaDescription column" HeaderText="Uniform Credit Recommendation" SortExpression="CriteriaDescription" UniqueName="CriteriaDescription" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="180px" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="true">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="Criteria" FilterControlAltText="Filter Criteria column" HeaderText="Original ACE Credit Recommendation" SortExpression="Criteria" UniqueName="Criteria" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="180px" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="true">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn SortExpression="Units" HeaderText="Units" DataField="Units" UniqueName="Units" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="true" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" CurrentFilterFunction="Contains">
                                                            </telerik:GridBoundColumn>
                                                        </Columns>
                                                    </telerik:GridTableView>
                                                </DetailTables>
                                                <Columns>
                                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="40px" ItemStyle-Width="10px" Display="true" Exportable="false">
                                                        <ItemTemplate>
                                                            <asp:Label CssClass="badge" runat="server" ID="badgeRelatedCourses"></asp:Label>
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                    <telerik:GridBoundColumn DataField="RecordCount" UniqueName="RecordCount" Display="false" AllowFiltering="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="SubjectID" UniqueName="SubjectID" DataType="System.Int32" Display="false">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="CriteriaDescription" FilterControlAltText="Filter CriteriaDescription column" HeaderText="Uniform Credit Recommendation" SortExpression="CriteriaDescription" UniqueName="CriteriaDescription" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="180px" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                </Columns>
                                            </telerik:GridTableView>
                                        </DetailTables>
                                        <Columns>
                                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="60px" ItemStyle-Width="10px" Display="false" Exportable="false">
                                                <ItemTemplate>
                                                    <asp:Label CssClass="badge" runat="server" ID="badgeRelatedCourses"></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="SubjectID" UniqueName="SubjectID" DataType="System.Int32" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="RecordCount" UniqueName="RecordCount" DataType="System.Int32" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="SubjectName" FilterControlAltText="Filter SubjectName column" HeaderText="Discipline" SortExpression="SubjectName" UniqueName="SubjectName" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="300px" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                            </asp:Panel>
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>






                </div>
            </div>
        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">

        var handler = Telerik.Web.UI.RadAutoCompleteBox.prototype._onKeyDown;
        Telerik.Web.UI.RadAutoCompleteBox.prototype._onKeyDown = function (e) {

            handler.apply(this, [e]); // Let AutoCompleteBox finish it's internal logic

            if (e.keyCode == Sys.UI.Key.enter) {
                this._onBlur();

                $get("rbSearchOccAttribute").click();
            }
        }

        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }

        function OnRowDragStarted(sender, args) {
            if (args.get_tableView().get_name() == "ChildGrid") {
                args.set_cancel(true);
            }
        }
        function OnRowDropped(sender, args) {
            if (args._targetItemTableView.get_name() == "ChildGrid" || args._targetItemTableView.get_name() == "ChildGridArticulations") {
                args.set_cancel(true);
            }
        }

        function ArticulationCreated() {
            $('#divArticulationCreated').fadeIn(1500).delay(1000).fadeOut(1500);
        }

        function selectedRowNorco(sender, eventArgs) {
            var item = eventArgs.get_item();
            var cell = item.get_cell("outline_id");
            var value = $telerik.$(cell).text().trim();
            var cellTitle = item.get_cell("course_title");
            var valueTitle = $telerik.$(cellTitle).text().trim();
            document.getElementById('selectedRowValue').value = value;
            document.getElementById('selectedCourseTitle').value = valueTitle;
        }

        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }

        $(window).scroll(function () {
            t = $('.ACEContainer').offset();
            t = t.top;

            s = $(window).scrollTop();

            d = t - s;

            if (d < 0) {
                $('.ACEViews').addClass('fixed');
                $('.ACEContainer').addClass('paddingTop');
                $('.ACEContainer').addClass('paddingBotton');
            } else {
                $('.ACEViews').removeClass('fixed');
                $('.ACEContainer').removeClass('paddingTop');
            }
        });

        function ExportConfirm(sender, args) {
            args.set_cancel(!window.confirm("Make sure you apply any filters first! Exporting ALL ACE catalog data without any search criteria will take some time. Do you want to proceed ?"));
        }

        function OpenRecommendationCriteria(sender, eventArgs) {
            var oWindow = window.radopen("../popups/ArticulationsCRiteria.aspx", null);
            oWindow.setSize(1000, 700);
            oWindow.set_visibleStatusbar(false);
        }

        function OnClientEntryAddingHandler(sender, eventArgs) {

            if (sender.get_entries().get_count() > 0) {
                eventArgs.set_cancel(true);
                alert("You can select only one entry");
            }

        }

    </script>
</asp:Content>
