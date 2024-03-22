<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Welcome.aspx.cs" Inherits="ems_app.modules.popups.Welcome" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Welcome to MAP !</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <!-- Bootstrap -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/js/bootstrap.min.js") %>"></script>
    <!-- Custom Theme Scripts -->
    <script src="<%= this.ResolveUrl("~/Common/build/js/custom.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
</head>
<script type="text/javascript">
    function GetRadWindow() {
        var oWindow = null;
        if (window.radWindow)
            oWindow = window.radWindow;
        else if (window.frameElement && window.frameElement.radWindow)
            oWindow = window.frameElement.radWindow;
        return oWindow;
    }
    function CloseModal() {
        var oWnd = GetRadWindow();
        if (oWnd) oWnd.close();
        top.location.href = top.location.href;
    }
</script>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" Modal="false"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="280px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div style="padding: 15px !important;">
                <div class="row">
                    <h2>Hello, <asp:Label ID="lblUserFirstName" runat="server"></asp:Label>! </h2>
                </div>
                <div class="row">
                    <p></p>
                    <p>Welcome to the MAP Self-Guided Training Tool!</p>
                    <p>We created this self-guided training tool to help new and experienced users learn specific functions in MAP related to their roles. This can easily be accessed inside the Help link on the upper-right corner of the website.</p>
                    <p>We hope that this guide will further ensure a pleasant user experience for everyone.</p>
                </div>
                <div class="row text-center" style="margin-top:20px">
                    <telerik:RadButton ID="rbShowMe" runat="server" ButtonType="LinkButton" Text="Show me around" Primary="true" NavigateUrl="Onboarding.aspx" ></telerik:RadButton>
                </div>
                <div class="row text-center" style="margin-top:20px">
                    <telerik:RadButton ID="rbSkip" runat="server" Text="Skip for now" OnClick="rbSkip_Click"></telerik:RadButton>
                </div>
                <div class="row text-center" style="margin-top:20px">
                    <telerik:RadButton ID="rbDontShow" runat="server" Text="Don't show again" OnClick="rbDontShow_Click"></telerik:RadButton>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>

</body>
</html>
