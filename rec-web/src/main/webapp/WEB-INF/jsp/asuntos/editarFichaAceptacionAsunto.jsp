<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fwk:page>
	var labelStyle='font-weight:bolder;width:300'
	
	var aceptacionChecked = ${asunto.fichaAceptacion.aceptacion || accion==1};
	var deshabilitado =  ${accion}==1;

	//Variables que determinan el estado inicial de los componentes.
	var aceptacionBloq = ${asunto.fichaAceptacion.conflicto || asunto.fichaAceptacion.conflicto == null};
	var documentacionRecibidaBloq = ${asunto.fichaAceptacion.conflicto || asunto.fichaAceptacion.conflicto == null};
	var fechaRecepcionDocumentacionBloq = ${!asunto.fichaAceptacion.documentacionRecibida || asunto.fichaAceptacion.documentacionRecibida == null};

	//Función para deshabilitar los combos de aceptación y Documentación recibida si existe conflico y los habilita si no existe.
	var bloquearAceptacion = function(){
		if (conflicto.getValue()=='false'){
			aceptacion.enable();
			documentacionRecibida.enable();
		}else {
			aceptacion.disable();
			aceptacion.setValue('');
			documentacionRecibida.disable();
			documentacionRecibida.setValue('');
			fechaRecepcionDocumentacion.setValue('');
			fechaRecepcionDocumentacion.disable();
		}
	}

	//Función para deshabilitar el capo de Fecha de Recepción de la documentación si se recibió la misma
	var bloquearFechaRecDoc = function() {
		if (documentacionRecibida.getValue()=='true') {
			fechaRecepcionDocumentacion.enable();
		} else {
			fechaRecepcionDocumentacion.setValue('');
			fechaRecepcionDocumentacion.disable();
		}
	}

	//Opciones para los combos Conflicto, Aceptación y Decomentación Recibida.
	var dictCombos = 
		{'diccionario':[
			{'codigo':'','descripcion':''},
			{'codigo':'true','descripcion':'<s:message code="label.si" text="**Si" />'},
			{'codigo':'false','descripcion':'<s:message code="label.no" text="**No" />'}]}

	conflicto = app.creaComboOffset({
		data : dictCombos
		,name : 'aceptada'
		,allowBlank : false
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="asunto.tabaceptacion.conflicto" text="**Conflicto"/>'
		,value : '${asunto.fichaAceptacion.conflicto}' 
		,width:'30px'
	});

	conflicto.on('select',bloquearAceptacion);
	
	aceptacion = app.creaComboOffset({
		data : dictCombos
		,name : 'aceptada'
		,allowBlank : false
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="asunto.tabaceptacion.aceptacion" text="**Aceptacion"/>'
		,value : '${asunto.fichaAceptacion.aceptacion}'
		,disabled:aceptacionBloq
		,width:'30px'
	});

	documentacionRecibida = app.creaComboOffset({
		data : dictCombos
		,name : 'aceptada'
		,allowBlank : false
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="asunto.tabaceptacion.documentacionRecibida" text="**Documentación recibida"/>'
		,value : '${asunto.fichaAceptacion.documentacionRecibida}'
		,disabled:documentacionRecibidaBloq
		,width:'30px'
		,handler : function(){
			alert('Nada');
		}
	}); 

	documentacionRecibida.on('select',bloquearFechaRecDoc);

	var fechaRecepcionDocumentacion = new Ext.ux.form.XDateField({
		name : 'usuario.alta'
		,fieldLabel : '<s:message code="asunto.tabaceptacion.fechaRecepcionDocumentacion" />'
 		,value : '<fwk:date value="${asunto.fechaRecepDoc}" />'
		,allowBlank : true
		,style:'margin:0px'
		,maxValue:new Date()
		,labelStyle:labelStyle
		,disabled:fechaRecepcionDocumentacionBloq
	});

	/* Grid historial de aceptacion asunto */
	
	var observaciones=new Ext.form.TextArea({
		fieldLabel:'<s:message code="asunto.tabaceptacion.observaciones" text="**Observaciones"/>'
		,labelStyle:'font-weight:bolder'
		,width:770
		,height:200
		,maxLength:2048
		<c:if test="${fn:length(asunto.fichaAceptacion.observaciones)>0}">
			,value:'<s:message text="${asunto.fichaAceptacion.observaciones[0].detalle}" javaScriptEscape="true" />'
		</c:if>
	});
		
	var formObservaciones=new Ext.form.FormPanel({
		items:[
			observaciones
		]
		,border:false
	});
	
	var fieldSetObservaciones=new Ext.form.FieldSet({
		items:[formObservaciones]
		,title:'<s:message code="solvencia.editar.observaciones" text="**Observaciones" />'
		,bodyStyle:'padding:5px'
		,width:400
		,autoHeight:true
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if (${accion}==1
				&& !(conflicto.getValue()=='false' 
					&& aceptacion.getValue()=='true' 
					&& documentacionRecibida.getValue()=='true')){
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="ficha.observacion.aceptarConflicto"/>');
				return;
			}else{
	            var fechaRecepDocStr = '';
	            if(fechaRecepcionDocumentacion.getValue()!= '') {
	                fechaRecepDocStr = fechaRecepcionDocumentacion.getValue().format('d/m/Y');
	            }
				//if(observaciones.getValue()!= null && observaciones.getValue()!='' && observaciones.validate()){
				if(observaciones.validate()){
					if (documentacionRecibida.getValue()=='true' && fechaRecepcionDocumentacion.getValue()=='') {
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="ficha.fechaRec.nula" text="**Si la documentación está recibida debe ingresar la fecha." />');
					} else {
						btnGuardar.disable();
						page.webflow({
							eventName:'guardarFicha'
							,params: {
								idAsunto:${asunto.id}
								,conflicto:conflicto.getValue()
								,aceptacion:aceptacion.getValue()
								,documentacionRecibida:documentacionRecibida.getValue()
								,observaciones:observaciones.getValue()
								,fechaRecepDoc:fechaRecepDocStr
								,accion:${accion}
							}
							,success :  function(){ 
			                  				page.fireEvent(app.event.DONE);
			                  			}
						});
					}
				}else {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="main.error.limiteTextArea"/>');
				}
			}
		}
	});
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var panel = new Ext.form.FormPanel({
		bodyStyle : 'padding:5px'
		,layout:'anchor'
		,autoHeight : true
		,bodyStyle:'padding:10px'
		,defaults:{
			border:false
			,cellCls:'vtop'
		}
		,items:[{
					border : false
					,autoWidth:true
					,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
					,items:[
						{ items:[conflicto,aceptacion,documentacionRecibida,fechaRecepcionDocumentacion]}
					]
				}
				,{
					items:[observaciones]
				}
			]
			,bbar:[btnGuardar, btnCancelar]
	});
	
	page.add(panel);
	
</fwk:page>
