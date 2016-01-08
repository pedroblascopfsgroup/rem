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

	<%--
	<pfsforms:check labelKey="plugin.itinerarios.editarReglaExclusion.CEmayorPRE" label="" name="" value=""/>
	<pfsforms:check labelKey="plugin.itinerarios.editarReglaExclusion.CEmenorPRE" label="" name="" value=""/>
	 --%>
	<pfsforms:ddCombo name="tipoReglaVigenciaPolitica"
		labelKey="plugin.itinerarios.reglasVigencia.tipoRegla"
		label="**Reglas vigencia de política" 
		value="" dd="${reglasExclusion}" 
		obligatory="true" width="400"/>
		
	
	<pfs:hidden name="estado" value="${estado.id}"/>
	<pfs:defineParameters name="parametros" paramId="" 
		estado="estado"
		tipoReglaVigenciaPolitica="tipoReglaVigenciaPolitica"
		/>
		
	<pfs:editForm saveOrUpdateFlow="plugin/itinerarios/plugin.itinerarios.guardaReglaConsensoEstado"
		leftColumFields="tipoReglaVigenciaPolitica"
		rightColumFields=""
		parameters="parametros" />

</fwk:page>