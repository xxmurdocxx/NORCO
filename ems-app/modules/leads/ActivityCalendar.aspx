<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="ActivityCalendar.aspx.cs" Inherits="ems_app.modules.leads.ActivityCalendar" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Activity Calendar</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlActivities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select la.*, v.FirstName + ', ' + v.LastName Veteran, v.id VeteranId, at.Description + ' - ' + a.Description Subject  from LeadAction la join VeteranLead vl on la.LeadID = vl.ID join ActionType at on la.ActionType = at.ID join Action a on la.ActionID = a.ID join Veteran v on vl.VeteranID = v.id where a.CollegeID =  @CollegeID">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <div class="container-fluid">
        <telerik:RadScheduler ID="rsActivities" runat="server" Culture="en-US" DataEndField="DueDate" DataKeyField="ID" DataSourceID="sqlActivities" DataStartField="DueDate"  DataSubjectField="Subject" DataDescriptionField="Description" DisplayRecurrenceActionDialogOnMove="false" EnableCustomAttributeEditing="True" EnableExactTimeRendering="True" Height="600px" AllowInsert="false" AllowEdit="false" AllowDelete="false" SelectedView="MonthView" MonthView-AdaptiveRowHeight="true" TimelineView-UserSelectable="false" AgendaView-UserSelectable="true" AppointmentStyleMode="Default" Width="100%" AdvancedForm-Modal="true" >
            <AppointmentTemplate>
                <div>
                    <p class="boldText">
                        <%# Eval("Subject") %>
                    </p>
                    <%# Eval("Description") %>
                </div>
            </AppointmentTemplate>
        </telerik:RadScheduler>
        </div>
    </telerik:RadAjaxPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
