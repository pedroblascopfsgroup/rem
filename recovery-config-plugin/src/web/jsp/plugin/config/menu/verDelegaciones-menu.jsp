<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
      text:'<s:message code="plugin.config.delegaciones.menu.ver.delegaciones" text="**Delegaciones activas" />'
        ,iconCls:'icon_historico_delegaciones'
        ,handler: function() {
			        	var w = app.openWindow({
                                flow : 'delegaciontareas/historicoDelegaciones'
                                ,title : '<s:message code="plugin.config.delegaciones.historico.title" text="**Histórico de delegaciones" />'
                                ,width:900
								,closable:true
                                ,params : {}
                        });
                        w.on(app.event.DONE, function(){
                                w.close();
                        });
                        w.on(app.event.CANCEL, function(){w.close(); });
        }