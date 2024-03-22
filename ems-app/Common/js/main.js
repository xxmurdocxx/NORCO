$(function () {
    $('body').removeClass('nav-md').addClass('nav-sm');
    $('.left_col').removeClass('scroll-view').removeAttr('style');
    $('#sidebar-menu li').removeClass('active');
    $('#sidebar-menu li ul').hide();
});
function RowDblClickVeteran(sender, eventArgs) {
    var item = eventArgs.get_item();
    var cell = item.get_cell("Id");
    var value = $telerik.$(cell).text().trim();
    var oWindow = window.radopen("../popups/Veteran.aspx?VeteranId=" + value, null);
    oWindow.setSize(900, 600);
    oWindow.set_visibleStatusbar(false);
}
function RowDblClickNORCO(sender, eventArgs) {
    var item = eventArgs.get_item();
    var cell = item.get_cell("outline_id");
    var value = $telerik.$(cell).text().trim();
    var oWindow = window.radopen("../popups/ShowCourseDetail.aspx?outline_id=" + value, null);
    oWindow.setSize(900, 600);
    oWindow.set_visibleStatusbar(false);
}
function RowDblClickNORCOWithClose(sender, eventArgs) {
    var item = eventArgs.get_item();
    var cell = item.get_cell("outline_id");
    var value = $telerik.$(cell).text().trim();
    var oWindow = window.radopen("../popups/ShowCourseDetail.aspx?outline_id=" + value, null);
    oWindow.setSize(900, 600);
    oWindow.set_visibleStatusbar(false);
    oWindow.add_close(closeRadWindow);
}
function RowDblClickOccupation(sender, eventArgs) {
    var item = eventArgs.get_item();
    var cellAceId = item.get_cell("AceID");
    var valAceId = $telerik.$(cellAceId).text().trim();
    var cellTeamRevd = item.get_cell("TeamRevd");
    var valTeamRevd = $telerik.$(cellTeamRevd).text().trim();
    var cellOccupation = item.get_cell("Occupation");
    var valOccupation = $telerik.$(cellOccupation).text().trim();
    var cellTitle = item.get_cell("Title");
    var valTitle = $telerik.$(cellTitle).text().trim();
    var advanced_search = $('#hfAdvancedSarch').val();
    var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(advanced_search), null);
    oWindow.setSize(800, 600);
    oWindow.set_visibleStatusbar(false);
}

function RowDblClickACE(sender, eventArgs) {
    var item = eventArgs.get_item();
    var cellAceId = item.get_cell("AceID");
    var valAceId = $telerik.$(cellAceId).text().trim();
    var cellTeamRevd = item.get_cell("TeamRevd");
    var valTeamRevd = $telerik.$(cellTeamRevd).text().trim();
    var advanced = $find("rtbAttribute");
    var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + document.getElementById('selectedCourseTitle').value + "&AdvancedSearch=" + advanced.get_value(), null);
    oWindow.setSize(900, 600);
    oWindow.set_visibleStatusbar(false);
}

function RowDblClick(sender, eventArgs) {
    var item = eventArgs.get_item();
    var cellEntityType = item.get_cell("EntityType");
    var valEntityType = $telerik.$(cellEntityType).text().trim();
    var cellAceId = item.get_cell("AceID");
    var valAceId = $telerik.$(cellAceId).text().trim();
    var cellTeamRevd = item.get_cell("TeamRevd");
    var valTeamRevd = $telerik.$(cellTeamRevd).text().trim();
    if (item.get_cell("StartDate") != null) {
        var cellStartDate = item.get_cell("StartDate");
        var valStartDate = $telerik.$(cellStartDate).text().trim();
        var cellEndDate = item.get_cell("EndDate");
        var valEndDate = $telerik.$(cellEndDate).text().trim();
    } 
    var cellTitle = item.get_cell("Title");
    var valTitle = $telerik.$(cellTitle).text().trim();
    if (valEntityType == "1") { // 1 = ACE Course
        //var advanced = $find("rtbAttribute");
        var advanced = $('#hfACECourseAdvancedSearch').val();
        if (advanced != null) {
            if (cellStartDate == null) {
                var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(advanced), null);
            } else {
                var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(advanced) + "&StartDate=" + valStartDate + "&EndDate=" + valEndDate, null);
            }
            
        } else {
            if (cellStartDate == null) {
                var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle), null);
            } else {
                var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle) + "&StartDate=" + valStartDate + "&EndDate=" + valEndDate, null);
            }        
        }
    }
    if (valEntityType == "2") { // 2 = ACE Occupation
        var cellOccupation = item.get_cell("Occupation");
        var valOccupation = $telerik.$(cellOccupation).text().trim();
        var advanced_search = $('#hfAdvancedSarch').val();
        if (advanced != null) {
            if (cellStartDate == null) {
                var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle), null);
            } else {
                var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&StartDate=" + valStartDate + "&EndDate=" + valEndDate, null);
            }
        } else {
            if (cellStartDate == null) {
                var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(advanced_search), null);
            } else {
                var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(advanced_search) + "&StartDate=" + valStartDate + "&EndDate=" + valEndDate, null);
            }
        }
    }
    if (valEntityType == "3") { // 3 = College Course
        var cell = item.get_cell("outline_id");
        var value = $telerik.$(cell).text().trim();
        var oWindow = window.radopen("../popups/ShowCourseDetail.aspx?outline_id=" + value, null);
    }
    oWindow.setSize(900, 600);
    oWindow.center();
    oWindow.set_visibleStatusbar(false);
}

function showExhibit(valEntityType, valAceId, valTeamRevd, valCriteria, cellStartDate, valEndDate, valTitle) {
    if (valEntityType == "1") {
        if (valCriteria != "") {
            if (cellStartDate == null) {
                var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(valCriteria), null);
            } else {
                var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(valCriteria) + "&StartDate=" + cellStartDate + "&EndDate=" + valEndDate, null);
            }

        } else {
            if (cellStartDate == null) {
                var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle), null);
            } else {
                var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle) + "&StartDate=" + cellStartDate + "&EndDate=" + valEndDate, null);
            }
        }
    }
    if (valEntityType == "2") {
        var cellOccupation = "";
        var valOccupation = "";
        if (valCriteria != "") {
            if (cellStartDate == null) {
                var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(valCriteria), null);
            } else {
                var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(valCriteria) + "&StartDate=" + cellStartDate + "&EndDate=" + valEndDate, null);
            }
        } else {
            if (cellStartDate == null) {
                var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle), null);
            } else {
                var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&StartDate=" + cellStartDate + "&EndDate=" + valEndDate, null);
            }
        }
    }
    oWindow.setSize(700, 600);
    oWindow.center();
    oWindow.set_visibleStatusbar(false);
}

function showExhibitInfo(id, valCriteria) {
    if (valCriteria != "") {
            var oWindow = window.radopen("../popups/ShowExhibit.aspx?ID=" + id + "&AdvancedSearch=" + escape(valCriteria), null);
        } else {
            var oWindow = window.radopen("../popups/ShowExhibit.aspx?ID=" + id, null);
        }
    oWindow.setSize(700, 600);
    oWindow.center();
    oWindow.set_visibleStatusbar(false);
}


    function RowDblClickHighlightCriteria(sender, eventArgs) {
        var item = eventArgs.get_item();
        var cellEntityType = item.get_cell("EntityType");
        var valEntityType = $telerik.$(cellEntityType).text().trim();
        var cellAceId = item.get_cell("AceID");
        var valAceId = $telerik.$(cellAceId).text().trim();
        var cellTeamRevd = item.get_cell("TeamRevd");
        var valTeamRevd = $telerik.$(cellTeamRevd).text().trim();
        var cellCriteria = item.get_cell("SelectedCriteria");
        var valCriteria = $telerik.$(cellCriteria).text().trim();
        if (item.get_cell("StartDate") != null) {
            var cellStartDate = item.get_cell("StartDate");
            var valStartDate = $telerik.$(cellStartDate).text().trim();
            var cellEndDate = item.get_cell("EndDate");
            var valEndDate = $telerik.$(cellEndDate).text().trim();
        }
        var cellTitle = item.get_cell("Title");
        var valTitle = $telerik.$(cellTitle).text().trim();
        console.log(valCriteria);
        console.log(valEntityType);
        if (valEntityType == "1") {
            if (valCriteria != "") {
                if (cellStartDate == null) {
                    var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(valCriteria), null);
                } else {
                    var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(valCriteria) + "&StartDate=" + valStartDate + "&EndDate=" + valEndDate, null);
                }

            } else {
                if (cellStartDate == null) {
                    var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle), null);
                } else {
                    var oWindow = window.radopen("../popups/ShowACECourseDetail.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + escape(valTitle) + "&StartDate=" + valStartDate + "&EndDate=" + valEndDate, null);
                }
            }
        }
        if (valEntityType == "2") { // 2 = ACE Occupation
            var cellOccupation = item.get_cell("Occupation");
            var valOccupation = $telerik.$(cellOccupation).text().trim();
            if (valCriteria != "") {
                if (cellStartDate == null) {
                    var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(valCriteria), null);
                } else {
                    var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&AdvancedSearch=" + escape(valCriteria) + "&StartDate=" + valStartDate + "&EndDate=" + valEndDate, null);
                }
            } else {
                if (cellStartDate == null) {
                    var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle), null);
                } else {
                    var oWindow = window.radopen("../popups/ShowOccupation.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Occupation=" + valOccupation + "&Title=" + escape(valTitle) + "&StartDate=" + valStartDate + "&EndDate=" + valEndDate, null);
                }
            }
        }
        if (valEntityType == "3") { // 3 = College Course
            var cell = item.get_cell("outline_id");
            var value = $telerik.$(cell).text().trim();
            var oWindow = window.radopen("../popups/ShowCourseDetail.aspx?outline_id=" + value, null);
        }
        oWindow.setSize(900, 600);
        oWindow.center();
        oWindow.set_visibleStatusbar(false);
    }



function RowDblClickOccupations(sender, eventArgs) {
    var item = eventArgs.get_item();
    var cellAceId = item.get_cell("AceID");
    var valAceId = $telerik.$(cellAceId).text().trim();
    var cellTeamRevd = item.get_cell("TeamRevd");
    var valTeamRevd = $telerik.$(cellTeamRevd).text().trim();
    var cellTitle = item.get_cell("Title");
    var valTitle = $telerik.$(cellTitle).text().trim();
    var oWindow = window.radopen("../popups/ShowOccupations.aspx?AceID=" + valAceId + "&TeamRevd=" + valTeamRevd + "&Title=" + valTitle, null);
    oWindow.setSize(900, 400);
    oWindow.set_visibleStatusbar(false);
}
function ShowFeedback() {
    var oWindow = window.radopen("../../modules/popups/Feedback.aspx", null);
    oWindow.setSize(500, 500);
    oWindow.set_modal(true);
    oWindow.set_visibleStatusbar(false);
}
function ShowTESReport() {
    var oWindow = window.radopen("../../modules/popups/TESReport.aspx", null);
    oWindow.setSize(1100, 600);
    oWindow.set_modal(true);
    oWindow.set_visibleStatusbar(false);
}
function ShowImplementedArticulations() {
    var oWindow = window.radopen("../../modules/popups/ImplementedArticulations.aspx", null);
    oWindow.setSize(1100, 600);
    oWindow.set_modal(true);
    oWindow.set_visibleStatusbar(false);
}
function ShowCollegeMetrics() {
    var oWindow = window.radopen("../../modules/popups/CollegeMetrics.aspx", null);
    oWindow.setSize(1100, 600);
    oWindow.set_modal(true);
    oWindow.set_visibleStatusbar(false);
}

function ShowOnboarding() {
    var oWindow = window.radopen("../../modules/popups/Onboarding.aspx", null);
    oWindow.setSize(500, 500);
    oWindow.set_modal(true);
    oWindow.set_visibleStatusbar(false);
}

function ShowWelcome() {
    var oWindow = window.radopen("../../modules/popups/Welcome.aspx", null);
    oWindow.setSize(600, 600);
    oWindow.set_modal(true);
    oWindow.set_visibleStatusbar(false);
}

function ShowVeteranLetterReport(LeadId ) {
    var oWindow = window.radopen("../reports/VeteranLetter.aspx?TemplateType=1&LeadId=" + LeadId, null);
    oWindow.setSize(1000, 600);
    oWindow.center();
    oWindow.set_visibleStatusbar(false);
}

function ShowTemplate(LeadId,TemplateType,Email) {
    var oWindow = window.radopen("../popups/ShowTemplate.aspx?LeadId=" + LeadId + "&TemplateType=" + TemplateType + "&Email=" + Email, null);
    oWindow.setSize(1000, 600);
    oWindow.center();
    oWindow.set_visibleStatusbar(false);
}

function ShowArticulations(url,width, height) {
    var oWindow = window.radopen(url, null);
    oWindow.setSize(width, height);
    oWindow.center();
    oWindow.set_visibleStatusbar(false);
}

function OpenPopupWindow(url, width, height, maximized) {
    var oWindow = window.radopen(url, null);
    oWindow.setSize(width, height);
    oWindow.center();
    oWindow.set_visibleStatusbar(false);
    if (maximized) {
        oWindow.maximized();
    }
}

function EditVeteranLead(LeadId, VeteranID) {
    var oWindow = window.radopen("../popups/Lead.aspx?LeadId=" + LeadId + "&VeteranId=" + VeteranID, null);
    oWindow.setSize(1200, 720);
    oWindow.center();
    oWindow.set_visibleStatusbar(false);
}

function PrintVeteranLetter(LeadId, Email) {
    var oWindow = window.radopen("../popups/ShowTemplate.aspx?TemplateType=1&LeadId=" + LeadId + "&email=" + Email, null);
    oWindow.setSize(1200, 720);
    oWindow.center();
    oWindow.set_visibleStatusbar(false);
}

function CloseWindow() {
    if (confirm("Are you sure you want to close this window ?")) {
        close();
    }
}

function FilterMenuShowing(sender, eventArgs) {
    var column_name = eventArgs.get_column().get_uniqueName();
    if (column_name == "course_number" || column_name == "course_title" || column_name == "Occupation" || column_name == "Title" || column_name == "Course" || column_name == "AceID" || column_name == "Event" || column_name == "ExhibitDate" || column_name == "Exhibit" || column_name == "FullName" || column_name == "Email" || column_name == "Occupation" || column_name == "OccupationTitle" || column_name == "MobilePhone" || column_name == "HomePhone" || column_name == "ZipCode" || column_name == "DNC_FLG" || column_name == "WARN_FLG" || column_name == "TemplateLinkColumn" || column_name == "StudentID" || column_name == "CollegeAbbreviation" || column_name == "CourseCollege" || column_name == "CIDNumber" || column_name == "Descriptor" || column_name == "subject" || column_name == "TopCode" || column_name == "FirstName" || column_name == "LastName" || column_name == "MiddleName" || column_name == "UserName" || column_name == "Roles" || column_name == "Subjects" || column_name == "UniformCreditRecommendation" || column_name == "CriteriaDescription" || column_name == "Units" || column_name == "RecordCount" || column_name == "DoNotArticulate" ) {
        var menu = eventArgs.get_menu();
        var items = menu._itemData;

        var i = 0;

        while (i < items.length) {
            if (items[i].value != "NoFilter" && items[i].value != "Contains" && items[i].value != "DoesNotContain") {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "none";
            }
            i++;
        }
    }
    else {
        if (column_name == "PotentialStudent") {
            var menu = eventArgs.get_menu();
            var items = menu._itemData;

            var i = 0;

            while (i < items.length) {
                if (items[i].value != "NoFilter" && items[i].value != "EqualTo" && items[i].value != "NotEqualTo") {
                    var item = menu._findItemByValue(items[i].value);
                    if (item != null)
                        item._element.style.display = "none";
                }
                i++;
            }
        } else {

            var menu = eventArgs.get_menu();
            var items = menu._itemData;

            var i = 0;
            while (i < items.length) {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "";
                i++;
            }
        }
    }

} 
function FilteringMenu(sender, eventArgs) {
    var column = eventArgs.get_column();
    var column_name = eventArgs.get_column().get_uniqueName();
    if (column.get_dataType() == "System.String") {
        var i = 0;
        var menu = eventArgs.get_menu();
        var items = menu._itemData;        
        while (i < items.length) {
            if (items[i].value != "NoFilter" && items[i].value != "Contains" && items[i].value != "DoesNotContain") {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "none";
            } else {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "block";
            }
            i++;
        }
    }
    if (column.get_dataType() == "System.Decimal" || column.get_dataType() == "System.Int32") {
        var i = 0;
        var menu = eventArgs.get_menu();
        var items = menu._itemData;        
        while (i < items.length) {
            if (items[i].value != "NoFilter" && items[i].value != "EqualTo" && items[i].value != "NotEqualTo") {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "none";
            } else {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "block";
            }
            i++;
        }
    }
    if (column.get_dataType() == "System.DateTime") {
        var i = 0;
    var menu = eventArgs.get_menu();
    var items = menu._itemData;
        while (i < items.length) {
            if (items[i].value != "NoFilter" && items[i].value != "EqualTo" && items[i].value != "NotEqualTo") {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "none";
            } else {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "block";
            }
            i++;
        }
    }    
}

function HeaderFilteringMenu(sender, eventArgs) {
    var column = eventArgs.get_gridColumn();
    if (column.get_dataType() == "System.String") {
        var i = 0;
        var menu = eventArgs.get_menu();
        var items = menu._itemData;
        while (i < items.length) {
            if (items[i].value != "NoFilter" && items[i].value != "Contains" && items[i].value != "DoesNotContain") {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "none";
            } else {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "block";
            }
            i++;
        }
    }
    if (column.get_dataType() == "System.Decimal" || column.get_dataType() == "System.Int32") {
        var i = 0;
        var menu = eventArgs.get_menu();
        var items = menu._itemData;
        while (i < items.length) {
            if (items[i].value != "NoFilter" && items[i].value != "EqualTo" && items[i].value != "NotEqualTo") {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "none";
            } else {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "block";
            }
            i++;
        }
    }
    if (column.get_dataType() == "System.DateTime") {
        var i = 0;
        var menu = eventArgs.get_menu();
        var items = menu._itemData;
        while (i < items.length) {
            if (items[i].value != "NoFilter" && items[i].value != "EqualTo" && items[i].value != "NotEqualTo") {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "none";
            } else {
                var item = menu._findItemByValue(items[i].value);
                if (item != null)
                    item._element.style.display = "block";
            }
            i++;
        }
    }
}
/*

 */


function popUpShowing(sender, eventArgs) {
    var popUp;
    popUp = eventArgs.get_popUp();
    //var gridWidth = sender.get_element().offsetWidth;
    //var gridHeight = sender.get_element().offsetHeight;
    var viewportWidth = $(window).width();
    var viewportHeight = $(window).height();
    var popUpWidth = popUp.style.width.substr(0, popUp.style.width.indexOf("px"));
    var popUpHeight = popUp.style.height.substr(0, popUp.style.height.indexOf("px"));
    popUp.style.position = "fixed";
    popUp.style.left = Math.floor((viewportWidth - popUpWidth) / 2) + "px";
    popUp.style.top = Math.floor((viewportHeight - popUpHeight) / 2) + "px";
}

$(document).on('click', '.panel-heading span.clickable', function (e) {
    var $this = $(this);
    if (!$this.hasClass('panel-collapsed')) {
        $this.parents('.panel').find('.panel-body').slideUp();
        $this.addClass('panel-collapsed');
        $this.find('i').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
    } else {
        $this.parents('.panel').find('.panel-body').slideDown();
        $this.removeClass('panel-collapsed');
        $this.find('i').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
    }
})