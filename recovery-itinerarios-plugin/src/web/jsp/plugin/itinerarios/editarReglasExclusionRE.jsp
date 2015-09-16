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

	<pfsforms:check labelKey="plugin.itinerarios.editarReglaExclusion.REmayorPRE" 
		label="**Exclusi�n si la pol�tica de RE es mayor que la vigente" 
		name="reMayorPre" value="" labelWidth="400"/>	
	reMayorPre.on('check',function(){
		reMayorPre.check();
		remenorPre.setValue(false);
	});
	
	<pfsforms:check labelKey="plugin.itinerarios.editarReglaExclusion.REmenorPRE" 
		label="**Exclusi�n si la pol�tica de RE es menor que la vigente" 
		name="remenorPre" value="" labelWidth="800"/>
	remenorPre.on('check',function(){
		reMayorPre.setValue(false);
	});
	
	<pfsforms:check labelKey="plugin.itinerarios.editarReglaExclusion.REmayorCE" 
		label="**Exclusi�n si la pol�tica de RE es mayor que la pol�tica de CE" 
		name="reMayorCe" value=""/>
	reMayorCe.on('check',function(){
		remenorCe.setValue(false);
	});
		
	<pfsforms:check labelKey="plugin.itinerarios.editarReglaExclusion.REmenorCE" 
		label="**Exclusi�n si la pol�tica de RE es menor que la pol�tica de CE" 
		name="remenorCe" value=""/>
	remenorCe.on('check',function(){
		reMayorCe.setValue(false);
	});
	
	<pfs:hidden name="estado" value="${estado.id}"/>
	
	<pfs:defineParameters name="parametros" paramId="" 
		estado="estado"
		
		/>
		
	<pfs:editForm saveOrUpdateFlow="plugin/itinerarios/plugin.itinerarios.guardaReglasExclusionEstado"
		leftColumFields="reMayorPre,remenorPre,reMayorCe,remenorCe"
		rightColumFields=""
		parameters="parametros" />

</fwk:page>