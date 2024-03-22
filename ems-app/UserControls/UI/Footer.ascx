<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Footer.ascx.cs" Inherits="ems_app.UserControls.UI.Footer" %>
<%@ Register src="CompanyName.ascx" tagname="CompanyName" tagprefix="uc1" %>
<div>
    <i class="fa fa-tags"></i>
    <asp:Label ID="lblAppName" runat="server" Text=""></asp:Label>
</div>
<div>
    <uc1:CompanyName ID="CompanyName1" runat="server" />
    <asp:Label ID="lblBussinesName" runat="server" Text="" Visible="false"></asp:Label>
</div>
