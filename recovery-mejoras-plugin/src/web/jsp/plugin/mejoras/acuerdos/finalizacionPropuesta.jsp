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
		label="**Tipo de acuerdo" value="${acuerdo.tipoAcuerdo.descripcion}" readOnly="true" width="150"/>
		
	var fechaPropuesta = app.creaLabel('<s:message code="mejoras.plugin.acuerdos.fechaVencimiento" text="**Fecha vencimiento" />', "<fwk:date value='${acuerdo.fechaPropuesta}' />",{labelStyle:'font-weight:bolder;width:150px'});
	

	
	var fechaPago = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="mejoras.plugin.acuerdos.fechaFinalizacion" text="**Fecha de finalización" />'
			,labelStyle:'font-weight:bolder;width:150px'
			,name:'fechaPago'
			,width : 120
			,style:'margin-left:0px'
			,value : new Date()
		});
		
	var observaciones = new Ext.form.HtmlEditor({
		id:'observaciones'
		,name:'observaciones'
		,readOnly:false
		,width: 600
		,height: 150
		,enableColors: true
       	,enableAlignments: true
       	,enableFont:true
       	,enableFontSize:true
       	,enableFormat:true
       	,enableLinks:true
       	,enableLists:true
       	,enableSourceEdit:true	
       	,hideLabel: true	
		,html:''
        });	
		
	
	var lblObservaciones = app.creaLabel('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.informe" text="**Observaciones"/>', "",{labelStyle:'font-weight:bolder;width:150px'});
	
		
	var cumplidoData=<app:dict value="${ddSiNo}" />;
	var cumplido=app.creaCombo({
		triggerAction:'all'
		<app:test id="cumplido" addComa="true" />
		,data:cumplidoData
		,name : 'cumplido'
		,labelStyle:'font-weight:bolder;width:100' 
		,fieldLabel : '<s:message code="plugin.mejoras.acuerdos.cumplido" text="**Cumplido" />'
		,width : 100
		,allowBlank : false
	});
			
	<pfs:defineParameters name="parametros" paramId="${acuerdo.id}" 
		fechaPago_date="fechaPago"
		cumplido="cumplido"
		observaciones="observaciones"
		/>		
	
  			
  	var btnGuardar = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
				if(cumplido.getValue() != ''){
					page.webflow({
						flow: 'propuestas/finalizar'
						,params: parametros
						,success : function(){ 
									page.fireEvent(app.event.DONE); 
								}
					});
				}else{
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', 'Debe indicar si la propuesta está cumplida');
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
				,defaults : {xtype : 'fieldset',width:300, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [tipoAcuerdo, cumplido]},{items: [fechaPropuesta,fechaPago]}]
			}
			, {  layout:'form'
				,border:false
				,defaults:{xtype:'fieldset',bodyStyle:'padding-left:30px',border:false}
				,bodyStyle:'padding-left:20px; padding-bottom:10px;'
				,items:[lblObservaciones,observaciones]}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	

	page.add(panelEdicion);
	
</fwk:page>
