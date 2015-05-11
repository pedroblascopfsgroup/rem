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

	var treOld='${infoRegistro['treOld']}';
	var treNew='${infoRegistro['treNew']}';
	var juzOld='${infoRegistro['juzOld']}';
	var juzNew='${infoRegistro['juzNew']}';
	var pplOld='${infoRegistro['pplOld']}';
	var pplNew='${infoRegistro['pplNew']}';
	var plaOld='${infoRegistro['plaOld']}';
	var plaNew='${infoRegistro['plaNew']}';
	var estOld='${infoRegistro['estOld']}';
	var estNew='${infoRegistro['estNew']}';

	<pfsforms:textfield name="tipoReclamacionOld" labelKey="plugin.mejoras.procedimiento.cabecera.tipoReclamacionOld" 
		label="**Tipo de Reclamación anterior" value="${descTreOld}" readOnly="true"/>
	
	<pfsforms:textfield name="tipoReclamacionNew" labelKey="plugin.mejoras.procedimiento.cabecera.tipoReclamacionNew" 
		label="**Tipo de Reclamación nueva" value="${descTreNew}" readOnly="true"/>
			
	<pfsforms:textfield name="tipoJuzgadoOld" labelKey="plugin.mejoras.procedimiento.cabecera.tipoJuzgadoOld" 
		label="**Juzgado anterior" value="${descJuzOld}" readOnly="true"/>
		
	<pfsforms:textfield name="tipoJuzgadoNew" labelKey="plugin.mejoras.procedimiento.cabecera.tipoJuzgadoNew" 
		label="**Juzgado nuevo" value="${descJuzNew}" readOnly="true"/>
		
	<pfsforms:textfield name="plazaOld" labelKey="plugin.mejoras.procedimiento.cabecera.plazaOld" 
		label="**Plaza anterior" value="${descPlazaOld}" readOnly="true"/>
		
	<pfsforms:textfield name="plazaNew" labelKey="plugin.mejoras.procedimiento.cabecera.plazaNew" 
		label="**Plaza nuevo" value="${descPlazaNew}" readOnly="true"/>
		
	<pfsforms:textfield name="principalOld" labelKey="plugin.mejoras.procedimiento.cabecera.principalOld" 
		label="**Principal anterior" value="${infoRegistro['pplOld']}" readOnly="true"/>
		
	<pfsforms:textfield name="principalNew" labelKey="plugin.mejoras.procedimiento.cabecera.principalNew" 
		label="**Principal nuevo" value="${infoRegistro['pplNew']}" readOnly="true"/>
			
	<pfsforms:textfield name="plazoOld" labelKey="plugin.mejoras.procedimiento.cabecera.plazoOld" 
		label="**Plazo anterior" value="${infoRegistro['plaOld']}" readOnly="true"/>
		
	<pfsforms:textfield name="plazoNew" labelKey="plugin.mejoras.procedimiento.cabecera.plazoNew" 
		label="**Plazo nuevo" value="${infoRegistro['plaNew']}" readOnly="true"/>
		
	<pfsforms:textfield name="estimacionOld" labelKey="plugin.mejoras.procedimiento.cabecera.estimacionOld" 
		label="**Estimación anterior" value="${infoRegistro['estOld']}" readOnly="true"/>
		
	<pfsforms:textfield name="estimacionNew" labelKey="plugin.mejoras.procedimiento.cabecera.estimacionNew" 
		label="**Estimacion nuevo" value="${infoRegistro['estNew']}" readOnly="true"/>
	
	var itemsOld = [];
	var itemsNew = [];	
	
	if (treNew != '') {
		itemsOld.push(tipoReclamacionOld);
		itemsNew.push(tipoReclamacionNew);
	}
	if (juzNew != '') {
		itemsOld.push(tipoJuzgadoOld);
		itemsOld.push(plazaOld);
		itemsNew.push(tipoJuzgadoNew);
		itemsNew.push(plazaNew);
	}
	if (pplNew != '') {
		itemsOld.push(principalOld);
		itemsNew.push(principalNew);
	}
	if (plaNew != '') {
		itemsOld.push(plazoOld);
		itemsNew.push(plazoNew);
	}
	if (estNew != '') {
		itemsOld.push(estimacionOld);
		itemsNew.push(estimacionNew);
	}
	
	
	var btnAceptar = new Ext.Button({
			text : '<s:message code="app.botones.aceptar" text="**Aceptar" />'
			,iconCls : 'icon_ok'
			,handler : function(){
				 page.fireEvent(app.event.DONE) 
			}
		});	
		
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,style:'padding-right:0px;padding-bottom:0px'
		,bodyStyle : 'padding:5px'
		,border : false
		,defaults : {xtype:'panel', border : false ,autoHeight:true}
		,items : [
				{ 
				border : false
				,layout : 'table'
				,layoutConfig:{columns:2}
				,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form'}
				,items : [{items:itemsOld}
							,{items:itemsNew}]
			}]
		,bbar : [btnAceptar]
	});
	
	page.add(panelEdicion);

</fwk:page>