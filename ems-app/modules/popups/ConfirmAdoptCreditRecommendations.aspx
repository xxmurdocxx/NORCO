<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfirmAdoptCreditRecommendations.aspx.cs" Inherits="ems_app.modules.popups.ConfirmAdoptCreditRecommendations" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Adopt Articulations</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
    <style>
        .RadTile_Material,
        .RadWindow_Material .rwTitleBar,
        .rmContent [type="submit"],
        .RadButton_Material.rbButton.rbPrimaryButton,
        .RadWizard_Material .rwzNext, .RadWizard_Material .rwzFinish,
        .RadWizard_Material .rwzProgress,
        .RadNotification_Material .rnTitleBar,
        /*.badge, */
        .RadCalendar_Material .rcTitlebar,
        .RadCalendar_Material .rcPrev, .RadCalendar_Material .rcNext, .RadCalendar_Material .rcFastPrev, .RadCalendar_Material .rcFastNext {
            border-color: #203864 !important;
            background-color: #203864 !important;
        }

        .rgExpandCol {
            display: none !important;
        }
        .RadComboBox_Material .rcbInner {
            background-color: lightyellow !important;
        }
        .RadComboBox_Material .rcbLabel {
            color:inherit !important;
            font-weight: 700 !important;
            font-size: 10px !important;
        }
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" EnableViewState="false" runat="server" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <asp:HiddenField ID="hvUserID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hvCollegeID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hvUserStage" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hfExcludeArticulationOverYears" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hfOnlyImplemented" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hfBySubjectCourseCIDNumber" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hfArticulations" runat="server" ClientIDMode="Static" />

             <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Title="NOTICE" TitleIcon="info"
                    VisibleOnPageLoad="false" AutoCloseDelay="0" ShowCloseButton="true" 
                    Position="Center" Height="180" Width="550"
                    EnableRoundedCorners="true" EnableShadow="true">
                    <ContentTemplate>
                        <div class="mt-4 mb-3 d-flex justify-content-center" style="padding: 10px 20px">
                            One or more articulations you are attempting to adopt have already been adopted. Please review your selection and try again.
                        </div>
                        <div class="d-flex justify-content-center" style="text-align: center; padding: 10px 0px"> 
                            <telerik:RadButton ID="btnOk" runat="server" AutoPostBack="false" Text="Dismiss" OnClientClicked="OnClientClicked" PostBackUrl="~/modules/popups/AdoptArticulations.aspx" NavigateUrl="~/modules/popups/AdoptArticulations.aspx"></telerik:RadButton>
                        </div>
                    </ContentTemplate>
                </telerik:RadNotification>

            <div style="padding: 15px;">
                <div class="row">
                    <asp:SqlDataSource runat="server" ID="sqlArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                        SelectCommand="SELECT DISTINCT aec.Criteria AS SelectedCriteria, ac.AceID, ac.TeamRevd, ac.Title, ac.CriteriaID, ac.ExhibitID, ac.outline_id, sub.subject , cif.course_number , cif.course_title,  ac.CollegeID, (SELECT PropertyValue FROM IssuedFormProperties WHERE PropertyName = 'CIDnumber' AND IssuedFormID = CIF.IssuedFormID) CIDNumber, (select top 1 outline_id from Course_IssuedForm where college_id = @CollegeID and status = 0 and CIDNumber in (SELECT top(1) PropertyValue FROM IssuedFormProperties WHERE PropertyName = 'CIDnumber' AND IssuedFormID = CIF.IssuedFormID)) _outline_college, (SELECT top 1 MM.[c-id_descriptor] FROM master_cid AS M CROSS apply (SELECT DISTINCT TOP 1 [c-id], [c-id_descriptor] FROM   master_cid WHERE  [c-id] = M.[c-id] ORDER  BY [c-id]) AS MM where mm.[C-ID] = (SELECT top(1) PropertyValue FROM IssuedFormProperties WHERE PropertyName = 'CIDnumber' AND IssuedFormID = CIF.IssuedFormID)) CIDDescriptor FROM Articulation ac  JOIN Stages s on ac.ArticulationStage = s.Id JOIN Course_IssuedForm cif on ac.outline_id = cif.outline_id JOIN tblsubjects sub ON cif.subject_id = sub.subject_id join ACEExhibitCriteria aec on ac.CriteriaID = aec.CriteriaID  WHERE ac.id in (select value from [dbo].fn_split(@Articulations,',')) ">
                        <SelectParameters>
                            <asp:Parameter Name="Articulations" Type="String" DefaultValue="" />
                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" DefaultValue="" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <p>First, select or adjust your college course that best matches the course being adopted. If associated with C-ID, your course will already be selected. Next, choose the workflow member to receive/review this adoption, if not the default member is evaluator. Finally, select Adopt!
                    </p>
                    <telerik:RadGrid ID="rgArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulations" AllowFilteringByColumn="false" AllowPaging="False" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" AllowMultiRowSelection="true" Width="1050px" OnPreRender="rgArticulations_PreRender" OnItemDataBound="rgArticulations_ItemDataBound" OnItemCreated="rgArticulations_ItemCreated" GroupHeaderItemStyle-Font-Bold="true" Height="460px">
                        <ClientSettings AllowRowsDragDrop="false"  EnableRowHoverStyle="false" EnableAlternatingItems="false">
                            <Scrolling AllowScroll="true" UseStaticHeaders="true"  />
                            <Selecting AllowRowSelect="True"  />
                        </ClientSettings>
                        <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulations" PageSize="8" CommandItemDisplay="none" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" ItemStyle-BackColor="#dbedff" AlternatingItemStyle-BackColor="#dbedff" Width="100%" HierarchyDefaultExpanded="true" RetainExpandStateOnRebind="true" EnableHierarchyExpandAll="false" >
                            <GroupByExpressions>
                                <telerik:GridGroupByExpression>
                                    <SelectFields>
                                        <telerik:GridGroupByField FieldAlias="SelectedCriteria" FieldName="SelectedCriteria"></telerik:GridGroupByField>
                                    </SelectFields>
                                    <GroupByFields>
                                        <telerik:GridGroupByField FieldName="SelectedCriteria" SortOrder="Descending"></telerik:GridGroupByField>
                                    </GroupByFields>
                                </telerik:GridGroupByExpression>
                            </GroupByExpressions>
                            <Columns>
                                <telerik:GridBoundColumn SortExpression="outline_id" DataField="outline_id" UniqueName="outline_id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn SortExpression="_outline_college" DataField="_outline_college" UniqueName="_outline_college" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="subject" UniqueName="subject" HeaderText="Subject" HeaderStyle-Width="40px"  AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px"  AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ShowSortIcon="true" AllowSorting="true">
                                </telerik:GridBoundColumn>
<%--                                <telerik:GridBoundColumn DataField="course_title" HeaderStyle-Width="100px" UniqueName="course_title" HeaderText="Course Title"  AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false"  >
                                </telerik:GridBoundColumn>--%>
                                <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" AllowFiltering="false" HeaderStyle-Width="90px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" >
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="CIDNumber" UniqueName="CIDNumber" HeaderText="C-ID Number" HeaderStyle-Width="50px"  AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" >
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="CIDDescriptor" UniqueName="CIDDescriptor" HeaderText="C-ID Title" HeaderStyle-Width="50px"  AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true"  HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="Exhibit ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" HeaderStyle-Width="70px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" >
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker"  HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="60px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" EnableRangeFiltering="true" EnableHeaderContextMenu="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="10px"   EnableHeaderContextMenu="false" >
                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn SortExpression="SelectedCriteria" DataField="SelectedCriteria" UniqueName="SelectedCriteria" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="CriteriaID" UniqueName="CriteriaID" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false">
                                </telerik:GridBoundColumn>
                            </Columns>
                            <NestedViewTemplate>
                                <asp:Label ID="lblOutline" Font-Bold="true" Font-Italic="true" Text='<%# Eval("outline_id") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblOutlineIDCollege" Font-Bold="true" Font-Italic="true" Text='<%# Eval("_outline_college") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblSubject" Font-Bold="true" Font-Italic="true" Text='<%# Eval("subject") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblCourseNumber" Font-Bold="true" Font-Italic="true" Text='<%# Eval("course_number") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblCIDNumber" Font-Bold="true" Font-Italic="true" Text='<%# Eval("CIDNumber") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblSelectedCriteria" Font-Bold="true" Font-Italic="true" Text='<%# Eval("SelectedCriteria") %>' Visible="false" runat="server"></asp:Label>
                                <div class="row">
                                    <div class="col-sm-6">
                                        <telerik:RadComboBox ID="rcbCourses" DataSourceID="sqlCourses" DataTextField="CourseDescription" DataValueField="outline_id" MaxHeight="200px" Width="100%" EmptyMessage="Select a course..." AllowCustomText="false" ToolTip="Search for a college course (i.e. BUS 10) " runat="server" MarkFirstMatch="true" Filter="Contains" DropDownAutoWidth="Enabled" Label="Course : "  AutoPostBack="true" Font-Bold="true">
                                        </telerik:RadComboBox>
                                        <asp:SqlDataSource runat="server" ID="sqlCourses" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="sp_SearchCourses" SelectCommandType="StoredProcedure">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" DbType="Int32" />
                                                <asp:Parameter Name="CourseType" DbType="Int32" DefaultValue="1" />
                                                <asp:Parameter Name="All" DbType="Int32" DefaultValue="1" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <asp:RequiredFieldValidator runat="server" CssClass="alert alert-warning" ControlToValidate="rcbCourses" ErrorMessage="Please select a course." Display="Dynamic" ValidationGroup="CloneArticulation" EnableClientScript="true" />
                                    </div>
                                    <div class="col-sm-6">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-6" style="font-size: 10px !important;">
                                        <asp:SqlDataSource ID="sqlSelectedCollegeCourse" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                                            <SelectParameters>
                                                <asp:ControlParameter Name="outline_id" ControlID="rcbCourses" PropertyName="SelectedValue" Type="Int32" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <asp:Repeater ID="Repeater2" runat="server" DataSourceID="sqlSelectedCollegeCourse">
                                            <ItemTemplate>
                                                <div class="row">
                                                    <div class="col-12"><b>College : </b><%# Eval("_College") %></div>
                                                    <div class="col-12">&nbsp;</div>
                                                    <div class="col-12"><b>Catalog Description :</b></div>
                                                    <div class="col-12"><%# Eval("_CatalogDescription") %></div>
                                                    <div class="col-12"><b>Taxonomy of Program Code (TOP CODE) : <%# Eval("_TopsCode") %></b></div>
                                                </div>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                    <div class="col-sm-6" style="font-size: 10px !important;">
                                        <asp:SqlDataSource ID="sqlCoursesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                                            <SelectParameters>
                                                <asp:ControlParameter Name="outline_id" ControlID="lblOutline" PropertyName="Text" Type="Int32" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <asp:Repeater ID="rptCourseDetails" runat="server" DataSourceID="sqlCoursesDetails">
                                            <ItemTemplate>
                                                <div class="row">
                                                    <div class="col-12"><b>College : </b><%# Eval("_College") %></div>
                                                    <div class="col-12">
                                                        <b>Course :</b>
                                                        <%# String.Concat(Eval("_Subject"), " ", Eval("_CourseNumber"), " ", Eval("_CourseTitle")) %> <b>Units :</b> <%# Eval("_Units") %>
                                                    </div>
                                                    <div class="col-12"><b>Catalog Description :</b></div>
                                                    <div class="col-12"><%# Eval("_CatalogDescription") %></div>
                                                    <div class="col-12"><b>Taxonomy of Program Code (TOP CODE) : <%# Eval("_TopsCode") %></b></div>
                                                </div>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </NestedViewTemplate>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
                
                <div class="row text-right" style="margin-bottom:6px !important;">
                    <asp:SqlDataSource ID="sqlStages" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.id, r.RoleName from Stages s left outer join ROLES r on s.RoleId = r.RoleID where s.CollegeId = @CollegeID order by s.[Order]">
                        <SelectParameters>
                            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadComboBox ID="rcbStages" runat="server" Culture="es-ES" DataSourceID="sqlStages" DataTextField="RoleName" DataValueField="id" Label="Who should review this adoption? : " Text="Who should review this adoption? " Width="330px" DropDownAutoWidth="Enabled" BackColor="LightYellow">
                    </telerik:RadComboBox>
                </div>
                <div class="row text-right" style="margin-top:5px;">
                    <telerik:RadButton ID="rbProceed" runat="server" Text="Adopt" CausesValidation="true" OnClick="rbProceed_Click" ValidationGroup="CloneArticulation" ToolTip="Click here to proceed adopting articulations." Primary="true">
                        <Icon PrimaryIconCssClass="rbOk"></Icon>
                    </telerik:RadButton>
                    <telerik:RadButton ID="rbCancel" runat="server" Text="Cancel" OnClientClicked="CloseModal">
                        <Icon PrimaryIconCssClass="rbCancel"></Icon>
                    </telerik:RadButton>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>

    </form>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script>
        window.addEventListener('load',
            function () {
                SelectAllArticulation();
            }, false);

        function SelectAllArticulation() {
            var masterTable = $find("<%= rgArticulations.ClientID %>").get_masterTableView();
            var row = masterTable.get_dataItems();
            for (var i = 0; i < row.length; i++) {
                masterTable.get_dataItems()[i].set_selected(true);
            }
        }
        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow)
                oWindow = window.radWindow;
            else if (window.frameElement && window.frameElement.radWindow)
                oWindow = window.frameElement.radWindow;
            return oWindow;
        }
        function CloseModal() {
            setTimeout(function () {
                GetRadWindow().close();
                top.location.href = top.location.href;
            }, 0);
        }
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function OnClientClicked(sender, args) {
            var notification = $find("<%=rnMessage.ClientID %>");
            notification._close(true);
            CloseModal();
        }
    </script>
</body>
</html>

