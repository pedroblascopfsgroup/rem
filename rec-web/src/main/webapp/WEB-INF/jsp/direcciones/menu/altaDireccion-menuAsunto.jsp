<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
new Ext.Button({
	text: '<s:message code="rec-web.direccion.menu" text="**Alta Direcciones" />' 
		,iconCls : 'icon_bienes'	
		,handler : function(){
			var idAsunto = null;
	        if (typeof data === 'undefined'){
	         	idAsunto = '';
	        }else{
	        	idAsunto = data.id;
	        }
	        
        	app.openTab("<s:message code="rec-web.direccion.menu" text="**Alta Direcciones"/>", 
			"direccion/altaDireccion",
			{idAsunto: idAsunto},
			{id:'direccion-alta',iconCls : 'icon_bienes'});
		}
	})
		
