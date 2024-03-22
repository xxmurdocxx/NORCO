<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="NoAccess.aspx.cs" Inherits="ems_app.modules.security.NoAccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- page content -->
    <div class="col-md-12">
        <div class="col-middle">
            <div class="text-center text-center">
                <h1 class="error-number">403</h1>
                <h2>Access denied</h2>
                <p>
                    Sorry your role is not configured for this feature, If you need access to this feature, Please contact the system administrator.
                </p>
                <p>
                    To cantact the system administrator to request this feature , click on the Request Access button bellow.
                </p>
                <p>
                    <asp:LinkButton runat="server" ID="btnRequestAccess" CssClass="btn btn-default submit" Text="<i class='fa fa-send'></i> Request Access" OnClick="btnRequestAccess_Click" ValidationGroup="UserData" /> 
                </p>
                <p>
                    <asp:Label ID="lblUserMessage" runat="server" Visible="false" />
                </p>
            </div>
        </div>
    </div>
    <!-- /page content -->
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
