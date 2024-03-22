<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmailAccess_o.aspx.cs" Inherits="ems_app.modules.notifications.EmailAccess_o" %>

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
<%--                    <telerik:RadNotification RenderMode="Lightweight" ID="rnDisableTrainning" runat="server" Text="" Position="Center" AutoCloseDelay="0" Width="400" Height="230" Title="System Maintenance Notice" EnableRoundedCorners="true" Visible="false">
                        <ContentTemplate>
                            <div class="text-center">
                                <p>
                                    Notice: The MAP Training Site will be disabled starting on January 1, 2023. Please contact support (link - mapadmin@mappingarticulatedpathways.org) if you wish to maintain your Training Site data.
                                </p>
                                <telerik:RadButton ID="rbDismiss" runat="server" Text="Do not show this message again"></telerik:RadButton>
                            </div>
                        </ContentTemplate>
                    </telerik:RadNotification>--%>
                    <div class="d-flex justify-content-center">
                                <LayoutTemplate>
                                    <div class="mt-3 mb-3">
                                        <div class="mb-3">
                                            <asp:Label ID="FailureText" CssClass="login-failure" runat="server"></asp:Label>
                                        </div>
                                        <%--<h3 class="d-flex justify-content-start">This link has expired, please log into MAP below</h3>--%>
                                        <div class="mb-3">
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </div>
                                        <div class="mt-4 mb-3">
                                            <asp:Button ID="Login" CommandName="Login" runat="server" CssClass="btn btn-default submit submit-login" Text="Back To Login Page" OnClick="Login_Click"></asp:Button>
                                        </div>
                                        
                                    </div>
                                    <br /><br /><br />
                                </LayoutTemplate>
                    </div>
                    <div class="clearfix"></div>

                    <div class="row login-footer">

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

        
        //function getCookie(cname) {
        //    let name = cname + "=";
        //    let decodedCookie = decodeURIComponent(document.cookie);
        //    let ca = decodedCookie.split(';');
        //    for (let i = 0; i < ca.length; i++) {
        //        let c = ca[i];
        //        while (c.charAt(0) == ' ') {
        //            c = c.substring(1);
        //        }
        //        if (c.indexOf(name) == 0) {
        //            return c.substring(name.length, c.length);
        //        }
        //    }
        //    return "";
        //}

    </script>

   

</body>



</html>
