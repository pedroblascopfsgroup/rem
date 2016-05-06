<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	{
        text:'<s:message code="plugin.procuradores.arbol.titulo" text="**Tareas Pendientes Validar" />'
        ,id :'arbol_tareas_nodo_resoluciones'
        ,iconCls:'icon_pendientes'
        ,leaf:false
        ,listeners:{click: function() {
        							var node = tree.getNodeById('arbol_tareas_nodo_resoluciones');
        							node.setText(node.getUI().getTextEl().innerHTML.replace(/<.?b>/g,""));
        							app.openTab('<s:message code="plugin.procuradores.listadoResoluciones.title" text="**Listado de tareas pendientes de validar"/>',
        							"procuradores/getPanelListadoTareasPendientes",{},{id:'tareas_resoluciones_panel',iconCls:'icon_pendientes_validar'});
        							}
        }
        ,init: function(){
        		tree.getNodeById('arbol_tareas_nodo_resoluciones').getUI().hide();
        		app.recargaDatosCategorias();
                //this.recargaDatosCategorias();
                //this.cargaCategorias();
                //Comentado para evitar que se hagan llamadas periodicas a recovery
                //setInterval(this.recargaDatosResoluciones, ${appProperties.arbolTareasTiempoRecarga});
                
        }
        
        ,recargaResolucionesTree: app.recargaResolucionesTree = function(){
        		tree.getNodeById('arbol_tareas_nodo_resoluciones').getUI().hide();
        		tree.getNodeById('arbol_tareas_nodo_resoluciones').removeAll();
        		app.recargaDatosCategorias();
        }
        
        ,recargaDatosCategorias: app.recargaDatosCategorias = function(){
		              var params = {idUsuario:app.usuarioLogado.id};
		              page.webflow({
		                      flow:"categorias/getListaCategoriasByUsuario"
		                      ,params: params
		                      ,success: function(datos){
		                      		if(datos.despachoIntegral){
		                      			 if (datos.categorias.length > 0){
		                      			 	tree.getNodeById('arbol_tareas_nodo_resoluciones').expand(true);
		                      			 	var vista = datos.vistaCount;
		                      			 	for(i = 0; i < datos.categorias.length; i++){
												var categoria = datos.categorias[i];
												tree.getNodeById('arbol_tareas_nodo_resoluciones').appendChild([{text:categoria.nombre
																				,id :'arbol_tareas_nodo_resoluciones_categoria_' + i
															        			,iconCls:'icon_pendientes'
															        			,leaf:true
															        			,idCategoria: categoria.id
															        			,listeners:{click: function() {
														        							//var node = tree.getNodeById('arbol_tareas_nodo_resoluciones');
														        							//node.setText(node.getUI().getTextEl().innerHTML.replace(/<.?b>/g,""));
														        							app.openTab('<s:message code="plugin.procuradores.listadoResoluciones.title" text="**Listado de tareas pendientes de validar"/>',
														        							"procuradores/getPanelListadoTareasPendientes",{idCategoria:this.attributes.idCategoria,iconCls:'icon_pendientes_validar'},{id:'tareas_resoluciones_panel'});
														        							}
														        				}
												}]);
											};
											
											<%--Añadimos el nodo de tareas pausadas --%>
<%--											page.webflow({ --%>
<%--						                      flow:"configuraciondespachoexterno/getConfiguracionDespachoExterno" --%>
<%--						                      ,params: {idDespacho:datos.idDespacho} --%>
<%--						                      ,success: function(conf){ --%>
						                      
<%--						                      			if(conf.pausados){ --%>
<%--							                      			tree.getNodeById('arbol_tareas_nodo_resoluciones').appendChild([{ --%>
<%-- 																text:'<s:message code="plugin.procuradores.listadoResoluciones.tareasPausadas" text="**Tareas Pausadas"/>' --%>
<%--																,id :'arbol_tareas_nodo_resoluciones_pausadas' --%>
<%--											        			,iconCls:'icon_pendientes' --%>
<%--											        			,leaf:true --%>
<%--											        			,idCategoria: 10000 --%>
<%--											        			,listeners:{click: function() { --%>
<%--										        							//var node = tree.getNodeById('arbol_tareas_nodo_resoluciones'); --%>
<%--										        							//node.setText(node.getUI().getTextEl().innerHTML.replace(/<.?b>/g,"")); --%>
<%-- 										        							app.openTab('<s:message code="plugin.procuradores.listadoResoluciones.ListadotareasPausadas" text="**Listado de Tareas Pausadas"/>', --%>
<%--														        			"procuradores/getPanelListadoTareasPendientes",{pausadas:true},{id:'tareas_resoluciones_panel'}); --%>
<%--										        					} --%>
<%--										        				} --%>
<%--															}]); --%>
<%--						                      			} --%>

<%--												} --%>
<%--											}); --%>
											


		                      			 }
		                      			 	tree.getNodeById('arbol_tareas_nodo_resoluciones').collapse(true);
											tree.getNodeById('arbol_tareas_nodo_resoluciones').getUI().show();
		                      		}

<%--		                        Cargamos el número de resoluciones por categoría --%>
		                            var datosCategorias = datos.categorias;
		                            var vista = datos.vistaCount;
		                            var total = Number(0);

		                            for(i = 0; i < datosCategorias.length; i++){
		                            	var texto = tree.getNodeById('arbol_tareas_nodo_resoluciones_categoria_' + i).text;
		                            	var contador = Number(0);
										for(j = 0; j < vista.length; j++){
											if(datosCategorias[i].id == vista[j].id)
											{
												contador += Number(vista[j].count);
												total += contador;
											}
										}
										texto += ' (' + contador + ')';
										tree.getNodeById('arbol_tareas_nodo_resoluciones_categoria_' + i).setText(texto);
									}


			                        Ext.Ajax.request({
										url: '/pfs/procuradores/getCountListadoTareasPendientes.htm'
										,params: {idUsuario:app.usuarioLogado.id}
										,method: 'POST'
										,success: function (result, request){
											var r = Ext.util.JSON.decode(result.responseText);
											total = r.total;
											var textotal = '<s:message code="plugin.procuradores.arbol.titulo" text="**Tareas Pendientes Validar" /> (' + total + ')';
 		                            		tree.getNodeById('arbol_tareas_nodo_resoluciones').setText(textotal); 
										}
									});

									
		                            
<%-- 		                      		  debugger;
		                              var tareas = datos.total;
		                              if (old_previsiones != tareas){
		                              		  var texto = '<b><s:message code="plugin.procuradores.arbol.titulo" text="**Tareas Pendientes Validar" /> (' + tareas;
		                              		  texto = texto + ')</b>';
		                                      tree.getNodeById('arbol_tareas_nodo_resoluciones').setText(texto);
		                                      old_previsiones = tareas; 
		                              }--%>
		                      }
		              });
		}
        ,cargaCategorias:function(){
    			tree.getNodeById('arbol_tareas_nodo_resoluciones').expand(true);
				tree.getNodeById('arbol_tareas_nodo_resoluciones').appendChild([{text:'Categor&iacute;a 1'
																				,id :'arbol_tareas_nodo_resoluciones_categoria_1'
															        			,iconCls:'icon_pendientes'
															        			,leaf:true
															        			}
															        			,{text:'Categor&iacute;a 2'
																				,id :'arbol_tareas_nodo_resoluciones_categoria_2'
															        			,iconCls:'icon_pendientes'
															        			,leaf:true
															        			}]);
				tree.getNodeById('arbol_tareas_nodo_resoluciones').collapse(true);
				//tree.getNodeById('arbol_tareas_nodo_resoluciones').remove();
				tree.getNodeById('arbol_tareas_nodo_resoluciones').getUI().show();
		}		
		,children:[]

	}


