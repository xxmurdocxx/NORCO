<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="UserRequest.aspx.cs" Inherits="ems_app.modules.security.UserRequest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">User Requests</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [ROLES] ORDER BY [RoleName]"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlUserRequests" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="Select * from UserRequest where CollegeID = @CollegeID" UpdateCommand="UPDATE UserRequest SET [UserName] = @UserName, [RoleID] = @RoleID where [Id] = @Id">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="Id" Type="Int32" />
                <asp:Parameter Name="UserName" Type="String" />
                <asp:Parameter Name="RoleID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
    <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
        <p id="divMsgs" runat="server">
            <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
            </asp:Label>
            <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
            </asp:Label>
        </p>
    </telerik:RadToolTip>
    <telerik:RadGrid ID="rgUserRequest" runat="server" AllowPaging="True" AllowSorting="True" DataSourceID="sqlUserRequests" PageSize="10" AutoGenerateColumns="False" CellSpacing="-1" GridLines="None" AllowAutomaticUpdates="true" AllowFilteringByColumn="true" OnItemCommand="rgUserRequest_ItemCommand">
        <GroupingSettings CaseSensitive="false" />
        <ClientSettings AllowDragToGroup="false">
            <Selecting AllowRowSelect="true" EnableDragToSelectRows="false" />
        </ClientSettings>
        <MasterTableView DataSourceID="sqlUserRequests" DataKeyNames="Id" CommandItemDisplay="Top" EditMode="Batch">
            <BatchEditingSettings EditType="Cell" />
            <CommandItemSettings ShowAddNewRecordButton="False" />
            <Columns>
                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="40px">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" ToolTip="Approve User Request" CommandName="Approve" ID="btnApprove" Text='<i class="fa fa-check-circle" aria-hidden="true"></i>' />
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="FirstName" FilterControlAltText="Filter FirstName column" HeaderText="FirstName" ReadOnly="True" SortExpression="FirstName" UniqueName="FirstName" AutoPostBackOnFilter="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="LastName" FilterControlAltText="Filter LastName column" HeaderText="LastName" ReadOnly="True" SortExpression="LastName" UniqueName="LastName" AutoPostBackOnFilter="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Email" FilterControlAltText="Filter Email column" HeaderText="Email" ReadOnly="True" SortExpression="Email" UniqueName="Email" AutoPostBackOnFilter="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="RoleID" UniqueName="role_id" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="UserName" FilterControlAltText="Filter UserName column" HeaderText="UserName" SortExpression="UserName" UniqueName="UserName" AllowFiltering="false" ColumnValidationSettings-EnableRequiredFieldValidation="true" ColumnValidationSettings-RequiredFieldValidator-Enabled="true" ColumnValidationSettings-RequiredFieldValidator-Text="User name is required" >
                </telerik:GridBoundColumn>
                <telerik:GridDropDownColumn DataField="RoleID" DataSourceID="sqlRoles" HeaderText="Role" ListTextField="RoleName" ListValueField="RoleID" AllowFiltering="false"></telerik:GridDropDownColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
    </telerik:RadAjaxPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
