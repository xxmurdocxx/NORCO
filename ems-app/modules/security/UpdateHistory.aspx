<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Common/templates/main.Master" CodeBehind="UpdateHistory.aspx.cs" Inherits="ems_app.modules.security.UpdateHistory" %>



<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
    <style>
        .changeDetail {
            white-space: pre-wrap;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2 headerMainTitle">Update History</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" LoadingPanelID="RadAjaxLoadingPanel1">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <telerik:RadGrid ID="rgUpdateHistory" runat="server" AllowPaging="true" Culture="es-ES" DataSourceID="odsUpdateHistory" Width="100%" CellSpacing="-1" ResolvedRenderMode="Classic" RenderMode="Lightweight" HorizontalAlign="Center">
                    <GroupingSettings CaseSensitive="false" />
                    <MasterTableView AutoGenerateColumns="false" DataKeyNames="" DataSourceID="odsUpdateHistory" PageSize="10" AllowPaging="true" HeaderStyle-Font-Bold="true" HorizontalAlign="Center" CommandItemDisplay="None">
                        <ItemStyle CssClass="rowMedCompact" />
                        <AlternatingItemStyle CssClass="rowMedCompact" />
                        <Columns>
                            <telerik:GridBoundColumn DataField="MaintenanceEndDate" HeaderText="Date of Deployment" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="135px" UniqueName="MaintenanceDeploymentDate" ItemStyle-HorizontalAlign="Center" AllowFiltering="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="ChangeDetails" HeaderText="Change Details" HeaderStyle-HorizontalAlign="Center" UniqueName="ChangeDetails" AllowFiltering="false" >
                                <ItemStyle CssClass="changeDetail" />
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
            </div>
        </div>
    </div>
    
    </telerik:RadAjaxPanel>
    <asp:ObjectDataSource ID="odsUpdateHistory" runat="server" SelectMethod="GetList" TypeName="ems_app.Common.models.GenericLookup">
        <SelectParameters>
            <asp:Parameter Name="storedProcedure" Type="String" DefaultValue="spSystemMaintenance_UpdateHistoryList" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
