<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="QualifiedVetsButtons.ascx.cs" Inherits="ems_app.UserControls.QualifiedVetsButtons" %>
<asp:HiddenField ID="hfCollegeID" runat="server" />
<asp:SqlDataSource ID="sqlQualifiedVets" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommand="select  concat(count(*),' Qualified Vets for Credit') as 'Title', concat('ShowArticulations(''../popups/ShowArticulations.aspx?Type=3&Title=Qualified Vets for Credit&CollegeID=',@CollegeID,''',1100,600);') as 'link' from ( select distinct va.VeteranId  from (SELECT VeteranId, AceID, TeamRevd FROM VeteranACECourse  union SELECT vo.VeteranId, o.AceID, o.TeamRevd FROM VeteranOccupation vo JOIN AceExhibit o ON vo.OccupationCode = o.Occupation union SELECT v.id as 'VeteranId', o.AceID, o.TeamRevd FROM Veteran v JOIN AceExhibit o ON v.Occupation = o.Occupation ) VA JOIN Articulation a ON va.AceID = a.AceID and va.TeamRevd = a.TeamRevd WHERE a.ArticulationStage = [DBO].GetMaximumStageId(a.CollegeID)  AND a.CollegeID = @CollegeID  ) a">
    <SelectParameters>
        <asp:ControlParameter Name="CollegeID" ControlID="hfCollegeID" PropertyName="Value" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:Repeater ID="Repeater3" runat="server"
    DataSourceID="sqlQualifiedVets">
    <ItemTemplate>
        <asp:LinkButton runat="server" OnClientClick='<%# Eval("link") %>' ToolTip="" ID="LinkBUtton3" Text='<%# Eval("Title") %>' CssClass="btn btn-light" Width="250px" Visible="true"></asp:LinkButton>
    </ItemTemplate>
</asp:Repeater>
