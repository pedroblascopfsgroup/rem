package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.context.SecurityContextHolder;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.model.DestinatariosRest;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
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
@SuppressWarnings("rawtypes")
public abstract class DetectorCambiosBD<T extends WebcomRESTDto>
		implements InfoTablasBD, Comparable<DetectorCambiosBD> {

	private static final String DTO_CLASS_NO_PUEDE_SER_NULL = "'dtoClass' no puede ser NULL";

	private static interface DataAccessOperation {
		public CambiosList getDatabaseChanges();
	}

	@Autowired
	private CambiosBDDao dao;

	@Autowired
	private RestApi restApi;

	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Obtener el peso del handler. A mayor peso antes se ejecutará
	 * 
	 * @return
	 */
	protected abstract Integer getWeight();

	/**
	 * Permite activar y desactivar el envio del servicio
	 * 
	 * @return
	 */
	public abstract boolean isActivo();

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
	 * @param registro
	 *            Objeto en el que se irá dejando trazas de tiempos de
	 *            ejecución. Puede ser NULL si no queremos dejar ninguna traza.
	 * @throws ErrorServicioWebcom
	 */
	public abstract void invocaServicio(List<T> data, RestLlamada registro) throws ErrorServicioWebcom;
	
	
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
	 * @param registro
	 *            Objeto en el que se irá dejando trazas de tiempos de
	 *            ejecución. Puede ser NULL si no queremos dejar ninguna traza.
	 * 
	 * @return Este método devolverá NULL si el parámetro dtoClass no coincide
	 *         con el DTO asociado al detector.
	 */
	public CambiosList listPendientes(Class<?> dtoClass, RestLlamada registro, CambiosList listPendientes) {
		if (dtoClass == null) {
			throw new IllegalArgumentException(DTO_CLASS_NO_PUEDE_SER_NULL);
		}

		final CambiosList cambios = dao.listCambios(dtoClass, this, registro, listPendientes);
			if (cambios != null) {
			cambios.setPaginacion(listPendientes.getPaginacion());
	
			return extractDtos(dtoClass, new DataAccessOperation() {
				@Override
				public CambiosList getDatabaseChanges() {
					return cambios;
				}
			});
		} else {
			return null;
		}

	}

	public CambiosList listDatosCompletos(Class<?> dtoClass, RestLlamada registro, CambiosList listPendientes) {

		if (dtoClass == null) {
			throw new IllegalArgumentException(DTO_CLASS_NO_PUEDE_SER_NULL);
		}

		final CambiosList cambios = dao.listDatosActuales(dtoClass, this, registro, listPendientes);
		cambios.setPaginacion(listPendientes.getPaginacion());

		return extractDtos(dtoClass, new DataAccessOperation() {
			@Override
			public CambiosList getDatabaseChanges() {
				return cambios;
			}
		});

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
	 * @param registro
	 *            Objeto en el que se irá dejando trazas de tiempos de
	 *            ejecución. Puede ser NULL si no queremos dejar ninguna traza.
	 */
	public void marcaComoEnviados(Class<?> dtoClass, List<RestLlamada> registro) {
		if (dtoClass == null) {
			throw new IllegalArgumentException(DTO_CLASS_NO_PUEDE_SER_NULL);
		}

		if (dtoClass.equals(getDtoClass())) {
			dao.marcaComoEnviados(dtoClass, this, registro);
		} else {
			logger.warn("No coincide la clase con el DTO asociado al detctor. Se esperaba " + getDtoClass().getName()
					+ " pero se ha especificado " + dtoClass.getName());
			logger.warn(
					"Esto puede significar que no se está usando el handler correcto, por lo tanto no se van a marcar los registros de BD como enviados.");
		}

	}
	
	public void marcarComoEnviadosMarcadosComun(CambiosList listPendientes,Class<?> dtoClass) throws Exception{
		dao.marcarComoEnviadosMarcadosComun(listPendientes, this, dtoClass);
	}
	

	/**
	 * Devuelve la clase que implementa el DTO asociado al detector de cambios.
	 * Este método se usa para como método de control para verificar que
	 * ejecutamos el método listPendientes() sobre el handler apropiado.
	 * 
	 * @return
	 */
	public Class<?> getDtoClass() {
		return this.createDtoInstance().getClass();
	}

	/**
	 * A mas peso mayor es el handler
	 */
	public int compareTo(DetectorCambiosBD o) {
		return o.getWeight().compareTo(getWeight());
	}

	/**
	 * Actualiza la vista materializada
	 */
	public void actualizarVistaMaterializada() {
		this.actualizarVistaMaterializada(null);
	}

	/**
	 * Actualiza la vista materializada
	 */
	public void actualizarVistaMaterializada(RestLlamada registro) {
		dao.refreshMaterializedView(this);
		if (registro != null) {
			registro.logTiempoRefrescoVista();
		}
	}

	private CambiosList extractDtos(Class<?> dtoClass, DataAccessOperation dao) {
		if (dao == null) {
			throw new IllegalArgumentException("Data Access Operation is not defined");
		}
		if (dtoClass.equals(getDtoClass())) {
			CambiosList listCambios = dao.getDatabaseChanges();

			CambiosList listaCambios = new CambiosList(null);
			listaCambios.setPaginacion(listCambios.getPaginacion());

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
				for (Object cambio : listCambios) {
					try {
						if (logger.isDebugEnabled()) {
							logger.trace("Obtenemos los cambios registros cambiados en BD");
						}
						Map<String, Object> camposActualizados = ((CambioBD) cambio).getCambios();
						if (!camposActualizados.isEmpty()) {

							// Obtenemos el contenido que debe tener el DTO
							Map<String, Object> datos = ((CambioBD) cambio)
									.getValoresHistoricos(WebcomRequestUtils.camposObligatorios(dtoClass));
							datos.putAll(camposActualizados);

							if (fusionCambios == null) {
								// Poblamos directamente el DTO y lo añadimos a
								// la
								// lista
								T dto = creaYRellenaDto(dtoClass, datos);
								listaCambios.add(dto);
							} else {
								// Dejamos el poblado del DTO al fusionador de
								// cambios
								fusionCambios.addDataMap(datos);
							}
						} else if (logger.isDebugEnabled()) {
							logger.trace("Map de cambios vacío, nada que notificar");
						}
					} catch (Exception e) {
						logger.error("Error gestionando la fusion de cambios en DetectorCambiosBD", e);
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
	private FusionCambios necesitaFusionarCambios(Class<?> dtoClass) {
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

	private T creaYRellenaDto(Class<?> dtoClass, Map<String, Object> datos) {
		T dto = createDtoInstance();
		logger.trace("Relenamos el dto " + dtoClass + " con " + datos);
		Converter.updateObjectFromHashMap(datos, dto, null);
		return dto;
	}

	/**
	 * Configura el contexto hibernate
	 * 
	 * @param workingCode
	 * @throws Exception
	 */
	public void setdbContext() throws Exception {
		restApi.doSessionConfig();
	}

	/**
	 * Cierra la sesion
	 */
	public void closeSession() {
		SecurityContextHolder.clearContext();
	}

	/**
	 * Devuelve true si la apirest esta cerrada
	 * 
	 * @return
	 */
	public boolean isApiRestCerrada() {
		boolean restLocked = false;
		if (servletContext.getAttribute(RestApi.REST_API_WEBCOM) != null
				&& ((Boolean) servletContext.getAttribute(RestApi.REST_API_WEBCOM))
				|| (servletContext.getAttribute(RestApi.REST_API_ENVIAR_CAMBIOS) != null
						&& (Boolean) servletContext.getAttribute(RestApi.REST_API_ENVIAR_CAMBIOS))) {
			restLocked = true;
		}
		return restLocked;
	}
	
	/**
	 * Borra de la tabla de modificaciones aquellas que se han enviado
	 * @param listPendientes
	 */
	public  void marcarComoEnviadosMarcadosEspecifico(Date fechaEjecucion) throws Exception{
		//para sobreescribir
	}
	
	public void setSoloCambiosMarcados(Boolean procesar){
		//para sobreescribir
	}
	
	/**
	 * Envia un correo con el error del detector de cambios
	 */
	public void eviarCorreoErrorDC(String message){
		List<String> destinatarios = getDestinatariosDetectorCambios();
		
		if (Checks.estaVacio(destinatarios)) {
			throw new IllegalArgumentException("No se ha encontrado destinatarios para la notificación. ");
		}
		
		List<String> mailsCC = new ArrayList<String>();
		String asunto = "[Detector Cambios] Error en el detector de cambios";
		String cuerpo = "<p>" + message + "</p>";
		
		genericAdapter.sendMail(destinatarios, mailsCC, asunto, cuerpo);
	}
	
	public List<String> getDestinatariosDetectorCambios(){
		List<DestinatariosRest> destinatariosRest = genericDao.getList(DestinatariosRest.class);
		List<String> destinatarios = new ArrayList<String>();
		if (!Checks.estaVacio(destinatariosRest)){
			for (DestinatariosRest dRest : destinatariosRest){
				destinatarios.add(dRest.getCorreo());
			}
		}
		return destinatarios;
	}
}
