<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CourseEdit.ascx.cs" Inherits="ems_app.UserControls.CourseEdit" %>
<style>
    .rbShowOptions {
        padding: 5px !important;
        margin: 5px 0 !important;
    }
</style>
<asp:SqlDataSource ID="sqlCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetAmbassadorCourseList" SelectCommandType="StoredProcedure" >
    <SelectParameters>
        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        <asp:Parameter Name="FilterStatus" Type="Int32" DefaultValue="-1" />
    </SelectParameters>
    <InsertParameters>
        <asp:Parameter Name="subject_id" Type="Int32"></asp:Parameter>
        <asp:Parameter Name="course_number" Type="String"></asp:Parameter>
        <asp:Parameter Name="course_title" Type="String"></asp:Parameter>
        <asp:Parameter Name="unit_id" Type="Int32"></asp:Parameter>
        <asp:Parameter Name="comments" Type="String"></asp:Parameter>
        <asp:SessionParameter Name="college_id" SessionField="CollegeID" Type="Int32" />
        <asp:SessionParameter Name="author_user_id" SessionField="UserID" Type="Int32" />
        <asp:Parameter Name="CatalogDescription" Type="String"></asp:Parameter>
        <asp:Parameter Name="topscode_id" Type="Int32"></asp:Parameter>
    </InsertParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlSubject" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="spAmbassadorSubjectsListByCollege" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        <asp:Parameter Name="FilterStatus" Type="Int32" DefaultValue="-1" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT unit_id, cast(unit as decimal(18,2)) unit FROM tblLookupUnits where college_id = 1 ORDER BY cast(unit as decimal(18,2))" SelectCommandType="Text">
</asp:SqlDataSource>
<asp:SqlDataSource ID="sqlTopsCode" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT topscode_id, Program_Title FROM tblTOPSCodeLookup WHERE college_id = 1 ORDER BY Program_Title" SelectCommandType="Text">
    <SelectParameters>
        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:Panel runat="server" ID="pnlError" Visible="false" CssClass="alert alert-danger">
    <pre style="white-space:pre-wrap"><asp:Label runat="server" ID="lblError"></asp:Label></pre>
</asp:Panel>

Show:
<asp:RadioButton runat="server" ID="radCourseFilterAll" GroupName="radCourseFilter" Text="All Courses" AutoPostBack="true" OnCheckedChanged="radCourseFilter_CheckedChanged" Checked="true" CssClass="rbShowOptions" />
<asp:RadioButton runat="server" ID="radCourseFilterOfficial" GroupName="radCourseFilter" Text="Official Courses" AutoPostBack="true" OnCheckedChanged="radCourseFilter_CheckedChanged" CssClass="rbShowOptions"/>
<asp:RadioButton runat="server" ID="radCourseFilterElective" GroupName="radCourseFilter" Text="Elective Courses" AutoPostBack="true" OnCheckedChanged="radCourseFilter_CheckedChanged" CssClass="rbShowOptions" />
<asp:RadioButton runat="server" ID="radCourseFilterAreaCredit" GroupName="radCourseFilter" Text="Area Credit" AutoPostBack="true" OnCheckedChanged="radCourseFilter_CheckedChanged" CssClass="rbShowOptions"/>
<telerik:RadGrid ID="rgCourses" runat="server" CellSpacing="-1" DataSourceID="sqlCourses" Width="100%" PageSize="40" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" AllowFilteringByColumn="false" AllowAutomaticUpdates="true" AllowAutomaticInserts="true" OnBatchEditCommand="rgCourses_BatchEditCommand" OnItemDataBound="rgCourses_ItemDataBound" >
    <GroupingSettings CaseSensitive="false" />
    <ExportSettings IgnorePaging="true" ExportOnlyData="true">
    </ExportSettings>
    <ClientSettings AllowKeyboardNavigation="true">
        <Selecting AllowRowSelect="True" />
        <Scrolling AllowScroll="True" UseStaticHeaders="True"></Scrolling>
        <ClientEvents OnBatchEditOpening="rgCourses_OnBatchEditOpening" />
    </ClientSettings>
    <MasterTableView AutoGenerateColumns="False" DataKeyNames="outline_id,status,CourseType" ClientDataKeyNames="status,CourseType" DataSourceID="sqlCourses" CommandItemDisplay="Top" PageSize="40" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel" EditMode="Batch" >
        <NoRecordsTemplate>
            <p>No records to display</p>
        </NoRecordsTemplate>
        <BatchEditingSettings EditType="Cell" />
        <Columns>
            <telerik:GridDropDownColumn SortExpression="subject" HeaderText="Subject" DataField="subject_id" UniqueName="subject_id" HeaderStyle-Width="110px" HeaderStyle-Font-Bold="true" DataSourceID="sqlSubject" ListTextField="subject" ListValueField="subject_id" ColumnValidationSettings-EnableRequiredFieldValidation="true" ColumnValidationSettings-RequiredFieldValidator-ErrorMessage="*Required" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red">
            </telerik:GridDropDownColumn>
            <telerik:GridBoundColumn SortExpression="course_number" HeaderText="Course Number" DataField="course_number" UniqueName="course_number" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" HeaderTooltip="Dept. # (CB01A)" ColumnValidationSettings-EnableRequiredFieldValidation="true" ColumnValidationSettings-RequiredFieldValidator-ErrorMessage="*Required" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn SortExpression="course_title" HeaderText="Course Title" DataField="course_title" UniqueName="course_title" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true" HeaderTooltip="Title (CB02)" ColumnValidationSettings-EnableRequiredFieldValidation="true" ColumnValidationSettings-RequiredFieldValidator-ErrorMessage="*Required" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red">
            </telerik:GridBoundColumn>
            <telerik:GridDropDownColumn SortExpression="Units" HeaderText="Units" DataField="unit_id" DataType="System.Double" UniqueName="unit_id" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" DataSourceID="sqlUnits" ListTextField="unit" ListValueField="unit_id" ColumnValidationSettings-EnableRequiredFieldValidation="true" ColumnValidationSettings-RequiredFieldValidator-ErrorMessage="*Required" ColumnValidationSettings-RequiredFieldValidator-ForeColor="Red">
            </telerik:GridDropDownColumn>
            <telerik:GridBoundColumn SortExpression="CatalogDescription" HeaderText="Catalog Description" DataField="CatalogDescription" UniqueName="CatalogDescription" HeaderStyle-Width="300px" HeaderStyle-Font-Bold="true">
            </telerik:GridBoundColumn>
            <telerik:GridDropDownColumn SortExpression="TopsCode" HeaderText="TOP Code" DataField="topscode_id" UniqueName="topscode_id" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true" HeaderTooltip="TOP Code" DataSourceID="sqlTopsCode" ListTextField="Program_Title" ListValueField="topscode_id">
            </telerik:GridDropDownColumn>
            <telerik:GridBoundColumn SortExpression="comments" HeaderText="Comments" DataField="comments" UniqueName="comments" HeaderStyle-Width="300px" HeaderStyle-Font-Bold="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn  DataField="CourseType" UniqueName="CourseType" Display="false" >
            </telerik:GridBoundColumn>
        </Columns>
    </MasterTableView>
</telerik:RadGrid>

<script type="text/javascript">
    function rgCourses_OnBatchEditOpening(sender, args) {
        var item = args.get_row().control;
        if (item.get_itemIndex() < 0) {
            // this is a new row; all items should be editable
            return;
        }

        var dataItem = $find("<%=rgCourses.ClientID%>").get_masterTableView().get_dataItems()[item.get_itemIndex()];
        var courseStatus = dataItem.getDataKeyValue("status");
        var courseType = dataItem.getDataKeyValue("CourseType");
        // get the unique name of the column
        var columnName = args.get_columnUniqueName();

        if (courseStatus == 0) {
            if (columnName == "subject_id") {
                args.set_cancel(true);
            }
            else if (columnName == "course_number") {
                args.set_cancel(true);
            }
            else if (columnName == "course_title") {
                args.set_cancel(true);
            }
            else if (columnName == "unit_id" && courseType == "1") {
                args.set_cancel(true);
            }
            else if (columnName == "topscode_id") {
                args.set_cancel(true);
            }
            else if (columnName == "comments") {
                args.set_cancel(true);
            }
        }
    }

    
</script>