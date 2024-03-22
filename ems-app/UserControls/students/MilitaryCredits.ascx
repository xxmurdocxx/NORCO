<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MilitaryCredits.ascx.cs" Inherits="ems_app.UserControls.students.MilitaryCredits" %>
<asp:HiddenField ID="hfCollege" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfVeteranID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfCourse" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfOccupational" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfOccupationalElectives" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfTotal" runat="server" ClientIDMode="Static" />
<asp:Panel ID="pnlMilitaryCredits" runat="server">
    <telerik:RadNotification ID="rnElegibleCredits" runat="server" Position="Center"></telerik:RadNotification>
    <asp:SqlDataSource ID="sqlMilitaryCredits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT DISTINCT  a.id, ae.id AceExhibitID,a.ArticulationType, a.AceID, a.TeamRevd, ae.Title, a.outline_id,  Concat(a.AceID , ' ' , a.Title) AceExhibit, Concat([subject] , '-' , course_number , ' ' , course_title) Course, cast(u.unit as float) as 'Units', STUFF((SELECT ',' + Criteria FROM ArticulationCriteria ac join Articulation art ON ac.ArticulationID = art.ArticulationID and ac.ArticulationType =art.ArticulationType where art.AceID = v.AceID AND art.TeamRevd = v.TeamRevd AND art.outline_id = a.outline_id  FOR XML PATH('') ), 1, 1, '') Criteria   FROM ( SELECT VeteranId, AceID, TeamRevd, StartDate, EndDate, 'Course' as 'Type' FROM VeteranACECourse WHERE veteranid = @VeteranID UNION SELECT VeteranId, AceID, TeamRevd, StartDate, EndDate, 'Occupation' as 'Type' FROM VeteranOccupation  WHERE veteranid = @VeteranID ) v INNER JOIN ACEExhibit as ae on ae.AceID = v.AceID and ae.TeamRevd = v.TeamRevd and ae.StartDate = v.StartDate and ae.EndDate = v.EndDate INNER JOIN Articulation as a on a.aceid = ae.AceID and a.TeamRevd = ae.TeamRevd INNER JOIN Course_IssuedForm as c on c.outline_id = a.outline_id and c.status = 0 and c.college_id = @CollegeID INNER JOIN tblSubjects as s on s.subject_id = c.subject_id INNER JOIN Stages as st on a.ArticulationStage = st.id and st.[Order] = 4  INNER JOIN tblLookupUnits u on c.unit_id = u.unit_id WHERE v.veteranid = @VeteranID and a.Articulate = 1" SelectCommandType="Text">
        <SelectParameters>
            <asp:Parameter Name="VeteranID" Type="Int32" />
            <asp:Parameter Name="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <p class="p-2">Below are the credits for which the student is eligible. Some may already be articulated. For those that need an articulation click "Create Articulation".  Within the table, use the checkboxes to apply credit(s) to this student. View total confirmed credits at the bottom of the screen.</p>
    <telerik:RadGrid ID="rgMilitaryCredits" runat="server" CellSpacing="-1" DataSourceID="sqlMilitaryCredits" Width="100%" AllowAutomaticUpdates="true" PageSize="50" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true"  ShowFooter="true" EnableLinqExpressions="false" AllowFilteringByColumn="false" AllowMultiRowSelection="true" OnItemCommand="rgMilitaryCredits_ItemCommand">
        <GroupingSettings CaseSensitive="false" />
        <ExportSettings IgnorePaging="true" ExportOnlyData="true">
        </ExportSettings>
        <ClientSettings AllowKeyboardNavigation="true">
            <Scrolling AllowScroll="false" UseStaticHeaders="false" />
            <Selecting AllowRowSelect="true" />
        </ClientSettings>
        <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlMilitaryCredits" CommandItemDisplay="Top" PageSize="20" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel" EditFormSettings-EditColumn-Resizable="true">
            <CommandItemTemplate>
                <div class="commandItems">
                    <telerik:RadButton runat="server" ID="btnApply" ButtonType="StandardButton" Text="Apply" CommandName="Apply" ToolTip="Apply selected articulation(s)">
                        <ContentTemplate>
                            <i class='fa fa-check'></i><span> Apply selected articulations</span>
                        </ContentTemplate>
                        <ConfirmSettings ConfirmText="Are you sure you want to Apply the selected articulations?" />
                    </telerik:RadButton>
                </div>
            </CommandItemTemplate>
            <NoRecordsTemplate>
                <p>No records to display</p>
            </NoRecordsTemplate>
            <Columns>
                <telerik:GridClientSelectColumn UniqueName="selectCheckbox" HeaderStyle-Width="30px"></telerik:GridClientSelectColumn>
                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="40px" AllowFiltering="false" EnableHeaderContextMenu="false">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" ToolTip="View Articulation" CommandName="View" ID="btnView" Text='<i class="fa fa-eye" aria-hidden="true"></i> View' CssClass="d-block" />
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="AceExhibitID" UniqueName="AceExhibitID" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="ArticulationType" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="AceExhibit" HeaderText="ACE Exhibit" DataField="AceExhibit" UniqueName="AceExhibit" AllowFiltering="False" HeaderStyle-Width="250px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendations" DataField="Criteria" UniqueName="Criteria" AllowFiltering="False" HeaderStyle-Width="380px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Course" HeaderText="College Course" DataField="Course" UniqueName="Course" AllowFiltering="False" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="" ReadOnly="true">
                </telerik:GridBoundColumn>
                <telerik:GridNumericColumn SortExpression="Units" HeaderText="Units" DataField="Units" UniqueName="Units" AllowFiltering="False" HeaderStyle-Width="80px" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Aggregate="Sum" DecimalDigits="1" FooterAggregateFormatString="Total :{0:### ##0.0}" DataType="System.Double" DataFormatString="{0:### ##0.0}">
                </telerik:GridNumericColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
    <asp:SqlDataSource ID="sqlSelected" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT DISTINCT EC.id, 
        Concat(a.AceID , ' ' , a.Title) AceExhibit, Concat([subject] , '-' , course_number , ' ' , course_title) Course, cast(u.unit as float) Units, STUFF((SELECT ',' + Criteria FROM ArticulationCriteria ac join Articulation art ON ac.ArticulationID = art.ArticulationID and ac.ArticulationType =art.ArticulationType where art.AceID = a.AceID AND art.TeamRevd = a.TeamRevd AND art.outline_id = a.outline_id  FOR XML PATH('') ), 1, 1, '') Criteria   FROM ElegibleCredits EC INNER JOIN Articulation as a on EC.ArticulationID = a.id  INNER JOIN Course_IssuedForm as c on c.outline_id = a.outline_id  INNER JOIN tblSubjects as s on s.subject_id = c.subject_id   INNER JOIN tblLookupUnits u on c.unit_id = u.unit_id WHERE EC.veteranid = @VeteranID" SelectCommandType="Text">
        <SelectParameters>
            <asp:Parameter Name="VeteranID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <br />
    <h2 class="mb-2">Applied Credits</h2>
    <telerik:RadGrid ID="rgSelected" runat="server" CellSpacing="-1" DataSourceID="sqlSelected" Width="100%" AllowAutomaticUpdates="true" PageSize="50" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true"  ShowFooter="true" EnableLinqExpressions="false" AllowFilteringByColumn="false" AllowMultiRowSelection="true" OnItemCommand="rgMilitaryCredits_ItemCommand">
        <GroupingSettings CaseSensitive="false" />
        <ClientSettings>
            <Selecting AllowRowSelect="true" />
        </ClientSettings>
        <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlSelected" CommandItemDisplay="Top" PageSize="20" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel" EditFormSettings-EditColumn-Resizable="true">
            <CommandItemTemplate>
                <div class="commandItems">
                    <telerik:RadButton runat="server" ID="btnDelete" ButtonType="StandardButton" Text="Delete" CommandName="Delete" ToolTip="Delete selected articulation(s)">
                        <ContentTemplate>
                            <i class='fa fa-trash'></i><span> Delete selected articulations</span>
                        </ContentTemplate>
                        <ConfirmSettings ConfirmText="Are you sure you want to Delete the selected articulations?" />
                    </telerik:RadButton>
                </div>
            </CommandItemTemplate>
            <NoRecordsTemplate>
                <p>No records to display</p>
            </NoRecordsTemplate>
            <Columns>
                <telerik:GridClientSelectColumn UniqueName="selectCheckbox" HeaderStyle-Width="30px"></telerik:GridClientSelectColumn>
                <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="AceExhibit" HeaderText="ACE Exhibit" DataField="AceExhibit" UniqueName="AceExhibit" AllowFiltering="False" HeaderStyle-Width="250px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendations" DataField="Criteria" UniqueName="Criteria" AllowFiltering="False" HeaderStyle-Width="380px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Course" HeaderText="College Course" DataField="Course" UniqueName="Course" AllowFiltering="False" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="" ReadOnly="true">
                </telerik:GridBoundColumn>
                <telerik:GridNumericColumn SortExpression="Units" HeaderText="Units" DataField="Units" UniqueName="Units" AllowFiltering="False" HeaderStyle-Width="80px" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Aggregate="Sum" DecimalDigits="1" FooterAggregateFormatString="Total :{0:### ##0.0}" DataType="System.Double" DataFormatString="{0:### ##0.0}">
                </telerik:GridNumericColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
    <br />
</asp:Panel>

