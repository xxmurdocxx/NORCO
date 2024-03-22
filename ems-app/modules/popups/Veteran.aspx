<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Veteran.aspx.cs" Inherits="ems_app.modules.popups.Veteran" %>

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
<body>
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlVeteran" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT *, LastName + ', ' + FirstName as 'FullName' FROM Veteran WHERE Id = @Id" UpdateCommand="UPDATE Veteran SET [FirstName] = @FirstName, [LastName] = @LastName, [ServiceID] = @ServiceID, [BirthDate] = @BirthDate, [TermDate] = @TermDate, [Email] = @Email, [Email1] = @Email1,  [OfficePhone] = @OfficePhone, [MobilePhone] = @MobilePhone, [HomePhone] = @HomePhone, [StreetAddress] = @StreetAddress, [CityId] = @CityId, [State] = @State, [ZipCode] = @ZipCode, [SalutationID] = @SalutationID WHERE [ID] = @Id">
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
                <asp:Parameter Name="State" Type="String" />
                <asp:Parameter Name="ZipCode" Type="String" />
                <asp:Parameter Name="SalutationID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlVeteranOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct a.OccupationCode, a.OccupationTitle, a.id from ( SELECT VO.OccupationCode, VO.Id, ( select a.title from AceExhibit a join ( select Occupation, max(EndDate) as EndDate from AceExhibit where Occupation = vo.OccupationCode group by Occupation ) as b on a.Occupation = b.Occupation and a.EndDate = b.EndDate ) as OccupationTitle FROM VeteranOccupation VO where VO.VeteranId = @Id and VO.CollegeId = @CollegeId) as a where a.OccupationTitle is not null order by a.OccupationCode" DeleteCommand="DELETE FROM [VeteranOccupation] WHERE [id] = @id" InsertCommand="INSERT INTO  [VeteranOccupation] ([OccupationCode],[CollegeID],[VeteranId]) values (@OccupationCode, @CollegeID, @Id)">
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
        <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ao.Occupation as 'OccupationCode', ao.Occupation + ' - ' + ao.Title as OccupationTitle from AceExhibit ao inner join ( SELECT Occupation, max(AceID) as AceID FROM AceExhibit aoc group by Occupation ) a02 on ao.AceID = a02.AceID order by ao.Occupation"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlOccupationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT CO.AceID, CO.TeamRevd, CO.Exhibit, '' CourseNumber, CO.Title, '' CourseLength, CO.Occupation as OccupationCode, ( select a.title from AceExhibit a join ( select Occupation, max(EndDate) as EndDate from AceExhibit where Occupation = co.Occupation group by Occupation ) as b  on a.Occupation = b.Occupation and a.EndDate = b.EndDate ) as OccupationTitle FROM ACEExhibit CO where co.[Occupation] = @OccupationCode ORDER BY CO.AceID, CO.TeamRevd">
            <SelectParameters>
                <asp:ControlParameter ControlID="rgVeteranOccupations" Name="OccupationCode" PropertyName="SelectedValue" Type="String"></asp:ControlParameter>
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LookupService"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlSalutations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from SalutationCodes"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, City + ' - ' + State as 'FullCity' from City order by State, City" />
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <div style="padding: 15px !important;background-color: #fff !important;">
                <div class="row">
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <h3>Veteran Information</h3>
                        <telerik:RadGrid ID="rgVeteran" runat="server" AutoGenerateColumns="False" DataSourceID="sqlVeteran" AllowAutomaticUpdates="true">
                            <ClientSettings>
                                <ClientEvents OnPopUpShowing="popUpShowing" />
                            </ClientSettings>
                            <MasterTableView DataSourceID="sqlVeteran" DataKeyNames="id" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true" CommandItemDisplay="None" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save">
                                <Columns>
                                    <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit">
                                    </telerik:GridEditCommandColumn>
                                    <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="SalutationID" HeaderText="Salutation" UniqueName="SalutationID" DataSourceID="sqlSalutations" ListTextField="ShortDescription" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn DataField="FirstName" UniqueName="FirstName" HeaderText="First Name" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="LastName" UniqueName="LastName" HeaderText="Last Name" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDropDownColumn DataField="ServiceID" HeaderText="Service" UniqueName="ServiceID" DataSourceID="sqlServices" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridDateTimeColumn UniqueName="BirthDate" PickerType="DatePicker" HeaderText="BirthDate" DataField="BirthDate" DataFormatString="{0:MM/dd/yyyy}" Display="false">
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridDateTimeColumn UniqueName="TermDate" PickerType="DatePicker" HeaderText="TermDate" DataField="TermDate" DataFormatString="{0:MM/dd/yyyy}" Display="false">
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridBoundColumn DataField="Email" HeaderText="Email 1" UniqueName="Email" Display="false" ColumnEditorID="CEEmail" />
                                    <telerik:GridBoundColumn DataField="Email2" HeaderText="Email 2" UniqueName="Email2" Display="false" ColumnEditorID="CEEmail" />
                                    <telerik:GridMaskedColumn UniqueName="OfficePhone" HeaderText="Office Phone" DataField="OfficePhone" Mask="(###) ###-####" Display="false" />
                                    <telerik:GridMaskedColumn UniqueName="MobilePhone" HeaderText="Mobile Phone" DataField="MobilePhone" Mask="(###) ###-####" Display="false" />
                                    <telerik:GridMaskedColumn UniqueName="HomePhone" HeaderText="Home Phone" DataField="HomePhone" Mask="(###) ###-####" Display="false" />
                                    <telerik:GridBoundColumn DataField="StreetAddress" HeaderText="Street Address" UniqueName="StreetAddress" Display="false"  ColumnEditorID="CEAddress" />
                                    <telerik:GridDropDownColumn DataField="CityId" HeaderText="City"  UniqueName="CityId" DataSourceID="sqlCities" ListTextField="FullCity" ListValueField="id" Display="false">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn DataField="State" HeaderText="State" UniqueName="State" Display="false" />
                                    <telerik:GridBoundColumn DataField="ZipCode" HeaderText="ZipCode" UniqueName="ZipCode" Display="false" />
                                </Columns>
                                <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Veteran: {0}" CaptionDataField="Fullname" FormCaptionStyle-Font-Bold="true" PopUpSettings-ShowCaptionInEditForm="true">
                                    <PopUpSettings Height="570px" Modal="True" Width="500px" />
                                </EditFormSettings>
                            </MasterTableView>
                        </telerik:RadGrid>                        
                    </div>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <h3>Occupation(s)</h3>
                        <div class="OccupationDetails">
                            <telerik:RadGrid ID="rgVeteranOccupations" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlVeteranOccupations" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" AllowAutomaticInserts="true" OnItemCommand="rgVeteranOccupations_ItemCommand">
                                <ClientSettings AllowKeyboardNavigation="true" EnablePostBackOnRowClick="true">
                                    <Selecting AllowRowSelect="true"></Selecting>
                                </ClientSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlVeteranOccupations" PageSize="12" DataKeyNames="OccupationCode" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="true" EnableHierarchyExpandAll="true" AllowFilteringByColumn="false" CommandItemSettings-AddNewRecordText="Add an Occupation">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDropDownColumn DataField="OccupationCode" FilterControlAltText="Filter OccupationCode column" HeaderText="Occupation" SortExpression="OccupationCode" UniqueName="OccupationCode" DataSourceID="sqlOccupations" ListTextField="OccupationTitle" ListValueField="OccupationCode" HeaderStyle-Width="365px" AllowFiltering="false"  HeaderStyle-Font-Bold="true">
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
                        <h3>Related Courses</h3>
                        <div>
                            <telerik:RadGrid ID="rgRelatedCourses" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOccupationCourses" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false">
                                <MasterTableView DataSourceID="sqlOccupationCourses"  CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" AllowFilteringByColumn="false" DataKeyNames="OccupationCode">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="AceId" UniqueName="AceId" HeaderText="ACE ID" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn UniqueName="TeamRevd" PickerType="DatePicker" HeaderText="Team Revd" DataField="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Font-Bold="true">
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridBoundColumn DataField="Title" UniqueName="Title" HeaderText="Title" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </div>
                    </div>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
</body>
</html>
