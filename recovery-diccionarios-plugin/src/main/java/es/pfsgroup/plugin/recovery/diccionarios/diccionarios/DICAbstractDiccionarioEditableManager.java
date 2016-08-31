package es.pfsgroup.plugin.recovery.diccionarios.diccionarios;

import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.TypeVariable;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.persistence.GeneratedValue;

import org.hibernate.cfg.Configuration;
import org.hibernate.metadata.ClassMetadata;
import org.hibernate.persister.entity.AbstractEntityPersister;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.hibernate.dao.HibernateDao; //import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.pfs.auditoria.model.Auditoria;
//import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICDiccionarioEditableLogDaoInterface;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICDiccionarioModeloDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICGenericDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.impl.DICDiccionarioModeloDaoImpl;
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
	
	@Autowired
	private DICDiccionarioModeloDao dicDiccionarioModeloDao;
	
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
		// TODO completar la b�squeda de diccionarios para que devuelva una
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
		D dicc=getDiccionarioEditable(dto.getIdDiccionarioEditable());
		String nombreTabla=dicc.getNombreTabla();
		if(existeCodDic(dto,nombreTabla)==1){
			throw new IllegalStateException("El codigo introducido ya existe");
		}else{
			if(existeCodDic(dto,nombreTabla)==2){
				dicDiccionarioModeloDao.updateLineaDic(dto,nombreTabla);	
			}else{
				Serializable nuevo = createPersistentObject(dto, dao);		
				createSucesoDiccionarioLog(null, dto);
				dao.save(nuevo);
			}		
		}
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
	
	private int existeCodDic(DICDtoValorDiccionario dto,String nombreTabla) {
		List<DICDtoValorDiccionario> lineas = new ArrayList<DICDtoValorDiccionario>();
		lineas=getDiccionarioDatos(dto.getIdDiccionarioEditable());
		int existe=0;
		for (DICDtoValorDiccionario dc : lineas) {
			//Si existe código sin borrado (mensaje de error)
			if(dc.getCodigo().equals(dto.getCodigo()) && !dc.getAuditoria().isBorrado()){
				existe=1;
				break;
			}else{
				//Si existe código con borrado (update)
				if(dicDiccionarioModeloDao.existeCodigoConBorrado(dto,nombreTabla)){
					existe=2;
				}	
			}
		}
		return existe;
	}
	
	
	protected void editarDiccionarioDatosLinea(DICDtoValorDiccionario dto) {
		HibernateDao dao = getDao(dto.getIdDiccionarioEditable());
		Object viejo = dao.get(dto.getIdLineaEnDiccionario());
		D dicc=getDiccionarioEditable(dto.getIdDiccionarioEditable());
		String nombreTabla=dicc.getNombreTabla();
		
		if(!dto.getCodigoDiccionarioEditable().equals(dto.getCodigo())){
			if(existeCodDic(dto,nombreTabla)==1){
				throw new IllegalStateException("El codigo introducido ya existe");
			}else{
				if(existeCodDic(dto,nombreTabla)==2){
					dicDiccionarioModeloDao.updateLineaDic(dto,nombreTabla);
					eliminarDiccionarioDatosLinea(dto.getIdDiccionarioEditable(),dto.getIdLineaEnDiccionario());
				}else{
						editaDicLinea(dto, dao, viejo);	
					}
				}
			}else{
				editaDicLinea(dto, dao, viejo);	
			}
		
	}

	private void editaDicLinea(DICDtoValorDiccionario dto, HibernateDao dao,
			Object viejo) {
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
			} 	catch (Exception e) {
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
	
	private void changePersistentAuditoriaObject(DICDtoValorDiccionario dto, Object o, HibernateDao dao)
			throws Exception {
		Class c = o.getClass();
		Auditoria audi = new Auditoria();
		audi.setBorrado(false);
		dto.setAuditoria(audi);
		c.getMethod("setAuditoria", Auditoria.class).invoke(o, dto.getAuditoria());
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
			dto.setCodigoDiccionarioEditable((String) c.getMethod("getCodigo", null).invoke(dc,
					null));
			dto.setAuditoria((Auditoria) c.getMethod("getAuditoria", null).invoke(dc,	null));
			
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
					// Edici�n
					if (!valorNuevo.getDescripcion().equals(valorAntiguo.getDescripcion())) {
						saveLogDiccionario(valorNuevo.getIdDiccionarioEditable(), 
								"Edici�n", valorAntiguo.getDescripcion(), valorNuevo.getDescripcion());
					}
					if (!valorNuevo.getDescripcionLarga().equals(valorAntiguo.getDescripcionLarga())) {
						saveLogDiccionario(valorNuevo.getIdDiccionarioEditable(), 
								"Edici�n", valorAntiguo.getDescripcionLarga(), valorNuevo.getDescripcionLarga());
					}
					if (!valorNuevo.getCodigo().equals(valorAntiguo.getCodigo())) {
						saveLogDiccionario(valorNuevo.getIdDiccionarioEditable(), 
								"Edici�n", valorAntiguo.getCodigo(), valorNuevo.getCodigo());
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