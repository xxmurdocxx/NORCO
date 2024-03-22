<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="ConfirmDownloadExhibit.aspx.cs" Inherits="ems_app.modules.popups.ConfirmDownloadExhibit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
    <div class="container" style="display: flex; justify-content: center; align-items: center; height: 100vh">
        <div id="showPassword" runat="server">
            <div style="width:490px; margin:0 auto;">
                <p style="text-align:left;">NOTICE: MAP users are responsible to understand and adhere to FERPA requirements and responsibilities concerning student privacy rights.</p>
                <p style="text-align:left;">This action downloads a copy of student CPL records to your computer. Note that MAP redacts the social security number and date of birth on JSTs only when the stored JST is a non-imaged (original) JST file. JSTs uploaded to an imaging service and then uploaded to MAP will not have redacted personal identifiable information and may not parse all credit recommendations correctly. It is recommended that only original pdf versions of the JST be uploaded to MAP.</p>
                <p>Furthermore, once a JST is accessed from MAP, it is recommended that the user:</p>
                <ul style="text-align:left;">
                    <li>Store downloaded JSTs (or other CPL documentation) in a secure folder;</li>
                    <li style="list-style-type:none;">And/Or</li>
                    <li>Delete downloaded JSTs (or other CPL documentation) after use.</li>
                </ul>
            </div>
            <label for="exampleInputPassword1" class="form-label d-flex justify-content-start">This document contains sensitive information, please re-enter your password : </label>
            <asp:TextBox ID="Password" ValidationGroup="checkPassword" CssClass="form-control" runat="server" TextMode="Password" placeholder="Password" BackColor="LightYellow"></asp:TextBox>
            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" CssClass="validators" ControlToValidate="Password" Text="*"></asp:RequiredFieldValidator>
            <br />
            <div style="width:100%; text-align:center;">
                <asp:Button ID="Login" OnClick="Login_Click" runat="server" CssClass="btn btn-default submit submit-login" Text="Submit" CausesValidation="true" ValidationGroup="checkPassword"></asp:Button>
            </div>
            <br />
            <br />
            <telerik:RadNotification ID="rnMessage" runat="server" Position="Center" Width="400px" Height="200px" ></telerik:RadNotification>
        </div>
        <telerik:RadLinkButton ID="rlbDownload" runat="server" CssClass="text-capitalize" Text="Thank you! Your user account has been authenticated. To download/view the file, please click here." Visible="false" OnClientClicking="closeDownloadWindow"></telerik:RadLinkButton>
    </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script>
        function closeDownloadWindow(sender, args) {
            //args.set_cancel(!window.confirm("To proceed please click OK button. This page will be closed shortly."));
            setTimeout(function () { var ww = window.open(window.location, '_self'); ww.close(); }, 5000);
        }

    </script>
</asp:Content>
