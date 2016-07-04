<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

new Ext.form.Checkbox({
        id:'chkbxMiCartera'
        ,boxLabel:'<s:message code="menu.clientes.listado.filtro.micartera" text="**Mi Cartera" />'
        ,labelStyle:'font-weight:bolder'
        ,style:'margin-top:2px;margin-left:2px'
        }
    )	