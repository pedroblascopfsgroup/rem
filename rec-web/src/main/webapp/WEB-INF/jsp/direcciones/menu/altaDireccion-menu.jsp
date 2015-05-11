<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="rec-web.direccion.menu" text="**Alta Direcciones" />' 
		,iconCls : 'icon_bienes'	
		,handler : function(){
			app.openTab("<s:message code="rec-web.direccion.menu" text="**Alta Direcciones"/>", 
			"direccion/altaDireccion",
			{},
			{id:'direccion-alta',iconCls : 'icon_bienes'});
		}
		
