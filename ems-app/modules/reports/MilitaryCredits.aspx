<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MilitaryCredits.aspx.cs" Inherits="ems_app.modules.reports.MilitaryCredits" %>
<%@ Register TagPrefix="telerik" Assembly="Telerik.ReportViewer.Html5.WebForms" Namespace="Telerik.ReportViewer.Html5.WebForms" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CPL Summary Report </title>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>

	<style>
		#reportViewer1 {
			position: absolute;
			left: 5px;
			right: 5px;
			top: 5px;
			bottom: 5px;
			overflow: auto;
			font-family: Verdana, Arial;
		}
	</style>

</head>
<body>
    <form runat="server">
        <label id="msg" runat="server"></label>
        <telerik:ReportViewer
            ID="reportViewer1" 
			Width="99%"
			Height="98%"
			EnableAccessibility="false"
            runat="server">
            <ReportSource IdentifierType="UriReportSource" Identifier="MilitaryCredits.trdp">
            </ReportSource>
        </telerik:ReportViewer>
    </form>
    <script>

    </script>
</body>
</html>
