<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfirmDenyArticulation.aspx.cs" Inherits="ems_app.modules.popups.ConfirmDenyArticulation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Deny Articulations</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
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
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="0" Width="350" Height="150" Title="" EnableRoundedCorners="true" Animation="Fade" AnimationDuration="3" >
            </telerik:RadNotification>
            <div style="padding: 15px;">
                <div class="row">
                    <asp:SqlDataSource runat="server" ID="sqlArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                        SelectCommand="SELECT ac.id, ac.LastSubmittedOn as LastSubmitted, (SELECT STUFF((SELECT ',' + criteria FROM ArticulationCriteria where ArticulationID = ac.ArticulationID	and ArticulationType = ac.ArticulationType FOR XML PATH('')) ,1,1,'')) AS SelectedCriteria, sub.subject , cif.course_number , cif.course_title, case when ac.ArticulationType = 1 then 'ACE Course' else 'Occupation' end as 'ArticulationTypeName', ac.ArticulationID, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, ac.Title, ac.TeamRevd, ac.CreatedOn, cc.Occupation , ac.outline_id, s.RoleID, ac.id, ac.ArticulationType, ac.ArticulationStatus, ac.ArticulationStage ,  case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Office Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes, ac.Notes, ac.Justification, ac.ArticulationOfficerNotes,  ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.Exhibit,   concat(mu.firstname , ', ' , mu.lastname) as 'FullName' , cc.Occupation, ac.ModifiedBy, ac.Articulate, ac.CollegeID, c.CollegeAbbreviation as 'ArticulationCollege' FROM Articulation ac LEFT OUTER JOIN AceOccupation cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd LEFT OUTER JOIN tblusers u on ac.CreatedBy = u.userid LEFT OUTER JOIN TBLUSERS mu on ac.LastSubmittedBy = mu.UserID LEFT OUTER JOIN Stages s on ac.ArticulationStage = s.Id LEFT OUTER JOIN Course_IssuedForm cif on ac.outline_id = cif.outline_id LEFT OUTER JOIN tblsubjects sub ON cif.subject_id = sub.subject_id LEFT OUTER JOIN LookupColleges C ON ac.CollegeID = C.CollegeID WHERE ac.id in (select value from [dbo].fn_split(@Articulations,',')) ORDER BY ac.LastSubmittedOn DESC">
                        <SelectParameters>
                            <asp:Parameter Name="Articulations" Type="String" DefaultValue="" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadGrid ID="rgArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulations" AllowFilteringByColumn="false" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" AllowMultiRowSelection="true" Width="100%">
                        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" EnableAlternatingItems="false">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                        </ClientSettings>
                        <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulations" PageSize="8" CommandItemDisplay="none" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1" >
                            <Columns>
                            <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn" HeaderStyle-Width="15px">
                            </telerik:GridClientSelectColumn>
                                <telerik:GridBoundColumn SortExpression="id" DataField="id" UniqueName="id" Display="false" >
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
                                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" >
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="190px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
                <div class="row">
                    <h3>Notes : </h3>
                    <br />
                    <telerik:RadTextBox ID="rtbNotes" runat="server" ValidationGroup="notification-form" Width="100%" TextMode="MultiLine" Rows="5"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" CssClass="alert alert-warning" ControlToValidate="rtbNotes" ErrorMessage="Please add notes." Display="Dynamic" ValidationGroup="notification-form" EnableClientScript="true" />
                </div>
                <div class="row text-right">
                    <br />
                    <telerik:RadButton ID="rbProceed" runat="server" Text="Proceed" CausesValidation="true" OnClick="rbProceed_Click" ValidationGroup="notification-form" ToolTip="Click here if you want to proceed in denying the articulation.">
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
    </script>
</body>
</html>
