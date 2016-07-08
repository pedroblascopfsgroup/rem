package es.pfsgroup.plugin.rem.jbpm.handler.plazo.impl;

import org.springframework.stereotype.Component;
import es.pfsgroup.plugin.rem.genericService.api.impl.AbstractServiceFactoryManager;
import es.pfsgroup.plugin.rem.jbpm.handler.plazo.PlazoAssignationService;
import es.pfsgroup.plugin.rem.jbpm.handler.plazo.PlazoAssignationServiceFactoryApi;

@Component
public class PlazoAssignationServiceFactoryManager extends AbstractServiceFactoryManager<PlazoAssignationService> implements PlazoAssignationServiceFactoryApi {

}
