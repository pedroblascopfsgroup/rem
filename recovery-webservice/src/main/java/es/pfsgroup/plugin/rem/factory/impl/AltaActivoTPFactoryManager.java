package es.pfsgroup.plugin.rem.factory.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.factory.AltaActivoTPFactoryApi;
import es.pfsgroup.plugin.rem.genericService.api.impl.AbstractServiceFactoryManager;
import es.pfsgroup.plugin.rem.service.AltaActivoThirdPartyService;

@Component
public class AltaActivoTPFactoryManager extends AbstractServiceFactoryManager<AltaActivoThirdPartyService> implements AltaActivoTPFactoryApi{

}
