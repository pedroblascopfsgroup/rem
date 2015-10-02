<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>


<fwk:page>

	var labelStyle='font-weight:bolder;width:150px'

	var tipoSolucionLabel=app.creaLabel('<s:message code="acuerdos.actuacionesExpl.solamistosa" text="**Tipo Solución Amistosa"/>'
                            ,'${subtipoSolucionAmistosa.ddTipoSolucionAmistosa.descripcion}'
                            ,{labelStyle:labelStyle});

	var subtipoSolucionLabel=app.creaLabel('<s:message code="acuerdos.actuacionesExpl.subsolamistosa" text="**Subtipo Solución Amistosa"/>'
                            ,'${subtipoSolucionAmistosa.descripcion}'
                            ,{labelStyle:labelStyle});

	var tipoValoracionActual = app.creaCombo({
		data: <app:dict value="${tiposValoracionActuacionAmistosa}" />
		<app:test id="tipoValoracionActual" addComa="true" />
		,name: 'ddValoracionActuacionAmistosa'
		,allowBlank: false
		,fieldLabel: '<s:message code="acuerdos.actuacionesExpl.valoracionactual" text="**Valoración Actual" />'
		,value: '${actuaciones.ddValoracionActuacionAmistosa.codigo}'
		,labelStyle:labelStyle
	});

	var tituloobservaciones = new Ext.form.Label({
   		text:'<s:message code="acuerdos.actuacionesExpl.observaciones" text="**Observaciones" />'
	,style:labelStyle
	}); 
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdos.actuacionesExpl.observaciones" text="**Observaciones" />'
		<app:test id="observacionesActAExplorar" addComa="true" />
		,name: 'observaciones'
		,value:'<s:message javaScriptEscape="true" text="${actuaciones.observaciones}" />'
		,width:530
		,height:220
		, maxLength: 250
		,labelStyle:labelStyle
	});

	var idExpedienteH = new Ext.form.Hidden({name:'idExpediente', value :'${expediente.id}'});
	var idActuacionH = new Ext.form.Hidden({name:'idActuacion', value :'${actuaciones.id}'});
	var codDDSubtipoSolucionAmistosaAcuerdo = new Ext.form.Hidden({name:'ddSubtipoSolucionAmistosaAcuerdo', value :'${subtipoSolucionAmistosa.codigo}'});
	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if (!observaciones.validate()) {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.conclusiones.observaciones.error"/>');
			}else{
				page.submit({
					eventName : 'update'
					,formPanel : panelEdicion
					,success : function(){ page.fireEvent(app.event.DONE) }
				});
			}
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,width:500
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				//,layout : 'column'
				//,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false}
				,items : [
					{ items : [ 
							tipoSolucionLabel
							,subtipoSolucionLabel
							,tipoValoracionActual
							,tituloobservaciones
							,{items:observaciones,border:false,style:'margin-top:5px'} 
							,idExpedienteH
							,idActuacionH
							,codDDSubtipoSolucionAmistosaAcuerdo 
						], style : 'margin-right:10px' }
					
				]
			}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});

	page.add(panelEdicion);

</fwk:page>
