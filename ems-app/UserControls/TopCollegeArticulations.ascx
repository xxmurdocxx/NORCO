<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TopCollegeArticulations.ascx.cs" Inherits="ems_app.UserControls.TopCollegeArticulations" %>

<asp:SqlDataSource runat="server" ID="sqlTopCollegesArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
    SelectCommand="TopCollegesArticulations" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="TopNumber" Type="Int32" />
        <asp:Parameter Name="OnlyPublished" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:Repeater ID="rptTopCollegesArticulations" runat="server" DataSourceID="sqlTopCollegesArticulations">
    <HeaderTemplate>
        <table class="table">
            <thead>
                <tr>
                    <th scope="col">College</th>
                    <th scope="col" class="text-center">Articulations In Process</th>
                </tr>
            </thead>
            <tbody>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>
            <td><img src='<%# Eval("Logo") %>' width="24" height="24" class='rounded-circle' /> <%# Eval("College") %></td>
            <td class="text-center"><%# Eval("Articulations") %></td>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        </tbody>
</table>
    </FooterTemplate>
</asp:Repeater>


