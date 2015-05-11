<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
        text:'<s:message code="plugin.cambiosMasivosAsuntos.cambiogestores.title" text="**Cambio masivo de usuarios" />'
        ,iconCls:'icon_cambio_gestor'
        ,handler: function() {
			        	var w = app.openWindow({
                                flow : 'cambiomasivogestoresasunto/abreVentana'
                                ,title : '<s:message code="plugin.cambiosMasivosAsuntos.cambiogestores.title" text="**Cambio masivo de usuarios" />'
                                ,width:470
								,closable:true
                                ,params : {}
                        });
                        w.on(app.event.DONE, function(){
                                w.close();
                                page.fireEvent(app.event.DONE);
                        });
                        w.on(app.event.CANCEL, function(){w.close(); });
        }
    
