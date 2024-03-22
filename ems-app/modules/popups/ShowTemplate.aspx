<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowTemplate.aspx.cs" Inherits="ems_app.modules.popups.ShowTemplate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet"/>
</head>
<body style="background-color: #fff !important;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
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
                    <div class="col-md-12 col-sm-12 col-xs-12 text-right no-print">
                        <telerik:RadButton RenderMode="Lightweight" ID="rbEmail" runat="server" Text=" Send" OnClick="rbEmail_Click" Font-Names="Calibri" Font-Size="Small">
                            <Icon PrimaryIconCssClass="rbMail"></Icon>
                        </telerik:RadButton>
                        <a href="#" onclick="window.print();" class="RadButton RadButton_Office2010Silver rbButton rbRounded"><i class="fa fa-print" aria-hidden="true"></i> Print</a>
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12 text-right logo-image-print">
                        <asp:Image ID="Image1" runat="server" Width="170px" Height="100px" />
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12" id="templateContent" runat="server">
                    </div>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script>
        function OnClientClicked() {
            window.print();
        }
    </script>
</body>
</html>