<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Close.aspx.cs" Inherits="ems_app.modules.popups.Close" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Redirecting...</title>
    <script>
        setTimeout(function () {
            window.close()
        }, 2000);
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
