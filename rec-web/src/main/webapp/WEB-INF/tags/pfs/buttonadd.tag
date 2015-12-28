<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="flow" required="true" type="java.lang.String"%>
<%@ attribute name="parameters" required="true" type="java.lang.String"%>
<%@ attribute name="windowTitleKey" required="true" type="java.lang.String"%>
<%@ attribute name="windowTitle" required="true" type="java.lang.String"%>
<%@ attribute name="store_ref" required="true" type="java.lang.String"%>

<%@ attribute name="on_success" required="false" type="java.lang.String"%>


<%@ attribute name="closableWindow" required="false" type="java.lang.Boolean"%>



var ${name} = new Ext.Button({
		text : '<s:message code="pfs.tags.buttonadd.agregar" text="**Agregar" />'
		<app:test id="btnAdd_${name}" addComa="true" />
		,iconCls : 'icon_mas'
		,handler : function() {
						var allowClose= false;
						<c:if test="${closableWindow}">allowClose = true;</c:if>
						var w= app.openWindow({
								flow: '${flow}'
								,closable: allowClose
								,width : 700
								,title : '<s:message code="${windowTitleKey}" text="${windowTitle}" />'
								,params: ${parameters}()
							});
							w.on(app.event.DONE, function(){
								w.close();
								${store_ref}.webflow(${parameters}());
								<c:if test="${on_success != null}">${on_success}();</c:if>
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
				   }
	});