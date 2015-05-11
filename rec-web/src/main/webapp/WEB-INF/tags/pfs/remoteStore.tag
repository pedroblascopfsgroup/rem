<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="dataFlow" required="true" type="java.lang.String"%>
<%@ attribute name="resultRootVar" required="true" type="java.lang.String"%>
<%@ attribute name="recordType" required="true" type="java.lang.String"%>

<%@ attribute name="parameters" required="false" type="java.lang.String"%>
<%@ attribute name="autoload" required="false" type="java.lang.Boolean"%>
<%@ attribute name="resultTotalVar" required="false" type="java.lang.String"%>

var createStore_${name} = function(){
	var limit=25;
	var p${name} = page.getStore({
		limit:limit
		,remoteSort : true
		//,loading:false
		,flow: '${dataFlow}'
		,reader: new Ext.data.JsonReader({
	    	root : '${resultRootVar}'
	    	<c:if test="${resultTotalVar != null}">,totalProperty : '${resultTotalVar}'</c:if>
	    }, ${recordType})
	});
	return p${name};
}

var ${name} = createStore_${name}();

<c:if test="${autoload}">
var ${name}_params = {}; 
<c:if test="${parameters != null}">${name}_params = ${parameters}();</c:if>
${name}.webflow(${name}_params);
</c:if>
