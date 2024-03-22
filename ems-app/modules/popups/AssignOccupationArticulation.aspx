<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssignOccupationArticulation.aspx.cs" Inherits="ems_app.modules.popups.AssignOccupationArticulation" ValidateRequest="false" MasterPageFile="~/Common/templates/main.Master" %>

<%@ Register Src="~/UserControls/CourseInformation.ascx" TagPrefix="uc" TagName="CourseInformation" %>
<%@ Register Src="~/UserControls/ExhibitInformation.ascx" TagPrefix="uc" TagName="OccupationInformation" %>
<%@ Register Src="~/UserControls/CriteriaLegend.ascx" TagPrefix="uc" TagName="CriteriaLegend" %>
<%@ Register Src="~/UserControls/DisplayMessages.ascx" TagPrefix="uc" TagName="DisplayMessages" %>
<%@ Register Src="~/UserControls/Eligibility.ascx" TagPrefix="uc" TagName="Eligibility" %>
<%@ Register Src="~/UserControls/ArticulationDocuments.ascx" TagName="ArticulationDocuments" TagPrefix="uc1" %>
<%@ Register Src="~/UserControls/AuditTrailLog.ascx" TagName="AuditTrail" TagPrefix="uc" %>

<%@ Register Src="~/UserControls/ArticulateWithOtherCourses.ascx" TagName="ArticulateWithOtherCourses" TagPrefix="uc2" %>
<%@ Register Src="~/UserControls/OtherCollegesNotes.ascx" TagPrefix="uc" TagName="OtherCollegesNotes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .RadListBox .rlbTemplate {
            display: inline !important;
        }

        .courseDetails {
            height: auto !important;
        }
        /*.RadGrid_Bootstrap .rgPagerCell .rgNumPart a.rgCurrentPage, .RadGrid_Bootstrap .rgMasterTable .rgSelectedCell, .RadGrid_Bootstrap .rgSelectedRow td, .RadGrid_Bootstrap td.rgEditRow .rgSelectedRow, .RadGrid_Bootstrap .rgSelectedRow td.rgSorted {
            background-color: transparent !important;
        }*/
        #reAssignNotes, #reJustification, #reArticulationOfficer {
            padding: 5px;
            border: 1px solid #ccc;
        }

        #articulation-info p {
            font-weight: bold;
            font-size:11px;
            margin: 5px 0;
        }

        .hideBorder td {
            border: none !important;
        }
        i {
            color:blue !important;
        }
        .commandItems a {
            color: inherit !important;
        }
		.delete {
            background-color:darkred !important;
            color:white !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" id="SystemTitle" runat="server">View Details</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlArticulationType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from ArticulationType"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlConditions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM tblLookupConditions order by ConditionName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlEligibility" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ac.ID, cc.AceID, cc.TeamRevd, cc.Exhibit, cc.Occupation, cc.Title as 'OccupationTitle', ac.ForAssociateOnly , ac.ForTransfer from Articulation ac left outer join AceExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join tblusers u on ac.CreatedBy = u.userid where ac.outline_id = @outline_id  and ac.ArticulationStage = @ArticulationStage  order by cc.AceID, cc.TeamRevd">
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
    <asp:SqlDataSource ID="sqlOtherRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select [dbo].[GetRecommendationHighlightedCriteria] (aod.id, ac.id, 2 ) AS HighlightRecommendation, ac.ID, ac.ArticulationID, cc.AceID,  aod.ID RecommendationID, ac.Recommendation as 'RecommendationIDs', [dbo].[RecommendationIsChecked] (ac.Recommendation, aod.ID) as 'RecommendationIsChecked', cc.TeamRevd, cc.Exhibit, cc.Occupation, cc.Title as 'OccupationTitle', aod.HTMLDetail as 'Recommendation' from Articulation ac left outer join AceOccupation cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd left outer join tblusers u on ac.CreatedBy = u.userid left outer join AceOccupationDetail aod on ac.AceID = aod.AceID and ac.TeamRevd = aod.TeamRevd where ac.ArticulationType = 2 and ac.outline_id = @outline_id and aod.HTMLDetail like '<b>Recommendation%' and ac.ArticulationStage = @ArticulationStage AND [dbo].[GetRecommendationHaveCriteria] (aod.id, @ArticulationID, 2 ) > 0 and ( ac.AceID <> @AceID and ac.TeamRevd <> @TeamRevd ) order by cc.AceID, cc.TeamRevd, aod.HTMLDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
            <asp:ControlParameter ControlID="hvUserArticulationStage" DefaultValue="0" Name="ArticulationStage" PropertyName="Value" />
            <asp:ControlParameter Name="ArticulationID" ControlID="hvArticulationID" PropertyName="Value" Type="Int32" ConvertEmptyStringToNull="true" />
            <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
            <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select *, isnull([dbo].[GetRecommendationCriteriaFlags] (id, @ArticulationID, 2 ),'') + ' ' + SUBSTRING(HTMLDetail, CHARINDEX('<b>', HTMLDetail) + LEN('<b>'),  CHARINDEX('</b>', HTMLDetail) - CHARINDEX('<b>', HTMLDetail) - LEN('<b>')) as 'Recommendation' from AceOccupationDetail where HTMLDetail like '%Recommendation,%' and AceID = @AceID and TeamRevd = @TeamRevd">
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
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
        <uc:DisplayMessages ID="DisplayMessagesControl" runat="server"></uc:DisplayMessages>
        <div id="divArticulationCreated" class="ArticulationCreated" style="display: none;">
            <p style="color: #fff; font-weight: bold;">
                <i class="fa fa-check-circle-o fa-5x" aria-hidden="true"></i>Articulation successfully created!!!
            </p>
        </div>
        <div style="padding: 15px !important;">
            <div class="row">
                <div id="articulation-info" class="col-md-4">
                    <p id="lblCollegeToAdopt" runat="server"></p>
                    <p id="lblArticulationTitle" runat="server"></p>
                    <p id="lblExhibit" runat="server"></p>
                    <asp:SqlDataSource ID="sqlCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT  ac.CriteriaID, aec.CRiteria FROM [Articulation] ac left outer join AceExhibitCriteria aec on ac.CriteriaID = aec.CriteriaID  WHERE ac.ID = @ArticulationID">
                        <SelectParameters>
                            <asp:ControlParameter Name="ArticulationID" ControlID="hvId" PropertyName="Value" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <div class="container credit-recommendations-area">
                        <div style="display:flex; align-items:center; justify-content:start;" >
                            <p>Credit Recommendation</p>
                            <telerik:RadGrid ID="rgCriteria" CssClass="hideBorder" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="sqlCriteria" AllowFilteringByColumn="false" AllowPaging="false" ShowFooter="false" ShowHeader="false" BorderStyle="None" ItemStyle-BorderStyle="None" EditItemStyle-BorderStyle="None" AlternatingItemStyle-BorderStyle="None" HeaderStyle-BorderStyle="None" MasterTableView-BorderStyle="None" EditItemStyle-CssClass="hideBorder" ItemStyle-CssClass="hideBorder" AlternatingItemStyle-CssClass="hideBorder">
                                <ClientSettings AllowKeyboardNavigation="true">
                                    <Selecting AllowRowSelect="true"></Selecting>
                                </ClientSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlCriteria" PageSize="12" DataKeyNames="CriteriaID" CommandItemDisplay="None" AllowFilteringByColumn="false">
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="CriteriaId" UniqueName="CriteriaId" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Criteria" UniqueName="Criteria" HeaderText="Credit Recommendation" ItemStyle-ForeColor="#ffffff">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>

                        </div>
                    </div>
                </div>
                <div class="col-md-4 text-center" style="display: flex; justify-content: center; align-items: center;">
                    <h1 >Articulation Details</h1>
                    &nbsp;<i id="tooltipArticulationDetails" class="fa-regular fa-circle-info"></i>
                    <telerik:RadToolTip RenderMode="Lightweight" runat="server" ID="RadToolTip1" Width="300px" ShowEvent="onmouseover"
                        RelativeTo="Element" Animation="Resize" TargetControlID="tooltipArticulationDetails" IsClientID="true" Skin="Material"
                        HideEvent="LeaveTargetAndToolTip" Position="TopRight" Text="The Articulation Details Screen allows the User to view the articulation's course details, exhibit, notes & audit trail.">
                    </telerik:RadToolTip>
                    <div style="display: none !important;">
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
                        <telerik:RadButton ID="rbDontArticulate" runat="server" Text="Deny" OnClick="rbDontArticulate_Click" Visible="false">
                            <Icon PrimaryIconCssClass="rbCancel"></Icon>
                            <ConfirmSettings ConfirmText="Are you sure you want to Deny this articulation? " />
                        </telerik:RadButton>
                        <telerik:RadButton ID="rbArchive" runat="server" Text="Archive" Visible="false" OnClick="rbArchive_Click" OnClientClicking="ArchiveConfirm">
                            <Icon PrimaryIconCssClass="rbSave"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton ID="rbAdoptArticulation" runat="server" Text="Adopt Articulation" OnClick="rbAdoptArticulation_Click" BackColor="LightGreen">
                            <Icon PrimaryIconCssClass="rbAdd"></Icon>
                        </telerik:RadButton>
                        <asp:Label ID="lblDenied" runat="server" CssClass="d-inline-block alert alert-danger"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> This articulation has been denied</asp:Label>
                        <asp:Label ID="lblArchived" runat="server" CssClass="d-inline-block alert alert-danger"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> This articulation has been archived</asp:Label>
                        <asp:Label ID="lblAdopt" runat="server" CssClass="d-inline-block alert alert-warning"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> </asp:Label>
                    </div>
                </div>
                <div class="col-md-4" style="display: flex; justify-content: center; align-items: center;">
                    <div class="container">
                    <div class="col-6" runat="server">
                        <div class="hidePanel">
                            <asp:SqlDataSource ID="sqlArticulationMatrix" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select  [dbo].[GetArticulationMatrix](@id) Matrix" SelectCommandType="Text">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="id" QueryStringField="articulationID" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:Repeater ID="rptArticulationMatrix" runat="server" DataSourceID="sqlArticulationMatrix">
                                <HeaderTemplate>
                                    <table style="width:100%;">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label10" Text='<%# Eval("Matrix") %>' /></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <div class="col-6 d-flex justify-content-center ">
                        <telerik:RadButton ID="rbAssign" runat="server" Text=" Save Articulation" OnClick="rbAssign_Click" Visible="false" Primary="true" Height="32px" >
                        </telerik:RadButton> &nbsp; &nbsp;
                        <telerik:RadButton ID="rbDelete" runat="server" Text=" Delete" CssClass="delete" OnClick="rbDelete_Click" OnClientClicked="closeCurrentTab" Height="32px">
                            <ConfirmSettings ConfirmText="Are you sure you want to Delete this articulation?" />
						</telerik:RadButton> &nbsp; &nbsp;
                        <telerik:RadButton ID="rbClose" runat="server" Text=" Close" OnClientClicked="closeCurrentTab" Height="32px" AutoPostBack="false">
                        </telerik:RadButton>
                    </div>
                    </div>
                </div>
            </div>
            <div class="clearfix"></div>
            <div class="row">
                <div class="col-md-4 col-sm-4 col-xs-12">
                    <asp:TextBox ID="tbID" runat="server" CssClass="displayNone"></asp:TextBox>
                    <asp:HiddenField ID="hvId" runat="server" />
                    <asp:HiddenField ID="hvArticulationStage" runat="server" />
                    <asp:HiddenField ID="hvArticulationID" runat="server" />
                    <asp:HiddenField ID="hvArticulationType" Value="2" runat="server" />
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
                    <asp:HiddenField ID="hvExhibitID" runat="server" />
                    <asp:HiddenField ID="hvCriteriaID" runat="server" />
                    <asp:HiddenField ID="hvIsArticulationOfficer" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hvReviewArticulations" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hvArticulationOrder" runat="server" ClientIDMode="Static" />
                    <uc:CourseInformation ID="CourseInformationControl" runat="server"></uc:CourseInformation>
                </div>
                <div class="credit-recommendations-area col-md-4 col-sm-4 col-xs-12">
                    <uc:OccupationInformation ID="OccupationInformationControl" runat="server"></uc:OccupationInformation>
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
                    <asp:Panel ID="pnlCriteria" runat="server" CssClass="hidePanel">

                        <div style="display: flex; justify-content: center; align-items: center;">
                            <h2 style="text-align: center; width: 100%; font-weight: bold;">Notes & Audit Trail</h2>
                            &nbsp;<i id="tooltipNotesInfo" class="fa-regular fa-circle-info"></i>
                            <telerik:RadToolTip RenderMode="Lightweight" runat="server" ID="RadToolTip2" Width="400px" ShowEvent="onmouseover"
                                RelativeTo="Element" Animation="Resize" TargetControlID="tooltipNotesInfo" IsClientID="true" Skin="Material" ManualClose="true"  
                                 Position="BottomLeft" Text="<br><br><ul><li>The <b>Notes Table</b> automatically populates notes left by users in each stage from the Notifications Screen upon Approval or Denial of an Articulation. (Notes are captured at the package level and are applied to each exhibit because of the</li><li>The <b>Articulation Documents</b> Capture the Documents uploaded by the User in the Notifications Screen upon Approval or Denial of an Articulation.</li><li>The <b>Audit Trail</b> captures action taken by a User on the Articulation. </li></ul>">
                            </telerik:RadToolTip>
                        </div>
                <hr />

                </asp:Panel>

                    <asp:Panel ID="pnlNotes" runat="server" CssClass="hidePanel">
                        <div class="row" style="padding: 10px 0;">
                            <div class="col-sm-12">
                                <h3>Evaluator Notes :</h3>
                            </div>
                        </div>
                        <telerik:RadEditor runat="server" ID="reAssignNotes" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="100px" Width="100%" RenderMode="Lightweight" ToolTip="Enter notes here" OnClientLoad="editorLoad" ContentFilters="ConvertToXhtml" BackColor="ControlLightLight">
                            <Tools>
                                <telerik:EditorToolGroup Tag="Formatting">
                                    <telerik:EditorTool Name="Bold" />
                                </telerik:EditorToolGroup>
                            </Tools>
                            <Content>
                            </Content>
                            <TrackChangesSettings CanAcceptTrackChanges="False" />
                        </telerik:RadEditor>
                        <div class="row" style="padding: 10px 0;">
                            <div class="col-sm-12 text-right">
                                <telerik:RadButton ID="rbSaveEvaluatorNotes" Visible="false" runat="server" Text="Save" OnClick="rbAssign_Click" AutoPostBack="true">
                                </telerik:RadButton>
                            </div>
                        </div>
                        <div class="row" style="padding: 10px 0;">
                            <div class="col-sm-12">
                                <h3>Faculty Notes :</h3>
                            </div>
                        </div>
                        <telerik:RadEditor runat="server" ID="reJustification" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="100px" Width="100%" RenderMode="Lightweight" NewLineBr="false" ToolTip="Enter notes here" OnClientLoad="editorLoad" ContentFilters="ConvertToXhtml" BackColor="ControlLightLight">
                            <Tools>
                                <telerik:EditorToolGroup Tag="Formatting">
                                    <telerik:EditorTool Name="Bold" />
                                </telerik:EditorToolGroup>
                            </Tools>
                            <Content>
                            </Content>
                            <TrackChangesSettings CanAcceptTrackChanges="False" />
                        </telerik:RadEditor>
                        <div class="row" style="padding: 10px 0;">
                            <div class="col-sm-12 text-right">
                                <telerik:RadButton ID="RadButton1" Visible="false" runat="server" Text="Save" OnClick="rbAssign_Click" AutoPostBack="true">
                                </telerik:RadButton>
                            </div>
                        </div>
                        <div class="row" style="padding: 10px 0;">
                            <div class="col-sm-12">
                                <h3>Articulation Officer Notes :</h3>
                            </div>
                        </div>
                        <telerik:RadEditor runat="server" ID="reArticulationOfficer" ContentAreaMode="Div" NewLineMode="Br" ContentFilters="ConvertToXhtml" EditModes="Design" Height="100px" Width="100%" RenderMode="Lightweight" NewLineBr="false" ToolTip="Enter notes here" OnClientLoad="editorLoad" BackColor="ControlLightLight">
                            <Tools>
                                <telerik:EditorToolGroup Tag="Formatting">
                                    <telerik:EditorTool Name="Bold" />
                                </telerik:EditorToolGroup>
                            </Tools>
                            <Content>
                            </Content>
                            <TrackChangesSettings CanAcceptTrackChanges="False" />
                        </telerik:RadEditor>
                        <div class="row" style="padding: 10px 0;">
                            <div class="col-sm-12 text-right">
                                <telerik:RadButton ID="RadButton2" Visible="false" runat="server" Text="Save" OnClick="rbAssign_Click" AutoPostBack="true">
                                </telerik:RadButton>
                            </div>
                        </div>
                    </asp:Panel>
                <asp:Panel ID="pnlOtherCollegesNotes" runat="server" Visible="false" CssClass="hidePanel">
                    <br />
                    <h3>District Colleges Notes :</h3>
                    <br />
                    <uc:OtherCollegesNotes runat="server" ID="OtherCollegesNotes" />
                </asp:Panel>
                <asp:Panel ID="pnlDocuments" runat="server" CssClass="hidePanel">
                    <br />
                    <div style="display: flex; justify-content: start; align-items: center; margin-bottom:10px;">
                        <h3>Articulation Documents </h3>
                            &nbsp;<i id="tooltipDocuments" class="fa-regular fa-circle-info"></i>
                            <telerik:RadToolTip RenderMode="Lightweight" runat="server" ID="RadToolTip3" Width="300px" ShowEvent="onmouseover"
                                RelativeTo="Element" Animation="Resize" TargetControlID="tooltipDocuments" IsClientID="true" Skin="Material"
                                HideEvent="LeaveTargetAndToolTip" Position="TopRight" Text="The Articulation Documents capture the documents uploaded by the user in the Notifications screen upon Approval or Denial of an Articulation">
                            </telerik:RadToolTip>
                    </div>
                    <uc1:ArticulationDocuments ID="ArticulationDocumentsViewer" runat="server" />
                </asp:Panel>
                <br />
                    <div style="display: flex; justify-content: start; align-items: center; margin-bottom:10px;" class="hidePanel">
                        <h3>Audit Trail </h3>
                            &nbsp;<i id="tooltipAudit" class="fa-regular fa-circle-info"></i>
                            <telerik:RadToolTip RenderMode="Lightweight" runat="server" ID="RadToolTip4" Width="300px" ShowEvent="onmouseover"
                                RelativeTo="Element" Animation="Resize" TargetControlID="tooltipAudit" IsClientID="true" Skin="Material"
                                HideEvent="LeaveTargetAndToolTip" Position="TopRight" Text="The Audit Trail captures action taken by a User on the Articulation">
                            </telerik:RadToolTip>
                    </div>
                    <div class="hidePanel">
                        <uc:AuditTrail ID="AuditTrailViewer" runat="server" />
                    </div>
                
            </div>
        </div>
        <div style="display: none !important;">
            <telerik:RadTextBox ID="selectedRowValue" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
            <telerik:RadTextBox ID="selectedCourseTitle" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
        </div>

        <div class="clearfix"></div>

        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script src="../../Common/js/TelerikControls.js"></script>
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
                var articulationOrder = document.getElementById('hvArticulationOrder').value;
                // Check if the value is 4
                if (articulationOrder === '4') {
                    var divsToHide = document.querySelectorAll('.hidePanel');
                    for (var i = 0; i < divsToHide.length; i++) {
                        divsToHide[i].style.display = 'none';
                    }
                }
            }, false);


        function HiglightCreditRecommendation() {
            var criteria = [];
            var masterTable = $find("<%=rgCriteria.ClientID%>").get_masterTableView();
            for (var row = 0; row < masterTable.get_dataItems().length; row++) {
                criteria.push(masterTable.getCellByColumnUniqueName(masterTable.get_dataItems()[row], "Criteria").innerHTML);
            }

            var instance = new Mark("div.credit-recommendations-area");

            instance.mark(criteria, {
                "separateWordSearch": false,
                "ignoreJoiners": true,
                "acrossElements": true,
            });
        }

        function closeRadWindow() {
            window.location.reload(); $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
            window.location.reload();
        }

        function SaveChangesInGrid(sender, args) {
            var grid = $find('<%=rgCriteria.ClientID%>');
            grid.get_batchEditingManager().saveChanges(grid.get_masterTableView());
            grid.get_masterTableView().rebind();
        }



        function ArticulationCreated() {
            $('#divArticulationCreated').fadeIn(1500).delay(1000).fadeOut(1500);
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
        function OpenInNewWindow() {
            window.open(document.URL + '&NewWindow=true', '_blank');
        }
        function highlight() {
            //var $input = $("input[name='keyword']"),
            //    $context = $("div.context table tbody tr");
            //$input.on("input", function () {
            //    var term = $(this).val();
            //    $context.show().unmark();
            //    if (term) {
            //        $context.mark(term, {
            //            separateWordSearch: false,
            //            done: function () {
            //                $context.not(":has(mark)").hide();
            //            }
            //        });
            //    }
            //});
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

        function closeCurrentTab() {
            const currentWindow = window.open('', '_self');
            currentWindow.close();
        }

    </script>
</asp:Content>


