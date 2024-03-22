<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="ArchivedArticulations.aspx.cs" Inherits="ems_app.modules.military.ArchivedArticulations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
<p class="h2" id="SystemTitle" runat="server">Archived Articulations</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
        <p id="divMsgs" runat="server">
            <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
            </asp:Label>
            <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
            </asp:Label>
        </p>
    </telerik:RadToolTip>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
        <SelectParameters>
            <asp:ControlParameter Name="CollegeID" ControlID="hvCollegeID" PropertyName="Value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select r.RoleName from Stages s join ROLES r on s.RoleID = r.RoleID where s.CollegeID = @CollegeID order by s.[order]">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArchivedArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArchivedArticulations" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="CollegeID" ControlID="hvCollegeID" PropertyName="Value" Type="Int32" />
            <asp:ControlParameter Name="Years" ControlID="hvExcludeArticulationOverYears" PropertyName="Value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:HiddenField ID="hvCollegeID" runat="server" />
    <asp:HiddenField ID="hvExcludeArticulationOverYears" runat="server" />
    <telerik:RadGrid ID="rgArchivedArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArchivedArticulations" AllowFilteringByColumn="true" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" OnItemDataBound="rgArchivedArticulations_ItemDataBound" OnItemCommand="rgArchivedArticulations_ItemCommand">
        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
            <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
            <ClientEvents OnFilterMenuShowing="FilteringMenu" />
        </ClientSettings>
        <MasterTableView Name="ParentGrid" DataSourceID="sqlArchivedArticulations" PageSize="8" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" ItemStyle-Height="25px" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
            <Columns>
                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="15px" Exportable="false">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="EditArticulation" ID="btnEdit" Text='<i class="fa fa-pencil-square fa-lg" aria-hidden="true"></i>' />
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="15px">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" ToolTip="Reverse Archive" CommandName="Archive" ID="btnReverse" Text='<i class="fa fa-undo fa-lg" aria-hidden="true"></i>' OnClientClick="javascript:if(!confirm('Are you sure you want to reverse archive for this articulation ?')){return false;}" />
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridDropDownColumn DataSourceID="sqlRoles" ListTextField="RoleName" ListValueField="RoleName" UniqueName="RoleName" SortExpression="RoleName" HeaderText="Filter by Role/Stage" DataField="RoleName" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px" ReadOnly="true" FilterControlToolTip="Filter by workflow role or stage (i.e. Articulation Officer, Evaluator, Faculty, Implementation)" HeaderStyle-Font-Bold="true" FilterControlWidth="60px">
                    <FilterTemplate>
                        <telerik:RadComboBox ID="RadComboBoxRole" DataSourceID="sqlRoles" DataTextField="RoleName"
                            DataValueField="RoleName" Height="150px" Width="100px" DropDownAutoWidth="Enabled" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("RoleName").CurrentFilterValue %>'
                            runat="server" OnClientSelectedIndexChanged="RoleIndexChanged">
                            <Items>
                                <telerik:RadComboBoxItem Text="All" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock188" runat="server">
                            <script type="text/javascript">
                                function RoleIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("RoleName", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridDropDownColumn>
                <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="50px">
                    <FilterTemplate>
                        <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                            DataValueField="subject" MaxHeight="200px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                            runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged2">
                            <Items>
                                <telerik:RadComboBoxItem Text="All" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock43" runat="server">
                            <script type="text/javascript">
                                function SubjectIndexChanged2(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                            }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridDropDownColumn>
                <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="30px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" AllowFiltering="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" HeaderText="Type" AllowFiltering="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="80px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="true">
                </telerik:GridBoundColumn>
                <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="100px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" >
                    <ItemStyle HorizontalAlign="Center" />
                </telerik:GridDateTimeColumn>
                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="190px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false" EmptyDataText="">
                </telerik:GridBoundColumn>
                <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes">
                    <ItemTemplate>
                        <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                        <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                        <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                        </telerik:RadToolTip>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn SortExpression="SelectedCriteria" HeaderText="Credit Recommendation" DataField="SelectedCriteria" UniqueName="SelectedCriteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Submitted By" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="100px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false"></telerik:GridBoundColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
