<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="ems_app.modules.popups.Feedback" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
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
                    <h2>Feedback</h2>
                </div>
                <div class="row">
                    <p>Please tell us what you think. Any feedback is highly appreciated.</p>
                    <telerik:RadTextBox ID="txtFeedbackType" runat="server" CssClass="displayNone" ClientIDMode="Static" />
                    <br />
                    <telerik:RadButton ID="rbIdea" runat="server" ToggleType="Radio" AutoPostBack="false" OnClientClicked="OnClientClicked"   ButtonType="ToggleButton" Text="Idea" Value ="2" GroupName="feedbackType" CausesValidation="false">
                        <ContentTemplate>
                            <i class='fa fa-lightbulb-o'></i> Idea
                        </ContentTemplate>
                    </telerik:RadButton>
                    <telerik:RadButton ID="rbIssue" runat="server" ToggleType="Radio" AutoPostBack="false" OnClientClicked="OnClientClicked"  ButtonType="ToggleButton" Text="Issue" Value ="1" GroupName="feedbackType"  CausesValidation="false">
                        <ContentTemplate>
                            <i class='fa fa-exclamation-circle'></i> Issue
                        </ContentTemplate>
                    </telerik:RadButton>
                    <telerik:RadButton ID="rbQuestion" runat="server" ToggleType="Radio" AutoPostBack="false" OnClientClicked="OnClientClicked"  ButtonType="ToggleButton" Text="Question" Value ="4" GroupName="feedbackType"  CausesValidation="false">
                        <ContentTemplate>
                            <i class='fa fa-question-circle'></i> Question
                        </ContentTemplate>
                    </telerik:RadButton>
                    <telerik:RadButton ID="rbKudos" runat="server" ToggleType="Radio" AutoPostBack="false" OnClientClicked="OnClientClicked" ButtonType="ToggleButton" Text="Kudos" Value ="3" GroupName="feedbackType"  CausesValidation="false">
                        <ContentTemplate>
                            <i class='fa fa-thumbs-o-up'></i> Kudos
                        </ContentTemplate>
                    </telerik:RadButton>
                    <telerik:RadButton ID="rbOther" runat="server" ToggleType="Radio" AutoPostBack="false" OnClientClicked="OnClientClicked" ButtonType="ToggleButton" Text="Other" Value ="5" GroupName="feedbackType"  CausesValidation="false">
                        <ContentTemplate>
                            <i class='fa fa-info-circle'></i> Other
                        </ContentTemplate>
                    </telerik:RadButton>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="alert-danger" ControlToValidate="txtFeedbackType" Display="Dynamic">Please select feedback type.</asp:RequiredFieldValidator>
                    <br /><br />
                    <p>Short Detail :</p>
                    <telerik:RadTextBox ID="rtbDetails" TextMode="MultiLine" Width="100%" Rows="10" runat="server"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="alert-danger" ControlToValidate="rtbDetails" Display="Dynamic">Please explain your feedback.</asp:RequiredFieldValidator>
                    <br />
                    <br />
                    <telerik:RadButton ID="rbSave" runat="server" Text="Save" ButtonType="StandardButton" OnClick="rbSave_Click" CausesValidation="true">
                        <ContentTemplate>
                            <i class="fa fa-paper-plane"></i> Submit Feedback
                        </ContentTemplate>
                    </telerik:RadButton>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
        <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
            <script type="text/javascript">

            function OnClientClicked(sender, args) {
                var feedbackType = $find('<%= txtFeedbackType.ClientID %>');
                feedbackType.set_value(sender.get_value());
            }
                </script>
        </telerik:RadCodeBlock>
    </form>
</body>
</html>
