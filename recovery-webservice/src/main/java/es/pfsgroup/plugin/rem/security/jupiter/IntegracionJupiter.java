package es.pfsgroup.plugin.rem.security.jupiter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;

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
	private IntegracionJupiterDao integracionJupiterDao;
	
	@Autowired
	private TraductorCodigosJupiter traductor;

	@Override
	public void setDBContext() {
		if (DbIdContextHolder.getDbId() <= 0) {
			DbIdContextHolder.setDbId((long) 1);
		}
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public void actualizarInfoPersonal(String username, String nombre, String apellidos, String email) {
		
		Assert.notNull(username, "username no puede ser null");
		Assert.notNull(nombre, "nombre no puede ser null");
		Assert.notNull(email, "email no puede ser null");
		
		if (apellidos == null) {
			apellidos = "";
		}
		
		Usuario usuario = usuarioDao.getByUsername(username);
		
		if (usuario == null) {
			logger.info("No existe en REM el usuario: " + username + ". Procedemos a su creación.");
			try {
				usuario = integracionJupiterDao.crearUsuario(username, nombre, apellidos, email);
			} catch (Exception e) {
				logger.error("IntegracionJupiter: problema al crear el usuario en REM desde Jupiter: " + e.getMessage()	+ " --- " + e.getCause());
			}
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
				logger.error("IntegracionJupiter: problema al actualizar los datos personales del usuario en REM desde Jupiter: " + e.getMessage() 
					+ " --- " + e.getCause());
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
		
		if (listaRoles == null) {
			listaRoles = "";
		}
		
		Usuario usuario = usuarioDao.getByUsername(username);
		
		if (usuario == null) {
			logger.error("IntegracionJupiter: No existe en REM el usuario: " + username);
		} else {
			try {
				List<String> listaCodigosJupiter = extraerListaCodigosJupiter(listaRoles);
		
				//Cargar maestro de mapeo Jupiter-REM
				Map<String, MapeoJupiterREM> mapaTraductor = null;
				try {
					mapaTraductor = traductor.getMap();
				} catch (Exception e) {
					logger.error("IntegracionJupiter: Error al cargar el mapa de traducciones de codigos entre Jupiter y REM: " + e.getMessage() 
						+ " --- " + e.getCause());
					mapaTraductor = traductor.getMapaInicial();
				}
				
				if (mapaTraductor != null) {
					List<String> codigosPerfilesJupiter = new ArrayList<String>();
					List<String> codigosGruposJupiter = new ArrayList<String>();
					List<String> codigosCarterasJupiter = new ArrayList<String>();
					List<String> codigosSubcarterasJupiter = new ArrayList<String>();
					traducirYSeparar(listaCodigosJupiter, mapaTraductor, codigosPerfilesJupiter, codigosGruposJupiter, codigosCarterasJupiter, codigosSubcarterasJupiter);
					
					List<String>  altasGrupos = new ArrayList<String>();
					List<String>  bajasGrupos = new ArrayList<String>();
					List<String> codigosGruposREM = integracionJupiterDao.getCodigodGruposREM(usuario);
					List<String> codigosGruposPerfilesREM = integracionJupiterDao.getCodigodGruposPerfilesREM(codigosPerfilesJupiter);
					obtenerListaAltasBajas(codigosGruposJupiter, codigosGruposREM, altasGrupos, bajasGrupos );
					excluirBajasGruposPorPerfiles(bajasGrupos, codigosGruposPerfilesREM);
					integracionJupiterDao.actualizarGrupos(usuario, altasGrupos, bajasGrupos);
					
					List<String> codigosPerfilesREM = integracionJupiterDao.getPerfilesREM(username);
					List<String>  altasPerfiles = new ArrayList<String>();
					List<String>  bajasPerfiles = new ArrayList<String>();
					obtenerListaAltasBajas(codigosPerfilesJupiter, codigosPerfilesREM, altasPerfiles, bajasPerfiles );
					integracionJupiterDao.actualizarPerfiles(usuario, altasPerfiles, bajasPerfiles);
					
					List<String>  altasCarteras = new ArrayList<String>();
					List<String>  bajasCarteras = new ArrayList<String>();
					List<String> codigosCarterasREM = integracionJupiterDao.getCodigosCarterasREM(usuario);
					obtenerListaAltasBajas(codigosCarterasJupiter, codigosCarterasREM, altasCarteras, bajasCarteras );
					if (codigosCarterasREM.size()>0 && !bajasCarteras.containsAll(codigosCarterasREM)) {
						altasCarteras = new ArrayList<String>();
					}
					integracionJupiterDao.actualizarCarteras(usuario, altasCarteras, bajasCarteras);
					int numCarteras = integracionJupiterDao.getCodigosCarterasREM(usuario).size();
					
					List<String> altasSubcarteras = new ArrayList<String>();
					List<String> bajasSubcarteras = new ArrayList<String>();
					List<String> codigosSubcarterasREM = integracionJupiterDao.getCodigosSubcarterasREM(usuario);
					obtenerListaAltasBajas(codigosSubcarterasJupiter, codigosSubcarterasREM, altasSubcarteras, bajasSubcarteras);
					if (numCarteras > 0 && codigosSubcarterasJupiter.size()>0) {
						integracionJupiterDao.eliminarCarteras(usuario);
					}
					integracionJupiterDao.actualizarSubcarteras(usuario, altasSubcarteras, bajasSubcarteras);
				}
			} catch (Exception e) {
				logger.error("IntegracionJupiter: problema al actualizar los datos de perfiles del usuario en REM desde Jupiter: " + e.getMessage() 
					+ " --- " + e.getCause());
			}
		}
	}

	// No vamos a dar de baja los grupos que provengan de perfiles
	private void excluirBajasGruposPorPerfiles(List<String> bajasGrupos, List<String> codigosPerfilesJupiter) {
		
		bajasGrupos.removeAll(codigosPerfilesJupiter);
		
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
			String codigoJupiterCorregido = corregirCodigoJupiter(codigoJupiter);
			if (!"".contentEquals(codigoJupiterCorregido.trim()) & !"999".contentEquals(codigoJupiterCorregido)) {
				MapeoJupiterREM traduccion = mapaTraductor.get(codigoJupiterCorregido);
				if (traduccion == null) {
					logger.error("IntegracionJupiter: Error al traducir el codigo desde Jupiter: " + codigoJupiter + " no existe en el maestro de traduccion.");
				} else {
					String tipoPerfil = traduccion.getTipoPerfil();
					if (PERFIL_ROL.equals(tipoPerfil)) {
	  					codigosPerfiles.add(traduccion.getCodigoREM());
					} else if (GRUPO.equals(tipoPerfil)) {
						codigosGrupos.add(traduccion.getCodigoREM());
					} else if (CARTERA.equals(tipoPerfil)) {
						codigosCarteras.add(traduccion.getCodigoREM());
					} else if (SUBCARTERA.equals(tipoPerfil)) {
						//El código de subcartera viene con el código de cartera por delante más un separador <espacio>/<espacio>. Hay que extraerlo.
						codigosSubcarteras.add(extraerCodigoSubcartera(traduccion.getCodigoREM()));
					} else {
						logger.error("IntegracionJupiter: Error al traducir el codigo desde Jupiter: " + codigoJupiter + " tiene un tipo de perfil no soportado " + traduccion.getTipoPerfil());
					}
				}
			}
		}
		
	}

	private String corregirCodigoJupiter(String codigoJupiter) {
		//Los códigos de perfil vienen de Jupiter a veces sin formateo de relleno a ceros por la izquierda
		try {  
			Long numero = Long.parseLong(codigoJupiter);
			if (numero < 999) {
				return String.format("%03d" , numero);
			} else {
				return codigoJupiter;
			}
		} catch(NumberFormatException e){  
			return codigoJupiter;  
		}
	}

	private String extraerCodigoSubcartera(String codigoSubcarteraREM) {
		final String SEPARADOR = " / "; 
		if (codigoSubcarteraREM.length()<=SEPARADOR.length()) {
			return codigoSubcarteraREM;
		} else {
			return codigoSubcarteraREM.split(SEPARADOR)[1];
		}	
	}

	private List<String> extraerListaCodigosJupiter(String listaRoles) {
		
		String[] array = listaRoles.split(",");      
		List<String> listaJupiter = Arrays.asList(array);
		Collections.sort(listaJupiter);
		return listaJupiter;

	}

}
