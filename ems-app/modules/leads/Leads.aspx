<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Leads.aspx.cs" Inherits="ems_app.modules.leads.Leads" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Veterans Outreach</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlVeterans" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, LastName + ', ' + FirstName as 'VeteranName' from Veteran order by Lastname"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlUsers" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, LastName + ', ' + FirstName as 'FullName' from tblUsers where [CollegeID] = @CollegeID order by Lastname">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlLeadStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LeadStatus " />
    <asp:SqlDataSource ID="sqlCampaignStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from CampaignStatus " />
    <asp:SqlDataSource ID="sqlSemesters" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from Semesters " />
    <asp:SqlDataSource ID="sqlLeadOutcome" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LeadOutcome " />
    <asp:SqlDataSource ID="sqlCampaigns" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [Campaign] WHERE ([CollegeID] = @CollegeID) ORDER BY [Description]" DeleteCommand="DELETE FROM [Campaign] WHERE [ID] = @ID">
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlVeteranLeads" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="GetVeteransOutreach" UpdateCommand="Update VeteranLead SET [ToBeContacted] = @ToBeContacted WHERE [Id] = @Id" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfCampaignID" Name="CampaignID" PropertyName="Value" Type="Int32"></asp:ControlParameter>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:Parameter Name="Exhibits" DefaultValue="" DbType="String" ConvertEmptyStringToNull="true" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="ToBeContacted" Type="Boolean" />
            <asp:Parameter Name="ID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlVeteranLeadsByProgram" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct  vl.id, v.id VeteranID, case when vpo.Occupation is null then cast(0 as bit) else cast(1 as bit) end OccupationIsPublished, vl.LeadStatusId, vl.LeadOutcomeID, vl.Id as 'LeadID', v.LastName + ', ' + FirstName + ' ' + Coalesce(MiddleName,' ') as 'FullName', v.Email, v.MobilePhone, v.HomePhone, v.City, v.CityId, v.State, v.ZipCode, v.DNC_FLG, CASE WHEN v.WARN_FLG = 'X' THEN 'X' ELSE ' ' END AS WARN_FLG, vl.OccupationCode as Occupation, Coalesce(Title,'Unknown') as OccupationTitle, vl.CampaignId, vl.ToBeContacted, units.Units from ( select distinct vl.LeadOutcomeID, vl.LeadStatusId, vl.ID, vl.CampaignID, vl.active, vo.OccupationCode, vo.VeteranId, vo.CollegeId, vl.ToBeContacted from VeteranOccupation vo left join VeteranLead vl on vo.VeteranID = vl.VeteranId union select distinct vl.LeadOutcomeID, vl.LeadStatusId, vl.ID, vl.CampaignID, vl.active, v.Occupation, vl.VeteranID, c.CollegeID, vl.ToBeContacted from VeteranLead vl join Veteran v on vl.VeteranID = v.id join Campaign c on vl.CampaignID = c.ID ) vl join Veteran v on vl.VeteranId = v.id left outer join View_MostCurrentOccupation moc on vl.OccupationCode = moc.occupation left outer join ( select * from ViewPublishedOccupations where college_id = @CollegeID) vpo on vl.OccupationCode = vpo.Occupation left outer join ( select distinct pub.outline_id, pc.program_id, pub.Occupation from ( select cco.outline_id, ao.Occupation  from Articulation cco left outer join AceExhibit ao on cco.AceID = ao.AceID and cco.TeamRevd = ao.TeamRevd where cco.ArticulationStatus = 2 and cco.ArticulationType = 2 and cco.CollegeID = @CollegeID ) pub left outer join tblProgramCourses pc on pub.outline_id = pc.outline_id ) prog on vl.OccupationCode = prog.Occupation left outer join ( select a.Occupation, sum(cast(a.unit as float)) as Units from ( select distinct ocups.Occupation, u.unit, a.outline_id, pc.program_id from Articulation a left outer join AceExhibit ocups on a.AceID = ocups.AceID and a.TeamRevd = ocups.TeamRevd left outer join Course_IssuedForm cif on a.outline_id = cif.outline_id left outer join tblLookupUnits u on cif.unit_id = u.unit_id left outer join tblProgramCourses pc on a.outline_id = pc.outline_id where a.ArticulationType in(1, 2) and a.ArticulationStatus = 2 and cif.college_id = @CollegeID and coalesce(pc.program_id,'0') IN (select value from fn_split(@Program,',')) ) a group  by a.Occupation ) units on vl.OccupationCode = units.Occupation where VL.ACTIVE = 1 AND vl.CampaignID = @CampaignID and coalesce(prog.program_id,'0') IN (select value from fn_split(@Program,','))" UpdateCommand="Update VeteranLead SET [ToBeContacted] = @ToBeContacted WHERE [Id] = @Id">
        <SelectParameters>
            <asp:Parameter DbType="String" Name="Program" />
            <asp:ControlParameter ControlID="rgCampaigns" Name="CampaignID" PropertyName="SelectedValue" Type="Int32"></asp:ControlParameter>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="ToBeContacted" Type="Boolean" />
            <asp:Parameter Name="ID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlLeadActivities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [LeadAction] WHERE [ID] = @ID" InsertCommand="INSERT INTO [LeadAction] ([Description], [LeadID], [ActionID], [ActionType], [DueDate], [LeadStatusID], [LeadOutcomeID], [Notes], [CreatedBy]) VALUES (@Description, @LeadID, @ActionID, @ActionType, @DueDate, @LeadStatusID, @LeadOutcomeID, @Notes, @CreatedBy)" SelectCommand="SELECT * FROM [LeadAction] WHERE ([LeadID] = @LeadID )" UpdateCommand="UPDATE [LeadAction] SET [Description] = @Description, [ActionID] = @ActionID, [ActionType] = @ActionType, [DueDate] = @DueDate, [LeadStatusID] = @LeadStatusID, [LeadOutcomeID] = @LeadOutcomeID, [Notes] = @Notes,  [UpdatedBy] = @UpdatedBy, [UpdatedOn] = getdate() WHERE [ID] = @ID">
        <SelectParameters>
            <asp:Parameter Name="LeadID" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="LeadID" Type="Int32" />
            <asp:Parameter Name="ActionID" Type="Int32" />
            <asp:Parameter Name="ActionType" Type="Int32" />
            <asp:Parameter Name="DueDate" Type="DateTime" />
            <asp:Parameter Name="LeadStatusID" Type="Int32" />
            <asp:Parameter Name="LeadOutcomeID" Type="Int32" />
            <asp:Parameter Name="Notes" Type="String" />
            <asp:SessionParameter Name="CreatedBy" SessionField="UserID" Type="Int32" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="ActionID" Type="Int32" />
            <asp:Parameter Name="ActionType" Type="Int32" />
            <asp:Parameter Name="DueDate" Type="DateTime" />
            <asp:Parameter Name="LeadStatusID" Type="Int32" />
            <asp:Parameter Name="LeadOutcomeID" Type="Int32" />
            <asp:Parameter Name="Notes" Type="String" />
            <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="ID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlActionType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from ActionType" />
    <asp:SqlDataSource ID="sqlActionsActivities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from Action where [CollegeID] = @CollegeID order by Description">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, City + ' - ' + State as 'FullCity' from City order by  City" />
    <asp:SqlDataSource ID="sqlColleges" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select CollegeID, CollegeAbbreviation from LookupColleges where  DistrictID in (select DistrictID from tblDistrictCollege where CollegeID = @CollegeID)">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest" ClientEvents-OnRequestStart="onRequestStart">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <div class="container-fluid">
            <div class="row" style="margin: 0 0 10px 0;">
                <div class="col-md-12">
                    <asp:HiddenField ID="hfCampaignID" runat="server" />
                    <asp:HiddenField ID="hfCampaignDescription" runat="server" />
                    <asp:HiddenField ID="hvExcludeArticulationOverYears" runat="server" />

                    <h2 class="mb-2">Campaigns</h2>

                    <telerik:RadGrid ID="rgCampaigns" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" DataSourceID="sqlCampaigns" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" OnItemCommand="rgCampaigns_ItemCommand" OnItemDataBound="rgCampaigns_ItemDataBound" RenderMode="Lightweight">
                        <ClientSettings AllowKeyboardNavigation="true" EnablePostBackOnRowClick="true">
                            <ClientEvents OnPopUpShowing="popUpShowing" />
                            <Selecting AllowRowSelect="true"></Selecting>
                        </ClientSettings>
                        <MasterTableView Name="ParentGrid" DataSourceID="sqlCampaigns" PageSize="12" DataKeyNames="ID" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                            <CommandItemTemplate>
                                <div class="commandItems">
                                    <telerik:RadButton runat="server" ID="btnAddCampaign" Text="Add new Campaign" ButtonType="LinkButton" CommandName="AddCampaign">
                                        <Icon PrimaryIconCssClass="rbAdd"></Icon>
                                    </telerik:RadButton>
                                    <telerik:RadButton runat="server" ID="btnEditCampaign" Text="Edit Campaign" ButtonType="LinkButton" CommandName="EditCampaign" ToolTip="Click here to edit the selected campaign">
                                        <Icon PrimaryIconCssClass="rbOpen"></Icon>
                                    </telerik:RadButton>
                                </div>
                            </CommandItemTemplate>
                            <CommandItemSettings ShowExportToExcelButton="True" />
                            <Columns>
                                <telerik:GridTemplateColumn HeaderStyle-Width="40px">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" Visible="false" ToolTip="Upload Vets to this campaign." CommandName="Upload" ID="btnUpload" Text='<i class="fa fa-upload" aria-hidden="true"></i>' />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Description" UniqueName="Description" HeaderText="Campaign" HeaderStyle-Font-Bold="true" ColumnEditorID="CEDescription">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="CampaignStatus" FilterControlAltText="Filter CampaignStatus column" HeaderText="Status" SortExpression="CampaignStatus" UniqueName="CampaignStatus" DataSourceID="sqlCampaignStatus" ListTextField="description" ListValueField="id" AllowFiltering="false" HeaderStyle-Font-Bold="true">
                                </telerik:GridDropDownColumn>
                                <telerik:GridDropDownColumn DataField="SemesterID" FilterControlAltText="Filter SemesterID column" HeaderText="Semester" SortExpression="SemesterID" UniqueName="SemesterID" DataSourceID="sqlSemesters" ListTextField="semestername" ListValueField="id" AllowFiltering="false" HeaderStyle-Font-Bold="true">
                                </telerik:GridDropDownColumn>
                                <telerik:GridHTMLEditorColumn DataField="Notes" FilterControlAltText="Filter Notes column" SortExpression="Notes" UniqueName="Notes" HeaderStyle-Font-Bold="true" HeaderText="Notes" Display="false" ColumnEditorID="CEEditor">
                                </telerik:GridHTMLEditorColumn>
                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this Campaign ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>
                            <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Campaign: {0}" CaptionDataField="Description">
                                <PopUpSettings Height="560px" Modal="True" Width="600px" />
                            </EditFormSettings>
                        </MasterTableView>
                    </telerik:RadGrid>

                </div>
            </div>
            <asp:Panel ID="pnlProgramSelection" runat="server" Visible="false">
                <div class="row" style="margin: 0 0 10px 0;">
                    <div class="col-md-2" style="margin-top: 5px; font-weight: bold;">
                        <telerik:RadCheckBox ID="rcbFilterByPrograms" runat="server" Text="Filter Veterans by Program(s) of Study" AutoPostBack="true" OnCheckedChanged="rcbFilterByPrograms_CheckedChanged" ToolTip=""></telerik:RadCheckBox>
                    </div>
                    <div class="col-md-8">
                        <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct ua.program_id, ua.program from View_UnitsAwarded ua left outer join Program_IssuedForm pif on ua.program_id = pif.program_id where ua.college_id = @CollegeID and pif.status = 0 order by ua.program">
                            <SelectParameters>
                                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:Panel ID="pnlPrograms" runat="server" Visible="false">
                            <telerik:RadComboBox ID="rcbPrograms" Text="" Label="Select a program(s) : " runat="server" DataSourceID="sqlPrograms" DataTextField="program" DataValueField="program_id" AutoPostBack="true" CheckBoxes="true" Width="700px" AppendDataBoundItems="true" AllowCustomText="true" Filter="Contains" OnPreRender="rcbPrograms_PreRender" OnSelectedIndexChanged="rcbPrograms_SelectedIndexChanged" RenderMode="Lightweight" ToolTip="Please select the Program(s) of Study with Articulated and Published Courses.">
                            </telerik:RadComboBox>
                            <asp:Panel ID="pnlProgramsResult" runat="server">
                                <div style="margin-top: 10px;">
                                    <asp:Label ID="lblTotalVeterans" CssClass="alert alert-info" runat="server"></asp:Label>
                                    <asp:Label ID="lblTotalUnits" CssClass="alert alert-info" runat="server"></asp:Label>
                                </div>
                                <div id="divSelectedPrograms" cssclass="alert alert-info" runat="server"></div>
                            </asp:Panel>
                        </asp:Panel>
                        <asp:SqlDataSource ID="sqlACEExhibit" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT AceID, CONCAT(CASE WHEN AceType = 1 THEN '[Course]' ELSE '[Occupation]' END,' ',AceID,' - ',Title) Exhibit from ACEExhibit"></asp:SqlDataSource>
                        <telerik:RadAutoCompleteBox ID="racbAceExhibit" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="20" DropDownHeight="200" DataSourceID="sqlACEExhibit" DataTextField="Exhibit" EmptyMessage="Advanced search..." DataValueField="AceID" ClientIDMode="Static" AllowCustomEntry="true" HighlightFirstMatch="true" Delimiter=",">
                        </telerik:RadAutoCompleteBox>
                    </div>
                    <div class="col-md-2">
                        <telerik:RadButton ID="rbExhibitSearch" runat="server" Text="Search" AutoPostBack="true" OnClick="rbExhibitSearch_Click"></telerik:RadButton>
                        <telerik:RadButton ID="rbExhibitSearchClear" runat="server" Text="Clear" AutoPostBack="true" OnClick="rbExhibitSearchClear_Click"></telerik:RadButton>
                    </div>
                </div>
            </asp:Panel>
            <div class="row">
                <div class="col-md-12">
                    <telerik:RadGrid ID="rgVeteranLeads" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlVeteranLeads" Width="100%" GroupingSettings-CaseSensitive="false" OnItemCommand="rgVeteranLeads_ItemCommand" AllowAutomaticUpdates="true" RenderMode="Lightweight" OnItemDataBound="rgVeteranLeads_ItemDataBound">
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" CaseSensitive="false" />
                        <ExportSettings FileName="VeteransLeadsReport" ExportOnlyData="True" IgnorePaging="True">
                        </ExportSettings>
                        <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" AllowKeyboardNavigation="true" Resizing-AllowColumnResize="true" EnablePostBackOnRowClick="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                            <ClientEvents OnPopUpShowing="popUpShowing" OnFilterMenuShowing="FilteringMenu" />
                        </ClientSettings>
                        <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlVeteranLeads" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="Top" NoMasterRecordsText="No records to display" EditMode="Batch" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" DataKeyNames="LeadID" Name="ParentGrid">
                            <BatchEditingSettings EditType="Cell" />
                            <CommandItemTemplate>
                                <div class="commandItems">
                                    <telerik:RadButton runat="server" ID="btnAddveterans" Text="Add Veterans" ButtonType="LinkButton" ToolTip="Click here to add Veterans to this campaign" CommandName="AddVeterans">
                                        <Icon PrimaryIconCssClass="rbAdd"></Icon>
                                    </telerik:RadButton>
                                    <telerik:RadButton runat="server" ID="btnSaveAll" Text="Save changes" ButtonType="LinkButton" AutoPostBack="false" OnClientClicked="saveGridChanges" ToolTip="Click here to update the Only Contacted flag column for the selected veteran(s)">
                                        <Icon PrimaryIconCssClass="rbSave"></Icon>
                                    </telerik:RadButton>
                                    <telerik:RadButton runat="server" ID="btnPrintVeteranLetter" ToolTip="Print Preview Veteran Letter for the selected veteran" CommandName="PrintVeteranLetter" Text="Print Veteran Letter" ButtonType="LinkButton">
                                        <Icon PrimaryIconCssClass="rbPrint"></Icon>
                                    </telerik:RadButton>
                                    <telerik:RadButton runat="server" ID="btnEditLead" ToolTip="Select the veteran and click here to edit his/her related information." CommandName="EditLead" Text="Edit Veteran Related Information" ButtonType="LinkButton">
                                        <Icon PrimaryIconCssClass="rbOpen"></Icon>
                                    </telerik:RadButton>
                                    <telerik:RadButton runat="server" ID="btnFlag" ToolTip="Click here to flag all veterans on this page to be contacted" CommandName="FlagToBeContacted" Text="Flag Veterans to be Contacted" ButtonType="LinkButton">
                                        <Icon PrimaryIconCssClass="rbOk"></Icon>
                                    </telerik:RadButton>
                                    <telerik:RadButton runat="server" ID="btnAddArticulation" ToolTip="Click here to create an articulation" CommandName="AddArticulation" Text="Add Articulation" ButtonType="LinkButton">
                                        <Icon PrimaryIconCssClass="rbOk"></Icon>
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="btnExcel" runat="server" Text="Print" ButtonType="StandardButton" CommandName="ExportToExcel" ToolTip="Click here to export veteran list to Excel ">
                                        <ContentTemplate>
                                            <i class='fa fa-file-excel-o'></i>Export to Excel
                                        </ContentTemplate>
                                    </telerik:RadButton>
                                </div>
                            </CommandItemTemplate>
                            <CommandItemSettings ShowExportToExcelButton="True" />
                            <Columns>
                                <telerik:GridButtonColumn ButtonType="LinkButton" CommandName="DeleteVeteran" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Are you sure you want to remove this Veteran from the current campaign? " ConfirmTitle="Delete" HeaderStyle-Width="50px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                    <HeaderStyle Width="60px" />
                                </telerik:GridButtonColumn>
                                <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="LeadId" UniqueName="LeadId" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn DataField="ToBeContacted" DataType="System.Boolean" HeaderText="Only Contacted" UniqueName="ToBeContacted" AllowFiltering="true" HeaderStyle-Width="65px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" FilterControlToolTip="Filter By Contacted Veterans Only">
                                    <ItemTemplate>
                                        <asp:CheckBox runat="server" ID="CheckBox1" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("ToBeContacted")) %>' onclick="checkBoxClick(this, event);" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:CheckBox runat="server" ID="CheckBox2" />
                                    </EditItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="StudentID" UniqueName="StudentID" HeaderText="Student ID" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="90px" ItemStyle-Width="75px" FilterControlWidth="60px">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="CollegeAbbreviation" UniqueName="CollegeAbbreviation" HeaderText="College" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="100px" ItemStyle-Width="95px" FilterControlWidth="50px">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="VeteranID" UniqueName="VeteranID" Display="false">
                                </telerik:GridBoundColumn>                             
                                <telerik:GridBoundColumn DataField="FullName" FilterControlAltText="Filter FullName column" HeaderText="Veteran" SortExpression="FullName" UniqueName="FullName" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" ItemStyle-Wrap="false" />
                                <telerik:GridDropDownColumn DataField="CampaignID" FilterControlAltText="Filter CampaignID column" HeaderText="Campaign" SortExpression="CampaignID" UniqueName="CampaignID" DataSourceID="sqlCampaigns" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true" Display="false" ReadOnly="true">
                                    <FilterTemplate>
                                        <telerik:RadComboBox ID="RadComboBoxCampaign" DataSourceID="sqlCampaigns" DataTextField="Description"
                                            DataValueField="id" Height="200px" Width="100px" DropDownAutoWidth="Enabled" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("CampaignID").CurrentFilterValue %>'
                                            runat="server" OnClientSelectedIndexChanged="CampaignIndexChanged">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="All" />
                                            </Items>
                                        </telerik:RadComboBox>
                                        <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                            <script type="text/javascript">
                                                function CampaignIndexChanged(sender, args) {
                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                    tableView.filter("CampaignID", args.get_item().get_value(), "EqualTo");
                                                }
                                            </script>
                                        </telerik:RadScriptBlock>
                                    </FilterTemplate>
                                </telerik:GridDropDownColumn>
                                <telerik:GridDropDownColumn DataField="LeadStatusID" FilterControlAltText="Filter LeadStatusID column" HeaderText="Status" SortExpression="LeadStatusID" UniqueName="LeadStatusID" DataSourceID="sqlLeadStatus" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true" Display="false" ReadOnly="true">
                                    <FilterTemplate>
                                        <telerik:RadComboBox ID="RadComboBoxStatus" DataSourceID="sqlLeadStatus" DataTextField="Description"
                                            DataValueField="id" Height="200px" Width="100px" DropDownAutoWidth="Enabled" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("LeadStatusID").CurrentFilterValue %>'
                                            runat="server" OnClientSelectedIndexChanged="StatusIndexChanged">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="All" />
                                            </Items>
                                        </telerik:RadComboBox>
                                        <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                            <script type="text/javascript">
                                                function StatusIndexChanged(sender, args) {
                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                    tableView.filter("LeadStatusID", args.get_item().get_value(), "EqualTo");
                                                }
                                            </script>
                                        </telerik:RadScriptBlock>
                                    </FilterTemplate>
                                </telerik:GridDropDownColumn>
                                <telerik:GridDropDownColumn DataField="LeadOutcomeID" FilterControlAltText="Filter LeadOutcomeID column" HeaderText="Outcome" SortExpression="LeadOutcomeID" UniqueName="LeadOutcomeID" DataSourceID="sqlLeadOutcome" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true" Display="false" ReadOnly="true">
                                    <FilterTemplate>
                                        <telerik:RadComboBox ID="RadComboBoxOutcome" DataSourceID="sqlLeadOutcome" DataTextField="Description"
                                            DataValueField="id" Height="200px" Width="100px" DropDownAutoWidth="Enabled" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("LeadOutcomeID").CurrentFilterValue %>'
                                            runat="server" OnClientSelectedIndexChanged="OutcomeIndexChanged">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="All" />
                                            </Items>
                                        </telerik:RadComboBox>
                                        <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                                            <script type="text/javascript">
                                                function OutcomeIndexChanged(sender, args) {
                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                    tableView.filter("LeadOutcomeID", args.get_item().get_value(), "EqualTo");
                                                }
                                            </script>
                                        </telerik:RadScriptBlock>
                                    </FilterTemplate>
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn DataField="Email" UniqueName="Email" HeaderText="Email" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" Display="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridCheckBoxColumn DataField="OccupationIsPublished" DataType="System.Boolean" HeaderText="Only Arts. in Implementation" UniqueName="OccupationIsPublished" AllowFiltering="true" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ReadOnly="true" FilterControlToolTip="Show Only Veteran occupations articulated and published" >
                                </telerik:GridCheckBoxColumn>
                                <telerik:GridBoundColumn DataField="Occupation" UniqueName="Occupation" HeaderText="Occupation Code" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="90px" ItemStyle-Width="75px" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn UniqueName="TemplateLinkColumn" DataField="Occupation" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" AllowFiltering="True" HeaderStyle-Font-Bold="true" HeaderText="Occupation Code" HeaderStyle-Width="90px" ItemStyle-Width="75px" FilterControlWidth="50px" Display="false">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkShowOccupation" CommandName="ShowOccupation" runat="server"><i class="fa fa-info-circle" aria-hidden="true"></i></asp:LinkButton>
                                        <%# DataBinder.Eval(Container, "DataItem.Occupation") %>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="OccupationTitle" UniqueName="OccupationTitle" HeaderText="Occupation Title" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="140px" ItemStyle-Width="110px" FilterControlWidth="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-Wrap="false" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="MobilePhone" UniqueName="MobilePhone" HeaderText="Mobile Phone" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="80px" ItemStyle-Width="55px" FilterControlWidth="45px">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="HomePhone" UniqueName="HomePhone" HeaderText="Home Phone" HeaderStyle-Font-Bold="true" Display="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="80px" ItemStyle-Width="55px" FilterControlWidth="45px" HeaderStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridHTMLEditorColumn DataField="Notes" FilterControlAltText="Filter Notes column" SortExpression="Notes" UniqueName="Notes" HeaderStyle-Font-Bold="true" HeaderText="Notes" Display="false" ReadOnly="true">
                                </telerik:GridHTMLEditorColumn>
                                <telerik:GridBoundColumn DataField="City" UniqueName="City" HeaderText="City" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="80px" ItemStyle-Width="85px" FilterControlWidth="55px" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="CityId" FilterControlAltText="Filter CityId column" HeaderText="City" SortExpression="CityId" UniqueName="CityId" DataSourceID="sqlCities" ListTextField="FullCity" ListValueField="id" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                    <FilterTemplate>
                                        <telerik:RadComboBox ID="RadComboBoxCitites" DataSourceID="sqlCities" DataTextField="FullCity"
                                            DataValueField="id" Height="200px" Width="100px" DropDownAutoWidth="Enabled" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("CityId").CurrentFilterValue %>'
                                            runat="server" OnClientSelectedIndexChanged="CityIndexChanged" RenderMode="Lightweight">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="All" />
                                            </Items>
                                        </telerik:RadComboBox>
                                        <telerik:RadScriptBlock ID="RadScriptBlock7" runat="server">
                                            <script type="text/javascript">
                                                function CityIndexChanged(sender, args) {
                                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                    tableView.filter("CityId", args.get_item().get_value(), "EqualTo");
                                                }
                                            </script>
                                        </telerik:RadScriptBlock>
                                    </FilterTemplate>
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn DataField="ZipCode" UniqueName="ZipCode" HeaderText="Zip Code" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="90px" ItemStyle-Width="75px" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="DNC_FLG" UniqueName="DNC_FLG" HeaderText="Do Not Call" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="70px" ItemStyle-Width="55px" FilterControlWidth="35px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="WARN_FLG" UniqueName="WARN_FLG" HeaderText="Address Warning" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="70px" ItemStyle-Width="55px" FilterControlWidth="35px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Units" UniqueName="Units" HeaderText="Units Awarded" HeaderStyle-Font-Bold="true" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" HeaderStyle-Width="70px" ItemStyle-Width="55px" FilterControlWidth="35px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                            </Columns>
                            <NoRecordsTemplate>
                                <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                    &nbsp;No items to view
                                </div>
                            </NoRecordsTemplate>
                        </MasterTableView>
                    </telerik:RadGrid>

                    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
                        <SelectParameters>
                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="sqlArticulationsByOccupationCode" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT [dbo].[GetArticulationMatrix](ac.id) 'Matrix', ac.LastSubmittedOn as LastSubmitted, (SELECT STUFF((SELECT ',' + criteria FROM ArticulationCriteria where ArticulationID = ac.ArticulationID	and ArticulationType = ac.ArticulationType FOR XML PATH('')) ,1,1,'')) AS SelectedCriteria, sub.subject , cif.course_number , cif.course_title, case when ac.ArticulationType = 1 then 'ACE Course' else 'Occupation' end as 'ArticulationTypeName', ac.ArticulationID, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, ac.Title, ac.TeamRevd, ac.CreatedOn, cc.Occupation , ac.outline_id, s.RoleID, ac.id, ac.ArticulationType, ac.ArticulationStatus, ac.ArticulationStage ,  case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Office Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes,  ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id',   concat(mu.firstname , ', ' , mu.lastname) as 'FullName' , ac.ModifiedBy, ac.Articulate, ac.CollegeID,  (select count(*) from Articulation a left outer join LookupColleges c on a.CollegeID = c.CollegeID where a.Articulate = 0 and c.CheckExistOtherColleges = 1 and a.CollegeID <> @CollegeID and a.AceID = ac.AceID and a.TeamRevd = ac.TeamRevd) as HaveDeniedArticulations FROM ( select AceID, TeamRevd from VeteranACECourse where VeteranId = @VeteranID union select o.AceID, o.TeamRevd from VeteranOccupation vo join AceExhibit o on vo.OccupationCode = o.Occupation where vo.VeteranId = @VeteranID union select o.AceID, o.TeamRevd from Veteran v join ACEExhibit o on v.Occupation = o.Occupation where v.id = @VeteranID ) VA left outer join Articulation ac on va.AceID = ac.AceID and va.TeamRevd = ac.TeamRevd LEFT OUTER JOIN ACEExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd LEFT OUTER JOIN tblusers u on ac.CreatedBy = u.userid LEFT OUTER JOIN TBLUSERS mu on ac.LastSubmittedBy = mu.UserID LEFT OUTER JOIN Stages s on ac.ArticulationStage = s.Id LEFT OUTER JOIN Course_IssuedForm cif on ac.outline_id = cif.outline_id LEFT OUTER JOIN tblsubjects sub ON cif.subject_id = sub.subject_id WHERE cif.[college_id] = @CollegeID and ac.ArticulationStatus = 1 and ac.ArticulationStage = [DBO].GetMaximumStageId(ac.CollegeID) ORDER BY ac.LastSubmittedOn DESC">
                        <SelectParameters>
                            <asp:Parameter Name="Occupation" Type="String"></asp:Parameter>
                            <asp:Parameter Name="VeteranID" Type="Int32"></asp:Parameter>
                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:Panel ID="pnlArticulations" runat="server">
                        <h3 id="OccupationCodeTitle" runat="server"></h3>
                        <telerik:RadGrid ID="rgArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationsByOccupationCode" AllowFilteringByColumn="true" AllowPaging="True" GroupingSettings-CaseSensitive="false" OnItemCommand="rgArticulations_ItemCommand" RenderMode="Lightweight" OnItemDataBound="rgArticulations_ItemDataBound" AllowMultiRowSelection="true">
                            <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="true" />
                                <ClientEvents OnRowContextMenu="demo.RowContextMenu" OnFilterMenuShowing="FilteringMenu" />
                            </ClientSettings>
                            <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulationsByOccupationCode" PageSize="8" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
                                <Columns>
                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false">
                                        <ItemTemplate>
                                            <asp:LinkButton Visible="false" runat="server" ToolTip="Have denied articulation(s) in other colleges." CommandName="AdoptArticulations" ID="btnHaveDeniedArticulations" Text='<i class="fa fa-ban" aria-hidden="true"></i>' />
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn DataField="HaveDeniedArticulations" UniqueName="HaveDeniedArticulations" Display="false" Exportable="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" Exportable="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="50px">
                                        <FilterTemplate>
                                            <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                                DataValueField="subject" MaxHeight="200px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged2">
                                                <Items>
                                                    <telerik:RadComboBoxItem Text="All" />
                                                </Items>
                                            </telerik:RadComboBox>
                                            <telerik:RadScriptBlock ID="RadScriptBlock43" runat="server">
                                                <script type="text/javascript">
                                                    function SubjectIndexChanged2(sender, args) {
                                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                        tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                    }
                                                </script>
                                            </telerik:RadScriptBlock>
                                        </FilterTemplate>
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="true" ShowSortIcon="true" AllowSorting="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn UniqueName="ArticulationTypeName" DataField="ArticulationTypeName" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" AllowFiltering="True" HeaderStyle-Font-Bold="true" HeaderText="Type" HeaderStyle-Width="90px" ItemStyle-Width="75px" FilterControlWidth="50px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkShowExhibit" CommandName="ShowACEExhibit" runat="server"><i class="fa fa-info-circle" aria-hidden="true"></i></asp:LinkButton>
                                            <%# DataBinder.Eval(Container, "DataItem.ArticulationTypeName") %>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="90px" AllowFiltering="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="190px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false" EmptyDataText="">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes">
                                        <ItemTemplate>
                                            <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                            <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                                                <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                                            </telerik:RadToolTip>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn SortExpression="SelectedCriteria" HeaderText="Credit Recommendation" DataField="SelectedCriteria" UniqueName="SelectedCriteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Submitted By" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="100px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDateTimeColumn DataField="CreatedOn" DataType="System.DateTime" FilterControlAltText="Filter CreatedOn column" HeaderText="Created On" SortExpression="CreatedOn" UniqueName="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true" Display="false">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridDateTimeColumn DataField="LastSubmitted" DataType="System.DateTime" FilterControlAltText="Filter LastSubmitted column" HeaderText="Last Submitted" SortExpression="LastSubmitted" UniqueName="LastSubmitted" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="CollegeID" UniqueName="CollegeID" Display="false"></telerik:GridBoundColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                        <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" runat="server" />
                        <input type="hidden" id="radGridClickedRowIndexAdopt" name="radGridClickedRowIndexAdopt" runat="server" />
                        <input type="hidden" id="hvOutlineID" name="hvOutlineID" runat="server" />
                        <input type="hidden" id="hvID" name="hvID" runat="server" />
                        <input type="hidden" id="hvArticulationID" name="hvArticulationID" runat="server" />
                        <input type="hidden" id="hvArticulationType" name="hvArticulationType" runat="server" />
                        <input type="hidden" id="hvArticulationStage" name="hvArticulationStage" runat="server" />
                        <input type="hidden" id="hvAceID" name="hvAceID" runat="server" />
                        <input type="hidden" id="hvTeamRevd" name="hvTeamRevd" runat="server" />
                        <input type="hidden" id="hvTitle" name="hvTitle" runat="server" />
                        <telerik:RadContextMenu ID="RadMenu1" runat="server" OnItemClick="RadMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
                            <Items>
                                <telerik:RadMenuItem Text="Edit" Value="Edit">
                                </telerik:RadMenuItem>
                                <telerik:RadMenuItem Text="View" Value="View">
                                </telerik:RadMenuItem>
                            </Items>
                        </telerik:RadContextMenu>
                    </asp:Panel>
                </div>
            </div>
        </div>
        <telerik:GridTextBoxColumnEditor ID="CEDescription" TextBoxStyle-Width="500px" TextBoxMaxLength="200" runat="server" />
        <telerik:GridTextBoxColumnEditor ID="CEDescriptionAction" TextBoxStyle-Width="290px" TextBoxMaxLength="200" runat="server" />
        <telerik:GridHTMLEditorColumnEditor ID="CEEditor" Editor-BackColor="White" runat="server" Editor-ContentAreaCssFile="~/Common/css/Editor.css" />
        <telerik:GridHTMLEditorColumnEditor ID="CEEditorAction" Editor-BackColor="White" Editor-Width="200px" Editor-Height="200px" runat="server" Editor-ContentAreaCssFile="~/Common/css/Editor.css" />
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        ; (function ($, undefined) {
            var menu;
            var grid;
            var demo = window.demo = {};

            Sys.Application.add_load(function () {
                grid = $telerik.findControl(document, "rgArticulations");
                menu = $telerik.findControl(document, "RadMenu1");
            });

            demo.RowContextMenu = function (sender, eventArgs) {
                var evt = eventArgs.get_domEvent();
                if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
                    return;
                }

                var index = eventArgs.get_itemIndexHierarchical();

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

                $('#<%=hvOutlineID.ClientID%>').val(outline_id);
                $('#<%=hvID.ClientID%>').val(id);
                $('#<%=hvArticulationID.ClientID%>').val(articulation_id);
                $('#<%=hvArticulationType.ClientID%>').val(articulation_type);
                $('#<%=hvArticulationStage.ClientID%>').val(articulation_stage);
                $('#<%=hvAceID.ClientID%>').val(ace_id);
                $('#<%=hvTeamRevd.ClientID%>').val(team_revd);
                $('#<%=hvTitle.ClientID%>').val(title);

                menu.show(evt);
                evt.cancelBubble = true;
                evt.returnValue = false;

                if (evt.stopPropagation) {
                    evt.stopPropagation();
                    evt.preventDefault();
                }
            };

        })($telerik.$);
    </script>
    <script type="text/javascript">
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function saveGridChanges(sender, args) {
            var grid = $find("<%=rgVeteranLeads.ClientID%>");
            var batchManager = grid.get_batchEditingManager();
            batchManager.saveAllChanges();
        }
        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }
        function checkBoxClick(sender, args) {
            var grid = $find("<%= rgVeteranLeads.ClientID %>");
            var masterTableView = grid.get_masterTableView();
            var batchEditingManager = grid.get_batchEditingManager();
            var parentCell = $telerik.$(sender).closest("td")[0];

            var initialValue = sender.checked;
            sender.checked = !sender.checked;

            batchEditingManager.changeCellValue(parentCell, initialValue);
        }
    </script>
</asp:Content>
