<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Program.aspx.cs" Inherits="ems_app.modules.popups.Program" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Program of Study</title>
    <!-- Bootstrap -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/bootstrap/dist/css/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
    <style>
        .reToolBarWrapper
        {
        display: block !important;
        }
        .RadMultiPage .rmpView {
            padding: 20px !important;
        }
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="sdsSessions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [tblSessions]"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlDiscipline" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select discipline_id DisciplineID, discipline DisciplineName from tblDisciplineLookup order by discipline"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsCatalogYear" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select academic_id, academic_year from tblAcademicYear order by academic_year desc"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlTaxonomySubjects" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select distinct subject_id SubjectID, Subject, SubjectName from tblSubjects order by SubjectName"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlDepartmentsTax" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select de.department_id DepartmentID, de.department DepartmentName from tblLookupDepartments de order by de.department"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlTaxonomyDivisions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select division_id as DivisionID, Division as DivisionName from tblLookupDivisions order by division"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlDepartments" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select department_id , department from tblLookupDepartments order by department"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlTopsCodes" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select topscode_id, topscode + ' ' + Program_Title as topscode from tblTOPSCodeLookup"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlGoals" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from tblLookupGoals order by sorder"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlDegreeType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from tblLookupDegreeType order by degree"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCDCPEligibilityCategory" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from CDCPEligibilityCategory"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlYesNo" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select 'True' as id, 'Yes' as 'YesNo' union select 'False' as id, 'No' as 'YesNo'"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlTransferDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [TransferDocuments] WHERE [id] = @id" InsertCommand="INSERT INTO [TransferDocuments] ([FileName], [FileDescription],  [BinaryData], [program_id], [user_id]) VALUES (@FileName, @FileDescription,  @BinaryData, @program_id,@user_id) SET @InsertedID = SCOPE_IDENTITY()" SelectCommand="SELECT id, filename, filedescription, binarydata FROM [TransferDocuments] where (program_id = @program_id)" UpdateCommand="UPDATE [TransferDocuments] SET  [FileDescription] = @FileDescription, [user_id] = @user_id WHERE [id] = @id" OnInserted="sqlTransferDocuments_Inserted" OnUpdated="sqlTransferDocuments_Updated">
            <SelectParameters>
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:SessionParameter Name="user_id" SessionField="UserID" Type="Int32" />
                <asp:Parameter Name="FileName" Type="String" />
                <asp:Parameter Name="FileDescription" Type="String" />
                <asp:Parameter Name="BinaryData" Type="Byte" />
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
                <asp:Parameter Name="InsertedID" Type="Int32" Direction="Output"></asp:Parameter>
            </InsertParameters>
            <UpdateParameters>
                <asp:SessionParameter Name="user_id" SessionField="UserID" Type="Int32" />
                <asp:Parameter Name="FileName" Type="String" />
                <asp:Parameter Name="FileDescription" Type="String" />
                <asp:Parameter Name="id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM [Documents] WHERE [id] = @id" InsertCommand="INSERT INTO [Documents] ([FileName], [FileDescription],  [BinaryData], [program_id], [user_id]) VALUES (@FileName, @FileDescription,  @BinaryData, @program_id, @user_id) SET @InsertedID = SCOPE_IDENTITY()" SelectCommand="SELECT id, filename, filedescription, binarydata FROM [Documents] where (program_id = @program_id)" UpdateCommand="UPDATE [Documents] SET  [FileDescription] = @FileDescription, [user_id] = @user_id WHERE [id] = @id" OnInserted="sqlDocuments_Inserted" OnUpdated="sqlDocuments_Updated">
            <SelectParameters>
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:SessionParameter Name="user_id" SessionField="UserID" Type="Int32" />
                <asp:Parameter Name="FileName" Type="String" />
                <asp:Parameter Name="FileDescription" Type="String" />
                <asp:Parameter Name="BinaryData" Type="Byte" />
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
                <asp:Parameter Name="InsertedID" Type="Int32" Direction="Output"></asp:Parameter>
            </InsertParameters>
            <UpdateParameters>
                <asp:SessionParameter Name="user_id" SessionField="UserID" Type="Int32" />
                <asp:Parameter Name="FileName" Type="String" />
                <asp:Parameter Name="FileDescription" Type="String" />
                <asp:Parameter Name="id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlProgramAdditionalResources" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT ar.id, art.Description, ar.BriefDescription, ar.Cost, ar.haveResource FROM [tblAdditionalResources] ar LEFT OUTER JOIN [tblLookupAdditionalResources] art ON ar.ResourceID = art.id WHERE (ar.[program_id] = @program_id) ORDER BY art.[sorder]" UpdateCommand="UPDATE [tblAdditionalResources] SET [BriefDescription] = @BriefDescription, [haveResource] = @haveResource, [Cost] = @Cost WHERE [id] = @id">
            <SelectParameters>
                <asp:ControlParameter ControlID="hfProgramID" PropertyName="Value" Name="program_id" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="BriefDescription" Type="String" />
                <asp:Parameter Name="Cost" Type="Double" />
                <asp:Parameter Name="haveResource" Type="Boolean" />
                <asp:Parameter Name="id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadWindowManager ID="RadWindowManager2" runat="server"></telerik:RadWindowManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="280px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="Default">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <telerik:RadToolTip runat="server" ID="RadToolTip2" Width="380px" Height="70px" HideEvent="ManualClose" EnableRoundedCorners="true" Position="TopRight" Animation="Fade" >
                <p id="P1" runat="server">
                    <asp:Label ID="Label3" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label><br />
                    <br />
                    <asp:Label ID="Label4" runat="server" EnableViewState="true">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div style="padding: 15px !important;">
                <div class="row">
                    <div class="col-md-6">
                        <h2 runat="server" id="programTitle"></h2>
                        <asp:HiddenField ID="hfProgramID" runat="server" />
                        <asp:HiddenField ID="hfIssuedFormId" runat="server" />
                    </div>
                    <div class="col-md-6 text-right">
                        <telerik:RadButton RenderMode="Lightweight" ID="rbSave" runat="server" Text=" Save" OnClick="rbSave_Click">
                            <Icon PrimaryIconCssClass="rbSave"></Icon>
                        </telerik:RadButton>
                    </div>
                </div>
                <div class="row">
                    <telerik:RadTabStrip runat="server" ID="RadTabStrip1" MultiPageID="RadMultiPage1" SelectedIndex="0" Width="95%" Height="50px" ShowBaseLine="true" RenderMode="Lightweight" Skin="Default">
                        <Tabs>
                            <telerik:RadTab Text="Program Information" ToolTip="PROGRAM INFORMATION:
Program Title, 
Division,
Department,
Discipline,
TOP Code,
CIP Code,
SOC Code,
Program Type,
Program Goal,
CDCP Eligibility Category,                                                                
AA or AS Degrees Transfer Documentation, 
Division/Department/Advisory Board Meeting Minutes,
Units for Degree,
Gainful Employment,
Anticipated Date of Approval By District Governing Board,



 


,  




Subject Area, 

"
                                Selected="True">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Catalog Description" ToolTip="CATALOG DESCRIPTION:
Program Catalog Description,
Program Learning Outcomes">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Planning" Visible="false" ToolTip="PLANNING: 
External Demand,
Internal Demand,
Opportunity Analysis,
Rationale,
Resources">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Curriculum/Similar Programs" Visible="false" ToolTip="CURRICULUM/SIMILAR PROGRAMS:
Simliar Programs, 
Substantive Change Reporting">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage runat="server" ID="RadMultiPage1" SelectedIndex="0" Width="99%" CssClass="multipageWrapper" RenderMode="Lightweight" >
                        <telerik:RadPageView runat="server" ID="RadPageView1" Width="100%">
                            <h2>Program Information</h2>
                            <div class="row">
                                <div class="col-md-12">
                                    Enter the exact title that is proposed for the catalog. The title must clearly and accurately reflect the scope and level of the program. Do not include descriptors, such as “with an emphasis,” “degree,” “certificate,” “transfer” or “for transfer” in the program title.<br />
                                    <br />
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <label>PROGRAM TITLE : </label>
                                    <telerik:RadTextBox ID="rtProgramTitle" InputType="Text" runat="server" Width="400px" RenderMode="Lightweight"></telerik:RadTextBox>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton1" runat="server" CommandName="ProgramTitle" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-md-6" style="display: none;">
                                    <label>ACADEMIC YEAR :</label>
                                    <asp:DropDownList ID="rcbSeason" runat="server" Width="100px" DataSourceID="sdsSessions" DataTextField="SessionName" DataValueField="Session_id" AppendDataBoundItems="true">
                                        <asp:ListItem Text="Select a value" Value="" />
                                    </asp:DropDownList>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton127" runat="server" CommandName="SessionName" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <asp:DropDownList ID="rcbYear" runat="server" Width="120px" DataSourceID="sdsCatalogYear" DataTextField="academic_year" DataValueField="academic_id">
                                    </asp:DropDownList>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton129" runat="server" CommandName="AcademicYear" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-sm-4">
                                    <label>DIVISION : </label>
                                    <asp:DropDownList ID="rcbDivision" runat="server" DataSourceID="sqlTaxonomyDivisions" DataTextField="DivisionName" DataValueField="DivisionID" Width="85%">
                                        <asp:ListItem Text="Select a value" Value="0" />
                                    </asp:DropDownList>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton8" runat="server" CommandName="Division" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <label>DEPARTMENT : </label>
                                    <asp:DropDownList ID="rcbDepartment" runat="server" DataSourceID="sqlDepartmentsTax" DataTextField="DepartmentName" DataValueField="DepartmentID" Width="90%">
                                        <asp:ListItem Text="Select a value" Value="0" />
                                    </asp:DropDownList>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton10" runat="server" CommandName="Emphasis" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <label>DISCIPLINE :</label>
                                    <asp:DropDownList ID="rcbDiscipline" runat="server" DataSourceID="sqlDiscipline" Width="90%" DataTextField="DisciplineName" DataValueField="DisciplineID">
                                        <asp:ListItem Text="Select a value" Value="0" />
                                    </asp:DropDownList>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton16" runat="server" CommandName="Emphasis" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-4">
                                    <label>TOP CODE : </label>
                                    <asp:DropDownList ID="ddlTopsCode" CssClass="ddlTopsCode" runat="server" Width="85%" DataSourceID="sqlTopsCodes" DataTextField="topscode" DataValueField="topscode_id" ClientIDMode="Static">
                                    </asp:DropDownList>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton6" runat="server" CommandName="TopCode" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-sm-4"  style="display:none;">
                                    <label>CIP CODE : </label>
                                    <telerik:RadTextBox ID="rtbCIPCode" InputType="Text" Width="150px" runat="server" RenderMode="Lightweight"></telerik:RadTextBox>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton12" runat="server" CommandName="CIPCode" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-sm-4"  style="display:none;">
                                    <label>SOC CODE : </label>
                                    <telerik:RadTextBox ID="rtbSOCCode" InputType="Text" Width="150px" runat="server" RenderMode="Lightweight"></telerik:RadTextBox>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton137" runat="server" CommandName="SOCCode" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-md-6">
                                    <p>PROGRAM TYPE :</p>
                                    <telerik:RadComboBox RenderMode="Lightweight" ID="rcbProgramType" DataSourceID="sqlDegreeType" DataTextField="degree" DataValueField="degree_id" runat="server" Width="320px" />
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton14" runat="server" CommandName="ProgramType" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <p>PROGRAM GOAL : (Not applicable for Noncredit)</p>
                                    <telerik:RadComboBox RenderMode="Lightweight" ID="rcbProgramGoal" DataSourceID="sqlGoals" DataTextField="goalDescription" DataValueField="goalID" runat="server" Width="320px" ClientIDMode="Static">
                                    </telerik:RadComboBox>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton20" runat="server" CommandName="ProgramGoal" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="row" style="display:none;">
                                <div class="col-md-12">
                                    <br />
                                    <span>CDCP Eligibility Category for Noncredit Certificates Only:</span><br />
                                    <br />
                                    <asp:RadioButtonList ID="rblCDCP" runat="server" DataSourceID="sqlCDCPEligibilityCategory" DataTextField="description" DataValueField="CodeID" ClientIDMode="Static">
                                    </asp:RadioButtonList>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton62" runat="server" CommandName="CDCPEligibilityCategory" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="row"  style="display:none;">
                                <div class="col-md-12">
                                    <div id="hideTransfer" runat="server">
                                        <br />
                                        <p>Local AA OR AS degrees with a goal of transfer must include one of the following:</p>
                                        <ul style="list-style: circle;">
                                            <li>PDF evidence of programmatic articulation agreements.</li>
                                            <li>PDF of ASSIST documentation verifying that a majority of courses in the program are articulated for the major AAM) to the baccalaureate institutions to which students are likely to transfer.</li>
                                            <li>Scanned copy of a table of major requirements from the most recent catalog dates and page numbers cited for targeted transfer institutions showing crosswalk with CCC program requirements.</li>
                                            <li>PDFSummary of lower division major preparation published or endorsed by relevant professional bodies or programmatic accreditors with citations included.</li>
                                            <li>Scanned Formal letters from the intended receiving institution that verify alignment of proposed program with their program curriculum (PCAH 6th edition 77).</li>
                                        </ul>
                                        <br />
                                        <br />
                                        <telerik:RadGrid ID="rgTransferDocuments" DataSourceID="sqlTransferDocuments" AllowPaging="True" Width="100%" runat="server" AutoGenerateColumns="False" AllowSorting="True" PageSize="10" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemCommand="rgTransferDocuments_ItemCommand" AllowAutomaticDeletes="true" OnItemDataBound="rgTransferDocuments_ItemDataBound" RenderMode="Lightweight">
                                            <ClientSettings AllowDragToGroup="false">
                                                <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                                            </ClientSettings>
                                            <MasterTableView DataKeyNames="id" AutoGenerateColumns="false" CommandItemDisplay="Top">
                                                <CommandItemTemplate>
                                                    <div class="commandItems">
                                                        <asp:LinkButton runat="server" CommandName="InitInsert" ID="btnAdd" Text="<i class='fa fa-upload'></i> Upload Transfer Documentation" />
                                                    </div>
                                                </CommandItemTemplate>
                                                <CommandItemSettings ShowAddNewRecordButton="true" ShowRefreshButton="true" />
                                                <Columns>
                                                    <telerik:GridBoundColumn DataField="id" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" Display="false" ReadOnly="true">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="FileDescription" FilterControlAltText="Filter FileDescription column" HeaderText="File Description" SortExpression="FileDescription" UniqueName="FileDescription">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridAttachmentColumn SortExpression="FileName" UploadControlType="RadAsyncUpload" DataSourceID="sqlTranferDownloadColumn" MaxFileSize="1048576" EditFormHeaderTextFormat="Upload File:" HeaderText="Attachment" AttachmentDataField="BinaryData" AttachmentKeyFields="id" ForceExtractValue="Always" FileNameTextField="FileName" DataTextField="FileName" UniqueName="AttachmentColumn">
                                                    </telerik:GridAttachmentColumn>
                                                    <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" ButtonType="ImageButton">
                                                        <ItemStyle Width="50px"></ItemStyle>
                                                    </telerik:GridEditCommandColumn>
                                                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this document ?" ConfirmTitle="Delete" HeaderStyle-Width="50px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                                        <HeaderStyle Width="50px" />
                                                    </telerik:GridButtonColumn>
                                                </Columns>
                                                <EditFormSettings ColumnNumber="2" FormMainTableStyle-CellPadding="5" FormTableStyle-CellPadding="5" EditColumn-ButtonType="ImageButton"></EditFormSettings>
                                            </MasterTableView>
                                        </telerik:RadGrid>
                                    </div>
                                </div>
                            </div>
                            <div class="row"  style="display:none;">
                                <div class="col-md-12">
                                    <br />
                                    <p>Please attach division/department/advisory board meeting minutes indicating program’s approval</p>
                                    <br />
                                </div>
                            </div>
                            <div class="row"  style="display:none;">
                                <div class="col-md-12">
                                    <telerik:RadGrid ID="rgJustificationDocs" DataSourceID="sqlDocuments" AllowPaging="True" Width="100%" runat="server" AutoGenerateColumns="False" AllowSorting="True" PageSize="10" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemCommand="rgJustificationDocs_ItemCommand" AllowAutomaticDeletes="true" OnItemDataBound="rgJustificationDocs_ItemDataBound" RenderMode="Lightweight">
                                        <ClientSettings AllowDragToGroup="false">
                                            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
                                        </ClientSettings>
                                        <MasterTableView DataKeyNames="id" AutoGenerateColumns="false" CommandItemDisplay="Top">
                                            <CommandItemTemplate>
                                                <div class="commandItems">
                                                    <asp:LinkButton runat="server" CommandName="InitInsert" ID="btnAdd" Text="<i class='fa fa-upload'></i> Upload Division/Department/Advisory Board Meeting Minutes" />
                                                </div>
                                            </CommandItemTemplate>
                                            <CommandItemSettings ShowAddNewRecordButton="true" ShowRefreshButton="true" />
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="id" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" Display="false" ReadOnly="true">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="FileDescription" FilterControlAltText="Filter FileDescription column" HeaderText="File Description" SortExpression="FileDescription" UniqueName="FileDescription">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridAttachmentColumn SortExpression="FileName" UploadControlType="RadAsyncUpload" DataSourceID="SqlDataSource2" MaxFileSize="1048576" EditFormHeaderTextFormat="Upload File:" HeaderText="Attachment" AttachmentDataField="BinaryData" AttachmentKeyFields="id" ForceExtractValue="Always" FileNameTextField="FileName" DataTextField="FileName" UniqueName="AttachmentColumn">
                                                </telerik:GridAttachmentColumn>
                                                <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" ButtonType="ImageButton">
                                                    <ItemStyle Width="50px"></ItemStyle>
                                                </telerik:GridEditCommandColumn>
                                                <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this document ?" ConfirmTitle="Delete" HeaderStyle-Width="50px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                                                    <HeaderStyle Width="50px" />
                                                </telerik:GridButtonColumn>
                                            </Columns>
                                            <EditFormSettings ColumnNumber="2" FormMainTableStyle-CellPadding="5" FormTableStyle-CellPadding="5" EditColumn-ButtonType="ImageButton"></EditFormSettings>
                                        </MasterTableView>
                                    </telerik:RadGrid><br />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <p>PROGRAM UNITS:</p>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-6">
                                    <label>MINIMUM :</label><telerik:RadNumericTextBox ID="rntbMinimumUnits" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" ReadOnly="true" RenderMode="Lightweight" />
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton28" runat="server" CommandName="MinimumUnits" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <label>MAXIMUM :</label><telerik:RadNumericTextBox ID="rntbMaximumUnits" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" ReadOnly="true" RenderMode="Lightweight" />
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton30" runat="server" CommandName="MaximumUnits" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <br />
                            <div class="row"  style="display:none;">
                                <div class="col-md-12">
                                    Enter the (minimum and maximum) number of semester units for the major or area of emphasis including course requirements, restricted electives, and other completion requirements. Do not include general education requirements and units completed in nondegree-applicable credit courses that raise student skills to standard collegiate levels of language and computational competence.
When the proposed program includes a degree with an area of emphasis, students may be allowed to choose from a list of courses to complete a specified number of units. For these proposed programs, include the number of units that all students are required to complete.
If the units required are the same (not a range), then enter the same number in both (min/max) fields.<br />
                                    <br />
                                </div>
                            </div>
                            <div class="row"  style="display:none;">
                                <div class="col-md-12">
                                    <p>FOR NEW DEGREE, MAJOR, OR AREA OF EMPHASIS PROGRAMS ONLY, TOTAL UNITS FOR DEGREE:</p>
                                </div>
                            </div>
                            <div class="row"  style="display:none;">
                                <div class="col-sm-6">
                                    <label>MINIMUM :</label><telerik:RadNumericTextBox ID="rntbMinimumUnitsDegree" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" RenderMode="Lightweight" />
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton32" runat="server" CommandName="MinimumUnitsDegree" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <label>MAXIMUM :</label><telerik:RadNumericTextBox ID="rntbMaximumUnitsDegree" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" RenderMode="Lightweight" />
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton34" runat="server" CommandName="MaximumUnitsDegree" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <br />
                            <div class="row"  style="display:none;">
                                <div class="col-md-12">
                                    Enter the total (minimum and maximum) units required to complete the degree including the units for the major or area of emphasis, the general education pattern units, any other graduation requirements, and electives to reach a minimum of 60 semester units. If the degree requires greater than 60 semester units, then include a justification in Narrative Item 4. If the units required are the same (not a range), then enter the same number in both (min/max) fields.
                                </div>
                            </div>
                            <br />
                            <!-- END FOR CTE -->
                            <div class="row"  style="display:none;">
                                <div class="col-sm-6">
                                    <label>GAINFUL EMPLOYMENT : </label>
                                    <div class="yesno-radio" style="width: 70%;">
                                        <asp:RadioButtonList ID="rblGainfulEmployment" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                    </div>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton54" runat="server" CommandName="GainfulEmployment" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-sm-6" style="display: none;">
                                    <label>APPRENTICESHIP : </label>
                                    <div class="yesno-radio">
                                        <asp:RadioButtonList ID="rblApprenticeship" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                    </div>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton56" runat="server" CommandName="Apprenticeship" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="row"  style="display:none;">
                                <div class="col-md-12">
                                    <label style="display: none;">DISTANCE EDUCATION : </label>
                                    <asp:RadioButtonList ID="rblDistanceEducation" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" Visible="false" />
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton58" runat="server" CommandName="DistanceEducation" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="row"  style="display:none;">
                                <div class="col-md-12">
                                    <label>ANTICIPATED DATE OF APPROVAL BY DISTRICT GOVERNING BOARD : (To Be Completed By the Instruction Office)</label>
                                    <telerik:RadDatePicker ID="rdpBoardApprovalDate" runat="server" DateInput-Label="" Width="100px"></telerik:RadDatePicker>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton60" runat="server" CommandName="BoardApprovalDate" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </telerik:RadPageView>
                        <!-- START : Catalog Description Section -->
                        <telerik:RadPageView runat="server" ID="RadPageView2" Width="100%">
                            
                            <h2>Program Catalog Description</h2>
                            <div class="row">
                                <div class="col-md-12">
                                    <p>The catalog description should:</p>
                                    <ul>
                                        <li>Provide an overview of the knowledge and skills that students who complete the requirements must demonstrate </li>
                                        <li>List all prerequisite skills, program requirements, or enrollment limitations per Title 5 section 58106 <a href="http://govt.westlaw.com/calregs/Search/Index" target="_blank">http://govt.westlaw.com/calregs/Search/Index</a></li>
                                        <li>Suggest some caveats that students must be aware of where job market data or other factors are documented in the proposal. These warnings must be as clearly conveyed in the catalog description as possible. The catalog description needs to mention any risks, such as occupations that are inherently competitive or low-salaried and/or occupational areas where inexperienced graduates are not generally hired.</li>
                                        <li>If the associate degree program goal selected is “Career Technical Education (CTE)” or “Career Technical Education (CTE) and Transfer,” then the description must list the potential careers students may enter upon completion.</li>
                                        <li>If the associate degree program goal selected includes Transfer, then the description must list baccalaureate major or related majors.</li>
                                        <li>If applicable, advise students if this is a high-unit program (more than 60 semester or 90 quarter units) and how this impacts degree completion.</li>
                                        <li>If applicable, reference accrediting and/or licensing standards including an explanation of any departures from the standards. In some occupations, while there is no legal requirement for a license to practice, there is a widely recognized certification provided by a professional association. For example, the American Massage Therapy Association certifies massage therapists; the California Association of Alcohol and Drug Abuse Counselors certify counselors in that field. In these cases, the Chancellor’s Office expects that the description will specify whether the program will fully prepare completers for the recognized professional certification.</li>
                                    </ul>
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reCatalogDescription" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton72" runat="server" CommandName="CatalogDescription" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <h2>Program Learning Outcomes</h2>
                                    <p>This program was developed due to SLO assessment data findings (If true, check box and explain)</p>
                                    <asp:RadioButtonList ID="rbDevelopedSLO" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" ClientIDMode="Static">
                                    </asp:RadioButtonList>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton24" runat="server" CommandName="DevelopedSLO" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <asp:Panel ID="pnlDevelopSLO" runat="server" ClientIDMode="Static">
                                        <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reDevelopedSLO" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" ClientIDMode="Static" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                            <Tools>
                                                <telerik:EditorToolGroup Tag="Formatting">
                                                    <telerik:EditorTool Name="FontName" />
                                                    <telerik:EditorTool Name="FontSize" />
                                                    <telerik:EditorTool Name="Bold" />
                                                    <telerik:EditorTool Name="Italic" />
                                                    <telerik:EditorTool Name="Underline" />
                                                    <telerik:EditorTool Name="InsertUnorderedList" />
                                                    <telerik:EditorTool Name="InsertOrderedList" />
                                                    <telerik:EditorTool Name="Indent" />
                                                    <telerik:EditorTool Name="Outdent" />
                                                </telerik:EditorToolGroup>
                                            </Tools>
                                            <Content>
                                            </Content>
                                        </telerik:RadEditor>
                                        <div class="helpButtons"  style="display:none;">
                                            <asp:LinkButton ID="LinkButton26" runat="server" CommandName="DevelopedSLODescription" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                    </asp:Panel>
                                    <p>Sample Program Learning Outcomes.</p>
                                    <br />
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reSampleProgramLevel" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" ClientIDMode="Static" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>
                                    <div class="helpButtons"  style="display:none;">
                                        <asp:LinkButton ID="LinkButton125" runat="server" CommandName="ProgramLearningOutcomes" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <br />

                                    <telerik:GridTextBoxColumnEditor runat="server" ID="TextEditor" TextBoxStyle-BorderColor="#cccccc" TextBoxStyle-BorderWidth="1px">
                                        <TextBoxStyle Width="100%" />
                                    </telerik:GridTextBoxColumnEditor>
                                </div>
                            </div>
                            <!-- END : Catalog Description Section -->
                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="RadPageView3" Width="100%">
                            <!-- START : Planning section -->
                            <div style="display: none;">
                                <div class="row">
                                    <div class="col-md-12">
                                        <p>A. Explain how the program is appropriate to the objectives of the mission of the California Community College system (http://law.onecle.com/california/education/66010.4.html). Please also comment on how the program conforms to Mt San Antonio College’s Master Plan.</p>
                                        <p>This discussion may include some history of the program proposal origins, a description of the program purpose, and/or the program’s relevancy for the region and the college including related community support. If any expenditure values were entered earlier on in the proposal for facilities or other resources then please explain the specific needs for facilities and equipment in this section and respond to each of the following sub questions below.</p>
                                        <p>If applicable, this section may also be used to justify program objectives or the inclusion of a given course as a requirement. Similarly, high-unit programs (above 60 semester units) must be addressed in this section by providing a rationale for the additional unit requirements (e.g.; mandate, law, baccalaureate requirements, etc.)</p>
                                        <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reMasterPlanning" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                            <Tools>
                                                <telerik:EditorToolGroup Tag="Formatting">
                                                    <telerik:EditorTool Name="FontName" />
                                                    <telerik:EditorTool Name="FontSize" />
                                                    <telerik:EditorTool Name="Bold" />
                                                    <telerik:EditorTool Name="Italic" />
                                                    <telerik:EditorTool Name="Underline" />
                                                    <telerik:EditorTool Name="InsertUnorderedList" />
                                                    <telerik:EditorTool Name="InsertOrderedList" />
                                                    <telerik:EditorTool Name="Indent" />
                                                    <telerik:EditorTool Name="Outdent" />
                                                </telerik:EditorToolGroup>
                                            </Tools>
                                            <Content>
                                            </Content>
                                        </telerik:RadEditor>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton79" runat="server" CommandName="MasterPlanning" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>B. Questions for Programs Requesting Resources : </p>
                                        <p>
                                            1. What is the approximate cost to adopt this program (include any start-up costs and projected ongoing costs) ? :
                            <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reProgramCost" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                <Tools>
                                    <telerik:EditorToolGroup Tag="Formatting">
                                        <telerik:EditorTool Name="FontName" />
                                        <telerik:EditorTool Name="FontSize" />
                                        <telerik:EditorTool Name="Bold" />
                                        <telerik:EditorTool Name="Italic" />
                                        <telerik:EditorTool Name="Underline" />
                                        <telerik:EditorTool Name="InsertUnorderedList" />
                                        <telerik:EditorTool Name="InsertOrderedList" />
                                        <telerik:EditorTool Name="Indent" />
                                        <telerik:EditorTool Name="Outdent" />
                                    </telerik:EditorToolGroup>
                                </Tools>
                                <Content>
                                </Content>
                            </telerik:RadEditor>

                                        </p>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton81" runat="server" CommandName="ProgramCost" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>

                                        <p>
                                            3. Will its adoption require additional equipment ? :
                                        </p>
                                        <div class="yesno-radio">
                                            <asp:RadioButtonList ID="rblAdditionalEquipment" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                        </div>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton85" runat="server" CommandName="AdditionalEquipment" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>
                                            4. Will its adoption require materials ? :
                                        </p>
                                        <div class="yesno-radio">
                                            <asp:RadioButtonList ID="rblAdditionalMaterials" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                        </div>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton87" runat="server" CommandName="AdditionalMaterials" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>
                                            5. Will its adoption require modifications of facilities (lab space, specialized classroom space, etc.) :
                                        </p>
                                        <div class="yesno-radio">
                                            <asp:RadioButtonList ID="rblModificationFacilities" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                        </div>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton89" runat="server" CommandName="ModificationFacilities" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>
                                            6. Will its adoption require additional travel resources (recurring or one time) ? :
                                        </p>
                                        <div class="yesno-radio">
                                            <asp:RadioButtonList ID="rblAdditionalTravel" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                        </div>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton91" runat="server" CommandName="AdditionalTravel" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>
                                            7. Will its adoption require additional library resources ? :
                                        </p>
                                        <div class="yesno-radio">
                                            <asp:RadioButtonList ID="rblAdditionalLibrary" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                        </div>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton93" runat="server" CommandName="AdditionalLibrary" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>
                                            8. Will its adoption require additional software purchases and/or license renewal ? :
                                        </p>
                                        <div class="yesno-radio">
                                            <asp:RadioButtonList ID="rblAdditionalSoftware" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                        </div>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton95" runat="server" CommandName="AdditionalSoftware" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>


                                        <p>Attach plan of how needed resources will be secured. Include relevant signatures of library representative, IT representative, instructional dean).</p>
                                        <p>As applicable, resource requests to provide adequate resources for this course have been or will be included with the Program Review Report Form for this course’s division/department for Academic Year</p>
                                        <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="rePlanNeededResources" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                            <Tools>
                                                <telerik:EditorToolGroup Tag="Formatting">
                                                    <telerik:EditorTool Name="FontName" />
                                                    <telerik:EditorTool Name="FontSize" />
                                                    <telerik:EditorTool Name="Bold" />
                                                    <telerik:EditorTool Name="Italic" />
                                                    <telerik:EditorTool Name="Underline" />
                                                    <telerik:EditorTool Name="InsertUnorderedList" />
                                                    <telerik:EditorTool Name="InsertOrderedList" />
                                                    <telerik:EditorTool Name="Indent" />
                                                    <telerik:EditorTool Name="Outdent" />
                                                </telerik:EditorToolGroup>
                                            </Tools>
                                            <Content>
                                            </Content>
                                        </telerik:RadEditor>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton103" runat="server" CommandName="PlanNeededResources" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <label>NEW FACUTLY POSITIONS :</label><telerik:RadNumericTextBox ID="rntbFacultyPositions" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" />
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton68" runat="server" CommandName="FacultyPositions" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>Enter the number (not FTEF) of separately identified new faculty positions, both part and full-time. For example, if three part-time positions will be new then enter the number 3.</p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <label>ANNUAL COMPLETERS :</label><telerik:RadNumericTextBox ID="rntbAnnualCompleters" NumberFormat-DecimalDigits="0" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" />
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton36" runat="server" CommandName="AnnualCompleters" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>
                                            Enter the number of students projected to be awarded the degree each year after the program is fully established. The estimation submitted for annual completers should be reasonable in light of historical completion rates. As a
point of reference, refer to the Chancellor's Office Data Mart (www.cccco.edu click on the DATAMART hyperlink on the top right header) for historical completion rates by academic year for each TOP Code. An explanation for this entry must be provided in the Narrative Item 5. Enrollment and Completer Projections. The number of completers entered must be greater than zero.
                                        </p>

                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <label>NEW EQUIPMENT REQUIRED : </label>
                                        <telerik:RadNumericTextBox ID="rntbEquipmentRequired" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" />
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton46" runat="server" CommandName="EquipmentRequired" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>If new equipment will be acquired for the program, estimate (in dollars) the total cost from all sources, including district and state funds. If no new equipment will be acquired for the program, enter zero (0).</p>

                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <label>NEW REMODELED FACILITIES : </label>
                                        <telerik:RadNumericTextBox ID="rntbRemoledFacilities" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" />
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton48" runat="server" CommandName="RemoledFacilities" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>If new facilities will be acquired for the program, estimate (in dollars) the total cost from all sources, including district and state funds. If no new facilities will be acquired for the program, enter zero (0).</p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <label>LIBRARY ACQUISITIONS : </label>
                                        <telerik:RadNumericTextBox ID="rntbLibraryAcquisitions" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" />
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton50" runat="server" CommandName="LibraryAcquisitions" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>If new library and learning resources materials will be acquired for the program, estimate (in dollars) the total cost from all sources, including district and state funds. If no new materials will be acquired for the program, enter zero (0).</p>
                                    </div>
                                </div>
                            </div>
                            <h2>RATIONALE</h2>
                            <div class="row">
                                <div class="col-md-12">
                                    <p>How is the program essential to the mission of California Community College system ( <a href="http://law.onecle.com/california/education/66010.4.html" target="_blank">http://law.onecle.com/california/education/66010.4.html</a> )?  </p>
                                    <p>This discussion may include some history of the program proposal origins, a description of the program purpose, and/or the program’s relevancy for the region and the college including related community support. </p>

                                    <p>High-unit programs (above 60 semester units) must be addressed in this section by providing a rationale for the additional unit requirements (e.g.; mandate, law, baccalaureate requirements, etc.)</p>

                                    <br />
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reEssentialMisision" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>
                                </div>
                            </div>
                            <h2>Internal Demand</h2>
                            <!--<h2>Enrollment and Completer Projections</h2>-->
                            <div class="row">
                                <div class="col-md-12">
                                    <p>Will this new program fulfill a current need ? </p>
                                    <div class="yesno-radio">
                                        <asp:RadioButtonList ID="rblEnrollmentFulfillNeed" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                    </div>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton105" runat="server" CommandName="EnrollmentFulfillNeed" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <p>What is the expected number of annual completers?</p>
                                    <telerik:RadNumericTextBox ID="rntbExpectedAnnualCompleters" NumberFormat-DecimalDigits="0" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" />
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton107" runat="server" CommandName="ExpectedAnnualCompleters" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <p>What, if any, enrollment changes will this program create? Will it accommodate an overflow or attract a new market? Will it be possible for students to move between this program and another program?</p>
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reEnrollmentChanges" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton109" runat="server" CommandName="EnrollmentChanges" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reInternalDemandDetails" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton135" runat="server" CommandName="InternalDemandDetails" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <h2>External Demand</h2>
                            <p>EMPLOYMENT DEMAND</p>
                            <div id="hideCTE" runat="server">
                                <!-- BEGIN FOR CTE -->
                                <div class="row">
                                    <div class="col-md-12">

                                        <label>FOR CTE PROGRAMS ONLY, NET ANNUAL LABOR DEMAND : </label>
                                        <telerik:RadNumericTextBox ID="rntbAnualLaborDemand" NumberFormat-DecimalDigits="0" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" />
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton38" runat="server" CommandName="AnualLaborDemand" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                        <p>For programs with a selected program goal of “Career Technical Education (CTE)” or “Career Technical Education (CTE) and Transfer,” enter the estimated number of annual job openings, minus the annual number of program completers of other programs within the counties in the college service areas. The number entered here must be explicitly stated and consistent with the Labor Market Information and Analysis provided as Supporting Documentation. The figure entered must be greater than zero.</p>
                                    </div>
                                    <div class="col-md-12">
                                        <p>ADDITIONAL SUPPORTING DOCUMENTATION-CTE</p>
                                    </div>
                                    <div class="col-md-12">
                                        <label>FOR CTE PROGRAMS ONLY, CTE REGIONAL CONSORTIUM RECOMMENDATION DATE : </label>
                                        <telerik:RadDatePicker ID="rdpCTEApprovalDate" runat="server" Width="100px"></telerik:RadDatePicker>
                                        <div class="helpButtons">
                                            <asp:LinkButton ID="LinkButton44" runat="server" CommandName="CTEApprovalDate" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <h2>Opportunity Analysis</h2>
                            <div class="row">
                                <div class="col-md-12">
                                    <p>Describe any political, environmental, social, technological, economic, or legal trends that are relevant opportunities or threats for this program</p>
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reOpportunityThreats" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" Language="en-US" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Languages>
                                            <telerik:SpellCheckerLanguage Code="en-US" />
                                        </Languages>
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>
                                </div>
                            </div>
                            <h2>Resources</h2>
                            <div class="row">
                                <div class="col-md-12">
                                    <p>
                                        Will adopting this program increase the total number of students to be served by College ? :
                                    </p>
                                    <div class="yesno-radio">
                                        <asp:RadioButtonList ID="rblIncreaseTotalStudents" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                    </div>
                                    <p>If yes how many ? </p>
                                    <telerik:RadNumericTextBox ID="rntbIncreaseTotalStudents" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" />

                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton101" runat="server" CommandName="IncreaseTotalStudents" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <label>FACULTY WORKLOAD : </label>
                                    <telerik:RadNumericTextBox ID="rntbFacultyWorkload" NumberFormat-DecimalDigits="2" Width="50px" runat="server" MinValue="0" ClientIDMode="Static" Value="0" IncrementSettings-InterceptArrowKeys="false" />
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton66" runat="server" CommandName="FacultyWorkload" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <p>This is the number of full-time equivalent faculty (FTEF) that will be dedicated to teaching in the program during the first full year of operation, regardless of whether they are new or existing faculty. This number has been calculated by determining the sum of the FTEF allocated for each individual course students are required to take as part of the program during their first year of coursework. The Program Course Approval Handbook states that this number will typically be between .5 and .7.</p>
                                    <br />
                                    <div class="row">
                                        <div class="col-md-12">
                                            <p>
                                                How will the section offerings be modified if the program is offered?  Will the courses be offered in lieu of existing sections of another course?   :
                                            </p>
                                            <div class="yesno-radio">
                                                <asp:RadioButtonList ID="rblSectionOfferings" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                            </div>
                                            <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reSectionOfferingsDescription" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                                <Tools>
                                                    <telerik:EditorToolGroup Tag="Formatting">
                                                        <telerik:EditorTool Name="FontName" />
                                                        <telerik:EditorTool Name="FontSize" />
                                                        <telerik:EditorTool Name="Bold" />
                                                        <telerik:EditorTool Name="Italic" />
                                                        <telerik:EditorTool Name="Underline" />
                                                        <telerik:EditorTool Name="InsertUnorderedList" />
                                                        <telerik:EditorTool Name="InsertOrderedList" />
                                                        <telerik:EditorTool Name="Indent" />
                                                        <telerik:EditorTool Name="Outdent" />
                                                    </telerik:EditorToolGroup>
                                                </Tools>
                                                <Content>
                                                </Content>
                                            </telerik:RadEditor>
                                            <div class="helpButtons">
                                                <asp:LinkButton ID="LinkButton97" runat="server" CommandName="SectionOfferings" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <span>For the each of the following, indicate if resources will be needed.  If yes for any of the following, provide the anticipated cost and a brief description</span>
                                    <br />
                                    <br />
                                    <telerik:RadGrid ID="rgAdditionalResources" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sqlProgramAdditionalResources" Width="100%" AllowAutomaticUpdates="true" MasterTableView-CommandItemSettings-SaveChangesText="Save" MasterTableView-CommandItemSettings-CancelChangesText="Cancel" RenderMode="Lightweight">
                                        <GroupingSettings CaseSensitive="false" />
                                        <ClientSettings AllowKeyboardNavigation="true">
                                            <Scrolling AllowScroll="false" />
                                            <ClientEvents></ClientEvents>
                                        </ClientSettings>
                                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="sqlProgramAdditionalResources" CommandItemDisplay="Top" EditMode="Batch" PageSize="10" CommandItemSettings-ShowAddNewRecordButton="false">
                                            <BatchEditingSettings EditType="Row" />
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="id" HeaderText="ID" UniqueName="id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn DataField="program_id" HeaderText="Program ID" UniqueName="program_id" Display="false">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridCheckBoxColumn DataField="haveResource" HeaderText="Yes/No" UniqueName="haveResource" HeaderStyle-Width="70px"></telerik:GridCheckBoxColumn>
                                                <telerik:GridBoundColumn DataField="Description" ReadOnly="true" HeaderText="" UniqueName="Description">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridNumericColumn DataField="Cost" HeaderText="Cost" UniqueName="Cost" DecimalDigits="2">
                                                </telerik:GridNumericColumn>
                                                <telerik:GridHTMLEditorColumn DataField="BriefDescription" HeaderText="Brief Description" UniqueName="BriefDescription">
                                                </telerik:GridHTMLEditorColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton168" runat="server" CommandName="AdditionalResources" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>

                            <!-- END : Planning Section -->

                        </telerik:RadPageView>
                        <telerik:RadPageView runat="server" ID="RadPageView5" Width="100%">
                            <h2>Curriculum / Similar Programs</h2>
                            <div class="row">
                                <div class="col-md-12">
                                    <p>What related programs does the college offer?</p>
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reRelatedProgramsOffer" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton111" runat="server" CommandName="RelatedProgramsOffer" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <p>Does the program establish a new direction for the college?</p>
                                    <div class="yesno-radio">
                                        <asp:RadioButtonList ID="rlbEstablishNewDireccion" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />

                                    </div>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton113" runat="server" CommandName="EstablishNewDireccion" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <p>Will this new program fulfill a current need ? </p>
                                    <div class="yesno-radio">
                                        <asp:RadioButtonList ID="rblFulfillCurrentNeed" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                    </div>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton115" runat="server" CommandName="FulfillCurrentNeed" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <p>Will there be courses in common shared by this program and another existing program?</p>
                                    <div class="yesno-radio">
                                        <asp:RadioButtonList ID="rblCommonSharedCourses" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                    </div>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton117" runat="server" CommandName="CommonSharedCourses" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                    <p>Will programs share resources? Describe service, if any, to other disciplines that this proposed program will provide. Explain how, if at all, this program makes a new or more productive use of existing resources and/or builds upon existing programs or services?</p>
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reDescribeShareResources" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>
                                    <div class="helpButtons">
                                        <asp:LinkButton ID="LinkButton119" runat="server" CommandName="DescribeShareResources" ValidationGroup="ToolTips" OnClick="showTooltip_Click"><i class="fa fa-question-circle"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>

                            <h2>SUBSTANTIVE CHANGE REPORTING</h2>
                            <p>(If yes, to any of the following, please describe.)</p>
                            <div class="row">
                                <div class="col-md-12">
                                    <p>Was this program previously offered in face-to-face format but now will be offered 50% or more online?</p>
                                    <div class="yesno-radio">
                                        <asp:RadioButtonList ID="rblFaceToFace" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                    </div>
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reFaceToFaceDescription" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>

                                    <br />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <p>Will this program be offered 100% online?</p>
                                    <div class="yesno-radio">
                                        <asp:RadioButtonList ID="rblOfferedOnline" runat="server" DataSourceID="SqlYesNo" DataTextField="YesNo" DataValueField="id" RepeatDirection="Horizontal" />
                                    </div>
                                    <telerik:RadEditor RenderMode="Lightweight" runat="server" ID="reOfferedOnlineDescription" SkinID="DefaultSetOfTools" ToolbarMode="Default" NewLineMode="P" EditModes="Design" Height="200px" Width="95%" StripFormattingOptions="MsWord,Span,Css,ConvertWordLists">
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="FontName" />
                                                <telerik:EditorTool Name="FontSize" />
                                                <telerik:EditorTool Name="Bold" />
                                                <telerik:EditorTool Name="Italic" />
                                                <telerik:EditorTool Name="Underline" />
                                                <telerik:EditorTool Name="InsertUnorderedList" />
                                                <telerik:EditorTool Name="InsertOrderedList" />
                                                <telerik:EditorTool Name="Indent" />
                                                <telerik:EditorTool Name="Outdent" />
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                        <Content>
                                        </Content>
                                    </telerik:RadEditor>

                                    <br />
                                </div>
                            </div>
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </div>
            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>

    </form>
</body>
</html>

