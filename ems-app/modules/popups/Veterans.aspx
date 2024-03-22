<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Veterans.aspx.cs" Inherits="ems_app.modules.popups.Veterans" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Add Veterans to Campaign</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
    <style>
        html .RadUpload_Material .ruSelectWrap .ruBrowse {
            height:25px !important;
        }
    </style>
</head>
<body style="background-color: #fff !important;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlVeteran" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT v.*, v.LastName + ', ' + v.FirstName as 'FullName' FROM VeteranLead vl left outer join Veteran v on vl.VeteranID  = v.id where vl.CampaignID = @Id"
            UpdateCommand="UPDATE Veteran SET [FirstName] = @FirstName, [LastName] = @LastName, [ServiceID] = @ServiceID, [BirthDate] = @BirthDate, [TermDate] = @TermDate, [Email] = @Email, [Email1] = @Email1,  [OfficePhone] = @OfficePhone, [Occupation] = @Occupation, [MobilePhone] = @MobilePhone, [HomePhone] = @HomePhone, [StreetAddress] = @StreetAddress, [CityId] = @CityId,  [ZipCode] = @ZipCode, [SalutationID] = @SalutationID, [Rank] = @Rank, [LevelID] = @LevelID, UpdatedBy = @UpdatedBy, UpdatedOn = getdate() WHERE [ID] = @id"
            InsertCommand="INSERT INTO [dbo].[Veteran] ([FirstName],[LastName],[BirthDate],[TermDate],[Email],[Email1],[OfficePhone],[MobilePhone],[HomePhone],[SalutationID],[ServiceID],[StreetAddress],[ZipCode],[CreatedBy],[CreatedOn],[CityId],[CampaignID],[Occupation],[Rank],[LevelID],[CollegeID]) 
            VALUES(@FirstName,@LastName,@BirthDate,@TermDate,@Email,@Email1,@OfficePhone,@MobilePhone,@HomePhone,@SalutationID,@ServiceID,@StreetAddress,@ZipCode,@CreatedBy,getdate(),@CityId,@CampaignId,@Occupation,@Rank,@LevelID,@CollegeID)"
            DeleteCommand="DELETE FROM VeteranLead WHERE CampaignID = @CampaignID AND VeteranID = @id">
            <DeleteParameters>
                <asp:QueryStringParameter Name="CampaignID" QueryStringField="CampaignId" />
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="Id" QueryStringField="CampaignId" />
            </SelectParameters>
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
                <asp:QueryStringParameter DefaultValue="0" Name="CampaignId" QueryStringField="CampaignId" />
            </InsertParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="sqlVeteran2" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
            UpdateCommand="UPDATE Veteran SET   UpdatedBy = @UpdatedBy, UpdatedOn = getdate(), CampaignID = @CampaignID, CollegeID = @CollegeID  WHERE [ID] = @id">
            <UpdateParameters>
                <asp:Parameter Name="id" Type="Int32" /> 
                <asp:Parameter Name="CampaignID" Type="Int32" />
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlSalutations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from SalutationCodes"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LookupService"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlLevel" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select LevelID, concat(Code,'=',Description) as Description from VeteranLevel"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ao.Occupation as 'OccupationCode', ao.Occupation + ' - ' + ao.Title as OccupationTitle from ACEExhibit ao inner join ( SELECT Occupation, max(AceID) as AceID FROM ACEExhibit aoc group by Occupation ) a02 on ao.AceID = a02.AceID order by ao.Occupation"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, City + ' - ' + State as 'FullCity' from City order by City" />
        <telerik:RadWindowManager ID="RadWindowManager111" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
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
            <div style="padding: 10px !important;margin: 10px;">
                <div class="row">
                    <asp:HiddenField ID="hfCampaignID" runat="server" />
                    <asp:HiddenField ID="hfVeteranID" runat="server" />
                    <h3 id="popupHeader" runat="server"></h3>
            <div class="col-12" style="border: thin; border-color: lightgray; padding: 10px;">
                <div class="row col-12" style="padding-left:10px;">
                    <p style="padding-left:10px;">Select Documents to upload, then click "Complete Upload" </p>
                </div>
                <div class="row col-12">
                    <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="AsyncUpload1"
                        OnClientFilesSelected="showUploadConfirm"
                        MultipleFileSelection="Automatic" Width="500px" />
                </div>
                <div id="divCompleteUpload" class="row col-12 complete" style="display: none;" runat="server">
                    <asp:Label ID="lblUploadDisclosure" CssClass="d-block p-2 red bold" runat="server"></asp:Label>
                    <br /><br />
                    <telerik:RadButton ID="btnComple" runat="server" OnClick="btnCompleteUpload_Click" Text="Complete Upload" Skin="Material"></telerik:RadButton>
                </div>
            </div>
                    <telerik:RadGrid ID="rgVeteran" runat="server" AutoGenerateColumns="False" DataSourceID="sqlVeteran" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" Skin="Material" EnableHeaderContextMenu="true" AllowSorting="true" OnItemCommand="rgVeteran_ItemCommand" AllowPaging="true" PageSize="30">
                        <ClientSettings AllowKeyboardNavigation="true" Resizing-AllowColumnResize="true">
                            <Scrolling />
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                            <ClientEvents></ClientEvents>
                        </ClientSettings>
                        <MasterTableView DataSourceID="sqlVeteran" DataKeyNames="id" EditMode="Batch" CommandItemDisplay="Top" CommandItemSettings-SaveChangesText="Save" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" AllowPaging="true">
                            <BatchEditingSettings EditType="Cell" />
                            <Columns>
                                <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="SalutationID" HeaderText="Salutation" UniqueName="SalutationID" DataSourceID="sqlSalutations" ListTextField="ShortDescription" ListValueField="id" HeaderStyle-Font-Bold="true" HeaderStyle-Width="80px" Display="false">
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn DataField="FirstName" UniqueName="FirstName" HeaderText="First Name" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="LastName" UniqueName="LastName" HeaderText="Last Name" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="ServiceID" HeaderText="Service" UniqueName="ServiceID" DataSourceID="sqlServices" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true" HeaderStyle-Width="90px">
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn DataField="Rank" UniqueName="Rank" HeaderText="Rank" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="LevelID" HeaderText="Level" UniqueName="LevelID" DataSourceID="sqlLevel" ListTextField="Description" ListValueField="LevelID" HeaderStyle-Font-Bold="true" HeaderStyle-Width="150px">
                                </telerik:GridDropDownColumn>
                                <telerik:GridDropDownColumn DataField="Occupation" HeaderText="Occupation" UniqueName="Occupation" DataSourceID="sqlOccupations" ListTextField="OccupationTitle" ListValueField="OccupationCode" HeaderStyle-Font-Bold="true" HeaderStyle-Width="290px" DropDownControlType="RadComboBox">
                                </telerik:GridDropDownColumn>
                                <telerik:GridDateTimeColumn UniqueName="BirthDate" PickerType="DatePicker" HeaderText="BirthDate" DataField="BirthDate" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Font-Bold="true" Display="false">
                                </telerik:GridDateTimeColumn>
                                <telerik:GridDateTimeColumn UniqueName="TermDate" PickerType="DatePicker" HeaderText="TermDate" DataField="TermDate" DataFormatString="{0:MM/dd/yyyy}" Display="false" HeaderStyle-Font-Bold="true">
                                </telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn DataField="Email" HeaderText="Email 1" UniqueName="Email" ColumnEditorID="CEEmail" HeaderStyle-Font-Bold="true" />
                                <telerik:GridBoundColumn DataField="Email2" HeaderText="Email 2" UniqueName="Email2" ColumnEditorID="CEEmail" Display="false" HeaderStyle-Font-Bold="true" />
                                <%--<telerik:GridMaskedColumn UniqueName="OfficePhone" HeaderText="Office Phone" DataField="OfficePhone" Mask="(###) ###-####" Display="false" />--%>
                                <telerik:GridMaskedColumn UniqueName="MobilePhone" HeaderText="Mobile Phone" DataField="MobilePhone" Mask="(###) ###-####" HeaderStyle-Font-Bold="true" />
                                <telerik:GridMaskedColumn UniqueName="HomePhone" HeaderText="Home Phone" DataField="HomePhone" Mask="(###) ###-####" Display="false" HeaderStyle-Font-Bold="true" />
                                <telerik:GridBoundColumn DataField="StreetAddress" HeaderText="Street Address" UniqueName="StreetAddress" ColumnEditorID="CEAddress" Display="false" HeaderStyle-Font-Bold="true" />
                                <telerik:GridDropDownColumn DataField="CityId" HeaderText="City" UniqueName="CityId" DataSourceID="sqlCities" ListTextField="FullCity" ListValueField="id" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px">
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn DataField="ZipCode" HeaderText="ZipCode" UniqueName="ZipCode" HeaderStyle-Font-Bold="true" HeaderStyle-Width="55px" />
                                <telerik:GridButtonColumn ButtonType="LinkButton" CommandName="EditVeteran" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="35px" HeaderText="Edit" Text="Edit" UniqueName="EditColumn">
                                    <HeaderStyle Width="35px" />
                                </telerik:GridButtonColumn>
                                <telerik:GridClientDeleteColumn ConfirmTitle="Delete" ConfirmText="Are you sure you want to remove this Veteran from the current campaign? After deleting please click on Save button to confirm changes ?" HeaderStyle-Width="35px" ButtonType="FontIconButton" />
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
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
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function showUploadConfirm() {

            $(".complete").show();
        }
    </script>
</body>
</html>


