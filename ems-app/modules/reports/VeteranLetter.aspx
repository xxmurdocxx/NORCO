<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VeteranLetter.aspx.cs" Inherits="ems_app.modules.reports.VeteranLetter" %>

<%@ Register TagPrefix="telerik" Assembly="Telerik.ReportViewer.Html5.WebForms" Namespace="Telerik.ReportViewer.Html5.WebForms" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Veteran Letter</title>
	<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>

	<style>
		#reportViewer1 {
			position: absolute;
			left: 5px;
			right: 5px;
			top: 5px;
			bottom: 5px;
			overflow: hidden;
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
            <ReportSource IdentifierType="UriReportSource" Identifier="SampleReport.trdp">
            </ReportSource>
        </telerik:ReportViewer>
    </form>
</body>
</html>