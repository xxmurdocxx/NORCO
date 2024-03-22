<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Veterans.aspx.cs" Inherits="ems_app.modules.veteran.Veterans" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        html .RadUpload_Material .ruSelectWrap .ruBrowse {
            height: 30px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" runat="server">Current Military Students</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <asp:SqlDataSource ID="sqlVeteran" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT distinct  '' as CreditRecommendation,'' as Recommendation,
v.id, v.FirstName, v.MiddleName, v.LastName, v.Branch, v.BirthDate, v.TermDate, v.Email, v.Email1, v.Email2, v.OfficePhone, v.MobilePhone, v.HomePhone, v.SalutationID, v.StatusID, v.ServiceID, v.StreetAddress, v.City, v.State, v.ZipCode, '' as Occupation, v.CreatedBy, v.CreatedOn, v.UpdatedBy, v.UpdatedOn,v.RESULT_CD, v.DNC_FLG, v.WARN_FLG, v.EMAIL_OPTOUT, v.CityId,0 as CampaignID, v.[Rank], v.LevelID, v.StudentID, v.CollegeID, v.POS, v.MapTotalCredits, v.CCCApplication, v.ProgramStudy, v.EducationalBenefits, v.FinancialAide, v.CounselingAppt, v.Orientation, v.Assessment, '' as recommendation, 0 as 'LeadID', 0 as CampaignID, '' AS 'Campaign' FROM Veteran v --inner join VeteranACECourse vac on v.id = vac.VeteranId
--inner join Articulation a  on vac.AceID=a.AceID 
ORDER BY V.LastName, V.FirstName"
        UpdateCommand="UPDATE Veteran SET [FirstName] = @FirstName, [LastName] = @LastName, [ServiceID] = @ServiceID, [BirthDate] = @BirthDate, [TermDate] = @TermDate, [Email] = @Email, [Email1] = @Email1,  [OfficePhone] = @OfficePhone, [Occupation] = @Occupation, [MobilePhone] = @MobilePhone, [HomePhone] = @HomePhone, [StreetAddress] = @StreetAddress, [CityId] = @CityId,  [ZipCode] = @ZipCode, [SalutationID] = @SalutationID, [Rank] = @Rank, [LevelID] = @LevelID, UpdatedBy = @UpdatedBy, UpdatedOn = getdate() WHERE [ID] = @id"
        InsertCommand="INSERT INTO [dbo].[Veteran] ([FirstName],[LastName],[BirthDate],[TermDate],[Email],[Email1],[OfficePhone],[MobilePhone],[HomePhone],[SalutationID],[ServiceID],[StreetAddress],[ZipCode],[CreatedBy],[CreatedOn],[CityId],[Occupation],[Rank],[LevelID],[CollegeID]) 
            VALUES(@FirstName,@LastName,@BirthDate,@TermDate,@Email,@Email1,@OfficePhone,@MobilePhone,@HomePhone,@SalutationID,@ServiceID,@StreetAddress,@ZipCode,@CreatedBy,getdate(),@CityId,@Occupation,@Rank,@LevelID,@CollegeID)"
        DeleteCommand="DELETE FROM Veteran WHERE id = @id">
        <DeleteParameters>
            <asp:Parameter Name="id" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="id" Type="Int32" />
            <asp:Parameter Name="FirstName" Type="String" />
            <asp:Parameter Name="ServiceId" Type="Int32" />
            <asp:Parameter Name="BirthDate" Type="DateTime" />
            <asp:Parameter Name="TermDate" Type="DateTime" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="Email1" Type="String" />
            <asp:Parameter Name="OfficePhone" Type="String" />
            <asp:Parameter Name="MobilePhone" Type="String" />
            <asp:Parameter Name="Occupation" Type="String" />
            <asp:Parameter Name="HomePhone" Type="String" />
            <asp:Parameter Name="StreetAddress" Type="String" />
            <asp:Parameter Name="CityId" Type="Int32" />
            <asp:Parameter Name="ZipCode" Type="String" />
            <asp:Parameter Name="Rank" Type="String" />
            <asp:Parameter Name="LevelID" Type="Int32" />
            <asp:Parameter Name="SalutationID" Type="Int32" />
            <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="FirstName" Type="String" />
            <asp:Parameter Name="LastName" Type="String" />
            <asp:Parameter Name="ServiceId" Type="Int32" />
            <asp:Parameter Name="BirthDate" Type="DateTime" />
            <asp:Parameter Name="TermDate" Type="DateTime" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="Email1" Type="String" />
            <asp:Parameter Name="OfficePhone" Type="String" />
            <asp:Parameter Name="MobilePhone" Type="String" />
            <asp:Parameter Name="Occupation" Type="String" />
            <asp:Parameter Name="HomePhone" Type="String" />
            <asp:Parameter Name="StreetAddress" Type="String" />
            <asp:Parameter Name="CityId" Type="Int32" />
            <asp:Parameter Name="ZipCode" Type="String" />
            <asp:Parameter Name="Rank" Type="String" />
            <asp:Parameter Name="LevelID" Type="Int32" />
            <asp:Parameter Name="SalutationID" Type="Int32" />
            <asp:Parameter Name="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="CreatedBy" SessionField="UserID" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSalutations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from SalutationCodes"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LookupService"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlLevel" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select LevelID, concat(Code,'=',Description) as Description from VeteranLevel"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select trim(ao.Occupation) as Occupation, ao.Occupation + ' - ' + ao.Title as OccupationTitle from ACEExhibit ao inner join ( SELECT Occupation, max(AceID) as AceID FROM ACEExhibit aoc group by Occupation ) a02 on ao.AceID = a02.AceID order by ao.Occupation"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, City + ' - ' + State as 'FullCity' from City order by City" />
    <asp:SqlDataSource ID="sqlVeteran2" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
        UpdateCommand="UPDATE Veteran SET   UpdatedBy = @UpdatedBy, UpdatedOn = getdate(), CampaignID = @CampaignID, CollegeID = @CollegeID  WHERE [ID] = @id">
        <UpdateParameters>
            <asp:Parameter Name="id" Type="Int32" />
            <asp:Parameter Name="CampaignID" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <telerik:RadWindowManager ID="RadWindowManager11" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
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
                <h3 id="popupHeader" runat="server"></h3>
                <asp:HiddenField ID="hfVeteranID" runat="server" />
                <asp:HiddenField ID="hfCampaignID" runat="server" />
                <div class="col-md-12" style="border: thin; border-color: lightgray; padding: 10px;">
                    <div class="row col-md-12">
                        Select Documents to upload, then click "Complete Upload" 
                    </div>
                    <div class="row col-md-12">
                        <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="AsyncUpload1"
                            OnClientFilesSelected="showUploadConfirm"
                            MultipleFileSelection="Automatic" Width="500px" />
                    </div>
                    <div id="divCompleteUpload" class="row col-md-12 complete" style="display: none;" runat="server">
                        <asp:Label ID="lblUploadDisclosure" CssClass="form-control red bold" runat="server"></asp:Label>
                        <telerik:RadButton ID="btnComple" runat="server" OnClick="btnCompleteUpload_Click" Text="Complete Upload" Skin="Material"></telerik:RadButton>
                    </div>
                </div>
                <telerik:RadGrid ID="rgVeteran" runat="server" AutoGenerateColumns="False" DataSourceID="sqlVeteran" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" Skin="Material" EnableHeaderContextMenu="true" AllowSorting="true" AllowPaging="true" PageSize="20" AllowFilteringByColumn="true" OnItemCommand="rgVeterans_ItemCommand">
                    <ClientSettings AllowKeyboardNavigation="true" Resizing-AllowColumnResize="true">
                        <Scrolling />
                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                        <ClientEvents OnPopUpShowing="popUpShowing"></ClientEvents>
                    </ClientSettings>
                    <GroupingSettings CaseSensitive="false" />
                    <MasterTableView DataSourceID="sqlVeteran" DataKeyNames="id" EditMode="Batch" CommandItemDisplay="Top" CommandItemSettings-SaveChangesText="Save" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                        <BatchEditingSettings EditType="Row" />
                        <Columns>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" ItemStyle-Width="10px" ReadOnly="true" Display="false">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ToolTip="Print Veteran Letter" CommandName="PrintVeteranLetter" ID="btnPrintVeteran" Text='<i class="fa fa-print" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" ItemStyle-Width="10px" ReadOnly="true">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ToolTip="Edit Veteran" CommandName="EditLead" ID="btnEditVeteran" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" ItemStyle-Width="10px" ReadOnly="true" Display="false">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ToolTip="Create Articulation" CommandName="AddArticulation" ID="btnAddArticulation" Text='<i class="fa fa-plus-circle" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" ItemStyle-Width="10px" ReadOnly="true">
                                <ItemTemplate>
									<asp:LinkButton runat="server" ToolTip="Militar Credits" CommandName="ViewMilitarCredits" ID="btnViewMilitarCredits" Text='<i class="fa fa-check-square" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" ItemStyle-Width="10px" ReadOnly="true" Display="false">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ToolTip="View Veteran Articulations" CommandName="VeteranArticulations" ID="btnViewVeteranArticulations" Text='<i class="fa fa-th-list" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="LeadID" UniqueName="LeadID" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataField="SalutationID" HeaderText="Salutation" UniqueName="SalutationID" DataSourceID="sqlSalutations" ListTextField="ShortDescription" ListValueField="id" HeaderStyle-Font-Bold="true" HeaderStyle-Width="80px" Display="false">
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn DataField="LastName" UniqueName="LastName" HeaderText="Last Name" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                    <RequiredFieldValidator SetFocusOnError="true" ForeColor="Red" Text="Please enter Last Name." ToolTip="Please enter last name."><span>Please enter Last Name</span>  </RequiredFieldValidator>
                                </ColumnValidationSettings>
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="FirstName" UniqueName="FirstName" HeaderText="First Name" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                    <RequiredFieldValidator SetFocusOnError="true" ForeColor="Red" Text="Please enter First Name." ToolTip="Please enter first name."><span>Please enter First Name</span>  </RequiredFieldValidator>
                                </ColumnValidationSettings>
                            </telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataField="ServiceID" HeaderText="Service" UniqueName="ServiceID" DataSourceID="sqlServices" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true" HeaderStyle-Width="100px" ItemStyle-Width="100px" DropDownControlType="RadComboBox" ColumnEditorID="CEDropdownServices">
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn DataField="Rank" UniqueName="Rank" HeaderText="Rank" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataField="LevelID" HeaderText="Level" UniqueName="LevelID" DataSourceID="sqlLevel" ListTextField="Description" ListValueField="LevelID" HeaderStyle-Font-Bold="true" HeaderStyle-Width="150px" Display="false">
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn DataField="Occupation" UniqueName="OccupationCode" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataField="Occupation" HeaderText="Occupation" UniqueName="Occupation" DataSourceID="sqlOccupations" ListTextField="OccupationTitle" ListValueField="Occupation" HeaderStyle-Font-Bold="true" HeaderStyle-Width="290px" Display="false">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboOccupations" DataSourceID="sqlOccupations" DataTextField="OccupationTitle"
                                        DataValueField="Occupation" MaxHeight="200px" Width="180px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Occupation").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="OccupationIndexChanged" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlockOccupation" runat="server">
                                        <script type="text/javascript">
                                            function OccupationIndexChanged(sender, args) {
                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("Occupation", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridDateTimeColumn UniqueName="BirthDate" PickerType="DatePicker" HeaderText="BirthDate" DataField="BirthDate" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Font-Bold="true" Display="false">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridDateTimeColumn UniqueName="TermDate" PickerType="DatePicker" HeaderText="TermDate" DataField="TermDate" DataFormatString="{0:MM/dd/yyyy}" Display="false" HeaderStyle-Font-Bold="true">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn DataField="Email" HeaderText="Email 1" UniqueName="Email" ColumnEditorID="CEEmail" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" Display="false">
                                <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                    <RequiredFieldValidator SetFocusOnError="true" ForeColor="Red" Text="Please enter an email." ToolTip="Please enter an email."><span>Please enter an email.</span>  </RequiredFieldValidator>
                                </ColumnValidationSettings>
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Email2" HeaderText="Email 2" UniqueName="Email2" ColumnEditorID="CEEmail" Display="false" HeaderStyle-Font-Bold="true" />
                            <telerik:GridBoundColumn DataField="CreditRecommendation" HeaderText="Credit Recommendation" UniqueName="CreditRecommendation" ColumnEditorID="CreditRecommendation"   ReadOnly="true"  Display="false"/>
                            <%--<telerik:GridMaskedColumn UniqueName="OfficePhone" HeaderText="Office Phone" DataField="OfficePhone" Mask="(###) ###-####" Display="false" />--%>
                            <telerik:GridMaskedColumn UniqueName="MobilePhone" HeaderText="Mobile Phone" DataField="MobilePhone" Mask="(###) ###-####" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" Display="false"/>
                            <telerik:GridMaskedColumn UniqueName="HomePhone" HeaderText="Home Phone" DataField="HomePhone" Mask="(###) ###-####" Display="false" HeaderStyle-Font-Bold="true" />
                            <telerik:GridBoundColumn DataField="StreetAddress" HeaderText="Street Address" UniqueName="StreetAddress" ColumnEditorID="CEAddress" Display="false" HeaderStyle-Font-Bold="true" />
                            <telerik:GridDropDownColumn DataField="CityId" HeaderText="City" UniqueName="CityId" DataSourceID="sqlCities" ListTextField="FullCity" ListValueField="id" HeaderStyle-Font-Bold="true" HeaderStyle-Width="150px">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboCities" DataSourceID="sqlCities" DataTextField="FullCity"
                                        DataValueField="id" MaxHeight="200px" Width="130px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("CityId").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="CityIndexChanged" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlockCity" runat="server">
                                        <script type="text/javascript">
                                            function CityIndexChanged(sender, args) {
                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                tableView.filter("CityId", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn DataField="ZipCode" HeaderText="ZipCode" UniqueName="ZipCode" HeaderStyle-Font-Bold="true" HeaderStyle-Width="55px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" />
                            <telerik:GridBoundColumn DataField="Campaign" HeaderText="Campaign" UniqueName="Campaign" HeaderStyle-Font-Bold="true" HeaderStyle-Width="75px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ReadOnly="true" Display="false" />
                            <telerik:GridClientDeleteColumn ConfirmTitle="Delete" ConfirmText="Are you sure you want to remove this Veteran ? After deleting please click on Save button to confirm changes ?" HeaderStyle-Width="35px" ButtonType="FontIconButton" />
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </div>
        </div>
        <telerik:GridTextBoxColumnEditor ID="CEDescription" TextBoxStyle-Width="500px" TextBoxMaxLength="200" runat="server" />
        <telerik:GridTextBoxColumnEditor ID="CEEmail" TextBoxStyle-Width="400px" TextBoxMaxLength="300" TextBoxMode="Email" TextBoxStyle-CssClass="" runat="server" />
        <telerik:GridTextBoxColumnEditor ID="CEAddress" TextBoxStyle-Width="400px" TextBoxMaxLength="300" runat="server" />
        <telerik:GridHTMLEditorColumnEditor ID="CEEditor" Editor-BackColor="White" runat="server" Editor-ContentAreaCssFile="~/Common/css/Editor.css" />
        <telerik:GridDropDownListColumnEditor ID="CEDropdown" runat="server" DropDownStyle-Width="400px" />
        <telerik:GridDropDownListColumnEditor ID="CEDropdownServices" runat="server" DropDownStyle-Width="100px" />
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function showUploadConfirm() {

            $(".complete").show();
        }
    </script>
</asp:Content>
