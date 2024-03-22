<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Eligibility.ascx.cs" Inherits="ems_app.UserControls.Eligibility" %>
<asp:SqlDataSource ID="sqlEligibility" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ac.ID, cc.AceID, cc.TeamRevd, cc.Exhibit, cc.Occupation, cc.Title as 'OccupationTitle', ac.ForAssociateOnly , ac.ForTransfer from Articulation ac left outer join ACEOccupation cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd where ac.outline_id = @OutlineID  and ac.ArticulationStage = @ArticulationStage and ac.ArticulationType = 2 order by cc.AceID, cc.TeamRevd" UpdateCommand="update Articulation set ForAssociateOnly = @ForAssociateOnly , ForTransfer = @ForTransfer where id = @ID">
    <SelectParameters>
        <asp:Parameter Name="OutlineID" />
        <asp:Parameter Name="AceID" />
        <asp:Parameter Name="ArticulationStage" />
        <asp:Parameter Name="TeamRevd" />
    </SelectParameters>
    <UpdateParameters>
        <asp:Parameter Name="ID" Type="Int32" />
        <asp:Parameter Name="ForAssociateOnly" Type="Boolean" />
        <asp:Parameter Name="ForTransfer" Type="Boolean" />
    </UpdateParameters>
</asp:SqlDataSource>
<h2>Eligibility</h2>
<telerik:RadGrid ID="rgEligibility" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlEligibility" Width="100%" AllowAutomaticUpdates="true">
    <GroupingSettings CaseSensitive="false" />
    <MasterTableView AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="sqlEligibility" CommandItemDisplay="Top" EditMode="Batch" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true">
        <NoRecordsTemplate>
            <p>No records to display</p>
        </NoRecordsTemplate>
        <BatchEditingSettings EditType="Cell" />
        <Columns>
            <telerik:GridBoundColumn DataField="id" HeaderText="ID" UniqueName="id" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridTemplateColumn DataField="ForAssociateOnly" DataType="System.Boolean" HeaderText="For Associate Only" UniqueName="ForAssociateOnly" HeaderStyle-Width="110px" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="CheckBox1" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("ForAssociateOnly")) %>' onclick="checkBoxClick(this, event);" />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="CheckBox2" />
                </EditItemTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridTemplateColumn DataField="ForTransfer" DataType="System.Boolean" HeaderText="For Transfer" UniqueName="ForTransfer" HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="CheckBox3" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("ForTransfer")) %>' onclick="checkBoxClick(this, event);" />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox runat="server" ID="CheckBox4" />
                </EditItemTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="Ace ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="TeamRevd" HeaderText="Team Revd" DataField="TeamRevd" UniqueName="TeamRevd" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" DataFormatString="{0:MM/dd/yyyy}">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" DataFormatString="{0:MM/dd/yyyy}">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="OccupationTitle" HeaderText="Title" DataField="OccupationTitle" UniqueName="OccupationTitle" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px">
            </telerik:GridBoundColumn>
        </Columns>
    </MasterTableView>
</telerik:RadGrid>
<telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    <script>
        function checkBoxClick(sender, args) {
            var grid = $find("<%= rgEligibility.ClientID %>");
            var masterTableView = grid.get_masterTableView();
            var batchEditingManager = grid.get_batchEditingManager();
            var parentCell = $telerik.$(sender).closest("td")[0];

            var initialValue = sender.checked;
            sender.checked = !sender.checked;

            batchEditingManager.changeCellValue(parentCell, initialValue);
        } 
    </script>
</telerik:RadCodeBlock>         
