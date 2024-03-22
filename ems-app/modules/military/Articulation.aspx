<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Articulation.aspx.cs" Inherits="ems_app.modules.military.Articulation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Articulation Update</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ao.Occupation, ao.Occupation + ' - ' + ao.Title as Title from AceOccupation ao inner join ( SELECT Occupation, max(AceID) as AceID FROM AceOccupation aoc group by Occupation ) a02 on ao.AceID = a02.AceID order by ao.Occupation">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlNotes" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from Articulation where [id] = @id">
        <SelectParameters>
            <asp:Parameter Name="id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlConditions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM tblLookupConditions order by ConditionName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct program_id, isnull(program,'') + ' - ' + cast(isnull(description,'') as varchar(20)) as 'program' from Program_IssuedForm where status = 0 and [college_id] = @CollegeID order by program">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlACECourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select acc.*, dbo.HaveArticulatedCourses(acc.AceID, acc.TeamRevd, @CollegeID) as 'HaveArticulatedCourses' from AceCourseCatalog acc order by acc.Title, acc.Teamrevd desc">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlACECoursesSearch" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct cc.AceID, cc.Title, cc.teamrevd, cc.exhibit, dbo.HaveArticulatedCourses(cc.AceID, cc.TeamRevd, @CollegeID) as 'HaveArticulatedCourses' from AceCatalogDetail cd inner join AceCourseCatalog cc on cd.AceID = cc.AceID and cd.teamrevd = cc.teamrevd where  (cd.[CourseDetail] LIKE '%' + @rtbAttribute + '%') order by cc.Title,cc.teamrevd desc">
        <SelectParameters>
            <asp:ControlParameter ControlID="rtbAttribute" Name="rtbAttribute" PropertyName="Text" Type="String" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSearchOccupation" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select DISTINCT acc.AceID, acc.Title, acc.Exhibit, acc.TeamRevd from CourseOccupations co inner join AceCourseCatalog acc on co.AceID = acc.AceID and co.TeamRevd = acc.TeamRevd inner join ( select ao.Occupation, ao.Title from AceOccupation ao inner join ( SELECT Occupation, max(AceID) as AceID FROM AceOccupation aoc group by Occupation ) a02 on ao.AceID = a02.AceID ) ocu on co.OccupationID = ocu.Occupation where co.OccupationID LIKE '%' + @occupation + '%' order by acc.Title,acc.TeamRevd desc">
        <SelectParameters>
            <asp:ControlParameter ControlID="rcbOccupations" Name="occupation" PropertyName="SelectedValue" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSearchOccupationAttribute" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct co.OccupationID, cc.AceID, cc.Title, cc.teamrevd, cc.exhibit from AceCatalogDetail cd inner join AceCourseCatalog cc on cd.AceID = cc.AceID and cd.teamrevd = cc.teamrevd left outer join CourseOccupations co on cc.AceID = co.AceID and cc.TeamRevd = co.TeamRevd inner join AceCourseCatalog acc on co.AceID = acc.AceID and co.TeamRevd = acc.TeamRevd inner join ( select ao.Occupation, ao.Title from AceOccupation ao inner join ( SELECT Occupation, max(AceID) as AceID FROM AceOccupation aoc group by Occupation ) a02 on ao.AceID = a02.AceID ) ocu on co.OccupationID = ocu.Occupation where  (cd.[CourseDetail] LIKE '%' + @attribute + '%') and co.OccupationID like '%' + @occupation + '%' order by cc.Title">
        <SelectParameters>
            <asp:ControlParameter ControlID="rtbAttribute" Name="attribute" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="rcbOccupations" Name="occupation" PropertyName="SelectedValue" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRequired" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from View_ProgramMatrix   WHERE ([program_id] = @program_id and [required] = @required) ORDER BY iorder">
        <SelectParameters>
            <asp:Parameter Name="required" DefaultValue="1" Type="Int32" />
            <asp:ControlParameter ControlID="rcbPrograms" Name="program_id" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAceArticulationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject + ' ' + cif.course_number + ' - ' + cif.course_title as 'course_title', cco.[AceID], cco.[TeamRevd], cif.[outline_id]  from Articulation cco join Course_IssuedForm cif on cco.outline_id = cif.outline_id left outer join tblSubjects s on cif.subject_id = s.subject_id where cco.[AceID] = @AceID  and cco.[TeamRevd] = @TeamRevd and cif.[college_id] = @CollegeID and cco.ArticulationType = 1">
        <SelectParameters>
            <asp:Parameter Name="AceID" Type="String" />
            <asp:Parameter Name="TeamRevd" Type="DateTime" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseMatches" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="sselect pc.programcourse_id, cc.Exhibit,  ac.outline_id, ac.AceID, ac.TeamRevd, ac.Title, ac.id, dbo.ACECourseHaveOccupations(ac.AceID,ac.TeamRevd) as 'HaveOccupations'  from Articulation ac join tblProgramCourses pc on ac.outline_id = pc.outline_id left outer join AceCourseCatalog cc on ac.AceID = cc.AceID and ac.TeamRevd = cc.TeamRevd where pc.[programcourse_id] = @programcourse_id and ac.ArticulationType = 1 order by ac.id">
        <SelectParameters>
            <asp:Parameter Name="programcourse_id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCollegeCourseMatches" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select cc.Exhibit, ac.outline_id, ac.AceID, ac.TeamRevd, ac.Title, ac.id, dbo.ACECourseHaveOccupations(ac.AceID,ac.TeamRevd) as 'HaveOccupations'  from Articulation ac join Course_Issuedform pc on ac.outline_id = pc.outline_id left outer join AceCourseCatalog cc on ac.AceID = cc.AceID and ac.TeamRevd = cc.TeamRevd where pc.[outline_id] = @outline_id and ac.ArticulationType = 1 order by ac.id">
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
    <asp:SqlDataSource ID="sqlCourseSimilarities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select acc.* , dbo.HaveArticulatedCourses(acc.AceID, acc.TeamRevd, @CollegeID) as 'HaveArticulatedCourses' from AceCourseCatalog acc where acc.[ID] IN (select value from fn_split(@AceCourseIDList,','))  order by acc.title" >
        <SelectParameters>
            <asp:Parameter DbType="String" Name="AceCourseIDList"  />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseSimilaritiesByDetail" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct cc.AceID,cc.Exhibit,cc.TeamRevd,cc.Title, dbo.HaveArticulatedCourses(cc.AceID, cc.TeamRevd, @CollegeID) as 'HaveArticulatedCourses' from AceCatalogDetail cd join AceCourseCatalog cc on cd.aceid = cc.aceid and cd.teamrevd = cc.teamrevd  where cd.[ID] IN (select value from fn_split(@AceCourseIDList,','))  order by cc.title" >
        <SelectParameters>
            <asp:Parameter DbType="String" Name="AceCourseIDList"  />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlPerformArticulationBy" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 'program' as id, 'Programs of Study ' as 'Type' union select 'course' as id, 'Catalog Courses ' as 'Type'"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCollegeCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="
select distinct pm.outline_id, ( select case when isnull(count(*),0) > 0 then cast(1 as bit) else cast(0 as bit) end as 'IsPublished' from ViewArticulations where outline_id = pm.outline_id and ArticulationStatus = 2)  as 'isPublished', subject, course_number, course_title from Course_IssuedForm pm left outer join tblSubjects s on pm.subject_id = s.subject_id where pm.status = 0 and pm.college_id = @CollegeID order by s.subject, pm.course_number">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct subject from View_ProgramMatrix where college_id = @CollegeID order by subject">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSearchRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct acc.*, dbo.HaveArticulatedCourses(acc.AceID, acc.TeamRevd, 1) as 'HaveArticulatedCourses' from AceCourseCatalog acc join AceCatalogDetail acd on acc.AceID = acd.AceID and acc.TeamRevd = acd.TeamRevd where acd.CourseDetail like '%<b>Credit Recommendation: </b>%' and  (acd.CourseDetail LIKE '%' + @attribute + '%') order by acc.Title, acc.Teamrevd desc">
        <SelectParameters>
            <asp:ControlParameter ControlID="rtbAttribute" Name="attribute" PropertyName="Text" Type="String" />
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
                    <div class="col-sm-3 col-xs-12" style="margin-top:0px">
                        <h3 style="margin-top:5px; font-weight:bold">Articulate by </h3>
                    </div>
                    <div class="col-sm-9 col-xs-12">
                        <telerik:RadComboBox ID="rblPerformArticulationBy" runat="server" DataSourceID="SqlPerformArticulationBy" DataTextField="Type" DataValueField="Id" AutoPostBack="true" Width="200px" OnSelectedIndexChanged="rblPerformArticulationBy_SelectedIndexChanged" RenderMode="Lightweight">
                        </telerik:RadComboBox>
                    </div>
                </div>
                <asp:Panel ID="panelCollegeCourses" runat="server" ClientIDMode="Static">
                <telerik:RadGrid ID="rgCollegeCourses" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlCollegeCourses" AutoGenerateColumns="False" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" OnItemDataBound="ProgramCourses_ItemDataBound" HeaderStyle-Font-Bold="true"  RenderMode="Lightweight" AllowFilteringByColumn="true" EnableHeaderContextMenu="true">
                        <GroupingSettings CaseSensitive="false" />
                        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                            <ClientEvents OnRowDblClick="RowDblClickNORCO" OnRowSelected="selectedRowNorco"></ClientEvents>
                        </ClientSettings>
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <MasterTableView Name="ParentGrid" DataKeyNames="outline_id" DataSourceID="sqlCollegeCourses" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="true" EnableHierarchyExpandAll="true"  HeaderStyle-Font-Bold="true" AllowMultiColumnSorting="true" AutoGenerateColumns="false">
                            <DetailTables>
                                <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlCollegeCourseMatches" Width="100%"
                                runat="server" DataKeyNames="outline_id" AllowFilteringByColumn="false">
                                    <ParentTableRelation>
                                        <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                    </ParentTableRelation>
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Display="false">
                                            <ItemTemplate>
                                                <asp:LinkBUtton runat="server" CommandName="EditOccupations" ToolTip="This course has related occupation codes. Click here to view/update occupation codes." ID="btnHaveOccupations" Text='<i class="fa fa-wrench" ForeColor="White" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="HaveOccupations" DataType="System.Boolean" UniqueName="HaveOccupations" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="ConditionSymbol" HeaderText="&/Or" DataField="ConditionSymbol" UniqueName="ConditionSymbol" HeaderStyle-Font-Bold="true" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderStyle-Width="100px" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Exhibit" HeaderStyle-Width="110px" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="ACE Course Title" DataField="Title" UniqueName="Title" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
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
                    <h3 style="margin-top:6px; margin-bottom:2px;">Required Courses</h3>
                    <telerik:RadGrid ID="rgRequired" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlRequired" AutoGenerateColumns="False" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" OnItemCommand="ProgramCourses_ItemCommand" OnItemDataBound="ProgramCourses_ItemDataBound" HeaderStyle-Font-Bold="true"  RenderMode="Lightweight">
                        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                            <ClientEvents OnRowDblClick="RowDblClickNORCO" OnRowSelected="selectedRowNorco"></ClientEvents>
                        </ClientSettings>
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <MasterTableView Name="ParentGrid" DataKeyNames="programcourse_id" DataSourceID="sqlRequired" EnableNoRecordsTemplate="true" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="true" EnableHierarchyExpandAll="true"  AlternatingItemStyle-BackColor="#ffffcc" HeaderStyle-Font-Bold="true" AllowMultiColumnSorting="true">
                            <DetailTables>
                                <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlCourseMatches" Width="100%"
                                runat="server" DataKeyNames="id">
                                    <ParentTableRelation>
                                        <telerik:GridRelationFields DetailKeyField="programcourse_id" MasterKeyField="programcourse_id"></telerik:GridRelationFields>
                                    </ParentTableRelation>
                                    <DetailTables>
                                        <telerik:GridTableView Width="100%" DataSourceID="sqlNotes" EnableHierarchyExpandAll="true" runat="server" CommandItemSettings-ShowAddNewRecordButton="false" Name="SubChildGrid" DataKeyNames="id" CommandItemDisplay="None" AllowFilteringByColumn="false" GroupsDefaultExpanded="true" HierarchyDefaultExpanded="true" >
                                            <ParentTableRelation>
                                                <telerik:GridRelationFields DetailKeyField="id" MasterKeyField="id"></telerik:GridRelationFields>
                                            </ParentTableRelation>
                                            <Columns>
                                                <telerik:GridHTMLEditorColumn DataField="Notes" UniqueName="Notes" HeaderText="Notes"></telerik:GridHTMLEditorColumn>
                                            </Columns>
                                        </telerik:GridTableView>
                                    </DetailTables>
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                            <ItemTemplate>
                                                <asp:LinkBUtton runat="server" CommandName="EditOccupations" ToolTip="This course has related occupation codes. Click here to view/update occupation codes." ID="btnHaveOccupations" Text='<i class="fa fa-wrench" ForeColor="White" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Edit Notes" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="HaveOccupations" DataType="System.Boolean" UniqueName="HaveOccupations" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="ConditionSymbol" HeaderText="&/Or" DataField="ConditionSymbol" UniqueName="ConditionSymbol" HeaderStyle-Font-Bold="true" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderStyle-Width="100px" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Exhibit" HeaderStyle-Width="110px" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="ACE Course Title" DataField="Title" UniqueName="Title" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </telerik:GridTableView>
                            </DetailTables>
                            <CommandItemTemplate>
                                <div class="commandItems">
                                    <asp:LinkButton runat="server" CommandName="SimilarCourses" ID="btnSimilarCourses" Text="<i class='fa fa-exchange'></i> Show similar courses" />&nbsp;|&nbsp;
                                    <asp:LinkButton runat="server" CommandName="NoArticulate" ID="btnNoArticulate" Text="<i class='fa fa-ban'></i> Do not articulate" />&nbsp;|&nbsp;
                                    <asp:Label runat="server"  ID="lblArticulated" Text='<i class="fa fa-check-square" aria-hidden="true"></i> Articulated courses' />
                                </div>
                            </CommandItemTemplate>
                            <Columns>
                                <telerik:GridTemplateColumn>
                                    <ItemTemplate>
                                        <asp:Label runat="server"  Visible="false" ID="lblArticulate" ToolTip="Do not articulate" Text="<i class='fa fa-ban'></i>" />
                                        <asp:Label runat="server" ToolTip="Have ACE Matches" ID="btnShowMatches" Text='<i class="fa fa-check-square" aria-hidden="true"></i>' Visible="false" />
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
                    <br />
                    <h3 style="margin-top:6px; margin-bottom:2px;">Restricted Elective</h3>
                    <telerik:RadGrid ID="rgRecommended" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlRecommended" AutoGenerateColumns="False" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" OnItemCommand="ProgramCourses_ItemCommand" OnItemDataBound="ProgramCourses_ItemDataBound" RenderMode="Lightweight">
                        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                            <ClientEvents OnRowDblClick="RowDblClickNORCO"  OnRowSelected="selectedRowNorco"></ClientEvents>
                        </ClientSettings>
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <MasterTableView Name="ParentGrid" DataKeyNames="programcourse_id" DataSourceID="sqlRecommended" EnableNoRecordsTemplate="true" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="true" EnableHierarchyExpandAll="true"  AlternatingItemStyle-BackColor="#ffffcc" AllowMultiColumnSorting="true">
                            <DetailTables>
                                <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlCourseMatches" Width="100%"
                                runat="server" DataKeyNames="id">
                                    <ParentTableRelation>
                                        <telerik:GridRelationFields DetailKeyField="programcourse_id" MasterKeyField="programcourse_id"></telerik:GridRelationFields>
                                    </ParentTableRelation>
                                    <DetailTables>
                                        <telerik:GridTableView Width="100%" DataSourceID="sqlNotes" EnableHierarchyExpandAll="true" runat="server" CommandItemSettings-ShowAddNewRecordButton="false" Name="SubChildGrid" DataKeyNames="id" CommandItemDisplay="None" AllowFilteringByColumn="false" GroupsDefaultExpanded="true" HierarchyDefaultExpanded="true" >
                                            <ParentTableRelation>
                                                <telerik:GridRelationFields DetailKeyField="id" MasterKeyField="id"></telerik:GridRelationFields>
                                            </ParentTableRelation>
                                            <Columns>
                                                <telerik:GridHTMLEditorColumn DataField="Notes" UniqueName="Notes" HeaderText="Notes"></telerik:GridHTMLEditorColumn>
                                            </Columns>
                                        </telerik:GridTableView>
                                    </DetailTables>
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                            <ItemTemplate>
                                                <asp:LinkBUtton runat="server" CommandName="EditOccupations" ToolTip="This course has related occupation codes. Click here to view/update occupation codes." ID="btnHaveOccupations" Text='<i class="fa fa-wrench" ForeColor="White" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Edit Notes" CommandName="EditNotes" ID="btnEditNotes" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="HaveOccupations" DataType="System.Boolean" UniqueName="HaveOccupations" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="ConditionSymbol" HeaderText="And/Or" DataField="ConditionSymbol" UniqueName="ConditionSymbol" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderStyle-Width="100px" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Exhibit" HeaderStyle-Width="120px" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="ACE Course Title" DataField="Title" UniqueName="Title" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </telerik:GridTableView>
                            </DetailTables>
                            <CommandItemTemplate>
                                <div class="commandItems">
                                    <asp:LinkButton runat="server" CommandName="SimilarCourses" ID="btnSimilarCourses" Text="<i class='fa fa-exchange'></i> Show similar courses" />&nbsp;|&nbsp;
                                    <asp:LinkButton runat="server" CommandName="NoArticulate" ID="btnNoArticulate" Text="<i class='fa fa-ban'></i> Do not articulate" />&nbsp;|&nbsp;
                                    <asp:Label runat="server"  ID="lblArticulated" Text='<i class="fa fa-check-square" aria-hidden="true"></i> Articulated courses' />
                                </div>
                            </CommandItemTemplate>
                            <Columns>
                                <telerik:GridTemplateColumn>
                                    <ItemTemplate>
                                        <asp:Label runat="server" ToolTip="Do not articulate" Visible="false" ID="lblArticulate" Text="<i class='fa fa-ban'></i>" />
                                        <asp:Label runat="server" ToolTip="Have ACE Matches" ID="btnShowMatches" Text='<i class="fa fa-check-square" aria-hidden="true"></i>' Visible="false" />
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
                <div class="ACEViews" style="margin-top:0px;">
                <div class="row" style="margin-top:0px;">
                    <telerik:RadCheckBox ID="rcheckSimilarPrograms" runat="server" Text="Show Similar Courses" AutoPostBack="true" OnCheckedChanged="rcheckSimilarPrograms_CheckedChanged" Font-Bold="True" ToolTip="If it is unchecked, the Entire ACE Course Catalog is Shown"></telerik:RadCheckBox>
                </div>
                <asp:Panel ID="pnlSimilar" runat="server" Visible="false">
                    <div class="row" style="margin:10px 0 40px 0;">
                        <div class="col-sm-7">
                            <p>Matching Attribute</p>
                            <telerik:RadComboBox id="rcbAttribute" runat="server" Width="100%" OnSelectedIndexChanged="rcbAttribute_SelectedIndexChanged" AutoPostBack="true"> 
                                <Items>   
                                    <telerik:RadComboBoxItem runat="server" Selected="true" Value="1" Text="Course Title" />   
                                    <telerik:RadComboBoxItem runat="server" Value="2" Text="Course Detail" /> 
                                </Items>
                            </telerik:RadComboBox>
                        </div>
                        <div class="col-sm-5">
                            <p>Matching Factor : </p>
                             <telerik:RadComboBox id="rcbMatchingFactor" runat="server" Width="90%" AutoPostBack="true" OnSelectedIndexChanged="rcbMatchingFactor_SelectedIndexChanged"> 
                                <Items>   
                                    <telerik:RadComboBoxItem runat="server" Value="1" Text="Weak" />   
                                    <telerik:RadComboBoxItem runat="server" Value="2" Text="Average" />   
                                    <telerik:RadComboBoxItem runat="server" Value="3" Text="Strong" /> 
                                </Items>
                            </telerik:RadComboBox>
                            <asp:LinkButton ID="lbHelp" runat="server" CausesValidation="false" ><i class="fa fa-question-circle"></i></asp:LinkButton>
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
                                        <telerik:RadGrid ID="rgSimilarities" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlCourseSimilarities" Width="100%" GroupingSettings-CaseSensitive="false" OnRowDrop="ACECourses_RowDrop" RenderMode="Lightweight" EnableHeaderContextMenu="true" OnItemDataBound="rgSimilarities_ItemDataBound" OnPreRender="rgSimilarities_PreRender">
                                            <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                            <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                                <ClientEvents OnRowDblClick="RowDblClickACE" OnRowDragStarted="OnRowDragStarted" OnRowDropped="OnRowDropped"></ClientEvents>
                                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                            </ClientSettings>
                                            <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlCourseSimilarities" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="None" AllowMultiColumnSorting="true" Name="ParentGrid" HierarchyLoadMode="ServerBind" DataKeyNames="AceID,TeamRevd">
                                            <DetailTables>
                                                <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlAceArticulationCourses" Width="100%" runat="server" DataKeyNames="AceID,TeamRevd" AllowFilteringByColumn="false" ShowHeader="false" AutoGenerateColumns="false">
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
                                                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" FilterControlAltText="Filter Title column" HeaderText="ACE Title" SortExpression="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"  ShowFilterIcon="true" FilterControlWidth="150px" HeaderStyle-Font-Bold="true">
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
                    <div class="row" style="margin:0px 0 0px 0;">
                        <div class="col-sm-7">
                            <label><strong>Advanced Search :</strong> </label>
                            <telerik:RadTextBox ID="rtbAttribute" Width="150px" runat="server" OnTextChanged="rtbAttribute_TextChanged" AutoPostBack="true" ClientIDMode="Static"></telerik:RadTextBox>
                        </div>
                        <div class="col-sm-5">
                            <telerik:RadButton RenderMode="Lightweight" ID="rbSearchAttribute" runat="server" Text="Search" OnClick="rbSearchAttribute_Click">
                                <Icon PrimaryIconCssClass="rbSearch"></Icon>
                            </telerik:RadButton>
                            <telerik:RadButton RenderMode="Lightweight" ID="rbClearAttribute" runat="server" Text="Clear" OnClick="rbClearAttribute_Click">
                                <Icon PrimaryIconCssClass="rbCancel"></Icon>
                            </telerik:RadButton>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12" >
                            <telerik:RadCheckBox ID="rchkSearchRecommendations" AutoPostBack="false" runat="server" Text="Search recommendations"></telerik:RadCheckBox>
                        </div>
                    </div>
                    <div class="row" style="margin:2px 0 30px 0;">
                        <div class="col-sm-12" style="margin-bottom:0px;">
                            <label><strong>Occupation : </strong> </label><telerik:RadComboBox RenderMode="Lightweight" ID="rcbOccupations" runat="server" Width="400px" Height="400px" AllowCustomText="true" Filter="Contains" DataSourceID="sqlOccupations" DataValueField="occupation" DataTextField="title" EmptyMessage="Select an occupation" AutoPostBack="true" OnSelectedIndexChanged="rcbOccupations_SelectedIndexChanged">
                            </telerik:RadComboBox>
                        </div>
                    </div>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="RadPanelBar2" Width="100%" ExpandMode="MultipleExpandedItems">
                        <Items>
                            <telerik:RadPanelItem Expanded="True" Text="ACE - Course Catalog" Font-Bold="true">
                                <ContentTemplate>
                                    <div class="padding-panels" style="margin-top:0px;margin-bottom:0px;">
                                        <telerik:RadGrid ID="rgACECourses" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlACECourses" Width="100%" GroupingSettings-CaseSensitive="false" OnRowDrop="ACECourses_RowDrop" RenderMode="Lightweight" EnableHeaderContextMenu="true" OnItemDataBound="rgACECourses_ItemDataBound" OnPreRender="rgACECourses_PreRender">
                                            <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                            <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                                <ClientEvents OnRowDblClick="RowDblClickACE" OnRowDragStarted="OnRowDragStarted" OnRowDropped="OnRowDropped"></ClientEvents>
                                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                            </ClientSettings>
                                            <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlACECourses" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="None" AllowMultiColumnSorting="true" Name="ParentGrid" HierarchyLoadMode="ServerBind" DataKeyNames="AceID,TeamRevd">
                                            <DetailTables>
                                                <telerik:GridTableView Name="ChildGrid" EnableHierarchyExpandAll="false" DataSourceID="sqlAceArticulationCourses" Width="100%" runat="server" DataKeyNames="AceID,TeamRevd" AllowFilteringByColumn="false" ShowHeader="false" AutoGenerateColumns="false" >
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
                                                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" FilterControlAltText="Filter Title column" HeaderText="ACE Title" SortExpression="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"  ShowFilterIcon="true" FilterControlWidth="150px" HeaderStyle-Font-Bold="true">
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
    $(window).scroll(function () {
        t = $('.ACEContainer').offset();
        t = t.top;

        s = $(window).scrollTop();

        d = t - s;

        if (d < 0) {
            $('.ACEViews').addClass('fixed');
            $('.ACEContainer').addClass('paddingTop');
        } else {
            $('.ACEViews').removeClass('fixed');
            $('.ACEContainer').removeClass('paddingTop');
        }
    });
    </script> 
</asp:Content>
