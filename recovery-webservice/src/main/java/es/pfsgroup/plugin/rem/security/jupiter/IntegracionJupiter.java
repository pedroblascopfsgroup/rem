package es.pfsgroup.plugin.rem.security.jupiter;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

@Service("integracionJupiter")
public class IntegracionJupiter implements IntegracionJupiterApi {
	
	private static final String PERFIL_ROL = "perfil-rol";
	private static final String GRUPO = "grupo";
	private static final String CARTERA = "cartera";
	private static final String SUBCARTERA = "subcartera";

	private static final Log logger = LogFactory.getLog(IntegracionJupiter.class);
	
	@Autowired
	private UsuarioDao usuarioDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired 
	private IntegracionJupiterDao integracionJupiterDao;
	
	@Autowired
	private TraductorCodigosJupiter traductor;
	
	@Override
	@Transactional(readOnly = false)
	public void actualizarInfoPersonal(String username, String nombre, String apellidos, String email) {
		
		Assert.notNull(username, "username no puede ser null");
		Assert.notNull(username, "nombre no puede ser null");
		Assert.notNull(username, "apellidos no puede ser null");
		Assert.notNull(username, "email no puede ser null");
		
		Usuario usuario = usuarioDao.getByUsername(username);
		
		if (usuario == null) {
			logger.error("No existe en REM el usuario: " + username);
		} else {	
			String nombreREM = usuario.getNombre();
			String apellidosREM = usuario.getApellidos();
			String emailREM = usuario.getEmail();		
			try {
				if (hayDiferenciasJupiterREM(nombre, apellidos, email, nombreREM, apellidosREM, emailREM)) {
					logger.info("actualizarInfoPersonal: se han detectado diferencias entre los datos de Jupiter y REM");
					integracionJupiterDao.actualizarUsuario(usuario, nombre, apellidos, email);
					logger.info("actualizarInfoPersonal: actualizados los datos de REM procedentes de Jupiter");
				}
			} catch (Exception e) {
				logger.error("Jupiter: problema al actualizar los datos personales del usuario en REM desde Jupiter: " + e.getMessage());
				if (e instanceof SQLException) {
					logger.error("Detalles del error: " + e.getCause());
				} else {
					e.printStackTrace();
				}
			}
		}
		
	}

	private boolean hayDiferenciasJupiterREM(String nombre, String apellidos, String email, String nombreREM,
			String apellidosREM, String emailREM) {
		return !(nombre.equalsIgnoreCase(nombreREM) && apellidos.equalsIgnoreCase(apellidosREM) && email.equalsIgnoreCase(emailREM));
	}


	@Override
	@Transactional(readOnly = false)
	public void actualizarRolesDesdeJupiter(String username, String listaRoles) {

		Assert.notNull(username, "username no puede ser null");
		Assert.notNull(username, "listaRoles no puede ser null");
		
		Usuario usuario = usuarioDao.getByUsername(username);
		
		if (usuario == null) {
			logger.error("No existe en REM el usuario: " + username);
		} else {
			try {
				List<String> listaCodigosJupiter = extraerListaCodigosJupiter(listaRoles);
		
				//Cargar maestro de mapeo Jupiter-REM
				Map<String, MapeoJupiterREM> mapaTraductor = traductor.getMap();
				
				//Traducir y separar
				List<String> codigosPerfilesJupiter = new ArrayList<String>();
				List<String> codigosGruposJupiter = new ArrayList<String>();
				List<String> codigosCarterasJupiter = new ArrayList<String>();
				List<String> codigosSubcarterasJupiter = new ArrayList<String>();
				traducirYSeparar(listaCodigosJupiter, mapaTraductor, codigosPerfilesJupiter, codigosGruposJupiter, codigosCarterasJupiter, codigosSubcarterasJupiter);
				
				//Obtener lista de perfiles REM
				List<String> codigosPerfilesREM = integracionJupiterDao.getPerfilesREM(username);
		
				//Obtener listas de diferencias
				List<String>  altasPerfiles = new ArrayList<String>();
				List<String>  bajasPerfiles = new ArrayList<String>();
				obtenerListaAltasBajas(codigosPerfilesJupiter, codigosPerfilesREM, altasPerfiles, bajasPerfiles );
				
				List<String>  altasGrupos = new ArrayList<String>();
				List<String>  bajasGrupos = new ArrayList<String>();
				List<String> codigosGruposREM = integracionJupiterDao.getCodigodGruposREM(usuario);
				obtenerListaAltasBajas(codigosGruposJupiter, codigosGruposREM, altasGrupos, bajasGrupos );
				
				List<String>  altasCarteras = new ArrayList<String>();
				List<String>  bajasCarteras = new ArrayList<String>();
				List<String> codigosCarterasREM = integracionJupiterDao.getCodigosCarterasREM(usuario);
				obtenerListaAltasBajas(codigosCarterasJupiter, codigosCarterasREM, altasCarteras, bajasCarteras );
				//Controlar que sólo pueda haber una cartera asociada al usuario
				if (altasCarteras.size() > 1) {
					List<String> altasCarterasNuevo = new ArrayList<String>();
					altasCarterasNuevo.add(altasCarteras.get(0));
					altasCarteras = altasCarterasNuevo;
				}
				
				List<String>  altasSubcarteras = new ArrayList<String>();
				List<String>  bajasSubcarteras = new ArrayList<String>();
				List<String> codigosSubcarterasREM = integracionJupiterDao.getCodigosSubcarterasREM(usuario);
				obtenerListaAltasBajas(codigosSubcarterasJupiter, codigosSubcarterasREM, altasSubcarteras, bajasSubcarteras );
				
				//Actualizar según las diferencias encontradas
				integracionJupiterDao.actualizarPerfiles(usuario, altasPerfiles, bajasPerfiles);
				integracionJupiterDao.actualizarGrupos(usuario, altasGrupos, bajasGrupos);
				integracionJupiterDao.actualizarCarteras(usuario, altasCarteras, bajasCarteras);
				integracionJupiterDao.actualizarSubcarteras(usuario, altasSubcarteras, bajasSubcarteras);
			} catch (Exception e) {
				logger.error("Jupiter: problema al actualizar los datos de perfiles, grupos y carteras del usuario en REM desde Jupiter: " + e.getMessage());
				if (e instanceof SQLException) {
					logger.error("Detalles del error: " + e.getCause());
				} else {
					e.printStackTrace();
				}
			}
		}
	}

	private void obtenerListaAltasBajas(List<String> codigosJupiter, List<String> codigosREM,
			List<String> altas, List<String> bajas) {
		
		Collections.sort(codigosJupiter);
        Collections.sort(codigosREM);
        
        int indiceREM = 0;
        int indiceJupiter = 0;

        while (indiceREM < codigosREM.size() && indiceJupiter < codigosJupiter.size()) {
			int comparacion = codigosREM.get(indiceREM).compareTo(codigosJupiter.get(indiceJupiter));
			if (comparacion == 0) {
				indiceREM++;
				indiceJupiter++;
			} else if (comparacion > 0) {
				altas.add(codigosJupiter.get(indiceJupiter));
				indiceJupiter++;
			} else {
				bajas.add(codigosREM.get(indiceREM));
				indiceREM++;
			}
        }
        
        while (indiceREM < codigosREM.size()) {
            bajas.add(codigosREM.get(indiceREM));
            indiceREM++;
        }
        while (indiceJupiter < codigosJupiter.size()) {
            altas.add(codigosJupiter.get(indiceJupiter));
            indiceJupiter++;
        }
        
	}

	private void traducirYSeparar(List<String> listaCodigosJupiter, Map<String, MapeoJupiterREM> mapaTraductor,
			List<String> codigosPerfiles, List<String> codigosGrupos, List<String> codigosCarteras,
			List<String> codigosSubcarteras) {
		
		for (String codigoJupiter : listaCodigosJupiter) {
			MapeoJupiterREM traduccion = mapaTraductor.get(codigoJupiter);
			if (traduccion == null) {
				logger.error("Error al traducir el código desde Júpiter: " + codigoJupiter + " no existe en el maestro de traducción.");
			} else {
				String tipoPerfil = traduccion.getTipoPerfil();
				if (PERFIL_ROL.equals(tipoPerfil)) {
					codigosPerfiles.add(traduccion.getCodigoREM());
				} else if (GRUPO.equals(tipoPerfil)) {
					codigosGrupos.add(traduccion.getCodigoREM());
				} else if (CARTERA.equals(tipoPerfil)) {
					codigosCarteras.add(traduccion.getCodigoREM());
				} else if (SUBCARTERA.equals(tipoPerfil)) {
					codigosSubcarteras.add(traduccion.getCodigoREM());
				} else {
					logger.error("Error al traducir el código desde Júpiter: " + codigoJupiter + " tiene un tipo de perfil no soportado " + traduccion.getTipoPerfil());
				}
			}
		}
		
	}

	private List<String> extraerListaCodigosJupiter(String listaRoles) {
		
		String[] array = listaRoles.split(",");      
		List<String> listaJupiter = Arrays.asList(array);
		Collections.sort(listaJupiter);
		return listaJupiter;

	}

}
