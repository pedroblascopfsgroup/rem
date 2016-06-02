<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="obligatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean"%>
<%@ attribute name="searchOnEnter" required="false" type="java.lang.Boolean"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>
<%@ attribute name="value" required="false" type="java.util.Date"%>
<%@ attribute name="hideLabel" required="false" type="java.lang.Boolean" %>

<c:set var="_width" value="100" />

<c:if test="${width != null}">
	<c:set var="_width" value="${width}" />
</c:if>

<c:if test="${value != null}">
var ${name}_parseValue = function(){
	var fecha = '<fwk:date value="${value}" />';
	var valor = fecha.replace(/(\d*)-(\d*)-(\d*)/,"$3/$2/$1");  //conversión de yyyy-MM-dd a dd/MM/yyyy
	return valor;
	
};
</c:if>

var ${name} = new Ext.ux.form.XDateField({
		name : '${name}'
		,fieldLabel : '<s:message code="${labelKey}" text="${label}" />'
 		<c:if test="${value != null}">,value : '<fwk:date value="${value}" />'</c:if>
		<c:if test="${obligatory}">,allowBlank: false</c:if>
		<c:if test="${disabled}">,disabled:true</c:if>
		<c:if test="${searchOnEnter}">,enableKeyEvents: true
		,listeners : {
			keypress : function(target,e){
					if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
      					buscarFunc();
  					}
  				}
		}</c:if>
		<c:if test="${hideLabel}">,hideLabel:true</c:if>
	});
