<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowCourseDetail.aspx.cs" Inherits="ems_app.modules.popups.ShowCourseDetail" %>

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
    <div style="padding: 15px !important;">
        <form id="form1" runat="server">
        <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct p.program_id, concat('<h3>',p.program,'</h3><p>',DBO.Get_Value_IssuedFromProperties_POS(p.IssuedFormID, 'DevelopedSLODescription'),'</p>') program from Program_IssuedForm p where p.program_id in ( select pc.program_id from tblProgramCourses pc left outer join Program_IssuedForm pif on pc.program_id = pif.program_id  where pc.outline_id = @outline_id) and DBO.Get_Value_IssuedFromProperties_POS(p.IssuedFormID, 'DevelopedSLODescription') <> '' and p.status = 0 and college_id = @CollegeID">
            <SelectParameters>
                    <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCrossListingCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetCrossListingCourses" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlStudentLearningOutcome" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [StudentLearningOutcome] WHERE ([outline_id] = @outline_id) ORDER BY [id]">
                <SelectParameters>
                    <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
            <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" >
                <div class="row">
                    <div class="col-sm-4">
                        <h2>Course Information</h2>
                    </div>
                    <div class="col-sm-8 text-right">
                        <telerik:RadButton RenderMode="Lightweight" ID="rbDisableArticulate" runat="server" Text="Disable this course for Articulation" OnClick="rbDisableArticulate_Click">
                        </telerik:RadButton>
                        <telerik:RadButton RenderMode="Lightweight" ID="rbEnableArticulate" runat="server" Text="Enable this course for Articulation"  OnClick="rbDisableArticulate_Click" OnClientClicking="DisableConfirm">
                        </telerik:RadButton>
                        <asp:label id="lblDisableArticulate" runat="server" CssClass="alert alert-warning"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> This course has been disabled for articulation</asp:label>
                        <asp:Panel ID="pnlDisableArticulate" runat="server">
                            <br />
                            Please enter a rationale : <br /><br />
                            <telerik:RadTextBox ID="rtbRationale" TextMode="MultiLine" Rows="3" Wrap="true" Width="100%" runat="server"></telerik:RadTextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="rtbRationale" runat="server" ErrorMessage="Please enter a rationale" CssClass="alert alert-danger" ValidationGroup="rationale"></asp:RequiredFieldValidator>
                            <br />
                            <telerik:RadButton RenderMode="Lightweight" ID="rbConfirm" runat="server" Text="Confirm" OnClick="rbConfirm_Click"   OnClientClicking="DisableConfirm" ValidationGroup="rationale">
                                <Icon PrimaryIconCssClass="rbOk"></Icon>
                            </telerik:RadButton>&nbsp;&nbsp;
                            <telerik:RadButton RenderMode="Lightweight" ID="rbCancel" runat="server" Text="Cancel" OnClick="rbCancel_Click">
                                <Icon PrimaryIconCssClass="rbCancel"></Icon>
                            </telerik:RadButton>
                        </asp:Panel>
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <asp:SqlDataSource ID="sqlCoursesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="PCCCourseDataSelect" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="outline_id" QueryStringField="outline_id" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:Repeater ID="Repeater1" runat="server"
                            DataSourceID="sqlCoursesDetails">
                            <ItemTemplate>
                                <div class="col-sm-2">
                                    <asp:Label runat="server" ID="Label9" Text='Course : ' Font-Bold="true" /></div>
                                <div class="col-sm-10">
                                    <asp:Label runat="server" ID="Label10" Text='<%# Eval("_Subject") %>' />
                                    <asp:Label runat="server" ID="Label2" Text='<%# Eval("_CourseNumber") %>' /></div>
                                <div class="clearfix"></div>
                                <div class="col-sm-2">
                                    <asp:Label runat="server" ID="Label3" Text='Title : ' Font-Bold="true" /></div>
                                <div class="col-sm-10">
                                    <asp:Label runat="server" ID="Label4" Text='<%# Eval("_CourseTitle") %>' /></div>
                                <div class="clearfix"></div>
                                <div class="col-sm-2">
                                    <asp:Label runat="server" ID="Label1" Text='Units : ' Font-Bold="true" /></div>
                                <div class="col-sm-10">
                                    <asp:Label runat="server" ID="Label5" Text='<%# Eval("_Units") %>' /></div>
                                <div class="clearfix"></div>
                                <div class="col-sm-2">
                                    <asp:Label runat="server" ID="Label7" Text='Division : ' Font-Bold="true" /></div>
                                <div class="col-sm-10">
                                    <asp:Label runat="server" ID="Label8" Text='<%# Eval("_Division") %>' /></div>
                                <div class="clearfix"></div>
                                <div class="col-sm-2">
                                    <asp:Label runat="server" ID="Label11" Text='Catalog Description:' Font-Bold="true" /></div>
                                <div class="col-sm-10">
                                    <asp:Label runat="server" ID="Label12" Text='<%# Eval("_CatalogDescription") %>' /></div>
                                <div class="clearfix"></div>
                                <div class="col-sm-2">
                                    <asp:Label runat="server" ID="Label13" Text='Course Notes : ' Font-Bold="true" /></div>
                                <div class="col-sm-10">
                                    <asp:Label runat="server" ID="Label14" Text='<%# Eval("_CourseNotes") %>' /></div>
                                <div class="clearfix"></div>
                                <div class="col-sm-2">
                                    <asp:Label runat="server" ID="Label6" Text='Student Objectives : ' Font-Bold="true" /></div>
                                <div class="col-sm-10">
                                    <asp:Label runat="server" ID="Label15" Text='<%# Eval("_StudentObjectives") %>' /></div>
                                <div class="clearfix"></div>
                                <div class="col-sm-2">
                                    <asp:Label runat="server" ID="Label16" Text='C-ID Number : ' Font-Bold="true" /></div>
                                <div class="col-sm-10">
                                    <asp:Label runat="server" ID="Label17" Text='<%# Eval("_CIDNumber") %>' /></div>
                                <div class="clearfix"></div>
                                <div class="col-sm-2">
                                    <asp:Label runat="server" ID="Label18" Text='C-ID Title : ' Font-Bold="true" /></div>
                                <div class="col-sm-10">
                                    <asp:Label runat="server" ID="Label19" Text='<%# Eval("_CIDTitle") %>' /></div>

                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                        <br />
                        <div class="clearfix"></div>
                        <h2>Student Learning Outcomes</h2>
                        <telerik:RadGrid ID="rgStudentLearningOutcomes" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlStudentLearningOutcome" Width="100%" AllowAutomaticUpdates="true" AllowAutomaticDeletes="true" AllowAutomaticInserts="true">
                            <GroupingSettings CaseSensitive="false" />
                            <ClientSettings AllowKeyboardNavigation="true">
                                <Scrolling AllowScroll="false" />
                                <ClientEvents></ClientEvents>
                            </ClientSettings>
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="sqlStudentLearningOutcome" CommandItemDisplay="None" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="false" InsertItemDisplay="Bottom">
                                <Columns>
                                    <telerik:GridBoundColumn DataField="id" HeaderText="ID" UniqueName="id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="outline_id" HeaderText="Outline ID" UniqueName="outline_id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn UniqueName="RowNumber" HeaderText="">
                                        <ItemTemplate>
                                            <%#Container.ItemIndex+1%>
                                        </ItemTemplate>
                                        <HeaderStyle Width="40px" />
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn DataField="SLODescription" HeaderText="SLO Description" UniqueName="SLODescription" ColumnEditorID="TextEditor" HeaderStyle-Font-Bold="true">
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                        <h2>Program Learning Outcomes</h2>
                        <telerik:RadGrid ID="rgPLOs" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlPrograms" AutoGenerateColumns="False" HeaderStyle-Font-Bold="true" RenderMode="Lightweight">
                            <MasterTableView Name="ParentGrid" DataKeyNames="program_id" DataSourceID="sqlPrograms" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="false" HeaderStyle-Font-Bold="true" AutoGenerateColumns="false" >
                                <Columns>
                                    <telerik:GridBoundColumn DataField="program_id" DataType="System.Int32" FilterControlAltText="Filter program_id column" HeaderText="program_id" SortExpression="program_id" UniqueName="program_id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridHTMLEditorColumn DataField="program" FilterControlAltText="Filter program column" HeaderText="Program of Study" SortExpression="program" UniqueName="program" ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="150px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                    </telerik:GridHTMLEditorColumn>
                                </Columns>
                                <NoRecordsTemplate>
                                    <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                        &nbsp;No Program Learning Outcomes found
                                    </div>
                                </NoRecordsTemplate>
                            </MasterTableView>
                        </telerik:RadGrid>
                        <h2>Cross Listing Courses</h2>
                        <telerik:RadGrid ID="rgCrossListingCourses" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlCrossListingCourses" AutoGenerateColumns="False" HeaderStyle-Font-Bold="true" RenderMode="Lightweight">
                            <MasterTableView Name="ParentGrid" DataKeyNames="outline_id" DataSourceID="sqlCrossListingCourses" EnableNoRecordsTemplate="true" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false" CommandItemSettings-ShowRefreshButton="false" HeaderStyle-Font-Bold="true" AutoGenerateColumns="false">
                                <Columns>
                                    <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="150px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Course Number" SortExpression="course_number" UniqueName="course_number" ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="150px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Subject" SortExpression="course_title" UniqueName="course_title" ItemStyle-Wrap="true" ReadOnly="true" FilterControlWidth="150px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                    </telerik:GridBoundColumn>
                                </Columns>
                                <NoRecordsTemplate>
                                    <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                        &nbsp;No Cross Listing courses found
                                    </div>
                                </NoRecordsTemplate>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
                </div>
            </telerik:RadAjaxPanel>
            <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
        </form>
    </div>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/TelerikControls.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script>
        function DisableConfirm(sender, args) {
            args.set_cancel(!window.confirm("Are you sure yo want to enable/disable this course for articulation. ?"));
        }
        function openwin() {
            window.radopen(null, "RadWindow1");
        }
    </script>
</body>
</html>

