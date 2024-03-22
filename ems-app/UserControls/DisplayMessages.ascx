<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DisplayMessages.ascx.cs" Inherits="ems_app.UserControls.DisplayMessages" %>
<telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
    <p id="divMsgs" runat="server">
        <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
        </asp:Label>
        <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
        </asp:Label>
    </p>
</telerik:RadToolTip>
