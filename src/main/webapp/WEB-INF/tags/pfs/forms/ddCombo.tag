<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="dd" required="true" type="java.util.List"%>
<%@ attribute name="value" required="true" type="java.lang.String"%>
<%@ attribute name="blankElement" required="false" type="java.lang.Boolean"%>
<%@ attribute name="blankElementText" required="false" type="java.lang.String"%>
<%@ attribute name="blankElementValue" required="false" type="java.lang.String"%>
<%@ attribute name="disableIfNotEmpty" required="false" type="java.lang.Boolean"%>
<%@ attribute name="obligatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="propertyCodigo" required="false" type="java.lang.String"%>
<%@ attribute name="propertyDescripcion" required="false" type="java.lang.String"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>
<%@ attribute name="readOnly" required="false" type="java.lang.Boolean"%>
<%@ attribute name="searchOnEnter" required="false" type="java.lang.Boolean"%>

<c:set value="${name}Diccionario" var="nombreDiccionario"/>

<c:set var="_cod" value="id" />
<c:set var="_des" value="descripcion" />
<c:set var="_width" value="175" />

<c:if test="${propertyCodigo != null}">
	<c:set var="_cod" value="${propertyCodigo}" />
</c:if>

<c:if test="${propertyDescripcion != null}">
	<c:set var="_des" value="${propertyDescripcion}" />
</c:if>

<c:if test="${width != null}">
	<c:set var="_width" value="${width}" />
</c:if>


<c:if test="${blankElement == null}">
	<c:set value="true" var="blankElement"/>
</c:if>
<c:if test="${blankElementValue == null}">
	<c:set value="" var="blankElementValue"/>
</c:if>
<c:if test="${blankElementText == null}">
	<c:set value="---" var="blankElementText"/>
</c:if>

var ${nombreDiccionario} = <json:object>
	<json:array name="diccionario" items="${dd}" var="d">	
		<c:set var="_current" value="${d}" scope="page" />
			 <c:if test="${blankElement}">
		 	 		<json:object>
			 			<json:property name="codigo" value="${blankElementValue}"/>
				 		<json:property name="descripcion" value="${blankElementText}" />
			 		</json:object>
			 		<c:set var="blankElement" value="false"/>
			 </c:if>
		 <json:object>
			  <json:property name="codigo" value="${pageScope['_current'][_cod]}" />
		 	  <json:property name="descripcion" value="${pageScope['_current'][_des]}" />
		</json:object>
	</json:array>
</json:object>;
<c:if test="${readOnly}">
var ${name}_Store = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: '${root}'
	       ,data : ${dict}
	});
var ${name}_labelStyle='font-weight:bolder;width:150px';
var ${name}_idx = var ${name}_Store.find('codigo','${value}');
var ${name}_value = var ${name}_Store.getAt(var ${name}_idx).get('descripcion');
var ${name} = app.creaLabel('<s:message code='${labelKey}' text='${label}' />',${name}_value,{labelStyle:${name}_labelStyle});
</c:if>
<c:if test="${!readOnly}">
var ${name} = app.creaCombo({
		data:${nombreDiccionario}
    	,name : '${name}'
    	<c:if test="${obligatory}">,allowBlank: false</c:if>
    	,fieldLabel : '<s:message code='${labelKey}' text='${label}' />' <app:test id="combo${name}" addComa="true" />
		,width : ${_width}
		,resizable: true
		<c:if test="${value != 0}">,value: '${value}'</c:if>
		<c:if test="${disableIfNotEmpty && (value != '') && (value != 0)}">,disabled:true</c:if>
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
