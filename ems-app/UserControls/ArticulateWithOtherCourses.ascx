<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticulateWithOtherCourses.ascx.cs" Inherits="ems_app.UserControls.ArticulateWithOtherCourses" %>
<%@ Register Src="~/UserControls/DisplayMessages.ascx" TagPrefix="uc" TagName="DisplayMessages" %>
<uc:DisplayMessages id="DisplayMessagesControl" runat="server"></uc:DisplayMessages>
<asp:HiddenField ID="hfID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfArticulationType" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfTitle" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfCollegeID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfUserStageID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfUserID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfAceID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfTeamRevd" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfEvaluatorNotes" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfFacultyNotes" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfArticulationOfficerNotes" runat="server" ClientIDMode="Static" />
<telerik:RadWindowManager ID="RadWindowManager1" RenderMode="Lightweight" ShowContentDuringLoad="true" runat="server"  EnableViewState="false"></telerik:RadWindowManager>
<div class="row">
    <div class="col-sm-6">
        <%-- COURSE CATALOG --%>
        <h2>Course Catalog</h2>
        <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT DISTINCT s.subject FROM  Course_IssuedForm cif INNER JOIN tblSubjects s ON cif.subject_id = s.subject_id WHERE (cif.status = 0) AND (cif.college_id = @CollegeID) and s.college_id=@CollegeID ORDER BY s.subject">
            <SelectParameters>
                <asp:Parameter Name="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="ldsView_CoursesSearchResults" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from (SELECT   0 sorder, a.outline_id, a.subject_id, a.division_id, a.department_id, a.course_number, a.course_title, a.IssuedFormID, a.college_id, b.subject, [dbo].[CheckArticulationExistOtherColleges] ( @CollegeID, b.subject, a.course_number, @AceID, @TeamRevd) 'ExistInOtherColleges' FROM Course_IssuedForm AS a INNER JOIN tblSubjects AS b ON a.subject_id = b.subject_id where a.college_id = @CollegeID AND a.status= 0 AND ( a.outline_id <> @outline_id or A.outline_id NOT IN (select outline_id from Articulation where AceID = @AceID and TeamRevd = @TeamRevd AND CollegeID = @CollegeID AND  ArticulationStatus <> 3)  )) as available_courses  order by subject, course_number">
            <SelectParameters>
                <asp:Parameter Name="CollegeID" Type="Int32" />
                <asp:Parameter DefaultValue="0" Name="outline_id" />
                <asp:Parameter DefaultValue="0" Name="AceID" />
                <asp:Parameter DefaultValue="0" Name="TeamRevd" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadGrid ID="rgCourseCatalog" runat="server" AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="True" DataSourceID="ldsView_CoursesSearchResults" AllowPaging="True" PageSize="7" RenderMode="Lightweight" OnItemCommand="rgCourseCatalog_ItemCommand" AllowMultiRowSelection="true" OnItemDataBound="rgCourseCatalog_ItemDataBound">
            <GroupingSettings CaseSensitive="false" />
            <ClientSettings AllowRowsDragDrop="False" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                <ClientEvents OnRowDblClick="RowDblClickNORCO" OnRowSelected="selectedRowNorco"></ClientEvents>
            </ClientSettings>
            <MasterTableView DataKeyNames="outline_id" CommandItemDisplay="Top" DataSourceID="ldsView_CoursesSearchResults" PagerStyle-Mode="NextPrev" PagerStyle-ShowPagerText="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true">
                <CommandItemSettings ShowAddNewRecordButton="False" />
                <CommandItemTemplate>
                    <div class="commandItems">
                        <telerik:RadButton runat="server" ID="btnArticulate" ToolTip="Check to add selected courses." CommandName="Articulate" Text=" Articulate selected courses" ButtonType="LinkButton">
                            <Icon PrimaryIconCssClass="rbOk"></Icon>
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>
                <Columns>
                    <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                    </telerik:GridClientSelectColumn>
                    <telerik:GridTemplateColumn HeaderStyle-Width="20px" AllowFiltering="false">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CommandName="OtherCollegesArticulations" ToolTip="This course has been articulated in another college." ID="btnOtherCollegeArticulations"  Text='<i class="fa fa-university" aria-hidden="true"></i>' />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="ExistInOtherColleges" UniqueName="ExistInOtherColleges" Display="false"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="subject_id" DataType="System.Int32" FilterControlAltText="Filter subject_id column" HeaderText="subject_id" SortExpression="subject_id" UniqueName="subject_id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn UniqueName="subject" DataField="subject" HeaderText="Subject"
                        HeaderStyle-Width="60px" HeaderTooltip="Drag and Drop the selected course into either Required Courses and/or Restricted Electives data grid.">
                        <FilterTemplate>
                            <telerik:RadComboBox ID="RadComboBoxSubject" DataSourceID="sqlSubjects" DataTextField="subject"
                                DataValueField="Subject" Height="200px" Width="60px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged" RenderMode="Lightweight" DropDownAutoWidth="Enabled">
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
                    <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Course Number" SortExpression="course_number" UniqueName="course_number" FilterControlWidth="60px" FilterControlToolTip="Search by course number" DataType="System.String" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                        <HeaderStyle Width="60px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title" FilterControlWidth="100px" FilterControlToolTip="Search by course title" DataType="System.String" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <%-- COURSE CATALOG --%>
    </div>
    <div class="col-sm-6">
        <asp:SqlDataSource ID="sqlOtherCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select a.*, cif.course_number, cif.course_title, s.[subject], r.RoleName, su.[Description] as Status, [dbo].[CheckArticulationExistOtherColleges] ( @CollegeID, s.subject, cif.course_number, @AceID, @TeamRevd) 'ExistInOtherColleges' from ( select outline_id, ID, ArticulationID, ArticulationType, ArticulationStage, ArticulationStatus, Notes, Articulate from Articulation where AceID = @AceID and TeamRevd = @TeamRevd AND CollegeID = @CollegeID AND  ArticulationStatus <> 3 ) a left outer join Course_IssuedForm cif on a.outline_id = cif.outline_id left outer join tblSubjects s on cif.subject_id = s.subject_id left outer join Stages st on a.ArticulationStage = st.Id left outer join ROLES r on st.RoleId = r.RoleID left outer join LookupStatus su on a.ArticulationStatus = su.id where a.outline_id <> @outline_id">
            <SelectParameters>
                <asp:Parameter Name="CollegeID" Type="Int32" />
                <asp:Parameter DefaultValue="0" Name="outline_id" />
                <asp:Parameter DefaultValue="0" Name="AceID" />
                <asp:Parameter DefaultValue="0" Name="TeamRevd" />
            </SelectParameters>
        </asp:SqlDataSource>
        <h2>Existing Articulated course(s) to this MOS</h2>
        <telerik:RadGrid ID="rgOtherCourses" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOtherCourses" AllowFilteringByColumn="false" AllowPaging="True" GroupingSettings-CaseSensitive="false" OnItemCommand="rgOtherCourses_ItemCommand" RenderMode="Lightweight" PageSize="8" OnItemDataBound="rgOtherCourses_ItemDataBound" AllowMultiRowSelection="true">
            <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
                <ClientEvents />
            </ClientSettings>
            <MasterTableView Name="ParentGrid" DataSourceID="sqlOtherCourses" PageSize="8" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" ItemStyle-Height="25px">
                <CommandItemTemplate>
                    <div class="commandItems">
                        <telerik:RadButton runat="server" ID="btnMoveForward" ToolTip="Check to move forward selected articulations." CommandName="MoveForward" Text=" Move forward selected articulations" ButtonType="LinkButton">
                            <Icon PrimaryIconCssClass="rbOk"></Icon>
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>
                <Columns>
                    <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                    </telerik:GridClientSelectColumn>
                    <telerik:GridTemplateColumn HeaderStyle-Width="20px" AllowFiltering="false">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CommandName="OtherCollegesArticulations" ToolTip="This course has been articulated in another college." ID="btnOtherCollegeArticulations"  Text='<i class="fa fa-university" aria-hidden="true"></i>' />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="ExistInOtherColleges" UniqueName="ExistInOtherColleges" Display="false"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="subject" UniqueName="subject" HeaderText="Subject" AllowFiltering="false" HeaderStyle-Width="40px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" AllowFiltering="false" HeaderStyle-Width="50px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" AllowFiltering="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="RoleName" UniqueName="RoleName" HeaderText="Stage" AllowFiltering="false" HeaderStyle-Width="60px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Notes" UniqueName="Notes" HeaderText="Notes" AllowFiltering="false" HeaderStyle-Width="110px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false"></telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
    </div>
</div>
