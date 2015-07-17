<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
new Ext.Button({
	text : '<s:message code="plugin.masivo.accesoNotificacionDemandados.title" text="**Acceso Notificacion Demandados" />'
	,iconCls : 'icon_busquedas'
			,handler : function(){
				app.openTab("Notificacion Demandados", 'procedimientos/consultaProcedimiento', {id:data.id, nombreTab:'notificacionDemandados'} , {id:'procedimiento'+id,iconCls:'icon_procedimiento'});
//				var w = app.openWindow({
//					text:'Notificación Demandados'
//					,flow: 'msvnotificaciondemandados/abreVentanaNotificacion'
//					,width:910
//					,title: 'Notificación Demandados'
//					,layout: 'form'
//					,closable: true
//					,params:{
//						idProcedimiento:data.id
//					}					
//				});
//				w.on(app.event.DONE, function(){
//					w.close();
//					//entidad.refrescar();
//				});
//				w.on(app.event.CANCEL, function(){ 
//					w.close(); 
//				});			
			}
})		

