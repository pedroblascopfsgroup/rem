<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>

	var labelStyle='font-weight:bolder;width:100';
	
	var info = new Ext.form.Label({
		   	text:'<s:message code="plugin.mejoras.procedimiento.recursos.info" text="**Si no tiene informaci�n del recurso puede posponer la tarea pulsando el bot�n de Revisado " />'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
			,border:false
			});		
			
	var panel = new Ext.Panel({
		layout:'table'
		,layoutConfig:{columns:1}
		,autoHeight:true
		,border:false
		,style:'padding:10px'
		,cellCls:'vtop'
		,width:900
		,defaults:{xtype:'table',height:120, border:false}
		,items : [info]
		
	});		
	
	var fecha = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.edicionRecurso.fechaRec" text="**Fecha" />'
		,name:'recurso.fechaRecurso'
		,labelStyle:labelStyle
		,value: '<fwk:date value="${recurso.fechaRecurso}" />'
	});

	var comboActor = app.creaCombo({
		data :<app:dict value="${DDActor}" />
		,labelStyle:labelStyle
		,name : 'recurso.actor'
		,fieldLabel : '<s:message code="procedimiento.edicionRecurso.actor" text="**Actor" />'
		,value : '${recurso.actor.codigo}'
	});

	var comboTipoRecurso = app.creaCombo({
		data : <app:dict value="${DDTipoRecurso}" />
		,name:'recurso.tipoRecurso'
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="procedimiento.edicionRecurso.tipo" text="**Tipo" />'
		,value : '${recurso.tipoRecurso.codigo}'
	});

	var comboCausa = app.creaCombo({
		data : <app:dict value="${DDCausaRecurso}" />
		,name:'recurso.causaRecurso'
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="procedimiento.edicionRecurso.causa" text="**Causa" />'
		,value : '${recurso.causaRecurso.codigo}'
	});

	var fechaImpugnacion = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.edicionRecurso.fechaImp" text="**Fecha impugnaci�n" />'
		,name: 'recurso.fechaImpugnacion'
		,disabled:true
		,labelStyle:labelStyle
		,value: '<fwk:date value="${recurso.fechaImpugnacion}" />' 
	});

	var valor = false;
	<c:if test="${recurso.confirmarImpugnacion != null && recurso.confirmarImpugnacion == true}">
		valor = true;
	</c:if>


	var chkImpugnacion = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="procedimiento.edicionRecurso.confirmarImp" text="**Confirmar impugnaci�n" />'
		,labelStyle:labelStyle
		,checked:valor
		,handler:function(){
			fechaImpugnacion.setDisabled(!chkImpugnacion.checked);
			if (!chkImpugnacion.checked){
				fechaImpugnacion.setValue('');
			}
		}
	});

	valor = false;
	<c:if test="${recurso.suspensivo != null}">
		valor = ${recurso.suspensivo};
	</c:if>
	var chkSuspensivo = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.mejoras.procedimiento.edicionRecurso.suspensivo" text="**Suspensivo" />'
		,labelStyle:labelStyle
		,checked:valor
	});

	fechaImpugnacion.setDisabled(!chkImpugnacion.checked);

	var fechaVista = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.edicionRecurso.fechaVista" text="**Fecha vista" />'
		,name: 'recurso.fechaVista'
		,disabled:true
		,labelStyle:labelStyle
		,value: '<fwk:date value="${recurso.fechaVista}" />' 
	});


	valor = false;
	<c:if test="${recurso.confirmarVista != null && recurso.confirmarVista == true}">
		valor = true;
	</c:if>

	var chkVista = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="procedimiento.edicionRecurso.confirmarVista" text="**Confirmar vista" />'
		,labelStyle:labelStyle
		,checked:valor
		,handler:function(){
			fechaVista.setDisabled(!chkVista.checked);
			if (!chkVista.checked){
				fechaVista.setValue('');
			}
		}
	});

	fechaVista.setDisabled(!chkVista.checked);

	var observaciones = app.crearTextArea('<s:message code="procedimiento.edicionRecurso.observaciones" text="**Observaciones" />','<s:message text="${recurso.observaciones}" javaScriptEscape="true" />',false,labelStyle,'recurso.observaciones', {maxLength:100});
	observaciones.allowBlank = true; 


	var fechaResolucion= new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.edicionRecurso.fechaRes" text="**Fecha resoluci�n" />'
		,name:'recurso.fechaResolucion'
		,labelStyle:labelStyle
		,value: '<fwk:date value="${recurso.fechaResolucion}" />' 
	});

	var comboResultado = app.creaCombo({
		data : <app:dict value="${DDResultadoResolucion}" /> 
		,labelStyle:labelStyle
		,name:'recurso.resultadoResolucion'
		,fieldLabel : '<s:message code="procedimiento.edicionRecurso.resultado" text="**Resultado" />'
		,value : '${recurso.resultadoResolucion.codigo}'
	});

	comboResultado.on('select', function(){
		fechaResolucion.setDisabled(false);
	});

	fechaResolucion.setDisabled(!comboResultado.getValue());


	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,params:{
					idProcedimiento:'${idProcedimiento}'
					,'recurso.confirmarVista': chkVista.getValue()
					,'recurso.confirmarImpugnacion': chkImpugnacion.getValue()
					,'recurso.suspensivo' : chkSuspensivo.getValue()
				}
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.submit({
				eventName : 'cancel'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.CANCEL) }	
			});
		}
	});
	
	var btnRevisado= new Ext.Button({
		text : '<s:message code="plugin.mejoras.procedimientos.recursos.revisado" text="**Revisado" />'
		,iconCls : 'icon_edit'
		,handler : function(){
			page.submit({
				eventName : 'revisado'
				,formPanel : panelEdicion
				,params:{
						idProcedimiento:'${idProcedimiento}'
				}
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});

	var bottomBar = [];
	
	<c:if test="${recurso.fechaResolucion == null && !isConsulta}">
		<sec:authorize ifAnyGranted="ROLE_PUEDE_VER_BOTONES_RECURSOS_GUARDAR_REVISADO"> 
			bottomBar.push(btnGuardar);
			bottomBar.push(btnRevisado);
		</sec:authorize> 
	</c:if>

	bottomBar.push(btnCancelar);

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{items:[panel]}
			,{
				border : false
				,layout : 'table'
				,viewConfig : { columns : 2 }
				,defaults :  {layout:'form', autoHeight : true, border : false,width:400 }
				,items : [
					{ items : [fecha, comboActor,comboTipoRecurso, comboCausa , observaciones, chkSuspensivo], style : 'margin-right:10px' }
					,{ items : [chkImpugnacion,fechaImpugnacion,chkVista,fechaVista,comboResultado, fechaResolucion] }
				]
			}
		]
		,bbar:[bottomBar]
		
	});

	//Si ya tiene fecha de recurso pero no tiene de resoluci�n, es porque 
	//se trata de una edici�n, desactivamos valores b�sicos
	<c:if test="${recurso.fechaRecurso != null && recurso.fechaResolucion == null}">
		fecha.setDisabled(true);
		comboActor.setDisabled(true);
		comboTipoRecurso.setDisabled(true);
		comboCausa.setDisabled(true);
		observaciones.setDisabled(true);
		chkSuspensivo.setDisabled(true);
	</c:if>

	<%-- 
	var panelFinal = new Ext.form.FormPanel({
		bodyStyle : 'padding-left:5px;padding-top:5px'
		,layout:'anchor'
		,autoHeight : true
		,defaults:{
			border:false
		}
		,items : [
		 	{ xtype : 'errorList', id:'errL' }
		 	,{
		 		autoHeight:true
		 		,border:false
		 		,defaults:{border:false,xtype:'fieldset',autoHeight:true}
		 		,items:[ 
		 			panel
					,panelEdicion
		 		]
		 	}
		]
		
	});
		--%>
		
	var paralizado = ${paralizado};
	var finalizado = ${finalizado};
	if(paralizado && finalizado) {
		info.text = '<s:message code="plugin.mejoras.procedimiento.recursos.paralizado" text="**No es posible interponer un recurso mientras el procedimiento se encuentre paralizado" />'
		btnGuardar.setDisabled(true);
		btnRevisado.setDisabled(true);
		btnCancelar.setDisabled(false);
	}	
		
	page.add(panelEdicion);



</fwk:page>