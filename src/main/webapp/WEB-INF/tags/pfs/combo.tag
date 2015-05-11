<%@ include file="forms/combo.tag" %>
<%--
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="root" required="true" type="java.lang.String"%>
<%@ attribute name="displayField" required="true" type="java.lang.String"%>
<%@ attribute name="valueField" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="true" type="java.lang.Long"%>
<%@ attribute name="dict" required="true" type="java.lang.String"%>
<%@ attribute name="obligatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>
<%@ attribute name="disableIfNotEmpty" required="false" type="java.lang.Boolean"%>
<%@ attribute name="readOnly" required="false" type="java.lang.Boolean"%>


<c:set var="_width" value="175" />


var ${name}_Store = new Ext.data.JsonStore({
	       fields: ['${valueField}', '${displayField}']
	       ,root: '${root}'
	       ,data : ${dict}
	});
	
var ${name} = new Ext.form.ComboBox({
				store:${name}_Store
				,displayField:'${displayField}'
				,valueField:'${valueField}'
				,mode: 'local'
				,emptyText:'---'
				<c:if test="${disableIfNotEmpty && (value != 0)}">,disabled:true</c:if>
				,triggerAction: 'all'
				,fieldLabel : '<s:message code='${labelKey}' text='${label}' />'
				<c:if test="${value > 0}">,value:${value}</c:if>
				<c:if test="${readOnly}">,readOnly:${readOnly}</c:if>

	});
--%>