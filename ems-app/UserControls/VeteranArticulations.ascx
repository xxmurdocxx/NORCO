<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VeteranArticulations.ascx.cs" Inherits="ems_app.UserControls.VeteranArticulations" %>
<telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
    <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
        <p id="divMsgs" runat="server">
            <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
            </asp:Label>
            <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
            </asp:Label>
        </p>
    </telerik:RadToolTip>
    <asp:SqlDataSource ID="sqlArticulationsByOccupationCode" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT [dbo].[GetArticulationMatrix](ac.id) 'Matrix', ac.LastSubmittedOn as LastSubmitted, (SELECT STUFF((SELECT ',' + criteria FROM ArticulationCriteria where ArticulationID = ac.ArticulationID	and ArticulationType = ac.ArticulationType FOR XML PATH('')) ,1,1,'')) AS SelectedCriteria, sub.subject , cif.course_number , cif.course_title, case when ac.ArticulationType = 1 then 'ACE Course' else 'Occupation' end as 'ArticulationTypeName', ac.ArticulationID, ac.ArticulationType articulation_type, ac.outline_id, ac.AceID, cc.Exhibit, ac.Title, ac.TeamRevd, ac.CreatedOn, cc.Occupation , ac.outline_id, s.RoleID, ac.id, ac.ArticulationType, ac.ArticulationStatus, ac.ArticulationStage ,  case when ( ac.Notes = '' or ac.Notes is null) and (ac.Justification = '' or ac.Justification is null)  and (ac.ArticulationOfficerNotes = '' or ac.ArticulationOfficerNotes is null) then '' else CONCAT('Evaluator Notes : ', ISNULL(NULLIF(ac.Notes, ''), 'None') , ' - Faculty Notes : ', ISNULL(NULLIF(ac.Justification, ''), 'None'), ' - Articulation Office Notes : ', ISNULL(NULLIF(ac.ArticulationOfficerNotes, ''), 'None') ) end as ArticulationNotes,  ac.ArticulationType as 'articulation_type', ac.ArticulationStatus as 'status_id', ac.ArticulationStage as 'stage_id',   concat(mu.firstname , ', ' , mu.lastname) as 'FullName' , ac.ModifiedBy, ac.Articulate, ac.CollegeID,  (select count(*) from Articulation a left outer join LookupColleges c on a.CollegeID = c.CollegeID where a.Articulate = 0 and c.CheckExistOtherColleges = 1 and a.CollegeID <> @CollegeID and a.AceID = ac.AceID and a.TeamRevd = ac.TeamRevd) as HaveDeniedArticulations FROM ( select AceID, TeamRevd from VeteranACECourse where VeteranId = @VeteranID union select o.AceID, o.TeamRevd from VeteranOccupation vo join AceExhibit o on vo.OccupationCode = o.Occupation where vo.VeteranId = @VeteranID union select o.AceID, o.TeamRevd from Veteran v join ACEExhibit o on v.Occupation = o.Occupation where v.id = @VeteranID ) VA left outer join Articulation ac on va.AceID = ac.AceID and va.TeamRevd = ac.TeamRevd LEFT OUTER JOIN ACEExhibit cc on ac.AceID = cc.ACeID and ac.TeamRevd = cc.TeamRevd LEFT OUTER JOIN tblusers u on ac.CreatedBy = u.userid LEFT OUTER JOIN TBLUSERS mu on ac.LastSubmittedBy = mu.UserID LEFT OUTER JOIN Stages s on ac.ArticulationStage = s.Id LEFT OUTER JOIN Course_IssuedForm cif on ac.outline_id = cif.outline_id LEFT OUTER JOIN tblsubjects sub ON cif.subject_id = sub.subject_id WHERE cif.[college_id] = @CollegeID and ac.ArticulationStatus = 1 and ac.ArticulationStage = [DBO].GetMaximumStageId(ac.CollegeID) ORDER BY ac.LastSubmittedOn DESC">
        <SelectParameters>
            <asp:Parameter Name="Occupation" Type="String"></asp:Parameter>
            <asp:Parameter Name="VeteranID" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="CollegeID" Type="Int32"></asp:Parameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
        <SelectParameters>
            <asp:Parameter Name="CollegeID" Type="Int32"></asp:Parameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadGrid ID="rgArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationsByOccupationCode" AllowFilteringByColumn="true" AllowPaging="True" GroupingSettings-CaseSensitive="false" OnItemCommand="rgArticulations_ItemCommand" RenderMode="Lightweight" OnItemDataBound="rgArticulations_ItemDataBound" AllowMultiRowSelection="true">
        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
            <Selecting AllowRowSelect="True" EnableDragToSelectRows="true" />
            <ClientEvents OnFilterMenuShowing="FilterMenuShowing" />
        </ClientSettings>
        <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulationsByOccupationCode" PageSize="8" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
            <Columns>
                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false">
                    <ItemTemplate>
                        <asp:LinkButton Visible="false" runat="server" ToolTip="Have denied articulation(s) in other colleges." CommandName="AdoptArticulations" ID="btnHaveDeniedArticulations" Text='<i class="fa fa-ban" aria-hidden="true"></i>' />
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn DataField="HaveDeniedArticulations" UniqueName="HaveDeniedArticulations" Display="false" Exportable="false">
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
                <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" HeaderStyle-Width="40px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="true" ShowSortIcon="true" AllowSorting="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains">
                </telerik:GridBoundColumn>
                <telerik:GridTemplateColumn UniqueName="ArticulationTypeName" DataField="ArticulationTypeName" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" AllowFiltering="True" HeaderStyle-Font-Bold="true" HeaderText="Type" HeaderStyle-Width="90px" ItemStyle-Width="75px" FilterControlWidth="50px">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkShowExhibit" CommandName="ShowACEExhibit" runat="server"><i class="fa fa-info-circle" aria-hidden="true"></i></asp:LinkButton>
                        <%# DataBinder.Eval(Container, "DataItem.ArticulationTypeName") %>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="90px" FilterControlWidth="90px" AllowFiltering="false">
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
                <telerik:GridBoundColumn SortExpression="SelectedCriteria" HeaderText="Credit Recommendation" DataField="SelectedCriteria" UniqueName="SelectedCriteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Submitted By" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="false" HeaderStyle-Font-Bold="true" HeaderStyle-Width="100px">
                </telerik:GridBoundColumn>
                <telerik:GridDateTimeColumn DataField="CreatedOn" DataType="System.DateTime" FilterControlAltText="Filter CreatedOn column" HeaderText="Created On" SortExpression="CreatedOn" UniqueName="CreatedOn" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true" Display="false">
                    <ItemStyle HorizontalAlign="Center" />
                </telerik:GridDateTimeColumn>
                <telerik:GridDateTimeColumn DataField="LastSubmitted" DataType="System.DateTime" FilterControlAltText="Filter LastSubmitted column" HeaderText="Last Submitted" SortExpression="LastSubmitted" UniqueName="LastSubmitted" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" CurrentFilterFunction="EqualTo" ShowFilterIcon="true">
                    <ItemStyle HorizontalAlign="Center" />
                </telerik:GridDateTimeColumn>
                <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationStage" UniqueName="ArticulationStage" Display="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="CollegeID" UniqueName="CollegeID" Display="false"></telerik:GridBoundColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
</telerik:RadAjaxPanel>
<telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
