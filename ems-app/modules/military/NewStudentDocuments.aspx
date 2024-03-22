<%@ Page Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="NewStudentDocuments.aspx.cs" Inherits="ems_app.modules.military.NewStudentDocuments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        @media only screen and (max-width: 1920px) {
            .PageCenter {
                width: 100%;
                overflow-x: auto;
                padding-left: 25%;
                padding-right: 25%;
                font-size: 15px;
            }

            .listCheck {
                padding-left: 20%
            }
        }

        @media only screen and (max-width: 600px) {
            .PageCenter {
                width: 100%;
                overflow-x: auto;
                padding-left: 5%;
                padding-right: 5%;
                font-size: 15px;
            }

            .listCheck {
                padding-left: 5%
            }
        }

        .title {
            background-color: #337ab7;
            padding: 20px;
            text-align: center;
            font-size: 30px;
        }

        .tableSBorder td {
            border-bottom-width: 0px !important;
        }

        .demo-container {
            display: inline-block;
            text-align: left;
        }

            .demo-container .RadUpload .ruUploadProgress {
                width: 210px;
                display: inline-block;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                vertical-align: top;
            }

            .demo-container .ruBrowse {
                padding: unset !important;
            }

        html .demo-container .ruFakeInput {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="appTitle" id="SystemTitle" runat="server"></p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlVeteranOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
        SelectCommand="SELECT AC.ID AS Id, AC.AceID + ' ' + AC.Title AS Title FROM VeteranACECourse AS VC INNER JOIN ACEExhibit AS AC ON VC.AceID = AC.AceID AND VC.TeamRevd = AC.TeamRevd AND VC.StartDate = AC.StartDate AND VC.EndDate = AC.EndDate WHERE VC.VeteranId = @VeteranId AND VC.CollegeId = @CollegeId UNION SELECT AC.ID AS Id, AC.AceID + ' ' + AC.Title AS Title FROM VeteranOccupation AS VO INNER JOIN ACEExhibit AC ON VO.AceID = AC.AceID AND VO.TeamRevd = AC.TeamRevd AND VO.StartDate = AC.StartDate AND VO.EndDate = AC.EndDate WHERE VO.VeteranId = @VeteranId AND VO.CollegeId = @CollegeId"
        DeleteCommand="IF((SELECT AceType FROM ACEExhibit WHERE ID = @id) = 1) BEGIN DELETE FROM [dbo].[VeteranACECourse] WHERE [VeteranId] = @VeteranID AND ([AceID] = (SELECT AceID FROM ACEExhibit WHERE ID = @id)) AND ([TeamRevd] = (SELECT TeamRevd FROM ACEExhibit WHERE ID = @id)) AND [CollegeId] = @CollegeId END ELSE BEGIN DELETE FROM [dbo].[VeteranOccupation] WHERE [VeteranId] = @VeteranID AND ([OccupationCode] = (SELECT Occupation FROM ACEExhibit WHERE ID = @id)) AND [CollegeId] = @CollegeId END"
        InsertCommand="IF((SELECT AceType FROM ACEExhibit WHERE ID = @id) = 1) BEGIN INSERT INTO [dbo].[VeteranACECourse] ([VeteranId],[AceID],[TeamRevd],[CollegeId],[CreatedOn],[StartDate],[EndDate]) VALUES (@VeteranID,(SELECT AceID FROM ACEExhibit WHERE ID = @id),(SELECT TeamRevd FROM ACEExhibit WHERE ID = @id), @CollegeId, GETDATE(),(SELECT StartDate FROM ACEExhibit WHERE ID = @id),(SELECT EndDate FROM ACEExhibit WHERE ID = @id)) END ELSE BEGIN INSERT INTO [dbo].[VeteranOccupation] ([VeteranId],[OccupationCode],[CollegeId],[AceID],[StartDate],[EndDate],[TeamRevd]) VALUES (@VeteranID,(SELECT Occupation FROM ACEExhibit WHERE ID = @id),@CollegeId,(SELECT AceID FROM ACEExhibit WHERE ID = @id),(SELECT StartDate FROM ACEExhibit WHERE ID = @id),(SELECT EndDate FROM ACEExhibit WHERE ID = @id),(SELECT TeamRevd FROM ACEExhibit WHERE ID = @id)) END">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfCollege" PropertyName="Value" Name="CollegeId" Type="Int32" />
            <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="id" Type="Int32" />
            <asp:ControlParameter ControlID="hfCollege" PropertyName="Value" Name="CollegeId" Type="Int32" />
            <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="id" Type="String" />
            <asp:ControlParameter ControlID="hfCollege" PropertyName="Value" Name="CollegeId" Type="Int32" />
            <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT distinct id, TRIM(Occupation) + ' – ' + [AceID] + ' ' + concat(cast(FORMAT(StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(EndDate, 'MM/yy') as varchar(7))) + ' ' + [Title] as OccupationDetail  FROM [dbo].[ACEExhibit] order by OccupationDetail"></asp:SqlDataSource>
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
    <asp:HiddenField ID="hfCollege" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfUserID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfVeteranID" runat="server" ClientIDMode="Static" />
    <div class="PageCenter">
        <br />
        <table style="width: 100%;">
            <colgroup>
                <col style="width: 37%" />
                <col style="width: 14%" />
                <col style="width: 37%" />
                <col style="width: 10%" />
            </colgroup>
            <tbody>
                <tr>
                    <td>
                        <div>
                            <asp:Label ID="lblEducational" runat="server" Text="Educational Benefits:" Width="100%"></asp:Label>
                            <asp:Label ID="lblSubtitle" runat="server" Text="(Certificate of Eligibility)" Font-Size="X-Small"></asp:Label>
                        </div>
                    </td>
                    <td></td>
                    <td>
                        <div>
                            <asp:Label ID="lblStudentPlan" runat="server" Text="Student Educational Plan:" Width="100%"></asp:Label>
                        </div>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="fuStudenteducationalbenefits" AllowedFileExtensions="doc,docx,xls,xlsx,pdf" TargetFolder="" MultipleFileSelection="Disabled"
                            OnClientValidationFailed="validationFailed" OnFileUploaded="fuStudenteducationalbenefits_FileUploaded" Localization-Select="Upload">
                        </telerik:RadAsyncUpload>
                    </td>
                    <td></td>
                    <td>
                        <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="fuStudentEducationalPlan" AllowedFileExtensions="doc,docx,xls,xlsx,pdf" TargetFolder="" MultipleFileSelection="Disabled"
                            OnClientValidationFailed="validationFailed" OnFileUploaded="fuStudentEducationalPlan_FileUploaded" Localization-Select="Upload">
                        </telerik:RadAsyncUpload>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <div>
                            <asp:Label ID="lblJST" runat="server" Text="JST or CCAF Transcript:" Width="100%"></asp:Label>
                        </div>
                    </td>
                    <td></td>
                    <td>
                        <div>
                            <asp:Label ID="lblMapTotal" runat="server" Text="MAP Total Credits:" Width="100%" Visible="false"></asp:Label>
                        </div>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="fuJoinsServicesTypeScript" AllowedFileExtensions="doc,docx,xls,xlsx,pdf" TargetFolder="" MultipleFileSelection="Disabled"
                            OnClientValidationFailed="validationFailed" OnFileUploaded="fuJoinsServicesTypeScript_FileUploaded" Localization-Select="Upload">
                        </telerik:RadAsyncUpload>
                    </td>
                    <td></td>
                    <td>
                        <asp:DropDownList ID="ddlMapTotal" runat="server" CssClass="form-control" Width="100%" Visible="false">
                            <asp:ListItem Value="0" Text="0" Selected="True" />
                            <asp:ListItem Value="1" Text="1" />
                            <asp:ListItem Value="2" Text="2" />
                            <asp:ListItem Value="3" Text="3" />
                            <asp:ListItem Value="4" Text="4" />
                            <asp:ListItem Value="5" Text="5" />
                            <asp:ListItem Value="6" Text="6" />
                            <asp:ListItem Value="7" Text="7" />
                            <asp:ListItem Value="8" Text="8" />
                            <asp:ListItem Value="9" Text="9" />
                            <asp:ListItem Value="10" Text="10" />
                            <asp:ListItem Value="11" Text="11" />
                            <asp:ListItem Value="12" Text="12" />
                            <asp:ListItem Value="13" Text="13" />
                            <asp:ListItem Value="14" Text="14" />
                            <asp:ListItem Value="15" Text="15" />
                            <asp:ListItem Value="16" Text="16" />
                            <asp:ListItem Value="17" Text="17" />
                            <asp:ListItem Value="18" Text="18" />
                            <asp:ListItem Value="19" Text="19" />
                            <asp:ListItem Value="20" Text="20" />
                            <asp:ListItem Value="21" Text="21" />
                            <asp:ListItem Value="22" Text="22" />
                            <asp:ListItem Value="23" Text="23" />
                            <asp:ListItem Value="24" Text="24" />
                            <asp:ListItem Value="25" Text="25" />
                            <asp:ListItem Value="26" Text="26" />
                            <asp:ListItem Value="27" Text="27" />
                            <asp:ListItem Value="28" Text="28" />
                            <asp:ListItem Value="29" Text="29" />
                            <asp:ListItem Value="30" Text="30" />
                        </asp:DropDownList>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <div>
                            <asp:Label ID="lblDD214" runat="server" Text="DD-214:" Width="100%"></asp:Label>
                        </div>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="fuDD214" AllowedFileExtensions="doc,docx,xls,xlsx,pdf" TargetFolder="" MultipleFileSelection="Disabled"
                            OnClientValidationFailed="validationFailed" OnFileUploaded="fuDD214_FileUploaded" Localization-Select="Upload">
                        </telerik:RadAsyncUpload>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <div>
                            <asp:Label ID="lblStudentMos" runat="server" Text="Student MOS, AFCS or Rating:" Width="100%"></asp:Label>
                        </div>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="4">
                        <div class="OccupationDetails">
                            <telerik:RadAjaxPanel ID="pnlVeteranOccupations" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
                                <telerik:RadGrid ID="rgVeteranOccupations" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlVeteranOccupations" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" AllowAutomaticInserts="true">
                                    <ClientSettings AllowKeyboardNavigation="true">
                                        <Selecting AllowRowSelect="true"></Selecting>
                                        <ClientEvents />
                                    </ClientSettings>
                                    <MasterTableView Name="ParentGrid" DataSourceID="sqlVeteranOccupations" PageSize="12" DataKeyNames="id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="true" EnableHierarchyExpandAll="true" AllowFilteringByColumn="false" CommandItemSettings-AddNewRecordText="Add an Occupation" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                        <Columns>
                                            <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false" ReadOnly="true">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridDropDownColumn DataField="id" FilterControlAltText="Filter OccupationCode column" HeaderText="Occupation Code" SortExpression="id" UniqueName="OccupationCode" DataSourceID="sqlOccupations" ListTextField="OccupationDetail" ListValueField="id" FilterControlWidth="100%" AllowFiltering="false" HeaderStyle-Font-Bold="true" ColumnEditorID="CEDropdown" EmptyListItemText="Not found">
                                            </telerik:GridDropDownColumn>
                                            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this occupation ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                                <telerik:GridDropDownListColumnEditor ID="CEDropdown" DropDownStyle-Width="625px" runat="server" />
                            </telerik:RadAjaxPanel>
                            <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server">
                            </telerik:RadAjaxLoadingPanel>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <br />
        <br />
        <div style="text-align: right">
            <asp:Button runat="server" Text="BACK" CssClass="btn" Width="200px" BackColor="#203864" ForeColor="White" OnClientClick="window.location.href = '../military/NewStudent.aspx'"/>
            &nbsp&nbsp&nbsp
            <asp:Button ID="btnSave" runat="server" Text="NEXT" CssClass="btn" Width="200px" BackColor="#203864" ForeColor="White" OnClick="btnSave_Click" />
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        function validationFailed(radAsyncUpload, args) {
            var $row = $(args.get_row());
            var erorMessage = getErrorMessage(radAsyncUpload, args);
            var span = createError(erorMessage);
            $row.addClass("ruError");
            $row.addClass("ruWrap");
            $row.append("<br/>");
            $row.append(span);
        }
        function getErrorMessage(sender, args) {
            var fileExtention = args.get_fileName().substring(args.get_fileName().lastIndexOf('.') + 1, args.get_fileName().length);
            if (args.get_fileName().lastIndexOf('.') != -1) {//this checks if the extension is correct
                if (sender.get_allowedFileExtensions().indexOf(fileExtention) == -1) {
                    return ("This file type is not supported.");
                }
            }
            else {
                return ("not correct extension.");
            }
        }

        function createError(erorMessage) {
            var input = '<span class="ruErrorMessage">' + erorMessage + ' </span>';
            return input;
        }
    </script>
</asp:Content>
