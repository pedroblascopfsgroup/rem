package es.pfsgroup.plugin.rem.logTrust;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCodigoEstadoPeticion;

@Service
public class LogTrustEvento extends LogTrust {

	public enum REQUEST_STATUS_CODE {
		CODIGO_ESTADO_OK("200"),
		CODIGO_ESTADO_KO("500"),
		CODIGO_ESTADO_USUARIO_SIN_ACCESO("403");
		
		private final String text;

		REQUEST_STATUS_CODE(final String text) {
	        this.text = text;
	    }

	    @Override
	    public String toString() {
	        return text;
	    }
	}

	public enum ACCION_CODIGO {
		CODIGO_VER,
		CODIGO_MODIFICAR,
		CODIGO_ELIMINAR
	}

	public enum ENTIDAD_CODIGO {
		CODIGO_ACTIVO("activo"),
		CODIGO_TRABAJO("trabajo"),
		CODIGO_AGRUPACION("agrupacion"),
		CODIGO_EXPEDIENTE_COMERCIAL("expediente"),
		CODIGO_PROVEEDOR("proveedor"),
		CODIGO_GASTOS_PROVEEDOR("gastosProveedor"),
		CODIGO_TRAMITE("tramite");

	    private final String text;

	    ENTIDAD_CODIGO(final String text) {
	        this.text = text;
	    }

	    @Override
	    public String toString() {
	        return text;
	    }
	}

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	public LogTrustEvento() {
		super();
		logTrustLogger = LogFactory.getLog(LogTrustEvento.class);
	}

	/**
	 * Este método registra el suceso de acceso a una entidad.
	 *
	 * @param peticion: objeto de la petición web para obtener la llamada.
	 * @param idEntidad: ID de la entidad accedida.
	 * @param tabOrEvento: indica la tab o el evento de la entidad con el que se interacciona.
	 * @param accion: código de tipo de interación predefinido.
	 */
	public void registrarSuceso(HttpServletRequest peticion, Long idEntidad, ENTIDAD_CODIGO entidad, String tabOrEvento, ACCION_CODIGO accion) {
		//this.obtenerInformacionDelEvento(peticion, entidad, idEntidad, accion, REQUEST_STATUS_CODE.CODIGO_ESTADO_OK, tabOrEvento);
	}
	
	/**
	 * Este método registra el suceso erroneo de acceso a una entidad.
	 *
	 * @param peticion: objeto de la petición web para obtener la llamada.
	 * @param idEntidad: ID de la entidad accedida.
	 * @param tabOrEvento: indica la tab o el evento de la entidad con el que se interacciona.
	 * @param accion: código de tipo de interaciión predefinido.
	 * @param codigoEstadoPeticion: código de error predefinido.
	 */
	public void registrarError(HttpServletRequest peticion, Long idEntidad, ENTIDAD_CODIGO entidad, String tabOrEvento, ACCION_CODIGO accion, REQUEST_STATUS_CODE codigoEstadoPeticion) {
		//this.obtenerInformacionDelEvento(peticion, entidad, idEntidad, accion, codigoEstadoPeticion, tabOrEvento);
	}

	/**
	 * Este método obtiene los datos del activo y los junta con el resto para montar un registro para LogTrust.
	 *
	 * @param peticion: objeto de la petición web para obtener la llamada.
	 * @param entidad: indica el tipo de entidad al que se hace referéncia en el log.
	 * @param idEntidad: ID de la entidad accedida.
	 * @param accion: código de tipo de interaciión predefinido.
	 * @param codigoEstadoPeticion: código de error predefinido.
	 * @param tabOrEvento: indica la tab o el evento de la entidad con el que se interacciona.
	 */
	private void obtenerInformacionDelEvento(HttpServletRequest peticion, ENTIDAD_CODIGO entidad, Long idEntidad, ACCION_CODIGO accion, REQUEST_STATUS_CODE codigoEstadoPeticion, String tabOrEvento) {

		long time = System.currentTimeMillis();
		
		Activo activo = null;
		String carteraActivo = "";
		
		StringBuilder builder = new StringBuilder();
		builder.append(sdf.format(new Date()));
		builder.append(SEPARADOR);
		builder.append(this.obtenerStringCodigoAccion(entidad, accion, tabOrEvento));
		builder.append(SEPARADOR);
		builder.append(peticion.getRequestURI());
		builder.append(SEPARADOR);
		builder.append(getUsernameUsuarioLogueado());
		builder.append(SEPARADOR);
		builder.append(getDescripcionesCarterasUsuarioLogueado());
		builder.append(SEPARADOR);
		builder.append(this.obtenerStringCodigoEstado(codigoEstadoPeticion));
		builder.append(SEPARADOR);
				
		switch(entidad){
			case CODIGO_ACTIVO:
				activo = activoApi.get(idEntidad);
				builder.append(ENTIDAD_CODIGO.CODIGO_ACTIVO);
				break;
			case CODIGO_TRABAJO:
				Trabajo trabajo = trabajoApi.findOne(idEntidad);
				activo = trabajo.getActivo();
				builder.append(ENTIDAD_CODIGO.CODIGO_TRABAJO);
				break;
			case CODIGO_AGRUPACION:
				ActivoAgrupacionActivo activoAgrupacion;
				activoAgrupacion = activoAgrupacionActivoApi.getActivoAgrupacionActivoPrincipalByIdAgrupacion(idEntidad);
				
				if(Checks.esNulo(activoAgrupacion)) {
					activoAgrupacion = activoAgrupacionActivoApi.primerActivoPorActivoAgrupacion(idEntidad);
				}
				
				activo = activoAgrupacion.getActivo();
				builder.append(ENTIDAD_CODIGO.CODIGO_AGRUPACION);
				break;
			case CODIGO_EXPEDIENTE_COMERCIAL:
				ExpedienteComercial expediente = expedienteComercialApi.findOne(idEntidad);
				activo = expediente.getOferta().getActivoPrincipal();
				builder.append(ENTIDAD_CODIGO.CODIGO_EXPEDIENTE_COMERCIAL);
				break;
			case CODIGO_PROVEEDOR:
				activo = activoApi.getActivoByIdProveedor(idEntidad);
				builder.append(ENTIDAD_CODIGO.CODIGO_PROVEEDOR);
				break;
			case CODIGO_GASTOS_PROVEEDOR:
				activo = activoApi.getActivoByIdGastoProveedor(idEntidad);
				builder.append(ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR);
				break;
			case CODIGO_TRAMITE:
				ActivoTramite activoTramite = activoTramiteApi.get(idEntidad);
				activo = activoTramite.getActivo();
				builder.append(ENTIDAD_CODIGO.CODIGO_TRAMITE);
				break;
			default:
				break;
		}
		
		if(activo != null && !Checks.esNulo(activo.getCartera())) {
			carteraActivo = activo.getCartera().getDescripcion();
		}
		
		builder.append(SEPARADOR);		
		builder.append(carteraActivo);
		builder.append(SEPARADOR);
		builder.append(peticion.getServerName());
		builder.append(SEPARADOR);
		builder.append(System.currentTimeMillis() - time);
		
		registrarMensaje(builder.toString());
	}

	/**
	 * Este método recibe la variable constante del código de error y devuelve un literal con el estado de error.
	 *
	 * @param codigoEstado: enum de los códigos de estado.
	 * @return Devuelve un literal con el string del código de estado.
	 */
	private String obtenerStringCodigoEstado(REQUEST_STATUS_CODE codigoEstadoPeticion) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoPeticion.toString());
		DDCodigoEstadoPeticion codEstadoPeticion = genericDao.get(DDCodigoEstadoPeticion.class, filtro);
		
		if(!Checks.esNulo(codEstadoPeticion)) {
			return codEstadoPeticion.getDescripcion();
		} else {
			return "ERR";
		}
	}
	
	/**
	 * Este método monta el string de código de acción cometida durante el registro.
	 *
	 * @param accion: indica el tipo de acción.
	 * @param tabOrEvento: indica que pestaña o evento se ha solicitado.
	 * @return Devuelve un literal que simboliza la acción del registro.
	 */
	private String obtenerStringCodigoAccion(ENTIDAD_CODIGO entidad, ACCION_CODIGO accion, String tabOrEvento) {
		switch(accion) {
			case CODIGO_VER:
				return "ver-".concat(entidad.toString()).concat("-").concat(tabOrEvento);
			case CODIGO_MODIFICAR:
				return "modificar-".concat(entidad.toString()).concat("-").concat(tabOrEvento);
			case CODIGO_ELIMINAR:
				return "eliminar-".concat(entidad.toString()).concat("-").concat(tabOrEvento);
			default:
				return "ERR";
		}
	}
}
