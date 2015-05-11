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
		
	var fechaPropuesta = app.creaLabel('<s:message code="mejoras.plugin.acuerdos.fechaPropuesta" text="**Fecha propuesta" />', "<fwk:date value='${acuerdo.fechaPropuesta}' />");
	

	<pfsforms:numberfield name="importePagado" labelKey="mejoras.plugin.acuerdo.conclusiones.importePagado"
		label="**Cantidad pagada" value="" allowDecimals="true" allowNegative="false"
		/>
	
	var fechaPago = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="mejoras.plugin.acuerdos.fechaCumplimiento" text="**Fecha Cumplimiento" />'
			,name:'fechaPago'
			,style:'margin:0px'
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
	
	<pfs:editForm saveOrUpdateFlow="editacuerdo/guardaCumplimientoAcuerdo"
			leftColumFields="tipoAcuerdo,  importePagado,fechaPago,cumplido"
			rightColumFields="fechaPropuesta,continuar,finalizar,oculto"
			parameters="parametros" 
			/>

</fwk:page>