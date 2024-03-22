<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Campaign.aspx.cs" Inherits="ems_app.modules.popups.Campaign" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Campaign</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
    <style>
        .courseDetails {
            height: 390px !important;
        }
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlSemesters" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from Semesters order by semester desc" />
        <asp:SqlDataSource ID="sqlCampaignStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from CampaignStatus" />
        <asp:SqlDataSource ID="sqlStates" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct State  from City order by State" />
        <asp:SqlDataSource ID="sqlCitiesByState" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from City where [state] = @State order by State, City">
            <SelectParameters>
                <asp:ControlParameter ControlID="rcbStates" Name="State" PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCampaignCities" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select cc.id, c.City, c.State from CampaignCities cc join City c on cc.CityId = c.Id where cc.CampaignId = @CampaignID order by City" DeleteCommand="Delete from CampaignCities WHERE [Id] = @Id">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfId" Name="CampaignID" PropertyName="Value" Type="Int32"></asp:ControlParameter>
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="Id" Type="Int32" />
        </DeleteParameters>
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
                    <div class="col-md-10 col-sm-10 col-xs-12">
                        <div class="row">
                            <div class="col-xs-2">
                                <asp:HiddenField ID="hfId" runat="server" />
                                <label>Campaign : </label>
                            </div>
                            <div class="col-xs-10">
                                <telerik:RadTextBox RenderMode="Lightweight" ID="rtbDescription" runat="server" Width="100%"></telerik:RadTextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="rtbDescription" Text="* Description is required." CssClass="alert alert-warning"></asp:RequiredFieldValidator>
                            </div>
                            <div class="clearfix"></div>
                            <div class="col-xs-2">
                                <label>Cities : </label>
                            </div>
                            <div class="col-xs-10">
                                <div class="row">
                                    <div class="col-xs-12">
                                        <label>State : </label>
                                        <telerik:RadComboBox RenderMode="Lightweight" ID="rcbStates" runat="server" Width="150px" DropDownWidth="150px" Height="150px" DataSourceID="sqlStates" DataValueField="State" DataTextField="State" AutoPostBack="true" CausesValidation="false" EmptyMessage="Select a state..." DropDownAutoWidth="Enabled">
                                        </telerik:RadComboBox>
                                        <label> City : </label>
                                        <telerik:RadComboBox RenderMode="Lightweight" ID="rcbCities" runat="server" Width="150px" DropDownWidth="150px" Height="150px" DataSourceID="sqlCitiesByState" DataValueField="Id" DataTextField="City" AutoPostBack="true" CausesValidation="false" EmptyMessage="Select a city..." DropDownAutoWidth="Enabled">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="rcbCities" Text="* City is required." CssClass="alert alert-warning" ValidationGroup="city"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-xs-12">
                                        <telerik:RadGrid ID="rgCampaignCities" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" DataSourceID="sqlCampaignCities" AllowFilteringByColumn="false" AllowPaging="false" RenderMode="Lightweight">
                                            <ClientSettings>
                                                <Selecting AllowRowSelect="true"></Selecting>
                                            </ClientSettings>
                                            <MasterTableView DataSourceID="sqlCampaignCities" DataKeyNames="ID" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false">
                                                <Columns>
                                                    <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="City" UniqueName="City" HeaderText="City" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="State" UniqueName="State" HeaderText="State" HeaderStyle-Font-Bold="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this City ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </telerik:GridTemplateColumn>
                                                </Columns>
                                            </MasterTableView>
                                        </telerik:RadGrid>
                                    </div>
                                </div>
                                </div>
                                <div class="clearfix"></div>
                                <div class="col-xs-2">
                                    <label>Status : </label>
                                </div>
                                <div class="col-xs-10">
                                    <telerik:RadComboBox RenderMode="Lightweight" ID="rcbStatus" runat="server" Width="150px" DropDownWidth="150px" Height="80px" DataSourceID="sqlCampaignStatus" DataValueField="id" DataTextField="description">
                                    </telerik:RadComboBox>
                                </div>
                                <div class="clearfix"></div>
                                <div class="col-xs-2">
                                    <label>Semester : </label>
                                </div>
                                <div class="col-xs-10">
                                    <telerik:RadComboBox RenderMode="Lightweight" ID="rcbSemester" runat="server" Width="150px" DropDownWidth="150px" Height="80px" DataSourceID="sqlSemesters" DataValueField="id" DataTextField="SemesterName" DropDownAutoWidth="Enabled">
                                    </telerik:RadComboBox>
                                </div>
                                <div class="clearfix"></div>
                                <div class="col-xs-2">
                                    <label>Notes :</label>
                                </div>
                                <div class="col-xs-10">
                                    <telerik:RadEditor runat="server" ID="reNotes" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="100px" Width="99%" RenderMode="Lightweight">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="Bold" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                        <TrackChangesSettings CanAcceptTrackChanges="False" />
                                    </telerik:RadEditor>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                        </div>
                        <div class="col-md-2 col-sm-2 col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 text-center">
                                    <telerik:RadButton RenderMode="Lightweight" ID="rbAddUpdate" runat="server" Text="Save" OnClick="rbAddUpdate_Click">
                                        <Icon PrimaryIconCssClass="rbSave"></Icon>
                                    </telerik:RadButton>
                                </div>
                                <div class="col-xs-12  text-center">
                                    <br />
                                    <telerik:RadButton RenderMode="Lightweight" ID="rbDelete" runat="server" Text="Delete" OnClick="rbDelete_Click" Visible="false">
                                        <Icon PrimaryIconCssClass="rbRemove"></Icon>
                                    </telerik:RadButton>
                                        <telerik:RadButton runat="server" ID="btnAddCity" Text="Add City" ButtonType="LinkButton" ValidationGroup="city" OnClick="btnAddCity_Click">
                                            <Icon PrimaryIconCssClass="rbAdd"></Icon>
                                        </telerik:RadButton>
                                </div>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>

    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>

    <script>

        function GetRadWindow() {

            var oWindow = null;

            if (window.radWindow)

                oWindow = window.radWindow;

            else if (window.frameElement && window.frameElement.radWindow)

                oWindow = window.frameElement.radWindow;

            return oWindow;

        }

        function CloseModal() {

            // GetRadWindow().close();

            setTimeout(function () {

                GetRadWindow().close();

                top.location.href = top.location.href;

            }, 0);

        }

    </script>
</body>
</html>



