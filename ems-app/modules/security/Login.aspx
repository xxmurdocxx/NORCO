<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ems_app.modules.users.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title></title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous">
    <!-- Font Awesome -->
    <%--<link href="/Common/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">--%>

    <!-- Font Awesome 6.2.1 -->
    <link href="/Common/vendors/fontawesome/css/all.css" rel="stylesheet">
    <!-- update existing v4 CSS to use v6 icons and assets -->
    <link href="/Common/vendors/fontawesome/css/v4-shims.css" rel="stylesheet">

    <!-- Custom Theme Style -->
    <link href="/Common/build/css/custom.css" rel="stylesheet">
    <style type="text/css">
        .login-failure {
            color: red;
            font-weight: bold;
        }

        .validators {
            margin: 0px;
            padding: 0px;
            float: right;
            color: #ff0000;
        }

        .RadPanelBar_Material, .RadPanelBar .rpLast .rpRootLink, .RadPanelBar .rpLast .rpHeaderTemplate {
            background-color: transparent !important;
            border: none !important;
            color: #244d95 !important;
        }
    </style>
</head>

<body class="login d-flex justify-content-center align-items-center">
    <form id="form1" runat="server">
        <asp:HiddenField ID="swShowDialog" runat="server" ClientIDMode="Static" />
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" CssClass="fitContent">
            <div class="d-flex flex-column">
                <div class="logo d-flex justify-content-center">
                    <img src="../../Common/images/logo.png" title="MAP articulates college courses with ACE military credit recommendations and allows colleges to reach out to regional veterans, offering up to one year of credit in programs leading to high wage jobs and transfer." width="250" style="padding-top: 80px;" />
                </div>
                <div class="map">
                    <div class="login-app-site-description" style="display: none;">
                        MAP articulates college courses with ACE military credit recommendations and allows colleges to reach out to regional veterans, offering up to one year of credit in programs leading to high wage jobs and transfer.
                    </div>

                </div>
                <div class="login_wrapper text-center">
                    <h3 class="d-flex justify-content-start mt-3">
                        <!--<asp:Label ID="lblAppName" runat="server" Text=""></asp:Label>-->
                    </h3>
                    <!--<div class="separator"></div>-->
                    <br />
                    <telerik:RadNotification RenderMode="Lightweight" ID="rnSystemNotification" ClientIDMode="Static" runat="server" Text="System Maintenance is scheduled for Sunday January 7, 2024 04:00PM PST" Position="Center" AutoCloseDelay="0" Width="450" Height="220" Title="System Maintenance Notice" EnableRoundedCorners="true" Visible="false">
                        <ContentTemplate>
                            <div class="text-center m-3">
                                <p>
                                    Notice: The Mapping Articulated Pathways Production Site will be disabled Starting on January 7th, 2024 4:00PM PST. 
                                </p>
                               <%-- <p>Please contact support <a style="color: #000;" href="mailto: mappingarticulatedpathways.org">mapadmin@mappingarticulatedpathways.org</a> if you wish to maintain your Training Site data.</p>--%>

                                <p>
                                    <asp:LinkButton runat="server" ID="lnkDontShow" ClientIDMode="Static" CausesValidation="false" Text="Do not show this message again." CssClass="btn btn-light" />
                                </p>

                                <%--                        <p style="color:red;">
                           Sunday,  April 10 2022 from 06:00AM - 6:30AM PST.
                        </p>
                        <p>
                            During this period, you will experience connectivity issues.
                        </p>
                        <p>
                            We apologize for this inconvenience and appreciate your patience during this maintenance window.
                        </p>--%>
                            </div>
                        </ContentTemplate>
                    </telerik:RadNotification>
                    <telerik:RadNotification RenderMode="Lightweight" ID="rnDisableTrainning" runat="server" Text="" Position="Center" AutoCloseDelay="0" Width="400" Height="230" Title="System Maintenance Notice" EnableRoundedCorners="true" Visible="false">
                        <ContentTemplate>
                            <div class="text-center">
                                <p>
                                    Notice: The MAP Training Site will be disabled starting on January 1, 2023. Please contact support (link - mapadmin@mappingarticulatedpathways.org) if you wish to maintain your Training Site data.
                                </p>
                                <telerik:RadButton ID="rbDismiss" runat="server" Text="Do not show this message again"></telerik:RadButton>
                            </div>
                        </ContentTemplate>
                    </telerik:RadNotification>
                    <div>
                        <asp:Panel ID="panelLogin" runat="server" DefaultButton="Login1$Login" CssClass="d-flex justify-content-center">
                            <asp:Login ID="Login1" runat="server" OnAuthenticate="Login1_Authenticate" TitleText="" DisplayRememberMe="false" LoginButtonType="Button" UserNameLabelText="User : " LoginButtonStyle-Width="100%" FailureTextStyle-CssClass="alert alert-warning" Width="250px" LabelStyle-Width="70px">
                                <LayoutTemplate>
                                    <div>
                                        <h3 class=" d-flex justify-content-start">Login</h3>
                                        <br />
                                        <div class="mb-3">
                                            <label for="UserName" class="form-label d-flex justify-content-start">User name:</label>
                                            <asp:TextBox ID="UserName" CssClass="form-control" runat="server" placeholder="Username" BackColor="LightYellow"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" CssClass="validators" ControlToValidate="UserName" Text="*"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="mb-3">
                                            <label for="exampleInputPassword1" class="form-label d-flex justify-content-start">Password:</label>
                                            <asp:TextBox ID="Password" CssClass="form-control" runat="server" TextMode="Password" placeholder="Password" BackColor="LightYellow"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" CssClass="validators" ControlToValidate="Password" Text="*"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="mb-3">
                                            <asp:Button ID="Login" CommandName="Login" runat="server" CssClass="btn btn-default submit submit-login" Text="Login"></asp:Button>
                                        </div>
                                        <div class="mb-3">
                                            <asp:Label ID="FailureText" CssClass="login-failure" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                </LayoutTemplate>
                            </asp:Login>
                        </asp:Panel>
                    </div>
                    <div class="clearfix"></div>
                    <div class="row">
                        <div class="col-md-6">
                            <br />
                            <asp:LinkButton runat="server" ID="btnForgotPassword" CausesValidation="false" Text="Forgot username or password?" OnClick="btnForgotPassword_Click" />
                        </div>
                        <div class="col-md-6">
                            <br />
                            <asp:LinkButton runat="server" ID="btnNewUser" CausesValidation="false" Text="Request an Account" OnClick="btnNewUser_Click" />
                        </div>
                    </div>
                    <br />
                    <div class="new-user" id="divForgotPassword" runat="server">
                        <div class="col-md-12">
                            <h2>Recover your password</h2>
                        </div>
                        <div class="col-md-12">
                            We can help you recover your username or password. Enter your email and you will receive instructions.
                        </div>
                        <asp:Panel ID="pnlLogin" runat="server" DefaultButton="btnSend">
                            <div class="col-md-12">
                                <asp:TextBox runat="server" ID="rtbUsername" CssClass="form-control" Width="100%"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="rtbUsername" ErrorMessage="* Required" ValidationGroup="ValidateForgotPassword" CssClass="validators" />
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="rtbUsername" ErrorMessage="* Please enter a valid email." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="ValidateForgotPassword" CssClass="validators" />
                                <asp:Label ID="lblRememberPassword" runat="server" Visible="false"></asp:Label>
                                <br />
                            </div>
                            <div class="col-md-12">
                                <asp:LinkButton runat="server" ID="btnSend" CssClass="btn btn-default submit submit-login" Text="<i class='fa fa-paper-plane'></i> Send" OnClick="btnSend_Click" ValidationGroup="ValidateForgotPassword" />
                                <asp:LinkButton runat="server" ID="btnCancel" CssClass="btn btn-default submit submit-login" CausesValidation="false" Text="<i class='fa fa-times'></i> Cancel" OnClick="btnCancel_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                    <div id="divNewUser" runat="server" class="new-user">
                        <div class="col-md-12">
                            <h2>Request an account</h2>
                        </div>
                        <div class="col-md-12">
                            <label class="d-flex justify-content-start" style="margin-top: 10px;">College </label>
                            <asp:SqlDataSource ID="sqlColleges" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LookupColleges where collegeid not in(4,5) order by college "></asp:SqlDataSource>
                            <asp:DropDownList ID="ddlCollege" runat="server" Width="100%" DataSourceID="sqlColleges" DataTextField="College" DataValueField="CollegeID" AppendDataBoundItems="true">
                                <asp:ListItem Text="Select a College" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="ddlCollege" ErrorMessage="* Required" ValidationGroup="UserData" CssClass="validators" />
                        </div>
                        <div class="col-md-12">
                            <label class="d-flex justify-content-start" style="margin-top: 10px;">First Name </label>
                            <asp:TextBox ID="rtFirstName" runat="server" CssClass="form-control" Width="100%"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="rtFirstName" ErrorMessage="* Required" ValidationGroup="UserData" CssClass="validators" />
                        </div>
                        <div class="col-md-12">
                            <label class="d-flex justify-content-start">Last Name </label>
                            <asp:TextBox ID="rtLastName" runat="server" CssClass="form-control" Width="100%"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="rtLastName" ErrorMessage="* Required" ValidationGroup="UserData" CssClass="validators" />
                        </div>
                        <div class="col-md-12">
                            <label class="d-flex justify-content-start">Email </label>
                            <asp:TextBox ID="rtbEmail" InputType="Email" TextMode="Email" CssClass="form-control" runat="server" Width="100%"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="rtbEmail" ErrorMessage="* Required" ValidationGroup="UserData" CssClass="validators" />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="rtbEmail" ErrorMessage="* Please enter a valid email." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="UserData" CssClass="validators" />
                        </div>
                        <div class="col-md-12">
                            <label class="d-flex justify-content-start">Password </label>
                            <asp:TextBox ID="rtPassword" runat="server" Width="100%" TextMode="Password" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="rtPassword" ErrorMessage="* Required" ValidationGroup="UserData" CssClass="validators" />
                            <asp:RegularExpressionValidator ID="RequiredValidator77" runat="server" ControlToValidate="rtPassword" ErrorMessage="* Password needs to be at least 5 characters." ValidationExpression='^[\s]*[\x21-\x7E][\x20-\x7E]{3,}[\x21-\x7E][\s]*$' ValidationGroup="UserData" CssClass="validators" />
                        </div>
                        <div class="col-md-12">
                            <label class="d-flex justify-content-start">Confirm Password </label>
                            <asp:TextBox ID="rtConfirmPassword" runat="server" Width="100%" TextMode="Password" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="rtConfirmPassword" ErrorMessage="* Required" ValidationGroup="UserData" CssClass="validators" />
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="rtPassword" ControlToCompare="rtConfirmPassword" Operator="Equal" ErrorMessage="* Confirm password must match" ValidationGroup="UserData" CssClass="validators"></asp:CompareValidator>
                        </div>
                        <div class="col-md-12">
                            <asp:Label ID="lblUserMessage" runat="server" Visible="false" />
                        </div>
                        <div class="col-md-12 text-center">
                            <asp:LinkButton runat="server" ID="btnRequestUser" CssClass="btn btn-default submit submit-login" Text="<i class='fa fa-user-plus'></i> Request New  User" OnClick="btnRequestUser_Click" ValidationGroup="UserData" />
                            <asp:LinkButton runat="server" ID="btnCancelUser" CssClass="btn btn-default submit submit-login" CausesValidation="false" Text="<i class='fa fa-times'></i> Cancel" OnClick="btnCancelUser_Click" />
                        </div>

                    </div>

                    <div class="clearfix"></div>

                    <div class="row login-footer">
                        <div class="col-12 text-center">
                            <img src="../../Common/images/Firefox-logo.png" alt="Firefox" style="width: 32px; height: 30px; display: none;" />
                            <p>Mozilla Firefox recommended browser.</p>
                        </div>
                        <div class="col-12 text-center">
                            <h3 style="display: none;">
                                <asp:Label ID="lblBussinesName" runat="server" Text=""></asp:Label></h3>
                            <p>© 2017-2024 California MAP Initiative. All Rights Reserved.</p>
                            <div style="width: 490px; margin: 0 auto;">
                                <p>Funding is provided by: <a href="https://a60.asmdc.org/" style="font-weight: bold; text-decoration: underline;" target="_blank">Assembly member Sabrina Cervantes,</a> District 60, and the <a href="https://latinocaucus.legislature.ca.gov/" style="font-weight: bold; text-decoration: underline;" target="_blank">California Latino Legislative Caucus.</a> and 2023 Federal Omnibus Community Project Sponsored by U.S. Representative Ken Calvert, 41st District, Chairman of the Defense Appropriations Subcommittee.</p>
                                <br />
                                <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="rpbMyNotifications" Width="100%" CssClass="mb-2">
                                    <Items>
                                        <telerik:RadPanelItem Text="My Notifications" Expanded="false" EnableTheming="false" ToolTip="Click here to collapse/expand this area">
                                            <HeaderTemplate>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div class="col-11 text-center" style="font-weight: bold;">
                                                        FERPA Compliance
                                                    </div>
                                                    <div class="col-1">
                                                        <a class="rpExpandable">
                                                            <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </HeaderTemplate>
                                            <ContentTemplate>
                                                <div style="padding: 10px;">
                                                    <p style="text-align: left;">The MAP platform is hosted in a secure FERPA-compliant, Microsoft Azure cloud environment, and the following best practices for data governance are in place:</p>
                                                    <ul style="text-align: left;">
                                                        <li>Security protocols are utilized, and MAP SSL certificate and data encryption routines protect all student personal identifiable information (PII).</li>
                                                        <li>The Server Firewall has been configured to secure both the QA Training and Production platforms; database and network security access have been configured.</li>
                                                        <li>MAP Administrator and Ambassador accounts have been configured to give or restrict access to the platform.</li>
                                                        <li>A security governance framework is in place to ensure that procedural, personnel, physical, and technical controls remain effective through the platform's lifetime and in response to changes in threat and technology developments.</li>
                                                        <li>The MAP platform uses the Microsoft Azure Antimalware, which runs in real-time and provides protection that helps prevent, identify, and remove viruses, spyware, and other malicious software.</li>
                                                        <li>MAP has embedded a security validation routine that alerts users when they are accessing copies of student documentation containing personal identifying information.</li>
                                                    </ul>
                                                </div>
                                            </ContentTemplate>
                                        </telerik:RadPanelItem>
                                    </Items>
                                </telerik:RadPanelBar>

                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </telerik:RadAjaxPanel>
    </form>
    <!-- jQuery -->
    <script src="/Common/vendors/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap -->
    <script src="/Common/vendors/bootstrap/dist/js/bootstrap.min.js"></script>


    <script type="text/javascript">

        //$(function () {
        //    let dsh = getCookie("dialogShown");
        //    alert(dsh);
        //    if (dsh != null)
        //    {
        //        if (dsh == "false") {
        //            $('#rnSystemNotification_popup').hide();
        //        } else {
        //            let domainName = window.location.hostname;
        //            var trainingHost = "maptrainingplatform.azurewebsites.net";
        //            //var trainingHost = "localhost";
        //            if (domainName == trainingHost) {
        //                $('#rnSystemNotification_popup').show();
        //            } else {
        //                $('#rnSystemNotification_popup').hide();
        //            }
        //        }
        //    }


        //    $("#lnkDontShow").click(function () {
        //        document.cookie = "dialogShown=false";
        //        location.reload();
        //    });
        //});

        function getCookie(cname) {
            let name = cname + "=";
            let decodedCookie = decodeURIComponent(document.cookie);
            let ca = decodedCookie.split(';');
            for (let i = 0; i < ca.length; i++) {
                let c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }

    </script>

</body>
</html>
