<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TreeviewMenu.ascx.cs" Inherits="ems_app.UserControls.UI.TreeviewMenu" %>
<telerik:RadTreeView RenderMode="Lightweight" ID="rtvMenu" runat="server" Width="280px" Height="550px" DataFieldID="MenuID" DataFieldParentID="ParentMenuID" DataTextField="Title" DataValueField="MenuID" DataSourceID="sqlMenu" DataNavigateUrlField="url" OnContextMenuItemClick="rtvMenu_ContextMenuItemClick" OnClientLoad="TreeviewLoad" OnClientNodeClicked="onClientNodeClickedHandler">
    <ContextMenus>
        <telerik:RadTreeViewContextMenu ID="MainContextMenu" runat="server" RenderMode="Lightweight">
            <Items>
                <telerik:RadMenuItem Value="Add" Text="Add/Remove Favorite" ImageUrl="~/Common/images/favorite-on-12px.png">
                </telerik:RadMenuItem>
            </Items>
            <CollapseAnimation Type="none"></CollapseAnimation>
        </telerik:RadTreeViewContextMenu>
    </ContextMenus>
    <DataBindings>
        <telerik:RadTreeNodeBinding Expanded="false" ImageUrlField="imageURL"></telerik:RadTreeNodeBinding>
    </DataBindings>
</telerik:RadTreeView>
<asp:HiddenField runat="server" ID="hfUserID" />
<asp:SqlDataSource runat="server" ID="sqlMenu" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
    SelectCommand="GetMenuOptions" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="CollegeID" Type="Int32" />
        <asp:Parameter Name="RoleID" Type="Int32" />
        <asp:Parameter Name="ApplicationID" Type="Int32" />
        <asp:Parameter Name="UserID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<script>
    function TreeviewLoad() {
        var tree = $find("<%= rtvMenu.ClientID %>");
        var nodes = tree.get_allNodes();
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].get_level() == 0) {
                nodes[i].set_cssClass("bold");
                nodes[i].set_toolTip("Click on the > icon to expand and then select the menu item");
            }
            //if (nodes[i].get_text() == "MAP Uniform Credit Recommendations") {
            //    nodes[i].disable();
            //}
            if (nodes[i].get_text() == "Archived Articulations") {
                nodes[i].disable();
            }
            if (nodes[i].get_text() == "Veterans Units Awarded") {
                nodes[i].disable();
            }
            //if (nodes[i].get_text() == "Programs of Study") {
            //    nodes[i].disable();
            //}
            if (nodes[i].get_text() == "Current Military Students") {
                nodes[i].disable();
            }
        }
        
        
    }
    function onClientNodeClickedHandler(sender, eventArgs) {
        var node = eventArgs.get_node();
        node.toggle();
    }
</script>