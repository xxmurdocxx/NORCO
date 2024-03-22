<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Submit.aspx.cs" Inherits="ems_app.modules.popups.Submit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Submit / Return Articulation</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlPreviousStages" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"  SelectCommand="GetPreviousStages" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                <asp:ControlParameter Name="StageId" ControlID="hfCurrentStageID" PropertyName="Value" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div style="padding: 15px !important;">
                <div class="row">
                    <div class="col-md-8 col-sm-8 col-xs-12">
                        <asp:HiddenField ID="hfCurrentStageID" runat="server"></asp:HiddenField>
                            <asp:Panel ID="pnlPrevious" runat="server" Visible="False">
                                <br />
                                <telerik:RadComboBox ID="rcbPreviousStage" runat="server" Culture="es-ES" DataSourceID="sqlPreviousStages" DataTextField="RoleName" DataValueField="id" Label="Select Previous Stage : " Text="Select Previous Stage : " Width="300px">
                                </telerik:RadComboBox>
                                <br />
                                <br />
                            </asp:Panel>
                            <p>Please provide any additional information (notes) that you wish to attach. These notes will be visible on the audit trail. When you have finished, click 'Submit'.</p>
                            <br />
                            <telerik:RadEditor  runat="server" ID="reAdditionalInfo" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="200px" Width="95%"  RenderMode="Lightweight">
                                <Tools>
                                    <telerik:EditorToolGroup Tag="Formatting">
                                        <telerik:EditorTool Name="Bold" />
                                    </telerik:EditorToolGroup>
                                </Tools>
                                <Content>
                                </Content>
                                <TrackChangesSettings CanAcceptTrackChanges="False" />
                            </telerik:RadEditor>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="reAdditionalInfo" Text="* Additional information is required." CssClass="alert alert-warning"></asp:RequiredFieldValidator>                            
                    </div>
                    <div class="col-md-4 col-sm-4 col-xs-12">
                        <div class="row">
                            <div class="col-xs-12 text-center">
                                <telerik:RadButton RenderMode="Lightweight" ID="rbSubmit" runat="server" Text="Submit Articulation" Height="70px" OnClick="rbSubmit_Click">
                                        <Icon PrimaryIconCssClass="rbSave"></Icon>
                                </telerik:RadButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
</body>
</html>


