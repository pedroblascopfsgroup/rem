package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessCompositeValidatorsAutowiredSupport;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidationFactory;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidators;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidatorsAutowiredSupport;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

/**
 * Factor�a de validadores de negocio con soporte de Spring.
 * <p>
 * Este bean no necesia ninguna configuraci�n ni inicializaci�n mediante XML. En
 * �l se dan de alta los validadores disponibles mediante el autowiring de
 * Spring.
 * 
 * @author bruno
 * 
 * PBO: Modificaciones para a�adir las capacidades de validadores compuestos.
 */
@Component
public class MSVBusinessValidationSpringAutowiredFactoryImpl implements MSVBusinessValidationFactory {
	
	@Autowired(required = false)
	private List<MSVBusinessValidatorsAutowiredSupport> validators;

	@Autowired(required = false)
	private List<MSVBusinessCompositeValidatorsAutowiredSupport> compositeValidators;

	@Override
	public MSVBusinessValidators getValidators(MSVDDOperacionMasiva tipoOperacion) {
		if (tipoOperacion == null){
			return null;
		}
		if (!Checks.estaVacio(validators)){
			for (MSVBusinessValidatorsAutowiredSupport v : validators){
				if (tipoOperacion.getCodigo().equals(v.getCodigoTipoOperacion())){
					return v;
				}
			}
			// Si no encuentra ninguno ..
			return null;
		}else{
			return null;
		}
	}

	@Override
	public MSVBusinessCompositeValidators getCompositeValidators(MSVDDOperacionMasiva tipoOperacion) {
		if (tipoOperacion == null){
			return null;
		}
		if (!Checks.estaVacio(compositeValidators)){
			for (MSVBusinessCompositeValidatorsAutowiredSupport v : compositeValidators){
				if (tipoOperacion.getCodigo().equals(v.getCodigoTipoOperacion())){
					return v;
				}
			}
			// Si no encuentra ninguno ..
			return null;
		}else{
			return null;
		}
	}

}
