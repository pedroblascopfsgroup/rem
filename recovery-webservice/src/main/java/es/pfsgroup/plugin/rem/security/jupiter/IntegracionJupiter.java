package es.pfsgroup.plugin.rem.security.jupiter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.GrupoUsuario;
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
	private UsuarioApi usuarioManager;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private TraductorCodigosJupiter traductor;
	
	@Override
	public void actualizarInfoPersonal(String username, String nombre, String apellidos, String email)
			throws Exception {

		Assert.notNull(username, "username cannot be null");
		Assert.notNull(username, "nombre cannot be null");
		Assert.notNull(username, "apellidos cannot be null");
		Assert.notNull(username, "email cannot be null");
		
		//TODO: ¿es necesario el parámetro username?  --> Ver GenericManager
		//Si getUsuarioLogado devuelve el usuario logado, ya no necesitamos el username
		// En caso contrario, hay que recuperarlo de la BD
		Usuario usuario = usuarioManager.getUsuarioLogado();
		
		String nombreREM = usuario.getNombre();
		String apellidosREM = usuario.getApellidos();
		String emailREM = usuario.getEmail();
		
		if (hayDiferenciasJupiterREM(nombre, apellidos, email, nombreREM, apellidosREM, emailREM)) {
			logger.info("actualizarInfoPersonal: se han detectado diferencias entre los datos de Jupiter y REM");
			actualizarUsuario(usuario, nombre, apellidos, email);
			logger.info("actualizarInfoPersonal: actualizados los datos de REM procedentes de Jupiter");
		}
		
	}

	private boolean hayDiferenciasJupiterREM(String nombre, String apellidos, String email, String nombreREM,
			String apellidosREM, String emailREM) {
		return !(nombre.equalsIgnoreCase(nombreREM) && apellidos.equalsIgnoreCase(apellidosREM) && email.equalsIgnoreCase(emailREM));
	}

	private void actualizarUsuario(Usuario usuario, String nombre, String apellidos, String email) throws Exception {
		
		String ape1;
		String ape2;
		
		usuario.setNombre(nombre);
		if (apellidos.contains(" ")) {
			ape1 = apellidos.split(" ")[0];
			ape2 = apellidos.split(" ", 1)[1];
		} else {
			ape1 = apellidos;
			ape2 = "";
		}
		usuario.setApellido1(ape1);
		usuario.setApellido2(ape2);
		usuario.setEmail(email);
		
		try {
			genericDao.save(Usuario.class, usuario);
		} catch (Exception e) {
			System.out.println("Error al actualizar datos personales del usuario: " + e.getMessage());
			throw new Exception("Error al actualizar datos personales del usuario: " + e.getMessage());
		}
		
	}

	@Override
	public void actualizarRolesDesdeJupiter(String username, String listaRoles) throws Exception {

		//TODO: ¿es necesario el parámetro username? --> Ver GenericManager
		Usuario usuario = usuarioManager.getUsuarioLogado();
		
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
		List<Perfil> listaPerfilesREM = usuario.getPerfiles();
		List<String> codigosPerfilesREM = obtenerListaCodigosPerfilesREM(listaPerfilesREM);

		//Obtener listas de diferencias
		List<String>  altasPerfiles = new ArrayList<String>();
		List<String>  bajasPerfiles = new ArrayList<String>();
		obtenerListaAltasBajas(codigosPerfilesJupiter, codigosPerfilesREM, altasPerfiles, bajasPerfiles );
		
		List<String>  altasGrupos = new ArrayList<String>();
		List<String>  bajasGrupos = new ArrayList<String>();
		List<String> codigosGruposREM = getCodigodGruposREM(usuario);
		obtenerListaAltasBajas(codigosGruposJupiter, codigosGruposREM, altasGrupos, bajasGrupos );
		
		List<String>  altasCarteras = new ArrayList<String>();
		List<String>  bajasCarteras = new ArrayList<String>();
		List<String> codigosCarterasREM = getCodigosCarterasREM(usuario);
		obtenerListaAltasBajas(codigosCarterasJupiter, codigosCarterasREM, altasCarteras, bajasCarteras );
		
		List<String>  altasSubcarteras = new ArrayList<String>();
		List<String>  bajasSubcarteras = new ArrayList<String>();
		List<String> codigosSubcarterasREM = getCodigosSubcarterasREM(usuario);
		obtenerListaAltasBajas(codigosSubcarterasJupiter, codigosSubcarterasREM, altasSubcarteras, bajasSubcarteras );
		
		//Actyualizar según las diferencias encontradas
		actualizarPerfiles(usuario, altasPerfiles, bajasPerfiles);
		actualizarGrupos(usuario, altasGrupos, bajasGrupos);
		actualizarCarteras(usuario, altasCarteras, bajasCarteras);
		actualizarSubcarteras(usuario, altasSubcarteras, bajasSubcarteras);
		
	}

	private void actualizarPerfiles(Usuario usuario, List<String> altasPerfiles, List<String> bajasPerfiles) {
		
		for (String codigoPerfil : altasPerfiles) {
			ZonaUsuarioPerfil zpu = new ZonaUsuarioPerfil();
			zpu.setUsuario(usuario);
			Perfil perfil = genericDao.get(Perfil.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", codigoPerfil));
			zpu.setPerfil(perfil);
			DDZona zona = genericDao.get(DDZona.class, 
					genericDao.createFilter(FilterType.EQUALS, "descripcion", "REM"));
			zpu.setZona(zona);
			zpu.setAuditoria(Auditoria.getNewInstance());
			zpu.setVersion(0);
			genericDao.save(ZonaUsuarioPerfil.class, zpu);
			logger.info("Creando asociación perfil " + codigoPerfil + " - usuario " + usuario.getUsername());
		}
		
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());
		for (String codigoPerfil : bajasPerfiles) {
			Filter filtroPerfil = genericDao.createFilter(FilterType.EQUALS, "perfil.codigo", codigoPerfil);
			genericDao.delete(ZonaUsuarioPerfil.class, filtroUsuario, filtroPerfil);
			logger.info("Eliminando asociación perfil " + codigoPerfil + " - usuario " + usuario.getUsername());
		}

	}

	private void actualizarGrupos(Usuario usuario, List<String> altasGrupos, List<String> bajasGrupos) {

		for (String codigoGrupo : altasGrupos) {
			GrupoUsuario grupoNuevo = new GrupoUsuario();
			Filter filtroGrupo = genericDao.createFilter(FilterType.EQUALS, "grupo.username", codigoGrupo);
			Usuario grupo = genericDao.get(Usuario.class, filtroGrupo);
			grupoNuevo.setGrupo(grupo);
			grupoNuevo.setUsuario(usuario);
			genericDao.save(GrupoUsuario.class, grupoNuevo);
			logger.info("Creando asociación grupo " + codigoGrupo + " - usuario " + usuario.getUsername());
		}
		
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());
		for (String codigoGrupo : bajasGrupos) {
			Filter filtroGrupo = genericDao.createFilter(FilterType.EQUALS, "grupo.username", codigoGrupo);
			genericDao.delete(GrupoUsuario.class, filtroUsuario, filtroGrupo);
			logger.info("Eliminando asociación grupo " + codigoGrupo + " - usuario " + usuario.getUsername());
		}
		
	}

	private void actualizarCarteras(Usuario usuario, List<String> altasCarteras, List<String> bajasCarteras) {

		for (String codigoCartera : altasCarteras) {
			UsuarioCartera usuarioCarteraNuevo = new UsuarioCartera();
			Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoCartera);
			DDCartera cartera= genericDao.get(DDCartera.class, filtroCartera);
			usuarioCarteraNuevo.setUsuario(usuario);
			usuarioCarteraNuevo.setCartera(cartera);
			genericDao.save(UsuarioCartera.class, usuarioCarteraNuevo);
			logger.info("Creando asociación cartera " + codigoCartera + " - usuario " + usuario.getUsername());
		}
		
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());
		for (String codigoCartera : bajasCarteras) {
			Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", codigoCartera);
			genericDao.delete(UsuarioCartera.class, filtroUsuario, filtroCartera);
			logger.info("Eliminando asociación cartera " + codigoCartera + " - usuario " + usuario.getUsername());
		}
		
	}

	private void actualizarSubcarteras(Usuario usuario, List<String> altasSubcarteras, List<String> bajasSubcarteras) {

		for (String codigoSubartera : altasSubcarteras) {
			UsuarioCartera usuarioSubcarteraNuevo = new UsuarioCartera();
			Filter filtroSubcartera = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoSubartera);
			DDSubcartera subcartera= genericDao.get(DDSubcartera.class, filtroSubcartera);
			usuarioSubcarteraNuevo.setUsuario(usuario);
			usuarioSubcarteraNuevo.setCartera(subcartera.getCartera());
			usuarioSubcarteraNuevo.setSubCartera(subcartera);
			genericDao.save(UsuarioCartera.class, usuarioSubcarteraNuevo);
			logger.info("Creando asociación subcartera " + codigoSubartera + " - usuario " + usuario.getUsername());
		}
		
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());
		for (String codigoSubcartera : bajasSubcarteras) {
			Filter filtroSubcartera = genericDao.createFilter(FilterType.EQUALS, "subcartera.codigo", codigoSubcartera);
			genericDao.delete(UsuarioCartera.class, filtroUsuario, filtroSubcartera);
			logger.info("Eliminando asociación subcartera " + codigoSubcartera + " - usuario " + usuario.getUsername());
		}
				
	}

	private List<String> getCodigosCarterasREM(Usuario usuario) {
		List<String> resultado = new ArrayList<String>();
		Filter filtroUca = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());

		List<UsuarioCartera> uca = genericDao.getList(UsuarioCartera.class, filtroUca);
		if (uca != null && !uca.isEmpty()) {
			resultado.add(uca.get(0).getCartera().getCodigo());
		}
		return resultado;
	}

	private List<String> getCodigosSubcarterasREM(Usuario usuario) {
		List<String> resultado = new ArrayList<String>();
		Filter filtroUca = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());

		List<UsuarioCartera> uca = genericDao.getList(UsuarioCartera.class, filtroUca);
		if (uca != null && !uca.isEmpty()) {
			for (UsuarioCartera uc : uca) {
				if (uc.getSubCartera() != null && !uc.getSubCartera().getAuditoria().isBorrado()) {
					resultado.add(uc.getSubCartera().getCodigo());
				}
			}
		}
		return resultado;
	}

	private List<String> getCodigodGruposREM(Usuario usuario) {
		List<String> resultado = new ArrayList<String>();

		Filter filtroGru = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());
		List<GrupoUsuario> gruUsu = genericDao.getList(GrupoUsuario.class, filtroGru);	
		for (GrupoUsuario grupo : gruUsu) {
			resultado.add(grupo.getGrupo().getUsername());
		}
		return resultado;
		
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
				switch (traduccion.getTipoPerfil()) {
				case PERFIL_ROL:
					codigosPerfiles.add(traduccion.getCodigoREM());
					break;
				case GRUPO:
					codigosGrupos.add(traduccion.getCodigoREM());
					break;
				case CARTERA:
					codigosCarteras.add(traduccion.getCodigoREM());
					break;
				case SUBCARTERA:
					codigosSubcarteras.add(traduccion.getCodigoREM());
					break;
				default:
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

	private List<String> obtenerListaCodigosPerfilesREM(List<Perfil> listaPerfilesREM) {
		List<String> listaCodigos = new ArrayList<String>();
		for (Perfil perfilREM : listaPerfilesREM) {
			listaCodigos.add(perfilREM.getCodigo());
		}
		return listaCodigos;
	}

}
