<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CourseInformation.ascx.cs" Inherits="ems_app.UserControls.CourseInformation" %>
<asp:SqlDataSource ID="sqlCoursesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="outline_id" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlStudentLearningOutcome" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [StudentLearningOutcome] WHERE ([outline_id] = @outline_id) ORDER BY [id]">
    <SelectParameters>
        <asp:Parameter Name="outline_id" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct p.program_id, concat('<h3>',p.program,'</h3><p>',DBO.Get_Value_IssuedFromProperties(p.IssuedFormID, 'DevelopedSLODescription'),'</p>') program from Program_IssuedForm p where p.program_id in ( select pc.program_id from tblProgramCourses pc left outer join Program_IssuedForm pif on pc.program_id = pif.program_id  where pc.outline_id = @outline_id) and DBO.Get_Value_IssuedFromProperties(p.IssuedFormID, 'DevelopedSLODescription') <> '' and p.status = 0 and college_id = @CollegeID">
    <SelectParameters>
        <asp:Parameter Name="outline_id" Type="Int32" />
        <asp:Parameter Name="CollegeID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlCrossListingCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetCrossListingCourses" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="outline_id" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<div class="courseDetails">
    <div style="display: flex; justify-content: center; align-items: center;">    
    <h2 style="text-align:center; width:100%; font-weight:bold !important;">Course Information</h2>
&nbsp;<i id="tooltipCourseInfo" class="fa-regular fa-circle-info"></i>
<telerik:RadToolTip RenderMode="Lightweight" runat="server" ID="RadToolTip1" Width="300px" ShowEvent="onmouseover"
    RelativeTo="Element" Animation="Resize" TargetControlID="tooltipCourseInfo" IsClientID="true" Skin="Material"
    HideEvent="LeaveTargetAndToolTip" Position="TopRight" Text="The Course Description Column identifies all information from your college associated with this course. College data is accessible to the MAP Ambassador in the Data Module.">
</telerik:RadToolTip>
    </div>
    <hr />
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
            <tr>
                <td>
                    <asp:Label runat="server" ID="Label5" Text='Student Objectives : ' Font-Bold="true" /></td>
            </tr>
            <tr>
                <td>
                    <div><%# Eval("_StudentObjectives") %></div>
                </td>
            </tr>
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
        <MasterTableView Name="ParentGrid" DataKeyNames="program_id" DataSourceID="sqlPrograms" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="false" HeaderStyle-Font-Bold="true" AutoGenerateColumns="false">
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
