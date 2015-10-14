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
		
	<pfsforms:textfield name="oculto" labelKey="" 
		label="" value="" readOnly="true" />
		
	var fechaPropuesta = app.creaLabel('<s:message code="mejoras.plugin.acuerdos.fechaVencimiento" text="**Fecha vencimiento" />', "<fwk:date value='${acuerdo.fechaPropuesta}' />");
	

	
	var fechaPago = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="mejoras.plugin.acuerdos.fechaCumplimiento" text="**Fecha Cumplimiento" />'
			,name:'fechaPago'
			,style:'margin:0px'
		});
		
	var observaciones = new Ext.form.HtmlEditor({
		id:'observaciones'
		,name:'observaciones'
		,readOnly:false
		,width: 400
		,height: 150
		,enableColors: true
       	,enableAlignments: true
       	,enableFont:true
       	,enableFontSize:true
       	,enableFormat:true
       	,enableLinks:true
       	,enableLists:true
       	,enableSourceEdit:true		
		,html:''});	
		
	var observacionesCont = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.informe" text="**Observaciones"/>'
		,layout:'form'
		,autoHeight:true
		,autoWidth: true
		,border:true
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
			{items:[observaciones]}
		]
	});	
		
	<pfsforms:check name="cumplido"
		labelKey="plugin.mejoras.acuerdos.cumplido" label="**Cumplido"
		value=""/>

			
	<pfs:defineParameters name="parametros" paramId="${acuerdo.id}" 
		fechaPago_date="fechaPago"
		cumplido="cumplido"
		observaciones="observaciones"
		/>		
	
	<pfs:editForm saveOrUpdateFlow="propuestas/finalizar"
			leftColumFields="tipoAcuerdo, cumplido"
			rightColumFields="fechaPropuesta,fechaPago,oculto"
			centerColumFieldsDown="observacionesCont"
			parameters="parametros" 
			/>

</fwk:page>