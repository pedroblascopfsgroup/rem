<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.procesoFacturacion.nombre"
		label="**Nombre" value="${procesoFacturacion.nombre}" obligatory="true" />
		
	nombre.maxLength=100;
	
	<pfsforms:datefield name="filtroFechaDesde"
		labelKey="plugin.recobroConfig.procesoFacturacion.fechaDesde" 
		label="**Fecha desde" obligatory="true"/>
	
	<pfsforms:datefield name="filtroFechaHasta"
		labelKey="plugin.recobroConfig.procesoFacturacion.fechaHasta" 
		label="**Fecha hasta" obligatory="true"/>
		
	filtroFechaHasta.maxValue =new Date();
	filtroFechaDesde.maxValue =new Date();		
	
	var validarForm= function(){
		if (nombre.getActiveError()!=''){
			return nombre.getActiveError();
		}
		if (filtroFechaDesde.getActiveError()!=''){
			return filtroFechaDesde.getActiveError();
		}
		if (filtroFechaHasta.getActiveError()!=''){
			return filtroFechaHasta.getActiveError();
		}
		return '';
	}
	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()==''){
    			var parms = {};
    			parms.id='${procesoFacturacion.id}';
    			parms.nombre=nombre.getValue();
    			parms.fechaDesde=filtroFechaDesde.getValue().format('d/m/Y');
    			parms.fechaHasta=filtroFechaHasta.getValue().format('d/m/Y');
    			page.webflow({
						flow: 'recobroprocesosfacturacion/saveProcesoFacturacion'
						,params: parms
						,success : function(){ 
							page.fireEvent(app.event.DONE); 
						}
					});
			}else{
				Ext.Msg.alert('<s:message code="plugin.politicaAcuerdo.alta.error" text="**Error" />',validarForm());
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
				,items:[{items: [nombre]}
						,{items: [ filtroFechaDesde,filtroFechaHasta]}
				]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		

	<%-- 	
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_PROCESO_FACTUARCION">
		btnGuardarValidacion.show();
	</sec:authorize>	
	--%>
	page.add(panelEdicion);	
	

</fwk:page>