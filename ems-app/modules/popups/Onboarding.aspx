<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Onboarding.aspx.cs" Inherits="ems_app.modules.popups.Onboarding" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>MAP Self-Guided Training Tool</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
    <style>
        .BootcampOptions {
            padding: 0 15px;
        }

            .BootcampOptions ul li {
                list-style: none;
                padding: 3px;
            }

                .BootcampOptions ul li ul {
                    padding-top: 0px;
                }

            .BootcampOptions li:first-child {
                padding-bottom: 0px;
            }

            .BootcampOptions ul > li {
                font-weight: bold;
            }

                .BootcampOptions ul > li li {
                    font-weight: normal;
                }
    </style>
</head>
<script type="text/javascript">
    function GetRadWindow() {
        var oWindow = null;
        if (window.radWindow)
            oWindow = window.radWindow;
        else if (window.frameElement && window.frameElement.radWindow)
            oWindow = window.frameElement.radWindow;
        return oWindow;
    }
    function CloseModal() {
        var oWnd = GetRadWindow();
        if (oWnd) oWnd.close();
        top.location.href = top.location.href;
    }
</script>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlFeedbackType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from FeedbackType"></asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="280px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div style="padding: 15px !important;">
                <div class="row">
                    <h2>Let’s get started!</h2>
                </div>
                <div class="row">
                    <p>Here are the different features that you can do based on your Faculty role.</p>

                </div>
                <div class="row">
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="RadPanelbar1" Width="100%">
                        <Items>
                            <telerik:RadPanelItem Text="My Favorites" Expanded="true" EnableTheming="false" ToolTip="Click here to expand/collapse this area. To mark a menu item as your favorite, please right-click the menu item and left-click on Add/Remove Favorite">
                                <HeaderTemplate>
                                    &nbsp;<b>Articulations Pending to Review</b>
                                    <a class="rpExpandable">
                                        <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                    </a>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <div class="BootcampOptions">
                                        <ul>
                                            <li><a href="#">Articulations in process</a></li>
                                            <li>
                                                <ul>
                                                    <li><a href="../faculty/ArticulaTionsPendingToReview.aspx?onboarding=true&action=approved-articulations" target="_blank">Approve Articulations</a></li>
                                                    <li><a href="../faculty/ArticulaTionsPendingToReview.aspx?onboarding=true&action=archive-articulations" target="_blank">Archive Articulations</a></li>
                                                    <li><a href="../faculty/ArticulaTionsPendingToReview.aspx?onboarding=true&action=denny-articulations" target="_blank">Deny Articulations</a></li>
                                                    <li><a href="../faculty/ArticulaTionsPendingToReview.aspx?onboarding=true&action=return-articulations" target="_blank">Return Articulations</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="../faculty/ArticulaTionsPendingToReview.aspx?onboarding=true&action=recent-user-activity" target="_blank">Recent User Activity</a></li>
                                            <li><a href="../faculty/ArticulaTionsPendingToReview.aspx?onboarding=true&action=denied-articulations" target="_blank">Denied Articulations</a></li>
                                            <li><a href="../faculty/ArticulaTionsPendingToReview.aspx?onboarding=true&action=archived-articulations" target="_blank">Archived Articulations</a></li>
                                            <li><a href="#">Articulation to adopt from other colleges</a></li>
                                            <li>
                                                <ul>
                                                    <li><a href="../faculty/ArticulaTionsPendingToReview.aspx?onboarding=true&action=adopt-articulations" target="_blank">Adopt Selected Articulations</a></li>
                                                    <li><a href="../faculty/ArticulaTionsPendingToReview.aspx?onboarding=true&action=view-articulations" target="_blank">View Selected Articulations</a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                        <ExpandAnimation Type="None" />
                        <CollapseAnimation Type="None" />
                    </telerik:RadPanelBar>
                    <telerik:RadPanelBar RenderMode="Lightweight" runat="server" ID="RadPanelbar2" Width="100%" Visible="false">
                        <Items>
                            <telerik:RadPanelItem Text="My Favorites" Expanded="true" EnableTheming="false" ToolTip="Click here to expand/collapse this area. To mark a menu item as your favorite, please right-click the menu item and left-click on Add/Remove Favorite">
                                <HeaderTemplate>
                                    &nbsp;<b>Settings</b>
                                    <a class="rpExpandable">
                                        <span class="rpExpandHandle"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                                    </a>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <div style="padding: 0 15px;">
                                        <a href="../security/Profile.aspx?onboarding=true" target="_parent">Your Profile</a>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                        <ExpandAnimation Type="None" />
                        <CollapseAnimation Type="None" />
                    </telerik:RadPanelBar>
                    <br />
                    <div class="text-center">
                        <telerik:RadButton ID="rbShowMe" runat="server" ButtonType="LinkButton" Text="CLOSE" Primary="true" OnClientClicked="CloseModal"></telerik:RadButton>
                    </div>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
        <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        </telerik:RadCodeBlock>
    </form>
</body>
</html>
