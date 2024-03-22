<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OtherOccupationsHaveCriteria.aspx.cs" Inherits="ems_app.modules.popups.OtherOccupationsHaveCriteria" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Other Courses/Occupations have this criteria</title>
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
        <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="GetOtherOccupationsHaveCriteria">
            <SelectParameters>
                <asp:QueryStringParameter Name="ArticulationID" QueryStringField="ArticulationID" />
                <asp:QueryStringParameter Name="ArticulationType" QueryStringField="ArticulationType" />
                <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" />
                <asp:QueryStringParameter Name="CollegeID" QueryStringField="CollegeID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div class="row" style="padding: 15px !important;">
                <div class="col-sm-4"><h3 id="popupTitle" runat="server">Other Courses/Occupations have this criteria</h3></div>
                <div class="col-sm-8"><div style="font-size:9px; padding-left:5px; padding-bottom:5px;"> <i class="fa fa-info-circle" aria-hidden="true"></i> If you want to select more than one item and the items are listed consecutively in the selection box, use the Shift key to quickly select the entire group of entries. Click the first item in the section you want to select to highlight it. Scroll to the last item in the section, hold down the 'Shift' key and click the item. Shift-Click selects the first item, last item and all items in between. Use the Ctrl key to select additional items outside of the consecutive group, then click the button to process the selections you highlighted.</div></div>
                <div class="col-sm-12 col-md-12">
                    <asp:HiddenField ID="hvBackColor" runat="server" />
                    <asp:HiddenField ID="hvForeColor" runat="server" />
                    
                    <telerik:RadGrid ID="rgOccupations" runat="server" AllowFilteringByColumn="True" AllowPaging="true" PageSize="50" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOccupations" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" OnItemCommand="rgOccupations_ItemCommand" AllowMultiRowSelection="true" OnPreRender="rgOccupations_PreRender" OnItemCreated="rgOccupations_ItemCreated">
                        <GroupingSettings CaseSensitive="false" />
                        <ClientSettings AllowColumnsReorder="true">
                            <ClientEvents OnRowDblClick="RowDblClick"></ClientEvents>
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
                        </ClientSettings>
                        <MasterTableView DataKeyNames="AceID,TeamRevd" DataSourceID="sqlOccupations" CommandItemDisplay="Top"   AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                            <CommandItemTemplate>
                                <div class="commandItems">
                                    <telerik:RadButton runat="server" ID="btnAddOccupation" ToolTip="Check to add selected occupations." CommandName="AddOccupation" Text=" Add selected occupations" ButtonType="LinkButton">
                                        <Icon PrimaryIconCssClass="rbOk"></Icon>
                                    </telerik:RadButton>
                                    <telerik:RadButton runat="server" ID="btnAddAllOccupations" ToolTip="Add all occupations." CommandName="AddAllOccupations" Text=" Add all occupations" ButtonType="LinkButton" OnClientClicking="ConfirmAddAll" UseSubmitBehavior="false" CausesValidation="false">
                                        <Icon PrimaryIconCssClass="rbOk"></Icon>
                                    </telerik:RadButton>
                                </div>
                            </CommandItemTemplate>
                            <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                            <Columns>
                                <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="Ace ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" HeaderStyle-Width="80px">
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="TeamRevd" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="100px" FilterControlToolTip="Search by TeamRevd" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false">
                                    <HeaderStyle Width="100px" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn DataField="Occupation" FilterControlAltText="Filter Occupation column" HeaderText="Occ. Code" SortExpression="Occupation" UniqueName="Occupation" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="40px" HeaderStyle-Width="30px">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Title" FilterControlAltText="Filter Title column" HeaderText="Occupation" SortExpression="Title" UniqueName="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" >
                                </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="EntityType" UniqueName="EntityType" Display="false" >
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script>
        function ConfirmAddAll(sender, args) {
            args.set_cancel(!window.confirm("Are you sure you want to add all occupations ?"));
        }
    </script>
</body>
</html>