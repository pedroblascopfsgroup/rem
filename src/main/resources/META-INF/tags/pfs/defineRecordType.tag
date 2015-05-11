<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>

var ${name} = Ext.data.Record.create([
		{name:'id'}
<jsp:doBody/>
]);