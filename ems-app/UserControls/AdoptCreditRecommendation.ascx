<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AdoptCreditRecommendation.ascx.cs" Inherits="ems_app.UserControls.AdoptCreditRecommendation" %>
<%@ Register Src="~/UserControls/DisplayMessages.ascx" TagPrefix="uc" TagName="DisplayMessages" %>
<style>
    .height-fit-content {
        height: fit-content !important;
    }
</style>
<asp:HiddenField ID="hvUserName" runat="server" />
<asp:HiddenField ID="hvUserID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hvCollegeID" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hvUserStage" runat="server" />
<asp:HiddenField ID="hvUserStageOrder" runat="server" />
<asp:HiddenField ID="hfExcludeArticulationOverYears" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfOnlyImplemented" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfBySubjectCourseCIDNumber" runat="server" ClientIDMode="Static" />
<asp:HiddenField ID="hfCreditRecommendation" runat="server" />
<asp:HiddenField ID="hfAceID" runat="server" />

<telerik:RadWindowManager ID="RadWindowManagerAdopt" EnableViewState="false" CssClass="height-fit-content" runat="server" RenderMode="Classic" Behaviors="Move, Close, Maximize, Pin"></telerik:RadWindowManager>
<telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server">
</telerik:RadWindowManager>
<telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager2" runat="server">
</telerik:RadWindowManager>
<uc:DisplayMessages ID="DisplayMessagesControl" runat="server"></uc:DisplayMessages>
<asp:SqlDataSource ID="sqlSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s where s.college_id = @CollegeID order by s.subject">
    <SelectParameters>
        <asp:Parameter Name="CollegeID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlColleges" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LookupColleges INNER JOIN MAPCohort ON COLLEGE = COLLEGE_NAME where CollegeId <> @CollegeID order by College">
    <SelectParameters>
        <asp:Parameter Name="CollegeID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlAllSubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select s.subject_id, s.subject from tblSubjects s  order by s.subject"></asp:SqlDataSource>
<asp:SqlDataSource ID="sqlOtherCollegeArticulations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetAdoptByCreditRecommendations" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
    <SelectParameters>
        <asp:Parameter Name="CollegeID" Type="Int32" />
        <asp:Parameter Name="ExcludeArticulationOverYears" Type="Int32" />
        <asp:Parameter Name="OnlyImplemented" Type="Boolean" />
        <asp:Parameter Name="BySubjectCourseNumberorCIDNumber" Type="Boolean" />
        <asp:Parameter Name="ShowAll" Type="Boolean" DefaultValue="True" />
        <asp:Parameter Name="CreditRecommendation" Type="String" DefaultValue="" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="AceIDs" Type="String" DefaultValue="" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct r.RoleName from Stages s left outer join ROLES  r on s.RoleId = r.RoleID"></asp:SqlDataSource>
<div  style="display:flex; justify-content:start; align-items:center;">
    <h2 style="width:200px;" ><b>Adopt Articulations </b></h2><span id="hh2AdoptArticulations" runat="server" style="display:inline-block; font-size: 14px !important;"><i class='fa fa-info-circle'></i></span>
</div>

<telerik:RadToolTip ManualClose="true" ID="rttAdoptArticulations" TargetControlID="hh2AdoptArticulations" runat="server" Text="The Adopt Articulations feature allows MAP Evaluators to assume ownership of the articulations that have been made at other colleges. Once the adoption takes place, you will be able to tailor the adopted articulations. These adoptions will be finalized through your approval queue." Width="500px">
</telerik:RadToolTip>
<div class="row">
    <div class="col-sm-5">
        <telerik:RadComboBox ID="cboCriteria" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="200" DropDownHeight="200" DataSourceID="sqlCriteria" DataTextField="selectedcriteria" EmptyMessage="Search by credit recommendation(s)" DataValueField="selectedcriteria" ClientIDMode="Static" AllowCustomEntry="false" HighlightFirstMatch="true" Delimiter="," AutoPostBack="false" ToolTip="Search Credit Recommendations within the Adoption Module." CssClass="acbCriteria" BackColor="#ffffe0" CheckBoxes="true" AllowCustomText="true"></telerik:RadComboBox>
        <%--<telerik:RadAutoCompleteBox ID="racbCriteria" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="200" DropDownHeight="200" DataSourceID="sqlCriteria" DataTextField="selectedcriteria" EmptyMessage="Search by credit recommendation(s)" DataValueField="selectedcriteria" ClientIDMode="Static" AllowCustomEntry="false" HighlightFirstMatch="true" Delimiter="," AutoPostBack="true" ToolTip="Search one or more credit recommendation(s)" CssClass="acbCriteria" BackColor="#ffffe0"></telerik:RadAutoCompleteBox>--%>
        <asp:SqlDataSource ID="sqlCriteria" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetAdoptByCreditRecommendationsCriteria" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
            <SelectParameters>
                <asp:Parameter Name="CollegeID" Type="Int32" />
                <asp:Parameter Name="ExcludeArticulationOverYears" Type="Int32" />
                <asp:Parameter Name="OnlyImplemented" Type="Boolean" />
                <asp:Parameter Name="BySubjectCourseNumberorCIDNumber" Type="Boolean" />
                <asp:Parameter Name="ShowAll" Type="Boolean" DefaultValue="True" />
                <asp:Parameter Name="CreditRecommendation" Type="String" DefaultValue="" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="AceIDs" Type="String" DefaultValue="" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
        <br />
        <telerik:RadComboBox ID="cboAdvancedSearch" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="200" DropDownHeight="200" DataSourceID="sqlAdvancedSearch" DataTextField="FullDescription" EmptyMessage="Search by Exhibit ID(s) or Exhibit Titles within the Adoption Module." DataValueField="AceID" ClientIDMode="Static" AllowCustomEntry="false" HighlightFirstMatch="true" Delimiter="|" AutoPostBack="false" ToolTip="Search Exhibit ID's or Exhibit Titles within the Adoption Module." CssClass="acbCriteria" BackColor="#ffffe0" CheckBoxes="true" AllowCustomText="true" ></telerik:RadComboBox>
        <%--<telerik:RadAutoCompleteBox ID="racbAdvancedSearch" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="200" DropDownHeight="200" DataSourceID="sqlAdvancedSearch" DataTextField="FullDescription" EmptyMessage="Search by Exhibit ID(s) or keyword(s)" DataValueField="AceID" ClientIDMode="Static" AllowCustomEntry="false" HighlightFirstMatch="true" Delimiter="|" AutoPostBack="true" ToolTip="" CssClass="acbCriteria" BackColor="#ffffe0"></telerik:RadAutoCompleteBox>--%>
        <asp:SqlDataSource runat="server" ID="sqlAdvancedSearch" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="GetAdoptByCreditRecommendationsACEID" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:Parameter Name="CollegeID" Type="Int32" />
                <asp:Parameter Name="ExcludeArticulationOverYears" Type="Int32" />
                <asp:Parameter Name="OnlyImplemented" Type="Boolean" />
                <asp:Parameter Name="BySubjectCourseNumberorCIDNumber" Type="Boolean" />
                <asp:Parameter Name="ShowAll" Type="Boolean" DefaultValue="True" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div class="col-sm-5">
        <telerik:RadCheckBox ID="rchkExcludeOverYears" AutoPostBack="true" runat="server" CausesValidation="false" Text=" Exclude articulations over " OnCheckedChanged="rchkExcludeOverYears_CheckedChanged" ToolTip="This filter removes articulations older than 25 years from the user’s view."></telerik:RadCheckBox>
        <telerik:RadCheckBox ID="rchkOnlyImplemented" AutoPostBack="true" runat="server" CausesValidation="false" Text=" Show Approved Articulations Only" OnCheckedChanged="rchkOnlyImplemented_CheckedChanged" Checked="true" ToolTip="This filter only shows articulations that have been approved."></telerik:RadCheckBox>
        <telerik:RadCheckBox ID="rchkSubjectCourseCIDNumber" AutoPostBack="true" runat="server" CausesValidation="false" Text=" Show Only Courses with C-ID" OnCheckedChanged="rchkSubjectCourseCIDNumber_CheckedChanged" ToolTip="This option only allows viewing of articulations associated with courses that have a C-ID (Course Identification Numbering System)"></telerik:RadCheckBox>
        <telerik:RadCheckBox ID="rchkShowAll" AutoPostBack="true" runat="server" CausesValidation="false" Text=" Show all articulations from other colleges" OnCheckedChanged="rchkShowAll_CheckedChanged" Visible="false" Checked="true"></telerik:RadCheckBox>
    </div>

    <div class="col-sm-2">
        <br />
        <div style="display: flex; align-items: end; justify-content: center;">
            <telerik:RadButton ID="rbSearch" runat="server" Text="Search" Width="80px" Primary="true" AutoPostBack="true" OnClick="rbSearch_Click"></telerik:RadButton>
            <telerik:RadButton ID="rbClear" runat="server" Text="Reset" Width="60px" OnClick="rbClear_Click" CausesValidation="false" AutoPostBack="true"></telerik:RadButton>
        </div>

    </div>
</div>

<div style="clear: both;"></div>
<telerik:RadWindowManager ID="RadWindowManagerAdp" EnableViewState="false" runat="server" CssClass="height-fit-content" OnClientClose="closeRadWindow"></telerik:RadWindowManager>
<div class="row" style="display:flex;justify-content:end;">
    <div style="margin:10px;">
        <telerik:RadButton ID="btnExcel" runat="server" Text=" Export" ButtonType="StandardButton" OnClick="btnExcel_Click" ToolTip="Click here to export to Excel">
            <ContentTemplate>
                <i class='fa fa-file-excel-o'></i> Export to Excel
            </ContentTemplate>
        </telerik:RadButton>        
    </div>
</div>
<telerik:RadGrid ID="rgOtherCollegeArticulations" runat="server" AllowFilteringByColumn="true" AllowPaging="true" PageSize="50" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlOtherCollegeArticulations" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true" Width="100%" RenderMode="Lightweight" AllowMultiRowSelection="true" OnItemCommand="rgOtherCollegeArticulations_ItemCommand" OnItemDataBound="rgOtherCollegeArticulations_ItemDataBound" MasterTableView-NoMasterRecordsText="There are no articulations ready to adopt from other colleges based on your search criteria. Please review your search options." Height="680px" GroupHeaderItemStyle-Font-Bold="true" EnableGroupsExpandAll="true"  MasterTableView-AllowMultiColumnSorting="true" GroupingSettings-ExpandAllTooltip="Click to expand/collapse all credit recommendation and articulation details" HierarchySettings-ExpandAllTooltip="Click to expand/collapse college course articulation details." ShowFooter="true" ItemStyle-BackColor="LightGray">
    <GroupingSettings CaseSensitive="false" />
    <PagerStyle PagerTextFormat="{4} {3} Articulations in {0} of {1} pages" />
    <ExportSettings ExportOnlyData="true" IgnorePaging="true" OpenInNewWindow="true" Excel-Format="Html">
    </ExportSettings>
    <ClientSettings AllowColumnsReorder="true">
        <Selecting AllowRowSelect="True" EnableDragToSelectRows="true" />
        <ClientEvents  OnFilterMenuShowing="FilterMenuShowing" />
        <Scrolling AllowScroll="true" UseStaticHeaders="true" />
        <Resizing AllowColumnResize="true" ResizeGridOnColumnResize="true" AllowResizeToFit="true" />
    </ClientSettings>
    <MasterTableView Name="ParentGrid" DataSourceID="sqlOtherCollegeArticulations" CommandItemDisplay="Bottom" HierarchyLoadMode="Client" HierarchyDefaultExpanded="false" GroupsDefaultExpanded="false" GroupLoadMode="Client" >
        <CommandItemTemplate>
            <div class="commandItems text-right" style="margin: 5px !important;">
                <telerik:RadButton runat="server" ID="btnAddOccupation" ToolTip="Check to adopt selected articulations." CommandName="Adopt" Text=" Adopt selected articulations" ButtonType="LinkButton" Primary="true">
                    <ContentTemplate>
                        <i class="fa fa-clone"></i>Review / Adopt selected articulations
                    </ContentTemplate>
                </telerik:RadButton>
                <telerik:RadButton runat="server" ID="btnView" Visible="false" ToolTip="Check to view selected articulation." CommandName="View" Text=" View selected articulations" ButtonType="LinkButton">
                    <ContentTemplate>
                        <i class="fa fa-eye"></i>View articulations
                    </ContentTemplate>
                </telerik:RadButton>
            </div>
        </CommandItemTemplate>
        <CommandItemSettings ShowExportToExcelButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
        <GroupByExpressions>
            <telerik:GridGroupByExpression>
                <SelectFields>
                    <telerik:GridGroupByField FieldAlias="SelectedCriteria" FieldName="SelectedCriteria"></telerik:GridGroupByField>
                </SelectFields>
                <GroupByFields>
                    <telerik:GridGroupByField FieldName="SelectedCriteria" SortOrder="Ascending"></telerik:GridGroupByField>
                </GroupByFields>
            </telerik:GridGroupByExpression>
        </GroupByExpressions>
        <Columns>
            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px" Visible="false" Exportable="false">
                <ItemTemplate>
                    <asp:LinkButton runat="server" ToolTip="View Articulation Details" CommandName="View" ID="ViewArticulation" Text='<i class="fa fa-eye fa-lg" aria-hidden="true"></i>' />
                </ItemTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn" HeaderStyle-Width="30px" ItemStyle-BackColor="#f4f7f8" Exportable="false">
            </telerik:GridClientSelectColumn>
            <telerik:GridBoundColumn DataField="CourseCollege" UniqueName="CourseCollege" HeaderText="College Course" HeaderStyle-Width="220px" FilterControlToolTip="Filter by College Course" FilterControlWidth="100px"  AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="true" HeaderStyle-Font-Bold="true" ItemStyle-BackColor="#f4f7f8" ItemStyle-Font-Bold="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="CIDNumber" HeaderText="C-ID Number" DataField="CIDNumber" UniqueName="CIDNumber" HeaderStyle-Font-Bold="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" HeaderTooltip="Filter by Course Identification Numbering System (C-ID)" FilterControlToolTip="Filter by Course Identification Numbering System (C-ID)">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="Descriptor" HeaderText="C-ID Title" DataField="Descriptor" UniqueName="Descriptor" HeaderStyle-Font-Bold="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" FilterControlWidth="100px" FilterControlToolTip="Filter by C-ID Title">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="subject" UniqueName="subject" HeaderText="Subject" HeaderStyle-Width="80px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="true" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center">
            </telerik:GridBoundColumn>
            <%--  <telerik:GridDropDownColumn DataSourceID="sqlSubjects" ListTextField="subject" ListValueField="subject" UniqueName="subject_filter" SortExpression="subject" HeaderText="Subject" DataField="subject" AllowFiltering="true" ItemStyle-Font-Bold="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center">
                <FilterTemplate>
                    <telerik:RadComboBox ID="RadComboBoxSubjects" DataSourceID="sqlSubjects" DataTextField="subject" DropDownAutoWidth="Enabled"  
                        DataValueField="subject" MaxHeight="200px" Width="80px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("subject").CurrentFilterValue %>'
                        runat="server" OnClientSelectedIndexChanged="SubjectIndexChanged">
                        <Items>
                            <telerik:RadComboBoxItem Text="All" />
                        </Items>
                    </telerik:RadComboBox>
                    <telerik:RadScriptBlock ID="RadScriptBlock2332" runat="server">
                        <script type="text/javascript">
                            function SubjectIndexChanged(sender, args) {
                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                tableView.filter("subject", args.get_item().get_value(), "EqualTo");
                            }
                        </script>
                    </telerik:RadScriptBlock>
                </FilterTemplate>
            </telerik:GridDropDownColumn>--%>
            <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course #" HeaderStyle-Width="80px" FilterControlWidth="40px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true" AllowFiltering="true" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="course_title" UniqueName="course_title" HeaderText="Course Title" FilterControlWidth="100px" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" HeaderStyle-Font-Bold="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="TopCode" HeaderText="TOP Code" DataField="TopCode" UniqueName="TopCode" HeaderStyle-Font-Bold="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" FilterControlWidth="100px">
            </telerik:GridBoundColumn>


            <%-- Lines 159-176 Commented out on 3/16/22 per Beto's latest updates --%>
            <%-- <telerik:GridDropDownColumn DataSourceID="sqlColleges" ListTextField="College" ListValueField="College" UniqueName="college_filter" SortExpression="College" HeaderText="College" DataField="College" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true">
                <FilterTemplate>
                    <telerik:RadComboBox ID="RadComboBoxColleges" DataSourceID="sqlColleges" DataTextField="College" DropDownAutoWidth="Enabled"  
                        DataValueField="College" MaxHeight="200px" Width="170px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("College").CurrentFilterValue %>'
                        runat="server" OnClientSelectedIndexChanged="CollegeIndexChanged">
                        <Items>
                            <telerik:RadComboBoxItem Text="All" />
                        </Items>
                    </telerik:RadComboBox>
                    <telerik:RadScriptBlock ID="RadScriptBlock187681" runat="server">
                        <script type="text/javascript">
                            function CollegeIndexChanged(sender, args) {
                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                tableView.filter("College", args.get_item().get_value(), "EqualTo");
                            }
                        </script>
                    </telerik:RadScriptBlock>
                </FilterTemplate>
            </telerik:GridDropDownColumn>--%>
            <telerik:GridDropDownColumn DataSourceID="sqlColleges" ListTextField="College" ListValueField="College" UniqueName="college_filter" SortExpression="College" HeaderText="College" DataField="College" AllowFiltering="true" ItemStyle-Font-Size="15px" HeaderStyle-Width="180px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                <FilterTemplate>
                    <telerik:RadComboBox ID="RadComboBoxColleges" DataSourceID="sqlColleges" DataTextField="College" DropDownAutoWidth="Enabled"
                        DataValueField="College" MaxHeight="200px" Width="170px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("College").CurrentFilterValue %>'
                        runat="server" OnClientSelectedIndexChanged="CollegeIndexChanged">
                        <Items>
                            <telerik:RadComboBoxItem Text="All" />
                        </Items>
                    </telerik:RadComboBox>
                    <telerik:RadScriptBlock ID="RadScriptBlock187681" runat="server">
                        <script type="text/javascript">
                            function CollegeIndexChanged(sender, args) {
                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                tableView.filter("College", args.get_item().get_value(), "EqualTo");
                            }
                        </script>
                    </telerik:RadScriptBlock>
                </FilterTemplate>
            </telerik:GridDropDownColumn>
            <telerik:GridBoundColumn SortExpression="ArticulationsCount" HeaderText="Articulated Exhibits" DataField="ArticulationsCount" UniqueName="ArticulationsCount" HeaderStyle-Font-Bold="true" ShowFilterIcon="false" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" AllowFiltering="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Aggregate="Sum" FooterAggregateFormatString="Total Exhibits :{0}">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="SelectedCriteria" HeaderText="Credit Recommendation" DataField="SelectedCriteria" UniqueName="SelectedCriteria" AllowFiltering="false" ReadOnly="true" ItemStyle-Font-Bold="true" HeaderStyle-Font-Bold="true" HeaderStyle-Width="200px" Display="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="CollegeID" UniqueName="CollegeID" Display="false" Exportable="false">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false">
            </telerik:GridBoundColumn>

            <telerik:GridBoundColumn DataField="College" UniqueName="College" Display="false" Exportable="false">
            </telerik:GridBoundColumn>
        </Columns>
        <NestedViewTemplate>
            <asp:Label ID="lblSelectedCriteria" Font-Bold="true" Font-Italic="true" Text='<%# Eval("SelectedCriteria") %>' Visible="false" runat="server"></asp:Label>
            <asp:Label ID="lblOutlineID" Font-Bold="true" Font-Italic="true" Text='<%# Eval("outline_id") %>' Visible="false" runat="server"></asp:Label>
            <asp:SqlDataSource runat="server" ID="sqlArticulations" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT x.id, x.ExhibitID, x.LastSubmittedOn as LastSubmitted, case when x.ArticulationType = 1 then 'ACE Course' else 'Occupation' end as 'ArticulationTypeName', x.ArticulationID,  x.AceID, x.Exhibit, x.StartDate, x.EndDate, concat(cast(FORMAT(x.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(x.EndDate, 'MM/yy') as varchar(7))) AS 'ExhibitDate', x.Title, x.TeamRevd, x.CreatedOn, x.Occupation , x.outline_id, x.ArticulationType, x.ArticulationStatus, x.ArticulationStage ,    x.ArticulationType as 'articulation_type', x.ArticulationStatus as 'status_id', x.ArticulationStage as 'stage_id',  x.ModifiedBy, x.Articulate, x.CollegeID, x.FullName, x.[Order] as sorder, case when x.[Order] = 1 then 'Evaluator' when x.[Order] = 2 then 'Faculty' when x.[Order] = 3 then 'Articulation Officer' else 'Implemented' end as Stage, x.SelectedCriteria FROM ( SELECT A.*, concat(mu.firstname , ', ' , mu.lastname) as 'FullName' , st.[Order], cc.Exhibit, cc.StartDate, cc.EndDate, concat(cast(FORMAT(cc.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(cc.EndDate, 'MM/yy') as varchar(7))) AS 'ExhibitDate', cc.Occupation , ISNULL(aec.Criteria,'Articulations without Credit Recommendations') AS SelectedCriteria FROM articulation a join AceExhibitCriteria AEC on a.CriteriaID = aec.CriteriaID JOIN course_issuedform c ON a.outline_id = c.outline_id JOIN tblsubjects s ON c.subject_id = s.subject_id LEFT OUTER JOIN (SELECT s1.subject, c1.course_number FROM course_issuedform c1 JOIN tblsubjects s1 ON c1.subject_id = s1.subject_id WHERE c1.college_id = @CollegeID AND c1.status = 0) nc ON s.subject = nc.subject AND c.course_number = nc.course_number JOIN stages st ON a.articulationstage = st.id LEFT OUTER JOIN (SELECT issuedformid, propertyvalue AS CIDNumber FROM issuedformproperties WHERE propertyname = 'CIDnumber') CID ON C.issuedformid = CID.issuedformid LEFT OUTER JOIN AceExhibit cc on a.ExhibitID = cc.ID LEFT OUTER JOIN tblusers u on a.CreatedBy = u.userid LEFT OUTER JOIN TBLUSERS mu on a.LastSubmittedBy = mu.UserID WHERE a.articulate = 1 AND c.status = 0 AND a.outline_id = @outline_id AND a.collegeid <> @CollegeID AND dbo.Checkarticulationexistincollege(@CollegeID, s.subject, c.course_number, a.aceid, a.teamrevd) = 0 AND a.teamrevd > Dateadd(year, -@ExcludeArticulationOverYears, dbo.Returnpstdate(Getdate())) AND ( ( @OnlyImplemented = 0 AND st.[order] IN ( 1, 2, 3, 4 ) ) OR ( @OnlyImplemented = 1 AND st.[order] = 4 ) ) AND ( ( @BySubjectCourseNumberorCIDNumber = 0 AND ( cid.cidnumber IS NOT NULL OR cid.cidnumber IS NULL ) ) OR ( @BySubjectCourseNumberorCIDNumber = 1 AND cid.cidnumber IS NOT NULL ) )  ) x WHERE x.SelectedCriteria = @SelectedCriteria">
                <SelectParameters>
                    <asp:SessionParameter SessionField="CollegeID" Name="CollegeID" Type="Int32" DefaultValue="" />
                    <asp:ControlParameter ControlID="lblOutlineID" Name="outline_id" Type="Int32" PropertyName="Text" DefaultValue="" />
                    <asp:ControlParameter ControlID="lblSelectedCriteria" Name="SelectedCriteria" PropertyName="Text" Type="String" DefaultValue="" />
                    <asp:ControlParameter ControlID="hfExcludeArticulationOverYears" Name="ExcludeArticulationOverYears" PropertyName="Value" Type="Int32" />
                    <asp:ControlParameter ControlID="rchkSubjectCourseCIDNumber" Name="BySubjectCourseNumberorCIDNumber" PropertyName="Checked" Type="Boolean" />
                    <asp:ControlParameter ControlID="rchkOnlyImplemented" Name="OnlyImplemented" PropertyName="Checked  " Type="Boolean" />
                </SelectParameters>
            </asp:SqlDataSource>
            <telerik:RadGrid ID="rgArticulations" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlArticulations" AllowFilteringByColumn="false" AllowPaging="False" GroupingSettings-CaseSensitive="false" RenderMode="Lightweight" AllowMultiRowSelection="true" Width="100%" OnItemDataBound="rgArticulations_ItemDataBound">
                <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false" EnableAlternatingItems="false">
                    <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                    <ClientEvents OnRowDblClick="RowDblClickHighlightCriteria" />
                </ClientSettings>
                <MasterTableView Name="ParentGrid" DataSourceID="sqlArticulations" PageSize="8" CommandItemDisplay="none" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" HeaderStyle-Font-Bold="true" DataKeyNames="id" ItemStyle-BackColor="#f1f1f1" AlternatingItemStyle-BackColor="#f1f1f1">
                    <Columns>
                        <telerik:GridBoundColumn SortExpression="id" DataField="id" UniqueName="id" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn SortExpression="ExhibitID" DataField="ExhibitID" UniqueName="ExhibitID" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ArticulationTypeName" UniqueName="ArticulationTypeName" HeaderText="Type" AllowFiltering="false" HeaderStyle-Width="100px">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" HeaderStyle-Width="120px" FilterControlWidth="80px" AllowFiltering="false" HeaderTooltip="Double click to view ACE Exhibit details for this articulation" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderStyle-Width="120px" UniqueName="AceExhibitLink" HeaderText="ACE ID" SortExpression="AceID" HeaderTooltip="Double click to view ACE Exhibit details for this articulation" FilterControlWidth="80px" AllowFiltering="false">
                            <ItemTemplate>
                                <asp:HyperLink NavigateUrl="javascript:showExhibitInfo();" runat="server" ID="hlAceExhibit" Text="" Font-Underline="true"></asp:HyperLink>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="EntityType" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="SelectedCriteria" UniqueName="SelectedCriteria" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridDateTimeColumn DataField="StartDate" UniqueName="StartDate" Display="false" DataFormatString="{0:MM/dd/yyyy}" />
                        <telerik:GridDateTimeColumn DataField="EndDate" UniqueName="EndDate" Display="false" DataFormatString="{0:MM/dd/yyyy}" />
                        <telerik:GridBoundColumn DataField="ExhibitDate" HeaderStyle-Width="100px" HeaderText="Exhibit Date" AllowFiltering="false" SortExpression="ExhibitDate" UniqueName="ExhibitDate" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" EnableHeaderContextMenu="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridDateTimeColumn DataField="TeamRevd" DataType="System.DateTime" FilterControlAltText="Filter TeamRevd column" HeaderText="TeamRevd Date" SortExpression="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" AutoPostBackOnFilter="true" PickerType="DatePicker" FilterControlWidth="110px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" AllowFiltering="false">
                            <ItemStyle HorizontalAlign="Center" />
                        </telerik:GridDateTimeColumn>
                        <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="false" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" ShowFilterIcon="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false" Display="false">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn UniqueName="ExhibitLink" HeaderText="Title" SortExpression="Title" >
                            <ItemTemplate>
                                <asp:HyperLink NavigateUrl="javascript:showExhibitInfo();" runat="server" ID="hlExhibit" Text="" Font-Underline="true"></asp:HyperLink>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn> 
                        <telerik:GridBoundColumn SortExpression="Stage" HeaderText="Stage" DataField="Stage" UniqueName="Stage" AutoPostBackOnFilter="true" ShowFilterIcon="true" CurrentFilterFunction="Contains" AllowFiltering="false">
                        </telerik:GridBoundColumn> 
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
        </NestedViewTemplate>
    </MasterTableView>
</telerik:RadGrid>

<input type="hidden" id="hvOutlineID" name="hvOutlineID" runat="server" />
<input type="hidden" id="hvSelectedCriteria" name="hvSelectedCriteria" runat="server" />

<telerik:RadContextMenu ID="rcmAdoptArticulations" runat="server" OnItemClick="rcmAdoptArticulations_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
    <Items>
        <telerik:RadMenuItem Text="Adopt" Value="Adopt">
        </telerik:RadMenuItem>
        <telerik:RadMenuItem Text="View Articulations" Value="View">
        </telerik:RadMenuItem>
    </Items>
</telerik:RadContextMenu>
<script type="text/javascript">
    function GridRowClickEventHandler(sender, args) {
        var menu = $find('<%= rcmAdoptArticulations.ClientID %>');

        var evt = args.get_domEvent();
        if (evt.target.tagName == "INPUT" || evt.target.tagName == "A") {
            return;
        }

        var index = args.get_itemIndexHierarchical();

        sender.get_masterTableView().selectItem(sender.get_masterTableView().get_dataItems()[index].get_element(), true);

        var selectedRow = sender.get_masterTableView().get_selectedItems()[0];

        var outline_id = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "outline_id").innerHTML;
        var selected_criteria = sender.get_masterTableView().getCellByColumnUniqueName(selectedRow, "SelectedCriteria").innerHTML;

        document.getElementById("<%= hvOutlineID.ClientID %>").value = outline_id;
        document.getElementById("<%= hvSelectedCriteria.ClientID %>").value = selected_criteria;

        menu.show(evt);
        evt.cancelBubble = true;
        evt.returnValue = false;

        if (evt.stopPropagation) {
            evt.stopPropagation();
            evt.preventDefault();
        }
    }
    
</script>
