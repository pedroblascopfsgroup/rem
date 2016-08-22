package es.pfsgroup.plugin.rem.factory.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.factory.TabActivoFactoryApi;
import es.pfsgroup.plugin.rem.genericService.api.impl.AbstractServiceFactoryManager;
import es.pfsgroup.plugin.rem.service.TabActivoService;

@Component
public class TabActivoFactoryManager extends AbstractServiceFactoryManager<TabActivoService> implements TabActivoFactoryApi {

}
