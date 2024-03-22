<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="UpdateCid.aspx.cs" Inherits="ems_app.modules.settings.UpdateCid" %>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <p>This page will update the master C-ID list and the C-ID properties for all courses in MAP.</p>
    <p>Start by downloading the C-ID list from c-id.net.  Clean up the .csv file in Excel by replacing double quotes (") with two double quotes(""), and renaming colleges to exactly match the college name in MAP.  Make sure the file is saved with encoding UTF-8.  Then upload the file and wait for it to process.  Any colleges or courses that were not matched will be displayed after it runs.</p>
    <asp:Panel runat="server" ID="pnlSuccess" CssClass="alert alert-success"><pre style="white-space:pre-wrap"><asp:Label ID="lblSuccessMessage" runat="server"></asp:Label></pre></asp:Panel>
    <asp:Panel runat="server" ID="pnlError" CssClass="alert alert-danger"><pre style="white-space:pre-wrap"><asp:Label ID="lblErrorMessage" runat="server"></asp:Label></pre></asp:Panel>
    <asp:Panel runat="server" ID="pnlWarning" CssClass="alert alert-warning"><pre style="white-space:pre-wrap"><asp:Label ID="lblWarningMessage" runat="server"></asp:Label></pre></asp:Panel>
    <div id="divAsyncUpload" class="float-start">
        <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="rauUploadFile" MultipleFileSelection="Disabled" AllowedFileExtensions="csv" ToolTip="Select the file to upload" AutoAddFileInputs="false" OnFileUploaded="rauUploadFile_FileUploaded">
            <FileFilters>
                <telerik:FileFilter Description="CSV Files(csv)" Extensions="csv" />
            </FileFilters>
        </telerik:RadAsyncUpload>
    </div>
    <div id="divSubmitUpload" class="float-start mt-1 align-bottom">
        <asp:Button runat="server" ID="btnSubmitUpload" Text="Upload File" UseSubmitBehavior="true" CssClass="btn btn-primary" Enabled="true" />    
    </div>
    <div class="clearfix"></div>
    <div><asp:CheckBox runat="server" ID="chkUpdateMasterCidList" /> Update Master CID List (if checked, master cid table will be reloaded from spreadsheet.  Uncheck if this has already been done for current spreadsheet)</div>
</asp:Content>