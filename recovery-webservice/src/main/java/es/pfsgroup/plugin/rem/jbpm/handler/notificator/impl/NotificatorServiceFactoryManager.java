package es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.genericService.api.impl.AbstractServiceFactoryManager;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorService;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.NotificatorServiceFactoryApi;

@Component
public class NotificatorServiceFactoryManager extends AbstractServiceFactoryManager<NotificatorService> implements NotificatorServiceFactoryApi {

}
