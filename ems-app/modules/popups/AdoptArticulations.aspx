<%@ Page Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="AdoptArticulations.aspx.cs" Inherits="ems_app.modules.popups.AdoptArticulatons" %>

<%@ Register Src="../../UserControls/AdoptArticulations.ascx" TagName="AdoptArticulations" TagPrefix="uc1" %>
<%@ Register Src="~/UserControls/AdoptCreditRecommendation.ascx" TagPrefix="uc1" TagName="AdoptCreditRecommendation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" id="SystemTitle" runat="server">Adopt Articulations</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart">
        <telerik:RadWindowManager ID="RadWindowManager1" EnableViewState="false" runat="server" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>

        <div class="row" style="padding: 10px;">
            <%--<div class="col-md-6 col-sm-6 col-xs-6">
                    <h2>Adopt Articulations</h2>
                </div>
                <div class="col-md-6 col-sm-6 col-xs-6 text-right" style="padding-right: 10px;">
                </div>--%>
            <div class="col-md-12 col-sm-12 col-xs-12">

                <uc1:AdoptArticulations ID="AdoptArticulationsViewer" runat="server" />
                <uc1:AdoptCreditRecommendation runat="server" ID="AdoptCreditRecommendationViewer" />
            </div>
        </div>

    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }
    </script>
</asp:Content>

