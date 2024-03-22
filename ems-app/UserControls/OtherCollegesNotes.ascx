<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OtherCollegesNotes.ascx.cs" Inherits="ems_app.UserControls.OtherCollegesNotes" %>
<asp:HiddenField ID="hfSubject" runat="server" />
<asp:HiddenField ID="hfCourseNumber" runat="server" />
<asp:HiddenField ID="hfExhibitID" runat="server" />
<asp:HiddenField ID="hfCriteriaID" runat="server" />
<asp:HiddenField ID="hfCollegeID" runat="server" />
<asp:SqlDataSource ID="sqlNotes" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM ( SELECT DISTINCT CONCAT (CASE WHEN A.Notes IS NULL OR A.Notes = '' THEN '' ELSE CONCAT('<b>Evaluator Notes : </b>',A.Notes,'<BR/>') END , CASE WHEN A.Justification IS NULL OR A.Justification = '' THEN '' ELSE CONCAT('<b>Faculty Notes : </b>',A.Justification,'<BR/>') END ,CASE WHEN A.ArticulationOfficerNotes IS NULL OR A.ArticulationOfficerNotes = '' THEN '' ELSE CONCAT('<b>Articulation Officer Notes : </b>',A.ArticulationOfficerNotes,'<BR/>') END ) AS Notes, col.College FROM Articulation a JOIN Course_IssuedForm c ON a.outline_id = c.outline_id JOIN tblSubjects s ON c.subject_id = s.subject_id JOIN LookupColleges col ON A.CollegeID = col.CollegeID WHERE s.subject = @Subject AND c.course_number = @CourseNumber AND A.ExhibitID = @ExhibitID AND A.CriteriaID = @CriteriaID AND A.CollegeID <> @CollegeID and A.ArticulationStatus = 1) A WHERE Notes <> '' " >
    <SelectParameters>
        <asp:ControlParameter Name="Subject" ControlID="hfSubject" PropertyName="Value" Type="String" />
        <asp:ControlParameter Name="CourseNumber" ControlID="hfCourseNumber" PropertyName="Value" Type="String" />
        <asp:ControlParameter Name="ExhibitID" ControlID="hfExhibitID" PropertyName="Value" Type="Int32" />
        <asp:ControlParameter Name="CriteriaID" ControlID="hfCriteriaID" PropertyName="Value" Type="Int32" />
        <asp:ControlParameter Name="CollegeID" ControlID="hfCollegeID" PropertyName="Value" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<telerik:RadGrid ID="rgNotes" DataSourceID="sqlNotes" AllowPaging="True" Width="100%" runat="server" AutoGenerateColumns="False" AllowSorting="True" PageSize="10"  EditItemStyle-BackColor="#ffff66">
    <ClientSettings AllowDragToGroup="false">
        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
    </ClientSettings>
    <MasterTableView AutoGenerateColumns="false" CommandItemDisplay="None">
        <Columns>
            <telerik:GridBoundColumn SortExpression="Notes" HeaderText="Notes" DataField="Notes" UniqueName="Notes" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="280px" HeaderStyle-HorizontalAlign="Center">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="College" HeaderText="College" DataField="College" UniqueName="College" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center">
            </telerik:GridBoundColumn>
        </Columns>
        <EditFormSettings ColumnNumber="2" FormMainTableStyle-CellPadding="5" FormTableStyle-CellPadding="5" EditColumn-ButtonType="ImageButton"></EditFormSettings>
    </MasterTableView>
</telerik:RadGrid>