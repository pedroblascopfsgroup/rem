<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


new Ext.Button({
      text    : 'Exportar informes',
      menu : {
      	items: [
<%--		OCULTAMOS LA FICHA GLOBAL DE FORMA TEMPORAL --%>
			
      		 {text:'<s:message code="plugin.mejoras.asuntos.btnExportarFichaGlobalConcurso" text="**Exportar ficha concurso" />'
			  ,id: 'btn-exportar-informes-asunto-fg-concurso'      		 
      		  ,iconCls:'icon_pdf'
      		  ,handler : function() {
					var flow = 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.exportarFichaGlobalConcurso';
					var params = {id:data.id};
					app.openBrowserWindow(flow,params);
			  }
			 }				
      		,
      		{text:'<s:message code="plugin.mejoras.asuntos.btnExportarFichaGlobalLitigio" text="**Ficha global litigio" />'
      		   ,id: 'btn-exportar-informes-asunto-fg-litigio'
      		  ,iconCls:'icon_pdf'
      		  ,handler : function() {
					var flow = 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.exportarFichaGlobalLitigio';
					var params = {id:data.id};
					app.openBrowserWindow(flow,params);
			  }
			 }				
      		
 
      		<sec:authorize ifAllGranted="EXPORTAR_FICHAGLOBAL">
      		, {text:'<s:message code="plugin.mejoras.asuntos.btnExportarFichaGlobal" text="**Exportar ficha global" />'
      		  ,iconCls:'icon_pdf'
      		  ,handler : function() {
					var flow = 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.exportarFichaGlobal';
					var params = {id:data.id};
					app.openBrowserWindow(flow,params);
			  }
			 }	
      		</sec:authorize>
      		<sec:authorize ifAllGranted="EXPORTAR_COMUNICACIONES">
      		, { 
      		text:'<s:message code="plugin.mejoras.asuntos.exportarComunicaciones" text="**Exportar comunicaciones" />'
        	,iconCls:'icon_pdf'
			,condition: ''
        	,handler: function() {
	         	var flow = 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.exportarComunicaciones';
				var params = {id:data.id};
				app.openBrowserWindow(flow,params);
			}}
      		</sec:authorize>
      		<sec:authorize ifAllGranted="EXPORTAR_HISTORICO">
      		, {text:'<s:message code="plugin.mejoras.asuntos.exportarHistorico" text="**Exportar hist�rico" />'
		        ,iconCls:'icon_pdf'
				,condition: ''
		        ,handler: function() {
		         	var flow = 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.exportarHistorico';
					var params = {id:data.id};
					app.openBrowserWindow(flow,params);
			}}</sec:authorize>
      		]}
     })