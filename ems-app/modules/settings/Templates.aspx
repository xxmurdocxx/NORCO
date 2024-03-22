<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Templates.aspx.cs" Inherits="ems_app.modules.settings.Templates" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Communication Templates</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlTemplates" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [Templates] WHERE [ID] = @ID" InsertCommand="INSERT INTO [Templates] ([Description], [CreatedBy], [CollegeId]) VALUES (@Description, @CreatedBy,  @CollegeId)" SelectCommand="SELECT * FROM [Templates] WHERE ([CollegeId] = @CollegeId) ORDER BY [Description]">
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:SessionParameter Name="CreatedBy" SessionField="UserID" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter Name="CollegeId" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="280px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <div class="container-fluid">
            <div class="row" style="margin: 0 0 10px 0;">
                <div class="col-md-12">
                    <telerik:RadGrid ID="rgTemplates" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" DataSourceID="sqlTemplates" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemCommand="rgTemplates_ItemCommand">
                        <ClientSettings AllowKeyboardNavigation="true">
                            <ClientEvents OnPopUpShowing="popUpShowing" />
                            <Selecting AllowRowSelect="true"></Selecting>
                        </ClientSettings>
                        <MasterTableView Name="ParentGrid" DataSourceID="sqlTemplates" PageSize="12" DataKeyNames="ID" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="true" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save" CommandItemSettings-AddNewRecordText="Add new Template">
                            <Columns>
                                <telerik:GridTemplateColumn HeaderStyle-Width="40px" AllowFiltering="false">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ToolTip="Edit this template." CommandName="EditTemplate" ID="btnEditTemplate" Text='<i class="fa fa-tasks" aria-hidden="true"></i>' />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Description" UniqueName="Description" HeaderText="Description" HeaderStyle-Font-Bold="true" ColumnEditorID="CEDescription">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="TypeID" UniqueName="TypeID" HeaderText="Type">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this Template ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>
                            <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Template: {0}" CaptionDataField="Description">
                                <PopUpSettings Height="450px" Modal="True" Width="600px" />
                            </EditFormSettings>
                        </MasterTableView>
                    </telerik:RadGrid>
                    <telerik:GridTextBoxColumnEditor ID="CEDescription" TextBoxStyle-Width="500px" TextBoxMaxLength="200" runat="server" />
                </div>
            </div>
        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
