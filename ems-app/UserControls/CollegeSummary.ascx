<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CollegeSummary.ascx.cs" Inherits="ems_app.UserControls.CollegeSummary" %>
<asp:SqlDataSource ID="sqlDistrictColleges" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="select * from LookupColleges where DistrictID IN (select DistrictID from LookupColleges where CollegeID = @CollegeID)">
    <SelectParameters>
        <asp:Parameter Name="CollegeID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<div class="row" style="display:grid; grid-template-columns:repeat(4, 1fr); gap:4px;">
        <div class="tile-stats yellow-stats">
            <div class="icon white-icon">
                <i class="fa <%# Eval("iconClass") %>"></i>
            </div>
            <br />
            <label>&nbsp;Summary for : </label>
            <telerik:RadComboBox ID="rcbColleges" DataSourceID="sqlDistrictColleges" DataTextField="College" DataValueField="CollegeID" Height="200px" Width="150px" DropDownAutoWidth="Enabled" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rcbColleges_SelectedIndexChanged">
            </telerik:RadComboBox>
        </div>
    <!-- Qualified Vets Data -->
    <asp:SqlDataSource ID="sqlQualifiedVets" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="select 'Qualified Vets for Credit' as Title, count(*) as 'CountValue', 'fa-graduation-cap' as iconClass, @CollegeID as CollegeID from ( select distinct va.VeteranId  from (SELECT VeteranId, AceID, TeamRevd FROM VeteranACECourse  union SELECT vo.VeteranId, o.AceID, o.TeamRevd FROM VeteranOccupation vo JOIN AceExhibit o ON vo.OccupationCode = o.Occupation union SELECT v.id as 'VeteranId', o.AceID, o.TeamRevd FROM Veteran v JOIN AceExhibit o ON v.Occupation = o.Occupation ) VA JOIN Articulation a ON va.AceID = a.AceID and va.TeamRevd = a.TeamRevd WHERE a.ArticulationStage = [DBO].GetMaximumStageId(a.CollegeID)  AND a.CollegeID = @CollegeID  ) a">
        <SelectParameters>
            <asp:ControlParameter ControlID="rcbColleges" PropertyName="selectedValue" Name="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:Repeater ID="Repeater3" runat="server"
        DataSourceID="sqlQualifiedVets">
        <ItemTemplate>

                    <div class="tile-stats yellow-stats">
                                    <a href="#" onclick="ShowArticulations('../popups/ShowArticulations.aspx?Type=3&Title=Qualified Vets for Credit&CollegeID=<%# Eval("CollegeID") %>',1100,600);">
                        <div class="icon white-icon">
                            <i class="fa <%# Eval("iconClass") %>"></i>
                        </div>
                        <span class="count  white-icon big-numbers"><%# Eval("countValue") %></span>
                        <span class="text-info-stat"><%# Eval("Title") %></span>
                                                    </a>
                    </div>
        </ItemTemplate>
    </asp:Repeater>
    <!-- Published Articulations Data -->
    <asp:SqlDataSource ID="sqlPublishedArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="select 'Implemented ' + c.CollegeAbbreviation + ' Articulation(s)' as 'Title' ,count(*) CountValue, 'fa-calendar-check-o' IconClass, @CollegeID as CollegeID from  Articulation a join Course_IssuedForm cif on a.outline_id = cif.outline_id join LookupColleges c on cif.college_id = c.CollegeID where a.ArticulationStage = [DBO].GetMaximumStageId(a.CollegeID)  and cif.college_id = @CollegeID and a.ArticulationStatus = 1  and a.Articulate = 1 group by c.CollegeAbbreviation">
        <SelectParameters>
            <asp:ControlParameter ControlID="rcbColleges" PropertyName="selectedValue" Name="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:Repeater ID="Repeater7" runat="server"
        DataSourceID="sqlPublishedArticulations">
        <ItemTemplate>
            <%--<a href="#" onclick="ShowArticulations('../popups/ShowArticulations.aspx?Type=5&Title=Proposed Published  Articulation(s)&CollegeID=<%# Eval("CollegeID") %>',1100,600);">--%>
                    <div class="tile-stats yellow-stats">
                        <div class="icon white-icon">
                            <i class="fa <%# Eval("iconClass") %>"></i>
                        </div>
                        <span class="count  white-icon big-numbers"><%# Eval("countValue") %></span>

                        <span class="text-info-stat"><%# Eval("Title") %></span>
                    </div>
            <%--</a>--%>
        </ItemTemplate>
    </asp:Repeater>
    <!--Published Courses Data -->
    <asp:SqlDataSource ID="sqlPublishedCourses" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="select 'Implemented ' + c.CollegeAbbreviation + ' Course(s)' as 'Title' ,count(*) CountValue, 'fa-calendar-check-o' IconClass, @CollegeID as CollegeID from (select distinct outline_id, ArticulationStage, ArticulationStatus, CollegeID from Articulation) a join Course_IssuedForm cif on a.outline_id = cif.outline_id join LookupColleges c on cif.college_id = c.CollegeID where a.ArticulationStage =  [DBO].GetMaximumStageId(a.CollegeID) and cif.college_id = @CollegeID and a.ArticulationStatus = 1 and a.articulate = 1 group by c.CollegeAbbreviation">
        <SelectParameters>
            <asp:ControlParameter ControlID="rcbColleges" PropertyName="selectedValue" Name="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:Repeater ID="Repeater2" runat="server"
        DataSourceID="sqlPublishedCourses">
        <ItemTemplate>
            <%--<a href="#" onclick="ShowArticulations('../popups/ShowArticulations.aspx?Type=2&Order=4&Title=Proposed Published  Course(s)&CollegeID=<%# Eval("CollegeID") %>',1100,600);">--%>
                    <div class="tile-stats yellow-stats">
                        <div class="icon white-icon">
                            <i class="fa <%# Eval("iconClass") %>"></i>
                        </div>
                        <span class="count  white-icon  big-numbers"><%# Eval("countValue") %></span>

                        <span class="text-info-stat"><%# Eval("Title") %></span>
                    </div>
            <%--</a>--%>
        </ItemTemplate>
    </asp:Repeater>
</div>  
<!--College Summary Cards Data -->
<div class="row" style="display:grid; grid-template-columns:repeat(4, 1fr);" id="divCollegeSummary" runat="server">
</div>
