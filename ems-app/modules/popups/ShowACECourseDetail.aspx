<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowACECourseDetail.aspx.cs" Inherits="ems_app.modules.popups.ShowACECourseDetail" %>

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
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet"/>
</head>
<body style="background-color: #fff;" id="detailPopup" runat="server">
    <div style="padding: 15px !important;">
        <form id="form1" runat="server">
            <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
            <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
                <asp:HiddenField ID="hfAdvancedSearch" runat="server" ClientIDMode="Static" />
                <div class="row context">
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <telerik:RadTabStrip RenderMode="Lightweight" ID="tsVersions" runat="server" EnableDragToReorder="true" MultiPageID="rmpVersions" SelectedIndex="0">
                            <Tabs>
                                <telerik:RadTab Text="Current Version"></telerik:RadTab>
                                <telerik:RadTab Text="Legacy Version"></telerik:RadTab>
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
                                                    <asp:Label runat="server" ID="Label2" Text='<%# Eval("ExhibitDisplay") %>' /></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
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
                                <asp:SqlDataSource ID="sqlACECoursesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT CourseDetail FROM AceCatalogDetail ac WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd">
                                    <SelectParameters>
                                        <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                        <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlACECoursesHeader" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select AceID, Exhibit, Title, CourseNumber, Location, CourseLength from AceCourseCatalog ac WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd">
                                    <SelectParameters>
                                        <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                        <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <div>
                                    <asp:Repeater ID="Repeater1" runat="server"
                                        DataSourceID="sqlACECoursesHeader">
                                        <HeaderTemplate>
                                            <h2>ACE Course Exhibit</h2>
                                            <table style="width: 100%">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label1" Text='Course Exhibit : ' Font-Bold="true" />
                                                    <asp:Label runat="server" ID="Label2" Text='<%# Eval("Exhibit") %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label3" Text='Title : ' Font-Bold="true" />
                                                    <asp:Label runat="server" ID="Label4" Text='<%# Eval("Title") %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label5" Text='Course Number : ' Font-Bold="true" />
                                                    <asp:Label runat="server" ID="Label6" Text='<%# Eval("CourseNumber") %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label9" Text='Course Length : ' Font-Bold="true" />
                                                    <asp:Label runat="server" ID="Label10" Text='<%# Eval("CourseLength") %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label7" Text='Location : ' Font-Bold="true" />
                                                    <asp:Label runat="server" ID="Label8" Text='<%# Eval("Location") %>' /></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                                <br />
                                <div>
                                    <asp:Repeater ID="Repeater2" runat="server"
                                        DataSourceID="sqlACECoursesDetails">
                                        <HeaderTemplate>
                                            <table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label2" Text='<%# Eval("CourseDetail") %>' />
                                                </td>
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
            var instance = new Mark(document.getElementsByClassName("context"));
            instance.mark(criteriaArray, {
                "separateWordSearch": false,
                "ignoreJoiners": true,
                "acrossElements": true,
            });
        });
    </script>
</body>
</html>

