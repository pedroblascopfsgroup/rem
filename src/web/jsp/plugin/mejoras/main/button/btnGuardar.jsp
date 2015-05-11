<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
		<app:test id="btnGuardarABM" addComa="true"/>
	})