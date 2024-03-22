<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="ArticulationsPendingToReview.aspx.cs" Inherits="ems_app.modules.faculty.ArticulationsPendingToReview" %>
<%@ Register src="../../UserControls/AdoptArticulations.ascx" tagname="AdoptArticulations" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" runat="server">Articulations Pending Review</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
            <telerik:RadWindowManager ID="RadWindowManager1" EnableViewState="false" runat="server" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>

            <div class="row" style="padding: 10px;">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <asp:HiddenField ID="hvUserName" runat="server" />
                    <asp:HiddenField ID="hvUserID" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hvCollegeID" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="hvAppID" runat="server" />
                    <asp:HiddenField ID="hvUserStage" runat="server" />
                    <asp:HiddenField ID="hvUserStageOrder" runat="server" />
                    <asp:HiddenField ID="hvExcludeArticulationOverYears" runat="server" />
                    <asp:HiddenField ID="hvFirstStage" runat="server" />
                    <asp:HiddenField ID="hvLastStage" runat="server" />

                    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
                        <SelectParameters>
                            <asp:ControlParameter Name="CollegeID" ControlID="hvCollegeID" PropertyName="Value" Type="Int32" />
                            <asp:ControlParameter ControlID="hvUserName" DefaultValue="0" Name="Username" PropertyName="Value" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="sqlReview" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 0 as id , 'Not Reviewed' description union select 1 as id , 'Reviewed' description">
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="sqlUserLog" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ac.ExhibitID, s.subject + ' ' + cif.course_number + ' ' + cif.course_title as 'Course', r1.RoleName as RoleName, ac.id, al.outline_id, case when al.ArticulationType = 1 then 'Course' else 'Occupation' end ArticulationType, al.ArticulationType as 'articulation_type', al.[event], ac.AceID, ac.TeamRevd, ac.Title, al.LogTime from ArticulationLog al left outer join Articulation ac on al.ArticulationID = ac.ArticulationID and al.ArticulationType = ac.ArticulationType join Course_IssuedForm cif on al.outline_id = cif.outline_id  left outer join Stages s1 on ac.ArticulationStage = s1.Id left outer join ROLES r1 on s1.RoleId = r1.RoleID left outer join tblSubjects s on cif.subject_id = s.subject_id where cif.college_id = @CollegeID and al.ArticulationID > 0 and al.UserID = @UserID order by al.LogTime desc">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="hvCollegeID" DefaultValue="0" Name="CollegeID" PropertyName="Value" Type="Int32" />
                            <asp:ControlParameter ControlID="hvUserID" DefaultValue="0" Name="UserID" PropertyName="Value" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="sqlFacultyReviewArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetFacultyReviewArticulations" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="hvUserName" DefaultValue="0" Name="Username" PropertyName="Value" />
                            <asp:ControlParameter Name="Years" ControlID="hvExcludeArticulationOverYears" PropertyName="Value" Type="Int32" />
                            <asp:Parameter Name="ShowDenied" Type="Byte" DefaultValue="1" />
                            <asp:SessionParameter Name="RoleID" SessionField="RoleID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="sqlDeniedArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetFacultyReviewArticulations" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="hvUserName" DefaultValue="0" Name="Username" PropertyName="Value" />
                            <asp:ControlParameter Name="Years" ControlID="hvExcludeArticulationOverYears" PropertyName="Value" Type="Int32" />
                            <asp:Parameter Name="ShowDenied" Type="Byte" DefaultValue="0" />
                            <asp:SessionParameter Name="RoleID" SessionField="RoleID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>                   
                    <asp:SqlDataSource ID="sqlArchivedArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArchiveArticulations" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="hvUserName" DefaultValue="0" Name="Username" PropertyName="Value" />
                            <asp:ControlParameter Name="Years" ControlID="hvExcludeArticulationOverYears" PropertyName="Value" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadTabStrip runat="server" ID="RadTabStrip1" MultiPageID="RadMultiPage1" SelectedIndex="0" Width="100%" Height="50px" ShowBaseLine="false" RenderMode="Lightweight"  OnClientTabSelected="OnClientTabSelected">
                        <Tabs>
                            <telerik:RadTab Text="Articulations In Process" Value="InProcess" ToolTip="" Selected="True" CssClass="ArticulationsInProcess">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Recent User Activity" Value="UserActivity" ToolTip="" ClientIDMode="Static" CssClass="RecentUserActivity" >
                            </telerik:RadTab>
                            <telerik:RadTab Text="Denied Articulations" Value="Denied" ToolTip="">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Archived Articulations" Value="Denied" ToolTip="">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Articulations to adopt from other colleges" Value="Adopt" ToolTip="">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage runat="server" ID="RadMultiPage1" SelectedIndex="0" Width="99%" RenderMode="Lightweight">
                        <telerik:RadPageView runat="server" ID="RadPageView1" Width="100%">
                            <telerik:RadGrid ID="rgFacultyReviewArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlFacultyReviewArticulations" AllowFilteringByColumn="true" AllowPaging="True" GroupingSettings-CaseSensitive="false" OnItemCommand="rgFacultyReviewArticulations_ItemCommand" RenderMode="Lightweight" OnItemDataBound="rgFacultyReviewArticulations_ItemDataBound" AllowMultiRowSelection="true">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="True" EnableDragToSelectRows="true" />
                                    <ClientEvents OnRowContextMenu="demo.RowContextMenu" OnFilterMenuShowing="FilteringMenu" />
                                </ClientSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlFacultyReviewArticulations" PageSize="8" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                            <div class="col-sm-6">
                                                <telerik:RadButton runat="server" ID="btnMoveForward" OnClientClick="javascript:if(!confirm('Are you sure you want to approve this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="MoveForward" CommandName="MoveForward" ToolTip="Approve selected articulation(s)">
                                                    <ContentTemplate>
                                                        <i class='fa fa-send'></i> <span class="txtMoveForward">Approve</span>
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
                                                <telerik:RadButton ID="rbDelete" runat="server" Text="Delete Articulation" Height="34px" CommandName="Delete" ToolTip="Delete selected articulation(s)">
                                                    <Icon PrimaryIconCssClass="rbRemove"></Icon>
                                                    <ConfirmSettings ConfirmText="Are you sure you want to Delete this articulation(s)?" />
                                                </telerik:RadButton>
                                                <telerik:RadButton runat="server" ID="btnArchive" OnClientClick="javascript:if(!confirm('Are you sure you want to Archive this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Archive" CommandName="Archive" ToolTip="Archive selected articulation(s)">
                                                    <ContentTemplate>
                                                        <i class='fa fa-archive'></i> Archive
                                                    </ContentTemplate>
                                                </telerik:RadButton>
                                            </div>
                                            <div class="col-sm-6 text-right" style="padding-top:5px;">
                                                <asp:Label runat="server" ID="lblDanger" CssClass="alert"></asp:Label> &nbsp;
                                                <asp:Label runat="server" ID="lblWarning" CssClass="alert"></asp:Label> &nbsp;
                                                <asp:Label runat="server" ID="lblSuccess" CssClass="alert"></asp:Label> &nbsp;
                                            </div>
                                        </div>
                                    </CommandItemTemplate>
                                    <Columns>
                                        <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                                        </telerik:GridClientSelectColumn>
                                        <telerik:GridCheckBoxColumn DataField="checkUpdatedCurrentUser" DataType="System.Boolean" HeaderText="Revised" UniqueName="checkUpdatedCurrentUser" AllowFiltering="true" HeaderStyle-Width="65px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo">
                                        </telerik:GridCheckBoxColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false">
                                            <ItemTemplate>
                                                <asp:LinkButton Visible="false" runat="server" ToolTip="Have denied articulation(s) in other colleges." CommandName="AdoptArticulations" ID="btnHaveDeniedArticulations" Text='<i class="fa fa-ban" aria-hidden="true"></i>' />
                                                <asp:LinkButton Visible="false" runat="server" ToolTip="Have articulation(s) in other colleges." CommandName="AdoptArticulations" ID="btnArticulationsInOtherColleges" Text='<i class="fa fa-university" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="HaveDeniedArticulations" UniqueName="HaveDeniedArticulations" Display="false" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationsInOtherColleges" UniqueName="ArticulationsInOtherColleges" Display="false" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Matrix" UniqueName="Matrix" AllowFiltering="false" Exportable="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="50px">
                                            <FilterTemplate>
                                                <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                                    DataValueField="subject" MaxHeight="200px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                    runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged2">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="All" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                                <telerik:RadScriptBlock ID="RadScriptBlock43" runat="server">
                                                    <script type="text/javascript">
                                                        function SubjectIndexChanged2(sender, args) {
                                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                            tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                        }
                                                    </script>
                                                </telerik:RadScriptBlock>
                                            </FilterTemplate>
                                        </telerik:GridDropDownColumn>
                                        <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"  ShowFilterIcon="true" AllowFiltering="true" ShowSortIcon="true" AllowSorting="true" >
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" HeaderText="Type" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn UniqueName="TemplateLinkColumn" AllowFiltering="False" HeaderStyle-Width="30px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lnkShowAcePopup" CommandName="ShowAcePopup" runat="server"><i class="fa fa-info-circle" aria-hidden="true"></i></asp:LinkButton>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="80px" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="190px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false" EmptyDataText="">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                                <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight" ManualClose="false" HideEvent="LeaveTargetAndToolTip">
                                                <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                                                </telerik:RadToolTip>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn SortExpression="SelectedCriteria" HeaderText="Credit Recommendation" DataField="SelectedCriteria" UniqueName="SelectedCriteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Submitted By" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="100px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn DataField="CreatedOn" DataType="System.DateTime" FilterControlAltText="Filter CreatedOn column" HeaderText="Created On" SortExpression="CreatedOn" UniqueName="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true" Display="false" >
                                            <ItemStyle HorizontalAlign="Center" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridDateTimeColumn DataField="LastSubmitted" DataType="System.DateTime" FilterControlAltText="Filter LastSubmitted column" HeaderText="Last Submitted" SortExpression="LastSubmitted" UniqueName="LastSubmitted" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true">
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
                                </MasterTableView>
                            </telerik:RadGrid>
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
                            <input type="hidden" id="hvExhibitID" name="hvExhibitID" runat="server" />
                            <telerik:RadContextMenu ID="RadMenu1" runat="server" OnClientItemClicked="contextMenuItemClicked" OnItemClick="RadMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
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
                                    <telerik:RadMenuItem Text="Delete" Value="Delete">
                                    </telerik:RadMenuItem>
                                </Items>
                            </telerik:RadContextMenu>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="RadPageView2" Width="100%">
                            <telerik:RadGrid ID="rgUserLog" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlUserLog" EnableHeaderContextMenu="True" Width="100%" AllowFilteringByColumn="true" PageSize="50" GridLines="None" OnItemCommand="rgUserLog_ItemCommand">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                                    <ClientEvents OnFilterMenuShowing="FilteringMenu" />
                                </ClientSettings>
                                <MasterTableView DataKeyNames="outline_id" DataSourceID="sqlUserLog" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true">
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="ViewArticulation" ID="LinkButton1" Text='<i class="fa fa-edit fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="Id" DataType="System.Int32" FilterControlAltText="Filter Id column" HeaderText="Id" ReadOnly="True" SortExpression="Id" UniqueName="Id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Course" FilterControlAltText="Filter Course column" AllowFiltering="true" HeaderText="Course" SortExpression="Course" UniqueName="Course" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="ArticulationType" HeaderStyle-Width="100px" HeaderText="Type" DataField="ArticulationType" UniqueName="ArticulationType" HeaderStyle-Font-Bold="true" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderStyle-Width="150px" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Font-Bold="true" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" HeaderText="Team Revd" HeaderStyle-Font-Bold="true" DataFormatString="{0:MM/dd/yyyy}" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Font-Bold="true" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Event" FilterControlAltText="Filter Event column" HeaderText="Filter by Tracking Information" SortExpression="Event" UniqueName="Event" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Contains" FilterControlToolTip="Filter by tracking information (i.e. updated by ... implementation ... submitted...">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn DataField="LogTime" DataType="System.DateTime" FilterControlAltText="Filter approv_date column" HeaderText="Filter by Tracking Date" SortExpression="LogTime" UniqueName="LogTime" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="articulation_type" UniqueName="articulation_type" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="RadPageView3" Width="100%">
                            <telerik:RadGrid ID="rgDeniedArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlDeniedArticulations" AllowFilteringByColumn="true" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" OnItemDataBound="rgFacultyReviewArticulations_ItemDataBound" OnItemCommand="rgDeniedArticulations_ItemCommand">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                                    <ClientEvents OnFilterMenuShowing="FilteringMenu" />
                                </ClientSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlDeniedArticulations" PageSize="8" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" ItemStyle-Height="25px" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
                                    <Columns>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Reverse Articulation" CommandName="DontArticulate" ID="btnDontArticulate" Text='<i class="fa fa-ban fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ToolTip="Edit Articulation" CommandName="ViewArticulation" ID="LinkButton1" Text='<i class="fa fa-edit fa-lg" aria-hidden="true"></i>' />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="50px">
                                            <FilterTemplate>
                                                <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                                    DataValueField="subject" MaxHeight="200px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                    runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged3">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="All" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                                <telerik:RadScriptBlock ID="RadScriptBlock43" runat="server">
                                                    <script type="text/javascript">
                                                        function SubjectIndexChanged3(sender, args) {
                                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                            tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                        }
                                                    </script>
                                                </telerik:RadScriptBlock>
                                            </FilterTemplate>
                                        </telerik:GridDropDownColumn>
                                        <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" HeaderText="Type" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="80px" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="Between" Display="False">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="190px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false" EmptyDataText="">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                                <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight"  ManualClose="false"  HideEvent="LeaveTargetAndToolTip">
                                                <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                                                </telerik:RadToolTip>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn SortExpression="SelectedCriteria" HeaderText="Credit Recommendation" DataField="SelectedCriteria" UniqueName="SelectedCriteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Submitted By" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="100px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn DataField="CreatedOn" DataType="System.DateTime" FilterControlAltText="Filter CreatedOn column" HeaderText="Created On" SortExpression="CreatedOn" UniqueName="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true" >
                                            <ItemStyle HorizontalAlign="Center" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridDateTimeColumn DataField="LastSubmitted" DataType="System.DateTime" FilterControlAltText="Filter LastSubmitted column" HeaderText="Last Submitted" SortExpression="LastSubmitted" UniqueName="LastSubmitted" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="RadPageView5" Width="100%">
                            <telerik:RadGrid ID="rgArchivedArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArchivedArticulations" AllowFilteringByColumn="true" AllowPaging="True" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" OnItemDataBound="rgFacultyReviewArticulations_ItemDataBound" OnItemCommand="rgArchivedArticulations_ItemCommand" AllowMultiRowSelection="true">
                                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
                                    <Selecting AllowRowSelect="true" EnableDragToSelectRows="False" />
                                    <ClientEvents OnFilterMenuShowing="FilteringMenu" />
                                </ClientSettings>
                                <MasterTableView Name="ParentGrid" DataSourceID="sqlArchivedArticulations" PageSize="8" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" ItemStyle-Height="25px" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
                                    <CommandItemTemplate>
                                        <div class="commandItems">
                                                <telerik:RadButton runat="server" ID="btnArchive" OnClientClick="javascript:if(!confirm('Are you sure you want to Archive this articulation(s) ?')){return false;}" ButtonType="StandardButton" Text="Archive" CommandName="Archive" ToolTip="Reverse archive selected articulation(s)">
                                                    <ContentTemplate>
                                                        <i class='fa fa-archive'></i> Reverse archive
                                                    </ContentTemplate>
                                                </telerik:RadButton>
                                        </div>
                                    </CommandItemTemplate>
                                    <Columns>
                                        <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                                        </telerik:GridClientSelectColumn>
                                        <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="50px">
                                            <FilterTemplate>
                                                <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject"
                                                    DataValueField="subject" MaxHeight="200px" Width="70px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                    runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged4773">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="All" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                                <telerik:RadScriptBlock ID="RadScriptBlock43" runat="server">
                                                    <script type="text/javascript">
                                                        function SubjectIndexChanged4773(sender, args) {
                                                            var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                            tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                        }
                                                    </script>
                                                </telerik:RadScriptBlock>
                                            </FilterTemplate>
                                        </telerik:GridDropDownColumn>
                                        <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" HeaderText="Type" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="80px" AllowFiltering="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" HeaderStyle-Width="190px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="ArticulationNotes" HeaderText="Notes" DataField="ArticulationNotes" UniqueName="ArticulationNotes" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false" EmptyDataText="">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderText="Notes">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ToolTip="Articulation Notes" ID="lblArticulationNotes" Visible="false" Text="<i class='fa fa-commenting fa-lg'></i>" />
                                                <telerik:RadToolTip RenderMode="Lightweight" ID="RadToolTip11" runat="server" TargetControlID="lblArticulationNotes" Width="450px" RelativeTo="Element" Position="MiddleRight"  ManualClose="false"  HideEvent="LeaveTargetAndToolTip">
                                                <%# DataBinder.Eval(Container, "DataItem.ArticulationNotes") %>
                                                </telerik:RadToolTip>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn SortExpression="SelectedCriteria" HeaderText="Credit Recommendation" DataField="SelectedCriteria" UniqueName="SelectedCriteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Submitted By" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="100px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridDateTimeColumn DataField="CreatedOn" DataType="System.DateTime" FilterControlAltText="Filter CreatedOn column" HeaderText="Created On" SortExpression="CreatedOn" UniqueName="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true" >
                                            <ItemStyle HorizontalAlign="Center" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridDateTimeColumn DataField="LastSubmitted" DataType="System.DateTime" FilterControlAltText="Filter LastSubmitted column" HeaderText="Last Submitted" SortExpression="LastSubmitted" UniqueName="LastSubmitted" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </telerik:GridDateTimeColumn>
                                        <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ArticulationStatus" UniqueName="ArticulationStatus" Display="false"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Articulate" UniqueName="Articulate" Display="false">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="RadPageView4" Width="100%">
                            <!-- ADD ADOPT ARTICULATIONS -->
                            <uc1:AdoptArticulations ID="AdoptArticulationsViewer" runat="server" />
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>


                </div>
            </div>

        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript" src="<%= this.ResolveUrl("~/Common/js/Guiders-JS-master/guiders.js") %>"></script>
    <script>
        ; (function ($, undefined) {
            var menu;
            var grid;
            var demo = window.demo = {};

            Sys.Application.add_load(function () {
                grid = $telerik.findControl(document, "rgFacultyReviewArticulations");
                menu = $telerik.findControl(document, "RadMenu1");
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

                menu.show(evt);
                evt.cancelBubble = true;
                evt.returnValue = false;

                if (evt.stopPropagation) {
                    evt.stopPropagation();
                    evt.preventDefault();
                }
            };

        })($telerik.$);
    </script>
    <script type="text/javascript">
        function contextMenuItemClicked(sender, args) {
            var itemValue = args.get_item().get_value();
            if (itemValue == "Delete") {
                var proceed = confirm("Permanently delete this articulation(s)?");
                if (!proceed) {
                    eventArgs.set_cancel(true);
                }
            }
        }
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        window.addEventListener('load',
            function () {
                var user_stage = document.getElementById('<%= hvUserStage.ClientID %>').value;
                var first_stage = document.getElementById('<%= hvFirstStage.ClientID %>').value;
                if (user_stage == first_stage) {
                    //hideEvaluatorMenuItems();
                }
            }, false);
        function hideEvaluatorMenuItems() {
            var radGrid = $get('rgFacultyReviewArticulations');
            var rbtDenied = $telerik.findControl(radGrid, 'btnDenied');
            var rbtMoveForward = $telerik.findControl(radGrid, 'btnMoveForward');

            rbtDenied.set_visible(false);
            rbtMoveForward.set_text("Move Forward");
            document.getElementsByClassName('txtMoveForward')[0].style.visibility = 'hidden';
            document.getElementsByClassName('txtMoveForward')[0].style.display = 'none';

            var menu = $find("<%= RadMenu1.ClientID %>");
            var item = menu.findItemByText("Deny");
            var items = item.get_parent().get_items();
            var index = items.indexOf(item);
            items.removeAt(index); 
            menu.get_items().getItem(0).set_text("Move Forward");
        } 
    </script>
    <script>
        function OnClientTabSelected(sender, eventArgs) {
            var tab = eventArgs.get_tab();
            if (tab.get_value() == "InProcess") {
                var masterTable = $find("<%= rgFacultyReviewArticulations.ClientID %>").get_masterTableView();
                masterTable.rebind();
            }
        }
    </script>
    <script type="text/javascript">
        url = new URL(window.location.href);

        if (url.searchParams.get('onboarding')) {
            const action = url.searchParams.get('action');
            switch (action) {
                case "archive-articulations":
                    ArchiveArticulations();
                    break;
                case "approved-articulations":
                    ApprovedArticulations();
                    break;
                case "denny-articulations":
                    DennyArticulations();
                    break;
                case "return-articulations":
                    ReturnArticulations();
                    break;
                case "recent-user-activity":
                    RecentUserActivity();
                    break;
                case "denied-articulations":
                    DeniedArticulations();
                    break;
                case "archived-articulations":
                    ArchivedArticulations();
                    break;
                case "adopt-articulations":
                    AdoptArticulations();
                    break;
                case "view-articulations":
                    ViewArticulations();
                    break;
                default:
            }
        } 
        function ApprovedArticulations() {
            guiders.createGuider({
                buttons: [{ name: "EXIT", onclick: guiders.hideAll }, { name: "NEXT", classString: "guiders_primary_button" }],
                description: "In this module, you will learn how to select and approve articulations in different ways.<br>Click NEXT so we can show you.",
                id: "guiderApprove1",
                next: "guiderApprove2",
                overlay: true,
                
                title: "Approve Articulations",
                xButton: true
            }).show();

            guiders.createGuider({
                attachTo: ".ArticulationsInProcess",
                buttons: [{ name: "EXIT", onclick: guiders.hideAll },
                { name: "BACK" },
                { name: "NEXT", classString: "guiders_primary_button", onclick: guiders.next }],
                description: "Click here to display all active articulations in your stage.",
                id: "guiderApprove2",
                next: "guiderApprove3",
                position: 3,
                title: "Approve Articulations",
                width: 500,
                xButton: true
            });

            guiders.createGuider({
                attachTo: "#rgFacultyReviewArticulations_ctl00_ctl04_ClientSelectColumnSelectCheckBox",
                buttons: [{ name: "EXIT", onclick: guiders.hideAll },
                { name: "BACK" },
                { name: "NEXT", classString: "guiders_primary_button", onclick: guiders.next }],
                description: "The checkboxes on the left will allow you to select a single or multiple articulations to approve.",
                id: "guiderApprove3",
                next: "guiderApprove31",
                position: 3,
                title: "Approve Articulations",
                width: 500,
                xButton: true
            });

            guiders.createGuider({
                attachTo: "#rgFacultyReviewArticulations_ctl00_ctl02_ctl02_ClientSelectColumnSelectCheckBox",
                buttons: [{ name: "EXIT", onclick: guiders.hideAll },
                { name: "BACK" },
                { name: "NEXT", classString: "guiders_primary_button", onclick: guiders.next }],
                description: "Click here to select or deselect all articulations at one time.",
                id: "guiderApprove31",
                next: "guiderApprove4",
                position: 3,
                title: "Approve Articulations",
                width: 500,
                xButton: true
            });

            guiders.createGuider({
                buttons: [{ name: "EXIT", onclick: guiders.hideAll },
                { name: "BACK" },
                { name: "NEXT", classString: "guiders_primary_button", onclick: guiders.next }],
                description: "Once you selected the articulation(s) to approve:<br><br><ul style='list-style:none;'><li>1. You can click the APPROVE button, OR</li><li>2. You can right-click on your mouse, and select APPROVE.</li></ul>Whatever method you choose, a pop- up window will appear where you can enter your notes.<br/> <img src=\"../../Common/images/onboarding/ApproveContextMenuVideo.gif\" style=\"border: none;\" width='470' height='400' border=0 />",
                id: "guiderApprove4",
                next: "guiderApprove5",
                title: "Approve Articulations",
                width: 500,
                xButton: true
            });


            guiders.createGuider({
                attachTo: "#rgFacultyReviewArticulations_ctl00_ctl02_ctl00_btnMoveForward",
                buttons: [{ name: "EXIT", onclick: guiders.hideAll },
                { name: "BACK" },
                { name: "NEXT", classString: "guiders_primary_button", onclick: guiders.next }],
                description: "Enter your notes here.<br>FYI: In this window, you have the option to notify your Faculty and/ or District Evaluators regarding the approval of the articulation(s).<br/><br/>Click here to save your notes, and send notification (if applicable). <br/><br/> <img src=\"../../Common/images/onboarding/AproveArticulationPopup.gif\" style=\"border: 1px solid #333;\" width='580' height='474' border=0 />",
                id: "guiderApprove5",
                next: "guiderApprove7",
                title: "Approve Articulations",
                width: 600,
                xButton: true
            });

            guiders.createGuider({
                attachTo: "#update_anchor",
                buttons: [{ name: "Close", classString: "primary-button" }],
                description: "CONGRATULATIONS, you just learned how to approved articulations.",
                id: "guiderApprove7",
                overlay: true,
                title: "Thank you!",
                width: 500
            });
        }
    </script>
</asp:Content>
