<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="ems_app.modules.popups.Quiz" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Quiz</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server"></telerik:RadWindowManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
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
                    <div class="col-sm-12 text-right">
                        <telerik:RadButton ID="rbSave" runat="server" Text="Save & Continue" OnClick="rbSave_Click"></telerik:RadButton>
                        <telerik:RadButton ID="rbFinish" runat="server" Text="Finish Quiz" OnClick="rbFinish_Click"></telerik:RadButton>
                    </div>
                    <div class="col-sm-12">
                        <h1 runat="server" id="quizTitle"></h1>
                        <h4 runat="server" id="WelcomeMessage"></h4>
                        <asp:Panel ID="pnlSurvey" runat="server">
                        </asp:Panel>
                        <h5 runat="server" id="ExitMessage"></h5>
                    </div>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script>
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
</body>
</html>

