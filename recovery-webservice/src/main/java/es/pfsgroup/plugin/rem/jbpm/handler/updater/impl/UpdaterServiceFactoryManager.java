package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.genericService.api.impl.AbstractServiceFactoryManager;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterServiceFactoryApi;

@Component
public class UpdaterServiceFactoryManager extends AbstractServiceFactoryManager<UpdaterService> implements UpdaterServiceFactoryApi {

}
