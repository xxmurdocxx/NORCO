<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="ACECatalogSearch.aspx.cs" Inherits="ems_app.modules.military.ACECatalogSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" runat="server">ACE Catalog Search</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlArticulationType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 1 as id, 'Course' as description union select 2 as id , 'Occupation' as description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStages" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.Id as stage_id, r.RoleName as 'Description' from Stages s join ROLES r on s.RoleId = r.RoleID where s.CollegeId =  @CollegeID">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM LookupStatus"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAceCatalog" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT AceID, concat(AceID,' - ',convert(varchar(10), cast(TeamRevd as date), 101),' - ', Title) as 'Description' FROM AceExhibit ORDER BY AceID"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetACECatalogSearch" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="String" />
            <asp:ControlParameter Name="AceID" ControlID="hfACEIds" Type="String" PropertyName="Value" ConvertEmptyStringToNull="true" DefaultValue="" />
        </SelectParameters>
    </asp:SqlDataSource>
    <div class="row">
        <div class="col-10">
            <telerik:RadAutoCompleteBox ID="racbAceExhibit" Label="Search by ACE ID's" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="20" DropDownHeight="200" DataSourceID="sqlACECatalog" DataTextField="Description" EmptyMessage="Search..." DataValueField="AceID" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true" Delimiter="," AutoPostBack="true" ToolTip="" ></telerik:RadAutoCompleteBox>
        </div>
        <div class="col-2">
            <telerik:RadButton ID="rbSearch" runat="server" Text="Search" AutoPostBack="true" Primary="true" OnClick="rbSearch_Click"></telerik:RadButton>
            <telerik:RadButton ID="rbClear" runat="server" Text="Clear" AutoPostBack="true" Primary="false" OnClick="rbClear_Click"></telerik:RadButton>
        </div>
    </div>
    <asp:HiddenField ID="hfSubjectFilter" runat="server" ClientIDMode="Static" Value="" />
    <asp:HiddenField ID="hfCourseFilter" runat="server" ClientIDMode="Static" Value="" />
    <asp:HiddenField ID="hfTitleFilter" runat="server" ClientIDMode="Static" Value="" />

    <asp:HiddenField ID="hfACEIds" runat="server" ClientIDMode="Static" Value="" />

    <telerik:RadGrid ID="rgArticulationCourses" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationCourses" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" FilterType="HeaderContext" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" OnFilterCheckListItemsRequested="rgArticulationCourses_FilterCheckListItemsRequested" OnItemCommand="rgArticulationCourses_ItemCommand" OnItemDataBound="rgArticulationCourses_ItemDataBound">
        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
            <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
            <ClientEvents OnFilterMenuShowing="FilterMenuShowing" />
        </ClientSettings>
        <ExportSettings HideStructureColumns="true" ExportOnlyData="True" OpenInNewWindow="True" IgnorePaging="True">
        </ExportSettings>
        <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulationCourses" PageSize="12" DataKeyNames="outline_id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true"  HeaderStyle-Font-Bold="true">
            <Columns>
                <telerik:GridDropDownColumn FilterCheckListEnableLoadOnDemand="true" DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject_id" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="90px">
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
                <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" HeaderStyle-Wrap="false" DataField="course_number" UniqueName="course_number" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="50px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px">
                </telerik:GridBoundColumn>
                <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" >
                </telerik:GridDropDownColumn>
                <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" Exportable="false" EnableHeaderContextMenu="false">
                </telerik:GridBoundColumn>
                <telerik:GridDropDownColumn DataSourceID="sqlStatus" ListTextField="description" ListValueField="id" UniqueName="status_id" SortExpression="status_id" HeaderText="Status" DataField="status_id" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px" ReadOnly="true" Display="false">
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
                <telerik:GridDropDownColumn DataSourceID="sqlStages" ListTextField="description" ListValueField="stage_id" UniqueName="stage_id" SortExpression="stage_id" HeaderText="Stage" DataField="stage_id" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="70px" ReadOnly="true" Display="false">
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
                <telerik:GridBoundColumn FilterCheckListEnableLoadOnDemand="true" SortExpression="ArtRole" HeaderText="Stage" DataField="ArtRole" UniqueName="ArtRole" HeaderStyle-Width="120px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" HeaderStyle-Width="90px">
                </telerik:GridBoundColumn>
                <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableRangeFiltering="true">
                    <ItemStyle HorizontalAlign="Center" />
                </telerik:GridDateTimeColumn>
                <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="190px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="MinUnits" HeaderText="Min. Units" DataField="MinUnits" UniqueName="MinUnits" AllowFiltering="true" HeaderStyle-Width="90px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="MaxUnits" HeaderText="Max. Units" DataField="MaxUnits" UniqueName="MaxUnits" AllowFiltering="true" HeaderStyle-Width="90px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true" Display="false" EnableHeaderContextMenu="false">
                </telerik:GridBoundColumn>
                <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes" EnableHeaderContextMenu="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                        <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                            <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                        </telerik:RadToolTip>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Criteria" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Articulated by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Wrap="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="LastSubmmited" HeaderText="Last Submitted By" DataField="LastSubmmited" UniqueName="LastSubmmited" AllowFiltering="false" ReadOnly="true" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" HeaderStyle-Width="100px" >
                </telerik:GridBoundColumn>
                <telerik:GridDateTimeColumn DataField="LastSubmittedOn" DataType="System.DateTime" FilterControlAltText="Filter LastSubmmitedOn column" HeaderText="Last Submmited On" SortExpression="LastSubmittedOn" UniqueName="LastSubmittedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" HeaderStyle-HorizontalAlign="Center">
                    <ItemStyle HorizontalAlign="Center" />
                </telerik:GridDateTimeColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
