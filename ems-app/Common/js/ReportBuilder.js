(function (global, undefined) {
    var editor = undefined;
    var tree = undefined;

    var TelerikDemo = global.TelerikDemo = {};

    TelerikDemo.RadTreeView_OnClientLoad = function (sender, args) {
        tree = sender;
        makeUnselectable(tree.get_element());
    };

    TelerikDemo.RadEditor_OnClientLoad = function (sender, args) {
        editor = sender;
    };

    TelerikDemo.OnClientNodeDragStart = function () {
        setOverlayVisible(true);
    };

    TelerikDemo.OnClientNodeDropping = function (sender, args) {
        var event = args.get_domEvent();
        var result = isMouseOverEditor(editor, event);
        if (result) {
            var imageSrc = args.get_sourceNode().get_value();
            editor.setFocus();
            editor.pasteHtml(imageSrc);
        }
        setOverlayVisible(false);
    };

    TelerikDemo.OnClientNodeDragging = function (sender, args) {
        var event = args.get_domEvent();
        if (shimId && shimId._backgroundElement) {
            if (isMouseOverEditor(editor, event)) {
                shimId._backgroundElement.style.cursor = "alias";
            }
            else {
                shimId._backgroundElement.style.cursor = "no-drop";
            }
        }
    };

    /* ================== Utility methods needed for the Drag/Drop ===============================*/

    //Make all treeview nodes unselectable to prevent selection in editor being lost
    function makeUnselectable(element) {
        var nodes = element.getElementsByTagName("*");
        for (var index = 0; index < nodes.length; index++) {
            var elem = nodes[index];
            elem.setAttribute("unselectable", "on");
        }
    };

    //Create and display an overlay to prevent the editor content area from capturing mouse events
    var shimId = null;

    function setOverlayVisible(toShow) {
        if (!shimId) {
            var div = document.createElement("DIV");
            document.body.appendChild(div);
            shimId = new Telerik.Web.UI.ModalExtender(div);
        }

        if (toShow)
            shimId.show();
        else
            shimId.hide();
    };

    //Check if the image is over the editor or not
    function isMouseOverEditor(editor, event) {
        return $telerik.isMouseOverElementEx(editor.get_contentAreaElement(), event);
    };

    /* ================== These two methods are not related to the drag/drop functionality, but to the preview functionality =======*/

    function Scale(img, width, height) {
        var hRatio = img.height / height;
        var wRatio = img.width / width;

        if (img.width > width && img.height > height) {
            var ratio = (hRatio >= wRatio ? hRatio : wRatio);
            img.width = (img.width / ratio);
            img.height = (img.height / ratio);
        }
        else {
            if (img.width > width) {
                img.width = (img.width / wRatio);
                img.height = (img.height / wRatio);
            }
            else {
                if (img.height > height) {
                    img.width = (img.width / hRatio);
                    img.height = (img.height / hRatio);
                }
            }
        }
    };

})(window, undefined);