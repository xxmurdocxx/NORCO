<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Messages.ascx.cs" Inherits="ems_app.UserControls.notifications.Messages" %>
<%@ Register Src="~/UserControls/DisplayMessages.ascx" TagPrefix="uc1" TagName="DisplayMessages" %>

<telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
    <telerik:RadNotification RenderMode="Lightweight" ID="rnMessageNotifications" runat="server" Text="" Position="Center" AutoCloseDelay="0" Width="400" Height="230" Title="" EnableRoundedCorners="true" >
    </telerik:RadNotification>
    <telerik:RadWindowManager ID="RadWindowManager1" EnableViewState="false" runat="server" OnClientClose="closeRadWindow" ReloadOnShow="false"></telerik:RadWindowManager>
    <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
        <p id="divMsgs" runat="server">
            <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
            </asp:Label>
            <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
            </asp:Label>
        </p>
    </telerik:RadToolTip>
    <uc1:DisplayMessages ID="DisplayMessagesControl" runat="server"></uc1:DisplayMessages>
    <asp:HiddenField runat="server" ID="hfUserID" />
    <asp:HiddenField runat="server" ID="hfMessageID" />
    <asp:HiddenField runat="server" ID="hfActionTaken" />
    <asp:HiddenField runat="server" ID="hfDeleted" />
    <asp:HiddenField runat="server" ID="hfReviewed" />
    <asp:HiddenField runat="server" ID="hfSent" />
    <asp:HiddenField runat="server" ID="hfSubject" />
    <asp:HiddenField runat="server" ID="hfAceIds" />
    <asp:HiddenField ID="hvUserName" runat="server" />
    <asp:HiddenField ID="hvUserID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hvCollegeID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hvAppID" runat="server" />
    <asp:HiddenField ID="hvUserStage" runat="server" />
    <asp:HiddenField ID="hvMessageSharedCourseCount" runat="server" />
    <asp:HiddenField ID="hvUserStageOrder" runat="server" />
    <asp:HiddenField ID="hvExcludeArticulationOverYears" runat="server" />
    <asp:HiddenField ID="hvFirstStage" runat="server" />
    <asp:HiddenField ID="hvLastStage" runat="server" />
    <asp:HiddenField ID="hvFromUserCollegeID" runat="server" />
    <asp:HiddenField ID="hvFromUserStageID" runat="server" />
    <asp:HiddenField ID="hvDisabledArticulationsCount" runat="server" />
    <asp:HiddenField ID="hvMessageCount" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hvProposedCR" runat="server" ClientIDMode="Static" />
    <div class="row container-fluid">
        <div class="col-md-6">
            <asp:SqlDataSource ID="sqlMessages" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="GetMessages" CancelSelectOnNullParameter="false">
                <SelectParameters>
                    <asp:ControlParameter Name="UserID" ControlID="hfUserID" Type="Int32" PropertyName="Value" />
                    <asp:ControlParameter Name="Deleted" ControlID="hfDeleted" Type="Boolean" PropertyName="Value" />
                    <asp:ControlParameter Name="Sent" ControlID="hfSent" Type="Boolean" PropertyName="Value" />
                    <asp:ControlParameter Name="SubjectID" Type="Int32" PropertyName="SelectedValue" ControlID="rcbSubject" DefaultValue="" ConvertEmptyStringToNull="true" />
                    <asp:ControlParameter Name="Reviewed" ControlID="hfReviewed" Type="Boolean" PropertyName="Value" />
                    <asp:ControlParameter Name="AceIDs" ControlID="hfAceIds" Type="String" PropertyName="Value" />
                    <asp:SessionParameter Name="SelectedRoleID" SessionField="RoleID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlMessagesCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="GetMessagesCriteria" CancelSelectOnNullParameter="false">
                <SelectParameters>
                    <asp:ControlParameter Name="UserID" ControlID="hfUserID" Type="Int32" PropertyName="Value" />
                    <asp:ControlParameter Name="Deleted" ControlID="hfDeleted" Type="Boolean" PropertyName="Value" />
                    <asp:ControlParameter Name="Sent" ControlID="hfSent" Type="Boolean" PropertyName="Value" />
                    <asp:Parameter Name="SubjectID" DBType="Int32" DefaultValue="" ConvertEmptyStringToNull="true" />
                    <asp:ControlParameter Name="Reviewed" ControlID="hfReviewed" Type="Boolean" PropertyName="Value" />
                </SelectParameters>
            </asp:SqlDataSource>
            <div class="row">
                <div class="col-6">
                    <telerik:RadTabStrip RenderMode="Lightweight" runat="server" ID="rtbMessages" OnTabClick="rtbMessages_TabClick" SelectedIndex="0" Width="300px">
                        <Tabs>
                            <telerik:RadTab Text="Inbox" Value="inbox" Width="100px"></telerik:RadTab>
                            <telerik:RadTab Text="Reviewed" Value="reviewed" Width="100px" Visible="false"></telerik:RadTab>
                            <telerik:RadTab Text="Sent" Value="sent" Width="100px" Visible="false"></telerik:RadTab>
                            <telerik:RadTab Text="Archive" Value="deleted" Width="100px"></telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                </div>
                <div class="col-6 d-flex justify-content-end">
                    <asp:Panel ID="pnlSubject" runat="server" Visible="false">
                        <telerik:RadComboBox ID="rcbSubject" runat="server" RenderMode="Lightweight" DataSourceID="sqlSubjects" DataTextField="subject" DataValueField="subject_id" Skin="Material" DropDownAutoWidth="Enabled" EmptyMessage="Select a Subject" AutoPostBack="true"></telerik:RadComboBox>
                        <asp:SqlDataSource ID="sqlSubjects" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="SELECT subject_id, [subject] FROM tblSubjects S WHERE S.subject_id IN ( SELECT SubjectID FROM UserSubjects WHERE UserID = @UserID )">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hfUserID" Name="UserID" PropertyName="Value" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>
                </div>
            </div>

            <div class="row p-2" style="display:none;">
                <asp:Panel ID="divAdvancedSearchMessages" runat="server">
                    <div class="row p-2">
                        <div class="col-sm-10">
                            <telerik:RadAutoCompleteBox ID="racbAdvancedSearchMessages" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="200" DropDownHeight="200" DataSourceID="sqlAdvancedSearchMessages" DataTextField="FullCriteria" DataValueField="FullCriteria"
                                EmptyMessage="Search by Exhibit ID(s) or keyword(s)" ClientIDMode="Static" AllowCustomEntry="false" HighlightFirstMatch="true" Delimiter="," AutoPostBack="true" ToolTip="" CssClass="acbCriteria" BackColor="#ffffe0"></telerik:RadAutoCompleteBox>
                            <asp:SqlDataSource runat="server" ID="sqlAdvancedSearchMessages" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="SearchCriteriaAdvancedMessage" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                            <asp:Label ID="lblAdvancedSearchMessages" runat="server" CssClass="alert alert-warning" Text="Please Search by Exhibit ID or Keyword" Visible="false" />
                        </div>
                        <div class="col-sm-2">
                            <telerik:RadButton ID="rbSearchMessages" runat="server" Text="Search" Width="80px" Primary="true" CausesValidation="false" OnClick="rbSearchMessages_Click"></telerik:RadButton>
                        </div>
                    </div>
                </asp:Panel>
            </div>

            <telerik:RadGrid ID="rgMessages" runat="server" AllowFilteringByColumn="true" AllowPaging="true" PageSize="5" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlMessages" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" AllowMultiRowSelection="true" OnItemCommand="rgMessages_ItemCommand" OnItemDataBound="rgMessages_ItemDataBound" MasterTableView-NoMasterRecordsText="There are no messages." OnPreRender="rgMessages_PreRender">
                <GroupingSettings CaseSensitive="false" />
                <ClientSettings AllowColumnsReorder="true">
                    <ClientEvents OnFilterMenuShowing="FilteringMenu" />
                    <Selecting AllowRowSelect="True" EnableDragToSelectRows="true" />
                    <ClientEvents OnRowContextMenu="GridRowClickEventHandlerMessages" OnRowDblClick="readMessageCommand" />
                </ClientSettings>
                <MasterTableView Name="ParentGrid" DataKeyNames="MessageID" DataSourceID="sqlMessages" CommandItemDisplay="Top">
                    <PagerStyle Mode="NextPrev" PagerTextFormat="Navigate {4} {0} of {1} pages, {5} Messages" />
                    <CommandItemTemplate>
                        <div class="commandItems">
                            <div style="display:none;">
                                <telerik:RadButton runat="server" ID="btnView" ToolTip="Read Message." CommandName="View"  Text=" Read Message" ButtonType="LinkButton">
                                    <ContentTemplate>
                                        <i class="fa fa-eye"></i> Read Message
                                    </ContentTemplate>
                                </telerik:RadButton>
                                <telerik:RadButton runat="server" ID="btnSetAsReaded" ToolTip="Check to flag message as read." CommandName="Read" Text=" Flag message as Read" ButtonType="LinkButton">
                                    <ContentTemplate>
                                        <i class="fa fa-check"></i> Flag message as Read
                                    </ContentTemplate>
                                </telerik:RadButton>
                            </div>
                            <telerik:RadButton runat="server" ID="btnDeleteMessage" ToolTip="Check to delete message." CommandName="Delete" Text=" Delete message" ButtonType="LinkButton">
                                <ContentTemplate>
                                    <i class="fa fa-trash"></i> Delete Message
                                </ContentTemplate>
                            </telerik:RadButton>
                        </div>
                    </CommandItemTemplate>
                    <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                    <Columns>
                        <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn" HeaderStyle-Width="15px">
                        </telerik:GridClientSelectColumn>
                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="15px" Display="false">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ToolTip="Read Message" CommandName="View" ID="ViewArticulation" Text='<i class="fa fa-eye" aria-hidden="true"></i>' />
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="MessageID" UniqueName="MessageID" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="FromUserCollegeID" UniqueName="FromUserCollegeID" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="FromUserStageID" UniqueName="FromUserStageID" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ActionTaken" UniqueName="ActionTaken" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CriteriaPackageID" UniqueName="CriteriaPackageID" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CriteriaPackageCourses" UniqueName="CriteriaPackageCourses" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ProposedCR" UniqueName="ProposedCR" Display="false" EmptyDataText="0">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Criteria" UniqueName="Criteria" Display="true" HeaderText ="Credit Recommendations" HeaderStyle-Font-Bold="true">
                         <FilterTemplate>
                            <telerik:RadComboBox RenderMode="Lightweight" ID="rcbCriteria" DataSourceID="sqlMessagesCriteria" DataTextField="Criteria" AllowCustomText="true"
                                DataValueField="Criteria" Width="100%" filter="Contains" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Criteria").CurrentFilterValue %>' AppendDataBoundItems="true"
                                runat="server" OnClientSelectedIndexChanged="CriteriaIndexChanged">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                <script type="text/javascript">
                                    function CriteriaIndexChanged(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("Criteria", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Articulations" UniqueName="Articulations" ConvertEmptyStringToNull="false" EmptyDataText=""  Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="IsRead" UniqueName="IsRead" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="FromUserID" UniqueName="FromUserID" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn SortExpression="Subject" HeaderText="Subject" DataField="Subject" UniqueName="Subject" HeaderStyle-Font-Bold="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn SortExpression="FromUser" HeaderText="From" DataField="FromUser" UniqueName="FromUser" HeaderStyle-Font-Bold="true" HeaderStyle-Width="150px">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn SortExpression="ToUser" HeaderText="To" DataField="ToUser" UniqueName="ToUser" HeaderStyle-Font-Bold="true" HeaderStyle-Width="150px" Visible="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridDateTimeColumn DataField="Received" DataType="System.DateTime" FilterControlAltText="Filter Received column" HeaderText="Received" SortExpression="Received" UniqueName="Received" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="140px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="140px" HeaderStyle-Font-Bold="true" ShowFilterIcon="false" CurrentFilterFunction="EqualTo">
                            <ItemStyle HorizontalAlign="Center" />
                        </telerik:GridDateTimeColumn>
                        <telerik:GridBoundColumn DataField="TookAction" UniqueName="TookAction" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="IsCC" UniqueName="IsCC" Display="false">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
            <telerik:RadContextMenu ID="rcmMessages" runat="server" OnItemClick="rcmMessages_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
                <Items>
                    <telerik:RadMenuItem Text="Read Message" Value="View">
                    </telerik:RadMenuItem>
                    <telerik:RadMenuItem Text="Flag message as readed" Value="Read">
                    </telerik:RadMenuItem>
                    <telerik:RadMenuItem Text="Delete message" Value="Delete">
                    </telerik:RadMenuItem>
                </Items>
            </telerik:RadContextMenu>
        </div>
        <div class="col-md-6">
            <asp:SqlDataSource ID="sqlMessage" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="GetMessage">
                <SelectParameters>
                    <asp:ControlParameter Name="MessageID" ControlID="hfMessageID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <div class="MessageDetails">
                <asp:Repeater ID="rptMessage" runat="server" DataSourceID="sqlMessage">
                    <HeaderTemplate>
                        <div class="row">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="col-sm-12">
                            <h3><%# Eval("Subject") %></h3>
                        </div>
                        <div class="col-sm-6">
                            <asp:Label runat="server" ID="Label9" Text='From : ' Font-Bold="true" />
                            <asp:Label runat="server" ID="Label10" Text='<%# Eval("FromUser") %>' />
                        </div>
                        <div class="col-sm-6">
                            <asp:Label runat="server" ID="Label3" Text='Received : ' Font-Bold="true" />
                            <asp:Label runat="server" ID="Label4" Text='<%# Eval("Received") %>' />
                        </div>
                        <div class="col-sm-12">
                            <asp:Label runat="server" ID="Label16" Text='<%# Eval("Body") %>' />
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
            <asp:Panel ID="pnlCreditRecommendation" runat="server" Visible="false">
                <div class="row" style="display:block;margin-bottom:10px !important;">
                    <div class="col-12" style="display:none;">
                        <telerik:RadButton runat="server" ID="btnAgree" OnClientClick="javascript:if(!confirm('Are you sure ?')){return false;}" ButtonType="StandardButton" Text="Return" ToolTip="Agree" OnClick="btnAgree_Click">
                            <ConfirmSettings ConfirmText="Are you sure ?" UseRadConfirm="true" />                           
                            <ContentTemplate>
                                <i class="fa-light fa-thumbs-up"></i> Agree
                            </ContentTemplate>
                        </telerik:RadButton>    
                        <telerik:RadButton runat="server" ID="btnDisagree" OnClientClick="javascript:if(!confirm('Are you sure ?')){return false;}" ButtonType="StandardButton" Text="Return" ToolTip="Disagree" OnClick="btnDisagree_Click">
                            <ConfirmSettings ConfirmText="Are you sure ?" UseRadConfirm="true" /> 
                            <ContentTemplate>
                                <i class="fa-solid fa-thumbs-down"></i> Disagree
                            </ContentTemplate>
                        </telerik:RadButton>                            
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnlArticulations" runat="server" Visible="false">
                <asp:SqlDataSource runat="server" ID="sqlFacultyReviewArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
                    SelectCommand="SELECT [dbo].[CourseExistInCollege] (@CollegeID,sub.subject,cif.course_number) AS 'CourseExists', [dbo].[CheckArticulationExistInCollege](@CollegeID,sub.subject,cif.course_number, ac.AceID, ac.TeamRevd) AS 'ArticulationExists', [dbo].[GetArticulationMatrix](ac.id) 'Matrix', ac.id, ac.LastSubmittedOn as LastSubmitted, AEC.Criteria AS SelectedCriteria, sub.subject , cif.course_number , cif.course_title, case when ac.ArticulationType = 1 then 'ACE Course' else 'Occupation' end as 'ArticulationTypeName', ac.ArticulationID, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, ac.Title, ac.TeamRevd, ac.CreatedOn, cc.Occupation , ac.outline_id, s.RoleID, ac.id, ac.ArticulationType, ac.ArticulationStatus, ac.ArticulationStage ,  case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Office Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes, ac.Notes, ac.ExhibitID, ac.Justification, ac.ArticulationOfficerNotes,  ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id', cc.Exhibit,   concat(mu.firstname , ', ' , mu.lastname) as 'FullName' , cc.Occupation, ac.ModifiedBy, ac.Articulate, ac.CollegeID, c.CollegeAbbreviation as 'ArticulationCollege', STUFF((SELECT ',' + Criteria FROM ArticulationCriteria a where a.ArticulationID = ac.ArticulationID and a.ArticulationType =ac.ArticulationType FOR XML PATH('') ), 1, 1, '') Criteria FROM Articulation ac LEFT OUTER JOIN AceExhibit cc on ac.ExhibitID = cc.ID LEFT OUTER JOIN tblusers u on ac.CreatedBy = u.userid LEFT OUTER JOIN TBLUSERS mu on ac.LastSubmittedBy = mu.UserID LEFT OUTER JOIN Stages s on ac.ArticulationStage = s.Id LEFT OUTER JOIN Course_IssuedForm cif on ac.outline_id = cif.outline_id LEFT OUTER JOIN tblsubjects sub ON cif.subject_id = sub.subject_id LEFT OUTER JOIN LookupColleges C ON ac.CollegeID = C.CollegeID LEFT OUTER JOIN ACEExhibitCriteria aec ON AC.CriteriaID = AEC.CriteriaID WHERE ac.id in (select value from [dbo].fn_split(@Articulations,','))  ORDER BY ac.LastSubmittedOn DESC">
                    <SelectParameters>
                        <asp:Parameter Name="Articulations" Type="String" DefaultValue="" />
                        <asp:ControlParameter Name="CollegeID" ControlID="hvCollegeID" Type="Int32" PropertyName="Value" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <label id="lblMessages" runat="server" class="alert alert-info" style="margin-top: 5px; margin-bottom: 6px;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i></label>
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
                <telerik:RadGrid ID="rgFacultyReviewArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlFacultyReviewArticulations" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" OnItemCommand="rgFacultyReviewArticulations_ItemCommand" RenderMode="Lightweight" OnItemDataBound="rgFacultyReviewArticulations_ItemDataBound" AllowMultiRowSelection="true" OnPreRender="rgFacultyReviewArticulations_PreRender" OnItemCreated="rgFacultyReviewArticulations_ItemCreated" GroupHeaderItemStyle-Font-Bold="true">
                    <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" EnableAlternatingItems="false" >
                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                        <ClientEvents OnRowContextMenu="demo.RowContextMenu" />
                    </ClientSettings>
                    <MasterTableView Name="ParentGrid" DataSourceID="sqlFacultyReviewArticulations" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1" EnableHeaderContextMenu="true" AllowPaging="false">
                        <CommandItemTemplate>
                            <div class="commandItems" style="padding: 5px;">
                                <div class="row">
                                    <div class="col-sm-8">
                                        <telerik:RadButton runat="server" ID="btnAdopt" ToolTip="Check to adopt selected articulations." CommandName="Adopt" Text=" Adopt selected articulations" ButtonType="LinkButton">
                                            <ContentTemplate>
                                                <i class="fa fa-clone"></i> Adopt 
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                        <telerik:RadButton runat="server" ID="btnMoveForward" OnClientClick="javascript:if(!confirm('Are you sure you want to approve this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="MoveForward" CommandName="MoveForward" ToolTip="Approve selected articulation(s)">
                                            <ContentTemplate>
                                                <i class='fa fa-send'></i><span class="txtMoveForward"> Approve</span>
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                        <telerik:RadButton runat="server" ID="btnReturn" OnClientClick="javascript:if(!confirm('Are you sure you want to Return this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Return" CommandName="Return" ToolTip="Return selected articulation(s)">
                                            <ContentTemplate>
                                                <i class='fa fa-hand-o-left'></i> Return
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                        <telerik:RadButton runat="server" ID="btnDenied" OnClientClick="javascript:if(!confirm('Are you sure you want to Deny this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Deny" CommandName="Denied" ToolTip="Deny selected articulation(s)">
                                            <ContentTemplate>
                                                <i class='fa fa-ban'></i> Deny
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                        <telerik:RadButton runat="server" ID="btnRevise" OnClientClick="javascript:if(!confirm('Are you sure you want to Revise this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Revise" CommandName="Revise" ToolTip="Revise selected articulation(s)" Visible="false">
                                            <ContentTemplate>
                                                <i class='fa fa-eye'></i> Revise
                                            </ContentTemplate>
                                        </telerik:RadButton>
                                        <telerik:RadButton runat="server" ID="btnArchive" OnClientClick="javascript:if(!confirm('Are you sure you want to Archive this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Archive" CommandName="Archive" ToolTip="Archive selected articulation(s)" Visible="false">
                                            <ContentTemplate>
                                                <i class='fa fa-archive'></i> Archive
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
                            <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                            </telerik:GridClientSelectColumn>
                            <telerik:GridBoundColumn DataField="CourseExists" UniqueName="CourseExists" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationExists" UniqueName="ArticulationExists" Display="false"></telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationCollege" UniqueName="ArticulationCollege" HeaderText="College" HeaderStyle-Width="60px" FilterControlWidth="60px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="false" Visible="false" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="subject" UniqueName="subject" HeaderText="Subject" HeaderStyle-Width="60px" FilterControlWidth="60px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="false" ShowSortIcon="true" AllowSorting="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" HeaderText="Type" AllowFiltering="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="80px" AllowFiltering="false" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn UniqueName="ExhibitLink" HeaderText="ACE ID" SortExpression="AceID" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true">
                                <ItemTemplate>
                                    <asp:HyperLink NavigateUrl="javascript:showExhibitInfo();" runat="server" ID="hlExhibit" Text="" Font-Underline="true"></asp:HyperLink>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>    
                            <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" AllowFiltering="false">
                                <ItemStyle HorizontalAlign="Center" />
                            </telerik:GridDateTimeColumn>
                            <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="190px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false">
                            </telerik:GridBoundColumn>
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
                            <telerik:GridBoundColumn DataField="CollegeID" UniqueName="CollegeID" Display="false"></telerik:GridBoundColumn>
                        </Columns>
                        <NestedViewTemplate>
                            <div class="row" style="padding: 5px; font-size: 10px;">
                                <div class="col-sm-4">
                                    <p class="bold">Articulation Matrix</p>
                                    <%# Eval("Matrix") %>
                                </div>
                                <div class="col-sm-4" style="display:none;">
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
                <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" runat="server" />
                <input type="hidden" id="radGridClickedRowIndexAdopt" name="radGridClickedRowIndexAdopt" runat="server" />
                <input type="hidden" id="hvOutlineID" name="hvOutlineID" runat="server" />
                <input type="hidden" id="hvID" name="hvID" runat="server" />
                <input type="hidden" id="hvArticulationID" name="hvArticulationID" runat="server" />
                <input type="hidden" id="hvArticulationType" name="hvArticulationType" runat="server" />
                <input type="hidden" id="hvArticulationStage" name="hvArticulationStage" runat="server" />
				<input type="hidden" id="hvExhibitID" name="hvExhibitID" runat="server" />																	  
                <input type="hidden" id="hvAceID" name="hvAceID" runat="server" />
                <input type="hidden" id="hvTeamRevd" name="hvTeamRevd" runat="server" />
                <input type="hidden" id="hvTitle" name="hvTitle" runat="server" />
                <input type="hidden" id="hvCriteriaPackageID" name="hvCriteriaPackageID" runat="server" />
                <telerik:RadContextMenu ID="RadMenu1" runat="server" OnItemClick="RadMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
                    <Items>
                        <telerik:RadMenuItem Text="Approve" Value="MoveForward">
                        </telerik:RadMenuItem>
                        <telerik:RadMenuItem Text="Archive" Value="Archive">
                        </telerik:RadMenuItem>
                        <telerik:RadMenuItem Text="Deny" Value="Denied">
                        </telerik:RadMenuItem>
                        <telerik:RadMenuItem Text="Edit" Value="Edit">
                        </telerik:RadMenuItem>
                        <telerik:RadMenuItem Text="Return" Value="Return">
                        </telerik:RadMenuItem>
                        <telerik:RadMenuItem Text="View" Value="View">
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
            </asp:Panel>
        </div>
    </div>
</telerik:RadAjaxPanel>
<telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
<telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    <script>
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
        function GridRowClickEventHandlerMessages(sender, args) {
            var menu = $find('<%= rcmMessages.ClientID %>');

            var evt = args.get_domEvent();
            if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
                return;
            }

            var index = args.get_itemIndexHierarchical();

            sender.get_masterTableView().selectItem(sender.get_masterTableView().get_dataItems()[index].get_element(), true);

            var selectedRow = sender.get_masterTableView().get_selectedItems()[0];

            menu.show(evt);
            evt.cancelBubble = true;
            evt.returnValue = false;

            if (evt.stopPropagation) {
                evt.stopPropagation();
                evt.preventDefault();
            }
        }

        function readMessageCommand(sender, args) {
            var index = args.get_itemIndexHierarchical();
            sender.get_masterTableView().fireCommand("View", index);
        }
    </script>
</telerik:RadCodeBlock>

