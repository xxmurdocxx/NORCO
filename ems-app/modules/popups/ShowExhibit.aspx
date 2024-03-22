<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowExhibit.aspx.cs" Inherits="ems_app.modules.popups.ShowExhibit" ValidateRequest="false" %>

<%@ Register Src="~/UserControls/ExhibitInformation.ascx" TagPrefix="uc" TagName="OccupationInformation"  %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Exhibit Information</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
    <style>
        hr { border : none !important; display:none !important; }
        hr:first-child, h2:first-child {
          display: none !important;
        }
    </style>
</head>
<body style="background-color: #fff;">
    <div style="padding: 15px !important;">
        <form id="form1" runat="server">
            <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
            <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
                <div class="row context">
                    <uc:OccupationInformation ID="OccupationInformationControl" runat="server"></uc:OccupationInformation>
                </div>

            </telerik:RadAjaxPanel>
            <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
        </form>
    </div>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mark.js/8.11.1/jquery.mark.es6.js"></script>
    <script>
        $(document).ready(function () {
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            const criteria = urlParams.get('AdvancedSearch')
            var criteriaArray = criteria.split(',');
            $("div.context").mark(criteriaArray, {
                "separateWordSearch": false,
                "ignoreJoiners": true,
                "acrossElements": true
            });
        });


    </script>
</body>
</html>


