﻿<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
	
 	var labelStyle = 'width:150px;font-weight:bolder;margin-bottom:5px",width:375';

 	function label(id,text){
    	return app.creaLabel(text,"",  {id:'entidad-contrato-'+id, labelStyle:labelStyle});
	}
  	
	// DATOS PRINCIPALES
 	var contratoNivel2 = label('contratoNivel2','<s:message code="contrato.consulta.tabOtrosDatos.contratoNivel2" text="**Identificador del contrato del que cuelga el contrato paraguas"/>');
 	var odCharExtra7 = label('odCharExtra7','<s:message code="contrato.consulta.tabOtrosDatos.charExtra7" text="**Marca de Empresa Externa de Recobro"/>');
 	var odCharExtra9 = label('odCharExtra9','<s:message code="contrato.consulta.tabOtrosDatos.charExtra9" text="**Estado expediente GESDACI"/>');
 	var odCharExtra10 = label('odCharExtra10','<s:message code="contrato.consulta.tabOtrosDatos.charExtra10" text="**Estado del Contrato Cajamar"/>');
 	var odFlagExtra4 = label('odFlagExtra4','<s:message code="contrato.consulta.tabOtrosDatos.flagExtra4" text="**Operación Reestructurada"/>');
 	var odFlagExtra5 = label('odFlagExtra5','<s:message code="contrato.consulta.tabOtrosDatos.flagExtra5" text="**Licencia Primera Ocupaci&oacute;n"/>');
 	var odFlagExtra7 = label('odFlagExtra7','<s:message code="contrato.consulta.tabOtrosDatos.flagExtra6" text="**Certificado fin obra"/>');
 	var odDateExtra2 = label('odDateExtra2','<s:message code="contrato.consulta.tabOtrosDatos.dateExtra2" text="**Fecha de Entrada Actual en Gestión especial"/>');
 	var odDateExtra3 = label('odDateExtra3','<s:message code="contrato.consulta.tabOtrosDatos.dateExtra3" text="**Fecha Próxima Amortización"/>');
 	var odDateExtra9 = label('odDateExtra9','<s:message code="contrato.consulta.tabOtrosDatos.dateExtra9" text="**Fecha Próxima Revisión"/>');
 	var odDateExtra4 = label('odDateExtra4','<s:message code="contrato.consulta.tabOtrosDatos.dateExtra4" text="**Fecha Fin de la Carencia"/>');
 	var odDateExtra5 = label('odDateExtra5','<s:message code="contrato.consulta.tabOtrosDatos.dateExtra5" text="**Fecha Test de Cumplimiento"/>');
 	var odDateExtra6 = label('odDateExtra6','<s:message code="contrato.consulta.tabOtrosDatos.dateExtra6" text="**Fecha de dotaci&oacute;n de la provisi&oacute;n"/>');
 	var odDateExtra7 = label('odDateExtra7','<s:message code="contrato.consulta.tabOtrosDatos.dateExtra7" text="**Fecha orden"/>');
 	var odNumExtra4 = label('odNumExtra4','<s:message code="contrato.consulta.tabOtrosDatos.numExtra4" text="**Número de Expediente GESDACI"/>');
 	var odNumExtra5 = label('odNumExtra5','<s:message code="contrato.consulta.tabOtrosDatos.numExtra5" text="**Importe Retenciones"/>');
 	var odNumExtra6 = label('odNumExtra6','<s:message code="contrato.consulta.tabOtrosDatos.numExtra6" text="**C&oacute;digo orden"/>');
 	var odNumExtra7 = label('odNumExtra7','<s:message code="contrato.consulta.tabOtrosDatos.numExtra7" text="**Porcentaje Grado de Ejecuci&oacute;n de Obra"/>');
 	var odNumExtra8 = label('odNumExtra8','<s:message code="contrato.consulta.tabOtrosDatos.numExtra8" text="**Porcentaje Ventas Promoci&oacute;n"/>');
 	
 	//otros
 	var riesgoOperacional = label('riesgoOperacional','<s:message code="contrato.consulta.tabOtrosDatos.riesgoOperacional" text="**Riesgo Operacional"/>');
 	var tipoVencido = label('tipoVencido','<s:message code="contrato.consulta.tabOtrosDatos.tipoVencido" text="**Tipo Vencido"/>');
 	var tramoPrevio = label('tramoPrevio','<s:message code="contrato.consulta.tabOtrosDatos.tramoPrevio" text="**Tramo Previo"/>');
 	
  	contratoNivel2.autoHeight = true;
  	odCharExtra7.autoHeight = true;
 	odCharExtra9.autoHeight = true;
 	odCharExtra10.autoHeight = true;
 	odFlagExtra4.autoHeight = true;
 	odDateExtra2.autoHeight = true;
 	odDateExtra3.autoHeight = true;
 	odDateExtra4.autoHeight = true;
 	odDateExtra5.autoHeight = true;
 	odDateExtra9.autoHeight = true;
 	odNumExtra4.autoHeight = true;
 	odNumExtra5.autoHeight = true;
 	odNumExtra6.autoHeight = true;
 	odNumExtra7.autoHeight = true;
 	odNumExtra8.autoHeight = true;
 	odDateExtra6.autoHeight = true;
 	odDateExtra7.autoHeight = true;
 	odFlagExtra5.autoHeight = true;
 	odFlagExtra7.autoHeight = true;
 	
 	riesgoOperacional.autoHeight = true;
 	tipoVencido.autoHeight = true;
 	tramoPrevio.autoHeight = true;
 	
 	
 	var getParametros = function(){
 	 	return entidad.get("data").id;
 	};
 	
 	var mostrarBtnRiesgoOp;
    var btnModificarRiesgoOperacional = new Ext.Button({
 		text: '<s:message code = "contrato.consulta.tabOtrosDatos.modifRiesgoOper" text="**Modificar riesgo operacional"/>'
 		,iconCls: 'icon_edit'
 		,width: 75
 		,handler: function (){
 			var w = app.openWindow({
 				flow: 'riesgooperacional/obtenerRiesgoOperacionalContrato'
 				,closable: true
 				,width:400
 				,y: 250
 				,x:400
 				,params : {cntId:getParametros()}
 				,title : '<s:message code="contrato.consulta.tabOtrosDatos.popUpTitle" text="**Editar riesgo operacional"/>'
 			})
 			w.on(app.event.DONE, function(){
 				w.close();
 				entidad.refrescar();
 			});
 			
 			w.on(app.event.CANCEL, function(){
 				w.close()
 			});
 		}
 	});
   
	var otrosDatosFieldSet = new Ext.form.FieldSet({
		autoHeight:true
		,width:800
		,style:'padding:0px'
		,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{columns:2}
		,title:''
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:400, style:'padding:10px; margin:10px'}
		,items : [{items:[contratoNivel2, odCharExtra9, odFlagExtra4, odDateExtra3, odDateExtra4,odDateExtra6, odNumExtra4, odNumExtra6, odNumExtra8, riesgoOperacional,tipoVencido]}
				, {items:[odCharExtra7, odCharExtra10, odFlagExtra5, odFlagExtra7, odDateExtra2, odDateExtra9, odDateExtra5, odDateExtra7, odNumExtra5, odNumExtra7, tramoPrevio]}]
	});
	  
	//Panel propiamente dicho...
	var panel=new Ext.Panel({
		title : '<s:message code="contrato.consulta.tabOtrosDatos.titulo" text="**Otros datos"/>'
		,layout:'table'
		,border : false
		,layoutConfig: { columns: 1 }
		,autoScroll : true
		,bodyStyle : 'padding:5px;margin:5px'
		,autoHeight : true
		,autoWidth : true
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,items:[otrosDatosFieldSet <sec:authorize ifAllGranted="MODIFICAR_RIESGO_OPERACIONAL">,btnModificarRiesgoOperacional</sec:authorize>]
		,nombreTab : 'otrosDatos'
	});
	
	panel.getValue = function() {
	}
	
	panel.setValue = function() {
  		var data=entidad.get("data");
  		var d=data.otrosDatos;
  
  		
  		entidad.setLabel('contratoNivel2', d.contratoPadreNivel2);  
  		entidad.setLabel('odCharExtra7', d.charextra7);
  		entidad.setLabel('odCharExtra9', d.charextra9);
  		entidad.setLabel('odCharExtra10', d.charextra10);
  		if(d.flagextra4 != null && d.flagextra4 != ''){
  			if(d.flagextra4 != 0){
  				entidad.setLabel('odFlagExtra4', 'SI');
  			}else{
  				entidad.setLabel('odFlagExtra4', 'NO');
  			}
  		}else{
  			entidad.setLabel('odFlagExtra4', d.flagextra4);
  		}
  		if(d.flagextra5 != null && d.flagextra5 != ''){
  			if(d.flagextra5 != 0){
  				entidad.setLabel('odFlagExtra5', 'SI');
  			}else{
  				entidad.setLabel('odFlagExtra5', 'NO Promotores');
  			}
  		}else{
  			entidad.setLabel('odFlagExtra5', d.flagextra5);
  		}
  		if(d.flagextra7 != null && d.flagextra7 != ''){
  			if(d.flagextra7 != 'N'){
  				entidad.setLabel('odFlagExtra7', 'SI');
  			}else{
  				entidad.setLabel('odFlagExtra7', 'NO Promotores');
  			}
  		}else{
  			entidad.setLabel('odFlagExtra7', d.flagextra7);
  		}
		
		if(d.numextra5 != null && d.numextra5 != ''){
			entidad.setLabel('odNumExtra5', d.numextra5 + ' ' + app.EURO);			
		}else{
			entidad.setLabel('odNumExtra5', d.numextra5);	
		}
	
  		entidad.setLabel('odDateExtra2', d.dateextra2);
  		entidad.setLabel('odDateExtra3', d.dateextra3);
  		entidad.setLabel('odDateExtra9', d.dateextra9);
  		entidad.setLabel('odDateExtra4', d.dateextra4);
  		entidad.setLabel('odDateExtra5', d.dateextra5);
  		entidad.setLabel('odDateExtra6', d.dateextra6);
  		entidad.setLabel('odDateExtra7', d.dateextra7);
  		entidad.setLabel('odNumExtra4', d.numextra4);
  		entidad.setLabel('odNumExtra6', d.numextra6);
  		entidad.setLabel('odNumExtra7', d.numextra7);
  		entidad.setLabel('odNumExtra8', d.numextra8);
  		
  		entidad.setLabel('riesgoOperacional', d.descripcionRiesgo);
  		entidad.setLabel('tipoVencido', d.tipoVencido);
  		entidad.setLabel('tramoPrevio', d.tramoPrevio);
  		
  		
  		btnModificarRiesgoOperacional.setVisible(d.isTipoExpedienteCorrecto || d.isTipoAsuntoCorrecto);
  		
 	}
 	
  	return panel;
})
