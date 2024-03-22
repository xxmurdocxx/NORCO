<%@ Page Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="ems_app.modules.settings.Courses" %>
<%@ Register Src="~/UserControls/CourseEdit.ascx" TagPrefix="uc" TagName="CourseEdit" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" id="SystemTitle" runat="server">Manage Courses</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <p class="h2">Manage Courses</p>
    <uc:CourseEdit runat="server" id="ucCourseEdit"></uc:CourseEdit>
</asp:Content>