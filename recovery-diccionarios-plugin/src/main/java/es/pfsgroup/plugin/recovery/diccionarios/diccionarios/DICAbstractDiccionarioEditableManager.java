package es.pfsgroup.plugin.recovery.diccionarios.diccionarios;

import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.TypeVariable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.GeneratedValue;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.hibernate.dao.HibernateDao; //import es.capgemini.devon.hibernate.pagination.PaginationManager;
//import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICDiccionarioEditableLogDaoInterface;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICGenericDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dto.DICDtoBusquedaDiccionario;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dto.DICDtoValorDiccionario;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditableInterface;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditableLogInterface;

@SuppressWarnings("unchecked")
public abstract class DICAbstractDiccionarioEditableManager<D extends DICDiccionarioEditableInterface, L extends DICDiccionarioEditableLogInterface> {

	@Autowired
	private Executor executor;
	
	@Autowired
	private DICGenericDao genericDao;

	protected abstract HibernateDao<D, Long> getDiccionarioDao();

	protected abstract DICDiccionarioEditableLogDaoInterface<L, Long> getLogDao();

	private Map<String, HibernateDao> daos = new HashMap<String, HibernateDao>();

	// private PaginationManager paginationManager;

	public void setDaos(final Map<String, HibernateDao> d) {
		this.daos = d;
	}

	protected List<D> listaDiccionariosEditables() {
		return getDiccionarioDao().getList();
	}

	protected List listaDiccionariosEditablesPaginado() {
		List list = getDiccionarioDao().getList();
		return list;
		// PageSql page = (PageSql)
		// executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
		// PageSql page = new PageSql();
		// page.setResults(list);
		// return page;
	}

	public List<D> findDiccionariosEditable(DICDtoBusquedaDiccionario dto) {
		HQLBuilder hb = new HQLBuilder("select dd from D ");

		hb.appendWhere("dd.auditoria.borrado = 0");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "dd.nombre", dto.getNombre());

		HQLBuilder.addFiltroLikeSiNotNull(hb, "de.descripcion", dto
				.getDescripcion());

		// return paginationManager.getHibernatePage(getHibernateTemplate(),
		// hb.toString(), dto, hb.getParameters());
		// TODO completar la búsqueda de diccionarios para que devuelva una
		// lista paginada
		return (List<D>) hb;
	}

	protected D getDiccionarioEditable(Long idDiccionario) {
		return getDiccionarioDao().get(idDiccionario);
	}

	protected List<DICDtoValorDiccionario> getDiccionarioDatos(
			Long idDiccionario) {
		HibernateDao dao = getDao(idDiccionario);
		ArrayList<DICDtoValorDiccionario> valores = new ArrayList<DICDtoValorDiccionario>();

		for (Object dc : dao.getList()) {
			DICDtoValorDiccionario dto = createDto(idDiccionario, dc);
			valores.add(dto);
		}

		return valores;
	}

	protected DICDtoValorDiccionario getDiccionarioDatosLinea(
			Long idDiccionario, Long idLineaEnDiccionario) {
		HibernateDao dao = getDao(idDiccionario);
		Object o = dao.get(idLineaEnDiccionario);
		return createDto(idDiccionario, o);
	}

	// protected void nuevoDiccionarioDatosLinea2(DICDtoValorDiccionario dto) {
	// HibernateDao dao = getDao(dto.getIdDiccionarioEditable());
	// Object viejo = dao.get(dto.getIdLineaEnDiccionario());
	/*
	 * Object viejo = null ; if (Checks.esNulo(viejo)) { throw new
	 * IllegalStateException( "No exise la linea que se quiere editar"); }
	 * ADMDtoValorDiccionario valorAntiguo = createDto(dto
	 * .getIdDiccionarioEditable(), viejo);
	 */
	// Serializable nuevo = createPersistentObject(dto, dao);
	// dao.save(nuevo);
	// createSucesoDiccionarioLog(valorAntiguo, dto);
	// createSucesoDiccionarioLog(null, dto);
	// }

	protected void nuevoDiccionarioDatosLinea(DICDtoValorDiccionario dto) {
		HibernateDao dao = getDao(dto.getIdDiccionarioEditable());
		Serializable nuevo = createPersistentObject(dto, dao);
		
		createSucesoDiccionarioLog(null, dto);
		
		dao.save(nuevo);

	}

	private Serializable createPersistentObject(DICDtoValorDiccionario dto,
			HibernateDao dao) {
		try {
			ParameterizedType parameterizedType = (ParameterizedType) dao
					.getClass().getGenericSuperclass();
			Class c = (Class) parameterizedType.getActualTypeArguments()[0];
			Object o = c.newInstance();
			changePersistentObject(dto, o, dao);
			return (Serializable) o;
		} catch (Exception e) {
			throw new BusinessOperationException(e);
		}
	}

	protected void editarDiccionarioDatosLinea(DICDtoValorDiccionario dto) {
		HibernateDao dao = getDao(dto.getIdDiccionarioEditable());
		Object viejo = dao.get(dto.getIdLineaEnDiccionario());
		if (Checks.esNulo(viejo)) {
			throw new IllegalStateException(
					"No exise la linea que se quiere editar");
		}
		DICDtoValorDiccionario valorAntiguo = createDto(dto
				.getIdDiccionarioEditable(), viejo);
		try {
			changePersistentObject(dto, viejo,dao);
			dao.save((Serializable) viejo);
			createSucesoDiccionarioLog(valorAntiguo, dto);
		} catch (Exception e) {
			throw new BusinessOperationException(e);
		}
	}

	private void changePersistentObject(DICDtoValorDiccionario dto, Object o, HibernateDao dao)
			throws Exception {
		Class c = o.getClass();
		seteaIdSiNoSecuencia(o,dao);
		c.getMethod("setCodigo", String.class).invoke(o, dto.getCodigo());
		c.getMethod("setDescripcion", String.class).invoke(o,
				dto.getDescripcion());
		c.getMethod("setDescripcionLarga", String.class).invoke(o,
				dto.getDescripcionLarga());
	}

	private void seteaIdSiNoSecuencia(Object o,HibernateDao dao) {
		try {
			Field f = o.getClass().getDeclaredField("id");
			Object v = o.getClass().getMethod("getId").invoke(o);
			Annotation a = f.getAnnotation(GeneratedValue.class);
			if ((v == null) && (a == null)){
				Long newId = genericDao.getLastId(o.getClass()) + 1L;
				o.getClass().getMethod("setId",Long.class).invoke(o, newId);
			}
		} catch (Exception e) {
			throw new BusinessOperationException(o.getClass().getName().concat(" no tiene un campo ID"));
		}
	}

	public void eliminarDiccionarioDatosLinea(Long id, Long idValor) {
		HibernateDao dao = getDao(id);
		Serializable viejo = dao.get(idValor);
		if (Checks.esNulo(viejo)) {
			throw new IllegalStateException(
					"No exise la linea que se quiere eliminar");
		}
		DICDtoValorDiccionario valorAntiguo = createDto(id, viejo);
		try {
			createSucesoDiccionarioLog(valorAntiguo, null);
			dao.delete(viejo);
		} catch (Exception e) {
			throw new BusinessOperationException(e);
		}
	}

	protected List<L> listarSucesosDiccionarioEditable(
			Long idDiccionarioEditable) {
		return getLogDao().findByIdDiccionario(idDiccionarioEditable);
	}

	private HibernateDao getDao(Long idDiccionario) {
		String nombreDiccionario = getDiccionarioDao().get(idDiccionario)
				.getNombreTabla();
		HibernateDao dao = daos.get(nombreDiccionario);
		if (Checks.esNulo(dao)) {
			throw new IllegalStateException(nombreDiccionario
					.concat(": No se encuentra el DAO"));
		}
		return dao;
	}

	private DICDtoValorDiccionario createDto(Long idDiccionario, Object dc) {
		try {
			DICDtoValorDiccionario dto = new DICDtoValorDiccionario();
			Class c = dc.getClass();
			dto.setIdLineaEnDiccionario((Long) c.getMethod("getId", null)
					.invoke(dc, null));
			dto.setIdDiccionarioEditable(idDiccionario);
			dto.setCodigo((String) c.getMethod("getCodigo", null).invoke(dc,
					null));
			dto.setDescripcion((String) c.getMethod("getDescripcion", null)
					.invoke(dc, null));
			dto.setDescripcionLarga((String) c.getMethod("getDescripcionLarga",
					null).invoke(dc, null));
			return dto;
		} catch (Exception e) {
			throw new BusinessOperationException(e);
		}
	}

	private void createSucesoDiccionarioLog(DICDtoValorDiccionario valorAntiguo, DICDtoValorDiccionario valorNuevo) {
		if (valorNuevo==null){
			// Borrado
			saveLogDiccionario(valorAntiguo.getIdDiccionarioEditable(), 
					"Borrado", valorAntiguo.getDescripcion(), " ");
		} else {
			if (valorNuevo.getIdLineaEnDiccionario() != null) {
					// Edición
					if (!valorNuevo.getDescripcion().equals(valorAntiguo.getDescripcion())) {
						saveLogDiccionario(valorNuevo.getIdDiccionarioEditable(), 
								"Edición", valorAntiguo.getDescripcion(), valorNuevo.getDescripcion());
					}
					if (!valorNuevo.getDescripcionLarga().equals(valorAntiguo.getDescripcionLarga())) {
						saveLogDiccionario(valorNuevo.getIdDiccionarioEditable(), 
								"Edición", valorAntiguo.getDescripcionLarga(), valorNuevo.getDescripcionLarga());
					}
					if (!valorNuevo.getCodigo().equals(valorAntiguo.getCodigo())) {
						saveLogDiccionario(valorNuevo.getIdDiccionarioEditable(), 
								"Edición", valorAntiguo.getCodigo(), valorNuevo.getCodigo());
					}
			} else {
					// Nuevo
					if (valorNuevo.getDescripcion() != null) {
						saveLogDiccionario(valorNuevo.getIdDiccionarioEditable(), 
								"Nuevo", null, valorNuevo.getDescripcion());
					}
					if (valorNuevo.getDescripcionLarga() != null) {
						saveLogDiccionario(valorNuevo.getIdDiccionarioEditable(), 
								"Nuevo", null, valorNuevo.getDescripcionLarga());
					}
					if (valorNuevo.getCodigo() != null) {
						saveLogDiccionario(valorNuevo.getIdDiccionarioEditable(), 
								"Nuevo", null, valorNuevo.getCodigo());
					}
			}
		}
	}

	private void saveLogDiccionario(Long idDiccionarioEditable, String accion, String valorAnterior, String valorNuevo) {
		L logDiccionario;
		try {
			logDiccionario = (L) ((Class) ((ParameterizedType) this.getClass()
					.getGenericSuperclass()).getActualTypeArguments()[1])
					.newInstance();
		} catch (Exception e) {
			throw new BusinessOperationException(e);
		}
		
		Usuario u = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		logDiccionario.setUsuario(u.getApellidoNombre());
		logDiccionario.setDiccionario(getDiccionarioDao().get(idDiccionarioEditable));
		logDiccionario.setFecha(new Date());
		
		logDiccionario.setAccion(accion);
		logDiccionario.setValorAnterior(valorAnterior);
		logDiccionario.setValorNuevo(valorNuevo);
		getLogDao().save(logDiccionario);
	}

}