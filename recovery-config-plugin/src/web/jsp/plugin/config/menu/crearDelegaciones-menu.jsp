<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
      text:'<s:message code="plugin.config.delegaciones.menu.delegaciones" text="**Delegar tareas" />'
        ,iconCls:'icon_delegacion_tareas'
        ,handler: function() {
			        	var w = app.openWindow({
                                flow : 'delegaciontareas/nuevaDelegacion'
                                ,title : '<s:message code="plugin.config.delegaciones.new.title" text="**Delegar tareas internas" />'
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