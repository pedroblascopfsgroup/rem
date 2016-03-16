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

	<pfslayout:includetab name="tabSupervisores">
		<%@ include file="tabSupervisoresDespachoExterno.jsp"%>
	</pfslayout:includetab>
	
	<c:choose>

		<%-- Es tipo despacho letrado --%>
		<c:when test="${despacho.tipoDespacho.codigo == codigoTipoDespachoLetradoValido}">
			tabsDespacho = new Ext.TabPanel({
				autoHeight: true
				,items: [tabCabecera, tabGestores]
				,layoutOnTabChange: true 
				,activeItem: ${numTab == null ? 0 : numTab}
				,autoScroll: true
				,border: false
			})

			<sec:authorize ifAllGranted="ROLE_PUEDE_VER_TAB_SUPERVISORES_DESPACHO">
				tabsDespacho.add(tabSupervisores);
			</sec:authorize>

			<%-- Es tipo despacho letrado y es bankia se añade el tab turnado --%>
			<c:if test="${usuarioEntidad == 'BANKIA'}">

				<pfslayout:includetab name="tabEsquemaTurnado">
					<%@ include file="tabEsquemaTurnado.jsp"%>
				</pfslayout:includetab>

				tabsDespacho.add(tabEsquemaTurnado);
			</c:if>

			<%-- Es tipo despacho letrado y está habilitado el modulo de procuradores se añade el tab procuradores--%>
			<c:if test="${moduloProcuradoresActivado}">

				<pfslayout:includetab name="tabProcuradores">
					<%@ include file="tabProcuradoresDespachoExterno.jsp"%>
				</pfslayout:includetab>

				tabsDespacho.add(tabProcuradores);
			</c:if>

		</c:when>

		<%-- Es tipo despacho procurador (no debe mostrar el tabSupervisores) --%>
		<c:when test="${despacho.tipoDespacho.codigo == '2'}">
			<pfslayout:tabpanel name="tabsDespacho" tabs="tabCabecera, tabGestores" />
		</c:when>

		<%-- Por defecto y para todos los tipos restantes de despacho se muestra [tabCabecera, tabGestores] y tabSupervisores --%>
		<c:otherwise>
			<sec:authorize ifAllGranted="ROLE_PUEDE_VER_TAB_SUPERVISORES_DESPACHO">
				<pfslayout:tabpanel name="tabsDespacho" tabs="tabCabecera, tabGestores, tabSupervisores" />
			</sec:authorize>

			<sec:authorize ifNotGranted="ROLE_PUEDE_VER_TAB_SUPERVISORES_DESPACHO">
				<pfslayout:tabpanel name="tabsDespacho" tabs="tabCabecera, tabGestores" />
			</sec:authorize>
		</c:otherwise>
	</c:choose>

	var panel = new Ext.Panel({
		bodyStyle : 'padding : 5px'
		,autoHeight : true
		,items : [tabsDespacho]
		,tbar : new Ext.Toolbar()
	})

	page.add(panel);

</fwk:page>