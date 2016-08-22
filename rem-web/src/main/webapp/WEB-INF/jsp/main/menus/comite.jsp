<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="menu.comite" text="**Comité de Recuperaciones" />'
	,menu : [
	      { text : '<s:message code="menu.comite.celebracion" text="**Celebración de Comité" />'
			 	,iconCls:'icon_comite_celebrar'
			 	, handler : function(){
						app.openTab("<s:message code="comite.listado.titulo" text="**Listado Comites"/>", "comites/listadoComitesUsuario",{},{id:'listadoComitesUsuario', iconCls:'icon_comite_celebrar'});
				} 
			 }
		 ,{ 
				text : '<s:message code="menu.comite.actas" text="**Actas" />'
				,iconCls:'icon_comite_actas' 
				,handler : function(){
						app.openTab("<s:message code="actas.listado.titulo" text="**Listado Actas"/>", "comites/listadoActas",  {evento : "listadoCerradoJSON"},{id:'listadoActas', iconCls:'icon_comite_actas'});
				} 
			 }
	         ]