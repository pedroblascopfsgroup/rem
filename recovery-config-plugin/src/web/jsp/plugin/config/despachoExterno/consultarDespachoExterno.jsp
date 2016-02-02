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

	<%--El tab supervisores solo lo mostramos en el caso que el despacho no sea de procuradores --%>
	<c:if test="${despacho.tipoDespacho.codigo!='2' || despacho.tipoDespacho.codigo!='1'}">
		<pfslayout:includetab name="tabSupervisores">
			<%@ include file="tabSupervisoresDespachoExterno.jsp"%>
		</pfslayout:includetab>
		<pfslayout:tabpanel name="tabsDespacho"
			tabs="tabCabecera,tabGestores,tabSupervisores" />
	</c:if>
	
	<c:if test="${despacho.tipoDespacho.codigo=='2'}">
		<pfslayout:tabpanel name="tabsDespacho"
			tabs="tabCabecera,tabGestores" />
	</c:if>
	
var tabPanel;
var numTab = '${numTab}';
	<c:if test="${despacho.tipoDespacho.codigo=='1'}">
		<pfslayout:includetab name="tabEsquemaTurnado">
			<%@ include file="tabEsquemaTurnado.jsp"%>
		</pfslayout:includetab>
		<pfslayout:includetab name="tabProcuradores">
			<%@ include file="tabProcuradoresDespachoExterno.jsp"%>
		</pfslayout:includetab>
			<%--<pfslayout:tabpanel name="tabsDespacho"
				tabs="tabCabecera,tabGestores,tabSupervisores,tabProcuradores,tabEsquemaTurnado" /> --%>
		tabsDespacho=new Ext.TabPanel({
		       autoHeight:true
		       <c:if test="${usuario.entidad.descripcion eq 'BANKIA'}">
		       ,items:[tabCabecera,tabGestores,tabSupervisores,tabProcuradores,tabEsquemaTurnado]
		       </c:if>
		       <c:if test="${usuario.entidad.descripcion != 'BANKIA'}">
		       ,items:[tabCabecera,tabGestores,tabSupervisores,tabProcuradores]
		       </c:if>		
		       ,layoutOnTabChange:true 
		       ,activeItem:${numTab == null ? 0 : numTab}
		       ,autoScroll:true
		       ,border : false
		})

	</c:if>	
	var panel = new Ext.Panel({
       bodyStyle : 'padding : 5px'
       ,autoHeight : true
       ,items : [tabsDespacho]
       ,tbar : new Ext.Toolbar()
})
	<%--<c:if test="${nombretab !=null}">
		page.add(panel);
	</c:if> --%>
page.add(panel);
		<%--page.add(tabsDespacho); --%>
	<%--<c:choose>
    <c:when test="${numTab != ''}">
        page.add(panel);
    </c:when>    
    <c:otherwise>
        page.add(tabsDespacho);
    </c:otherwise>
</c:choose> --%>

</fwk:page>