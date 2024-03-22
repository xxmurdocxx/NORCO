<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OccupationInformation.ascx.cs" Inherits="ems_app.UserControls.OccupationInformation" %>
<asp:SqlDataSource ID="sqlACEOccupationHeader" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct * from AceOccupation ac WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd">
    <SelectParameters>
        <asp:Parameter Name="AceID" />
        <asp:Parameter Name="TeamRevd" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlHighlightedRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArticulationHighlightedCriteria" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="AceID" />
        <asp:Parameter Name="TeamRevd" />
        <asp:Parameter Name="ArticulationID" Type="Int32" />
        <asp:Parameter Name="ArticulationType" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<h2>Occupation Information</h2>
<div class="courseDetails">


    <telerik:RadTabStrip RenderMode="Lightweight" ID="tsVersions" runat="server" EnableDragToReorder="true" MultiPageID="rmpVersions" SelectedIndex="0">
        <Tabs>
            <telerik:RadTab Text="Current Version"></telerik:RadTab>
            <telerik:RadTab Text="Legacy Version"></telerik:RadTab>
        </Tabs>
    </telerik:RadTabStrip>
    <telerik:RadMultiPage ID="rmpVersions" runat="server" CssClass="RadMultiPage" SelectedIndex="0">
        <telerik:RadPageView ID="rpvCurrentVersion" runat="server" Style="overflow: hidden">
            <div class="courseDetails">
                <asp:SqlDataSource ID="sqlHighlightedCurrentVersion" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArticulationHighlightedCriteriaCurrentVersion" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                        <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                        <asp:ControlParameter Name="ArticulationID" ControlID="hvArticulationID" PropertyName="Value" Type="Int32" ConvertEmptyStringToNull="true" />
                        <asp:Parameter Name="ArticulationType" DefaultValue="2" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:Repeater ID="rptCurrentVerion" runat="server" DataSourceID="sqlHighlightedCurrentVersion">
                    <HeaderTemplate>
                        <table>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label2" Text='<%# Eval("Recommendations") %>' /></td>
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
        </telerik:RadPageView>
        <telerik:RadPageView ID="rpvLegacyVersion" runat="server" Style="overflow: hidden">
            <div class="courseDetails">
                <asp:Repeater ID="rptOccupationHeader" runat="server"
                    DataSourceID="sqlACEOccupationHeader">
                    <HeaderTemplate>
                        <table>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label1" Text='Occupation Code : ' Font-Bold="true" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label2" Text='<%# Eval("Occupation") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label3" Text='Title : ' Font-Bold="true" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label4" Text='<%# Eval("Title") %>' /></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <br />
                <asp:Repeater ID="rptHighlightedRecommendations" runat="server"
                    DataSourceID="sqlHighlightedRecommendations">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("Recommendations") %>
                    </ItemTemplate>
                    <FooterTemplate>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </telerik:RadPageView>
    </telerik:RadMultiPage>
</div>