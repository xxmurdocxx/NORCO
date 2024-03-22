<%@ Page Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="NewStudent.aspx.cs" Inherits="ems_app.modules.military.NewStudent" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        @media only screen and (max-width: 1920px) {
            .PageCenter {
                width: 100%;
                padding-left: 15%;
                padding-right: 15%;
                font-size: 15px;
            }

            .listCheck {
                padding-left: 20%
            }
        }

        @media only screen and (max-width: 600px) {
            .PageCenter {
                width: 100%;
                padding-left: 5%;
                padding-right: 5%;
                font-size: 15px;
            }

            .listCheck {
                padding-left: 5%
            }
        }

        .title {
            background-color: #f1f1f1;
            padding: 20px;
            text-align: center;
            font-size: 30px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="appTitle" id="SystemTitle" runat="server"></p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hfCollege" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfUserID" runat="server" ClientIDMode="Static" />
    <asp:SqlDataSource ID="sqlBranch" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [LookupService]"></asp:SqlDataSource>
    <asp:HiddenField ID="hfVeteranID" runat="server" ClientIDMode="Static" />
    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true">
    </telerik:RadWindowManager>
    <h1 class="title">Student Intake</h1>
    <div class="PageCenter">
        <br />
        <asp:Label ID="lblError" runat="server" ForeColor="Red" Font-Size="Small" Font-Bold="true" Visible="false"></asp:Label>
        <table style="width: 100%">
            <colgroup>
                <col style="width: 15%" />
                <col style="width: 25%" />
                <col style="width: 60%" />
            </colgroup>
            <tbody>
                <tr>
                    <td>
                        <asp:Label ID="lblname" runat="server" Text="First Name:"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtFirstName" CssClass="form-control" placeholder="Enter First Name" Width="100%" MaxLength="50"></asp:TextBox>
                        <asp:HiddenField ID="hfFirstName" runat="server" ClientIDMode="Static" />
                    </td>
                    <td rowspan="8">
                        <div style="padding-left: 20%;">
                            <asp:Label ID="Label2" runat="server" Text="Reason for visit:"></asp:Label>
                            <br />
                            <asp:Label ID="Label3" runat="server" Text="(Check all apply)" Font-Size="X-Small"></asp:Label>
                            <br />
                        </div>
                        <telerik:RadCheckBoxList runat="server" ID="ckblReason" AutoPostBack="false" Width="100%" CssClass="listCheck">
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
                        <telerik:RadTextBox ID="txtOtherDescription" runat="server" ClientIDMode="Static" MaxLength="200" Enabled="false"></telerik:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblMidleName" runat="server" Text="Middle Name:"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtMiddleName" CssClass="form-control" placeholder="Enter Middle Name" Width="100%" MaxLength="50"></asp:TextBox>
                        <asp:HiddenField ID="hfMiddleName" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblLastName" runat="server" Text="Last Name:"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtLastName" CssClass="form-control" placeholder="Enter Last Name" Width="100%" MaxLength="50"></asp:TextBox>
                        <asp:HiddenField ID="hfLastName" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblID" runat="server" Text="ID #:"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtID" CssClass="form-control" placeholder="Enter ID" Width="100%" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="lblErrorID" runat="server" Text="Registered ID" ForeColor="Red" Font-Size="X-Small" Visible="false"></asp:Label>
                        <asp:HiddenField ID="hfidn" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblPhone" runat="server" Text="Phone:"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtPhone" CssClass="form-control" placeholder="Enter phone" Width="100%" MaxLength="50"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblEmail" runat="server" Text="Email:"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtEmail" CssClass="form-control" placeholder="Enter email" Width="100%" MaxLength="300"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" Display="Dynamic" ControlToValidate="txtEmail" ErrorMessage="Invalid Email Format" ForeColor="Red" Font-Size="X-Small" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" Display="Dynamic" ControlToValidate="txtEmail" ErrorMessage="* Required" ForeColor="Red" Font-Size="X-Small"></asp:RequiredFieldValidator>
                        <asp:Label ID="lblerrorEmail" runat="server" Text="Registered Email" ForeColor="Red" Font-Size="X-Small" Visible="false"></asp:Label>
                        <asp:HiddenField ID="hfEmail" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblBranch" runat="server" Text="Branch:"></asp:Label></td>
                    <td>
                        <telerik:RadDropDownList ID="ddlBranch" DataSourceID="sqlBranch" DataTextField="Description" DataValueField="id" runat="server" Width="100%" DefaultMessage="Select Branch">
                        </telerik:RadDropDownList>
                    </td>
                </tr>
            </tbody>
        </table>
        <br />
        <div style="text-align: right">
            <asp:Button ID="btnNewStudent" runat="server" Text="NEXT" CssClass="btn" Width="200px" OnClick="btnNewStudent_Click" BackColor="#203864" ForeColor="White" />
            <asp:Button ID="btnSave" Text="" Style="display: none;" OnClick="btnSave_Click" runat="server" />
            <%--button for ok of windows--%>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        function selectedIndexChanged(list, args) {
            var valores = list.get_selectedIndices();
            valores.includes(11) ? $find("txtOtherDescription").enable() : $find("txtOtherDescription").disable();
        }

        function confirmCallbackFn(arg) {
            if (arg) //the user clicked OK
            {
                __doPostBack("<%=btnSave.UniqueID %>", "");
            }
        }

        function callBackFn(arg) {
            //alert(arg);
        }

    </script>
</asp:Content>
