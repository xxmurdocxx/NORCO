<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UploadVeterans.aspx.cs" Inherits="ems_app.modules.popups.UploadVeterans" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
</head>
<body style="background-color: #fff !important;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlCampaigns" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from Campaign where [CollegeID] = @CollegeID order by Description">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server" AsyncPostBackTimeout="6000"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="280px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="TopRight" Animation="Fade" HideEvent="Default" ManualClose="true">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h3>Upload Veterans</h3>
                    </div>
                </div>
                <div class="row" style="margin: 0 0 10px 0;">
                    <div class="col-md-4">
                        <telerik:RadComboBox Label="Campaign(s) : " ID="rcbCampaigns" runat="server" DataSourceID="sqlCampaigns" DataTextField="description" DataValueField="id" Width="100%">
                        </telerik:RadComboBox>
                    </div>
                    <div class="col-md-1">
                        Upload CSV: 
                    </div>
                    <div class="col-md-3">
                        <telerik:RadAsyncUpload ID="rauUploadFile" runat="server" MaxFileInputsCount="1" MaxFileSize="10524288" InputSize="1" AllowedFileExtensions="csv" MultipleFileSelection="Disabled"></telerik:RadAsyncUpload>
                    </div>
                    <div class="col-md-2">
                        <telerik:RadButton RenderMode="Lightweight" ID="rbImport" runat="server" Text="Import CSV" OnClick="btnImport_Click">
                                <Icon PrimaryIconCssClass="rbUpload"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton RenderMode="Lightweight" ID="rbXml" runat="server" Text="XML" OnClick="rbXml_Click">
                                <Icon PrimaryIconCssClass="rbUpload"></Icon>
                        </telerik:RadButton>
                    </div>
                    <div class="col-md-2">
                        <telerik:RadButton RenderMode="Lightweight" ID="rbSave" runat="server" Text="Save Veterans" OnClick="btnSave_Click" >
                                <Icon PrimaryIconCssClass="rbSave"></Icon>
                        </telerik:RadButton>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <telerik:RadGrid ID="rgVeterans" runat="server" HeaderStyle-Font-Bold="true" AllowAutomaticDeletes="false"></telerik:RadGrid>
                    </div>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script type="text/javascript">
    function OnClientClicked(button, args)
    {
        window.radconfirm("Are you sure you want to save Vets to the selected Campaign?");
    }
</script>
</body>
</html>
