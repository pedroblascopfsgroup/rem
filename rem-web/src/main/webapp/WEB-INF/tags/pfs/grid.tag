<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ tag body-content="empty"%>
<%@ tag import="java.util.*" %>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="dataStore" required="true" type="java.lang.String"%>
<%@ attribute name="columnModel" required="true" type="java.lang.String"%>
<%@ attribute name="title" required="true" type="java.lang.String"%>
<%@ attribute name="titleKey" required="true" type="java.lang.String"%>
<%@ attribute name="collapsible" required="true" type="java.lang.Boolean"%>

<%@ attribute name="tbar" required="false" type="java.lang.String"%>
<%@ attribute name="bbar" required="false" type="java.lang.String"%>
<%@ attribute name="autoexpand" required="false" type="java.lang.Boolean"%>
<%@ attribute name="iconCls" required="false" type="java.lang.String"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>
<%@ attribute name="rowdblclick" required="false" type="java.lang.String"%>


var ${name}_cfg={
		title : '<s:message code="${titleKey}" text="${title}" />'
		,collapsible : ${collapsible}
		,collapsed: ${collapsible}
		,titleCollapse : ${collapsible}
		,stripeRows:true
		<c:if test="${tbar != null}">
		,tbar : [${tbar}]
		</c:if>
		<c:if test="${bbar != null}">
		,bbar : [${bbar}]
		</c:if>
		//,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		<c:if test="${width != null}">,margin: app.contenido.getSize(true).width-${width}</c:if>
		<c:if test="${iconCls != null}">,iconCls:'${iconCls}'</c:if>
		<c:if test="${autoexpand}">,height: 450</c:if>
	};

var ${name} = app.crearGrid(${dataStore},${columnModel},${name}_cfg);

<c:if test="${rowdblclick != null}">
${name}.on('rowdblclick', ${rowdblclick});
</c:if>