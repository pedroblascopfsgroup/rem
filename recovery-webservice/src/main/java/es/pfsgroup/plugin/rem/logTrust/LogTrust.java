package es.pfsgroup.plugin.rem.logTrust;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;

@Service
public class LogTrust {

	protected static final Log logger = LogFactory.getLog(LogTrust.class);
	private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	private static final String SEPARADOR = ",";

	public enum REQUEST_STATUS_CODE {
		CODIGO_ESTADO_OK,
		CODIGO_ESTADO_KO,
		CODIGO_ESTADO_USUARIO_SIN_ACCESO
	}
	
	public enum ACCION_CODIGO {
		CODIGO_VER,
		CODIGO_MODIFICAR,
		CODIGO_ELIMINAR
	}
	
	public enum ENTIDAD_CODIGO {
		CODIGO_ACTIVO("activo"),
		CODIGO_TRABAJO("trabajo"),
		CODIGO_AGRUPACION("agrupacion");

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
	private GenericAdapter genericAdapter;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;


	/**
	 * Este método registra el suceso de acceso a una entidad.
	 *
	 * @param peticion: objeto de la petición web para obtener la llamada.
	 * @param idEntidad: ID de la entidad accedida.
	 * @param tabOrEvento: indica la tab o el evento de la entidad con el que se interacciona.
	 * @param accion: código de tipo de interaciión predefinido.
	 */
	public void registrarSuceso(HttpServletRequest peticion, Long idEntidad, ENTIDAD_CODIGO entidad, String tabOrEvento, ACCION_CODIGO accion) {
		this.obtenerInformacionDelEvento(peticion, entidad, idEntidad, accion, REQUEST_STATUS_CODE.CODIGO_ESTADO_OK, tabOrEvento);
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
		this.obtenerInformacionDelEvento(peticion, entidad, idEntidad, accion, codigoEstadoPeticion, tabOrEvento);
	}
	
	public void obtenerInformacionDelEvento(HttpServletRequest peticion, ENTIDAD_CODIGO entidad, Long idEntidad, ACCION_CODIGO accion, REQUEST_STATUS_CODE codigoEstadoPeticion, String tabOrEvento) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		Activo activo = activoApi.get(idEntidad);
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		String codigoCartera = "";
		String codigoCarteraActivo = "";

		if(!Checks.esNulo(activo.getCartera())) {
			codigoCarteraActivo = activo.getCartera().getCodigo();
		}
		
		
		if(!Checks.esNulo(usuarioCartera)){
			codigoCartera = usuarioCartera.getCartera().getCodigo();
		}
		
		// Montaje: fecha actual, diccionario acción, ruta url, usuario logueado, cartera usuario, codigo status petición, num o código entidad, código cartera entidad.
		// Ejemplo: 2018-06-14T17:15:24.109904,ver-bien,/pfs/rem-ver-bien,usuario33@pfs.es,,200,10066,04
		StringBuilder builder = new StringBuilder();
		builder.append(sdf.format(new Date()));
		builder.append(SEPARADOR);
		builder.append(this.obtenerStringCodigoAccion(entidad, accion, tabOrEvento));
		builder.append(SEPARADOR);
		builder.append(peticion.getRequestURI());
		builder.append(SEPARADOR);
		builder.append(usuarioLogado.getUsername());
		builder.append(SEPARADOR);
		builder.append(codigoCartera);
		builder.append(SEPARADOR);
		builder.append(this.obtenerStringCodigoEstado(codigoEstadoPeticion));
		builder.append(SEPARADOR);
		builder.append(activo.getNumActivo().toString());
		builder.append(SEPARADOR);
		builder.append(codigoCarteraActivo);
		
		this.registrarMensaje(builder.toString());
	}

	/**
	 * Este método recibe la variable constante del código de error y devuelve un literal con el número de
	 * estado de error.
	 *
	 * @param codigoEstado: enum de los códigos de estado.
	 * @return Devuelve un literal con el string del código de estado.
	 */
	private String obtenerStringCodigoEstado(REQUEST_STATUS_CODE codigoEstadoPeticion) {
		switch(codigoEstadoPeticion) {
			case CODIGO_ESTADO_OK:
				return "200";
			case CODIGO_ESTADO_KO:
				return "500";
			case CODIGO_ESTADO_USUARIO_SIN_ACCESO:
				return "403";
			default:
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

	/**
	 * Este método recibe una cadena de texto y lo direcciona al log4j.
	 *
	 * @param mensaje: texto que se direcciona al log4j.
	 */
	private void registrarMensaje(String mensaje) {
		logger.info(mensaje);
	}
}
