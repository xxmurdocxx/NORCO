<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AuditTrail.ascx.cs" Inherits="ems_app.UserControls.AuditTrail" %>
<asp:SqlDataSource ID="sqlAudit" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetAuditTrail" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="OutlineID" DbType="Int32" />
        <asp:Parameter Name="AceID" DbType="String" ConvertEmptyStringToNull="false" />
        <asp:Parameter Name="TeamRevd" DbType="String" ConvertEmptyStringToNull="false" />
        <asp:Parameter Name="CollegeID" DbType="Int32" />
        <asp:Parameter Name="UserID" DbType="Int32" />
        <asp:Parameter Name="StageID" DbType="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<telerik:RadGrid ID="rgAuditTrail" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlAudit" EnableHeaderContextMenu="True" Width="100%" AllowFilteringByColumn="true" OnPreRender="rgAuditTrail_PreRender">
    <GroupingSettings CollapseAllTooltip="Collapse all groups" />
    <ClientSettings>
        <ClientEvents OnFilterMenuShowing="FilteringMenu" />
    </ClientSettings>
    <MasterTableView DataSourceID="sqlAudit">
        <Columns>
            <telerik:GridBoundColumn DataField="Id" DataType="System.Int32" FilterControlAltText="Filter Id column" HeaderText="Id" ReadOnly="True" SortExpression="Id" UniqueName="Id" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="Course" FilterControlAltText="Filter Course column" AllowFiltering="true" HeaderText="Course" SortExpression="Course" UniqueName="Course" HeaderStyle-Font-Bold="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="ArticulationType" HeaderStyle-Width="100px" HeaderText="Type" DataField="ArticulationType" UniqueName="ArticulationType" HeaderStyle-Font-Bold="true" AllowFiltering="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="AceID" HeaderStyle-Width="150px" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true" AllowFiltering="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" HeaderText="Team Revd" HeaderStyle-Font-Bold="true" DataFormatString="{0:MM/dd/yyyy}" AllowFiltering="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Font-Bold="true" AllowFiltering="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="Event" FilterControlAltText="Filter Event column" HeaderText="Tracking Information" SortExpression="Event" UniqueName="Event" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Contains" FilterControlToolTip="Filter by tracking information (i.e. updated by ... implementation ... submitted...">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="College" UniqueName="College" HeaderText="College" HeaderStyle-Font-Bold="true"  AllowFiltering="false">
            </telerik:GridBoundColumn>
            <telerik:GridDateTimeColumn DataField="LogTime" DataType="System.DateTime" FilterControlAltText="Filter approv_date column" HeaderText="Tracking Date" SortExpression="LogTime" UniqueName="LogTime" DataFormatString="{0:MM/dd/yyyy hh:mm}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true">
                <ItemStyle HorizontalAlign="Center" />
            </telerik:GridDateTimeColumn>
            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
            </telerik:GridBoundColumn>
        </Columns>
    </MasterTableView>
</telerik:RadGrid>