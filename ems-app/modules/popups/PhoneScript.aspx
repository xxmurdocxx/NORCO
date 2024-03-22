<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PhoneScript.aspx.cs" Inherits="ems_app.modules.popups.PhoneScript" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Phone Script</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
</head>
<body style="background-color: #fff !important;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlLeads" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct vl.id 'LeadID', pif.program, ac.outline_id, sub.subject, cif.course_number, cif.course_title, ac.AceID, ac.TeamRevd, acc.Exhibit, acc.Title, co.OccupationID, CASE WHEN pc.group_desc <> '' THEN CAST(pc.group_units_min AS varchar(4)) + ' - ' + CAST(pc.group_units_max AS varchar(4)) ELSE CAST(pc.vunits AS varchar(4)) END AS vunits, acc.ServiceID from Articulation ac join Course_IssuedForm cif on ac.outline_id = cif.outline_id join tblSubjects sub on cif.subject_id = sub.subject_id join tblProgramCourses pc on ac.outline_id = pc.outline_id join Program_IssuedForm pif on pc.program_id = pif.program_id join AceExhibit acc on ac.AceID = acc.AceID and ac.TeamRevd = acc.TeamRevd left outer join CourseOccupations co on ac.AceID = co.AceID and ac.TeamRevd = co.TeamRevd join VeteranOccupation vo on co.OccupationID = vo.OccupationCode join Veteran v on vo.VeteranId = v.id join VeteranLead vl on v.id = vl.VeteranID where vl.ID = @LeadId">
            <SelectParameters>
                <asp:QueryStringParameter Name="LeadID" QueryStringField="LeadId" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlInfo" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select v.id 'VeteranID', v.FirstName + ' ' + v.LastName 'VeteranName', cif.course_title, CASE WHEN pc.group_desc <> '' THEN CAST(pc.group_units_min AS varchar(4)) + ' - ' + CAST(pc.group_units_max AS varchar(4)) ELSE CAST(pc.vunits AS varchar(4)) END AS vunits, s.Description 'Service', c.College  from Articulation ac join Course_IssuedForm cif on ac.outline_id = cif.outline_id join tblSubjects sub on cif.subject_id = sub.subject_id join tblProgramCourses pc on ac.outline_id = pc.outline_id join AceExhibit acc on ac.AceID = acc.AceID and ac.TeamRevd = acc.TeamRevd left outer join CourseOccupations co on ac.AceID = co.AceID and ac.TeamRevd = co.TeamRevd join VeteranOccupation vo on co.OccupationID = vo.OccupationCode join Veteran v on vo.VeteranId = v.id left outer join VeteranLead vl on v.id = vl.VeteranID left outer join LookupService s on v.ServiceID = s.id join LookupColleges c on vo.CollegeId = c.CollegeID where cif.college_id = @CollegeID and vo.CollegeId =  @CollegeID and pc.outline_id = @outline_id and pc.program_id = @program_id and vl.ID = @LeadID">
            <SelectParameters>
                <asp:QueryStringParameter Name="LeadID" QueryStringField="LeadId" Type="Int32" />
                <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
                <asp:QueryStringParameter Name="program_id" QueryStringField="program_id" Type="Int32" />
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <div style="padding: 15px !important;">
                <div class="row">
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="sqlInfo">
                            <ItemTemplate>
                                <h2>Norco College</h2>
                                <h3>Veterans Resource Center: Sample Phone Script</h3>
                                <p>Residents on the call list are all veterans not currently enrolled at <%# Eval("College") %> and are eligible to use their VA educational benefits. They will receive early and priority registration. They potentially may get college credit for their military training.</p>
                                <h3>CONVERSATION SCRIPT</h3>
                                <p>Good evening, my name is __________ and I’m calling you from <%# Eval("College") %>. I am calling you because we noticed you are a veteran of the <%# Eval("Service") %> and eligible to attend college for free using your VA educational benefits. </p>
                                <p>Through our unique partnership with CalVet, <%# Eval("College") %> has had the opportunity to review your joint services transcript and it is a pleasure to inform you we can provide you units of free, completed college credit in the following course(s) for your previously completed military education and training.  
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Repeater ID="rptProgramCourses" runat="server" DataSourceID="sqlLeads">
                            <HeaderTemplate>
                                <table class="tableProgramCourses">
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label9" Text='Program of Study' Font-Bold="true" /></td>
                                        <td>
                                            <asp:Label runat="server" ID="Label15" Text='Subject' Font-Bold="true" /></td>
                                        <td>
                                            <asp:Label runat="server" ID="Label16" Text='Course' Font-Bold="true" /></td>
                                        <td>
                                            <asp:Label runat="server" ID="Label17" Text='Course Title' Font-Bold="true" /></td>
                                        <td>
                                            <asp:Label runat="server" ID="Label18" Text='Units' Font-Bold="true" /></td>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label1" Text='<%# Eval("program") %>' /></td>
                                    <td>
                                        <asp:Label runat="server" ID="Label10" Text='<%# Eval("subject") %>' /></td>
                                    <td>
                                        <asp:Label runat="server" ID="Label2" Text='<%# Eval("course_number") %>' /></td>
                                    <td>
                                        <asp:Label runat="server" ID="Label3" Text='<%# Eval("course_title") %>' /></td>
                                    <td style="text-align: right;">
                                        <asp:Label runat="server" ID="lblUnits" Text='<%# Eval("vunits") %>' /></td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                            </FooterTemplate>
                        </asp:Repeater>
                        <table class="tableProgramCourses">
                            <tr>
                                <td style="text-align: right;">
                                    <asp:Label runat="server" ID="lblTotalValue" Text='' Font-Bold="true" /></td>
                            </tr>
                        </table>
                        <asp:Repeater ID="Repeater2" runat="server" DataSourceID="sqlInfo">
                            <ItemTemplate>
                                 <p>These units count towards a certificate and/or 2-year Associate’s Degree. You are well on your way towards completing your college degree already!</p>
                                <p>As a veteran student at <%# Eval("College") %>, you will receive priority registration and we have a Veterans Resource Center with certified counselors to help you step by step through the process. The fall term begins on Monday, August 27th and we offer classes during the day, in the evenings, online, and on Saturday mornings.  Would you like to come in and meet with our Veteran Services Staff to explain all your benefits and help you register for classes?</p>
                                <h3>[If YES]</h3>
                                <p>Great!  Our Veterans Resource Center staff are available to help you Monday through Friday from ___________(time). I can help make an appointment for you.  When is a good time for you to come in? </p>
                                <h3>[If NO]</h3>
                                <p>completely understand if attending college isn’t possible with your schedule at this time.  Let me ask you, are you working this fall either fulltime or part time?  Norco College also offers a Work Experience class [WKX-200] and veterans can earn either 1, 2, 3 or 4 units that are also transferable to Cal State. The class is online and you can still make progress towards your degree even if you can’t take any other classes this fall.</p> 
                                <p>The Veterans Resource Center is always available to answer any questions and can help you step by step to make referals and to help guide you in using your earned benefits when you’re ready.</p>
                                <p>Thank you for your time – we look forward to seeing you in the Veterans Resource Center and around <%# Eval("College") %> soon!</p>
                                <br /><br />
                                <h2>VOICEMAIL SCRIPT</h2>
                                <p>This message is for <%# Eval("VeteranName") %>. My name is ______ calling from <%# Eval("College") %> to inform you that as a veteran of the <%# Eval("Service") %> you are eligible to attend college for free using your VA educational benefits. Through our unique partnership with CalVet, <%# Eval("College") %> has had the opportunity to review your joint services transcript and it is a pleasure to inform you we can provide you <%# Eval("vunits") %> units of free, completed college credit in <%# Eval("course_title") %> for your previously completed military education and training.  These units count towards a certificate and/or 2-year Associate’s Degree. You are well on your way towards completing your college degree already!</p>
                                <p>Veteran students also receive priority registration as an added benefit, and our Veterans Resource Center can help you every step of the way. The Fall 2018 Semester begins on August 27th and classes are still available so we hope you’ll take advantage of this opportunity. If you have any questions about your VA educational benefits, please call 951-372-7142 or feel free to come in and visit our Veterans Resource Center on the first floor of the Student Success building here at <%# Eval("College") %>.</p>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
</body>
</html>



