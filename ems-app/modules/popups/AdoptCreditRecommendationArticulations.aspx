<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdoptCreditRecommendationArticulations.aspx.cs" Inherits="ems_app.modules.popups.AdoptCreditRecommendationArticulations" %>

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
     <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet"/>
    <style>
        .RadTile_Material,
    .RadWindow_Material .rwTitleBar,
    .rmContent [type="submit"],
    .RadButton_Material.rbButton.rbPrimaryButton,
    .RadWizard_Material .rwzNext, .RadWizard_Material .rwzFinish,
    .RadWizard_Material .rwzProgress,
    .RadNotification_Material .rnTitleBar, /*
.badge, */
    .RadCalendar_Material .rcTitlebar,
    .RadCalendar_Material .rcPrev, .RadCalendar_Material .rcNext, .RadCalendar_Material .rcFastPrev, .RadCalendar_Material .rcFastNext {
        border-color: #203864 !important;
        background-color: #203864 !important;
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
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="0" Width="350" Height="150" Title="" EnableRoundedCorners="true" Animation="Fade" AnimationDuration="3">
            </telerik:RadNotification>
            <div style="padding: 15px;">
                <div class="row">
                    <asp:SqlDataSource runat="server" ID="sqlArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                        SelectCommand="SELECT x.subject, x.course_number, x.course_title, x.id,x.LastSubmittedOn as LastSubmitted, case when x.ArticulationType = 1 then 'ACE Course' else 'Occupation' end as 'ArticulationTypeName', x.ArticulationID,  x.AceID, x.Exhibit, x.StartDate, x.EndDate, concat(cast(FORMAT(x.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(x.EndDate, 'MM/yy') as varchar(7))) AS 'ExhibitDate', x.Title, x.TeamRevd, x.CreatedOn, x.Occupation , x.outline_id, x.ArticulationType, x.ArticulationStatus, x.ArticulationStage ,    x.ArticulationType as 'articulation_type', x.ArticulationStatus as 'status_id', x.ArticulationStage as 'stage_id',  x.ModifiedBy, x.Articulate, x.CollegeID, x.FullName, x.[Order] as sorder FROM ( SELECT A.*, c.course_number, c.course_title, s.subject, concat(mu.firstname , ', ' , mu.lastname) as 'FullName' , st.[Order], cc.Exhibit, cc.StartDate, cc.EndDate, concat(cast(FORMAT(cc.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(cc.EndDate, 'MM/yy') as varchar(7))) AS 'ExhibitDate', cc.Occupation , ISNULL((SELECT STUFF((SELECT ',' + TRIM(Criteria) FROM ArticulationCriteria WHERE ArticulationID = A.ArticulationID AND ArticulationType = A.ArticulationType FOR XML PATH('')) ,1,1,'')),'Articulations without Credit Recommendations') AS SelectedCriteria FROM articulation a JOIN course_issuedform c ON a.outline_id = c.outline_id JOIN tblsubjects s ON c.subject_id = s.subject_id LEFT OUTER JOIN (SELECT s1.subject, c1.course_number FROM course_issuedform c1 JOIN tblsubjects s1 ON c1.subject_id = s1.subject_id WHERE c1.college_id = @CollegeID AND c1.status = 0) nc ON s.subject = nc.subject AND c.course_number = nc.course_number JOIN stages st ON a.articulationstage = st.id LEFT OUTER JOIN (SELECT issuedformid, propertyvalue AS CIDNumber FROM issuedformproperties WHERE propertyname = 'CIDnumber') CID ON C.issuedformid = CID.issuedformid LEFT OUTER JOIN View_MostCurrentOccupation cc on a.AceID = cc.ACeID and a.TeamRevd = cc.TeamRevd LEFT OUTER JOIN tblusers u on a.CreatedBy = u.userid LEFT OUTER JOIN TBLUSERS mu on a.LastSubmittedBy = mu.UserID WHERE a.articulate = 1 AND c.status = 0 AND a.outline_id = @outline_id AND a.collegeid <> @CollegeID AND dbo.Checkarticulationexistincollege(@CollegeID, s.subject, c.course_number, a.aceid, a.teamrevd) = 0 AND a.teamrevd > Dateadd(year, -@ExcludeArticulationOverYears, dbo.Returnpstdate(Getdate())) AND ( ( @OnlyImplemented = 0 AND st.[order] IN ( 1, 2, 3, 4 ) ) OR ( @OnlyImplemented = 1 AND st.[order] = 4 ) ) AND ( ( @BySubjectCourseNumberorCIDNumber = 0 AND ( cid.cidnumber IS NOT NULL OR cid.cidnumber IS NULL ) ) OR ( @BySubjectCourseNumberorCIDNumber = 1 AND cid.cidnumber IS NOT NULL ) )  ) x WHERE x.SelectedCriteria = @SelectedCriteria order by SELECT x.subject, x.course_number">
                        <SelectParameters>                          
                            <asp:SessionParameter SessionField="CollegeID" Name="CollegeID" Type="Int32" DefaultValue="" />
                            <asp:QueryStringParameter QueryStringField="outline_id" Name="outline_id" Type="Int32" DefaultValue="" />
                            <asp:QueryStringParameter QueryStringField="selected_criteria" Name="SelectedCriteria" Type="String" DefaultValue="" />
                            <asp:QueryStringParameter QueryStringField="exclude" Name="ExcludeArticulationOverYears" Type="Int32" />
                            <asp:QueryStringParameter QueryStringField="subject_cid" Name="BySubjectCourseNumberorCIDNumber" Type="Boolean" />
                            <asp:QueryStringParameter QueryStringField="only_implemented" Name="OnlyImplemented" Type="Boolean" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <telerik:RadGrid ID="rgArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulations" AllowFilteringByColumn="false" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" AllowMultiRowSelection="true" Width="100%">
                        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" EnableAlternatingItems="false">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                        </ClientSettings>
                        <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulations" PageSize="8" CommandItemDisplay="none" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
                            <Columns>
                                <telerik:GridBoundColumn SortExpression="id" DataField="id" UniqueName="id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="subject" UniqueName="subject" HeaderText="Subject" HeaderStyle-Width="60px" FilterControlWidth="60px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" HeaderText="Type" AllowFiltering="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="80px" AllowFiltering="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" AllowFiltering="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                </telerik:GridDateTimeColumn>
                                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="190px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>

    </form>
    <!-- jQuery -->
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
            setTimeout(function () {
                GetRadWindow().close();
            }, 0);
        }
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
    </script>
</body>
</html>

