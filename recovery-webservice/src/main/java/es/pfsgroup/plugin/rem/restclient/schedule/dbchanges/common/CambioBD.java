package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class CambioBD implements Serializable {

	private static final long serialVersionUID = 5589867039700461941L;
	
	private final Log logger = LogFactory.getLog(getClass());

	private String[] configCambios;

	private Object[] datosHistoricos;

	private Object[] datosActuales;

	public CambioBD(String[] configCambios) {
		super();
		this.configCambios = configCambios;
	}

	public void setDatosHistoricos(Object[] datosHistoricos) {
		checkEstado();
		checkArray("datos históricos", datosHistoricos);
		this.datosHistoricos = datosHistoricos;
	}

	public void setDatosActuales(Object[] datosActuales) {
		checkEstado();
		checkArray("datos actuales", datosActuales);
		this.datosActuales = datosActuales;
	}

	public Map<String, Object> getCambios() {
		checkEstado();

		HashMap<String, Object> cambios = new HashMap<String, Object>();

		if (datosActuales != null) {
			for (int i = 0; i < datosActuales.length; i++) {
				Object datoActual = datosActuales[i];
				if ((datosHistoricos == null) || (!sonIguales(datoActual, datosHistoricos[i]))) {
					cambios.put(configCambios[i], datoActual);
				}
			}
		}else{
			logger.debug("'datosActuales' es nulo, devolvemos un Map vacío");
		}

		return cambios;
	}

	/**
	 * 
	 * @param datoActual
	 * @param datoHistorico
	 * @return
	 */
	private boolean sonIguales(Object datoActual, Object datoHistorico) {
		if (datoActual == null) {
			return (datoHistorico == null);
		}
		if (datoHistorico == null) {
			return false;
		}
		return datoActual.equals(datoHistorico);
	}

	private void checkArray(String arrayName, Object[] array) {
		if ((array == null) || (array.length != configCambios.length)) {
			throw new IllegalArgumentException(
					"El array de " + arrayName + " es NULL o no tiene los elementos esperados (se esperaban "
							+ configCambios.length + ") [" + array + "]");
		}
	}

	private void checkEstado() {
		if (configCambios == null) {
			throw new IllegalStateException("'configCambios' no puede ser NULL");
		}
	}

}
