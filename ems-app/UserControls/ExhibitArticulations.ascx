<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitArticulations.ascx.cs" Inherits="ems_app.UserControls.ExhibitArticulations" %>
<asp:SqlDataSource ID="sqlCoursesArticulated" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT '' AceID, null TeamRevd, '' Title, 0 ExhibitID,  '<i class=''fa fa-circle'' aria-hidden=''true'' title=''Not Started'' style=''color:red''></i>' StageIcon, 0 id, c.outline_id as outline_id, AEC.OutlineID as outline_id_cid, aec.CriteriaID CriteriaID, Criteria, U.unit, s.subject, c.course_number, c.course_title, C.CIDNumber, (SELECT TOP 1 [C-ID_Descriptor] from MASTER_CID WHERE [C-ID]= C.CIDNumber AND Institution LIKE '%'+col.College+'%' ORDER BY Approval_date DESC ) CIDDescriptor  FROM [ACEExhibitCriteria] AEC LEFT OUTER JOIN Course_IssuedForm c on aec.OutlineID = C.outline_id LEFT OUTER JOIN tblLookupUnits U ON C.unit_id = U.unit_id LEFT OUTER JOIN tblSubjects S ON C.subject_id = S.subject_id LEFT OUTER JOIN LookupColleges COL ON c.college_id = COL.CollegeID WHERE ExhibitID = @ExhibitID AND CriteriaID NOT IN (SELECT DISTINCT CriteriaID FROM Articulation WHERE ExhibitID = @ExhibitID) UNION SELECT A.AceID, A.TeamRevd, A.Title, A.ExhibitID, CASE WHEN st.[Order] = 4 THEN '<i class=''fa fa-circle'' aria-hidden=''true'' title=''Implemented'' style=''color:green''></i>' ELSE '<i class=''fa fa-circle'' aria-hidden=''true'' title=''In Progress'' style=''color:yellow;''></i>' END StageIcon, a.id, a.outline_id, a.outline_id  outline_id_cid, a.CriteriaID, aec.Criteria, U.unit, S.subject,C.course_number,C.course_title, c.CIDNumber, (SELECT TOP 1 [C-ID_Descriptor] from MASTER_CID WHERE [C-ID]= C.CIDNumber AND Institution LIKE '%'+col.College+'%' ORDER BY Approval_date DESC ) CIDDescriptor FROM Articulation A JOIN Stages ST ON A.ArticulationStage = ST.Id JOIN ACEExhibit AE ON A.ExhibitID = AE.ID JOIN Course_IssuedForm C ON A.outline_id = C.outline_id JOIN tblSubjects S ON C.subject_id = S.subject_id JOIN LookupColleges COL ON A.CollegeID = COL.CollegeID JOIN ACEExhibitCriteria AEC ON A.CriteriaID = AEC.CriteriaID  JOIN tblLookupUnits U ON C.unit_id = U.unit_id  WHERE A.ExhibitID = @ExhibitID and A.CollegeID = @CollegeID">
    <SelectParameters>
        <asp:Parameter Name="ExhibitID" Type="Int32" />
        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" DbType="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<telerik:RadGrid ID="rgCoursesArticulated" runat="server" CellSpacing="-1" DataSourceID="sqlCoursesArticulated" AllowFilteringByColumn="False" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemCommand="rgCoursesArticulated_ItemCommand" OnItemDataBound="rgCoursesArticulated_ItemDataBound">
    <ExportSettings ExportOnlyData="true" FileName="Articulations" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
    </ExportSettings>
    <GroupingSettings CaseSensitive="false" />
    <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
    </ClientSettings>
    <MasterTableView DataSourceID="sqlCoursesArticulated" DataKeyNames="ID" CommandItemDisplay="None" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HierarchyLoadMode="Client">
        <CommandItemSettings ShowExportToExcelButton="false" ShowRefreshButton="false" />
        <ColumnGroups>
            <telerik:GridColumnGroup HeaderText="Credit Recommendation" Name="CreditRecommendation" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="33%">
            </telerik:GridColumnGroup>
            <telerik:GridColumnGroup HeaderText="College Course" Name="CollegeCourse" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="33%">
            </telerik:GridColumnGroup>
            <telerik:GridColumnGroup HeaderText="C-ID" Name="CID" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="33%">
            </telerik:GridColumnGroup>
        </ColumnGroups>
        <Columns>
            <telerik:GridBoundColumn DataField="ID" UniqueName="ID" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="outline_id_cid" UniqueName="outline_id_CID" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="CriteriaID" UniqueName="CriteriaID" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="70px" ReadOnly="true" AllowFiltering="false" EnableHeaderContextMenu="false" ItemStyle-CssClass="row-buttons">
                <ItemTemplate>
                    <asp:LinkButton runat="server" ToolTip="View Articulation" CommandName="View" ID="btnView" Text='View' CssClass="d-block" />
                </ItemTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridBoundColumn SortExpression="StageIcon" HeaderText="" DataField="StageIcon" UniqueName="StageIcon" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" HeaderStyle-Width="30px">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendation" DataField="Criteria" UniqueName="Criteria" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CreditRecommendation" HeaderStyle-Width="25%">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="subject" HeaderText="Subject" HeaderStyle-Width="60px" DataField="subject" UniqueName="subject" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CollegeCourse">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="70px" DataField="course_number" UniqueName="course_number" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CollegeCourse">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CollegeCourse" HeaderStyle-Width="300px">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="unit" HeaderText="Units" DataField="unit" HeaderStyle-Width="40px" UniqueName="unit" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CollegeCourse">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="CIDNumber" HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" HeaderText="CID Number" DataField="CIDNumber" UniqueName="CIDNumber" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CID">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="CIDDescriptor" HeaderText="CID Course" DataField="CIDDescriptor" UniqueName="CIDDescriptor" AllowFiltering="false" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="false" ColumnGroupName="CID">
            </telerik:GridBoundColumn>
        </Columns>
        <NestedViewTemplate>
            <asp:Label ID="lblOutlineID" Font-Bold="true" Font-Italic="true" Text='<%# Eval("outline_id") %>' runat="server" Visible="false" />
            <asp:Label ID="lblOutlineIDCID" Font-Bold="true" Font-Italic="true" Text='<%# Eval("outline_id_CID") %>' runat="server" Visible="false" />
            <asp:Label ID="lblCriteriaID" Font-Bold="true" Font-Italic="true" Text='<%# Eval("CriteriaID") %>' runat="server" Visible="false" />
            <asp:SqlDataSource ID="sqlCoursesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="lblOutlineID" PropertyName="Text" Type="Int32" Name="outline_id" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlCourseCID" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="lblOutlineIDCID" PropertyName="Text" Type="Int32" Name="outline_id" />
                </SelectParameters>
            </asp:SqlDataSource>
            <table>
                <tr>
                    <td style="width: 33%; vertical-align: top; padding-left: 40px; padding-top: 10px;">
                        <asp:SqlDataSource ID="sqlCreditRecommendationsNotes" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT Notes FROM ACEExhibitCriteria WHERE CriteriaID = @CriteriaID">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="lblCriteriaID" PropertyName="Text" Type="Int32" Name="CriteriaID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <h3>Credit Recommendation Notes</h3>
                        <asp:Repeater ID="rptNotes" runat="server" DataSourceID="sqlCreditRecommendationsNotes">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblNotes" Text='<%# Eval("Notes") %>' /></td>
                            </ItemTemplate>
                        </asp:Repeater>
                    </td>
                    <td style="width: 33%; vertical-align: top; padding-left: 20px; padding-top: 10px;">
                        <h3>Course Information</h3>
                        <asp:Repeater ID="rptCourseDetails" runat="server" DataSourceID="sqlCoursesDetails">
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
                                        <asp:Label runat="server" ID="Label12" Text='<%# Eval("_CatalogDescription") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label13" Text='Course Notes : ' Font-Bold="true" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label14" Text='<%# Eval("_CourseNotes") %>' /></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                        <h3 class="mt-3 mb-3">Student Learning Outcomes</h3>
                        <asp:SqlDataSource ID="sqlStudentLearningOutcome" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [StudentLearningOutcome] WHERE ([outline_id] = @outline_id) ORDER BY [id]">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="lblOutlineID" PropertyName="Text" Type="Int32" Name="outline_id" />
                            </SelectParameters>
                        </asp:SqlDataSource>
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
                    </td>
                    <td style="width: 33%; vertical-align: top; padding-left: 20px; padding-top: 10px;">
                        <h3>CID Information</h3>
                        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="sqlCourseCID">
                            <HeaderTemplate>
                                <table>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label2" Text='C-ID Number : ' Font-Bold="true" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div><%# Eval("_CIDNumber") %></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label6" Text='C-ID Title : ' Font-Bold="true" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div><%# Eval("_CIDTitle") %></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label1" Text='C-ID Descriptor : ' Font-Bold="true" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div><%# Eval("_CIDDescriptor") %></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label5" Text='Evaluation Methods : ' Font-Bold="true" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div><%# Eval("_EvalutionMethods") %></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label17" Text='Course Objectives : ' Font-Bold="true" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div><%# Eval("_CourseObejctives") %></div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </td>
                </tr>
            </table>
        </NestedViewTemplate>
    </MasterTableView>
</telerik:RadGrid>
<p style="display: none;" class="alert alert-warning mt-3">Note : The Articulations listed here are for demo purposes only.</p>
