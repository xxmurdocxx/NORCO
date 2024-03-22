<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="CourseOutline.aspx.cs" Inherits="ems_app.modules.reports.CourseOutline" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Course Outline Reports</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadComboBox RenderMode="Lightweight" ID="rcbPrograms" AllowCustomText="true" runat="server" Width="100%" Height="400px"
            DataSourceID="sqlPrograms" DataValueField="program_id" DataTextField="program" EmptyMessage="Search for programs..." Filter="Contains" AutoPostBack="true" OnSelectedIndexChanged="rcbPrograms_SelectedIndexChanged">
        </telerik:RadComboBox>

    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
