<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	var labelStyle='font-weight:bolder;width:100';
	var advertencia = new Ext.form.Label({
		text: '<s:message code="plugin.liquidaciones.introducirdatos.message.advertencia" text="**Advertencia" />'
		,style:labelStyle + ';font-size:0.8em; margin:20px'
		,autoWidth: true
	});
	
	var actuacionesAsunto = {"actuaciones" :<json:array name="actuaciones" items="${actuaciones}" var="a">
		<json:object>
			<json:property name="id" value="${a.id}" />
			<json:property name="nombre" value="${a.nombreProcedimiento}" />
		</json:object>
	</json:array>};

	<pfsforms:combo name="actuaciones"
		 dict="actuacionesAsunto" 
		 labelKey="plugin.liquidaciones.introducirdatos.control.actuaciones"
		 displayField="nombre" root="actuaciones" label="**Actuaciones" 
		 value="" valueField="id" width="500" obligatory="true"/>
	
	<pfs:defineParameters name="pcontratos" paramId=""
		idProcedimiento="actuaciones"
	/>
	
	<pfsforms:remotecombo 
		name="contratos" 
		dataFlow="plugin.liquidaciones.contratosData" 
		labelKey="plugin.liquidaciones.introducirdatos.control.contratos" 
		displayField="codigo" 
		root="contratos" 
		label="**Contratos" 
		value="" 
		valueField="id"
		parameters="pcontratos"
		width="500"
		obligatory="true"
		/>
		
		 
	<pfsforms:datefield labelKey="plugin.liquidaciones.introducirdatos.control.fechacierre" label="**Fecha de cierre" name="fechacierre" obligatory="true"/>
	<pfsforms:numberfield name="intereses" labelKey="plugin.liquidaciones.introducirdatos.control.intereses" label="**Intereses de demora" value="" obligatory="true" allowDecimals="true"/>
	<pfsforms:numberfield name="principal" labelKey="plugin.liquidaciones.introducirdatos.control.principal" label="**Principal" value="" obligatory="true" allowDecimals="true" />
	<pfsforms:textfield name="nombre" labelKey="plugin.liquidaciones.introducirdatos.control.nombre" label="**Nombre" value="" obligatory="true" width="500"/>
	<pfsforms:textfield name="dni" labelKey="plugin.liquidaciones.introducirdatos.control.dni" label="**D.N.I." value="" obligatory="true"/>
	<pfsforms:datefield labelKey="plugin.liquidaciones.introducirdatos.control.fechaliquidacion" label="xxxx" name="fechaliquidacion" obligatory="true"/>
	
	intereses.width = 50;
	
	actuaciones.on('select',function (){
		contratos.reload(true)
		//---
		Ext.Ajax.request({
			url: page.resolveUrl('plugin.liquidaciones.getprocedimiento')
			,params: {id: actuaciones.getValue()}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				principal.setValue(r.procedimiento.principal);
				
		}});
		//---	
	});
	
	contratos.on('select',function (){
		Ext.Ajax.request({
			url: page.resolveUrl('plugin.liquidaciones.getcontrato')
			,params: {id: contratos.getValue()}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				nombre.setValue(r.persona.nombre);
				dni.setValue(r.persona.docid);
				
		}});
	});
	
	<pfs:defineParameters name="parametros" paramId=""
		actuacion="actuaciones"
		contrato="contratos"
		fechaCierre_date="fechacierre"
		intereses="intereses"
		principal="principal"
		nombre="nombre"
		dni="dni"
		fechaLiquidacion_date="fechaliquidacion"
	/>

	<%--<pfs:editForm saveOrUpdateFlow="plugin.liquidaciones.openReport"
		leftColumFields="actuaciones,contratos"
		rightColumFields="fechacierre,intereses"
		parameters="parametros" />--%>
		
	<pfs:buttoncancel name="btCancelar"/>
	
	<pfs:button name="btAceptar" caption="**Aceptar"  captioneKey="plugin.liquidaciones.introducirdatos.action.aceptar" iconCls="icon_ok">
		var flow='plugin.liquidaciones.openReport';
		var tipo='generaPDF';
		var p=parametros();
		var params='actuacion='+p.actuacion+'&contrato='+p.contrato+'&fechaCierre='+p.fechaCierre+'&intereses='+p.intereses+'&principal='+p.principal+'&nombre='+p.nombre+'&dni='+p.dni;
		params = params + '&fechaLiquidacion='+p.fechaLiquidacion
		//var params='id='+ '${expediente.id}'+'&REPORT_NAME=reporteExpediente'+'${expediente.id}'+'.pdf';
		app.openPDF(flow,tipo,params);
		page.fireEvent(app.event.DONE);
	</pfs:button>


	//LabelStyle
	actuaciones.labelStyle=labelStyle;
	contratos.labelStyle=labelStyle;
	fechacierre.labelStyle=labelStyle;
	intereses.labelStyle=labelStyle;
	principal.labelStyle=labelStyle;
	nombre.labelStyle=labelStyle;
	dni.labelStyle=labelStyle;
	fechaliquidacion.labelStyle=labelStyle;

	var panelEdicion = new Ext.Panel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{   autoHeight:true
				,layout:'table'
				,columns: 1
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [advertencia,{html: '&nbsp;',border:false},actuaciones,contratos,fechacierre,fechaliquidacion,intereses,principal,nombre,dni]}
				]
			}
		]
		,bbar : [
			btAceptar, btCancelar
		]
	});	
	page.add(panelEdicion);

</fwk:page>