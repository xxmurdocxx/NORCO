<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notify.aspx.cs" Inherits="ems_app.modules.popups.Notify" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Notifications</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
    <style>
        .reContentArea {
            background-color: lightyellow !important;
        }
        .RadInput .riEmpty, .RadInput_Empty {         
            font-family: "Roboto","Noto",sans-serif;
            font-style: normal !important;
            color: #455A64 !important;
        }
    </style>
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
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="2000" Width="350" Height="110" Title="Notification" EnableRoundedCorners="true">
            </telerik:RadNotification>
            <div class="row" style="padding: 20px;">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <asp:HiddenField runat="server" ID="hvStageIDToNotify" />
                    <asp:HiddenField runat="server" ID="hvCollegeID" />
                    <asp:HiddenField runat="server" ID="hvTotalCoursesDistrict" />
                    <asp:HiddenField runat="server" ID="hvSubjectCC" />

                    <div class="row">
                        <div class="col-sm-3">
                            <h3 id="headerAction" runat="server"></h3>
                            <h3 class="bold">The following recipients will be notified : </h3>  
                            <div style="display:none !important">
                                <asp:Panel ID="pnlRecipients" runat="server">
                            <br />                                  
                            <asp:SqlDataSource runat="server" ID="sqlStages" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                                SelectCommand="select * from Stages s left outer join ROLES r on s.RoleId = r.RoleID where s.CollegeId = @CollegeID and s.BypassStage = 0">
                                <SelectParameters>
                                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" DefaultValue="" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <telerik:RadComboBox ID="rcbStages" runat="server" DataSourceID="sqlStages" DataTextField="RoleName" DataValueField="ID" CheckBoxes="true" Width="100%" EnableCheckAllItemsCheckBox="true" EmptyMessage="Select a stages " DropDownAutoWidth="Enabled" RenderMode="Lightweight" CheckedItemsTexts="FitInInput" >
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="rfvStages" runat="server" ControlToValidate="rcbStages" CssClass="alert alert-warning" ErrorMessage="* Select a Stage to notify" ValidationGroup="" Display="Dynamic"></asp:RequiredFieldValidator>
                            </asp:Panel>                                
                            </div>

                            <telerik:RadLabel ID="rlStage" Font-Size="Large" runat="server"></telerik:RadLabel>
                            <asp:Panel ID="pnlCheckboxes" runat="server">
                                <br />                               
                                <telerik:RadCheckBox ID="rchkDistrictEvaluators" AutoPostBack="false" runat="server" CausesValidation="false" Text="District Evaluators" Enabled="false"></telerik:RadCheckBox>
                                <br />
                                <telerik:RadCheckBox ID="rchkDistrictFaculty" AutoPostBack="false" runat="server" CausesValidation="false" Text="District Discipline Faculty" Enabled="true"></telerik:RadCheckBox>
                                <br />
                                <telerik:RadCheckBox ID="rchkIEDRCEvaluators" AutoPostBack="false" runat="server" CausesValidation="false" Text="Cohort Colleges Evaluators" Enabled="false" Visible="false"></telerik:RadCheckBox>
                                <br />
                                <telerik:RadCheckBox ID="rchkIEDRCFaculty" AutoPostBack="false" runat="server" CausesValidation="false" Text="Cohort Colleges Discipline Faculty" Enabled="false" Visible="false"></telerik:RadCheckBox>
                                <br />
                            </asp:Panel>                      
                        </div>
                        <div class="col-sm-1">
                        </div>
                        <div class="col-sm-8">
                            <br />
                            <telerik:RadTextBox ID="rtbSubject" runat="server" Width="100%" TextMode="MultiLine" Rows="3" Label="Subject"></telerik:RadTextBox><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="rtbSubject" runat="server" ErrorMessage="Please enter a subject" CssClass="alert alert-warning" ValidationGroup="notification-form"></asp:RequiredFieldValidator><br />
                            <telerik:RadLabel ID="rlNotes" runat="server" Text="Message to Recipient : "></telerik:RadLabel>
                            <telerik:RadEditor runat="server" ID="reComments" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="60px" Width="100%" RenderMode="Lightweight" ToolTip="Message" ContentFilters="ConvertToXhtml" BackColor="LightYellow">
                                <Tools>
                                    <telerik:EditorToolGroup Tag="Formatting">
                                        <telerik:EditorTool Name="Bold" />
                                    </telerik:EditorToolGroup>
                                </Tools>
                                <Content>
                                    
                                </Content>
                                <TrackChangesSettings CanAcceptTrackChanges="False" />
                            </telerik:RadEditor>
                            <telerik:RadLabel ID="rlFacultyNotification" runat="server" Visible="true" ForeColor="Red"></telerik:RadLabel>
                            <br />
<%--                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="reComments" runat="server" ErrorMessage="Please add notes for returning or denying articulation." CssClass="alert alert-warning" ValidationGroup="notification-form" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                            <asp:Panel ID="pnlCreditRecommendations" runat="server" Visible="false">
                                <telerik:RadLabel ID="RadLabel1" runat="server" Text="Proposed Credit Recommendation : "></telerik:RadLabel>
                            <telerik:RadComboBox ID="rcbCreditRecs" DataSourceID="sqlCriteria" DataTextField="Criteria" DataValueField="Criteria" MaxHeight="200px" Width="100%" AppendDataBoundItems="true" EmptyMessage="Select a Credit Recommendation" ToolTip="" runat="server" MarkFirstMatch="true" Filter="Contains"  DropDownWidth="450px" AutoPostBack="true"  BackColor="#ffffe0" CssClass="RadComboBoxCourses">
                            <Items>
                                <telerik:RadComboBoxItem Text="" Value="" />
                            </Items>
                            </telerik:RadComboBox>
                                <asp:SqlDataSource runat="server" ID="sqlCriteria" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="select distinct aec.Criteria  from articulation a join ACEExhibit ae on a.ExhibitID = ae.ID join ACEExhibitCriteria aec on ae.AceID = aec.AceID and ae.TeamRevd = aec.TeamRevd and ae.StartDate = aec.StartDate where a.id in (select value from dbo.fn_Split(@Articulations,','))  and aec.CriteriaID not in (select CriteriaID from Articulation where id in (select value from dbo.fn_Split(@Articulations,','))) " SelectCommandType="Text" CancelSelectOnNullParameter="false">
                                    <SelectParameters>
                                        <asp:Parameter Name="Articulations" Type="String" DefaultValue="" />
                                    </SelectParameters>
                                </asp:SqlDataSource>                        
                            </asp:Panel>                            
                            <telerik:RadLabel ID="labelNotes" runat="server" Text="Add Articulation Notes : "></telerik:RadLabel>
                            <telerik:RadTextBox ID="rtbNotes" EmptyMessage="" runat="server" InputType="Text" TextMode="MultiLine" BackColor="LightYellow" Rows="3" Skin="Metro" Width="100%"></telerik:RadTextBox>
                            <telerik:RadLabel ID="rlSignature" runat="server" Text="Add Signature : "></telerik:RadLabel>
                            <telerik:RadTextBox ID="rtbSignature" EmptyMessage="" runat="server" InputType="Text" BackColor="LightYellow" Rows="3" Skin="Metro" Width="100%"></telerik:RadTextBox>
                            <div style="display:flex; flex-direction:row; width:100%; margin-top:10px;">
                                  <div style="display: flex; flex-direction: column; flex-basis: 100%; flex: 1;">
                                      <div id="divUploadDocument" runat="server" >
                                        <telerik:RadAsyncUpload Localization-Select="Upload Document(s)" RenderMode="Lightweight" runat="server" ID="AsyncUpload1" MultipleFileSelection="Automatic"/>
                                        <telerik:RadProgressArea RenderMode="Lightweight" runat="server" ID="RadProgressArea1" />
                                      </div>                                  
                                </div>
                                <div style="display: flex; flex-direction: column; flex-basis: 100%; flex:auto; justify-content:end;">
                                    <div style="width:100%; text-align:center;">
                                       <telerik:RadButton ID="rbSubmit" runat="server" Text="Submit" CausesValidation="true" OnClick="rbSubmit_Click" ValidationGroup="notification-form" Width="100px" Primary="true" ToolTip="Email notifications will be sent to all recipients specified above.">
                                        <Icon PrimaryIconCssClass="rbMail"></Icon>
                                    </telerik:RadButton>                                         
                                    </div>                            
                                </div>                                  
                            </div>                  
                        </div>
                    </div>
                    <h3 class="bold">Selected records</h3>
                    <div class="row"  style="margin-top:10px !important; display:block;">
                        <asp:SqlDataSource runat="server" ID="sqlArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                            SelectCommand="SELECT DISTINCT ac.id, ac.ExhibitID, concat(cast(FORMAT(cc.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(cc.EndDate, 'MM/yy') as varchar(7))) AS 'ExhibitDate', ac.LastSubmittedOn as LastSubmitted, AEC.Criteria AS SelectedCriteria, sub.subject , cif.course_number , cif.course_title, case when ac.ArticulationType = 1 then 'ACE Course' else 'Occupation' end as 'ArticulationTypeName', ac.ArticulationID, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, ac.Title, ac.TeamRevd, ac.CreatedOn, cc.Occupation , ac.outline_id, s.RoleID, ac.id, ac.ArticulationType, ac.ArticulationStatus, ac.ArticulationStage ,  case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Office Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes, ac.Notes, ac.Justification, ac.ArticulationOfficerNotes,  ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.Exhibit,   concat(mu.firstname , ', ' , mu.lastname) as 'FullName' , cc.Occupation, ac.ModifiedBy, ac.Articulate, ac.CollegeID, c.CollegeAbbreviation as 'ArticulationCollege' FROM Articulation ac LEFT OUTER JOIN AceExhibit cc on ac.ExhibitID = cc.Id LEFT OUTER JOIN AceExhibitCriteria AEC on ac.CriteriaID = AEC.CriteriaID LEFT OUTER JOIN tblusers u on ac.CreatedBy = u.userid LEFT OUTER JOIN TBLUSERS mu on ac.LastSubmittedBy = mu.UserID LEFT OUTER JOIN Stages s on ac.ArticulationStage = s.Id LEFT OUTER JOIN Course_IssuedForm cif on ac.outline_id = cif.outline_id LEFT OUTER JOIN tblsubjects sub ON cif.subject_id = sub.subject_id LEFT OUTER JOIN LookupColleges C ON ac.CollegeID = C.CollegeID WHERE ac.id in (select value from [dbo].fn_split(@Articulations,',')) ORDER BY ac.LastSubmittedOn DESC">
                            <SelectParameters>
                                <asp:Parameter Name="Articulations" Type="String" DefaultValue="" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <telerik:RadGrid ID="rgArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulations" AllowFilteringByColumn="false" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" AllowMultiRowSelection="true" Width="100%" OnItemDataBound="rgArticulations_ItemDataBound" OnItemCommand="rgArticulations_ItemCommand" GroupHeaderItemStyle-Font-Bold="true">
                            <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" EnableAlternatingItems="false">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                            </ClientSettings>
                            <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulations" PageSize="8" CommandItemDisplay="none" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
                                <GroupByExpressions>
                                    <telerik:GridGroupByExpression>
                                        <SelectFields>
                                            <telerik:GridGroupByField FieldAlias="SelectedCriteria" FieldName="SelectedCriteria"></telerik:GridGroupByField>
                                        </SelectFields>
                                        <GroupByFields>
                                            <telerik:GridGroupByField FieldName="SelectedCriteria" SortOrder="Ascending" ></telerik:GridGroupByField>
                                        </GroupByFields>
                                    </telerik:GridGroupByExpression>
                                </GroupByExpressions>
                                <Columns>
                                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="20px" ReadOnly="true" AllowFiltering="false" EnableHeaderContextMenu="false" ItemStyle-CssClass="row-buttons">
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" ToolTip="View Articulation Details" CommandName="EditNotes" ID="btnEditNotes" Text='' >
                                                <i class='fa fa-eye fa-lg'></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>                                    
                                    <telerik:GridBoundColumn DataField="subject" UniqueName="subject" HeaderText="Subject" HeaderStyle-Width="40px" FilterControlWidth="60px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" HeaderText="Type" AllowFiltering="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="80px" AllowFiltering="false" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="SelectedCriteria" UniqueName="SelectedCriteria" Display="false">
                                    </telerik:GridBoundColumn>                                    
                                    <telerik:GridTemplateColumn UniqueName="ExhibitLink" HeaderText="Ace ID" HeaderStyle-Width="100px" SortExpression="Title" >
                                        <ItemTemplate>
                                            <asp:HyperLink NavigateUrl="javascript:showExhibitInfo();" runat="server" ID="hlExhibit" Text="" Font-Underline="true"></asp:HyperLink>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>                                      
                                    <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" AllowFiltering="false">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridBoundColumn SortExpression="ExhibitDate" HeaderText="Exhibit Date" DataField="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Width="100px" FilterControlWidth="90px" AllowFiltering="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="190px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false">
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
               </div>
            </div>
            <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server">
            </telerik:RadWindowManager>            
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
            // GetRadWindow().close();
            setTimeout(function () {
                GetRadWindow().close();
                top.location.href = top.location.href;
            }, 0);
        }
    </script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- Place this before your closing </body> tag, assuming jQuery is loaded earlier in the page -->
    <script>
        $(document).ready(function () {
            // Replace '.yourUniqueClass' with the actual class of your LinkButton or the appropriate selector
            $(".fa.fa-eye.fa-lg").click(function (e) {
                e.preventDefault();
                __doPostBack('rgArticulations$ctl00$ctl05$btnEditNotes', '');
            });
        });
    </script>

</body>
</html>

