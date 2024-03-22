<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OtherCollegesArticulations.aspx.cs" Inherits="ems_app.modules.popups.OtherCollegesArticulations" %>
<%@ Register src="../../UserControls/AdoptArticulations.ascx" tagname="AdoptArticulations" tagprefix="uc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Other Colleges Articulations</title>
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
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div class="row" style="padding: 15px !important;">
                <div class="col-sm-6 col-md-6">                    
                    <h2 id="pageTitle" runat="server"></h2>
                </div>
                <div class="col-sm-6 col-md-6 text-right">
                    <asp:Label ID="lblExists" runat="server" CssClass="alert alert-danger"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Articulation exists in other colleges, review highlighted rows.</asp:Label>
                </div>
                <div class="col-sm-12 col-md-12">
                    <uc1:AdoptArticulations ID="AdoptArticulationsViewer" runat="server" />
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script type="text/javascript">
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
    </script>
</body>
</html>
