<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

<fwk:page>

	<pfsforms:textfield name="tipoAcuerdo" labelKey="mejoras.plugin.acuerdos.tipoAcuerdo" 
		label="**Tipo de acuerdo" value="${acuerdo.tipoAcuerdo.descripcion}" readOnly="true" />
		
	var fechaPropuesta = app.creaLabel('<s:message code="mejoras.plugin.acuerdos.fechaPropuesta" text="**Fecha propuesta" />', "<fwk:date value='${acuerdo.fechaPropuesta}' />");
	

	<pfsforms:numberfield name="importePagado" labelKey="mejoras.plugin.acuerdo.conclusiones.importePagado"
		label="**Cantidad pagada" value="" allowDecimals="true" allowNegative="false"
		/>
	
	var fechaPago = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="mejoras.plugin.acuerdos.fechaFinalizacion" text="**Fecha de finalización" />'
			,name:'fechaPago'
			,style:'margin:0px'
			,value: new Date()
		});
		
	var cumplidoData=<app:dict value="${ddSiNo}" />;
	var cumplidoSelect=app.creaCombo({
		triggerAction:'all'
		<app:test id="cumplido" addComa="true" />
		,data:cumplidoData
		,name : 'cumplidoSelect'
		,labelStyle:'width:100' 
		,fieldLabel : '<s:message code="plugin.mejoras.acuerdos.cumplido" text="**Cumplido" />'
		,width : 100
		,allowBlank : false
	});
	
	<pfsforms:check name="cumplido"
		labelKey="plugin.mejoras.acuerdos.cumplido" label="**Cumplido"
		value=""/>
		
	<pfsforms:check name="continuar"
		labelKey="plugin.mejoras.acuerdos.continuar" label="**Continuar"
		value="true"/>
		
	<pfsforms:check name="finalizar"
		labelKey="plugin.mejoras.acuerdos.finalizar" label="**Finalizar"
		value=""/>

	continuar.on('check',function(){
		if (continuar.getValue()== true){finalizar.setValue(false);}
		else {finalizar.setValue(true);}
			});
			
	finalizar.on('check',function(){
		if (finalizar.getValue()== true){continuar.setValue(false);}
		else {continuar.setValue(true);}
			});
			
	<pfs:defineParameters name="parametros" paramId="${acuerdo.id}" 
		importePagado="importePagado"
		fechaPago_date="fechaPago"
		cumplido="cumplido"
		continuar="continuar"
		finalizar="finalizar"
		/>		
	

	var btnGuardar = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
		
						if(cumplidoSelect.getValue() != ''){
							if(cumplidoSelect.getValue() == '01'){
								cumplido.setValue(true);
							}else{
								cumplido.setValue(false);
							}
							page.webflow({
								flow: 'propuestas/guardaCumplimientoAcuerdo'
								,params: parametros
								,success : function(){ 
												page.fireEvent(app.event.DONE); 
											}
							});
						}else{
							Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', 'Debe indicar si el acuerdo está cumplido');
						}

					}
	});

	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});

	var panelEdicion = new Ext.Panel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [tipoAcuerdo,  importePagado,fechaPago,cumplidoSelect]},{items: [fechaPropuesta,continuar,finalizar]}]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	


	page.add(panelEdicion);

</fwk:page>