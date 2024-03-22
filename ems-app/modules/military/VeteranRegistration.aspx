<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="VeteranRegistration.aspx.cs" Inherits="ems_app.modules.military.VeteranRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Registration</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
    <!-- Smart Wizard -->
    <p>Please fill out the required information.</p>
    <div id="wizard" class="form_wizard wizard_horizontal">
        <ul class="wizard_steps">
            <li>
                <a href="#step-1">
                    <span class="step_no">1</span>
                    <span class="step_descr">Step 1<br />
                        <small>Step 1 - Personal Information</small>
                    </span>
                </a>
            </li>
            <li>
                <a href="#step-2">
                    <span class="step_no">2</span>
                    <span class="step_descr">Step 2<br />
                        <small>Step 2 - Military Experience</small>
                    </span>
                </a>
            </li>
            <li>
                <a href="#step-3">
                    <span class="step_no">3</span>
                    <span class="step_descr">Step 3<br />
                        <small>Step 3 - Transcripts</small>
                    </span>
                </a>
            </li>
            <li>
                <a href="#step-4">
                    <span class="step_no">4</span>
                    <span class="step_descr">Step 4<br />
                        <small>Step 4 - Additional Information</small>
                    </span>
                </a>
            </li>
        </ul>
        <div id="step-1">
            <h2 class="StepTitle">Personal Information</h2>
            <div class="form-horizontal form-label-left">

                <div class="form-group">
                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">
                        First Name <span class="required">*</span>
                    </label>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <input type="text" id="first-name" required="required" class="form-control col-md-7 col-xs-12">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">
                        Last Name <span class="required">*</span>
                    </label>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <input type="text" id="last-name" name="last-name" required="required" class="form-control col-md-7 col-xs-12">
                    </div>
                </div>
                <div class="form-group">
                    <label for="middle-name" class="control-label col-md-3 col-sm-3 col-xs-12">Middle Name / Initial</label>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <input id="middle-name" class="form-control col-md-7 col-xs-12" type="text" name="middle-name">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-3 col-sm-3 col-xs-12">Gender</label>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <div id="gender" class="btn-group" data-toggle="buttons">
                            <label class="btn btn-default" data-toggle-class="btn-primary" data-toggle-passive-class="btn-default">
                                <input type="radio" name="gender" value="male">
                                &nbsp; Male &nbsp;
                               
                            </label>
                            <label class="btn btn-primary" data-toggle-class="btn-primary" data-toggle-passive-class="btn-default">
                                <input type="radio" name="gender" value="female">
                                Female
                               
                            </label>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-3 col-sm-3 col-xs-12">
                        Date Of Birth <span class="required">*</span>
                    </label>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <input id="birthday" class="date-picker form-control col-md-7 col-xs-12" required="required" type="text">
                    </div>
                </div>

            </div>

        </div>
        <div id="step-2">
            <h2 class="StepTitle">Military experience</h2>
            <div class="form-horizontal form-label-left">
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
        <div id="step-3">
            <h2 class="StepTitle">Transcript Files</h2>
            <div class="form-horizontal form-label-left">
                <div class="form-group">
                    <div class="col-md-12 col-sm-12 col-xs-12">
                    <label>Upload transcript files</label>
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12">
                    <div class="upload-container size-narrow">
                    <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="AsyncUpload1"  MultipleFileSelection="Automatic" Width="500px" />
                    <telerik:RadProgressArea RenderMode="Lightweight" runat="server" ID="RadProgressArea1" />
                    </div>
                    </div>
                </div>

            </div>
        </div>
        <div id="step-4">
            <h2 class="StepTitle">Additional Information</h2>
            <div class="form-horizontal form-label-left">

                <div class="form-group">
                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="add1">
                        Additional field 1 <span class="required">*</span>
                    </label>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <input type="text" id="add1" required="required" class="form-control col-md-7 col-xs-12">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-3 col-sm-3 col-xs-12" for="add2">
                        Additional field 2 <span class="required">*</span>
                    </label>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <input type="text" id="add2" name="last-name" required="required" class="form-control col-md-7 col-xs-12">
                    </div>
                </div>
                <div class="form-group">
                    <label for="add3" class="control-label col-md-3 col-sm-3 col-xs-12">Additional field 3</label>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <input id="add3" class="form-control col-md-7 col-xs-12" type="text" name="middle-name">
                    </div>
                </div>
            </div>
        </div>

    </div>
    <!-- End SmartWizard Content -->
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <!-- jQuery Smart Wizard -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jQuery-Smart-Wizard/js/jquery.smartWizard.js") %>"></script>
</asp:Content>
