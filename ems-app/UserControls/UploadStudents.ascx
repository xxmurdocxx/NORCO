<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UploadStudents.ascx.cs" Inherits="ems_app.UserControls.UploadStudents" %>
<style>
    .alert {
    margin-top: 5px !important;
    }
    .buttons .btn {
        line-height: 1.42857143em !important;
        font-weight: 500 !important;
        border-color: #CFD8DC;
        color: #FFF;
        background-color: #203864 !important;
        transition: all .2s ease-in-out;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.2);
    }
    html .RadUpload_Material .ruSelectWrap .ruBrowse {
        margin:0px !important;
        padding: 8px 66px !important;
        display: flex;            /* User Story 707: Center the text on the "button". */
        justify-content: center;  /* User Story 707: Center the text on the "button". */
    }
</style>
<asp:Panel runat="server" ID="pnlSuccess" CssClass="alert alert-success"><pre style="white-space:pre-wrap"><asp:Label ID="lblSuccessMessage" runat="server"></asp:Label></pre></asp:Panel>
<asp:Panel runat="server" ID="pnlError" CssClass="alert alert-danger"><pre style="white-space:pre-wrap"><asp:Label ID="lblErrorMessage" runat="server"></asp:Label></pre></asp:Panel>
<asp:Panel runat="server" ID="pnlWarning" CssClass="alert alert-warning"><pre style="white-space:pre-wrap"><asp:Label ID="lblWarningMessage" runat="server"></asp:Label></pre></asp:Panel>
<asp:Panel runat="server" ID="pnlEdit" Visible="false" CssClass="mt-2 ms-2">
    <p><b>Please make changes directly in the grid to the left and click Save Changes when done and before switching pages.</b></p>
</asp:Panel>
<asp:Panel runat="server" ID="pnlUpload"  CssClass="mt-2 ms-2">
    <asp:Panel runat="server" id="pnlDeleteAndReplaceWarning" Visible="false" CssClass="alert alert-warning">PLEASE NOTE: Existing data will be replaced with the uploaded data.</asp:Panel>
    <p><b>Download the sample file, structure your data according to the provided format, then select the file and click Upload File to upload the file into MAP.</b></p>
    <p>Note that the uploaded file must match the sample file's format and file type (csv).</p>
    <p>Sample File: <asp:HyperLink runat="server" ID="lnkSampleFile"><i class="fa fa-download" style="color:black !important;" title=" Click to download sample file"></i></asp:HyperLink></p>
    <div id="divUploadContainer" style="display:flex;">
        <div id="divAsyncUpload" class="float-start">
            <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="rauUploadFile" MultipleFileSelection="Disabled" AllowedFileExtensions="csv" ToolTip="Select the file to upload" AutoAddFileInputs="false" OnFileUploaded="rauUploadFile_FileUploaded"   OnClientFileUploaded="OnClientFileUploadedBatchUpload">
                <Localization Select="Select File" />
                <FileFilters>
                    <telerik:FileFilter Description="CSV Files(csv)" Extensions="csv" />
                </FileFilters>
            </telerik:RadAsyncUpload>
        </div>
        <div id="divSubmitUpload" class="float-start align-bottom buttons btn" style="padding:2px;">
            <asp:Button runat="server" ID="btnSubmitUpload" Text=" UPLOAD FILE" OnClick="btnSubmitUpload_Click" ClientIDMode="Static" CssClass="btnHiden" Height="36px" />    
        </div>
    </div>
</asp:Panel>


<script type="text/javascript">
    function enableSubmitButton_<%=this.ClientID%>(sender, args, clientId) {
        document.getElementById(clientId).disabled = false;
    }
    function OnClientFileUploadedBatchUpload(sender, args) {
        $('#btnSubmitUpload').trigger('click');
    }
</script>