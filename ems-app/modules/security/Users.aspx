<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="ems_app.modules.security.Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .ambassador-details .RadLabel_Material {
            padding-bottom: 8px;
            font-size: 11px !important;
            display: block;
            font-weight: normal;
        }

        .ambassador-details label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
            color: #607D8B;
        }

        .ambassador-details a {
            color: darkblue;
            font-size: 11px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Users</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlUserSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [UserSubjects] WHERE [Id] = @Id" InsertCommand="INSERT INTO [UserSubjects] ( [UserID], [SubjectID]) VALUES ( @UserID, @SubjectID)" SelectCommand="SELECT * FROM [UserSubjects] WHERE ([UserID] = @UserID)" UpdateCommand="UPDATE [UserSubjects] SET [UserID] = @UserID, [SubjectID] = @SubjectID WHERE [Id] = @Id">
        <DeleteParameters>
            <asp:Parameter Name="Id" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter Name="UserID" ControlID="hfUserID" PropertyName="Value" Type="Int32" />
            <asp:Parameter Name="SubjectID" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter Name="UserID" ControlID="hfUserID" PropertyName="Value" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:ControlParameter Name="UserID" ControlID="hfUserID" PropertyName="Value" Type="Int32" />
            <asp:Parameter Name="SubjectID" Type="Int32" />
            <asp:Parameter Name="Id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlUserRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommandType="StoredProcedure" DeleteCommand="spROLES_USER_Delete" InsertCommandType="Text" InsertCommand="IF NOT EXISTS (SELECT * FROM ROLES_USER WHERE UserID = @UserID AND RoleID = @RoleID) BEGIN INSERT INTO ROLES_USER(UserID, RoleID, DefaultRole) VALUES (@UserID, @RoleID, @DefaultRole) END SET @InsertedID = SCOPE_IDENTITY()" SelectCommandType="StoredProcedure" SelectCommand="spROLES_USER_GetByUserID" OnInserted="sqlUserRoles_Inserted">
        <DeleteParameters>
            <asp:Parameter Name="RoleUserId" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter Name="UserID" ControlID="hfUserID" PropertyName="Value" Type="Int32" />
            <asp:Parameter Name="RoleID" Type="Int32" />
            <asp:Parameter Name="DefaultRole" Type="Boolean" DefaultValue="false" />
            <asp:Parameter Name="InsertedID" Type="Int32" Direction="Output"></asp:Parameter>
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter Name="UserID" ControlID="hfUserID" PropertyName="Value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlUserAvailableRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="spROLES_USER_GetRolesByUserID">
        <SelectParameters>
            <asp:ControlParameter Name="UserID" ControlID="hfUserID" PropertyName="Value" Type="Int32" />
            <asp:SessionParameter Name="ApplicationID" SessionField="ApplicationID" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlUsers" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [TBLUSERS] WHERE [UserID] = @UserID" SelectCommand="GetMAPUsers" SelectCommandType="StoredProcedure">
        <DeleteParameters>
            <asp:Parameter Name="UserID" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" DefaultValue="1" />
            <asp:SessionParameter Name="ApplicationID" SessionField="ApplicationID" Type="Int32" DefaultValue="1" />
            <asp:ControlParameter Name="facultyUsers" ControlID="hvFilterByFacultySubject" PropertyName="Value" Type="Int32" DefaultValue="0" />
            <asp:ControlParameter Name="subjectList" ControlID="hvSelectedSubjects" PropertyName="Value" Type="String" DefaultValue="0" />
            <asp:ControlParameter Name="ShowDisabled" ControlID="hvShowDisabled" PropertyName="Value" Type="Boolean" DefaultValue="False" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [ROLES] r WHERE r.ApplicationID  = @ApplicationID and r.[CollegeID] = @CollegeID ORDER BY R.[RoleName]">
        <SelectParameters>
            <asp:SessionParameter Name="ApplicationID" SessionField="ApplicationID" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from tblSubjects where college_id = @CollegeID order by subject">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <asp:HiddenField runat="server" ID="hfUserID" />
        <asp:HiddenField runat="server" ID="hvFilterByFacultySubject" />
        <asp:HiddenField runat="server" ID="hvSelectedSubjects" />
        <input type="hidden" id="hvShowDisabled" name="hvShowDenied" runat="server" />
        <div class="row">
            <div class="col-9">
                <telerik:RadTabStrip RenderMode="Lightweight" ID="RadTabStrip2" runat="server" EnableDragToReorder="true" MultiPageID="RadMultiPage2" SelectedIndex="0">
                    <Tabs>
                        <telerik:RadTab Text="College Roles"></telerik:RadTab>
                    </Tabs>
                </telerik:RadTabStrip>
                <telerik:RadMultiPage ID="RadMultiPage2" runat="server" CssClass="RadMultiPage" SelectedIndex="0">
                    <telerik:RadPageView ID="RadPageView2" runat="server" Style="overflow: hidden">
                <div class="row" style="padding-top:5px !important;">
                    <div class="col-4 d-flex justify-content-start align-items-center">
                        <telerik:RadCheckBox ID="rcbFilterBySubject" runat="server" Text="Filter Faculty Users by Subject(s)" AutoPostBack="true" OnCheckedChanged="rcbFilterBySubject_CheckedChanged" ToolTip=""></telerik:RadCheckBox>
                        <asp:Panel ID="pnlSubjects" runat="server" Font-Bold="true">
                            <telerik:RadComboBox ID="rcbSubjectsFilter" Text="" Label="Select a subject(s) : " runat="server" DataSourceID="sqlSubjects" DataTextField="subject" DataValueField="subject_id" AutoPostBack="true" CheckBoxes="true" Width="100%" AppendDataBoundItems="true" Filter="Contains" RenderMode="Lightweight" ToolTip="Please select the Subject(s) to list the discipline faculty users" DropDownAutoWidth="Enabled" EnableCheckAllItemsCheckBox="true" OnSelectedIndexChanged="rcbSubjectsFilter_SelectedIndexChanged" Font-Bold="true">
                            </telerik:RadComboBox>
                        </asp:Panel>
                    </div>
                    <div class="col-4 d-flex justify-content-center align-items-center">
                        <div class="form-group">
                            <asp:LinkButton ID="lbNewUser" Visible="false" OnClick="rbNewUser_Click" CssClass="btn btn-default"  runat="server"><i class='fa fa-plus-circle'></i> Add New User</asp:LinkButton>
                            <telerik:RadButton ID="RadButton1" CssClass="btn btn-default" runat="server" OnClick="rbNewUser_Click" Text="Add New User" Primary="true">
                                <Icon PrimaryIconCssClass="rbAdd"></Icon>
                            </telerik:RadButton>
                            <asp:Label ID="lblUserMessage" runat="server" />
                        </div>
                    </div>
                    <div class="col-4 d-flex justify-content-end align-items-center">
                        <div style="margin-right: 10px;">
                            <telerik:RadLabel ID="rlShowDisabled" Text="Show Disabled Accounts " runat="server"></telerik:RadLabel>
                            <telerik:RadSwitch ID="rsShowDisbled" runat="server" Width="65px" AutoPostBack="true" Checked="false" OnCheckedChanged="rsShowDisbled_CheckedChanged">
                                <ToggleStates>
                                    <ToggleStateOn Text="Yes" Value="true" />
                                    <ToggleStateOff Text="No" Value="false" />
                                </ToggleStates>
                            </telerik:RadSwitch>
                        </div>
                    </div>
                </div>
                <telerik:RadGrid ID="rgUsers" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlUsers" OnItemCommand="rgUsers_ItemCommand" OnPreRender="rgUsers_PreRender" Width="100%">
                    <ClientSettings EnablePostBackOnRowClick="true">
                        <Selecting AllowRowSelect="true" />
                        <ClientEvents OnFilterMenuShowing="FilteringMenu" />
                        <Scrolling AllowScroll="true" ScrollHeight="550px" />
                    </ClientSettings>
                    <ExportSettings HideStructureColumns="false" ExportOnlyData="True" OpenInNewWindow="True" IgnorePaging="True" Excel-AutoFitColumnWidth="AutoFitAll" FileName="Users" Excel-WorksheetName="Users" Excel-Format="Xlsx">
                    </ExportSettings>
                    <GroupingSettings CaseSensitive="false" />
                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="UserID" DataSourceID="sqlUsers" PageSize="10" AllowSorting="true" AllowPaging="true" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Font-Bold="true" CommandItemSettings-ShowExportToExcelButton="true" CommandItemSettings-ExportToExcelText="Export to Excel" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowRefreshButton="false" CommandItemDisplay="Top">
                        <Columns>
                            <telerik:GridBoundColumn DataField="Status" FilterControlAltText="Filter Status column" HeaderText="Status" SortExpression="Status" UniqueName="Status" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ReadOnly="true" FilterControlWidth="50px" HeaderStyle-Width="70px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="UserName" FilterControlAltText="Filter UserName column" HeaderText="User Name" SortExpression="UserName" UniqueName="UserName" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ReadOnly="true" FilterControlWidth="50px" HeaderStyle-Width="70px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="FirstName" FilterControlAltText="Filter FirstName column" HeaderText="First Name" SortExpression="FirstName" UniqueName="FirstName" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ReadOnly="true" FilterControlWidth="50px" HeaderStyle-Width="70px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="LastName" FilterControlAltText="Filter LastName column" HeaderText="Last Name" SortExpression="LastName" UniqueName="LastName" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ReadOnly="true" FilterControlWidth="50px" HeaderStyle-Width="70px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Email" FilterControlAltText="Filter Email column" HeaderText="Email" SortExpression="Email" UniqueName="Email" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" HeaderStyle-Width="80px" ReadOnly="true" FilterControlWidth="80px">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="CreatedDate" DataType="System.DateTime" FilterControlAltText="Filter CreatedDate column" HeaderText="Created Date" SortExpression="CreatedDate" UniqueName="CreatedDate" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="120px" FilterControlToolTip="Search by Created Date" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" Exportable="false">
                                <HeaderStyle Width="130px" />
                            </telerik:GridDateTimeColumn>
                            <telerik:GridDateTimeColumn DataField="LastLoginDate" DataType="System.DateTime" FilterControlAltText="Filter LastLoginDate column" HeaderText="Last Login Date" SortExpression="LastLoginDate" UniqueName="LastLoginDate" DataFormatString="{0:MM/dd/yyyy}" FilterControlWidth="120px" FilterControlToolTip="Search by Last Login Date" PickerType="DatePicker" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" Display="false" Exportable="false">
                                <HeaderStyle Width="130px" />
                            </telerik:GridDateTimeColumn>
                            <telerik:GridDropDownColumn UniqueName="RoleID" DataField="RoleID" HeaderText="Main Role"
                                HeaderStyle-Width="100px" DataSourceID="sqlRoles" ListTextField="RoleName" ListValueField="RoleID">
                                <FilterTemplate>
                                    <telerik:RadComboBox ID="RadComboBoxRoles" DataSourceID="sqlRoles" DataTextField="RoleName"
                                        DataValueField="RoleID" Height="150px" Width="100px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("RoleID").CurrentFilterValue %>'
                                        runat="server" OnClientSelectedIndexChanged="RoleIndexChanged">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="All" />
                                        </Items>
                                    </telerik:RadComboBox>
                                    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                        <script type="text/javascript">
                                            function RoleIndexChanged(sender, args) {
                                                var tableView = $find('<%# ((GridItem)Container).OwnerTableView.ClientID %>');
                                                tableView.filter("RoleID", args.get_item().get_value(), "EqualTo");
                                            }
                                        </script>
                                    </telerik:RadScriptBlock>
                                </FilterTemplate>
                            </telerik:GridDropDownColumn>
                            <telerik:GridBoundColumn DataField="UserID" DataType="System.Int32" FilterControlAltText="Filter UserID column" HeaderText="User ID" ReadOnly="True" SortExpression="UserID" UniqueName="UserID" Display="false" Exportable="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Roles" HeaderText="Add. Roles" UniqueName="Roles" Display="true" Exportable="true" HeaderStyle-Width="80px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Subjects" HeaderText="Subjects" UniqueName="Subjects" Exportable="true" HeaderStyle-Width="80px">
                            </telerik:GridBoundColumn>
                            <telerik:GridNumericColumn DataField="UserID" HeaderText="Subjects" UniqueName="UserID2" Exportable="true" HeaderStyle-Width="80px">
                            </telerik:GridNumericColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
                    </telerik:RadPageView>
                </telerik:RadMultiPage>
                <br />

            </div>
            <div class="col-3">
                <div class="panel-heading">
                </div>
                <div class="panel-body">
                    <telerik:RadTabStrip RenderMode="Lightweight" ID="RadTabStrip1" runat="server" EnableDragToReorder="true" MultiPageID="RadMultiPage1" SelectedIndex="0">
                        <Tabs>
                            <telerik:RadTab Text="User Information"></telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" CssClass="RadMultiPage" SelectedIndex="0">
                        <telerik:RadPageView ID="RadPageView1" runat="server" Style="overflow: hidden">
                    <asp:Panel ID="pnlUser" runat="server" DefaultButton="rbUpdate">

                        <div class="form-group" style="margin-top:10px;">
                            <div class="row">
                                <div class="col-sm-3">
                                    <label style="font-weight: bold;">Primary Role</label>
                                </div>
                                <div class="col-sm-6">
                                    <%--<asp:TextBox ID="tbUserID" runat="server"></asp:TextBox>--%>
                                    <telerik:RadComboBox ID="rcbRoles" runat="server" Width="100%" Culture="es-ES" DataSourceID="sqlRoles" DataTextField="RoleName" DataValueField="RoleID"></telerik:RadComboBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3" style="margin-top: 10px;">
                                    <label style="font-weight: bold">First Name</label>
                                </div>
                                <div class="col-sm-6" style="margin-top: 10px;">
                                    <telerik:RadTextBox ID="rtFirstName" runat="server" Width="100%"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3" style="margin-top: 10px;">
                                    <label style="font-weight: bold">Last Name</label>
                                </div>
                                <div class="col-sm-6" style="margin-top: 10px;">
                                    <telerik:RadTextBox ID="rtLastName" runat="server" Width="100%"></telerik:RadTextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3" style="margin-top: 10px;">
                                    <label style="font-weight: bold">Email</label>
                                </div>
                                <div class="col-sm-6" style="margin-top: 10px;">
                                    <telerik:RadTextBox ID="rtbEmail" InputType="Email" runat="server" Width="100%"></telerik:RadTextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="rtbEmail" ErrorMessage="* Required Field" ValidationGroup="UserData" CssClass="alert alert-danger" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3">
                                    <label style="font-weight: bold">User Name</label>
                                </div>
                                <div class="col-sm-6">
                                    <telerik:RadTextBox ID="rtUserName" runat="server" Width="100%"></telerik:RadTextBox>
                                    <asp:RequiredFieldValidator ID="rfvUserName" runat="server" ControlToValidate="rtUserName" ErrorMessage="* Required Field" ValidationGroup="UserData" CssClass="alert alert-danger" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3">
                                    <label style="font-weight: bold">Current Password</label>
                                </div>
                                <div class="col-sm-6">
                                    <telerik:RadTextBox ID="rtPassword" runat="server" MaxLength="15" Width="100%" TextMode="Password"></telerik:RadTextBox>
                                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="rtPassword" ErrorMessage="* Required Field" ValidationGroup="UserData" CssClass="alert alert-danger" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-6">
                                    <telerik:RadCheckBox ID="rchkAutomaticNotification" AutoPostBack="false" runat="server" CausesValidation="false" Text=" Allow Email Notifications"></telerik:RadCheckBox>
                                </div>

                                <div class="col-sm-4">
                                    <telerik:RadCheckBox ID="rchkSuperUser" Visible="false" AutoPostBack="false" runat="server" CausesValidation="false" Text=" Super User" ToolTip="When this option is checked, the user will gain access to the SuperUser page"></telerik:RadCheckBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-6">
                                    <telerik:RadCheckBox ID="rchkWelcome" AutoPostBack="false" runat="server" CausesValidation="false" Text=" Show Self-Guided Training " ToolTip="When this option is checked, MAP will automatically show onboarding help"></telerik:RadCheckBox>
                                </div>
                                <div class="col-sm-6">
                                    <telerik:RadCheckBox ID="rchkDistrictAdministrator" Visible="false" AutoPostBack="false" runat="server" CausesValidation="false" Text=" District Administrator" ToolTip="When this option is checked, the user's access to the SuperUser page is limited to colleges within the user's district"></telerik:RadCheckBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-6">
                                    <telerik:RadCheckBox ID="rchkActive" AutoPostBack="false" runat="server" CausesValidation="false" Text=" Active User " ToolTip="When this option is checked..."></telerik:RadCheckBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12" style="text-align: center">
                                    <telerik:RadButton ID="rbSave" CssClass="btn btn-default" runat="server" OnClick="rbSave_Click" Text="Save" ValidationGroup="UserData" Primary="true"></telerik:RadButton>
                                    <br />
                                    <telerik:RadButton ID="rbUpdate" CssClass="btn btn-default" runat="server" OnClick="rbUpdate_Click" Text="Update User Information" ValidationGroup="UserData"></telerik:RadButton>
                                </div>
                            </div>
                            <br />
                        </div>
                        <%--<div class="form-group">
                                <div class="col-sm-12">
                                    <div class="alert success fade in" data-alert="alert" >
                                        <a class="close" data-dismiss="alert" href="#">&times;</a>
                                        <asp:Label ID="lblUserMessage"  runat="server" /> 
                                    </div>
                                <br />
                                </div>
                            </div>--%>
                        <asp:Panel ID="pnlUserRoles" runat="server" Visible="false">
                            <h3 style="text-align: center">Additional Roles assigned to this user :</h3>
                            <telerik:RadGrid ID="rgUserRoles" runat="server" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="sqlUserRoles" GroupPanelPosition="Top" MasterTableView-EditFormSettings-EditColumn-HeaderStyle-Width="50px" MasterTableView-NoMasterRecordsText="No additional roles">
                                <MasterTableView CommandItemDisplay="Top" DataKeyNames="RoleUserID" DataSourceID="sqlUserRoles" CommandItemSettings-ShowRefreshButton="false" CommandItemSettings-CancelChangesText="Cancel" CommandItemSettings-SaveChangesText="Save" CommandItemSettings-AddNewRecordText="Add">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="RoleUserID" UniqueName="RoleUserID" DataType="System.Int32" ReadOnly="true" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDropDownColumn DataField="RoleID" DataSourceID="sqlUserAvailableRoles" FilterControlAltText="Filter RoleID column" HeaderText="Role" UniqueName="RoleID" ListTextField="RoleName" ListValueField="RoleID" HeaderStyle-Font-Bold="true">
                                        </telerik:GridDropDownColumn>
                                        <telerik:GridCheckBoxColumn UniqueName="DefaultRole" DataField="DefaultRole" HeaderText="Default Role" Display="false" DefaultInsertValue="false" ReadOnly="true">
                                        </telerik:GridCheckBoxColumn>
                                        <telerik:GridButtonColumn CommandName="Delete" Text="Delete" ConfirmDialogType="RadWindow" ConfirmText="Are you sure want to delete this User Role ?" HeaderStyle-Width="50px" UniqueName="DeleteColumn"></telerik:GridButtonColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                            <br />
                        </asp:Panel>
                        <asp:Panel ID="pnlUserSubjects" runat="server" Visible="false">
                            <h3 style="text-align: center">Assigned subjects for faculty users</h3>
                            <telerik:RadGrid ID="rgUserSubjects" runat="server" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" AllowSorting="True" AutoGenerateColumns="False" AutoGenerateEditColumn="True" DataSourceID="sqlUserSubjects" GroupPanelPosition="Top" MasterTableView-EditFormSettings-EditColumn-HeaderStyle-Width="50px" MasterTableView-NoMasterRecordsText="No subjects">
                                <MasterTableView CommandItemDisplay="Top" DataKeyNames="id" DataSourceID="sqlUserSubjects" EditMode="Batch" CommandItemSettings-ShowRefreshButton="false" CommandItemSettings-CancelChangesText="Cancel" CommandItemSettings-SaveChangesText="Save" CommandItemSettings-AddNewRecordText="Add">
                                    <BatchEditingSettings EditType="Row" />
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="ID" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" DataType="System.Int32" ReadOnly="True" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="UserID" FilterControlAltText="Filter UserID column" HeaderText="UserID" SortExpression="UserID" UniqueName="UserID" DataType="System.Int32" ReadOnly="True" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDropDownColumn DataField="SubjectID" DataSourceID="sqlSubjects" FilterControlAltText="Filter SubjectID column" HeaderText="Subject" UniqueName="SubjectID" ListTextField="subject" ListValueField="subject_id" HeaderStyle-Font-Bold="true">
                                        </telerik:GridDropDownColumn>
                                        <telerik:GridButtonColumn CommandName="Delete" Text="Delete" ConfirmDialogType="RadWindow" ConfirmText="Are you sure want to delete this Subject ?" HeaderStyle-Width="50px" UniqueName="DeleteColumn"></telerik:GridButtonColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </asp:Panel>
                    </asp:Panel>
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </div>
            </div>
        </div>
        <div class="row">
            <telerik:RadTabStrip RenderMode="Lightweight" ID="tsVersions" runat="server" EnableDragToReorder="true" MultiPageID="rmpVersions" SelectedIndex="0">
                <Tabs>
                    <telerik:RadTab Text="Contact Log"></telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="rmpVersions" runat="server" CssClass="RadMultiPage" SelectedIndex="0">
                <telerik:RadPageView ID="rpvCurrentVersion" runat="server" Style="overflow: hidden">
                    <asp:SqlDataSource runat="server" ID="sqlAmbassador" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetMAPCohort" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:SessionParameter Name="CollegeName" SessionField="College" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:Repeater ID="rptAmbassador" runat="server" DataSourceID="sqlAmbassador">
                        <HeaderTemplate>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="row ambassador-details">
                                <div class="col-2">
                                    <label>MAP Ambassador</label>
                                    <telerik:RadLabel ID="rlAmbassador" runat="server" Text='<%# Eval("LEAD_MANAGER") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("LEAD_MANAGER_EMAIL") %>'><%# Eval("LEAD_MANAGER_EMAIL") %></a>
                                    <label>Primary Contact</label>
                                    <telerik:RadLabel ID="RadLabel2" runat="server" Text='<%# Eval("PRIMARY_CONTACT") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("PRIMARY_CONTACT_EMAIL") %>'><%# Eval("PRIMARY_CONTACT_EMAIL") %></a>
                                </div>
                                <div class="col-2">
                                    <label>College President</label>
                                    <telerik:RadLabel ID="RadLabel4" runat="server" Text='<%# Eval("CEO") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("CEO_EMAIL") %>'><%# Eval("CEO_EMAIL") %></a>
                                    <label>Curriculum Specialist</label>
                                    <telerik:RadLabel ID="RadLabel6" runat="server" Text='<%# Eval("IT_CONTACT") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("IT_CONTACT_EMAIL") %>'><%# Eval("IT_CONTACT_EMAIL") %></a>
                                </div>
                                <div class="col-2">
                                    <label>Lead Evaluator</label>
                                    <telerik:RadLabel ID="RadLabel8" runat="server" Text='<%# Eval("LEAD_EVALUATOR") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("LEAD_EVALUATOR_EMAIL") %>'><%# Eval("LEAD_EVALUATOR_EMAIL") %></a>
                                    <label>School Certifying Official</label>
                                    <telerik:RadLabel ID="RadLabel10" runat="server" Text='<%# Eval("SCHOOL_CERTIFYING_OFFICIAL") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("VETERAN_SCHOOL_CERTIFYING_OFFICIAL_EMAIL") %>'><%# Eval("VETERAN_SCHOOL_CERTIFYING_OFFICIAL_EMAIL") %></a>
                                </div>
                                <div class="col-2">
                                    <label>Articulation Officer</label>
                                    <telerik:RadLabel ID="RadLabel12" runat="server" Text='<%# Eval("ARTICULATION_OFFICER") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("ARTICULATION_OFFICER_EMAIL") %>'><%# Eval("ARTICULATION_OFFICER_EMAIL") %></a>
                                    <label>Veteran Rep/Counselor</label>
                                    <telerik:RadLabel ID="RadLabel14" runat="server" Text='<%# Eval("VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION_EMAIL") %>'><%# Eval("VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION_EMAIL") %></a>
                                </div>
                                <div class="col-2">
                                    <label>Academic Senate President</label>
                                    <telerik:RadLabel ID="RadLabel16" runat="server" Text='<%# Eval("ACADEMIC_SENATE_PRESIDENT") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("ACADEMIC_SENATE_PRESIDENT_EMAIL") %>'><%# Eval("ACADEMIC_SENATE_PRESIDENT_EMAIL") %></a>
                                    <label>VPAA</label>
                                    <telerik:RadLabel ID="RadLabel18" runat="server" Text='<%# Eval("VPAA") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("VPAA_EMAIL") %>'><%# Eval("VPAA_EMAIL") %></a>
                                </div>
                                <div class="col-2">
                                    <label>Faculty Lead</label>
                                    <telerik:RadLabel ID="RadLabel20" runat="server" Text='<%# Eval("FACULTY_LEAD") %>'></telerik:RadLabel>
                                    <a href='mailto:<%# Eval("FACULTY_LEAD_EMAIL") %>'><%# Eval("FACULTY_LEAD_EMAIL") %></a>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                        </FooterTemplate>
                    </asp:Repeater>
                </telerik:RadPageView>
            </telerik:RadMultiPage>
        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        function checkBoxClick(sender, args) {
            var grid = $find("<%= rgUserRoles.ClientID %>");
            var masterTableView = grid.get_masterTableView();
            var batchEditingManager = grid.get_batchEditingManager();
            var parentCell = $telerik.$(sender).closest("td")[0];

            var initialValue = sender.checked;
            sender.checked = !sender.checked;

            batchEditingManager.changeCellValue(parentCell, initialValue);
        }
        $(document).ready(function () {
            $(".alert").fadeOut(3000);
        });

    </script>
</asp:Content>
