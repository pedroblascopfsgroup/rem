<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	{
        text:'<s:message code="plugin.procuradores.arbol.tituloRecordatorios" text="**Recordatorios" />'
        ,id :'arbol_tareas_nodo_recordatorios'
        ,iconCls:'icon_pendientes'
        ,leaf:true
        ,listeners:{click: function() {
        							var node = tree.getNodeById('arbol_tareas_nodo_recordatorios');
        							node.setText(node.getUI().getTextEl().innerHTML.replace(/<.?b>/g,""));
        							app.openTab('<s:message code="plugin.procuradores.listadoRecordatorios.title" text="**Listado de recordatorios"/>',
        							"procuradores/getPanelListadoRecordatorios",{},{id:'tareas_recordatorios_panel'});
        							}
        }
        ,init: app.recargaRecordatoriosTree = function(){
        
                tree.getNodeById('arbol_tareas_nodo_recordatorios').getUI().hide();
        		var params = {idUsuario:app.usuarioLogado.id}; 
 		              page.webflow({ 
 		                      flow:"configuraciondespachoexterno/getConfiguracionDespachoExternoDelUsuario" 
 		                      ,params: params 
 		                      ,success: function(datos){
 		                      	if(datos.despachoIntegal){
 		                      			
 		                      			tree.getNodeById('arbol_tareas_nodo_recordatorios').getUI().show();
 		                      		   	
 		                      		   	Ext.Ajax.request({
											url: '/pfs/recrecordatorio/getCountListadoTareasRecordatorios.htm'
											,params: {idUsuario:app.usuarioLogado.id}
											,method: 'POST'
											,success: function (result, request){
												var r = Ext.util.JSON.decode(result.responseText);
												total = r.total;
												var textotal = '<s:message code="plugin.procuradores.arbol.tituloRecordatorios" text="**Recordatorios" /> (' + total + ')';
						                          		tree.getNodeById('arbol_tareas_nodo_recordatorios').setText(textotal); 
											}
										});
 		                      		
 		                      	}
 		                      }
 		              });
        
                
        }


	}


