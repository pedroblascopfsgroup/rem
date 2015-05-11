<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:150';
	var labelStyle2='font-weight:bolder;width:50';
	var codigoTipoEntidad = new Ext.form.Hidden({name:'codigoTipoEntidad', value :'${codigoTipoEntidad}'}) ;
	var idEntidad = new Ext.form.Hidden({name:'idEntidad', value :'${idEntidad}'}) ;

	var tienePerfilGestor = ${tienePerfilGestor};
	var esGestorCex = ${esGestorCex}; 
	var tienePerfilSupervisor = ${tienePerfilSupervisor};
	var esSupervisorCex = ${esSupervisorCex}; 
	var subtipoTarea = new Ext.form.Hidden({name:'subtipoTarea'});
	if(tienePerfilGestor) {
		if(codigoTipoEntidad.getValue() == '2' || codigoTipoEntidad.getValue() == '1'){
			subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR_EXPTE);
		}
		else{
			if(codigoTipoEntidad.getValue() == '5' && esGestorCex){
				subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_GESTOR_CONFECCION_EXPTE);
			}else
				subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR);
		}
	} else if(tienePerfilSupervisor) {
		if(codigoTipoEntidad.getValue() == '2' || codigoTipoEntidad.getValue() == '1'){
			subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR_EXPTE);
		}
		else{
			if(codigoTipoEntidad.getValue() == '5' && esSupervisorCex){
				subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE);
			}else
				subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR);
		}
	}

	var titulodescripcion = new Ext.form.Label({
   	text:'<s:message code="generartarea.descripcion" text="**Introduzca el texto de la comunicacion" />'
	,style:'font-weight:bolder; font-size:11'
	}); 
	
	//Text Area
	var descripcion = new Ext.form.TextArea({
		width:600
		,hideLabel: true
		,height:200
		,maxLength:3500
		,name : 'descripcion'
		<app:test id="campoParaComunicacion" addComa="true"/>
	});

	var reqRes = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="generartarea.reqresp" text="**¿Requiere Respuesta?" />'
		,labelStyle:labelStyle
		,name:'reqRes'
		,handler:function(){
			if(tienePerfilGestor) {
				if(fecha.disabled == true){
					fecha.enable();
					
					if(codigoTipoEntidad.getValue() == '2' || codigoTipoEntidad.getValue() == '1'){
						subtipoTarea.setValue(app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR_EXPTE);
					}
					else{
						if(codigoTipoEntidad.getValue() == '5' && esGestorCex){
							subtipoTarea.setValue(app.subtipoTarea.CODIGO_TAREA_COMUNICACION_GESTOR_CONFECCION_EXPTE);
						}else
							subtipoTarea.setValue(app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR);
					}		
				}else{
					fecha.disable();
					if(codigoTipoEntidad.getValue() == '2' || codigoTipoEntidad.getValue() == '1'){
						subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR_EXPTE);
					}
					else{
						if(codigoTipoEntidad.getValue() == '5' && esGestorCex){
							subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_GESTOR_CONFECCION_EXPTE);
						}else
							subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR);
					}
				}
			} else if(tienePerfilSupervisor) {
				if(fecha.disabled == true){
					fecha.enable();
					if(codigoTipoEntidad.getValue() == '2' || codigoTipoEntidad.getValue() == '1'){
						subtipoTarea.setValue(app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR_EXPTE);
					}
					else{
						if(codigoTipoEntidad.getValue() == '5' && esSupervisorCex){
							subtipoTarea.setValue(app.subtipoTarea.CODIGO_TAREA_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE);
						}else
							subtipoTarea.setValue(app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR);
					}
				}else{
					fecha.disable();
					if(codigoTipoEntidad.getValue() == '2' || codigoTipoEntidad.getValue() == '1'){
						subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR_EXPTE);
					}
					else{
						if(codigoTipoEntidad.getValue() == '5' && esSupervisorCex){
							subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE);
						}else
							subtipoTarea.setValue(app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR);
					}
				}
			}
		}
		<app:test id="campoRequiereRespuesta" addComa="true"/>
	});

	//date chooser 
	var fecha = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="generartarea.fecha" text="**Fecha" />'
		,minValue : new Date()
		,labelWidth:80
		,name : 'fecha'
		,labelStyle:labelStyle2
		,disabled :true
        ,value:''
		<app:test id="campoFechaRespuesta" addComa="true"/>
	});



	var contenedor=new Ext.Panel({
		border:false
		,width:650
		,height: 300
		,layout : 'table'
		,layoutConfig:{columns:2}
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
					{ items : reqRes}
					,{ items : fecha}
					,{ items : titulodescripcion,colspan:2}
					,{ items : descripcion,colspan:2}
					,codigoTipoEntidad
					,idEntidad
					,subtipoTarea
			]
	});
	app.crearABMWindow(page,contenedor);
	//page.add(panelEdicion);
</fwk:page>	