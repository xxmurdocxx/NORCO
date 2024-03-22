<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CriteriaLegend.ascx.cs" Inherits="ems_app.UserControls.CriteriaLegend" %>
<asp:SqlDataSource ID="sqlCriteriaTypes" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from ArticulationCriteriaType where ArticulationType = 2 order by sorder"></asp:SqlDataSource>
<div style="float: left;">
    <asp:Repeater ID="rptCriteriaTypes" runat="server" OnItemDataBound="rptCriteriaTypes_ItemDataBound" DataSourceID="sqlCriteriaTypes">
        <ItemTemplate>
            <div id="DivLegend" class="DivLegend" runat="server"></div>
            <div class="DivLegendDesc"><%# Eval("Description") %> </div>
        </ItemTemplate>
    </asp:Repeater>
</div>
