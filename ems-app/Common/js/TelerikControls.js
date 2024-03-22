//JS implementations for Telerik Controls

//ACGL:Hide the content's area tooltip of radeditor
function editorLoad(editor) {
    var contentAreaEl = editor.get_contentAreaElement();
    contentAreaEl.removeAttribute("title");
}