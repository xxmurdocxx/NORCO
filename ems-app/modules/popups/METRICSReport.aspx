<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="METRICSReport.aspx.cs" Inherits="ems_app.modules.popups.METRICSReport" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>TES Report</title>
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
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct cif.subject_id, s.subject from (select outline_id, CollegeID from Articulation where CollegeID = @CollegeID) Ac join Course_IssuedForm cif on ac.outline_id = cif.outline_id and ac.CollegeID = cif.college_id join tblSubjects s on cif.subject_id = s.subject_id and cif.college_id = s.college_id where cif.college_id = @CollegeID order by s.subject">
                <SelectParameters>
                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
           <asp:SqlDataSource ID="sqlDepartments" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from tblLookupDepartments where college_id = @CollegeID order by department">
                <SelectParameters>
                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
           <asp:SqlDataSource ID="sqlType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 'Course' as 'Type' union select 'Occupation' as 'Type'">
                <SelectParameters>
                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlTESArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.[subject], cif.course_number, cif.course_title, case when cif.Vunit_id is null then U.unit else concat(U.unit, ' - ', v.unit ) end as Units, d.department, cif.effective_start_date, cif.effective_end_date, case when a.ArticulationType = 1 then 'Course' else 'Occupation' end as 'Type', a.AceID, a.TeamRevd, case when a.ArticulationType = 1 then acc.Title else ao.Title end 'Title', [dbo].[GetHighlightRecommendationCriteria] (a.id) as 'Detail', [dbo].[GetArticulationMatrix](a.id) 'Matrix' from  Articulation a join Course_IssuedForm cif on a.outline_id = cif.outline_id join LookupColleges c on cif.college_id = c.CollegeID join tblSubjects s on cif.subject_id = s.subject_id left outer join tblLookupUnits u on cif.unit_id = u.unit_id left outer join tblLookupUnits v on cif.Vunit_id = v.unit_id left outer join AceCourseCatalog acc on a.AceID = acc.AceID and a.TeamRevd = acc.TeamRevd left outer join AceOccupation ao on a.AceID = ao.AceID and a.TeamRevd = ao.TeamRevd left outer join tblLookupDepartments d on cif.department_id = d.department_id  where cif.college_id = @CollegeID and a.ArticulationStage = dbo.GetMaximumStageId(a.CollegeID) and a.ArticulationStatus = 1 order by s.[subject], cif.course_number, a.AceID">
                <SelectParameters>
                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <div style="padding: 15px !important;">
                <div class="row">
                    <div class="col-sm-8">
                        <h2 id="pageTitle" runat="server"></h2>
                    </div>
                    <div class="col-sm-4 text-right">
                    </div>
                </div>

                <telerik:RadGrid ID="rgTESArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlTESArticulations" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHierarchyExpandAll="true"  OnPreRender="grid_PreRender">
                    <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                        <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                        <ClientEvents />
                    </ClientSettings>
                    <ExportSettings HideStructureColumns="true" IgnorePaging="true" ExportOnlyData="true" HideNonDataBoundColumns="true" Excel-DefaultCellAlignment="Left">
                    </ExportSettings>
                    <MasterTableView Name="ParentGrid" DataSourceID="sqlTESArticulations" PageSize="12" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" ItemStyle-BackColor="#CAE3BF" AlternatingItemStyle-BackColor="#CAE3BF" HeaderStyle-Font-Bold="true" >
                        <CommandItemTemplate>
                            <div class="commandItems">
                                <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" Visible="true">
                                    <ContentTemplate>
                                        <i class='fa fa-file-excel-o'></i>Export to Excel
                                    </ContentTemplate>
                                </telerik:RadButton>
                            </div>
                        </CommandItemTemplate>
                        <Columns>
                            <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" AllowSorting="false" Exportable="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataSourceID="sqlType" ListTextField="Type" ListValueField="Type" UniqueName="Type" SortExpression="Type" HeaderText="Type" DataField="Type" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxType" DataSourceID="sqlType" DataTextField="Type"
                                        DataValueField="Type" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Type").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="TypeIndexChanged">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlock3333" runat="server">
                                        <script type="text/javascript">
                                            function TypeIndexChanged(sender, args) {
                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("Type", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                        DataValueField="subject" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                                        <script type="text/javascript">
                                            function SubjectIndexChanged(sender, args) {
                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Name" UniqueName="course_title" DataField="course_title" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px">
                            </telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataSourceID="sqlDepartments" ListTextField="department" ListValueField="department" UniqueName="department" SortExpression="department" HeaderText="Department" DataField="department" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="60px">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxDepartment" DataSourceID="sqlDepartments" DataTextField="department"
                                        DataValueField="department" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("department").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="DepartmentIndexChanged" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlock33" runat="server">
                                        <script type="text/javascript">
                                            function DepartmentIndexChanged(sender, args) {
                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("department", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn DataField="Units" UniqueName="Units" HeaderText="Units">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="effective_start_date" UniqueName="effective_start_date" HeaderText="Start Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridDateTimeColumn DataField="effective_end_date" UniqueName="effective_end_date" HeaderText="End Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="true" FilterControlWidth="80px" HeaderStyle-Width="90px">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="TeamRevd" UniqueName="TeamRevd" SortExpression="TeamRevd" HeaderText="Team Revd" AllowFiltering="true" DataFormatString="{0:MM/dd/yyyy}">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="true" >
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Detail" HeaderText="Detail" DataField="Detail" UniqueName="Detail" AllowFiltering="true" HeaderStyle-Width="600px" >
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





