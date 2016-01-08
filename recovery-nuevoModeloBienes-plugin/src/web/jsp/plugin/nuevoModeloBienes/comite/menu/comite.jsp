<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="menu.comite" text="**Comit� de Recuperaciones" />'
	,menu : [
		<sec:authorize ifAllGranted="ROLE_COMITE_MENU">
	      { text : '<s:message code="menu.comite.celebracion" text="**Celebraci�n de Comit�" />'
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
			 	<sec:authorize ifAllGranted="MSV-INST-SUBASTA">
			 ,
			 	</sec:authorize>
			 </sec:authorize>
			<sec:authorize ifAllGranted="MSV-INST-SUBASTA">		
			{
				text : '<s:message code="subastas.instruccionesLoteSubasta.menu.gestMasivaInstrucciones.tituloMenu" text="**Propuesta de Instrucciones" />' 
				,iconCls : 'icon_subasta'	
				,handler : function(){
					app.openTab("<s:message code="subastas.instruccionesLoteSubasta.menu.gestMasivaInstrucciones.titulo" text="**Propuesta de Instrucciones"/>", 
						"plugin/nuevoModeloBienes/subastas/busquedas/NMBgestionPropuestaInstruccionesSubasta"
						,{}
						,{id:'plugin_gestPropuestaInstrucciones_listado',iconCls:'icon_subasta'}
					);
				}
			}
			</sec:authorize>
	        ]