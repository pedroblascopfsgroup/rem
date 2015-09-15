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

	<pfsforms:check labelKey="plugin.itinerarios.estados.telecobro" label="**Telecobro" 
		name="telecobro" value="${siNo}"/>

	<pfsforms:ddCombo name="proveedor"
		labelKey="plugin.itinerarios.telecobro.proveedor"
		label="**Proveedor" value="${telecobro.proveedor.id}" dd="${proveedores}" 
		propertyCodigo="id" propertyDescripcion="nombre"  />
		

	<pfsforms:numberfield name="plazoInicial" labelKey="plugin.itinerarios.telecobro.plazoInicial"
		label="**Plazo Inicial" value="" allowDecimals="false"  allowNegative="false"/>
	
	plazoInicial.setValue(Math.round(${telecobro.plazoInicial / 86400000 }));
		
	<pfsforms:numberfield name="plazoFinal" labelKey="plugin.itinerarios.telecobro.plazoFinal"
		label="**Plazo Final" value="" allowDecimals="false" allowNegative="false"/>
	plazoFinal.setValue(Math.round(${telecobro.plazoFinal / 86400000 }));	
	
	<pfsforms:numberfield name="diasAntelacion" labelKey="plugin.itinerarios.telecobro.diasAntelacion"
		label="**Días de Antelación" value="" allowDecimals="false" allowNegative="false" />
	diasAntelacion.setValue(Math.round(${telecobro.diasAntelacion / 86400000 }));
	
	<pfsforms:numberfield name="plazoRespuesta" labelKey="plugin.itinerarios.telecobro.plazoRespuesta"
		label="**Plazo Respuesta" value="" allowDecimals="false" allowNegative="false" />
	plazoRespuesta.setValue(Math.round(${telecobro.plazoRespuesta / 86400000 }));
	
	<pfsforms:check labelKey="plugin.itinerarios.telecobro.automatico" 
		label="**Automático" name="automatico" value="${telecobro.automatico}"/>
	
	proveedor.setDisabled(true);
	plazoInicial.setDisabled(true);
	plazoFinal.setDisabled(true);
	diasAntelacion.setDisabled(true);
	plazoRespuesta.setDisabled(true);
	automatico.setDisabled(true);
	
	if (telecobro.checked == true){
			proveedor.setDisabled(false);
			plazoInicial.setDisabled(false);
			plazoFinal.setDisabled(false);
			diasAntelacion.setDisabled(false);
			plazoRespuesta.setDisabled(false);
			automatico.setDisabled(false);
		}else{
			proveedor.setDisabled(true);
			plazoInicial.setDisabled(true);
			plazoFinal.setDisabled(true);
			diasAntelacion.setDisabled(true);
			plazoRespuesta.setDisabled(true);
			automatico.setDisabled(true);
		}
	
			
	telecobro.on('check',function(){
		if (telecobro.getValue() == true){
			proveedor.setDisabled(false);
			plazoInicial.setDisabled(false);
			plazoFinal.setDisabled(false);
			diasAntelacion.setDisabled(false);
			plazoRespuesta.setDisabled(false);
			automatico.setDisabled(false);
		}else{
			proveedor.setDisabled(true);
			plazoInicial.setDisabled(true);
			plazoFinal.setDisabled(true);
			diasAntelacion.setDisabled(true);
			plazoRespuesta.setDisabled(true);
			automatico.setDisabled(true);
		}
	});	
	
	<pfs:hidden name="estado" value="${estado.id}"/>
	<pfs:defineParameters name="parametros" paramId="${telecobro.id}" 
		estado ="estado"
		telecobro="telecobro"
		proveedor="proveedor"
		plazoInicial="plazoInicial"
		plazoFinal="plazoFinal"
		diasAntelacion="diasAntelacion"
		plazoRespuesta="plazoRespuesta"
		automatico="automatico"
		/>
		
	Ext.util.CSS.createStyleSheet(".icon_telecobro { background-image: url('../img/plugin/itinerarios/money.png');}");
	
	var mensaje ={
			html:'**Todos los plazos se deben introducir en días'
			,border: false
			,style:'font-weight:bolder;font-size:0.6em;color:#00008B'
	};
	<pfs:editForm saveOrUpdateFlow="plugin/itinerarios/plugin.itinerarios.guardaEstadoTelecobro"
		leftColumFields="telecobro,proveedor,plazoInicial,plazoFinal,mensaje"
		rightColumFields="diasAntelacion,plazoRespuesta,automatico"
		parameters="parametros" tab_iconCls="icon_telecobro"
		/>

</fwk:page>