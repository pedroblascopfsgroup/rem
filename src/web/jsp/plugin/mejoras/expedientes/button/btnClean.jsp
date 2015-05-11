<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
new Ext.Button({
        text:'<s:message code="app.botones.limpiar" text="**limpiar" />'
        ,iconCls:'icon_limpiar'
        ,handler: function() {
            for (var tab=0; tab < filtroTabPanel.items.length; tab++) {
                filtroTabPanel.items.get(tab).fireEvent('limpiar');
            }
        }
    })