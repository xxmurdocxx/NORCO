<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="LookupTables.aspx.cs" Inherits="ems_app.modules.settings.LookupTables" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Manage Lookup Tables</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <asp:SqlDataSource ID="sqlActionTypes" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [ActionType] WHERE [id] = @id" InsertCommand="INSERT INTO [ActionType] ([description]) VALUES (@description)" SelectCommand="SELECT * FROM [ActionType]" UpdateCommand="UPDATE [ActionType] SET [description] = @description WHERE [id] = @id">
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="description" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="description" Type="String" />
                <asp:Parameter Name="id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlActions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [Action] WHERE [id] = @id" InsertCommand="INSERT INTO [Action] ([description],  [ActionType], [CollegeId]) VALUES (@description, @ActionType, @CollegeID)" SelectCommand="SELECT * FROM [Action]" UpdateCommand="UPDATE [Action] SET [description] = @description, [ActionType] = @ActionType WHERE [id] = @id">
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="description" Type="String" />
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                <asp:Parameter Name="ActionType" Type="Int32" DefaultValue="0" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="description" Type="String" />
                <asp:Parameter Name="ActionType" Type="Int32" DefaultValue="0" />
                <asp:Parameter Name="id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlSemesters" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [Semesters] WHERE [id] = @id" InsertCommand="INSERT INTO [Semesters] ([Semester],  [SemesterName], [BeginningDate], [EndingDate], [LastAdded], [LastAddedBy], [CollegeId]) VALUES (@Semester, @SemesterName, @BeginningDate, @EndingDate, getdate(), @LastAddedBy, @CollegeID)" SelectCommand="SELECT * FROM [Semesters]" UpdateCommand="UPDATE [Semesters] SET [Semester] = @Semester, [SemesterName] = @SemesterName, [BeginningDate] = @BeginningDate, [EndingDate] = @EndingDate, [LastUpdated] = getdate(),[LastUpdatedBy] = @LastUpdatedBy WHERE [id] = @id">
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="Semester" Type="String" />
                <asp:Parameter Name="SemesterName" Type="String" />
                <asp:Parameter Name="BeginningDate" Type="DateTime" />
                <asp:Parameter Name="EndingDate" Type="DateTime" />
                <asp:SessionParameter Name="LastAddedBy" SessionField="UserID" Type="Int32" />
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="Semester" Type="String" />
                <asp:Parameter Name="SemesterName" Type="String" />
                <asp:Parameter Name="BeginningDate" Type="DateTime" />
                <asp:Parameter Name="EndingDate" Type="DateTime" />
                <asp:SessionParameter Name="LastUpdatedBy" SessionField="UserID" Type="Int32" />
                <asp:Parameter Name="id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlFeedback" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select fb.*, u.FirstName + ' ' + u.LastName as 'FullName', fbt.TypeDescription from Feedback fb left outer join TBLUSERS u on fb.CreatedBy = u.UserID left outer join FeedbackType fbt on fb.FeedType = fbt.FeedTypeId">
        </asp:SqlDataSource>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadTabStrip runat="server" ID="RadTabStrip1" AutoPostBack="True" MultiPageID="RadMultiPage1" SelectedIndex="0" ScrollChildren="True" Width="95%" Height="50px" ShowBaseLine="true">
            <Tabs>
                <telerik:RadTab Text="Action Types" Selected="True"></telerik:RadTab>
                <telerik:RadTab Text="Actions"></telerik:RadTab>
                <telerik:RadTab Text="Semesters"></telerik:RadTab>
                <telerik:RadTab Text="Feedback"></telerik:RadTab>
            </Tabs>
        </telerik:RadTabStrip>
        <telerik:RadMultiPage runat="server" ID="RadMultiPage1" SelectedIndex="0" Width="95%">
            <telerik:RadPageView runat="server" ID="rpvActionTypes" Width="100%">
                <telerik:RadGrid ID="rgActionTypes" runat="server" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" AllowSorting="True" AutoGenerateColumns="False"   AutoGenerateEditColumn="True" DataSourceID="sqlActionTypes" GroupPanelPosition="Top">
                    <MasterTableView CommandItemDisplay="Top" DataKeyNames="id" DataSourceID="sqlActionTypes">
                        <Columns>
                            <telerik:GridBoundColumn DataField="id" DataType="System.Int32" Display="False" FilterControlAltText="Filter id column" HeaderText="id" ReadOnly="True" SortExpression="id" UniqueName="id">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="description" FilterControlAltText="Filter description column" HeaderText="Description" SortExpression="description" UniqueName="description" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridButtonColumn CommandName="Delete" Text="Delete" ConfirmDialogType="RadWindow" ConfirmText="Are you sure want to delete this property ?" UniqueName="DeleteColumn" HeaderStyle-Width="30px" Display="false"></telerik:GridButtonColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </telerik:RadPageView>
            <telerik:RadPageView runat="server" ID="rpvActions" Width="100%">
                <telerik:RadGrid ID="rgActions" runat="server" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" AllowSorting="True" AutoGenerateColumns="False"   AutoGenerateEditColumn="True" DataSourceID="sqlActions" GroupPanelPosition="Top">
                    <MasterTableView CommandItemDisplay="Top" DataKeyNames="id" DataSourceID="sqlActions">
                        <Columns>
                            <telerik:GridBoundColumn DataField="ID" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" DataType="System.Int32" ReadOnly="True" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="description" FilterControlAltText="Filter description column" HeaderText="Description" SortExpression="description" UniqueName="description" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataField="ActionType" DataSourceID="sqlActionTypes" FilterControlAltText="Filter ActionType column" HeaderText="Action Type" UniqueName="ActionType" ListTextField="description" ListValueField="id" HeaderStyle-Font-Bold="true">
                            </telerik:GridDropDownColumn>
                            <telerik:GridButtonColumn CommandName="Delete" Text="Delete" ConfirmDialogType="RadWindow" ConfirmText="Are you sure want to delete this property ?" HeaderStyle-Width="30px" UniqueName="DeleteColumn" Display="false"></telerik:GridButtonColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </telerik:RadPageView>
            <telerik:RadPageView runat="server" ID="rpvSemesters" Width="100%">
                <telerik:RadGrid ID="rgSemesters" runat="server" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" AllowSorting="True" AutoGenerateColumns="False"   AutoGenerateEditColumn="True" DataSourceID="sqlSemesters" GroupPanelPosition="Top">
                    <MasterTableView CommandItemDisplay="Top" DataKeyNames="id" DataSourceID="sqlSemesters">
                        <Columns>
                            <telerik:GridBoundColumn DataField="ID" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" DataType="System.Int32" ReadOnly="True" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Semester" FilterControlAltText="Filter Semester column" HeaderText="Semester" SortExpression="Semester" UniqueName="Semester" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="SemesterName" FilterControlAltText="Filter SemesterName column" HeaderText="Semester Name" SortExpression="SemesterName" UniqueName="SemesterName" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="BeginningDate" DataType="System.DateTime" FilterControlAltText="Filter BeginningDate column" HeaderText="Beginning Date" SortExpression="BeginningDate" UniqueName="BeginningDate" DataFormatString="{0:MM/dd/yyyy}" EditDataFormatString="MM/dd/yyyy" PickerType="DatePicker" HeaderStyle-Font-Bold="true">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridDateTimeColumn DataField="EndingDate" DataType="System.DateTime" FilterControlAltText="Filter EndingDate column" HeaderText="Ending Date" SortExpression="EndingDate" UniqueName="EndingDate" DataFormatString="{0:MM/dd/yyyy}" EditDataFormatString="MM/dd/yyyy" PickerType="DatePicker" HeaderStyle-Font-Bold="true">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridButtonColumn CommandName="Delete" Text="Delete" ConfirmDialogType="RadWindow" ConfirmText="Are you sure want to delete this property ?" UniqueName="DeleteColumn" Display="false"></telerik:GridButtonColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </telerik:RadPageView>
            <telerik:RadPageView runat="server" Width="100%">
                <telerik:RadGrid ID="rgFeedback" runat="server" AllowSorting="True" AutoGenerateColumns="False"  DataSourceID="sqlFeedback" GroupPanelPosition="Top">
                    <MasterTableView CommandItemDisplay="None"  DataSourceID="sqlFeedback">
                        <Columns>
                            <telerik:GridBoundColumn DataField="TypeDescription" FilterControlAltText="Filter TypeDescription column" HeaderText="Feedback Type" SortExpression="TypeDescription" UniqueName="TypeDescription" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="FullName" FilterControlAltText="Filter FullName column" HeaderText="Submitted By" SortExpression="FullName" UniqueName="FullName" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridDateTimeColumn DataField="CreatedOn" DataType="System.DateTime" FilterControlAltText="Filter CreatedOn column" HeaderText="Submitted On" SortExpression="CreatedOn" UniqueName="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" EditDataFormatString="MM/dd/yyyy" PickerType="DatePicker" HeaderStyle-Font-Bold="true">
                            </telerik:GridDateTimeColumn>
                            <telerik:GridHTMLEditorColumn DataField="Detail" FilterControlAltText="Filter Detail column" HeaderText="Detail" SortExpression="Detail" UniqueName="Detail" HeaderStyle-Font-Bold="true">
                            </telerik:GridHTMLEditorColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </telerik:RadPageView>
        </telerik:RadMultiPage>
    </telerik:RadAjaxPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
