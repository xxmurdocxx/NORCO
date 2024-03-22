<%@ Page Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="MilitaryCredits.aspx.cs" Inherits="ems_app.modules.military.MilitaryCredits" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        h2 {
            background-color:#203864 !important;
            color:#fff !important;
            padding:5px;
            width:400px;
            margin:0 auto;
        }
        .btn-primary {
            background-color: #203864 !important;
        }
        .student-information .form-control {
            font-size: 12px !important;
            font-weight: bold !important;
        }
        .section-header, .RadTabStrip_Material .rtsSelected .rtsLink {
            margin:auto 0 !important;
        }
        @media print {
            body * {
                visibility: hidden;
            }

            #btnPrint {
                visibility: hidden !important;
            }

            #section-to-print, #section-to-print * {
                visibility: visible;
            }

            #section-to-print {
                margin-top: 50px;
                position: absolute;
                left: 0;
                top: 0;
            }
            tr.rgCommandRow {
                visibility: hidden !important;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="appTitle" id="SystemTitle" runat="server"></p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hfCollege" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfVeteranID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfCourse" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfOccupational" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfOccupationalElectives" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfTotal" runat="server" ClientIDMode="Static" />
    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" DestroyOnClose="true" EnableViewState="false" EnableShadow="true" InitialBehaviors="Close">
        <Windows>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalEmail" runat="server" Title="Send Email" Width="550px" Height="300px" Behaviors="Close" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <telerik:RadTextBox RenderMode="Lightweight" runat="server" ID="txtSendEmail" Width="515px" Height="180px" TextMode="MultiLine" Resize="None" EmptyMessage="Email account recipient(s). Multiple emails must be separated by semicolons(;)"  BackColor="#ffffe0" EmptyMessageStyle-Font-Italic="true"></telerik:RadTextBox>
                    <div style="float: right; padding-top: 15px">
                        <telerik:RadButton ID="btnSendMail" runat="server" OnClick="btnSendMail_Click" Text="Send email"></telerik:RadButton>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>
    <telerik:RadNotification ID="rnMessages" runat="server" Position="Center" Width="300px" Height="150px"></telerik:RadNotification>
    <div class="container text-center" style="margin-bottom:40px;">
        <h1 style="padding-bottom:10px;">CPL Summary Report</h1>
        <h3 id="hCollegeName" runat="server">College: </h3>
    </div>
    <div id="section-to-print">


        <div class="container">
        <h2 class="section-header p-2 text-center">Student Information</h2>
        <div class="container student-information"  >
            <div class="container" style="margin-top:10px;">
              <div class="row">
                <div class="col-md-3">
                    <telerik:RadLabel ID="rlname" runat="server" Font-Bold="true" Text="First Name: "></telerik:RadLabel>
                </div>
                <div class="col-md-9">
                    <telerik:RadLabel ID="rlEmail" runat="server" Font-Bold="true" Text="Email: "></telerik:RadLabel>
                </div>
              </div>
              <div class="row">
                <div class="col-md-3">
                    <telerik:RadLabel ID="rlLastName" runat="server" Font-Bold="true" Text="Last Name: "></telerik:RadLabel>
                </div>
                <div class="col-md-9">
                    <telerik:RadLabel ID="rlPhone" runat="server" Font-Bold="true" Text="Phone: "></telerik:RadLabel>
                </div>
              </div>
              <div class="row">
                <div class="col-md-3">
                    <telerik:RadLabel ID="rlBranch" runat="server" Font-Bold="true" Text="Branch: "></telerik:RadLabel>
                </div>
                <div class="col-md-9">
                    <telerik:RadLabel ID="rlProgramStudy" runat="server" Font-Bold="true" Text="Program of Study: "></telerik:RadLabel>
                </div>
              </div>
              <div class="row">
                <div class="col-md-3">
                    <telerik:RadLabel ID="rlCPLType" runat="server" Font-Bold="true" Text="CPL Type: "></telerik:RadLabel>
                </div>
                <div class="col-md-9">
                    <telerik:RadLabel ID="rlCPLStatus" runat="server" Font-Bold="true" Text="CPL Status: "></telerik:RadLabel>
                </div>
              </div>
                <div class="row">
                <div class="col-md-3">
                    <telerik:RadLabel ID="rlLearningMode" runat="server" Font-Bold="true" Text="Learning Mode: "></telerik:RadLabel>
                </div>
                <div class="col-md-9">
                    
                </div>
                </div>
              <div class="row">
                <div class="col-md-3">
                    <telerik:RadLabel ID="rlID" runat="server" Font-Bold="true" Text="ID #: "></telerik:RadLabel>
                </div>
                <div class="col-md-9">
                    
                </div>
              </div>
            </div>
        </div> 
         <div class="row">
            <div class="col-8"></div>
            <div class="col-4 text-center">
                <div class="col"><div class="btn btn-primary" onclick="ShowModalEmail()"><i class="fa fa-envelope-o" aria-hidden="true"></i> Email</div></div>
                <div class="col"><asp:LinkButton runat="server" class="btn btn-primary" ToolTip="Print" ID="btnPrintMilitaryCredits" Text='<i class="fa fa-print" aria-hidden="true"></i> Print' /></div>
            </div>
         </div>
            <br />
            <h2 class="section-header p-2 text-center">Applied MAP Credits</h2>
            <br />
            <div class="d-flex justify-content-center">
                <asp:SqlDataSource ID="sqlSelected" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select criteria, CASE WHEN s.isElective = 1 then 'Elective' else case when s.isAreaCredit = 1 then 'Area' else  a.CourseType end end course_type,  units, AceID, Course, TeamRevd, CourseNumber, CourseVersion, Level  from [dbo].[fn_GetEligibleCredits](@VeteranId,@CollegeId) a left outer join Course_IssuedForm c on a.outline_id = c.outline_id left outer join tblSubjects s on c.subject_id = s.subject_id where units > 0 and IsElective = 1 OR JSTOrder = 99 OR StageOrder = 4 and isnull(DNA,0) <> 1"
                    SelectCommandType="Text">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
                        <asp:SessionParameter SessionField="CollegeID" Name="CollegeId" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <telerik:RadGrid ID="rgSelected" runat="server" CellSpacing="-1" DataSourceID="sqlSelected" Width="100%" AllowAutomaticUpdates="false" PageSize="50" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" ShowFooter="false" EnableLinqExpressions="false" AllowFilteringByColumn="false" AllowMultiRowSelection="false" ShowHeader="false" ClientSettings-EnableAlternatingItems="false"  >
                    <GroupingSettings CaseSensitive="false" />
                    <ExportSettings IgnorePaging="true" ExportOnlyData="false" FileName="Applied MAP Credits" Excel-FileExtension="xls" Excel-Format="Xlsx">
                    </ExportSettings>
                    <ClientSettings EnableAlternatingItems="false">
                        <Selecting AllowRowSelect="false" />
                    </ClientSettings>
                    <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlSelected" CommandItemDisplay="None" PageSize="20" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel" EditFormSettings-EditColumn-Resizable="true"  AlternateRowColor="false" >
                        <NoRecordsTemplate>
                            <p>No records to display</p>
                        </NoRecordsTemplate>
                        <Columns>

                            <telerik:GridNumericColumn SortExpression="Units" HeaderText="Units" DataField="Units" UniqueName="Units" AllowFiltering="False" HeaderStyle-Width="80px" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"  DecimalDigits="1"  DataType="System.Double" DataFormatString="{0:### ##0.0}">
                            </telerik:GridNumericColumn>
                            <telerik:GridBoundColumn SortExpression="course_type" HeaderText="" DataField="course_type" UniqueName="course_type" AllowFiltering="False" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="" ReadOnly="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Course" HeaderText="College Course" DataField="Course" UniqueName="Course" AllowFiltering="False" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="" ReadOnly="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendations" DataField="Criteria" UniqueName="Criteria" AllowFiltering="False" HeaderStyle-Width="380px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="AceID" HeaderText="Exhibit" DataField="AceID" UniqueName="AceID" AllowFiltering="False" HeaderStyle-Width="250px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="">
                            </telerik:GridBoundColumn>
                             <telerik:GridBoundColumn SortExpression="CourseNumber" HeaderText="Course Number" DataField="CourseNumber" UniqueName="CourseNumber" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="CourseVersion" HeaderText="Course Version" DataField="CourseVersion" UniqueName="CourseVersion" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Level" HeaderText="Level" DataField="Level" UniqueName="Level" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Type" HeaderText="Type" DataField="Type" UniqueName="Type" HeaderStyle-Width="150px" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
                <br />
            </div>
            <div class="container d-flex justify-content-end mt-2">
                <telerik:RadLabel ID="rlAppliedCredits" CssClass="shadow p-2 mt-3 bg-light rounded" runat="server"></telerik:RadLabel>
            </div>
            <br />
            <br />
            <br />
            <h2 class="section-header p-2 text-center">Eligible MAP Credits</h2>
            <br />
            <div class="d-flex justify-content-center">
                <asp:SqlDataSource ID="sqlApprovedCredits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select criteria, CASE WHEN s.isElective = 1 then 'Elective' else case when s.isAreaCredit = 1 then 'Area' else  'Course' end end course_type, DNA,  units, AceID, Course,  TeamRevd, CourseNumber, CourseVersion, Level   from [dbo].[fn_GetEligibleCredits](@VeteranId,@CollegeId) a left outer join Course_IssuedForm c on a.outline_id = c.outline_id left outer join tblSubjects s on c.subject_id = s.subject_id where units = 0 OR DNA = 1"
                    SelectCommandType="Text">
                    <SelectParameters>
                        <asp:SessionParameter SessionField="CollegeID" Name="CollegeId" Type="Int32" />
                        <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <telerik:RadGrid ID="rgApprovedCredits" runat="server" CellSpacing="-1" DataSourceID="sqlApprovedCredits" Width="100%" AllowAutomaticUpdates="false" PageSize="50" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" ShowFooter="false" EnableLinqExpressions="false" AllowFilteringByColumn="false" AllowMultiRowSelection="false" OnItemDataBound="rgApprovedCredits_ItemDataBound" ShowHeader="false" ClientSettings-EnableAlternatingItems="false">
                    <GroupingSettings CaseSensitive="false" />
                    <ExportSettings IgnorePaging="false" ExportOnlyData="false" FileName="Approved MAP Credits" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Xlsx">
                    </ExportSettings>
                    <ClientSettings AllowKeyboardNavigation="true">
                        <Scrolling AllowScroll="false" UseStaticHeaders="false" />
                        <Selecting AllowRowSelect="false" />
                    </ClientSettings>
                    <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlApprovedCredits" CommandItemDisplay="None" PageSize="50" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel" EditFormSettings-EditColumn-Resizable="true"  AlternateRowColor="false" >
                        <NoRecordsTemplate>
                            <p>No records to display</p>
                        </NoRecordsTemplate>
                        <Columns>
                            <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" HeaderStyle-Width="120px">
                            </telerik:GridBoundColumn>
                            <telerik:GridNumericColumn SortExpression="Units" HeaderText="Units" DataField="Units" UniqueName="Units" AllowFiltering="False" HeaderStyle-Width="80px" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DecimalDigits="1" DataType="System.Double" DataFormatString="{0:### ##0.0}" EmptyDataText="" ReadOnly="true" Display="false">
                            </telerik:GridNumericColumn>
                            <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendations" DataField="Criteria" UniqueName="Criteria" AllowFiltering="False"  HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn UniqueName="CPLStatus">
                                <ItemTemplate>
                                  <asp:Label ID="lblCPLStatus" runat="server" Text=""></asp:Label>
                                </ItemTemplate>
                              </telerik:GridTemplateColumn>
                            <telerik:GridBoundColumn DataField="DNA" UniqueName="DNA" Display="false" >
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="CourseNumber" HeaderText="Course Number" DataField="CourseNumber" UniqueName="CourseNumber" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="CourseVersion" HeaderText="Course Version" DataField="CourseVersion" UniqueName="CourseVersion" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Level" HeaderText="Level" DataField="Level" UniqueName="Level" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn SortExpression="Type" HeaderText="Type" DataField="Type" UniqueName="Type" HeaderStyle-Width="150px" HeaderStyle-Font-Bold="true">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </div>
            <br />
            
            <br />
            <br />
            <br />
           
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        function ShowModalEmail() {
            var wnd = $find("<%= modalEmail.ClientID %>");
            wnd.show();
        }
    </script>  
</asp:Content>
