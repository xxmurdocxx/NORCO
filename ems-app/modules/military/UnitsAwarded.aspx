<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="UnitsAwarded.aspx.cs" Inherits="ems_app.modules.military.UnitsAwarded" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Veteran Units Awarded</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct ua.program_id, ua.program from View_UnitsAwarded ua left outer join Program_IssuedForm pif on ua.program_id = pif.program_id where ua.college_id = @CollegeID and pif.status = 0 order by ua.program">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlChildPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct program_id, program from View_UnitsAwarded where college_id = @CollegeID and coalesce(program_id,'0') IN (select value from fn_split(@Program,','))">
        <SelectParameters>
            <asp:Parameter DbType="String" Name="Program" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlChildCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select DISTINCT program_id, outline_id, CourseTitle from View_UnitsAwarded where college_id = @CollegeID and program_id = @program_id">
        <SelectParameters>
            <asp:Parameter DbType="Int32" Name="program_id" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlChildOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select DISTINCT program_id, outline_id, Occupation, Title, Exhibit from View_UnitsAwarded where college_id = @CollegeID and program_id = @program_id and outline_id = @outline_id">
        <SelectParameters>
            <asp:Parameter DbType="Int32" Name="program_id" />
            <asp:Parameter DbType="Int32" Name="outline_id" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlChildVeterans" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct program_id, outline_id, Occupation, Title, AceID, TeamRevd, Exhibit, LeadID, VeteranID, Veteran, vunits, LeadID, email from View_UnitsAwarded where college_id = @CollegeID and program_id = @program_id and outline_id = @outline_id ">
        <SelectParameters>
            <asp:Parameter DbType="Int32" Name="program_id" />
            <asp:Parameter DbType="Int32" Name="outline_id" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <div class="container-fluid">
            <div class="row" style="margin: 0 0 10px 0;">
                <div class="col-md-2" style="margin-top: 5px; font-weight: bold;">
                    Program(s) of Study : 
                </div>
                <div class="col-md-10">
                    <telerik:RadComboBox ID="rcbPrograms" runat="server" DataSourceID="sqlPrograms" DataTextField="program" DataValueField="program_id" AutoPostBack="true" CheckBoxes="true" Width="500px" AppendDataBoundItems="true" EnableCheckAllItemsCheckBox="true" AllowCustomText="true" Filter="Contains" OnPreRender="rcbPrograms_PreRender" OnSelectedIndexChanged="rcbPrograms_SelectedIndexChanged" RenderMode="Lightweight" ToolTip="Program(s) of Study with Articulated and Published Courses.">
                    </telerik:RadComboBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <telerik:RadGrid ID="rgUnitsAwarded" runat="server" AllowFilteringByColumn="True" AllowPaging="true" AllowSorting="True" Culture="es-ES" DataSourceID="sqlChildPrograms" Width="100%" GroupingSettings-CaseSensitive="false" OnItemDataBound="rgUnitsAwarded_ItemDataBound" OnItemCommand="rgUnitsAwarded_ItemCommand" RenderMode="Lightweight" EnableHeaderContextAggregatesMenu="True" HeaderStyle-HorizontalAlign="Center">
                        <GroupingSettings CollapseAllTooltip="Collapse all groups" RetainGroupFootersVisibility="true" />
                        <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="true">
                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                        </ClientSettings>
                        <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlChildPrograms" EnableNoRecordsTemplate="true" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemDisplay="None" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Font-Bold="true" GroupHeaderItemStyle-Font-Size="X-Small" DataKeyNames="program_id" GroupHeaderItemStyle-Font-Bold="true">
                            <DetailTables>
                                <telerik:GridTableView Name="ChildGridCourses" EnableHierarchyExpandAll="false" DataSourceID="sqlChildCourses" Width="100%" runat="server" DataKeyNames="program_id,outline_id" AllowFilteringByColumn="false" AutoGenerateColumns="false">
                                    <ParentTableRelation>
                                        <telerik:GridRelationFields DetailKeyField="program_id" MasterKeyField="program_id"></telerik:GridRelationFields>
                                    </ParentTableRelation>
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="CourseTitle" UniqueName="CourseTitle" FilterControlAltText="Filter CourseTitle column" HeaderText="Course Title" SortExpression="CourseTitle" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="140px" HeaderStyle-Font-Bold="true">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                    <DetailTables>
                                        <telerik:GridTableView Name="ChildGridOccupations" EnableHierarchyExpandAll="false" DataSourceID="sqlChildOccupations" Width="100%" runat="server" DataKeyNames="program_id,outline_id,Exhibit" AllowFilteringByColumn="false"  AutoGenerateColumns="false">
                                            <ParentTableRelation>
                                                <telerik:GridRelationFields DetailKeyField="program_id" MasterKeyField="program_id"></telerik:GridRelationFields>
                                                <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                            </ParentTableRelation>
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="program_id" UniqueName="program_id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="AceID" FilterControlAltText="Filter AceID column" HeaderText="ACE ID" SortExpression="AceID" UniqueName="AceID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="60px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Exhibit" FilterControlAltText="Filter Exhibit column" HeaderText="Version (Exhibit)" SortExpression="Exhibit" UniqueName="Exhibit" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="60px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Occupation" UniqueName="Occupation" FilterControlAltText="Filter Occupation column" HeaderText="Occupation" SortExpression="Occupation" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="140px" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="Title" UniqueName="Title" FilterControlAltText="Filter Title column" HeaderText="Title" SortExpression="Title" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="140px" HeaderStyle-Font-Bold="true">
                                                </telerik:GridBoundColumn>
                                            </Columns>
                                            <DetailTables>
                                                <telerik:GridTableView Name="ChildGridVeterans" EnableHierarchyExpandAll="false" DataSourceID="sqlChildVeterans" Width="100%" runat="server" DataKeyNames="LeadId" AllowFilteringByColumn="false"  AutoGenerateColumns="false">
                                                    <ParentTableRelation>
                                                        <telerik:GridRelationFields DetailKeyField="program_id" MasterKeyField="program_id"></telerik:GridRelationFields>
                                                        <telerik:GridRelationFields DetailKeyField="outline_id" MasterKeyField="outline_id"></telerik:GridRelationFields>
                                                    </ParentTableRelation>
                                                    <Columns>
                                                        <telerik:GridTemplateColumn HeaderStyle-Width="40px" AllowFiltering="false">
                                                            <ItemTemplate>
                                                                <asp:LinkButton runat="server" ToolTip="Edit this lead." CommandName="EditLead" ID="btnEditLead" Text='<i class="fa fa-tasks" aria-hidden="true"></i>' />
                                                            </ItemTemplate>
                                                        </telerik:GridTemplateColumn>
                                                        <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="25px" ItemStyle-HorizontalAlign="Center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton runat="server" ToolTip="Print Veteran Letter" CommandName="PrintVeteranLetter" ID="btnPrintVeteranLetter" Text='<i class="fa fa-print" aria-hidden="true"></i>' />
                                                            </ItemTemplate>
                                                        </telerik:GridTemplateColumn>
                                                        <telerik:GridTemplateColumn HeaderStyle-Width="30px" AllowFiltering="false">
                                                            <ItemTemplate>
                                                                <asp:LinkButton runat="server" ToolTip="Send Veteran Letter" CommandName="EmailLetter" ID="btnEmailLetter" Text='<i class="fa fa-envelope" aria-hidden="true" ></i>' />
                                                            </ItemTemplate>
                                                        </telerik:GridTemplateColumn>
                                                        <telerik:GridTemplateColumn HeaderStyle-Width="30px" AllowFiltering="false">
                                                            <ItemTemplate>
                                                                <asp:LinkButton runat="server" ToolTip="View Phone Script" CommandName="PhoneScript" ID="btnPhoneScript" Text='<i class="fa fa-volume-control-phone" aria-hidden="true" ></i>' />
                                                            </ItemTemplate>
                                                        </telerik:GridTemplateColumn>
                                                        <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="program_id" UniqueName="program_id" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="VeteranID" UniqueName="VeteranID" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="LeadID" UniqueName="LeadID" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="email" UniqueName="email" Display="false">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="Veteran" UniqueName="Veteran" FilterControlAltText="Filter Veteran column" HeaderText="Veteran" SortExpression="Veteran" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="120px" HeaderStyle-Font-Bold="true" FilterControlToolTip="Filter by last name, first name">
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="vunits" FilterControlAltText="Filter vunits column" HeaderText="Units" SortExpression="vunits" UniqueName="vunits" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="30px" ShowFilterIcon="true" HeaderStyle-Font-Bold="true">
                                                        </telerik:GridBoundColumn>
                                                    </Columns>
                                                </telerik:GridTableView>
                                            </DetailTables>
                                        </telerik:GridTableView>

                                    </DetailTables>
                                </telerik:GridTableView>
                            </DetailTables>
                            <Columns>
                                <telerik:GridBoundColumn DataField="program_id" UniqueName="program_id" Display="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Program" UniqueName="Program" FilterControlAltText="Filter Program column" HeaderText="Program" SortExpression="Program" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" FilterControlWidth="140px" HeaderStyle-Font-Bold="true">
                                </telerik:GridBoundColumn>
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
        </div>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
