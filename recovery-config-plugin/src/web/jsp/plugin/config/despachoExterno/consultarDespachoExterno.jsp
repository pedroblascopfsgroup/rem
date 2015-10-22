<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>
	
	<pfslayout:includetab name="tabCabecera">
		<%@ include file="tabCabeceraDespachoExterno.jsp"%>
	</pfslayout:includetab>

	<pfslayout:includetab name="tabGestores">
		<%@ include file="tabGestoresDespachoExterno.jsp"%>
	</pfslayout:includetab>

	<pfslayout:includetab name="tabEsquemaTurnado">
		<%@ include file="tabEsquemaTurnado.jsp"%>
	</pfslayout:includetab>

	<%--El tab supervisores solo lo mostramos en el caso que el despacho no sea de procuradores --%>
	<c:if test="${despacho.tipoDespacho.codigo!=2 || despacho.tipoDespacho.codigo!=1}">
		<pfslayout:includetab name="tabSupervisores">
			<%@ include file="tabSupervisoresDespachoExterno.jsp"%>
		</pfslayout:includetab>
		<pfslayout:tabpanel name="tabsDespacho"
			tabs="tabCabecera,tabGestores,tabSupervisores,tabEsquemaTurnado" />
	</c:if>
	
	<c:if test="${despacho.tipoDespacho.codigo==2}">
		<pfslayout:tabpanel name="tabsDespacho"
			tabs="tabCabecera,tabGestores,tabEsquemaTurnado" />
	</c:if>
	
	
	<c:if test="${despacho.tipoDespacho.codigo==1}">
		<pfslayout:includetab name="tabProcuradores">
			<%@ include file="tabProcuradoresDespachoExterno.jsp"%>
		</pfslayout:includetab>	
		<pfslayout:tabpanel name="tabsDespacho"
			tabs="tabCabecera,tabGestores,tabSupervisores,tabProcuradores,tabEsquemaTurnado" />
	</c:if>	
	
	page.add(tabsDespacho);
</fwk:page>