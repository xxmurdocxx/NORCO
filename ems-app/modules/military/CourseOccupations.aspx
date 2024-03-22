<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="CourseOccupations.aspx.cs" Inherits="ems_app.modules.military.CourseOccupations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">ACE Occupation Codes</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from OccupationService order by Description">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, isnull(( select isnull(count(*),0) from Articulation where AceID = ao.AceID and TeamRevd = ao.TeamRevd and CollegeID = @CollegeID group by AceID, TeamRevd ),0) as 'Articulations', isnull( ( select isnull(sum(cast(u.unit as float)),0) from Articulation cco left outer join Course_IssuedForm cif on cco.outline_id = cif.outline_id left outer join tblLookupUnits u on cif.unit_id = u.unit_id where AceID = ao.AceID and TeamRevd = ao.TeamRevd and cco.CollegeID = @CollegeID group by AceID, TeamRevd ) ,0) as 'Units' from AceExhibit ao where coalesce(ao.[OccupationServiceCode],'0') IN (select value from fn_split(@Service,',')) and ao.TeamRevd > DATEADD(year,-@ExcludeArticulationOverYears,getdate())  order by ao.Title, ao.TeamRevd, ao.Exhibit" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:Parameter DbType="String" Name="Service" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:ControlParameter ControlID="hfExcludeArticulationOverYears" DbType="Int32" Name="ExcludeArticulationOverYears" PropertyName="Value"  />
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
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
        <div class="container-fluid">
            <div class="row" style="margin:0 0 10px 0;">
                <div class="col-md-1">
                    Service : 
                </div>
                <div class="col-md-2">
                <telerik:RadComboBox ID="rcbServices" runat="server" DataSourceID="sqlServices" DataTextField="description" DataValueField="Code" AutoPostBack="true" CheckBoxes="true" Width="200px" AppendDataBoundItems="true" EnableCheckAllItemsCheckBox="true" OnPreRender="rcbServices_PreRender" OnSelectedIndexChanged="rcbServices_SelectedIndexChanged" RenderMode="Lightweight">
                </telerik:RadComboBox>
                </div>
                <div class="col-md-9">
                    <asp:HiddenField ID="hfExcludeArticulationOverYears" runat="server" ClientIDMode="Static" />
                    <telerik:RadCheckBox ID="rchkExcludeYears" AutoPostBack="true" runat="server" Text="Exclude articulations over" OnCheckedChanged="rchkExcludeYears_CheckedChanged" ></telerik:RadCheckBox>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <telerik:RadGrid ID="rgCourseOccupations" runat="server" AllowFilteringByColumn="True" AllowPaging="true" PageSize="13" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlCourseOccupations" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="99%" RenderMode="Lightweight" OnItemCommand="rgCourseOccupations_ItemCommand">
                        <GroupingSettings CaseSensitive="false" />
                        <ClientSettings AllowColumnsReorder="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
                        </ClientSettings>
                        <MasterTableView DataKeyNames="AceID,TeamRevd" DataSourceID="sqlCourseOccupations" CommandItemDisplay="None"  AllowMultiColumnSorting="true">
                            <CommandItemSettings ShowExportToExcelButton="true" ShowAddNewRecordButton="false" ShowRefreshButton="false"  />
                            <Columns>
                                <telerik:GridTemplateColumn UniqueName="TemplateLinkColumn" AllowFiltering="False" HeaderStyle-Width="30px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkShowAceOccupation" CommandName="ShowAceOccupation" runat="server"><i class="fa fa-info-circle" aria-hidden="true"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="Occupation" FilterControlAltText="Filter Occupation column" HeaderText="Occ. Code" SortExpression="Occupation" UniqueName="Occupation" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Title" FilterControlAltText="Filter Title column" HeaderText="Occupation" SortExpression="Title" UniqueName="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="Ace ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Exhibit" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="StartDate" FilterControlAltText="Filter StartDate column" HeaderText="Start Date" SortExpression="StartDate" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="100px" FilterControlToolTip="Search by Start date" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false">
                                    <HeaderStyle Width="100px" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridDateTimeColumn DataField="EndDate" FilterControlAltText="Filter EndDate column" HeaderText="End Date" SortExpression="EndDate" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="100px" FilterControlToolTip="Search by End date" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false">
                                    <HeaderStyle Width="100px" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridDateTimeColumn DataField="TeamRevd" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="100px" FilterControlToolTip="Search by TeamRevd" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false">
                                    <HeaderStyle Width="100px" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn DataField="Articulations" FilterControlAltText="Filter Articulations column" HeaderText="Existing Articulations" SortExpression="Articulations" UniqueName="Articulations" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Units" FilterControlAltText="Filter Units column" HeaderText="Total Units" SortExpression="Units" UniqueName="Units" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
            </div>
        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
