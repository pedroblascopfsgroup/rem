<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>


new Ext.Button({
	id:'prc-btnAccionesPrecontencioso-padre',
	text: '<s:message code="plugin.precontencioso.button.acciones.titulo" text="**Acciones" />',
	menu: {
		items: [{
			text: '<s:message code="plugin.precontencioso.button.finalizarPreparacion" text="**Finalizar preparaci�n" />',
			icon:'/pfs/css/book_next.png',
			handler: function() {

				var mensajeFinalizacionCorrecto = function() {
					Ext.Msg.show({
						title: fwk.constant.alert,
						msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.correcto"
				 				text="**Se ha finalizado el expediente judicial" />',
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.WARNING});
				}
				
				var mensajeFinalizacionError = function(mensaje) {
					Ext.Msg.show({
						title: fwk.constant.alert,
						msg: mensaje,
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.WARNING});
				}
				
				var finalizarPreparacion = function() {
					Ext.Ajax.request({
						url: page.resolveUrl('expedientejudicial/finalizarPreparacion'),
						params: {idProcedimiento: data.id},
						method: 'POST',
						success: function (result, request){
							var resultado = Ext.decode(result.responseText);
							if(resultado.finalizado == true) {
								mensajeFinalizacionCorrecto();
							}else{
								mensajeFinalizacionError('<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.exception" text="**Se ha producido un error. Consulte con soporte" />');
							}
						}
						,error: function(){
							mensajeFinalizacionError('<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.exception" text="**Se ha producido un error. Consulte con soporte" />');
					    }
					});	
				}

				var estado = data.estadoPrecontencioso;
				var estadoPreparacion = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO.PREPARACION" />';
				var estadoSubsanar = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO.SUBSANAR" />';
				var estadoSubsanarCambio = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO.SUBSANAR_POR_CAMBIO" />';
				var result;
				if(estado == estadoPreparacion || estado == estadoSubsanar || estado == estadoSubsanarCambio) {
					result = false;
				}else{
					result = true;
				}
				if(result) {
					mensajeFinalizacionError('<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.tipo"
	             				text="**Podr�n ser finalizados aquellos expedientes que se encuentren en estado Preparaci�n, Subsanar o Subsanar por cambio de procedimiento." />');
				}else{
					var page = new fwk.Page("pfs", "", "", "");
					Ext.Ajax.request({
						url: page.resolveUrl('expedientejudicial/comprobarFinalizacionPosible'),
						params: {idProcedimiento: data.id},
						method: 'POST',
						success: function (result, request){
							var resultado = Ext.decode(result.responseText);
							if(resultado.finalizado == true){
								finalizarPreparacion();
							} else {
								Ext.Msg.confirm(
								'<s:message code="app.confirmar" text="**Confirmar" />', 
								'<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.faltanDocumentos"
 									text="**Alguno de los documentos no ha sido marcado como Disponible o no ha sido Adjuntado. ¿Desea continuar con la Finalización de la Preparación?" />', 
									function(btn) {
										if (btn == 'yes') {
											finalizarPreparacion();
										}
									}
								);
							}
						}
						,error: function(){
							mensajeFinalizacionError('<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.exception" text="**Se ha producido un error. Consulte con soporte" />');
						} 
					});
				}
			}
		},{
			text: '<s:message code="plugin.precontencioso.button.devolverPreparacion" text="**Devolver a preparacion" />',
			handler: function() {
	
				var estadoPreparado = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO.PREPARADO" />';

				if(data.estadoPrecontencioso != estadoPreparado) {
					Ext.Msg.show({
						title: fwk.constant.alert,
						msg: '<s:message code="plugin.precontencioso.button.devolverPreparacion.error.estado"
	             				text="**Podr�n ser devueltos a preparaci�n aquellos expedientes que se encuentren en estado preparado." />',			             
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.WARNING
					});
					return;
				}
				var page = new fwk.Page("pfs", "", "", "");
				Ext.Ajax.request({
					url: page.resolveUrl('expedientejudicial/devolverPreparacion'),
					params: {idProcedimiento: data.id},
					method: 'POST',
					success: function (result, request) {
						Ext.Msg.show({
							title: fwk.constant.alert,
							msg: '<s:message code="plugin.precontencioso.button.devolverPreparacion.correcto"
		             				text="**El expediente judicial se ha devuelto a preparacion correctamente" />',
							buttons: Ext.Msg.OK
						});
					},
					error: function(){
						Ext.MessageBox.show({
				            title: fwk.constant.alert,
				            msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.exception" text="**Se ha producido un error. Consulte con soporte" />',
				            width: 300,
				            buttons: Ext.MessageBox.OK
				        });
					} 
				});
			}
		}]
	}
})