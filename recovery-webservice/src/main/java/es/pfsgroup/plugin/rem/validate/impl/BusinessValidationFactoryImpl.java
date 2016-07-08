package es.pfsgroup.plugin.rem.validate.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.BusinessValidationFactory;
import es.pfsgroup.plugin.rem.validate.BusinessValidators;

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
public class BusinessValidationFactoryImpl implements BusinessValidationFactory {
	
	@Autowired(required = false)
	private List<BusinessValidators> validators;

	@Override
	public List<BusinessValidators> getValidators(DDTipoAgrupacion tipoAgrupacion) {
		
		List<BusinessValidators> lista = new ArrayList<BusinessValidators>();

		if (!Checks.estaVacio(validators)){
			for (BusinessValidators v : validators){
				if (v.usarValidator(tipoAgrupacion.getCodigo())){
					lista.add(v);
				}
			}
		}				
		return lista;
	}

}
