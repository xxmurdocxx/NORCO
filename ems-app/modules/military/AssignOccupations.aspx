<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="AssignOccupations.aspx.cs" Inherits="ems_app.modules.military.AssignOccupations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Assign/Update Occupations to ACE Courses</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LookupService order by description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlACECourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, dbo.ACECourseHaveOccupations(AceID, TeamRevd) as 'HaveOccupations' from AceCourseCatalog where coalesce([ServiceID],'0') IN (select value from fn_split(@Service,',')) and ( dbo.ACECourseHaveOccupations(AceID, TeamRevd) = @Only OR @Only = '') order by Title, AceID, Exhibit" CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:Parameter DbType="String" Name="Service" />
            <asp:ControlParameter ControlID="rddlOnly" Name="Only" PropertyName="SelectedValue" Type="Int32" DefaultValue="" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlACECoursesSearch" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct cc.AceID, cc.Title, cc.teamrevd, cc.CourseNumber, cc.exhibit,  dbo.ACECourseHaveOccupations(cc.AceID, cc.TeamRevd) as 'HaveOccupations' from AceCatalogDetail cd inner join AceCourseCatalog cc on cd.AceID = cc.AceID and cd.teamrevd = cc.teamrevd where (cd.[CourseDetail] LIKE '%' + @rtbAttribute + '%' or  cc.[Title] LIKE '%' + @rtbAttribute + '%' or  cc.[CourseNumber] LIKE '%' + @rtbAttribute + '%') and coalesce(cc.[ServiceID],'0') IN (select value from fn_split(@Service,',')) and ( dbo.ACECourseHaveOccupations(cc.AceID, cc.TeamRevd) = @Only OR @Only = '') order by cc.Title">
        <SelectParameters>
            <asp:ControlParameter ControlID="rtbAttribute" Name="rtbAttribute" PropertyName="Text" Type="String" />
            <asp:Parameter DbType="String" Name="Service" />
            <asp:ControlParameter ControlID="rddlOnly" Name="Only" PropertyName="SelectedValue" Type="Int32" DefaultValue="" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ao.Occupation, ao.Occupation + ' - ' + ao.Title as Title from MostCurrentACEOccupation ao order by ao.Occupation">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlCourseOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM CourseOccupations WHERE [AceID] = @AceID and [TeamRevd] = @TeamRevd" DeleteCommand="DELETE FROM [CourseOccupations] WHERE [ID] = @ID" UpdateCommand="UPDATE [CourseOccupations] SET [OccupationID] = @OccupationID WHERE [ID] = @ID" InsertCommand="INSERT INTO [CourseOccupations] ([AceID],[TeamRevd],[OccupationID]) VALUES (@AceID, @TeamRevd, @OccupationID)">
        <SelectParameters>
            <asp:Parameter Name="AceID" Type="String" />
            <asp:Parameter Name="TeamRevd" Type="DateTime" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="AceID" Type="String" />
            <asp:Parameter Name="TeamRevd" Type="DateTime" />
            <asp:Parameter Name="OccupationID" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="ID" Type="Int32" />
            <asp:Parameter Name="OccupationID" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow"  EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000" RenderMode="Lightweight">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <div class="row">
            <div class="col-md-4">
                <label style="font-weight:bold; padding:5px;">Courses by Service(s) : </label>
                <telerik:RadComboBox ID="rcbServices" runat="server" DataSourceID="sqlServices" DataTextField="description" DataValueField="id" AutoPostBack="true" CheckBoxes="true" Width="200px" AppendDataBoundItems="true" EnableCheckAllItemsCheckBox="true" OnPreRender="rcbServices_PreRender" OnSelectedIndexChanged="rcbServices_SelectedIndexChanged" RenderMode="Lightweight">
                </telerik:RadComboBox>
            </div>
            
            <div class="col-sm-3">
                <telerik:RadDropDownList runat="server" ID="rddlOnly" AutoPostBack="true" Width="100%"  RenderMode="Lightweight">
                    <Items>
                        <telerik:DropDownListItem Value="0" Text="All ACE Courses" />
                        <telerik:DropDownListItem Value="1" Text="ACE Courses with assigned occupations" />
                    </Items>
                </telerik:RadDropDownList>
            </div>
            <div class="col-sm-3">
                <label><strong>Advanced Search :</strong> </label>
                <telerik:RadTextBox ID="rtbAttribute" Width="150px" runat="server" OnTextChanged="rtbAttribute_TextChanged" AutoPostBack="true"  RenderMode="Lightweight"></telerik:RadTextBox>
            </div>
            <div class="col-sm-2">
                <telerik:RadButton RenderMode="Lightweight" ID="rbSearchAttribute" runat="server" Text="Search" OnClick="rbSearchAttribute_Click" ToolTip="Search in either Course Number, ACE Title or Course Details">
                    <Icon PrimaryIconCssClass="rbSearch"></Icon>
                </telerik:RadButton>
                <telerik:RadButton RenderMode="Lightweight" ID="rbClearAttribute" runat="server" Text="Clear" OnClick="rbClearAttribute_Click">
                    <Icon PrimaryIconCssClass="rbCancel"></Icon>
                </telerik:RadButton>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <telerik:RadGrid ID="rgACECourses" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlACECourses" Width="100%" GroupingSettings-CaseSensitive="false" PageSize="14" OnItemDataBound="rgACECourses_ItemDataBound" RenderMode="Lightweight" OnItemCommand="rgACECourses_ItemCommand">
                    <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                    <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                    </ClientSettings>
                    <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlACECourses" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="None" Name="ParentGrid" EnableHierarchyExpandAll="true" DataKeyNames="AceID,TeamRevd"  AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                    <DetailTables>
                        <telerik:GridTableView Name="ChildGrid" DataKeyNames="ID" EnableHierarchyExpandAll="false" DataSourceID="sqlCourseOccupations" Width="100%" HierarchyDefaultExpanded="true" runat="server"  CommandItemDisplay="Top" AllowFilteringByColumn="false" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" AutoGenerateColumns="false" EditMode="Batch">
                            <BatchEditingSettings EditType="Cell" />
                            <ParentTableRelation>
                                <telerik:GridRelationFields DetailKeyField="AceID" MasterKeyField="AceID"></telerik:GridRelationFields>
                                <telerik:GridRelationFields DetailKeyField="TeamRevd" MasterKeyField="TeamRevd"></telerik:GridRelationFields>
                            </ParentTableRelation>
                            <Columns>
                                <telerik:GridDropDownColumn DataField="OccupationID" FilterControlAltText="Filter OccupationID column" HeaderText="Occupation" SortExpression="OccupationID" UniqueName="OccupationID" DataSourceID="sqlOccupations" ListTextField="Title" ListValueField="Occupation" HeaderStyle-Font-Bold="true" DropDownControlType="DropDownList" ColumnEditorID="ceOccupations"  EnableEmptyListItem="true" EmptyListItemText="Select an occupation and click on Save Changes...">
                                </telerik:GridDropDownColumn>
                                <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this occupation ?')){return false;}" runat="server"><i class='fa fa-trash' ></i></asp:LinkButton>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>
                        </telerik:GridTableView>
                    </DetailTables>
                        <Columns>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="25px" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ToolTip="View Course Details" CommandName="ViewCourseDetails" ID="btnViewCourseDetails" Text='<i class="fa fa-info-circle" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px">
                                <ItemTemplate>
                                    <asp:LinkBUtton runat="server" CommandName="EditOccupations" ToolTip="This course has related occupation codes. Click here to view/update occupation codes." ID="btnHaveOccupations" Text='<i class="fa fa-wrench" ForeColor="White" aria-hidden="true"></i>' />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="ACE ID" SortExpression="AceID" UniqueName="AceID" CurrentFilterFunction="Contains" FilterControlWidth="100px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="HaveOccupations" DataType="System.Boolean" UniqueName="HaveOccupations" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="100px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="CourseNumber" UniqueName="CourseNumber" FilterControlAltText="Filter CourseNumber column" HeaderText="Course Number" SortExpression="CourseNumber" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="80px" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Title" UniqueName="Title" FilterControlAltText="Filter Title column" HeaderText="ACE Title" SortExpression="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="190px" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                        </Columns>
                        <NoRecordsTemplate>
                            <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                &nbsp;No items to view
                            </div>
                        </NoRecordsTemplate>
                    </MasterTableView>
                </telerik:RadGrid>
            </div>
        </div>
        <telerik:GridDropDownListColumnEditor runat="server" ID="ceOccupations" DropDownStyle-Height="25px"></telerik:GridDropDownListColumnEditor>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        function closeRadWindow()  
        {  
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();   
        }
        function ShowACECourseDetail(AceId,TeamRevd,Title,AdvancedSearch) {
            var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + AceId + "&TeamRevd=" + TeamRevd + "&Title=" + Title + "&AdvancedSearch=" + AdvancedSearch, null);
            oWindow.setSize(1000, 600);
            oWindow.center();
            oWindow.set_visibleStatusbar(false);
        }
    </script>
</asp:Content>
