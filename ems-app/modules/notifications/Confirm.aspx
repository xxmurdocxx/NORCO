<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Confirm.aspx.cs" Inherits="ems_app.modules.notifications.Confirm" MasterPageFile="~/Common/templates/main.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
   <style>
        html, body, form {
            height: 100% !important;
            margin: 0px;
            padding: 0px;
        }

        .RadGrid .rgSelectedRow td {
            background: none !important;
        }

        .RadGrid_Material .rgRow > td, .RadGrid_Material .rgAltRow > td, .RadGrid_Material .rgEditRow > td {
            border-bottom: 1px solid #ccc !important;
        }

        .RadSplitter_Material .rspSlideHeader, .RadSplitter_Material .rspSlideTitleContainer, .RadSplitter_Material .rspSlideTitleContainer, .RadSplitter_Material .rspSlideHeaderIconWrapper, .RadSplitter_Material .rspSlideTitleContainer, .RadSplitter_Material .rspSlideHeaderIconWrapper, .RadSplitter_Material .rspSlideTitleContainer, .RadSplitter_Material .rspSlideHeaderIconWrapper {
            background-color: #203864 !important;
            border-top: 1px solid #203864 !important;
            border-bottom: 1px solid #203864 !important;
        }
        .rspSlideHeaderUndockIcon, .RadSplitter .rspSlideHeaderCollapseIcon {
            height: 35px !important;
        }
        .RadSplitter .rspSlideHeaderUndockIcon:before {
            content: "\f053" !important;
            font-family:"FontAwesome" !important ;
        }
        @media print {
          body * {
            visibility: hidden;
          }
          .section-to-print-title, .section-to-print-title * {
            visibility: visible;
          }
          .section-to-print-title{
            /*position: absolute;*/
            left: 0px;
            top: 50px;
          }
          .section-to-print, .section-to-print * {
            visibility: visible;
          }
          .section-to-print {
            position: absolute;
            left: 0;
            top: 140px;
            border-bottom: 1px solid black;
          }
          .section-to-print2, .section-to-print2 * 
          {
            visibility: visible;
          } 
          .section-to-print2
          {
            position: absolute;
            left: 0;
            top: 480px;
            border-bottom: 1px solid black;
            width: 100%;
          }

        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" id="SystemTitle" runat="server">MAP Notifications</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" Height="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" Modal="false"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="580px" Height="120px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <asp:HiddenField runat="server" ID="hfUserID" />
            <asp:HiddenField runat="server" ID="hfMessageID" />
            <asp:HiddenField runat="server" ID="hfActionTaken" />
            <asp:HiddenField runat="server" ID="hfArticulations" />
            <asp:HiddenField ID="hvUserName" runat="server" />
            <asp:HiddenField ID="hvUserID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hvCollegeID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hvAppID" runat="server" />
            <asp:HiddenField ID="hvUserStage" runat="server" />
            <asp:HiddenField ID="hvUserStageOrder" runat="server" />
            <asp:HiddenField ID="hvExcludeArticulationOverYears" runat="server" />
            <asp:HiddenField ID="hvFirstStage" runat="server" />
            <asp:HiddenField ID="hvLastStage" runat="server" />
            <asp:HiddenField ID="hvFromUserCollegeID" runat="server" />
            <asp:HiddenField ID="hvFromUserStageID" runat="server" />
            <asp:HiddenField ID="hvDisabledArticulationsCount" runat="server" Value="0" />
            <asp:HiddenField ID="hvMessageCount" runat="server" ClientIDMode="Static" />
   
            <div class="row" style="margin-bottom: 50px;">
                <div class="col-8">
                    <h3 class="section-to-print-title">
                        <label id="lblTitle" runat="server" style="margin: 5px;"></label>
                    </h3>
                </div>
            </div>

            <div class="container-fluid">
                <telerik:RadSplitter RenderMode="Lightweight" ID="RadSplitter1" runat="server" Height="700px" Width="100%" LiveResize="true">
                    <telerik:RadPane ID="LeftPane" runat="server" Width="22" Scrolling="None">
                        <telerik:RadSlidingZone ID="SlidingZone1" runat="server" Width="22" ExpandedPaneId="Pane1" DockedPaneId="Pane1">
                            <telerik:RadSlidingPane ID="Pane1" ToolTip="Pin / Unpin" Title="Course Information" runat="server" Width="300" MinWidth="130" Height="100%" Font-Bold="true" DockOnOpen="true">
                                <asp:SqlDataSource ID="sqlCoursesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="outline_id" ControlID="hfOutlineID" PropertyName="Value" Type="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <div class="section-to-print">
                                <asp:Repeater ID="rptCourseDetails"  runat="server" DataSourceID="sqlCoursesDetails">
                                    <ItemTemplate>
                                        <div class="row">
                                            <div class="col-3"><b>Course :</b></div>
                                            <div class="col-9"><%# String.Concat(Eval("_Subject"), " ", Eval("_CourseNumber")) %></div>
                                            <div class="col-3"><b>Title :</b></div>
                                            <div class="col-9"><%# Eval("_CourseTitle") %></div>
                                            <div class="col-3"><b>Units :</b></div>
                                            <div class="col-9"><%# Eval("_Units") %></div>
                                            <%--                                <div class="col-3"><b>Division :</b></div>
                                <div class="col-9"><%# Eval("_Division") %></div>--%>
                                            <div class="col-12"><b>Catalog Description :</b></div>
                                            <div class="col-12"><%# Eval("_CatalogDescription") %></div>
                                            <div class="col-12"><b>Taxonomy of Program Code (TOP CODE) :</b></div>
                                            <div class="col-12"><%# Eval("_TopsCode") %></div>
                                        </div>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                    </FooterTemplate>
                                </asp:Repeater>
                                </div>
                                <asp:SqlDataSource runat="server" ID="sqlOtherMessages" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                                    SelectCommand="select distinct cpc.Criteria, concat(s.subject, '-',c.course_number,' ',course_title, ' ', u.unit, ' Unit(s)' ) 'Course', concat('This credit recommendation occurs in',(select count(*) from ACEExhibitCriteria where Criteria = cpc.Criteria),' Exhibit(s) course(s)') 'Ocurrences', cp.outline_id  from CriteriaPackageCriteria cpc join CriteriaPackage cp on cpc.PackageID = cp.Id join Course_IssuedForm c on cp.outline_id = c.outline_id join tblSubjects s on c.subject_id = s.subject_id join tblLookupUnits u on c.unit_id = u.unit_id join Messages m on  cp.id = m.CriteriaPackageID where m.ToUserID = 40 and cp.outline_id <> 10131  order by cpc.Criteria desc">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="outline_id" ControlID="hfOutlineID" Type="Int32" PropertyName="Value" DefaultValue="" />
                                        <asp:ControlParameter Name="ToUserID" ControlID="hfUserID" Type="Int32" PropertyName="Value" DefaultValue="0" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <div style="display: none !important">
                                    <h2>Other Credit Recommendation Articulation(s) in your queue</h2>
                                    <br />
                                    <telerik:RadGrid ID="rgOtherMessages" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOtherMessages" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" AllowMultiRowSelection="true">
                                        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" EnableAlternatingItems="false">
                                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                                            <ClientEvents OnRowContextMenu="demo.RowContextMenu" />
                                        </ClientSettings>
                                        <MasterTableView Name="ParentGrid" DataSourceID="sqlOtherMessages" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1" EnableHeaderContextMenu="true" AllowPaging="false">
                                            <CommandItemTemplate>
                                                <div class="commandItems" style="padding: 5px;">
                                                    <div class="row">
                                                        <div class="col-sm-8">
                                                            <telerik:RadButton runat="server" ID="btnMoveForward" OnClientClick="javascript:if(!confirm('Are you sure you want to approve this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="MoveForward" CommandName="MoveForward" ToolTip="Approve selected articulation(s)">
                                                                <ContentTemplate>
                                                                    <i class='fa fa-send'></i><span class="txtMoveForward">Approve</span>
                                                                </ContentTemplate>
                                                            </telerik:RadButton>
                                                            <telerik:RadButton runat="server" ID="btnReturn" OnClientClick="javascript:if(!confirm('Are you sure you want to Return this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Return" CommandName="Return" ToolTip="Return selected articulation(s)">
                                                                <ContentTemplate>
                                                                    <i class='fa fa-hand-o-left'></i>Return
                                           
                                                                </ContentTemplate>
                                                            </telerik:RadButton>
                                                            <telerik:RadButton runat="server" ID="btnDenied" OnClientClick="javascript:if(!confirm('Are you sure you want to Deny this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Deny" CommandName="Denied" ToolTip="Deny selected articulation(s)">
                                                                <ContentTemplate>
                                                                    <i class='fa fa-ban'></i>Deny
                                           
                                                                </ContentTemplate>
                                                            </telerik:RadButton>
                                                        </div>
                                                    </div>
                                                </div>
                                            </CommandItemTemplate>
                                            <Columns>
                                                <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn" HeaderStyle-Width="20px">
                                                </telerik:GridClientSelectColumn>
                                                <telerik:GridBoundColumn SortExpression="Course" HeaderText="Course" DataField="Course" UniqueName="Course" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Width="150px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn SortExpression="Ocurrences" HeaderText="Ocurrences" DataField="Ocurrences" UniqueName="Ocurrences" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="100px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false"></telerik:GridBoundColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                </div>
                            </telerik:RadSlidingPane>
                        </telerik:RadSlidingZone>
                    </telerik:RadPane>
                    <telerik:RadSplitBar ID="RadSplitbar1" runat="server" Height="100%">
                    </telerik:RadSplitBar>
                    <telerik:RadPane ID="MainPane" runat="server" Height="100%">
                        <div class="row">
                            <div class="col-8">
<%--                                <h3 class="section-to-print-title">
                                    <label id="lblTitle" runat="server" style="margin: 5px;"></label>
                                </h3>--%>
                            </div>
                            <div class="col-4">
                                <telerik:RadButton ID="rbAction" ValidationGroup="ConfirmAction" CausesValidation="true" runat="server" Text="" AutoPostBack="true" Primary="true" OnClick="rbAction_Click"></telerik:RadButton>
                                <button type="button" class="btn btn-secondary" onclick="window.print();">Print</button> 
                                <button type="button" class="btn btn-secondary" onclick="window.open('', '_self', ''); window.close();">Close</button> 
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" ValidationGroup="ConfirmAction" ControlToValidate="rtbNotes" runat="server" ErrorMessage="Please add some notes." CssClass="alert alert-warning" Display="Dynamic" ForeColor="Red" Font-Size="X-Small"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <telerik:RadLabel ID="rlMessage" runat="server"></telerik:RadLabel>
                        <asp:HiddenField ID="hfOutlineID" runat="server" />
                        <asp:SqlDataSource runat="server" ID="sqlFacultyReviewArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                            SelectCommand="SELECT ac.ExhibitID, [dbo].[CourseExistInCollege] (@CollegeID,sub.subject,cif.course_number) AS 'CourseExists', [dbo].[CheckArticulationExistInCollege](@CollegeID,sub.subject,cif.course_number, ac.AceID, ac.TeamRevd) AS 'ArticulationExists', [dbo].[GetArticulationMatrix](ac.id) 'Matrix', ac.id, ac.LastSubmittedOn as LastSubmitted, (SELECT STUFF((SELECT ', ' + criteria FROM (select ArticulationID, ArticulationType, Criteria from ArticulationCriteria join tblLookupConditions con on ConditionID = con.id) a where a.ArticulationID = ac.ArticulationID	and a.ArticulationType = ac.ArticulationType FOR XML PATH('')) ,1,1,'')) AS SelectedCriteria, sub.subject , cif.course_number , cif.course_title, case when ac.ArticulationType = 1 then 'ACE Course' else 'Occupation' end as 'ArticulationTypeName', ac.ArticulationID, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, ac.Title, ac.TeamRevd, ac.CreatedOn, cc.Occupation , ac.outline_id, s.RoleID, ac.id, ac.ArticulationType, ac.ArticulationStatus, ac.ArticulationStage ,  case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Office Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes, ac.Notes, ac.Justification, ac.ArticulationOfficerNotes,  ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.Exhibit,   concat(mu.firstname , ', ' , mu.lastname) as 'FullName' , cc.Occupation, ac.ModifiedBy, ac.Articulate, ac.CollegeID, c.CollegeAbbreviation as 'ArticulationCollege', STUFF((SELECT ',' + Criteria FROM ArticulationCriteria a where a.ArticulationID = ac.ArticulationID and a.ArticulationType =ac.ArticulationType FOR XML PATH('') ), 1, 1, '') Criteria FROM Articulation ac LEFT OUTER JOIN AceExhibit cc on ac.ExhibitID = cc.ID LEFT OUTER JOIN tblusers u on ac.CreatedBy = u.userid LEFT OUTER JOIN TBLUSERS mu on ac.LastSubmittedBy = mu.UserID LEFT OUTER JOIN Stages s on ac.ArticulationStage = s.Id LEFT OUTER JOIN Course_IssuedForm cif on ac.outline_id = cif.outline_id LEFT OUTER JOIN tblsubjects sub ON cif.subject_id = sub.subject_id LEFT OUTER JOIN LookupColleges C ON ac.CollegeID = C.CollegeID WHERE ac.id in (select value from [dbo].fn_split(@Articulations,',')) ORDER BY ac.LastSubmittedOn DESC">
                            <SelectParameters>
                                <asp:ControlParameter Name="Articulations" ControlID="hfArticulations" Type="String" PropertyName="Value" DefaultValue="" />
                                <asp:ControlParameter Name="CollegeID" ControlID="hvCollegeID" Type="Int32" PropertyName="Value" DefaultValue="0" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <label id="lblMessages" visible="false" runat="server" class="alert alert-info" style="margin-top: 5px; margin-bottom: 6px;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i></label>
                        <asp:Label ID="lConfirmText" runat="server" CssClass="d-block alert alert-success"></asp:Label>
                        <asp:Panel ID="pnlCriteriaPackage" runat="server" Visible="false">
                            <div class="row rounded-2 bg-light mb-2 p-2">
                                <div class="col-md-6">
                                    <h3>Course(s)</h3>
                                    <telerik:RadLabel ID="rlCourses" runat="server"></telerik:RadLabel>
                                </div>
                                <div class="col-md-6">
                                    <h3>Credit Recommendation(s)</h3>
                                    <telerik:RadLabel ID="rlCriteria" runat="server"></telerik:RadLabel>
                                </div>
                            </div>
                        </asp:Panel>
                        <telerik:RadTextBox ID="rtbNotes" ValidationGroup="ConfirmAction" EmptyMessage="Please add some notes..." runat="server" InputType="Text" TextMode="MultiLine" Rows="4" Skin="Metro" Width="100%" BackColor="LightYellow"></telerik:RadTextBox>
                        <br />
                        <br />
                        <div class="section-to-print2">
                        <telerik:RadGrid ID="rgFacultyReviewArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlFacultyReviewArticulations" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" OnItemCommand="rgFacultyReviewArticulations_ItemCommand" RenderMode="Lightweight" OnItemDataBound="rgFacultyReviewArticulations_ItemDataBound" AllowMultiRowSelection="true" OnPreRender="rgFacultyReviewArticulations_PreRender">
                            <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" EnableAlternatingItems="false">
                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                                <ClientEvents OnRowDblClick="RowDblClickHighlightCriteria" OnRowContextMenu="demo.RowContextMenu" />
                            </ClientSettings>
                            <MasterTableView Name="ParentGrid" DataSourceID="sqlFacultyReviewArticulations" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" HierarchyDefaultExpanded="true" HierarchyLoadMode="Client" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1" EnableHeaderContextMenu="true" AllowPaging="false">
                                <CommandItemTemplate>
                                    <div class="commandItems" style="padding: 5px;">
                                        <div class="row">
                                            <div class="col-sm-8">
                                                <telerik:RadButton runat="server" ID="btnAdopt" ToolTip="Check to adopt selected articulations." CommandName="Adopt" Text=" Adopt selected articulations" ButtonType="LinkButton">
                                                    <ContentTemplate>
                                                        <i class="fa fa-clone"></i>Adopt 
                                           
                                                    </ContentTemplate>
                                                </telerik:RadButton>
                                                <telerik:RadButton runat="server" ID="btnMoveForward" OnClientClick="javascript:if(!confirm('Are you sure you want to approve this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="MoveForward" CommandName="MoveForward" ToolTip="Approve selected articulation(s)">
                                                    <ContentTemplate>
                                                        <i class='fa fa-send'></i><span class="txtMoveForward">Approve</span>
                                                    </ContentTemplate>
                                                </telerik:RadButton>
                                                <telerik:RadButton runat="server" ID="btnReturn" OnClientClick="javascript:if(!confirm('Are you sure you want to Return this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Return" CommandName="Return" ToolTip="Return selected articulation(s)">
                                                    <ContentTemplate>
                                                        <i class='fa fa-hand-o-left'></i>Return
                                           
                                                    </ContentTemplate>
                                                </telerik:RadButton>
                                                <telerik:RadButton runat="server" ID="btnDenied" OnClientClick="javascript:if(!confirm('Are you sure you want to Deny this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Deny" CommandName="Denied" ToolTip="Deny selected articulation(s)">
                                                    <ContentTemplate>
                                                        <i class='fa fa-ban'></i>Deny
                                           
                                                    </ContentTemplate>
                                                </telerik:RadButton>
                                            </div>
                                            <div class="col-sm-4 text-right" style="padding-top: 5px;">
                                                <asp:Label runat="server" ID="lblDanger" CssClass="alert"></asp:Label>
                                                &nbsp;
                                               
                                            <asp:Label runat="server" ID="lblWarning" CssClass="alert"></asp:Label>
                                                &nbsp;
                                               
                                            <asp:Label runat="server" ID="lblSuccess" CssClass="alert"></asp:Label>
                                                &nbsp;
                                   
                                            </div>
                                        </div>
                                    </div>
                                </CommandItemTemplate>
                                <Columns>
                                    <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                                    </telerik:GridClientSelectColumn>
                                    <telerik:GridBoundColumn DataField="CourseExists" UniqueName="CourseExists" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationExists" UniqueName="ArticulationExists" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationCollege" UniqueName="ArticulationCollege" HeaderText="College" HeaderStyle-Width="60px" FilterControlWidth="60px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="false" Visible="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="subject" UniqueName="subject" HeaderText="Subject" HeaderStyle-Width="60px" FilterControlWidth="60px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="false" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="true" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" ItemStyle-Width="80px" HeaderText="Type" AllowFiltering="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="80px" AllowFiltering="false" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn UniqueName="AceIDExhibitLink" HeaderText="ACE ID" SortExpression="AceID">
                                        <ItemTemplate>
                                            <asp:HyperLink NavigateUrl="javascript:showExhibit();" runat="server" ID="hlAceIDExhibit" Text="" Font-Underline="true"></asp:HyperLink>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" AllowFiltering="false">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false" Display="false">
                                    </telerik:GridBoundColumn>  
                                    <telerik:GridTemplateColumn UniqueName="ExhibitLink" HeaderText="Exhibit Title" SortExpression="Title">
                                        <ItemTemplate>
                                            <asp:HyperLink NavigateUrl="javascript:showExhibit();" runat="server" ID="hlExhibit" Text="" Font-Underline="true"></asp:HyperLink>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false" EmptyDataText="">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes" Display="false">
                                        <ItemTemplate>
                                            <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                            <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                                                <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                                            </telerik:RadToolTip>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn SortExpression="SelectedCriteria" HeaderText="Credit Recommendation" DataField="SelectedCriteria" UniqueName="SelectedCriteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Submitted By" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="100px" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridDateTimeColumn DataField="CreatedOn" DataType="System.DateTime" FilterControlAltText="Filter CreatedOn column" HeaderText="Created On" SortExpression="CreatedOn" UniqueName="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true" Display="false">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridDateTimeColumn DataField="LastSubmitted" DataType="System.DateTime" FilterControlAltText="Filter LastSubmitted column" HeaderText="Last Submitted" SortExpression="LastSubmitted" UniqueName="LastSubmitted" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true" Display="false">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </telerik:GridDateTimeColumn>
                                    <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="EntityType" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="CollegeID" UniqueName="CollegeID" Display="false"></telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="StartDate" DataType="System.DateTime" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="EndDate" DataType="System.DateTime" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                </Columns>
                                <NestedViewTemplate>
                                    <div class="row" style="padding: 5px; font-size: 10px;">
                                        <div class="col-sm-4">
                                            <p class="bold">Articulation Matrix</p>
                                            <%# Eval("Matrix") %>
                                        </div>
                                        <div class="col-sm-4">
                                            <p class="bold">Evaluator Notes</p>
                                            <%# Eval("Notes") %>
                                            <p class="bold">Faculty Notes</p>
                                            <%# Eval("Justification") %>
                                            <p class="bold">Articulation Officer Notes</p>
                                            <%# Eval("ArticulationOfficerNotes") %>
                                        </div>
                                        <div class="col-sm-4">
                                            <p class="bold">Selected Criteria</p>
                                            <%# Eval("SelectedCriteria") %>
                                        </div>
                                    </div>
                                </NestedViewTemplate>
                            </MasterTableView>
                        </telerik:RadGrid>
                        </div>
                        <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" runat="server" />
                        <input type="hidden" id="radGridClickedRowIndexAdopt" name="radGridClickedRowIndexAdopt" runat="server" />
                        <input type="hidden" id="hvOutlineID" name="hvOutlineID" runat="server" />
                        <input type="hidden" id="hvID" name="hvID" runat="server" />
                        <input type="hidden" id="hvArticulationID" name="hvArticulationID" runat="server" />
                        <input type="hidden" id="hvArticulationType" name="hvArticulationType" runat="server" />
                        <input type="hidden" id="hvArticulationStage" name="hvArticulationStage" runat="server" />
                        <input type="hidden" id="hvAceID" name="hvAceID" runat="server" />
                        <input type="hidden" id="hvTeamRevd" name="hvTeamRevd" runat="server" />
                        <input type="hidden" id="hvTitle" name="hvTitle" runat="server" />
                        <input type="hidden" id="hvCriteriaPackageID" name="hvCriteriaPackageID" runat="server" />
                        <input type="hidden" id="hvExhibitID" name="hvExhibitID" runat="server" />
                        <telerik:RadContextMenu ID="RadMenu1" runat="server" OnItemClick="RadMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
                            <Items>
                                <telerik:RadMenuItem Text="Approve" Value="MoveForward">
                                </telerik:RadMenuItem>
                                <telerik:RadMenuItem Text="Archive" Value="Archive">
                                </telerik:RadMenuItem>
                                <telerik:RadMenuItem Text="Deny" Value="Denied">
                                </telerik:RadMenuItem>
                                <telerik:RadMenuItem Text="Edit Articulation" Value="Edit">
                                </telerik:RadMenuItem>
                                <telerik:RadMenuItem Text="Return" Value="Return">
                                </telerik:RadMenuItem>
                                <telerik:RadMenuItem Text="View Articulation" Value="View">
                                </telerik:RadMenuItem>
                                <telerik:RadMenuItem Text="View Exhibit" Value="ViewExhibit">
                                </telerik:RadMenuItem>
                            </Items>
                        </telerik:RadContextMenu>
                        <telerik:RadContextMenu ID="RadMenuAdopt" runat="server" OnItemClick="RadMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
                            <Items>
                                <telerik:RadMenuItem Text="Adopt" Value="Adopt">
                                </telerik:RadMenuItem>
                                <telerik:RadMenuItem Text="View" Value="View">
                                </telerik:RadMenuItem>
                            </Items>
                        </telerik:RadContextMenu>
                    </telerik:RadPane>
                </telerik:RadSplitter>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        ; (function ($, undefined) {
            var menu;
            var grid;
            var demo = window.demo = {};

            Sys.Application.add_load(function () {
                grid = $telerik.findControl(document, "rgFacultyReviewArticulations");
                menu = $telerik.findControl(document, "RadMenu1");
                menu_adopt = $telerik.findControl(document, "RadMenuAdopt");
            });

            demo.RowContextMenu = function (sender, eventArgs) {
                var evt = eventArgs.get_domEvent();
                if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
                    return;
                }

                var index = eventArgs.get_itemIndexHierarchical();

                sender.get_masterTableView().selectItem(sender.get_masterTableView().get_dataItems()[index].get_element(), true);

                var selectedRow = sender.get_masterTableView().get_selectedItems()[0];

                var outline_id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "outline_id").innerHTML;
                var id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "id").innerHTML;
                var articulation_id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "ArticulationID").innerHTML;
                var articulation_type = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "ArticulationType").innerHTML;
                var articulation_stage = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "ArticulationStage").innerHTML;
                var ace_id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "AceID").innerHTML;
                var team_revd = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "TeamRevd").innerHTML;
                var title = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "Title").innerHTML;
                var exhibit_id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "ExhibitID").innerHTML;

                $('#<%=hvOutlineID.ClientID%>').val(outline_id);
                $('#<%=hvID.ClientID%>').val(id);
                $('#<%=hvArticulationID.ClientID%>').val(articulation_id);
                $('#<%=hvArticulationType.ClientID%>').val(articulation_type);
                $('#<%=hvArticulationStage.ClientID%>').val(articulation_stage);
                $('#<%=hvAceID.ClientID%>').val(ace_id);
                $('#<%=hvTeamRevd.ClientID%>').val(team_revd);
                $('#<%=hvTitle.ClientID%>').val(title);
                $('#<%=hvExhibitID.ClientID%>').val(exhibit_id);

                var college_id = $('#<%=hvCollegeID.ClientID%>').val();
                var from_college_id = $('#<%=hvFromUserCollegeID.ClientID%>').val();

                if (college_id != from_college_id) {
                    menu_adopt.show(evt);
                } else {
                    menu.show(evt);
                }

                evt.cancelBubble = true;
                evt.returnValue = false;

                if (evt.stopPropagation) {
                    evt.stopPropagation();
                    evt.preventDefault();
                }
            };

        })($telerik.$);


        function readMessageCommand(sender, args) {
            var index = args.get_itemIndexHierarchical();
            sender.get_masterTableView().fireCommand("View", index);
        }


    </script>
</asp:Content>
