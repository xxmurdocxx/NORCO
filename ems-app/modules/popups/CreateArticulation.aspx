<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateArticulation.aspx.cs" Inherits="ems_app.modules.popups.CreateArticulation" %>

<%@ Register Src="~/UserControls/OccupationInformation.ascx" TagPrefix="uc" TagName="OccupationInformation" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Create Articulation</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
    <style>
        .RadTile_Material,
        .RadWindow_Material .rwTitleBar,
        .rmContent [type="submit"],
        .RadButton_Material.rbButton.rbPrimaryButton,
        .RadWizard_Material .rwzNext, .RadWizard_Material .rwzFinish,
        .RadWizard_Material .rwzProgress,
        .RadNotification_Material .rnTitleBar,
        /*.badge, */
        .RadCalendar_Material .rcTitlebar,
        .RadCalendar_Material .rcPrev, .RadCalendar_Material .rcNext, .RadCalendar_Material .rcFastPrev, .RadCalendar_Material .rcFastNext {
            border-color: #203864 !important;
            background-color: #203864 !important;
        }

        .rgExpandCol {
            display: none !important;
        }

        .RadComboBox_Material .rcbInner {
            background-color: lightyellow !important;
        }

        .RadComboBox_Material .rcbLabel {
            color: inherit !important;
            font-weight: 700 !important;
            font-size: 10px !important;
        }
        .alert {
            margin:5px 0;
        }
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" EnableViewState="false" runat="server" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <asp:HiddenField ID="hvUserID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hvCollegeID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hvOutlineID" runat="server" ClientIDMode="Static" />
            <%--<asp:HiddenField ID="hvUnits" runat="server" ClientIDMode="Static" />--%>
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="0" Width="350" Height="150" Title="" EnableRoundedCorners="true" Animation="Fade" AnimationDuration="3">
            </telerik:RadNotification>
            <div style="padding: 15px;">
                <div class="row">
                    <div class="col-sm-6">
                        <telerik:RadComboBox ID="rcbCourses" DataSourceID="sqlCourses" DataTextField="CourseDescription" DataValueField="outline_id" MaxHeight="200px" Width="100%" EmptyMessage="Search..." AllowCustomText="false" ToolTip="Search for a college course (i.e. BUS 10) " runat="server" MarkFirstMatch="true" Filter="Contains" DropDownAutoWidth="Enabled" Label="Course : " AutoPostBack="true" Font-Bold="true" AppendDataBoundItems="true">
                                <Items>
                                    <telerik:RadComboBoxItem Text="" Value="" />
                                </Items>
                        </telerik:RadComboBox>
                        <asp:Panel ID="pnlDisclaimer" runat="server" Width="100%" CssClass="alert alert-warning" Text="" Visible="false" ClientIDMode="Static">
                            <i class='fa fa-exclamation-triangle' aria-hidden='true'></i> Area credits must be configured by your MAP Ambassador within the Ambassador's Module. 
                        </asp:Panel>
                        <asp:SqlDataSource runat="server" ID="sqlCourses" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="sp_SearchCourses" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter Name="CollegeID" ControlID="hvCollegeID" PropertyName="Value" DbType="Int32" />
                                <asp:Parameter Name="CourseType" DbType="Int32" DefaultValue="1" />
                                <asp:Parameter Name="All" DbType="Int32" DefaultValue="1" />
                                <%--<asp:ControlParameter Name="Units" ControlID="hvUnits" PropertyName="Value" DbType="Decimal" />--%>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:RequiredFieldValidator runat="server" CssClass="alert alert-warning" ControlToValidate="rcbCourses" ErrorMessage="Please select a course." Display="Dynamic" ValidationGroup="CreateArticulation" EnableClientScript="true" />
                    </div>
                    <div class="col-sm-6 text-right">
                    <telerik:RadButton ID="rbCreate" runat="server" Text="Create" CausesValidation="true" OnClick="rbCreate_Click" ValidationGroup="CreateArticulation" ToolTip="Click here to proceed creating the articulation." Primary="true">
                        <Icon PrimaryIconCssClass="rbOk"></Icon>
                    </telerik:RadButton>
                    <telerik:RadButton ID="rbCancel" runat="server" Text="Cancel" OnClientClicked="CloseModal">
                        <Icon PrimaryIconCssClass="rbCancel"></Icon>
                    </telerik:RadButton>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6" style="font-size: 10px !important;">
                        <asp:SqlDataSource ID="sqlSelectedCollegeCourse" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter Name="outline_id" ControlID="rcbCourses" PropertyName="SelectedValue" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:Repeater ID="Repeater2" runat="server" DataSourceID="sqlSelectedCollegeCourse">
                            <ItemTemplate>
                                <div class="row">
                                    <div class="col-12"><b>Catalog Description :</b></div>
                                    <div class="col-12"><%# Eval("_CatalogDescription") %></div>
                                    <div class="col-12"><b>Taxonomy of Program Code (TOP CODE) : <%# Eval("_TopsCode") %></b></div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="col-sm-6" style="font-size: 10px !important;">
                        <div class="courseDetails context">
                            <asp:SqlDataSource ID="sqlHighlightedCurrentVersion" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  ExhibitDisplay  FROM ACEExhibit ac  WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd and ISNULL(ac.EndDate, 0) = (select ISNULL(max(EndDate),0) from AceExhibit WHERE  AceID = @AceID and TeamRevd = @TeamRevd group by AceID, TeamRevd)" SelectCommandType="Text">
                                <SelectParameters>
                                    <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                    <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:Repeater ID="rptCurrentVerion" runat="server" DataSourceID="sqlHighlightedCurrentVersion">
                                <HeaderTemplate>
                                    <table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label2" Text='<%# Eval("ExhibitDisplay") %>' /></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                            <br />
                            <asp:SqlDataSource ID="sqlLocations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct  Location  from AceExhibitLocation ac WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd and ac.EndDate = (select max(EndDate) from AceExhibitLocation WHERE  AceID = @AceID and TeamRevd = @TeamRevd group by AceID, TeamRevd)">
                                <SelectParameters>
                                    <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                    <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:Repeater ID="Repeater3" runat="server" DataSourceID="sqlLocations">
                                <HeaderTemplate>
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="Label7" Text='Location(s) : ' Font-Bold="true" /></td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label8" Text='<%# Eval("Location") %>' /></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                            <asp:SqlDataSource ID="sqlExhibitRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  ac.Recommendation, ac.LearningOutcome  FROM ACEExhibitRecommendation ac  WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd">
                                <SelectParameters>
                                    <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                    <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:Repeater ID="Repeater5" runat="server" DataSourceID="sqlExhibitRecommendations">
                                <HeaderTemplate>
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="Label7" Text="Related Competencies" Font-Bold="true" /><br />
                                                <br />
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label8" Font-Bold="true" Text='<%# Eval("Recommendation") %>' /></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label11" Text='<%# Eval("LearningOutcome") %>' /></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
                <div class="row text-right" style="margin-top: 5px;">
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>

    </form>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mark.js/8.11.1/jquery.mark.es6.js"></script>
    <script>
        $(document).ready(function () {
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            const criteria = urlParams.get('CreditRecommendations')
            var criteriaArray = criteria.split(',');
            $("div.context").mark(criteriaArray, {
                "separateWordSearch": false,
                "ignoreJoiners": true,
                "acrossElements": true
            });
        });
        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow)
                oWindow = window.radWindow;
            else if (window.frameElement && window.frameElement.radWindow)
                oWindow = window.frameElement.radWindow;
            return oWindow;
        }
        function CloseModal() {
            setTimeout(function () {
                GetRadWindow().close();
                top.location.href = top.location.href;
            }, 0);
        }
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
    </script>
</body>
</html>
