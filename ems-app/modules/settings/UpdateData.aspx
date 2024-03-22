<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="UpdateData.aspx.cs" Inherits="ems_app.modules.settings.UpdateData" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Update College Data</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlDataIntakeDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" InsertCommand="INSERT INTO [DataIntakeDocuments] ([FileName], [FileDescription],  [BinaryData], [CollegeID], [CreatedBy], [CreatedOn]) VALUES (@FileName, @FileDescription,  @BinaryData, @CollegeID,@user_id, getdate()) SET @InsertedID = SCOPE_IDENTITY()" SelectCommand="SELECT id, filename, filedescription, binarydata FROM [DataIntakeDocuments] where (CollegeID = @CollegeID)" UpdateCommand="UPDATE [DataIntakeDocuments] SET  [FileDescription] = @FileDescription, [UpdatedBy] = @user_id, [UpdatedOn] = getdate() WHERE [id] = @id" OnInserted="sqlDataIntakeDocuments_Inserted" OnUpdated="sqlDataIntakeDocuments_Updated">
        <SelectParameters>
            <asp:SessionParameter Name="CollegeID" SessionField="UserID" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:SessionParameter Name="user_id" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="FileName" Type="String" />
            <asp:Parameter Name="FileDescription" Type="String" />
            <asp:Parameter Name="BinaryData" Type="Byte" />
            <asp:Parameter Name="InsertedID" Type="Int32" Direction="Output"></asp:Parameter>
            <asp:SessionParameter Name="CollegeID" SessionField="UserID" Type="Int32" />
        </InsertParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="user_id" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="FileName" Type="String" />
            <asp:Parameter Name="FileDescription" Type="String" />
            <asp:Parameter Name="id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlDataIntakeDownloadColumn" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT [id], [BinaryData] FROM [DataIntakeDocuments] WHERE [id] = @id">
        <SelectParameters>
            <asp:Parameter Name="id" Type="Int32"></asp:Parameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <telerik:RadGrid ID="rgDataIntakeDocuments" DataSourceID="sqlDataIntakeDocuments" AllowPaging="True" Width="100%" runat="server" AutoGenerateColumns="False" AllowSorting="True" PageSize="10" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" OnItemCommand="rgDataIntakeDocuments_ItemCommand" AllowAutomaticDeletes="true" OnItemDataBound="rgDataIntakeDocuments_ItemDataBound" RenderMode="Lightweight">
        <ClientSettings AllowDragToGroup="false">
            <Selecting AllowRowSelect="True" EnableDragToSelectRows="false" />
        </ClientSettings>
        <MasterTableView DataKeyNames="id" AutoGenerateColumns="false" CommandItemDisplay="None">
            <CommandItemTemplate>
                <div class="commandItems">
                    <asp:LinkButton runat="server" CommandName="InitInsert" ID="btnAdd" Text="<i class='fa fa-upload'></i> Upload Document" />
                </div>
            </CommandItemTemplate>
            <CommandItemSettings ShowAddNewRecordButton="true" ShowRefreshButton="true" />
            <Columns>
                <telerik:GridBoundColumn DataField="id" FilterControlAltText="Filter id column" HeaderText="id" SortExpression="id" UniqueName="id" Display="false" ReadOnly="true">
                </telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="FileDescription" FilterControlAltText="Filter FileDescription column" HeaderText="File Description" SortExpression="FileDescription" UniqueName="FileDescription">
                </telerik:GridBoundColumn>
                <telerik:GridAttachmentColumn SortExpression="FileName" UploadControlType="RadAsyncUpload" DataSourceID="sqlDataIntakeDownloadColumn" MaxFileSize="1048576" EditFormHeaderTextFormat="Upload File:" HeaderText="Attachment" AttachmentDataField="BinaryData" AttachmentKeyFields="id" ForceExtractValue="Always" FileNameTextField="FileName" DataTextField="FileName" UniqueName="AttachmentColumn" AllowedFileExtensions="csv,xls">
                </telerik:GridAttachmentColumn>
                <telerik:GridEditCommandColumn UniqueName="EditCommandColumn" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" ButtonType="ImageButton">
                    <ItemStyle Width="50px"></ItemStyle>
                </telerik:GridEditCommandColumn>
            </Columns>
            <EditFormSettings ColumnNumber="2" FormMainTableStyle-CellPadding="5" FormTableStyle-CellPadding="5" EditColumn-ButtonType="ImageButton"></EditFormSettings>
        </MasterTableView>
    </telerik:RadGrid>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
