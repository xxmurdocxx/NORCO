<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Programs.aspx.cs" Inherits="ems_app.modules.academic.Programs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Programs of Study</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select program_id, status, archive_info, REPLACE (program, '&','and') as program, description, degree_id, division_id, core_units, elect_units, tot_units, approv_date, IssuedFormID, reqelec_text, reqelec_units, semester, comments, implementation_date, college_id, effective_start_date, effective_end_date, author_user_id, division_user_id, department_user_id, ProgramCoursesText, department_id, ( select isnull(count(pc.outline_id),0) from Articulation ac left outer join tblProgramCourses pc on pc.outline_id = ac.outline_id where ac.Articulate = 1 and pc.program_id = pif.program_id and ac.ArticulationType = 1 group by pc.program_id  ) 'Courses', ( select isnull(count(pc.outline_id),0) from Articulation ac left outer join tblProgramCourses pc on pc.outline_id = ac.outline_id where ac.Articulate = 1 and pc.program_id = pif.program_id and ac.ArticulationType = 2 group by pc.program_id  ) 'Occupations' , ( select count(*) from tblProgramCourses where program_id = pif.program_id and outline_id <> 0 and required in (1,2)) as 'CollegeCourses' from Program_IssuedForm pif where status = 0 and [college_id] = @CollegeID order by program, cast(pif.description as varchar(5))">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <telerik:RadGrid ID="rgPrograms" runat="server" CellSpacing="-1" DataSourceID="sqlPrograms" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" OnItemCommand="rgPrograms_ItemCommand">
            <ExportSettings ExportOnlyData="true" FileName="ProgramsOfStudy" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
            </ExportSettings>
            <GroupingSettings CaseSensitive="false" />
            <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
            </ClientSettings>
            <MasterTableView DataSourceID="sqlPrograms" DataKeyNames="program_id" CommandItemDisplay="Top" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Font-Bold="true">
                <CommandItemSettings ShowExportToExcelButton="true" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                <CommandItemTemplate>
                    <div class="commandItems">
                        <telerik:RadButton runat="server" ID="btnPrintProgram" ToolTip="Print Full Version Program of Study" CommandName="PrintProgram" Text="Print Full Version" ButtonType="LinkButton">
                            <Icon PrimaryIconCssClass="rbPrint"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton runat="server" ID="btnPrintProgramShort" ToolTip="Print Short Version Program of Study" CommandName="PrintProgramShort" Text="Print Short Version" ButtonType="LinkButton">
                            <Icon PrimaryIconCssClass="rbPrint"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton runat="server" ID="btnPrintProgramAll" ToolTip="Print All Program of Study" CommandName="PrintProgramAll" Text="Print All Programs" ButtonType="LinkButton">
                            <Icon PrimaryIconCssClass="rbPrint"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton runat="server" ID="btnEditProgram" ToolTip="Edit Program of Study information." CommandName="EditProgram" Text="Edit Program Info" ButtonType="LinkButton">
                            <Icon PrimaryIconCssClass="rbOpen"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton runat="server" ID="btnRequirements" ToolTip="Edit Program Requirements." CommandName="EditRequirements" Text="Edit Program Requirements" ButtonType="LinkButton">
                            <Icon PrimaryIconCssClass="rbOk"></Icon>
                        </telerik:RadButton>
                        <telerik:RadButton ID="rbExport" runat="server" Text="Export" CommandName="ExportToExcel" ToolTip="Export Programs of Study" >
                            <ContentTemplate>
                                <i class="fa fa-file-excel-o"></i> Export to Excel
                            </ContentTemplate>
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>
                <Columns>
                    <telerik:GridBoundColumn DataField="program_id" DataType="System.Int32" Display="False" FilterControlAltText="Filter program_id column" HeaderText="program_id" ReadOnly="True" SortExpression="program_id" UniqueName="program_id">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="program" FilterControlAltText="Filter program column" HeaderText="Program Name" SortExpression="program" UniqueName="program" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="250px">
                    </telerik:GridBoundColumn>
                    
                    <telerik:GridBoundColumn DataField="Courses" FilterControlAltText="Filter Courses column" HeaderText="Articulated ACE Courses" SortExpression="Courses" UniqueName="Courses" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" FilterControlToolTip="Filter By Number of Articulated ACE Courses">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Occupations" FilterControlAltText="Filter Occupations column" HeaderText="Articulated ACE Occupations" SortExpression="Occupations" UniqueName="Occupations" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" FilterControlToolTip="Filter By Number of Articulated ACE Occupations">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CollegeCourses" FilterControlAltText="Filter CollegeCourses column" HeaderText="Total Courses" SortExpression="CollegeCourses" UniqueName="CollegeCourses" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" FilterControlWidth="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" FilterControlToolTip="Filter By Number of Total Courses in the program.">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Description" FilterControlAltText="Filter Description column" HeaderText="Acad Prog ID" SortExpression="Description" UniqueName="Description" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                    </telerik:GridBoundColumn>
                    <telerik:GridDateTimeColumn DataField="approv_date" DataType="System.DateTime" FilterControlAltText="Filter approv_date column" HeaderText="Date Approved" SortExpression="approv_date" UniqueName="approv_date" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" >
                        <ItemStyle HorizontalAlign="Center" />
                    </telerik:GridDateTimeColumn>
                    <telerik:GridDateTimeColumn DataField="effective_start_date" DataType="System.DateTime" FilterControlAltText="Filter effective_start_date column" HeaderText="Start Date" SortExpression="effective_start_date" UniqueName="effective_start_date" DataFormatString="{0:MM/dd/yyyy}" AllowFiltering="true" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="120px" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                    </telerik:GridDateTimeColumn>
                    <telerik:GridDateTimeColumn DataField="effective_end_date" DataType="System.DateTime" FilterControlAltText="Filter effective_end_date column" HeaderText="End Date" SortExpression="effective_end_date" UniqueName="effective_end_date" DataFormatString="{0:MM/dd/yyyy}" AllowFiltering="true" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="120px" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                    </telerik:GridDateTimeColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">  
    function closeRadWindow()  
    {  
        $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();   
    }
    </script> 
    <script type="text/javascript">
    function onRequestStart(sender, args) {
        if (args.get_eventTarget().indexOf("rbExport") >= 0) {
            args.set_enableAjax(false);
            document.forms[0].target = "_blank";
        }
    }
</script>
</asp:Content>
