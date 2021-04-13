package es.pfsgroup.plugin.rem.configuracion.manager;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.upload.dto.DtoFileUpload;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.configuracion.api.ConfiguracionApi;
import es.pfsgroup.plugin.rem.configuracion.dao.ConfiguracionDao;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ConfiguracionReam;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.DtoMantenimientoFilter;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresEvaluarDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.commons.utils.dao.abm.Order;

@Service("configuracionManager")
public class ConfiguracionManager extends BusinessOperationOverrider<ConfiguracionApi> implements  ConfiguracionApi{

	@Autowired
	private ConfiguracionDao configuracionDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GenericAdapter adapter;
	
	@Resource
	private MessageService messageServices;
	

	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Override
	public String managerName() {
		return "configuracionManager";
	}
	
	protected static final Log logger = LogFactory.getLog(ConfiguracionManager.class);
	
	public static final String SI = "1";
	public static final int VALOR_SI = 1;
	public static final int VALOR_NO = 0;
	
	private static final String ERROR_REGISTROS_DUPLICADOS= "msg.error.configuracion.mantenimiento.error.duplicados";
	
	
	@Override
	public List<DtoMantenimientoFilter> getListMantenimiento(DtoMantenimientoFilter dto) {
		
		return  this.listaToDto(configuracionDao.getListMantenimiento(dto));
	}
	
	@Override
	@BusinessOperationDefinition("configuracionManager.getPropietariosByCartera")
	public List<ActivoPropietario> getPropietariosByCartera(String codCartera) {
		List<ActivoPropietario> listaPropietario = new ArrayList<ActivoPropietario>();

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", codCartera);
		Order order = new Order(OrderType.ASC, "nombre");
		List<ActivoPropietario> listaPropietarios = genericDao.getListOrdered(ActivoPropietario.class, order,
				filtroBorrado, filtroCartera);

		for (ActivoPropietario activoPropietario : listaPropietarios) {
			ActivoPropietario actProp = new ActivoPropietario();
			actProp.setId(activoPropietario.getId());
			actProp.setNombre(activoPropietario.getNombre());
			listaPropietario.add(actProp);
		}

		return listaPropietario;
	}

	@Override
	@BusinessOperationDefinition("configuracionManager.getSubcarteraFilterByCartera")
	public List<DDSubcartera> getSubcarteraFilterByCartera(String codCartera) {
		List<DDSubcartera> listaSubcarteras = new ArrayList<DDSubcartera>();
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", codCartera);
		Order order = new Order(OrderType.ASC, "descripcion");
		
		List<DDSubcartera> listaSubcarterasOrder = genericDao.getListOrdered(DDSubcartera.class,order,filtroBorrado,filtroCartera);
		
		for (DDSubcartera ddSubcartera : listaSubcarterasOrder) {
			DDSubcartera subcartera = new DDSubcartera();
			subcartera.setId(ddSubcartera.getId());
			subcartera.setCodigo(ddSubcartera.getCodigo());
			subcartera.setDescripcion(ddSubcartera.getDescripcion());
			listaSubcarteras.add(subcartera);
		}
		return listaSubcarteras;
	}
	
	
	private List<DtoMantenimientoFilter> listaToDto (List<ConfiguracionReam> listaConfReam) {
		
		List<DtoMantenimientoFilter> listaDto = new ArrayList<DtoMantenimientoFilter>();
		DtoMantenimientoFilter dto;
		for (ConfiguracionReam iterator : listaConfReam) {
			dto = new DtoMantenimientoFilter();
			dto.setId(iterator.getId());
			dto.setCodCartera(iterator.getCartera().getDescripcion());
			if (iterator.getSubcartera() != null) {
				dto.setCodSubCartera(iterator.getSubcartera().getDescripcion());
			}
			if (iterator.getPropietario() != null) {
				dto.setCodPropietario(iterator.getPropietario().getId());
				dto.setNombrePropietario(iterator.getPropietario().getNombre());
			}
			if (iterator.getCarteraMacc() != null) {
				dto.setCarteraMacc("1".equals(iterator.getCarteraMacc().toString()) ? "Si" : "No");
			}						
			if (iterator.getAuditoria() != null && iterator.getAuditoria().getFechaCrear() != null) {
				dto.setFechaCrear(iterator.getAuditoria().getFechaCrear());
			}
			if (iterator.getAuditoria() != null && iterator.getAuditoria().getUsuarioCrear() != null) {
				dto.setUsuarioCrear(iterator.getAuditoria().getUsuarioCrear());
			}
			
			
			listaDto.add(dto);
		}
		
		
		return listaDto;
		
	}
	

	@Override
	@Transactional(readOnly = false)
	public Boolean deleteMantenimiento(Long idMantenimiento) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idMantenimiento);
			ConfiguracionReam confReam = genericDao.get(ConfiguracionReam.class, filtro);
			if(confReam != null){
				genericDao.deleteById(ConfiguracionReam.class, confReam.getId());
			}
			
		} catch (Exception e) {
			logger.error("Error en ConfiguracionManager, deleteMantenimiento", e);
		}

		return true;
	}
	@Override
	@Transactional(readOnly = false)
	public Boolean createMantenimiento(DtoMantenimientoFilter dto) throws DataIntegrityViolationException, IllegalAccessException, InvocationTargetException{
		ConfiguracionReam configuracionReam = new ConfiguracionReam();		
		ActivoPropietario propietario = null;
		DDCartera cartera = null;
		DDSubcartera subcartera = null;
		
		Filter carteraCodFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodCartera());
		cartera = genericDao.get(DDCartera.class, carteraCodFilter);
		
		Filter subcarteraCodFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodSubCartera());
		if (subcarteraCodFilter != null) {
			subcartera = genericDao.get(DDSubcartera.class, subcarteraCodFilter);
		}
		if (dto.getCodPropietario() != null && !Checks.esNulo(dto.getCodPropietario())) {
			Filter propietarioIdFilter = genericDao.createFilter(FilterType.EQUALS, "id", dto.getCodPropietario());
			if (propietarioIdFilter != null) {
				propietario = genericDao.get(ActivoPropietario.class, propietarioIdFilter);
			}
		}
		
		
			if (cartera != null) {
				beanUtilNotNull.copyProperty(configuracionReam, "cartera", cartera);
			}
			if (subcartera != null ) {
				beanUtilNotNull.copyProperty(configuracionReam, "subcartera", subcartera);
			}			
			if (propietario != null) {
				beanUtilNotNull.copyProperty(configuracionReam, "propietario", propietario);
			}
			if (dto.getCarteraMacc() != null && !dto.getCarteraMacc().isEmpty()) {
				if (SI.equalsIgnoreCase(dto.getCarteraMacc())) {
					beanUtilNotNull.copyProperty(configuracionReam, "carteraMacc", VALOR_SI);
				}else {
					beanUtilNotNull.copyProperty(configuracionReam, "carteraMacc", VALOR_NO);
				}
			}
			Usuario usuarioLogado = adapter.getUsuarioLogado();
			if (!Checks.esNulo(usuarioLogado)) {
				Auditoria auditoria = new Auditoria();
				auditoria.setUsuarioCrear(usuarioLogado.getNombre());
				auditoria.setFechaCrear(new Date());
				configuracionReam.setAuditoria(auditoria);
			} else {
				return false;
			}

			genericDao.save(ConfiguracionReam.class, configuracionReam);
	
		return true;
		
	}
	
}
