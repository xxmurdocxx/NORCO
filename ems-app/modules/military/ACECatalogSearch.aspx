<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="ACECatalogSearch.aspx.cs" Inherits="ems_app.modules.military.ACECatalogSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" runat="server">Articulations Search</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlColleges" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="select * from LookupColleges lc join MAPCohort mc on lc.college = mc.COLLEGE_NAME where DistrictID is not null and DistrictID in(select distinct DistrictID from tblDistrictCollege where collegeid = @CollegeID) order by college">
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
    <asp:SqlDataSource ID="sqlStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM LookupStatus"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAceCatalog" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT ae.VersionNumber, ae.Revision, ae.ID,a.AceID, concat(a.AceID,' - ',convert(varchar(10), cast(a.TeamRevd as date), 101), case when VersionNumber is null or VersionNumber = '' then '' else concat(' - Version : ',VersionNumber) end ,' - ', a.Title, ' - ',  aec.Criteria) as 'Description' FROM Articulation a join ACEExhibitCriteria aec on a.CriteriaID = aec.CriteriaID join ACEExhibit ae on a.ExhibitID = ae.ID where a.CollegeID = @CollegeID  ORDER BY a.AceID,a.TeamRevd">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAceCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT CriteriaID, Criteria FROM Criteria ORDER BY Criteria"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetACECatalogSearch" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <%--<asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="String" />--%>
            <asp:ControlParameter ControlID="rcbColleges" PropertyName="selectedValue" Name="CollegeID" Type="Int32" ConvertEmptyStringToNull="true" />
            <asp:ControlParameter Name="AceID" ControlID="hfACEIds" Type="String" PropertyName="Value" ConvertEmptyStringToNull="true" DefaultValue="" />
            <asp:ControlParameter Name="DistrictID" ControlID="hfDistrictID" Type="String" PropertyName="Value" ConvertEmptyStringToNull="true" DefaultValue="" />
           <%-- <asp:ControlParameter Name="CriteriaID" ControlID="hfCriteriaIds" Type="String" PropertyName="Value" ConvertEmptyStringToNull="true" DefaultValue="" />--%>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 'Approved' status union select 'Denied' status">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct s.[Order],r.RoleName from Stages s join ROLES r on s.RoleId = r.RoleID order by s.[Order]">
    </asp:SqlDataSource>
    <div class="row">
        <div class="col-8">
            <telerik:RadAutoCompleteBox ID="racbAceExhibit" Label="Search by Exhibit ID's" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="20" DropDownHeight="200" DataSourceID="sqlACECatalog" DataTextField="Description" EmptyMessage="Search..." DataValueField="ID" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true" Delimiter="," AutoPostBack="true" ToolTip="This filter allows you to select/search exhibits that have existing articulations only..."  BackColor="LightYellow" ></telerik:RadAutoCompleteBox>
        </div>
        <div class="col-10" style="display:none">
            <telerik:RadAutoCompleteBox ID="racbACECriteria" Label="Search by Credit Recommendation" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="20" DropDownHeight="200" DataSourceID="sqlACECriteria" DataTextField="Criteria" EmptyMessage="Search..." DataValueField="CriteriaID" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true" Delimiter="," AutoPostBack="true" ToolTip="" ></telerik:RadAutoCompleteBox>
        </div>
        <div class="col-3">
            <%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
                <telerik:RadLabel ID="RadLabel7" runat="server" Text="District College : " Font-Size="Small" Font-Bold="false"></telerik:RadLabel>
                <telerik:RadComboBox ID="rcbColleges" DataSourceID="sqlColleges" DataTextField="College" DataValueField="CollegeID" Height="400px" Width="190px" DropDownAutoWidth="Enabled" runat="server" AutoPostBack="true" CssClass="mt-1 mb-1" AppendDataBoundItems="true">
                    <Items>
                        <telerik:RadComboBoxItem Value="" Text="ALL DISTRICT" />
                    </Items>
                </telerik:RadComboBox>
                <%--&nbsp;&nbsp;&nbsp;&nbsp;--%>
            <telerik:RadButton ID="rbSearch" runat="server" Text="Search" AutoPostBack="true" Primary="true" OnClick="rbSearch_Click"></telerik:RadButton>
            <telerik:RadButton ID="rbClear" runat="server" Text="Clear" AutoPostBack="true" Primary="false" OnClick="rbClear_Click"></telerik:RadButton>
        </div>
    </div>
    <asp:HiddenField ID="hfDistrictID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfCollegeID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfSubjectFilter" runat="server" ClientIDMode="Static" Value="" />
    <asp:HiddenField ID="hfCourseFilter" runat="server" ClientIDMode="Static" Value="" />
    <asp:HiddenField ID="hfTitleFilter" runat="server" ClientIDMode="Static" Value="" />

    <asp:HiddenField ID="hfACEIds" runat="server" ClientIDMode="Static" Value="" />
    <asp:HiddenField ID="hfCriteriaIds" runat="server" ClientIDMode="Static" Value="" />

    <telerik:RadGrid ID="rgArticulationCourses" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationCourses" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" EnableHeaderContextMenu="true"  OnFilterCheckListItemsRequested="rgArticulationCourses_FilterCheckListItemsRequested" OnItemCommand="rgArticulationCourses_ItemCommand" ShowGroupPanel="true" OnItemDataBound="rgArticulationCourses_ItemDataBound" Width="100%" GroupPanel-BackColor="LightGray" >
        <GroupingSettings ShowUnGroupButton="True" />
        <ClientSettings AllowRowsDragDrop="false" AllowDragToGroup="true" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
            <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
            <ClientEvents OnFilterMenuShowing="FilterMenuShowing" />
            <Scrolling AllowScroll="true" ScrollHeight="450px" UseStaticHeaders="true" />
        </ClientSettings>
        <ExportSettings HideStructureColumns="true" ExportOnlyData="True" OpenInNewWindow="True" IgnorePaging="True" Excel-AutoFitColumnWidth="AutoFitAll" Pdf-PageWidth="1700" Pdf-PageTitle="Articulation Search" >
        </ExportSettings>
        <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulationCourses" PageSize="12" DataKeyNames="outline_id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" CommandItemSettings-ExportToExcelText="Export to Excel" CommandItemSettings-ShowExportToPdfButton="true" CommandItemSettings-ExportToPdfText="Export to PDF" AllowFilteringByColumn="true" AllowMultiColumnSorting="true"  HeaderStyle-Font-Bold="true" EnableHeaderContextMenu="true" >
            <Columns>
                <telerik:GridBoundColumn  DataField="outline_id" UniqueName="outline_id" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn  DataField="id" UniqueName="id" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn  DataField="ExhibitID" UniqueName="ExhibitID" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="40px" ReadOnly="true" AllowFiltering="false" EnableHeaderContextMenu="false">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" ToolTip="Edit Articulation" OnClick="btnEditNotes_Click" ID="btnEditNotes" Text='Edit' CssClass="d-block" />
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridDropDownColumn DataSourceID="sqlArticulationStatus" ListTextField="status" ListValueField="status" UniqueName="Status" SortExpression="status" HeaderText="Status" ItemStyle-Font-Bold="true" DataField="Status" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="85px">
                    <FilterTemplate>
                        <telerik:RadComboBox ID="RadComboBoxArtStatus" DataSourceID="sqlArticulationStatus" DataTextField="status"
                            DataValueField="status" Height="100px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Status").CurrentFilterValue %>'
                            runat="server" OnClientSelectedIndexChanged="StatusIndexChanged" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="All" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock222" runat="server">
                            <script type="text/javascript">
                                function StatusIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("Status", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridDropDownColumn>
                <telerik:GridDropDownColumn FilterCheckListEnableLoadOnDemand="true" DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject_id" HeaderText="Discipline" DataField="subject" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="100px" AllowSorting="false" FilterControlWidth="30px" ItemStyle-HorizontalAlign="Center">
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
                <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course #" DataField="course_number" UniqueName="course_number" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="85px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-HorizontalAlign="Center" FilterControlWidth="40px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="100px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="250px" ItemStyle-Width="180px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn  DataField="ArticulationType" UniqueName="articulation_type" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" FilterControlWidth="50px" Display="false">
                </telerik:GridDropDownColumn>
                <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" Exportable="false" EnableHeaderContextMenu="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" FilterControlWidth="70px" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" EnableHeaderContextMenu="true">
                </telerik:GridBoundColumn>
                <telerik:GridDropDownColumn DataSourceID="sqlStages" ListTextField="description" ListValueField="stage_id" UniqueName="stage_id" SortExpression="stage_id" HeaderText="Stage" DataField="stage_id" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="40px" ReadOnly="true" Display="false">
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
<%--                <telerik:GridBoundColumn FilterCheckListEnableLoadOnDemand="true" SortExpression="ArtRole" HeaderText="Stage" DataField="ArtRole" UniqueName="ArtRole" HeaderStyle-Width="100px">
                </telerik:GridBoundColumn>--%>
                <telerik:GridDropDownColumn DataSourceID="sqlRoles" ListTextField="RoleName" ListValueField="RoleName" UniqueName="ArtRole" SortExpression="ArtRole" HeaderText="Stage" DataField="ArtRole" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="100px">
                    <FilterTemplate>
                        <telerik:RadComboBox ID="RadComboBoxRole" DataSourceID="sqlRoles" DataTextField="RoleName"
                            DataValueField="RoleName" Height="150px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("ArtRole").CurrentFilterValue %>'
                            runat="server" OnClientSelectedIndexChanged="RoleIndexChanged" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Value="" Text="All" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock10188" runat="server">
                            <script type="text/javascript">
                                function RoleIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("ArtRole", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridDropDownColumn>

                <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableRangeFiltering="true" HeaderStyle-HorizontalAlign="Center">
                    <ItemStyle HorizontalAlign="Center" />
                </telerik:GridDateTimeColumn>
                <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" ReadOnly="true" HeaderStyle-Width="250px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="MinUnits" HeaderText="Min. Units" DataField="MinUnits" UniqueName="MinUnits" AllowFiltering="true" HeaderStyle-Width="70px" FilterControlWidth="30px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="MaxUnits" HeaderText="Max. Units" DataField="MaxUnits" UniqueName="MaxUnits" AllowFiltering="true" HeaderStyle-Width="90px" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true" Display="false"  HeaderStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes" HeaderStyle-Width="50px" >
                    <ItemTemplate>
                        <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                        <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                            <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                        </telerik:RadToolTip>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn SortExpression="CreditRecommendation" HeaderText="Credit Recommendation" DataField="CreditRecommendation" UniqueName="CreditRecommendation" AllowFiltering="true" ReadOnly="true" EmptyDataText="" HeaderStyle-Wrap="false" ItemStyle-Wrap="true" HeaderStyle-Width="380px" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" Display="false" > 
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="College" HeaderText="College" DataField="College" UniqueName="College" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Wrap="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Last Submitted by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Wrap="false">
                </telerik:GridBoundColumn> 
                <telerik:GridDateTimeColumn DataField="CreatedOn" DataType="System.DateTime" FilterControlAltText="Filter CreatedOn column" HeaderText="Created On" SortExpression="CreatedOn" UniqueName="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableRangeFiltering="true" HeaderStyle-HorizontalAlign="Center">
                    <ItemStyle HorizontalAlign="Center" />
                </telerik:GridDateTimeColumn>
                <telerik:GridBoundColumn SortExpression="LastSubmmited" HeaderText="Last Submitted By" DataField="LastSubmmited" UniqueName="LastSubmmited" AllowFiltering="false" ReadOnly="true" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" HeaderStyle-Width="150px"  Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridDateTimeColumn DataField="LastSubmittedOn" DataType="System.DateTime" FilterControlAltText="Filter LastSubmmitedOn column" HeaderText="Last Submmited On" SortExpression="LastSubmittedOn" UniqueName="LastSubmittedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" HeaderStyle-HorizontalAlign="Center" Display="false">
                    <ItemStyle HorizontalAlign="Center" />
                </telerik:GridDateTimeColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
