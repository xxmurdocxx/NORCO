<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreditRecommendationsMultiple.aspx.cs" Inherits="ems_app.modules.popups.CreditRecommendationsMultiple" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Create Multiple Articulation</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous" />
    <!-- Font Awesome -->
    <script src="https://use.fontawesome.com/6c4529ef90.js"></script>
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
    <style>
        .criteria-body {
            position: relative;
            height: 400px;
            overflow: auto;
        }

        html .RadUpload_Material .ruSelectWrap .ruBrowse {
            height: 20px !important;
        }

        .RadWindow_Material .rwContent {
            overflow: hidden !important;
        }

        .advancedSearchContainer {
            background-color: #f1f1f1;
        }

        .table caption {
            caption-side: top;
            font-weight: bold;
        }

        .ruBrowse::before {
            content: "\e133" !important;
            font: 16px/1 "WebComponentsIcons" !important;
            vertical-align: -2px;
        }

        .RadButton,
        .RadAsyncUpload {
            display: inline-block;
        }
        .alert {
            margin:5px 0;
        }
        .badge-secondary {
            font-size:11px !important;
            font-weight:normal !important;
        }

        .RadGrid .rgHeader input[type="checkbox"]:first-child {
            display: none;
        }
/*        .RadGrid .rgDetailTable thead {
            position: fixed;
            top: 120px;
        }

        .RadGrid .rgDetailTable tbody {
            border: 1px solid red;
            padding-top: 500px;
        }


        #rgCreditRecommendations_ctl00__0 {
            position: fixed;
            width: 64%;
            background-color: white;
        }

        #rgCreditRecommendations_ctl00__0 .myClass {
            width: 90%;
        }

        .RadGrid .rgDetailTable thead tr th:nth-child(17) {
            width:320px;
        }
        .RadGrid_Material .rgDetailTable {
            margin:70px 0 !important;
        }*/
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
                <asp:HiddenField ID="hfAdvancedSarch" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfACECourseAdvancedSearch" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfSelectedCourse" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfSelectedCondition" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfCreditRecommendationsCount" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfSelectedCriteria" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfExcludeArticulationOverYears" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfUnits" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hfUnitsID" runat="server" ClientIDMode="Static" />
                
                <asp:Panel ID="pnlCriteriaPackage" runat="server" class="row p-2 alert alert-info alert-dismissible fade show" role="alert">
                    <div class="row">
                        <div class="col-10">
                            <p id="ArticulationTitle" runat="server"></p>
                        </div>
                        <div class="col-1">
                            <telerik:RadButton ID="rbEditCriteriaPackage" runat="server" Text="Edit" Width="80px" OnClick="rbEditCriteriaPackage_Click" CausesValidation="false" AutoPostBack="true" CssClass="m-3" Visible="false"></telerik:RadButton>
                        </div>
                        <div class="col-1">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </div>
                </asp:Panel>
                <div class="row">
                    <div class="col-sm-4">
                        <div id="pnlSelectCourse" runat="server">
                            <telerik:RadComboBox ID="rcbCourses" DataSourceID="sqlCourses" DataTextField="CourseDescription" DataValueField="outline_id" MaxHeight="200px" Width="100%" EmptyMessage="Select College Course..." AllowCustomText="false" ToolTip="Search for a college course (i.e. BUS 10) " runat="server" MarkFirstMatch="true" Filter="Contains" DropDownAutoWidth="Enabled" Label="Course : " AutoPostBack="true" Font-Bold="true" OnSelectedIndexChanged="rcbCourses_SelectedIndexChanged" BackColor="#ffffe0" AppendDataBoundItems="true">
                                <Items>
                                    <telerik:RadComboBoxItem Text="" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                            <asp:Panel ID="pnlDisclaimer" runat="server" Width="100%" CssClass="alert alert-warning" Text="" Visible="false" ClientIDMode="Static">
                                <i class='fa fa-exclamation-triangle' aria-hidden='true'></i> Area credits must be configured by your MAP Ambassador within the Ambassador's Module. 
                            </asp:Panel>
                            <asp:SqlDataSource runat="server" ID="sqlCourses" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="sp_SearchCourses" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                                    <asp:Parameter Name="CourseType" DbType="Int32" DefaultValue="1" />
                                    <asp:Parameter Name="All" DbType="Int32" DefaultValue="0" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:RequiredFieldValidator runat="server" CssClass="alert alert-warning" ControlToValidate="rcbCourses" ErrorMessage="Please select a course." Display="Dynamic" ValidationGroup="CriteriaValidation" EnableClientScript="true" />
                        </div>
                        <asp:SqlDataSource ID="sqlCoursesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter Name="outline_id" ControlID="rcbCourses" PropertyName="SelectedValue" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <!-- Unit List Using College ID = 1 Norco by default -->
                        <asp:SqlDataSource ID="sqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT unit_id,unit FROM tblLookupUnits WHERE college_id = 1 AND CAST(unit AS float) <= @Units and unit_id <> 33 ORDER BY CAST(unit AS float) DESC" SelectCommandType="Text">
                        <SelectParameters>
                            <%--<asp:ControlParameter Name="CollegeID" ControlID="hfCollegeID" PropertyName="value" Type="Int32" />--%>
                            <asp:ControlParameter Name="Units" ControlID="hfUnits" PropertyName="value" Type="Double" />
                        </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:Repeater ID="rptCourseDetails" runat="server" DataSourceID="sqlCoursesDetails" OnItemDataBound="rptCourseDetails_ItemDataBound">
                            <ItemTemplate>
                                <div class="row">
                                    <div class="col-3"><b>Course :</b></div>
                                    <div class="col-9"><%# String.Concat(Eval("_Subject"), " ", Eval("_CourseNumber")) %></div>
                                    <div class="col-3"><b>Title :</b></div>
                                    <div class="col-9"><%# Eval("_CourseTitle") %></div>
                                    <div class="col-3"><b>Units :</b></div>
                                    <div class="col-9">
                                        <telerik:RadComboBox ID="rbcUnits" DataSourceID="sqlUnits" DataTextField="unit" DataValueField="unit_id" Width="100%" ToolTip="Search units" runat="server" MarkFirstMatch="true" OnSelectedIndexChanged="rbcUnits_SelectedIndexChanged" >
                                        </telerik:RadComboBox>
                                    </div>
                                    <div class="col-3"><b>Division :</b></div>
                                    <div class="col-9"><%# Eval("_Division") %></div>
                                    <div class="col-12"><b>Catalog Description :</b></div>
                                    <div class="col-12"><%# Eval("_CatalogDescription") %></div>
                                    <div class="col-12"><b>Taxonomy of Program Code (TOP CODE) :</b></div>
                                    <div class="col-12"><%# Eval("_TopsCode") %></div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                            </FooterTemplate>
                        </asp:Repeater>
                        <telerik:RadGrid ID="rgCourses" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" Culture="es-ES" EnableHeaderContextMenu="False" Width="100%" AllowFilteringByColumn="False" GroupingSettings-CaseSensitive="false" MasterTableView-GroupLoadMode="Client" DataSourceID="sqlCoursesSLOs" Skin="Material" GroupHeaderItemStyle-Font-Bold="true">
                            <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                            <ClientSettings EnableAlternatingItems="false">
                            </ClientSettings>
                            <MasterTableView DataKeyNames="outline_id" DataSourceID="sqlCoursesSLOs" NoMasterRecordsText="There are no records to display.">
                                <NoRecordsTemplate>
                                    <div>
                                        There are no records to display.
                                    </div>
                                </NoRecordsTemplate>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="slodescription" HeaderText="Student Learning Outcomes" SortExpression="slodescription" UniqueName="slodescription" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                        <asp:SqlDataSource runat="server" ID="sqlCoursesSLOs" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="GetCourseSLOs" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter Name="OutlineIDs" ControlID="rcbCourses" PropertyName="SelectedValue" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <div class="col-sm-8">
                        <div class="d-none" style="display: none;">
                            <asp:TextBox ID="tbSelectedItems" runat="server" ClientIDMode="Static" Text="0" />
                        </div>
                        <div class="row">
                            <div class="col-8">
                                <asp:RangeValidator ID="rvSelectedItems" ControlToValidate="tbSelectedItems" MinimumValue="1" MaximumValue="2147483647" Type="Integer" Text="Please select at least an Exhibit per Credit Recommendation(s)" runat="server" CssClass="alert alert-danger" ErrorMessage="Please select a Recommendation Criteria" Display="Dynamic" ValidationGroup="CriteriaValidation" EnableClientScript="true" />
                            </div>
                            <div class="col-4 d-flex justify-content-end">
                                <telerik:RadLabel ID="rlExclude" runat="server" Text="Exclude Exhibits over " Visible="false"></telerik:RadLabel>
                                <telerik:RadSwitch ID="rsExclude" runat="server" Width="65px" AutoPostBack="true" Checked="false" OnCheckedChanged="rsExclude_CheckedChanged" Visible="false">
                                    <ToggleStates>
                                        <ToggleStateOn Text="Yes" />
                                        <ToggleStateOff Text="No" />
                                    </ToggleStates>
                                </telerik:RadSwitch>
                            </div>
                        </div>
                        <telerik:RadLabel ID="rlSelectedCRiteria" Font-Bold="true" runat="server"></telerik:RadLabel>

                        <telerik:RadGrid ID="rgCreditRecommendations" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" Culture="es-ES" EnableHeaderContextMenu="False" Width="100%" AllowFilteringByColumn="True" GroupingSettings-CaseSensitive="false" MasterTableView-GroupLoadMode="Client" DataSourceID="sqlCriteriaGroup" Skin="Material" Height="510px" AllowMultiRowSelection="true" EnableHierarchyExpandAll="false" MasterTableView-HierarchyDefaultExpanded="true" OnItemDataBound="rgCreditRecommendations_ItemDataBound" OnPreRender="rgCreditRecommendations_PreRender" MasterTableView-ExpandCollapseColumn-Visible="false">
                            <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                            <ClientSettings EnableAlternatingItems="false" Scrolling-UseStaticHeaders="true">
                                <Selecting AllowRowSelect="true" EnableDragToSelectRows="true" UseClientSelectColumnOnly="true" />
                                <Scrolling AllowScroll="true" UseStaticHeaders="true" SaveScrollPosition="false" />
                                <ClientEvents OnGridCreated="GridCreated" OnRowClick="toggleSelection" OnRowDblClick="RowDblClickHighlightCriteria" OnRowSelected="RowSelected" OnRowDeselected="RowSelected" OnRowSelecting="RowSelecting"/>
                            </ClientSettings>
                          <MasterTableView Name="Master" DataKeyNames="Criteria" DataSourceID="sqlCriteriaGroup" HierarchyLoadMode="Client" CommandItemDisplay="None" AllowFilteringByColumn="false" ItemStyle-Font-Bold="true" AlternatingItemStyle-Font-Bold="true" HierarchyDefaultExpanded="true" >
                              <CommandItemSettings ShowExportToWordButton="False"
                                    ShowAddNewRecordButton="False" ShowRefreshButton="False" ShowExportToExcelButton="True" />
                                <DetailTables>
                                    <telerik:GridTableView Name="ChildGridDetails" DataKeyNames="Criteria" DataSourceID="sqlCriteriaDetails" Width="100%" runat="server" CommandItemDisplay="None" AllowFilteringByColumn="false" CommandItemSettings-ShowAddNewRecordButton="false" HeaderStyle-Font-Bold="true" AllowAutomaticUpdates="True" HierarchyLoadMode="Client" AllowSorting="true" AllowMultiColumnSorting="true" HierarchyDefaultExpanded="true">
                                        <ParentTableRelation>
                                            <telerik:GridRelationFields DetailKeyField="Criteria" MasterKeyField="Criteria"></telerik:GridRelationFields>
                                        </ParentTableRelation>
                                        <Columns>
                                            <telerik:GridClientSelectColumn UniqueName="selectCheckbox" HeaderStyle-Width="30px">
                                            </telerik:GridClientSelectColumn>
                                            <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="AceType" UniqueName="AceType" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="AceType" UniqueName="EntityType" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Occupation" UniqueName="Occupation" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="CriteriaID" UniqueName="CriteriaID" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Criteria" UniqueName="Criteria" HeaderText="Credit Recommendation" Display="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Criteria" UniqueName="SelectedCriteria" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="AceID" HeaderText="Exhibit ID" SortExpression="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true" HeaderStyle-Width="110px">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" DataFormatString="{0:MM/dd/yyyy}"
                                                HeaderText="Team Revd" SortExpression="TeamRevd" UniqueName="TeamRevd" HeaderStyle-Font-Bold="true" HeaderStyle-Width="90px" AllowFiltering="true" CurrentFilterFunction="GreaterThan" AutoPostBackOnFilter="false" FilterControlWidth="80px">
                                            </telerik:GridDateTimeColumn>
                                            <telerik:GridDateTimeColumn DataField="StartDate" UniqueName="StartDate" Display="false" DataFormatString="{0:MM/dd/yyyy}" />
                                            <telerik:GridDateTimeColumn DataField="EndDate" UniqueName="EndDate" Display="false" DataFormatString="{0:MM/dd/yyyy}" />
                                            <telerik:GridDateTimeColumn DataField="VersionNumber" UniqueName="VersionNumber" HeaderText="Version" AllowFiltering="false" HeaderStyle-Width="55px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="90px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" EnableHeaderContextMenu="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Title" Display="false" HeaderText="Title" SortExpression="Title" UniqueName="Title" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                            <%--<telerik:GridBoundColumn DataField="ExhibitDisplay" HeaderText="Exhibit Display" SortExpression="ExhibitDisplay" UniqueName="ExhibitDisplay" HeaderStyle-Font-Bold="true" Display="false">
                                            </telerik:GridBoundColumn>--%>
                                            <telerik:GridTemplateColumn UniqueName="ExhibitLink" HeaderText="Title" SortExpression="Title" >
                                                <ItemTemplate>
                                                    <asp:HyperLink NavigateUrl="javascript:showExhibitInfo();" runat="server" ID="hlExhibit" Text="" Font-Underline="true"></asp:HyperLink>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>                                               
                                        </Columns>
                                    </telerik:GridTableView>
                                </DetailTables>
                                <Columns>
                                    <telerik:GridTemplateColumn UniqueName="Condition" HeaderText="" HeaderStyle-Width="95px" Display="false">
                                        <ItemTemplate>
                                            <telerik:RadComboBox ID="rcbCondition" runat="server" Width="80px" DropDownAutoWidth="Enabled" ToolTip="Use the & / Or condition to indicate the credit recommendations relationship that justifies this articulation" Font-Bold="true">
                                                <Items>
                                                    
                                                    <telerik:RadComboBoxItem Value="1" Text="&" />
                                                    <telerik:RadComboBoxItem Value="2" Text="Or" />
                                                </Items>
                                            </telerik:RadComboBox>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>                                          
                                    <telerik:GridBoundColumn DataField="CriteriaDescription" HeaderText="Credit Recommendation" SortExpression="CriteriaDescription" UniqueName="CriteriaDescription" HeaderStyle-Font-Bold="true" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Criteria" FilterControlAltText="Filter Criteria column" HeaderText="Credit Recommendation" SortExpression="Criteria" UniqueName="Criteria" HeaderStyle-Font-Bold="true" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-CssClass="myClass">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Occurances" HeaderText="Occurences" SortExpression="Occurances" UniqueName="Occurances" HeaderStyle-Font-Bold="true" ItemStyle-Font-Bold="true" HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="Condition" FilterControlAltText="Filter Condition column" HeaderText="&/or" SortExpression="Condition" UniqueName="Condition" DataSourceID="sqlConditions" ListTextField="ConditionSymbol" EmptyListItemValue="" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" Visible="false"  EnableHeaderContextMenu="false">
                                    </telerik:GridDropDownColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>


                        <asp:SqlDataSource runat="server" ID="sqlCriteriaGroup" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="GetCriteriaGroup" CancelSelectOnNullParameter="false" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter Name="SelectedCriteria" DbType="String" ControlID="hfSelectedCriteria" PropertyName="Value" />
                                <asp:ControlParameter Name="outline_id" Type="String" ControlID="hfSelectedCourse" PropertyName="Value" />
                                <asp:ControlParameter ControlID="hfExcludeArticulationOverYears" DbType="Int32" Name="ExcludeArticulationOverYears" PropertyName="Value" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource runat="server" ID="sqlCriteriaDetails" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="GetCriteriaDetailsVeteranRecomendation" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                            <SelectParameters>
                                <asp:SessionParameter Name="VeteranId" SessionField="VeteranID" DbType="Int32" />
                                <asp:ControlParameter Name="SelectedCriteria" DbType="String" ControlID="hfSelectedCriteria" PropertyName="Value" />																										  
                                <asp:ControlParameter ControlID="hfExcludeArticulationOverYears" DbType="Int32" Name="ExcludeArticulationOverYears" PropertyName="Value" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource runat="server" ID="sqlConditions" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="select * from tblLookupConditions" CancelSelectOnNullParameter="false"></asp:SqlDataSource>
                        <div class="row mt-1">
                            <div class="col-4">
                                <h3 style="display:none;" class="mb-3 mt-3">Notes : </h3>
                            </div>
                            <div class="col-8 d-flex justify-content-center">
                                <telerik:RadAsyncUpload Localization-Select="Upload Document(s)" Visible="false" RenderMode="Lightweight" runat="server" ID="AsyncUpload1" MultipleFileSelection="Disabled" Width="200px" />
                                <telerik:RadProgressArea RenderMode="Lightweight" runat="server" Visible="false" ID="RadProgressArea1" />
                            </div>
                        </div>
                        <div class="row mt-1 d-flex justify-content-end">
                            <telerik:RadTextBox ID="rtbNotes" runat="server" InputType="Text" TextMode="MultiLine" Visible="false" Rows="4" Skin="Metro" Width="100%"></telerik:RadTextBox>
                            <telerik:RadButton ID="rbFinish" runat="server" Text="Articulate" Width="120px" Primary="true" ValidationGroup="CriteriaValidation" OnClick="rbFinish_Click" CausesValidation="true" AutoPostBack="true" CssClass="m-3"></telerik:RadButton>
                            <telerik:RadButton ID="rbClose" runat="server" Text="Cancel" Width="80px" OnClick="rbClose_Click" CausesValidation="false" AutoPostBack="true" CssClass="m-3"></telerik:RadButton>
                        </div>
                    </div>
                </div>
            </div>
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="2000" Width="350" Height="110" Title="Notification" EnableRoundedCorners="false">
            </telerik:RadNotification>
            <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server">
            </telerik:RadWindowManager>
            <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager2" runat="server">
            </telerik:RadWindowManager>
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


        function RowSelecting(sender, args) {
            if (args.get_tableView().get_name() == "Master") {
                args.set_cancel(true)
            }
        }

        function RowSelected(sender, args) {
            var grid = sender;
            let selected = grid.get_selectedItems();
            document.getElementById('<%=tbSelectedItems.ClientID %>').value = selected.length;
        }
        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow)
                oWindow = window.radWindow;
            else if (window.frameElement && window.frameElement.radWindow)
                oWindow = window.frameElement.radWindow;
            return oWindow;
        }
        function toggleSelection(sender, args) {
            args.get_gridDataItem().set_selected(!args.get_gridDataItem().get_selected());
        }
        function CloseModal() {
            // GetRadWindow().close();
            setTimeout(function () {
                GetRadWindow().close();
                top.location.href = top.location.href;
            }, 0);
        }

        function GridCreated(sender, eventArgs) {
            ////gets the main table scrollArea HTLM element  
            //var scrollArea = document.getElementById(sender.get_element().id + "_GridData");
            ////var row = sender.get_masterTableView().get_selectedItems()[0];
            //var MasterTable = sender.get_masterTableView();
            //var row = MasterTable.get_dataItems()[0];
            //var selectedItem = row.get_nestedViews()[0].get_selectedItems()[0];

            ////if the position of the selected row is below the viewable grid area  
            //if (selectedItem) {
            //    if ((selectedItem.get_element().offsetTop - scrollArea.scrollTop) + selectedItem.get_element().offsetHeight + 20 > scrollArea.offsetHeight) {
            //        //scroll down to selected row  
            //        scrollArea.scrollTop = scrollArea.scrollTop + ((selectedItem.get_element().offsetTop - scrollArea.scrollTop) +
            //            selectedItem.get_element().offsetHeight - scrollArea.offsetHeight) + selectedItem.get_element().offsetHeight;
            //    }
            //    //if the position of the the selected row is above the viewable grid area  
            //    else if ((selectedItem.get_element().offsetTop - scrollArea.scrollTop) < 0) {
            //        //scroll the selected row to the top  
            //        scrollArea.scrollTop = selectedItem.get_element().offsetTop;
            //    }
            //}
        }

    </script>
</body>
</html>

