package es.pfsgroup.plugin.rem.security.jupiter;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
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

@Repository("IntegracionJupiterDao")
public class IntegracionJupiterDaoImpl extends AbstractEntityDao<MapeoJupiterREM, Long> implements IntegracionJupiterDao {

	private static final String USUARIO_USERNAME = "usuario.username";
	private static final String CODIGO = "codigo";
	private static final String USUARIO_ID = "usuario.id";
	private static final String DESCRIPCION = "descripcion";
	private static final String ZPU_ZONA_DESCRIPCION = "zona.descripcion";
	private static final String CODIGO_ZONA_REM = "REM";
	private static final String PERFIL_CODIGO = "codigo";
	private static final String ZPU_PERFIL_CODIGO = "perfil.codigo";
	private static final String CODIGO_USUARIO = "username";
	private static final String GU_CODIGO_USUARIO = "grupo.username";
	private static final String UCA_CODIGO = "cartera.codigo";
	private static final String UCA_CODIGO_SUB = "subcartera.codigo";

	private static final Log logger = LogFactory.getLog(IntegracionJupiterDaoImpl.class);
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public void actualizarPerfiles(Usuario usuario, List<String> altasPerfiles, List<String> bajasPerfiles) {
		
		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try {
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
				} else {
					logger.error("No existe el perfil " + codigoPerfil + " en REM: no se crea asociacion con el usuario " + usuario.getUsername());
				}
			}
			Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
			for (String codigoPerfil : bajasPerfiles) {
				genericDao.delete(ZonaUsuarioPerfil.class, filtroUsuario, obtenerFiltroZPUPerfil(codigoPerfil));
				logger.debug("Eliminando asociacion perfil " + codigoPerfil + " - usuario " + usuario.getUsername());
			}
			tx.commit();
		} catch (Exception e) {
			logger.error("Error al persistir los cambios de perfil del usuario: ", e);
			tx.rollback();
		} finally {
			if (session.isOpen()) {
				session.flush();
				session.close();
			}
		}

	}

	@Override
	public void actualizarGrupos(Usuario usuario, List<String> altasGrupos, List<String> bajasGrupos) {

		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try {
			for (String codigoGrupo : altasGrupos) {
				Usuario grupo = obtenerGrupo(codigoGrupo);
				if (grupo != null) {
					GrupoUsuario nuevaRelGrupoUsuario = new GrupoUsuario();
					nuevaRelGrupoUsuario.setGrupo(grupo);
					nuevaRelGrupoUsuario.setUsuario(usuario);
					nuevaRelGrupoUsuario.setAuditoria(Auditoria.getNewInstance());
					nuevaRelGrupoUsuario.setVersion(0);
					genericDao.save(GrupoUsuario.class, nuevaRelGrupoUsuario);
					logger.debug("Creando asociacion grupo " + codigoGrupo + " - usuario " + usuario.getUsername());
				} else {
					logger.error("No existe el grupo " + codigoGrupo + " en REM: no se crea asociacion con el usuario " + usuario.getUsername());
				}
			}	
			Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
			for (String codigoGrupo : bajasGrupos) {
				genericDao.delete(GrupoUsuario.class, filtroUsuario, obtenerFiltroGUGrupo(codigoGrupo));
				logger.debug("Eliminando asociacion grupo " + codigoGrupo + " - usuario " + usuario.getUsername());
			}
			tx.commit();
		} catch (Exception e) {
			logger.error("Error al persistir los cambios de grupos del usuario: ", e);
			tx.rollback();
		} finally {
			if (session.isOpen()) {
				session.flush();
				session.close();
			}
		}
		
	}

	@Override
	public void actualizarCarteras(Usuario usuario, List<String> altasCarteras, List<String> bajasCarteras) {

		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try {		
			for (String codigoCartera : altasCarteras) {
				DDCartera cartera = obtenerCartera(codigoCartera);
				if (cartera != null) {
					UsuarioCartera usuarioCarteraNuevo = new UsuarioCartera();
					usuarioCarteraNuevo.setUsuario(usuario);
					usuarioCarteraNuevo.setCartera(cartera);
					genericDao.save(UsuarioCartera.class, usuarioCarteraNuevo);
					logger.debug("Creando asociacion cartera " + codigoCartera + " - usuario " + usuario.getUsername());
				} else {
					logger.error("No existe la cartera " + codigoCartera + " en REM: no se crea asociacion con el usuario " + usuario.getUsername());
				}
			}		
			Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
			for (String codigoCartera : bajasCarteras) {
				genericDao.delete(UsuarioCartera.class, filtroUsuario, obtenerFiltroUCACodigoCartera(codigoCartera));
				logger.debug("Eliminando asociacion cartera " + codigoCartera + " - usuario " + usuario.getUsername());
			}
			tx.commit();
		} catch (Exception e) {
			logger.error("Error al persistir los cambios de carteras del usuario: ", e);
			tx.rollback();
		} finally {
			if (session.isOpen()) {
				session.flush();
				session.close();
			}
		}
		
	}

	@Override
	public void actualizarSubcarteras(Usuario usuario, List<String> altasSubcarteras, List<String> bajasSubcarteras) {

		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try {
			for (String codigoSubcartera : altasSubcarteras) {
				DDSubcartera subcartera= genericDao.get(DDSubcartera.class, obtenerFiltroCodigoSubcartera(codigoSubcartera));
				if (subcartera != null) {
					UsuarioCartera usuarioSubcarteraNuevo = new UsuarioCartera();
					usuarioSubcarteraNuevo.setUsuario(usuario);
					usuarioSubcarteraNuevo.setCartera(subcartera.getCartera());
					usuarioSubcarteraNuevo.setSubCartera(subcartera);
					genericDao.save(UsuarioCartera.class, usuarioSubcarteraNuevo);
					logger.debug("Creando asociacion subcartera " + codigoSubcartera + " - usuario " + usuario.getUsername());
				} else {
					logger.error("No existe la subcartera " + codigoSubcartera + " en REM: no se crea asociacion con el usuario " + usuario.getUsername());
				}
			}
			Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
			for (String codigoSubcartera : bajasSubcarteras) {
				genericDao.delete(UsuarioCartera.class, filtroUsuario, obtenerFiltroUCACodigoSubcartera(codigoSubcartera));
				logger.debug("Eliminando asociacion subcartera " + codigoSubcartera + " - usuario " + usuario.getUsername());
			}
			tx.commit();
		} catch (Exception e) {
			logger.error("Error al persistir los cambios de subcarteras del usuario: ", e);
			tx.rollback();
		} finally {
			if (session.isOpen()) {
				session.flush();
				session.close();
			}
		}
				
	}

	public void actualizarUsuario(Usuario usuario, String nombre, String apellidos, String email) {
		
		String ape1;
		String ape2;
		
		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try {
			usuario.setNombre(nombre);
			if (apellidos.contains(" ")) {
				ape1 = apellidos.split(" ")[0];
				ape2 = apellidos.split(" ", 2)[1];
			} else {
				ape1 = apellidos;
				ape2 = "";
			}
			usuario.setApellido1(ape1);
			usuario.setApellido2(ape2);
			usuario.setEmail(email);
			genericDao.save(Usuario.class, usuario);
			tx.commit();
		} catch (Exception e) {
			logger.error("Error al actualizar datos personales del usuario: " + e.getMessage());
			tx.rollback();
		} finally {
			if (session.isOpen()) {
				session.flush();
				session.close();
			}
		}
		
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
	
	private Filter obtenerFiltroCodigoCartera(String codigoCartera) {
		return genericDao.createFilter(FilterType.EQUALS, DESCRIPCION, codigoCartera);
	}
	
	private Filter obtenerFiltroUCACodigoCartera(String codigoCartera) {
		return genericDao.createFilter(FilterType.EQUALS, UCA_CODIGO, codigoCartera);
	}
	
	private DDCartera obtenerCartera(String codigoCartera) {
		return genericDao.get(DDCartera.class, obtenerFiltroCodigoCartera(codigoCartera));
	}
	
	private Filter obtenerFiltroCodigoSubcartera(String codigoSubcartera) {
		return genericDao.createFilter(FilterType.EQUALS, CODIGO, codigoSubcartera);
	}
	
	private Filter obtenerFiltroUCACodigoSubcartera(String codigoSubcartera) {
		return genericDao.createFilter(FilterType.EQUALS, UCA_CODIGO_SUB, codigoSubcartera);
	}
	
	public List<String> getCodigosCarterasREM(Usuario usuario) {
		List<String> resultado = new ArrayList<String>();
		Filter filtroUca = genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
		List<UsuarioCartera> uca = genericDao.getList(UsuarioCartera.class, filtroUca);
		if (uca != null && !uca.isEmpty()) {
			resultado.add(uca.get(0).getCartera().getCodigo());
		}
		return resultado;
	}

	public List<String> getCodigosSubcarterasREM(Usuario usuario) {
		List<String> resultado = new ArrayList<String>();
		Filter filtroUca = genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
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

}
