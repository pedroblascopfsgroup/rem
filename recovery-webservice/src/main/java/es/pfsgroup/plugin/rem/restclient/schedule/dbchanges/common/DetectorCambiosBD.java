package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;

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
	 */
	public abstract void invocaServicio(List<T> data);

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
				for (CambioBD cambio : listCambios) {
					logger.debug("Obtenemos los cambios registros cambiados en BD");
					Map<String, Object> camposActualizados = cambio.getCambios();
					if (!camposActualizados.isEmpty()) {
						T dto = createDtoInstance();
						Map<String, Object> datos = cambio.getValoresHistoricos(camposObligatorios(dto));
						logger.debug("Valores historicos: " + datos);
						logger.debug("Campos actualizados: " + camposActualizados);
						datos.putAll(camposActualizados);
						logger.debug("Relenamos el dto "+ dto.getClass() + " con " + camposActualizados );
						Converter.updateObjectFromHashMap(datos, dto, null);
						listaCambios.add(dto);
					} else {
						logger.debug("Map de cambios vacío, nada que notificar");
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
	 * Devuelve una lista de campos marcados como obligatorios mediante la anotacion @WebcomRequired en el DTO.
	 * @param dto
	 * @return
	 */
	private String[] camposObligatorios(T dto) {
		ArrayList<String> result = new ArrayList<String>();
		Field[] fields = dto.getClass().getDeclaredFields();
		if (fields != null){
			for (Field f : fields){
				if (f.getAnnotation(WebcomRequired.class) != null){
					result.add(f.getName());
				}
			}
		}
		
		return result.toArray(new String[]{});
	}

}
