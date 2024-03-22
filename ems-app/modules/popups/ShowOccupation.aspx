<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowOccupation.aspx.cs" Inherits="ems_app.modules.popups.ShowOccupation" ValidateRequest="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>ACE Occupation Information</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
</head>
<body style="background-color: #fff;">
    <div style="padding: 15px !important;">
        <form id="form1" runat="server">
            <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
            <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
                <div class="row context">
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="occupationInfoHeader">
                            <h2>
                                <asp:Label ID="Occupation" runat="server" Width="100%"></asp:Label>
                            </h2>
                        </div>
                        <telerik:RadTabStrip RenderMode="Lightweight" ID="tsVersions" runat="server" EnableDragToReorder="true" MultiPageID="rmpVersions" SelectedIndex="0">
                            <Tabs>
                                <telerik:RadTab Text="Current Version"></telerik:RadTab>
                                <telerik:RadTab Text="Legacy Version"></telerik:RadTab>
                                <telerik:RadTab Text="Related Competencies / Learning Outcomes"></telerik:RadTab>
                            </Tabs>
                        </telerik:RadTabStrip>
                        <telerik:RadMultiPage ID="rmpVersions" runat="server" CssClass="RadMultiPage" SelectedIndex="0">
                            <telerik:RadPageView ID="rpvCurrentVersion" runat="server" Style="overflow: hidden">
                                <asp:SqlDataSource ID="sqlCurrentVersion" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetACEInformation" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                                    <SelectParameters>
                                        <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                        <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                        <asp:QueryStringParameter DefaultValue="0" Name="StartDate" QueryStringField="StartDate" ConvertEmptyStringToNull="false" />
                                         <asp:QueryStringParameter DefaultValue="0" Name="EndDate" QueryStringField="EndDate" ConvertEmptyStringToNull="false" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <div class="courseDetails">
                                    <asp:Repeater ID="rptCurrentVerion" runat="server" DataSourceID="sqlCurrentVersion">
                                        <HeaderTemplate>
                                            <table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label2" Text='<%# Eval("ExhibitDisplay").ToString().Replace("null","#") %>' /></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                    <asp:SqlDataSource ID="sqlLocations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct  Location  from AceExhibitLocation ac WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd">
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
                                    <asp:SqlDataSource ID="sqlRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select Recommendation, LearningOutcome  from ACEExhibitRecommendation ac WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd">
                                        <SelectParameters>
                                            <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                            <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:Repeater ID="Repeater4" runat="server" DataSourceID="sqlRecommendations">
                                        <HeaderTemplate>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="Label7" Text='Recommendation(s) : ' Font-Bold="true" /></td>
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
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="rpvLegacyVersion" runat="server" Style="overflow: hidden">
                                <asp:SqlDataSource ID="sqlOccupationDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from [AceOccupation] where AceID = @AceID and TeamRevd = @TeamRevd">
                                    <SelectParameters>
                                        <asp:QueryStringParameter Name="AceID" QueryStringField="AceID" Type="String" />
                                        <asp:QueryStringParameter Name="TeamRevd" QueryStringField="TeamRevd" Type="String" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <div class="occupationInfoDetail">
                                    <asp:Repeater ID="Repeater1" runat="server"
                                        DataSourceID="sqlOccupationDetails">
                                        <HeaderTemplate>
                                            <table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label10" Text='<%# Eval("Details") %>' /></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="rpvLearningOutcomes" runat="server" Style="overflow: hidden">
                                <asp:SqlDataSource ID="sqlLearningOutcomes" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from [ACEExhibitRecommendation] where AceID = @AceID and TeamRevd = @TeamRevd">
                                    <SelectParameters>
                                        <asp:QueryStringParameter Name="AceID" QueryStringField="AceID" Type="String" />
                                        <asp:QueryStringParameter Name="TeamRevd" QueryStringField="TeamRevd" Type="String" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <div class="LearningOutcomesInfoDetail">
                                    <asp:Repeater ID="Repeater2" runat="server"
                                        DataSourceID="sqlLearningOutcomes">
                                        <HeaderTemplate>
                                            <table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <h2 class="badge" style="display:block;"><%# Eval("Recommendation") %></h2>
                                                    <asp:Label runat="server" ID="Label10" Text='<%# Eval("LearningOutcome") %>' /></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </telerik:RadPageView>
                        </telerik:RadMultiPage>

                    </div>
                </div>
            </telerik:RadAjaxPanel>
            <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
        </form>
    </div>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mark.js/8.11.1/jquery.mark.es6.js"></script>
    <script>
        $(document).ready(function () {
                        const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            const criteria = urlParams.get('AdvancedSearch')
            var criteriaArray = criteria.split(',');
            $("div.context").mark(criteriaArray, {			  
                "separateWordSearch": false,
                "ignoreJoiners": true,
                "acrossElements": true
            });
        });


    </script>
</body>
</html>


