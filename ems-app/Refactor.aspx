<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Refactor.aspx.cs" Inherits="ems_app.Refactor" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadListBox ID="rblRecommendations" runat="server" CheckBoxes="true">
        <Items>
            <telerik:RadListBoxItem Value="1" Text="Item 1" />
            <telerik:RadListBoxItem Value="2" Text="Item 2" />
            <telerik:RadListBoxItem Value="3" Text="Item 3" />
        </Items>
    </telerik:RadListBox>
    <asp:Label ID="lblTest" runat="server"></asp:Label>
    <telerik:RadButton ID="RadButton1" runat="server" Text="Test" OnClick="RadButton1_Click"></telerik:RadButton>
    </div>
    </form>
</body>
</html>
