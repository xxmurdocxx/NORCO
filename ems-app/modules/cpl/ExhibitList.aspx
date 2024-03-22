<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="ExhibitList.aspx.cs" Inherits="ems_app.modules.cpl.ExhibitList" %>

<%@ Register Src="~/UserControls/ExhibitArticulations.ascx" TagPrefix="uc1" TagName="ExhibitArticulations" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .RadWindow_Material .rwContent {
            align-items: center;
            display: flex;
            justify-content: center;
        }

        .RadNotification_Material a {
            color: blue;
        }

        .RadNotification .rnContentWrapper {
            justify-content: center;
            align-items: center;
            display: flex;
            flex-direction: column;
        }

        .RadButton_Material.rbCheckBox .rbText, .RadButton_Material.rbRadioButton .rbText {
            font-size: 13px !important;
            font-weight: normal !important;
            color: #455A64 !important;
        }
        .linkButtons a {
            color:blue !important;
        }
        .action-button {
            color:blue !important;
        }
        .delete-button {
            color:red !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Credit for Prior Learning (CPL) Exhibits</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart">
        <asp:HiddenField ID="hfCollegeID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hfSelectedExhibitID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hfSelectedAceID" runat="server" ClientIDMode="Static" Value="" />
        <asp:HiddenField runat="server" ID="hvCollaborative" />
        <telerik:RadWindowManager RenderMode="Lightweight" runat="server" ID="RadWindowManager1">
            <Windows>
                <telerik:RadWindow RenderMode="Lightweight" ID="rw_customConfirm" Modal="true" Behaviors="Close, Move" VisibleStatusbar="false"
                    Width="500px" Height="200px" runat="server" Title="Edit Exhibit">
                    <ContentTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <div class="rwDialogText text-center">
                                <p>This Exhibit has existing articulations, Do you want to Create a New Version or make a Revision ?</p>
                            </div>
                            <div style="margin-top: 10px;" class="text-center">
                                <telerik:RadButton RenderMode="Lightweight" runat="server" ID="rbConfirmNewVersion_OK" Text="Create a New Version" OnClick="rbConfirmNewVersion_OK_Click">
                                </telerik:RadButton>
                                <telerik:RadButton RenderMode="Lightweight" runat="server" ID="rbConfirmRevision_OK" Text="Create a Revision" OnClick="rbConfirmRevision_OK_Click">
                                </telerik:RadButton>
                                <telerik:RadLinkButton RenderMode="Lightweight" runat="server" ID="rbViewExhibit" Text="View" Target="_blank" OnClientClicked="OnClientClicked">
                                </telerik:RadLinkButton>
                            </div>
                        </div>
                    </ContentTemplate>
                </telerik:RadWindow>
                <telerik:RadWindow RenderMode="Lightweight" ID="rwConfirmDelete" Modal="true" Behaviors="Close, Move" VisibleStatusbar="false"
                    Width="300px" Height="200px" runat="server" Title="Delete Exhibit">
                    <ContentTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <div class="rwDialogText text-center">
                                <asp:Literal ID="confirmText" runat="server"></asp:Literal>
                            </div>
                            <div style="margin-top: 10px;" class="text-center">
                                <telerik:RadButton RenderMode="Lightweight" runat="server" ID="rbDelete" Text="Delete" OnClick="rbDelete_Click">
                                </telerik:RadButton>
                            </div>
                        </div>
                    </ContentTemplate>
                </telerik:RadWindow>
                <telerik:RadWindow RenderMode="Lightweight" ID="rwConfirmClone" Modal="true" Behaviors="Close, Move" VisibleStatusbar="false"
                    Width="300px" Height="200px" runat="server" Title="Clone Exhibit">
                    <ContentTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <div class="rwDialogText text-center">
                                <p>Are you sure you want to clone this Exhibit ?</p>
                            </div>
                            <div style="margin-top: 10px;" class="text-center">
                                <telerik:RadButton RenderMode="Lightweight" runat="server" ID="rbClone" Text="Clone" OnClick="rbClone_Click">
                                </telerik:RadButton>
                            </div>
                        </div>
                    </ContentTemplate>
                </telerik:RadWindow>
            </Windows>
        </telerik:RadWindowManager>
        <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="Center" AutoCloseDelay="0" Width="350" Height="210" Title="" EnableRoundedCorners="true" ShowCloseButton="true">
            <ContentTemplate>
                <asp:Literal ID="rnLiteral" runat="server"></asp:Literal>
            </ContentTemplate>
        </telerik:RadNotification>
        <div class="row">
            <div class="col-2" style="display: flex; justify-content: start; align-items: baseline;">
                <h2 style="padding-top: 10px;">MAP Exhibits</h2>
            </div>
            <div class="col-10" style="display: flex; justify-content: end; align-items: baseline;">
                <telerik:RadTextBox ID="rtbKeyword" runat="server" Width="400px" BackColor="LightYellow" AutoPostBack="true" CssClass="mt-1 mb-1" EmptyMessage="Search by any Keyword..."></telerik:RadTextBox>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <asp:SqlDataSource ID="sqlCollaborative" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLCollaborative] ORDER BY SortOrder"></asp:SqlDataSource>
                <telerik:RadLabel ID="RadLabel1" runat="server" Text="Collaborative : " Font-Size="Small" Font-Bold="false"></telerik:RadLabel>
                <telerik:RadComboBox ID="rcbCollaborative" DataSourceID="sqlCollaborative" DataTextField="Description" DataValueField="ID" runat="server" Width="250px" CheckBoxes="true" OnSelectedIndexChanged="rcbCollaborative_SelectedIndexChanged" EnableCheckAllItemsCheckBox="true" AppendDataBoundItems="true" AutoPostBack="true">
                </telerik:RadComboBox>
                <asp:SqlDataSource ID="sqlColleges" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="select * from LookupColleges lc join MAPCohort mc on lc.college = mc.COLLEGE_NAME where DistrictID is not null and lc.collegeid in(select distinct collegeid from ACEExhibit where SourceID = 4)
order by college"></asp:SqlDataSource>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <telerik:RadLabel ID="RadLabel7" runat="server" Text="Originator College : " Font-Size="Small" Font-Bold="false"></telerik:RadLabel>
                <telerik:RadComboBox ID="rcbColleges" DataSourceID="sqlColleges" DataTextField="College" DataValueField="CollegeID" Height="400px" Width="190px" DropDownAutoWidth="Enabled" runat="server" AutoPostBack="true" CssClass="mt-1 mb-1" AppendDataBoundItems="true">
                    <Items>
                        <telerik:RadComboBoxItem Value="" Text="All" />
                    </Items>
                </telerik:RadComboBox>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <telerik:RadButton ID="rbSearch" UseSubmitBehavior="true" runat="server" Text="Search" CssClass="mt-1 mb-1" Width="80px" Primary="true" AutoPostBack="true"></telerik:RadButton>
            </div>
        </div>

        <%--<p class="alert alert-warning mt-3" style="text-align:center;font-weight:bold">*** Beta Release ***</p>--%>
        <br />
        <asp:SqlDataSource ID="sqlExhibits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SearchCPLExhibits" SelectCommandType="StoredProcedure" DeleteCommand="DELETE FROM [CPLExhibit] WHERE ID = @ID" DeleteCommandType="Text" CancelSelectOnNullParameter="false" OnSelecting="sqlExhibits_Selecting">
            <SelectParameters>
                <asp:ControlParameter ControlID="rcbColleges" PropertyName="selectedValue" Name="CollegeID" Type="Int32" ConvertEmptyStringToNull="true" />
                <asp:ControlParameter ControlID="rtbKeyword" PropertyName="Text" Name="Keyword" Type="String" ConvertEmptyStringToNull="true" />
                <asp:ControlParameter Name="Collaborative" ControlID="hvCollaborative" PropertyName="Value" Type="String" ConvertEmptyStringToNull="true" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="ID" Type="Int32" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlExhibitSource" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="select * from [ACEExhibitSource] where CPLSource = 1"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCPLType" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="SELECT * FROM [CPLType] WHERE Active = 1 ORDER BY SortOrder"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLExhibitStatus] ORDER BY RowOrder"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlModeLearning" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="SELECT ID, CPLModeofLearningDescription FROM CPLModeofLearning WHERE Active = 1 ORDER BY SortOrder"></asp:SqlDataSource>
        <telerik:RadGrid ID="rgCPLExhibits" runat="server" CellSpacing="-1" DataSourceID="sqlExhibits" EnableHeaderContextMenu="true" AllowFilteringByColumn="true" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" Width="100%" AllowAutomaticDeletes="true" OnItemCommand="rgCPLExhibits_ItemCommand" OnItemDataBound="rgCPLExhibits_ItemDataBound" ActiveItemStyle-BackColor="#99ccff">
            <ExportSettings ExportOnlyData="true" FileName="CPLExhibits" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
            </ExportSettings>
            <GroupingSettings CaseSensitive="false" />
            <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
            </ClientSettings>
            <MasterTableView DataSourceID="sqlExhibits" DataKeyNames="ID" CommandItemDisplay="Top" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Font-Bold="true" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save" HierarchyLoadMode="ServerBind">
                <CommandItemTemplate>
                    <div class="commandItems">
                        <telerik:RadButton runat="server" ID="btnMoveForward" ButtonType="StandardButton" NavigateUrl="Exhibits.aspx" Target="_blank" Text="MoveForward" ToolTip="Add new Exhibit">
                            <ContentTemplate>
                                <i class='fa fa-save'></i><span class="txtMoveForward"> Add Exhibit</span>
                            </ContentTemplate>
                        </telerik:RadButton>
                        <telerik:RadButton ID="btnExcel" runat="server" Text=" Export" ButtonType="StandardButton" CommandName="ExportToExcel" ToolTip="Click here to export Exhibits">
                            <ContentTemplate>
                                <i class='fa fa-file-excel-o'></i> Export to Excel
                            </ContentTemplate>
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>
                <CommandItemSettings ShowExportToExcelButton="true" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                <Columns>
                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CollegeID" UniqueName="CollegeID" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SourceName" UniqueName="SourceName" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridDropDownColumn DataSourceID="sqlStatus" ListTextField="Description" ListValueField="Description" UniqueName="StatusDesc" SortExpression="StatusDesc" HeaderText="Status" DataField="StatusDesc" AllowFiltering="true" HeaderStyle-Width="60px" ReadOnly="true">
                        <FilterTemplate>
                            <telerik:RadComboBox ID="RadComboBoxStatus" DataSourceID="sqlStatus" DataTextField="Description"
                                DataValueField="Description" Height="200px" Width="60px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("StatusDesc").CurrentFilterValue %>'
                                runat="server" OnClientSelectedIndexChanged="StatusIndexChanged" DropDownAutoWidth="Enabled">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="rsStatus" runat="server">
                                <script type="text/javascript">
                                    function StatusIndexChanged(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("StatusDesc", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn SortExpression="Title" HeaderText="Exhibit Title" DataField="Title" HeaderStyle-Width="120px" UniqueName="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="110px" EmptyDataText="">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="AceID" HeaderText="MAP ID" DataField="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EmptyDataText="" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" FilterControlWidth="110px">
                    </telerik:GridBoundColumn>
                    <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="false">
                        <ItemStyle HorizontalAlign="Center" />
                    </telerik:GridDateTimeColumn>
                    <telerik:GridBoundColumn SortExpression="College" HeaderText="Originator" DataField="College" UniqueName="College" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EmptyDataText="" HeaderStyle-Width="100px">
                    </telerik:GridBoundColumn>
                    <telerik:GridDropDownColumn DataSourceID="sqlExhibitSource" ListTextField="SourceName" ListValueField="SourceName" UniqueName="SourceName" SortExpression="SourceName" HeaderText="Source" DataField="SourceName" AllowFiltering="true" HeaderStyle-Width="60px" ReadOnly="true">
                        <FilterTemplate>
                            <telerik:RadComboBox ID="RadComboBoxSources" DataSourceID="sqlExhibitSource" DataTextField="SourceName"
                                DataValueField="Id" Height="200px" Width="100px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("SourceName").CurrentFilterValue %>'
                                runat="server" OnClientSelectedIndexChanged="SourceIndexChanged" DropDownAutoWidth="Enabled">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="rsSource" runat="server">
                                <script type="text/javascript">
                                    function SourceIndexChanged(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("SourceName", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridDropDownColumn>
                    <telerik:GridDropDownColumn DataSourceID="sqlCPLType" ListTextField="CPLTypeDescription" ListValueField="CPLTypeDescription" UniqueName="Description" SortExpression="Description" HeaderText="CPL Type" DataField="Description" AllowFiltering="true" HeaderStyle-Width="60px" ReadOnly="true">
                        <FilterTemplate>
                            <telerik:RadComboBox ID="RadComboBoxType" DataSourceID="sqlCPLType" DataTextField="CPLTypeDescription"
                                DataValueField="CPLTypeDescription" Height="200px" Width="100px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Description").CurrentFilterValue %>'
                                runat="server" OnClientSelectedIndexChanged="TypeIndexChanged" DropDownAutoWidth="Enabled">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="rsType" runat="server">
                                <script type="text/javascript">
                                    function TypeIndexChanged(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("Description", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridDropDownColumn>
                    <telerik:GridDropDownColumn DataSourceID="sqlModeLearning" ListTextField="CPLModeofLearningDescription" ListValueField="CPLModeofLearningDescription" UniqueName="CPLModeofLearningDescription" SortExpression="CPLModeofLearningDescription" HeaderText="Learning Mode" DataField="CPLModeofLearningDescription" AllowFiltering="true" HeaderStyle-Width="60px" ReadOnly="true">
                        <FilterTemplate>
                            <telerik:RadComboBox ID="RadComboBoxModeLearning" DataSourceID="sqlModeLearning" DataTextField="CPLModeofLearningDescription"
                                DataValueField="CPLModeofLearningDescription" Height="200px" Width="100px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("CPLModeofLearningDescription").CurrentFilterValue %>'
                                runat="server" OnClientSelectedIndexChanged="ModeLearningIndexChanged" DropDownAutoWidth="Enabled">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="rsModeLearning" runat="server">
                                <script type="text/javascript">
                                    function ModeLearningIndexChanged(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("CPLModeofLearningDescription", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn SortExpression="EstimatedUnits" HeaderText="Hours" DataField="EstimatedUnits" UniqueName="EstimatedUnits" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EmptyDataText="" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px" FilterControlWidth="40px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="VersionNumber" HeaderText="Ver" DataField="VersionNumber" UniqueName="VersionNumber" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EmptyDataText="" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="Revision" HeaderText="Rev" DataField="Revision" UniqueName="Revision" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EmptyDataText="" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="Collaborative" HeaderText="Collaborative" DataField="Collaborative" UniqueName="Collaborative" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EmptyDataText="" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="150px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="Students" HeaderText="Stus" DataField="Students" UniqueName="Students" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EmptyDataText="" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px" HeaderTooltip="Student count per exhibit">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="Articulations" HeaderText="Artics" DataField="Articulations" UniqueName="Articulations" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EmptyDataText="" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="60px" HeaderTooltip="Articulation count per exhibit">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="55px" ItemStyle-HorizontalAlign="Center" ReadOnly="true" AllowFiltering="false" Exportable="false" Groupable="false">
                        <ItemTemplate>
                            <div style="display:flex; width:55px;">
                            <asp:LinkButton runat="server" ToolTip="Clone Exhibit" CommandName="Clone" ID="btnClone" Text='<i class="fa fa-clone" aria-hidden="true"></i>' CssClass="m-1 action-button" />
                            <asp:LinkButton runat="server" ToolTip="View Exhibit" CommandName="View" ID="btnView" Text='<i class="fa fa-eye" aria-hidden="true"></i>' CssClass="m-1 action-button" />
                            <asp:LinkButton runat="server" ToolTip="Edit Exhibit" CommandName="EditExhibit" ID="btnEdit" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' CssClass="m-1 action-button" />
                            <asp:LinkButton runat="server" ToolTip="Print Exhibit" CommandName="PrintExhibit" ID="btnPrint" Text='<i class="fa fa-print" aria-hidden="true"></i>' CssClass="m-1 action-button" />
                            <asp:LinkButton runat="server" ToolTip="Delete Exhibit" CommandName="Delete" ID="btnDelete" Text='<i class="fa fa-trash" aria-hidden="true"></i>' CssClass="m-1 delete-button"  />
                            </div>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>
                <NestedViewTemplate>
                    <asp:Label ID="lblID" Font-Bold="true" Font-Italic="true" Text='<%# Eval("ID") %>' runat="server" Visible="false" />

                    <div class="row">
                        <asp:SqlDataSource ID="sqlCoursesArticulated" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT '' AceID, null TeamRevd, '' Title, 0 ExhibitID,  '<i class=''fa fa-circle'' aria-hidden=''true'' title=''Not Started'' style=''color:red''></i>' StageIcon, 0 id, 0 as outline_id, AEC.OutlineID as outline_id_cid, aec.CriteriaID CriteriaID, Criteria, U.unit, s.subject, c.course_number, c.course_title, C.CIDNumber, (SELECT TOP 1 [C-ID_Descriptor] from MASTER_CID WHERE [C-ID]= C.CIDNumber AND Institution LIKE '%'+col.College+'%' ORDER BY Approval_date DESC ) CIDDescriptor  FROM [ACEExhibitCriteria] AEC LEFT OUTER JOIN Course_IssuedForm c on aec.OutlineID = C.outline_id LEFT OUTER JOIN tblLookupUnits U ON C.unit_id = U.unit_id LEFT OUTER JOIN tblSubjects S ON C.subject_id = S.subject_id LEFT OUTER JOIN LookupColleges COL ON c.college_id = COL.CollegeID WHERE ExhibitID = @ExhibitID AND CriteriaID NOT IN (SELECT DISTINCT CriteriaID FROM Articulation WHERE ExhibitID = @ExhibitID) UNION SELECT A.AceID, A.TeamRevd, A.Title, A.ExhibitID, CASE WHEN st.[Order] = 4 THEN '<i class=''fa fa-circle'' aria-hidden=''true'' title=''Implemented'' style=''color:green''></i>' ELSE '<i class=''fa fa-circle'' aria-hidden=''true'' title=''In Progress'' style=''color:yellow;''></i>' END StageIcon, a.id, a.outline_id, a.outline_id  outline_id_cid, a.CriteriaID, aec.Criteria, U.unit, S.subject,C.course_number,C.course_title, c.CIDNumber, (SELECT TOP 1 [C-ID_Descriptor] from MASTER_CID WHERE [C-ID]= C.CIDNumber AND Institution LIKE '%'+col.College+'%' ORDER BY Approval_date DESC ) CIDDescriptor FROM Articulation A JOIN Stages ST ON A.ArticulationStage = ST.Id JOIN ACEExhibit AE ON A.ExhibitID = AE.ID JOIN Course_IssuedForm C ON A.outline_id = C.outline_id JOIN tblSubjects S ON C.subject_id = S.subject_id JOIN LookupColleges COL ON A.CollegeID = COL.CollegeID JOIN ACEExhibitCriteria AEC ON A.CriteriaID = AEC.CriteriaID  JOIN tblLookupUnits U ON C.unit_id = U.unit_id  WHERE A.ExhibitID = @ExhibitID and A.CollegeID = @CollegeID">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="lblID" PropertyName="Text" Type="String" Name="ExhibitID" />
                                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" DbType="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <h3 class="m-2">College Course(s) Articulated To This Exhibit</h3>
                        <telerik:RadGrid ID="rgCoursesArticulated" runat="server" CellSpacing="-1" DataSourceID="sqlCoursesArticulated" AllowFilteringByColumn="False" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemCommand="rgCoursesArticulated_ItemCommand" OnItemDataBound="rgCoursesArticulated_ItemDataBound">
                            <ExportSettings ExportOnlyData="true" FileName="Articulations" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
                            </ExportSettings>
                            <GroupingSettings CaseSensitive="false" />
                            <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                            </ClientSettings>
                            <MasterTableView DataSourceID="sqlCoursesArticulated" DataKeyNames="ID" CommandItemDisplay="None" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HierarchyLoadMode="Client">
                                <CommandItemSettings ShowExportToExcelButton="false" ShowRefreshButton="false" />
                                <ColumnGroups>
                                    <telerik:GridColumnGroup HeaderText="Credit Recommendation" Name="CreditRecommendation" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="33%">
                                    </telerik:GridColumnGroup>
                                    <telerik:GridColumnGroup HeaderText="College Course" Name="CollegeCourse" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="33%">
                                    </telerik:GridColumnGroup>
                                    <telerik:GridColumnGroup HeaderText="C-ID" Name="CID" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="33%">
                                    </telerik:GridColumnGroup>
                                </ColumnGroups>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="outline_id_cid" UniqueName="outline_id_CID" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="CriteriaID" UniqueName="CriteriaID" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="70px" ReadOnly="true" AllowFiltering="false" EnableHeaderContextMenu="false" ItemStyle-CssClass="row-buttons">
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" ToolTip="View Articulation" CommandName="View" ID="btnView" Text='View' CssClass="d-block" />
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn SortExpression="StageIcon" HeaderText="" DataField="StageIcon" UniqueName="StageIcon" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" HeaderStyle-Width="30px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CreditRecommendation" HeaderStyle-Width="25%">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="subject" HeaderText="Subject" HeaderStyle-Width="60px" DataField="subject" UniqueName="subject" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CollegeCourse">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="70px" DataField="course_number" UniqueName="course_number" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CollegeCourse">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CollegeCourse" HeaderStyle-Width="300px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="unit" HeaderText="Units" DataField="unit" HeaderStyle-Width="40px" UniqueName="unit" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CollegeCourse">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="CIDNumber" HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" HeaderText="CID Number" DataField="CIDNumber" UniqueName="CIDNumber" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="CIDDescriptor" HeaderText="CID Course" DataField="CIDDescriptor" UniqueName="CIDDescriptor" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CID">
                                    </telerik:GridBoundColumn>
                                </Columns>
                                <NestedViewTemplate>
                                    <asp:Label ID="lblOutlineID" Font-Bold="true" Font-Italic="true" Text='<%# Eval("outline_id") %>' runat="server" Visible="false" />
                                    <asp:Label ID="lblOutlineIDCID" Font-Bold="true" Font-Italic="true" Text='<%# Eval("outline_id_CID") %>' runat="server" Visible="false" />
                                    <asp:Label ID="lblCriteriaID" Font-Bold="true" Font-Italic="true" Text='<%# Eval("CriteriaID") %>' runat="server" Visible="false" />
                                    <asp:SqlDataSource ID="sqlCoursesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="lblOutlineID" PropertyName="Text" Type="Int32" Name="outline_id" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlCourseCID" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="lblOutlineIDCID" PropertyName="Text" Type="Int32" Name="outline_id" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <table>
                                        <tr>
                                            <td style="width: 33%; vertical-align: top; padding-left: 40px; padding-top: 10px;">
                                                <asp:SqlDataSource ID="sqlCreditRecommendationsNotes" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT Notes FROM ACEExhibitCriteria WHERE CriteriaID = @CriteriaID">
                                                    <SelectParameters>
                                                        <asp:ControlParameter ControlID="lblCriteriaID" PropertyName="Text" Type="Int32" Name="CriteriaID" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <h3>Credit Recommendation Notes</h3>
                                                <asp:Repeater ID="rptNotes" runat="server" DataSourceID="sqlCreditRecommendationsNotes">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lblNotes" Text='<%# Eval("Notes") %>' /></td>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </td>
                                            <td style="width: 33%; vertical-align: top; padding-left: 20px; padding-top: 10px;">
                                                <h3>Course Information</h3>
                                                <asp:Repeater ID="rptCourseDetails" runat="server" DataSourceID="sqlCoursesDetails">
                                                    <HeaderTemplate>
                                                        <table>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label9" Text='Course : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label10" Text='<%# String.Concat(Eval("_Subject"), " ", Eval("_CourseNumber")) %>' /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label3" Text='Title : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label4" Text='<%# Eval("_CourseTitle") %>' /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label15" Text='Units : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label16" Text='<%# Eval("_Units") %>' /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label7" Text='Division : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label8" Text='<%# Eval("_Division") %>' /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label11" Text='Catalog Description : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label12" Text='<%# Eval("_CatalogDescription") %>' /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label13" Text='Course Notes : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label14" Text='<%# Eval("_CourseNotes") %>' /></td>
                                                        </tr>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        </table>
                                                    </FooterTemplate>
                                                </asp:Repeater>
                                                <h3 class="mt-3 mb-3">Student Learning Outcomes</h3>
                                                <asp:SqlDataSource ID="sqlStudentLearningOutcome" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [StudentLearningOutcome] WHERE ([outline_id] = @outline_id) ORDER BY [id]">
                                                    <SelectParameters>
                                                        <asp:ControlParameter ControlID="lblOutlineID" PropertyName="Text" Type="Int32" Name="outline_id" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <telerik:RadGrid ID="rgStudentLearningOutcomes" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlStudentLearningOutcome" Width="100%">
                                                    <GroupingSettings CaseSensitive="false" />
                                                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="sqlStudentLearningOutcome" CommandItemDisplay="None" PageSize="10">
                                                        <BatchEditingSettings EditType="Row" />
                                                        <Columns>
                                                            <telerik:GridBoundColumn DataField="id" HeaderText="ID" UniqueName="id" Display="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn DataField="outline_id" HeaderText="Outline ID" UniqueName="outline_id" Display="false">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridTemplateColumn UniqueName="RowNumber" HeaderText="">
                                                                <ItemTemplate>
                                                                    <%#Container.ItemIndex+1%>
                                                                </ItemTemplate>
                                                                <HeaderStyle Width="40px" />
                                                            </telerik:GridTemplateColumn>
                                                            <telerik:GridBoundColumn DataField="SLODescription" HeaderText="SLO Description" UniqueName="SLODescription" ColumnEditorID="TextEditor">
                                                            </telerik:GridBoundColumn>
                                                        </Columns>
                                                    </MasterTableView>
                                                </telerik:RadGrid>
                                            </td>
                                            <td style="width: 33%; vertical-align: top; padding-left: 20px; padding-top: 10px;">
                                                <h3>CID Information</h3>
                                                <asp:Repeater ID="Repeater1" runat="server" DataSourceID="sqlCourseCID">
                                                    <HeaderTemplate>
                                                        <table>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label2" Text='C-ID Number : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div><%# Eval("_CIDNumber") %></div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label6" Text='C-ID Title : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div><%# Eval("_CIDTitle") %></div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label1" Text='C-ID Descriptor : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div><%# Eval("_CIDDescriptor") %></div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label5" Text='Evaluation Methods : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div><%# Eval("_EvalutionMethods") %></div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="Label17" Text='Course Objectives : ' Font-Bold="true" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div><%# Eval("_CourseObejctives") %></div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        </table>
                                                    </FooterTemplate>
                                                </asp:Repeater>
                                            </td>
                                        </tr>
                                    </table>
                                </NestedViewTemplate>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <h3 class="m-2">Credit Recommendations</h3>
                            <asp:SqlDataSource ID="sqlCreditRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT ExhibitID, Criteria, Notes FROM ACEExhibitCriteria WHERE ExhibitID = @ExhibitID">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="lblID" PropertyName="Text" Type="String" Name="ExhibitID" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <telerik:RadGrid ID="rgCreditRecommendations" runat="server" CellSpacing="-1" DataSourceID="sqlCreditRecommendations" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" Width="100%" OnItemCommand="rgCreditRecommendations_ItemCommand">
                                <MasterTableView DataSourceID="sqlCreditRecommendations" DataKeyNames="ExhibitID" CommandItemDisplay="None" PageSize="12" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true">
                                    <NoRecordsTemplate>
                                        <p>There are no existing Credit Recommendations for this exhibit.</p>
                                    </NoRecordsTemplate>
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Criteria" UniqueName="Criteria" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderText="Credit Recommendation">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Credit Recommendation" CommandName="StudentIntake" ID="btnStudentIntake" Text='<%# Eval("Criteria") %>' CssClass="d-block" />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="Notes" UniqueName="Notes" HeaderText="Notes">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </div>
                    </div>
                </NestedViewTemplate>
            </MasterTableView>
        </telerik:RadGrid>
    </telerik:RadAjaxPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }
        function OnClientClicked(sender, args) {
            var window = $find('<%=rw_customConfirm.ClientID %>');
            window.close();
        }
    </script>
</asp:Content>
