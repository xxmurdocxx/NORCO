<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Exhibits.aspx.cs" Inherits="ems_app.modules.settings.Exhibits1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <style>
        .reContent {
            height:98% !important;
        }
        .reBottomProperties {
            display:none !important;
        }
        .RadCalendar .t-font-icon::before {
          font: 16px/1.25 "WebComponentsIcons" !important;
        }
        .skill-levels table td:nth-child(2){
            text-align:right;
        }
        .RadEditor_Material .reContent h1,h2,h3 {            font-size:13px !important;            font-weight:bold !important;        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlExhibits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select top 100 * , b.SkillLevels as 'SkilLevelList' FROM ACEExhibit a left outer join [ACEExhibitSkillLevels] b on a.AceID = b.AceID and a.AceType = b.AceType and a.TeamRevd = b.TeamRevd and a.StartDate = b.StartDate and a.EndDate = b.EndDate WHERE (@SourceID IS NULL or (@SourceID IS NOT NULL and a.SourceID = @SourceID)) and (@AceType IS NULL or (@AceType IS NOT NULL and a.AceType = @AceType)) ORDER BY a.AceID , a.TeamRevd" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:ControlParameter Name="SourceID" ControlID="rcbSource" ConvertEmptyStringToNull="true" PropertyName="SelectedValue" />
            <asp:ControlParameter Name="AceType" ControlID="rcbAceType" ConvertEmptyStringToNull="true" PropertyName="SelectedValue" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="AceID" Type="String" />
            <asp:Parameter Name="VersionNumber" Type="String" />
            <asp:Parameter Name="AceType" Type="Int32" />
            <asp:Parameter Name="TeamRevd" Type="DateTime" />
            <asp:Parameter Name="StartDate" Type="DateTime" />
            <asp:Parameter Name="EndDate" Type="DateTime" />
            <asp:Parameter Name="Title" Type="String" />
            <asp:Parameter Name="ExhibitDisplay" Type="String" />
            <asp:Parameter Name="SourceID" Type="Int32" />
            <asp:Parameter Name="id" Type="Int32" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="ID" Type="Int32" />
            <asp:Parameter Name="VersionNumber" Type="String" />
            <asp:Parameter Name="TeamRevd" Type="DateTime" />
            <asp:Parameter Name="StartDate" Type="DateTime" />
            <asp:Parameter Name="EndDate" Type="DateTime" />
            <asp:Parameter Name="Title" Type="String" />
            <asp:Parameter Name="ExhibitDisplay" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 1 as id, 'Course' as description union select 2 as id , 'Occupation' as description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSource" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from ACEExhibitSource"></asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="0" Width="350" Height="110" Title="Notification" EnableRoundedCorners="false">
        </telerik:RadNotification>
        <div class="row">
            <div class="col-6">

            </div>
            <div class="col-6">
                <telerik:RadComboBox ID="rcbAceType" runat="server" AutoPostBack="true" Width="250px"  RenderMode="Lightweight" Label="Exhibit Type : " DropDownAutoWidth="Enabled" Visible="false">
                    <Items>
                        <telerik:RadComboBoxItem Value="" Text="All" Selected="true" />
                        <telerik:RadComboBoxItem Value="1" Text="Course" />
                        <telerik:RadComboBoxItem Value="2" Text="Occupation" />
                    </Items>
                </telerik:RadComboBox>
                <asp:SqlDataSource ID="sqlSources" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select Id, (ShortDescription + ' - ' + SourceName) as source_descr from ACEExhibitSource where statusExhibitSource = 1">
                </asp:SqlDataSource>
                <telerik:RadComboBox ID="rcbSource" runat="server" AutoPostBack="true" Width="250px" DataSourceID="sqlSources" DataTextField="source_descr" DataValueField="id" AppendDataBoundItems="true" RenderMode="Lightweight" Label="Exhibit Source : " DropDownAutoWidth="Enabled">
                    <Items>
                        <telerik:RadComboBoxItem Value="" Text="All" Selected="true" />
                    </Items>
                </telerik:RadComboBox>
            </div>
        </div>
        <telerik:RadGrid ID="rgExhibits" runat="server" CellSpacing="-1" DataSourceID="sqlExhibits" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" OnItemCommand="rgExhibits_ItemCommand" OnItemDataBound="rgExhibits_ItemDataBound" AllowAutomaticInserts="true" OnItemCreated="rgExhibits_ItemCreated" OnUpdateCommand="rgExhibits_UpdateCommand" RenderMode="Lightweight" FilterType="HeaderContext" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" OnInsertCommand="rgExhibits_InsertCommand">
            <ExportSettings ExportOnlyData="true" FileName="ProgramsOfStudy" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
            </ExportSettings>
            <GroupingSettings CaseSensitive="false" />
            <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                <ClientEvents OnRowDblClick="RowDblClick"></ClientEvents>
            </ClientSettings>
            <MasterTableView DataSourceID="sqlExhibits" DataKeyNames="ID" CommandItemDisplay="Top" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Font-Bold="true" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true">
                <CommandItemSettings ShowExportToExcelButton="true" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                <CommandItemTemplate>
                    <div class="commandItems">
                        <telerik:RadButton ID="btnAdd" runat="server" ToolTip="Add Exhibit." CommandName="InitInsert" CssClass="rgAdd" Text=" Add Exhibit" ButtonType="LinkButton">
                            <ContentTemplate>
                                <i class="fa fa-plus"></i>Add Exhibit
                            </ContentTemplate>
                        </telerik:RadButton>
                        <telerik:RadButton runat="server" ID="btnCreditRecs" ToolTip="Manage Credit Recommendations." CommandName="CreditRecommendations" Text=" Manage Credit Recommendations" ButtonType="LinkButton">
                            <Icon PrimaryIconCssClass="rbOk"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton ID="rbExport" runat="server" Text=" Export" CommandName="ExportToExcel" ToolTip="Export">
                            <ContentTemplate>
                                <i class="fa fa-file-excel-o"></i>Export to Excel
                            </ContentTemplate>
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>
                <Columns>

                    <telerik:GridTemplateColumn UniqueName="EditColumn" HeaderStyle-Width="50px" AllowFiltering="false" EnableHeaderContextMenu="false" Exportable="false" HeaderText="Edit" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <div class="d-flex align-items-center justify-content-center"></div>
                            <asp:LinkButton runat="server" ToolTip="Edit Exhibit" CommandName="Edit" ID="btnEdit" Text=''><i class="fa fa-pencil" aria-hidden="true"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn UniqueName="DeleteColumn" HeaderStyle-Width="50px" AllowFiltering="false" EnableHeaderContextMenu="false" Exportable="false" HeaderText="Delete" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <div class="d-flex align-items-center justify-content-center"></div>
                            <asp:LinkButton runat="server" ToolTip="Delete Exhibit" CommandName="Delete" ID="btnDelete" Text=''><i class="fa fa-trash" aria-hidden="true"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" AllowFiltering="true" HeaderStyle-Width="100px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="true" HeaderText="Exhibit ID" FilterControlWidth="90px">
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                        </ColumnValidationSettings>
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false" ReadOnly="true" >
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="VersionNumber" HeaderText="Version" DataField="VersionNumber" UniqueName="VersionNumber" AllowFiltering="false" HeaderStyle-Width="60px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" MaxLength="3">
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                        </ColumnValidationSettings>
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AceType" UniqueName="AceTypeID" Display="false" ReadOnly="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AceType" UniqueName="EntityType" Display="false" ReadOnly="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridDropDownColumn DataField="AceType" FilterControlAltText="Filter AceType column" HeaderText="Type" SortExpression="AceType" UniqueName="AceType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" EnableHeaderContextMenu="false" HeaderStyle-HorizontalAlign="Center" Display="false">
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                        </ColumnValidationSettings>
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn DataField="SourceID" UniqueName="SourceIDKey" Display="false" ReadOnly="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridDropDownColumn DataField="SourceID" FilterControlAltText="Filter SourceID column" HeaderText="Source" SortExpression="SourceID" UniqueName="SourceID" DataSourceID="sqlSource" ListTextField="ShortDescription" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" HeaderStyle-HorizontalAlign="Center" >
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                        </ColumnValidationSettings>
                    </telerik:GridDropDownColumn>
                    <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="true" ColumnEditorID="CETitle" FilterControlWidth="200px">
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                        </ColumnValidationSettings>
                    </telerik:GridBoundColumn>
                    <telerik:GridHTMLEditorColumn SortExpression="ExhibitDisplay" HeaderText="Full Description" DataField="ExhibitDisplay" UniqueName="ExhibitDisplay" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" Display="false">
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                        </ColumnValidationSettings>
                    </telerik:GridHTMLEditorColumn>
                    <telerik:GridHTMLEditorColumn SortExpression="SkilLevelList" HeaderText="Skill Levels" DataField="SkilLevelList" UniqueName="SkilLevelList" AllowFiltering="true" ItemStyle-CssClass="skill-levels" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="true" FilterControlWidth="200px" ReadOnly="true" >
                    </telerik:GridHTMLEditorColumn>
                    <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="Team Revd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="130px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableHeaderContextMenu="true" HeaderStyle-HorizontalAlign="Center">
                        <ItemStyle HorizontalAlign="Center" />
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                        </ColumnValidationSettings>
                    </telerik:GridDateTimeColumn>
                    <telerik:GridDateTimeColumn DataField="StartDate" DataType="System.DateTime" FilterControlAltText="Filter StartDate column" HeaderText="Start Date" SortExpression="StartDate" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableHeaderContextMenu="true" HeaderStyle-HorizontalAlign="Center" ShowFilterIcon="false">
                        <ItemStyle HorizontalAlign="Center" />
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                        </ColumnValidationSettings>
                    </telerik:GridDateTimeColumn>
                    <telerik:GridDateTimeColumn DataField="EndDate" DataType="System.DateTime" FilterControlAltText="Filter EndDate column" HeaderText="End Date" SortExpression="EndDate" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableHeaderContextMenu="true" HeaderStyle-HorizontalAlign="Center" ShowFilterIcon="false">
                        <ItemStyle HorizontalAlign="Center" />
                        <ColumnValidationSettings EnableRequiredFieldValidation="true">
                            <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                        </ColumnValidationSettings>
                    </telerik:GridDateTimeColumn>
                </Columns>
                <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Exhibit:" CaptionDataField="Title" FormCaptionStyle-Font-Bold="true" PopUpSettings-ShowCaptionInEditForm="true" ColumnNumber="2" EditColumn-CancelText="Cancel" EditColumn-UpdateText="Update">
                    <PopUpSettings Height="700px" Modal="True" Width="1100px" ScrollBars="None" KeepInScreenBounds="true" OverflowPosition="Center" />
                </EditFormSettings>
            </MasterTableView>
        </telerik:RadGrid>
        <telerik:GridTextBoxColumnEditor ID="CETitle" TextBoxStyle-Width="850px" TextBoxMaxLength="200" runat="server" />
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
