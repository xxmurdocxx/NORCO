<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitInformation.ascx.cs" Inherits="ems_app.UserControls.ExhibitInformation" %>
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server">
    </telerik:RadWindowManager>
<div style="display: flex; justify-content: center; align-items: center;">
    <h2 style="text-align: center; width: 100%; font-weight: bold;">Exhibit Information</h2>
    &nbsp;<i id="tooltipExhibitInfo" class="fa-regular fa-circle-info"></i>
    <telerik:RadToolTip RenderMode="Lightweight" runat="server" ID="RadToolTip1" Width="300px" ShowEvent="onmouseover"
        RelativeTo="Element" Animation="Resize" TargetControlID="tooltipExhibitInfo" IsClientID="true" Skin="Material"
        HideEvent="LeaveTargetAndToolTip" Position="TopRight" Text="The Exhibit Information Column identifies the exhibit details outlined in the ACE Military Guide.">
    </telerik:RadToolTip>
</div>
<hr />
<div class="courseDetails">
    <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="Center" AutoCloseDelay="0" Width="400" Height="210" Title="Notification" EnableRoundedCorners="false">
        <ContentTemplate>
            <asp:Literal ID="rnLiteral" runat="server"></asp:Literal>
        </ContentTemplate>
    </telerik:RadNotification>
    <div class="courseDetails">
        <asp:SqlDataSource ID="sqlHighlightedCurrentVersion" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetExhibit" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:Parameter Name="ExhibitID" Type="Int32" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:Repeater ID="rptCurrentVerion" runat="server" DataSourceID="sqlHighlightedCurrentVersion">
            <HeaderTemplate>
                <table>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td>
                        <asp:Label runat="server" ID="Label2" Text='<%# Eval("ExhibitDisplay") %>' /></td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        <br />
        <div id="creditRecommendations">
            <asp:SqlDataSource ID="sqlCreditRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT (SELECT CASE WHEN ( (CIF.CIDNumber IS NULL OR CIF.CIDNumber = '') AND ISNULL((SELECT TOP 1 [C-ID_Descriptor] from MASTER_CID WHERE [C-ID]= CIF.CIDNumber AND Institution LIKE '%' + COL.College + '%' ORDER BY Approval_date DESC ),'') = '' ) THEN 'College' ELSE 'C-ID' END FROM   course_issuedform CIF  LEFT OUTER JOIN LookupColleges COL ON CIF.college_id = COL.CollegeID WHERE  CIF.outline_id = aec.OutlineID) CRType, aec.* FROM [ACEExhibitCriteria] aec WHERE ExhibitID = @ExhibitID" DeleteCommand="DELETE FROM [ACEExhibitCriteria] WHERE CriteriaID = @CriteriaID" DeleteCommandType="Text" UpdateCommand="UPDATE [ACEExhibitCriteria] SET Criteria = @Criteria, Notes = @Notes WHERE CriteriaID = @CriteriaID" UpdateCommandType="Text">
                <SelectParameters>
                   <asp:Parameter Name="ExhibitID" Type="Int32" />
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
            <telerik:RadGrid ID="rgCreditRecommendations" runat="server" CellSpacing="-1" DataSourceID="sqlCreditRecommendations" AllowFilteringByColumn="False" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" AllowAutomaticInserts="true" AllowAutomaticUpdates="true"  OnItemCommand="rgCreditRecommendations_ItemCommand" AllowAutomaticDeletes="true" OnItemDataBound="rgCreditRecommendations_ItemDataBound">
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
        <br />
        <div id="evidenceCompetency">
            <h2>Evidence of Competency</h2>
            <br />
            <asp:SqlDataSource ID="sqlEvidence" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLExhibitEvidence] WHERE Active = 1 ORDER BY SortOrder"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlCPLEvidenceCompetency" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLEvidenceCompetency] WHERE ExhibitID = @ExhibitID" InsertCommand="INSERT INTO [dbo].[CPLEvidenceCompetency] ([ExhibitID] ,[CollegeID] ,[ExhibitEvidenceID], [Notes], [ActiveCurrent], [CreatedBy] ,[CreatedOn]) VALUES (@ExhibitID ,@CollegeID ,@ExhibitEvidenceID , @Notes, @ActiveCurrent, @CreatedBy ,GETDATE())" InsertCommandType="Text" UpdateCommand="UPDATE [dbo].[CPLEvidenceCompetency]  SET [ExhibitEvidenceID] = @ExhibitEvidenceID, [Notes] = @Notes, ActiveCurrent = @ActiveCurrent, [UpdatedBy] = @UpdatedBy, [UpdatedOn] = GETDATE() WHERE ID = @ID" UpdateCommandType="Text" DeleteCommand="DELETE FROM [CPLEvidenceCompetency] WHERE ID = @ID" DeleteCommandType="Text">
                <SelectParameters>
                    <asp:Parameter Name="ExhibitID" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                    <asp:Parameter Name="ExhibitEvidenceID" Type="Int32" />
                    <asp:Parameter Name="Notes" Type="String" />
                    <asp:Parameter Name="ActiveCurrent" Type="Boolean" />
                    <asp:SessionParameter SessionField="UserID" Name="UpdatedBy" Type="Int32" />
                </UpdateParameters>
                <InsertParameters>
                    <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="CollegeID" Type="Int32" />
                    <asp:ControlParameter ControlID="hfExhibitID" PropertyName="Value" Name="ExhibitID" Type="Int32" />
                    <asp:Parameter Name="ExhibitEvidenceID" Type="Int32" />
                    <asp:Parameter Name="Notes" Type="String" />
                    <asp:Parameter Name="ActiveCurrent" Type="Boolean" />
                    <asp:SessionParameter SessionField="UserID" Name="CreatedBy" Type="Int32" />
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
                        <telerik:GridCheckBoxColumn UniqueName="ActiveCurrent" DataField="ActiveCurrent" HeaderText="Current / Active">                        </telerik:GridCheckBoxColumn>
                        <telerik:GridButtonColumn ButtonType="FontIconButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this credit recommendation ?" ConfirmTitle="Delete" HeaderStyle-Width="70px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                            <HeaderStyle Width="70px" />
                            <ItemStyle Width="200px" />
                        </telerik:GridButtonColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
        </div>
        <br />
        <div id="rubricItems">
            <h2>Rubric Items</h2>
            <br />
            <asp:SqlDataSource ID="sqlRubricItems" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM CPLRubric WHERE ExhibitID = @ExhibitID AND CollegeID = @CollegeID" InsertCommand="INSERT INTO [dbo].[CPLRubric] ([ExhibitID] ,[CollegeID] ,[Rubric] ,[ScoreRange] ,[MinScore] ,[CreatedBy] ,[CreatedOn]) VALUES (@ExhibitID ,@CollegeID ,@Rubric ,@ScoreRange ,@MinScore ,@CreatedBy ,GETDATE())" InsertCommandType="Text" UpdateCommand="UPDATE [dbo].[CPLRubric]  SET [Rubric] = @Rubric, [ScoreRange] = @ScoreRange ,[MinScore] = @MinScore, [UpdatedBy] = @UpdatedBy, [UpdatedOn] = GETDATE() WHERE ID = @ID" UpdateCommandType="Text" DeleteCommand="DELETE FROM [CPLRubric] WHERE ID = @ID" DeleteCommandType="Text">
                <SelectParameters>
                    <asp:SessionParameter SessionField="CollegeID" Name="CollegeID" Type="Int32" />
                    <asp:Parameter Name="ExhibitID" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                    <asp:Parameter Name="Rubric" Type="String" />
                    <asp:Parameter Name="ScoreRange" Type="Double" />
                    <asp:Parameter Name="MinScore" Type="Double" />
                    <asp:SessionParameter SessionField="UserID" Name="UpdatedBy" Type="Int32" />
                </UpdateParameters>
                <InsertParameters>
                    <asp:SessionParameter SessionField="CollegeID" Name="CollegeID" Type="Int32" />
                    <asp:Parameter Name="ExhibitID" Type="Int32" />
                    <asp:Parameter Name="Rubric" Type="String" />
                    <asp:Parameter Name="ScoreRange" Type="Double" />
                    <asp:Parameter Name="MinScore" Type="Double" />
                    <asp:SessionParameter SessionField="UserID" Name="CreatedBy" Type="Int32" />
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
                    <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="true" ShowRefreshButton="false" />
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
        </div>
        <div id="documents">
            <br />
            <h2>Documents</h2>
            <br />
            <asp:SqlDataSource ID="sqlDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [CPLExhibitDocuments] WHERE id = @id" DeleteCommandType="Text" SelectCommand="SELECT ad.id, ad.filename, ad.filedescription, ad.binarydata, concat(u.firstname , ', ' , u.lastname ) as 'FullName', ad.CreatedBy FROM [CPLExhibitDocuments] ad left outer join tblusers u on ad.CreatedBy = u.userid  where (ad.CPLExhibitID = @ExhibitID)">
                <SelectParameters>
                    <asp:Parameter Name="ExhibitID" Type="Int32" />
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
        </div>
    </div>
</div>
    <script>
        function closeCurrentTab() {
            const currentWindow = window.open('', '_self');
            currentWindow.close();
        }
        function OnClientFileUploaded(sender, args) {
            $('#btnComple').trigger('click');
        }
        function OnRowClickCreditRecommendations(sender, eventArgs) {
            editedRow = eventArgs.get_itemIndexHierarchical();
            $find("<%= rgCreditRecommendations.ClientID %>").get_masterTableView().editItem(editedRow);
        }
        function OnRowClickEvidence(sender, eventArgs) {
            editedRow = eventArgs.get_itemIndexHierarchical();
            $find("<%= rgEvidenceCompetency.ClientID %>").get_masterTableView().editItem(editedRow);
        }
        function OnRowClickRubric(sender, eventArgs) {
            editedRow = eventArgs.get_itemIndexHierarchical();
            $find("<%= rgRubricItems.ClientID %>").get_masterTableView().editItem(editedRow);
        }
        document.addEventListener('DOMContentLoaded', function () {
            var elements = document.querySelectorAll('.courseDetails');

            elements.forEach(function (element) {
                var html = element.innerHTML;
                var newHtml = html.replace(/Ace\s?ID:?/gi, 'ID:');
                element.innerHTML = newHtml;
            });
        });
    </script>
