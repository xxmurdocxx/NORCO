<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="ems_app.modules.security.ChangePassword" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Change Pasword</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous" />
    <!-- Font Awesome -->
    <script src="https://use.fontawesome.com/6c4529ef90.js"></script>
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
    <style>
    </style>
</head>
<body class="login d-flex justify-content-center align-items-center" style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <asp:HiddenField ID="hfUserID" runat="server" />
            <asp:HiddenField ID="hfCryptPwd" runat="server" />
            <div class="row" style="padding: 20px;">
                <div class="d-flex flex-column">
                    <div class="logo d-flex justify-content-center">
                        <img src="../../Common/images/logo.png" title="MAP articulates college courses with ACE military credit recommendations and allows colleges to reach out to regional veterans, offering up to one year of credit in programs leading to high wage jobs and transfer." width="250" />
                    </div>
                    <div class="map">
                        <div class="login-app-site-description" style="display: none;">
                            MAP articulates college courses with ACE military credit recommendations and allows colleges to reach out to regional veterans, offering up to one year of credit in programs leading to high wage jobs and transfer.
                        </div>

                    </div>
                    <div class="login_wrapper text-center">
                        <div class="panel-heading d-flex justify-content-center mb-4">
                        </div>
                        <div class="panel-body change-password d-flex justify-content-center">
                            <asp:ChangePassword ID="ChangePassword1" runat="server" CssClass="m-3" TextBoxStyle-CssClass="form-control" CancelButtonStyle-CssClass="btn btn-secondary m-buttons" ChangePasswordButtonStyle-CssClass="btn btn-primary m-buttons" TitleTextStyle-ForeColor="#ffffff" ChangePasswordTitleText="" OnCancelButtonClick="ChangePassword1_CancelButtonClick" OnChangingPassword="ChangePassword1_ChangingPassword"
                                RenderOuterTable="true" NewPasswordRegularExpression="(?=^.{8,25}$)(?=(?:.*?\d){1})(?=.*[a-z])(?=(?:.*?[A-Z]){1})(?=(?:.*?[!@#$%*()_+^&}{:;?.]){1})(?!.*\s)[0-9a-zA-Z!@#$%*()_+^&]*$" NewPasswordRegularExpressionErrorMessage="Password error, please follow password hint instructions" CancelDestinationPageUrl="~/modules/dashboard/Default.aspx">
                            </asp:ChangePassword>
                            <ul class="d-block alert alert-warning h-25 m-2 list-unstyled">
                                <li>Password hints : </li>
                                <li>At least 1 special characters.</li>
                                <li>At least 1 digit</li>
                                <li>At least 1 upper case character</li>
                            </ul>
                            <asp:Label ID="lblMessage" runat="server" />

                        </div>
                        <div class="row login-footer">
                            <div class="col-12 text-center">
                                <img src="../../Common/images/Firefox-logo.png" alt="Firefox" style="width: 32px; height: 30px; display: none;" />
                                <p>Mozilla Firefox recommended browser.</p>
                            </div>
                            <div class="col-12 text-center">
                                <h3 style="display: none;">
                                    <asp:Label ID="lblBussinesName" runat="server" Text=""></asp:Label></h3>
                                <p>© 2017-2024 California MAP Initiative. All Rights Reserved.</p>
                                <p>The California MAP Initiative is funded by a legislative grant sponsored by <a href="https://a60.asmdc.org/" style="font-weight: bold; text-decoration: underline;" target="_blank">Assembly member Sabrina Cervantes</a> (60th Assembly District) and the <a href="https://latinocaucus.legislature.ca.gov/" style="font-weight: bold; text-decoration: underline;" target="_blank">California Latino Legislative Caucus.</a></p>
                                <%--<p class="text-center"><a href="#">FERPA Compliance</a></p>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="2000" Width="350" Height="110" Title="Notification" EnableRoundedCorners="false">
            </telerik:RadNotification>
            <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server">
            </telerik:RadWindowManager>
            <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager2" runat="server">
            </telerik:RadWindowManager>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <!-- jQuery -->
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <!-- Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj" crossorigin="anonymous"></script>
    <!-- Custom Theme Scripts -->
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
    <script>

</script>
</body>
</html>

