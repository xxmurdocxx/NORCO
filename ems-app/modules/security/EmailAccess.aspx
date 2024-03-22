<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmailAccess.aspx.cs" Inherits="ems_app.modules.users.EmailAccess" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title></title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous">
    <!-- Font Awesome -->
    <%--<link href="/Common/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">--%>

    <!-- Font Awesome 6.2.1 -->
    <link href="/Common/vendors/fontawesome/css/all.css" rel="stylesheet">
    <!-- update existing v4 CSS to use v6 icons and assets -->
    <link href="/Common/vendors/fontawesome/css/v4-shims.css" rel="stylesheet">

    <!-- Custom Theme Style -->
    <link href="/Common/build/css/custom.css" rel="stylesheet">
    <style type="text/css">
        .login-failure {
            color: red;
            font-weight: bold;
        }

        .validators {
            margin: 0px;
            padding: 0px;
            float: right;
            color: #ff0000;
        }

        .RadPanelBar_Material, .RadPanelBar .rpLast .rpRootLink, .RadPanelBar .rpLast .rpHeaderTemplate {
            background-color: transparent !important;
            border: none !important;
            color: #244d95 !important;
        }
    </style>
</head>

<body class="login d-flex justify-content-center align-items-center">




     <!-- jQuery -->
    <script src="/Common/vendors/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap -->
    <script src="/Common/vendors/bootstrap/dist/js/bootstrap.min.js"></script>


    <script type="text/javascript">

        
        function getCookie(cname) {
            let name = cname + "=";
            let decodedCookie = decodeURIComponent(document.cookie);
            let ca = decodedCookie.split(';');
            for (let i = 0; i < ca.length; i++) {
                let c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }

    </script>

   

</body>



</html>
