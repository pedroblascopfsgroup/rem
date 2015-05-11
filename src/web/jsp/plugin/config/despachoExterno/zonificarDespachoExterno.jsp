<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>

	

	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.tipoDespacho" label="**Tipo de despacho" name="tipoDespacho" value="${despacho.tipoDespacho.descripcion}" readOnly="true" />
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.despacho" label="**Despacho" name="despacho" value="${despacho.despacho}" readOnly="true"/>

	<pfsforms:ddCombo name="nivel" labelKey="plugin.config.despachoExterno.field.zona.nivel.descripcion" label="**Nivel" value="${despacho.zona!=null?despacho.zona.nivel.id:''}" dd="${niveles}" obligatory="true"/>
	<%--<pfs:defineParameters name="getzonasParam" paramId=""
		id="nivel"
	/>--%>
	
	var getzonasParam = function() {
		return{id:nivel.getValue()};
	}; 
	
	<pfsforms:remotecombo name="zona" 
		labelKey="plugin.config.despachoExterno.field.zona.descripcion" 
		dataFlow="plugin/config/zona/ADMlistadoZonasPorNivelData"
		parameters="getzonasParam"
		label="**Zona" 
		root="zonas" 
		value="${despacho.zona!=null?despacho.zona.id:''}" 
		valueField="id"
		displayField="descripcion" 
		autoload="${despacho.zona != null?'true':'false'}" obligatory="true"/>

	nivel.on('select',function(){
		zona.reload(true);
	});
	
	

	<pfs:defineParameters name="parametros" paramId="${despacho.id}" 
		idZona="zona"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/config/despachoExterno/ADMguardarZonificacionDespachoExterno"
		leftColumFields="tipoDespacho, despacho"
		rightColumFields="nivel,zona"
		parameters="parametros"  />

</fwk:page>