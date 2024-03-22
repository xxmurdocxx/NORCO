<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitInformation.ascx.cs" Inherits="ems_app.UserControls.ExhibitInformation" %>
<h2>Exhibit Information</h2>
<div class="courseDetails">
    <div class="courseDetails">
        <asp:SqlDataSource ID="sqlHighlightedCurrentVersion" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetExhibit" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:Parameter Name="ExhibitID" Type="Int32" ConvertEmptyStringToNull="true" />
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
    </div>
</div>
