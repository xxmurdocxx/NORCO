<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssignArticulation.aspx.cs" Inherits="ems_app.modules.popups.AssignArticulation" ValidateRequest="false" %>
<%@ Register Src="~/UserControls/DisplayMessages.ascx" TagPrefix="uc" TagName="DisplayMessages" %>
<%@ Register src="~/UserControls/ArticulationDocuments.ascx" tagname="ArticulationDocuments" tagprefix="uc1" %>
<%@ Register src="~/UserControls/AuditTrail.ascx" tagname="AuditTrail" tagprefix="uc" %>
<%@ Register src="~/UserControls/ArticulateWithOtherCourses.ascx" tagname="ArticulateWithOtherCourses" tagprefix="uc2" %>
<%@ Register Src="~/UserControls/OtherCollegesNotes.ascx" TagPrefix="uc" TagName="OtherCollegesNotes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet"/>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlEligibility" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ac.ID, cc.AceID, cc.TeamRevd, cc.Exhibit,  cc.Title, ac.ForAssociateOnly , ac.ForTransfer from  Articulation ac left outer join AceExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd  where ac.outline_id = @outline_id and cc.AceType = 1 and ac.ArticulationStage = @ArticulationStage  order by cc.AceID, cc.TeamRevd" UpdateCommand="update Articulation set ForAssociateOnly = @ForAssociateOnly , ForTransfer = @ForTransfer where id = @ID">
            <SelectParameters>
                <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
                <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                <asp:ControlParameter ControlID="hvUserArticulationStage" DefaultValue="0" Name="ArticulationStage" PropertyName="Value" />
                <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="ID" Type="Int32" />
                <asp:Parameter Name="ForAssociateOnly" Type="Boolean" />
                <asp:Parameter Name="ForTransfer" Type="Boolean" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlArticulationType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from ArticulationType"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlOtherRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select  [dbo].[GetRecommendationHighlightedCriteria] (aod.id, ac.id, 1 ) AS HighlightRecommendation, ac.outline_id, ac.ID, ac.ArticulationID, cc.AceID, cc.TeamRevd, aod.ID RecommendationID, ac.Recommendation as 'RecommendationIDs', [dbo].[RecommendationIsChecked] (ac.Recommendation, aod.ID) as 'RecommendationIsChecked', cc.Exhibit, cc.Title, aod.CourseDetail as 'Recommendation' from Articulation ac left outer join AceCourseCatalog cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join AceCatalogDetail aod on ac.AceID = aod.AceID and ac.TeamRevd = aod.TeamRevd where ac.outline_id = @outline_id and aod.CourseDetail like '%<b>Credit Recommendation%' and ac.ArticulationStage = @ArticulationStage  order by cc.Exhibit, aod.CourseDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
                <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                <asp:ControlParameter ControlID="hvUserArticulationStage" DefaultValue="0" Name="ArticulationStage" PropertyName="Value" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlConditions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM tblLookupConditions order by ConditionName"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCoursesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlACECoursesHeader" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct AceID, Exhibit, Title, CourseNumber, Location, CourseLength from AceCourseCatalog ac WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, isnull([dbo].[GetRecommendationCriteriaFlags] (id, @ArticulationID, 1 ),'') + ' ' + CourseDetail as 'Recommendation' from AceCatalogDetail where CourseDetail like '%<b>Credit Recommendation: </b>%' and AceID = @AceID and TeamRevd = @TeamRevd">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                <asp:ControlParameter Name="ArticulationID" ControlID="hvArticulationID" PropertyName="Value" Type="Int32" ConvertEmptyStringToNull="true" /> 
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlPreviousStages" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetPreviousStages" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                <asp:ControlParameter Name="StageId" ControlID="hvArticulationStage" PropertyName="Value" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlStudentLearningOutcome" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [StudentLearningOutcome] WHERE ([outline_id] = @outline_id) ORDER BY [id]">
            <SelectParameters>
                <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct p.program_id, concat('<h3>',p.program,'</h3><p>',DBO.Get_Value_IssuedFromProperties_POS(p.IssuedFormID, 'DevelopedSLODescription'),'</p>') program from Program_IssuedForm p where p.program_id in ( select pc.program_id from tblProgramCourses pc left outer join Program_IssuedForm pif on pc.program_id = pif.program_id  where pc.outline_id = @outline_id) and DBO.Get_Value_IssuedFromProperties(p.IssuedFormID, 'DevelopedSLODescription') <> '' and p.status = 0 and college_id = @CollegeID">
            <SelectParameters>
                    <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCrossListingCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetCrossListingCourses" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
        <uc:DisplayMessages id="DisplayMessagesControl" runat="server"></uc:DisplayMessages>
        <div id="divArticulationCreated" class="ArticulationCreated" style="display:none;">
            <p style="color:#fff;font-weight:bold;">
                <i class="fa fa-check-circle-o fa-5x" aria-hidden="true"></i>Articulation successfully created!
            </p>
        </div> 
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
                    <div class="col-sm-2">
                    </div>
                    <div class="col-sm-10 text-right">
                        <telerik:RadButton ID="rbOpendInNewWindow" runat="server" Text="Open In New Window" OnClientClicked="OpenInNewWindow">
                            <Icon PrimaryIconCssClass="rbOpen"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton runat="server" ID="btnPublish" CssClass="radButtonFontAwesome" ButtonType="StandardButton" Text="Publish" Enabled="false" OnClick="btnPublish_Click">
                            <ContentTemplate>
                                <i class='fa fa-newspaper-o'></i>Publish / Unpublish
                            </ContentTemplate>
                        </telerik:RadButton>
                        <telerik:RadButton runat="server" ID="btnReturn" Text="Return" ButtonType="LinkButton" OnClick="btnReturn_Click" OnClientClicking="SubmitArticulationConfirm" CssClass="radButtonFontAwesome">
                            <Icon PrimaryIconCssClass="rbPrevious"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton runat="server" ID="btnSubmit" Text="Approve" ButtonType="LinkButton" OnClick="btnSubmit_Click" OnClientClicking="SubmitArticulationConfirm" CssClass="radButtonFontAwesome">
                            <Icon PrimaryIconCssClass="rbNext"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton ID="rbAssign" runat="server" Text="Save Articulation" OnClick="rbAssign_Click"  Visible="false">
                            <Icon PrimaryIconCssClass="rbSave"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton ID="rbDelete" runat="server" Text="Delete" Visible="false" OnClick="rbDelete_Click">
                            <Icon PrimaryIconCssClass="rbRemove"></Icon>
                            <ConfirmSettings ConfirmText="Are you sure you want to Delete this articulation? If you proceed the articulation will be deleted and this page will be closed, please refresh the articulation in proces homepage." />
                        </telerik:RadButton>
                        <telerik:RadButton ID="rbDontArticulate" runat="server" Text="Deny" OnClick="rbDontArticulate_Click">
                            <Icon PrimaryIconCssClass="rbCancel"></Icon>
                            <ConfirmSettings ConfirmText="Are you sure you want to Deny this articulation?" />
                        </telerik:RadButton>
                        <telerik:RadButton ID="rbArchive" runat="server" Text="Archive" Visible="false" OnClick="rbArchive_Click" OnClientClicking="ArchiveConfirm">
                            <Icon PrimaryIconCssClass="rbSave"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton ID="rbAdoptArticulation" runat="server" Text="Adopt Articulation" OnClick="rbAdoptArticulation_Click"  BackColor="LightGreen">
                            <Icon PrimaryIconCssClass="rbAdd"></Icon>
                        </telerik:RadButton>
                        <asp:label id="lblDenied" runat="server" CssClass="d-inline-block alert alert-danger"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> This articulation has been denied</asp:label>
                        <asp:label id="lblArchived" runat="server" CssClass="d-inline-block alert alert-danger"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> This articulation has been archived</asp:label>
                        <asp:label id="lblAdopt" runat="server" CssClass="d-inline-block alert alert-warning"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> </asp:label> 
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-4"><h3 id="lblCollegeToAdopt" runat="server"></h3></div>
                    <div class="col-sm-4 text-center"><h1>Articulation Details</h1></div>
                    <div class="col-sm-4">&nbsp;</div>
                </div>
                <div class="row">
                    <div class="col-sm-12"><h3 id="lblArticulationTitle" runat="server"></h3></div>
                </div>
                <div class="clearfix"></div>
                <telerik:RadTabStrip runat="server" ID="RadTabStrip1" MultiPageID="RadMultiPage1" SelectedIndex="0" Width="99%" Height="50px" ShowBaseLine="true" RenderMode="Lightweight">
                    <Tabs>
                        <telerik:RadTab Text="Selected Articulation" ToolTip="" Selected="True">
                        </telerik:RadTab>
                        <telerik:RadTab Text="Recommendations" ToolTip="">
                        </telerik:RadTab>
                        <telerik:RadTab Text="Eligibility" ToolTip="" Visible="false">
                        </telerik:RadTab>
                        <telerik:RadTab Text="Articulate with Other Courses" ToolTip="Articulate with other available courses.">
                        </telerik:RadTab>
                    </Tabs>
                </telerik:RadTabStrip>
                <telerik:RadMultiPage runat="server" ID="RadMultiPage1" SelectedIndex="0" Width="99%" RenderMode="Lightweight">
                    <telerik:RadPageView runat="server" ID="RadPageView1" Width="100%">
                        <div class="row">
                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <asp:TextBox ID="tbID" runat="server" CssClass="displayNone"></asp:TextBox>
                                <asp:HiddenField ID="hvId" runat="server" />
                                <asp:HiddenField ID="hvArticulationStage" runat="server" />
                                <asp:HiddenField ID="hvArticulationID" runat="server" />
                                <asp:HiddenField ID="hvArticulationType" Value="1" runat="server" />
                                <asp:HiddenField ID="hvUserArticulationStage" runat="server" />
                                <asp:HiddenField ID="hvArticulationStatus" runat="server" />
                                <asp:HiddenField ID="hvArticulate" runat="server" />
                                <asp:HiddenField ID="hvOutlineID" runat="server" />
                                <asp:HiddenField ID="hvSubject" runat="server" />
                                <asp:HiddenField ID="hvCourseNumber" runat="server" />
                                <asp:HiddenField ID="hvUserStageID" runat="server" ClientIDMode="Static" />
                                <asp:HiddenField ID="hvCurrentStageID" runat="server" />
                                <asp:HiddenField ID="hvCollegeID" runat="server" />
                                <asp:HiddenField ID="hvRoleID" runat="server" />
                                <asp:HiddenField ID="hvRoleName" runat="server" ClientIDMode="Static" />
                                <asp:HiddenField ID="hvUserID" runat="server" />
                                <asp:HiddenField ID="hvAceID" runat="server" />
                                <asp:HiddenField ID="hvTitle" runat="server" />
                                <asp:HiddenField ID="hvTeamRevd" runat="server" />
                                <asp:HiddenField ID="hvFirstStage" runat="server" ClientIDMode="Static" />
                                <asp:HiddenField ID="hvLastStage" runat="server" />
                                <asp:HiddenField ID="hvCourse" runat="server" />
                                <asp:HiddenField ID="hvFrom" runat="server" />
                                <asp:HiddenField ID="hvEnforceFacultyReview" runat="server" />
                                <asp:HiddenField ID="hvOtherCollegeID" runat="server" />

                                <asp:HiddenField ID="hvIsArticulationOfficer" runat="server" ClientIDMode="Static" />
                                <asp:HiddenField ID="hvReviewArticulations" runat="server" ClientIDMode="Static" />

                                <h2>Course Information</h2>
                                <div class="courseDetails">
                                    <asp:Repeater ID="Repeater1" runat="server"
                                        DataSourceID="sqlCoursesDetails">
                                        <HeaderTemplate>
                                            <table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label9" Text='Course : ' Font-Bold="true" /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label10" Text='<%# String.Concat(Eval("_Subject"), " ", Eval("_CourseNumber")) %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label3" Text='Title : ' Font-Bold="true" /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label4" Text='<%# Eval("_CourseTitle") %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label15" Text='Units : ' Font-Bold="true" /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label16" Text='<%# Eval("_Units") %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label7" Text='Division : ' Font-Bold="true" /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label8" Text='<%# Eval("_Division") %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label11" Text='Catalog Description : ' Font-Bold="true" /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div><%# Eval("_CatalogDescription").ToString().Replace("<br />","") %></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label13" Text='Course Notes : ' Font-Bold="true" /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div><%# Eval("_CourseNotes") %></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label12" Text='Student Objectives : ' Font-Bold="true" /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div><%# Eval("_StudentObjectives") %></div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                    <h2>Student Learning Outcomes</h2>
                                    <telerik:RadGrid ID="rgStudentLearningOutcomes" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlStudentLearningOutcome" Width="100%">
                                        <GroupingSettings CaseSensitive="false" />
                                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="sqlStudentLearningOutcome" CommandItemDisplay="None" PageSize="10">
                                            <BatchEditingSettings EditType="Row" />
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="id" HeaderText="ID" UniqueName="id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="outline_id" HeaderText="Outline ID" UniqueName="outline_id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn UniqueName="RowNumber" HeaderText="">
                                                    <ItemTemplate>
                                                        <%#Container.ItemIndex+1%>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="40px" />
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="SLODescription" HeaderText="SLO Description" UniqueName="SLODescription" ColumnEditorID="TextEditor">
                                                </telerik:GridBoundColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                    <h2>Program Learning Outcomes</h2>
                        <telerik:RadGrid ID="rgPLOs" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlPrograms" AutoGenerateColumns="False" HeaderStyle-Font-Bold="true" RenderMode="Lightweight">
                            <MasterTableView Name="ParentGrid" DataKeyNames="program_id" DataSourceID="sqlPrograms" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="false" HeaderStyle-Font-Bold="true" AutoGenerateColumns="false" >
                                <Columns>
                                    <telerik:GridBoundColumn DataField="program_id" DataType="System.Int32" FilterControlAltText="Filter program_id column" HeaderText="program_id" SortExpression="program_id" UniqueName="program_id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridHTMLEditorColumn DataField="program" FilterControlAltText="Filter program column" HeaderText="Program of Study" SortExpression="program" UniqueName="program" ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="150px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                    </telerik:GridHTMLEditorColumn>
                                </Columns>
                                <NoRecordsTemplate>
                                    <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                        &nbsp;No Program Learning Outcomes found
                                    </div>
                                </NoRecordsTemplate>
                            </MasterTableView>
                        </telerik:RadGrid>
                                    <h2>Cross Listing Courses</h2>
                                    <telerik:RadGrid ID="rgCrossListingCourses" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlCrossListingCourses" AutoGenerateColumns="False" HeaderStyle-Font-Bold="true" RenderMode="Lightweight">
                                        <MasterTableView Name="ParentGrid" DataKeyNames="outline_id" DataSourceID="sqlCrossListingCourses" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="false" HeaderStyle-Font-Bold="true" AutoGenerateColumns="false">
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="150px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Course Number" SortExpression="course_number" UniqueName="course_number" ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="150px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Subject" SortExpression="course_title" UniqueName="course_title" ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="150px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                                </telerik:GridBoundColumn>
                                            </Columns>
                                            <NoRecordsTemplate>
                                                <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                                    &nbsp;No Cross Listing courses found
                                                </div>
                                            </NoRecordsTemplate>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                </div>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <h2>ACE Course Exhibit</h2>
                                <telerik:RadTabStrip RenderMode="Lightweight" ID="tsVersions" runat="server"  EnableDragToReorder="true" MultiPageID="rmpVersions" SelectedIndex="0">
                                    <Tabs>
                                        <telerik:RadTab Text="Current Version"></telerik:RadTab>
                                        <telerik:RadTab Text="Legacy Version"></telerik:RadTab>
                                    </Tabs>
                                </telerik:RadTabStrip>
                                <telerik:RadMultiPage ID="rmpVersions" runat="server"  CssClass="RadMultiPage" SelectedIndex="0">
                                    <telerik:RadPageView ID="rpvCurrentVersion" runat="server" Style="overflow: hidden">
                                <div class="courseDetails">
                                    <asp:SqlDataSource ID="sqlHighlightedCurrentVersion" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArticulationHighlightedCriteriaCurrentVersion" SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                            <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                            <asp:ControlParameter Name="ArticulationID" ControlID="hvArticulationID" PropertyName="Value" Type="Int32" ConvertEmptyStringToNull="true" /> 
                                            <asp:Parameter Name="ArticulationType" DefaultValue="1" Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:Repeater ID="rptCurrentVerion" runat="server" DataSourceID="sqlHighlightedCurrentVersion">
                                        <HeaderTemplate>
                                            <table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label2" Text='<%# Eval("Recommendations") %>' /></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                    <br />
                                    <asp:SqlDataSource ID="sqlLocations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct  Location  from AceExhibitLocation ac WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd and ac.EndDate = (select max(EndDate) from AceExhibitLocation WHERE  AceID = @AceID and TeamRevd = @TeamRevd group by AceID, TeamRevd)">
                                        <SelectParameters>
                                            <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                            <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:Repeater ID="Repeater3" runat="server" DataSourceID="sqlLocations">
                                        <HeaderTemplate>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="Label7" Text='Location(s) : ' Font-Bold="true" /></td>
                                                </tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label8" Text='<%# Eval("Location") %>' /></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                    <asp:SqlDataSource ID="sqlExhibitRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select Recommendation, LearningOutcome  from ACEExhibitRecommendation ac WHERE ac.AceID = @AceID and ac.TeamRevd = @TeamRevd">
                                        <SelectParameters>
                                            <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                            <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <br />
                                    <asp:Repeater ID="Repeater5" runat="server" DataSourceID="sqlExhibitRecommendations">
                                        <HeaderTemplate>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="Label7" Text='Student Learning Outcomes' Font-Bold="true" /></td>
                                                </tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label8" Font-Bold="true" Text='<%# Eval("Recommendation") %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label11" Text='<%# Eval("LearningOutcome") %>' /></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                        </div>
                                    </telerik:RadPageView>
                                    <telerik:RadPageView ID="rpvLegacyVersion" runat="server" Style="overflow: hidden">
                                        <div class="courseDetails">
                                            <asp:Repeater ID="Repeater2" runat="server"
                                                DataSourceID="sqlACECoursesHeader">
                                                <HeaderTemplate>
                                                    <table>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label1" Text='Course Exhibit : ' Font-Bold="true" /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label2" Text='<%# Eval("Exhibit") %>' /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label3" Text='Title : ' Font-Bold="true" /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label4" Text='<%# Eval("Title") %>' /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label5" Text='Course Number : ' Font-Bold="true" /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label6" Text='<%# Eval("CourseNumber") %>' /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label14" Text='Length : ' Font-Bold="true" /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label17" Text='<%# Eval("CourseLength") %>' /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label7" Text='Location : ' Font-Bold="true" /></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label8" Text='<%# Eval("Location") %>' /></td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                    </table>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                            <br />
                                            <asp:Repeater ID="Repeater4" runat="server"
                                                DataSourceID="sqlHighlightedRecommendations">
                                                <HeaderTemplate>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Eval("Recommendations") %>
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </telerik:RadPageView>
                                </telerik:RadMultiPage>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                                <asp:Panel ID="pnlPrevious" runat="server" Visible="False" BackColor="#95DD77">
                                    <br />
                                    <telerik:RadComboBox ID="rcbPreviousStage" runat="server" Culture="es-ES" DataSourceID="sqlPreviousStages" DataTextField="RoleName" DataValueField="id" Label="Return to : " Text="Select Previous Stage : " Width="200px">
                                    </telerik:RadComboBox>
                                    <telerik:RadButton runat="server" ID="rbSubmitPrevious" Text="" ButtonType="LinkButton" OnClick="rbSubmitPrevious_Click">
                                        <Icon PrimaryIconCssClass="rbOk"></Icon>
                                    </telerik:RadButton>
                                    <telerik:RadButton runat="server" ID="rbCancel" Text="" ButtonType="LinkButton" OnClick="rbCancel_Click">
                                        <Icon PrimaryIconCssClass="rbCancel"></Icon>
                                    </telerik:RadButton>
                                    <br />
                                    <br />
                                </asp:Panel>
                                <div class="row" style="display: none;">
                                    <div class="col-xs-12">
                                        <label>Add a condition : </label>
                                        <telerik:RadComboBox RenderMode="Lightweight" ID="rcbCondition" runat="server" Width="50px" DropDownWidth="50px" Height="80px" DataSourceID="sqlConditions" DataValueField="id" DataTextField="ConditionSymbol">
                                        </telerik:RadComboBox>
                                    </div>
                                    <div class="col-md-12 col-xs-12">
                                        <label><strong>Request for : </strong></label>
                                        <telerik:RadComboBox RenderMode="Lightweight" ID="rcbArticulationType" runat="server" Width="100px" DropDownAutoWidth="Enabled" Height="80px" DataSourceID="sqlArticulationType" DataValueField="id" DataTextField="Description">
                                        </telerik:RadComboBox>
                                        <br />
                                        <h3>Criteria :</h3>
                                        <telerik:RadEditor runat="server" ID="reCriteria" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="150px" Width="95%" RenderMode="Lightweight">
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
                                </div>
                                <asp:Panel id="pnlCriteria" runat="server">
                                    <asp:SqlDataSource ID="sqlHighlightedRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArticulationHighlightedCriteria" SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                                            <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
                                            <asp:ControlParameter Name="ArticulationID" ControlID="hvArticulationID" PropertyName="Value" Type="Int32" ConvertEmptyStringToNull="true" /> 
                                            <asp:Parameter Name="ArticulationType" DefaultValue="1" Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [ArticulationCriteria] WHERE [CriteriaID] = @CriteriaID" SelectCommand="SELECT ac.*, u.LastName + ', ' + u.FirstName as FullName FROM [ArticulationCriteria] ac left outer join TBLUSERS u on ac.CreatedBy = u.UserID  WHERE ac.ArticulationID = @ArticulationID AND ac.ArticulationType = @ArticulationType  and ac.[CriteriaType]= 1">  
                                        <DeleteParameters> 
                                            <asp:Parameter Name="CriteriaID" Type="Int32" /> 
                                        </DeleteParameters>
                                        <SelectParameters> 
                                            <asp:ControlParameter Name="ArticulationID" ControlID="hvArticulationID" PropertyName="Value" Type="Int32" /> 
                                            <asp:Parameter Name="ArticulationType" DefaultValue="1" Type="Int32" /> 
                                        </SelectParameters> 
                                    </asp:SqlDataSource>
                                    <h2>Recommendations Criteria</h2>
                                    <telerik:RadTextBox ID="rtbCriteria" runat="server" Width="175px" Visible="false"></telerik:RadTextBox>
                                   <asp:SqlDataSource ID="sqlCriteriaList" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"  SelectCommand="select CriteriaID, case when SkillLevel is NULL then Criteria else SkillLevel + ' - ' + Criteria END as Criteria from AceExhibitCriteria where CriteriaID IN (SELECT max(CriteriaID) CriteriaID FROM [ACEExhibitCriteria] WHERE AceID = @AceID AND TeamRevd = @TeamRevd and AceType = @ArticulationType AND ltrim(rtrim(Criteria)) NOT IN ( SELECT ltrim(rtrim(ac.CRITERIA)) FROM [ArticulationCriteria] ac  WHERE ac.ArticulationID = @ArticulationID and ac.ArticulationType = @ArticulationType  and ac.[CriteriaType]= 1 ) GROUP BY Criteria ) order by Criteria">  
                                        <SelectParameters> 
                                            <asp:ControlParameter Name="AceID" ControlID="hvAceID" PropertyName="Value" /> 
                                            <asp:ControlParameter Name="TeamRevd" ControlID="hvTeamRevd" PropertyName="Value" />
                                            <asp:ControlParameter Name="ArticulationType" ControlID="hvArticulationType" PropertyName="Value" /> 
                                            <asp:ControlParameter Name="ArticulationID" ControlID="hvArticulationID" PropertyName="Value" Type="Int32" /> 
                                        </SelectParameters> 
                                    </asp:SqlDataSource>
                                    <div class="container">
                                        <div class="row">
                                    <telerik:RadComboBox RenderMode="Lightweight" ID="rcbCriteriaList" runat="server" Width="250px" DropDownWidth="250px" Height="180px" DataSourceID="sqlCriteriaList" DataValueField="CriteriaID" DataTextField="Criteria" EmptyMessage="Select a criteria" AllowCustomText="true" DropDownAutoWidth="Enabled" Filter="Contains">
                                    </telerik:RadComboBox><br /><br />
                                    <telerik:RadComboBox RenderMode="Lightweight" ID="rcbCriteriaCondition" runat="server" Width="75px" DropDownWidth="75px" Height="80px" DataSourceID="sqlConditions" DataValueField="id" DataTextField="ConditionSymbol" DropDownAutoWidth="Enabled">
                                    </telerik:RadComboBox>
                                    <telerik:RadColorPicker RenderMode="Lightweight" runat="server" SelectedColor="#00B0F0" ID="rcpColor" ShowIcon="true" Preset="None" ShowEmptyColor="false" Visible="false">
                                        <telerik:ColorPickerItem Title="Blue" Value="#00B0F0"></telerik:ColorPickerItem>
                                        <telerik:ColorPickerItem Title="Green" Value="#92D050"></telerik:ColorPickerItem>
                                        <telerik:ColorPickerItem Title="Yellow" Value="#FFFF66"></telerik:ColorPickerItem>
                                        <telerik:ColorPickerItem Title="Red" Value="#FF9999"></telerik:ColorPickerItem>
                                        <telerik:ColorPickerItem Title="Gray" Value="#BBBBBB"></telerik:ColorPickerItem>
                                    </telerik:RadColorPicker>
                                    <telerik:RadColorPicker RenderMode="Lightweight" runat="server" SelectedColor="#000000" ID="rcpFontcolor" ShowIcon="true" Preset="None" Visible="false">
                                        <telerik:ColorPickerItem Title="Blue" Value="#000000"></telerik:ColorPickerItem>
                                        <telerik:ColorPickerItem Title="Green" Value="#FFFFFF"></telerik:ColorPickerItem>
                                    </telerik:RadColorPicker>
                                    <telerik:RadButton ID="rbAddCriteria" runat="server" Text="Add" OnClick="rbAddCriteria_Click" Font-Bold="true" ToolTip="Click here to add your criteria" CommandArgument="1"></telerik:RadButton>
                                    <telerik:RadButton ID="rbClearCriteria" runat="server" Text="Clear" OnClientClicked="ClearCriteria" AutoPostBack="false" CausesValidation="false"></telerik:RadButton>
                                        </div>
                                        <div class="row" style="padding-top:10px !important;">
                                            <telerik:RadButton ID="rbAddOthersCriteria" runat="server" Text="Search for this Credit Recommendation in other Exhibits" OnClick="rbAddOthersCriteria_Click"  ToolTip="Click here to save the added criteria(s) related to this articulation and to search for other courses with the same criteria(s) in their recommendations section"  Font-Bold="true" ></telerik:RadButton>
                                        </div>
                                    </div>


                                    <br /><br />
                                    <telerik:RadGrid ID="rgCriteria" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="sqlCriteria" AllowFilteringByColumn="false" AllowPaging="false"  OnItemDataBound="rgCriteria_ItemDataBound" OnItemCommand="rgCriteria_ItemCommand">
                                        <ClientSettings AllowKeyboardNavigation="true">
                                            <Selecting AllowRowSelect="true"></Selecting>
                                        </ClientSettings>
                                        <MasterTableView Name="ParentGrid" DataSourceID="sqlCriteria" PageSize="12" DataKeyNames="CriteriaID" CommandItemDisplay="None" AllowFilteringByColumn="false" ShowHeader="true" >
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="CriteriaId" UniqueName="CriteriaId" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridDropDownColumn DataField="ConditionID" DataType="System.Int32" FilterControlAltText="Filter ConditionID column" HeaderText="And/Or" SortExpression="ConditionID" UniqueName="ConditionID" DataSourceID="sqlConditions" ListTextField="ConditionSymbol" ListValueField="id" HeaderStyle-Width="65px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                </telerik:GridDropDownColumn>
                                                <telerik:GridBoundColumn DataField="Criteria" UniqueName="Criteria" HeaderText="Credit Recommendation" ItemStyle-ForeColor="#ffffff">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Backcolor" HeaderText="Color" UniqueName="Backcolor" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Fullname" HeaderText="Created By" UniqueName="Fullname" HeaderStyle-Width="80px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Fontcolor" HeaderText="Font Color" UniqueName="Fontcolor" Display="false">
                                                </telerik:GridBoundColumn>                                                 
                                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this criteria ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                    <asp:Repeater ID="rptCriteriaLegend" runat="server" OnItemDataBound="rptCriteriaTypes_ItemDataBound" 
                                    DataSourceID="sqlCriteriaTypes" Visible="false">
                                    <ItemTemplate>
                                        <div id="DivLegend" style="width:10px; height:10px; display:inline-block;" runat="server">
                                        </div> <div style="display:inline;line-height:18px;height:18px; font-size:10px; margin:0 5px;"><%# Eval("Description") %> </div>
                                    </ItemTemplate>
                                    </asp:Repeater>
                                    <br /><br />
                                </asp:Panel>
                                <telerik:RadCheckBox ID="rchkOverrideRecommendation" AutoPostBack="false" runat="server" CausesValidation="false"  Text="Override Recommendations" OnClientClicking="OverrideRecommendations" OnClientCheckedChanged="SetEnabledRecommendations"></telerik:RadCheckBox>
                                <br />
                                <h3>Recommendations</h3>
                                <asp:HiddenField ID="hfRecommendations" runat="server" ClientIDMode="Static" />
                                <telerik:RadListBox ID="rblRecommendations" runat="server" CheckBoxes="true" DataSourceID="sqlRecommendations" DataTextField="Recommendation" DataValueField="ID" Width="100%" Enabled="false" OnClientItemChecked="RecommendationChanged">
                                    <ItemTemplate>
                                        <div style="display: inline-block;">
                                            <%# DataBinder.Eval(Container, "Text")%>
                                        </div>
                                    </ItemTemplate>
                                    <Items>
                                    </Items>
                                </telerik:RadListBox>
                                <br /><br />
                                <telerik:RadCheckBox ID="rchkAdditionalCriteria" AutoPostBack="false" runat="server" CausesValidation="false"  Text="Additional Criteria" OnClientClicking="AdditionalRecommendations" Font-Bold="true" ></telerik:RadCheckBox>
                                <asp:Panel runat="server" ID="pnlAdditionalCriteria" ClientIDMode="Static">
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="rtbAdditionalCriteria" runat="server" ErrorMessage="Please enter a additional criteria" CssClass="alert alert-warning" ValidationGroup="AdditionalCriteria"></asp:RequiredFieldValidator>
                                    <div style="margin:5px 0">
                                    <telerik:RadTextBox ID="rtbAdditionalCriteria" runat="server" Width="250px" ToolTip="Enter the additional criteria(s) here from the occupation information recommendation section for this articulation and click on the Add button"></telerik:RadTextBox>
                                    <telerik:RadButton ID="rbAddAdditionalCriteria" runat="server" Text="Add" OnClick="rbAddCriteria_Click" ValidationGroup="AdditionalCriteria" Font-Bold="true" ToolTip="Click here to add your criteria" CommandArgument="2"></telerik:RadButton>
                                    <telerik:RadButton ID="rbClearAdditionalCriteria" runat="server" Text="Clear" OnClientClicked="ClearAdditionalCriteria" AutoPostBack="false" CausesValidation="false"  Font-Bold="true" ToolTip="Click here to clear the criteria field" CommandArgument="2"></telerik:RadButton>
                                    </div>
                                    <br />
                                    <asp:SqlDataSource ID="sqlAdditionalCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [ArticulationCriteria] WHERE [CriteriaID] = @CriteriaID" SelectCommand="SELECT ac.*, u.LastName + ', ' + u.FirstName as FullName FROM [ArticulationCriteria] ac left outer join TBLUSERS u on ac.CreatedBy = u.UserID  WHERE ac.ArticulationID = @ArticulationID AND ac.ArticulationType = @ArticulationType  and ac.[CriteriaType]= 2 order by ac.criteriaid">  
                                        <DeleteParameters> 
                                            <asp:Parameter Name="CriteriaID" Type="Int32" /> 
                                        </DeleteParameters>
                                        <SelectParameters> 
                                            <asp:ControlParameter Name="ArticulationID" ControlID="hvArticulationID" PropertyName="Value" Type="Int32" /> 
                                            <asp:Parameter Name="ArticulationType" DefaultValue="1" Type="Int32" /> 
                                        </SelectParameters> 
                                    </asp:SqlDataSource>
                                    <telerik:RadGrid ID="rgAdditionalCriteria" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="sqlAdditionalCriteria" AllowFilteringByColumn="false" AllowPaging="false"  OnItemDataBound="rgCriteria_ItemDataBound" AllowAutomaticUpdates="true"  OnItemCommand="rgCriteria_ItemCommand" >
                                        <ClientSettings AllowKeyboardNavigation="true">
                                            <Selecting AllowRowSelect="true"></Selecting>
                                        </ClientSettings>
                                        <MasterTableView Name="ParentGrid" DataSourceID="sqlAdditionalCriteria" PageSize="12" DataKeyNames="CriteriaID" CommandItemDisplay="None" AllowFilteringByColumn="false" ShowHeader="true" CommandItemSettings-ShowAddNewRecordButton="false" >
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="CriteriaId" UniqueName="CriteriaId" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Criteria" UniqueName="Criteria" HeaderText="Credit Recommendation" ItemStyle-ForeColor="#ffffff" ReadOnly="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Fullname" HeaderText="Created By" UniqueName="Fullname" HeaderStyle-Width="80px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Backcolor" HeaderText="Color" UniqueName="Backcolor" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Fontcolor" HeaderText="Font Color" UniqueName="Fontcolor" Display="false">
                                                </telerik:GridBoundColumn>                                                 
                                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="25px" ReadOnly="true" AllowFiltering="false">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this additional criteria ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                    <br />
                                </asp:Panel>

                                <asp:Panel ID="pnlNotes" runat="server">
                                <div class="row" style="padding:10px 0;">
                                    <div class="col-sm-6">
                                        <h3>Evaluator Notes :</h3>
                                    </div>
                                    <div class="col-sm-6">
                                        <telerik:RadButton ID="rbSaveEvaluatorNotes" runat="server" Text="Save" OnClick="rbAssign_Click" AutoPostBack="true">
                                            <Icon PrimaryIconCssClass="rbSave"></Icon>
                                        </telerik:RadButton>
                                    </div>
                                </div> 
                                <telerik:RadEditor runat="server" ID="reAssignNotes" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="100px" Width="95%" RenderMode="Lightweight" ToolTip="Enter notes here" OnClientLoad="editorLoad">
                                    <Tools>
                                        <telerik:EditorToolGroup Tag="Formatting">
                                            <telerik:EditorTool Name="Bold" />
                                        </telerik:EditorToolGroup>
                                    </Tools>
                                    <Content>
                                    </Content>
                                    <TrackChangesSettings CanAcceptTrackChanges="False" />
                                </telerik:RadEditor>
                                <div class="row" style="padding:10px 0;">
                                    <div class="col-sm-6">
                                        <h3>Faculty Notes :</h3>
                                    </div>
                                    <div class="col-sm-6"> 
                                        <telerik:RadButton ID="rbSaveFacultyNotes" runat="server" Text="Save" OnClick="rbAssign_Click" AutoPostBack="true">
                                            <Icon PrimaryIconCssClass="rbSave"></Icon>
                                        </telerik:RadButton>
                                    </div>
                                </div> 
                                <telerik:RadEditor runat="server" ID="reJustification" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="100px" Width="95%" RenderMode="Lightweight" ToolTip="Enter notes here" OnClientLoad="editorLoad">
                                    <Tools>
                                        <telerik:EditorToolGroup Tag="Formatting">
                                            <telerik:EditorTool Name="Bold" />
                                        </telerik:EditorToolGroup>
                                    </Tools>
                                    <Content>
                                    </Content>
                                    <TrackChangesSettings CanAcceptTrackChanges="False" />
                                </telerik:RadEditor>
                                <div class="row" style="padding:10px 0;">
                                    <div class="col-sm-6">
                                        <h3>Articulation Officer Notes :</h3>
                                    </div>
                                    <div class="col-sm-6">
                                        <telerik:RadButton ID="rbSaveARticulationNotes" runat="server" Text="Save" OnClick="rbAssign_Click" AutoPostBack="true">
                                            <Icon PrimaryIconCssClass="rbSave"></Icon>
                                        </telerik:RadButton>
                                    </div>
                                </div> 
                                <telerik:RadEditor runat="server" ID="reArticulationOfficer" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="100px" Width="95%" RenderMode="Lightweight" NewLineBr="false" ToolTip="Enter notes here" OnClientLoad="editorLoad">
                                    <Tools>
                                        <telerik:EditorToolGroup Tag="Formatting">
                                            <telerik:EditorTool Name="Bold" />
                                        </telerik:EditorToolGroup>
                                    </Tools>
                                    <Content>
                                    </Content>
                                    <TrackChangesSettings CanAcceptTrackChanges="False" />
                                </telerik:RadEditor>
                                </asp:Panel>
                                <asp:Panel ID="pnlOtherCollegesNotes" runat="server" Visible="false">
                                    <br />
                                    <h3>District Colleges Notes :</h3>
                                    <br />
                                    <uc:OtherCollegesNotes runat="server" id="OtherCollegesNotes" />
                                </asp:Panel>
                                
                                <asp:Panel ID="pnlDocuments" runat="server">
                                    <br />
                                    <h3>Articulation Documents :</h3>
                                    <uc1:ArticulationDocuments ID="ArticulationDocumentsViewer" runat="server" />
                                </asp:Panel>
                                <br />
                                <h3>Audit Trail :</h3>
                                <uc:AuditTrail ID="AuditTrailViewer" runat="server" />
                            </div>
                        </div>
                    </telerik:RadPageView>
                    <telerik:RadPageView runat="server" ID="RadPageView2" Width="100%">
                        <asp:Panel ID="pnlOtherRecommedations" runat="server">
                        <div class="row">
                            <div class="col-sm-12">
                                <asp:SqlDataSource ID="sqlCriteriaTypes" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from ArticulationCriteriaType where ArticulationType = 1 order by sorder">   
                                </asp:SqlDataSource>  
                                <div style="float:left;">
                                <asp:Repeater ID="rptCriteriaTypes" runat="server" OnItemDataBound="rptCriteriaTypes_ItemDataBound" 
                                    DataSourceID="sqlCriteriaTypes" Visible="false">
                                    <ItemTemplate>
                                        <div id="DivLegend" style="width:10px; height:10px; display:inline-block;" runat="server">
                                        </div> <div style="display:inline;line-height:18px;height:18px; font-size:10px; margin:0 5px;"><%# Eval("Description") %> </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                </div>
                                <div style="float:right;margin-bottom:5px;">
                                    <input type="text" name="keyword" class="higlightRecommendations" onkeyup="highlight(this)" placeholder="Highlight recommendations..." style="width:200px;" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12 context">
                                <asp:Panel ID="pnlConfirmMoveAllRecommendations" runat="server" Visible="false">
                                    <div class="panel panel-danger">
                                        <div class="panel-heading"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Recommendations are about to be submmited</div>
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <i class="fa fa-exclamation-circle" aria-hidden="true"></i> The following recommendations will be submitted, this action can not be reversed.  Are you sure ? 
                                                </div>
                                                <div class="col-md-4">
                                                    <telerik:RadButton ID="rbMoveAll" runat="server" Text="Move Forward All Articulations" ButtonType="LinkButton" OnClick="rbMoveAll_Click" Primary="true" >
                                                    <Icon PrimaryIconCssClass="rbOk"></Icon>
                                                </telerik:RadButton>
                                                    <telerik:RadButton ID="rbCancelMoveAll" runat="server" Text="Cancel" ButtonType="LinkButton" OnClick="rbCancelMoveAll_Click">
                                                    <Icon PrimaryIconCssClass="rbCancel"></Icon>
                                                </telerik:RadButton>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
                                <telerik:RadGrid ID="rgOtherRecommendations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOtherRecommendations" AllowFilteringByColumn="False" AllowPaging="false" RenderMode="Lightweight" OnItemCommand="rgOtherRecommendations_ItemCommand" OnItemDataBound="rgOtherRecommendations_ItemDataBound" EnableHeaderContextMenu="true">
                                    <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="True" />
                                        <ClientEvents />
                                    </ClientSettings>
                                    <MasterTableView DataSourceID="sqlOtherRecommendations" PageSize="12" DataKeyNames="ID" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" AllowFilteringByColumn="False" HeaderStyle-Font-Bold="true">
                                        <CommandItemTemplate>
                                            <div class="commandItems">
                                                <telerik:RadButton runat="server" ID="btnMoveForward" Text="Move Forward Highlighted Articulation" ButtonType="LinkButton" CommandName="MoveForward" OnClientClicking="StandardConfirm">
                                                    <Icon PrimaryIconCssClass="rbNext"></Icon>
                                                </telerik:RadButton>
                                                <telerik:RadButton ID="rbUpdateOther" runat="server" Text="Update Recommendations" ButtonType="LinkButton" CommandName="UpdateOther">
                                                    <Icon PrimaryIconCssClass="rbSave"></Icon>
                                                </telerik:RadButton>
                                                <telerik:RadButton ID="rbMoveAll" runat="server" Text="Move Forward All Articulations" ButtonType="LinkButton" CommandName="MoveAll" OnClientClicking="ConfirmMoveAll">
                                                    <Icon PrimaryIconCssClass="rbSave"></Icon>
                                                </telerik:RadButton>
                                            </div>
                                        </CommandItemTemplate>
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="RecommendationID" UniqueName="RecommendationID" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="RecommendationIDs" UniqueName="RecommendationIDs" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="RecommendationIsChecked" UniqueName="RecommendationIsChecked" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn UniqueName="CheckBoxTemplateColumn" AllowFiltering="false" HeaderStyle-Width="10px">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="CheckBox1" runat="server" OnCheckedChanged="ToggleRowSelection"
                                                        AutoPostBack="True" />
                                                </ItemTemplate>
                                                <HeaderTemplate>
                                                    <asp:CheckBox ID="headerChkbox" runat="server" OnCheckedChanged="ToggleSelectedState"
                                                        AutoPostBack="True" />
                                                </HeaderTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="Ace ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="TeamRevd" HeaderText="Team Revd" DataField="TeamRevd" UniqueName="TeamRevd" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" DataFormatString="{0:MM/dd/yyyy}">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="ExhibitD" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn SortExpression="HighlightRecommendation" HeaderText="Recommendation(s)" UniqueName="HighlightRecommendation" DataField="HighlightRecommendation" ReadOnly="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                                <br />
                            </div>

                        </div>
                        </asp:Panel>
                    </telerik:RadPageView>
                    <telerik:RadPageView runat="server" ID="RadPageView3" Width="100%">
                        <div class="col-sm-12">
                            <h2>Eligibility</h2>
                            <telerik:RadGrid ID="rgEligibility" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlEligibility" Width="100%" AllowAutomaticUpdates="true">
                                <GroupingSettings CaseSensitive="false" />
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="sqlEligibility" CommandItemDisplay="Top" EditMode="Batch" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true">
                                    <NoRecordsTemplate>
                                        <p>No records to display</p>
                                    </NoRecordsTemplate>
                                    <BatchEditingSettings EditType="Cell" />
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="id" HeaderText="ID" UniqueName="id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn DataField="ForAssociateOnly" DataType="System.Boolean" HeaderText="For Associate Only" UniqueName="ForAssociateOnly" HeaderStyle-Width="110px" ItemStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="CheckBox1" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("ForAssociateOnly")) %>' onclick="checkBoxClick(this, event);" />
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:CheckBox runat="server" ID="CheckBox2" />
                                            </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridTemplateColumn DataField="ForTransfer" DataType="System.Boolean" HeaderText="For Transfer" UniqueName="ForTransfer" HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="CheckBox3" Enabled="true" Checked='<%# Convert.ToBoolean(Eval("ForTransfer")) %>' onclick="checkBoxClick(this, event);" />
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:CheckBox runat="server" ID="CheckBox4" />
                                            </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="Ace ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="TeamRevd" HeaderText="Team Revd" DataField="TeamRevd" UniqueName="TeamRevd" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Exhibit" HeaderText="Exhibit" DataField="Exhibit" UniqueName="Exhibit" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="100px" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </div>
                    </telerik:RadPageView>
                    <telerik:RadPageView ID="RadPageView4" runat="server">
                        <uc2:ArticulateWithOtherCourses ID="ArticulateWithOtherCourses1" SetEnabled="true" runat="server" />
                    </telerik:RadPageView>
                </telerik:RadMultiPage>
                <div style="display: none !important;">
                    <telerik:RadTextBox ID="selectedRowValue" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
                    <telerik:RadTextBox ID="selectedCourseTitle" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
                </div>

                <div class="clearfix"></div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/TelerikControls.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mark.js/8.11.1/jquery.mark.es6.js"></script>
    <script>
        window.addEventListener('load',
            function () {
                const queryString = window.location.search;
                const urlParams = new URLSearchParams(queryString);
                if (!urlParams.get('OtherCollegeID')) {
                    var userStageID = document.getElementById('<%= hvUserStageID.ClientID %>').value;
                    var role_name = document.getElementById('<%= hvRoleName.ClientID %>').value;
                    var articulation_stage = document.getElementById('<%= hvArticulationStage.ClientID %>').value;
                    if (userStageID != articulation_stage) {
                        alert("This articulation is being revised in the " + role_name + " stage. Only recommendation criteria(s) and notes can be updated.");
                    }
                }
                HiglightCreditRecommendation();
            }, false);

        function HiglightCreditRecommendation() {
            var criteria = [];
            var masterTable = $find("<%=rgCriteria.ClientID%>").get_masterTableView();
                    for (var row = 0; row < masterTable.get_dataItems().length; row++) {
                        criteria.push(masterTable.getCellByColumnUniqueName(masterTable.get_dataItems()[row], "Criteria").innerHTML);
                    }

                    var instance = new Mark(document.querySelector("body"));

                    instance.mark(criteria, {
                        "separateWordSearch": false,
                        "ignoreJoiners": true,
                        "acrossElements": true,
                    });
        }

        function ArticulationCreated() {
            $('#divArticulationCreated').fadeIn(1500).delay(1000).fadeOut(1500);
        }
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
			window.location.reload();						 
        }

        function checkBoxClick(sender, args) {
            var grid = $find("<%= rgEligibility.ClientID %>");
            var masterTableView = grid.get_masterTableView();
            var batchEditingManager = grid.get_batchEditingManager();
            var parentCell = $telerik.$(sender).closest("td")[0];

            var initialValue = sender.checked;
            sender.checked = !sender.checked;

            batchEditingManager.changeCellValue(parentCell, initialValue);
        }

        function ClearCriteria() {
            var rtbCriteria = $find("<%= rtbCriteria.ClientID %>");
            rtbCriteria.set_value("");
            rtbCriteria.focus();
        }

        function ClearAdditionalCriteria() {
            var rtbCriteria = $find("<%= rtbAdditionalCriteria.ClientID %>");
            rtbCriteria.set_value("");
            rtbCriteria.focus();
        }

        function OverrideRecommendations(sender, args) {
            var checkBox = $find("<%=rchkOverrideRecommendation.ClientID%>");
            var isChecked = checkBox.get_checked();
            //checkBox.set_checked(!isChecked);
            if (!isChecked) {
                if (confirm('Are you sure you want to override recommendations ?')) {
                }
                else {
                    args.set_cancel(true);
                }
            }
        }

        function AdditionalRecommendations(sender, args) {
            var checkBox = $find("<%=rchkAdditionalCriteria.ClientID%>");
            var isChecked = checkBox.get_checked();
            if (!isChecked) {
                $("#pnlAdditionalCriteria").show();
            } else {
                $("#pnlAdditionalCriteria").hide();
            }
        }

        function SaveChangesInGrid(sender,args) {
            var grid = $find('<%=rgCriteria.ClientID%>');
            grid.get_batchEditingManager().saveChanges(grid.get_masterTableView());
            grid.get_masterTableView().rebind();
        }

        function SetEnabledRecommendations(sender, args) {
            var checkBox = $find("<%=rchkOverrideRecommendation.ClientID%>");
            var isChecked = checkBox.get_checked();
            EnableDisableRecommendation(isChecked);
        }

        function EnableDisableRecommendation(isChecked) {
            var list = $find("<%= rblRecommendations.ClientID %>");
            var items = list.get_items()
                for (var i = 0; i < items.get_count(); i++) {
                    var item = items.getItem(i);
                    if (isChecked) {
                        item.enable();  
                        }           
                    else {
                        item.disable();
                    }
                }
            }

        function RecommendationChanged(sender, args) {
            var result = new Array();
            var list = $find("<%= rblRecommendations.ClientID %>");
            var items = list.get_items()
                for (var i = 0; i < items.get_count(); i++) {
                    var item = items.getItem(i);
                    if (item.get_checked()) {
                        result.push(item.get_value());
                        }  
                }
            $("#<%=hfRecommendations.ClientID %>").val(result.join(',').toString()); 
        }

        function OpenInNewWindow() {
            window.open(document.URL + '&NewWindow=true', '_blank');
        }

        function SubmitArticulationConfirm(sender, args) {
<%--            if (confirm('Did you want to assign eligibility to any of these occupations?')) {
                var tabStrip= $find("<%= RadTabStrip1.ClientID %>");
                var tab = tabStrip.findTabByText("Eligibility");
                if (tab) {
                    tab.select();
                    args.set_cancel(true);
                }
            }
            else {--%>
                args.set_cancel(!window.confirm("Are you sure you want to submit this articulation ?"));
            //}
        }
        function StandardConfirm(sender, args) {
            args.set_cancel(!window.confirm("Are you sure you want to move forward this articulation ?"));
        }
        function ConfirmMoveAll(sender, args) {
            args.set_cancel(!window.confirm("Are you sure you want to move forward all articulations ?"));
        }
        function ArchiveConfirm(sender, args) {
            var button = $find("<%= rbArchive.ClientID %>");
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            const TeamRevd = urlParams.get('TeamRevd').split(' ')[0];
            var message = "Are you sure you want to " + button.get_text() + " this articulation with Team Revd Date : " + TeamRevd + "?";
            args.set_cancel(!window.confirm(message));
        }
        function DoNotArticulateConfirm(sender, args) {
            var evaluatorNotes = $find("<%=reAssignNotes.ClientID%>");
            var facultyNotes = $find("<%= reJustification.ClientID%>");
            var articulationOfficerNotes = $find("<%=reArticulationOfficer.ClientID%>");

            var firstStage = document.getElementById('<%= hvFirstStage.ClientID %>').value;
            var userStageID = document.getElementById('<%= hvUserStageID.ClientID %>').value;
            var isArticulationOfficer = document.getElementById('<%= hvIsArticulationOfficer.ClientID %>').value;
            var reviewArticulations = document.getElementById('<%= hvReviewArticulations.ClientID %>').value;

            if (userStageID == firstStage) {
                if (evaluatorNotes.get_text() == "<br />" || evaluatorNotes.get_text() == "") {
                    alert("Please provide Evaluator Notes");
                    evaluatorNotes.setFocus();
                    args.set_cancel(true);
                    return false;
                }
            }

            if (isArticulationOfficer == "True") {
                if (articulationOfficerNotes.get_text() == "<br />" || articulationOfficerNotes.get_text() == "") {
                    alert("Please provide Articulation Officer Notes");
                    articulationOfficerNotes.setFocus();
                    args.set_cancel(true);
                    return false;
                }
            }

            if (reviewArticulations == "True") {
                if (facultyNotes.get_text() == "<br />" || facultyNotes.get_text() == "") {
                    alert("Please provide Faculty Notes");
                    facultyNotes.setFocus();
                    args.set_cancel(true);
                    return false;
                }
            }
        }

        function selectedRowNorco(sender, eventArgs) {
            var item = eventArgs.get_item();
            var cell = item.get_cell("outline_id");
            var value = $telerik.$(cell).text().trim();
            var cellTitle = item.get_cell("course_title");
            var valueTitle = $telerik.$(cellTitle).text().trim();
            document.getElementById('selectedRowValue').value = value;
            document.getElementById('selectedCourseTitle').value = valueTitle;
        }

        function highlight() {
            var $input = $("input[name='keyword']"),
              $context = $("div.context table tbody tr");
            $input.on("input", function () {
                var term = $(this).val();
                $context.show().unmark();
                if (term) {
                    $context.mark(term, {
                        separateWordSearch: false,
                        done: function () {
                            $context.not(":has(mark)").hide();
                        }
                    });
                }
            });
        }
    </script>
</body>
</html>

