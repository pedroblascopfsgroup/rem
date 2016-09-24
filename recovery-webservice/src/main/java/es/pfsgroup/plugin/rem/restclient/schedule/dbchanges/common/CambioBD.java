package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;

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
		} else {
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
		if ((array == null) || (array.length < configCambios.length)) {
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

	public Map<String, Object> getValoresHistoricos(String... camposObligatorios) {
		HashMap<String, Object> valores = new HashMap<String, Object>();

		ArrayList<String> missing = new ArrayList<String>();

		if (camposObligatorios != null) {
			for (String campo : camposObligatorios) {
				int pos = WebcomRequestUtils.buscarEnArray(configCambios, campo);
				if (pos >= 0) {
					if (pos < datosHistoricos.length) {
						valores.put(campo, datosHistoricos[pos]);
					} else {
						missing.add(campo + " (pos=" + pos + ": excede array])");
					}
				} else {
					missing.add(campo);
				}
			}
		}

		if (!missing.isEmpty()) {
			StringBuilder detalle = new StringBuilder();
			for (String c : missing) {
				detalle.append("[").append(c).append("] ");
			}
			detalle.append("]");
			throw new IllegalArgumentException(
					"Estos campos obligatorios no se han podido encontrar: " + detalle.toString());
		}

		return valores;
	}

}
