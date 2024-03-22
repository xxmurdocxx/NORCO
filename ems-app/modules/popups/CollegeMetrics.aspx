<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CollegeMetrics.aspx.cs" Inherits="ems_app.modules.popups.CollegeMetrics" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>MAP Metrics Report</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
    <style>
        .RadGrid .rgSelectedRow td {
            background: none !important;
        }
                .RadGrid_Material .rgRow > td, .RadGrid_Material .rgAltRow > td, .RadGrid_Material .rgEditRow > td {
            border-bottom:1px solid #ccc !important;
        }
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" Modal="false"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="580px" Height="120px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <asp:SqlDataSource ID="sqlCollegeMetrics" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * FROM MAP_METRICS">
            </asp:SqlDataSource>
            <div style="padding: 15px !important;">
                <div class="row">
                    <div class="col-sm-8">
                        <h2 id="pageTitle" runat="server"></h2>
                    </div>
                    <div class="col-sm-4 text-right">
                    </div>
                </div>

                <telerik:RadGrid ID="rgCollegeMetrics" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlCollegeMetrics" AllowFilteringByColumn="false" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true"  Width="100%"  >
                    <ClientSettings AllowRowsDragDrop="False" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                        <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                        <ClientEvents />
                    </ClientSettings>
                    <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                    </ExportSettings>
                    <MasterTableView Name="ParentGrid" DataSourceID="sqlCollegeMetrics" PageSize="12" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" >
                        <CommandItemTemplate>
                            <div class="commandItems">
                                <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="false" >
                                    <ContentTemplate>
                                        <i class='fa fa-file-excel-o'></i>Export to Excel
                                    </ContentTemplate>
                                </telerik:RadButton>
                            </div>
                        </CommandItemTemplate>
                        <Columns>
                            <telerik:GridBoundColumn DataField="COLLEGE" UniqueName="COLLEGE" AllowFiltering="false" Exportable="false" HeaderText="COLLEGE NAME" ItemStyle-Font-Bold="true"  HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                           <%-- COLLEGE, FALL_2020_VETERANS, ELIGIBLE_REGIONAL_VETS_BASED_ON_ARTICULATIONS, COCI_CATALOG_COURSES, CATALOG_COURSES_REVIEWED, COCI_PROGRAMS_OF_STUDY, PROGRAMS_OF_STUDY_PARTIALLY_ARTICULATED, 
             PROGRAMS_OF_STUDY_100_ARTICULATED, TOTAL_COCI_ELIGIBLE_UNITS, MILITARY_CREDITS_AWARDED_TO_DATE, VETERANS_AWARDED_MILITARY_CREDIT_TO_DATE, ARTICULATION_LISTED_ON_TES, 
             [ACE_CREDIT_RECOMMENDATIONS_PERCENT_REVIEWED_867 POSSIBLE], LEAD_EVALUATOR, ARTICULATION_OFFICER, SENATE_PRESIDENT, FACULTY_LEAD, VETERANS_SERVICES, VPAA, [LEAD _MANAGER], PRESIDENT, LEGISLATORS, ID--%>
                            <telerik:GridBoundColumn SortExpression="FALL_2020_VETERANS" HeaderText="FALL 2021 VETERANS" DataField="FALL_2020_VETERANS" UniqueName="FALL_2020_VETERANS" AllowFiltering="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="ELIGIBLE_REGIONAL_VETS_BASED_ON_ARTICULATIONS" HeaderText="ELIGIBLE REGIONAL VETS BASED ON ARTICULATIONS" UniqueName="ELIGIBLE_REGIONAL_VETS_BASED_ON_ARTICULATIONS" DataField="ELIGIBLE_REGIONAL_VETS_BASED_ON_ARTICULATIONS" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                           <telerik:GridBoundColumn SortExpression="COCI_CATALOG_COURSES" HeaderText="COCI CATALOG COURSES" UniqueName="COCI_CATALOG_COURSES" DataField="COCI_CATALOG_COURSES" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="CATALOG_COURSES_REVIEWED" HeaderText="CATALOG COURSES REVIEWED" UniqueName="CATALOG_COURSES_REVIEWED" DataField="CATALOG_COURSES_REVIEWED" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="PROGRAMS_OF_STUDY_100_ARTICULATED" HeaderText="PROGRAMS OF STUDY 100 ARTICULATED" UniqueName="PROGRAMS_OF_STUDY_100_ARTICULATED" DataField="PROGRAMS_OF_STUDY_100_ARTICULATED" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                             <telerik:GridBoundColumn SortExpression="COCI_PROGRAMS_OF_STUDY" HeaderText="COCI PROGRAMS OF STUDY" UniqueName="COCI_PROGRAMS_OF_STUDY" DataField="COCI_PROGRAMS_OF_STUDY" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="TOTAL_COCI_ELIGIBLE_UNITS" HeaderText="TOTAL COCI ELIGIBL UNITS" UniqueName="TOTAL_COCI_ELIGIBLE_UNITS" DataField="TOTAL_COCI_ELIGIBLE_UNITS" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                             <%-- COLLEGE, FALL_2020_VETERANS, ELIGIBLE_REGIONAL_VETS_BASED_ON_ARTICULATIONS, COCI_CATALOG_COURSES, CATALOG_COURSES_REVIEWED, COCI_PROGRAMS_OF_STUDY, PROGRAMS_OF_STUDY_PARTIALLY_ARTICULATED, 
             PROGRAMS_OF_STUDY_100_ARTICULATED, TOTAL_COCI_ELIGIBLE_UNITS, MILITARY_CREDITS_AWARDED_TO_DATE, VETERANS_AWARDED_MILITARY_CREDIT_TO_DATE, ARTICULATION_LISTED_ON_TES, 
             [ACE_CREDIT_RECOMMENDATIONS_PERCENT_REVIEWED_867_POSSIBLE], LEAD_EVALUATOR, ARTICULATION_OFFICER, SENATE_PRESIDENT, FACULTY_LEAD, VETERANS_SERVICES, VPAA, [LEAD_MANAGER], PRESIDENT, LEGISLATORS, ID--%>
                            <telerik:GridBoundColumn SortExpression="MILITARY_CREDITS_AWARDED_TO_DATE" HeaderText="MILITARY CREDITS AWARDED TO DATE" UniqueName="MILITARY_CREDITS_AWARDED_TO_DATE" DataField="MILITARY_CREDITS_AWARDED_TO_DATE" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="VETERANS_AWARDED_MILITARY_CREDIT_TO_DATE" HeaderText="VETERANS AWARDED MILITARY CREDIT TO DATE" UniqueName="VETERANS_AWARDED_MILITARY_CREDIT_TO_DATE" DataField="VETERANS_AWARDED_MILITARY_CREDIT_TO_DATE" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="ARTICULATION_LISTED_ON_TES" HeaderText="ARTICULATION LISTED ON TES" UniqueName="ARTICULATION_LISTED_ON_TES" DataField="ARTICULATION_LISTED_ON_TES" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                             <telerik:GridBoundColumn SortExpression="ACE_CREDIT_RECOMMENDATIONS_PERCENT_REVIEWED_867_POSSIBLE" HeaderText="ACE CREDIT RECOMMENDATIONS PERCENT REVIEWED 867 POSSIBLE" UniqueName="ACE_CREDIT_RECOMMENDATIONS_PERCENT_REVIEWED_867_POSSIBLE" DataField="ACE_CREDIT_RECOMMENDATIONS_PERCENT_REVIEWED_867_POSSIBLE" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                             <telerik:GridBoundColumn SortExpression="LEAD_EVALUATOR" HeaderText="LEAD EVALUATOR" UniqueName="LEAD_EVALUATOR" DataField="LEAD_EVALUATOR" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                             <telerik:GridBoundColumn SortExpression="ARTICULATION_OFFICER" HeaderText="ARTICULATION OFFICER" UniqueName="ARTICULATION_OFFICER" DataField="ARTICULATION_OFFICER" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                             <telerik:GridBoundColumn SortExpression="SENATE_PRESIDENT" HeaderText="SENATE PRESIDENT" UniqueName="SENATE_PRESIDENT" DataField="SENATE_PRESIDENT" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-Width="300px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                             <telerik:GridBoundColumn SortExpression="FACULTY_LEAD" HeaderText="FACULTY LEAD" UniqueName="FACULTY_LEAD" DataField="FACULTY_LEAD" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"   HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="VETERANS_SERVICES" HeaderText="VETERANS SERVICES" UniqueName="VETERANS_SERVICES" DataField="VETERANS_SERVICES" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                             <telerik:GridBoundColumn SortExpression="VPAA" HeaderText="VPAA" UniqueName="VPAA" DataField="VPAA" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="LEAD_MANAGER" HeaderText="LEAD MANAGER" UniqueName="LEAD_MANAGER" DataField="LEAD_MANAGER" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"  HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                             <telerik:GridBoundColumn SortExpression="PRESIDENT" HeaderText="PRESIDENT" UniqueName="PRESIDENT" DataField="PRESIDENT" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px"   HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="LEGISLATORS" HeaderText="LEGISLATORS" UniqueName="LEGISLATORS" DataField="LEGISLATORS" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"  HeaderStyle-Width="400px"  HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="400px">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <script type="text/javascript">
        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }
    </script>
</body>
</html>







