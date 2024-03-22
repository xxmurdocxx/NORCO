<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CriteriaPackage.aspx.cs" Inherits="ems_app.modules.popups.CriteriaPackage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Edit Credit Recommendation</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
    <style>
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div class="row" style="padding: 20px;">
                <asp:HiddenField ID="hfSelectedCourse" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfSelectedCriteria" runat="server" ClientIDMode="Static" />
            </div>

            <div class="row">
                <div class="col-4">
                    <telerik:RadGrid ID="rgPackages" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" Culture="es-ES" EnableHeaderContextMenu="False" Width="100%" AllowFilteringByColumn="True" GroupingSettings-CaseSensitive="false" DataSourceID="sqlPackages" Skin="Material" Height="400px" OnPreRender="rgPackages_PreRender">
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <ClientSettings EnableAlternatingItems="false" EnablePostBackOnRowClick="true">
                            <Selecting AllowRowSelect="true" />
                        </ClientSettings>
                        <MasterTableView DataKeyNames="PackageID" DataSourceID="sqlPackages" CommandItemDisplay="None" AllowFilteringByColumn="false" ItemStyle-Font-Bold="true" AlternatingItemStyle-Font-Bold="true">
                            <Columns>
                                <telerik:GridBoundColumn DataField="PackageID" UniqueName="PackageID" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Criteria" HeaderText="Credit Recommendation" SortExpression="Criteria" UniqueName="Criteria" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="User" HeaderText="Created By" SortExpression="User" UniqueName="User" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="CreatedOn" HeaderText="Created On" SortExpression="CreatedOn" UniqueName="CreatedOn" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
                <div class="col-8">
                    <telerik:RadGrid ID="rgCreditRecommendations" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" Culture="es-ES" EnableHeaderContextMenu="False" Width="100%" AllowFilteringByColumn="True" GroupingSettings-CaseSensitive="false" MasterTableView-GroupLoadMode="Client" DataSourceID="sqlCreditRecommendations" Skin="Material" Height="160px">
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <ClientSettings EnableAlternatingItems="false">
                            <Selecting AllowRowSelect="true" EnableDragToSelectRows="true" />
                        </ClientSettings>
                        <MasterTableView DataKeyNames="Criteria" DataSourceID="sqlCreditRecommendations" CommandItemDisplay="None" AllowFilteringByColumn="false" ItemStyle-Font-Bold="true" AlternatingItemStyle-Font-Bold="true" EditMode="Batch">
                            <BatchEditingSettings EditType="Cell" />
                            <Columns>
                                <telerik:GridBoundColumn DataField="Criteria" HeaderText="Credit Recommendation" SortExpression="Criteria" UniqueName="Criteria" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="Condition" FilterControlAltText="Filter Condition column" HeaderText="&/or" SortExpression="Condition" UniqueName="Condition" DataSourceID="sqlConditions" ListTextField="ConditionSymbol" EmptyListItemValue="" ListValueField="id" HeaderStyle-Width="130px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" EnableHeaderContextMenu="false" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                </telerik:GridDropDownColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                    <telerik:RadGrid ID="rgArticulations" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" Culture="es-ES" EnableHeaderContextMenu="False" Width="100%" AllowFilteringByColumn="True" GroupingSettings-CaseSensitive="false" DataSourceID="sqlArticulations" Skin="Material" Height="360px" AllowMultiRowSelection="true">
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                        <ClientSettings EnableAlternatingItems="false">
                            <Selecting AllowRowSelect="true" EnableDragToSelectRows="true" />
                            <Scrolling AllowScroll="true" UseStaticHeaders="true" />
                            <ClientEvents OnRowDblClick="RowDblClick" />
                        </ClientSettings>
                        <MasterTableView DataSourceID="sqlArticulations" CommandItemDisplay="None" AllowFilteringByColumn="false" ItemStyle-Font-Bold="true" AlternatingItemStyle-Font-Bold="true">
                            <Columns>
                                <telerik:GridBoundColumn DataField="AceType" UniqueName="AceType" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="AceType" UniqueName="EntityType" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Occupation" UniqueName="Occupation" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Criteria" UniqueName="Criteria" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridClientSelectColumn UniqueName="selectCheckbox" HeaderStyle-Width="30px"></telerik:GridClientSelectColumn>
                                <telerik:GridBoundColumn DataField="AceID" HeaderText="Ace ID" SortExpression="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true" HeaderStyle-Width="110px">
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" DataFormatString="{0:MM/dd/yyyy}"
                                    HeaderText="Team Revd" SortExpression="TeamRevd" UniqueName="TeamRevd" HeaderStyle-Font-Bold="true" HeaderStyle-Width="130px" AllowFiltering="true" CurrentFilterFunction="GreaterThan" AutoPostBackOnFilter="false" FilterControlWidth="110px">
                                </telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" EnableHeaderContextMenu="false" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Title" HeaderText="Title" SortExpression="Title" UniqueName="Title" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="ExhibitDisplay" HeaderText="Exhibit Display" SortExpression="ExhibitDisplay" UniqueName="ExhibitDisplay" HeaderStyle-Font-Bold="true" Display="false">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
            </div>

            <asp:SqlDataSource runat="server" ID="sqlPackages" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="SELECT CP.Id as PackageID, CP.Criteria, CONCAT(U.LastName,', ',U.FirstName) 'User', CP.CreatedOn FROM CriteriaPackage CP LEFT OUTER JOIN TBLUSERS U ON CP.CreatedBy = U.UserID WHERE CP.outline_id = @outline_id AND CP.Criteria = @SelectedCriteria ORDER BY CP.CreatedOn DESC" CancelSelectOnNullParameter="false">
                <SelectParameters>
                    <asp:ControlParameter Name="outline_id" DbType="Int32" ControlID="hfSelectedCourse" PropertyName="Value" />
                    <asp:ControlParameter Name="SelectedCriteria" DbType="String" ControlID="hfSelectedCriteria" PropertyName="Value" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="sqlCreditRecommendations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="SELECT PC.Id, PC.PackageID, PC.Criteria, PC.Condition FROM CriteriaPackageCriteria PC WHERE PC.PackageID = @PackageID" CancelSelectOnNullParameter="false">
                <SelectParameters>
                    <asp:ControlParameter ControlID="rgPackages" DefaultValue="0" Name="PackageID" PropertyName="SelectedValue" Type="Int32"></asp:ControlParameter>
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="sqlArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="SELECT DISTINCT A.AceID, A.TeamRevd, E.ExhibitDisplay, E.AceType, E.Title, concat(cast(FORMAT(E.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(E.EndDate, 'MM/yy') as varchar(7))) AS 'ExhibitDate', E.Occupation FROM CriteriaPackageArticulation CPA LEFT OUTER JOIN Articulation A ON CPA.ArticulationId = A.id LEFT OUTER JOIN ACEExhibit E ON A.AceID = E.AceID AND A.TeamRevd = E.TeamRevd WHERE CPA.PackageId = @PackageID" CancelSelectOnNullParameter="false">
                <SelectParameters>
                    <asp:ControlParameter ControlID="rgPackages" DefaultValue="0" Name="PackageID" PropertyName="SelectedValue" Type="Int32"></asp:ControlParameter>
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="sqlConditions" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="select * from tblLookupConditions" CancelSelectOnNullParameter="false"></asp:SqlDataSource>
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="0" Width="350" Height="110" Title="Notification" EnableRoundedCorners="false">
            </telerik:RadNotification>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <!-- jQuery -->
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <!-- Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj" crossorigin="anonymous"></script>
    <!-- Custom Theme Scripts -->
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
    <script>
        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow)
                oWindow = window.radWindow;
            else if (window.frameElement && window.frameElement.radWindow)
                oWindow = window.frameElement.radWindow;
            return oWindow;
        }
        function CloseModal() {
            // GetRadWindow().close();
            setTimeout(function () {
                GetRadWindow().close();
            }, 0);
        }
    </script>
</body>
</html>
