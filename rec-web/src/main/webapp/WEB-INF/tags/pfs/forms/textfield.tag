<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="true" type="java.lang.String"%>
<%@ attribute name="obligatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="searchOnEnter" required="false" type="java.lang.Boolean"%>
<%@ attribute name="width" required="false" type="java.lang.String"%>
<%@ attribute name="readOnly" required="false" type="java.lang.Boolean"%>
<%@ attribute name="labelWidth" required="false" type="java.lang.String"%>
<%@ attribute name="maxLength" required="false" type="java.lang.String" %>

<c:set var="_width" value="175" />

<c:if test="${width != null}">
	<c:set var="_width" value="${width}" />
</c:if>

<c:if test="${readOnly}">
var ${name}_labelStyle='font-weight:bolder<c:if test="${labelWidth != null}">;width:${labelWidth}</c:if>';
var ${name} = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code='${labelKey}' text='${label}' />'
		,value : '${value}'
		,name : '${name}'
		,labelStyle:${name}_labelStyle
		,width : ${_width} 
	});
</c:if>
<c:if test="${!readOnly}">
var ${name} = app.creaText("${name}","<s:message code="${labelKey}" text="${label}" />","${value}",{
	width : ${_width}
	<c:if test="${obligatory}">,allowBlank: false</c:if>
	<c:if test="${readOnly}">,readOnly:${readOnly}</c:if>
	<c:if test="${maxLength != null}">
		,autoCreate: {tag: 'input', type: 'text', maxlength: '${maxLength}'}
	</c:if>
	<c:if test="${searchOnEnter}">,enableKeyEvents: true
	,listeners : {
			keypress : function(target,e){
					if((e.getKey() == e.ENTER) && (this.getValue().length > 0)) {
      					buscarFunc();
  					}
  				}
		}</c:if>
});
</c:if>
