<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExcludeArticulationCourses.aspx.cs" Inherits="ems_app.modules.popups.ExcludeArticulationCourses" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Exclude Articulated Courses</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous" />
    <!-- Font Awesome -->
    <script src="https://use.fontawesome.com/6c4529ef90.js"></script>
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>?v=<%=DateTime.Now.Ticks.ToString()%>" rel="stylesheet" />
    <style>
 
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <div class="row" style="padding: 20px;">
                <asp:HiddenField ID="hfVeteranCreditRecommendationID" runat="server" ClientIDMode="Static" />
                   <div class="row">
                        <div class="col-12" style="text-align: right">
                            <telerik:RadLabel ID="rlCreditRecommendation" CssClass="alert alert-light mt-2" runat="server"></telerik:RadLabel>
                        </div>
                    </div>
                    <asp:SqlDataSource ID="sqlExcludedArticulationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"  
                        SelectCommand="GetExcludedArticulationCourses" SelectCommandType="StoredProcedure" >
                        <SelectParameters>
                            <asp:ControlParameter ControlID="hfVeteranCreditRecommendationID" PropertyName="Value" Name="VeteranCreditRecommendationID" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadGrid ID="rgExcludeArticulatedCourses" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="sqlExcludedArticulationCourses" AllowMultiRowSelection="true" AllowPaging="false" ShowHeader="true" OnPreRender="rgExcludeArticulatedCourses_PreRender" OnItemCommand="rgExcludeArticulatedCourses_ItemCommand">
                    <ClientSettings>
                        <Selecting AllowRowSelect="true" UseClientSelectColumnOnly="true"/>
                        <ClientEvents OnRowClick="toggleSelection" />
                    </ClientSettings>
                        <MasterTableView Name="ParentGrid" DataSourceID="sqlExcludedArticulationCourses" CommandItemDisplay="Top" PageSize="12" DataKeyNames="ArticulationID" >
                                <CommandItemTemplate>
                                    <div class="commandItems">
                                        <telerik:RadButton runat="server" ID="btnExclude" Primary="true" Text="MoveForward" CommandName="Exclude" ToolTip="Exclude selected articulation course(s)">
                                            <ContentTemplate>
                                                <i class='fa fa-exchange'></i> Exclude
                                            </ContentTemplate>
                                            <ConfirmSettings ConfirmText="Are you sure you want to Exclude the selected articulated course(s) ?" />
                                        </telerik:RadButton>
                                        <telerik:RadButton runat="server" ID="btnDelete" ButtonType="StandardButton" Text="Return" CommandName="Delete" ToolTip="Delete selected articulation(s)">
                                            <ContentTemplate>
                                                <i class='fa fa-trash'></i> Delete
                                            </ContentTemplate>
                                            <ConfirmSettings ConfirmText="Are you sure you want to delete the selected articulated course(s) ? This action cannot be undone. Do you want to proceed ?" Width="500" />
                                        </telerik:RadButton>
                                    </div>
                                </CommandItemTemplate>
                            <Columns>
                                <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="VeteranCreditRecommendationID" UniqueName="VeteranCreditRecommendationID" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridClientSelectColumn UniqueName="selectCheckbox" HeaderStyle-Width="30px"></telerik:GridClientSelectColumn>
                                <telerik:GridBoundColumn DataField="subject" UniqueName="subject" HeaderText="Subject">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="unit" UniqueName="unit" HeaderText="Units">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="RoleName" UniqueName="RoleName" HeaderText="Stage">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
            </div>
            <telerik:RadLabel ID="RadLabel1" runat="server" CssClass="alert alert-warning mt-2" Text="Note : Click the checkbox of the articulated course that you want to be excluded. Unchecked articulated courses will be excluded from the Eligible Credits Workspace."></telerik:RadLabel>
            <telerik:RadNotification RenderMode="Lightweight" ID="rnMessage" runat="server" Text="" Position="TopCenter" AutoCloseDelay="2000" Width="650" Height="310" Title="Notification" EnableRoundedCorners="false">
            </telerik:RadNotification>
            <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server">
            </telerik:RadWindowManager>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <!-- jQuery -->
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <!-- Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj" crossorigin="anonymous"></script>
    <!-- Custom Theme Scripts -->
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>?ver=<%=DateTime.Now.Ticks.ToString()%>"></script>
    <script>
        function toggleSelection(sender, args) {
            args.get_gridDataItem().set_selected(!args.get_gridDataItem().get_selected());
        }
        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow)
                oWindow = window.radWindow;
            else if (window.frameElement && window.frameElement.radWindow)
                oWindow = window.frameElement.radWindow;
            return oWindow;
        }
        function CloseModal() {
            // GetRadWindow().close();
            setTimeout(function () {
                GetRadWindow().close();
                top.location.href = top.location.href;
            }, 0);
        }
    </script>
</body>
</html>

