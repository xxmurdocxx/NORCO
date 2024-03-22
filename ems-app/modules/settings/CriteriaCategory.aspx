<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="CriteriaCategory.aspx.cs" Inherits="ems_app.modules.settings.CriteriaCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" runat="server">Credit Recommendations</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlTopsCode" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM tblTOPSCodeLookup order by TopsCodeDescription" SelectCommandType="Text"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlTopsCode4Digit" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from TopCodeCategory4Digit order by description" SelectCommandType="Text"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlTopsCode2Digit" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from TopCodeCategory order by description" SelectCommandType="Text"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="spCriteriaCategoryList" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="CriteriaDescription" Type="String" />
            <asp:Parameter Name="DoNotArticulate" Type="Boolean" />
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="topscode_id" Type="Int32" />
            <asp:Parameter Name="UniformCreditRecommendation" Type="String" DefaultValue="" />
            <asp:Parameter Name="Units" Type="String" DefaultValue="" />
            <asp:Parameter Name="SourceID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadWindowManager ID="RadWindowManager1" RenderMode="Lightweight" ShowContentDuringLoad="true" runat="server" EnableViewState="false"></telerik:RadWindowManager>
        <div class="row d-flex justify-content-end mb-2">
            <asp:Label runat="server" ID="lblRelated" Text="<i class='fa fa-commenting fa-lg'></i> Related Competencies / Learning Outcomes." Width="350px" />
            <asp:Label runat="server" Text="<i class='fa fa-copy fa-lg'></i> Related Courses." Width="300px" />
        </div>
        <div class="mt-1">
            <telerik:RadGrid ID="rgCriteriaCategory" runat="server" CellSpacing="-1" DataSourceID="sqlCriteria" Width="100%" AllowAutomaticUpdates="true" PageSize="50" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" OnItemDataBound="rgCriteriaCategory_ItemDataBound" OnBatchEditCommand="rgCriteriaCategory_BatchEditCommand" Height="820px" AllowAutomaticInserts="true">
                <GroupingSettings CaseSensitive="false" />
                <ExportSettings IgnorePaging="true" ExportOnlyData="true">
                </ExportSettings>
                <ClientSettings AllowKeyboardNavigation="true">
                    <Scrolling AllowScroll="true" UseStaticHeaders="true" />
                    <ClientEvents OnFilterMenuShowing="FilteringMenu" />
                </ClientSettings>
                <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlCriteria" CommandItemDisplay="Top" EditMode="Batch" PageSize="20" CommandItemSettings-ShowAddNewRecordButton="true" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="true" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel" EditFormSettings-EditColumn-Resizable="true">
                    <NoRecordsTemplate>
                        <p>No records to display</p>
                    </NoRecordsTemplate>
                    <BatchEditingSettings EditType="Cell" />
                    <Columns>
                        <telerik:GridBoundColumn DataField="CriteriaDescription" UniqueName="CriteriaDescription" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="SourceName" UniqueName="SourceName" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn SortExpression="UniformCreditRecommendation" HeaderText="MAP Uniform Credit Recommendations" DataField="UniformCreditRecommendation" UniqueName="UniformCreditRecommendation" AllowFiltering="True" HeaderStyle-Width="280px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn SortExpression="CriteriaDescription" HeaderText="Uniform Credit Recommendations" DataField="CriteriaDescription" UniqueName="_CriteriaDescription" AllowFiltering="True" ReadOnly="false" HeaderStyle-Width="280px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="LearningOutcome" UniqueName="LearningOutcome" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn AllowFiltering="false" EnableHeaderContextMenu="false" HeaderStyle-Width="30px">
                            <ItemTemplate>
                                <asp:Label runat="server" ToolTip="Related Competencies / Student Learning Outcomes" ID="lblRelatedCompetencies" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                <telerik:RadToolTip RenderMode="Lightweight" ID="rttRelatedCompetencies" runat="server" TargetControlID="lblRelatedCompetencies" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                                    <%# DataBinder.Eval(Container, "DataItem.LearningOutcome") %>
                                </telerik:RadToolTip>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn SortExpression="Units" HeaderText="Units" DataField="Units" UniqueName="Units" AllowFiltering="True" ReadOnly="false" HeaderStyle-Width="80px" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        </telerik:GridBoundColumn>
                        <telerik:GridDropDownColumn DataField="topscode_id" FilterControlAltText="Filter topscode_id column" HeaderText="Taxonomy of Programs (TOP) Code" SortExpression="TopsCodeDescription" UniqueName="topscode_id" DataSourceID="sqlTopsCode" ListTextField="TopsCodeDescription" ListValueField="topscode_id" HeaderStyle-Width="300px" AllowFiltering="true" EnableHeaderContextMenu="false" HeaderStyle-Font-Bold="true" ConvertEmptyStringToNull="true" EnableEmptyListItem="true" DropDownControlType="RadComboBox">
                            <FilterTemplate>
                                <telerik:RadComboBox ID="RadComboBoxTopsCode" DataSourceID="sqlTopsCode" DataTextField="TopsCodeDescription"
                                    DataValueField="topscode_id" MaxHeight="200px" Width="250px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("topscode_id").CurrentFilterValue %>'
                                    runat="server" MarkFirstMatch="true" Filter="Contains" OnClientSelectedIndexChanged="TopsCodeIndexChanged" DropDownAutoWidth="Enabled">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="All" />
                                    </Items>
                                </telerik:RadComboBox>
                                <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                    <script type="text/javascript">
                                        function TopsCodeIndexChanged(sender, args) {
                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                            tableView.filter("topscode_id", args.get_item().get_value(), "EqualTo");
                                        }
                                    </script>
                                </telerik:RadScriptBlock>
                            </FilterTemplate>
                        </telerik:GridDropDownColumn>
                        <telerik:GridDropDownColumn DataField="CategoryID4Digit" FilterControlAltText="Filter CategoryID4Digit column" HeaderText="(TOP) Code 4 Digits" SortExpression="Description" UniqueName="CategoryID4Digit" DataSourceID="sqlTopsCode4Digit" ListTextField="Description" ListValueField="Code" HeaderStyle-Width="170px" AllowFiltering="true" EnableHeaderContextMenu="false" HeaderStyle-Font-Bold="true" ConvertEmptyStringToNull="true" EnableEmptyListItem="true" DropDownControlType="RadComboBox" ReadOnly="false">
                            <FilterTemplate>
                                <telerik:RadComboBox ID="RadComboBoxTopsCode4Digit" DataSourceID="sqlTopsCode4Digit" DataTextField="Description"
                                    DataValueField="Code" MaxHeight="200px" Width="150px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("CategoryID4Digit").CurrentFilterValue %>'
                                    runat="server" MarkFirstMatch="true" Filter="Contains" OnClientSelectedIndexChanged="TopsCode4DigitIndexChanged" DropDownAutoWidth="Enabled">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="All" />
                                    </Items>
                                </telerik:RadComboBox>
                                <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                    <script type="text/javascript">
                                        function TopsCode4DigitIndexChanged(sender, args) {
                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                            tableView.filter("CategoryID4Digit", args.get_item().get_value(), "EqualTo");
                                        }
                                    </script>
                                </telerik:RadScriptBlock>
                            </FilterTemplate>
                        </telerik:GridDropDownColumn>
                        <telerik:GridDropDownColumn DataField="CategoryID" FilterControlAltText="Filter CategoryID column" HeaderText="(TOP) Code 2 Digits" SortExpression="Description" UniqueName="CategoryID" DataSourceID="sqlTopsCode2Digit" ListTextField="Description" ListValueField="Code" HeaderStyle-Width="170px" AllowFiltering="true" EnableHeaderContextMenu="false" HeaderStyle-Font-Bold="true" ConvertEmptyStringToNull="true" EnableEmptyListItem="true" DropDownControlType="RadComboBox" ReadOnly="false">
                            <FilterTemplate>
                                <telerik:RadComboBox ID="RadComboBoxTopsCode2Digit" DataSourceID="sqlTopsCode2Digit" DataTextField="Description"
                                    DataValueField="Code" MaxHeight="200px" Width="150px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("CategoryID").CurrentFilterValue %>'
                                    runat="server" MarkFirstMatch="true" Filter="Contains" OnClientSelectedIndexChanged="TopsCodeIndexChanged2Digit" DropDownAutoWidth="Enabled">
                                    <Items>
                                        <telerik:RadComboBoxItem Text="All" />
                                    </Items>
                                </telerik:RadComboBox>
                                <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                                    <script type="text/javascript">
                                        function TopsCodeIndexChanged2Digit(sender, args) {
                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                            tableView.filter("CategoryID", args.get_item().get_value(), "EqualTo");
                                        }
                                    </script>
                                </telerik:RadScriptBlock>
                            </FilterTemplate>
                        </telerik:GridDropDownColumn>
                        <telerik:GridBoundColumn DataField="CourseList" UniqueName="CourseList" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn AllowFiltering="false" EnableHeaderContextMenu="false" HeaderStyle-Width="30px">
                            <ItemTemplate>
                                <asp:Label runat="server" ToolTip="Related Courses" ID="lblRelatedCourses" Visible="false" Text="<i class='fa fa-copy fa-lg'></i>" />
                                <telerik:RadToolTip RenderMode="Lightweight" ID="rttRelatedCourses" runat="server" TargetControlID="lblRelatedCourses" Width="550px" Height="650px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip" ContentScrolling="Auto" CssClass="align-items-start">
                                    <%# DataBinder.Eval(Container, "DataItem.CourseList") %>
                                </telerik:RadToolTip>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn SortExpression="RecordCount" HeaderText="# of Occurrences" DataField="RecordCount" UniqueName="RecordCount" AllowFiltering="True" ReadOnly="true" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn DataField="DoNotArticulate" DataType="System.Boolean" HeaderText="Exclude Credit Recommendations" UniqueName="DoNotArticulate" HeaderStyle-Width="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                            <ItemTemplate>
                                <asp:CheckBox runat="server" ID="CheckBox1" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("DoNotArticulate")) %>' onclick="checkBoxClick(this, event);" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox runat="server" ID="CheckBox2" />
                            </EditItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridDropDownColumn DataField="SourceID" FilterControlAltText="Filter SourceID column" HeaderText="Source" SortExpression="SourceID" UniqueName="SourceID" DataSourceID="sqlSource" ListTextField="SourceName" ListValueField="Id" HeaderStyle-Width="140px" AllowFiltering="true" EnableHeaderContextMenu="false" HeaderStyle-Font-Bold="true">
                        </telerik:GridDropDownColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
        </div>
        <asp:SqlDataSource ID="sqlSource" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="SELECT * FROM AceExhibitSource"></asp:SqlDataSource>
    </telerik:RadAjaxPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        function checkBoxClick(sender, args) {
            var grid = $find("<%= rgCriteriaCategory.ClientID %>");
            var masterTableView = grid.get_masterTableView();
            var batchEditingManager = grid.get_batchEditingManager();
            var parentCell = $telerik.$(sender).closest("td")[0];

            var initialValue = sender.checked;
            sender.checked = !sender.checked;

            batchEditingManager.changeCellValue(parentCell, initialValue);
        }
    </script>
</asp:Content>
