<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lead.aspx.cs" Inherits="ems_app.modules.popups.Lead" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
</head>
<body style="background-color: #fff !important;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
            SelectCommand="SELECT [id], [BinaryData] FROM [VeteranDocuments] WHERE [id] = @id">
            <SelectParameters>
                <asp:Parameter Name="id" Type="Int32"></asp:Parameter>
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlVeteranDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM VeteranDocuments WHERE [id] = @id" InsertCommand="INSERT INTO VeteranDocuments ([FileName], [FileDescription],  [BinaryData], [VeteranID], [user_id]) VALUES (@FileName, @FileDescription,  @BinaryData, @VeteranID, @user_id) SET @InsertedID = SCOPE_IDENTITY()" SelectCommand="SELECT id, filename, filedescription, binarydata FROM VeteranDocuments where (VeteranID = @VeteranID) " UpdateCommand="UPDATE VeteranDocuments SET  [FileDescription] = @FileDescription, [user_id] = @user_id WHERE [id] = @id" OnInserted="sqlVeteranDocuments_Inserted" OnUpdated="sqlVeteranDocuments_Updated">
            <SelectParameters>
                <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranID" Type="Int32" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:SessionParameter Name="user_id" SessionField="UserID" Type="Int32" />
                <asp:Parameter Name="FileName" Type="String" />
                <asp:Parameter Name="FileDescription" Type="String" />
                <asp:Parameter Name="BinaryData" Type="Byte" />
                <asp:Parameter Name="InsertedID" Type="Int32" Direction="Output"></asp:Parameter>
                <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranID" Type="Int32" />
            </InsertParameters>
            <UpdateParameters>
                <asp:SessionParameter Name="user_id" SessionField="UserID" Type="Int32" />
                <asp:Parameter Name="FileName" Type="String" />
                <asp:Parameter Name="FileDescription" Type="String" />
                <asp:Parameter Name="id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlVeteran" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT *, LastName + ', ' + FirstName as 'FullName' FROM Veteran WHERE Id = @Id" UpdateCommand="UPDATE Veteran SET [FirstName] = @FirstName, [LastName] = @LastName, [ServiceID] = @ServiceID, [BirthDate] = @BirthDate, [TermDate] = @TermDate, [Email] = @Email, [Email1] = @Email1,  [OfficePhone] = @OfficePhone, [MobilePhone] = @MobilePhone, [HomePhone] = @HomePhone, [StreetAddress] = @StreetAddress, [CityId] = @CityId,  [ZipCode] = @ZipCode, [SalutationID] = @SalutationID, [Rank] = @Rank, [LevelID] = @LevelID, [StudentID] = @StudentID, [CollegeID] = @CollegeID  WHERE [ID] = @Id">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="Id" QueryStringField="VeteranId" />
            </SelectParameters>
            <UpdateParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="Id" QueryStringField="VeteranId" />
                <asp:Parameter Name="FirstName" Type="String" />
                <asp:Parameter Name="ServiceId" Type="Int32" />
                <asp:Parameter Name="BirthDate" Type="DateTime" />
                <asp:Parameter Name="TermDate" Type="DateTime" />
                <asp:Parameter Name="Email" Type="String" />
                <asp:Parameter Name="Email1" Type="String" />
                <asp:Parameter Name="OfficePhone" Type="String" />
                <asp:Parameter Name="MobilePhone" Type="String" />
                <asp:Parameter Name="HomePhone" Type="String" />
                <asp:Parameter Name="StreetAddress" Type="String" />
                <asp:Parameter Name="CityId" Type="Int32" />
                <asp:Parameter Name="ZipCode" Type="String" />
                <asp:Parameter Name="SalutationID" Type="Int32" />
                <asp:Parameter Name="Rank" Type="String" />
                <asp:Parameter Name="LevelID" Type="Int32" />
                <asp:Parameter Name="StudentID" Type="String" />
                <asp:Parameter Name="CollegeID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlSalutations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from SalutationCodes"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlLeadStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LeadStatus " />
        <asp:SqlDataSource ID="sqlLeadOutcome" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LeadOutcome " />
        <asp:SqlDataSource ID="sqlActionType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from ActionType" />
        <asp:SqlDataSource ID="sqlCampaigns" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from Campaign where [CollegeID] = @CollegeID order by Description">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlUsers" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, LastName + ', ' + FirstName as 'FullName' from tblUsers where [CollegeID] = @CollegeID order by Lastname">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlActionsActivities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from Action where [CollegeID] = @CollegeID order by Description">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlLeadActivities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [LeadAction] WHERE [ID] = @ID" InsertCommand="INSERT INTO [LeadAction] ([Description], [LeadID], [ActionID], [ActionType], [DueDate], [LeadStatusID], [LeadOutcomeID], [Notes], [CreatedBy]) VALUES (@Description, @LeadID, @ActionID, @ActionType, @DueDate, @LeadStatusID, @LeadOutcomeID, @Notes, @CreatedBy)" SelectCommand="SELECT * FROM [LeadAction] WHERE ([LeadID] = @LeadID )" UpdateCommand="UPDATE [LeadAction] SET [Description] = @Description, [ActionID] = @ActionID, [ActionType] = @ActionType, [DueDate] = @DueDate, [LeadStatusID] = @LeadStatusID, [LeadOutcomeID] = @LeadOutcomeID, [Notes] = @Notes,  [UpdatedBy] = @UpdatedBy, [UpdatedOn] = getdate() WHERE [ID] = @ID">
            <SelectParameters>
                <asp:QueryStringParameter Name="LeadID" QueryStringField="LeadId" Type="Int32" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="Description" Type="String" />
                <asp:QueryStringParameter Name="LeadID" QueryStringField="LeadId" Type="Int32" />
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
        <asp:SqlDataSource ID="sqlLeads" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [VeteranLead] WHERE ([ID] = @ID)" UpdateCommand="UPDATE [VeteranLead] SET [CampaignID] = @CampaignID, [LeadStatusID] = @LeadStatusID, [LeadOutcomeID] = @LeadOutcomeID, [Notes] = @Notes, [UpdatedBy] = @UpdatedBy, [UpdatedOn] = getdate() WHERE [ID] = @ID">
            <SelectParameters>
                <asp:QueryStringParameter Name="ID" QueryStringField="LeadId" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="CampaignID" Type="Int32" />
                <asp:Parameter Name="LeadStatusID" Type="Int32" />
                <asp:Parameter Name="LeadOutcomeID" Type="Int32" />
                <asp:Parameter Name="Notes" Type="String" />
                <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
                <asp:Parameter Name="ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LookupService"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlVeteranOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT vo.*, OC.Occupation as 'OccupationCode', Concat(OC.Occupation,' - ',OC.Title) as OccupationTitle, OC.AceID, OC.TeamRevd, OC.Title FROM VeteranOccupation VO LEFT OUTER JOIN View_MostCurrentOccupation OC ON VO.OccupationCode = OC.Occupation WHERE VO.VeteranId = @id" DeleteCommand="DELETE FROM [VeteranOccupation] WHERE [id] = @id" InsertCommand="INSERT INTO  [VeteranOccupation] ([OccupationCode],[CollegeID],[VeteranId]) values (@OccupationCode, @CollegeID, @Id)">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                <asp:QueryStringParameter DefaultValue="0" Name="Id" QueryStringField="VeteranId" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="OccupationCode" Type="String" />
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                <asp:QueryStringParameter DefaultValue="0" Name="Id" QueryStringField="VeteranId" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlVeteranACECourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" 
            SelectCommand="select distinct acc.AceID, acc.TeamRevd,   acc.Title, vace.id  FROM VeteranACECourse VACE left outer join AceExhibit acc on VACE.AceID = acc.AceID AND vace.TeamRevd = acc.TeamRevd where VACE.VeteranID = @Id" 
            DeleteCommand="DELETE FROM [VeteranACECourse] WHERE [id] = @id">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                <asp:QueryStringParameter DefaultValue="0" Name="Id" QueryStringField="VeteranId" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select trim(ao.Occupation) as 'OccupationCode', ao.Occupation + ' - ' + ao.Title as OccupationTitle from AceExhibit ao inner join ( SELECT Occupation, max(AceID) as AceID FROM AceExhibit aoc group by Occupation ) a02 on ao.AceID = a02.AceID order by ao.Occupation"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, City + ' - ' + State as 'FullCity' from City order by State, City" />
        <asp:SqlDataSource ID="sqlACECourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select acc.* from AceExhibit acc where AceID not in ( select AceID from VeteranACECourse where VeteranId = @VeteranID ) and acc.AceType = 1 order by acc.Title, acc.Teamrevd desc">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="VeteranId" QueryStringField="VeteranId" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlColleges" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select CollegeID, CollegeAbbreviation from LookupColleges where  DistrictID in (select DistrictID from tblDistrictCollege where CollegeID = @CollegeID)">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div style="padding: 10px !important;">
                <div class="row">
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <asp:HiddenField ID="hfVeteranID" runat="server" />
                        <h3>Veteran Information</h3>
                        <telerik:RadGrid ID="rgVeteran" runat="server" AutoGenerateColumns="False" DataSourceID="sqlVeteran" AllowAutomaticUpdates="true" Skin="Material">
                            <ClientSettings>
                                <ClientEvents OnPopUpShowing="popUpShowing" />
                            </ClientSettings>
                            <MasterTableView DataSourceID="sqlVeteran" DataKeyNames="id" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true" CommandItemDisplay="None" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" EditFormSettings-ColumnNumber="2">
                                <Columns>
                                    <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit">
                                    </telerik:GridEditCommandColumn>
                                    <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true" HeaderText="Id(Protected-Do not change)">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="SalutationID" HeaderText="Salutation" UniqueName="SalutationID" DataSourceID="sqlSalutations" ListTextField="ShortDescription" ListValueField="id" HeaderStyle-Font-Bold="true" Display="false">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridDropDownColumn DataField="CollegeID" HeaderText="Home College" UniqueName="CollegeID" DataSourceID="sqlColleges" ListTextField="CollegeAbbreviation" ListValueField="CollegeID" EnableEmptyListItem="true" EmptyListItemText="" EmptyListItemValue="0">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn DataField="StudentID" UniqueName="StudentID" HeaderText="Student ID" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="FirstName" UniqueName="FirstName" HeaderText="First Name" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="LastName" UniqueName="LastName" HeaderText="Last Name" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="ServiceID" HeaderText="Service" UniqueName="ServiceID" DataSourceID="sqlServices" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn DataField="Rank" UniqueName="Rank" HeaderText="Rank" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="LevelID" HeaderText="Level" UniqueName="LevelID" DataSourceID="sqlLevel" ListTextField="Description" ListValueField="LevelID" HeaderStyle-Font-Bold="true" HeaderStyle-Width="120px">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridDateTimeColumn UniqueName="BirthDate" PickerType="DatePicker" HeaderText="BirthDate" DataField="BirthDate" DataFormatString="{0:MM/dd/yyyy}" Display="false">
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridDateTimeColumn UniqueName="TermDate" PickerType="DatePicker" HeaderText="TermDate" DataField="TermDate" DataFormatString="{0:MM/dd/yyyy}" Display="false" ReadOnly="true">
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridBoundColumn DataField="Email" HeaderText="Email 1" UniqueName="Email" Display="false" ColumnEditorID="CEEmail" />
                                    <telerik:GridBoundColumn DataField="Email2" HeaderText="Email 2" UniqueName="Email2" Display="false" ColumnEditorID="CEEmail" ReadOnly="true" />
                                    <%--<telerik:GridMaskedColumn UniqueName="OfficePhone" HeaderText="Office Phone" DataField="OfficePhone" Mask="(###) ###-####" Display="false" />--%>
                                    <telerik:GridMaskedColumn UniqueName="MobilePhone" HeaderText="Mobile Phone" DataField="MobilePhone" Mask="(###) ###-####" Display="false" />
                                    <telerik:GridMaskedColumn UniqueName="HomePhone" HeaderText="Home Phone" DataField="HomePhone" Mask="(###) ###-####" ReadOnly="true" Display="false" />
                                    <telerik:GridBoundColumn DataField="StreetAddress" HeaderText="Street Address" UniqueName="StreetAddress" Display="false" ColumnEditorID="CEAddress" />
                                    <telerik:GridDropDownColumn DataField="CityId" HeaderText="City" UniqueName="CityId" DataSourceID="sqlCities" ListTextField="FullCity" ListValueField="id" Display="false">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn DataField="ZipCode" HeaderText="ZipCode" UniqueName="ZipCode" Display="false" />
                                </Columns>
                                <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Veteran: {0}" CaptionDataField="Fullname" FormCaptionStyle-Font-Bold="true" PopUpSettings-ShowCaptionInEditForm="true" ColumnNumber="2" EditColumn-CancelText="Cancel" EditColumn-UpdateText="Update">
                                    <PopUpSettings Height="700px" Modal="True" Width="800px" ScrollBars="Vertical" KeepInScreenBounds="true" OverflowPosition="Center" />
                                </EditFormSettings>
                            </MasterTableView>
                        </telerik:RadGrid>

                        <h3>Veteran Documents</h3>
                        <telerik:RadGrid ID="rgVeteranDocs" DataSourceID="sqlVeteranDocuments" AllowPaging="True" Width="100%" runat="server" AutoGenerateColumns="False" AllowSorting="True" PageSize="10" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemCommand="rgVeteranDocs_ItemCommand" AllowAutomaticDeletes="true" OnItemDataBound="rgVeteranDocs_ItemDataBound" RenderMode="Lightweight" Skin="Metro">
                            <ClientSettings AllowDragToGroup="false">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                            </ClientSettings>
                            <MasterTableView DataKeyNames="id" AutoGenerateColumns="false" CommandItemDisplay="Top">
                                <CommandItemTemplate>
                                    <div class="commandItems">
                                        <asp:LinkButton runat="server" CommandName="InitInsert" ID="btnAdd" Text="<i class='fa fa-upload'></i> Upload Documents" />
                                    </div>
                                </CommandItemTemplate>
                                <CommandItemSettings ShowAddNewRecordButton="true" ShowRefreshButton="true" />
                                <Columns>
                                    <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="FileDescription" FilterControlAltText="Filter FileDescription column" HeaderText="File Description" SortExpression="FileDescription" UniqueName="FileDescription">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridAttachmentColumn SortExpression="FileName" UploadControlType="RadAsyncUpload" DataSourceID="SqlDataSource2" MaxFileSize="1048576" EditFormHeaderTextFormat="Upload File:" HeaderText="Attachment" AttachmentDataField="BinaryData" AttachmentKeyFields="id" ForceExtractValue="Always" FileNameTextField="FileName" DataTextField="FileName" UniqueName="AttachmentColumn">
                                    </telerik:GridAttachmentColumn>
                                    <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" ButtonType="ImageButton">
                                        <ItemStyle Width="50px"></ItemStyle>
                                    </telerik:GridEditCommandColumn>
                                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this document ?" ConfirmTitle="Delete" HeaderStyle-Width="50px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                        <HeaderStyle Width="50px" />
                                    </telerik:GridButtonColumn>
                                </Columns>
                                <EditFormSettings ColumnNumber="2" FormMainTableStyle-CellPadding="5" FormTableStyle-CellPadding="5" EditColumn-ButtonType="ImageButton"></EditFormSettings>
                            </MasterTableView>
                        </telerik:RadGrid>

                        <!-- DT ******************************** -->
                        <h3>PDF Results</h3>
                                                <telerik:RadGrid ID="rdPDFResults"   AllowPaging="True" Width="100%" runat="server" AutoGenerateColumns="False" AllowSorting="True" PageSize="10" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemCommand="rgVeteranDocs_ItemCommand" AllowAutomaticDeletes="true" OnItemDataBound="rgVeteranDocs_ItemDataBound" RenderMode="Lightweight">
                            <ClientSettings AllowDragToGroup="false">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                            </ClientSettings>
                            <MasterTableView DataKeyNames="AceID" AutoGenerateColumns="false" CommandItemDisplay="Top">
                                <CommandItemTemplate>
                                    <div class="commandItems">
                                        <asp:LinkButton runat="server" CommandName="InitInsert" ID="btnAdd" Text="<i class='fa fa-upload'></i> Upload Documents" />
                                    </div>
                                </CommandItemTemplate>
                                <CommandItemSettings ShowAddNewRecordButton="true" ShowRefreshButton="true" />
                                <Columns> 
                                    <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="AceID" SortExpression="AceID" UniqueName="AceID">
                                    </telerik:GridBoundColumn>
                                       <telerik:GridBoundColumn DataField="CourseNumber" FilterControlAltText="Filter CourseNumber column" HeaderText="CourseNumber" SortExpression="CourseNumber" UniqueName="CourseNumber">
                                    </telerik:GridBoundColumn>
                                </Columns>
                               </MasterTableView>
                        </telerik:RadGrid>
                        <asp:GridView ID="grdSummary" CssClass="table table-compressed" AutoGenerateColumns="false" runat="server"
                            HeaderStyle-BackColor="LightGoldenrodYellow">
                            <Columns>
                                <asp:BoundField DataField="AceID" HeaderText="ACE #" runat="server" />
                                <asp:BoundField DataField="CourseNumber" HeaderText="Course #" runat="server" />
                                <asp:BoundField DataField="CourseVersion" HeaderText="Version" runat="server" />
                                <asp:BoundField DataField="CourseTitle" HeaderText="CourseTitle" runat="server" />
                                <asp:BoundField DataField="CourseDate" HeaderText="CourseDate" DataFormatString="{0:MM-dd-yyyy}"  runat="server" />
                                <%--<asp:BoundField DataField="Credit" HeaderText="Credit" runat="server" />
                                <asp:BoundField DataField="Level" HeaderText="Level" runat="server" />--%>
                            </Columns>

                        </asp:GridView>
                        <!-- DT END ******************************** -->

                        <h3>Occupation(s)</h3>
                        <div class="OccupationDetails">
                            <telerik:RadGrid ID="rgVeteranOccupations" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlVeteranOccupations" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" AllowAutomaticInserts="true" OnItemCommand="rgVeteranOccupations_ItemCommand">
                                <ClientSettings AllowKeyboardNavigation="true">
                                    <Selecting AllowRowSelect="true"></Selecting>
                                    <ClientEvents />
                                </ClientSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlVeteranOccupations" PageSize="12" DataKeyNames="OccupationCode" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="true" EnableHierarchyExpandAll="true" AllowFilteringByColumn="false" CommandItemSettings-AddNewRecordText="Add an Occupation" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn UniqueName="TemplateLinkColumn" AllowFiltering="False" HeaderStyle-Width="30px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lnkShowAceOccupation" CommandName="ShowAceOccupation" runat="server"><i class="fa fa-info-circle" aria-hidden="true"></i></asp:LinkButton>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridDropDownColumn DataField="OccupationCode" FilterControlAltText="Filter OccupationCode column" HeaderText="Occupation Code" SortExpression="OccupationCode" UniqueName="OccupationCode" DataSourceID="sqlOccupations" ListTextField="OccupationTitle" ListValueField="OccupationCode" HeaderStyle-Width="365px" AllowFiltering="false" HeaderStyle-Font-Bold="true" ColumnEditorID="CEDropdown" EmptyListItemText="Not found">
                                        </telerik:GridDropDownColumn>
                                        <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this occupation ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>

                        </div>
                        <%--        <asp:SqlDataSource ID="sqlOccupationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT distinct ACD.AceID, ACD.TeamRevd, ACC.Exhibit, ACC.CourseNumber, ACC.Title, ACC.CourseLength, CO.Occupation as OccupationCode, ( select a.title from AceOccupation a join ( select Occupation, max(EndDate) as EndDate from AceOccupation where Occupation = co.Occupation group by Occupation ) as b  on a.Occupation = b.Occupation and a.EndDate = b.EndDate ) as OccupationTitle FROM AceOccupation CO JOIN AceCatalogDetail ACD ON ACD.ID = CO.ID JOIN AceCourseCatalog ACC ON ACC.AceID = ACD.AceID AND ACC.TeamRevd = ACD.TeamRevd where co.[Occupation] = @OccupationCode ORDER BY ACD.AceID, ACD.TeamRevd">
            <SelectParameters>
                <asp:ControlParameter ControlID="rgVeteranOccupations" Name="OccupationCode" PropertyName="SelectedValue" Type="String"></asp:ControlParameter>
            </SelectParameters>
        </asp:SqlDataSource>--%>
<%--                        <h3>Related Courses</h3>
                        <div>
                            <telerik:RadGrid ID="rgRelatedCourses" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOccupationCourses" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" EnableHeaderContextMenu="true">
                                <MasterTableView DataSourceID="sqlOccupationCourses" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" AllowFilteringByColumn="false" DataKeyNames="OccupationCode" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="AceId" UniqueName="AceId" HeaderText="ACE ID" HeaderStyle-Font-Bold="true" HeaderStyle-Width="95px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn UniqueName="TeamRevd" PickerType="DatePicker" HeaderText="Team Revd" DataField="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Font-Bold="true">
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridBoundColumn DataField="Title" UniqueName="Title" HeaderText="Title" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="CourseLength" UniqueName="CourseLength" HeaderText="Course Length" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </div>--%>
                        <h3>Veteran Military Courses</h3>
                        <asp:SqlDataSource ID="sqlLevel" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select LevelID, concat(Code,'=',Description) as Description from VeteranLevel"></asp:SqlDataSource>
                        <asp:SqlDataSource ID="sqlVeteranCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM MilitaryCourses where VeteranID = @VeteranID" UpdateCommand="UPDATE MilitaryCourses SET [AceID] = @AceID, [CourseNumber] = @CourseNumber, [CourseTitle] = @CourseTitle,  [Credit] = @Credit, [LevelID] = @LevelID, UpdatedBy = @UpdatedBy, UpdatedOn = getdate() WHERE [Id] = @Id" InsertCommand="INSERT INTO [dbo].[MilitaryCourses] ([AceID],[CourseNumber],[CourseTitle],[Credit],[LevelID],[CreatedBy],[CreatedOn],[VeteranID]) VALUES(@AceID,@CourseNumber,@CourseTitle,@Credit,@LevelID,@CreatedBy,getdate(),@VeteranId)" DeleteCommand="DELETE FROM MilitaryCourses WHERE Id = @Id">
                            <DeleteParameters>
                                <asp:Parameter Name="Id" Type="Int32" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranID" Type="Int32" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="Id" Type="Int32" />
                                <asp:Parameter Name="AceID" Type="String" />
                                <asp:Parameter Name="CourseNumber" Type="String" />
                                <asp:Parameter Name="CourseTitle" Type="String" />
                                <asp:Parameter Name="Credit" Type="String" />
                                <asp:Parameter Name="LevelID" Type="Int32" />
                                <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
                            </UpdateParameters>
                            <InsertParameters>
                                <asp:Parameter Name="AceID" Type="String" />
                                <asp:Parameter Name="CourseNumber" Type="String" />
                                <asp:Parameter Name="CourseTitle" Type="String" />
                                <asp:Parameter Name="Credit" Type="String" />
                                <asp:Parameter Name="LevelID" Type="Int32" />
                                <asp:SessionParameter Name="CreatedBy" SessionField="UserID" Type="Int32" />
                                <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranID" Type="Int32" />
                            </InsertParameters>
                        </asp:SqlDataSource>
                        <telerik:RadGrid ID="rgMilitaryCourses" runat="server" AutoGenerateColumns="False" DataSourceID="sqlVeteranCourses" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" Skin="Material" EnableHeaderContextMenu="true" AllowSorting="true">
                            <ClientSettings AllowKeyboardNavigation="true" Resizing-AllowColumnResize="true">
                                <Scrolling AllowScroll="true" />
                                <ClientEvents></ClientEvents>
                            </ClientSettings>
                            <MasterTableView DataSourceID="sqlVeteranCourses" DataKeyNames="id" EditMode="Batch" CommandItemDisplay="Top" CommandItemSettings-SaveChangesText="Save" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                <BatchEditingSettings EditType="Cell" />
                                <Columns>
                                    <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" HeaderText="ACE Exhibit Number" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="CourseNumber" UniqueName="CourseNumber" HeaderText="Military Course Number" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="CourseTitle" UniqueName="CourseTitle" HeaderText="Title/Subject" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Credit" UniqueName="Credit" HeaderText="Credit" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="LevelID" HeaderText="Level" UniqueName="LevelID" DataSourceID="sqlLevel" ListTextField="Description" ListValueField="LevelID" HeaderStyle-Font-Bold="true" HeaderStyle-Width="120px">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridButtonColumn ButtonType="FontIconButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Are you sure you want to remove this Veteran from the current campaign? After deleting please click on Save button to confirm changes ?" ConfirmTitle="Delete" HeaderStyle-Width="50px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                        <HeaderStyle Width="50px" />
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <h3>Outreach Details</h3>
                        <telerik:RadGrid ID="rgLead" runat="server" AutoGenerateColumns="False" DataSourceID="sqlLeads" AllowAutomaticUpdates="true">
                            <ClientSettings>
                                <ClientEvents OnPopUpShowing="popUpShowing" />
                            </ClientSettings>
                            <MasterTableView DataSourceID="sqlLeads" DataKeyNames="id" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true" CommandItemDisplay="None" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                <Columns>
                                    <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit">
                                    </telerik:GridEditCommandColumn>
                                    <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="CampaignID" FilterControlAltText="Filter CampaignID column" HeaderText="Campaign" SortExpression="CampaignID" UniqueName="CampaignID" DataSourceID="sqlCampaigns" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridDropDownColumn DataField="LeadStatusID" FilterControlAltText="Filter LeadStatusID column" HeaderText="Status" SortExpression="LeadStatusID" UniqueName="LeadStatusID" DataSourceID="sqlLeadStatus" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridDropDownColumn DataField="LeadOutcomeID" FilterControlAltText="Filter LeadOutcomeID column" HeaderText="Outcome" SortExpression="LeadOutcomeID" UniqueName="LeadOutcomeID" DataSourceID="sqlLeadOutcome" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridHTMLEditorColumn DataField="Notes" FilterControlAltText="Filter Notes column" SortExpression="Notes" UniqueName="Notes" HeaderStyle-Font-Bold="true" HeaderText="Notes" Display="false" ColumnEditorID="CEEditor">
                                    </telerik:GridHTMLEditorColumn>
                                    <telerik:GridDropDownColumn DataField="CreatedBy" FilterControlAltText="Filter CreatedBy column" HeaderText="Created By" SortExpression="CreatedBy" UniqueName="CreatedBy" DataSourceID="sqlUsers" ListTextField="FullName" ListValueField="UserID" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridDateTimeColumn UniqueName="CreatedOn" PickerType="DatePicker" HeaderText="Created On" DataField="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" ReadOnly="true" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDateTimeColumn>
                                </Columns>
                                <EditFormSettings EditColumn-ButtonType="FontIconButton">
                                    <PopUpSettings Height="500px" Modal="True" Width="600px" />
                                </EditFormSettings>
                            </MasterTableView>
                        </telerik:RadGrid>
                        <h3>Outreach Actions</h3>
                        <telerik:RadGrid ID="rgActivities" runat="server" AutoGenerateColumns="False" DataSourceID="sqlLeadActivities" AllowAutomaticUpdates="true" AllowAutomaticInserts="true" AllowAutomaticDeletes="true" AllowSorting="true">
                            <ClientSettings>
                                <ClientEvents OnPopUpShowing="popUpShowing" />
                            </ClientSettings>
                            <MasterTableView DataSourceID="sqlLeadActivities" DataKeyNames="id" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="true" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save" CommandItemSettings-AddNewRecordText="Add new Action" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                <Columns>
                                    <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit">
                                    </telerik:GridEditCommandColumn>
                                    <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Description" UniqueName="Description" HeaderText="Description" HeaderStyle-Font-Bold="true" ColumnEditorID="CEDescription" SortExpression="Description">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="ActionType" FilterControlAltText="Filter ActionType column" HeaderText="Action Type" SortExpression="ActionType" UniqueName="ActionType" DataSourceID="sqlActionType" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridDropDownColumn DataField="ActionID" FilterControlAltText="Filter ActionID column" HeaderText="Action" SortExpression="ActionID" UniqueName="ActionID" DataSourceID="sqlActionsActivities" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridDateTimeColumn UniqueName="DueDate" PickerType="DatePicker" HeaderText="Due Date" DataField="DueDate" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Font-Bold="true" SortExpression="DueDate">
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridDropDownColumn DataField="LeadStatusID" FilterControlAltText="Filter LeadStatusID column" HeaderText="Status" SortExpression="LeadStatusID" UniqueName="LeadStatusID" DataSourceID="sqlLeadStatus" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridDropDownColumn DataField="LeadOutcomeID" FilterControlAltText="Filter LeadOutcomeID column" HeaderText="Outcome" SortExpression="LeadOutcomeID" UniqueName="LeadOutcomeID" DataSourceID="sqlLeadOutcome" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridHTMLEditorColumn DataField="Notes" FilterControlAltText="Filter Notes column" SortExpression="Notes" UniqueName="Notes" HeaderStyle-Font-Bold="true" HeaderText="Notes" Display="false" ColumnEditorID="CEEditor">
                                    </telerik:GridHTMLEditorColumn>
                                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this Activity ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                </Columns>
                                <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Activity: {0}" CaptionDataField="Description">
                                    <PopUpSettings Height="600px" Modal="True" Width="600px" />
                                </EditFormSettings>
                            </MasterTableView>
                        </telerik:RadGrid>
                        <div style="display:flex;align-items:baseline;gap:10px;">
                            <h3>Ace Courses</h3><p> * ACE ( American Council on Education )</p>
                        </div>                      
                        <telerik:RadGrid ID="rgACECourses" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlVeteranACECourses" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" AllowAutomaticInserts="true" OnItemCommand="rgACECourseCatalog_ItemCommand">
                            <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true" >
                                <ClientEvents OnRowDblClick="RowDblClick"></ClientEvents>
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                            </ClientSettings>
                            <MasterTableView Name="ParentGrid" DataSourceID="sqlVeteranACECourses" PageSize="12" DataKeyNames="id" CommandItemDisplay="None" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                <Columns>
                                    <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn UniqueName="TemplateLinkColumn" AllowFiltering="False" HeaderStyle-Width="30px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkShowAceCourse" CommandName="ShowAceCourse" runat="server"><i class="fa fa-info-circle" aria-hidden="true"></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="ACE ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="65px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" HeaderText="Team Rev Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" FilterControlAltText="Filter Title column" HeaderText="ACE Title" SortExpression="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="150px" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="1" UniqueName="EntityType" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this ACE Course ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                        <br /><br />
                        <telerik:RadGrid ID="rgACECourseCatalog" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlACECourses" Width="100%" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" EnableHeaderContextMenu="true" ClientSettings-Scrolling-AllowScroll="true" Height="460px" OnItemCommand="rgACECourseCatalog_ItemCommand">
                            <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                            <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                <ClientEvents OnRowDblClick="RowDblClick"></ClientEvents>
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                            </ClientSettings>
                            <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlACECourses" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="Top" AllowMultiColumnSorting="true" Name="ParentGrid" HierarchyLoadMode="ServerBind" DataKeyNames="AceID,TeamRevd" PageSize="7">
                                <CommandItemSettings ShowAddNewRecordButton="False" />
                                <CommandItemTemplate>
                                    <div class="commandItems">
                                        <telerik:RadButton runat="server" ID="btnAdd" ToolTip="Check to add selected ACE courses." CommandName="Add" Text=" Add selected courses" ButtonType="LinkButton">
                                            <Icon PrimaryIconCssClass="rbOk"></Icon>
                                        </telerik:RadButton>
                                    </div>
                                </CommandItemTemplate>
                                <Columns>
                                    <telerik:GridTemplateColumn UniqueName="CheckBoxTemplateColumn" AllowFiltering="false" HeaderStyle-Width="10px">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CheckBox1" runat="server" OnCheckedChanged="ToggleRowSelection"
                                                AutoPostBack="True" />
                                        </ItemTemplate>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="headerChkbox" runat="server" OnCheckedChanged="ToggleSelectedState"
                                                AutoPostBack="True" />
                                        </HeaderTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridTemplateColumn UniqueName="TemplateLinkColumn" AllowFiltering="False" HeaderStyle-Width="30px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkShowAceCourse" CommandName="ShowAceCourse" runat="server"><i class="fa fa-info-circle" aria-hidden="true"></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="ACE ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="65px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                <%--    <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>--%>
                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" HeaderText="Team Rev Date" HeaderStyle-Font-Bold="true" DataType="System.DateTime" FilterControlWidth="75px" DataFormatString="{0:MM/dd/yyyy}" ItemStyle-HorizontalAlign="Center">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" FilterControlAltText="Filter Title column" HeaderText="ACE Title" SortExpression="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="150px" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="EntityType" EmptyDataText="1" UniqueName="EntityType" Display="false">
                                    </telerik:GridBoundColumn>
                                </Columns>
                                <NoRecordsTemplate>
                                    <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                        &nbsp;No items to view
                                    </div>
                                </NoRecordsTemplate>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
                </div>
            </div>
            <telerik:GridTextBoxColumnEditor ID="CEDescription" TextBoxStyle-Width="500px" TextBoxMaxLength="200" runat="server" />
            <telerik:GridTextBoxColumnEditor ID="CEEmail" TextBoxStyle-Width="400px" TextBoxMaxLength="300" TextBoxMode="Email" runat="server" />
            <telerik:GridTextBoxColumnEditor ID="CEAddress" TextBoxStyle-Width="400px" TextBoxMaxLength="300" runat="server" />
            <telerik:GridHTMLEditorColumnEditor ID="CEEditor" Editor-BackColor="White" runat="server" Editor-ContentAreaCssFile="~/Common/css/Editor.css" />
            <telerik:GridDropDownListColumnEditor ID="CEDropdown" runat="server" DropDownStyle-Width="400px" />
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
        <script type="text/javascript">
            function closeRadWindow() {
                return false;
            }
        </script>
</body>
</html>

