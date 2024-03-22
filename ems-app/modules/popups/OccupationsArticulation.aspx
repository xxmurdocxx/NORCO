
<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="OccupationsArticulation.aspx.cs" Inherits="ems_app.modules.military.OccupationsArticulation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">ACE Occupations Articulation</p> 
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from OccupationService order by Description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSmartKeywords" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from SmartKeywords where KeywordType = 2 order by Keyword"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAllOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, dbo.OccupationHaveCollegeCourses(ao.AceID,ao.TeamRevd) as 'HaveRelatedCourses'  from MostCurrentAceOccupation ao where coalesce(ao.[OccupationServiceCode],'0') IN (select value from fn_split(@Service,',')) order by ao.Title, ao.TeamRevd, ao.Exhibit" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:Parameter DbType="String" Name="Service" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSearchOccupationAttribute" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct mco.*, dbo.OccupationHaveCollegeCourses(mco.AceID,mco.TeamRevd) as 'HaveRelatedCourses' from AceOccupationDetail aod join MostCurrentACEOccupation mco on aod.AceID = mco.AceID and aod.teamrevd = mco.teamrevd  where ((aod.HTMLDetail LIKE '%' + @attribute + '%') or (mco.exhibit LIKE '%' + @attribute + '%'))  order by mco.Title, mco.TeamRevd, mco.Exhibit">
        <SelectParameters>
            <asp:ControlParameter ControlID="racAdvanceSearch" Name="attribute" PropertyName="Text" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSearchRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct mco.*, dbo.OccupationHaveCollegeCourses(mco.AceID,mco.TeamRevd) as 'HaveRelatedCourses' from AceOccupationDetail aod join MostCurrentACEOccupation mco on aod.AceID = mco.AceID and aod.teamrevd = mco.teamrevd  where (aod.HTMLDetail like '<b>Recommendation%') and (aod.HTMLDetail LIKE '%' + @attribute + '%') order by mco.Title, mco.TeamRevd, mco.Exhibit">
        <SelectParameters>
            <asp:ControlParameter ControlID="racAdvanceSearch" Name="attribute" PropertyName="Text" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOccupationCollegeCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'course_title', cco.[AceID], cco.[TeamRevd]  from Articulation cco left outer join Course_IssuedForm cif on cco.outline_id = cif.outline_id left outer join tblSubjects s on cif.subject_id = s.subject_id where cco.[AceID] = @AceID  and cco.[TeamRevd] = @TeamRevd and cco.CollegeID = @CollegeID and cco.ArticulationType = 2">
        <SelectParameters>
            <asp:Parameter Name="AceID" Type="String" />
            <asp:Parameter Name="TeamRevd" Type="DateTime" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlConditions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM tblLookupConditions order by ConditionName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCollegeCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct pm.outline_id, ( select case when isnull(count(*),0) > 0 then cast(1 as bit) else cast(0 as bit) end as 'IsPublished' from ViewArticulations where outline_id = pm.outline_id and ArticulationStatus = 2)  as 'isPublished', subject, course_number, course_title from Course_IssuedForm pm left outer join tblSubjects s on pm.subject_id = s.subject_id where pm.status = 0 and pm.college_id = @CollegeID order by s.subject, pm.course_number">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct program_id, isnull(program,'') + ' - ' + cast(isnull(description,'') as varchar(20)) as 'program' from Program_IssuedForm where status = 0 and [college_id] = @CollegeID order by program">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRequired" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from View_ProgramMatrix   WHERE ([program_id] = @program_id and [required] = @required) ORDER BY iorder">
        <SelectParameters>
            <asp:Parameter Name="required" DefaultValue="1" Type="Int32" />
            <asp:ControlParameter ControlID="rcbPrograms" Name="program_id" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseMatches" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select cco.*, ao.Title, ao.Occupation, ao.OccupationServiceCode from Articulation cco left outer join AceOccupation ao on cco.AceID = ao.AceID and cco.TeamRevd = ao.TeamRevd  where cco.outline_id = @outline_id and cco.ArticulationType = 2">
        <SelectParameters>
            <asp:Parameter Name="outline_id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRecommended" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from View_ProgramMatrix   WHERE ([program_id] = @program_id and [required] = @required) ORDER BY iorder">
        <SelectParameters>
            <asp:Parameter Name="required" DefaultValue="2" Type="Int32" />
            <asp:ControlParameter ControlID="rcbPrograms" Name="program_id" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlPerformArticulationBy" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 'program' as id, 'Programs of Study' as 'Type' union select 'course' as id, 'Catalog Courses' as 'Type'"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct subject from View_ProgramMatrix where college_id = @CollegeID order by subject">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadWindowManager RenderMode="Lightweight" ID="rwmDetails" runat="server" EnableShadow="true">
            <Windows>
                <telerik:RadWindow RenderMode="Lightweight" ID="DetailDialog" runat="server" Title="Course Detail" Height="600px" Width="800px" Modal="false" VisibleStatusbar="false">
                </telerik:RadWindow>
            </Windows>
        </telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000"> 
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <div style="display:none !important;">
            <telerik:RadTextBox ID="selectedRowValue" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
            <telerik:RadTextBox ID="selectedCourseTitle" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
        </div>
        <div class="row">
            <div class="col-md-6 col-xs-12">
                <div class="row">
                    <div class="col-sm-3 col-xs-12">
                        <h3 style="margin-top:5px; font-weight:bold">Articulate by </h3>
                    </div>
                    <div class="col-sm-9 col-xs-12" >
                        <telerik:RadComboBox ID="rblPerformArticulationBy" runat="server" DataSourceID="SqlPerformArticulationBy" DataTextField="Type" DataValueField="Id" AutoPostBack="true" Width="200px" OnSelectedIndexChanged="rblPerformArticulationBy_SelectedIndexChanged" RenderMode="Lightweight">
                        </telerik:RadComboBox>
                    </div>
                </div>
                <asp:Panel ID="panelCollegeCourses" runat="server" ClientIDMode="Static">
                <telerik:RadGrid ID="rgCollegeCourses" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlCollegeCourses" AutoGenerateColumns="False" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel"   OnItemDataBound="ProgramCourses_ItemDataBound" HeaderStyle-Font-Bold="true"  RenderMode="Lightweight" AllowFilteringByColumn="true" EnableHeaderContextMenu="true">
                        <GroupingSettings CaseSensitive="false" />
                        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                            <ClientEvents OnRowDblClick="RowDblClickNORCO" OnRowSelected="selectedRowNorco"></ClientEvents>
                        </ClientSettings>
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <MasterTableView Name="ParentGrid" DataKeyNames="outline_id" DataSourceID="sqlCollegeCourses" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="true" EnableHierarchyExpandAll="true"  AlternatingItemStyle-BackColor="#ffffcc" HeaderStyle-Font-Bold="true" AllowMultiColumnSorting="true" AutoGenerateColumns="false">
                            <DetailTables>
                                <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlCourseMatches" Width="100%"
                                runat="server" DataKeyNames="outline_id">
                                    <ParentTableRelation>
                                        <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                    </ParentTableRelation>
                                    <Columns>
                                        <telerik:GridBoundColumn SortExpression="Occupation" DataField="Occupation" UniqueName="Occupation" HeaderStyle-Width="40px" HeaderText="Occupation Code" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" DataField="Title" UniqueName="Title" HeaderText="Occupation Description">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" DataField="AceID" UniqueName="AceID" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="TeamRevd" DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </telerik:GridTableView>
                            </DetailTables>
                            <Columns>
                                <telerik:GridTemplateColumn AllowFiltering="false">
                                    <ItemTemplate>
                                        <asp:Label runat="server"  Visible="false" ID="lblArticulate" ToolTip="Do not articulate" Text="<i class='fa fa-ban'></i>" />
                                        <asp:Label runat="server" ToolTip="Have Related Occupations" ID="btnShowMatches" Text='<i class="fa fa-check-square" aria-hidden="true"></i>' Visible="false" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridCheckBoxColumn DataField="IsPublished"  UniqueName="IsPublished" DataType="System.Boolean" HeaderText="Published Courses"  AllowFiltering="true" HeaderStyle-Width="55px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" FilterControlToolTip="Filter Only Published Courses" >
                                </telerik:GridCheckBoxColumn>
                                <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true"  ItemStyle-Font-Size="15px" HeaderStyle-Width="60px">
                                    <FilterTemplate>
                                        <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                            DataValueField="subject" MaxHeight="200px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                            runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged">
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
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Number" SortExpression="course_number" UniqueName="course_number"  ReadOnly="true" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title"  ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="150px"  AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
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
                <asp:Panel ID="panelCollegePrograms" runat="server" ClientIDMode="Static">
                <telerik:RadComboBox RenderMode="Lightweight" ID="rcbPrograms" AllowCustomText="true" runat="server" Width="100%" Height="400px"
                    DataSourceID="sqlPrograms" DataValueField="program_id" DataTextField="program" EmptyMessage="Search for programs..." Filter="Contains" AutoPostBack="true" OnSelectedIndexChanged="rcbPrograms_SelectedIndexChanged">
                </telerik:RadComboBox>
                <asp:Panel ID="pnlProgramCourses" runat="server" Visible="false">
                    <%-- COURSES FOR THE MAJOR --%>
                    <h3 style="margin-top:10px;">Required Courses</h3>
                    <telerik:RadGrid ID="rgRequired" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlRequired" AutoGenerateColumns="False" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel"   OnItemDataBound="ProgramCourses_ItemDataBound" HeaderStyle-Font-Bold="true"  RenderMode="Lightweight">
                        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                            <ClientEvents OnRowDblClick="RowDblClickNORCO" OnRowSelected="selectedRowNorco"></ClientEvents>
                        </ClientSettings>
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <MasterTableView Name="ParentGrid" DataKeyNames="outline_id" DataSourceID="sqlRequired" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="true" EnableHierarchyExpandAll="true"  AlternatingItemStyle-BackColor="#ffffcc" HeaderStyle-Font-Bold="true">
                            <DetailTables>
                                <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlCourseMatches" Width="100%"
                                runat="server" DataKeyNames="outline_id">
                                    <ParentTableRelation>
                                        <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                    </ParentTableRelation>
                                    <Columns>
                                        <telerik:GridBoundColumn SortExpression="Occupation" DataField="Occupation" UniqueName="Occupation" HeaderStyle-Width="40px" HeaderText="Occupation Code">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" DataField="Title" UniqueName="Title" HeaderText="Occupation Description">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" DataField="AceID" UniqueName="AceID" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="TeamRevd" DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </telerik:GridTableView>
                            </DetailTables>
                            <Columns>
                                <telerik:GridTemplateColumn>
                                    <ItemTemplate>
                                        <asp:Label runat="server"  Visible="false" ID="lblArticulate" ToolTip="Do not articulate" Text="<i class='fa fa-ban'></i>" />
                                        <asp:Label runat="server" ToolTip="Have Related Occupations" ID="btnShowMatches" Text='<i class="fa fa-check-square" aria-hidden="true"></i>' Visible="false" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="programcourse_id" DataType="System.Int32" FilterControlAltText="Filter programcourse_id column" HeaderText="programcourse_id" ReadOnly="True" SortExpression="programcourse_id" UniqueName="programcourse_id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="condition" DataType="System.Int32" FilterControlAltText="Filter condition column" HeaderText="And/Or" SortExpression="condition" UniqueName="condition" DataSourceID="sqlConditions" ListTextField="ConditionSymbol" ListValueField="id" ColumnEditorID="ceCondition" ItemStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn DataField="iorder" DataType="System.Int32" FilterControlAltText="Filter iorder column" HeaderText="iorder" SortExpression="iorder" UniqueName="iorder" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" ReadOnly="true" HeaderStyle-Font-Bold="true" >
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Number" SortExpression="course_number" UniqueName="course_number"  ReadOnly="true" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title"  ItemStyle-Wrap="true" ReadOnly="true" Display="false">
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
                                <telerik:GridBoundColumn DataField="prereq_total" FilterControlAltText="Filter prereq_total column" HeaderText="prereq_total" SortExpression="prereq_total" UniqueName="prereq_total"  ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridNumericColumn DataField="vunits" DataType="System.Double" FilterControlAltText="Filter vunits column" HeaderText="Units" SortExpression="vunits" UniqueName="vunits" MinValue="0" ColumnEditorID="ceUnits" ReadOnly="true">
                                </telerik:GridNumericColumn>
                            </Columns>
                            <NoRecordsTemplate>
                                <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                    &nbsp;No items to view
                                </div>
                            </NoRecordsTemplate>
                        </MasterTableView>
                    </telerik:RadGrid>
                    <h3>Restricted Elective</h3>
                    <telerik:RadGrid ID="rgRecommended" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlRecommended" AutoGenerateColumns="False" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel"  OnItemDataBound="ProgramCourses_ItemDataBound" RenderMode="Lightweight">
                        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                            <ClientEvents OnRowDblClick="RowDblClickNORCO"  OnRowSelected="selectedRowNorco"></ClientEvents>
                        </ClientSettings>
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <MasterTableView Name="ParentGrid" DataKeyNames="outline_id" DataSourceID="sqlRecommended" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="true" EnableHierarchyExpandAll="true"  AlternatingItemStyle-BackColor="#ffffcc" HeaderStyle-Font-Bold="true">
                            <DetailTables>
                                <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlCourseMatches" Width="100%"
                                runat="server">
                                    <ParentTableRelation>
                                        <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                    </ParentTableRelation>
                                    <Columns>
                                        <telerik:GridBoundColumn SortExpression="Occupation" DataField="Occupation" UniqueName="Occupation" HeaderStyle-Width="40px" HeaderText="Occupation Code">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" DataField="Title" UniqueName="Title" HeaderText="Occupation Description">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" DataField="AceID" UniqueName="AceID" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="TeamRevd" DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </telerik:GridTableView>
                            </DetailTables>
                            <Columns>
                                <telerik:GridTemplateColumn>
                                    <ItemTemplate>
                                        <asp:Label runat="server"  Visible="false" ID="lblArticulate" ToolTip="Do not articulate" Text="<i class='fa fa-ban'></i>" />
                                        <asp:Label runat="server" ToolTip="Have Related Occupations" ID="btnShowMatches" Text='<i class="fa fa-check-square" aria-hidden="true"></i>' Visible="false" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="programcourse_id" DataType="System.Int32" FilterControlAltText="Filter programcourse_id column" HeaderText="programcourse_id" ReadOnly="True" SortExpression="programcourse_id" UniqueName="programcourse_id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="condition" DataType="System.Int32" FilterControlAltText="Filter condition column" HeaderText="And/Or" SortExpression="condition" UniqueName="condition" DataSourceID="sqlConditions" ListTextField="ConditionSymbol" ListValueField="id" ColumnEditorID="ceCondition" HeaderStyle-Width="55px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn DataField="iorder" DataType="System.Int32" FilterControlAltText="Filter iorder column" HeaderText="iorder" SortExpression="iorder" UniqueName="iorder" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" ReadOnly="true" HeaderStyle-Width="50px" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Number" SortExpression="course_number" UniqueName="course_number"  ReadOnly="true" HeaderStyle-Width="62px" HeaderStyle-Font-Bold="true">
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
            </div>
            <div class="ACEContainer col-md-6 col-xs-12">
                <div class="ACEViews">
                    <div class="row">
                        <div class="col-md-5">
                            <h3 style="font-weight:bold;margin-top:5px;">ACE Occupation Codes</h3>
                        </div>
                        <div class="col-md-2" style="font-weight:bold;margin-top:5px;">
                            Service : <asp:Label ID="draggedRows" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <telerik:RadComboBox ID="rcbServices" runat="server" DataSourceID="sqlServices" DataTextField="description" DataValueField="Code" AutoPostBack="true" CheckBoxes="true" Width="200px" AppendDataBoundItems="true" EnableCheckAllItemsCheckBox="true" OnPreRender="rcbServices_PreRender" OnSelectedIndexChanged="rcbServices_SelectedIndexChanged" RenderMode="Lightweight">
                            </telerik:RadComboBox>
                        </div>
                    </div>
                    <div class="row" style="margin:10px 0 10px 0;">
                        <div class="col-sm-4">
                            <telerik:RadAutoCompleteBox  ID="racAdvanceSearch" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Single" MinFilterLength="3" MaxResultCount="20" OnTextChanged="rtbAttribute_TextChanged" AutoPostBack="true" DropDownHeight="200" DataSourceID="sqlSmartKeywords" DataTextField="keyword" EmptyMessage="Advanced search..." DataValueField="keyword" OnClientEntryAdding="OnClientEntryAddingHandler" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true">
                            </telerik:RadAutoCompleteBox>
                        </div>
                        <div class="col-sm-4">
                            <telerik:RadCheckBox ID="rchkSearchRecommendations" AutoPostBack="false" runat="server" Text="Search recommendations" Font-Bold="true"></telerik:RadCheckBox>
                        </div>
                        <div class="col-sm-4">
                            <telerik:RadButton RenderMode="Lightweight" ID="rbSearchAttribute" runat="server" Text="Search" OnClick="rbSearchAttribute_Click">
                                <Icon PrimaryIconCssClass="rbSearch"></Icon>
                            </telerik:RadButton>
                            <telerik:RadButton RenderMode="Lightweight" ID="rbClearAttribute" runat="server" Text="Clear" OnClick="rbClearAttribute_Click">
                                <Icon PrimaryIconCssClass="rbCancel"></Icon>
                            </telerik:RadButton>
                        </div>
                    </div>
                    <asp:Panel id="panelSmartKeys" runat="server" Visible="false">
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
                        <div class="col-sm-12 col-md-12">
                            <telerik:RadGrid ID="rgACEOccupations" runat="server" AllowFilteringByColumn="True" AllowPaging="true" PageSize="8" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlAllOccupations" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" OnRowDrop="ACECourses_RowDrop"  OnItemDataBound="rgACEOccupations_ItemDataBound" OnPreRender="rgACEOccupations_PreRender" AllowMultiRowSelection="true">
                                <GroupingSettings CaseSensitive="false" />
                                <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                    <ClientEvents OnRowDblClick="RowDblClickOccupation" OnRowDragStarted="OnRowDragStarted" OnRowDropped="OnRowDropped" ></ClientEvents>
                                    <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                </ClientSettings>
                                <MasterTableView DataKeyNames="AceID,TeamRevd" DataSourceID="sqlAllOccupations" CommandItemDisplay="None" AllowMultiColumnSorting="true" Name="ParentGrid" HierarchyLoadMode="ServerBind" HeaderStyle-Font-Bold="true">
                                <DetailTables>
                                    <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlOccupationCollegeCourses" Width="100%" runat="server" DataKeyNames="AceID,TeamRevd" AllowFilteringByColumn="false" ShowHeader="false">
                                        <ParentTableRelation>
                                            <telerik:GridRelationFields DetailKeyField="AceID" MasterKeyField="AceID"></telerik:GridRelationFields>
                                            <telerik:GridRelationFields DetailKeyField="TeamRevd" MasterKeyField="TeamRevd"></telerik:GridRelationFields>
                                        </ParentTableRelation>
                                        <Columns>
                                            <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                    </telerik:GridTableView>
                                </DetailTables>
                                    <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ToolTip="This occupation has related course(s)." ID="btnOccupationHaveCourses" Text='<i class="fa fa-book" aria-hidden="true"></i>' CausesValidation="false" />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="HaveRelatedCourses" DataType="System.Boolean" UniqueName="HaveRelatedCourses" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Occupation" FilterControlAltText="Filter Occupation column" HeaderText="Occ. Code" SortExpression="Occupation" UniqueName="Occupation" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="40px" HeaderStyle-Width="30px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Title" FilterControlAltText="Filter Title column" HeaderText="Occupation" SortExpression="Title" UniqueName="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" >
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="Ace ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Exhibit" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="40px" FilterControlWidth="50px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn DataField="StartDate" FilterControlAltText="Filter StartDate column" HeaderText="Start Date" SortExpression="StartDate" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="100px" FilterControlToolTip="Search by Start date" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" Display="false">
                                            <HeaderStyle Width="100px" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridDateTimeColumn DataField="EndDate" FilterControlAltText="Filter EndDate column" HeaderText="End Date" SortExpression="EndDate" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="100px" FilterControlToolTip="Search by End date" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" Display="false">
                                            <HeaderStyle Width="100px" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridDateTimeColumn DataField="TeamRevd" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="90px" FilterControlToolTip="Search by TeamRevd" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" Display="True">
                                            <HeaderStyle Width="100px" />
                                        </telerik:GridDateTimeColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </div>
                    </div>                
                
                </div> 
            </div>
        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">

        function OnRowDragStarted(sender, args) {
            if (args.get_tableView().get_name() == "ChildGrid") {
                args.set_cancel(true);
            }
        }
        function OnRowDropped(sender, args) {
            if (args._targetItemTableView.get_name() == "ChildGrid") {
                args.set_cancel(true);
            }
        }
    </script>
    <script type="text/javascript">  
        function OnClientEntryAddingHandler(sender, eventArgs) {

            if (sender.get_entries().get_count() > 0) {
                eventArgs.set_cancel(true);
                alert("You can select only one entry");
            }

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
    function closeRadWindow()  
    {  
        $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();   
    }
    </script> 
</asp:Content>
