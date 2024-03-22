<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowACEMatches.aspx.cs" Inherits="ems_app.modules.popups.ShowACEMatches" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
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
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false"></telerik:RadWindowManager>
            <div style="padding:15px !important;">
            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <h3>Course Articulation</h3>
                    <asp:SqlDataSource ID="sqlArticulationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT ac.*, S.subject + ' ' + cif.course_number + ' - ' + cif.course_title as course_title  FROM Articulation ac LEFT OUTER JOIN Course_IssuedForm cif ON ac.outline_id = cif.outline_id LEFT OUTER JOIN tblSubjects s ON CIF.subject_id = S.subject_id WHERE ac.outline_id = @outline_id" DeleteCommand="DELETE FROM [ArticulationCourse] WHERE [id] = @id">
                        <SelectParameters>
                            <asp:QueryStringParameter DefaultValue="0" Name="outline_id" QueryStringField="outline_id" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:Parameter Name="id" Type="Int32" />
                        </DeleteParameters>
                    </asp:SqlDataSource>
                    <telerik:RadGrid ID="rgArticulationCourses" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulationCourses" AllowAutomaticDeletes="true" OnItemCommand="rgArticulationCourses_ItemCommand">
                        <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                        <MasterTableView DataSourceID="sqlArticulationCourses" DataKeyNames="id">
                            <Columns>
                                <telerik:GridBoundColumn DataField="ConditionSymbol" FilterControlAltText="Filter ConditionSymbol column" HeaderText="&/or" SortExpression="ConditionSymbol" UniqueName="ConditionSymbol">
                                </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn HeaderText="NORCO COLLEGE" UniqueName="cmdOpen" AllowFiltering="false" HeaderStyle-Width="142px" ItemStyle-Width="60px" ReadOnly="true" >
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CommandName="ViewCourse" ID="btnOpen3" Text='<%# DataBinder.Eval(Container.DataItem,"course_title")%>' ClientIDMode="Static" />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <telerik:GridTemplateColumn HeaderText="ACE ID" DataField="AceID" FilterControlAltText="Filter AceID column"  SortExpression="AceID" UniqueName="cmdOpen" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains"  >
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CommandName="ShowACEDEtail" ID="btnOpen" Text='<%# DataBinder.Eval(Container.DataItem,"AceID")%>' ClientIDMode="Static" />
                                </ItemTemplate>
                                <HeaderStyle Width="100px" />
                            </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="ACE ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn DataField="Title" FilterControlAltText="Filter Title column" HeaderText="Title" SortExpression="Title" UniqueName="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CommandName="ShowACEDEtail" ID="btnOpen2" Text='<%# DataBinder.Eval(Container.DataItem,"Title")%>' ClientIDMode="Static" />
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </div>
            </div>
        </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
</body>
</html>
