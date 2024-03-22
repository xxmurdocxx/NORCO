<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowOccupations.aspx.cs" Inherits="ems_app.modules.popups.ShowOccupations" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Related ACE Occupations Codes</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from OccupationService order by Description"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlAllOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ao.* from MostCurrentACEOccupation ao where coalesce(ao.[OccupationServiceCode],'0') IN (select value from fn_split(@Service,',')) and ao.Occupation not in (SELECT OccupationID FROM CourseOccupations WHERE [AceID] = @AceID and [TeamRevd] = @TeamRevd) order by ao.Title, ao.TeamRevd, ao.Exhibit" CancelSelectOnNullParameter="false">
            <SelectParameters>
                <asp:Parameter DbType="String" Name="Service" />
                <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ao.Occupation, ao.Occupation + ' - ' + ao.Title as Title from MostCurrentACEOccupation ao order by ao.Occupation"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCourseOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM CourseOccupations WHERE [AceID] = @AceID and [TeamRevd] = @TeamRevd" DeleteCommand="DELETE FROM [CourseOccupations] WHERE [AceID] = @AceID and [TeamRevd] = @TeamRevd and [OccupationID] = @OccupationID" InsertCommand="INSERT INTO [CourseOccupations] ([AceID],[TeamRevd],[OccupationID]) VALUES (@AceID, Convert(datetime, @TeamRevd, 103), @OccupationID)">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="AceID" Type="String" />
                <asp:Parameter Name="TeamRevd" Type="DateTime" />
                <asp:Parameter Name="OccupationID" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:QueryStringParameter Name="AceID" QueryStringField="AceID" Type="String" />
                <asp:QueryStringParameter Name="TeamRevd" QueryStringField="TeamRevd" />
                <asp:Parameter Name="OccupationID" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager2" runat="server"></telerik:RadWindowManager>
            <div class="row" style="padding: 15px !important;">
                <div class="col-md-6 col-sm-6 col-xs-6">
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <h3 id="courseTitle" runat="server"></h3>
                        <telerik:RadGrid ID="rgCourseOccupations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlCourseOccupations" AllowAutomaticDeletes="true" AllowAutomaticInserts="true">
                            <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                            <MasterTableView DataSourceID="sqlCourseOccupations" DataKeyNames="AceID,TeamRevd,OccupationID" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="true" EditMode="Batch"  AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                <BatchEditingSettings EditType="Cell" />
                                <Columns>
                                    <telerik:GridDropDownColumn DataField="OccupationID" FilterControlAltText="Filter OccupationID column" HeaderText="Occupation" SortExpression="OccupationID" UniqueName="OccupationID" DataSourceID="sqlOccupations" ListTextField="Title" ListValueField="Occupation" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this occupation ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
                </div>
                <div class="col-md-6 col-sm-6 col-xs-6">
                    <div class="row">
                        <div class="col-md-8">
                            <h3>ACE Occupation Codes</h3>
                        </div>
                        <div class="col-md-1">
                            Service : 
                        </div>
                        <div class="col-md-3">
                            <telerik:RadComboBox ID="rcbServices" runat="server" DataSourceID="sqlServices" DataTextField="description" DataValueField="Code" AutoPostBack="true" CheckBoxes="true" Width="200px" AppendDataBoundItems="true" EnableCheckAllItemsCheckBox="true" OnPreRender="rcbServices_PreRender" OnSelectedIndexChanged="rcbServices_SelectedIndexChanged" RenderMode="Lightweight">
                            </telerik:RadComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-md-12">
                            <telerik:RadGrid ID="rgACEOccupations" runat="server" AllowFilteringByColumn="True" AllowPaging="true" PageSize="8" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlAllOccupations" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" OnItemCommand="rgACEOccupations_ItemCommand" AllowMultiRowSelection="true">
                                <GroupingSettings CaseSensitive="false" />
                                <ClientSettings AllowColumnsReorder="true">
                                    <Selecting AllowRowSelect="False" EnableDragToSelectRows="False" />
                                </ClientSettings>
                                <MasterTableView DataKeyNames="AceID,TeamRevd" DataSourceID="sqlAllOccupations" CommandItemDisplay="Top"   AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                            <telerik:RadButton runat="server" ID="btnAddOccupation" ToolTip="Check to add selected occupations." CommandName="AddOccupation" Text=" Add selected occupations" ButtonType="LinkButton">
                                                <Icon PrimaryIconCssClass="rbOk"></Icon>
                                            </telerik:RadButton>
                                        </div>
                                    </CommandItemTemplate>
                                    <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                                    <Columns>
                                        <telerik:GridTemplateColumn UniqueName="CheckBoxTemplateColumn" AllowFiltering="false" HeaderStyle-Width="10px">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="CheckBox1" runat="server" OnCheckedChanged="ToggleRowSelection"
                                                    AutoPostBack="True" />
                                            </ItemTemplate>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="headerChkbox" runat="server" OnCheckedChanged="ToggleSelectedState"
                                                    AutoPostBack="True" />
                                            </HeaderTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="Occupation" FilterControlAltText="Filter Occupation column" HeaderText="Occ. Code" SortExpression="Occupation" UniqueName="Occupation" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="40px" HeaderStyle-Width="30px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Title" FilterControlAltText="Filter Title column" HeaderText="Occupation" SortExpression="Title" UniqueName="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="100px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="Ace ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Exhibit" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="50px" FilterControlWidth="50px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn DataField="StartDate" FilterControlAltText="Filter StartDate column" HeaderText="Start Date" SortExpression="StartDate" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="100px" FilterControlToolTip="Search by Start date" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" Display="false">
                                            <HeaderStyle Width="100px" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridDateTimeColumn DataField="EndDate" FilterControlAltText="Filter EndDate column" HeaderText="End Date" SortExpression="EndDate" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="100px" FilterControlToolTip="Search by End date" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" Display="false">
                                            <HeaderStyle Width="100px" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridDateTimeColumn DataField="TeamRevd" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="100px" FilterControlToolTip="Search by TeamRevd" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false" Display="false">
                                            <HeaderStyle Width="100px" />
                                        </telerik:GridDateTimeColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </div>
                    </div>
                </div>

            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
</body>
</html>
