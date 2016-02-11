<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	{
        text:'<s:message code="plugin.procuradores.listadoResoluciones.ListadotareasPausadas" text="**Listado de Tareas Pausadas"/>'
        ,id :'arbol_tareas_nodo_resoluciones_pausadas'
        ,iconCls:'icon_pendientes'
        ,leaf:true
        ,listeners:{click: function() {
        							var node = tree.getNodeById('arbol_tareas_nodo_resoluciones_pausadas');
        							node.setText(node.getUI().getTextEl().innerHTML.replace(/<.?b>/g,""));
        							app.openTab('<s:message code="plugin.procuradores.listadoResoluciones.ListadotareasPausadas" text="**Listado de Tareas Pausadas"/>',
        							"procuradores/getPanelListadoTareasPendientes",{pausadas:true},{id:'tareas_resoluciones_panel'});
        							}
        }
        ,init:function(){
        		
        		 tree.getNodeById('arbol_tareas_nodo_resoluciones_pausadas').getUI().hide();
        		 var params = {idUsuario:app.usuarioLogado.id}; 
 		              page.webflow({ 
 		                      flow:"configuraciondespachoexterno/getConfiguracionDespachoExternoDelUsuario" 
 		                      ,params: params 
 		                      ,success: function(datos){
 		                      	if(datos.despachoIntegal && datos.pausados){
 		                      		tree.getNodeById('arbol_tareas_nodo_resoluciones_pausadas').getUI().show();
 		                      	}
 		                      }
 		              });
        
        		
                //this.recargaDatosCategorias();
                //this.cargaCategorias();
                //Comentado para evitar que se hagan llamadas periodicas a recovery
                //setInterval(this.recargaDatosResoluciones, ${appProperties.arbolTareasTiempoRecarga});
                
        }

	}


