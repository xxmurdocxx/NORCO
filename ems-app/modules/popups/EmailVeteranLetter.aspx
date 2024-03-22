<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmailVeteranLetter.aspx.cs" Inherits="ems_app.modules.popups.EmailVeteranLetter" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Veteran Letter</title>
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
        <asp:SqlDataSource ID="sqlTemplates" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT
	[Templates].[TemplateText] FROM [Templates] WHERE [Templates].[ID] = @Template_ID">
            <SelectParameters>
                <asp:Parameter DefaultValue="1" Name="Template_ID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlLeadInfo" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select v.FirstName, clg.College from VeteranLead vl join Veteran v on vl.VeteranID = v.id join Campaign c on vl.CampaignID = c.ID join LookupColleges clg on c.CollegeID = clg.CollegeID where vl.id = @LeadId">
            <SelectParameters>
                <asp:QueryStringParameter Name="LeadID" QueryStringField="LeadId" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select o.Occupation, o.Title  from VeteranLead vl join VeteranOccupation vo on vl.VeteranID = vo.VeteranId join (  select ao.Occupation, ao.Occupation + ' - ' + ao.Title as Title from AceExhibit ao inner join ( SELECT Occupation, max(AceID) as AceID FROM AceExhibit aoc group by Occupation ) a02 on ao.AceID = a02.AceID ) o on vo.OccupationCode = o.Occupation where vl.id = @LeadId">
            <SelectParameters>
                <asp:QueryStringParameter Name="LeadID" QueryStringField="LeadId" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlLeads" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct vl.id 'LeadID', pif.program, ac.outline_id,sub.subject, cif.course_number, cif.course_title, ac.AceID, ac.TeamRevd, acc.Exhibit, acc.Title, co.OccupationID, CASE WHEN pc.group_desc <> '' THEN CAST(pc.group_units_min AS varchar(4)) + ' - ' + CAST(pc.group_units_max AS varchar(4)) ELSE CAST(pc.vunits AS varchar(4)) END AS vunits, acc.ServiceID from Articulation ac join Course_IssuedForm cif on ac.outline_id = cif.outline_id join tblSubjects sub on cif.subject_id = sub.subject_id join tblProgramCourses pc on ac.outline_id = pc.outline_id join Program_IssuedForm pif on pc.program_id = pif.program_id join AceExhibit acc on ac.AceID = acc.AceID and ac.TeamRevd = acc.TeamRevd left outer join CourseOccupations co on ac.AceID = co.AceID and ac.TeamRevd = co.TeamRevd join VeteranOccupation vo on co.OccupationID = vo.OccupationCode join Veteran v on vo.VeteranId = v.id join VeteranLead vl on v.id = vl.VeteranID and ac.ArticulationType = 1 where vl.ID = @LeadId">
            <SelectParameters>
                <asp:QueryStringParameter Name="LeadID" QueryStringField="LeadId" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="280px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div style="padding: 15px !important;">
                <div class="row">
                    <div class="col-md-12 col-sm-12 col-xs-12 text-right no-print">
                        <telerik:RadButton RenderMode="Lightweight" ID="rbEmail" runat="server" Text="Send Veteran Letter" OnClick="rbEmail_Click">
                            <Icon PrimaryIconCssClass="rbMail"></Icon>
                        </telerik:RadButton>
                        <a href="#" onclick="window.print();" class="RadButton RadButton_Office2010Silver rbButton rbRounded"><i class="fa fa-print" aria-hidden="true"></i> Print</a>
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12 text-right logo-image-print">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Common/images/norco.gif"  />
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12" id="mailContent" runat="server">
                        <asp:Repeater ID="Repeater2" runat="server" DataSourceID="sqlLeadInfo">
                            <ItemTemplate>
                                <p>Dear <%# Eval("FirstName") %>,</p>
                            </ItemTemplate>
                        </asp:Repeater>
                        <br />
                        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="sqlTemplates">
                            <ItemTemplate>
                                <p><%# Eval("TemplateText") %></p>
                            </ItemTemplate>
                        </asp:Repeater>
                        <br />
                        <asp:Repeater ID="Repeater3" runat="server" DataSourceID="sqlLeadInfo">
                            <ItemTemplate>
                                <p>Congratulations!  This communication is to inform you of your earned educational benefit through our unique partnership with CalVet. <%# Eval("College") %> has had the opportunity to review your joint services transcript and it is a pleasure to inform you we can provide you units of free, completed college credit in the following course(s) for your previously completed military education and training. </p>
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
                        <br />
                        <asp:Repeater ID="Repeater5" runat="server" DataSourceID="sqlLeadInfo">
                            <ItemTemplate>
                                <p>These units count towards a certificate and/or 2-year Associate’s Degree. You are well on your way towards completing your college degree already!</p>
                                <p><%# Eval("College") %> believes in supporting our Veterans and understands the education you have received in military is superior.  Now is the perfect time to utilize your GI Bill and continue your formal education at <%# Eval("College") %> (Norco, CA).  <%# Eval("College") %> is a premiere institution offering degrees, certificates and transfer programs and we are right around the corner. We take pride in serving a diverse student population by offering a wide range of services, courses, and programs. We value your service to our country and want to help you maximize the education/training you have already completed. </p>
                                <p>Our Veterans Resource Center is a three-time winner of “Best for Vets” by Military Times. The <%# Eval("College") %> staff is trained to understand your unique needs and how to maximize your GI Bill, housing allowance, etc. The college will be opening a brand new Veterans Resource Center in 2019 and has also received funding to build a child care education center dedicated to serving veterans and their families. </p>
                                <p>To get started, our certified counselors are available to personally assist you through the application process and in fully understanding your educational benefit.</p>
                                <p>Your personalized Veterans Specialist is:</p>
                                <p>
                                    Zachary Emorey<br />
                                    Norco College<br />
                                    USMC Veteran<br />
                                    Office: (951) 739-7840<br />
                                    zachary.emorey@norcocollege.edu
                                </p>

                                <p>Zach will be reaching out to you by phone as well.</p>
                                <p>
                                    We are deeply appreciative of your service to our country and we look forward to having you join our dynamic student community. <%# Eval("College") %> offers endless opportunities in an unparalleled setting for the next chapter of your life.
                                </p>
                                <p>
                                    You’ve had our back, and now we have yours.
                                </p>
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
    <script>
        function OnClientClicked() {
            window.print();
        }
    </script>
</body>
</html>


