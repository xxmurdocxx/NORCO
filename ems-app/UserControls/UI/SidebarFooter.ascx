<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SidebarFooter.ascx.cs" Inherits="ems_app.UserControls.UI.SidebarFooter" %>
<%@ Register Src="CompanyName.ascx" TagName="CompanyName" TagPrefix="uc1" %>
<div class="sidebar-footer hidden-small d-flex justify-content-space-between">
    <%--<a data-toggle="tooltip" data-placement="top" title="Settings" href="../../modules/security/Profile.aspx">
        <i class='fa fa-cog' aria-hidden='true'></i>
    </a>--%>
    <%-- <a data-toggle="tooltip" data-placement="top" title="Help"  href="../../modules/tutorial/Help.aspx" target="_blank">
                                <i class='fa fa-question' aria-hidden='true'></i>
                            </a>--%>
    <a data-toggle="tooltip" data-placement="top" title="Feedback" onclick="ShowFeedback();return false;">
        <i class='fa fa-pencil-square-o' aria-hidden='true'></i>
    </a>
    <asp:LinkButton ID="linkTopLogout" runat="server" OnClick="linkTopLogout_Click">Logout</asp:LinkButton>
        <uc1:CompanyName ID="CompanyName1" runat="server" />
</div>