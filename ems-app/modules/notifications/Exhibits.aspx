<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Exhibits.aspx.cs" Inherits="ems_app.modules.notifications.Exhibits" %>

<%@ Register Src="~/UserControls/ExhibitInformation.ascx" TagPrefix="uc" TagName="OccupationInformation" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>MAP Notifications</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous" />
    <!-- Font Awesome -->
    <link href="<%= this.ResolveUrl("~/Common/vendors/font-awesome/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- Custom Theme Style -->
    <link href="<%= this.ResolveUrl("~/Common/build/css/custom.css") %>" rel="stylesheet" />
    <style>
        .card-body {
          height: 600px !important;
          overflow: scroll !important;
        }
        @page { 
            size: auto;   /* auto is the initial value */ 

    /* this affects the margin in the printer settings */ 
    margin: 15mm 10mm 15mm 10mm; 
        }
        @media print {
          body * {
            visibility: hidden;
          }
          .section-to-print, .section-to-print * {
            visibility: visible;
          }
        }
    </style>
</head>
<body style="background-color: #fff;">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" Width="100%" Height="100%" LoadingPanelID="RadAjaxLoadingPanel1">
            <telerik:RadWindowManager ID="RadWindowManager1" runat="server" EnableViewState="false" Modal="false"></telerik:RadWindowManager>
            <telerik:RadToolTip runat="server" ID="RadToolTip1" Width="580px" Height="120px" OffsetX="-50" OffsetY="-50" IsClientID="false" EnableViewState="true" ShowCallout="false" RenderInPageRoot="true" RelativeTo="BrowserWindow" ContentScrolling="Auto" Position="BottomRight" Animation="Fade" HideEvent="ManualClose">
                <p id="divMsgs" runat="server">
                    <asp:Label ID="Label1" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                    <asp:Label ID="Label2" runat="server" EnableViewState="true" Font-Bold="True">
                    </asp:Label>
                </p>
            </telerik:RadToolTip>
            <div class="row container-fluid">
                <div class="col-8">
                    <h2 class="section-to-print" style="margin-left:20px;" ><asp:Label ID="lblTitle" runat="server" Text=""></asp:Label></h2>
                </div>
                <div class="col-4">
                    <button type="button" class="btn btn-secondary" onclick="window.print();">Print</button> 
                    <button type="button" class="btn btn-secondary" onclick="window.open('', '_self', ''); window.close();">Close</button> 
                </div>
            </div>
            <div class="container-fluid">
            <div class="row courseDetails context section-to-print">
                <asp:SqlDataSource ID="sqlExhibits" runat="server" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" SelectCommand="select ae.Title, ae.AceID, CONVERT(VARCHAR(10),ae.TeamRevd,111) TeamRevd, concat(cast(FORMAT(ae.StartDate, 'MM/yy') as varchar(7)),' - ',cast(FORMAT(ae.EndDate, 'MM/yy') as varchar(7))) AS 'ExhibitDate', ae.ExhibitDisplay from CriteriaPackageArticulation cpa join Articulation a on cpa.ArticulationId = a.id join ACEExhibit ae on a.ExhibitID = ae.ID where cpa.PackageId = @CriteriaPackageID order by a.LastSubmittedOn desc" SelectCommandType="Text">
                    <SelectParameters>
                        <asp:QueryStringParameter DefaultValue="0" Name="CriteriaPackageID" QueryStringField="CriteriaPackageID" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:Repeater ID="rptExhibits" runat="server" DataSourceID="sqlExhibits" OnItemDataBound="rptExhibits_ItemDataBound">
                    <ItemTemplate>
                         <div class="col-md-4">
                            <div class="card" style="width:100%;">
                                <div class="card-header">
                                    <!--Ace ID : <%# Eval("AceID") %> Team Revd : <%# Eval("TeamRevd") %> Exhibit Date : <%# Eval("ExhibitDate") %>-->
                                    <span style="font-weight:bold;"><%# Eval("Title") %></span>
                                  </div>
                              <div class="card-body">
                                <p class="card-text"><%# Eval("ExhibitDisplay") %></p>
                              </div>

                              <div class="credit-recommendations-area col-md-12 col-sm-12 col-xs-12">
                                  <asp:Literal ID="litCPLEvidenceCompt" runat="server" />

                                  <div class="credit-recommendations-area col-md-12 col-sm-12 col-xs-12">
                                      <asp:Literal ID="litCPLRubric" runat="server" />

                                      <div class="credit-recommendations-area col-md-12 col-sm-12 col-xs-12">
                                          <asp:Literal ID="litCPLExhiDoc" runat="server" />
                                      </div>

                                  </div>



                              </div>




                            </div>
                                <asp:Label Visible="false" runat="server" ID="Label2" Text='<%# Eval("ExhibitDisplay") %>' />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            </div>
        </telerik:RadAjaxPanel>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    </form>
    <script src="<%= this.ResolveUrl("~/Common/vendors/jquery/dist/jquery.min.js") %>"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mark.js/8.11.1/jquery.mark.es6.js"></script>
    <script>
        $(document).ready(function () {
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            const criteria = urlParams.get('Criteria')
            var criteriaArray = criteria.split(',');
            $("div.context").mark(criteriaArray, {
                "separateWordSearch": false,
                "ignoreJoiners": true,
                "acrossElements": true
            });
        });
    </script>
</body>
</html>
