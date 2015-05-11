package es.pfsgroup.plugin.recovery.masivo.factories.impl;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.recovery.masivo.api.MSVLoteGeneratorApi;
import es.pfsgroup.plugin.recovery.masivo.factories.MSVLoteGeneratorFactory;
import es.pfsgroup.recovery.geninformes.factories.imp.GENGenericFactoryImpl;

/**
 * Implementaci�n de la factoria del generador de n�meros lotes.
 * 
 * @author manuel
 *
 */
@Component
public class MSVLoteGeneratorFactoryImpl <T> extends GENGenericFactoryImpl<MSVLoteGeneratorApi> implements  MSVLoteGeneratorFactory{


}
