<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="ems_app.modules.tutorial.Help" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Help</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- iCheck -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/iCheck/skins/flat/green.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>

        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest"  ClientEvents-OnRequestStart="onRequestStart">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="280px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <asp:SqlDataSource ID="sqlSurveys" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT isnull(sp.Completed,0) Completed, s.* FROM Survey.SurveyRole sr JOIN Survey.[Survey] s ON sr.SurveyID = s.SurveyID left outer join ( select SurveyID, completed from Survey.[SurveyParticipant] where UserID = @UserID ) sp on sr.SurveyID = sp.SurveyID WHERE (S.[CollegeID] = @CollegeID AND sr.RoleID = @RoleID ) ">
                <SelectParameters>
                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                    <asp:SessionParameter Name="RoleID" SessionField="RoleID" Type="Int32" />
                    <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <div style="padding: 15px !important;">
               
                <%--<div class="row">--%>
                   

                        <div class="col-sm-6">
                            <caption>
                                <h2 style="margin-top:5px; font-weight:bold">MAP Faculty Tutorials Videos</h2>
                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h3 style="margin-top:5px; font-weight:bold">Faculty - MAP Login</h3>
                                        <span class="pull-right clickable"><i class="glyphicon glyphicon-chevron-up"></i></span>
                                        <div class="panel-body">
                                            <video controls="controls" poster="FacultyLogin.jpg" style="width:100%" title="Faculty - MAP Login">
                                                <source src="FacultyLogin.mp4" type="video/mp4"/>
                                                <source src="FacultyLogin.webm" type="video/webm"/>
                                                <source src="FacultyLogin.ogv" type="video/ogg"/>
                                            </video>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h3 style="margin-top:5px; font-weight:bold">Faculty - Articulations Summary Overview</h3>
                                        <span class="pull-right clickable"><i class="glyphicon glyphicon-chevron-down"></i></span>
                                        <div class="panel-body  panel-collapse collapse">
                                            <video controls="controls" poster="facultyCollegeArticulationsSummary.jpg" style="width:100%" title="Faculty MAP Articulation Summary">
                                                <source src="facultyCollegeArticulationsSummary.mp4" type="video/mp4"/>
                                                <source src="facultyCollegeArticulationsSummary.webm" type="video/webm"/>
                                                <source src="facultyCollegeArticulationsSummary.ogv" type="video/ogg"/>
                                            </video>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h3 style="margin-top:5px; font-weight:bold">Faculty - Updating Articulations Criteria</h3>
                                        <span class="pull-right clickable"><i class="glyphicon glyphicon-chevron-down"></i></span>
                                        <div class="panel-body panel-collapse collapse">
                                            <video controls="controls" poster="highlightingcriteria.jpg" style="width:100%" title="Reviewing Articulations Criteria">
                                                <source src="highlightingcriteria.mp4" type="video/mp4"/>
                                                <source src="highlightingcriteria.webm" type="video/webm"/>
                                                <source src="highlightingcriteria.ogv" type="video/ogg"/>
                                            </video>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h3 style="margin-top:5px; font-weight:bold">Faculty - Moving Forward/Returning Articulations</h3>
                                        <span class="pull-right clickable"><i class="glyphicon glyphicon-chevron-down"></i></span>
                                        <div class="panel-body panel-collapse collapse">
                                            <video controls="controls" poster="MovingForwardAllArticulations.jpg" style="width:100%" title="Moving Forward Articulations">
                                                <source src="MovingForwardAllArticulations.mp4" type="video/mp4"/>
                                                <source src="MovingForwardAllArticulations.webm" type="video/webm"/>
                                                <source src="MovingForwardAllArticulations.ogv" type="video/ogg"/>
                                            </video>
                                        </div>
                                    </div>
                                </div>
                                <%--</div>--%>
                                <div class="col-sm-6" style="display:none">
                                    <h2 id="quizTitle" runat="server"></h2>
                                    <telerik:RadGrid ID="rgSurveys" runat="server" DataSourceID="sqlSurveys" OnItemCommand="rgSurveys_ItemCommand" OnItemDataBound="rgSurveys_ItemDataBound" ToolTip="We are proud to offer tutorial assessments, or quizzes for each MAP role. Each assessment contains a few multiple-choice questions, and will help you gauge how much of the information you've retained. You can also skip straight to a quiz at any time by navigating to the right side of the tutorial page and clicking into the Take this Quiz icon" Visible="false">
                                        <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="SurveyID" DataSourceID="sqlSurveys">
                                            <Columns>
                                                <telerik:GridTemplateColumn HeaderStyle-Width="80px">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnTakeQuiz" runat="server" CommandName="TakeQuiz" Text="&lt;i class=&quot;fa fa-pencil-square&quot; aria-hidden=&quot;true&quot;&gt;&lt;/i&gt; " ToolTip="Take this Quiz" />
                                                        <asp:LinkButton ID="btnResultsQuiz" runat="server" CommandName="QuizResults" Text="&lt;i class=&quot;fa fa-file-text&quot; aria-hidden=&quot;true&quot;&gt;&lt;/i&gt;" ToolTip="Show results of this Quiz" Visible="false" />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn DataField="SurveyID" DataType="System.Int32" Display="False" FilterControlAltText="Filter SurveyID column" HeaderText="SurveyID" ReadOnly="True" SortExpression="SurveyID" UniqueName="SurveyID">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Name" FilterControlAltText="Filter Name column" HeaderText="Name" SortExpression="Name" UniqueName="Name">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Completed" Display="false" FilterControlAltText="Filter Completed column" HeaderText="Completed" SortExpression="Completed" UniqueName="Completed">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridHTMLEditorColumn DataField="Description" FilterControlAltText="Filter Description column" HeaderText="Description" SortExpression="Description" UniqueName="Description">
                                                </telerik:GridHTMLEditorColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                </div>
                            </caption>
                        </div>

                    
                    </div>
               
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script type="text/javascript">
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }
    </script>
</body>
</html>


