
(Ext.isIE ? document: window).onkeydown = function(event) {
    var e = Ext.isIE ? window.event: event;
    var t = Ext.isIE ? e.srcElement: e.target;
    if (e.keyCode === 8 && ((!/^input$/i.test(t.tagName) && !/^textarea$/i.test(t.tagName)) || t.disabled || t.readOnly)) {
        return false;
    }
};