<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

 new Ext.Button({
			text:'Finalizar asunto'
			//,iconCls : 'icon_comunicacion'
			,handler:function(){
				
				if(data.toolbar['esSupervisor'] == true){
						var w = app.openWindow({
							flow : 'plugin.mejoras.asuntos.finalizarAsunto'
							,title : 'Finalizar asunto'
							,width:650
							,params : {
											idAsunto : data.toolbar['asuntoId']
											
									}
						});
						w.on(app.event.DONE, function(){
							w.close();
							console.debug(Ext.getCmp("asunto-"+data.toolbar['asuntoId']));
							console.debug(Ext.getCmp("asunto-14571"));
							Ext.getCmp("asunto-14571").refrescar();
						});
								w.on(app.event.CANCEL, function(){w.close(); });
				}else{
					alert('Debe ser supervisor para finalizar el asunto');
				}
			}
				
			})