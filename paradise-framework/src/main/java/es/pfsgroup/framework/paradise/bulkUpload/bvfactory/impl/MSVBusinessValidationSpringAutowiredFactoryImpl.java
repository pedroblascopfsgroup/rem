package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidatorsAutowiredSupport;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationFactory;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidatorsAutowiredSupport;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;

/**
 * Factoría de validadores de negocio con soporte de Spring.
 * <p>
 * Este bean no necesia ninguna configuración ni inicialización mediante XML. En
 * él se dan de alta los validadores disponibles mediante el autowiring de
 * Spring.
 * 
 * @author bruno
 * 
 * PBO: Modificaciones para añadir las capacidades de validadores compuestos.
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
