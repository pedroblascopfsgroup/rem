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
<%@ attribute name="customView" required="false" type="java.lang.Boolean"%>
<%@ attribute name="customView_width" required="false" type="java.lang.Integer"%>

<c:if test="${!customView}">
var ${name} = new Ext.pfs.metaform.AgregarButton({
		windowTitle: '<s:message code="${windowTitle}" text="${windowTitle}" />'
		,caption: '<s:message code="metaform.${mfid}.btagregar.caption" text="xx" />'
		,flow : page.resolveUrl('metaform/process')
		,mfid: '${mfid}'
		,params: {${params}}
		,store : {
			cmp: ${store}
			,params:  {${storeParams}}
		}
	});
	
</c:if>
<c:if test="${customView}">
var ${name}Cfg = {
	caption: '<s:message code="metaform.${mfid}.btagregar.caption" text="xx" />'
	,defaultCaption: '<s:message code="pfs.tags.buttonadd.agregar" text="**Agregar" />'
};
var ${name} = new Ext.Button({
		text : ${name}Cfg.caption == 'xx' ? ${name}Cfg.defaultCaption : ${name}Cfg.caption
		,iconCls : 'icon_mas'
		,handler : function() {
						var allowClose= true;
						
						var w= app.openWindow({
								flow: 'metaform/process'
								,closable: allowClose
								<c:if test="${customView_width}">,width : ${customView_width}</c:if>
								,title :'<s:message code="${windowTitle}" text="${windowTitle}" />'
								,params: {${params},mfid:'${mfid}'}
							});
							w.on(app.event.DONE, function(){
								w.close();
								${store}.webflow({${storeParams}});
							}); 
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
				   }
	});
	<%--alert(${name}Cfg.caption  + ", " + ${name}Cfg.defaultCaption + " --> " + ${name}.text); --%>
	
</c:if>