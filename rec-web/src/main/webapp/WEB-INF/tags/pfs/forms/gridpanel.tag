<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ tag body-content="empty"%>
<%@ tag import="java.util.*" %>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="title" required="true" type="java.lang.String"%>
<%@ attribute name="titleKey" required="true" type="java.lang.String"%>
<%@ attribute name="columnModel" required="true" type="java.lang.String"%>
<%@ attribute name="store" required="true" type="java.lang.String"%>

<%@ attribute name="loadMaskMsg" required="false" type="java.lang.String"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>
<%@ attribute name="height" required="false" type="java.lang.Integer"%>
<%@ attribute name="iconCls" required="false" type="java.lang.String"%>
<%@ attribute name="bbar" required="false" type="java.lang.String"%>

<c:set var="_width" value="500"/>
<c:set var="_height" value="150"/>

<c:if test="${width != null}">
	<c:set var="_width" value="${width}"/>
</c:if>
<c:if test="${height != null}">
	<c:set var="_height" value="${height}"/>
</c:if>

var ${name} = new Ext.grid.GridPanel({
	title : '<s:message code="${titleKey}" text="${title}" />'
	,cm: ${columnModel}
	,store: ${store}
	<c:if test="${loadMask != null }">
		,loadMask: {msg: "${loadMaskMsg}", msgCls: "x-mask-loading"}
	</c:if>
	,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	,viewConfig:{forceFit:true}
	,width:${_width}
	,height:${_height}
	<c:if test="${iconCls != null}">
		,iconCls: '${iconCls}
	</c:if>
	<c:if test="${bbar != null}">
		,bbar: ${bbar}
	</c:if>	
});
