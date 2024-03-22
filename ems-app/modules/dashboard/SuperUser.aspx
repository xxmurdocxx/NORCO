<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="SuperUser.aspx.cs" Inherits="ems_app.modules.dashboard.SuperUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .viewWrap {
    padding: 5px;
    background: url(Img/metal.png) repeat;
    -moz-box-shadow: inset 0 0px 5px rgba(41,51,58,0.5);
    -webkit-box-shadow: inset 0 0px 5px rgba(41,51,58,0.5);
    box-shadow: inset 0 0px 5px rgba(41,51,58,0.5);
}
 
.contactWrap {
    padding: 5px 0;
    color: #333;
    width:100%;
}
 
    .contactWrap td {
        padding: 0 5px 0 0;
        font-size: 10px;
        border-style: none !important;
        border-width: 0 0 0 0 !important;
    }

 
.template img {
    margin:0 5px;
    float:left;
    border-radius:100%;
}
 
.template{
    overflow:hidden;
}
 
    .template .title {
        font-weight:bold;
        text-align:right;
    }
 
div.RadListView {
    border:none;
}
        .RadGrid_Material .rgFooter, .RadGrid_Material .rgFooter a {
            color:black !important;
            background-color:lightgray !important;
        }
    </style>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="appTitle" id="SystemTitle" runat="server">College Statistics</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    

    <asp:SqlDataSource ID="sqlCollegeList" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" runat="server" SelectCommandType="StoredProcedure" SelectCommand="GetSuperUserCollegeList">
        <SelectParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlArticulationCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetArticulationCourses" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter Name="Username" SessionField="UserName" Type="String" />
            <asp:SessionParameter Name="RoleID" SessionField="RoleID" Type="Int32" />
            <asp:Parameter Name="OrderBy" Type="String" DefaultValue="0" />
            <asp:Parameter Name="StageFilter" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
        SelectCommand="SELECT productId = 1">
    </asp:SqlDataSource>

    <h2>Welcome <asp:Label runat="server" ID="lblUserName"></asp:Label>!<br />
    Please select a college to view.</h2>
    <asp:Label ID="lblError" runat="server" Visible="false" ForeColor="Red"></asp:Label>
    <telerik:RadGrid RenderMode="Lightweight" ID="rgCollegeList" runat="server" DataSourceID="sqlCollegeList" AllowPaging="true" AllowSorting="true" AllowFilteringByColumn="true" Width="100%" AutoGenerateColumns="false" PageSize="20" ShowGroupPanel="true" AllowMultiRowSelection="true" OnPreRender="rgCollegeList_PreRender">
        <GroupingSettings CollapseAllTooltip="Collapse all groups" CaseSensitive="False" RetainGroupFootersVisibility="true" ShowUnGroupButton="true"></GroupingSettings>
        <ExportSettings FileName="CollegeDistrictContacts" ExportOnlyData="True" IgnorePaging="True">
        </ExportSettings>
        <ClientSettings AllowColumnsReorder="true" ReorderColumnsOnClient="true">
            <Selecting AllowRowSelect="true" />
            <Resizing AllowRowResize="True" EnableRealTimeResize="True" ResizeGridOnColumnResize="True" AllowColumnResize="True"></Resizing>
        </ClientSettings>
        <HeaderStyle BackColor="#8BC34A" ForeColor="#FFFFFF"  />
        <ItemStyle BackColor="#ffffff" Font-Bold="true" CssClass="RadGrid_TopLine"  />
        <AlternatingItemStyle Font-Bold="true" BackColor="#ffffff" CssClass="RadGrid_TopLine" />
        <MasterTableView CommandItemDisplay="Top" DataKeyNames="CollegeID,College,CollegeLogo" AllowFilteringByColumn="true" AllowMultiColumnSorting="true" HierarchyDefaultExpanded="false" HierarchyLoadMode="ServerBind" CommandItemSettings-AddNewRecordText="false" EnableHeaderContextMenu="true" ShowFooter="true" FooterStyle-Font-Bold="true">
		<ColumnGroups>
                 <telerik:GridColumnGroup HeaderText="Articulated" Name="ARTICULATED" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                        <HeaderStyle Font-Bold="True" HorizontalAlign="Center" />
                 </telerik:GridColumnGroup>
                <telerik:GridColumnGroup HeaderText="Credit Awarded" Name="AWARDED" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                        <HeaderStyle Font-Bold="True" HorizontalAlign="Center" />
                 </telerik:GridColumnGroup>
            </ColumnGroups>
            <PagerStyle Mode="NextPrevNumericAndAdvanced" Position="Bottom" PageSizeControlType="RadComboBox" AlwaysVisible="true" />
            <CommandItemSettings ShowAddNewRecordButton="False" ShowExportToExcelButton="True" />
            <NestedViewTemplate>
                <asp:Panel runat="server" ID="InnerContainer" CssClass="viewWrap">
                    <telerik:RadTabStrip RenderMode="Lightweight" runat="server" ID="TabStip1" MultiPageID="Multipage1" SelectedIndex="0">
                        <Tabs>
                            <telerik:RadTab runat="server" Text="Contact Information" PageViewID="PageView1">
                            </telerik:RadTab>
                            <telerik:RadTab runat="server" Text="Statistics" PageViewID="PageView2">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage runat="server" ID="Multipage1" SelectedIndex="0" RenderSelectedPageOnly="false">
                        <telerik:RadPageView runat="server" ID="PageView1" Height="116px">
                            <asp:Label ID="lblCollege" Font-Bold="true" Font-Italic="true" Text='<%# Eval("College") %>'
                                Visible="false" runat="server"></asp:Label>
                            <telerik:RadListView runat="server" ID="RadListView" DataSourceID="sqlContacts" ItemPlaceholderID="ContactsContainer"  >
                                <LayoutTemplate>
                                    <div class="contactWrap RadListView">
                                        <asp:PlaceHolder ID="ContactsContainer" runat="server"></asp:PlaceHolder>
                                    </div>
                                </LayoutTemplate>
                                <ItemTemplate>
                                    <div class="template">
                                        <table cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="title" width="7%">Ambassador:</td>
                                                <td width="10%"><%# Eval("LEAD_MANAGER") %></td>
                                                <td class="title" width="10%">Lead Evaluator:</td>
                                                <td width="10%"><%# Eval("LEAD_EVALUATOR") %></td>
                                                <td class="title" width="10%">Faculty Lead:</td>
                                                <td width="10%"><%# Eval("FACULTY_LEAD") %></td>
                                                <td class="title" width="10%">School Certifying Official:</td>
                                                <td width="10%"><%# Eval("SCHOOL_CERTIFYING_OFFICIAL") %></td>
                                            </tr>
                                            <tr>
                                                
                                                <td class="title">Ambassador Email:</td>
                                                <td><%# Eval("LEAD_MANAGER_EMAIL") %></td>
                                                <td class="title">Lead Evaluator Email:</td>
                                                <td><%# Eval("LEAD_EVALUATOR_EMAIL") %></td>
                                                <td class="title">Faculty Lead Email:</td>
                                                <td><%# Eval("FACULTY_LEAD_EMAIL") %></td>
                                                <td class="title">School Certifying Official Email:</td>
                                                <td><%# Eval("VETERAN_SCHOOL_CERTIFYING_OFFICIAL_EMAIL") %></td>
                                            </tr>
                                            <tr>
                                                <td class="title"></td>
                                                <td></td>
                                                <td class="title">Articulation Officer:</td>
                                                <td><%# Eval("ARTICULATION_OFFICER") %></td>
                                                <td class="title">Primary Contact:</td>
                                                <td><%# Eval("PRIMARY_CONTACT") %></td>
                                                <td class="title">Veteran Rep:</td>
                                                <td><%# Eval("VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION") %></td>
                                            </tr>
                                            <tr>
                                                
                                                <td class="title"></td>
                                                <td></td>
                                                <td class="title">Articulation Officer Email:</td>
                                                <td><%# Eval("ARTICULATION_OFFICER_EMAIL") %></td>
                                                <td class="title">Primary Contact Email:</td>
                                                <td><%# Eval("PRIMARY_CONTACT_EMAIL") %></td>
                                                <td class="title">Veteran Rep Email:</td>
                                                <td><%# Eval("VRC_OFFICIAL_FROM_MAP_COHOERT_APPLICATION_EMAIL") %></td>
                                            </tr>
                                            <tr>
                                                <td class="title">College President:</td>
                                                <td><%# Eval("CEO") %></td>  
                                                <td class="title">Academic Senate President:</td>
                                                <td><%# Eval("ACADEMIC_SENATE_PRESIDENT") %></td>
                                                <td class="title">Curriculum Specialist:</td>
                                                <td><%# Eval("IT_CONTACT") %></td>
                                                <td class="title">VPAA:</td>
                                                <td><%# Eval("VPAA") %></td>
                                            </tr>
                                            <tr>
                                                
                                                <td class="title">College President Email:</td>
                                                <td><%# Eval("CEO_EMAIL") %></td>
                                                <td class="title">Acedemic Senate President Email:</td>
                                                <td><%# Eval("ACADEMIC_SENATE_PRESIDENT_EMAIL") %></td>
                                                <td class="title">Curriculum Specialist Email:</td>
                                                <td><%# Eval("IT_CONTACT_EMAIL") %></td>
                                                <td class="title">VPAA Email:</td>
                                                <td><%# Eval("VPAA_EMAIL") %></td>
                                            </tr>
                                        </table>
                                    </div>
                                </ItemTemplate>
                            </telerik:RadListView>
                            <asp:SqlDataSource ID="sqlContacts" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommandType="StoredProcedure" SelectCommand="GetMAPCohort">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="lblCollege" PropertyName="Text" Type="String" Name="CollegeName"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="PageView2">
                            <telerik:RadHtmlChart runat="server" ID="PieChart1" Height="160px" Width="420px" DataSourceID="SqlDataSource5" Transitions="false">
                                <Appearance>
                                    <FillStyle BackgroundColor="Transparent" />
                                </Appearance>
                                <ChartTitle Text="College Statistics for 2022">
                                    <Appearance Align="Center" Position="Top">
                                        <TextStyle Margin="0 0 20 0" />
                                    </Appearance>
                                </ChartTitle>
                                <Legend>
                                    <Appearance Position="Right" Visible="true">
                                    </Appearance>
                                </Legend>
                                <PlotArea>
                                    <Series>
                                        <telerik:PieSeries StartAngle="90" DataFieldY="spentMoney" NameField="pName">
                                            <LabelsAppearance Position="OutsideEnd">
                                            </LabelsAppearance>
                                        </telerik:PieSeries>
                                    </Series>
                                </PlotArea>
                            </telerik:RadHtmlChart>
                            
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </asp:Panel>
            </NestedViewTemplate>
            <Columns>
                <telerik:GridTemplateColumn HeaderStyle-Width="30px" AllowFiltering="false">
                    <ItemTemplate>
                        <asp:LinkButton ID="lbtnGoToCollege3" title="Go To College" runat="server" OnClick="lbtnGoToCollege_Click"><i class="fa fa-external-link fa-lg"></i>
                        </asp:LinkButton>
                        <%--<asp:Label runat="server" ID="lblCollegeCoursesLoaded" Text="<i class='fa fa-check fa-lg' style='color:green'></i>" ToolTip="College courses loaded" CssClass="ms-2" Visible='<%# Eval("CollegeCoursesLoaded") %>' />--%>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn DataField="College"  HeaderText="College" HeaderStyle-Width="20%" FilterControlWidth="120" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderStyle-HorizontalAlign="Center" FooterText="COHORT Totals">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DISTRICT" HeaderText="District" HeaderStyle-Width="20%" FilterControlWidth="120" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="PRIMARY_CONTACT" HeaderText="Ambassador" HeaderStyle-Width="10%" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="LEAD_EVALUATOR" HeaderText="Lead Evaluator" HeaderStyle-Width="10%" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="FACULTY_LEAD" HeaderText="Lead Faculty" HeaderStyle-Width="10%" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="VeteranCount" HeaderText="Students" HeaderStyle-Width="7%" FilterControlWidth="38" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false" AllowFiltering="false" ItemStyle-HorizontalAlign="Center" Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationCount" HeaderText="College Courses" HeaderStyle-Width="7%" FilterControlWidth="38" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false"  HeaderStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderTooltip="Course(s) that have been Articulated with one or more Credit Recommendations" ColumnGroupName="ARTICULATED"  ItemStyle-HorizontalAlign="Center" Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationsPendingComnpletion" HeaderText="College Courses Pending Completion" HeaderStyle-Width="9%" FilterControlWidth="40" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderTooltip="Course that are Pending Articulation with one or more Credit Recommendations" ColumnGroupName="ARTICULATED"  ItemStyle-HorizontalAlign="Center" Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulatedCreditRecommendations" HeaderText="Credit Recommendations" HeaderStyle-Width="11%" FilterControlWidth="40" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderTooltip="Unique Articulated Credit Recommendations that are Fully Approved" ColumnGroupName="ARTICULATED"  ItemStyle-HorizontalAlign="Center" Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="CreditRecommendationsPendingCompletion" HeaderText="Credit Recommendations Pending Completion" HeaderStyle-Width="11%" FilterControlWidth="40" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderTooltip="Unique Credit Recommendations that are Pending Approval" ColumnGroupName="ARTICULATED"  ItemStyle-HorizontalAlign="Center" Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulatedOccupationsCourses" HeaderText="Exhibit IDs" HeaderStyle-Width="9%" FilterControlWidth="40" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderTooltip="Unique ACE Occupations/ACE Courses that have been Articulated" ColumnGroupName="ARTICULATED"  ItemStyle-HorizontalAlign="Center" Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="DeniedArticulationCount" HeaderText="Denied Articulations" HeaderStyle-Width="9%" FilterControlWidth="40" CurrentFilterFunction="EqualTo" AutoPostBackOnFilter="true" ShowFilterIcon="false" HeaderStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderTooltip="Denied Articulations" ColumnGroupName="ARTICULATED"  ItemStyle-HorizontalAlign="Center" Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center" >
                </telerik:GridBoundColumn>                
                <%--<telerik:GridBoundColumn DataField="StudentsAwardedUnitsCount" HeaderText="Articulated Credit Recommendations" HeaderStyle-Width="7%" FilterControlWidth="40" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="StudentsAwardedUnitsCount" HeaderText="Articulations Pending Completion" HeaderStyle-Width="7%" FilterControlWidth="40" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false">
                </telerik:GridBoundColumn>--%>
                <telerik:GridBoundColumn DataField="StudentsAwardedUnitsCount" HeaderText="Students Awarded" HeaderStyle-Width="7%" FilterControlWidth="40" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false" display="false">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="TotalUnitsAwardedCount" HeaderText="Total Units Awarded" FilterControlWidth="40" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ShowFilterIcon="false" Display="false" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="StudentsAwarded" HeaderText="Students Awarded" DataField="StudentsAwarded" UniqueName="StudentsAwarded" AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ShowSortIcon="true" AllowSorting="true" ColumnGroupName="AWARDED"  Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="AverageUnitsAwarded" HeaderText="Average Credits" DataField="AverageUnitsAwarded" UniqueName="AverageUnitsAwarded" AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ShowSortIcon="true" AllowSorting="true" ColumnGroupName="AWARDED"  Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="TotalUnitsAwarded" HeaderText="Total MAP Credits" DataField="TotalUnitsAwarded" UniqueName="TotalUnitsAwarded" AllowFiltering="false" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ShowSortIcon="true" AllowSorting="true" ColumnGroupName="AWARDED" Aggregate="Sum" FooterAggregateFormatString="{0:### ##0}" FooterStyle-HorizontalAlign="Center" >
                </telerik:GridBoundColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
    </script>
</asp:Content>