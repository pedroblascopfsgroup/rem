<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="root" required="true" type="java.lang.String"%>
<%@ attribute name="displayField" required="true" type="java.lang.String"%>
<%@ attribute name="valueField" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="true" type="java.lang.String"%>
<%@ attribute name="dict" required="true" type="java.lang.String"%>
<%@ attribute name="obligatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>
<%@ attribute name="disableIfNotEmpty" required="false" type="java.lang.Boolean"%>
<%@ attribute name="readOnly" required="false" type="java.lang.Boolean"%>
<%@ attribute name="labelWidth" required="false" type="java.lang.String"%>
<%@ attribute name="searchOnEnter" required="false" type="java.lang.Boolean"%>
<%@ attribute name="labelStyle" required="false" type="java.lang.String" %>

<c:set var="_width" value="175" />
<c:if test="${width != null}">
	<c:set var="_width" value="${width}" />
</c:if>

var ${name}_Store = new Ext.data.JsonStore({
	       fields: ['${valueField}', '${displayField}']
	       ,root: '${root}'
	       ,data : ${dict}
	});

<c:if test="${readOnly}">
var ${name}_labelStyle='font-weight:bolder<c:if test="${labelWidth != null}">;width:${labelWidth}</c:if><c:if test="${labelStyle != null}">;${labelStyle}</c:if>';
var ${name}_idx = var ${name}_Store.find('${valueField}','${value}');
var ${name}_value = var ${name}_Store.getAt(var ${name}_idx).get('${displayField}');
var ${name} = app.creaLabel('<s:message code='${labelKey}' text='${label}' />',${name}_value,{labelStyle:${name}_labelStyle});
</c:if>

<c:if test="${!readOnly}">
var ${name}_labelStyle='<c:if test="${labelWidth != null}">width:${labelWidth}</c:if><c:if test="${labelStyle != null}">;${labelStyle}</c:if>';
var ${name} = new Ext.form.ComboBox({
				store:${name}_Store
				,displayField:'${displayField}'
				,valueField:'${valueField}'
				,width : ${_width}
				,resizable: true
				,mode: 'local'
				,emptyText:'---'
				,labelStyle:${name}_labelStyle
				<c:if test="${disableIfNotEmpty && (value != 0)}">,disabled:true</c:if>
				,triggerAction: 'all'
				,fieldLabel : '<s:message code='${labelKey}' text='${label}' />'
				<c:if test="${value > 0}">,value:'${value}'</c:if>
				<%--<c:if test="${readOnly}">,readOnly:${readOnly}</c:if>--%>
				<c:if test="${searchOnEnter}">,enableKeyEvents: true
				,listeners : {
					keypress : function(target,e){				
							if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
		      					buscarFunc();
		  					}
		  				}
				}</c:if>
	});
</c:if>
