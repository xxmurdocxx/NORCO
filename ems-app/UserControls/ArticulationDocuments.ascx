<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticulationDocuments.ascx.cs" Inherits="ems_app.UserControls.ArticulationDocuments" %>
<asp:HiddenField ID="hfArticulationID" runat="server" />
<asp:HiddenField ID="hfUserID" runat="server" />
<asp:SqlDataSource ID="sqlDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" DeleteCommand="DeleteArticulationDocument"  DeleteCommandType="StoredProcedure" InsertCommand="INSERT INTO [ArticulationDocuments] ([FileName], [FileDescription],  [BinaryData], [ArticulationID], [CreatedBy]) VALUES (@FileName, @FileDescription, @BinaryData, @ArticulationID, @UserID) SET @InsertedID = SCOPE_IDENTITY()" SelectCommand="SELECT ad.id, ad.filename, ad.filedescription, ad.binarydata, concat(u.firstname , ', ' , u.lastname ) as 'FullName', ad.CreatedBy FROM [ArticulationDocuments] ad left outer join tblusers u on ad.CreatedBy = u.userid  where (ad.ArticulationID = @ArticulationID)" UpdateCommand="UPDATE [ArticulationDocuments] SET  [FileDescription] = @FileDescription, [UpdatedBy] = @UserID, [UpdatedOn] = getdate() WHERE [id] = @id" OnInserted="sqlDocuments_Inserted"  OnUpdated="sqlDocuments_Updated">
    <SelectParameters>
        <asp:ControlParameter Name="ArticulationID" ControlID="hfArticulationID" PropertyName="Value" Type="Int32" />
    </SelectParameters>
    <DeleteParameters>
        <asp:ControlParameter Name="ArticulationID" ControlID="hfArticulationID" PropertyName="Value" Type="Int32" />
        <asp:ControlParameter Name="UserID" ControlID="hfUserID" PropertyName="Value" Type="Int32" />
    </DeleteParameters>
    <InsertParameters>
        <asp:Parameter Name="FileName" Type="String" />
        <asp:Parameter Name="FileDescription" Type="String" />
        <asp:Parameter Name="BinaryData" Type="Byte" />
        <asp:ControlParameter Name="ArticulationID" ControlID="hfArticulationID" PropertyName="Value" Type="Int32" />
        <asp:ControlParameter Name="UserID" ControlID="hfUserID" PropertyName="Value" Type="Int32" />
        <asp:Parameter Name="InsertedID" Type="Int32" Direction="Output"></asp:Parameter>
    </InsertParameters>
    <UpdateParameters>
        <asp:Parameter Name="FileName" Type="String" />
        <asp:Parameter Name="FileDescription" Type="String" />
        <asp:Parameter Name="id" Type="Int32" />
        <asp:ControlParameter Name="UserID" ControlID="hfUserID" PropertyName="Value" Type="Int32" />
    </UpdateParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
    SelectCommand="SELECT [id], [BinaryData] FROM [ArticulationDocuments] WHERE [ArticulationId] = @id">
    <SelectParameters>
        <asp:Parameter Name="id" Type="Int32"></asp:Parameter>
    </SelectParameters>
</asp:SqlDataSource>
<telerik:RadGrid ID="rgArticulationDocs" DataSourceID="sqlDocuments" AllowPaging="True" Width="100%" runat="server" AutoGenerateColumns="False" AllowSorting="True" PageSize="10" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" AllowAutomaticDeletes="true" OnItemCommand="rgArticulationDocs_ItemCommand" OnItemDataBound="rgArticulationDocs_ItemDataBound" EditItemStyle-BackColor="#ffff66" Skin="Metro" OnPreRender="rgArticulationDocs_PreRender">
    <ClientSettings AllowDragToGroup="false">
        <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
    </ClientSettings>
    <MasterTableView DataKeyNames="id" AutoGenerateColumns="false" CommandItemDisplay="Top">
        <CommandItemTemplate>
            <div class="commandItems">
                <asp:LinkButton runat="server" CommandName="InitInsert" ID="btnAdd" Text="<i class='fa fa-upload'></i> Upload Document" ToolTip="Click here to upload documents" />
            </div>
        </CommandItemTemplate>
        <CommandItemSettings ShowAddNewRecordButton="true" ShowRefreshButton="true" />
        <Columns>
            <telerik:GridBoundColumn DataField="id" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="CreatedBy" FilterControlAltText="Filter CreatedBy column" HeaderText="CreatedBy" SortExpression="CreatedBy" UniqueName="CreatedBy" Display="false" ReadOnly="true">
            </telerik:GridBoundColumn>
            <telerik:GridTemplateColumn AllowFiltering="false" HeaderStyle-Width="10px" ItemStyle-Width="10px" Exportable="false" EnableHeaderContextMenu="false">
                <ItemTemplate>
                    <asp:LinkButton runat="server" ToolTip="Downloaad/View file"  CommandName="Download" ID="btnDownload" Text='<i class="fa fa-download" aria-hidden="true"></i>' />
                </ItemTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridBoundColumn DataField="FileDescription" FilterControlAltText="Filter FileDescription column" HeaderText="File Description" SortExpression="FileDescription" UniqueName="FileDescription">
                <ColumnValidationSettings EnableRequiredFieldValidation="true">
                    <RequiredFieldValidator SetFocusOnError="true" ForeColor="Red" Text="Please enter a file description." ToolTip="Please enter a file description."><span>Please enter a file description.</span>  </RequiredFieldValidator>
                </ColumnValidationSettings>
            </telerik:GridBoundColumn>
            <telerik:GridAttachmentColumn SortExpression="FileName" UploadControlType="RadAsyncUpload" DataSourceID="SqlDataSource1" MaxFileSize="10485760" EditFormHeaderTextFormat="Upload File:" HeaderText="" AttachmentDataField="BinaryData" AttachmentKeyFields="id" ForceExtractValue="Always" FileNameTextField="FileName" DataTextField="FileName" UniqueName="AttachmentColumnIcon" ButtonType="ImageButton" ImageUrl="~/Common/images/icons/baseline_attachment_black_18dp.png" ReadOnly="true" Display="false" >
            </telerik:GridAttachmentColumn>
            <telerik:GridAttachmentColumn SortExpression="FileName" UploadControlType="RadAsyncUpload" DataSourceID="SqlDataSource1" MaxFileSize="10048576" EditFormHeaderTextFormat="Upload File:" HeaderText="Attachment" AttachmentDataField="BinaryData" AttachmentKeyFields="id" ForceExtractValue="Always" FileNameTextField="FileName" DataTextField="FileName" UniqueName="AttachmentColumn" Display="false">
            </telerik:GridAttachmentColumn>
            <telerik:GridBoundColumn SortExpression="FullName" HeaderText="Uploaded by" DataField="FullName" UniqueName="FullName" AllowFiltering="false" ReadOnly="true" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
            </telerik:GridBoundColumn>
            <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" ButtonType="ImageButton" Display="false">
                <ItemStyle Width="50px"></ItemStyle>
            </telerik:GridEditCommandColumn>
            <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ConfirmDialogType="RadWindow" ConfirmText="Delete this document ?" ConfirmTitle="Delete" HeaderStyle-Width="50px" HeaderText="Delete" Text="Delete" UniqueName="DeleteColumn">
                <HeaderStyle Width="50px" />
            </telerik:GridButtonColumn>
        </Columns>
        <EditFormSettings ColumnNumber="2" FormMainTableStyle-CellPadding="5" FormTableStyle-CellPadding="5" EditColumn-ButtonType="ImageButton"></EditFormSettings>
    </MasterTableView>
</telerik:RadGrid>