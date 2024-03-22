<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateArticulationRecommendation.ascx.cs" Inherits="ems_app.UserControls.CreateArticulationRecommendation" %>
<style>
    .RadComboBox .rcbEmptyMessage {
      font-weight: normal !important;
      font-style:normal !important;
      opacity: 1;
      color: inherit !important;
      font-size: inherit !important;
    }
    .RadComboBoxCourses {
        background-color:lightyellow !important;
    }
</style>
<telerik:RadAjaxPanel runat="server" ID="RadAjaxPanel1" LoadingPanelID="RadAjaxLoadingPanel1">
    <telerik:RadNotification ID="rnCreateCreditRecommendation" runat="server" Position="Center" Width="400px" Height="200px"></telerik:RadNotification>
    <div class="advancedSearchContainer p-1 mb-2">
        <input id="hfSelectedAceID" type="hidden" runat="server" />
        <input id="hfSelectedTeamRevd" type="hidden" runat="server" />
        <div class="row p-2">
            <div class="col-sm-6" style="font-weight: bold;">
                <telerik:RadComboBox ID="rcbCourses" DataSourceID="sqlCourses" DataTextField="CourseDescription" DataValueField="outline_id" MaxHeight="200px" Width="100%" AppendDataBoundItems="true" EmptyMessage="First type a course or keyword you wish to articulate (e.g.BUS 10)." ToolTip="Search for a college course you wish to articulate (i.e.BUS 10). " runat="server" MarkFirstMatch="true" Filter="Contains" DropDownAutoWidth="Enabled" AutoPostBack="true" OnSelectedIndexChanged="rcbCourses_SelectedIndexChanged" BackColor="#ffffe0" CssClass="RadComboBoxCourses">
                <Items>
                    <telerik:RadComboBoxItem Text="" Value="" />
                </Items>
                </telerik:RadComboBox>
                <asp:SqlDataSource runat="server" ID="sqlCourses" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="sp_SearchCourses" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                    <SelectParameters>
                        <asp:Parameter Name="CollegeID" DbType="Int32" />
                        <asp:Parameter Name="CourseType" DbType="Int32" DefaultValue="1" />
                        <asp:Parameter Name="All" DbType="Int32" DefaultValue="" ConvertEmptyStringToNull="true"/>
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:Label ID="lblCourse" runat="server" CssClass="alert alert-warning" Text="Please select a course." Visible="false" />
            </div>
            <div class="col-sm-6">
                <asp:Panel CssClass="row p-2" ID="pnlSelectedCourseInfo" runat="server" Visible="false">
                    <telerik:RadLabel ID="rlSelectedCourse" runat="server"></telerik:RadLabel>
                </asp:Panel>

            </div>

        </div>
        <div class="row p-2">
            <div class="col-sm-10">
                <asp:Panel ID="pnlCreditRecommendations" runat="server">
                    <div class="row">
                        <div class="col-sm-11">
                            <telerik:RadAutoCompleteBox ID="racbCriteria" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="200" DropDownHeight="200" DataSourceID="sqlCriteria" DataTextField="FullCriteria" EmptyMessage="Search by credit recommendation(s) OR enter Exhibit ID(s) below." DataValueField="Criteria" ClientIDMode="Static" AllowCustomEntry="false" HighlightFirstMatch="true" Delimiter="," AutoPostBack="true" ToolTip="Once you have selected a course (left), search one or more credit recommendation(s) that best apply to the selected course" CssClass="acbCriteria" BackColor="#ffffe0" IsCaseSensitive="false" OnClientEntryAdded="entryAdding" OnClientEntryRemoved="entryAdding" ></telerik:RadAutoCompleteBox>                         
                        </div>
                        <div class="col-md-1">
                            <div id="rcCondition" style="display:none;">
                                 <telerik:RadComboBox ID="rcbCondition" runat="server" Width="90px" DropDownAutoWidth="Enabled" ToolTip="Use the & / Or condition to indicate the credit recommendations relationship that justifies this articulation" Font-Bold="true">
                                    <Items>
                                                    
                                        <telerik:RadComboBoxItem Value="1" Text=" And " />
                                        <telerik:RadComboBoxItem Value="2" Text=" Or " />
                                    </Items>
                                </telerik:RadComboBox>                        
                            </div>                            
                        </div>
                    </div>                    
                    <asp:SqlDataSource runat="server" ID="sqlCriteria" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="SearchCriteria" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                        <SelectParameters>
                            <asp:ControlParameter Name="OutlineIDs" ControlID="rcbCourses" PropertyName="SelectedValue" Type="String" ConvertEmptyStringToNull="true" />
                            <asp:Parameter Name="CollegeID" DbType="Int32" />
                            <asp:ControlParameter Name="ShowAll" ControlID="rchkShowAll" PropertyName="Checked" Type="Boolean" />
                            <asp:ControlParameter Name="Source" ControlID="rcbSources" PropertyName="SelectedValue" Type="Int32" ConvertEmptyStringToNull="true" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                       <asp:SqlDataSource runat="server" ID="sqlConditions" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="select * from tblLookupConditions" CancelSelectOnNullParameter="false"></asp:SqlDataSource>                    
                    <br />
                    <asp:Label ID="lblCreditRecommendation" runat="server" CssClass="alert alert-warning" Text="Please select a Recommendation Criteria or Keyword" Visible="false" />
                </asp:Panel>
            </div>
            <div class="col-sm-2 d-flex align-items-center">
                <telerik:RadCheckBox ID="rchkShowAll" AutoPostBack="true" runat="server" Text=" Show All" ToolTip="Select to view any potential credit recommendations, regardless of their TOP Code association" Checked="true"></telerik:RadCheckBox>
                <telerik:RadCheckBox ID="rchkkAdvancedSearch" AutoPostBack="true" runat="server" Text=" Advanced Search" ToolTip="" OnCheckedChanged="rchkkAdvancedSearch_CheckedChanged" Checked="true" Visible="false"></telerik:RadCheckBox>
                <asp:SqlDataSource runat="server" ID="sqlSources" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="SELECT * FROM AceExhibitSource WHERE statusExhibitSource = 0 ORDER BY ShortDescription" SelectCommandType="Text" CancelSelectOnNullParameter="false">
                 </asp:SqlDataSource>
                <div style="margin-left:10px;">
                <telerik:RadComboBox ID="rcbSources" Label="Source :" DataSourceID="sqlSources" DataTextField="ShortDescription" DataValueField="Id" MaxHeight="200px" Width="150px" AppendDataBoundItems="true" EmptyMessage="Select" ToolTip="Select the source for the Credit Recommandations" runat="server" CssClass="ml-2" DropDownAutoWidth="Enabled" AutoPostBack="true" >
                <Items>
                    <telerik:RadComboBoxItem Text="" Value="" />
                </Items>
                </telerik:RadComboBox>
                </div>
            </div>
        </div>
                    <asp:Panel ID="divAdvancedSearch" runat="server">
        <div class="row p-2" style="margin-top:10px !important;">

                    <div class="col-sm-10">
                        <telerik:RadAutoCompleteBox ID="racbAdvancedSearch" runat="server" Width="100%" Filter="Contains" TextSettings-SelectionMode="Multiple" MinFilterLength="3" MaxResultCount="200" DropDownHeight="200" DataSourceID="sqlAdvancedSearch" DataTextField="FullCriteria" EmptyMessage="Search by Exhibit ID(s) or keyword(s)" DataValueField="CriteriaKey" ClientIDMode="Static" AllowCustomEntry="false" HighlightFirstMatch="true" Delimiter="," AutoPostBack="true" ToolTip="" CssClass="acbCriteria" BackColor="#ffffe0"></telerik:RadAutoCompleteBox>
                        <asp:SqlDataSource runat="server" ID="sqlAdvancedSearch" ConnectionString="<%$ ConnectionStrings:NORCOConnectionString %>" ProviderName="System.Data.SqlClient" SelectCommand="SearchCriteriaAdvanced" SelectCommandType="StoredProcedure">
                        </asp:SqlDataSource>
                        <asp:Label ID="lblAdvancedSearch" runat="server" CssClass="alert alert-warning" Text="Please Search by Exhibit ID or Keyword" Visible="false" />
                    </div>
                    <div class="col-sm-2">
                        <telerik:RadButton ID="RadButton2" runat="server" Text="Search" Width="80px" Primary="true" OnClick="rbCreate_Click" CausesValidation="false"></telerik:RadButton>
                        <telerik:RadButton ID="rbClear" runat="server" Text="Reset" Width="60px" OnClick="rbClear_Click" CausesValidation="false" AutoPostBack="true"></telerik:RadButton>
                    </div>
        </div>
                                    </asp:Panel>
    </div>
    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" runat="server">
        <Windows>
            <telerik:RadWindow RenderMode="Lightweight" ID="modalPopup" runat="server" Title="Search Articulations" Width="1100px" Height="720px" Modal="true" VisibleStatusbar="false" NavigateUrl="~/modules/popups/CreditRecommendations.aspx?SourceID=3">
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function toggle(sender, args) {
                var cont = document.getElementById('divAdvancedSearch');
                cont.style.display = cont.style.display == 'none' ? 'block' : 'none';
            }
            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow)
                    oWindow = window.radWindow;
                else if (window.frameElement && window.frameElement.radWindow)
                    oWindow = window.frameElement.radWindow;
                return oWindow;
            }
            function CloseModal() {
                setTimeout(function () {
                    GetRadWindow().close();
                }, 0);
            }
            function toggle(ele) {
                var cont = document.getElementById('divAdvancedSearch');
                cont.style.display = cont.style.display == 'none' ? 'block' : 'none';
            }

            function entryAdding(sender, eventArgs) {
                var autoComplete = $find("<%= racbCriteria.ClientID %>");
                var entries = autoComplete.get_entries();
                var element = document.getElementById("rcCondition");
                if (entries.get_count() > 1) {
                    element.style.display = "block";
                } else {

                    element.style.display = "none";
                }
                
            }
        </script>
    </telerik:RadCodeBlock>
</telerik:RadAjaxPanel>
