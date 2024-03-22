<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Favorites.ascx.cs" Inherits="ems_app.UserControls.UI.Favorites" %>
<div class="row">
    <asp:SqlDataSource ID="sqlFavorites" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="GetUserFavorites" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter Name="UserID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <telerik:RadTileList RenderMode="Lightweight" runat="server" DataSourceID="sqlFavorites" ID="RadTileList1" Width="100%"
        ScrollingMode="Auto" AutoPostBack="false" DataBindings-CommonTileBinding-Shape="Wide" TileRows="1">
        <DataBindings>
            <CommonTileBinding TileType="RadContentTemplateTile" DataTitleTextField="Title" DataNameField="MenuID" DataBadgeImageUrlField="IconImage" DataNavigateUrlField="url" Shape="Square" />
        </DataBindings>
    </telerik:RadTileList>
</div>
