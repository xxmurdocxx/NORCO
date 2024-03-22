<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TopNavBar.ascx.cs" Inherits="ems_app.UserControls.UI.TopNavBar" %>
<%@ Register Src="~/UserControls/ChangeUserRole.ascx" TagPrefix="uc1" TagName="ChangeUserRole" %>
<style>
    .role-dropdown .p-icon:before, .role-dropdown .rcbInput, .role-dropdown .rcbEmptyMessage {
        color:#ffffff !important; 
    }
</style>
<div class="navbar" id="navbarNavDropdown">
    <ul class="navbar-nav">
        <li class="nav-item">
            <asp:HyperLink ID="hlkTickets" runat="server" ToolTip="Tickets" Visible="false">
                <asp:Literal ID="litTestEnvironmentDescription" runat="server" Text=""></asp:Literal>
            </asp:HyperLink>
        </li>         
    </ul>
</div>
<div class="d-flex justify-content-space-between">
    <asp:HiddenField ID="hfUsername" runat="server" />
    <asp:HiddenField ID="hfApplicationID" runat="server" />
    <asp:Panel ID="pnlAvailableRoles" runat="server">
        <asp:SqlDataSource ID="sqlUserAvailableRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="spROLES_USER_GetAvailableRolesByUserID">
            <SelectParameters>
                <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
                <asp:SessionParameter Name="RoleID" SessionField="RoleID" Type="Int32" />
                <asp:ControlParameter Name="ApplicationID" ControlID="hfApplicationID" PropertyName="Value" Type="Int32" />
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadComboBox ID="rcbRoles" Text="" runat="server" DataSourceID="sqlUserAvailableRoles" DataTextField="RoleName" DataValueField="RoleID" AutoPostBack="true" Width="170px" Filter="Contains" RenderMode="Lightweight" ToolTip="Please select the Role you would like to use as Default" DropDownAutoWidth="Enabled" OnSelectedIndexChanged="rcbRoles_SelectedIndexChanged" BorderStyle="None" EmptyMessage="Select a role" CssClass="role-dropdown">
        </telerik:RadComboBox>
    </asp:Panel>
    <div class="dropdown text-end" style="padding-right: 10px; padding-left:10px;">
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill badge-danger" title="You have New Potential users. Click here to view." id="PotentialBlurb" runat="server">
            <a href="/modules/military/StudentList.aspx" style="color:white;" id="PotentialBlurbText" runat="server">99+</a> 
            <span class="visually-hidden">unread messages</span>
            </span>
        <a href="#" class="d-block link-light text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
            <asp:Image ID="Image1" runat="server" ImageUrl="~/Common/images/img.jpg" AlternateText="UserName" class="rounded-circle" Width="32px" Height="32px" />
        </a>
        <ul class="dropdown-menu text-small" aria-labelledby="dropdownUser1" style="">
            <li><a class="dropdown-item" href="../../modules/security/Profile.aspx">Profile</a></li>
            <asp:Literal ID="litSuperUserMenuItem" runat="server" Visible="false"></asp:Literal>
            <li>
                <asp:LinkButton ID="linkMenuLogout" CssClass="dropdown-item" runat="server" OnClick="linkTopLogout_Click">Log out</asp:LinkButton>
            </li>
        </ul>
    </div>
    <asp:Label ID="lblUserName" runat="server" CssClass="roleName" Text=""></asp:Label>
    <asp:Label Visible="false" ID="lblRoleName" CssClass="roleName white-icon" runat="server" Text=""></asp:Label>
</div>



