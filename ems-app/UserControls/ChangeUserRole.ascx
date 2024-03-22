<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ChangeUserRole.ascx.cs" Inherits="ems_app.UserControls.ChangeUserRole" %>
<asp:SqlDataSource ID="sqlUserAvailableRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="spROLES_USER_GetAvailableRolesByUserID">
    <SelectParameters>
        <asp:Parameter Name="UserID" Type="Int32" />
        <asp:Parameter Name="RoleID" Type="Int32" />
        <asp:Parameter Name="ApplicationID" Type="Int32" />
        <asp:Parameter Name="CollegeID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<telerik:RadComboBox ID="rcbRoles" Text="" runat="server" DataSourceID="sqlUserAvailableRoles" DataTextField="RoleName" DataValueField="RoleID" AutoPostBack="true"  Width="150px" AppendDataBoundItems="true"  Filter="Contains" RenderMode="Lightweight" ToolTip="Please select the Role you would like to use as Default" DropDownAutoWidth="Enabled"  OnSelectedIndexChanged="rcbRoles_SelectedIndexChanged" Font-Bold="true" EmptyMessage="Select a role">
</telerik:RadComboBox>