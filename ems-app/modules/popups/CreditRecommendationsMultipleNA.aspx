<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreditRecommendationsMultipleNA.aspx.cs" Inherits="ems_app.modules.popups.ShowCreditRecomendation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
    <style>
        .RadWindow_Material .rwTitleBar .rwTitleWrapper {
            display: none !important;
        }
    </style>
</head>
<body style="background-color: #fff;">
    <div style="padding: 15px !important;">
        <form id="form1" runat="server">
            <asp:HiddenField ID="hfVeteranID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hfVeteranCreditRecommendationID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hfAceID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hfCreditRecommendation" runat="server" ClientIDMode="Static" />
            <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
            <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
                <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager3" runat="server" DestroyOnClose="true" EnableViewState="false" EnableShadow="true" InitialBehaviors="Close">
                </telerik:RadWindowManager>
                <%--                <telerik:RadWindow RenderMode="Lightweight" ID="modalAlert" runat="server" Width="360px" Height="365px" Modal="true" OffsetElementID="main" Style="z-index: 100001;">
                    <ContentTemplate>
                        <div style="padding: 10px; text-align: center;">
                            <telerik:RadButton RenderMode="Lightweight" ID="rbToggleModality" Text="Toggle modality" OnClientClicked="togglePopupModality"
                                AutoPostBack="false" runat="server" Height="65px" />
                        </div>
                        <p style="text-align: center;">
                            RadWindow is designed with keyboard support in mind - try tabbing
                                before and after removing the modal background. While the popup is modal
                                you cannot focus the text area, once the modality is removed the text area will
                                be the first thing to receive focus because it has tabIndex=1.
                        </p>
                    </ContentTemplate>
                </telerik:RadWindow>--%>
                <div class="row">
                    <div class="col-md-9">
                        <h3></h3>
                    </div>
                    <div class="col-md-3" style="display: flex; justify-content: right; padding-right: 5px;">
                        <asp:Button ID="btnAddNA" runat="server" Text="Save" CssClass="btn" Width="100px" OnClick="btnAddNA_Click" BackColor="#203864" ForeColor="White" ToolTip="This feature will SET the selected credit recommendations to NA. Not Selected credit recommendations will NOT be set to NA." />
                    </div>
                </div>
                <asp:SqlDataSource ID="sqlSearchNA" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                    SelectCommand="GetSearchNA" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
                        <asp:ControlParameter ControlID="hfVeteranCreditRecommendationID" PropertyName="Value" Name="CriteriaID" Type="Int32" />
                        <asp:ControlParameter ControlID="hfAceID" PropertyName="Value" Name="AceID" Type="String" />
                        <asp:ControlParameter ControlID="hfCreditRecommendation" PropertyName="Value" Name="CreditRecommendation" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <div class="row">
                    <div class="col-md-12">
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                            SelectCommand="GetSearchNA" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
                                <asp:ControlParameter ControlID="hfVeteranCreditRecommendationID" PropertyName="Value" Name="CriteriaID" Type="Int32" />


                            </SelectParameters>
                        </asp:SqlDataSource>
                        <telerik:RadGrid ID="radGroupNA" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="sqlSearchNA" OnItemDataBound="radGroupNA_ItemDataBound" Height="450px">
                            <ClientSettings AllowKeyboardNavigation="true">
                                <Selecting AllowRowSelect="true"></Selecting>
                                <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                                <ClientEvents />
                            </ClientSettings>
                            <MasterTableView Name="ParentGrid" DataSourceID="sqlSearchNA" PageSize="12" DataKeyNames="ID" AllowMultiColumnSorting="true">
                                <Columns>
                                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn DataField="DNA" UniqueName="DNA" HeaderStyle-Width="30px">
                                        <HeaderTemplate>
                                            <asp:CheckBox runat="server" ID="chkSelectAll" onclick="toggleSelectAll(this);" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox runat="server" ID="chkBoolean" Enabled="true" Checked='<%# Eval("DNA") %>' />
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn SortExpression="CreditRecommendation" DataField="CreditRecommendation" UniqueName="CreditRecommendation" Display="true" HeaderText="Credit Recommendation" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="AceID" DataField="AceID" UniqueName="AceID" Display="true" HeaderText="Exhibit ID" HeaderStyle-Width="120px" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn HeaderText="Course" UniqueName="Description">
                                        <ItemTemplate>
                                            <table>
                                                <tr>
                                                    <td style="padding: 5px;"><%# Eval("Course") %></td>
                                                </tr>
                                            </table>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn SortExpression="CreditType" DataField="CreditType" UniqueName="CreditType" Display="true" HeaderText="Type " ReadOnly="true" HeaderStyle-Width="100px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="RoleName" DataField="RoleName" UniqueName="RoleName" Display="true" HeaderText="Stage" ReadOnly="true" HeaderStyle-Width="100px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="MilitaryCourseNumber" DataField="MilitaryCourseNumber" UniqueName="MilitaryCourseNumber" Display="true" HeaderText="Exhibit Course Number" ReadOnly="true" HeaderStyle-Width="110px">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="CourseVersion" DataField="CourseVersion" UniqueName="CourseVersion" Display="true" HeaderText="Course Version" HeaderStyle-Width="70px" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
                </div>
            </telerik:RadAjaxPanel>
            <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
        </form>
    </div>
    <script>
        function alertCallBackFn(arg) {
        }

        function toggleSelectAll(chkBox) {
            var grid = $find('<%= radGroupNA.ClientID %>'); // get the client-side RadGrid object
            var masterTableView = grid.get_masterTableView();
            var rows = masterTableView.get_dataItems();

            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var rowCheckBox = row.findElement("chkBoolean");
                if (chkBox.checked) {
                    rowCheckBox.checked = true;
                } else {
                    rowCheckBox.checked = false;
                }
            }
        }

        function onRadAlertClose(arg) {
            if (arg) { // If 'OK' is clicked on the alert
                // Close the popup
                GetRadWindow().close();

                // Refresh the parent page
                GetRadWindow().BrowserWindow.location.reload();
            }
        }

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow;
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow;
            return oWindow;
        }
    </script>
</body>
</html>
