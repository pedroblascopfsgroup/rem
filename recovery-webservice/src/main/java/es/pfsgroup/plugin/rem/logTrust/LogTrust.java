package es.pfsgroup.plugin.rem.logTrust;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.usuarioRem.UsuarioRemApi;
import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

class LogTrust {
	protected Log logTrustLogger;
	protected static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	protected static final String SEPARADOR = ",";
	
	@Autowired
	protected UsuarioApi usuarioApi;

	@Autowired
	protected GenericABMDao genericDao;

	@Autowired
	private UsuarioRemApi usuarioRemApi;
	
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
	 * Este método obtiene los códigos de las carteras del usuario logueado (si el usuario está carterizado).
	 *
	 * @return Devuelve una lista con el código de cartera del usuario logueado, o una lista vacía si el usuario no está carterizado.
	 */
	protected List<String> getCodigosCarterasUsuarioLogueado() {
		Usuario usuarioLogueado = usuarioApi.getUsuarioLogado();

		return usuarioRemApi.getCodigosCarterasUsuario(null, usuarioLogueado);
	}
	
	/**
	* Este método obtiene los normbres de las carteras del usuario logueado (si el usuario está carterizado).
	*
	* @return Devuelve una lista con los nombres de las carteras del usuario logueado, o una lista vacía si el usuario no está carterizado.
	*/
	protected List<String> getDescripcionesCarterasUsuarioLogueado() {
		List<String> descripcionesCarterasUsuarioLogado = new ArrayList<String>();
		List<String> codigosCarteras = getCodigosCarterasUsuarioLogueado();

		for (String codigoCartera : codigosCarteras) {
			DDCartera cartera = genericDao.get(DDCartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoCartera));

			if(!Checks.esNulo(cartera))
				descripcionesCarterasUsuarioLogado.add(cartera.getDescripcion());
		}

		return descripcionesCarterasUsuarioLogado;
	}
}
