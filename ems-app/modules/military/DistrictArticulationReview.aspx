<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="DistrictArticulationReview.aspx.cs" Inherits="ems_app.modules.military.DistrictArticulationReview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style type="text/css">
    .selectedrow, .rgSelectedRow, .RadGrid_Bootstrap .rgPagerCell .rgNumPart a.rgCurrentPage, .RadGrid_Bootstrap .rgMasterTable .rgSelectedCell, .RadGrid_Bootstrap .rgSelectedRow td, .RadGrid_Bootstrap td.rgEditRow .rgSelectedRow, .RadGrid_Bootstrap .rgSelectedRow td.rgSorted  
    {  
        background-color:none !important; 
        background: None !important;  
    }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Faculty District Articulation Review</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlFacultyDistrictReview" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select [dbo].[GetFacultyStatusOtherColleges] ( fd.AceID, fd.TeamRevd, fd.CollegeID, fd.subject, fd.course_number, fd.articulationtype, fd.occupation ) as StatusDescription, fd.[id] ,fd.[Subject] ,fd.[course_number] ,fd.[AceID] ,fd.[TeamRevd] ,isnull(fd.[ArticulationID],0) ArticulationID ,fd.[ArticulationType] ,fd.[IsSource] ,fd.[VoteTypeID] ,fd.[UserID] ,fd.[VotedOn] ,fd.[Occupation] ,fd.[Title] ,fd.[CollegeID] ,fd.[outline_id], v.Description as VoteType, concat(u.FirstName,' ',u.LastName) as 'FullName' from FacultyDistrictReview fd left outer join tblLookupVoteType v on fd.VoteTypeID = v.id left outer join TBLUSERS u on fd.UserID = u.UserID left outer join View_MostCurrentOccupation cc on fd.AceID = cc.ACeID and fd.TeamRevd = cc.TeamRevd where fd.CollegeID = @CollegeID and fd.Subject in (select s.subject from UserSubjects us left outer join tblSubjects s on us.SubjectID = s.subject_id where UserID = @UserID)" UpdateCommand="update FacultyDistrictReview set VoteTypeID = @VoteTypeID, Reason = @Reason, UserID = @UserID, @VotedOn = getdate() where ID = @ID">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="VoteTypeID" Type="Int32" />
            <asp:Parameter Name="ID" Type="Int32" />
            <asp:Parameter Name="Reason" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlArticulationType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 1 as id, 'Course' as description union select 2 as id , 'Occupation' as description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlVoteType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from tblLookupVoteType"></asp:SqlDataSource>

    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart">
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default" AutoCloseDelay="4000">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <asp:Panel ID="pnlAddReason" runat="server" Visible="false">
            <div class="panel panel-danger">
                <div class="panel-heading"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Recommendations are about to be submmited</div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-12">
                            <i class="fa fa-exclamation-circle" aria-hidden="true"></i> Before denied this articulation, please provide a reason. 
                        </div>
                        <div class="col-md-8">
                            <telerik:RadTextBox ID="rtbReason" TextMode="MultiLine" Rows="3" Wrap="true" runat="server" Width="100%"></telerik:RadTextBox>
                        </div>
                        <div class="col-md-4">
                            <telerik:RadButton ID="rbDenied" runat="server" Text="Denied selected articulations" ButtonType="LinkButton" OnClick="rbDenied_Click" Primary="true" >
                            <Icon PrimaryIconCssClass="rbOk"></Icon>
                        </telerik:RadButton>
                            <telerik:RadButton ID="rbCancel" runat="server" Text="Cancel" ButtonType="LinkButton" OnClick="rbCancel_Click">
                            <Icon PrimaryIconCssClass="rbCancel"></Icon>
                        </telerik:RadButton>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12">
                            <asp:Label ID="lblMoveAll" runat="server" Text="" Visible="false"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
    <telerik:RadGrid ID="rgFacultyReview" runat="server" AllowSorting="True" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlFacultyDistrictReview" AllowFilteringByColumn="True" AllowPaging="True" GroupingSettings-CaseSensitive="false" OnItemCommand="rgFacultyReview_ItemCommand" RenderMode="Lightweight" OnItemDataBound="rgFacultyReview_ItemDataBound">
        <ClientSettings AllowRowsDragDrop="false" AllowColumnsReorder="true" ReorderColumnsOnClient="true" EnableRowHoverStyle="false">
            <Selecting AllowRowSelect="True" EnableDragToSelectRows="False" />
            <ClientEvents />
        </ClientSettings>
        <SelectedItemStyle CssClass="selectedrow" /> 
        <MasterTableView Name="ParentGrid" DataSourceID="sqlFacultyDistrictReview" PageSize="12" DataKeyNames="id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowExportToExcelButton="true" AllowFilteringByColumn="true" AllowMultiColumnSorting="true"  HeaderStyle-Font-Bold="true" EnableHierarchyExpandAll="true">
            <CommandItemTemplate>
                <div class="commandItems">
                    <telerik:RadButton runat="server" ID="btnApprove" ToolTip="Check to add selected articulations." CommandName="Approved" Text=" Approve selected articulations" ButtonType="LinkButton">
                        <Icon PrimaryIconCssClass="rbOk"></Icon>
                    </telerik:RadButton>
                    <telerik:RadButton runat="server" ID="btnDenied" ToolTip="Check to add selected articulations." CommandName="Denied" Text=" Denied selected articulations" ButtonType="LinkButton">
                        <Icon PrimaryIconCssClass="rbCancel"></Icon>
                    </telerik:RadButton>
                </div>
            </CommandItemTemplate>
            <Columns>
                <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="30px">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" ToolTip="View Articulation Details" CommandName="ViewArticulation" ID="ViewArticulation" Text='<i class="fa fa-eye fa-lg" aria-hidden="true"></i>' />
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridTemplateColumn UniqueName="CheckBoxTemplateColumn" AllowFiltering="false" HeaderStyle-Width="10px">
                    <ItemTemplate>
                        <asp:CheckBox ID="CheckBox1" runat="server" OnCheckedChanged="ToggleRowSelection"
                            AutoPostBack="True" />
                    </ItemTemplate>
                    <HeaderTemplate>
                        <asp:CheckBox ID="headerChkbox" runat="server" OnCheckedChanged="ToggleSelectedState"
                            AutoPostBack="True" />
                    </HeaderTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false" Exportable="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="VoteType" UniqueName="VoteType" HeaderText="Articulation Status" AllowFiltering="false" HeaderStyle-Width="90px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="subject" UniqueName="subject" HeaderText="Subject" AllowFiltering="false" HeaderStyle-Width="60px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="course_number" UniqueName="course_number" HeaderText="Course Number" AllowFiltering="false" HeaderStyle-Width="60px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="outline_id" UniqueName="outline_id" Display="false" Exportable="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false" Exportable="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="IsSource" UniqueName="IsSource" Display="false" Exportable="false"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="ArticulationType" UniqueName="articulation_type" Display="false" Exportable="false"></telerik:GridBoundColumn>
                <telerik:GridDropDownColumn DataField="ArticulationType" FilterControlAltText="Filter ArticulationType column" HeaderText="Type" SortExpression="ArticulationType" UniqueName="ArticulationType" DataSourceID="sqlArticulationType" ListTextField="description" ListValueField="id" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" AllowFiltering="false">
                </telerik:GridDropDownColumn>
                <telerik:GridBoundColumn SortExpression="AceID" HeaderText="ACE ID" DataField="AceID" UniqueName="AceID" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="90px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" HeaderText="Team Revd" AllowFiltering="false" DataFormatString="{0:MM/dd/yyyy}"  HeaderStyle-Width="80px">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Occupation" HeaderText="Occupation" DataField="Occupation" UniqueName="Occupation" AllowFiltering="True" FilterControlWidth="50px" ReadOnly="true" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="Title" HeaderText="Title" DataField="Title" UniqueName="Title" AllowFiltering="false" ReadOnly="true" >
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn SortExpression="StatusDescription" HeaderText="Status" DataField="StatusDescription" UniqueName="StatusDescription" AllowFiltering="false" ReadOnly="true" >
                </telerik:GridBoundColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
        <script type="text/javascript">
        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("btnExcel") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }
    </script>
</asp:Content>
