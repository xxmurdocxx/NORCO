<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="ManageVeteranOccupations.aspx.cs" Inherits="ems_app.modules.leads.ManageVeteranOccupations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Manage Veterans MOS's</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlUpdateOptions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 1 id, 'Update selected Veterans MOS(s) ' description union select 2 id, 'Update all Veterans MOS(s) ' description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from OccupationService order by Description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAllOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ao.* from View_MostCurrentOccupation ao where coalesce(ao.[OccupationServiceCode],'0') IN (select value from fn_split(@Service,',')) order by ao.Title, ao.TeamRevd, ao.Exhibit" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:Parameter DbType="String" Name="Service" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ao.Occupation as 'OccupationCode', ao.Occupation + ' - ' + ao.Title as OccupationTitle from View_MostCurrentOccupation ao order by ao.Occupation"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlVeteranLeads" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  v.id VeteranID,  v.LastName + ', ' + FirstName + ' ' + Coalesce(MiddleName,' ') as 'FullName', v.Email, v.Occupation, v.Occupation OccupationCode, Coalesce(moc.Title,'Unknown') as OccupationTitle from Veteran v left outer join View_MostCurrentOccupation moc on v.Occupation = moc.occupation  where moc.title is null and v.id in ( select VeteranID from VeteranLead where CampaignID = ( 
 select ID from Campaign where CampaignStatus = 1 and CollegeID =  @CollegeID ) ) order by v.lastname">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <!-- UPDATE OCCUPATION -->
    <asp:SqlDataSource ID="sqlRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from AceOccupationDetail where AceID = @AceID and TeamRevd = @TeamRevd" UpdateCommand="Update AceOccupationDetail SET [HTMLDetail] = @HTMLDetail WHERE ID = @ID" InsertCommand="insert into AceOccupationDetail (AceID,TeamRevd,HTMLDetail) values (@AceID, @TeamRevd, @HTMLDetail)">
        <SelectParameters>
            <asp:ControlParameter Name="AceID" ControlID="hfAceID" PropertyName="Value" DbType="String" />
            <asp:ControlParameter Name="TeamRevd" ControlID="hfTeamRevd" PropertyName="Value" DbType="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="HTMLDetail" Type="String" />
            <asp:Parameter Name="ID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:ControlParameter Name="AceID" ControlID="hfAceID" PropertyName="Value" DbType="String" />
            <asp:ControlParameter Name="TeamRevd" ControlID="hfTeamRevd" PropertyName="Value" DbType="String" />
            <asp:Parameter Name="HTMLDetail" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlOccupationService" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select code, code + ' - ' + description as 'CodeDescription' from OccupationService"></asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose" AutoCloseDelay="4000">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <div class="container">
            <div class="row">
                <div class="col-sm-6">
                    <asp:RadioButtonList ID="rlUpdateOptions" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" DataSourceID="sqlUpdateOptions" DataTextField="description" DataValueField="id" ClientIDMode="Static" >
                    </asp:RadioButtonList>
                    <telerik:RadGrid ID="rgVeteranLeads" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlVeteranLeads" Width="100%" GroupingSettings-CaseSensitive="false" AllowAutomaticUpdates="true" RenderMode="Lightweight" OnItemCommand="rgVeteranLeads_ItemCommand" AllowMultiRowSelection="true">
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <ExportSettings FileName="Veterans" ExportOnlyData="True" IgnorePaging="True">
                        </ExportSettings>
                        <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" AllowKeyboardNavigation="true" Resizing-AllowColumnResize="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                            <ClientEvents OnRowSelected="RowSelected"/>
                        </ClientSettings>
                        <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlVeteranLeads" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="None" NoMasterRecordsText="No records to display"  AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" DataKeyNames="VeteranID" Name="ParentGrid">
                            <CommandItemSettings ShowExportToExcelButton="True" />
                            <Columns>
                                <telerik:GridBoundColumn DataField="VeteranID" UniqueName="VeteranID" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="FullName" FilterControlAltText="Filter FullName column" HeaderText="Veteran" SortExpression="FullName" UniqueName="FullName" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ItemStyle-Wrap="false" />
                                <telerik:GridBoundColumn DataField="Email" UniqueName="Email" HeaderText="Email" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Occupation" UniqueName="Occupation" HeaderText="Occupation Code" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="120px" ItemStyle-Width="75px" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center">
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
                <div class="col-sm-6">
                <asp:HiddenField ID="hfAceID" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfTeamRevd" runat="server" ClientIDMode="Static" />
                <div class="panel panel-primary">
			        <div class="panel-heading">
				        <h3 class="panel-title">Update Unknown MOS</h3>
				        <span class="pull-right clickable"><i class="glyphicon glyphicon-chevron-up"></i></span>
			        </div>
			        <div class="panel-body">
                <div class="row">
                    <div class="col-sm-9" style="padding:5px 0 0 0;">
                        <span class="boldText">Occupation Code: </span>
                        <telerik:RadTextBox ID="rtbOccupationCode" Width="100px" CssClass="form-control" runat="server" onkeyup="changeCase(this)" ClientIDMode="Static"></telerik:RadTextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="rtbOccupationCode" runat="server" ErrorMessage="Please enter a Occupation Code" CssClass="alert alert-warning"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-sm-3 text-right">
                        <telerik:RadButton ID="rbSave" runat="server" Text="Save" ButtonType="StandardButton" OnClick="rbSave_Click" OnClientClicking="ConfirmOccupation">
                            <ContentTemplate>
                                <i class="fa fa-floppy-o"></i> Update Unknow Veteran MOS
                            </ContentTemplate>
                        </telerik:RadButton>
                    </div>
                    <div class="col-sm-12" style="padding:5px 0 0 0;">
                        <span class="boldText">Description : </span>
                        <telerik:RadTextBox ID="rtbOccupationTitle" CssClass="form-control" runat="server" Width="250px" ClientIDMode="Static"></telerik:RadTextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="rtbOccupationTitle" runat="server" ErrorMessage="Please enter a Occupation Title" CssClass="alert alert-warning"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-sm-12" style="padding:5px 0 0 0;">
                        <span class="boldText">Team Revised: </span>
                        <telerik:RadDatePicker ID="rtbTeamRevd" runat="server" Width="100px" ClientIDMode="Static"></telerik:RadDatePicker>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="rtbTeamRevd" runat="server" ErrorMessage="Please select a Team Revd date" CssClass="alert alert-warning"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-sm-12" style="padding:5px 0 0 0;">
                        <span class="boldText">Service: </span>
                        <telerik:RadComboBox RenderMode="Lightweight" ID="rcbService" runat="server" Width="200px" Height="100px" DataSourceID="sqlOccupationService" DataValueField="code" DataTextField="CodeDescription" EmptyMessage="Select a service..." ClientIDMode="Static" DropDownAutoWidth="Enabled">
                        </telerik:RadComboBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" ControlToValidate="rcbService" runat="server" ErrorMessage="Please select a Service" CssClass="alert alert-warning"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-sm-12" style="margin:5px 0 0 0;">
                        <div id="divMessage">
                        <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-success" Visible="false" ClientIDMode="Static"></asp:Label>
                        </div>
                    </div>
                </div>
                <br />
                <asp:Panel ID="pnlRecommendations" runat="server" Visible="false">
                    <div id="divRecommendations">
                    <telerik:RadGrid ID="rgRecommendations" runat="server" AllowPaging="False" AllowSorting="False" DataSourceID="sqlRecommendations" Width="100%" AllowAutomaticUpdates="true" AllowAutomaticInserts="true"  RenderMode="Lightweight">
                        <ClientSettings AllowKeyboardNavigation="true">
                            <Selecting EnableDragToSelectRows="false"></Selecting>
                        </ClientSettings>
                        <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlRecommendations" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="true" CommandItemDisplay="Top" NoMasterRecordsText="No records to display" EditMode="Batch" DataKeyNames="ID" Name="ParentGrid">
                            <BatchEditingSettings EditType="Cell" />
                            <Columns>
                                <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn UniqueName="HTMLDetail" SortExpression="HTMLDetail" HeaderText="Recommendation" DataField="HTMLDetail">
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
                </asp:Panel>
                    </div>
                </div>
                <div class="panel panel-primary">
			        <div class="panel-heading">
				        <h3 class="panel-title">Assign existing MOS</h3>
				        <span class="pull-right clickable"><i class="glyphicon glyphicon-chevron-up"></i></span>
			        </div>
			        <div class="panel-body">
                        <div class="row">
                            <div class="col-sm-12 text-right" style="font-weight: bold; margin-bottom: 5px;">
                                <asp:Label ID="draggedRows" runat="server"></asp:Label>
                                Service : <telerik:RadComboBox ID="rcbServices" runat="server" DataSourceID="sqlServices" DataTextField="description" DataValueField="Code" AutoPostBack="true" CheckBoxes="true" Width="200px" AppendDataBoundItems="true" EnableCheckAllItemsCheckBox="true" OnPreRender="rcbServices_PreRender" OnSelectedIndexChanged="rcbServices_SelectedIndexChanged" RenderMode="Lightweight" DropDownAutoWidth="Enabled">
                                </telerik:RadComboBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12 col-md-12" style="height: 440px;">
                                <telerik:RadGrid ID="rgACEOccupations" runat="server" AllowFilteringByColumn="True" AllowPaging="true" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlAllOccupations" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" OnRowDrop="rgACEOccupations_RowDrop" AllowMultiRowSelection="false" ClientSettings-Scrolling-AllowScroll="true" Height="460px" OnItemCommand="rgACEOccupations_ItemCommand">
                                    <GroupingSettings CaseSensitive="false" />
                                    <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                        <%--<ClientEvents OnRowDblClick="RowDblClickOccupation" OnRowDropping="OnRowDropped"></ClientEvents>--%>
                                        <Selecting AllowRowSelect="true" EnableDragToSelectRows="false"></Selecting>
                                    </ClientSettings>
                                    <MasterTableView DataKeyNames="AceID,TeamRevd" DataSourceID="sqlAllOccupations" CommandItemDisplay="Top" AllowMultiColumnSorting="true" Name="ParentGrid" HeaderStyle-Font-Bold="true" PageSize="7">
                                        <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                                        <CommandItemTemplate>
                                            <telerik:RadButton ID="rbUpdateExisting" runat="server" Text="Save" ButtonType="LinkButton"  CommandName="UpdateExistingMOS" CausesValidation="false" OnClientClicking="ConfirmOccupation">
                                                <ContentTemplate>
                                                    <i class="fa fa-floppy-o"></i> Assign/Update Existing MOS
                                                </ContentTemplate>
                                            </telerik:RadButton>
                                        </CommandItemTemplate>
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="Occupation" FilterControlAltText="Filter Occupation column" HeaderText="Occ. Code" SortExpression="Occupation" UniqueName="Occupation" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="40px" HeaderStyle-Width="30px">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Title" FilterControlAltText="Filter Title column" HeaderText="Occupation" SortExpression="Title" UniqueName="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="Ace ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Exhibit" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="40px" FilterControlWidth="50px">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridDateTimeColumn DataField="TeamRevd" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="90px" FilterControlToolTip="Search by TeamRevd" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" Display="True">
                                                <HeaderStyle Width="100px" />
                                            </telerik:GridDateTimeColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                                <div style="display: none !important;">
                                    <telerik:RadTextBox ID="selectedRowValue" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
                                </div>
                            </div>
                        </div>
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
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function OnRowSelected(sender, eventArgs) {
            var item = eventArgs.get_item();
            var cell = item.get_cell("Occupation");
            var value = $telerik.$(cell).text().trim();
            document.getElementById('selectedRowValue').value = value;
            alert("Click Event");
        }
        function RowSelected() {
            var rtbOccupationCode = $find("<%= rtbOccupationCode.ClientID %>");
            rtbOccupationCode.set_value("");
            rtbOccupationCode.enable();
            var rtbOccupationTitle = $find("<%= rtbOccupationTitle.ClientID %>");
            rtbOccupationTitle.set_value("");
            rtbOccupationTitle.enable();
            document.getElementById('hfAceID').value = "";
            document.getElementById('hfTeamRevd').value = "";
            var datepicker = $find("<%= rtbTeamRevd.ClientID %>"); 
            datepicker.set_selectedDate("");
            datepicker.set_enabled(true);
            var combo = $find("<%= rcbService.ClientID %>");
            combo.clearSelection();
            combo.set_enabled(true);
            $('#divMessage').fadeOut(2000);
            $('#divRecommendations').fadeOut(2000);
        }
        function changeCase(sender) {
            sender.value = sender.value.toUpperCase();
        }
        function ConfirmOccupation(sender, args) {
            args.set_cancel(!window.confirm("Are you sure you want to update the veteran's Occupation?"));
        }
        function OnRowDropped(sender, args) {
            if (args._targetItemTableView.get_name() == "ParentGrid") {
                if (confirm('Are you sure ?')) {
                }
                else {
                    args.set_cancel(true);
                }
            }
        }
        function onRequestStart(sender, args) {
            //if (args.get_eventTarget().indexOf("rbSave") >= 0) {
            //    args.set_enableAjax(false);
            //}
        }
    </script>
</asp:Content>
