<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DataUpdateChoice.ascx.cs" Inherits="ems_app.UserControls.DataUpdateChoice" %>
<asp:Panel runat="server" ID="pnlSuccess" CssClass="alert alert-success"><pre style="white-space:pre-wrap"><asp:Label ID="lblSuccessMessage" runat="server"></asp:Label></pre></asp:Panel>
<asp:Panel runat="server" ID="pnlError" CssClass="alert alert-danger"><pre style="white-space:pre-wrap"><asp:Label ID="lblErrorMessage" runat="server"></asp:Label></pre></asp:Panel>
<asp:Panel runat="server" ID="pnlWarning" CssClass="alert alert-warning"><pre style="white-space:pre-wrap"><asp:Label ID="lblWarningMessage" runat="server"></asp:Label></pre></asp:Panel>
<p><b>How would you like to update the data in this category?</b></p>
<div><asp:RadioButton runat="server" ID="radEdit" GroupName="radDataChoice" Text="Enter data on this page" AutoPostBack="true" OnCheckedChanged="radEdit_CheckedChanged" /></div>
<div><asp:RadioButton runat="server" ID="radUpload" GroupName="radDataChoice" Text="Upload a file with the data" AutoPostBack="true" OnCheckedChanged="radUpload_CheckedChanged" /></div>
<div style="display:none;"><asp:RadioButton runat="server" ID="radIntegration" GroupName="radDataChoice" Text="API integration between MAP and your curriculum system" AutoPostBack="true" OnCheckedChanged="radIntegration_CheckedChanged" /></div>
<asp:Panel runat="server" ID="pnlEdit" Visible="false" CssClass="mt-2 ms-2">
    <p><b>Please make changes directly in the grid to the left and click Save Changes when done and before switching pages.</b></p>
</asp:Panel>
<asp:Panel runat="server" ID="pnlUpload" Visible="false" CssClass="mt-2 ms-2">
    <asp:Panel runat="server" id="pnlDeleteAndReplaceWarning" Visible="false" CssClass="alert alert-warning">PLEASE NOTE: Existing data will be replaced with the uploaded data.</asp:Panel>
    <p><b>Download the sample file, structure your data according to the provided format, then select the file and click Upload File to upload the file into MAP.</b></p>
    <p>To utilize data shown in the grid (if applicable), click the Export to Excel button in the grid, then copy the data into the sample file and make changes.  Note that the uploaded file must match the sample file's format and file type (csv).</p>
    <p>Sample File: <asp:HyperLink runat="server" ID="lnkSampleFile"><i class="fa fa-download fa-2x" title="Click to download sample file"></i></asp:HyperLink></p>
    <div id="divUploadContainer">
        <div id="divAsyncUpload" class="float-start">
            <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="rauUploadFile" MultipleFileSelection="Disabled" AllowedFileExtensions="csv" ToolTip="Select the file to upload" AutoAddFileInputs="false" OnFileUploaded="rauUploadFile_FileUploaded">
                <FileFilters>
                    <telerik:FileFilter Description="CSV Files(csv)" Extensions="csv" />
                </FileFilters>
            </telerik:RadAsyncUpload>
        </div>
        <div id="divSubmitUpload" class="float-start mt-1 align-bottom">
            <asp:Button runat="server" ID="btnSubmitUpload" Text="Upload File" UseSubmitBehavior="true" CssClass="btn btn-primary" Enabled="false" />    
        </div>
    </div>
</asp:Panel>
<asp:Panel runat="server" id="pnlIntegration" Visible="false" CssClass="mt-2 ms-2">
    <p><b>To set up connectivity from MAP to your curriculum system, please submit a ticket through the MAP Portal here: </b><a href="http://help.mappingarticulatedpathways.org/support/home" target="_blank" class="link-primary">Support: Military Articulation Platform (MAP) Portal</a></p>
</asp:Panel>

<script type="text/javascript">
    function enableSubmitButton_<%=this.ClientID%>(sender, args, clientId) {
        document.getElementById(clientId).disabled = false;
    }
</script>