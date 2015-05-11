<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>

<fwk:page>
	
	<pfs:hidden name="idAsunto" value="${convenioCredito.convenio.procedimiento.asunto.id}"/>
	<pfs:hidden name="banderaEditar" value="1"/>
	<pfs:hidden name="idConvenioCredito" value="${convenioCredito.id}"/>

	<pfs:textfield name="tipoDefinitivo" labelKey="asunto.concurso.tabConvenios.tipoDefinido" label="**Tipo definitivo" value="${convenioCredito.credito.tipoDefinitivo.descripcion}" readOnly="true"/>
	<pfs:textfield name="principalDefinitivo" labelKey="asunto.concurso.tabConvenios.principal" label="**Principal definitivo" value="${convenioCredito.credito.principalDefinitivo}" readOnly="true"/>
	<pfs:currencyfield name="quita" labelKey="asunto.concurso.tabConvenios.quita" label="**% Quita" value="${convenioCredito.quita}" />
	<pfs:currencyfield name="espera" labelKey="asunto.concurso.tabConvenios.esperaMeses" label="**Espera en meses" value="${convenioCredito.espera}" />
	<pfs:currencyfield name="carencia" labelKey="asunto.concurso.tabConvenios.carenciaMeses" label="**Carencia en meses" value="${convenioCredito.carencia}" />
	<pfs:textfield name="comentario" width="405" labelKey="asunto.concurso.tabConvenios.observaciones" label="**Observaciones" value="${convenioCredito.comentario}" />
		
	
	<pfs:defineParameters name="parametros" paramId=""
		idConvenioCredito="idConvenioCredito"
		banderaEditar="banderaEditar"
		quita="quita"
		espera="espera"
		carencia="carencia"
		comentario="comentario"
		idAsunto="idAsunto"
	/>
	
	<pfs:editForm saveOrUpdateFlow="plugin/procedimientos/concursal/editarConvenioCredito" 
			rightColumFields="tipoDefinitivo, quita, comentario"  
			leftColumFields="principalDefinitivo, espera,carencia" 
			parameters="parametros" 
			centerColumFieldsDown="comentario"
	/>

</fwk:page>