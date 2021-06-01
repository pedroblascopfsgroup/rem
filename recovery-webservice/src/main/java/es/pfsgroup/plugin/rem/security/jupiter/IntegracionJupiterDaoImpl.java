package es.pfsgroup.plugin.rem.security.jupiter;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;
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
import es.pfsgroup.plugin.rem.activoproveedor.dao.ActivoProveedorDao;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.GrupoUsuario;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;

@Repository("IntegracionJupiterDao")
public class IntegracionJupiterDaoImpl extends AbstractEntityDao<MapeoJupiterREM, Long> implements IntegracionJupiterDao {

	private static final String CODIGO = "codigo";
	private static final String USUARIO_ID = "usuario.id";
	private static final String ZONA_DESCRIPCION = "descripcion";
	private static final String CODIGO_ZONA_REM = "REM";
	private static final String PERFIL_CODIGO = "perfil.codigo";
	private static final String CODIGO_USUARIO = "username";

	private static final Log logger = LogFactory.getLog(IntegracionJupiterDaoImpl.class);

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public void actualizarPerfiles(Usuario usuario, List<String> altasPerfiles, List<String> bajasPerfiles) {
		
		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try {
			DDZona zona = genericDao.get(DDZona.class, 
					genericDao.createFilter(FilterType.EQUALS, ZONA_DESCRIPCION, CODIGO_ZONA_REM));
			for (String codigoPerfil : altasPerfiles) {
				ZonaUsuarioPerfil zpu = new ZonaUsuarioPerfil();
				zpu.setUsuario(usuario);
				zpu.setPerfil(obtenerPerfil(codigoPerfil));
				zpu.setZona(zona);
				zpu.setAuditoria(Auditoria.getNewInstance());
				zpu.setVersion(0);
				genericDao.save(ZonaUsuarioPerfil.class, zpu);
				logger.debug("Creando asociación perfil " + codigoPerfil + " - usuario " + usuario.getUsername());
			}
			Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
			for (String codigoPerfil : bajasPerfiles) {
				genericDao.delete(ZonaUsuarioPerfil.class, filtroUsuario, obtenerFiltroPerfil(codigoPerfil));
				logger.debug("Eliminando asociación perfil " + codigoPerfil + " - usuario " + usuario.getUsername());
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
				GrupoUsuario grupoNuevo = new GrupoUsuario();
				grupoNuevo.setGrupo(obtenerGrupo(codigoGrupo));
				grupoNuevo.setUsuario(usuario);
				//grupoNuevo.setAuditoria
				genericDao.save(GrupoUsuario.class, grupoNuevo);
				logger.debug("Creando asociación grupo " + codigoGrupo + " - usuario " + usuario.getUsername());
			}	
			Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
			for (String codigoGrupo : bajasGrupos) {
				genericDao.delete(GrupoUsuario.class, filtroUsuario, obtenerFiltroGrupo(codigoGrupo));
				logger.debug("Eliminando asociación grupo " + codigoGrupo + " - usuario " + usuario.getUsername());
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
				UsuarioCartera usuarioCarteraNuevo = new UsuarioCartera();
				usuarioCarteraNuevo.setUsuario(usuario);
				usuarioCarteraNuevo.setCartera(obtenerCartera(codigoCartera));
				genericDao.save(UsuarioCartera.class, usuarioCarteraNuevo);
				logger.debug("Creando asociación cartera " + codigoCartera + " - usuario " + usuario.getUsername());
			}		
			Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
			for (String codigoCartera : bajasCarteras) {
				genericDao.delete(UsuarioCartera.class, filtroUsuario, obtenerFiltroCodigoCartera(codigoCartera));
				logger.debug("Eliminando asociación cartera " + codigoCartera + " - usuario " + usuario.getUsername());
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
			for (String codigoSubartera : altasSubcarteras) {
				UsuarioCartera usuarioSubcarteraNuevo = new UsuarioCartera();
				DDSubcartera subcartera= genericDao.get(DDSubcartera.class, obtenerFiltroCodigoSubcartera(codigoSubartera));
				usuarioSubcarteraNuevo.setUsuario(usuario);
				usuarioSubcarteraNuevo.setCartera(subcartera.getCartera());
				usuarioSubcarteraNuevo.setSubCartera(subcartera);
				genericDao.save(UsuarioCartera.class, usuarioSubcarteraNuevo);
				logger.debug("Creando asociación subcartera " + codigoSubartera + " - usuario " + usuario.getUsername());
			}
			Filter filtroUsuario = obtenerFiltroIdUsuario(usuario);
			for (String codigoSubcartera : bajasSubcarteras) {
				genericDao.delete(UsuarioCartera.class, filtroUsuario, obtenerFiltroCodigoSubcartera(codigoSubcartera));
				logger.debug("Eliminando asociación subcartera " + codigoSubcartera + " - usuario " + usuario.getUsername());
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

	@Override
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
	
	private Perfil obtenerPerfil(String codigoPerfil) {
		return genericDao.get(Perfil.class, obtenerFiltroPerfil(codigoPerfil));
	}

	private Filter obtenerFiltroGrupo(String codigoGrupo) {
		return genericDao.createFilter(FilterType.EQUALS, CODIGO_USUARIO, codigoGrupo);
	}
	
	private Usuario obtenerGrupo(String codigoUsuario) {
		return genericDao.get(Usuario.class, obtenerFiltroGrupo(codigoUsuario));
	}
	
	private Filter obtenerFiltroIdUsuario(Usuario usuario) {
		return genericDao.createFilter(FilterType.EQUALS, USUARIO_ID, usuario.getId());
	}
	
	private Filter obtenerFiltroCodigoCartera(String codigoCartera) {
		return genericDao.createFilter(FilterType.EQUALS, CODIGO, codigoCartera);
	}
	
	private DDCartera obtenerCartera(String codigoCartera) {
		return genericDao.get(DDCartera.class, obtenerFiltroCodigoCartera(codigoCartera));
	}
	
	private Filter obtenerFiltroCodigoSubcartera(String codigoSubcartera) {
		return genericDao.createFilter(FilterType.EQUALS, CODIGO, codigoSubcartera);
	}
	
}
