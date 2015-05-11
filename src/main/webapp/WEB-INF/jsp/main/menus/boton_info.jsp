<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
new Ext.Button({
		text:'<s:message code="app.info" text="**Acerca de" />'
		,iconCls:'icon_info'
		,handler:function(){
			var w = app.openWindow({
				flow : 'main/acercade'
				,width:420
				,title : '<s:message code="app.acercade" text="**Acerca de.." />'
				
			});
			w.on(app.event.DONE, function(){
				w.close();
			});
			
		}
	})