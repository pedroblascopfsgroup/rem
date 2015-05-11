<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="captioneKey" required="true" type="java.lang.String"%>
<%@ attribute name="caption" required="true" type="java.lang.String"%>
<%@ attribute name="items" required="false" type="java.lang.String"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>
<%@ attribute name="columns" required="false" type="java.lang.Integer"%>

<c:set var="_width" value="175" />

<c:if test="${width != null}">
	<c:set var="_width" value="${width}" />
</c:if>


var ${name} = new Ext.form.FieldSet({
		title:'<s:message code="${captioneKey}" text="${caption}"/>'
		,autoHeight:true
		//,border:true
		//,bodyStyle:'padding:5px;cellspacing:10px;'
		,width : ${_width}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:true}
		<c:if test="${columns != null}">
		,defaults : {border:false, cellCls: 'vtop', style:'width:auto'}
		,layout : 'table'
		,layoutConfig: {
			columns: ${columns}
		}
		</c:if>
		<c:if test="${items != null}">
		,items : [
		 	${items}
		]
		</c:if>
		<c:if test="${items == null}">
		,items:[
			<jsp:doBody />
		]
		</c:if>
	});