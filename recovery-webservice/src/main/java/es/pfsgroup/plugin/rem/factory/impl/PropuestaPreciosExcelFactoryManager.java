package es.pfsgroup.plugin.rem.factory.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.factory.PropuestaPreciosExcelFactoryApi;
import es.pfsgroup.plugin.rem.genericService.api.impl.AbstractServiceFactoryManager;
import es.pfsgroup.plugin.rem.service.PropuestaPreciosExcelService;

@Component
public class PropuestaPreciosExcelFactoryManager extends AbstractServiceFactoryManager<PropuestaPreciosExcelService> implements PropuestaPreciosExcelFactoryApi {

}
