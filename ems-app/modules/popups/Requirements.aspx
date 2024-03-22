<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Requirements.aspx.cs" Inherits="ems_app.modules.popups.Requirements" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Program of Study</title>
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
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" OnAjaxRequest="RadAjaxPanel1_AjaxRequest">
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="280px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <telerik:RadToolTip runat="server" ID="RadToolTip2" Width="380px" Height="70px" HideEvent="ManualClose" EnableRoundedCorners="true" Position="TopRight" Animation="Fade">
                <p id="P1" runat="server">
                    <asp:Label ID="Label3" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label><br />
                    <br />
                    <asp:Label ID="Label4" runat="server" EnableViewState="true">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div style="display: none !important;">
                <telerik:RadTextBox ID="selectedRowValue" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
                <telerik:RadTextBox ID="selectedCourseTitle" runat="server" ClientIDMode="Static" CssClass="displayNone"></telerik:RadTextBox>
            </div>

            <h3 runat="server" id="programTitle"></h3>
            <asp:HiddenField ID="hfProgramID" runat="server" />
            <asp:HiddenField ID="hfIssuedFormId" runat="server" />

            <telerik:RadTabStrip runat="server" ID="RadTabStrip1" AutoPostBack="false" MultiPageID="RadMultiPage1" SelectedIndex="0" ScrollChildren="True" Width="100%" Height="50px" ShowBaseLine="true" CausesValidation="false">
                <Tabs>
                    <telerik:RadTab Text="Program Requirements" ToolTip="Program Requirements" Selected="True"></telerik:RadTab>
                    <telerik:RadTab Text="Guided Pathways Map" ToolTip="Guided Pathways Map"></telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage runat="server" ID="RadMultiPage1" SelectedIndex="0" Width="100%">
                <telerik:RadPageView runat="server" ID="RadPageView1" Width="100%">
                    <div style="padding: 15px !important;">
                        <div class="row">
                            <div class="col-md-4">
                            </div>
                            <div class="col-md-4 text-right">
                                <telerik:RadTextBox ID="rtbGroupName" runat="server" ToolTip="Enter the Group Name/Description here"></telerik:RadTextBox><telerik:RadButton ID="rbAddGroup" OnClick="rbAddGroup_Click" runat="server" Text="ADD GROUP"></telerik:RadButton>
                            </div>
                            <div class="col-md-4">
                                <telerik:RadGrid ID="rgGroups" AutoGenerateColumns="false" DataSourceID="" runat="server" OnRowDrop="rgGroups_RowDrop" RenderMode="Lightweight" Skin="Metro">
                                    <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true">
                                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                    </ClientSettings>
                                    <MasterTableView DataSourceID="" PagerStyle-ShowPagerText="false" ShowHeader="false">
                                        <CommandItemSettings ShowAddNewRecordButton="False" />
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="groupName" HeaderText="" UniqueName="groupName" HeaderTooltip="Drag and Drop into either Required Courses and/or Restricted Electives">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <%-- COURSE CATALOG --%>
                                <h2>Course Catalog</h2>
                                <telerik:RadGrid ID="rgCourseCatalog" runat="server" AllowSorting="True" AutoGenerateColumns="False" AllowFilteringByColumn="True" DataSourceID="ldsView_CoursesSearchResults" AllowPaging="True" PageSize="8" OnRowDrop="rgCourseCatalog_RowDrop" RenderMode="Lightweight" Skin="Metro">
                                    <GroupingSettings CaseSensitive="false" />
                                    <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                        <ClientEvents OnRowDblClick="RowDblClickNORCO" OnRowSelected="selectedRowNorco"></ClientEvents>
                                    </ClientSettings>
                                    <MasterTableView DataKeyNames="outline_id" CommandItemDisplay="None" DataSourceID="ldsView_CoursesSearchResults" PagerStyle-Mode="NextPrev" PagerStyle-ShowPagerText="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true">
                                        <CommandItemSettings ShowAddNewRecordButton="False" />
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="proposal_id" DataType="System.Int32" FilterControlAltText="Filter proposal_id column" HeaderText="proposal_id" SortExpression="proposal_id" UniqueName="proposal_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="subject_id" DataType="System.Int32" FilterControlAltText="Filter subject_id column" HeaderText="subject_id" SortExpression="subject_id" UniqueName="subject_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="IssuedFormID" DataType="System.Int32" FilterControlAltText="Filter IssuedFormID column" HeaderText="IssuedFormID" SortExpression="IssuedFormID" UniqueName="IssuedFormID" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn UniqueName="subject" DataField="subject" HeaderText="Subject"
                                                HeaderStyle-Width="60px" HeaderTooltip="Drag and Drop the selected course into either Required Courses and/or Restricted Electives data grid.">
                                                <FilterTemplate>
                                                    <telerik:RadComboBox ID="RadComboBoxSubject" DataSourceID="sqlSubjects" DataTextField="subject"
                                                        DataValueField="Subject" Height="200px" Width="60px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                                                        runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged" RenderMode="Lightweight" DropDownAutoWidth="Enabled">
                                                        <Items>
                                                            <telerik:RadComboBoxItem Text="All" />
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                                        <script type="text/javascript">
                                                            function SubjectIndexChanged(sender, args) {
                                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                    tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                                                }
                                                        </script>
                                                    </telerik:RadScriptBlock>
                                                </FilterTemplate>
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Course Number" SortExpression="course_number" UniqueName="course_number" FilterControlWidth="60px" FilterControlToolTip="Search by course number" DataType="System.String" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                                <HeaderStyle Width="60px" />
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title" FilterControlWidth="100px" FilterControlToolTip="Search by course title" DataType="System.String" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                                <%-- COURSE CATALOG --%>
                            </div>
                            <div class="col-md-8">
                                <%-- COURSES FOR THE MAJOR --%>
                                <h2>Required Courses</h2>
                                <telerik:RadGrid ID="rgRequired" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlRequired" AutoGenerateColumns="False" AllowAutomaticUpdates="True" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" OnItemCommand="rgRequired_ItemCommand" OnItemDataBound="rgRequired_ItemDataBound" Width="100%" RenderMode="Lightweight" Skin="Metro">
                                    <ClientSettings EnableAlternatingItems="false">
                                    </ClientSettings>
                                    <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                    <MasterTableView DataKeyNames="programcourse_id" DataSourceID="sqlRequired" EnableNoRecordsTemplate="true" CommandItemDisplay="Top" EditMode="Batch" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false">
                                        <BatchEditingSettings EditType="Row" />
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="programcourse_id" DataType="System.Int32" FilterControlAltText="Filter programcourse_id column" HeaderText="programcourse_id" ReadOnly="True" SortExpression="programcourse_id" UniqueName="programcourse_id" Display="false" HeaderStyle-Width="55px">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridDropDownColumn DataField="condition" DataType="System.Int32" FilterControlAltText="Filter condition column" HeaderText="And/Or" SortExpression="condition" UniqueName="condition" DataSourceID="sqlConditions" ListTextField="ConditionSymbol" ListValueField="id" ColumnEditorID="ceCondition" HeaderStyle-Width="55px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            </telerik:GridDropDownColumn>
                                            <telerik:GridBoundColumn DataField="iorder" DataType="System.Int32" FilterControlAltText="Filter iorder column" HeaderText="iorder" SortExpression="iorder" UniqueName="iorder" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" ReadOnly="true" HeaderStyle-Width="50px" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn HeaderText="Number" UniqueName="cmdOpen" AllowFiltering="false" HeaderStyle-Width="62px" ItemStyle-Width="60px" ReadOnly="true" HeaderStyle-Font-Bold="true">
                                                <ItemTemplate>
                                                    <asp:LinkButton runat="server" CommandName="ViewCourse" ID="btnViewCourse" Text='<%# DataBinder.Eval(Container.DataItem,"course_number")%>' ClientIDMode="Static" />
                                                </ItemTemplate>
                                                <HeaderStyle Width="50px" />
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Number" SortExpression="course_number" UniqueName="course_number" Display="false" ReadOnly="true" HeaderStyle-Width="62px" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title" HeaderStyle-Width="118px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn HeaderStyle-Font-Bold="true">
                                                <HeaderTemplate>
                                                    Course Title  
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:LinkButton runat="server" ToolTip="Have Course Pre-Requisites" CommandName="ShowPreRequisites" ID="btnShowPreRequisites" Text='<i class="fa fa-info-circle" aria-hidden="true"></i>' Visible="false" />
                                                    <asp:LinkButton runat="server" ToolTip="Edit Group Info" CommandName="EditGroupInfo" ID="btnEditGroup" Text='<i class="fa fa-pencil" aria-hidden="true"></i> ' Visible="false" /><%#courseDescription(((GridDataItem) Container)) %>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridBoundColumn DataField="group_desc" FilterControlAltText="Filter group_desc column" HeaderText="group_desc" SortExpression="group_desc" UniqueName="group_desc" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="c_group" FilterControlAltText="Filter c_group column" HeaderText="c_group" SortExpression="c_group" UniqueName="c_group" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="prereq_total" FilterControlAltText="Filter prereq_total column" HeaderText="prereq_total" SortExpression="prereq_total" UniqueName="prereq_total" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridNumericColumn DataField="vunits" DataType="System.Double" FilterControlAltText="Filter vunits column" HeaderText="Units" SortExpression="vunits" UniqueName="vunits" HeaderStyle-Width="60px" MinValue="0" ColumnEditorID="ceUnits" ReadOnly="true" HeaderStyle-Font-Bold="true">
                                            </telerik:GridNumericColumn>
                                            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this course ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                        </Columns>
                                        <NoRecordsTemplate>
                                            <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                                &nbsp;No items to view
                                            </div>
                                        </NoRecordsTemplate>
                                    </MasterTableView>
                                </telerik:RadGrid>
                                <br />
                                <h2>Restricted Elective</h2>
                                <telerik:RadGrid ID="rgRecommended" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlRecommended" AutoGenerateColumns="False" AllowAutomaticUpdates="True" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" OnItemCommand="rgRecommended_ItemCommand" OnItemDataBound="rgRecommended_ItemDataBound" RenderMode="Lightweight" Skin="Metro">
                                    <ClientSettings EnableAlternatingItems="false" />
                                    <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                    <MasterTableView DataKeyNames="programcourse_id" DataSourceID="sqlRecommended" EnableNoRecordsTemplate="true" CommandItemDisplay="Top" EditMode="Batch" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false">
                                        <BatchEditingSettings EditType="Row" />
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="programcourse_id" DataType="System.Int32" FilterControlAltText="Filter programcourse_id column" HeaderText="programcourse_id" ReadOnly="True" SortExpression="programcourse_id" UniqueName="programcourse_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridDropDownColumn DataField="condition" DataType="System.Int32" FilterControlAltText="Filter condition column" HeaderText="And/Or" SortExpression="condition" UniqueName="condition" DataSourceID="sqlConditions" ListTextField="ConditionSymbol" ListValueField="id" ColumnEditorID="ceCondition" HeaderStyle-Width="55px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                            </telerik:GridDropDownColumn>
                                            <telerik:GridBoundColumn DataField="iorder" DataType="System.Int32" FilterControlAltText="Filter iorder column" HeaderText="iorder" SortExpression="iorder" UniqueName="iorder" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" ReadOnly="true" HeaderStyle-Width="50px" HeaderStyle-Font-Bold="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn HeaderText="Number" UniqueName="cmdOpen" AllowFiltering="false" HeaderStyle-Width="62px" ItemStyle-Width="60px" ReadOnly="true" HeaderStyle-Font-Bold="true">
                                                <ItemTemplate>
                                                    <asp:LinkButton runat="server" CommandName="ViewCourse" ID="btnViewCourse" Text='<%# DataBinder.Eval(Container.DataItem,"course_number")%>' ClientIDMode="Static" />
                                                </ItemTemplate>
                                                <HeaderStyle Width="50px" />
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Number" SortExpression="course_number" UniqueName="course_number" Display="false" ReadOnly="true" HeaderStyle-Width="62px">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title" HeaderStyle-Width="118px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn HeaderStyle-Font-Bold="true">
                                                <HeaderTemplate>
                                                    Course Title  
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:LinkButton runat="server" ToolTip="Have Course Pre-Requisites" CommandName="ShowPreRequisites" ID="btnShowPreRequisites" Text='<i class="fa fa-info-circle" aria-hidden="true"></i>' Visible="false" />
                                                    <asp:LinkButton runat="server" ToolTip="Edit Group Info" CommandName="EditGroupInfo" ID="btnEditGroup" Text='<i class="fa fa-pencil" aria-hidden="true"></i>' Visible="false" /><%#courseDescription(((GridDataItem) Container)) %>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridBoundColumn DataField="group_desc" FilterControlAltText="Filter group_desc column" HeaderText="group_desc" SortExpression="group_desc" UniqueName="group_desc" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="c_group" FilterControlAltText="Filter c_group column" HeaderText="c_group" SortExpression="c_group" UniqueName="c_group" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="prereq_total" FilterControlAltText="Filter prereq_total column" HeaderText="prereq_total" SortExpression="prereq_total" UniqueName="prereq_total" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridNumericColumn DataField="vunits" DataType="System.Double" FilterControlAltText="Filter vunits column" HeaderText="Units" SortExpression="vunits" UniqueName="vunits" HeaderStyle-Width="60px" MinValue="0" ColumnEditorID="ceUnits" ReadOnly="true" HeaderStyle-Font-Bold="true">
                                            </telerik:GridNumericColumn>
                                            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this course ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                        </Columns>
                                        <NoRecordsTemplate>
                                            <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                                &nbsp;No items to view
                                            </div>
                                        </NoRecordsTemplate>
                                    </MasterTableView>
                                </telerik:RadGrid>
                                <%-- COURSES FOR THE MAJOR --%>
                            </div>
                        </div>
                    </div>
                </telerik:RadPageView>
                <telerik:RadPageView runat="server" ID="RadPageView2" Width="100%">
                    <div class="row nopadding">
                        <div class="col-md-6">
                            <telerik:RadTabStrip runat="server" ID="RadTabStrip2" AutoPostBack="false" MultiPageID="RadMultiPage2" SelectedIndex="0" ScrollChildren="True" Width="100%" Height="50px" ShowBaseLine="true" CausesValidation="false">
                                <Tabs>
                                    <telerik:RadTab Text="Required Courses" ToolTip="Required Courses" Selected="True"></telerik:RadTab>
                                    <telerik:RadTab Text="Semesters" ToolTip="Semesters"></telerik:RadTab>
                                    <telerik:RadTab Text="Electives/GE" ToolTip="Electives/GE"></telerik:RadTab>
                                    <telerik:RadTab Text="Validation" ToolTip="Validation"></telerik:RadTab>
                                </Tabs>
                            </telerik:RadTabStrip>
                            <telerik:RadMultiPage runat="server" ID="RadMultiPage2" SelectedIndex="0" Width="100%">
                                <telerik:RadPageView runat="server" ID="RadPageView4" Width="100%">
                                    <telerik:RadGrid ID="rgProgramMatrix" runat="server" AllowSorting="false" AutoGenerateColumns="False" AllowFilteringByColumn="True" DataSourceID="sqlProgramMatrix" AllowPaging="false" OnRowDrop="rgProgramMatrix_RowDrop" Skin="Metro">
                                        <GroupingSettings CaseSensitive="false" />
                                        <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                        </ClientSettings>
                                        <MasterTableView DataKeyNames="outline_id" CommandItemDisplay="None" DataSourceID="sqlProgramMatrix">
                                            <CommandItemSettings ShowAddNewRecordButton="False" />
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="subject_id" DataType="System.Int32" FilterControlAltText="Filter subject_id column" HeaderText="subject_id" SortExpression="subject_id" UniqueName="subject_id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="course_type" FilterControlAltText="Filter course_type column" HeaderText="Type" SortExpression="course_type" UniqueName="course_type" FilterControlWidth="80px" FilterControlToolTip="Search by course type" DataType="System.String">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" HeaderStyle-Width="60px" ItemStyle-Width="60px" FilterControlWidth="30px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Course Number" SortExpression="course_number" UniqueName="course_number" FilterControlWidth="30px" FilterControlToolTip="Search by course number" DataType="System.String">
                                                    <HeaderStyle Width="60px" />
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title" FilterControlWidth="100px" FilterControlToolTip="Search by course title" DataType="System.String" Display="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="group_desc" FilterControlAltText="Filter group_desc column" HeaderText="group_desc" SortExpression="group_desc" UniqueName="group_desc" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                                </telerik:GridBoundColumn>

                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                </telerik:RadPageView>
                                <telerik:RadPageView runat="server" ID="RadPageView3" Width="100%">
                                    <telerik:RadGrid ID="rgSemesters" AutoGenerateColumns="false" DataSourceID="sqlSemesters" runat="server" OnRowDrop="rgSemesters_RowDrop" AllowPaging="false" Skin="Metro">
                                        <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                        </ClientSettings>
                                        <MasterTableView DataSourceID="sqlSemesters" AllowPaging="false" ShowHeader="false">
                                            <CommandItemSettings ShowAddNewRecordButton="False" />
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="id" HeaderText="" UniqueName="id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="description" HeaderText="" UniqueName="description" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn UniqueName="description_title">
                                                    <HeaderTemplate>
                                                        Semesters  
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <span style="font-weight: bold;"><%# DataBinder.Eval(Container.DataItem,"description")%></span><br />
                                                        <%# DataBinder.Eval(Container.DataItem,"notes")%>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                </telerik:RadPageView>
                                <telerik:RadPageView ID="RadPageView5" runat="server" Width="100%">
                                    <asp:SqlDataSource ID="sqlElectivesGE" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * from ElectivesGE">
                                    </asp:SqlDataSource>
                                    <telerik:RadGrid ID="rgElectives" runat="server" AllowSorting="false" AutoGenerateColumns="False" AllowFilteringByColumn="True" DataSourceID="sqlElectivesGE" AllowPaging="false" OnRowDrop="rgElectives_RowDrop" Skin="Metro">
                                        <GroupingSettings CaseSensitive="false" />
                                        <ClientSettings AllowRowsDragDrop="True" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                                        </ClientSettings>
                                        <MasterTableView DataKeyNames="id" CommandItemDisplay="None" DataSourceID="sqlElectivesGE">
                                            <CommandItemSettings ShowAddNewRecordButton="False" />
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="id" DataType="System.Int32" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="SubjectCode" FilterControlAltText="Filter SubjectCode column" HeaderText="Subject Code" SortExpression="SubjectCode" UniqueName="SubjectCode" HeaderStyle-Width="60px" ItemStyle-Width="60px" FilterControlWidth="30px">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="CourseNumber" FilterControlAltText="Filter CourseNumber column" HeaderText="Course Number" SortExpression="CourseNumber" UniqueName="CourseNumber" FilterControlWidth="30px" FilterControlToolTip="Search by Course Number" DataType="System.String">
                                                    <HeaderStyle Width="60px" />
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="CourseTitle" FilterControlAltText="Filter CourseTitle column" HeaderText="Course Title" SortExpression="CourseTitle" UniqueName="CourseTitle" FilterControlWidth="100px" FilterControlToolTip="Search by Course Title" DataType="System.String" Display="true">
                                                </telerik:GridBoundColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                </telerik:RadPageView>
                                <telerik:RadPageView ID="RadpageView6" runat="server">
                                    <asp:HiddenField ID="HiddenField1" runat="server" />
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h3>This program map satisfies the following requirements :</h3>
                                        </div>
                                        <div class="col-md-4 text-right">
                                            <telerik:RadButton ID="rbUpdateChecklist" runat="server" Text="Update Validation Checklist" OnClick="rbUpdateChecklist_Click">
                                            </telerik:RadButton>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h4>Deegree Program Checklist</h4>
                                            <telerik:RadListBox ID="rblDeegreeProgramChecklist" runat="server" CheckBoxes="true" DataSourceID="sqlDeegreeProgramChecklist" DataTextField="Description" DataValueField="CheckID" Width="270px">
                                            </telerik:RadListBox>
                                        </div>
                                        <div class="col-md-6">
                                            <h4>CSU Transfer Checklist</h4>
                                            <telerik:RadListBox ID="rblCSUTransferChecklist" runat="server" CheckBoxes="true" DataSourceID="sqlCSUTransferChecklist" DataTextField="Description" DataValueField="CheckID" Width="270px">
                                            </telerik:RadListBox>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <h4>IGETC Transfer Checklist</h4>
                                            <telerik:RadListBox ID="rblIGECTTransferChecklist" runat="server" CheckBoxes="true" DataSourceID="sqlIGECTTransferChecklist" DataTextField="Description" DataValueField="CheckID" Width="270px">
                                            </telerik:RadListBox>
                                        </div>
                                    </div>
                                    <asp:SqlDataSource ID="sqlDeegreeProgramChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from tblLookupChecklist where CheckType  = 1"></asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlCSUTransferChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from tblLookupChecklist where CheckType  = 2"></asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlIGECTTransferChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from tblLookupChecklist where CheckType  = 3"></asp:SqlDataSource>
                                </telerik:RadPageView>
                            </telerik:RadMultiPage>
                        </div>
                        <div class="col-md-6">
                            <h2>Program Schedule</h2>
                            <telerik:RadGrid ID="rgSchedule" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlSchedule" AutoGenerateColumns="False" AllowAutomaticUpdates="True" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" OnItemCommand="rgSchedule_ItemCommand" OnItemDataBound="rgSchedule_ItemDataBound" Skin="Metro">
                                <ClientSettings EnableAlternatingItems="false" />
                                <GroupingSettings CollapseAllTooltip="Collapse all groups" />
                                <MasterTableView DataKeyNames="programcourse_id" DataSourceID="sqlSchedule" EnableNoRecordsTemplate="true" CommandItemDisplay="Top" EditMode="Batch" CommandItemSettings-ShowAddNewRecordButton="false" ShowGroupFooter="false">
                                    <BatchEditingSettings EditType="Row" />
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="programcourse_id" DataType="System.Int32" FilterControlAltText="Filter programcourse_id column" HeaderText="programcourse_id" ReadOnly="True" SortExpression="programcourse_id" UniqueName="programcourse_id" Display="false" HeaderStyle-Width="55px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="outline_id" DataType="System.Int32" FilterControlAltText="Filter outline_id column" HeaderText="outline_id" SortExpression="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="required" DataType="System.Int32" FilterControlAltText="Filter required column" HeaderText="required" SortExpression="required" UniqueName="required" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="group_total" DataType="System.Int32" FilterControlAltText="Filter group_total column" HeaderText="group_total" SortExpression="group_total" UniqueName="group_total" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="iorder" DataType="System.Int32" FilterControlAltText="Filter iorder column" HeaderText="iorder" SortExpression="iorder" UniqueName="iorder" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="subject" FilterControlAltText="Filter subject column" HeaderText="Subject" SortExpression="subject" UniqueName="subject" ReadOnly="true" HeaderStyle-Width="50px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn HeaderText="Number" UniqueName="cmdOpen" AllowFiltering="false" HeaderStyle-Width="60px" ItemStyle-Width="60px" ReadOnly="true">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" CommandName="ViewCourse" ID="btnViewCourse" Text='<%# DataBinder.Eval(Container.DataItem,"course_number")%>' ClientIDMode="Static" />
                                            </ItemTemplate>
                                            <HeaderStyle Width="50px" />
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="course_number" FilterControlAltText="Filter course_number column" HeaderText="Number" SortExpression="course_number" UniqueName="course_number" Display="false" ReadOnly="true" HeaderStyle-Width="60px">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="course_title" FilterControlAltText="Filter course_title column" HeaderText="Title" SortExpression="course_title" UniqueName="course_title" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn UniqueName="description_title">
                                            <HeaderTemplate>
                                                Title  
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#courseDescription(((GridDataItem) Container)) %>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn DataField="group_desc" FilterControlAltText="Filter group_desc column" HeaderText="group_desc" SortExpression="group_desc" UniqueName="group_desc" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="c_group" FilterControlAltText="Filter c_group column" HeaderText="c_group" SortExpression="c_group" UniqueName="c_group" HeaderStyle-Width="120px" ItemStyle-Wrap="true" ReadOnly="true" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridNumericColumn DataField="vunits" DataType="System.Double" FilterControlAltText="Filter vunits column" HeaderText="Units" SortExpression="vunits" UniqueName="vunits" HeaderStyle-Width="60px" MinValue="0" ColumnEditorID="ceUnits" ReadOnly="true">
                                        </telerik:GridNumericColumn>
                                        <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this course ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                    </Columns>
                                    <NoRecordsTemplate>
                                        <div style="height: 30px; cursor: pointer; line-height: 30px;">
                                            &nbsp;No items to view
                                        </div>
                                    </NoRecordsTemplate>
                                </MasterTableView>
                            </telerik:RadGrid>
                        </div>
                    </div>
                </telerik:RadPageView>
            </telerik:RadMultiPage>

            <telerik:GridDropDownListColumnEditor ID="ceCondition" runat="server" DropDownStyle-Width="45px" DropDownStyle-Height="60px"></telerik:GridDropDownListColumnEditor>
            <telerik:GridNumericColumnEditor ID="ceUnits" runat="server" NumericTextBox-IncrementSettings-InterceptMouseWheel="false" NumericTextBox-IncrementSettings-InterceptArrowKeys="false" NumericTextBox-Width="50px">
            </telerik:GridNumericColumnEditor>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
        <asp:SqlDataSource ID="sqlSemesters" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM tblLookupSemesters"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlProgramMatrix" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * from View_ProgramMatrix   WHERE ([program_id] = @program_id and [required] <> @required and outline_id not in ( SELECT outline_id from View_ProgramMatrix   WHERE [program_id] = @program_id and [required] = @required )) order by required, iorder">
            <SelectParameters>
                <asp:Parameter Name="required" DefaultValue="3" Type="Int32" />
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT DISTINCT s.subject FROM  Course_IssuedForm cif INNER JOIN tblSubjects s ON cif.subject_id = s.subject_id WHERE (cif.status = 0) AND (cif.college_id = @CollegeID) and s.college_id=@CollegeID ORDER BY s.subject">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlConditions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM tblLookupConditions"></asp:SqlDataSource>
        <asp:SqlDataSource ID="ldsView_CoursesSearchResults" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from (SELECT 0 sorder, a.outline_id, a.subject_id, a.division_id, a.department_id, a.course_number, a.course_title, a.IssuedFormID, a.college_id, b.subject FROM Course_IssuedForm AS a INNER JOIN tblSubjects AS b ON a.subject_id = b.subject_id where a.college_id = @CollegeID  and status = 0 ) as available_courses  order by subject, course_number">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" type="Int32" />
        </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlRequired" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [tblProgramCourses] WHERE [programcourse_id] = @programcourse_id" SelectCommand="select * from View_ProgramMatrix   WHERE ([program_id] = @program_id and [required] = @required) ORDER BY iorder" UpdateCommand="UPDATE [tblProgramCourses] SET [condition] = @condition WHERE [programcourse_id] = @programcourse_id">
            <DeleteParameters>
                <asp:Parameter Name="programcourse_id" Type="Int32" />
            </DeleteParameters>
            <SelectParameters>
                <asp:Parameter Name="required" DefaultValue="1" Type="Int32" />
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="condition" Type="Int32" />
                <asp:Parameter Name="programcourse_id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlRecommended" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [tblProgramCourses] WHERE [programcourse_id] = @programcourse_id" SelectCommand="select * from View_ProgramMatrix   WHERE ([program_id] = @program_id and [required] = @required) ORDER BY iorder" UpdateCommand="UPDATE [tblProgramCourses] SET [condition] = @condition WHERE [programcourse_id] = @programcourse_id">
            <DeleteParameters>
                <asp:Parameter Name="programcourse_id" Type="Int32" />
            </DeleteParameters>
            <SelectParameters>
                <asp:Parameter Name="required" DefaultValue="2" Type="Int32" />
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="condition" Type="Int32" />
                <asp:Parameter Name="programcourse_id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlOthers" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [tblProgramCourses] WHERE [programcourse_id] = @programcourse_id" SelectCommand="select * from View_ProgramMatrix   WHERE   ([program_id] = @program_id and [required] = @required ) ORDER BY iorder" UpdateCommand="UPDATE [tblProgramCourses] SET [condition] = @condition WHERE [programcourse_id] = @programcourse_id">
            <DeleteParameters>
                <asp:Parameter Name="programcourse_id" Type="Int32" />
            </DeleteParameters>
            <SelectParameters>
                <asp:Parameter Name="required" DefaultValue="2" Type="Int32" />
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="condition" Type="Int32" />
                <asp:Parameter Name="programcourse_id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlSchedule" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [tblProgramCourses] WHERE [programcourse_id] = @programcourse_id" SelectCommand="select * from View_ProgramMatrix   WHERE   ([program_id] = @program_id and [required] = @required ) ORDER BY iorder" UpdateCommand="UPDATE [tblProgramCourses] SET [vunits] = @vunits WHERE [programcourse_id] = @programcourse_id">
            <DeleteParameters>
                <asp:Parameter Name="programcourse_id" Type="Int32" />
            </DeleteParameters>
            <SelectParameters>
                <asp:Parameter Name="required" DefaultValue="3" Type="Int32" />
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="vunits" Type="Double" />
                <asp:Parameter Name="programcourse_id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>

    </form>
    <!-- jQuery -->
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="<%= this.ResolveUrl("~/Common/js/main.js") %>"></script>
    <script>
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function ShowGroupInfo(programcourse_id) {
            var oWindow = window.radopen("GroupInfo.aspx?ProgramCourseID=" + programcourse_id, null);
            oWindow.setSize(400, 300);
            oWindow.center();
            oWindow.set_visibleStatusbar(false);
        }
        function ShowCourseInfo(outline_id) {
            var oWindow = window.radopen("ShowCourseDetail.aspx?outline_id=" + outline_id, null);
            oWindow.setSize(900, 600);
            oWindow.center();
            oWindow.set_visibleStatusbar(false);
        }

        function selectedRowNorco(sender, eventArgs) {
            var item = eventArgs.get_item();
            var cell = item.get_cell("outline_id");
            var value = $telerik.$(cell).text().trim();
            var cellTitle = item.get_cell("course_title");
            var valueTitle = $telerik.$(cellTitle).text().trim();
            document.getElementById('selectedRowValue').value = value;
            document.getElementById('selectedCourseTitle').value = valueTitle;
        }
    </script>
</body>
</html>

