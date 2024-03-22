<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="Student.aspx.cs" Inherits="ems_app.modules.military.Student" %>

<%@ Register Src="~/UserControls/students/MilitaryCredits.ascx" TagPrefix="uc1" TagName="MilitaryCredits" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .RadInput_Material input.riTextBox {
            color: #000 !important;
        }

        .RadGrid_Material .rgRow > td, .RadGrid_Material .rgAltRow > td, .RadGrid_Material .rgFooter > td, .RadGrid_Material .rgEditForm > td, .RadGrid_Material .rgEditRow > td, .RadGrid_Material .rgHoveredRow > td, .GridContextMenu_Material .rmContent .rgHCMClear {
            font-size: 13px !important;
        }

        .RadGrid_Material .rgMasterTable > tbody .rgRow > td
        {
            font-size: 13px !important;
        }
        .RadGrid_Material .rgMasterTable > tbody .rgAltRow > td
        {
            font-size: 13px !important;
        }

        .credit-recommendation {
            font-size: 13px !important;
            font-weight: normal !important;
            COLOR: inherit !important;
        }

        .btn-link {
            display: flex;
            justify-content: center;
        }

            .btn-link p {
                margin: 0;
            }

        .student-box {
            border: 5px solid lightgray;
            margin: 5px;
            padding: 10px;
            min-height: 250px;
        }

        .RadListView {
            overflow: auto;
            height: 180px;
            width: 100%;
            border-style: none !important;
        }

		.rtContent {
            display: -webkit-box !important;
            max-width: 300px !important;
            -webkit-line-clamp: 5 !important;
            -webkit-box-orient: vertical !important;
            white-space:unset !important;
            overflow: hidden !important;
            
        }
        .btnHiden {
            display:none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2" runat="server">Student Intake</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1" ClientEvents-OnRequestStart="onRequestStart">
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    <asp:HiddenField ID="hfCollegeID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfUserID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfVeteranID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfJSTOrder" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfAceID2" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfTeamRevd" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfCriteria" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfExistVeteran" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfExhibitID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfExhibitText" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfOutlineID" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfUnits" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfDeleteId" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfDeleteCriteriaId" runat="server" ClientIDMode="Static" />
    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" DestroyOnClose="true" EnableViewState="false" EnableShadow="true" InitialBehaviors="Close">
        <Windows>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalUpload" runat="server" Width="720px" Height="240px" Behaviors="Close" Modal="true" OffsetElementID="main" Title="Upload Files">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-3">
                            <telerik:RadLabel ID="rlTypeDoctos" runat="server" Text="Select type file" Font-Bold="true"></telerik:RadLabel>
                        </div>
                        <div class="col-3">
                            <telerik:RadDropDownList ID="ddlDocumenttypeUpload" DataSourceID="sqlDocumentType" DataTextField="documenttypeDescription" DataValueField="documenttypeid" runat="server" 
                                Width="100%" BackColor="#ffffe0" AppendDataBoundItems="true" OnClientItemSelected="OnClientSelectedFileIndexChanged">
                                <Items>
                                    <telerik:DropDownListItem Text="Select Type" Value="0" />
                                </Items>
                            </telerik:RadDropDownList>
                        </div>
                        <div class="col-3">
                            <telerik:RadLabel ID="rlFileUpload" runat="server" Text="Select file" Font-Bold="true"></telerik:RadLabel>
                        </div>
                        <div class="col-3">
                            <asp:HiddenField ID="htypeDocto" runat="server" ClientIDMode="Static"/>
                            <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="rauDocuments" AllowedFileExtensions="doc,docx,xls,xlsx,pdf" TargetFolder="" MultipleFileSelection="Disabled"
                                OnClientValidationFailed="validationFailed" OnFileUploaded="rauDocuments_FileUploaded" OnClientFileUploaded="OnClientFileUploaded" Localization-Select="Upload" ToolTip="Click to choose file(s). Once chosen, select Complete Upload.">
                            </telerik:RadAsyncUpload>
                            <telerik:RadButton ID="btnUploadFire" runat="server" OnClick="btnUploadFire_Click" ClientIDMode="Static" AutoPostBack="true" CssClass="btnHiden" ></telerik:RadButton>
                        </div>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalNotes" runat="server" Title="ADD/EDIT NOTES" Width="550px" Height="300px" Behaviors="Close" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <telerik:RadTextBox RenderMode="Lightweight" runat="server" ID="txtNotes2" Width="515px" Height="180px" TextMode="MultiLine" Resize="None" EmptyMessage=""></telerik:RadTextBox>
                    <div style="float: right; padding-top: 15px">
                        <telerik:RadButton ID="btnInsertNotes" runat="server" OnClick="btnInsertNotes_Click" Text="Save"></telerik:RadButton>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalPopup" runat="server" Title="Search Articulations" Width="1250px" Height="720px" Modal="true" VisibleStatusbar="false" NavigateUrl="~/modules/popups/CreditRecommendations.aspx?SourceID=8">
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalPrint" runat="server" Title="Print CPL" Width="800px" Height="600px" Modal="true" VisibleStatusbar="false">
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalExhibit" runat="server" Title="Add / Edit Exhibit" Width="1080px" Height="600px" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <h3>Manually Add Exhibits</h3>
                    <div class="row">
                        <div class="col-10">
                            <telerik:RadAutoCompleteBox ID="racbAceExhibit" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="200" DropDownHeight="200" DataSourceID="sqlAdvancedSearch" DataTextField="FullCriteria" EmptyMessage="Search by Exhibit ID(s) or keyword(s)" DataValueField="CriteriaID" ClientIDMode="Static" AllowCustomEntry="false" HighlightFirstMatch="true" Delimiter="," AutoPostBack="true" ToolTip="" CssClass="acbCriteria" BackColor="#ffffe0" DropDownWidth="1000px"></telerik:RadAutoCompleteBox>
                            <asp:RequiredFieldValidator ID="rfvAceExhibit" runat="server" Display="Dynamic" ControlToValidate="racbAceExhibit" ValidationGroup="AddAceExhibit" ErrorMessage="* Required" ForeColor="Red" Font-Size="X-Small"></asp:RequiredFieldValidator>
                            <asp:SqlDataSource runat="server" ID="sqlAdvancedSearch" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="SELECT DISTINCT AE.ID, AE.AceID, AE.Title, AE.Exhibit, cast(AE.ID as nvarchar) + '|' + cast(EXC.CriteriaID as nvarchar) as 'CriteriaID', CONCAT(AE.AceID,  ' - ',CASE WHEN  AE.Exhibit IS NULL OR AE.Exhibit = '' THEN '' ELSE CONCAT('V : ' , AE.Exhibit)  END, AE.Title, ' - ',	EXC.Criteria) FullCriteria FROM DBO.AceExhibit AE INNER JOIN ACEExhibitCriteria AS EXC ON EXC.AceID = AE.AceID AND EXC.TeamRevd = AE.TeamRevd AND EXC.Criteria IS NOT NULL ORDER BY AE.AceID" SelectCommandType="Text"></asp:SqlDataSource>
                        </div>
                        <div class="col-2">
                            <asp:Button ID="btnAddAceExhibit" runat="server" Text="Manually Add Exhibit IDs" CssClass="btn" Width="180px" ValidationGroup="AddAceExhibit" OnClick="btnAddAceExhibit_Click" BackColor="#203864" ForeColor="White" />
                        </div>
                    </div>
                    <asp:SqlDataSource ID="sqlVeteranOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" CancelSelectOnNullParameter="false"  
                         SelectCommand="SELECT distinct EX.ID AS Id, 
	                                           EX.AceID + ' ' + EX.Title + ' V' + EX.VersionNumber + ' - ' + EXC.Criteria AS Title, 
	                                           EXC.CriteriaID as CriteriaID 
                                          FROM ACEExhibit AS EX 
                                         INNER JOIN ACEExhibitCriteria AS EXC ON EXC.AceID = EX.AceID AND EXC.TeamRevd = EX.TeamRevd 
														                                              AND EXC.StartDate = EX.StartDate 
															                                          AND EXC.EndDate = EX.EndDate 
															                                          AND EXC.Criteria IS NOT NULL  
                                         LEFT OUTER JOIN VeteranACECourse AS VC ON VC.AceID = EX.AceID AND VC.TeamRevd = EX.TeamRevd 
                                                                                                  AND VC.StartDate = EX.StartDate 
													                                              AND VC.EndDate = EX.EndDate
														                                          AND EXC.CriteriaID = VC.CriteriaID
                                         LEFT OUTER JOIN VeteranCreditRecommendations AS CR ON CR.AceID = EXC.AceID 
												                                          AND CR.TeamRevd = EXC.TeamRevd 
												                                          AND CR.StartDate = EXC.StartDate
												                                          AND CR.EndDate = EXC.EndDate 
												                                          AND CR.CriteriaID = EXC.CriteriaID
                                         LEFT OUTER JOIN VeteranOccupation AS VO ON VO.AceID = EXC.AceID 
												                                          AND VO.TeamRevd = EXC.TeamRevd 
												                                          AND VO.StartDate = EXC.StartDate
												                                          AND VO.EndDate = EXC.EndDate 
												                                          AND VO.CriteriaID = EXC.CriteriaID
                                          WHERE (CR.VeteranId = @VeteranId OR VC.VeteranId = @VeteranId OR VO.VeteranId = @VeteranId)
                                          AND (VC.CollegeId = @CollegeId OR VO.CollegeId = @CollegeId)" 
                        DeleteCommand="DeleteVeteranExhibit" OnDeleted="sqlVeteranOccupations_Deleted" DeleteCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="CollegeId" Type="Int32" />
                            <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:ControlParameter ControlID="hfDeleteId" PropertyName="Value" Name="Id" Type="Int32" />
                            <asp:ControlParameter ControlID="hfDeleteCriteriaId" PropertyName="Value" Name="CriteriaID" Type="Int32" />
                            <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="CollegeId" Type="Int32" />
                            <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
                        </DeleteParameters>
                    </asp:SqlDataSource>
                    <telerik:RadGrid ID="rgVeteranOccupations" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlVeteranOccupations" AllowFilteringByColumn="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" AllowAutomaticInserts="true" ShowHeader="false">
                        <ClientSettings AllowKeyboardNavigation="true">
                            <Selecting AllowRowSelect="true"></Selecting>
                            <ClientEvents />
                        </ClientSettings>
                        <MasterTableView Name="ParentGrid" DataSourceID="sqlVeteranOccupations" PageSize="12" DataKeyNames="Id" CommandItemDisplay="None" CommandItemSettings-ShowAddNewRecordButton="true" EnableHierarchyExpandAll="true" AllowFilteringByColumn="false" CommandItemSettings-AddNewRecordText="Add an Occupation" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                            <Columns>
                                <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="CriteriaID" UniqueName="CriteriaID" Display="false" ReadOnly="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Title" UniqueName="Title" ReadOnly="true">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                    <ItemTemplate>
                                        <div class="btn btn-primary" onclick="ShowConfirmDeletedExhibits('<%#Eval("Id") %>', '<%#Eval("CriteriaID") %>' )"><i class="fa fa-trash" aria-hidden="true"></i> </div>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                    <telerik:GridDropDownListColumnEditor ID="CEDropdown" DropDownStyle-Width="625px" runat="server" />
                </ContentTemplate>
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalNA" runat="server" Title="Not Applicable" Width="550px" Height="200px" Behaviors="Close" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <div class="row">
                        <div class="col" style="text-align:center">
                            <p><h4>Which action do you want to apply?</h4></p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col" style="text-align:left">
                            <telerik:RadButton ID="btnConfirm" runat="server" OnClientClicked="ShowConfirm" Text="All Students" AutoPostBack="false"></telerik:RadButton>
                        </div>
                        <div class="col" style="text-align:right">
                            <telerik:RadButton ID="btnNAOnlyOne" runat="server"  OnClick="btnNAOnlyOne_Click" Text="Only This Student"></telerik:RadButton>
                        </div>
                        <div class="col" style="text-align:right">
                            <telerik:RadButton ID="btnCancel" runat="server" Text="Cancel" OnClientClicked="CancelModalNA"></telerik:RadButton>
                        </div>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalConfirm" runat="server" Title="Not Applicable" Width="550px" Height="200px" Behaviors="Close" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <div class="row">
                        <div class="col" style="text-align:center">
                            <p><h4>Are you sure you want to apply this to all students?</h4></p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col" style="text-align:right">
                            <telerik:RadButton ID="btnNAAll" runat="server" Text="Yes" OnClick="btnNAAll_Click"></telerik:RadButton>
                        </div>
                        <div class="col" style="text-align:left">
                            <telerik:RadButton ID="btnCancelConfirm" runat="server" Text="Cancel" OnClientClicked="CancelModalConfirm" AutoPostBack="false"></telerik:RadButton>
                        </div>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalApplicable" runat="server" Title="Make Applicable" Width="550px" Height="200px" Behaviors="Close" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <div class="row">
                        <div class="col" style="text-align:center">
                            <p><h4>Which action do you want to apply?</h4></p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col" style="text-align:left">
                            <telerik:RadButton ID="btnConfirmAplicable" runat="server" OnClientClicked="ShowConfirmApplicable" Text="All Students" AutoPostBack="false"></telerik:RadButton>
                        </div>
                        <div class="col" style="text-align:right">
                            <telerik:RadButton ID="btnApplicableOnlyOne" runat="server"  OnClick="btnApplicableOnlyOne_Click" Text="Only This Student"></telerik:RadButton>
                        </div>
                        <div class="col" style="text-align:right">
                            <telerik:RadButton ID="btnCancelAplicable" runat="server" Text="Cancel" OnClientClicked="CancelModalApplicable"></telerik:RadButton>
                        </div>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalConfirmApplicable" runat="server" Title="Make Applicable" Width="550px" Height="200px" Behaviors="Close" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <div class="row">
                        <div class="col" style="text-align:center">
                            <p><h4>Are you sure you want to apply this to all students?</h4></p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col" style="text-align:right">
                            <telerik:RadButton ID="btnApplicableAll" runat="server" Text="Yes" OnClick="btnApplicableAll_Click"></telerik:RadButton>
                        </div>
                        <div class="col" style="text-align:left">
                            <telerik:RadButton ID="btnCancelConfirmApplicable" runat="server" Text="Cancel" OnClientClicked="CancelModalConfirmApplicable" AutoPostBack="false"></telerik:RadButton>
                        </div>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalConfirmReverseElective" runat="server" Title="Make Applicable" Width="550px" Height="220px" Behaviors="Close" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <div class="row">
                        <div class="col" style="text-align:center">
                            <p><h4>Are you sure you want to reverse this elective articulation?</h4></p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col" style="text-align:center">
                            <telerik:RadButton ID="btnReverseElective" runat="server" OnClick="btnReverseElective_Click" Text="Yes"></telerik:RadButton>
                        </div>
                        <div class="col" style="text-align:center">
                            <telerik:RadButton ID="btnCancelReverseElective" runat="server" Text="Cancel" OnClientClicked="CancelModalConfirmReverseElective"></telerik:RadButton>
                        </div>
                     </div>
                </ContentTemplate>
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalElectiveUnits" runat="server" Title="Articulate as Elective" Width="550px" Height="200px" Behaviors="Close" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <asp:SqlDataSource ID="sqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT unit_id,unit FROM tblLookupUnits WHERE college_id = 1 AND CAST(unit AS float) <= @Units AND unit_id IN (SELECT unit_id FROM Course_IssuedForm WHERE college_id = @CollegeID AND subject_id = (SELECT subject_id FROM tblSubjects WHERE COLLEGE_ID = @CollegeID AND SUBJECT LIKE '%MIL-CRE%')) ORDER BY CAST(unit AS float) DESC" SelectCommandType="Text">
                        <SelectParameters>
                            <asp:ControlParameter Name="CollegeID" ControlID="hfCollegeID" PropertyName="value" Type="Int32" />
                            <asp:ControlParameter Name="Units" ControlID="hfUnits" PropertyName="value" Type="Double" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <div class="row">
                        <div class="col" style="text-align:center">
                            Applied Credits :
                            <telerik:RadComboBox ID="rbcUnits" DataSourceID="sqlUnits" DataTextField="unit" DataValueField="unit_id" Width="50%" ToolTip="Search units" runat="server" MarkFirstMatch="true" >
                            </telerik:RadComboBox>
                            <asp:CompareValidator runat="server" ID="rfvUnits" ValidationGroup="validateUnits" ValueToCompare="" Display="Dynamic" Operator="NotEqual" ControlToValidate="rbcUnits" ErrorMessage="* Required" ForeColor="Red" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col" style="text-align:center">
                            <telerik:RadButton ID="btnElectiveUnits" runat="server" OnClick="btnElectiveUnits_Click" Text="Ok" ValidationGroup="validateUnits"></telerik:RadButton>
                        </div>
                        <div class="col" style="text-align:center">
                            <telerik:RadButton ID="btnCancelElectiveUnits" runat="server" Text="Cancel" OnClientClicked="CancelModalElectiveUnits"></telerik:RadButton>
                        </div>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalConfirmDeletedExhibits" runat="server" Title="Deleted occupation" Width="550px" Height="220px" Behaviors="Close" Modal="true" VisibleStatusbar="false">
                <ContentTemplate>
                    <div class="row">
                        <div class="col" style="text-align: center">
                            <p>
                                <h4>Are you sure you want to remove this exhibit / credit recommendation?</h4>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col" style="text-align: right">
                            <telerik:RadButton ID="btnDeleteExhibit" runat="server" Text="Yes" OnClick="btnDeleteExhibit_Click" ></telerik:RadButton>
                        </div>
                        <div class="col" style="text-align: left">
                            <telerik:RadButton ID="btnCancelExhibit" runat="server" Text="Cancel" OnClientClicked="CancelModalConfirmExhibit" AutoPostBack="false"></telerik:RadButton>
                        </div>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>
    <telerik:RadNotification ID="rnStudent" runat="server" Position="Center" Width="650px" Height="430px" ShowCloseButton="true" ContentScrolling="Y" AutoCloseDelay="0"></telerik:RadNotification>
    <div class="row">
        <div class="col-12">
            <asp:Label ID="lblError" runat="server" ForeColor="Red" Font-Size="Small" Font-Bold="true" Visible="false"></asp:Label>
        </div>
    </div>
    <!-- STUDENT STATUS INFORMATION -->
    <div id="student_status_section" runat="server">
        <h2 class="section-header p-2 text-center">Student CPL Status</h2>
        <div class="row" style="white-space: nowrap">
            <div class="col text-center">
                <p>1. CPL Docs Verified</p>
                <div id="divDocUpload" runat="server" title="CPL Document has been uploaded successfully (JST, Industry Certificate, AP Scores, etc.)">
                    <i aria-hidden="true" style="font-size: 2.5em;"></i>
                    <%--<i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2.5em;"></i>--%>
                </div>
                <telerik:RadLabel ID="rlDocUpload" runat="server" Text="" Visible="false"></telerik:RadLabel>
            </div>
            <div class="col text-center" title="Student Educational Plan (SEP) created by counselor and major is designated.">
                <p>2. ED. Plan Created</p>
                <asp:Button runat="server" ID="btnEdPlan" ClientIDMode="Static" Style="display: none" OnClick="btnEdPlan_Click" />
                <div id="divEdPlan" runat="server">
                    <asp:HiddenField ID="hEdPlan" runat="server" Value="0" />
                    <i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2.5em; cursor: pointer;" onclick="document.getElementById('btnEdPlan').click()"></i>
                </div>
                <telerik:RadLabel ID="rlEdPlan" runat="server" Text=""></telerik:RadLabel>
            </div>
            <div class="col text-center" title="AREA E (JST/DD-214 or waived) credits have been verified via course catalog and applied.">
                <p>3. Global Credits Verified</p>
                <asp:Button runat="server" ID="btnGlobalCR" ClientIDMode="Static" Style="display: none" OnClick="btnGlobalCR_Click" />
                <div id="divGlobalCR" runat="server">
                    <asp:HiddenField ID="hGlobalCR" runat="server" Value="0" />
                    <i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2.5em; cursor: pointer;" onclick="document.getElementById('btnGlobalCR').click()"></i>
                </div>
                <telerik:RadLabel ID="rlGlobalCR" runat="server" Text=""></telerik:RadLabel>
            </div>
            <div class="col text-center" title="All Credit Recommendations (CRs) have been acted upon (Implemented, Not Applicable, etc.)  ">
                <p>4. Analysis Complete</p>
                <asp:Button runat="server" ID="btnAnalysis" ClientIDMode="Static" Style="display: none" OnClick="btnAnalysis_Click" />
                <div id="divAnalysis" runat="server">
                    <asp:HiddenField ID="hAnalysis" runat="server" Value="0" />
                    <i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2.5em; cursor: pointer;" onclick="document.getElementById('btnAnalysis').click()"></i>
                </div>
                <telerik:RadLabel ID="rlAnalysis" runat="server" Text=""></telerik:RadLabel>
            </div>
            <div class="col text-center" title="Status of IMPLEMENTED articulations are accurate and true on student’s behalf.">
                <p>5. Credits Applied to CPL Plan</p>
                <asp:Button runat="server" ID="btnApplied" ClientIDMode="Static" Style="display: none" OnClick="btnApplied_Click" />
                <div id="divApplied" runat="server">
                    <asp:HiddenField ID="hApplied" runat="server" Value="0" />
                    <i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2.5em; cursor: pointer;" onclick="document.getElementById('btnApplied').click()"></i>
                </div>
                <telerik:RadLabel ID="rlApplied" runat="server" Text=""></telerik:RadLabel>
            </div>
            <div class="col text-center" title="Counselor has reviewed ed. plan. Verifies all articulations (course, area, elective, global) are appropriate for SEP.  ">
                <p>6. Counselor Verified</p>
                <asp:Button runat="server" ID="btnCounselor" ClientIDMode="Static" Style="display: none" OnClick="btnCounselor_Click" />
                <div id="divCounselor" runat="server">
                    <asp:HiddenField ID="hCounselor" runat="server" Value="0" />
                    <i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2.5em; cursor: pointer;" onclick="document.getElementById('btnCounselor').click()"></i>
                </div>
                <telerik:RadLabel ID="rlCounselor" runat="server" Text=""></telerik:RadLabel>
            </div>
            <div class="col text-center" title="Student given opportunity to ACCEPT/DENY/APPEAL CPL Plan.">
                <p>7. Student Verified</p>
                <asp:Button runat="server" ID="btnStudent" ClientIDMode="Static" Style="display: none" OnClick="btnStudent_Click" />
                <div id="divStudent" runat="server">
                    <asp:HiddenField ID="hStudent" runat="server" Value="0" />
                    <i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2.5em; cursor: pointer;" onclick="document.getElementById('btnStudent').click()"></i>
                </div>
                <telerik:RadLabel ID="rlStudent" runat="server" Text=""></telerik:RadLabel>
            </div>
            <div class="col text-center" title="Awarded CPL in CPL Plan officially applied to official transcript and verified by A&R (successfully transferred on institutions ERP system).">
                <p>8. Transcribed</p>
                <asp:Button runat="server" ID="btnTranscribed" ClientIDMode="Static" Style="display: none" OnClick="btnTranscribed_Click" />
                <div id="divTranscribed" runat="server">
                    <asp:HiddenField ID="hTranscribed" runat="server" Value="0" />
                    <i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2.5em; cursor: pointer;" onclick="document.getElementById('btnTranscribed').click()"></i>
                </div>
                <telerik:RadLabel ID="rlTranscribed" runat="server" Text=""></telerik:RadLabel>
            </div>

        </div>
    </div>
    <!-- STUDENT STATUS INFORMATION -->

    <!-- STUDENT INFORMATION -->
    <h2 class="section-header p-2 text-center">Student Information</h2>
    <div class="row">
        <div class="col-12">
            <div class="row">
                <div class="col-1 d-flex justify-content-end align-items-center">
                    <telerik:RadLabel ID="rlname" runat="server" Font-Bold="true" Text="First Name:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <asp:TextBox runat="server" ID="txtFirstName" CssClass="form-control" placeholder="Enter First Name (Required)" Width="100%" MaxLength="50" BackColor="#ffffe0" TabIndex="1"></asp:TextBox>
                    <asp:HiddenField ID="hfFirstName" runat="server" ClientIDMode="Static" />
                    <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" Display="Dynamic" ValidationGroup="StudentInformation" ControlToValidate="txtFirstName" ErrorMessage="* Required" ForeColor="Red" Font-Size="X-Small"></asp:RequiredFieldValidator>
                </div>
                <div class="col-1 d-flex justify-content-end align-items-center">
                    <telerik:RadLabel ID="rlID" runat="server" Font-Bold="true" Text="ID #:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <asp:TextBox runat="server" ID="txtID" CssClass="form-control" placeholder="Enter ID" Width="100%" MaxLength="50" BackColor="#ffffe0" TabIndex="4"></asp:TextBox>
                    <asp:Label ID="lblErrorID" runat="server" Text="Registered ID" ForeColor="Red" Font-Size="X-Small" Visible="false"></asp:Label>
                    <asp:HiddenField ID="hfidn" runat="server" ClientIDMode="Static" />
                    <%--<asp:RequiredFieldValidator ID="rfvID" runat="server" Display="Dynamic" ControlToValidate="txtID" ValidationGroup="StudentInformation" ErrorMessage="* Required" ForeColor="Red" Font-Size="X-Small"></asp:RequiredFieldValidator>--%>
                </div>
                <div class="col-1 d-flex justify-content-end  align-items-center">
                    <telerik:RadLabel ID="rlCPLType" runat="server" Font-Bold="true" Text="CPL Type:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <asp:SqlDataSource ID="sqlCPLType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM CPLType"></asp:SqlDataSource>
                    <telerik:RadComboBox ID="ddlCPLType" DataSourceID="sqlCPLType" DataTextField="CPLTypeDescription" DataValueField="ID" runat="server" Width="100%" BackColor="#ffffe0" CheckBoxes="true" TabIndex="6">
                    </telerik:RadComboBox>
                </div>
                <div class="col-1 d-flex justify-content-end  align-items-center">
                    <telerik:RadLabel ID="rllProgram" runat="server" Font-Bold="true" Text="Program of Study:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select program_id, program + ' - ' + cast(coalesce(description,'') as varchar(50)) as program from Program_IssuedForm where college_id=@CollegeId and status = 0 order by program">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="CollegeId" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadComboBox ID="ddlProgram" DataSourceID="sqlPrograms" DataTextField="program" DataValueField="program_id" runat="server" Width="100%" BackColor="#ffffe0" CheckBoxes="true" TabIndex="8">
                    </telerik:RadComboBox>
                </div>
            </div>
            <div class="row">
                <div class="col-1 d-flex justify-content-end align-items-center">
                    <telerik:RadLabel ID="rlLastName" runat="server" Font-Bold="true" Text="Last Name:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <asp:TextBox runat="server" ID="txtLastName" CssClass="form-control" placeholder="Enter Last Name (Required)" Width="100%" MaxLength="50" BackColor="#ffffe0" TabIndex="2"></asp:TextBox>
                    <asp:HiddenField ID="hfLastName" runat="server" ClientIDMode="Static" />
                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" Display="Dynamic" ControlToValidate="txtLastName" ValidationGroup="StudentInformation" ErrorMessage="* Required" ForeColor="Red" Font-Size="X-Small"></asp:RequiredFieldValidator>
                </div>
                <div class="col-1 d-flex justify-content-end align-items-center">
                    <telerik:RadLabel ID="rlPhone" runat="server" Font-Bold="true" Text="Phone:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <asp:TextBox runat="server" ID="txtPhone" CssClass="form-control" placeholder="Enter phone" Width="100%" MaxLength="50" BackColor="#ffffe0" TabIndex="5"></asp:TextBox>
                </div>
                <div class="col-1 d-flex justify-content-end align-items-center">
                    <telerik:RadLabel ID="rlBranch" runat="server" Font-Bold="true" Text="Branch:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <asp:SqlDataSource ID="sqlBranch" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [LookupService]"></asp:SqlDataSource>
                    <telerik:RadDropDownList ID="ddlBranch" DataSourceID="sqlBranch" DataTextField="Description" DataValueField="id" runat="server" Width="100%" DefaultMessage="Select Branch" BackColor="#ffffe0" TabIndex="7" AppendDataBoundItems="true">
                    </telerik:RadDropDownList>
                </div>
                <div class="col-1 d-flex justify-content-end  align-items-center">
                    <telerik:RadLabel ID="rlGoals" runat="server" Font-Bold="true" Text="Program Goals:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <telerik:RadComboBox ID="ddlGoals" runat="server" Width="100%" BackColor="#ffffe0" CheckBoxes="true" TabIndex="9">
                        <Items>
                            <telerik:RadComboBoxItem Text="Local AA/AS" Value="0" />
                            <telerik:RadComboBoxItem Text="ADT" Value="1" />
                            <telerik:RadComboBoxItem Text="CSU" Value="2" />
                            <telerik:RadComboBoxItem Text="UC" Value="3" />
                            <telerik:RadComboBoxItem Text="Certificate" Value="4" />
                            <telerik:RadComboBoxItem Text="Private" Value="5" />
                            <telerik:RadComboBoxItem Text="Career Advancement" Value="6" />
                            <telerik:RadComboBoxItem Text="Other" Value="7" />
                        </Items>
                    </telerik:RadComboBox>
                </div>
            </div>
            <div class="row">
                
                <div class="col-1 d-flex justify-content-end align-items-center">
                    <telerik:RadLabel ID="rlEmail" runat="server" Font-Bold="true" Text="Email:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <asp:TextBox runat="server" ID="txtEmail" CssClass="form-control" placeholder="Enter email" Width="100%" MaxLength="300" BackColor="#ffffe0" TabIndex="3"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" Display="Dynamic" ControlToValidate="txtEmail" ErrorMessage="Invalid Email Format" ForeColor="Red" Font-Size="X-Small" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                    <%-- <asp:RequiredFieldValidator ID="rfvEmail" runat="server" Display="Dynamic" ControlToValidate="txtEmail" ValidationGroup="StudentInformation" ErrorMessage="* Required" ForeColor="Red" Font-Size="X-Small"></asp:RequiredFieldValidator>--%>
                    <asp:Label ID="lblerrorEmail" runat="server" Text="Registered Email" ForeColor="Red" Font-Size="X-Small" Visible="false"></asp:Label>
                    <asp:HiddenField ID="hfEmail" runat="server" ClientIDMode="Static" />
                </div>
                <div class="col-3">
                </div>
                <div class="col-3">
                </div>
                <div class="col-1 d-flex justify-content-end">
                    <telerik:RadLabel ID="rlTransfer" runat="server" Font-Bold="true" Text="Transfer Destination:"></telerik:RadLabel>
                </div>
                <div class="col-2">
                    <asp:TextBox runat="server" ID="rtbTransferDestination" CssClass="form-control" placeholder="" Width="100%" MaxLength="150" BackColor="#ffffe0" TabIndex="10"></asp:TextBox>
                </div>
            </div>
            <%--                 <div class="row">
                    <div class="col-6 d-flex justify-content-end align-items-center">
                        <telerik:RadLabel ID="rlMidleName" runat="server" Font-Bold="true" Text="Middle Name:"></telerik:RadLabel>
                    </div>
                    <div class="col-6">
                        <asp:TextBox runat="server" ID="txtMiddleName" CssClass="form-control" placeholder="Enter Middle Name" Width="100%" MaxLength="50" BackColor="#ffffe0" TabIndex="2"></asp:TextBox>
                        <asp:HiddenField ID="hfMiddleName" runat="server" ClientIDMode="Static" />
                    </div>
                    <div class="col-6 d-flex justify-content-end align-items-center">
                        <telerik:RadLabel ID="rlOrigin" runat="server" Font-Bold="true" Text="Origin:"></telerik:RadLabel>
                    </div>
                    <div class="col-6">
                        <asp:SqlDataSource ID="sqlOrigin" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [VeteranOrigin]"></asp:SqlDataSource>
                        <telerik:RadDropDownList ID="ddlOrigin" DataSourceID="sqlOrigin" DataTextField="Description" DataValueField="id" runat="server" Width="100%" DefaultMessage="Select Origin" BackColor="#ffffe0" TabIndex="7" OnClientSelectedIndexChanged="OnClientSelectedIndexChanged" AppendDataBoundItems="true">
                            <Items>
                                <telerik:DropDownListItem Text="" Value="" />
                            </Items>
                        </telerik:RadDropDownList>
                    </div>
                </div> --%>
            <%-- <div class="row">
                    <div class="col-6 d-flex  d-flex justify-content-end  align-items-center">
                        <asp:SqlDataSource ID="sqlEducationalBenefits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [EducationalBenefits]"></asp:SqlDataSource>
                        <telerik:RadLabel ID="rlBenefits" runat="server" Font-Bold="true" Text="Educational Benefits:"></telerik:RadLabel>
                    </div>
                    <div class="col-6">
                        <telerik:RadComboBox ID="rcbEducationalBenefits" DataSourceID="sqlEducationalBenefits" DataTextField="description" DataValueField="id" runat="server" BackColor="#ffffe0" Width="100%" DefaultMessage="Select Educational Benefits" DropDownAutoWidth="Enabled" OnClientSelectedIndexChanged="OnClientSelectedIndexChanged" AppendDataBoundItems="true">
                            <Items>
                                <telerik:RadComboBoxItem Text="" Value="" />
                            </Items>
                        </telerik:RadComboBox>
                    </div>
                    <div class="col-6 d-flex justify-content-end  align-items-center">
                        <telerik:RadLabel ID="rllProgram" runat="server" Font-Bold="true" Text="Program of Study:"></telerik:RadLabel>
                    </div>
                    <div class="col-6 d-flex justify-content-end">
                        <telerik:RadLabel ID="RadLabel3" runat="server" Font-Bold="true" Text="CPL Status:"></telerik:RadLabel>
                    </div>
                    <div class="col-6">
                        <asp:SqlDataSource ID="sqlCPLStatus" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [CPLStatus] ORDER BY RowOrder"></asp:SqlDataSource>
                        <telerik:RadDropDownList ID="rddlCPLStatus" DataSourceID="sqlCPLStatus" DataTextField="Description" DataValueField="ID" runat="server" Width="100%" DefaultMessage="Select Status" BackColor="#ffffe0" TabIndex="7" OnClientSelectedIndexChanged="OnClientSelectedIndexChanged" AppendDataBoundItems="true">
                            <Items>
                                <telerik:DropDownListItem Text="Select Status" Value="" />
                            </Items>
                        </telerik:RadDropDownList>
                    </div>
                </div> --%>
            <%-- <div style="padding-left: 20%;">
                    <telerik:RadLabel ID="rlReason" runat="server" Font-Bold="true" Text="Reason for visit:" Visible="false"></telerik:RadLabel>
                    <br />
                    <telerik:RadLabel ID="rlCheckApply" runat="server" Text="(Check all apply)" Font-Size="X-Small" Visible="false"></telerik:RadLabel>
                    <br />
                    <telerik:RadCheckBoxList runat="server" ID="ckblReason" AutoPostBack="false" Width="100%" CssClass="listCheck" TabIndex="8" Visible="false">
                        <ClientEvents OnSelectedIndexChanged="selectedIndexChanged" />
                        <Items>
                            <telerik:ButtonListItem Text="Counseling Appointment" Value="0" />
                            <telerik:ButtonListItem Text="General Inquiry" Value="1" />
                            <telerik:ButtonListItem Text="VA Statement of Responsibility" Value="2" />
                            <telerik:ButtonListItem Text="Educational Benefits Inquiry" Value="3" />
                            <telerik:ButtonListItem Text="Military Articulation Platform" Value="4" />
                            <telerik:ButtonListItem Text="Health Services" Value="5" />
                            <telerik:ButtonListItem Text="Tutoring" Value="6" />
                            <telerik:ButtonListItem Text="School Supplies/Materials" Value="7" />
                            <telerik:ButtonListItem Text="Computer/Printer" Value="8" />
                            <telerik:ButtonListItem Text="Homework/Study" Value="9" />
                            <telerik:ButtonListItem Text="Recreation" Value="10" />
                            <telerik:ButtonListItem Text="Others:" Value="11" />
                        </Items>
                    </telerik:RadCheckBoxList>

                </div>

                <telerik:RadTextBox ID="txtOtherDescription" runat="server" ClientIDMode="Static" MaxLength="200" Enabled="false"></telerik:RadTextBox>
            </div> --%>
        </div>
    </div>
    
    <!-- STUDENT INFORMATION -->

    
    <!-- UPLOAD DOCUMENTS NOTES AND NOTIFICATIONS -->
    <asp:Panel ID="pnlStudentDocuments" runat="server">
        <div class="row">
            <div class="col-4">
                <h3><b>Documents (JST, Ed Plan, Cert, Portfolio, Etc.) :</b></h3>
            </div>
            <div class="col-4">
                <h3><b>Note Concerning Student Plan :</b></h3>
            </div>
            <div class="col-4">
                <h3><b>Notifications :</b></h3>
            </div>
        </div>
        <div class="row">
            <div class="col-4">
                <div class="student-box">
                    <div class="RadListView">
                        <asp:SqlDataSource ID="sqlDocument" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT id, filename, ISNULL(DocumentTypeID, 0) AS 'DocumentTypeID' FROM VeteranDocuments where VeteranID = @veteranid and VeteranID <> 0 and VeteranID IS NOT NULL" SelectCommandType="Text">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="veteranid" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="sqlDocumentType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT [documenttypeid],[documenttypeDescription] FROM [dbo].[DocumentTypes]" SelectCommandType="Text"></asp:SqlDataSource>
                        <asp:HiddenField ID="hDocumentIDDelete" runat="server" />
                        <telerik:RadListView ID="rlvDocuments" DataSourceID="sqlDocument" runat="server" RenderMode="Lightweight" DataKeyNames="id" AllowPaging="false">
                            <ItemTemplate>
                                <fieldset class="fieldset itemFieldset">
                                    <div class="row">
                                        <div class="col-1">
                                            <i class="fa fa-check" aria-hidden="true" style="color: green; font-size: 2em"></i>
                                        </div>
                                        <div class="col-5">
                                            <span style="font-size: 1.2em;"><%# Eval("filename") %></span>
                                        </div>
                                        <div class="col-1 text-center">
                                            <asp:LinkButton ID="btnDownload" runat="server" ToolTip="Download/View file" OnClientClick=<%# Eval("id","javascript:window.open('/modules/popups/ConfirmDownload.aspx?ID={0}')") %>> <i class="fa fa-download" aria-hidden="true" style="font-size: 1.7em; color:black"></i></asp:LinkButton>
                                        </div>
                                        <%--<div class="col-1 text-center">
                                            <asp:LinkButton ID="btnDownload2" runat="server" ToolTip="Download/View file" OnClientClick=<%# Eval("id","javascript:window.open('/modules/popups/ConfirmDownload.aspx?ID={0}')") %>><i class="fa fa-eye" aria-hidden="true" style="font-size: 1.7em; color: black"></i></asp:LinkButton>
                                        </div>--%>
                                        <div class="col-1 text-center">
                                            <asp:LinkButton ID="btnDelete" runat="server" ToolTip="Delete file" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this file ?')){return false;}" OnClick="btnDelete_Click" CommandArgument='<%# Eval("id") %>'><i class="fa fa-trash" aria-hidden="true" style="font-size: 1.7em; color:black"></i></asp:LinkButton>
                                        </div>
                                        <div class="col-3">
                                            <telerik:RadDropDownList ID="ddlDocumenttype" DataSourceID="sqlDocumentType" DataTextField="documenttypeDescription" DataValueField="documenttypeid" runat="server" Width="100%" BackColor="#ffffe0"
                                                AppendDataBoundItems="true" SelectedValue='<%#Bind("DocumentTypeID") %>' OnClientDropDownOpening="OnClientDropDownOpening" Enabled="false">
                                                <Items>
                                                    <telerik:DropDownListItem Text="" Value="0" />
                                                </Items>
                                            </telerik:RadDropDownList>
                                        </div>
                                    </div>
                                </fieldset>
                            </ItemTemplate>
                        </telerik:RadListView>
                    </div>
                    <telerik:RadButton ID="btnUpload" runat="server" Text="Upload" CssClass="btn" BackColor="#203864" ForeColor="White" BorderStyle="Solid" AutoPostBack="false" BorderColor="White" OnClientClicked="OpenWnd" />
                </div>
            </div>
            <div class="col-4">
                <div class="student-box">
                    <telerik:RadTextBox RenderMode="Lightweight" runat="server" ID="txtNotes" Width="100%" Height="200px" TextMode="MultiLine" Resize="None" EmptyMessage="f.e., Student requested appeal of elegible credits 3 units in communication because it was listed as Do Not Articulate."></telerik:RadTextBox><br />
                </div>
            </div>
            <div class="col-4">
                <div class="student-box">
                    <asp:SqlDataSource ID="sqlNofication" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetVeteranNotifications" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="collegeid" Type="Int32" />
                            <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="veteranid" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <telerik:RadListView ID="rlvNotifications" DataSourceID="sqlNofication" runat="server" RenderMode="Lightweight" DataKeyNames="Description" AllowPaging="false">
                        <ItemTemplate>
                            <fieldset class="fieldset itemFieldset">
                                <span style="padding-left: 30px; font-size: 13px;"><i class="fa fa-exclamation-triangle" aria-hidden="true" style="color: #ffef33"></i> <%# Eval("Description") %> </span>
                            </fieldset>
                        </ItemTemplate>
                    </telerik:RadListView>
                </div>
            </div>
        </div>
    </asp:Panel>
    <!-- UPLOAD DOCUMENTS NOTES AND NOTIFICATIONS -->

    <div class="row" style="margin-bottom: 10px !important;">
        <div class="col-3 text-left">
            <b>Opt Out</b>
            <telerik:RadSwitch runat="server" ID="rsbOptOut" Checked="false" AutoPostBack="true" OnCheckedChanged="rsbOptOut_CheckedChanged">
            </telerik:RadSwitch>
        </div>
        <!-- SAVE STUDENT -->
        <div class="col-9 text-right" style="text-align: right;">
                <telerik:RadButton ID="btnNewStudent" runat="server" Text="Save" CssClass="btn" Width="200px" OnClick="btnNewStudent_Click" ValidationGroup="StudentInformation" BackColor="#203864" ForeColor="White" BorderStyle="Solid" AutoPostBack="true" BorderColor="White" ClientIDMode="Static" />
        </div>
        <!-- SAVE STUDENT -->
    </div>
    <!-- SAVE STUDENT -->

    <!-- STUDENT SUMMARY -->
    <asp:Panel ID="pnlStudentSummary" runat="server" Visible="false">
        <h2 class="section-header p-2 text-center">Student Status</h2>
        <div class="row">
            <div class="col-2">
            </div>
            <div class="col-8">
                <div class="row">
                    <div class="col-3  d-flex justify-content-end">
                        <telerik:RadLabel ID="rlName2" runat="server" Font-Bold="true" Text="Name:"></telerik:RadLabel>
                    </div>
                    <div class="col-3">
                        <asp:TextBox runat="server" ID="txtName" CssClass="form-control" Text="" Width="100%" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-3 d-flex justify-content-end">
                        <telerik:RadLabel ID="rlFinancial" runat="server" Font-Bold="true" Text="Financial Aid:"></telerik:RadLabel>
                    </div>
                    <div class="col-3">
                        <asp:DropDownList ID="ddlFinancial" runat="server" CssClass="form-control" Width="100%">
                            <asp:ListItem Value="0" Text="Incomplete" Selected="True" />
                            <asp:ListItem Value="1" Text="Completed" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-3 d-flex justify-content-end">
                        <telerik:RadLabel ID="rlConseling" runat="server" Font-Bold="true" Text="Counseling Appt:"></telerik:RadLabel>
                    </div>
                    <div class="col-3">
                        <asp:DropDownList ID="ddlConseling" runat="server" CssClass="form-control" BackColor="#ffffe0" Width="100%">
                            <asp:ListItem Value="0" Text="Incomplete" Selected="True" />
                            <asp:ListItem Value="1" Text="Completed" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-3 d-flex justify-content-end">
                        <telerik:RadLabel ID="rlOrientation" runat="server" Font-Bold="true" Text="Orientation:"></telerik:RadLabel>
                    </div>
                    <div class="col-3">
                        <asp:DropDownList ID="ddlOrientation" runat="server" CssClass="form-control" BackColor="#ffffe0" Width="100%">
                            <asp:ListItem Value="0" Text="Incomplete" Selected="True" />
                            <asp:ListItem Value="1" Text="Completed" />
                        </asp:DropDownList>
                    </div>

                </div>
                <div class="row">
                    <div class="col-3 d-flex justify-content-end">
                        <telerik:RadLabel ID="rlAssessment" runat="server" Font-Bold="true" Text="Assessment:"></telerik:RadLabel>
                    </div>
                    <div class="col-3">
                        <asp:DropDownList ID="ddlAssessment" runat="server" CssClass="form-control" BackColor="#ffffe0" Width="100%">
                            <asp:ListItem Value="0" Text="Incomplete" Selected="True" />
                            <asp:ListItem Value="1" Text="Completed" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-3 d-flex justify-content-end">
                        <telerik:RadLabel ID="rlJST2" runat="server" Font-Bold="true" Text="JST:"></telerik:RadLabel>
                    </div>
                    <div class="col-3">
                        <asp:DropDownList ID="ddlJST" runat="server" CssClass="form-control" Width="100%" Enabled="false">
                            <asp:ListItem Value="0" Text="Unsubmitted" Selected="True" />
                            <asp:ListItem Value="1" Text="Submitted" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-3 d-flex justify-content-end">
                        <telerik:RadLabel ID="rlDD" runat="server" Font-Bold="true" Text="DD-214:"></telerik:RadLabel>
                    </div>
                    <div class="col-3">
                        <asp:DropDownList ID="ddlDD214" runat="server" CssClass="form-control" Width="100%" Enabled="false">
                            <asp:ListItem Value="0" Text="Unsubmitted" Selected="True" />
                            <asp:ListItem Value="1" Text="Submitted" />
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="col-2">
            </div>
        </div>

    </asp:Panel>
    <!-- STUDENT SUMMARY -->

    <!-- Eligible Credits -->
    <asp:Panel ID="pnlMilitaryCredits" runat="server">
        <telerik:RadNotification ID="rnElegibleCredits" runat="server" Position="Center" Width="400px" Height="200px"></telerik:RadNotification>
        <asp:SqlDataSource ID="sqlCourses" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT CIF.outline_id, CONCAT(S.subject,' ', CIF.course_number, ' - ', CIF.course_title) CourseDescription FROM Course_IssuedForm CIF JOIN tblSubjects S ON CIF.subject_id = S.subject_id WHERE CIF.status = 0 AND CIF.college_id = @CollegeId ORDER BY S.subject, CIF.course_number"
            SelectCommandType="Text">
            <SelectParameters>
                <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="CollegeId" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlMilitaryCredits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetEligibleCredits" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="hfCollegeID" PropertyName="Value" Name="CollegeId" Type="Int32" />
                <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <h2 class="section-header p-2 text-center">Eligible Credits</h2>
        <asp:HiddenField ID="hfRowColor" runat="server" />
        <asp:HiddenField ID="hfAceID" runat="server" />
																		
        <p class="p-2">Below are the credits for which the student is eligible. Some may already be articulated. For those that need an articulation click on action and choose the appropriate  option.  Within the table, if you choose "Apply Credit" to this student, the total confirmed credits are shown at the bottom of the page.</p>
        <telerik:RadGrid ID="rgMilitaryCredits" runat="server" CellSpacing="-1" DataSourceID="sqlMilitaryCredits" Width="100%" AllowAutomaticUpdates="true" AllowSorting="true" ShowFooter="true" OnItemDataBound="rgMilitaryCredits_ItemDataBound" OnItemCommand="rgMilitaryCredits_ItemCommand" HeaderStyle-BorderColor="#CFD8DC" HeaderStyle-BorderStyle="Solid" HeaderStyle-BorderWidth="1px"  >
            <GroupingSettings CaseSensitive="false" />
            <ClientSettings Resizing-AllowColumnResize="true" Resizing-ResizeGridOnColumnResize="true">
                <Scrolling AllowScroll="false" UseStaticHeaders="false" />
            </ClientSettings>
            <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlMilitaryCredits" CommandItemDisplay="Top" PageSize="50" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" Column="false" AllowPaging="true" AlternateRowColor=true AlternatingItemStyle-BackColor="#CFD8DC" AllowMultiColumnSorting="true">
                <CommandItemTemplate>

                    <div class="commandItems">
                        <div style="float:left;"> 
                            <telerik:RadButton runat="server" ID="btnViewCPLPlan" CommandName="ViewCPLPlan" Text="VIEW CPL PLAN" ToolTip="" Font-Bold="true">
                            </telerik:RadButton>
                            <telerik:RadButton runat="server" ID="btnViewJST" CommandName="ViewJST" Text="VIEW JST" ToolTip=""  Font-Bold="true">
                            </telerik:RadButton>
                            <telerik:RadButton runat="server" ID="btnExhibit" CommandName="Exhibit" Text="MANUALLY ADD EXHIBIT" ToolTip=""  Font-Bold="true">
                            </telerik:RadButton>
                            <telerik:RadButton runat="server" ID="btnNewExhibit" CommandName="NewExhibit" Text="CREATE NEW CPL EXHIBIT" ToolTip=""  Font-Bold="true" Visible="false">
                            </telerik:RadButton>
                        </div>
                        <div style="float:right;">
                            <telerik:RadButton runat="server" ID="btnRefresh" CommandName="Refresh" Text="REFRESH" ToolTip="">
                            </telerik:RadButton>
                        </div>
                    </div>
                </CommandItemTemplate>
                <NoRecordsTemplate>
                    <p>No records to display</p>
                </NoRecordsTemplate>
                <Columns>
                    <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn UniqueName="Actions" HeaderText="ACTION" HeaderStyle-Width="200px" AllowFiltering="false" EnableHeaderContextMenu="false" Exportable="false" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <telerik:RadDropDownList ID="ddlAction" runat="server" AppendDataBoundItems="true" Width="100%" AutoPostBack="True" OnSelectedIndexChanged="ddlAction_SelectedIndexChanged">
                                <Items>
                                    <telerik:DropDownListItem Text="ACTION" Value="0" />
                                    <telerik:DropDownListItem Text="Apply Credit" Value="1" />
                                    <telerik:DropDownListItem Text="Articulate as Course" Value="2" />
                                    <telerik:DropDownListItem Text="Articulate as Area" Value="3" />
                                    <telerik:DropDownListItem Text="Articulate as Elective" Value="4" />
                                    <telerik:DropDownListItem Text="Reverse Elective" Value="5" />
                                    <telerik:DropDownListItem Text="Not Applicable (NA)" Value="6" />
                                    <telerik:DropDownListItem Text="View Articulate" Value="7" />
                                    <telerik:DropDownListItem Text="Add/Edit Notes" Value="8" />
                                    <telerik:DropDownListItem Text="Make Applicable" Value="9" />
                                </Items>
                            </telerik:RadDropDownList>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn UniqueName="CourseType" DataField="CourseType" SortExpression="CourseType" HeaderText="TYPE" AllowFiltering="False" HeaderStyle-Font-Bold="true" HeaderStyle-Width="120px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn UniqueName="RoleName" DataField="RoleName" SortExpression="RoleName" HeaderText="STATUS" AllowFiltering="False" HeaderStyle-Width="120px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn UniqueName="Criteria" DataField="Criteria" SortExpression="Criteria" HeaderText="CREDIT RECOMMENDATIONS (Units)" AllowFiltering="False" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn UniqueName="SelectedCreditRecommendation" HeaderText="Credit Recommendation" HeaderStyle-Font-Bold="true" HeaderStyle-Width="360px" AllowFiltering="true" EnableHeaderContextMenu="false" HeaderTooltip="All Credit Recommendations for an exhibit are grouped in rows." DataField="Criteria" SortExpression="Criteria" Display="false">
                        <ItemTemplate>
                            <telerik:RadTextBox ID="rtbCreditRecommendation" Width="100%" runat="server" Wrap="true" Text='<%# Bind("Criteria")%>' RenderMode="Lightweight"></telerik:RadTextBox>
                            <telerik:RadLabel CssClass="credit-recommendation" ID="rlCreditRecommendations" runat="server" Text='<%# Bind("Criteria")%>'></telerik:RadLabel>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn UniqueName="Course" DataField="Course" SortExpression="Course" HeaderText="COLLEGE COURSE" AllowFiltering="False" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="AceExhibit" HeaderText="Exhibit" DataField="AceExhibit" UniqueName="AceExhibit" AllowFiltering="False" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="" ReadOnly="true" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn UniqueName="ExhibitLink" SortExpression="AceExhibit" HeaderText="EXHIBIT" AllowFiltering="False" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                        <ItemTemplate>
                            <asp:HyperLink NavigateUrl="javascript:showExhibitInfo();" runat="server" ID="hlExhibit" Text="" Font-Underline="true"></asp:HyperLink>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn UniqueName="Source" DataField="Source" SortExpression="Source" HeaderText="SOURCE" AllowFiltering="False" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn UniqueName="Level" DataField="Level" HeaderText="LEVEL" AllowFiltering="false" HeaderStyle-Width="70px" EnableHeaderContextMenu="false" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        </telerik:GridBoundColumn>
<%--                    <telerik:GridTemplateColumn UniqueName="Level" HeaderText="LEVEL" AllowFiltering="false" HeaderStyle-Width="70px" EnableHeaderContextMenu="false" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            L
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>--%>
                    <telerik:GridNumericColumn UniqueName="EligibleCredits" DataField="EligibleCredits" SortExpression="EligibleCredits" HeaderText="ELIGIBLE CREDITS" AllowFiltering="False" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Aggregate="Sum" DecimalDigits="1" FooterAggregateFormatString="ELIGIBLE CREDITS {0:###,##0.0}" FooterStyle-HorizontalAlign="Center" DataType="System.Double" DataFormatString="{0:###,##0.0}" EmptyDataText="" ReadOnly="true" HeaderTooltip="Eligible Value">
                    </telerik:GridNumericColumn>
                    <telerik:GridNumericColumn UniqueName="Units" DataField="Units" SortExpression="Units" HeaderText="APPLIED CREDITS" AllowFiltering="False" HeaderStyle-Width="100px" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Aggregate="Sum" DecimalDigits="1" FooterAggregateFormatString="APPLIED CREDITS {0:###,##0.0}" FooterStyle-HorizontalAlign="Center" DataType="System.Double" DataFormatString="{0:###,##0.0}" EmptyDataText="" ReadOnly="true" HeaderTooltip="Unit Value will be shown once either the Articulation or Elective has been created">
                    </telerik:GridNumericColumn>
                    <telerik:GridTemplateColumn UniqueName="Notes" DataField="Notes" SortExpression="Notes" HeaderText="NOTES" AllowFiltering="False" HeaderStyle-Width="80px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                        <ItemTemplate>
							<telerik:RadToolTip RenderMode="Lightweight" runat="server" ID="ttNotes" ShowEvent="OnMouseOver" RelativeTo="Element" Animation="Slide" TargetControlID="divNotes" IsClientID="false" HideEvent="LeaveTargetAndToolTip" Position="MiddleLeft">
                                <div>
                                    <span>
                                        <%# DataBinder.Eval(Container, "DataItem.Notes")%>
                                    </span>
                                </div>
                            </telerik:RadToolTip>																						  				 
                            <div id="divNotes" runat="server" style="display: none">
                                <i class="fa fa-comments-o" aria-hidden="true" style="font-size: 2em; cursor: pointer;"></i>
                            </div>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn UniqueName="CplPlanStatus" SortExpression="CplPlanStatus" HeaderText="CPL PLAN STATUS" AllowFiltering="False" HeaderStyle-Width="80px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <div id="divImplementation" runat="server" style="color: green">
                                <i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2em;" title="Applied to CPL Plan"></i>
                            </div>
                            <div id="divOther" runat="server" style="color: #ffef33" title="In Process">
                                <i class="fa fa-exclamation-triangle" aria-hidden="true" style="font-size: 2em;"></i>
                            </div>
                            <div id="divNull" runat="server" style="color: red" title="Needs Action">
                                <i class="fa fa-question-circle" aria-hidden="true" style="font-size: 2em;"></i>
                            </div>
                            <div id="divNA" runat="server" style="color: gray; font-size: 1.5em;" title="Not Applicable">
                                <span><strong>NA</strong></span>
                            </div>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn UniqueName="DNA" DataField="DNA" SortExpression="DNA" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn UniqueName="JSTOrder" DataField="JSTOrder" SortExpression="JSTOrder" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ExistOtherColleges" UniqueName="ExistOtherColleges" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Elective" UniqueName="Elective" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="VeteranEligibleID" UniqueName="VeteranEligibleID" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AceExhibitID" UniqueName="AceExhibitID" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="outline_id" EmptyDataText="" UniqueName="outline_id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" EmptyDataText="">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="StageOrder" UniqueName="StageOrder" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AceType" UniqueName="ArticulationType" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AceType" UniqueName="EntityType" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CourseType" UniqueName="CourseType" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Criteria2" UniqueName="Criteria2" Display="false">
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <br />
        <h2 class="mb-2" style="display:none">Applied Credits</h2>
        <asp:SqlDataSource ID="sqlSelected" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT DISTINCT a.ExhibitID, EC.id, ec.ArticulationID, ae.AceID, ae.TeamRevd, ae.AceType as EntityType, ae.StartDate, ae.EndDate, ec.outline_id, ae.Title,  CASE WHEN EC.DefaultAreaEGlobalCreditID IS NULL THEN Concat(ae.AceID , ' ' , ae.Title) ELSE 'Military Training' END AS AceExhibit, CASE WHEN [subject] IN('CSU GE','IGETC') THEN  course_title ELSE Concat([subject] , '-' , course_number , ' ' , course_title) END Course, CASE WHEN EC.DefaultAreaEGlobalCreditID IS NULL or EC.DefaultAreaEGlobalCreditID = 0  THEN CASE WHEN C.CourseType = 1 THEN cast(u.unit as float) ELSE (SELECT TOP 1 CASE WHEN ISNUMERIC( SUBSTRING(Criteria, 1, 1) ) = 1 THEN SUBSTRING(Criteria,PATINDEX('%[0-9]%', Criteria), (CASE WHEN PATINDEX('%[^0-9]%', STUFF(Criteria, 1, (PATINDEX('%[0-9]%', Criteria) - 1), '')) = 0 THEN LEN(Criteria) ELSE (PATINDEX('%[^0-9]%', STUFF(Criteria, 1, (PATINDEX('%[0-9]%', Criteria) - 1), ''))) - 1 END ) ) ELSE 0 END FROM ArticulationCriteria WHERE ArticulationID = A.ArticulationID AND ArticulationType = A.ArticulationType ) END ELSE cast(DAGU.unit as float) END  Units, case when ec.ArticulationID <> 0 then STUFF((SELECT distinct ',' + Criteria FROM ArticulationCriteria ac join Articulation art ON ac.ArticulationID = art.ArticulationID and ac.ArticulationType =art.ArticulationType where art.AceID = a.AceID AND art.TeamRevd = a.TeamRevd AND art.outline_id = a.outline_id  FOR XML PATH('') ), 1, 1, '') else ec.criteria end  Criteria , CASE WHEN (EC.DefaultAreaEGlobalCreditID IS NULL) THEN aes.ShortDescription ELSE 'DD-214/JST' END as 'Source' , case when ec.outline_id <> 0 then STUFF((SELECT distinct ',' + Criteria FROM ArticulationCriteria ac join Articulation art ON ac.ArticulationID = art.ArticulationID and ac.ArticulationType =art.ArticulationType where art.AceID = a.AceID AND art.TeamRevd = a.TeamRevd AND art.outline_id = a.outline_id  FOR XML PATH('') ), 1, 1, '') else ec.Criteria end SelectedCriteria, EC.DefaultAreaEGlobalCreditID FROM ElegibleCredits EC LEFT OUTER JOIN Articulation as a on EC.ArticulationID = a.id  LEFT OUTER JOIN Course_IssuedForm as c on c.outline_id = EC.outline_id  LEFT OUTER JOIN tblSubjects as s on s.subject_id = c.subject_id   LEFT OUTER JOIN tblLookupUnits u on c.unit_id = u.unit_id LEFT OUTER JOIN ACEExhibit ae on EC.AceExhibitID = AE.ID left outer join ACEExhibitSource aes on ae.SourceID = aes.Id LEFT OUTER JOIN DefaultAreaEGlobalCredit DAG ON EC.DefaultAreaEGlobalCreditID = DAG.ID LEFT OUTER JOIN tblLookupUnits DAGU ON DAG.Min_Unit_id = DAGU.unit_id WHERE EC.veteranid = @VeteranID order by EC.DefaultAreaEGlobalCreditID"
            SelectCommandType="Text">
            <SelectParameters>
                <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <telerik:RadGrid ID="rgSelected" runat="server" CellSpacing="-1" DataSourceID="sqlSelected" Width="100%" AllowAutomaticUpdates="true" PageSize="50" AllowSorting="true" MasterTableView-AllowMultiColumnSorting="true" ShowFooter="true" EnableLinqExpressions="false" AllowFilteringByColumn="false" AllowMultiRowSelection="true" OnItemCommand="rgSelected_ItemCommand" OnItemDataBound="rgSelected_ItemDataBound" Visible="false">
            <GroupingSettings CaseSensitive="false" />
            <ClientSettings>
                <Selecting AllowRowSelect="true" />
                <ClientEvents OnRowDblClick="RowDblClick"></ClientEvents>
            </ClientSettings>
            <MasterTableView AutoGenerateColumns="False" DataSourceID="sqlSelected" CommandItemDisplay="Top" PageSize="20" CommandItemSettings-ShowAddNewRecordButton="false" NoMasterRecordsText="No records to display" EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" AllowFilteringByColumn="false" CommandItemSettings-ShowExportToExcelButton="true" AllowPaging="true" CommandItemSettings-ExportToExcelText="Export to Excel" EditFormSettings-EditColumn-Resizable="true">
                <CommandItemTemplate>
                    <div class="commandItems">
                        <telerik:RadButton runat="server" ID="RadButton1" ButtonType="StandardButton" Text="Delete" CommandName="Delete" ToolTip="Delete selected articulation(s)">
                            <ContentTemplate>
                                <i class='fa fa-trash'></i><span>Delete selected articulations</span>
                            </ContentTemplate>
                            <ConfirmSettings ConfirmText="Are you sure you want to Delete the selected articulations?" />
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>
                <NoRecordsTemplate>
                    <p>No records to display</p>
                </NoRecordsTemplate>
                <Columns>
                    <telerik:GridClientSelectColumn UniqueName="selectCheckbox" HeaderStyle-Width="30px"></telerik:GridClientSelectColumn>
                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="190px" AllowFiltering="false" EnableHeaderContextMenu="false" Exportable="false" HeaderText="Action" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <div class="d-flex align-items-center justify-content-center"></div>
                            <asp:LinkButton runat="server" ToolTip="Delete Articulation" CommandName="DeleteRow" ID="btnDeleteA" Text='' CssClass="btn btn-link m-2" Width="60px">
                                <p><i class="fa fa-trash" aria-hidden="true"></i></p>
                                <p>Delete</p>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ExhibitID" UniqueName="ExhibitID" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="DefaultAreaEGlobalCreditID" UniqueName="DefaultAreaEGlobalCreditID" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AceID" UniqueName="AceID" Display="false" EmptyDataText="">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ArticulationID" UniqueName="ArticulationID" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="TeamRevd" UniqueName="TeamRevd" DataFormatString="{0:MM/dd/yyyy}" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="StartDate" UniqueName="StartDate" Display="false" DataFormatString="{0:MM/dd/yyyy}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="EndDate" UniqueName="EndDate" Display="false" DataFormatString="{0:MM/dd/yyyy}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="EntityType" UniqueName="EntityType" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="AceExhibit" HeaderText="Exhibit" DataField="AceExhibit" UniqueName="AceExhibit" AllowFiltering="False" HeaderStyle-Width="240px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn UniqueName="ExhibitLink" HeaderText="Exhibit" SortExpression="Title" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true">
                        <ItemTemplate>
                            <asp:HyperLink NavigateUrl="javascript:showExhibitInfo();" runat="server" ID="HyperLink1" Text="" Font-Underline="true"></asp:HyperLink>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn SortExpression="Source" HeaderText="Exhibit Source" DataField="Source" UniqueName="Source" AllowFiltering="False" HeaderStyle-Width="50px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="" ReadOnly="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="Course" HeaderText="College Course" DataField="Course" UniqueName="Course" AllowFiltering="False" HeaderStyle-Width="200px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px" DefaultInsertValue="" ReadOnly="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn SortExpression="Criteria" HeaderText="Credit Recommendations" DataField="Criteria" UniqueName="Criteria" AllowFiltering="False" HeaderStyle-Width="300px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="150px">
                    </telerik:GridBoundColumn>
                    <telerik:GridNumericColumn SortExpression="Units" HeaderText="Units" DataField="Units" UniqueName="Units" AllowFiltering="False" HeaderStyle-Width="80px" HeaderStyle-Font-Bold="true" FilterControlWidth="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Aggregate="Sum" DecimalDigits="1" FooterAggregateFormatString="Total :{0:### ##0.0}" DataType="System.Double" DataFormatString="{0:### ##0.0}">
                    </telerik:GridNumericColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <br />
    </asp:Panel>
    <!-- Eligible Credits -->
    <div class="row" style="display:none">
        <div class="col-12">
            <br />
            <h2 class="mb-2">Notes / Comments</h2>
            <telerik:RadEditor runat="server" ID="reNotes" ContentAreaMode="Div" NewLineMode="Br" EditModes="Design" Height="150px" Width="100%" RenderMode="Lightweight">
                <Tools>
                    <telerik:EditorToolGroup Tag="Formatting">
                        <telerik:EditorTool Name="Bold" />
                    </telerik:EditorToolGroup>
                </Tools>
                <Content>
                </Content>
                <TrackChangesSettings CanAcceptTrackChanges="False" />
            </telerik:RadEditor>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        /* OPEN POPUP */
        function OpenWnd() {
            var wnd = $find("<%= modalUpload.ClientID %>");
            wnd.show();
        }

        /* ddlDocumenttype */
        function OnClientDropDownOpening(sender, eventArgs) {
            eventArgs.set_cancel(true);
        }

        //var unsaved = false;
        //$(document).on('change', '.form-control', function () {
        //    unsaved = true;
        //});
        //function OnClientSelectedIndexChanged(sender, eventArg) {
        //    unsaved = true;
        //}
        //function ClearUnSaved(sender, eventArgs) {
        //    unsaved = false;
        //}
        //function unloadPage() {
        //    if (unsaved) {
        //        return "Notice! You have unsaved changes to Student Information. Are you sure you wish to leave?";
        //    }
        //}
        //window.onbeforeunload = unloadPage;

        /* STUDENT INFORMATION */
        function confirmCallbackFn(arg) {
            if (arg) //the user clicked OK
            {
                //__doPostBack("<%=btnNewStudent.UniqueID %>", "");
            } else {
                $("#hfExistVeteran").val("");
            }
        }

        function onRequestStart(sender, args) {
            if (args.get_eventTarget().indexOf("rbExport") >= 0) {
                args.set_enableAjax(false);
                document.forms[0].target = "_blank";
            }
        }

        function callBackFn(arg) {
            //alert(arg);
        }

        /* UPDALOAD DOCUMENTS */
        function OnClientSelectedFileIndexChanged(sender, eventArgs) {
            $('#htypeDocto').val(eventArgs.get_item().get_value());
        }
        function OnClientFileUploaded(sender, args) {
            $('#btnUploadFire').trigger('click');
        }
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

        function ShowConfirm() {
            var wnd = $find("<%= modalConfirm.ClientID %>");
            wnd.show();
        }
        function CancelModalNA() {
            var wnd = $find("<%= modalNA.ClientID %>");
            wnd.hide();
        }
        function CancelModalConfirm() {
            var wnd = $find("<%= modalConfirm.ClientID %>");
            wnd.hide();
        }
        function ShowConfirmApplicable() {
            var wnd = $find("<%= modalConfirmApplicable.ClientID %>");
            wnd.show();
        }
        function CancelModalApplicable() {
            var wnd = $find("<%= modalApplicable.ClientID %>");
            wnd.hide();
        }
        function CancelModalConfirmApplicable() {
            var wnd = $find("<%= modalConfirmApplicable.ClientID %>");
            wnd.hide();
        }
        function CancelModalConfirmReverseElective() {
            var wnd = $find("<%= modalConfirmReverseElective.ClientID %>");
            wnd.hide();
        }
        function CancelModalElectiveUnits() {
            var wnd = $find("<%= modalElectiveUnits.ClientID %>");
            wnd.hide();
        }
        function ShowConfirmDeletedExhibits(id, criteriaID) {
            $('#hfDeleteId').val(id);
            $('#hfDeleteCriteriaId').val(criteriaID);
            var wnd = $find("<%= modalConfirmDeletedExhibits.ClientID %>");
             wnd.show();
        }
        function CancelModalConfirmExhibit() {
            var wnd = $find("<%= modalConfirmDeletedExhibits.ClientID %>");
            wnd.hide();
        }

    </script>
</asp:Content>
