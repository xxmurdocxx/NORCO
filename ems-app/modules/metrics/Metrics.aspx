<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Metrics.aspx.cs" Inherits="ems_app.modules.metrics.Metrics" %>



<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>MAP Metrics</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous" />
    <!-- Roboto Font -->
    <link href="../../Common/fonts/Roboto.css" rel="stylesheet" />
    <style>
        html, body {
            font-family: 'Roboto-Regular', sans-serif !important;
        }

        .RadGrid_Bootstrap .rgRow > td, .RadGrid_Bootstrap .rgAltRow > td, .RadGrid_Bootstrap .rgEditRow > td, .RadGrid_Bootstrap .rgFooter > td, .RadGrid_Bootstrap .rgFilterRow > td, .RadGrid_Bootstrap .rgHeader, .RadGrid_Bootstrap .rgResizeCol, .RadGrid_Bootstrap .rgGroupHeader td, .RadGrid_Bootstrap .rgPagerCell, .RadGrid_Bootstrap .rgCommandCell .t-button {
            font-family: 'Roboto-Regular', sans-serif !important;
            font-size: 11px !important;
            text-transform: capitalize !important;
        }

        .RadGrid_Bootstrap .rgFilter {
            padding: 6px !important;
        }

        .RadGrid_Bootstrap .rgPagerCell .rgNumPart a.rgCurrentPage {
            border-color: #2e6da4;
            color: #fff !important;
            background-color: #1E3864 !important;
        }

        .RadGrid_Bootstrap .rgHeader, .RadGrid_Bootstrap th.rgResizeCol, .RadGrid_Bootstrap .rgHeaderWrapper, .RadGrid_Bootstrap .rgMultiHeaderRow th.rgHeader, .RadGrid_Bootstrap .rgMultiHeaderRow th.rgResizeCol {
            border-bottom: 5px solid #ffb71c !important;
            border-left: 0 !important;
        }

        .RadGrid_Bootstrap td a {
            color: #1E3864 !important;
        }

        .h2, h2 {
            font-size: 18px !important;
        }

        .RadGrid .t-font-icon, .RadTreeList .t-font-icon, .RadCalendar .t-font-icon {
            color: #fff !important;
        }

        .RadGrid_Bootstrap .rgPagerCell .rgNumPart a, .RadGrid_Bootstrap .rgPagerCell .rgActionButton span {
            color: #000 !important;
        }

        .RadGrid_Bootstrap .rgFilter span, .RadGrid_Bootstrap .rgFilter:hover, .RadGrid_Bootstrap .rgFilter {
            color: #ffb71c !important;
            border-color: #1e3864 !important;
            background-color: #1e3864 !important;
        }
        .RadGrid_Bootstrap .rgFilterBox {
            border-color: #1e3864 !important;
        }
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <asp:SqlDataSource ID="sqlType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT 1 as [Type], 'Course' as [Description] UNION SELECT 2 as [Type], 'Occupation' as [Description]" SelectCommandType="Text"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlService" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM ( SELECT Code, Description FROM OccupationService UNION SELECT Code, Description FROM LookupService ) a ORDER BY Description" SelectCommandType="Text"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlCollegeMetrics" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetMetricsList" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                <SelectParameters>
                    <asp:ControlParameter Name="Service" ControlID="rcbService" PropertyName="SelectedValue" Type="String" ConvertEmptyStringToNull="true" />
                    <asp:ControlParameter Name="Type" ControlID="rcbType" PropertyName="SelectedValue" Type="Int32" ConvertEmptyStringToNull="true" />
                </SelectParameters>
            </asp:SqlDataSource>
            <div style="padding: 15px !important;">
                <div class="row">
                    <div class="col-sm-8">
                        <h2 id="pageTitle" runat="server">MAP Metrics </h2>
                    </div>
                    <div class="col-sm-4 text-right">
                    </div>
                </div>
                <div class="row">
                    <div class="col-6">
                        <telerik:RadComboBox ID="rcbService" runat="server" AutoPostBack="true" Width="50%" DataSourceID="sqlService" DataTextField="Description" DataValueField="Code" AppendDataBoundItems="true" RenderMode="Lightweight" Label="Service : " DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Value="" Text="All" Selected="true" />
                            </Items>
                        </telerik:RadComboBox>
                    </div>
                    <div class="col-6">
                        <telerik:RadComboBox ID="rcbType" runat="server" AutoPostBack="true" Width="50%" DataSourceID="sqlType" DataTextField="Description" DataValueField="Type" AppendDataBoundItems="true" RenderMode="Lightweight" Label="Type: " DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Value="" Text="All" Selected="true" />
                            </Items>
                        </telerik:RadComboBox>
                    </div>
                </div>

                <telerik:RadGrid ID="rgCollegeMetrics" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlCollegeMetrics" AllowFilteringByColumn="true" AllowPaging="True" GroupingSettings-CaseSensitive="false" Skin="Bootstrap" RenderMode="Lightweight" EnableHierarchyExpandAll="true" Width="100%">
                    <ClientSettings AllowRowsDragDrop="False" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                        <Selecting AllowRowSelect="false" EnableDragToSelectRows="False" />
                        <ClientEvents />
                    </ClientSettings>
                    <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                    </ExportSettings>
                    <SortingSettings ShowNoSortIcons="false" />
                    <MasterTableView Name="ParentGrid" DataSourceID="sqlCollegeMetrics" PageSize="12" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" HeaderStyle-BackColor="#1e3864" HeaderStyle-ForeColor="#ffffff" CommandItemStyle-ForeColor="#ffffff" CommandItemStyle-BackColor="#1e3864" >
                        <Columns>
                            <telerik:GridBoundColumn DataField="COLLEGE" UniqueName="COLLEGE" AllowFiltering="true" Exportable="true" HeaderText="Cohort College" HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center" FilterControlWidth="200px" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowSortIcon="true" AllowSorting="true" SortExpression="COLLEGE">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="ArticulationCount" HeaderText="Articulated College Courses" DataField="ArticulationCount" UniqueName="ArticulationCount" AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ShowSortIcon="true" AllowSorting="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="StudentsAwarded" HeaderText="Students Awarded MAP Credit" DataField="StudentsAwarded" UniqueName="StudentsAwarded" AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ShowSortIcon="true" AllowSorting="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="AverageUnitsAwarded" HeaderText="Average Credits Awarded" DataField="AverageUnitsAwarded" UniqueName="AverageUnitsAwarded" AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ShowSortIcon="true" AllowSorting="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="TotalUnitsAwarded" HeaderText="Total MAP Credits Awarded" DataField="TotalUnitsAwarded" UniqueName="TotalUnitsAwarded" AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ShowSortIcon="true" AllowSorting="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridHyperLinkColumn SortExpression="VeteranServices" HeaderText="Veteran Services" UniqueName="VeteranServices" AllowFiltering="false" DataTextField="VeteranServices" Text="Veteran Resource Center" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" DataNavigateUrlFields="VeteranServices" DataTextFormatString="Veteran Resource Center" Target="_blank" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridHyperLinkColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
</body>
</html>
