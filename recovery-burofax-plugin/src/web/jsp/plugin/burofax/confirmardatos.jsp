<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>

<fwk:page>

	var labelStyle='font-weight:bolder;width:100';
	<pfsforms:textfield name="nombre" labelKey="plugin.burofax.confirmardatos.control.nombre" label="**Nombre" value="${persona.nombre}" width="500"/>
	<pfsforms:textfield name="apellido1" labelKey="plugin.burofax.confirmardatos.control.apellido1" label="**Apellido1" value="${persona.apellido1}" width="500"/>
	<pfsforms:textfield name="apellido2" labelKey="plugin.burofax.confirmardatos.control.apellido2" label="**Apellido2" value="${persona.apellido2}" width="500"/>
	<pfsforms:textfield name="codigopostal" labelKey="plugin.burofax.confirmardatos.control.codigopostal" label="**Código postal" value="${direccion.codigoPostal}" />
	<pfsforms:textfield name="municipio" labelKey="plugin.burofax.confirmardatos.control.municipio" label="**Municipio" value="${direccion.municipio}" />
	<pfsforms:textfield name="provincia" labelKey="plugin.burofax.confirmardatos.control.provincia" label="**Provincia" value="${direccion.provincia.descripcion}" />
	<pfs:textarea name="domicilio" labelKey="plugin.burofax.confirmardatos.control.domicilio" label="**Domicilio" value="" width="500"/>
	<pfsforms:ddCombo name="tipoIntervencion" labelKey="plugin.burofax.confirmardatos.control.tipoIntervencion" label="xxx" 
		value="${tipoIntervencionDefault}" dd="${ddTiposIntervencion}" propertyCodigo="descripcion" propertyDescripcion="descripcion"/>
	<pfsforms:numberfield labelKey="plugin.burofax.confirmardatos.control.plazo" label="xxx" name="plazo" value="${plazoDefault}"/>
	<%--<pfsforms:check name="adjuntar" labelKey="plugin.burofax.confirmardatos.control.adjuntar" label="**Adjuntar"  value="false"/>--%>
	
	domicilio.setValue('${direccion.tipoVia.codigo} ${direccion.domicilio}, ${direccion.domicilio_n}.<c:if test="${direccion.piso!=null}">Piso ${direccion.piso}.</c:if><c:if test="${direccion.escalera!=null}">Escalera ${direccion.escalera}.</c:if><c:if test="${direccion.puerta!=null}">Puerta ${direccion.puerta}.</c:if>');
	 
	nombre.labelStyle=labelStyle;
	apellido1.labelStyle=labelStyle;
	apellido2.labelStyle=labelStyle;
	codigopostal.labelStyle=labelStyle;
	municipio.labelStyle=labelStyle;
	provincia.labelStyle=labelStyle;
	domicilio.labelStyle=labelStyle;
	tipoIntervencion.labelStyle=labelStyle;
	plazo.labelStyle=labelStyle;
	<%-->adjuntar.labelStyle=labelStyle; --%>
		
	<pfs:buttoncancel name="btCancelar"/>
	
	<pfs:button name="btAceptar" caption="**Aceptar"  captioneKey="plugin.burofax.confirmardatos.action.aceptar" iconCls="icon_ok">
		var flow='plugin.burofax.openReport';
		var tipo='generaPDF';
		//var params='id='+ '${expediente.id}'+'&REPORT_NAME=reporteExpediente'+'${expediente.id}'+'.pdf';
		var params = 'nombre='+nombre.getValue()+'&apellido1='+apellido1.getValue()+'&apellido2='+apellido2.getValue()+'&codigopostal='+codigopostal.getValue();
		params = params + '&municipio='+municipio.getValue()+'&provincia='+provincia.getValue()+'&domicilio='+domicilio.getValue();
		params = params + '&plazo='+plazo.getValue()+'&tipoIntervencion='+tipoIntervencion.getValue()
		app.openPDF(flow,tipo,params);
		page.fireEvent(app.event.DONE);
	</pfs:button>

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
				,items:[{items: [nombre,apellido1,apellido2,codigopostal,municipio,provincia,domicilio,plazo,tipoIntervencion<%--,{html:'&nbsp;',border:false},adjuntar--%>]}]
			}
		]
		,bbar : [
			btAceptar, btCancelar
		]
	});	
	page.add(panelEdicion);
</fwk:page>