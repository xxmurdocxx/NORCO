<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AdoptArticulations.ascx.cs" Inherits="ems_app.UserControls.AdoptArticulations" %>
<%@ Register Src="~/UserControls/DisplayMessages.ascx" TagPrefix="uc" TagName="DisplayMessages" %>

<asp:HiddenField ID="hvUserName" runat="server" />
<asp:HiddenField ID="hvUserID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hvCollegeID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hvAppID" runat="server" />
<asp:HiddenField ID="hvUserStage" runat="server" />
<asp:HiddenField ID="hvUserStageOrder" runat="server" />
<asp:HiddenField ID="hvExcludeArticulationOverYears" runat="server" />
<asp:HiddenField ID="hvFirstStage" runat="server" />
<asp:HiddenField ID="hvLastStage" runat="server" />

<asp:HiddenField ID="hfAceID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfTeamRevd" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfCourseNumber" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfSubject" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfByCourseSubject" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfByACEID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfExcludeAdopted" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfExcludeDenied" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfExcludeArticulationOverYears" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfOnlyImplemented" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfBySubjectCourseCIDNumber" runat="server" ClientIDMode="Static" />

<telerik:RadWindowManager ID="RadWindowManagerAdopt" EnableViewState="false" runat="server"></telerik:RadWindowManager>
<uc:DisplayMessages id="DisplayMessagesControl" runat="server"></uc:DisplayMessages>
<asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
    <SelectParameters>
        <asp:Parameter Name="CollegeID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlAllSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s  order by s.subject">
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlOtherCollegeArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArticulationsToAdopt" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="CollegeID" Type="Int32" />
        <asp:Parameter Name="AceID" Type="String" ConvertEmptyStringToNull="false" />
        <asp:Parameter Name="TeamRevd" Type="String" ConvertEmptyStringToNull="false" />
        <asp:Parameter Name="CourseNumber" Type="String" ConvertEmptyStringToNull="false" />
        <asp:Parameter Name="Subject" Type="String" ConvertEmptyStringToNull="false" />
        <asp:Parameter Name="ByCourseSubject" Type="Boolean" />
        <asp:Parameter Name="ByACEID" Type="Boolean" />
        <asp:Parameter Name="ExcludeAdopted" Type="Boolean" />
        <asp:Parameter Name="ExcludeDenied" Type="Boolean" />
        <asp:Parameter Name="ExcludeArticulationOverYears" Type="Int32" />
        <asp:Parameter Name="OnlyImplemented" Type="Boolean" />
        <asp:Parameter Name="BySubjectCourseNumberorCIDNumber" Type="Boolean" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct r.RoleName from Stages s left outer join ROLES  r on s.RoleId = r.RoleID"></asp:SqlDataSource>
<div class="row">
    <div class="col-sm-6">
        <telerik:RadCheckBox ID="rchkExcludeAdopted" AutoPostBack="true" runat="server" CausesValidation="false"  Text=" Exclude existing articulations" OnCheckedChanged="rchkExcludeAdopted_CheckedChanged"></telerik:RadCheckBox>
        <telerik:RadCheckBox ID="rchkExcludeDenied" AutoPostBack="true" runat="server" CausesValidation="false"  Text=" Exclude denied articulations" OnCheckedChanged="rchkExcludeDenied_CheckedChanged"></telerik:RadCheckBox>
        <telerik:RadCheckBox ID="rchkOnlyImplemented" AutoPostBack="true" runat="server" CausesValidation="false"  Text=" Only Approved Articulations" OnCheckedChanged="rchkOnlyImplemented_CheckedChanged" Checked="true"></telerik:RadCheckBox>
        <telerik:RadCheckBox ID="rchkSubjectCourseCIDNumber" AutoPostBack="true" runat="server" CausesValidation="false"  Text=" By CID Number" OnCheckedChanged="rchkSubjectCourseCIDNumber_CheckedChanged"></telerik:RadCheckBox>
    </div>
    <div class="col-sm-6">
        <div class="AdoptLegend">
            <div class="AdoptLegendColorBox LightBlue"></div> <div class="AdoptLegendText">&nbsp;Articulation(s) already exists </div>
            <div class="AdoptLegendColorBox LightGreen"></div><div class="AdoptLegendText">&nbsp;Articulation(s) ready to adopt</div>
            <div class="AdoptLegendColorBox LightPink"></div><div class="AdoptLegendText">&nbsp;Denied Articulation(s)</div>
        </div>
    </div>
</div>

<div style="clear:both;"></div>
<telerik:RadWindowManager ID="RadWindowManagerAdp" EnableViewState="false" runat="server" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
<telerik:RadGrid ID="rgOtherCollegeArticulations" runat="server" AllowFilteringByColumn="true" AllowPaging="true" PageSize="50" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOtherCollegeArticulations" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" AllowMultiRowSelection="true" OnItemCommand="rgOtherCollegeArticulations_ItemCommand" OnItemDataBound="rgOtherCollegeArticulations_ItemDataBound" MasterTableView-NoMasterRecordsText="There are no articulations ready to adopt from other colleges." Height="620px" >
    <GroupingSettings CaseSensitive="false" />
    <ClientSettings AllowColumnsReorder="true">
        <Selecting AllowRowSelect="True" EnableDragToSelectRows="true" />
        <ClientEvents OnRowContextMenu="GridRowClickEventHandler" OnFilterMenuShowing="FilteringMenu" />
        <Scrolling AllowScroll="true" UseStaticHeaders="true" />
    </ClientSettings>
    <MasterTableView Name="ParentGrid" DataKeyNames="AceID,TeamRevd" DataSourceID="sqlOtherCollegeArticulations" CommandItemDisplay="Top" AlternateRowColor=true AlternatingItemStyle-BackColor="#CFD8DC" >
        <CommandItemTemplate>
            <div class="commandItems">
                <telerik:RadButton runat="server" ID="btnAddOccupation" ToolTip="Check to adopt selected articulations." CommandName="Adopt" Text=" Adopt selected articulations" ButtonType="LinkButton">
                    <ContentTemplate>
                        <i class="fa fa-clone"></i> Adopt selected articulations
                    </ContentTemplate>
                </telerik:RadButton>
                <telerik:RadButton runat="server" ID="btnView" ToolTip="Check to view selected articulation." CommandName="View" Text=" View selected articulations" ButtonType="LinkButton">
                    <ContentTemplate>
                        <i class="fa fa-eye"></i> View selected articulation
                    </ContentTemplate>
                </telerik:RadButton>
                <telerik:RadButton runat="server" ID="btnDocuments" ToolTip="Check to view selected articulation documents." CommandName="ViewDocuments" Text=" View selected articulation Documents" ButtonType="LinkButton" Visible="false">
                    <ContentTemplate>
                        <i class="fa fa-file-text"></i> View selected articulation Documents
                    </ContentTemplate>
                </telerik:RadButton>                
            </div>
        </CommandItemTemplate>
        <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
        <GroupByExpressions>
            <telerik:GridGroupByExpression>
                <SelectFields>
                    <telerik:GridGroupByField FieldAlias="SelectedCriteria" FieldName="SelectedCriteria"></telerik:GridGroupByField>
                </SelectFields>
                <GroupByFields>
                    <telerik:GridGroupByField FieldName="SelectedCriteria" SortOrder="Descending"></telerik:GridGroupByField>
                </GroupByFields>
            </telerik:GridGroupByExpression>
        </GroupByExpressions>
        <Columns>
            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                <ItemTemplate>
                    <div class="d-flex align-items-center gap-3">
                    <div class="mr-2"><asp:Label runat="server" ID="lblLegend" Width="16px" Height="16px"></asp:Label></div>                  
                    </div>
                </ItemTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Visible="false">
                <ItemTemplate>
                    <asp:LinkButton runat="server" ToolTip="View Articulation Details" CommandName="View" ID="ViewArticulation" Text='<i class="fa fa-eye fa-lg" aria-hidden="true"></i>' />
                </ItemTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridBoundColumn DataField="Document" UniqueName="Document" Display="false"></telerik:GridBoundColumn>
            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Visible="false">
                <ItemTemplate>
                    <asp:LinkButton Visible="false" runat="server" ToolTip="Uploaded Articulation Documents" CommandName="ViewDocuments" ID="btnDocuments" Text='<i class="fa fa-file-text fa-lg" aria-hidden="true"></i>' />
                </ItemTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn" HeaderStyle-Width="30px">
            </telerik:GridClientSelectColumn>
            <telerik:GridBoundColumn SortExpression="College" HeaderText="College" DataField="College" UniqueName="College" HeaderStyle-Font-Bold="true" AllowFiltering="false" HeaderStyle-Width="90px">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="TypeDescription" HeaderText="Type" DataField="TypeDescription" UniqueName="TypeDescription" HeaderStyle-Font-Bold="true" AllowFiltering="false" HeaderStyle-Width="70px">
            </telerik:GridBoundColumn>
            <telerik:GridDropDownColumn DataSourceID="sqlRoles" ListTextField="RoleName" ListValueField="RoleName" UniqueName="RoleName" SortExpression="RoleName" HeaderText="Role" DataField="RoleName" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="90px" HeaderStyle-Font-Bold="true">
                <FilterTemplate>
                    <telerik:RadComboBox ID="RadComboBoxRoles" DataSourceID="sqlRoles" DataTextField="RoleName" DropDownAutoWidth="Enabled"
                        DataValueField="RoleName" MaxHeight="200px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("RoleName").CurrentFilterValue %>'
                        runat="server" OnClientSelectedIndexChanged="RoleNameIndexChanged">
                        <Items>
                            <telerik:RadComboBoxItem Text="All" />
                        </Items>
                    </telerik:RadComboBox>
                    <telerik:RadScriptBlock ID="RadScriptBlock663" runat="server">
                        <script type="text/javascript">
                            function RoleNameIndexChanged(sender, args) {
                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                tableView.filter("RoleName", args.get_item().get_value(), "Contains");
                            }
                        </script>
                    </telerik:RadScriptBlock>
                </FilterTemplate>
            </telerik:GridDropDownColumn>
<%--            <telerik:GridDropDownColumn DataSourceID="sqlAllSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject_filter" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="false" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="50px" HeaderStyle-Font-Bold="true">
                <FilterTemplate>
                    <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlAllSubjects" DataTextField="subject" DropDownAutoWidth="Enabled"
                        DataValueField="subject" MaxHeight="200px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                        runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged22">
                        <Items>
                            <telerik:RadComboBoxItem Text="All" />
                        </Items>
                    </telerik:RadComboBox>
                    <telerik:RadScriptBlock ID="RadScriptBlock443" runat="server">
                        <script type="text/javascript">
                            function SubjectIndexChanged22(sender, args) {
                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                            }
                        </script>
                    </telerik:RadScriptBlock>
                </FilterTemplate>
            </telerik:GridDropDownColumn>--%>
            <telerik:GridBoundColumn DataField="subject" UniqueName="subject_filter" HeaderText="Subject" HeaderStyle-Width="90px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="90px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" HeaderStyle-Font-Bold="true" HeaderStyle-Width="120px">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="CIDNumber" HeaderText="CID Number" DataField="CIDNumber" UniqueName="CIDNumber" HeaderStyle-Font-Bold="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="Descriptor" HeaderText="CID Descriptor" DataField="Descriptor" UniqueName="Descriptor" HeaderStyle-Font-Bold="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="CourseCollege" UniqueName="CourseCollege" HeaderText="College Course" HeaderStyle-Width="90px" FilterControlWidth="70px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="true" HeaderStyle-Font-Bold="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="TopCode" HeaderText="Top Code" DataField="TopCode" UniqueName="TopCode" HeaderStyle-Font-Bold="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" HeaderStyle-Width="100px">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="true" HeaderStyle-Width="80px" FilterControlWidth="40px">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="AceID" HeaderStyle-Width="110px" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="Exhibit" HeaderStyle-Width="110px" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" HeaderStyle-Font-Bold="true" Display="false" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Font-Bold="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" HeaderStyle-Width="110px">
            </telerik:GridBoundColumn>

            <telerik:GridBoundColumn SortExpression="SelectedCriteria" HeaderText="Credit Recommendation" DataField="SelectedCriteria" UniqueName="SelectedCriteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridDateTimeColumn DataField="LastSubmittedOn" DataType="System.DateTime" FilterControlAltText="Filter LastSubmittedOn column" HeaderText="Submitted" SortExpression="LastSubmittedOn" UniqueName="LastSubmittedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px"  HeaderStyle-Font-Bold="true" ShowFilterIcon="true" CurrentFilterFunction="EqualTo" EnableTimeIndependentFiltering="true">
                <ItemStyle HorizontalAlign="Center" />
            </telerik:GridDateTimeColumn>
            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="CollegeID" UniqueName="CollegeID" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="subject" UniqueName="subject" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="adopted" UniqueName="adopted" Display="false">
            </telerik:GridBoundColumn>
        </Columns>
    </MasterTableView>
</telerik:RadGrid>
 
<input type="hidden" id="hvOutlineID" name="hvOutlineID" runat="server"  />
<input type="hidden" id="hvID" name="hvID" runat="server" />
<input type="hidden" id="hvArticulationID" name="hvArticulationID" runat="server" />
<input type="hidden" id="hvArticulationType" name="hvArticulationType" runat="server" />
<input type="hidden" id="hvArticulationStage" name="hvArticulationStage" runat="server" />
<input type="hidden" id="hvAceID" name="hvAceID" runat="server" />
<input type="hidden" id="hvTeamRevd" name="hvTeamRevd" runat="server" />
<input type="hidden" id="hvTitle" name="hvTitle" runat="server" />

<telerik:RadContextMenu ID="rcmAdoptArticulations" runat="server" OnItemClick="rcmAdoptArticulations_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
    <Items>
        <telerik:RadMenuItem Text="Adopt" Value="Adopt">
        </telerik:RadMenuItem>
        <telerik:RadMenuItem Text="View Articulation" Value="View">
        </telerik:RadMenuItem>
        <telerik:RadMenuItem Text="View Documents" Value="ViewDocuments">
        </telerik:RadMenuItem>
    </Items>
</telerik:RadContextMenu>
<script type="text/javascript">
    function GridRowClickEventHandler(sender, args) {
        var menu = $find('<%= rcmAdoptArticulations.ClientID %>');

        var evt = args.get_domEvent();
        if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
            return;
        }

        var index = args.get_itemIndexHierarchical();

        sender.get_masterTableView().selectItem(sender.get_masterTableView().get_dataItems()[index].get_element(), true);

        var selectedRow = sender.get_masterTableView().get_selectedItems()[0];

        var outline_id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "outline_id").innerHTML;
        var id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "id").innerHTML;
        var articulation_id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "ArticulationID").innerHTML;
        var articulation_type = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "ArticulationType").innerHTML;
        var articulation_stage = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "ArticulationStage").innerHTML;
        var ace_id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "AceID").innerHTML;
        var team_revd = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "TeamRevd").innerHTML;
        var title = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "Title").innerHTML;

        document.getElementById("<%= hvID.ClientID %>").value = id;
        document.getElementById("<%= hvArticulationID.ClientID %>").value = articulation_id;
        document.getElementById("<%= hvArticulationType.ClientID %>").value = articulation_type;
        document.getElementById("<%= hvArticulationStage.ClientID %>").value = articulation_stage;
        document.getElementById("<%= hvAceID.ClientID %>").value = ace_id;
        document.getElementById("<%= hvTeamRevd.ClientID %>").value = team_revd;
        document.getElementById("<%= hvTitle.ClientID %>").value = title;

        menu.show(evt);
        evt.cancelBubble = true;
        evt.returnValue = false;

        if (evt.stopPropagation) {
            evt.stopPropagation();
            evt.preventDefault();
        }
    }
</script>
