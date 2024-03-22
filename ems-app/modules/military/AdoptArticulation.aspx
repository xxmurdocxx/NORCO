<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="AdoptArticulation.aspx.cs" Inherits="ems_app.modules.military.AdoptArticulation" %>

<%@ Register Src="~/UserControls/AdoptCreditRecommendation.ascx" TagPrefix="uc1" TagName="AdoptCreditRecommendation" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
   <%-- <p class="h2" runat="server">Adopt Articulations</p>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:AdoptCreditRecommendation runat="server" id="AdoptCreditRecommendation" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
