<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Exhibits.aspx.cs" Inherits="ems_app.modules.cpl.Exhibits" %>

<%@ Register Src="~/UserControls/ExhibitArticulations.ascx" TagPrefix="uc1" TagName="ExhibitArticulations" %>




<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .buttons {
            top: 80px !important;
            padding: 5px !important;
        }

        .buttons .btn {
            line-height: 1.42857143em !important;
            font-weight: 500 !important;
            border-color: #CFD8DC;
            color: #455A64;
            background-color: #f4f7f8;
            transition: all .2s ease-in-out;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.2);
        }

        .btnHidden {
            display: none !important;
        }

        .RadComboBox_Material {
            margin: 0 !important;
        }

        .dropdownLightYellow {
            background-color: lightyellow !important;
        }

        .RadUpload_Material .ruSelectWrap .ruBrowse {
            background-color: #203864 !important;
            color: white !important;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.2) !important;
            font-weight: 500 !important;
        }
        .remove-border {
            border: none !important;
        }
        .rad-checkbox .rbText, .rad-checkbox.RadButton.rbDisabled {
            font-size: 13px !important;
            font-weight: normal !important;
            color: #455A64 !important;
            opacity: 1 !important;
        }
        .RadGrid button, .RadGrid [type="button"] {
            line-height: 1.42857143em !important;
            font-weight: 500 !important;
            border-color: #CFD8DC;
            color: #455A64;
            background-color: #f4f7f8;
            transition: all .2s ease-in-out;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.2);
            border: none;
            padding: 5px;
            text-transform: uppercase;
        }
        .reToolBarWrapper {
            display:block !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Credit for Prior Learning (CPL) Exhibits</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hfCollegeID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfExhibitCollegeID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfAceID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfExhibitID" runat="server" ClientIDMode="Static" Value="9999999" />
    <asp:HiddenField ID="hfUserID" runat="server" ClientIDMode="Static" />
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow">
        <Windows>
            <telerik:RadWindow RenderMode="Lightweight" ID="rw_customConfirm" Modal="true" Behaviors="Close, Move" VisibleStatusbar="false"
                Width="500px" Height="300px" runat="server" Title="Edit Exhibit">
                <ContentTemplate>
                    <div class="rwDialogPopup radconfirm">
                        <div class="rwDialogText text-center">
                            <p>This MAP ID you want to update already exists, Do you want to Create a New Version or make a Revision ?</p>
                        </div>
                        <div style="margin-top: 10px;" class="text-center">
                            <telerik:RadButton RenderMode="Lightweight" runat="server" ID="rbConfirmNewVersion_OK" Text="Create a New Version" OnClick="rbConfirmNewVersion_OK_Click">
                            </telerik:RadButton>
                            <telerik:RadButton RenderMode="Lightweight" runat="server" ID="rbConfirmRevision_OK" Text="Create a Revision" OnClick="rbConfirmRevision_OK_Click">
                            </telerik:RadButton>
                            <telerik:RadLinkButton RenderMode="Lightweight" runat="server" ID="rbViewExhibit" Text="View" Target="_blank" OnClientClicked="OnClientClicked" >
                            </telerik:RadLinkButton>
                        </div>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <%--<p class="alert alert-warning mt-3" style="text-align: center; font-weight: bold">*** Beta Release ***</p>--%>
        <div class="row">
            <div class="container d-flex justify-content-end">
                <div class="fixed bg-white buttons p-3">
                    <telerik:RadButton ID="rbUpdate" runat="server" Text="Save" ToolTip="Click here to save/update Exhibit" Width="80px" Primary="true" CausesValidation="true" ValidationGroup="ExhibitValidation" OnClick="rbUpdate_Click" AutoPostBack="true">
                    </telerik:RadButton>
                    &nbsp;
                    <asp:LinkButton runat="server" class="btn btn-secondary" ToolTip="Print" ID="btnPrintExhibit" Width="80px" Height="35px" Text='PRINT' />&nbsp;
                    &nbsp;
                    <asp:LinkButton runat="server" class="btn btn-light" ToolTip="Close" ID="btnClose" OnClientClick="closeCurrentTab();" Width="80px" Height="35px" Text='CLOSE' />&nbsp;
                </div>
            </div>
            <div class="container">
                <div class="row" style="border-bottom: 1px solid #ccc;">
                    <div class="col-3 d-flex">
                        <telerik:RadLabel ID="rlArticulatedAt" runat="server" Text="Articulated at:" Font-Size="Small" Font-Bold="false" Width="120px"></telerik:RadLabel>
                        <telerik:RadTextBox Enabled="false" ID="rtArticulatedAt" CssClass="mb-3 remove-border" runat="server" Width="100%" ClientIDMode="Static"></telerik:RadTextBox>
                    </div>
                    <div class="col-1" style="display: flex; justify-content: end;">
                        <telerik:RadLabel ID="RadLabel14" runat="server" Text="Collaborative:" ToolTip="If the exhibit was developed through collaboration of subject matter experts from diverse institutions, please check all that apply and add notes to clarify as needed." Font-Size="Small" Font-Bold="false" Width="110px"></telerik:RadLabel>
                    </div>
                    <div class="col-4 d-flex align-content-center">
                        <asp:SqlDataSource ID="sqlCollaborative" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLCollaborative] ORDER BY SortOrder"></asp:SqlDataSource>
                        <telerik:RadComboBox ID="rcbCollaborative" DataSourceID="sqlCollaborative" DataTextField="Description" DataValueField="ID" runat="server" Width="200px"  CheckBoxes="true" ToolTip="If the exhibit was developed through collaboration of subject matter experts from diverse institutions, please check all that apply and add notes to clarify as needed.">
                        </telerik:RadComboBox>
                        <telerik:RadTextBox ID="rtCollaborativeNotes"  CssClass="mb-3" EmptyMessage="Collaborative Notes" runat="server" Width="300px" ClientIDMode="Static" ToolTip="Collaborative Notes" Height="36px" ></telerik:RadTextBox>
                    </div>
                    <div class="col-1" style="display: flex; justify-content: end;">
                        <telerik:RadLabel ID="rlOriginInstitution" runat="server" Text="Exhibit Originator:" Font-Size="Small" Font-Bold="false"></telerik:RadLabel>
                    </div>
                    <div class="col-3">
                        <telerik:RadTextBox ID="rtOrigin" Enabled="false" CssClass="mb-3 remove-border" runat="server" Width="100%" ClientIDMode="Static"></telerik:RadTextBox>
                    </div>
                </div>
                <div class="row" style="margin-top: 10px !important;">
                    <div class="col-4 d-flex">
                        <telerik:RadLabel ID="RadLabel7" runat="server" Text="Source : " Font-Size="Small" Font-Bold="false" Width="110px"></telerik:RadLabel>
                        <asp:RequiredFieldValidator runat="server" ForeColor="Red" ControlToValidate="rcbSourceCode" ErrorMessage="*" Display="Dynamic" ValidationGroup="ExhibitValidation" EnableClientScript="true" />
                        <asp:SqlDataSource ID="sqlSource" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM ACEExhibitSource where CPLSource = 1 ORDER BY id"></asp:SqlDataSource>
                        <telerik:RadComboBox ID="rcbSourceCode" DataSourceID="sqlSource" CssClass="mb-3" DataTextField="SourceName" DataValueField="id" runat="server"  Width="100%" DefaultMessage="" DropDownAutoWidth="Enabled" AppendDataBoundItems="true" EmptyMessage="Select a Exhibit Source">
                            <Items>
                                <telerik:RadComboBoxItem Text="" Value="" />
                            </Items>
                        </telerik:RadComboBox>
                    </div>
                    <div class="col-1">
                        <div style="display: flex; justify-content: end;">
                            <telerik:RadLabel ID="RadLabel1" runat="server" Text="Type : " Font-Size="Small" Font-Bold="false"></telerik:RadLabel>
                        </div>
                    </div>
                    <div class="col-2 d-flex">
                        <asp:RequiredFieldValidator runat="server" ForeColor="Red" ControlToValidate="rcbCPLType" ErrorMessage="*" Display="Dynamic" ValidationGroup="ExhibitValidation" EnableClientScript="true" />
                        <asp:SqlDataSource ID="sqlCPLType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT ID, CONCAT(CPLTypeDescription, ' (', CPLTypeCode, ')')  AS CPLTypeDescription, CreatedBy, CreatedOn, Active, SortOrder, CPLTypeCode FROM [CPLType] WHERE Active = 1 ORDER BY SortOrder"></asp:SqlDataSource>
                        <telerik:RadComboBox ID="rcbCPLType" DataSourceID="sqlCPLType" CssClass="mb-3" DataTextField="CPLTypeDescription" DataValueField="id" runat="server" Width="100%" DefaultMessage="" DropDownAutoWidth="Enabled" AppendDataBoundItems="true" EmptyMessage="Select a CPL Type" AutoPostBack="true" OnSelectedIndexChanged="ExhibitID_SelectedIndexChanged">
                            <Items>
                                <telerik:RadComboBoxItem Text="" Value="" />
                            </Items>
                        </telerik:RadComboBox>
                    </div>
                    <div class="col-1" style="display: flex; justify-content: end;">
                        <telerik:RadLabel ID="RadLabel2" runat="server" Text="Learning Mode : " Font-Size="Small" Font-Bold="false"></telerik:RadLabel>
                    </div>
                    <div class="col-2 d-flex">
                        <asp:RequiredFieldValidator runat="server" ForeColor="Red" ControlToValidate="rcbCPLType" ErrorMessage="*" Display="Dynamic" ValidationGroup="ExhibitValidation" EnableClientScript="true" />
                        <asp:SqlDataSource ID="sqlModelLearning" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLModeofLearning] WHERE Active = 1 ORDER BY SortOrder"></asp:SqlDataSource>
                        <telerik:RadComboBox ID="rcbModelLearning" DataSourceID="sqlModelLearning" CssClass="mb-3" DataTextField="CPLModeofLearningDescription" DataValueField="id" runat="server" Width="100%" DefaultMessage="" DropDownAutoWidth="Enabled" AppendDataBoundItems="true" EmptyMessage="Select a Model of Learning" AutoPostBack="true" OnSelectedIndexChanged="ExhibitID_SelectedIndexChanged">
                            <Items>
                                <telerik:RadComboBoxItem Text="" Value="" />
                            </Items>
                        </telerik:RadComboBox>
                    </div>
                    <div class="col-2" style="display: flex; justify-content: end;">
                        <div id="divCPLStatus" runat="server">
                            <telerik:RadLabel ID="RadLabel17" runat="server" Text="Status : " Width="70px" Font-Size="Small" Font-Bold="false"></telerik:RadLabel>
                            <asp:SqlDataSource ID="sqlStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLExhibitStatus] ORDER BY RowOrder"></asp:SqlDataSource>
                            <telerik:RadComboBox ID="rcbStatus" DataSourceID="sqlStatus" CssClass="mb-3" DataTextField="Description" DataValueField="id" runat="server" Width="150px" DefaultMessage="" DropDownAutoWidth="Enabled" AppendDataBoundItems="true" EmptyMessage="Select a Status">
                                <Items>
                                    <telerik:RadComboBoxItem Text="" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                        </div>
                    </div>
                </div>
                <div class="col-12 d-flex">
                    <telerik:RadLabel ID="RadLabel5" runat="server" Text="Exhibit Title : " Font-Size="Small" Font-Bold="false" Width="100px"></telerik:RadLabel>
                    <asp:RequiredFieldValidator runat="server" ForeColor="Red" ControlToValidate="rtUniformTitle" ErrorMessage="*" Display="Dynamic" ValidationGroup="ExhibitValidation" EnableClientScript="true" />
                    <telerik:RadTextBox ID="rtUniformTitle" LabelWidth="100px" CssClass="mb-3" runat="server" Width="100%" ClientIDMode="Static" ToolTip="The initials of the  first four words will be used to construct the Exhibit ID" AutoPostBack="true" OnTextChanged="rtUniformTitle_TextChanged" EmptyMessage="Please enter exhibit title here; the initials of the  first four words will be used to construct the Exhibit ID" EmptyMessageStyle-Font-Italic="true"></telerik:RadTextBox>
                </div>
                <div class="col-12" style="display: flex;">
                    <telerik:RadLabel ID="RadLabel10" runat="server" Width="90px" Font-Size="Small" Font-Bold="false" Text="Review Date : "></telerik:RadLabel>
                    <telerik:RadDatePicker ID="rtbTeamRevd" runat="server" Width="145px" Font-Size="Small" Font-Bold="false" ClientIDMode="Static"></telerik:RadDatePicker>
                    <asp:RequiredFieldValidator runat="server" ForeColor="Red" ControlToValidate="rtbTeamRevd" ErrorMessage="*" Display="Dynamic" ValidationGroup="ExhibitValidation" EnableClientScript="true" />
                    &nbsp;&nbsp;&nbsp;&nbsp;<telerik:RadLabel ID="RadLabel11" runat="server" Font-Size="Small" Font-Bold="false" Text=" Start Date : "></telerik:RadLabel>
                    <telerik:RadDatePicker ID="rtStartDate"  runat="server" Width="145px" ClientIDMode="Static" Font-Size="Small" Font-Bold="false"></telerik:RadDatePicker>
                    <asp:RequiredFieldValidator runat="server" ForeColor="Red" ControlToValidate="rtStartDate" ErrorMessage="*" Display="Dynamic" ValidationGroup="ExhibitValidation" EnableClientScript="true" />
                    &nbsp;&nbsp;&nbsp;&nbsp;<telerik:RadLabel ID="RadLabel12" runat="server" Font-Size="Small" Font-Bold="false" Text="End Date : "></telerik:RadLabel>
                    <telerik:RadDatePicker ID="rtEndDate" runat="server" Width="145px" ClientIDMode="Static" Font-Size="Small" Font-Bold="false"></telerik:RadDatePicker>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <telerik:RadLabel ID="RadLabel3" runat="server" Font-Size="Small" Font-Bold="false" Text="Estimated Hours : "></telerik:RadLabel>
                    <telerik:RadTextBox ID="rtEstimatedHours" runat="server" Width="70px" ClientIDMode="Static"></telerik:RadTextBox>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <telerik:RadLabel ID="RadLabel4" runat="server" Font-Size="Small" Font-Bold="false" Text="Version : "></telerik:RadLabel>
                    <telerik:RadTextBox ID="rtVersion" Enabled="false" runat="server" Width="70px" ClientIDMode="Static"></telerik:RadTextBox>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <telerik:RadLabel ID="RadLabel8" runat="server" Font-Size="Small" Font-Bold="false" Text="Revision : "></telerik:RadLabel>
                    <telerik:RadTextBox ID="rtRevision" Enabled="false" runat="server" Width="70px" ClientIDMode="Static"></telerik:RadTextBox>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <telerik:RadLabel ID="rlAceID" runat="server" Font-Size="Medium" Font-Bold="false" Text="<i class='fa fa-question-circle'></i>"></telerik:RadLabel>
                    <telerik:RadLabel ID="RadLabel9" runat="server" Font-Size="Small" Font-Bold="true" Text="Exhibit ID : "></telerik:RadLabel>
                    <telerik:RadLabel ID="rlExhibitID" runat="server" Font-Size="Small" Text=""></telerik:RadLabel>
                    <telerik:RadTextBox ID="rtAceID" Font-Bold="true" Enabled="false" runat="server" Width="170px" ClientIDMode="Static"></telerik:RadTextBox>
                    <telerik:RadToolTip ID="RadToolTip1" TargetControlID="rlAceID" runat="server" Text="Source - Type - Learning Mode Code - Uniform Title Code - Version - Revision" Width="310px"></telerik:RadToolTip>
                </div>
                <div class="col-12 d-flex">
                    <telerik:RadLabel ID="RadLabel6" runat="server" Text="Notes : " Font-Size="Small" Font-Bold="false" Width="100px"></telerik:RadLabel>
                    <telerik:RadTextBox ID="rtbNotes" LabelWidth="100px" CssClass="mb-3" runat="server" Width="100%" ClientIDMode="Static" BackColor="LightYellow"></telerik:RadTextBox>
                </div>
                <div class="col-8 d-flex">
                    <telerik:RadLabel ID="RadLabel15" runat="server" Text="Reviewed By : " Font-Size="Small" Font-Bold="false" Width="100px"></telerik:RadLabel>
                    <telerik:RadTextBox ID="rtbRevisedBy" LabelWidth="100px" CssClass="mb-3" runat="server" Width="100%" ClientIDMode="Static" BackColor="LightYellow"></telerik:RadTextBox>
                </div>
                <div class="col-1" style="display: flex;">
                    <telerik:RadLabel ID="RadLabel16" runat="server" Text="Last Updated by : " Font-Size="Small" Font-Bold="false"></telerik:RadLabel>
                </div>
                <div class="col-3 d-flex">
                    <telerik:RadTextBox ID="rtbLastUpdated" CssClass="mb-3" runat="server" Width="100%" ClientIDMode="Static" Enabled="false"></telerik:RadTextBox>
                </div>
            </div>
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="Center" AutoCloseDelay="0" Width="400" Height="210" Title="Notification" EnableRoundedCorners="false">
                <ContentTemplate>
                    <asp:Literal ID="rnLiteral" runat="server"></asp:Literal>
                </ContentTemplate>
            </telerik:RadNotification>
            <div class="container mb-3 mt-3">
                <div id="pnlExhibit" runat="server">

                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbCreditRecommendations" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Credit Recommendations" Expanded="false" EnableTheming="false" ToolTip="" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="col-3" style="font-weight: bold;">
                                            Credit Recommendations
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable" style="color: #fff !important;">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                    <div class="row">
                        <div class="col-12" style="display: flex; align-items: center; justify-content:start;">
                            <telerik:RadLabel ID="RadLabel13" runat="server" Font-Size="Small" Font-Bold="true" Text="Add Credit Recommendations based on Course Titles"></telerik:RadLabel>
                            &nbsp;&nbsp;
                            <telerik:RadComboBox ID="rcbCourses" DataSourceID="sqlCourses" DataTextField="CourseDescription" DataValueField="outline_id" MaxHeight="200px" Width="950px" AppendDataBoundItems="true" EmptyMessage="Please enter keyword to select course(s) (Multiple courses can be selected)." ToolTip="Search for a college course you wish to select. " runat="server" MarkFirstMatch="true" Filter="Contains" DropDownAutoWidth="Disabled" CheckBoxes="true" CheckedItemsTexts="FitInInput" BackColor="LightYellow"  >
                                <Items>
                                    <telerik:RadComboBoxItem Text="" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="rfCourse" runat="server" ControlToValidate="rcbCourses" Display="Dynamic" ValidationGroup="AddCourses" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:SqlDataSource runat="server" ID="sqlCourses" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="sp_SearchCoursesCID" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" DbType="Int32" />
                                    <asp:Parameter Name="CourseType" DbType="Int32" DefaultValue="1" />
                                    <asp:Parameter Name="All" DbType="Int32" DefaultValue="1" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            &nbsp;&nbsp;
                            <telerik:RadButton ID="rbAddCourses" runat="server" Text="Add" ToolTip="Click here to create the credit recommendations" Width="70px" Primary="true" OnClick="rbAddCourses_Click" CausesValidation="true" ValidationGroup="AddCourses" AutoPostBack="true"></telerik:RadButton>
                            &nbsp;&nbsp;&nbsp;
                            <telerik:RadButton ID="rbClear" runat="server" Text="Clear" ToolTip="Click here to clear the selected course(s)" Width="70px" Primary="false" OnClick="rbClear_Click" AutoPostBack="true"></telerik:RadButton>
                        </div>
                    </div>
                    <div class="mb-3">
                        <asp:SqlDataSource ID="sqlCreditRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT (SELECT CASE WHEN ( (CIF.CIDNumber IS NULL OR CIF.CIDNumber = '') AND ISNULL((SELECT TOP 1 [C-ID_Descriptor] from MASTER_CID WHERE [C-ID]= CIF.CIDNumber AND Institution LIKE '%' + COL.College + '%' ORDER BY Approval_date DESC ),'') = '' ) THEN 'College' ELSE 'C-ID' END FROM   course_issuedform CIF  LEFT OUTER JOIN LookupColleges COL ON CIF.college_id = COL.CollegeID WHERE  CIF.outline_id = aec.OutlineID) CRType, aec.* FROM [ACEExhibitCriteria] aec WHERE ExhibitID = @ExhibitID" DeleteCommand="DELETE FROM [ACEExhibitCriteria] WHERE CriteriaID = @CriteriaID" DeleteCommandType="Text" UpdateCommand="UPDATE [ACEExhibitCriteria] SET Criteria = @Criteria, Notes = @Notes WHERE CriteriaID = @CriteriaID" UpdateCommandType="Text">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hfExhibitID" PropertyName="Value" Name="ExhibitID" Type="Int32" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="Criteria" Type="String" />
                                <asp:Parameter Name="Notes" Type="String" />
                                <asp:Parameter Name="CriteriaID" Type="Int32" />
                            </UpdateParameters>
                            <DeleteParameters>
                                <asp:Parameter Name="CriteriaID" Type="Int32" />
                            </DeleteParameters>
                        </asp:SqlDataSource>
                        <div class="mt-3 mb-3">
                            <telerik:RadGrid ID="rgCreditRecommendations" runat="server" CellSpacing="-1" DataSourceID="sqlCreditRecommendations" AllowFilteringByColumn="False" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemDeleted="rgCreditRecommendations_ItemDeleted" OnItemCommand="rgCreditRecommendations_ItemCommand" AllowAutomaticDeletes="true" OnItemDataBound="rgCreditRecommendations_ItemDataBound">
                                <ExportSettings ExportOnlyData="true" FileName="CreditRecommendations" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
                                </ExportSettings>
                                <GroupingSettings CaseSensitive="false" />
                                <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                    <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                    <ClientEvents OnRowClick="OnRowClickCreditRecommendations" />
                                </ClientSettings>
                                <MasterTableView DataSourceID="sqlCreditRecommendations" DataKeyNames="CriteriaID" CommandItemDisplay="Top" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save" EditFormSettings-PopUpSettings-Modal="true" >
                                    <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                                    <NoRecordsTemplate>
                                        <p>No records to display</p>
                                    </NoRecordsTemplate>
                                    <BatchEditingSettings EditType="Row" />
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="CriteriaID" UniqueName="CriteriaID" Display="false" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderText="" HeaderStyle-Width="80px" ReadOnly="true">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Credit Recommendation" CommandName="StudentIntake" ID="btnStudentIntake" Text='View Stus' CssClass="d-block" />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn SortExpression="CRType" HeaderText="Type" DataField="CRType" UniqueName="CRType" AllowFiltering="false" AutoPostBackOnFilter="true" HeaderStyle-Width="80px" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" AutoPostBackOnFilter="true" HeaderStyle-Width="700px" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false">
                                        </telerik:GridBoundColumn>
<%--                                        <telerik:GridBoundColumn DataField="Notes" HeaderText="Notes" UniqueName="Notes" EmptyDataText="Enter any detail that might be used for this credit recommendation">
                                        </telerik:GridBoundColumn>--%>
                                        <telerik:GridHTMLEditorColumn UniqueName="Notes" DataField="Notes" HeaderText="Notes">
                                        </telerik:GridHTMLEditorColumn>
                                        <telerik:GridButtonColumn ButtonType="FontIconButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this credit recommendation ?" ConfirmTitle="Delete" HeaderStyle-Width="50px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                            <HeaderStyle Width="50px" />
                                        </telerik:GridButtonColumn>
                                    </Columns>
                                    <EditFormSettings EditColumn-ButtonType="PushButton" CaptionFormatString="Credit Recommendation: {0}" CaptionDataField="CreditRecommendation" FormCaptionStyle-Font-Bold="true" PopUpSettings-ShowCaptionInEditForm="true" ColumnNumber="2" EditColumn-CancelText="Cancel" EditColumn-UpdateText="Save">
                                        <PopUpSettings Height="300px" Modal="True" Width="800px" ScrollBars="None" KeepInScreenBounds="true" OverflowPosition="Center" />
                                    </EditFormSettings>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </div>

                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbArticulations" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="College Course(s) Articulated To This Exhibit" Expanded="false" EnableTheming="false" ToolTip="" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="col-3" style="font-weight: bold;">
                                            College Course(s) Articulated To This Exhibit
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable" style="color: #fff !important;">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <uc1:ExhibitArticulations runat="server" ID="ExhibitArticulations"  />
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbEvidenceCompetency" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Evidence of Competency" Expanded="false" EnableTheming="false" ToolTip="" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="col-3" style="font-weight: bold;">
                                            Evidence of Competency
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable" style="color: #fff !important;">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                        <asp:SqlDataSource ID="sqlEvidence" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLExhibitEvidence] WHERE Active = 1 ORDER BY SortOrder"></asp:SqlDataSource>
                        <asp:SqlDataSource ID="sqlCPLEvidenceCompetency" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLEvidenceCompetency] WHERE ExhibitID = @ExhibitID" InsertCommand="INSERT INTO [dbo].[CPLEvidenceCompetency] ([ExhibitID] ,[CollegeID] ,[ExhibitEvidenceID], [Notes], [ActiveCurrent], [CreatedBy] ,[CreatedOn]) VALUES (@ExhibitID ,@CollegeID ,@ExhibitEvidenceID , @Notes, @ActiveCurrent, @CreatedBy ,GETDATE())" InsertCommandType="Text" UpdateCommand="UPDATE [dbo].[CPLEvidenceCompetency]  SET [ExhibitEvidenceID] = @ExhibitEvidenceID, [Notes] = @Notes, ActiveCurrent = @ActiveCurrent, [UpdatedBy] = @UpdatedBy, [UpdatedOn] = GETDATE() WHERE ID = @ID" UpdateCommandType="Text" DeleteCommand="DELETE FROM [CPLEvidenceCompetency] WHERE ID = @ID" DeleteCommandType="Text">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hfExhibitID" PropertyName="Value" Name="ExhibitID" Type="Int32" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="ID" Type="Int32" />
                                <asp:Parameter Name="ExhibitEvidenceID" Type="Int32" />
                                <asp:Parameter Name="Notes" Type="String" />
                                <asp:Parameter Name="ActiveCurrent" Type="Boolean" />
                                <asp:ControlParameter ControlID="hfUserID" PropertyName="Value" Name="UpdatedBy" Type="Int32" />
                            </UpdateParameters>
                            <InsertParameters>
                                <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="CollegeID" Type="Int32" />
                                <asp:ControlParameter ControlID="hfExhibitID" PropertyName="Value" Name="ExhibitID" Type="Int32" />
                                <asp:Parameter Name="ExhibitEvidenceID" Type="Int32" />
                                <asp:Parameter Name="Notes" Type="String" />
                                <asp:Parameter Name="ActiveCurrent" Type="Boolean" />
                                <asp:ControlParameter ControlID="hfUserID" PropertyName="Value" Name="CreatedBy" Type="Int32" />
                            </InsertParameters>
                            <DeleteParameters>
                                <asp:Parameter Name="ID" Type="Int32" />
                            </DeleteParameters>
                        </asp:SqlDataSource>
                        <telerik:RadGrid ID="rgEvidenceCompetency" runat="server" CellSpacing="-1" DataSourceID="sqlCPLEvidenceCompetency" AllowFilteringByColumn="False" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" AllowAutomaticDeletes="true" OnItemDataBound="rgEvidenceCompetency_ItemDataBound">
                            <ExportSettings ExportOnlyData="true" FileName="EvidenceCompetency" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
                            </ExportSettings>
                            <GroupingSettings CaseSensitive="false" />
                            <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                <ClientEvents OnRowClick="OnRowClickEvidence" />
                            </ClientSettings>
                            
                            <MasterTableView DataSourceID="sqlCPLEvidenceCompetency" DataKeyNames="ID" CommandItemDisplay="Top" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save" EditFormSettings-PopUpSettings-Modal="true" CommandItemSettings-AddNewRecordText="Add Evidence of Competency" AllowAutomaticInserts="true" AllowAutomaticDeletes="true" EditFormSettings-FormCaptionStyle-Width="300px">
                                <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="true"  ShowRefreshButton="false" />
                                <NoRecordsTemplate>
                                    <p>No records to display</p>
                                </NoRecordsTemplate>
                                <BatchEditingSettings EditType="Row" />
                                <Columns>
                                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="ExhibitEvidenceID" FilterControlAltText="Filter ExhibitEvidenceID column" HeaderText="Evidence of Competency" SortExpression="ExhibitEvidenceID" UniqueName="ExhibitEvidenceID" DataSourceID="sqlEvidence" ListTextField="Description" ListValueField="id" HeaderStyle-Width="450px" AllowFiltering="false" EnableHeaderContextMenu="false" EnableEmptyListItem="true">
                                        <ColumnValidationSettings EnableRequiredFieldValidation="false">
                                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                                        </ColumnValidationSettings>
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn DataField="Notes" HeaderText="Notes" UniqueName="Notes" EmptyDataText="Please add notes">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridCheckBoxColumn UniqueName="ActiveCurrent" DataField="ActiveCurrent" HeaderText="Current / Active">                                    </telerik:GridCheckBoxColumn>
                                    <telerik:GridButtonColumn ButtonType="FontIconButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this credit recommendation ?" ConfirmTitle="Delete" HeaderStyle-Width="70px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                        <HeaderStyle Width="70px" />
                                        <ItemStyle Width="200px" />
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbRubic" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Rubric Items" Expanded="false" EnableTheming="false" ToolTip="" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="col-3" style="font-weight: bold;">
                                            Rubric Items
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable" style="color: #fff !important;">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                        <asp:SqlDataSource ID="sqlRubricItems" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM CPLRubric WHERE ExhibitID = @ExhibitID " InsertCommand="INSERT INTO [dbo].[CPLRubric] ([ExhibitID] ,[CollegeID] ,[Rubric] ,[ScoreRange] ,[MinScore] ,[CreatedBy] ,[CreatedOn]) VALUES (@ExhibitID ,@CollegeID ,@Rubric ,@ScoreRange ,@MinScore ,@CreatedBy ,GETDATE())" InsertCommandType="Text" UpdateCommand="UPDATE [dbo].[CPLRubric]  SET [Rubric] = @Rubric, [ScoreRange] = @ScoreRange ,[MinScore] = @MinScore, [UpdatedBy] = @UpdatedBy, [UpdatedOn] = GETDATE() WHERE ID = @ID" UpdateCommandType="Text" DeleteCommand="DELETE FROM [CPLRubric] WHERE ID = @ID" DeleteCommandType="Text">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="CollegeID" Type="Int32" />
                                <asp:ControlParameter ControlID="hfExhibitID" PropertyName="Value" Name="ExhibitID" Type="Int32" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="ID" Type="Int32" />
                                <asp:Parameter Name="Rubric" Type="String" />
                                <asp:Parameter Name="ScoreRange" Type="Double" />
                                <asp:Parameter Name="MinScore" Type="Double" />
                                <asp:ControlParameter ControlID="hfUserID" PropertyName="Value" Name="UpdatedBy" Type="Int32" />
                            </UpdateParameters>
                            <InsertParameters>
                                <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="CollegeID" Type="Int32" />
                                <asp:ControlParameter ControlID="hfExhibitID" PropertyName="Value" Name="ExhibitID" Type="Int32" />
                                <asp:Parameter Name="Rubric" Type="String" />
                                <asp:Parameter Name="ScoreRange" Type="Double" />
                                <asp:Parameter Name="MinScore" Type="Double" />
                                <asp:ControlParameter ControlID="hfUserID" PropertyName="Value" Name="CreatedBy" Type="Int32" />
                            </InsertParameters>
                            <DeleteParameters>
                                <asp:Parameter Name="ID" Type="Int32" />
                            </DeleteParameters>
                        </asp:SqlDataSource>
                        <telerik:RadGrid ID="rgRubricItems" runat="server" CellSpacing="-1" DataSourceID="sqlRubricItems" AllowFilteringByColumn="False" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" AllowAutomaticDeletes="true" OnItemDataBound="rgRubricItems_ItemDataBound">
                            <ExportSettings ExportOnlyData="true" FileName="RubricItems" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
                            </ExportSettings>
                            <GroupingSettings CaseSensitive="false" />
                            <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                <ClientEvents OnRowClick="OnRowClickRubric" />
                            </ClientSettings>
                            <MasterTableView DataSourceID="sqlRubricItems" DataKeyNames="ID" CommandItemDisplay="Top" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" CommandItemSettings-SaveChangesText="Save" CommandItemSettings-AddNewRecordText="Add Rubric Item">
                                <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="true" ShowRefreshButton="false"  />
                                <NoRecordsTemplate>
                                    <p>No records to display</p>
                                </NoRecordsTemplate>
                                <BatchEditingSettings EditType="Row" />
                                <Columns>
                                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Rubric" HeaderText="Rubric Item" DataField="Rubric" UniqueName="Rubric" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridNumericColumn SortExpression="ScoreRange" HeaderText="Score Range" DataField="ScoreRange" UniqueName="ScoreRange" AllowFiltering="false" HeaderStyle-Width="100px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false">
                                    </telerik:GridNumericColumn>
                                    <telerik:GridNumericColumn SortExpression="MinScore" HeaderText="Min Score" DataField="MinScore" UniqueName="MinScore" AllowFiltering="false" HeaderStyle-Width="100px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false">
                                    </telerik:GridNumericColumn>
                                    <telerik:GridButtonColumn ButtonType="FontIconButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this credit recommendation ?" ConfirmTitle="Delete" HeaderStyle-Width="70px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                        <HeaderStyle Width="70px" />
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                   <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbDocuments" Width="100%" CssClass="mb-2">
                        <Items>
                            <telerik:RadPanelItem Text="Documents" Expanded="false" EnableTheming="false" ToolTip="" CssClass="bg-light">
                                <HeaderTemplate>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="col-3" style="font-weight: bold;">
                                            Documents
                                        </div>
                                        <div class="col-8 d-flex justify-content-end fs-6 gap-3">
                                        </div>
                                        <div class="col-1">
                                            <a class="rpExpandable" style="color: #fff !important;">
                                                <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                            </a>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentTemplate>
                        <asp:SqlDataSource ID="sqlDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [CPLExhibitDocuments] WHERE id = @id" DeleteCommandType="Text" SelectCommand="SELECT ad.id, ad.filename, ad.filedescription, ad.binarydata, concat(u.firstname , ', ' , u.lastname ) as 'FullName', ad.CreatedBy FROM [CPLExhibitDocuments] ad left outer join tblusers u on ad.CreatedBy = u.userid  where (ad.CPLExhibitID = @CPLExhibitID)">
                            <SelectParameters>
                                <asp:ControlParameter Name="CPLExhibitID" ControlID="hfExhibitID" PropertyName="Value" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                            SelectCommand="SELECT [id], [BinaryData] FROM [CPLExhibitDocuments] WHERE [CPLExhibitID] = @id">
                            <SelectParameters>
                                <asp:Parameter Name="id" Type="Int32"></asp:Parameter>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <div class="row mb-5" id="divUpload" runat="server">
                            <div class="col-6">
                                <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="AsyncUpload1" Localization-Select="Upload Document" Font-Bold="true" MultipleFileSelection="Automatic" AutoAddFileInputs="false" AllowedFileExtensions=".pdf,.doc,.docx,.xls,.xlsx" Width="100%" ToolTip="Upload supporting course documents" MaxFileSize="10000000"  OnClientFileUploaded="OnClientFileUploaded" ClientIDMode="Static" />
                            </div>
                            <div class="col-6">
                                <telerik:RadButton ID="btnComple" runat="server" OnClick="btnComplete_Click" Text="Complete Upload" Skin="Material" Width="180px" Font-Bold="true" Font-Size="12px" Height="35px" CssClass="btnHidden" ClientIDMode="Static" AutoPostBack="true"></telerik:RadButton>
                            </div>
                        </div>
                        <telerik:RadGrid ID="rgCPLExhibitDocs" DataSourceID="sqlDocuments" AllowPaging="True" Width="100%" runat="server" AutoGenerateColumns="False" AllowSorting="True" PageSize="10" OnItemCommand="rgCPLExhibitDocs_ItemCommand" EditItemStyle-BackColor="#ffff66">
                            <ClientSettings AllowDragToGroup="false">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                            </ClientSettings>
                            <MasterTableView DataKeyNames="id" AutoGenerateColumns="false" CommandItemDisplay="None">
                                <Columns>
                                    <telerik:GridBoundColumn DataField="id" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="CreatedBy" FilterControlAltText="Filter CreatedBy column" HeaderText="CreatedBy" SortExpression="CreatedBy" UniqueName="CreatedBy" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false" EnableHeaderContextMenu="false">
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" ToolTip="Downloaad/View file" CommandName="Download" ID="btnDownload" Text='<i class="fa fa-download" aria-hidden="true"></i>' />
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn DataField="FileDescription" FilterControlAltText="Filter FileDescription column" HeaderText="File Description" SortExpression="FileDescription" UniqueName="FileDescription">
                                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                            <RequiredFieldValidator SetFocusOnError="true" ForeColor="Red" Text="Please enter a file description." ToolTip="Please enter a file description."><span>Please enter a file description.</span>  </RequiredFieldValidator>
                                        </ColumnValidationSettings>
                                    </telerik:GridBoundColumn>
                                    <telerik:GridAttachmentColumn SortExpression="FileName" UploadControlType="RadAsyncUpload" DataSourceID="SqlDataSource1" MaxFileSize="10485760" EditFormHeaderTextFormat="Upload File:" HeaderText="" AttachmentDataField="BinaryData" AttachmentKeyFields="id" ForceExtractValue="Always" FileNameTextField="FileName" DataTextField="FileName" UniqueName="AttachmentColumnIcon" ButtonType="ImageButton" ImageUrl="~/Common/images/icons/baseline_attachment_black_18dp.png" ReadOnly="true" Display="false">
                                    </telerik:GridAttachmentColumn>
                                    <telerik:GridAttachmentColumn SortExpression="FileName" UploadControlType="RadAsyncUpload" DataSourceID="SqlDataSource1" MaxFileSize="10048576" EditFormHeaderTextFormat="Upload File:" HeaderText="Attachment" AttachmentDataField="BinaryData" AttachmentKeyFields="id" ForceExtractValue="Always" FileNameTextField="FileName" DataTextField="FileName" UniqueName="AttachmentColumn" Display="false">
                                    </telerik:GridAttachmentColumn>
                                    <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Uploaded by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn ButtonType="FontIconButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this document ?" ConfirmTitle="Delete" HeaderStyle-Width="50px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                        <HeaderStyle Width="50px" />
                                    </telerik:GridButtonColumn>
                                </Columns>
                                <EditFormSettings ColumnNumber="2" FormMainTableStyle-CellPadding="5" FormTableStyle-CellPadding="5" EditColumn-ButtonType="ImageButton"></EditFormSettings>
                            </MasterTableView>
                        </telerik:RadGrid>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>


                </div>
            </div>
        </div>
    </telerik:RadAjaxPanel>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        function closeCurrentTab() {
            const currentWindow = window.open('', '_self');
            currentWindow.close();
        }
        function OnClientFileUploaded(sender, args) {
            $('#btnComple').trigger('click');
        }
        function OnClientClicked(sender, args) {
            var window = $find('<%=rw_customConfirm.ClientID %>');
                    window.close();
        }
        function OnRowClickCreditRecommendations(sender, eventArgs) {
            var hfCollegeID = document.getElementById('hfCollegeID');
            var hfExhibitCollegeID = document.getElementById('hfExhibitCollegeID');
            if (hfCollegeID.value === hfExhibitCollegeID.value) {
                editedRow = eventArgs.get_itemIndexHierarchical();
                $find("<%= rgCreditRecommendations.ClientID %>").get_masterTableView().editItem(editedRow);                
            }
        }
        function OnRowClickEvidence(sender, eventArgs) {
            var hfCollegeID = document.getElementById('hfCollegeID');
            var hfExhibitCollegeID = document.getElementById('hfExhibitCollegeID');
            if (hfCollegeID.value === hfExhibitCollegeID.value) {
                editedRow = eventArgs.get_itemIndexHierarchical();
                $find("<%= rgEvidenceCompetency.ClientID %>").get_masterTableView().editItem(editedRow);
            }
        }
        function OnRowClickRubric(sender, eventArgs) {
            var hfCollegeID = document.getElementById('hfCollegeID');
            var hfExhibitCollegeID = document.getElementById('hfExhibitCollegeID');
            if (hfCollegeID.value === hfExhibitCollegeID.value) {
                editedRow = eventArgs.get_itemIndexHierarchical();
                $find("<%= rgRubricItems.ClientID %>").get_masterTableView().editItem(editedRow);                
            }
        }

    </script>
</asp:Content>
