package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;

/**
 * Clase abstracta para desarrollar detectores de cambios.
 * 
 * Para desarrollar un nuevo detecor de cambios debes implementar cada uno de
 * los métodos tal y como se indica en el javadoc de los mismos.
 * 
 * Esta clase implementa {@link InfoTablasBD}, de modo que las clases hijas
 * deben sobreescribir los métodos definidos en la interfaz para indicar cuales
 * tablas de BD deben consultarse para obtener los cambios.
 * 
 * @author bruno
 *
 * @param <T>
 *            Tipo del DTO asociado a este detector de cambios, es decir, que se
 *            va a usar para invocar al servicio
 */
public abstract class DetectorCambiosBD<T extends WebcomRESTDto> implements InfoTablasBD {

	@Autowired
	private CambiosBDDao dao;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Implementa este método en cada detector simplemente haciendo un 'new' que
	 * devuelva una instancia vacía del DTO.
	 * 
	 * @return
	 */
	protected abstract T createDtoInstance();

	/**
	 * Este método contiene la lógica para invocar al srvicio REST de Webcom
	 * 
	 * @param data
	 *            Lista de DTO's que se queren mandar al servicio.
	 * @throws ErrorServicioWebcom
	 */
	public abstract void invocaServicio(List<T> data) throws ErrorServicioWebcom;

	/**
	 * Devuelve la lisa de cambios detectados ya convertidos al DTO
	 * correspondiente.
	 * 
	 * @param dtoClass
	 *            que implementa el DTO asociado a este detector de cambios.
	 *            Este parámetro debe pasársele al método como control de que
	 *            esamos invocando el handler correcto. Para ello, la clase que
	 *            invoca ester método debe obtener este valor usando el método
	 *            getDtoClass()
	 * 
	 * @return Este método devolverá NULL si el parámetro dtoClass no coincide
	 *         con el DTO asociado al detector.
	 */
	public List<T> listPendientes(Class dtoClass) {
		if (dtoClass == null) {
			throw new IllegalArgumentException("'dtoClass' no puede ser NULL");
		}

		if (dtoClass.equals(getDtoClass())) {
			List<CambioBD> listCambios = dao.listCambios(dtoClass, this);

			List<T> listaCambios = new ArrayList<T>();

			if (listCambios != null) {

				/*
				 * Si el DTO contiene la anotación @NestedDto quiere decir que
				 * deberemso fusionar varios cambios en un mismo dto.
				 * 
				 * Si fusionCambios != null quiere decir que deberemos fusionar
				 * cambios
				 */
				FusionCambios fusionCambios = necesitaFusionarCambios(dtoClass);

				// main loop
				for (CambioBD cambio : listCambios) {
					logger.debug("Obtenemos los cambios registros cambiados en BD");
					Map<String, Object> camposActualizados = cambio.getCambios();
					if (!camposActualizados.isEmpty()) {

						// Obtenemos el contenido que debe tener el DTO
						Map<String, Object> datos = cambio
								.getValoresHistoricos(WebcomRequestUtils.camposObligatorios(dtoClass));
						logger.debug("Valores historicos: " + datos);
						logger.debug("Campos actualizados: " + camposActualizados);
						datos.putAll(camposActualizados);

						if (fusionCambios == null) {
							// Poblamos directamente el DTO y lo añadimos a la
							// lista
							T dto = creaYRellenaDto(dtoClass, datos);
							listaCambios.add(dto);
						} else {
							// Dejamos el poblado del DTO al fusionador de
							// cambios
							fusionCambios.addDataMap(datos);
						}
					} else {
						logger.debug("Map de cambios vacío, nada que notificar");
					}
				} // fin main loop

				// Si era necesario fusionar los cambios obtenemos ahora el
				// resultado
				if ((fusionCambios != null) && (fusionCambios.contieneDatos())) {
					for (Map<String, Object> map : fusionCambios) {
						T dto = creaYRellenaDto(dtoClass, map);
						listaCambios.add(dto);
					}
				}
			}
			return listaCambios;
		} else {
			logger.warn("No coincide la clase con el DTO asociado al detctor. Se esperaba " + getDtoClass().getName()
					+ " pero se ha especificado " + dtoClass.getName());
			logger.warn(
					"Esto puede significar que no se está usando el handler correcto, por lo tanto no se van a devolver resultados.");
			return null;
		}

	}

	/**
	 * Marca los registros de BD como enviados.
	 * 
	 * @param dtoClass
	 *            que implementa el DTO asociado a este detector de cambios.
	 *            Este parámetro debe pasársele al método como control de que
	 *            esamos invocando el handler correcto. Para ello, la clase que
	 *            invoca ester método debe obtener este valor usando el método
	 *            getDtoClass()
	 */
	public void marcaComoEnviados(Class dtoClass) {
		if (dtoClass == null) {
			throw new IllegalArgumentException("'dtoClass' no puede ser NULL");
		}

		if (dtoClass.equals(getDtoClass())) {
			dao.marcaComoEnviados(dtoClass, this);
		} else {
			logger.warn("No coincide la clase con el DTO asociado al detctor. Se esperaba " + getDtoClass().getName()
					+ " pero se ha especificado " + dtoClass.getName());
			logger.warn(
					"Esto puede significar que no se está usando el handler correcto, por lo tanto no se van a marcar los registros de BD como enviados.");
		}

	}

	/**
	 * Devuelve la clase que implementa el DTO asociado al detector de cambios.
	 * Este método se usa para como método de control para verificar que
	 * ejecutamos el método listPendientes() sobre el handler apropiado.
	 * 
	 * @return
	 */
	public Class getDtoClass() {
		return this.createDtoInstance().getClass();
	}

	/**
	 * Si dtoClass contiene la anotación @NestedDto en su definición
	 * necesitaremos fusionar los cambios.
	 * <p>
	 * Devolvemos una instancia del {@link FusionCambios} si necesitamos
	 * fusionar o NULL en caso contrario
	 * </p>
	 * 
	 * @param dtoClass
	 * @return
	 */
	private FusionCambios necesitaFusionarCambios(Class dtoClass) {
		List<Field> containers = new ArrayList<Field>();
		for (Field f : dtoClass.getDeclaredFields()) {
			NestedDto nested = f.getAnnotation(NestedDto.class);
			if (nested != null) {
				containers.add(f);
			}
		}
		if (containers.isEmpty()) {
			return null;
		} else {
			return new FusionCambios(containers);
		}
	}

	private T creaYRellenaDto(Class dtoClass, Map<String, Object> datos) {
		T dto = createDtoInstance();
		logger.debug("Relenamos el dto " + dtoClass + " con " + datos);
		Converter.updateObjectFromHashMap(datos, dto, null);
		return dto;
	}
}
