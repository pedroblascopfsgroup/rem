<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

	
new Ext.Button({
	id:'prc-btnAccionesPrecontencioso-padre',
	text: '<s:message code="plugin.precontencioso.button.titulo" text="**Acciones" />',
	menu: {
		items: [{
			text: '<s:message code="plugin.precontencioso.button.finalizarPreparacion" text="**Finalizar preparación" />',
			handler: function() {
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
					Ext.Msg.show({
						title: fwk.constant.alert,
						msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.tipo"
	             				text="**Podrán ser finalizados aquellos expedientes que se encuentren en estado Preparación, Subsanar o Subsanar por cambio de procedimiento." />',			             
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.WARNING});
				}else{
					var page = new fwk.Page("pfs", "", "", "");
					Ext.Ajax.request({
						url: page.resolveUrl('expedientejudicial/finalizarPreparacion'),
						params: {idProcedimiento: data.id},
						method: 'POST',
	<!-- 					success: function ( result, request ) { } -->
						success: function (result, request){
							var resultado = Ext.decode(result.responseText);
							if(resultado.finalizado == true){
								Ext.Msg.show({
									title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.correcto"
				             				text="**Se ha finalizado el expediente judicial" />',
									buttons: Ext.Msg.OK,
									icon:Ext.MessageBox.WARNING});
							}else{
								Ext.Msg.show({
									title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.faltanDocumentos"
				             				text="**No es posible finalizar la preparación del expediente judicial hasta que todos los documentos disponibles estén adjuntos" />',			             
									buttons: Ext.Msg.OK,
									icon:Ext.MessageBox.WARNING});
							}
						}
						,error: function(){
							Ext.MessageBox.show({
					            title: 'Guardado',
					            msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.exception" text="**Se ha producido un error. Consulte con soporte" />',
					            width:300,
					            buttons: Ext.MessageBox.OK
					        });
						} 
					});
				}
			}
		}]
	}
})