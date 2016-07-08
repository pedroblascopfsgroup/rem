package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.genericService.api.impl.AbstractServiceFactoryManager;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionServiceFactoryApi;

@Component
public class UserAssigantionServiceFactoryManager extends AbstractServiceFactoryManager<UserAssigantionService> implements UserAssigantionServiceFactoryApi {

}
