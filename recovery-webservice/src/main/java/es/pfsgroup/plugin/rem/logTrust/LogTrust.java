package es.pfsgroup.plugin.rem.logTrust;

import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

class LogTrust {
	protected Log logTrustLogger;
	protected static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	protected static final String SEPARADOR = ",";
	
	@Autowired
	protected UsuarioApi usuarioApi;

	@Autowired
	protected GenericABMDao genericDao;
	
	/**
	 * Este método recibe una cadena de texto y lo direcciona al log4j.
	 * Se utiliza el nivel 'info' para lanzar el registro.
	 *
	 * @param mensaje: texto que se direcciona al log4j.
	 */
	protected void registrarMensaje(String mensaje) {
		logTrustLogger.info(mensaje);
	}
	
	/**
	 * Este método devuelve el username del usuario logueado.
	 *
	 * @return Devuelve un literal con el username.
	 */
	protected String getUsernameUsuarioLogueado() {
		return usuarioApi.getUsuarioLogado().getUsername();
	}
	
	/**
	 * Este método obtiene el código de la cartera del usuario logueado (si el usuario está carterizado).
	 *
	 * @return Devuelve un literal con el código de cartera del usuario logueado, o vacío si el usuario no está carterizado.
	 */
	protected String getCodigoCarteraUsuarioLogueado() {
		Usuario usuarioLogueado = usuarioApi.getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogueado.getId()));

		if(!Checks.esNulo(usuarioCartera)){
			return usuarioCartera.getCartera().getCodigo();
		}

		return "";
	}
	
	/**
	* Este método obtiene el nombre de la cartera del usuario logueado (si el usuario está carterizado).
	*
	* @return Devuelve un literal con el nombre de cartera del usuario logueado, o vacío si el usuario no está carterizado.
	*/
	protected String getDescripcionCarteraUsuarioLogueado() {
		String codigoCartera = getCodigoCarteraUsuarioLogueado();
		
		DDCartera cartera = genericDao.get(DDCartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoCartera));
		
		if(!Checks.esNulo(cartera)){
			return cartera.getDescripcion();
		}
	
		return "";
	}
}
