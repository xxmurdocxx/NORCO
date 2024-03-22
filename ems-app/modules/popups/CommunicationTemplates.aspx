<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CommunicationTemplates.aspx.cs" Inherits="ems_app.modules.popups.CommunicationTemplates" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Communication Template</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
    <style>
        .reToolBarWrapper {
            height: 30px !important;
            display: block !important;
        }
        .report-expressions {
            overflow-y:auto !important;
        }
    </style>
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
            <div class="row" style="margin: 20px 0 10px 0;">
                <div class="col-md-3">
                    <telerik:RadTreeView RenderMode="Lightweight" ID="RadTreeView1" runat="server" Height="450px" EnableDragAndDrop="True" Width="100%" OnClientNodeDragStart="TelerikDemo.OnClientNodeDragStart" OnClientNodeDragging="TelerikDemo.OnClientNodeDragging" OnClientNodeDropping="TelerikDemo.OnClientNodeDropping" OnClientLoad="TelerikDemo.RadTreeView_OnClientLoad" CssClass="report-expressions">
                    </telerik:RadTreeView>
                <asp:Label ID="lblResult" Visible="false" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                </div>
                <div class="col-md-9">
                    <div class="row">
                        <div class="col-md-9">
                            <h2 runat="server" id="pageTitle">Veteran Letter</h2>
                        </div>
                        <div class="col-md-3">
                            <telerik:RadButton RenderMode="Lightweight" ID="rbUpdateVeteranLetter" runat="server" Text="Update" OnClick="rbUpdateVeteranLetter_Click">
                                <Icon PrimaryIconCssClass="rbSave"></Icon>
                            </telerik:RadButton>
                        </div>
                    </div>
                    <asp:HiddenField runat="server" ID="hfTemplateType" />
                    <asp:HiddenField runat="server" ID="hfTemplateID" />
                    <telerik:RadEditor RenderMode="Lightweight" Width="100%" Height="500" ID="RadEditor1" runat="server" EmptyMessage="" OnClientLoad="TelerikDemo.RadEditor_OnClientLoad" ToolbarMode="Default" EnableAjaxSkinRendering="true" EnableResize="false">
                        <Tools>
                            <telerik:EditorToolGroup>
                                <telerik:EditorTool Name="FontSize" />
                                <telerik:EditorTool Name="Bold" />
                                <telerik:EditorTool Name="Italic" />
                                <telerik:EditorTool Name="ForeColor" />
                                <telerik:EditorTool Name="Underline" />
                                <telerik:EditorTool Name="JustifyCenter" />
                                <telerik:EditorTool Name="JustifyLeft" />
                                <telerik:EditorTool Name="JustifyRight" />
                                <telerik:EditorTool Name="JustifyFull" />
                                <telerik:EditorTool Name="JustifyNone" />
                                <telerik:EditorTool Name="Cut" />
                                <telerik:EditorTool Name="Copy" />
                                <telerik:EditorTool Name="Paste" />
                            </telerik:EditorToolGroup>
                        </Tools>
                    </telerik:RadEditor>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/ReportBuilder.js") %>"></script>
</body>
</html>
