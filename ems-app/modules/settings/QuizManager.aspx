<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="QuizManager.aspx.cs" Inherits="ems_app.modules.settings.QuizManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Quiz Manager</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlSurveys" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM Survey.[Survey] WHERE [SurveyID] = @SurveyID" InsertCommand="INSERT INTO Survey.[Survey] ([Name], [Description], [WelcomeMessage], [ExitMessage], [StartDate], [EndDate], [CollegeID], [CreatedBy], [CreatedOn]) VALUES (@Name, @Description, @WelcomeMessage, @ExitMessage, @StartDate, @EndDate, @CollegeID, @CreatedBy, getdate())" SelectCommand="SELECT * FROM Survey.[Survey] WHERE ([CollegeID] = @CollegeID)" UpdateCommand="UPDATE Survey.[Survey] SET [Name] = @Name, [Description] = @Description, [WelcomeMessage] = @WelcomeMessage, [ExitMessage] = @ExitMessage, [StartDate] = @StartDate, [EndDate] = @EndDate, [CollegeID] = @CollegeID, [UpdatedBy] = @UpdatedBy, [UpdatedOn] = getdate() WHERE [SurveyID] = @SurveyID">
        <DeleteParameters>
            <asp:Parameter Name="SurveyID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="WelcomeMessage" Type="String" />
            <asp:Parameter Name="ExitMessage" Type="String" />
            <asp:Parameter Name="StartDate" Type="DateTime" />
            <asp:Parameter Name="EndDate" Type="DateTime" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="CreatedBy" SessionField="UserID" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="WelcomeMessage" Type="String" />
            <asp:Parameter Name="ExitMessage" Type="String" />
            <asp:Parameter Name="StartDate" Type="DateTime" />
            <asp:Parameter Name="EndDate" Type="DateTime" />
            <asp:SessionParameter Name="CollegeID" SessionField="CollegeID" Type="Int32" />
            <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="SurveyID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlQuestions" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM Survey.[SurveyQuestion] WHERE [QuestionID] = @QuestionID" InsertCommand="INSERT INTO Survey.[SurveyQuestion] ([SurveyID], [QuestionNumber], [Text], [CreatedBy], [CreatedOn]) VALUES (@SurveyID, @QuestionNumber, @Text, @CreatedBy,getdate())" SelectCommand="SELECT * FROM Survey.[SurveyQuestion] WHERE ([SurveyID] = @SurveyID) ORDER BY QuestionNumber" UpdateCommand="UPDATE Survey.[SurveyQuestion] SET [SurveyID] = @SurveyID, [QuestionNumber] = @QuestionNumber, [Text] = @Text, [UpdatedBy] = @UpdatedBy, [UpdatedOn] = getdate() WHERE [QuestionID] = @QuestionID">
        <DeleteParameters>
            <asp:Parameter Name="QuestionID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="SurveyID" Type="Int32" />
            <asp:Parameter Name="QuestionNumber" Type="Int32" />
            <asp:Parameter Name="Text" Type="String" />
            <asp:SessionParameter Name="CreatedBy" SessionField="UserID" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="SurveyID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="SurveyID" Type="Int32" />
            <asp:Parameter Name="QuestionNumber" Type="Int32" />
            <asp:Parameter Name="Text" Type="String" />
            <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="QuestionID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlChoices" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM Survey.[Choice] WHERE [ChoiceID] = @ChoiceID" InsertCommand="INSERT INTO Survey.[Choice] ([Text], [Value], [QuestionID], [CreatedBy], [CreatedOn], [IsCorrectAnswer]) VALUES (@Text, (select max(isnull(Value,0)) + 1 from Survey.[Choice] ), @QuestionID, @CreatedBy, getdate(), @IsCorrectAnswer)" SelectCommand="SELECT * FROM Survey.[Choice] WHERE ([QuestionID] = @QuestionID)" UpdateCommand="UPDATE Survey.[Choice] SET [Text] = @Text, [IsCorrectAnswer] = @IsCorrectAnswer, [QuestionID] = @QuestionID, [UpdatedBy] = @UpdatedBy, [UpdatedOn] = getdate() WHERE [ChoiceID] = @ChoiceID">
        <DeleteParameters>
            <asp:Parameter Name="ChoiceID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Text" Type="String" />
            <asp:Parameter Name="IsCorrectAnswer" Type="Boolean" />
            <asp:Parameter Name="QuestionID" Type="Int32" />
            <asp:SessionParameter Name="CreatedBy" SessionField="UserID" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="QuestionID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Text" Type="String" />
            <asp:Parameter Name="QuestionID" Type="Int32" />
            <asp:Parameter Name="IsCorrectAnswer" Type="Boolean" />
            <asp:SessionParameter Name="UpdatedBy" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="ChoiceID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [ROLES]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSurveyRoles" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DELETE FROM Survey.[SurveyRole] WHERE [SurveyRoleID] = @SurveyRoleID" InsertCommand="INSERT INTO Survey.[SurveyRole] ([RoleID], [SurveyID]) VALUES (@RoleID, @SurveyID)" SelectCommand="SELECT * FROM Survey.[SurveyRole] WHERE ([SurveyID] = @SurveyID)" UpdateCommand="UPDATE Survey.[SurveyRole] SET [RoleID] = @RoleID, [SurveyID] = @SurveyID WHERE [SurveyRoleID] = @SurveyRoleID">
        <DeleteParameters>
            <asp:Parameter Name="SurveyRoleID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="RoleID" Type="Int32" />
            <asp:Parameter Name="SurveyID" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:Parameter Name="SurveyID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="RoleID" Type="Int32" />
            <asp:Parameter Name="SurveyID" Type="Int32" />
            <asp:Parameter Name="SurveyRoleID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false"></telerik:RadWindowManager>
        <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="480px" Height="100px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
            <p id="divMsgs" runat="server">
                <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
                <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                </asp:Label>
            </p>
        </telerik:RadToolTip>
        <telerik:RadGrid ID="rgSurveys" runat="server" DataSourceID="sqlSurveys" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true">
            <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
            <MasterTableView AutoGenerateColumns="False" DataKeyNames="SurveyID" DataSourceID="sqlSurveys" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true" CommandItemDisplay="Top" Caption="Quiz">
                <DetailTables>
                    <telerik:GridTableView Name="QuestionsChildGrid" DataKeyNames="SurveyID,QuestionID" DataSourceID="sqlQuestions" Width="100%" AllowMultiColumnSorting="true" runat="server" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true" CommandItemDisplay="Top" AllowFilteringByColumn="false" CommandItemSettings-ShowAddNewRecordButton="true" AllowAutomaticDeletes="true" AllowAutomaticUpdates="true" AllowAutomaticInserts="true" AutoGenerateColumns="false" Caption="Questions">
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="SurveyID" MasterKeyField="SurveyID"></telerik:GridRelationFields>
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridBoundColumn DataField="SurveyID" DataType="System.Int32" Display="False" FilterControlAltText="Filter SurveyID column" HeaderText="SurveyID" SortExpression="SurveyID" UniqueName="SurveyID" ReadOnly="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="QuestionID" DataType="System.Int32" Display="False" FilterControlAltText="Filter QuestionID column" HeaderText="QuestionID" ReadOnly="True" SortExpression="QuestionID" UniqueName="QuestionID">
                            </telerik:GridBoundColumn>
                            <telerik:GridNumericColumn DataField="QuestionNumber" DataType="System.Int32" FilterControlAltText="Filter QuestionNumber column" HeaderText="Question Order" SortExpression="QuestionNumber" UniqueName="QuestionNumber" HeaderStyle-Width="80px">
                            </telerik:GridNumericColumn>
                            <telerik:GridHTMLEditorColumn DataField="Text" FilterControlAltText="Filter Text column" HeaderText="Text" SortExpression="Text" UniqueName="Text">
                            </telerik:GridHTMLEditorColumn>
                            <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" HeaderStyle-Width="60px">
                            </telerik:GridEditCommandColumn>
                            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this Question ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                        <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Question: {0}" CaptionDataField="Text" FormCaptionStyle-Font-Bold="true" PopUpSettings-ShowCaptionInEditForm="true">
                            <PopUpSettings Height="500px" Modal="True" Width="800px" ScrollBars="Auto" />
                        </EditFormSettings>
                        <DetailTables>
                            <telerik:GridTableView Name="ChoicesChildGrid" DataKeyNames="QuestionID,ChoiceID" DataSourceID="sqlChoices" Width="100%" AllowMultiColumnSorting="true" runat="server" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true" CommandItemDisplay="Top" AllowFilteringByColumn="false" CommandItemSettings-ShowAddNewRecordButton="true" AllowAutomaticDeletes="true" AllowAutomaticUpdates="true" AllowAutomaticInserts="true" AutoGenerateColumns="false" Caption="Answers">
                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="QuestionID" MasterKeyField="QuestionID"></telerik:GridRelationFields>
                                </ParentTableRelation>
                                <Columns>
                                    <telerik:GridBoundColumn DataField="ChoiceID" DataType="System.Int32" Display="False" FilterControlAltText="Filter ChoiceID column" HeaderText="ChoiceID" ReadOnly="True" SortExpression="ChoiceID" UniqueName="ChoiceID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridHTMLEditorColumn DataField="Text" FilterControlAltText="Filter Text column" HeaderText="Text" SortExpression="Text" UniqueName="Text">
                                    </telerik:GridHTMLEditorColumn>
                                    <telerik:GridCheckBoxColumn DataField="IsCorrectAnswer" DataType="System.Boolean" HeaderText="Answer is Correct" UniqueName="IsCorrectAnswer" AllowFiltering="true" HeaderStyle-Width="65px" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    </telerik:GridCheckBoxColumn>
                                    <telerik:GridBoundColumn DataField="QuestionID" DataType="System.Int32" Display="False" FilterControlAltText="Filter QuestionID column" HeaderText="QuestionID" SortExpression="QuestionID" UniqueName="QuestionID" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" HeaderStyle-Width="60px">
                                    </telerik:GridEditCommandColumn>
                                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this Choice ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                </Columns>
                                <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Choice: {0}" CaptionDataField="Text" FormCaptionStyle-Font-Bold="true" PopUpSettings-ShowCaptionInEditForm="true">
                                    <PopUpSettings Height="500px" Modal="True" Width="800px" ScrollBars="Auto" />
                                </EditFormSettings>
                            </telerik:GridTableView>
                        </DetailTables>
                    </telerik:GridTableView>
                    <telerik:GridTableView Name="RolesChildGrid" DataKeyNames="SurveyID,SurveyRoleID" DataSourceID="sqlSurveyRoles" Width="100%" AllowMultiColumnSorting="true" runat="server" EditMode="PopUp" EditFormSettings-PopUpSettings-Modal="true" CommandItemDisplay="Top" AllowFilteringByColumn="false" CommandItemSettings-ShowAddNewRecordButton="true" AllowAutomaticDeletes="true" AllowAutomaticUpdates="true" AllowAutomaticInserts="true" AutoGenerateColumns="false" Caption="Assign Quiz to the following Roles">
                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="SurveyID" MasterKeyField="SurveyID"></telerik:GridRelationFields>
                        </ParentTableRelation>
                        <Columns>
                            <telerik:GridBoundColumn DataField="SurveyID" DataType="System.Int32" Display="False" FilterControlAltText="Filter SurveyID column" HeaderText="SurveyID" SortExpression="SurveyID" UniqueName="SurveyID" ReadOnly="true">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="SurveyRoleID" DataType="System.Int32" Display="False" FilterControlAltText="Filter SurveyRoleID column" HeaderText="SurveyRoleID" ReadOnly="True" SortExpression="SurveyRoleID" UniqueName="SurveyRoleID">
                            </telerik:GridBoundColumn>
                            <telerik:GridDropDownColumn DataField="RoleID" HeaderText="Role Name" UniqueName="RoleID" DataSourceID="sqlRoles" ListTextField="RoleName" ListValueField="RoleId" HeaderStyle-Width="100px" >
                            </telerik:GridDropDownColumn>
                            <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" HeaderStyle-Width="60px">
                            </telerik:GridEditCommandColumn>
                            <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this Question ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                        <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Assign to the following roles:" FormCaptionStyle-Font-Bold="true" PopUpSettings-ShowCaptionInEditForm="true">
                            <PopUpSettings Height="200px" Modal="True" Width="500px" ScrollBars="Auto" />
                        </EditFormSettings>
                        </telerik:GridTableView>
                </DetailTables>
                <Columns>
                    <telerik:GridBoundColumn DataField="SurveyID" DataType="System.Int32" Display="False" FilterControlAltText="Filter SurveyID column" HeaderText="SurveyID" ReadOnly="True" SortExpression="SurveyID" UniqueName="SurveyID">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Name" FilterControlAltText="Filter Name column" HeaderText="Name" SortExpression="Name" UniqueName="Name">
                    </telerik:GridBoundColumn>
                    <telerik:GridHTMLEditorColumn DataField="Description" FilterControlAltText="Filter Description column" HeaderText="Description" SortExpression="Description" UniqueName="Description">
                    </telerik:GridHTMLEditorColumn>
                    <telerik:GridHTMLEditorColumn DataField="WelcomeMessage" FilterControlAltText="Filter WelcomeMessage column" HeaderText="WelcomeMessage" SortExpression="WelcomeMessage" UniqueName="WelcomeMessage" Display="False">
                    </telerik:GridHTMLEditorColumn>
                    <telerik:GridHTMLEditorColumn DataField="ExitMessage" FilterControlAltText="Filter ExitMessage column" HeaderText="ExitMessage" SortExpression="ExitMessage" UniqueName="ExitMessage" Display="False">
                    </telerik:GridHTMLEditorColumn>
                    <telerik:GridDateTimeColumn DataField="StartDate" DataType="System.DateTime" FilterControlAltText="Filter StartDate column" HeaderText="StartDate" SortExpression="StartDate" UniqueName="StartDate" DataFormatString="{0:MM/dd/yyyy}">
                    </telerik:GridDateTimeColumn>
                    <telerik:GridDateTimeColumn DataField="EndDate" DataType="System.DateTime" FilterControlAltText="Filter EndDate column" HeaderText="EndDate" SortExpression="EndDate" UniqueName="EndDate" DataFormatString="{0:MM/dd/yyyy}">
                    </telerik:GridDateTimeColumn>
                    <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit">
                    </telerik:GridEditCommandColumn>
                    <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderStyle-Width="30px" ReadOnly="true" AllowFiltering="false">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbDelete" CommandName="Delete" OnClientClick="javascript:if(!confirm('Are you sure you want to remove this Survey ?')){return false;}" runat="server"><i class='fa fa-trash'></i></asp:LinkButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>
                <EditFormSettings EditColumn-ButtonType="FontIconButton" CaptionFormatString="Survey: {0}" CaptionDataField="Name" FormCaptionStyle-Font-Bold="true" PopUpSettings-ShowCaptionInEditForm="true">
                    <PopUpSettings Height="700px" Modal="True" Width="800px" ScrollBars="Auto" />
                </EditFormSettings>
            </MasterTableView>
        </telerik:RadGrid>
    </telerik:RadAjaxPanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
