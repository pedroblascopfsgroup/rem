<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="main.toolbar.admin" text="**Admin" />'
	,menu : [
		{ text : '<s:message code="main.toolbar.admin.usuarios" text="**Usuarios"/>'
		, handler : app.openTab.createDelegate(app,["Usuarios","admin/editarUsuarios"])
		}
		, { text : '<s:message code="main.toolbar.admin.usuarios2" text="**Usuarios2"/>'
			, handler : app.openTab.createDelegate(app,["Usuarios","admin/listadoUsuarios"])
		}
		, { text : '<s:message code="main.toolbar.admin.usuarios3" text="**Usuarios3"/>'
			, handler : app.openTab.createDelegate(app,["Usuarios","admin/usuarios"])
		}
		
		,{ text : '<s:message code="main.toolbar.admin.hibernate" text="**Hibernate"/>'
			, handler : app.openTab.createDelegate(app,["Hibernate","test/hibernate"])
		}
		,{ text : '<s:message code="main.toolbar.admin.excepciones" text="**Excepciones"/>'
			, handler : app.openTab.createDelegate(app,["excepciones","test/excepciones"])
		}
		
	]