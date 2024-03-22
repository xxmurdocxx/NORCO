<%@ Page Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="StudentList.aspx.cs" Inherits="ems_app.modules.military.StudentList" %>
<%@ Register Src="~/UserControls/UploadStudents.ascx" TagPrefix="uc1" TagName="UploadStudents" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style type="text/css">
        div.RadGrid .rgCommandCell a {
            float: right; /* Position the buttons on the right side */
        }
        .rgAdd {
            float: left !important;
        }

        .rotated {
            width:80px;
            margin-left: -25px;
            margin-bottom:-15px;
            padding-left: 20px;
            display: inline-block;
            vertical-align: middle;
            transform: rotate(280.0deg);
        }

        html div.RadAsyncUpload .ruButton.ruBrowse {
            color: white;
            background-color:#203864;
            font-size: 12px;
            width: 70px;
        }
        .delete-button {
            color:red !important;
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
<%--<asp:SqlDataSource ID="sqlVeteran" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
        SelectCommand="GetStudentList" SelectCommandType="StoredProcedure"  InsertCommand="INSERT INTO [dbo].[Veteran] (CampaignID,[FirstName],[LastName],[BirthDate],[Rank],[CollegeID],[ServiceID],[IsValidPDFFormat]) VALUES(@CampaignID,@FirstName,@LastName,@BirthDate,@Rank,@CollegeID,@ServiceID,@IsValidPDFFormat)"  DeleteCommand="DELETE FROM [Veteran] WHERE [ID] = @ID" CancelSelectOnNullParameter="false">
        <DeleteParameters>
            <asp:Parameter Name="ID" Type="Int32" />
        </DeleteParameters>
         <SelectParameters>
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                <asp:SessionParameter Name="_PotentialStudent" SessionField="PotentialStudent" Type="Byte" DefaultValue ="" ConvertEmptyStringToNull="true" />
                <asp:SessionParameter Name="_CPLSearchUpload" SessionField="CPLSearchUpload" Type="Byte" DefaultValue="0"/>
                <asp:SessionParameter Name="_CreditRecommendation" SessionField="SelectedCreditRecommendation" Type="String" DefaultValue="" ConvertEmptyStringToNull="true"/>
                <asp:ControlParameter Name="_CPLType" ControlID="hfCPLType" Type="String" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="true"/>
            </SelectParameters>
        <InsertParameters>
                <asp:Parameter Name="CampaignID" Type="Int32" />
                <asp:Parameter Name="StudentID" Type="String" />
                <asp:Parameter Name="FirstName" Type="String" />
                <asp:Parameter Name="LastName" Type="String" />
                <asp:Parameter Name="BirthDate" Type="DateTime" />
                <asp:Parameter Name="Rank" Type="String" />
                <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                <asp:Parameter Name="ServiceID" Type="Int32" ConvertEmptyStringToNull="true"/>
                <asp:Parameter Name="IsValidPDFFormat" Type="Boolean"  />
            </InsertParameters>
    </asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="sqlServices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from LookupService order by Description"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlOrigin" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select * from VeteranOrigin order by Description"></asp:SqlDataSource>
    <telerik:RadWindowManager ID="RadWindowManager11" runat="server" OnClientClose="closeRadWindow" EnableViewState="false"></telerik:RadWindowManager>
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadNotification ID="rnStudentIntake" runat="server" Position="Center" Width="650px" Height="450px" ShowCloseButton="true" ContentScrolling="Y" Pinned="false" AutoCloseDelay="0"></telerik:RadNotification>
        <asp:HiddenField ID="hfVeteranID" runat="server" />
        <asp:HiddenField ID="hfCPLType" runat="server" Value="%" />
        <asp:HiddenField ID="hfLearningMode" runat="server" Value="%" />
        <asp:HiddenField ID="hfCampaignID" runat="server" Value="30" />
        <div class="row text-center">
            <h2 class="d-block w-100"><strong>Credit For Prior Learning Student Log</strong></h2>
        </div>
        <div class="row">
            <div class="col-6" style="border: thin; border-color: lightgray; padding: 10px;">
                    <div class="row">
                        <div class="col-8">
                            <p style="font-weight:bold; margin-top:5px; font-size:small"> When Uploading CPL Documents: </p>
                                <ul style="list-style:none;padding-left:0;">
                                    <li>File size must not exceed 4MB.</li>
                                </ul>
                            <p style="font-weight:bold; margin-top:5px;"> Military CPL: </p>
                            <ul style="list-style:none;padding-left:0;">
                                <li>The Joint Services Transcript (JST) must have a summary page.</li>
                                <li>It is recommended to upload no more than five (5) JST(s) at the time.</li>
                                <li>It is recommended the file be an original PDF downloaded from <a style='color:blue' href='https://jst.doded.mil/' target='_blank'>here</a> </li>
                                <li><span style='font-weight:bold; font-style:italic;'>IMPORTANT: Imaged JSTs may display the student’s Social Security Number and Date of Birth.</span></li>
                                <li><span style='font-weight:bold; font-style:italic;'>NOTE: MAP redacts these data for original JST.pdf files, but can not do so for imaged files. Please note this for student privacy purposes.</span></li>
                            </ul>
                            <ul style="display:none;">
                                <li>Click on the "Select" button to upload Joint Services Transcript (JST) document(s). Then, click "Complete Upload".</li>
                                <li style="color:red">Notice: If the JST(s) you are attempting to load is missing a Summary section, the student(s) must be manually loaded. </li>
                                <li>To add a student manually, click "New Student". </li>
                                <li>To edit a student's information, click on the "Edit Student" icon within the table below.</li>
                            </ul>
                        </div>
<%--                         <div class="col-4">
                             <div class="d-flex justify-content-center align-items-center m-3" >
                                <telerik:RadButton ID="rbClear" runat="server" OnClick="rbClear_Click" Text="Clear Filter" Skin="Material" Width="160px" ToolTip="Click on this button to reset the student list. Clears selected credit recommendation."></telerik:RadButton>
                             </div>
                        </div>--%>
                    </div>
                    <div class="row">
                        <div class="col-9">
                            <telerik:RadAsyncUpload RenderMode="Lightweight" runat="server" ID="AsyncUpload1" Localization-Select="Upload CPL Docs"  Font-Bold="true"
                                 OnClientFilesSelected="showUploadConfirm" OnClientFileUploaded="OnClientFileUploaded" OnClientFilesUploaded="OnClientFilesUploaded" 
                                MultipleFileSelection="Automatic" Width="530px" ToolTip="" />
                            <p style="font-weight: bold; font-size:14px; margin-bottom:0px">Don't have CPL documentation?</p>
                            <a id="linkNewStudent" href="../military/Student.aspx?VeteranID=0" target="_blank" style="color:black; font-size: 14px; font-weight: bold; text-decoration: underline;">Manually Add Student</a>
                        </div>
                        <div class="col-3">
                                <telerik:RadLabel ID="rlPotential" runat="server" Text="Show Potential Students" Visible="false">
                                </telerik:RadLabel>
                                <telerik:RadSwitch ID="rsPotential" runat="server" AutoPostBack="true" Checked="false" OnCheckedChanged="rsShowPotential_CheckedChanged" Width="65px" Visible="false">
                                    <ToggleStates>
                                        <ToggleStateOn Text="Yes" Value="true" />
                                        <ToggleStateOff Text="No" Value="false" />
                                    </ToggleStates>
                                </telerik:RadSwitch>
                        </div>
                    </div>
                    <div id="loadingDiv" class="loadingDiv" runat="server" style="display:none;">
                        <img src="../../Common/images/hb.gif" height="95" width="340" />
                    </div>
                    <div id="divCompleteUpload" class="row col-md-12 complete" style="display: none;" runat="server">
                        <asp:Label ID="lblUploadDisclosure" CssClass="form-control red bold" runat="server"></asp:Label>
                        <telerik:RadButton ID="btnComple" runat="server" OnClick="btnCompleteUpload_Click" Text="Complete Upload" Skin="Material" Width="180px" Font-Bold="true" BackColor="#203864" ForeColor="White" Font-Size="15px" CssClass="btnHiden" ClientIDMode="Static"></telerik:RadButton>
                    </div>
            </div>
            <div class="col-6">
                <asp:SqlDataSource ID="sqlCreditRecommendations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="spVeteransCreditRecommendationsSummary" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" DbType="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <ul style="list-style: none; padding-left: 0;">
                    <li>This table identifies the most common credit recommendations found in the uploaded credit for prior learning documentation.</li>
                </ul>
                <telerik:RadGrid ID="rgCreditRecommendations" runat="server" CellSpacing="-1" DataSourceID="sqlCreditRecommendations" AllowFilteringByColumn="False"  AllowSorting="True" AutoGenerateColumns="False" GroupPanelPosition="Top" Width="100%" OnItemCommand="rgCreditRecommendations_ItemCommand" ToolTip="Ordered by Count in descending order. Click on the row to filter the student list for the selected credit recommendation." Height="300px">
                    <ExportSettings ExportOnlyData="true" FileName="CreditRecommendations" IgnorePaging="true" Excel-DefaultCellAlignment="Left" Excel-FileExtension="xls" Excel-Format="Biff" OpenInNewWindow="true">
                    </ExportSettings>
                    <GroupingSettings CaseSensitive="false" />
                    <ClientSettings AllowColumnsReorder="false" ReorderColumnsOnClient="false" EnableRowHoverStyle="true" EnablePostBackOnRowClick="true">
                        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false"></Selecting>
                        <Scrolling AllowScroll="true" UseStaticHeaders="true" SaveScrollPosition="true" ScrollHeight="150px" />
                    </ClientSettings>
                    <MasterTableView DataSourceID="sqlCreditRecommendations" CommandItemDisplay="None" PageSize="12" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Font-Bold="true" >
                        <CommandItemSettings ShowExportToExcelButton="true" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
                        <Columns>
                            <telerik:GridBoundColumn SortExpression="CreditRecommendation" HeaderText="Most Common Credit Recommendations" DataField="CreditRecommendation" UniqueName="CreditRecommendation" AllowFiltering="false" EnableHeaderContextMenu="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridTemplateColumn SortExpression="RecordCount" DataField="RecordCount" UniqueName="RecordCount" AllowFiltering="false" HeaderStyle-Width="100px">
                                <HeaderTemplate>
                                    <div id="divAnalysis" runat="server" style="display: inline">
                                        Count
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:LinkButton ID="rbClear" OnClick="rbClear_Click" runat="server" ToolTip="Clear Selected Credit Recommendation Filter"><i class="fa fa-refresh" aria-hidden="true" style="font-size: 2em;"></i></asp:LinkButton>
                                    
                                    </div>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%# Eval("RecordCount") %>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                            <%--<telerik:GridBoundColumn SortExpression="RecordCount" HeaderStyle-Width="90px" HeaderText="Count" DataField="RecordCount" UniqueName="RecordCount" AllowFiltering="false">
                            </telerik:GridBoundColumn>--%>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>

            </div>
        </div>
        <!-- BATCH UPLOAD -->
        <div class="row" style="margin-top:20px; padding-left:15px !important;">
            <telerik:RadButton RenderMode="Lightweight" runat="server" Width="200px" ID="rbUpload" Text="Batch Student Upload" OnClick="rbUpload_Click" ToolTip="Click here to upload a .csv file listing the students to be loaded into MAP. Further instructions will follow after clicking this button."></telerik:RadButton>
        </div>
        <div class="row">
            <div ID="pnlUpload" runat="server">
                <uc1:UploadStudents runat="server" id="ucUploadStudents" OnFileUploaded="UploadStudents_FileUploaded" />
            </div>
        </div>
        <div class="row" style="display:flex;justify-content:end;">
            <telerik:RadButton RenderMode="Lightweight" runat="server" ID="rbCloseUpload" Text="Close" Width="60px" OnClick="rbCloseUpload_Click"></telerik:RadButton>
        </div>
        <br />
        <!-- BATCH UPLOAD -->
        <div class="row" style="margin-top:20px; padding-left:15px !important;">
            <telerik:RadButton RenderMode="Lightweight" runat="server" Visible="false" Width="200px" ID="rbScanJST" Text="Scan JSTs" OnClick="rbScanJST_Click" ToolTip="Scan all Veteran JSTs"></telerik:RadButton>
        </div>
        <asp:SqlDataSource ID="sqlVeteran2" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
        UpdateCommand="UPDATE Veteran SET   UpdatedBy = @UpdatedBy, UpdatedOn = getdate(), CampaignID = @CampaignID, CollegeID = @CollegeID, IsValidPDFFormat = @IsValidPDFFormat WHERE [ID] = @id">
        <UpdateParameters>
            <asp:Parameter Name="id" Type="Int32" />
            <asp:Parameter Name="CampaignID" Type="Int32" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
			<asp:Parameter Name="IsValidPDFFormat" Type="Boolean" />														
        </UpdateParameters>
        
    </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlCPLType" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT ID, CONCAT(CPLTypeDescription, ' (', CPLTypeCode, ')') AS CPLTypeDescription, CPLTypeCode FROM   dbo.CPLType where Active = 1 order by SortOrder"></asp:SqlDataSource>  
        <asp:SqlDataSource ID="sqlLearningMode" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT ID, CPLModeofLearningDescription AS LearningModeDescription, ModeofLearningCode LearningModeCode FROM   dbo.CPLModeofLearning where Active = 1 order by SortOrder"></asp:SqlDataSource>  
        <asp:HiddenField ID="_Uploaded" runat="server" Value="" />
        <asp:HiddenField ID="_EdPlan" runat="server" Value="" />
        <asp:HiddenField ID="_Analysis" runat="server" Value="" />
        <asp:HiddenField ID="_Counselor" runat="server" Value="" />
        <asp:HiddenField ID="_Student" runat="server" Value="" />
        <asp:HiddenField ID="_Transcribed" runat="server" Value="" />
        <asp:SqlDataSource ID="sqlVeteran" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
            SelectCommand="GetStudentList" SelectCommandType="StoredProcedure"  InsertCommand="INSERT INTO [dbo].[Veteran] (CampaignID,[FirstName],[LastName],[BirthDate],[Rank],[CollegeID],[ServiceID],IsValidPDFFormat) VALUES(@CampaignID,@FirstName,@LastName,@BirthDate,@Rank,@CollegeID,@ServiceID,@IsValidPDFFormat)"  DeleteCommand="DELETE FROM [Veteran] WHERE [ID] = @ID" CancelSelectOnNullParameter="false" OnSelecting="sqlVeteran_Selecting">
            <DeleteParameters>
                <asp:Parameter Name="ID" Type="Int32" />
            </DeleteParameters>
             <SelectParameters>
                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                    <asp:SessionParameter Name="_PotentialStudent" SessionField="PotentialStudent" Type="Byte" DefaultValue ="" ConvertEmptyStringToNull="true" />
                    <asp:SessionParameter Name="_CPLSearchUpload" SessionField="CPLSearchUpload" Type="Byte" DefaultValue="0"/>
                    <asp:SessionParameter Name="_CreditRecommendation" SessionField="SelectedCreditRecommendation" Type="String" DefaultValue="" ConvertEmptyStringToNull="true"/>
                    <asp:ControlParameter Name="_CPLType" ControlID="hfCPLType" Type="String" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="true"/>
                    <asp:ControlParameter Name="_LearningMode" ControlID="hfLearningMode" Type="String" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="true"/>
                     <asp:ControlParameter Name="_Uploaded" ControlID="_Uploaded" Type="Boolean" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="true"/>
                     <asp:ControlParameter Name="_EdPlan" ControlID="_EdPlan" Type="Boolean" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="true"/>
                     <asp:ControlParameter Name="_Analysis" ControlID="_Analysis" Type="Boolean" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="true"/>
                     <asp:ControlParameter Name="_Counselor" ControlID="_Counselor" Type="Boolean" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="true"/>
                     <asp:ControlParameter Name="_Student" ControlID="_Student" Type="Boolean" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="true"/>
                     <asp:ControlParameter Name="_Transcribed" ControlID="_Transcribed" Type="Boolean" PropertyName="Value" DefaultValue="" ConvertEmptyStringToNull="true"/>
                </SelectParameters>
            <InsertParameters>
                    <asp:Parameter Name="CampaignID" Type="Int32" />
                    <asp:Parameter Name="StudentID" Type="String" />
                    <asp:Parameter Name="FirstName" Type="String" />
                    <asp:Parameter Name="LastName" Type="String" />
                    <asp:Parameter Name="BirthDate" Type="DateTime" />
                    <asp:Parameter Name="Rank" Type="String" />
                    <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
                    <asp:Parameter Name="ServiceID" Type="Int32" ConvertEmptyStringToNull="true"/>
                    <asp:Parameter Name="IsValidPDFFormat" Type="Boolean" />
                </InsertParameters>
        </asp:SqlDataSource>
        <div class="row d-flex justify-content-around align-items-center" style="margin-bottom:5px !important;">
            <telerik:RadLabel ID="rlIntro" runat="server"  Width="250px" Text="Current view is displaying filter(s)">
            </telerik:RadLabel>
            <telerik:RadLabel ID="RadLabel1" runat="server" Width="50px" Text="Uploaded">
            </telerik:RadLabel>
            <telerik:RadSwitch ID="rsUploaded" runat="server" Width="65px"  AutoPostBack="true" Checked="false" OnCheckedChanged="rsChange_CheckedChanged">
                    <ToggleStates>
                        <ToggleStateOn Text="Yes" Value="true" />
                        <ToggleStateOff Text="No"  Value="false"/>
                    </ToggleStates>
                </telerik:RadSwitch>
            <telerik:RadLabel ID="RadLabel2" runat="server" Width="50px" Text="EdPlan">
            </telerik:RadLabel>
            <telerik:RadSwitch ID="rsEdPlan" runat="server" Width="65px"  AutoPostBack="true" Checked="false" OnCheckedChanged="rsChange_CheckedChanged">
                    <ToggleStates>
                        <ToggleStateOn Text="Yes" Value="true" />
                        <ToggleStateOff Text="No"  Value="false"/>
                    </ToggleStates>
                </telerik:RadSwitch>
            <telerik:RadLabel ID="RadLabel3" runat="server" Width="50px" Text="Analysis">
            </telerik:RadLabel>
            <telerik:RadSwitch ID="rsAnalysis" runat="server" Width="65px"  AutoPostBack="true" Checked="false" OnCheckedChanged="rsChange_CheckedChanged">
                    <ToggleStates>
                        <ToggleStateOn Text="Yes" Value="true" />
                        <ToggleStateOff Text="No"  Value="false"/>
                    </ToggleStates>
                </telerik:RadSwitch>
            <telerik:RadLabel ID="RadLabel4" runat="server" Width="50px" Text="Counselor">
            </telerik:RadLabel>
            <telerik:RadSwitch ID="rsCounselor" runat="server" Width="65px"  AutoPostBack="true" Checked="false" OnCheckedChanged="rsChange_CheckedChanged">
                    <ToggleStates>
                        <ToggleStateOn Text="Yes" Value="true" />
                        <ToggleStateOff Text="No"  Value="false"/>
                    </ToggleStates>
                </telerik:RadSwitch>
            <telerik:RadLabel ID="RadLabel5" runat="server" Width="50px" Text="Student">
            </telerik:RadLabel>
            <telerik:RadSwitch ID="rsStudent" runat="server" Width="65px"  AutoPostBack="true" Checked="false" OnCheckedChanged="rsChange_CheckedChanged">
                    <ToggleStates>
                        <ToggleStateOn Text="Yes" Value="true" />
                        <ToggleStateOff Text="No"  Value="false"/>
                    </ToggleStates>
                </telerik:RadSwitch>
            <telerik:RadLabel ID="RadLabel6" runat="server" Width="50px" Text="Transcribed">
            </telerik:RadLabel>
            <telerik:RadSwitch ID="rsTranscribed" runat="server" Width="65px"  AutoPostBack="true" Checked="false" OnCheckedChanged="rsChange_CheckedChanged">
                    <ToggleStates>
                        <ToggleStateOn Text="Yes" Value="true" />
                        <ToggleStateOff Text="No"  Value="false"/>
                    </ToggleStates>
                </telerik:RadSwitch>
        </div>
        <telerik:RadGrid ID="rgStudents" runat="server" AutoGenerateColumns="False" EnableHeaderContextMenu="true" DataSourceID="sqlVeteran" Skin="Material"  AllowSorting="true"
            AllowPaging="true" PageSize="20" AllowFilteringByColumn="true" OnItemCommand="rgStudents_ItemCommand" Width="100%" AllowAutomaticDeletes="true"
            OnItemDataBound="rgStudents_ItemDataBound" ShowFooter="true" >
            <ClientSettings AllowKeyboardNavigation="true" Resizing-AllowColumnResize="true">
                <Scrolling />
                <ClientEvents  />
            </ClientSettings>
            <GroupingSettings CaseSensitive="false" />
            <MasterTableView DataSourceID="sqlVeteran" DataKeyNames="id" EditMode="EditForms" CommandItemDisplay="Top" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Height="76px" AlternateRowColor=true AlternatingItemStyle-BackColor="#CFD8DC" CommandItemSettings-ShowAddNewRecordButton="false" CommandItemSettings-ShowRefreshButton="true" CommandItemSettings-ShowExportToExcelButton="true" CommandItemStyle-HorizontalAlign="Left" CommandItemSettings-ExportToExcelText="Export to Excel" SortHeaderContextMenuColumns="true"  >
                <Columns>
                    <telerik:GridTemplateColumn HeaderText="Public Upload" AllowFiltering="false" HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="10px" ReadOnly="true" HeaderStyle-Font-Bold="true" HeaderTooltip="Students contacting your college using the public MAP Search feature will be identified with this icon." EnableHeaderContextMenu="true">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CommandName="btnPublicUpload" ID="btnPublicUpload" Text='<i class="fa fa-map-marker" aria-hidden="true" style="font-size: 1.5em;"></i>' Visible="false" Enabled="false"/>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn HeaderText="CPL Plan" AllowFiltering="false" HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="10px" ReadOnly="true" HeaderStyle-Font-Bold="true" HeaderTooltip="View and export student's MAP CPL Summary Report." EnableHeaderContextMenu="true">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CommandName="ViewMilitarCredits" ID="btnViewMilitarCredits" ToolTip="View CPL Summary Report" Text='<i class="fa fa-file-text-o" aria-hidden="true" style="font-size: 1.5em;"></i>' />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn HeaderText="Edit" AllowFiltering="false" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="40px" ItemStyle-Width="10px" ReadOnly="true" HeaderStyle-Font-Bold="true" HeaderTooltip="Edit student.">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CommandName="btnEditStudent" ID="btnEditStudent" ToolTip="Edit CPL Student"  Text='<i class="fa-regular fa-pen-to-square" aria-hidden="true" style="font-size: 1.5em;"></i>' />
                            <%--<asp:LinkButton runat="server" ToolTip="Edit student" CommandName="btnEditStudent"  ID="btnEditStudent" Text='<i class="fa fa-pencil-square-o" aria-hidden="true"></i>' />--%>
                        </ItemTemplate> 
                    </telerik:GridTemplateColumn>

                    <telerik:GridBoundColumn DataField="id" UniqueName="id" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="StudentID" UniqueName="StudentID" FilterControlWidth="75px" HeaderText="Student ID" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" Visible="true" HeaderStyle-Width="85px" EnableHeaderContextMenu="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="LastName" UniqueName="LastName" HeaderStyle-Width="115px" HeaderText="Last Name" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="FirstName" UniqueName="FirstName" FilterControlWidth="60px" HeaderStyle-Width="110px" HeaderText="First Name" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="MiddleName" UniqueName="MiddleName" HeaderStyle-Width="80px" HeaderText="Middle Name" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="35px" Display="false" EnableHeaderContextMenu="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn HeaderStyle-Width="60px" DataField="CPLTypeStudent" HeaderText="CPL Type" UniqueName="CreditTypeColumn" FilterControlAltText="Filter CPLTypeStudent column" FilterControlWidth="45px" Visible="true" HeaderStyle-Font-Bold="true"  EnableHeaderContextMenu="true">
                       <ItemTemplate>
                         <%# Eval("CPLTypeStudent") %>
                       </ItemTemplate>
                       <FilterTemplate>
                           <telerik:RadComboBox RenderMode="Lightweight" ID="RadComboBoxCPLType" DataSourceID="sqlCPLType" DataTextField="CPLTypeDescription"
                            DataValueField="CPLTypeCode" Width="45px" AppendDataBoundItems="true" DropDownAutoWidth="Enabled" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlCreditType_SelectedIndexChanged" ToolTip="CBE: Credit By Exam		
IC:  Industry Certification	
M:   Military				
PR:  Portfolio Review		
SA:  Standarized Assessment	" >
                            <Items>
                                <telerik:RadComboBoxItem Text="All" Value="%" />
                            </Items>
                        </telerik:RadComboBox>
                       </FilterTemplate>
                   </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn HeaderStyle-Width="60px" DataField="LearningModeStudent" HeaderText="Learning Mode" UniqueName="LearningModeColumn" FilterControlAltText="Filter LearningModeStudent column" FilterControlWidth="45px" Visible="true" HeaderStyle-Font-Bold="true"  EnableHeaderContextMenu="true">
                       <ItemTemplate>
                         <%# Eval("LearningModeStudent") %>
                       </ItemTemplate>
                       <FilterTemplate>
                           <telerik:RadComboBox RenderMode="Lightweight" ID="RadComboBoxLearningMode" DataSourceID="sqlLearningMode" DataTextField="LearningModeDescription"
                            DataValueField="LearningModeCode" Width="45px" AppendDataBoundItems="true" DropDownAutoWidth="Enabled" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlLearningMode_SelectedIndexChanged" ToolTip="" >
                            <Items>
                                <telerik:RadComboBoxItem Text="All" Value="%" />
                            </Items>
                        </telerik:RadComboBox>
                       </FilterTemplate>
                   </telerik:GridTemplateColumn>
                    <telerik:GridCheckBoxColumn UniqueName="PotentialStudent" HeaderStyle-Font-Bold="true" HeaderText="Potential Student" HeaderStyle-Width="80px" DataField="PotentialStudent" AllowSorting="true" AllowFiltering="true" CurrentFilterFunction="EqualTo" AutoPostBackOnFilter="true" HeaderTooltip="Potential Students are those that searched for credit within the public MAP Search Tool. Once a student ID is applied, 'Potential' status will be removed." Visible="false"  EnableHeaderContextMenu="true">
                    </telerik:GridCheckBoxColumn>
                    <telerik:GridNumericColumn DataField="EligibleCredits" UniqueName="EligibleCredits" HeaderText="Potential Credits" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:###,##0.0}" Aggregate="Sum" DecimalDigits="1" FooterAggregateFormatString="{0:###,##0.0}" HeaderStyle-Width="80px" FilterControlWidth="40px" FooterStyle-HorizontalAlign="Center" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderTooltip="Projected Credits Attainable Based on Current Approvals." EnableHeaderContextMenu="true">
                    </telerik:GridNumericColumn>
                    <telerik:GridNumericColumn DataField="CreditsInReview" UniqueName="CreditsInReview" HeaderText="Credits in Review" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" Aggregate="Sum" DataFormatString="{0:###,##0.0}" DecimalDigits="1" FooterAggregateFormatString="{0:### ##0.0}" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px" FilterControlWidth="40px" FooterStyle-HorizontalAlign="Center" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderTooltip="Credits that have associated active or implemented articulations." EnableHeaderContextMenu="true">
                    </telerik:GridNumericColumn>
                    <telerik:GridNumericColumn DataField="AppliedCredits" UniqueName="AppliedCredits" HeaderText="Applied Credits" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" HeaderStyle-HorizontalAlign="Center" Aggregate="Sum" DataFormatString="{0:###,##0.0}" DecimalDigits="1" FooterAggregateFormatString="{0:### ##0.0}" HeaderStyle-Width="80px" FooterStyle-HorizontalAlign="Center" FilterControlWidth="40px" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderTooltip="Credits that have been identified as ready for transcription." EnableHeaderContextMenu="true">
                    </telerik:GridNumericColumn>
                    <telerik:GridNumericColumn DataField="TranscribedCredits" UniqueName="TranscribedCredits" HeaderText="Transcribed Credits" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" HeaderStyle-HorizontalAlign="Center" Aggregate="Sum" DataFormatString="{0:###,##0.0}" DecimalDigits="1" FooterAggregateFormatString="{0:### ##0.0}" HeaderStyle-Width="80px" FooterStyle-HorizontalAlign="Center" FilterControlWidth="40px" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderTooltip="Credits that have been identified as ready for transcription." EnableHeaderContextMenu="true">
                    </telerik:GridNumericColumn>
                    <%--<telerik:GridBoundColumn DataField="AppliedCreditsColor" UniqueName="AppliedCreditsColor" HeaderText="Applied Credits Color" HeaderStyle-Font-Bold="true" Display="false">
                    </telerik:GridBoundColumn>--%>
                    <telerik:GridBoundColumn DataField="Email" UniqueName="Email" HeaderStyle-Width="160px" HeaderText="Email" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" EnableHeaderContextMenu="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="MobilePhone" UniqueName="MobilePhone" HeaderText="Phone" HeaderStyle-Width="110px" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" Display="false" EnableHeaderContextMenu="true">
                    </telerik:GridBoundColumn>                   
                    <telerik:GridDropDownColumn DataField="ServiceID" HeaderText="Branch" UniqueName="ServiceID" HeaderStyle-Width="90px" DataSourceID="sqlServices" ListTextField="Description" ListValueField="id" HeaderStyle-Font-Bold="true" EnableHeaderContextMenu="true">
                        <FilterTemplate>
                            <telerik:RadComboBox RenderMode="Lightweight" ID="RadComboBoxServiceID" DataSourceID="sqlServices" DataTextField="Description"
                                DataValueField="id" Width="90px" AppendDataBoundItems="true" DropDownAutoWidth="Enabled" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("ServiceID").CurrentFilterValue %>'
                                runat="server" OnClientSelectedIndexChanged="ServiceIDIndexChanged">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                <script type="text/javascript">
                                    function ServiceIDIndexChanged(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("ServiceID", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridDropDownColumn> 
                    <telerik:GridTemplateColumn UniqueName="DocUpload" DataField="DocUpload" HeaderStyle-Width="65px" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" HeaderText="Uploaded" AllowSorting="true" AllowFiltering="false" SortExpression="DocUpload" EnableHeaderContextMenu="true">
                        <ItemTemplate>
                            <div id="divDocUpload" runat="server">
                                <i aria-hidden="true" style="font-size: 2em;"></i>
                                <%--<i class="fa fa-check-circle" aria-hidden="true" style="font-size: 2em;"></i>--%>
                            </div>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="EdPlan" UniqueName="EdPlan" Display="false"/>
                    <telerik:GridTemplateColumn SortExpression="EdPlan" UniqueName="EdPlanTemplate" DataField="EdPlan" HeaderStyle-Width="55px" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" HeaderText="EdPlan" AllowSorting="true" AllowFiltering="false" EnableHeaderContextMenu="true">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdPlan" CommandName="UpdateStatus" CommandArgument="EdPlan" runat="server" ToolTip="" > <i class="fa fa-check-circle" id="linkIconEdPlan" aria-hidden="true" runat="server" style="font-size: 2em;color:#455A64;"></i></asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="GlobalCR" UniqueName="GlobalCR" Display="false"/>
                    <telerik:GridTemplateColumn UniqueName="GlobalCRTemplate" DataField="GlobalCR" HeaderStyle-Width="60px" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderText="Global CR" SortExpression="GlobalCR" AllowSorting="true" Display="false" EnableHeaderContextMenu="true">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnGlobalCR" CommandName="UpdateStatus" CommandArgument="GlobalCR" runat="server" ToolTip="" > <i class="fa fa-check-circle" id="linkIconGlobalCR" aria-hidden="true" runat="server" style="font-size: 2em;color:#455A64;"></i></asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="Analysis" UniqueName="Analysis" Display="false"/>
                    <telerik:GridTemplateColumn UniqueName="AnalysisTemplate" DataField="Analysis" HeaderStyle-Width="60px" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderText="Analysis" SortExpression="Analysis" AllowSorting="true" EnableHeaderContextMenu="true">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnAnalysis" CommandName="UpdateStatus" CommandArgument="Analysis" runat="server" ToolTip="" > <i class="fa fa-check-circle" id="linkIconAnalysis" aria-hidden="true" runat="server" style="font-size: 2em;color:#455A64;"></i></asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="Applied" UniqueName="Applied" Display="false"/>
                    <telerik:GridTemplateColumn UniqueName="AppliedTemplate" DataField="Applied" HeaderStyle-Width="60px" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderText="CRs Revd" SortExpression="Applied" AllowSorting="true" Display="false" EnableHeaderContextMenu="true">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnApplied" CommandName="UpdateStatus" CommandArgument="Applied" runat="server" ToolTip="" > <i class="fa fa-check-circle" id="linkIconApplied" aria-hidden="true" runat="server" style="font-size: 2em;color:#455A64;"></i></asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="Counselor" UniqueName="Counselor" Display="false"/>
                    <telerik:GridTemplateColumn UniqueName="CounselorTemplate" DataField="Counselor" HeaderStyle-Width="70px" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderText="Counselor" SortExpression="Counselor" AllowSorting="true" EnableHeaderContextMenu="true">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnCounselor" CommandName="UpdateStatus" CommandArgument="Counselor" runat="server" ToolTip="" > <i class="fa fa-check-circle" id="linkIconCounselor" aria-hidden="true" runat="server" style="font-size: 2em;color:#455A64;"></i></asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="Student" UniqueName="Student" Display="false" Exportable="true"/>
                    <telerik:GridTemplateColumn UniqueName="StudentTemplate" DataField="Student" HeaderStyle-Width="55px" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderText="Student" SortExpression="Student" AllowSorting="true" EnableHeaderContextMenu="true" Exportable="false">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnStudent" CommandName="UpdateStatus" CommandArgument="Student" runat="server" ToolTip="" > <i class="fa fa-check-circle" id="linkIconStudent" aria-hidden="true" runat="server" style="font-size: 2em;color:#455A64;"></i></asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="Transcribed" UniqueName="Transcribed" Display="false" Exportable="true" />
                    <telerik:GridTemplateColumn UniqueName="TranscribedTemplate" DataField="Transcribed" HeaderStyle-Width="80px" HeaderStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" AllowFiltering="false" HeaderText="Transcribed" SortExpression="Transcribed" AllowSorting="true" EnableHeaderContextMenu="true" Exportable="false">
                        <HeaderTemplate>
                            <div class="rotated">
                                Transcribed
                            </div>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnTranscribed" CommandName="UpdateStatus" CommandArgument="Transcribed" runat="server" ToolTip=""> <i class="fa fa-check-circle" id="linkIconTranscribed" aria-hidden="true" runat="server" style="font-size: 2em;color:#455A64;"></i></asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="CreatedOn" UniqueName="CreatedOn" HeaderText="Date Added" DataType="System.DateTime" DataFormatString="{0:MM/dd/yyyy}" HeaderStyle-Font-Bold="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="70px" HeaderStyle-Width="120px" EnableHeaderContextMenu="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbDelete" ToolTip="Delete Student and all related information" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this student ? all uploaded documents will be deleted as well.')){return false;}" runat="server" CssClass="delete-button"><i class='fa fa-trash' style="color:red !important;"></i></asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>
            </MasterTableView>
            <FooterStyle ForeColor="Maroon" HorizontalAlign="Right" />
        </telerik:RadGrid>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        //var blurred = false;
        //window.onblur = function () { blurred = true; };
        //window.onfocus = function () { blurred && (location.reload()); };
        function closeRadWindow() {
            $find("<%= RadAjaxPanel1.ClientID %>").ajaxRequest();
        }
        function showUploadConfirm() {

            $(".complete").show();								  
        }
        function OnClientFileUploaded(sender, args) {
            $('#btnComple').trigger('click') ;
        }
        function OnClientFilesUploaded(sender, args) {
            var elements = document.getElementsByClassName("loadingDiv");
            if (elements.length > 0) {
                var div = elements[0]; // Assuming there's only one element with the class "loadingDiv"
                div.style.display = 'block';
            } 
        }
    </script>
</asp:Content>
