<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="obligatory" required="false" type="java.lang.Boolean"%>

var ${name} = app.creaMinMaxPorcentaje('<s:message code="${labelKey}" text="${label}" />', '${name}',
	{ width : 90
	, widthPanel : 350
	, widthFieldSet : 220
	<c:if test="${obligatory}">
	,allowBlank: false
	</c:if>	
	}
);