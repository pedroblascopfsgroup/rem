package es.pfsgroup.plugin.recovery.masivo.test.utils.impl;

import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;

/**
 * Validador dummy que usaremos para los casos de prueba de validación de negocio
 * @author bruno
 *
 */
public class DummyColumnValidator implements MSVColumnValidator {
	
	private boolean debeValidar;

	/**
	 * Crea un validador Dummy
	 * @param debeValidar Si es true este validador dirá que la columna valida, si es false no valida
	 */
	public DummyColumnValidator(boolean debeValidar) {
		this.debeValidar = debeValidar;
	}

	public Boolean isValid() {
		return new Boolean(debeValidar);
	}

	@Override
	public String getTipoValidacion() {
		return "DUMMY";
	}

	@Override
	public String getErrorMessage() {
		return "DUMMY";
	}

	@Override
	public boolean isRequired() {
		// Nos da igual esto
		return false;
	}

	@Override
	public Map<Integer, MSVResultadoValidacionSQL> getResultConfig() {
		// Nos da igual esto
		return null;
	}

}
