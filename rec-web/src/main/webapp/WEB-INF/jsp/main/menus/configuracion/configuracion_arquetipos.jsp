<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text:'<s:message code="" text="Editor de paquetes de reglas" />'
<%-- text:'<s:message code="" text="Arquetipos" />'--%>
,iconCls:'icon_arquetipos'
,handler: function(){ 
	window.open("/pfs/editor/editor2.htm");
}

