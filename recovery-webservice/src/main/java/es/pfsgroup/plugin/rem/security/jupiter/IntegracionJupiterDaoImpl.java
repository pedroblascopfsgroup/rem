package es.pfsgroup.plugin.rem.security.jupiter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.GrupoUsuario;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDaoError;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.FieldInfo;

@Repository("IntegracionJupiterDao")
public class IntegracionJupiterDaoImpl extends AbstractEntityDao<MapeoJupiterREM, Long> implements IntegracionJupiterDao {

	private static final String USUARIO_USERNAME = "usuario.username";
	private static final String USUARIO_ID = "usuario.id";
	private static final String DESCRIPCION = "descripcion";
	private static final String ZPU_ZONA_DESCRIPCION = "zona.descripcion";
	private static final String CODIGO_ZONA_REM = "REM";
	private static final String PERFIL_CODIGO = "codigo";
	private static final String ZPU_PERFIL_CODIGO = "perfil.codigo";
	private static final String CODIGO_USUARIO = "username";
	private static final String GU_CODIGO_USUARIO = "grupo.username";
	private static final String UCA_DESCRIPCION = "cartera.descripcion";
	private static final String SUB_CARTERA = "subCartera";
	private static final String UCA_DESCRIPCION_SUB = "subCartera.descripcion";

	private static final Log logger = LogFactory.getLog(IntegracionJupiterDaoImpl.class);
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public void actualizarPerfiles(Usuario usuario, List<String> altasPerfiles, List<String> bajasPerfiles) {	
		DDZona zona = genericDao.get(DDZona.class, 
				genericDao.createFilter(FilterType.EQUALS, DESCRIPCION, CODIGO_ZONA_REM));
		for (String codigoPerfil : altasPerfiles) {
			Perfil perfil = obtenerPerfil(codigoPerfil);
			if (perfil != null) {
				ZonaUsuarioPerfil zpu = new ZonaUsuarioPerfil();
				zpu.setUsuario(usuario);
				zpu.setPerfil(perfil);
				zpu.setZona(zona);
				zpu.setAuditoria(Auditoria.getNewInstance());
				zpu.setVersion(0);
				genericDao.save(ZonaUsuarioPerfil.class, zpu);
				logger.debug("Creando asociacion perfil " + codigoPerfil + " - usuario " + usuario.getUsername());
				MapeoPerfilDespacho mpd = obtenerMapeoPerfilDespachoAlta(codigoPerfil); 
				if (mpd != null) {
					asociarUsuarioADespacho(usuario, mpd);
				}
			} else {
				logger.error("No existe el perfil " + codigoPerfil + " en REM: no se crea asociacion con el usuario " + usuario.getUsername());
			}
		}
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
		for (String codigoPerfil : bajasPerfiles) {
			genericDao.delete(ZonaUsuarioPerfil.class, filtroUsuario, obtenerFiltroZPUPerfil(codigoPerfil));
			logger.debug("Eliminando asociacion perfil " + codigoPerfil + " - usuario " + usuario.getUsername());
			List<MapeoPerfilDespacho> listMpd = obtenerMapeoPerfilDespachoBaja(codigoPerfil); 
			if (listMpd != null && listMpd.size()>0) {
				desasociarUsuarioADespacho(usuario, listMpd);
			}
		}
	}

	private MapeoPerfilDespacho obtenerMapeoPerfilDespachoAlta(String codigo) {
		return genericDao.get(MapeoPerfilDespacho.class, 
				genericDao.createFilter(FilterType.EQUALS, "codigoPerfil", codigo),
				genericDao.createFilter(FilterType.EQUALS, "manual", false));
	}

	private void asociarUsuarioADespacho(Usuario usuario, MapeoPerfilDespacho mapeo) {
		
		String codigoDespacho = mapeo.getCodigoDespacho();
		DespachoExterno despacho = genericDao.get(DespachoExterno.class, genericDao.createFilter(FilterType.EQUALS, "despacho",codigoDespacho));
		if (despacho == null) {
			logger.error("No existe el despacho " + codigoDespacho + " en REM: no se crea asociacion con el usuario " + usuario.getUsername());
		} else {
			GestorDespacho gd = new GestorDespacho();
			gd.setUsuario(usuario);
			gd.setDespachoExterno(despacho);
			gd.setSupervisor(false);
			gd.setGestorPorDefecto(false);
			gd.setVersion(0);
			gd.setAuditoria(Auditoria.getNewInstance());
			genericDao.save(GestorDespacho.class, gd);
			logger.debug("Creando asociacion despacho " + codigoDespacho + " (por perfil " + mapeo.getCodigoPerfil() + " - usuario " + usuario.getUsername());
			String codigoGrupo = mapeo.getCodigoGrupo();
			if (codigoGrupo != null && !"".equals(codigoGrupo)) {
				altaGrupo(usuario, codigoGrupo);
			}
		}
		
	}

	private List<MapeoPerfilDespacho> obtenerMapeoPerfilDespachoBaja(String codigo) {
		return genericDao.getList(MapeoPerfilDespacho.class, 
				genericDao.createFilter(FilterType.EQUALS, "codigoPerfil", codigo));
	}

	private void desasociarUsuarioADespacho(Usuario usuario, List<MapeoPerfilDespacho> listaMapeo) {
		
		Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
		for (MapeoPerfilDespacho mapeo : listaMapeo) {
			String codigoDespacho = mapeo.getCodigoDespacho();
			DespachoExterno despacho = genericDao.get(DespachoExterno.class, genericDao.createFilter(FilterType.EQUALS, "despacho",codigoDespacho));
			if (despacho == null) {
				logger.error("No existe el despacho " + codigoDespacho + " en REM: no se deshace asociacion con el usuario " + usuario.getUsername());
			} else {
				genericDao.delete(GestorDespacho.class, 
					genericDao.createFilter(FilterType.EQUALS, "usuario", usuario),
					genericDao.createFilter(FilterType.EQUALS, "despachoExterno.despacho", codigoDespacho));
				logger.debug("Deshaciendo asociacion grupo " + mapeo.getCodigoDespacho() + " - usuario " + usuario.getUsername());
				String codigoGrupo = mapeo.getCodigoGrupo();
				if (codigoGrupo != null && !"".equals(codigoGrupo)) {
					bajaGrupo(filtroUsuario, usuario.getUsername(), codigoGrupo);
				}
			}
		}
		
	}

	private void altaGrupo(Usuario usuario, String codigoGrupo) {
		Usuario grupo = obtenerGrupo(codigoGrupo);
		if (grupo != null) {
			GrupoUsuario nuevaRelGrupoUsuario = new GrupoUsuario();
			nuevaRelGrupoUsuario.setGrupo(grupo);
			nuevaRelGrupoUsuario.setUsuario(usuario);
			nuevaRelGrupoUsuario.setAuditoria(Auditoria.getNewInstance());
			nuevaRelGrupoUsuario.setVersion(0);
			genericDao.save(GrupoUsuario.class, nuevaRelGrupoUsuario);
			logger.debug("Creando asociacion grupo " + grupo.getUsername() + " - usuario " + usuario.getUsername());
		} else {
			logger.error("No existe el grupo " + codigoGrupo + " en REM: no se crea asociacion con el usuario " + usuario.getUsername());
		}
	}
	
	private void bajaGrupo(Filter filtroUsuario, String username, String codigoGrupo) {
		genericDao.delete(GrupoUsuario.class, filtroUsuario, obtenerFiltroGUGrupo(codigoGrupo));
		logger.debug("Eliminando asociacion grupo " + codigoGrupo + " - usuario " + username);
	}
	
	@Override
	public void actualizarGrupos(Usuario usuario, List<String> altasGrupos, List<String> bajasGrupos) {
		for (String codigoGrupo : altasGrupos) {
			altaGrupo(usuario, codigoGrupo);
		}	
		Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
		for (String codigoGrupo : bajasGrupos) {
			bajaGrupo(filtroUsuario, usuario.getUsername(), codigoGrupo);
		}
	}

	@Override
	public void actualizarCarteras(Usuario usuario, List<String> altasCarteras, List<String> bajasCarteras) {
		Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
		for (String descCartera : bajasCarteras) {
			genericDao.delete(UsuarioCartera.class, filtroUsuario, obtenerFiltroUCADescripcionCartera(descCartera),
					genericDao.createFilter(FilterType.NULL, SUB_CARTERA));
			logger.debug("Eliminando asociacion cartera " + descCartera + " - usuario " + usuario.getUsername());
		}
		for (String codigoCartera : altasCarteras) {
			DDCartera cartera = obtenerCartera(codigoCartera);
			if (cartera != null) {
				UsuarioCartera usuarioCarteraNuevo = new UsuarioCartera();
				usuarioCarteraNuevo.setUsuario(usuario);
				usuarioCarteraNuevo.setCartera(cartera);
				genericDao.save(UsuarioCartera.class, usuarioCarteraNuevo);
				logger.debug("Creando asociacion cartera " + codigoCartera + " - usuario " + usuario.getUsername());
				break; // Sólo puede haber una cartera activa
			} else {
				logger.error("No existe la cartera " + codigoCartera + " en REM: no se crea asociacion con el usuario " + usuario.getUsername());
			}
		}		
	}

	@Override
	public void actualizarSubcarteras(Usuario usuario, List<String> altasSubcarteras, List<String> bajasSubcarteras) {
		String username =  usuario.getUsername();
		Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
		for (String descSubcartera : bajasSubcarteras) {
			genericDao.delete(UsuarioCartera.class, filtroUsuario, obtenerFiltroUCADescripcionSubcartera(descSubcartera));
			logger.debug("Eliminando asociacion subcartera " + descSubcartera + " - usuario " + username);
		}
		for (String descSubcartera : altasSubcarteras) {
			DDSubcartera subcartera = genericDao.get(DDSubcartera.class, obtenerFiltroCodigoSubcartera(descSubcartera));
			if (subcartera != null) {
				UsuarioCartera usuarioSubcarteraNuevo = new UsuarioCartera();
				usuarioSubcarteraNuevo.setUsuario(usuario);
				usuarioSubcarteraNuevo.setCartera(subcartera.getCartera());
				usuarioSubcarteraNuevo.setSubCartera(subcartera);
				genericDao.save(UsuarioCartera.class, usuarioSubcarteraNuevo);
				logger.debug("Creando asociacion subcartera " + descSubcartera + " - usuario " + username);
			} else {
				logger.error("No existe la subcartera " + descSubcartera + " en REM: no se crea asociacion con el usuario " + username);
			}
		}
	}

	@Override
	public void eliminarCarteras(Usuario usuario) {
		Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
		eliminarCarterasFiltro(filtroUsuario, usuario.getUsername());
	}
	
	@Transactional(readOnly = false)
	private Usuario crearUsuario2(String username, String nombre, String apellidos, String email) {
		Usuario usuario = new Usuario();
		usuario.setUsername(username);
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		try {
			usuario.setFechaVigenciaPassword(sdf.parse("31-12-2099"));
		} catch (ParseException e) {
			logger.error("Error al asignar fecha de fin de vigencia de password");
		}
		usuario.setAuditoria(Auditoria.getNewInstance());
		usuario.setVersion(0);
		usuario.setUsuarioGrupo(false);
		actualizarUsuario(usuario, nombre, apellidos, email);
		DDZona zona = genericDao.get(DDZona.class, 
				genericDao.createFilter(FilterType.EQUALS, DESCRIPCION, CODIGO_ZONA_REM));
		Perfil perfil = obtenerPerfil("HAYACONSU");
		ZonaUsuarioPerfil zpu = new ZonaUsuarioPerfil();
		zpu.setUsuario(usuario);
		zpu.setPerfil(perfil);
		zpu.setZona(zona);
		zpu.setAuditoria(Auditoria.getNewInstance());
		zpu.setVersion(0);
		genericDao.save(ZonaUsuarioPerfil.class, zpu);		
		return usuario;
	}
	
	@Override
	public Usuario crearUsuario(String username, String nombre, String apellidos, String email) {
		
		Session session = this.getSession();
		
		String queryInsert = "";
		try {
			String nomTabla="REMMASTER.USU_USUARIOS";
			String columnas="USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_MAIL,USU_GRUPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,USU_FECHA_VIGENCIA_PASS";
			String valores="REMMASTER.S_USU_USUARIOS.NEXTVAL,1,'"+username+"','1234','"+nombre+"','"+
					(apellidos!=null?apellidos:"")+"','','" + email + "',0,0,'JUPITER',SYSDATE,0,TO_DATE('31/12/2099','dd/mm/yyyy')";
			queryInsert = "INSERT INTO " + nomTabla + " (" + columnas + ") VALUES (" + valores + ")";
			SQLQuery query = session.createSQLQuery(queryInsert);
			query.executeUpdate();
		} catch (Exception e) {
			logger.fatal("Error al crear usuario en BD. Realizando rollback de la transacción: " + queryInsert);
		}
		
		Usuario usuario = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", username));
		return usuario;
	}
	
	
	@Override
	public void actualizarUsuario(Usuario usuario, String nombre, String apellidos, String email) {
		String ape1;
		String ape2;
		usuario.setNombre(nombre);
		if (Checks.esNulo(apellidos)) {
			ape1 = "";
			ape2 = "";
		} else {
			if (apellidos.contains(" ")) {
				ape1 = apellidos.split(" ")[0];
				ape2 = apellidos.split(" ", 2)[1];
			} else {
				ape1 = apellidos;
				ape2 = "";
			}
		}
		usuario.setApellido1(ape1);
		usuario.setApellido2(ape2);
		usuario.setEmail(email);
		genericDao.save(Usuario.class, usuario);
	}

	@Override
	public List<String> getCodigosCarterasREM(Usuario usuario) {
		List<String> resultado = new ArrayList<String>();
		Filter filtroUca = genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
		List<UsuarioCartera> uca = genericDao.getList(UsuarioCartera.class, filtroUca, 
				genericDao.createFilter(FilterType.NULL, SUB_CARTERA));
		if (uca != null && !uca.isEmpty()) {
			resultado.add(uca.get(0).getCartera().getDescripcion());
		}
		return resultado;
	}

	@Override
	public List<String> getCodigosSubcarterasREM(Usuario usuario) {
		List<String> resultado = new ArrayList<String>();
		Filter filtroUca = genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
		List<UsuarioCartera> uca = genericDao.getList(UsuarioCartera.class, filtroUca);
		if (uca != null && !uca.isEmpty()) {
			for (UsuarioCartera uc : uca) {
				if (uc.getSubCartera() != null && !uc.getSubCartera().getAuditoria().isBorrado()) {
					resultado.add(uc.getSubCartera().getDescripcion());
				}
			}
		}
		return resultado;
	}

	@Override
	public List<String> getCodigodGruposREM(Usuario usuario) {
		List<String> resultado = new ArrayList<String>();
		Filter filtroGru = genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
		List<GrupoUsuario> gruUsu = genericDao.getList(GrupoUsuario.class, filtroGru,
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));	
		for (GrupoUsuario grupo : gruUsu) {
			resultado.add(grupo.getGrupo().getUsername());
		}
		return resultado;
	}

	@Override
	public List<String> getPerfilesREM(String username) {
		List<ZonaUsuarioPerfil> listaZonPefUsu = genericDao.getList(ZonaUsuarioPerfil.class,
				genericDao.createFilter(FilterType.EQUALS, USUARIO_USERNAME, username), 
				genericDao.createFilter(FilterType.EQUALS, ZPU_ZONA_DESCRIPCION, CODIGO_ZONA_REM),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		List<String> listaCodigosPerfilREM = new ArrayList<String>();
		for (ZonaUsuarioPerfil zpu : listaZonPefUsu) {
			listaCodigosPerfilREM.add(zpu.getPerfil().getCodigo());
		}
		return listaCodigosPerfilREM;
	}

	@Override
	public List<String> getCodigodGruposPerfilesREM(List<String> codigosPerfilesJupiter) {
		List<String> resultado = new ArrayList<String>();
		for (String codigoPerfil : codigosPerfilesJupiter) {
			MapeoPerfilDespacho mpd = obtenerMapeoPerfilDespachoAlta(codigoPerfil); 
			if (mpd != null && mpd.getCodigoGrupo() != null) {
				resultado.add(mpd.getCodigoGrupo());
			}
		}
		return resultado;
	}
	
	private Filter obtenerFiltroPerfil(String codigoPerfil) {
		return genericDao.createFilter(FilterType.EQUALS, PERFIL_CODIGO, codigoPerfil);
	}

	private Filter obtenerFiltroZPUPerfil(String codigoPerfil) {
		return genericDao.createFilter(FilterType.EQUALS, ZPU_PERFIL_CODIGO, codigoPerfil);
	}
	
	private Perfil obtenerPerfil(String codigoPerfil) {
		return genericDao.get(Perfil.class, obtenerFiltroPerfil(codigoPerfil));
	}

	private Filter obtenerFiltroGrupo(String codigoGrupo) {
		return genericDao.createFilter(FilterType.EQUALS, CODIGO_USUARIO, codigoGrupo);
	}
	
	private Filter obtenerFiltroGUGrupo(String codigoGrupo) {
		return genericDao.createFilter(FilterType.EQUALS, GU_CODIGO_USUARIO, codigoGrupo);
	}
	
	private Usuario obtenerGrupo(String codigoUsuario) {
		return genericDao.get(Usuario.class, obtenerFiltroGrupo(codigoUsuario));
	}
	
	private Filter obtenerFiltroIdUsuario(Usuario usuario) {
		return genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
	}
	
	private Filter obtenerFiltroDescCartera(String descCartera) {
		return genericDao.createFilter(FilterType.EQUALS, DESCRIPCION, descCartera);
	}
	
	private Filter obtenerFiltroUCADescripcionCartera(String descCartera) {
		return genericDao.createFilter(FilterType.EQUALS, UCA_DESCRIPCION, descCartera);
	}
	
	private DDCartera obtenerCartera(String descCartera) {
		return genericDao.get(DDCartera.class, obtenerFiltroDescCartera(descCartera));
	}
	
	private Filter obtenerFiltroCodigoSubcartera(String descSubcartera) {
		return genericDao.createFilter(FilterType.EQUALS, DESCRIPCION, descSubcartera);
	}
	
	private Filter obtenerFiltroUCADescripcionSubcartera(String descSubcartera) {
		return genericDao.createFilter(FilterType.EQUALS, UCA_DESCRIPCION_SUB, descSubcartera);
	}
	
	private void eliminarCarterasFiltro(Filter filtroUsuario, String username) {
		Filter filtroCarteraNotNull = genericDao.createFilter(FilterType.NULL, SUB_CARTERA);
		genericDao.delete(UsuarioCartera.class, filtroUsuario, filtroCarteraNotNull);
		logger.info("Eliminamos carteras previamente asociadas al usuario " + username + " dado que tiene subcarteras asociadas.");
	}

}
