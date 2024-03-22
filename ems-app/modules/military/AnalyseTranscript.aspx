<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="AnalyseTranscript.aspx.cs" Inherits="ems_app.modules.military.AnalyseTranscript" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Analyze Transcript document</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlResults" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select pif.tot_units, pif.program , d.degree from Program_IssuedForm pif left outer join tblLookupDegreeType d on pif.degree_id =  d.degree_id where pif.status = 0 and cast(pif.tot_units as float) > 0 order by pif.program "></asp:SqlDataSource>
    <div class="row">
        <div class="col-md-6 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Transcript document</h2>
                    <ul class="nav navbar-right panel_toolbox">
                        <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                        </li>
                    </ul>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <a class="btn btn-app">
                        <i class="fa fa-cogs"></i>Process Image
                    </a>
                    <a class="btn btn-app">
                        <i class="fa fa-play"></i>Save OCR Results
                    </a>
                    <!-- start accordion -->
                    <div class="accordion" id="accordion1" role="tablist" aria-multiselectable="true">
                        <div class="panel">
                            <a class="panel-heading" role="tab" id="headingOne1" data-toggle="collapse" data-parent="#accordion1" href="#collapseOne1" aria-expanded="true" aria-controls="collapseOne">
                                <h4 class="panel-title">Uploaded Image</h4>
                            </a>
                            <div id="collapseOne1" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                <div class="panel-body">
                                    <img class="img-responsive" src="../../Common/images/OCR-Image.png" alt="OCR" title="OCR Image">
                                </div>
                            </div>
                        </div>
                        <div class="panel">
                            <a class="panel-heading collapsed" role="tab" id="headingTwo1" data-toggle="collapse" data-parent="#accordion1" href="#collapseTwo1" aria-expanded="false" aria-controls="collapseTwo">
                                <h4 class="panel-title">OCR Results</h4>
                            </a>
                            <div id="collapseTwo1" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                <div class="panel-body">
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reResults" ContentFilters="None" StripFormattingOptions="NoneSupressCleanMessage" Width="100%" >
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="MainToolbar">
                                                <telerik:EditorTool Name="FindAndReplace"></telerik:EditorTool>
                                                <telerik:EditorSeparator></telerik:EditorSeparator>
                                                <telerik:EditorTool Name="Cut"></telerik:EditorTool>
                                                <telerik:EditorTool Name="Copy"></telerik:EditorTool>
                                                <telerik:EditorTool Name="Paste" ShortCut="CTRL+V"></telerik:EditorTool>
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                            Revising Courses/Awards
                                            The Elclarifies the data analysis needed. The El does not require any input on your
                                            part. For the other forms, you will need to click on the text (i.e., E2, etc) and
                                            complete the analysis. An E2 form, for example, requires you check the skills
                                            necessary for success in the class (see below).
                                            The E2 is a content analysis; most requisites involving a course require this be done. If
                                            your requisite is a course, when you click on the E2, the objectives from the requisite
                                            course will be displayed. Click on any that apply to the course (that äöTEÄüired
                                            Skitts-sttJdéhT5Sfiöü1ffhüÖFefore entering the course for a prerequisite or
                                            recommended preparation or should have while taking the course for a
                                            corerequisite). It will look something like this:
                                            431,836,108,327
                                            Courses
                                            Edit Course
                                            Cwrse
                                            ENG 241
                                            Indian
                                            .ctioa
                                            IESI-IESI SVEÖECI
                                            Stewart ,
                                            nks
                                            ASSIST page
                                            Blooms Taxonomy
                                            CurridJNET
                                            CurndJNET Training
                                            Gcwemet
                                            MSJC Best practces
                                            Website
                                            MSE OLOs and SLOS
                                            S'"al Charaders
                                            TOF codes
                                            users Guide
                                            573,830,321,781
                                            Form Sk'lls Analysis
                                            Page Last Smed on Tuesday, -hm 21, 2011 at 9-37 AM
                                            By NEchene Stewart
                                            ReWsite Prerequisite
                                            ENGL
                                            Sekct fie "Learning ObÉctivese trun me re-wisite coarse that are
                                            necessary entry Skdls Needed for success in the target culrse.
                                            research-baæd essay(S) (at one
                                            at least 2, 000 tned pages}
                                            at least (not
                                            including encycl*dia dictionary
                                            texts, hy•pctr.esize effective
                                            a:gurnt: in reaction to the texts, and synthesize nev
                                            knowledge in order
                                            college-level
                                            t:emnstzate arguentative/persuasive •ad
                                            'trateglea logical fallacies
                                            Forniate library research strategies
                                            @Examine and appropriate and
                                            techniques reaeat:h
                                            U Ecu—at :aurces using another universally
                                            eccegted style of
                                            and integrate them a
                                            paper
                                            in a range (in—class
                                            and outgi± While relying aa the procezg
                                            (laveatlca, drafting, revision, and editing
                                            Zeemn:trate an ability to revue and edit
                                            (at least totalzag
                                            40 tFed page:) shi:h deænytrate mastery
                                            conventions o! standard academic
                                            English and be able to edit/revise pape:a
                                            such 2 denagtraticn
                                            c
                                            Work 2 carunity Of
                                            and revonding to one
                                            and oatticipatlna in arauc and discussiza to
                                            103
                                        </Content>
                                    </telerik:RadEditor>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- end of accordion -->
                </div>
            </div>

        </div>
        <div class="col-md-6 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Related academic programs</h2>
                    <ul class="nav navbar-right panel_toolbox">
                        <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                        </li>
                    </ul>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <telerik:RadGrid ID="rgAcademicPrograms" runat="server" AllowPaging="True" AllowSorting="True" Culture="es-ES" DataSourceID="sqlResults" AllowFilteringByColumn="true" GroupingSettings-CaseSensitive="false">
                        <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                        <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlResults">
                            <Columns>
                                <telerik:GridBoundColumn DataField="tot_units" FilterControlAltText="Filter tot_units column" HeaderText="Credits" SortExpression="tot_units" UniqueName="tot_units" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" FilterControlWidth="30px">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="program" FilterControlAltText="Filter program column" HeaderText="Program Title" SortExpression="program" UniqueName="program" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="degree" FilterControlAltText="Filter degree column" HeaderText="Degree / Awward" SortExpression="degree" UniqueName="degree" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
            </div>
            <div class="x_panel">
                <div class="x_title">
                    <h2>Selected Academic Programs</h2>
                    <ul class="nav navbar-right panel_toolbox">
                        <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                        </li>
                    </ul>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Credits</th>
                                <th>Program Title</th>
                                <th>Degree Awward</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th scope="row">1</th>
                                <td>19</td>
                                <td>Art History</td>
                                <td>AA-T Degree</td>
                            </tr>
                            <tr>
                                <th scope="row">2</th>
                                <td>42</td>
                                <td>Artitectural Drafting & Design</td>
                                <td>AS Degree</td>
                            </tr>
                            <tr>
                                <th scope="row">3</th>
                                <td>24</td>
                                <td>Aviation Administration</td>
                                <td>Certificate of Achievement</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
