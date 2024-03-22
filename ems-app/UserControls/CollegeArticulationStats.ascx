<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CollegeArticulationStats.ascx.cs" Inherits="ems_app.UserControls.CollegeArticulationStats" %>
<style>
    * {box-sizing: border-box}

/* Style the tab */
.tab {
  float: left;
  background-color: #f1f1f1;
  width: 30%;
  height: auto;
}

/* Style the buttons that are used to open the tab content */
.tab button {
  display: block;
  background-color: inherit;
  color: black;
  padding: 15px 12px;
  width: 100%;
  border: none;
  outline: none;
  text-align: left;
  cursor: pointer;
  transition: 0.3s;
}

/* Change background color of buttons on hover */
.tab button:hover {
  background-color: #ddd;
}

/* Create an active/current "tab button" class */
.tab button.active {
  background-color: #203864;
  color:#fff;
}

/* Style the tab content */
.tabcontent {
  float: left;
  padding: 12px 12px;
  /*border: 1px solid #ccc;*/
  width: 30%;
  border-left: none;
  height: 195px;
  background-color: #203864;
  color: #fff;
}
.tabcontent a {
    color:#fff;
}
.tabcontent table td{
    padding:7px;
}
</style>
<div class="tab" id="stageTabs" runat="server">
</div>
<script>
    function openStage(evt, stageName) {
        // Declare all variables
        var i, tabcontent, tablinks;

        // Get all elements with class="tabcontent" and hide them
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }

        // Get all elements with class="tablinks" and remove the class "active"
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
            tablinks[i].addEventListener("click", function (event) {
                event.preventDefault()
            });
        }

        // Show the current tab, and add an "active" class to the link that opened the tab
        document.getElementById(stageName).style.display = "block";
        evt.currentTarget.className += " active";
    }
</script>