<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="CreditTransfer.aspx.cs" Inherits="ems_app.modules.military.CreditTransfer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Credit Transfer Information</p>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:SqlDataSource ID="sqlResults" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select pif.tot_units, pif.program , d.degree from Program_IssuedForm pif left outer join tblLookupDegreeType d on pif.degree_id =  d.degree_id where pif.status = 0 and cast(pif.tot_units as float) > 0 order by pif.program "></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlBranch" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 0 as 'branch_id', 'Select a Branch...' as 'branch' union all
select 1 as 'branch_id', 'Army Enlisted' as 'branch' union all
select 3 as 'branch_id', 'Army Warrant Officer' as 'branch' union all
select 4 as 'branch_id', 'Coast Guard Aviator' as 'branch' union all
select 5 as 'branch_id', 'Coast Guard Enlisted' as 'branch' union all
select 6 as 'branch_id', 'Coast Guard Warrants' as 'branch' union all
select 7 as 'branch_id', 'Marine Corps Enlisted' as 'branch' union all
select 8 as 'branch_id', 'Marine Corps Officer' as 'branch' union all
select 9 as 'branch_id', 'Navy Enlisted' as 'branch' union all
select 10 as 'branch_id', 'Navy Enlisted Certification' as 'branch' union all
select 11 as 'branch_id', 'Navy Limited Duty Officer' as 'branch' union all
select 12 as 'branch_id', 'Navy Warrant Officer' as 'branch' "></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSkills" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 0 as 'skill_id', 'Select a Rank/Silk...' as 'skill' union all
select 1 as 'skill_id', 'W1=Warrant Officer 1' as 'skill' union all
select 3 as 'skill_id', 'W1=Warrant Officer 2' as 'skill' union all
select 4 as 'skill_id', 'W1=Warrant Officer 3' as 'skill' "></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlDateRange" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 0 as 'daterange_id', 'Select a Date...' as 'daterange' union all
select 1 as 'daterange_id', 'Jan 2001 - Current' as 'daterange' union all
select 3 as 'daterange_id', 'Jan 1991 - Dec 2000' as 'daterange' union all
select 4 as 'daterange_id', 'Jul 1987 - Dec 1990' as 'daterange' "></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOccupation" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 0 as 'occupation_id', 'Select an Occupation...' as 'occupation' union all
select 1 as 'occupation_id', 'Aviation Maintenance Technician' as 'occupation' union all
select 2 as 'occupation_id', 'Special Forces Warrant Officer' as 'occupation' union all
select 3 as 'occupation_id', 'Utilities Operation and Maintenance Technician' as 'occupation' union all
select 4 as 'occupation_id', 'Data Processing Technician' as 'occupation' union all
select 5 as 'occupation_id', 'Signal Systems Support Technician' as 'occupation' union all
select 6 as 'occupation_id', 'Signal Systems Operations' as 'occupation' union all
select 7 as 'occupation_id', 'Legal Administrator' as 'occupation' union all
select 8 as 'occupation_id', 'All Source Intelligence Technician' as 'occupation' union all
select 9 as 'occupation_id', 'Imagery Intelligence Technician' as 'occupation' union all
select 10 as 'occupation_id', 'Unmanned Aerial Vehicle Operations Technician' as 'occupation' union all
select 11 as 'occupation_id', 'Attache Technician' as 'occupation' union all
select 12 as 'occupation_id', 'Counterintelligence Technician' as 'occupation' union all
select 13 as 'occupation_id', 'Area Intelligence Technician' as 'occupation' union all
select 14 as 'occupation_id', 'Signals Intelligence Analysis Technician' as 'occupation' union all
select 15 as 'occupation_id', 'Voice Intercept Technician' as 'occupation' union all
select 16 as 'occupation_id', 'Emanations Analysis Technician' as 'occupation' union all
select 17 as 'occupation_id', 'Siginals Collections Technician' as 'occupation' union all
select 18 as 'occupation_id', 'Intelligence and Electronic Warfare Equipment Technician' as 'occupation' union all
select 19 as 'occupation_id', 'Veterinary Services Technician' as 'occupation' union all
select 20 as 'occupation_id', 'Marine Deck Officer' as 'occupation' union all
select 21 as 'occupation_id', 'Marine Engineering Officer' as 'occupation' union all
select 22 as 'occupation_id', 'Ammunition Technician' as 'occupation' union all
select 23 as 'occupation_id', 'Land Combat Missile Systems Technician' as 'occupation'"></asp:SqlDataSource>
    <div class="row">
        <div class="col-md-4 col-xs-12">
            <!-- start accordion -->
            <div class="accordion" id="accordion1" role="tablist" aria-multiselectable="true">
                <div class="panel">
                    <a class="panel-heading" role="tab" id="headingOne1" data-toggle="collapse" data-parent="#accordion1" href="#collapseOne1" aria-expanded="true" aria-controls="collapseOne">
                        <h4 class="panel-title">Military Experience</h4>
                    </a>
                    <div id="collapseOne1" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                        <div class="panel-body">
                            <div class="form-horizontal form-label-left">
                                <div class="form-group">
                                <a href="VeteranRegistration.aspx"><span class="label label-success pull-right">Veteran Registration</span></a>
                                </div>
                                <div class="form-group">
                                    <label>Branch</label>
                                    <telerik:RadComboBox ID="rcbBranch" runat="server" AutoPostBack="false" Width="100%" DataSourceID="sqlBranch" DataTextField="branch" DataValueField="branch_id"></telerik:RadComboBox>
                                </div>
                                <div class="form-group">
                                    <label>Occupation</label>
                                    <telerik:RadComboBox ID="rcbOccupation" runat="server" AutoPostBack="false" Width="100%" DataSourceID="sqlOccupation" DataTextField="occupation" DataValueField="occupation_id"></telerik:RadComboBox>
                                </div>
                                <div class="form-group">
                                    <label>Date range</label>
                                    <telerik:RadComboBox ID="rcbDateRange" runat="server" AutoPostBack="false" Width="100%" DataSourceID="sqlDateRange" DataTextField="daterange" DataValueField="daterange_id"></telerik:RadComboBox>
                                </div>
                                <div class="form-group">
                                    <label>Rank / Skill</label>
                                    <telerik:RadComboBox ID="rcbSkill" runat="server" AutoPostBack="false" Width="100%" DataSourceID="sqlSkills" DataTextField="skill" DataValueField="skill_id"></telerik:RadComboBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel">
                    <a class="panel-heading collapsed" role="tab" id="headingTwo1" data-toggle="collapse" data-parent="#accordion1" href="#collapseTwo1" aria-expanded="false" aria-controls="collapseTwo">
                        <h4 class="panel-title">Contact an Advisor</h4>
                    </a>
                    <div id="collapseTwo1" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                        <div class="panel-body">
                            <div class="advanced-panel">

                                <h3 class="notoporbtm">Military support services</h3>

                                <p class="fourteenpt twelve-ln-ht">Our support staff provides assistance with questions about admissions, transfer, military benefits, support services, courses, programs and degrees.</p>

                                <p class="fourteenpt twelve-ln-ht">Online services are available 24/7 and personal assistance is available by telephone, Web chat and E-mail 7 days a week.</p>

                                <h3 class="notoporbtm">Telephone assistance:</h3>

                                <p class="fourteenpt twelve-ln-ht">
                                    Toll-free number: 1-800-456-8519<br>
                                    International: +1-651-5560596<br>
                                    TTY: (651) 282-2660
                                </p>

                                <h3 class="notoporbtm">Hours of operation:</h3>

                                <p class="fourteenpt twelve-ln-ht">
                                    Monday - Friday: 7 a.m. - 9 p.m. CST<br>
                                    Saturday: 10 a.m. - 4 p.m. CST<br>
                                    Sunday: 9:30 a.m. - 3:30 p.m. CST<br>
                                    Closed holidays
                                </p>

                                <h3 class="notoporbtm">Transfer evaluation requests:</h3>

                                <p class="fourteenpt twelve-ln-ht">
                                    <a href="#" target="_blank" class="bold requestTransfer" title="Request a Transfer Evaluation" aria-label="Request a Transfer Evaluation">Request a transfer evaluation</a> to find out how your military experience transfers into a specific program.
                                </p>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- end of accordion -->
        </div>
        <div class="col-md-8 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Academic programs</h2>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <telerik:RadGrid ID="rgAcademicPrograms" runat="server" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlResults">
                        <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                        <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlResults">
                            <Columns>
                                <telerik:GridBoundColumn DataField="tot_units" FilterControlAltText="Filter tot_units column" HeaderText="Credits" SortExpression="tot_units" UniqueName="tot_units">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="program" FilterControlAltText="Filter program column" HeaderText="Program Title" SortExpression="program" UniqueName="program">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="degree" FilterControlAltText="Filter degree column" HeaderText="Degree / Awward" SortExpression="degree" UniqueName="degree">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
