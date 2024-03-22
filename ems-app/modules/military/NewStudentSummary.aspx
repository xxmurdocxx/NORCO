<%@ Page Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="NewStudentSummary.aspx.cs" Inherits="ems_app.modules.military.NewStudentSummary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        @media only screen and (max-width: 1920px) {
            .PageCenter {
                width: 100%;
                overflow-x: auto;
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
                overflow-x: auto;
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

        .tableSBorder td {
            border-bottom-width: 0px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="appTitle" id="SystemTitle" runat="server"></p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="sqlVeteranOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>"
        SelectCommand="SELECT AC.ID AS Id, AC.AceID + ' ' + AC.Title AS Title FROM VeteranACECourse AS VC INNER JOIN ACEExhibit AS AC ON VC.AceID = AC.AceID AND VC.TeamRevd = AC.TeamRevd AND VC.StartDate = AC.StartDate AND VC.EndDate = AC.EndDate WHERE VC.VeteranId = @VeteranId AND VC.CollegeId = @CollegeId UNION SELECT AC.ID AS Id, AC.AceID + ' ' + AC.Title AS Title FROM VeteranOccupation AS VO INNER JOIN ACEExhibit AC ON VO.AceID = AC.AceID AND VO.TeamRevd = AC.TeamRevd AND VO.StartDate = AC.StartDate AND VO.EndDate = AC.EndDate WHERE VO.VeteranId = @VeteranId AND VO.CollegeId = @CollegeId">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfCollege" PropertyName="Value" Name="CollegeId" Type="Int32" />
            <asp:ControlParameter ControlID="hfVeteranID" PropertyName="Value" Name="VeteranId" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlPrograms" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select program_id, program + ' - ' + cast(coalesce(description,'') as varchar(50)) as program from Program_IssuedForm where college_id=1 and status = 0 order by program">
        <%--        <SelectParameters>
            <asp:ControlParameter ControlID="hfCollege" PropertyName="Value" Name="CollegeId" Type="Int32" />
        </SelectParameters>--%>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlMOS" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT * FROM [LookupService]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOccupations" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="SELECT distinct id, TRIM(Occupation) + ' – ' + [AceID] + ' ' + concat(cast(FORMAT(StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(EndDate, 'MM/yy') as varchar(7))) + ' ' + [Title] as OccupationDetail  FROM [dbo].[ACEExhibit] order by OccupationDetail"></asp:SqlDataSource>
    <asp:HiddenField ID="hfCollege" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfVeteranID" runat="server" ClientIDMode="Static" />
    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server" EnableShadow="true">
    </telerik:RadWindowManager>
    <h1 class="title">Student Intake</h1>
    <div class="PageCenter">
        <br />
        <table class="table tableSBorder" style="width: 100%;">
            <colgroup>
                <col style="width: 20%" />
                <col style="width: 30%" />
                <col style="width: 20%" />
                <col style="width: 30%" />
            </colgroup>
            <tbody>
                <tr>
                    <td>
                        <asp:Label ID="lblName" runat="server" Text="Name:"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtName" CssClass="form-control" Text="" Width="100%" ReadOnly="true"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Label ID="lblFinancial" runat="server" Text="Financial Aid:"></asp:Label></td>
                    <td>
                        <asp:DropDownList ID="ddlFinancial" runat="server" CssClass="form-control" Width="100%">
                            <asp:ListItem Value="0" Text="Incomplete" Selected="True" />
                            <asp:ListItem Value="1" Text="Complete" />
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblApplication" runat="server" Text="CCC Application:"></asp:Label></td>
                    <td>
                        <asp:DropDownList ID="ddlApplication" runat="server" CssClass="form-control" Width="100%">
                            <asp:ListItem Value="0" Text="Unsubmitted" Selected="True"/>
                            <asp:ListItem Value="1" Text="Submitted" />
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:Label ID="lblConseling" runat="server" Text="Counseling Appt:"></asp:Label></td>
                    <td>
                        <asp:DropDownList ID="ddlConseling" runat="server" CssClass="form-control" Width="100%">
                            <asp:ListItem Value="0" Text="Incomplete" Selected="True" />
                            <asp:ListItem Value="1" Text="Complete" />
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblProgram" runat="server" Text="Program of Study:"></asp:Label></td>
                    <td>
                        <telerik:RadDropDownList ID="ddlProgram" DataSourceID="sqlPrograms" DataTextField="program" DataValueField="program_id" runat="server" Width="100%" DefaultMessage="Select Program">
                        </telerik:RadDropDownList>
                    </td>
                    <td>
                        <asp:Label ID="lblOrientation" runat="server" Text="Orientation:"></asp:Label></td>
                    <td>
                        <asp:DropDownList ID="ddlOrientation" runat="server" CssClass="form-control" Width="100%">
                            <asp:ListItem Value="0" Text="Incomplete" Selected="True" />
                            <asp:ListItem Value="1" Text="Complete" />
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblBenefits" runat="server" Text="Educational Benefits:"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtBenefits" CssClass="form-control" Text="" Width="100%"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Label ID="lblAssessment" runat="server" Text="Assessment:"></asp:Label></td>
                    <td>
                        <asp:DropDownList ID="ddlAssessment" runat="server" CssClass="form-control" Width="100%">
                            <asp:ListItem Value="0" Text="Incomplete" Selected="True" />
                            <asp:ListItem Value="1" Text="Complete" />
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr style="display:none">
                    <td>
                    <td>
                    </td>
                    <td>
                        <asp:Label ID="lblTotalCredits" runat="server" Text="Total Credits:"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtTotalCredits" CssClass="form-control" Text="30" Width="100%" ReadOnly="true"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblJST" runat="server" Text="JST:"></asp:Label>
                        <br />
                        <br />
                        <br />
                        <asp:Label ID="lblDD214" runat="server" Text="DD-214:"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlJST" runat="server" CssClass="form-control" Width="100%" Enabled="false">
                            <asp:ListItem Value="0" Text="Unsubmitted" Selected="True" />
                            <asp:ListItem Value="1" Text="Submitted" />
                        </asp:DropDownList>
                        <br />
                        <asp:DropDownList ID="ddlDD214" runat="server" CssClass="form-control" Width="100%" Enabled="false">
                            <asp:ListItem Value="0" Text="Unsubmitted" Selected="True" />
                            <asp:ListItem Value="1" Text="Submitted" />
                        </asp:DropDownList>
                    </td>
                    <td colspan="2">
                        <telerik:RadGrid ID="rgVeteranOccupations" runat="server" AllowSorting="True" AllowAutomaticDeletes="true" AutoGenerateColumns="False" Culture="es-ES" DataSourceID="sqlVeteranOccupations" AllowFilteringByColumn="false" MasterTableView-CommandItemSettings-ShowRefreshButton="false" AllowPaging="false" GroupingSettings-CaseSensitive="false" AllowAutomaticInserts="true">
                            <ClientSettings AllowKeyboardNavigation="true">
                                <Selecting AllowRowSelect="true"></Selecting>
                                <ClientEvents />
                            </ClientSettings>
                            <MasterTableView Name="ParentGrid" DataSourceID="sqlVeteranOccupations" PageSize="12" DataKeyNames="id" CommandItemDisplay="Top" CommandItemSettings-ShowAddNewRecordButton="false" EnableHierarchyExpandAll="true" AllowFilteringByColumn="false" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true">
                                <Columns>
                                    <telerik:GridBoundColumn DataField="Id" UniqueName="Id" Display="false" ReadOnly="true">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Title" UniqueName="Title" Display="true" ReadOnly="true" HeaderText="MOS, AFCS, Rate 1:">
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>   
                    </td>
                </tr>
            </tbody>
        </table>
        <br />
        <br />
        <div style="text-align: right">
            <asp:Button runat="server" Text="CREDITS" CssClass="btn btn-primary" Width="200px" BackColor="#203864" ForeColor="White" OnClientClick="window.location.href='../military/MilitaryCredits.aspx'"/>
            &nbsp&nbsp&nbsp
            <asp:Button runat="server" Text="SAVE" ID="btnSave" CssClass="btn" Width="200px" BackColor="#203864" ForeColor="White" OnClick="btnSave_Click" />
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
    <script type="text/javascript">
        function callBackFn(arg) {
            //alert(arg);
        }
    </script>
</asp:Content>
