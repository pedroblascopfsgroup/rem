<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ tag body-content="scriptless"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="windowTitle" required="true" type="java.lang.String"%>
<%@ attribute name="mfid" required="true" type="java.lang.String"%>
<%@ attribute name="params" required="true" type="java.lang.String"%>
<%@ attribute name="store" required="true" type="java.lang.String"%>
<%@ attribute name="storeParams" required="true" type="java.lang.String"%>

var ${name} = new Ext.pfs.metaform.ModificarButton({
		windowTitle: '<s:message code="${windowTitle}" text="${windowTitle}" />'
		,caption: '<s:message code="metaform.${mfid}.btmodificar.caption" text="xx" />'
		,flow : page.resolveUrl('metaform/process')
		,mfid: '${mfid}'
		,params: {${params}}
		,store : {
			cmp: ${store}
			,params:  {${storeParams}}
		}
	});