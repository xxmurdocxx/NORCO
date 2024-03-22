<%@ Page Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="SystemMaintenanceNotifications.aspx.cs" Inherits="ems_app.modules.security.SystemMaintenanceNotifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .popUpWindow {
            position: absolute;
            z-index: 9000;
            border: 1px solid;
            border-color: black;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 800px;
            background-color:white;
        }
        .rowFooter {
            background-color: white;
        }
        .columnFooterLeft {
            flex: 50% !important;
            padding: 10px;
            text-align: right;
        }

       .columnFooterRight {
            flex: 50% !important;
            padding: 10px;
            text-align: left;
        }
        .changeDetail{
            white-space: pre-wrap;
        }
        .centerContainer {
            width: 100%;
            display: inline-block;
            text-align: center;
        }
        .RadCalendarPopup {
            z-index: 9999 !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2 headerMainTitle">System Maintenance Notifications</p>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div>
                <div class="form-group">
                    <asp:LinkButton ID="lblNewNotification" OnClick="lblNewNotification_Click" CssClass="btn btn-default" runat="server"><i class="fa fa-plus-circle"></i> Add New Notification</asp:LinkButton>
                </div>
                <telerik:RadGrid ID="rgNotifications" runat="server" AllowFilteringByColumn="True" AllowPaging="true" AllowSorting="True" Culture="es-ES" DataSourceID="odsSystemMaintenance" Width="100%" OnItemCommand="rgNotifications_ItemCommand" OnItemDataBound="rgNotifications_ItemDataBound" >
                    <GroupingSettings CaseSensitive="false" />
                    <MasterTableView AutoGenerateColumns="false" DataKeyNames="SystemMaintenanceID, IsNotificationEnabled" DataSourceID="odsSystemMaintenance" PageSize="10" AllowSorting="true" AllowPaging="true" AllowMultiColumnSorting="true" EnableHeaderContextMenu="true" HeaderStyle-Font-Bold="true">
                        <%-- Add columns here --%>
                        <Columns>
                            <%-- Add Edit and enable/disable columns here --%>
                            <telerik:GridButtonColumn ButtonType="LinkButton" ButtonCssClass="btn-link" Text="Edit" UniqueName="colEditNotification" CommandName="EditNotification" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                            </telerik:GridButtonColumn>
                            <telerik:GridButtonColumn ButtonType="LinkButton" ButtonCssClass="btn-link" DataTextField="IsNotificationEnabled" UniqueName="colDisableNotification" CommandName="DisableNotification" ConfirmText="Are you sure you want to enable/disable notification?" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                            </telerik:GridButtonColumn>

                            <telerik:GridBoundColumn DataField="MaintenanceStartDate" HeaderText="Start Date" HeaderStyle-HorizontalAlign="Center" UniqueName="MaintenanceStartDate" AutoPostBackOnFilter="true" AllowFiltering="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="MaintenanceEndDate" HeaderText="End Date" HeaderStyle-HorizontalAlign="Center" UniqueName="MaintenanceEndDate" AutoPostBackOnFilter="true" AllowFiltering="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="SelectHours" HeaderText="Hours Prior" HeaderStyle-HorizontalAlign="Center" UniqueName="SystemMaintenanceNotificationHoursID_Prior" AllowFiltering="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="SelectMessage" HeaderText="Message" HeaderStyle-HorizontalAlign="Center" UniqueName="SystemMaintenanceMessageID" ItemStyle-HorizontalAlign="Left" AllowFiltering="false" HeaderStyle-Width="260px">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ChangeDetails" HeaderText="Change Details" HeaderStyle-HorizontalAlign="Center" UniqueName="ChangeDetails" ItemStyle-HorizontalAlign="Left" AllowFiltering="false">
                                <ItemStyle CssClass="changeDetail" />
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </div>
        </div>
    </div>
    
    <asp:Panel runat="server" class="popUpWindow" ID="pnlPopupNotification" HorizontalAlign="Center" Visible="false">
        <div class="popUpHeader">
            <div class="popUpHeaderX">
                <asp:LinkButton runat="server" ID="lnkXPopupContainer" Text="X" OnClick="lnkXPopupContainer_Click" CausesValidation="false"></asp:LinkButton></div>
            <div id="divPopUpHeaderText" class="popUpHeaderText" runat="server">System Notification</div>
        </div>

        <%-- NEW NOTIFICATION --%>
        <asp:Panel runat="server" ID="pnlAddNewNotification" style="background-color: white;" Visible="false">
            <div style="text-align: right;" >
                <div>
                    <div style="border-top: solid 8px white; text-align: center">
                        <asp:Label CssClass="gridLabel" runat="server" ID="lblAddNewNotification">Add New Notification</asp:Label>
                    </div>
                    <div class="col-md-5" style="float: left; border-top: solid 8px white;">
                        <label class="LeftLabelColumn">Start Date :</label>
                        <label class="LeftLabelColumn" style="padding-top: 15px">End Date :</label>
                        <label class="LeftLabelColumn" style="padding-top: 30px">Hours to display prior :</label>
                        <label class="LeftLabelColumn" style="padding-top: 55px">Impact :</label>
                        <label class="LeftLabelColumn" style="padding-top: 105px">Change Details :</label>
                    </div>

                    <div class="LeftValueColumn">
                        <%-- START END DATES - DATE PICKERS - MIGHT NEED TO ADD RADTIMEPICKER AS WELL --%>
                        <div style="padding-top: 5px;">
                            <telerik:RadDateTimePicker runat="server" RenderMode="Lightweight" ID="rdpStartDate"  Width="30%" Culture="en-US"></telerik:RadDateTimePicker>
                        </div>
                        <div style="padding-top: 5px;">
                            <telerik:RadDateTimePicker runat="server" RenderMode="Lightweight" ID="rdpEndDate"  Width="30%" Culture="en-US"></telerik:RadDateTimePicker>
                        </div>
                        <%-- HOURS PRIOR - REVIEW IF POSTBACK IS NEEDED --%>
                        <div style="padding-top: 10px;">
                            <asp:DropDownList ID="ddlHoursPriorList" DataSourceID="odsHoursPrior" runat="server" Width="40" DataValueField="SystemMaintenanceNotificationHoursID" DataTextField="Hours" AutoPostBack="false"></asp:DropDownList>
                        </div>
                        <%-- IMPACT --%>
                        <div style="padding-top: 10px;">
                            <telerik:RadRadioButtonList runat="server" ID="rblImpact" AutoPostBack="false">
                                <Items>
                                    <telerik:ButtonListItem Text="There should be no impact to users during this time" Value="1" />
                                    <telerik:ButtonListItem Text="Users may experience slowness or intermittent connectivity during this time" Value="2" />
                                    <telerik:ButtonListItem Text="Services will be unavailable during this time" Value="3" />
                                </Items>
                            </telerik:RadRadioButtonList>
                        </div>
                        <%-- CHANGE DETAILS - LARGE MULTILINE TEXTBOX --%>
                        <div style="padding-top: 20px;">
                            <asp:TextBox runat="server" ID="tbChangeDetails" TextMode="MultiLine" Wrap="true" Columns="50" Rows="5"></asp:TextBox>
                        </div>

                        <div style="padding-top: 12px; text-align: center">
                            <asp:Button runat="server" ID="btnSaveNewNotification" Text="Save" CssClass="btn btn-primary" OnClick="btnSaveNewNotification_Click" BackColor="#203864"  ValidationGroup="vgNotificationValidationGroup"/>
                            <asp:Button runat="server" ID="btnCancelNotification" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancelNotification_Click" />
                            <br />
                            <br />
                            <asp:CustomValidator ID="cvNotificationNew" runat="server" OnServerValidate="cvNotificationNew_ServerValidate" CssClass="errorMessageSmall" EnableClientScript="False" ValidateEmptyText="True" ValidationGroup="vgNotificationValidationGroup"></asp:CustomValidator>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <%-- EDIT NOTIFICATION --%>
        <asp:Panel runat="server" ID="pnlNotificationDetail" style="background-color: white;" Visible="false">
            <div style="text-align: right;">
                <div>
                    <div style="border-top: solid 8px white; text-align: center">
                        <asp:Label CssClass="gridLabel" runat="server" ID="lblNotificationDetail"></asp:Label>
                    </div>
                    <div class="col-md-5" style="float: left; border-top: solid 8px white;">
                        <label class="LeftLabelColumn">Start Date :</label>
                        <label class="LeftLabelColumn" style="padding-top: 15px">End Date :</label>
                        <label class="LeftLabelColumn" style="padding-top: 30px">Hours to display prior :</label>
                        <label class="LeftLabelColumn" style="padding-top: 55px">Impact :</label>
                        <label class="LeftLabelColumn" style="padding-top: 105px">Change Details :</label>
                    </div>
                    <div class="LeftValueColumn">
                        <%-- START END DATES - DATE PICKERS --%>
                        <div style="padding-top: 5px;">
                            <telerik:RadDateTimePicker runat="server" RenderMode="Lightweight" ID="rdpStartDateEdit" Width="30%"></telerik:RadDateTimePicker>
                        </div>
                        <div style="padding-top: 5px;">
                            <telerik:RadDateTimePicker runat="server" RenderMode="Lightweight" ID="rdpEndDateEdit" Width="30%"></telerik:RadDateTimePicker>
                        </div>
                        <%-- HOURS PRIOR - REVIEW IF POSTBACK IS NEEDED --%>
                        <div style="padding-top: 10px;">
                            <asp:DropDownList ID="ddlHourPriorEdit" DataSourceID="odsHoursPrior" runat="server" Width="50" DataValueField="SystemMaintenanceNotificationHoursID" DataTextField="Hours" AutoPostBack="false"></asp:DropDownList>
                        </div>
                        <%-- IMPACT --%>
                        <div style="padding-top: 10px;">
                            <telerik:RadRadioButtonList runat="server" ID="rblImpactEdit" AutoPostBack="false">
                                <Items>
                                    <telerik:ButtonListItem Text="There should be no impact to users during this time" Value="1" />
                                    <telerik:ButtonListItem Text="Users may experience slowness or intermittent connectivity during this time" Value="2" />
                                    <telerik:ButtonListItem Text="Services will be unavailable during this time" Value="3" />
                                </Items>
                            </telerik:RadRadioButtonList>
                        </div>
                        <%-- CHANGE DETAILS - LARGE MULTILINE TEXTBOX --%>
                        <div style="padding-top: 20px;">
                            <asp:TextBox runat="server" ID="tbChangeDetailEdit" TextMode="MultiLine" Wrap="true" Columns="50" Rows="5"></asp:TextBox>
                        </div>
                        <%-- ADD FUNCTION TO THESE --%>
                        <div style="padding-top: 12px; text-align: center">
                            <asp:Button runat="server" ID="Button1" Text="Save" CssClass="btn btn-primary" OnClick="btnSaveNotification_Click" ValidationGroup="vgNotificationValidationGroup" BackColor="#203864"/>
                            <asp:Button runat="server" ID="Button2" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancelNotification_Click" />
                            <br />
                            <br />
                            <asp:CustomValidator ID="cvNotificationEdit" runat="server" OnServerValidate="cvNotificationEdit_ServerValidate" CssClass="errorMessageSmall" EnableClientScript="False" ValidateEmptyText="True" ValidationGroup="vgNotificationValidationGroup"></asp:CustomValidator>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <asp:Panel runat="server" ID="pnlFooter" Visible="false">
            <div class="centerContainer">
                <div class="rowFooter">
                    <table>
                        <tr>
                            <td style="width:400px;">
                                <p>Created</p>
                        <p>
                            <asp:Label Font-Size="X-Small" Text="N/A" ID="lblCreatedBy" runat="server" />
                        </p>
                            </td>
                            <td  style="width:400px;">
                                <p>Modified</p>
                        <p>
                            <asp:Label Text="N/A" Font-Size="X-Small" ID="lblModifiedBy" runat="server" />
                        </p>
                            </td>
                        </tr>
                    </table>
                    <div class="columnFooterLeft">
                        
                    </div>
                    <div class="columnFooterRight">
                        
                    </div>
                </div>
            </div>

        </asp:Panel>

    </asp:Panel>
    
    <asp:HiddenField runat="server" ID="hidSysMaintenanceNotificationsId" Value="" />

    <asp:ObjectDataSource ID="odsSystemMaintenance" runat="server" SelectMethod="GetList" TypeName="ems_app.Common.models.GenericLookup">
        <SelectParameters>
            <asp:Parameter Name="storedProcedure" Type="String" DefaultValue="spSystemMaintenance_List" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsHoursPrior" runat="server" SelectMethod="GetList" TypeName="ems_app.Common.models.GenericLookup">
        <SelectParameters>
            <asp:Parameter Name="storedProcedure" Type="String" DefaultValue="spSystemMaintenanceNotificationHours_List" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>
