<%@ include file="forms/remotecombo.tag" %>
<%--
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="dataFlow" required="true" type="java.lang.String"%>
<%@ attribute name="root" required="true" type="java.lang.String"%>
<%@ attribute name="displayField" required="true" type="java.lang.String"%>
<%@ attribute name="valueField" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="true" type="java.lang.Long"%>
<%@ attribute name="obligatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>
<%@ attribute name="disableIfNotEmpty" required="false" type="java.lang.Boolean"%>
<%@ attribute name="autoload" required="false" type="java.lang.Boolean"%>
<%@ attribute name="parameters" required="false" type="java.lang.String"%>


<c:set var="_width" value="175" />

<c:if test="${width!=null}"><c:set var="_width" value="${width}" /></c:if>


var ${name}_Record = Ext.data.Record.create([
	 {name:'${valueField}'}
	,{name:'${displayField}'}
]);

var ${name}_Store = page.getStore({
	flow: '${dataFlow}'
	,reader: new Ext.data.JsonReader({root : '${root}'} , ${name}_Record)
});


var ${name} = new Ext.form.ComboBox({
		store:${name}_Store
    	,name : '${name}'
    	,mode: 'local'
		,displayField:'${displayField}'
		,valueField:'${valueField}'
    	<c:if test="${obligatory}">,allowBlank: false</c:if>
    	,fieldLabel : '<s:message code='${labelKey}' text='${label}' />' <app:test id="combo${name}" addComa="true" />
		,width : ${_width}
		<c:if test="${value != 0}">,value: '${value}'</c:if>
		<c:if test="${disableIfNotEmpty && (value != 0)}">,disabled:true</c:if>
		,emptyText:'---'
		,triggerAction: 'all'
    });
 
 ${name}.reload = function(){
 	${name}_Store.webflow(<c:if test="${parameters!=null}">${parameters}()</c:if>);
 };
 
 <c:if test="${autoload}">
${name}.reload();
</c:if>
--%>