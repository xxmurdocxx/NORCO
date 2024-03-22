<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="BasicMilitaryTraining.aspx.cs" Inherits="ems_app.modules.settings.BasicMilitaryTraining" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Basic Military Training Configuration </p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT s.subject, cif.subject_id, cif.[course_number], cif.[course_title], cif.[college_id], cif.[isBasicMilitaryTraining], cif.[outline_id], cif.[unit_id], cif.[Vunit_id], u.unit FROM [Course_IssuedForm] cif left outer join tblSubjects s on cif.subject_id = s.subject_id left outer join tblLookupUnits u on cif.unit_id = u.unit_id LEFT OUTER JOIN tblLookupUnits V ON CIF.Vunit_id = V.unit_id WHERE (cif.[college_id] = @college_id) and s.college_id = @college_id order by s.subject, CAST(SUBSTRING(CIF.course_number, PATINDEX('%[0-9]%', CIF.course_number), PATINDEX('%[0-9][^0-9]%', CIF.course_number + 't') - PATINDEX('%[0-9]%', CIF.course_number) + 1) as INT)" UpdateCommand="UPDATE [Course_IssuedForm] SET [isBasicMilitaryTraining] = @isBasicMilitaryTraining, [UpdatedBy] = @UpdatedBy, [unit_id] = @unit_id, [Vunit_id] = @Vunit_id, [course_title] = @course_title WHERE [outline_id] = @outline_id ">
        <SelectParameters>
            <asp:SessionParameter Name="college_id" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="course_title" Type="String" />
            <asp:Parameter Name="unit_id" Type="Int32" />
            <asp:Parameter Name="Vunit_id" Type="Int32" />
            <asp:Parameter Name="isBasicMilitaryTraining" Type="Boolean" />
            <asp:Parameter Name="outline_id" Type="Int32" />
            <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select unit_id, CAST(unit AS decimal(18, 1)) AS unit, default_value, college_id, secondary_key from tblLookupUnits order by unit">
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadWindowManager ID="RadWindowManager1" RenderMode="Lightweight" ShowContentDuringLoad="true" runat="server"  EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadGrid ID="rgBasicMilitaryTraining" runat="server" CellSpacing="-1" DataSourceID="sqlCourses" Width="100%" AllowAutomaticUpdates="true" PageSize="20" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true">
        <GroupingSettings CaseSensitive="false" />
        <ExportSettings IgnorePaging="true" ExportOnlyData="true">
        </ExportSettings>
        <ClientSettings>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowDblClick="RowDblClickNORCO" ></ClientEvents>
        </ClientSettings>
        <MasterTableView AutoGenerateColumns="False" DataKeyNames="outline_id" DataSourceID="sqlCourses" CommandItemDisplay="Top" EditMode="Batch" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="true" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="true" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel" >
            <NoRecordsTemplate>
                <p>No records to display</p>
            </NoRecordsTemplate>
            <BatchEditingSettings EditType="Cell" />
            <Columns>
                <telerik:GridTemplateColumn DataField="isBasicMilitaryTraining" DataType="System.Boolean" HeaderText="Basic Military Training" UniqueName="isBasicMilitaryTraining" HeaderStyle-Width="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:CheckBox runat="server" ID="CheckBox1" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("isBasicMilitaryTraining")) %>' onclick="checkBoxClick(this, event);" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:CheckBox runat="server" ID="CheckBox2" />
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject_id" UniqueName="subject_id" SortExpression="subject_id" HeaderText="Subject" DataField="subject_id" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="100px" ReadOnly="true">
                    <FilterTemplate>
                        <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                            DataValueField="subject_id" MaxHeight="200px" Width="90px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject_id").CurrentFilterValue %>'
                            runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="All" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                            <script type="text/javascript">
                                function SubjectIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("subject_id", args.get_item().get_value(), "EqualTo");
                                    }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridDropDownColumn>
                <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="90px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="50px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" UniqueName="course_title" DataField="course_title" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px">
                </telerik:GridBoundColumn>
                <telerik:GridDropDownColumn DataSourceID="sqlUnits" ListTextField="unit" ListValueField="unit_id" UniqueName="unit_id" SortExpression="unit_id" HeaderText="Min Units" DataField="unit_id" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center">
                </telerik:GridDropDownColumn>
                <telerik:GridDropDownColumn DataSourceID="sqlUnits" ListTextField="unit" ListValueField="unit_id" UniqueName="Vunit_id" SortExpression="Vunit_id" HeaderText="Max Units" DataField="Vunit_id" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center">
                </telerik:GridDropDownColumn>           
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
    </telerik:RadAjaxPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        function checkBoxClick(sender, args) {
            var grid = $find("<%= rgBasicMilitaryTraining.ClientID %>");
            var masterTableView = grid.get_masterTableView();
            var batchEditingManager = grid.get_batchEditingManager();
            var parentCell = $telerik.$(sender).closest("td")[0];

            var initialValue = sender.checked;
            sender.checked = !sender.checked;

            batchEditingManager.changeCellValue(parentCell, initialValue);
        }
    </script>
</asp:Content>
