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
<%@ attribute name="store_ref" required="false" type="java.lang.String"%>
<%@ attribute name="on_success" required="false" type="java.lang.String"%>
<%@ attribute name="closableWindow" required="false" type="java.lang.Boolean"%>
<%@ attribute name="defaultWidth" required="false" type="java.lang.Integer"%>

var ${name} = new Ext.Button({
		text : '<s:message code="pfs.tags.buttonedit.modificar" text="**Modificar" />'
		<app:test id="btnEdit_${name}" addComa="true" />
		,iconCls : 'icon_edit'
		,handler : function() {
						var allowClose= false;
						<c:if test="${closableWindow}">allowClose = true;</c:if>
						<c:if test="${defaultWidth == null}">
						var ${name}_width=700;
						</c:if>
						<c:if test="${defaultWidth != null}">
						var ${name}_width=${defaultWidth};
						</c:if>
						var w= app.openWindow({
								flow: '${flow}'
								,closable: allowClose
								,width : ${name}_width
								,title : '<s:message code="${windowTitleKey}" text="${windowTitle}" />'
								,params: ${parameters}()
							});
							w.on(app.event.DONE, function(){
								w.close();
								<c:if test="${store_ref!=null}">${store_ref}.webflow(${parameters}());</c:if>
								<c:if test="${on_success!=null}">${on_success}();</c:if>
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
				   }
	});