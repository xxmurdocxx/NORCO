<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="VeteranManagement.aspx.cs" Inherits="ems_app.modules.military.VeteranManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Veterans Management</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlVeterans" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from Veteran  order by Lastname"></asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadGrid ID="rgVeterans" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlVeterans" Width="100%" GroupingSettings-CaseSensitive="false">
            <GroupingSettings CollapseAllTooltip="Collapse all groups" />
            <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                <ClientEvents OnRowDblClick="RowDblClickVeteran" OnPopUpShowing="popUpShowing"></ClientEvents>
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
            </ClientSettings>
            <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlVeterans" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="None">
                <Columns>
                    <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="FirstName" FilterControlAltText="Filter FirstName column" HeaderText="First Name" SortExpression="FirstName" UniqueName="FirstName" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="65px" HeaderStyle-Font-Bold="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="LastName" FilterControlAltText="Filter LastName column" HeaderText="Last Name" SortExpression="LastName" UniqueName="LastName" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" HeaderStyle-Font-Bold="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Birthdate" FilterControlAltText="Filter Birthdate column" HeaderText="Birth Date" SortExpression="Birthdate" UniqueName="Birthdate" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" HeaderStyle-Font-Bold="true" DataFormatString="{0:MM/dd/yyyy}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Department" UniqueName="Department" FilterControlAltText="Filter Department column" HeaderText="Department" SortExpression="Department" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="90px" HeaderStyle-Font-Bold="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Component" UniqueName="Component" FilterControlAltText="Filter Component column" HeaderText="Component" SortExpression="Component" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="90px" HeaderStyle-Font-Bold="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Branch" UniqueName="Branch" FilterControlAltText="Filter Branch column" HeaderText="Branch" SortExpression="Branch" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="90px" HeaderStyle-Font-Bold="true">
                    </telerik:GridBoundColumn>
                </Columns>
                <NoRecordsTemplate>
                    <div style="height: 30px; cursor: pointer; line-height: 30px;">
                        &nbsp;No items to view
                    </div>
                </NoRecordsTemplate>
            </MasterTableView>
        </telerik:RadGrid>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
