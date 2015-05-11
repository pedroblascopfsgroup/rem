<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

new Ext.Button({
        text:'<s:message code="plugin.mejoras.asuntos.adjuntarContratos" text="**Adjuntar contratos" />'
        ,iconCls:'icon_pendientes_tab'
        ,handler: function() {
        	var page = new fwk.Page("pfs", "", "", "");
        	var idAsunto=data.id;
        	var expediente=data.cabecera.expediente;
            page.webflow({
                flow:'listaprocedimientos/getTipoProcedimientosAsunto'
                ,params: {id:idAsunto}
                ,success: function(data, config) {
                    if(data.respuesta.respuesta=='OK') {
						Ext.Msg.alert('<s:message code="adjuntarContratos.titulo" text="**Adjuntar contratos" />','<s:message code="adjuntarContratos.mensaje" text="**Ya existe una actuación de tipo Contratos Adjuntos " />');
                    }else{
                    	    var w = app.openWindow({
								flow : 'plugin.mejoras.asuntos.listadoContratosParaAdjuntar'
								,width:950
								,title : '<s:message code="plugin.mejoras.asunto.generarContratosParaBloquear.title" text="**Selección de contratos para bloquear" />' 
								,params : {idAsunto:idAsunto,expediente:expediente}
							});
							w.on(app.event.DONE, function(){
								w.close();
							});
							w.on(app.event.CANCEL, function(){ w.close(); });
                    } 
                }
            });
        }
    })
    
