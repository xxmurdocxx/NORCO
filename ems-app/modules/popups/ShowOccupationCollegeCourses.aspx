<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowOccupationCollegeCourses.aspx.cs" Inherits="ems_app.modules.popups.ShowOccupationCollegeCourses" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Related ACE Occupations Codes</title>
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
        <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from OccupationService order by Description"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlAllOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from AceExhibit ao inner join ( SELECT Occupation, max(AceID) as AceID FROM AceExhibit aoc group by Occupation ) a02 on ao.AceID = a02.AceID where coalesce(ao.[OccupationServiceCode],'0') IN (select value from fn_split(@Service,',')) and ao.Occupation not in (SELECT OccupationID FROM CourseOccupations WHERE [AceID] = @AceID and [TeamRevd] = @TeamRevd) order by ao.Title, ao.TeamRevd, ao.Exhibit" CancelSelectOnNullParameter="false">
            <SelectParameters>
                <asp:Parameter DbType="String" Name="Service" />
                <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ao.Occupation, ao.Occupation + ' - ' + ao.Title as Title from ACEExhibit ao inner join ( SELECT Occupation, max(AceID) as AceID FROM ACEExhibit aoc group by Occupation ) a02 on ao.AceID = a02.AceID order by ao.Occupation"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCourseOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM CourseOccupations WHERE [AceID] = @AceID and [TeamRevd] = @TeamRevd" DeleteCommand="DELETE FROM [CourseOccupations] WHERE [AceID] = @AceID and [TeamRevd] = @TeamRevd and [OccupationID] = @OccupationID" InsertCommand="INSERT INTO [CourseOccupations] ([AceID],[TeamRevd],[OccupationID]) VALUES (@AceID, Convert(datetime, @TeamRevd, 103), @OccupationID)">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="AceID" QueryStringField="AceID" />
                <asp:QueryStringParameter DefaultValue="0" Name="TeamRevd" QueryStringField="TeamRevd" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <div class="row" style="padding: 15px !important;">
                <div class="col-md-6 col-sm-6 col-xs-6">
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <h3 id="courseTitle" runat="server"></h3>
                        <telerik:RadGrid ID="rgCourseOccupations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlCourseOccupations" AllowAutomaticDeletes="true" AllowAutomaticInserts="true">
                            <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                            <MasterTableView DataSourceID="sqlCourseOccupations" DataKeyNames="AceID,TeamRevd,OccupationID" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="true" EditMode="Batch"  AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                <BatchEditingSettings EditType="Cell" />
                                <Columns>
                                    <telerik:GridDropDownColumn DataField="OccupationID" FilterControlAltText="Filter OccupationID column" HeaderText="Occupation" SortExpression="OccupationID" UniqueName="OccupationID" DataSourceID="sqlOccupations" ListTextField="Title" ListValueField="Occupation" HeaderStyle-Font-Bold="true">
                                    </telerik:GridDropDownColumn>
                                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this occupation ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
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

