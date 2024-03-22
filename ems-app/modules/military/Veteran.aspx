<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Veteran.aspx.cs" Inherits="ems_app.modules.military.Veteran" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <!-- NProgress -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/nprogress/nprogress.css") %>" rel="stylesheet">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Veteran Profile</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="x_panel">
            <div class="x_title">
                <h2>Samuel Doe</h2>
                <ul class="nav navbar-right panel_toolbox">
                    <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                    </li>
                </ul>
                <div class="clearfix"></div>
            </div>
            <div class="x_content">
                <div class="col-md-3 col-sm-3 col-xs-12 text-center">

                    <div class="profile_img">
                        <div id="crop-avatar">
                            <!-- Current avatar -->
                            <img class="avatar-view img-circle" src="../../Common/images/img.jpg" alt="Avatar" title="Change the avatar">
                        </div>
                        <br />
                    </div>
                </div>
                <div class="col-md-3 col-sm-3 col-xs-12">
                    <h3>Contact Information</h3>
                    <ul class="list-unstyled user_data">
                        <li><i class="fa fa-map-marker user-profile-icon"></i> San Francisco, California, USA
                        </li>
                        <li>
                            <i class="fa fa-briefcase user-profile-icon"></i> Software Engineer
                        </li>
                        <li class="m-top-xs">
                            <i class="fa fa-external-link user-profile-icon"></i>
                            <a href="http://www.kimlabs.com/profile/" target="_blank"> www.kimlabs.com</a>
                        </li>
                        <li class="m-top-xs">
                            <i class="fa fa-envelope user-profile-icon"></i>
                            <a href="mailto:samueldoe@gmail.com" target="_blank"> samueldoe@gmail.com</a>
                        </li>
                        <li>
                            <i class="fa fa-phone user-profile-icon"></i> 305-666234
                        </li>
                    </ul>
                    <a class="btn btn-success"><i class="fa fa-edit m-right-xs"></i>Edit full details</a>
                </div>
                <div class="col-md-3 col-sm-3 col-xs-12">
                    <h3>Military Experience</h3>
                    <div class="project_detail">
                        <p class="title">Branch</p>
                        <p>Army Warrant Officer</p>
                        <p class="title">Occupation</p>
                        <p>Data Processing Technician</p>
                        <p class="title">Date range</p>
                        <p>Jan 2001 - Current</p>
                        <p class="title">Rank / Skill</p>
                        <p>W1=Warrant Officer 1</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-3 col-xs-12">
                    <h3>Lead Information</h3>
                    <div class="project_detail">
                        <p class="title">Lead Owner</p>
                        <p>Sarah Smith</p>
                        <p class="title">Division VP</p>
                        <p>John Carroll</p>
                        <p class="title">Last Contacted</p>
                        <p>3 days ago.</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <div class="row">
        <div class="col-md-6 col-sm-6 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Transcript documents</h2>
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
                                <th>Document Name</th>
                                <th>#Edit</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th scope="row">1</th>
                                <td><a href=""><i class="fa fa-file-word-o"></i>Functional-requirements.docx</a></td>
                                <td>
                                    <a href="AnalyseTranscript.aspx" class="btn btn-primary btn-xs"><i class="fa fa-folder"></i>Analyze </a>
                                    <a href="#" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i>Edit </a>
                                    <a href="#" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i>Delete </a>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">2</th>
                                <td><a href=""><i class="fa fa-file-word-o"></i> Contract-10_12_2014.docx</a></td>
                                <td>
                                    <a href="AnalyseTranscript.aspx" class="btn btn-primary btn-xs"><i class="fa fa-folder"></i>Analyze </a>
                                    <a href="#" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i>Edit </a>
                                    <a href="#" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i>Delete </a>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">3</th>
                                <td><a href=""><i class="fa fa-file-pdf-o"></i> UAT.pdf</a></td>
                                <td>
                                    <a href="AnalyseTranscript.aspx" class="btn btn-primary btn-xs"><i class="fa fa-folder"></i>Analyze </a>
                                    <a href="#" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i>Edit </a>
                                    <a href="#" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i>Delete </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-sm-6 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Related Academic Programs</h2>
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

    <div class="row">
        <div class="col-md-6 col-sm-6 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Activities</h2>
                    <ul class="nav navbar-right panel_toolbox">
                        <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                        </li>
                    </ul>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">
                    <div>

                        <!-- end of user messages -->
                        <ul class="messages">
                            <li>
                                <img src="../../Common/images/img.jpg" class="avatar" alt="Avatar">
                                <div class="message_date">
                                    <h3 class="date text-info">24</h3>
                                    <p class="month">May</p>
                                </div>
                                <div class="message_wrapper">
                                    <h4 class="heading">Desmond Davison</h4>
                                    <blockquote class="message">Raw denim you probably haven't heard of them jean shorts Austin. Nesciunt tofu stumptown aliqua butcher retro keffiyeh dreamcatcher synth.</blockquote>
                                    <br />
                                    <p class="url">
                                        <span class="fs1 text-info" aria-hidden="true" data-icon=""></span>
                                        <a href="#"><i class="fa fa-paperclip"></i>User Acceptance Test.doc </a>
                                    </p>
                                </div>
                            </li>
                            <li>
                                <img src="../../Common/images/img.jpg" class="avatar" alt="Avatar">
                                <div class="message_date">
                                    <h3 class="date text-error">21</h3>
                                    <p class="month">May</p>
                                </div>
                                <div class="message_wrapper">
                                    <h4 class="heading">Brian Michaels</h4>
                                    <blockquote class="message">Raw denim you probably haven't heard of them jean shorts Austin. Nesciunt tofu stumptown aliqua butcher retro keffiyeh dreamcatcher synth.</blockquote>
                                    <br />
                                    <p class="url">
                                        <span class="fs1" aria-hidden="true" data-icon=""></span>
                                        <a href="#" data-original-title="">Download</a>
                                    </p>
                                </div>
                            </li>
                            <li>
                                <img src="../../Common/images/img.jpg" class="avatar" alt="Avatar">
                                <div class="message_date">
                                    <h3 class="date text-info">24</h3>
                                    <p class="month">May</p>
                                </div>
                                <div class="message_wrapper">
                                    <h4 class="heading">Desmond Davison</h4>
                                    <blockquote class="message">Raw denim you probably haven't heard of them jean shorts Austin. Nesciunt tofu stumptown aliqua butcher retro keffiyeh dreamcatcher synth.</blockquote>
                                    <br />
                                    <p class="url">
                                        <span class="fs1 text-info" aria-hidden="true" data-icon=""></span>
                                        <a href="#"><i class="fa fa-paperclip"></i>User Acceptance Test.doc </a>
                                    </p>
                                </div>
                            </li>
                        </ul>
                        <!-- end of user messages -->


                    </div>
                </div>
            </div>

        </div>
        <div class="col-md-6 col-sm-6 col-xs-12">
            <div class="x_panel">
                <div class="x_title">
                    <h2>Tasks</h2>
                    <ul class="nav navbar-right panel_toolbox">
                        <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                        </li>
                    </ul>
                    <div class="clearfix"></div>
                </div>
                <div class="x_content">

                    <!-- start project list -->
                    <table class="table table-striped projects">
                        <thead>
                            <tr>
                                <th style="width: 1%">#</th>
                                <th style="width: 20%">Task Name</th>
                                <th>Progress</th>
                                <th>Status</th>
                                <th style="width: 20%">#Edit</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#</td>
                                <td>
                                    <a>Pesamakini Backend UI</a>
                                    <br />
                                    <small>Created 01.01.2015</small>
                                </td>
                                <td class="project_progress">
                                    <div class="progress progress_sm">
                                        <div class="progress-bar bg-green" role="progressbar" data-transitiongoal="57"></div>
                                    </div>
                                    <small>57% Complete</small>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-success btn-xs">Success</button>
                                </td>
                                <td>
                                    <a href="#" class="btn btn-primary btn-xs"><i class="fa fa-folder"></i>View </a>
                                    <a href="#" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i>Edit </a>
                                    <a href="#" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i>Delete </a>
                                </td>
                            </tr>
                            <tr>
                                <td>#</td>
                                <td>
                                    <a>Pesamakini Backend UI</a>
                                    <br />
                                    <small>Created 01.01.2015</small>
                                </td>
                                <td class="project_progress">
                                    <div class="progress progress_sm">
                                        <div class="progress-bar bg-green" role="progressbar" data-transitiongoal="47"></div>
                                    </div>
                                    <small>47% Complete</small>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-success btn-xs">Success</button>
                                </td>
                                <td>
                                    <a href="#" class="btn btn-primary btn-xs"><i class="fa fa-folder"></i>View </a>
                                    <a href="#" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i>Edit </a>
                                    <a href="#" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i>Delete </a>
                                </td>
                            </tr>
                            <tr>
                                <td>#</td>
                                <td>
                                    <a>Pesamakini Backend UI</a>
                                    <br />
                                    <small>Created 01.01.2015</small>
                                </td>
                                <td class="project_progress">
                                    <div class="progress progress_sm">
                                        <div class="progress-bar bg-green" role="progressbar" data-transitiongoal="77"></div>
                                    </div>
                                    <small>77% Complete</small>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-success btn-xs">Success</button>
                                </td>
                                <td>
                                    <a href="#" class="btn btn-primary btn-xs"><i class="fa fa-folder"></i>View </a>
                                    <a href="#" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i>Edit </a>
                                    <a href="#" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i>Delete </a>
                                </td>
                            </tr>
                            <tr>
                                <td>#</td>
                                <td>
                                    <a>Pesamakini Backend UI</a>
                                    <br />
                                    <small>Created 01.01.2015</small>
                                </td>
                                <td class="project_progress">
                                    <div class="progress progress_sm">
                                        <div class="progress-bar bg-green" role="progressbar" data-transitiongoal="60"></div>
                                    </div>
                                    <small>60% Complete</small>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-success btn-xs">Success</button>
                                </td>
                                <td>
                                    <a href="#" class="btn btn-primary btn-xs"><i class="fa fa-folder"></i>View </a>
                                    <a href="#" class="btn btn-info btn-xs"><i class="fa fa-pencil"></i>Edit </a>
                                    <a href="#" class="btn btn-danger btn-xs"><i class="fa fa-trash-o"></i>Delete </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- end project list -->

                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <!-- NProgress -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/nprogress/nprogress.js") %>"></script>
    <!-- bootstrap-progressbar -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/bootstrap-progressbar/bootstrap-progressbar.min.js") %>"></script>
</asp:Content>
