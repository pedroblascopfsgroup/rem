package es.pfsgroup.plugin.rem.factory.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.factory.GenerarPropuestaPreciosFactoryApi;
import es.pfsgroup.plugin.rem.genericService.api.impl.AbstractServiceFactoryManager;
import es.pfsgroup.plugin.rem.propuestaprecios.service.GenerarPropuestaPreciosService;

@Component
public class GenerarPropuestaPreciosFactoryManager extends AbstractServiceFactoryManager<GenerarPropuestaPreciosService> implements GenerarPropuestaPreciosFactoryApi {

}
