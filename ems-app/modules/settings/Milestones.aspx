<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/publicTemplate.Master" AutoEventWireup="true" CodeBehind="Milestones.aspx.cs" Inherits="ems_app.modules.settings.Milestones" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" id="SystemTitle" runat="server">Milestones</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
            <telerik:RadWindowManager ID="RadWindowManager1" EnableViewState="false" runat="server" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>

            <div class="row" style="padding: 10px;">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <asp:HiddenField ID="hvCollegeID" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hvIsAdmin" runat="server" />

                    <asp:SqlDataSource ID="sqlMilestones" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetMilestones" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="hvCollegeID" DefaultValue="0" Name="college_id" PropertyName="Value" Type="Int32" />
                            <asp:ControlParameter ControlID="hvIsAdmin" DefaultValue="0" Name="is_admin" PropertyName="Value" Type="Byte" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="sqlMilestonesCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from MAPMilestonesCriteria mc where mc.ParentMilestoneId = @ParentMilestoneId order by description" UpdateCommand="UPDATE [MAPMilestonesCriteria] SET [Met] = @Met, [Stakeholder] = @Stakeholder WHERE [Id] = @id">
                        <SelectParameters>
                            <asp:Parameter Name="ParentMilestoneId" Type="Int32" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Stakeholder" Type="String" />
                            <asp:Parameter Name="Met" Type="Boolean" />
                            <asp:Parameter Name="Id" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                    <telerik:RadGrid ID="rgMilestones" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="sqlMilestones" GroupPanelPosition="Top"  RenderMode="Lightweight" OnItemUpdated="rgMilestones_ItemUpdated" Skin="MetroTouch">
                        <MasterTableView CommandItemDisplay="None" DataKeyNames="id" DataSourceID="sqlMilestones" CommandItemSettings-ShowAddNewRecordButton="false" AllowAutomaticUpdates="true">
                            <GroupByExpressions>
                                <telerik:GridGroupByExpression>
                                    <SelectFields>
                                        <telerik:GridGroupByField FieldAlias="College" FieldName="College"></telerik:GridGroupByField>
                                    </SelectFields>
                                    <GroupByFields>
                                        <telerik:GridGroupByField FieldName="College"></telerik:GridGroupByField>
                                    </GroupByFields>
                                </telerik:GridGroupByExpression>
                            </GroupByExpressions>
                            <DetailTables>
                                <telerik:GridTableView Name="ChildGrid" DataKeyNames="Id" DataSourceID="sqlMilestonesCriteria" Width="100%" AllowMultiColumnSorting="true" runat="server" CommandItemDisplay="Top" AllowFilteringByColumn="false" CommandItemSettings-ShowAddNewRecordButton="false" HeaderStyle-Font-Bold="true" EditMode="Batch" AllowAutomaticUpdates="True"  ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
                                    <BatchEditingSettings EditType="Cell" />
                                    <ParentTableRelation>
                                        <telerik:GridRelationFields DetailKeyField="ParentMilestoneId" MasterKeyField="id"></telerik:GridRelationFields>
                                    </ParentTableRelation>
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="Id" FilterControlAltText="Filter Id column" HeaderText="Id" SortExpression="Id" UniqueName="Id" DataType="System.Int32" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Description" FilterControlAltText="Filter Description column" HeaderText="Credit Recommendation" SortExpression="Description" UniqueName="Description" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Stakeholder" FilterControlAltText="Filter Stakeholder column" HeaderText="Stakeholder" SortExpression="Stakeholder" UniqueName="Stakeholder" HeaderStyle-Font-Bold="true" HeaderStyle-Width="210px">
                                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                                <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic">
                                                </RequiredFieldValidator>
                                            </ColumnValidationSettings>
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn DataField="Met" DataType="System.Boolean" HeaderText="Met" UniqueName="Met" HeaderStyle-Width="110px" ItemStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="CheckBox1" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("Met")) %>' onclick="checkBoxClick(this, event);" />
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:CheckBox runat="server" ID="CheckBox2" />
                                            </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                    </Columns>
                                </telerik:GridTableView>
                            </DetailTables>
                            <Columns>
                                <telerik:GridBoundColumn DataField="ID" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" DataType="System.Int32" ReadOnly="True" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="College" FilterControlAltText="Filter College column" HeaderText="College" SortExpression="College" UniqueName="College" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Milestone" FilterControlAltText="Filter Milestone column" HeaderText="Milestone" SortExpression="Milestone" UniqueName="Milestone" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Stakeholder" FilterControlAltText="Filter Stakeholder column" HeaderText="Stakeholder" SortExpression="Stakeholder" UniqueName="Stakeholder" HeaderStyle-Font-Bold="true" HeaderStyle-Width="210px">
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="StartDate" DataType="System.DateTime" FilterControlAltText="Filter StartDate column" HeaderText="Start Date" SortExpression="StartDate" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridDateTimeColumn DataField="EndDate" DataType="System.DateTime" FilterControlAltText="Filter EndDate column" HeaderText="End Date" SortExpression="EndDate" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn DataField="PercentComplete" FilterControlAltText="Filter PercentComplete column" HeaderText="Percent Complete" SortExpression="PercentComplete" UniqueName="PercentComplete" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>


                </div>
            </div>

        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        function checkBoxClick(sender, args) {
            var grid = $find("<%= rgMilestones.ClientID %>");
            var masterTableView = grid.get_masterTableView();
            var batchEditingManager = grid.get_batchEditingManager();
            var parentCell = $telerik.$(sender).closest("td")[0];

            var initialValue = sender.checked;
            sender.checked = !sender.checked;

            batchEditingManager.changeCellValue(parentCell, initialValue);
        }
    </script>
    <script type="text/javascript">
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
    </script>
</asp:Content>
