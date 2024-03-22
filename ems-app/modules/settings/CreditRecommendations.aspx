<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreditRecommendations.aspx.cs" Inherits="ems_app.modules.settings.CreditRecommendations" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Manage Credit Recommendations</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous" />
    <!-- Font Awesome -->
    <script src="https://use.fontawesome.com/6c4529ef90.js"></script>
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div class="row" style="padding: 20px;">
                <div class="row">
                    <asp:SqlDataSource ID="sqlExhibits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM ACEExhibit WHERE trim(AceID) = trim(@AceID) AND AceType = @AceType AND cast(TeamRevd as date) = cast(@TeamRevd as date) AND cast(StartDate as date) = cast(@StartDate as date) AND cast(EndDate as date) = cast(@EndDate as date)">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="AceID" QueryStringField="AceID" Type="String" />
                            <asp:QueryStringParameter Name="AceType" QueryStringField="AceType" Type="Int32" />
                            <asp:QueryStringParameter Name="TeamRevd" QueryStringField="TeamRevd" Type="DateTime" />
                            <asp:QueryStringParameter Name="StartDate" QueryStringField="StartDate" Type="DateTime" />
                            <asp:QueryStringParameter Name="EndDate" QueryStringField="EndDate" Type="DateTime" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="sqlArticulationType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 1 as id, 'Course' as description union select 2 as id , 'Occupation' as description"></asp:SqlDataSource>
                    <asp:SqlDataSource ID="sqlCreditRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM ACEExhibitCriteria WHERE trim(AceID) = trim(@AceID) AND AceType = @AceType AND cast(TeamRevd as date) = cast(@TeamRevd as date) AND cast(StartDate as date) = cast(@StartDate as date) AND cast(EndDate as date) = cast(@EndDate as date)" InsertCommand="INSERT INTO [dbo].[ACEExhibitCriteria] ([AceID] ,[AceType] ,[StartDate] ,[EndDate] ,[TeamRevd] ,[Criteria] ,[ImportedOn] ,[CriteriaDescription] ,[SourceID]) VALUES (@AceID ,@AceType ,@StartDate ,@EndDate ,@TeamRevd ,@Criteria ,GETDATE() ,@CriteriaDescription ,@SourceID)" InsertCommandType="Text" UpdateCommand="UPDATE [dbo].[ACEExhibitCriteria]  SET [Criteria] = @Criteria, [CriteriaDescription] = @CriteriaDescription ,[SourceID] = @SourceID WHERE CriteriaID = @CriteriaID" UpdateCommandType="Text">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="AceID" QueryStringField="AceID" Type="String" />
                            <asp:QueryStringParameter Name="AceType" QueryStringField="AceType" Type="Int32" />
                            <asp:QueryStringParameter Name="TeamRevd" QueryStringField="TeamRevd" Type="DateTime" />
                            <asp:QueryStringParameter Name="StartDate" QueryStringField="StartDate" Type="DateTime" />
                            <asp:QueryStringParameter Name="EndDate" QueryStringField="EndDate" Type="DateTime" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="CriteriaID" Type="Int32" />
                            <asp:Parameter Name="Criteria" Type="String" />
                            <asp:Parameter Name="CriteriaDescription" Type="String" />
                        </UpdateParameters>
                        <InsertParameters>
                            <asp:QueryStringParameter Name="AceID" QueryStringField="AceID" Type="String" />
                            <asp:QueryStringParameter Name="AceType" QueryStringField="AceType" Type="Int32" />
                            <asp:QueryStringParameter Name="TeamRevd" QueryStringField="TeamRevd" Type="DateTime" />
                            <asp:QueryStringParameter Name="StartDate" QueryStringField="StartDate" Type="DateTime" />
                            <asp:QueryStringParameter Name="EndDate" QueryStringField="EndDate" Type="DateTime" />
                            <asp:Parameter Name="Criteria" Type="String" />
                            <asp:Parameter Name="CriteriaDescription" Type="String" />
                            <asp:Parameter Name="SourceID" Type="Int32" />
                        </InsertParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="sqlSource" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand=" select * from ACEExhibitSource"></asp:SqlDataSource>
                    <h2 style="margin: 10px 0px 10px 0;">Exhibit</h2>
                    <telerik:RadGrid ID="rgExhibits" runat="server" CellSpacing="-1" DataSourceID="sqlExhibits" AllowFilteringByColumn="False" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%">
                        <ExportSettings ExportOnlyData="true" FileName="Exhibits" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
                        </ExportSettings>
                        <GroupingSettings CaseSensitive="false" />
                        <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="False" EnableDragToSelectRows="false"></Selecting>
                        </ClientSettings>
                        <MasterTableView DataSourceID="sqlExhibits" DataKeyNames="ID" CommandItemDisplay="None" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Font-Bold="true">
                            <CommandItemSettings ShowExportToExcelButton="true" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                            <Columns>
                                <telerik:GridBoundColumn DataField="CriteriaID" UniqueName="CriteriaID" Display="false" ReadOnly="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="Exhibit ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" HeaderStyle-Width="100px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn SortExpression="VersionNumber" HeaderText="Version" DataField="VersionNumber" UniqueName="VersionNumber" AllowFiltering="false" HeaderStyle-Width="60px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="AceType" FilterControlAltText="Filter AceType column" HeaderText="Type" SortExpression="AceType" UniqueName="AceType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" EnableHeaderContextMenu="false" HeaderStyle-HorizontalAlign="Center">
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableHeaderContextMenu="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridDateTimeColumn DataField="StartDate" DataType="System.DateTime" FilterControlAltText="Filter StartDate column" HeaderText="StartDate Date" SortExpression="StartDate" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableHeaderContextMenu="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridDateTimeColumn DataField="EndDate" DataType="System.DateTime" FilterControlAltText="Filter EndDate column" HeaderText="EndDate Date" SortExpression="EndDate" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableHeaderContextMenu="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                </telerik:GridDateTimeColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                    <br />
                    <h2 style="margin: 10px 0;">Credit Recommendations</h2>
                    <asp:Panel ID="pnlAddCreditRecommendations" runat="server">
                    <div class="row">
                        <div class="col-1">
                            <telerik:RadLabel ID="rlAddCourses" runat="server" Text="College Course(s) : "></telerik:RadLabel>
                        </div>
                        <div class="col-9">
                            <telerik:RadWindow ID="modalPopup" runat="server" Width="600px" Height="360px" Modal="true">
                                <ContentTemplate>
                                    <div class="row">
                                        <div style="width:600px;margin:0 auto;">
                                            <br />
                                            <br />
                                            <h3>Credit recommendation to be added : </h3>
                                            <br />
                                            <br />
                                            <asp:Literal ID="ltSelectedCourse" runat="server"></asp:Literal>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-6 text-center">
                                            <telerik:RadButton ID="rbAddCreditRecommendations" runat="server" Text="Submit" ToolTip="Click here to create the credit recommendations" Width="100px" Primary="true" OnClick="rbAddCreditRecommendations_Click" AutoPostBack="true"></telerik:RadButton>
                                        </div>
                                        <div class="col-6 text-center">
                                            <telerik:RadButton ID="rbClose" runat="server" Text="Go Back" ToolTip="" Width="100px" Primary="false" OnClientClicked="closeAddCrediRecommendations"></telerik:RadButton>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </telerik:RadWindow>
                            <telerik:RadComboBox ID="rcbCourses" DataSourceID="sqlCourses" DataTextField="CourseDescription" DataValueField="outline_id" MaxHeight="200px" Width="100%" AppendDataBoundItems="true" EmptyMessage="Please enter keyword to select course(s) (Multiple courses can be selected)." ToolTip="Search for a college course you wish to select. " runat="server" MarkFirstMatch="true" Filter="Contains" DropDownAutoWidth="Enabled" CheckBoxes="true" CheckedItemsTexts="FitInInput" BackColor="#ffffe0" CssClass="RadComboBoxCourses">
                                <Items>
                                    <telerik:RadComboBoxItem Text="" Value="" />
                                </Items>
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="rfCourse" runat="server" ControlToValidate="rcbCourses" Display="Dynamic" ValidationGroup="AddCourses" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:SqlDataSource runat="server" ID="sqlCourses" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="sp_SearchCourses" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" DbType="Int32" />
                                    <asp:Parameter Name="CourseType" DbType="Int32" DefaultValue="1" />
                                    <asp:Parameter Name="All" DbType="Int32" DefaultValue="1" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                        <div class="col-2">
                            <telerik:RadButton ID="rbAddCourses" runat="server" Text="Add" ToolTip="Click here to create the credit recommendations" Width="70px" Primary="true" OnClick="rbAddCourses_Click" CausesValidation="true" ValidationGroup="AddCourses" AutoPostBack="true"></telerik:RadButton>
                            <telerik:RadButton ID="rbClear" runat="server" Text="Clear" ToolTip="Click here to clear the selected course(s)" Width="70px" Primary="false" OnClick="rbClear_Click" AutoPostBack="true"></telerik:RadButton>
                        </div>
                    </div>
                    </asp:Panel>

                    <telerik:RadGrid ID="rgCreditRecommendations" runat="server" CellSpacing="-1" DataSourceID="sqlCreditRecommendations" AllowFilteringByColumn="False" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemCommand="rgCreditRecommendations_ItemCommand" OnItemDataBound="rgCreditRecommendations_ItemDataBound">
                        <ExportSettings ExportOnlyData="true" FileName="CreditRecommandations" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
                        </ExportSettings>
                        <GroupingSettings CaseSensitive="false" />
                        <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                        </ClientSettings>
                        <MasterTableView DataSourceID="sqlCreditRecommendations" DataKeyNames="CriteriaID" CommandItemDisplay="Top" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Font-Bold="true" CommandItemSettings-SaveChangesText="Save" EditFormSettings-EditColumn-EditText="Save" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true">
                            <CommandItemSettings ShowExportToExcelButton="true" ShowAddNewRecordButton="true" ShowRefreshButton="false" />
                            <Columns>
                                <telerik:GridBoundColumn DataField="CriteriaID" UniqueName="CriteriaID" Display="false" ReadOnly="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridDropDownColumn DataField="SourceID" FilterControlAltText="Filter SourceID column" HeaderText="Source" SortExpression="SourceID" UniqueName="SourceID" DataSourceID="sqlSource" ListTextField="ShortDescription" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" EnableHeaderContextMenu="false" HeaderStyle-HorizontalAlign="Center">
                                    <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                        <RequiredFieldValidator ForeColor="Red" Text="*This field is required" Display="Dynamic" />
                                    </ColumnValidationSettings>
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnEditorID="CECriteria">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn SortExpression="CriteriaDescription" HeaderText="Category" DataField="CriteriaDescription" UniqueName="CriteriaDescription" AllowFiltering="false" HeaderStyle-Width="400px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnEditorID="CECriteria">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn SortExpression="SkillLevel" HeaderText="Skill Level" DataField="SkillLevel" UniqueName="SkillLevel" AllowFiltering="false" HeaderStyle-Width="400px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ReadOnly="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit">
                                </telerik:GridEditCommandColumn>
                                <telerik:GridButtonColumn ButtonType="FontIconButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this credit recommendation ?" ConfirmTitle="Delete" HeaderStyle-Width="50px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                    <HeaderStyle Width="50px" />
                                </telerik:GridButtonColumn>
                            </Columns>
                            <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Credit Recommendation: {0}" CaptionDataField="Criteria" FormCaptionStyle-Font-Bold="true" PopUpSettings-ShowCaptionInEditForm="true" ColumnNumber="2" EditColumn-CancelText="Cancel" EditColumn-UpdateText="Update">
                                <PopUpSettings Height="300px" Modal="True" Width="800px" ScrollBars="None" KeepInScreenBounds="true" OverflowPosition="Center" />
                            </EditFormSettings>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
            </div>
            <telerik:GridTextBoxColumnEditor ID="CECriteria" TextBoxStyle-Width="550px" TextBoxMaxLength="200" runat="server" />
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="0" Width="350" Height="110" Title="Notification" EnableRoundedCorners="false">
            </telerik:RadNotification>
            <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server">
            </telerik:RadWindowManager>
            <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager2" runat="server">
            </telerik:RadWindowManager>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <!-- jQuery -->
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <!-- Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj" crossorigin="anonymous"></script>
    <!-- Custom Theme Scripts -->
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
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
        function showWindow() {
            var win = $find("<%=modalPopup.ClientID %>");
            win.Show();
        }
        function closeAddCrediRecommendations() {
            $find("<%=modalPopup.ClientID %>").close();
        }
    </script>
</body>
</html>
