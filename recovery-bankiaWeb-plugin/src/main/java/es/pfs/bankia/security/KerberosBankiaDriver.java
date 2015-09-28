package es.pfs.bankia.security;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.pfs.security.KerberosDriver;
import es.cm.arq.sd.seguridad.Asignacion;
import es.cm.arq.sd.seguridad.GestionSSA;
import es.cm.arq.sd.seguridad.SSAException;

/**
 * 
 * Clase que acceder� al LDAP de Bankia para obtener los perfiles (funciones/asignaciones) del usuario
 * @author pedro
 *
 */
public class KerberosBankiaDriver implements KerberosDriver {

	private static final String TIPO_APLICACION_PFS = "PF";
	private static final String TIPO_FUNCION_CLASICA = "CLASICA";
	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public List<String> obtenerListaAutorizaciones(String username) {
		
		List<String> listaAutorizaciones = new ArrayList<String>();
		
		try {
			GestionSSA ssa = new GestionSSA();
			Asignacion[] asignaciones = ssa.funcionesUsuario(username);
			//Asignacion[] asignaciones = ssa.funcionesUsuario(username, TIPO_FUNCION_CLASICA, TIPO_APLICACION_PFS);
                        //Se comenta esta funcionalidad porque Bankia nos comunica que Recovery es la única aplicación que lo utiliza
                        // y hubo un fallo en producción con LDAP que solo afectó a Recovery (no al resto de apps) y achacan el 
                        // problema al uso de esa versión sobreescrita del método "funcionesUsuario" 
                        
			for (Asignacion asignacion : asignaciones) {
				listaAutorizaciones.add(asignacion.getFuncion());
			}
			if (asignaciones == null || asignaciones.length==0) { 
				logger.error("obtenerListaAutorizaciones: lista de asignaciones vac�a");
			} else {
				if (asignaciones.length <= 100) {
					logger.info(asignaciones);
				}
			}
//			Centro[] centros = ssa.centrosUsuario(username);
//			String codigoCentro = "";
//			for (Centro centro : centros) {
//				codigoCentro = centro.getCodigoCentro();
//			}
//			if (centros == null || centros.length==0) { 
//				logger.error("obtenerListaAutorizaciones: lista de centros vac�a");
//			} else {
//				logger.info(centros);
//			}
		} catch (SSAException ssae) {
			logger.error(ssae.getDescripcionError());
		}
		return listaAutorizaciones;
	}

	@Override
	public String obtenerUsername(String username, HttpServletRequest request) {

		String resultado = username; 
		es.cm.arq.sd.seguridad.DatosRequest datos = null;
		try {
			datos = new es.cm.arq.sd.seguridad.DatosRequest();
			resultado = datos.getCodigoUsuario(request);
		} catch (SSAException e) {
			logger.error(e.getMessage() + " (" + e.getCodigoError() + ")");
		}
		logger.info(username + " (" + resultado + ")");

		return resultado;
	}

	@Override
	public boolean pwCorrecta(String username, String password) {
		
		boolean ok = false;
		try {
			GestionSSA ssa = new GestionSSA();
			ok = ssa.validarUsuarioPassword(username, password);
		} catch (SSAException ssae) {
			logger.error(ssae.getDescripcionError());
		}
		return ok;
	}
}
