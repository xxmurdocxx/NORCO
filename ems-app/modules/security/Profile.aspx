<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="ems_app.modules.security.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/intro.js/4.3.0/introjs.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Profile</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .btn {
            display:inline-block !important;
            margin-right:2px !important;
            border:none !important;
        }
        .btn-primary {
            background-color:#011454 !important;
        }
    </style>
    <asp:SqlDataSource ID="sqlRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [ROLES] ORDER BY [RoleName]"></asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <div class="row">
            <div class="col-md-6">
                <div class="panel-heading">
                    <h3 class="panel-title">User Information</h3>
                </div>
                <div class="panel-body">
                    <asp:Panel ID="pnlUser" runat="server" DefaultButton="rbUpdate">
                        <asp:HiddenField ID="hfUserID" runat="server" />
                        <asp:HiddenField ID="hfCryptPwd" runat="server" />
                        <asp:HiddenField ID="hfOnBoarding" runat="server" />
                        <div class="form-group">
                            <label style="font-weight: bold;">Role </label>
                            <telerik:RadComboBox ID="rcbRoles" runat="server" Width="100%" Culture="es-ES" DataSourceID="sqlRoles" DataTextField="RoleName" DataValueField="RoleID" Enabled="false"></telerik:RadComboBox>
                        </div>
                        <div id="firstname_anchor" class="form-group">
                            <label style="font-weight: bold">First Name </label>
                            <telerik:RadTextBox ID="rtFirstName" runat="server" Width="100%"></telerik:RadTextBox>
                        </div>
                        <div id="lastname_anchor" class="form-group">
                            <label style="font-weight: bold">Last Name </label>
                            <telerik:RadTextBox ID="rtLastName" runat="server" Width="100%"></telerik:RadTextBox>
                        </div>
                        <div id="email_anchor" class="form-group">
                            <label style="font-weight: bold">Email </label>
                            <telerik:RadTextBox ID="rtbEmail" InputType="Email" runat="server" Width="100%"></telerik:RadTextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="rtbEmail" ErrorMessage="* Required Field" ValidationGroup="UserData" CssClass="alert alert-danger" />
                        </div>
                        <div class="form-group">
                            <label style="font-weight: bold">User Name </label>
                            <telerik:RadTextBox ID="rtUserName" runat="server" Width="100%" Enabled="false"></telerik:RadTextBox>
                            <asp:RequiredFieldValidator ID="rfvUserName" runat="server" ControlToValidate="rtUserName" ErrorMessage="* Required Field" ValidationGroup="UserData" CssClass="alert alert-danger" />
                        </div>
                        <div id="notification_anchor" class="form-group">
                            <telerik:RadCheckBox ID="rchkAutomaticNotification" AutoPostBack="false" runat="server" CausesValidation="false" Text=" Allow Email Notifications" ToolTip="When this option is checked, MAP will automatically notify workflow members via emai about the course a"></telerik:RadCheckBox>
                        </div>
                        <div class="form-group">
                            <telerik:RadCheckBox ID="rchkWelcome" AutoPostBack="false" runat="server" CausesValidation="false" Text=" Show Self Guided Training tool" ToolTip="When this option is checked, MAP will automatically show Self Guided Training tool"></telerik:RadCheckBox>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblUserMessage" runat="server" />
                        </div>
                        <div id="update_anchor" class="row text-center">
                            <telerik:RadButton ID="rbUpdate" OnClick="rbUpdate_Click" CssClass="btn btn-default" runat="server" Text="Update"></telerik:RadButton>
                        </div>
                    </asp:Panel>
                </div>
            </div>
            <div class="col-md-6">
                <div class="panel-heading">
                    <h3 class="panel-title">Change Password</h3>
                </div>
                <div class="panel-body change-password">
                    <asp:ChangePassword ID="ChangePassword1" runat="server" TextBoxStyle-CssClass="form-control" CancelButtonStyle-CssClass="btn btn-secondary m-buttons" ChangePasswordButtonStyle-CssClass="btn btn-primary m-buttons" TitleTextStyle-ForeColor="#ffffff" ChangePasswordTitleText="" OnChangingPassword="ChangePassword1_ChangingPassword" 
                        RenderOuterTable="false" NewPasswordRegularExpression="(?=^.{12,25}$)(?=(?:.*?\d){1})(?=.*[a-z])(?=(?:.*?[A-Z]){1})(?=(?:.*?[!@#$%*()_+^&}{:;?.]){1})(?!.*\s)[0-9a-zA-Z!@#$%*()_+^&]*$" NewPasswordRegularExpressionErrorMessage="Invalid password." CancelDestinationPageUrl="~/modules/dashboard/Default.aspx" >
                    </asp:ChangePassword>
                    <ul class="d-block alert alert-warning h-25 m-2 list-unstyled" style="font-size:9px;">
                        <li>Password hints : </li>
                        <li>Must have at least 12 characters and a maximum of 25 characters</li>
                        <li>At least 1 special characters.</li>
                        <li>At least 1 digit</li>
                        <li>At least 1 upper case character</li>
                    </ul>
                    <asp:Label ID="lblMessage" runat="server" />

                </div>
            </div>
        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/intro.js/4.3.0/intro.min.js" type="text/javascript"></script>
    <script src="../../Common/js/onboarding/Profile.js" type="text/javascript"></script>
    <script type="text/javascript">
        let onBoarding = document.getElementById('<%= hfOnBoarding.ClientID %>').value
        if (onBoarding == "True") {
            ShowOnboarding();
        }
    </script>
</asp:Content>
