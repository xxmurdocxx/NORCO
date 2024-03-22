<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="ems_app.modules.military.Notifications" %>

<%@ Register Src="~/UserControls/DisplayMessages.ascx" TagPrefix="uc" TagName="DisplayMessages" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" id="SystemTitle" runat="server"></p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" Modal="false" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <asp:HiddenField ID="hvUserID" runat="server" />
                <asp:HiddenField ID="hvUserName" runat="server" />
                <asp:HiddenField ID="hvCollegeID" runat="server" />
                <asp:HiddenField ID="hvUserStageID" runat="server" />
                <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
                    <SelectParameters>
                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="sqlPendingToNotifiy" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetFacultyReviewPendingToNotify" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hvUserName" DefaultValue="0" Name="Username" PropertyName="Value" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <h2>Notify Workflow Members</h2>
                <telerik:RadGrid ID="rgPendingToNotiify" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlPendingToNotifiy" AllowFilteringByColumn="true" AllowPaging="True" GroupingSettings-CaseSensitive="false" OnItemCommand="rgPendingToNotiify_ItemCommand" RenderMode="Lightweight" PageSize="8" AllowMultiRowSelection="true" OnItemDataBound="rgPendingToNotiify_ItemDataBound">
                    <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                        <ClientEvents />
                    </ClientSettings>
                    <MasterTableView Name="ParentGrid" DataSourceID="sqlPendingToNotifiy" PageSize="8" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true"  ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" Width="100%">
                        <CommandItemTemplate>
                            <div class="commandItems">
                                <telerik:RadButton runat="server" ID="btnNotify" OnClientClick="javascript:if(!confirm('Are you sure you want to send email  notifications for the selected articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Notify" CommandName="Notify" ToolTip="Notify Workflow Members via email that they need to take action regarding  the selected articulation(s)" >
                                    <ContentTemplate>
                                        <i class='fa fa-send'></i> Notify
                                    </ContentTemplate>
                                </telerik:RadButton>
                            </div>
                        </CommandItemTemplate>
                        <Columns>
                            <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                            </telerik:GridClientSelectColumn>
                            <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                        DataValueField="subject" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged2" DropDownAutoWidth="Enabled">
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
                            <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="50px" FilterControlWidth="30px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" FilterControlToolTip="Filter by Course Number">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" FilterControlToolTip="Filter by Course Title">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" HeaderText="Type" AllowFiltering="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" ReadOnly="true" HeaderStyle-Width="90px" FilterControlWidth="80px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" FilterControlToolTip="Filter by ACE ID">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="Team Revd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" FilterControlToolTip="Filter by Team Review Date" HeaderStyle-HorizontalAlign="Center">
                                <ItemStyle HorizontalAlign="Center" />
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true"   FilterControlToolTip="Filter by Occupation Code (MOS)">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" ReadOnly="true" HeaderStyle-Width="190px" FilterControlWidth="170px"  AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false" EmptyDataText="">
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes">
                                <ItemTemplate>
                                    <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                    <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                                    <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                                    </telerik:RadToolTip>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="CreatedOn" DataType="System.DateTime" FilterControlAltText="Filter CreatedOn column" HeaderText="Filter by Created Date" SortExpression="CreatedOn" UniqueName="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" ShowFilterIcon="false"  HeaderStyle-HorizontalAlign="Center">
                                <ItemStyle HorizontalAlign="Center" />
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false"></telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </div>
        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
        <script type="text/javascript">
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
    </script>
</asp:Content>
