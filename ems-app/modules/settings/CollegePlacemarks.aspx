<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="CollegePlacemarks.aspx.cs" Inherits="ems_app.modules.settings.CollegePlacemarks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .col1,
        .col2,
        .col3 {
            margin: 0;
            padding: 0 5px 0 0;
            width: 30%;
            line-height: 14px;
            float: left;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">College Placemarks</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadTabStrip runat="server" ID="RadTabStrip1" MultiPageID="RadMultiPage1" SelectedIndex="0" Width="100%" Height="50px" ShowBaseLine="false" RenderMode="Lightweight" Font-Bold="true" AutoPostBack="true">
            <Tabs>
                <telerik:RadTab Text="Colleges" Value="colleges" ToolTip="" Selected="True">
                </telerik:RadTab>
                <telerik:RadTab Text="Military Bases" Value="bases" ToolTip="" >
                </telerik:RadTab>
            </Tabs>
        </telerik:RadTabStrip>
        <telerik:RadWindowManager ID="RadWindowManager1" RenderMode="Lightweight" ShowContentDuringLoad="true" runat="server" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadMultiPage runat="server" ID="RadMultiPage1" SelectedIndex="0" Width="100%" RenderMode="Lightweight" RenderSelectedPageOnly="true">
            <telerik:RadPageView runat="server" ID="RadPageView1" Width="100%">
                <asp:SqlDataSource ID="sqlColleges" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT CollegeID, upper(College) as 'College', CollegeWebsite, VeteranServices, LogoUrl, ExcludeKMLFile, Coordinates, (SELECT Count(*) FROM   articulation WHERE  collegeid = c.collegeid AND articulationstage = dbo.Getmaximumstageid(c.collegeid) AND articulationstatus = 1) AS 'ApprovedArticulations', (SELECT Count(*) FROM   course_issuedform WHERE  college_id = c.collegeid AND [status] = 0) AS 'TotalCourses', (SELECT Count(*) FROM   program_issuedform WHERE  college_id = c.collegeid AND [status] = 0) AS 'TotalPrograms' FROM   LookupColleges C ORDER BY C.College" UpdateCommand="UPDATE LookupColleges SET [CollegeWebsite] = @CollegeWebsite, [VeteranServices] = @VeteranServices, [LogoUrl] = @LogoUrl, [ExcludeKMLFile] = @ExcludeKMLFile, [Coordinates] = @Coordinates, [UpdatedBy] = @UpdatedBy, [UpdatedOn] = GETDATE()  WHERE [CollegeID] = @CollegeID ">
                    <SelectParameters>
                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="CollegeWebsite" Type="String" />
                        <asp:Parameter Name="VeteranServices" Type="String" />
                        <asp:Parameter Name="LogoUrl" Type="String" />
                        <asp:Parameter Name="Coordinates" Type="String" />
                        <asp:Parameter Name="ExcludeKMLFile" Type="Boolean" />
                        <asp:Parameter Name="CollegeID" Type="Int32" />
                        <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <div class="row p-2 d-flex justify-content-end">
                    <telerik:RadLinkButton runat="server" ID="rlbExportKML" Primary="true" Text="Export KML File" ToolTip="Export MAP Locations to KML file" NavigateUrl="~/modules/settings/kml/ExportKML.ashx" Width="200px" CssClass="btn-primary" />
                </div>
                <telerik:RadGrid ID="rgColleges" runat="server" CellSpacing="-1" DataSourceID="sqlColleges" Width="100%" AllowAutomaticUpdates="true" PageSize="13" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true">
                    <GroupingSettings CaseSensitive="false" />
                    <ExportSettings IgnorePaging="true" ExportOnlyData="true">
                    </ExportSettings>
                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="CollegeID" DataSourceID="sqlColleges" CommandItemDisplay="Top" EditMode="Batch" PageSize="13" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="true" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel">
                        <NoRecordsTemplate>
                            <p>No records to display</p>
                        </NoRecordsTemplate>
                        <BatchEditingSettings EditType="Cell" />
                        <Columns>
                            <telerik:GridTemplateColumn DataField="ExcludeKMLFile" DataType="System.Boolean" HeaderText="Exclude from KML" UniqueName="ExcludeKMLFile" HeaderStyle-Width="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="CheckBox1" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("ExcludeKMLFile")) %>' onclick="checkBoxClick(this, event);" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:CheckBox runat="server" ID="CheckBox2" />
                                </EditItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="CollegeID" UniqueName="CollegeID" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="College" HeaderText="College" UniqueName="College" DataField="College" ItemStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" ReadOnly="true" HeaderStyle-Width="190px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="CollegeWebsite" HeaderText="College Website URL" UniqueName="CollegeWebsite" DataField="CollegeWebsite" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="200px" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="VeteranServices" HeaderText="Veteran Services URL" UniqueName="VeteranServices" DataField="VeteranServices" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="200px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="LogoUrl" HeaderText="College Logo URL" UniqueName="LogoUrl" DataField="LogoUrl" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="200px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Coordinates" HeaderText="Coordinates" UniqueName="Coordinates" DataField="Coordinates" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="120px" HeaderStyle-Width="170px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="ApprovedArticulations" HeaderText="Approved Articulations" UniqueName="ApprovedArticulations" DataField="ApprovedArticulations" HeaderStyle-Width="100px" FilterControlWidth="50px" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="TotalCourses" HeaderText="Total Courses" UniqueName="TotalCourses" DataField="TotalCourses" HeaderStyle-Width="100px" FilterControlWidth="50px" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="TotalPrograms" HeaderText="Total Programs" UniqueName="TotalPrograms" DataField="TotalPrograms" HeaderStyle-Width="100px" FilterControlWidth="50px" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </telerik:RadPageView>
            <telerik:RadPageView runat="server" ID="RadPageView2" Width="100%">
                <asp:SqlDataSource ID="sqlMilitaryBases" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM MilitaryBase ORDER BY [Name]" UpdateCommand="UPDATE [dbo].[MilitaryBase] SET [Name] = @Name, [Description] = @Description, [ExcludeKMLFile] = @ExcludeKMLFile, [UpdatedOn] = GETDATE(), [Coordinates] = @Coordinates
 WHERE id = @ID"
                    InsertCommand="INSERT INTO [dbo].[MilitaryBase] ([Name] ,[Description] ,[ExcludeKMLFile] ,[CreatedOn] ,[Coordinates]) VALUES (@Name ,@Description ,@ExcludeKMLFile ,GETDATE() ,@Coordinates)">
                    <SelectParameters>
                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="Name" Type="String" />
                        <asp:Parameter Name="Description" Type="String" />
                        <asp:Parameter Name="ExcludeKMLFile" Type="Boolean" />
                        <asp:Parameter Name="Coordinates" Type="String" />
                        <asp:Parameter Name="ID" Type="Int32" />
                    </UpdateParameters>
                    <InsertParameters>
                        <asp:Parameter Name="Name" Type="String" />
                        <asp:Parameter Name="Description" Type="String" />
                        <asp:Parameter Name="ExcludeKMLFile" Type="Boolean" />
                        <asp:Parameter Name="Coordinates" Type="String" />
                    </InsertParameters>
                </asp:SqlDataSource>
                <telerik:RadGrid ID="rgMilitaryBases" runat="server" CellSpacing="-1" DataSourceID="sqlMilitaryBases" Width="100%" AllowAutomaticUpdates="true" AllowAutomaticInserts="true" PageSize="13" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true">
                    <GroupingSettings CaseSensitive="false" />
                    <ExportSettings IgnorePaging="true" ExportOnlyData="true">
                    </ExportSettings>
                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="sqlMilitaryBases" CommandItemDisplay="Top" EditMode="Batch" PageSize="13" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="true" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel">
                        <NoRecordsTemplate>
                            <p>No records to display</p>
                        </NoRecordsTemplate>
                        <BatchEditingSettings EditType="Cell" />
                        <Columns>
                            <telerik:GridTemplateColumn DataField="ExcludeKMLFile" DataType="System.Boolean" HeaderText="Exclude from KML" UniqueName="ExcludeKMLFile" HeaderStyle-Width="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="CheckBox1" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("ExcludeKMLFile")) %>' onclick="checkBoxClickBases(this, event);" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:CheckBox runat="server" ID="CheckBox2" />
                                </EditItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Name" HeaderText="Name" UniqueName="Name" DataField="Name" ItemStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="340px"  HeaderStyle-Width="400px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Description" HeaderText="Description" UniqueName="Description" DataField="Description" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="200px" >
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Coordinates" HeaderText="Coordinates" UniqueName="Coordinates" DataField="Coordinates" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" HeaderStyle-Width="220px">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </telerik:RadPageView>
        </telerik:RadMultiPage>
    </telerik:RadAjaxPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        function checkBoxClick(sender, args) {
            var grid = $find("<%= rgColleges.ClientID %>");
            var masterTableView = grid.get_masterTableView();
            var batchEditingManager = grid.get_batchEditingManager();
            var parentCell = $telerik.$(sender).closest("td")[0];

            var initialValue = sender.checked;
            sender.checked = !sender.checked;

            batchEditingManager.changeCellValue(parentCell, initialValue);
        }
        function checkBoxClickBases(sender, args) {
            var grid = $find("<%= rgMilitaryBases.ClientID %>");
            var masterTableView = grid.get_masterTableView();
            var batchEditingManager = grid.get_batchEditingManager();
            var parentCell = $telerik.$(sender).closest("td")[0];

            var initialValue = sender.checked;
            sender.checked = !sender.checked;

            batchEditingManager.changeCellValue(parentCell, initialValue);
        }
    </script>
</asp:Content>
