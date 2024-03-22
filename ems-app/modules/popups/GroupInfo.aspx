<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GroupInfo.aspx.cs" Inherits="ems_app.modules.popups.GroupInfo" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Group Information</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false"></telerik:RadWindowManager>
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
                    <div class="col-md-6">
                        <asp:HiddenField ID="hfProgramCourseID" runat="server" />
                    </div>
                    <div class="col-md-6 text-right">
                        <telerik:RadButton RenderMode="Lightweight" ID="rbSave" runat="server" Text=" Save" OnClick="rbSave_Click">
                            <Icon PrimaryIconCssClass="rbSave"></Icon>
                        </telerik:RadButton>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        Group Heading : 
                    </div>
                    <div class="col-md-8">
                        <telerik:RadTextBox ID="rtbHeading" runat="server" MaxLength="150"></telerik:RadTextBox>
                    </div>
                    <div class="col-md-4">
                        Min. Units : 
                    </div>
                    <div class="col-md-8">
                        <telerik:RadNumericTextBox ID="rntbMinUnits" NumberFormat-DecimalDigits="0" runat="server" MinValue="0" Value="0"></telerik:RadNumericTextBox>
                    </div>
                    <div class="col-md-4">
                        Max. Units : 
                    </div>
                    <div class="col-md-8">
                        <telerik:RadNumericTextBox ID="rntbMaxUnits" NumberFormat-DecimalDigits="0" runat="server" MinValue="0" Value="0"></telerik:RadNumericTextBox>
                    </div>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>

    </form>
</body>
</html>

