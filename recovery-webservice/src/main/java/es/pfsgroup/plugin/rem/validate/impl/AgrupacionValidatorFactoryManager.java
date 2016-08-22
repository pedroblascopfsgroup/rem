package es.pfsgroup.plugin.rem.validate.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.genericService.api.impl.AbstractServiceFactoryManager;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidatorFactoryApi;

@Component
public class AgrupacionValidatorFactoryManager extends AbstractServiceFactoryManager<AgrupacionValidator> implements AgrupacionValidatorFactoryApi {

}
