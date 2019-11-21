package es.pfsgroup.plugin.rem.proveedores;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoIntegrado;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorCartera;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoProveedorDireccion;
import es.pfsgroup.plugin.rem.model.DtoActivoIntegrado;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoDireccionDelegacion;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvalua;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvaluaFilter;
import es.pfsgroup.plugin.rem.model.DtoMediadorOferta;
import es.pfsgroup.plugin.rem.model.DtoMediadorStats;
import es.pfsgroup.plugin.rem.model.DtoPersonaContacto;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.EntidadProveedor;
import es.pfsgroup.plugin.rem.model.MapeoGestorDocumental;
import es.pfsgroup.plugin.rem.model.ProveedorTerritorial;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedoresActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedorRetirar;
import es.pfsgroup.plugin.rem.model.dd.DDCargoProveedorContacto;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDOperativa;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoProcesoBlanqueo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivosCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoContenedorProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDireccionProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresCarteraDao;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresEvaluarDao;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresOfertasDao;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;

@Service("proveedoresManager")
public class ProveedoresManager extends BusinessOperationOverrider<ProveedoresApi> implements  ProveedoresApi {

	public static final String PROVEEDOR_EXISTS_EXCEPTION_CODE = "0001";
	public static final String USUARIO_NOT_EXISTS_EXCEPTION_CODE = "0002";
	public static final String ERROR_EVALUAR_MEDIADORES_CODE = "0003";
	public static final String ID_HAYA = "ID_HAYA";
	public static final String PROVEEDOR_EXISTS_EXCEPTION_MESSAGE = "Ya existe un proveedor con el NIF y características proporcionadas";
	public static final String USUARIO_NOT_EXISTS_EXCEPTION_MESSAGE = "No se ha encontrado el usuario especificado";
	public static final String ERROR_EVALUAR_MEDIADORES_MESSAGE = "Error al evaluar mediadores con calificaciones propuestas";
	public static final String BAJA_PROVEEDOR_ACTIVOS_ASIGNADOS = "proveedor.baja.proveedor.con.activos";
	public static final String ERROR_TIPO_DOCUMENTO_PROVEEDOR = "No existe el tipo de documento indicado";
	public static final String ERROR_SUBTIPO_DOCUMENTO_PROVEEDOR = "No existe el subtipo de documento indicado";

	public static final Integer comboOK = 1;
	public static final Integer comboKO = 0;

	protected static final Log logger = LogFactory.getLog(ProveedoresManager.class);

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ProveedoresDao proveedoresDao;
	
	@Autowired
	private GestorActivoDao gestorActivoDao;	
	
	@Autowired
	private MediadoresEvaluarDao mediadoresEvaluarDao;
	
	@Autowired
	private MediadoresCarteraDao mediadoresCarteraDao;
	
	@Autowired
	private MediadoresOfertasDao mediadoresOfertasDao;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Resource
	MessageService messageServices;


	@Override
	public String managerName() {
		return "proveedoresManager";
	}
	
	@Override
	public List<DtoProveedorFilter> getProveedores(DtoProveedorFilter dtoProveedorFiltro) {		
		
		
		// Usuario logado, proveedor o gestoria
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		Boolean esProveedor = genericAdapter.isProveedorHayaOrCee(usuarioLogado);
		Boolean esGestoria = genericAdapter.isGestoria(usuarioLogado);
		Boolean esExterno = gestorActivoDao.isUsuarioGestorExterno(usuarioLogado.getId());
		
		// HREOS-2179 - Búsqueda carterizada
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if (!Checks.esNulo(usuarioCartera)){
			if(!Checks.esNulo(usuarioCartera.getSubCartera())){
				dtoProveedorFiltro.setCartera(usuarioCartera.getCartera().getCodigo());
				dtoProveedorFiltro.setSubCartera(usuarioCartera.getSubCartera().getCodigo());
			}else{
				dtoProveedorFiltro.setCartera(usuarioCartera.getCartera().getCodigo());
			}
		}
		
		return proveedoresDao.getProveedoresList(dtoProveedorFiltro, usuarioLogado, esProveedor, esGestoria, esExterno);
	}
	
	@Override
	public List<DtoActivoProveedor> getProveedoresByNif(String nif) {	
		
		List<ActivoProveedor> lista = proveedoresDao.getProveedoresByNifList(nif);
   		List<DtoActivoProveedor> listaProveedores = new ArrayList<DtoActivoProveedor>();
   		
		for(ActivoProveedor proveedor: lista) {
			listaProveedores.add(proveedorToDto(proveedor));			
		}		
		return listaProveedores;
		
	}

	@Override
	public DtoActivoProveedor getProveedorById(Long id) {
		DtoActivoProveedor dto = new DtoActivoProveedor();
		
		ActivoProveedor proveedor = proveedoresDao.getProveedorById(id);
		
		if(!Checks.esNulo(proveedor)) {
			try {
				beanUtilNotNull.copyProperty(dto, "fechaUltimaActualizacion", proveedor.getAuditoria().getFechaModificar());
				beanUtilNotNull.copyProperty(dto, "id", proveedor.getId());
				beanUtilNotNull.copyProperty(dto, "codigo", proveedor.getCodigoProveedorRem());
				beanUtilNotNull.copyProperty(dto, "nombreProveedor", proveedor.getNombre());
				beanUtilNotNull.copyProperty(dto, "fechaAltaProveedor", proveedor.getFechaAlta());
				if(!Checks.esNulo(proveedor.getTipoProveedor())) {
					beanUtilNotNull.copyProperty(dto, "subtipoProveedorCodigo", proveedor.getTipoProveedor().getCodigo());
					if(!Checks.esNulo(proveedor.getTipoProveedor().getTipoEntidadProveedor())) {
						beanUtilNotNull.copyProperty(dto, "tipoProveedorCodigo", proveedor.getTipoProveedor().getTipoEntidadProveedor().getCodigo());
					}
				}
				beanUtilNotNull.copyProperty(dto, "nombreComercialProveedor", proveedor.getNombreComercial());
				beanUtilNotNull.copyProperty(dto, "fechaBajaProveedor", proveedor.getFechaBaja());
				beanUtilNotNull.copyProperty(dto, "nifProveedor", proveedor.getDocIdentificativo());
				if(!Checks.esNulo(proveedor.getTipoDocIdentificativo())) {
					beanUtilNotNull.copyProperty(dto, "tipoDocumentoCodigo", proveedor.getTipoDocIdentificativo().getCodigo());
				}
				beanUtilNotNull.copyProperty(dto, "localizadaProveedorCodigo", proveedor.getLocalizada());
				if(!Checks.esNulo(proveedor.getEstadoProveedor())) {
					beanUtilNotNull.copyProperty(dto, "estadoProveedorCodigo", proveedor.getEstadoProveedor().getCodigo());
				}
				if(!Checks.esNulo(proveedor.getTipoPersona())) {
					beanUtilNotNull.copyProperty(dto, "tipoPersonaProveedorCodigo", proveedor.getTipoPersona().getCodigo());
				}
				beanUtilNotNull.copyProperty(dto, "observacionesProveedor", proveedor.getObservaciones());
				beanUtilNotNull.copyProperty(dto, "webUrlProveedor", proveedor.getPaginaWeb());
				beanUtilNotNull.copyProperty(dto, "fechaConstitucionProveedor", proveedor.getFechaConstitucion());
				beanUtilNotNull.copyProperty(dto, "homologadoCodigo", proveedor.getHomologado());
				
				if(!Checks.esNulo(proveedor.getOperativa())) {
					beanUtilNotNull.copyProperty(dto, "operativaCodigo", proveedor.getOperativa().getCodigo());
				}
				
				Filter proveedorIdFiltro = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId());
				List<ProveedorTerritorial> proveedorTerritorial = genericDao.getList(ProveedorTerritorial.class, proveedorIdFiltro);
				if(!Checks.estaVacio(proveedorTerritorial)) {
					StringBuffer codigos = new StringBuffer();
					for(ProveedorTerritorial pt : proveedorTerritorial) {
						if(!Checks.esNulo(pt.getProvincia())) {
							codigos.append(pt.getProvincia().getCodigo()).append(",");
						}
					}
					beanUtilNotNull.copyProperty(dto, "territorialCodigo", codigos.substring(0, (codigos.length()-1)));
				}

				
				List<EntidadProveedor> entidadProveedores = genericDao.getList(EntidadProveedor.class, proveedorIdFiltro);
				if(!Checks.estaVacio(entidadProveedores)) {
					StringBuffer codigos = new StringBuffer();
					for(EntidadProveedor ent : entidadProveedores) {
						if(!Checks.esNulo(ent.getCartera())) {
							codigos.append(ent.getCartera().getCodigo()).append(",");
						}
					}
					beanUtilNotNull.copyProperty(dto, "carteraCodigo", codigos.substring(0, (codigos.length()-1)));
				}
				//beanUtilNotNull.copyProperty(dto, "subcarteraCodigo", proveedor.get); // TODO: todavia no esta implementado.
				beanUtilNotNull.copyProperty(dto, "custodioCodigo", proveedor.getCustodio());
				if(!Checks.esNulo(proveedor.getTipoActivosCartera())) {
					beanUtilNotNull.copyProperty(dto, "tipoActivosCarteraCodigo", proveedor.getTipoActivosCartera().getCodigo());
				}
				if(!Checks.esNulo(proveedor.getCalificacionProveedor())) {
					beanUtilNotNull.copyProperty(dto, "calificacionCodigo", proveedor.getCalificacionProveedor().getCodigo());
				}
				beanUtilNotNull.copyProperty(dto, "incluidoTopCodigo", proveedor.getTop());
				beanUtilNotNull.copyProperty(dto, "numCuentaIBAN", proveedor.getNumCuenta());
				beanUtilNotNull.copyProperty(dto, "titularCuenta", proveedor.getTitularCuenta());
				beanUtilNotNull.copyProperty(dto, "retencionPagoCodigo", proveedor.getRetener());
				beanUtilNotNull.copyProperty(dto, "fechaRetencion", proveedor.getFechaRetencion());
				if(!Checks.esNulo(proveedor.getMotivoRetencion())) {
					beanUtilNotNull.copyProperty(dto, "motivoRetencionCodigo", proveedor.getMotivoRetencion().getCodigo());
				}
				beanUtilNotNull.copyProperty(dto, "fechaProceso", proveedor.getFechaProcesoBlanqueo());
				beanUtilNotNull.copyProperty(dto, "email", proveedor.getEmail());
				if(!Checks.esNulo(proveedor.getResultadoProcesoBlanqueo())) {
					beanUtilNotNull.copyProperty(dto, "resultadoBlanqueoCodigo", proveedor.getResultadoProcesoBlanqueo().getCodigo());
				}
				beanUtilNotNull.copyProperty(dto, "criterioCajaIVA", proveedor.getCriterioCajaIVA());
				beanUtilNotNull.copyProperty(dto, "fechaEjercicioOpcion", proveedor.getFechaEjercicioOpcion());
				if(proveedor.getAutorizacionWeb() != null && proveedor.getAutorizacionWeb().equals(Integer.valueOf(1))){
					beanUtilNotNull.copyProperty(dto, "autorizacionWeb", "true");
				}else{
					beanUtilNotNull.copyProperty(dto, "autorizacionWeb", "false");
				}
				if(!Checks.esNulo(proveedor.getCodProveedorUvem())) {
					beanUtilNotNull.copyProperty(dto, "codProveedorUvem", proveedor.getCodProveedorUvem());
				}
				
			} catch (IllegalAccessException e) {
				logger.error(e.getMessage());
			} catch (InvocationTargetException e) {
				logger.error(e.getMessage());
			}
		}
		
		return dto;
	}
	
	public List<ActivoProveedor> getProveedoresByActivoId(Long idActivo){
		List<ActivoProveedor> listaProveedores= new ArrayList<ActivoProveedor>();

		//Obtiene de la vista del buscador, la relacion de proveedores de un activo
		List<VBusquedaProveedoresActivo> listadoVBProveedores = activoApi.getProveedorByActivo(idActivo);

		//Transforma la lista de la vista en una lista de proveedores
		for(VBusquedaProveedoresActivo proveedorVB : listadoVBProveedores){
			Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "id", proveedorVB.getIdFalso().getId());
			listaProveedores.add(genericDao.get(ActivoProveedor.class, filtroProveedor));
		}
		
		return listaProveedores;
		
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveProveedorById(DtoActivoProveedor dto) throws Exception {
		ActivoProveedor proveedor = proveedoresDao.getProveedorById(Long.valueOf(dto.getId()));

		try {
			beanUtilNotNull.copyProperty(proveedor, "id", dto.getId());
			beanUtilNotNull.copyProperty(proveedor, "nombre", dto.getNombreProveedor());
			beanUtilNotNull.copyProperty(proveedor, "fechaAlta", dto.getFechaAltaProveedor());
			if(!Checks.esNulo(dto.getSubtipoProveedorCodigo())) {
				// El Subtipo de proveedor (FASE 2) es el tipo de proveedor (FASE 1).
				DDTipoProveedor tipoProveedor = (DDTipoProveedor) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoProveedor.class, dto.getSubtipoProveedorCodigo());
				beanUtilNotNull.copyProperty(proveedor, "tipoProveedor", tipoProveedor);
			}
			beanUtilNotNull.copyProperty(proveedor, "nombreComercial", dto.getNombreComercialProveedor());
			
			beanUtilNotNull.copyProperty(proveedor, "docIdentificativo", dto.getNifProveedor());
			if(!Checks.esNulo(dto.getTipoDocumentoCodigo())) {
				DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getTipoDocumentoCodigo());
				if(!Checks.esNulo(tipoDocumento)) {
					beanUtilNotNull.copyProperty(proveedor, "tipoDocIdentificativo", tipoDocumento);
				}
			}
			if(dto.getAutorizacionWeb() != null){
				if(dto.getAutorizacionWeb().equals("true")){
					proveedor.setAutorizacionWeb(1);
				}else if(dto.getAutorizacionWeb().equals("false")){
					proveedor.setAutorizacionWeb(0);
				}
			}
			
			
			beanUtilNotNull.copyProperty(proveedor, "localizada", dto.getLocalizadaProveedorCodigo());
			if(!Checks.esNulo(dto.getEstadoProveedorCodigo())) {
				DDEstadoProveedor estadoProveedor = (DDEstadoProveedor) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoProveedor.class, dto.getEstadoProveedorCodigo());
				beanUtilNotNull.copyProperty(proveedor, "estadoProveedor", estadoProveedor);
			}
			if(!Checks.esNulo(dto.getTipoPersonaProveedorCodigo())) {
				DDTipoPersona tipoPersona = (DDTipoPersona) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPersona.class, dto.getTipoPersonaProveedorCodigo());
				beanUtilNotNull.copyProperty(proveedor, "tipoPersona", tipoPersona);
			}
			beanUtilNotNull.copyProperty(proveedor, "observaciones", dto.getObservacionesProveedor());
			beanUtilNotNull.copyProperty(proveedor, "paginaWeb", dto.getWebUrlProveedor());
			beanUtilNotNull.copyProperty(proveedor, "fechaConstitucion", dto.getFechaConstitucionProveedor());
			beanUtilNotNull.copyProperty(proveedor, "homologado", dto.getHomologadoCodigo());
			beanUtilNotNull.copyProperty(proveedor, "email", dto.getEmail());
			
			if(!Checks.esNulo(dto.getOperativaCodigo())) {
				DDOperativa operativa = (DDOperativa) utilDiccionarioApi.dameValorDiccionarioByCod(DDOperativa.class, dto.getOperativaCodigo());
				beanUtilNotNull.copyProperty(proveedor, "operativa", operativa);
			}
			
			if(!Checks.esNulo(dto.getTerritorialCodigo())) {
				List<String> codigosTerritorios = Arrays.asList(dto.getTerritorialCodigo().split(","));
				
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId());
				List<ProveedorTerritorial> proveedorTerritorialByProvID = genericDao.getList(ProveedorTerritorial.class, filtroProveedor);
				
				// Borrar los elementos que no vengan en la lista y existan en la DDBB.
				for(ProveedorTerritorial pt : proveedorTerritorialByProvID){
					if(!codigosTerritorios.contains(pt.getProvincia().getCodigo())){
						Filter filtroProvincia = genericDao.createFilter(FilterType.EQUALS, "provincia.id", pt.getProvincia().getId());
						ProveedorTerritorial entidadABorrar = genericDao.get(ProveedorTerritorial.class, filtroProvincia, filtroProveedor);
						if(!Checks.esNulo(entidadABorrar)) {
							genericDao.deleteById(ProveedorTerritorial.class, entidadABorrar.getId());
						}
					}
				}
				
				// Almacenar los elementos que vengan en la lista y no existan en la DDBB.
				// Dejar los elementos que vangan en la lista y exista en la DDBB.
				for(String codigo : codigosTerritorios) {
					DDProvincia provincia = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, codigo);
					if(!Checks.esNulo(provincia)) {
						Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "provincia.id", provincia.getId());
						List<ProveedorTerritorial> proveedoreTerritorial = genericDao.getList(ProveedorTerritorial.class, filtroProveedor, filtroCartera);
						if(Checks.estaVacio(proveedoreTerritorial)) {
							ProveedorTerritorial proveedorTerritorial = new ProveedorTerritorial();
							proveedorTerritorial.setProvincia(provincia);
							proveedorTerritorial.setProveedor(proveedor);
							genericDao.save(ProveedorTerritorial.class, proveedorTerritorial);
						}
					}
				}
				
			}
			if(!Checks.esNulo(dto.getCarteraCodigo())) {
				List<String> codigosCarteras = Arrays.asList(dto.getCarteraCodigo().split(","));
				
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId());
				List<EntidadProveedor> entidadProveedorByProvID = genericDao.getList(EntidadProveedor.class, filtroProveedor);
				
				// Borrar los elementos que no vengan en la lista y existan en la DDBB.
				for(EntidadProveedor e : entidadProveedorByProvID){
					if(!codigosCarteras.contains(e.getCartera().getCodigo())){
						Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.id", e.getCartera().getId());
						EntidadProveedor entidadABorrar = genericDao.get(EntidadProveedor.class, filtroCartera, filtroProveedor);
						if(!Checks.esNulo(entidadABorrar)) {
							genericDao.deleteById(EntidadProveedor.class, entidadABorrar.getId());
						}
					}
				}
				
				// Almacenar los elementos que vengan en la lista y no existan en la DDBB.
				// Dejar los elementos que vangan en la lista y exista en la DDBB.
				for(String codigo : codigosCarteras) {
					DDCartera cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, codigo);
					if(!Checks.esNulo(cartera)) {
						Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.id", cartera.getId());
						List<EntidadProveedor> entidadProveedores = genericDao.getList(EntidadProveedor.class, filtroProveedor, filtroCartera);
						if(Checks.estaVacio(entidadProveedores)) {
							EntidadProveedor entidadProveedor = new EntidadProveedor();
							entidadProveedor.setCartera(cartera);
							entidadProveedor.setProveedor(proveedor);
							Auditoria auditoria = new Auditoria();
							auditoria.setUsuarioCrear("REM");
							auditoria.setFechaCrear(new Date());
							entidadProveedor.setAuditoria(auditoria);
							genericDao.save(EntidadProveedor.class, entidadProveedor);
						}
					}
				}
			}
			if(!Checks.esNulo(dto.getSubcarteraCodigo())) {
				//beanUtilNotNull.copyProperty(proveedor, "subcarteraCodigo", proveedor.get);// TODO: todavia no existe.
			}
			if(!Checks.esNulo(dto.getCustodioCodigo())) {
				beanUtilNotNull.copyProperty(proveedor, "custodio", dto.getCustodioCodigo());
			}
			if(!Checks.esNulo(dto.getTipoActivosCarteraCodigo())) {
				DDTipoActivosCartera tipoActivosCartera = (DDTipoActivosCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoActivosCartera.class, dto.getTipoActivosCarteraCodigo());
				beanUtilNotNull.copyProperty(proveedor, "tipoActivosCartera", tipoActivosCartera);
			}
			if(!Checks.esNulo(dto.getCalificacionCodigo())) {
				DDCalificacionProveedor calificacionProveedor = (DDCalificacionProveedor) utilDiccionarioApi.dameValorDiccionarioByCod(DDCalificacionProveedor.class, dto.getCalificacionCodigo());
				beanUtilNotNull.copyProperty(proveedor, "calificacionProveedor", calificacionProveedor);
			}
			beanUtilNotNull.copyProperty(proveedor, "top", dto.getIncluidoTopCodigo());
			beanUtilNotNull.copyProperty(proveedor, "numCuenta", dto.getNumCuentaIBAN());
			beanUtilNotNull.copyProperty(proveedor, "titularCuenta", dto.getTitularCuenta());
			beanUtilNotNull.copyProperty(proveedor, "retener", dto.getRetencionPagoCodigo());
			beanUtilNotNull.copyProperty(proveedor, "fechaRetencion", dto.getFechaRetencion());
			if(!Checks.esNulo(dto.getMotivoRetencionCodigo())) {
				DDMotivoRetencion motivoRetencion = (DDMotivoRetencion) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRetencion.class, dto.getMotivoRetencionCodigo());
				beanUtilNotNull.copyProperty(proveedor, "motivoRetencion", motivoRetencion);
			}
			if(!Checks.esNulo(dto.getRetencionPagoCodigo()) && dto.getRetencionPagoCodigo().equals("0")) {
				proveedor.setMotivoRetencion(null);
				proveedor.setFechaRetencion(null);
			}
			beanUtilNotNull.copyProperty(proveedor, "fechaProcesoBlanqueo", dto.getFechaProceso());
			if(!Checks.esNulo(dto.getResultadoBlanqueoCodigo())) {
				DDResultadoProcesoBlanqueo resutladoProcesoBlanqueo = (DDResultadoProcesoBlanqueo) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoProcesoBlanqueo.class, dto.getResultadoBlanqueoCodigo());
				beanUtilNotNull.copyProperty(proveedor, "resultadoProcesoBlanqueo", resutladoProcesoBlanqueo);
			}
			beanUtilNotNull.copyProperty(proveedor, "criterioCajaIVA", dto.getCriterioCajaIVA());
			beanUtilNotNull.copyProperty(proveedor, "fechaEjercicioOpcion", dto.getFechaEjercicioOpcion());
			
			// Si viene fecha de baja, asignar el estado de proveedor a 'baja como proveedor'.
			Date fechaEnBlanco = new Date();
			fechaEnBlanco.setTime(0);
			
			if(!Checks.esNulo(dto.getFechaBajaProveedor()) || DDEstadoProveedor.ESTADO_BAJA_PROVEEDOR.equals(dto.getEstadoProveedorCodigo())){
				if(!Checks.esNulo(proveedor.getTipoProveedor()) && DDTipoProveedor.COD_MEDIADOR.equals(proveedor.getTipoProveedor().getCodigo())){
					
					Long activosAsignadosProveedor= proveedoresDao.activosAsignadosProveedorMediador(dto.getId());
					
					if(!Checks.esNulo(activosAsignadosProveedor) && activosAsignadosProveedor > 0){
						throw new JsonViewerException(messageServices.getMessage(BAJA_PROVEEDOR_ACTIVOS_ASIGNADOS));
					}
				
				}
			}
			
			if(!Checks.esNulo(dto.getFechaBajaProveedor()) || DDEstadoProveedor.ESTADO_BAJA_PROVEEDOR.equals(dto.getEstadoProveedorCodigo())){
				if(!Checks.esNulo(proveedor.getTipoProveedor()) && DDTipoProveedor.COD_MANTENIMIENTO_TECNICO.equals(proveedor.getTipoProveedor().getCodigo())){
					BigDecimal activosAsignadosNVendidoNoTraspasado = proveedoresDao.activosAsignadosNoVendidosNoTraspasadoProveedorTecnico(dto.getId());
					if(!Checks.esNulo(activosAsignadosNVendidoNoTraspasado) && !activosAsignadosNVendidoNoTraspasado.equals(new BigDecimal("0"))){
						throw new JsonViewerException(messageServices.getMessage(BAJA_PROVEEDOR_ACTIVOS_ASIGNADOS));
					}
				}
			}
			
			beanUtilNotNull.copyProperty(proveedor, "fechaBaja", dto.getFechaBajaProveedor());
			if(!Checks.esNulo(dto.getFechaBajaProveedor()) && dto.getFechaBajaProveedor().after(fechaEnBlanco)) {
				DDEstadoProveedor estadoProveedor = (DDEstadoProveedor) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoProveedor.class, DDEstadoProveedor.ESTADO_BAJA_PROVEEDOR);
				beanUtilNotNull.copyProperty(proveedor, "estadoProveedor", estadoProveedor);
			}
			// Si viene estado de proveedor como 'baja como proveedor', establecer fecha de baja a hoy.
			if(!Checks.esNulo(dto.getEstadoProveedorCodigo()) && dto.getEstadoProveedorCodigo().equals(DDEstadoProveedor.ESTADO_BAJA_PROVEEDOR)) {
				beanUtilNotNull.copyProperty(proveedor, "fechaBaja", new Date());
			}
			if(!Checks.esNulo(dto.getCodProveedorUvem())) {
				beanUtilNotNull.copyProperty(proveedor, "codProveedorUvem", dto.getCodProveedorUvem());
			}

		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
			return false;
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
			return false;
		}

		proveedoresDao.save(proveedor);

		return true;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoPersonaContacto> getPersonasContactoByProveedor(DtoPersonaContacto dtoPersonaContacto) {
		List<DtoPersonaContacto> dtoList = new ArrayList<DtoPersonaContacto>();
		
		if(!Checks.esNulo(dtoPersonaContacto.getId())) {
			Filter proveedorIDFilter = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", Long.parseLong(dtoPersonaContacto.getId()));
			Page page;
			if(!Checks.esNulo(dtoPersonaContacto.getDelegacion())) {
				// Filtrado por la delegacion seleccionada.
				Filter delegacionIDFilter = genericDao.createFilter(FilterType.EQUALS, "delegacion.id", Long.parseLong(dtoPersonaContacto.getDelegacion()));
				page = genericDao.getPage(ActivoProveedorContacto.class, dtoPersonaContacto, proveedorIDFilter, delegacionIDFilter);
			} else {
				page = genericDao.getPage(ActivoProveedorContacto.class, dtoPersonaContacto, proveedorIDFilter);
			}
			List<ActivoProveedorContacto> personaContacto = (List<ActivoProveedorContacto>) page.getResults();
			
			for(ActivoProveedorContacto persona : personaContacto) {
				DtoPersonaContacto dto = new DtoPersonaContacto();
				try {
					beanUtilNotNull.copyProperty(dto, "id", persona.getId());
					beanUtilNotNull.copyProperty(dto, "personaPrincipal", persona.getPrincipal());
					beanUtilNotNull.copyProperty(dto, "nombre", persona.getNombre());
					beanUtilNotNull.copyProperty(dto, "apellido1", persona.getApellido1());
					beanUtilNotNull.copyProperty(dto, "apellido2", persona.getApellido2());
					if(!Checks.esNulo(persona.getUsuario())) {
						beanUtilNotNull.copyProperty(dto, "codigoUsuario", persona.getUsuario().getUsername());
					}
					if(!Checks.esNulo(persona.getProveedor())){
						beanUtilNotNull.copyProperty(dto, "proveedorID", persona.getProveedor().getId());
						if(!Checks.esNulo(persona.getProveedor().getTipoProveedor())){
							if(!Checks.esNulo(persona.getProveedor().getTipoProveedor().getTipoEntidadProveedor())){
								if(DDEntidadProveedor.TIPO_ENTIDAD_CODIGO.equals(persona.getProveedor().getTipoProveedor().getTipoEntidadProveedor().getCodigo())) {
									if(!Checks.esNulo(persona.getCargoProveedorContacto())) {
										beanUtilNotNull.copyProperty(dto, "cargoCombobox", persona.getCargoProveedorContacto().getCodigo());
									}
									beanUtilNotNull.copyProperty(dto, "nif", persona.getDocIdentificativo());
									beanUtilNotNull.copyProperty(dto, "direccion", persona.getDireccion());
								} else {
									beanUtilNotNull.copyProperty(dto, "cargoTexto", persona.getCargo());
								}
							}
						}
					}
					
					beanUtilNotNull.copyProperty(dto, "telefono", persona.getTelefono1());
					beanUtilNotNull.copyProperty(dto, "email", persona.getEmail());
					if(!Checks.esNulo(persona.getProveedor())) {
						beanUtilNotNull.copyProperty(dto, "fechaAlta", persona.getFechaAlta());
						beanUtilNotNull.copyProperty(dto, "fechaBaja", persona.getFechaBaja());
					}
					beanUtilNotNull.copyProperty(dto, "observaciones", persona.getObservaciones());
					beanUtilNotNull.copyProperty(dto, "totalCount", page.getTotalCount());
				} catch (IllegalAccessException e) {
					logger.error(e.getMessage());
				} catch (InvocationTargetException e) {
					logger.error(e.getMessage());
				}
				
				dtoList.add(dto);
			}
		}

		return dtoList;
	}
	
	@Transactional(readOnly=false)
	@Override
	public boolean createPersonasContacto(DtoPersonaContacto dtoPersonaContacto) throws Exception {
		ActivoProveedorContacto personaContacto = new ActivoProveedorContacto();
		
		try {
			ActivoProveedor proveedor = proveedoresDao.getProveedorById(Long.parseLong(dtoPersonaContacto.getProveedorID()));
			
			if(!Checks.esNulo(proveedor)) {
				beanUtilNotNull.copyProperty(personaContacto, "proveedor", proveedor);
				if(!Checks.esNulo(proveedor.getTipoProveedor())){
					if(!Checks.esNulo(proveedor.getTipoProveedor().getTipoEntidadProveedor())){
						if(DDEntidadProveedor.TIPO_ENTIDAD_CODIGO.equals(proveedor.getTipoProveedor().getTipoEntidadProveedor().getCodigo())) {
							beanUtilNotNull.copyProperty(personaContacto, "direccion", dtoPersonaContacto.getDireccion());
							if(!Checks.esNulo(dtoPersonaContacto.getCargoCombobox())) {
								DDCargoProveedorContacto cargo = (DDCargoProveedorContacto) utilDiccionarioApi.dameValorDiccionarioByCod(DDCargoProveedorContacto.class, dtoPersonaContacto.getCargoCombobox());
								beanUtilNotNull.copyProperty(personaContacto, "cargoProveedorContacto", cargo);
							}
							beanUtilNotNull.copyProperty(personaContacto, "docIdentificativo", dtoPersonaContacto.getNif());
							if(!Checks.esNulo(dtoPersonaContacto.getNif())) {
								// Por defecto al crear el registro, el documento identificativo es de tipo NIF.
								DDTipoDocumento tipoDoc = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, "15");
								beanUtilNotNull.copyProperty(personaContacto, "tipoDocIdentificativo", tipoDoc);
							}
						} else {
							beanUtilNotNull.copyProperty(personaContacto, "cargo", dtoPersonaContacto.getCargoTexto());
						}
					}
				}
			}
			
			if(!Checks.esNulo(dtoPersonaContacto.getCodigoUsuario())) {
				Filter usuFilter = genericDao.createFilter(FilterType.EQUALS, "username", dtoPersonaContacto.getCodigoUsuario());
				Usuario usuario = genericDao.get(Usuario.class, usuFilter);
				if(Checks.esNulo(usuario)){
					throw new Exception(ProveedoresManager.USUARIO_NOT_EXISTS_EXCEPTION_CODE);
				}
				beanUtilNotNull.copyProperty(personaContacto, "usuario", usuario);
			}
			if(!Checks.esNulo(dtoPersonaContacto.getDelegacion())) {
				Filter direccionFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoPersonaContacto.getDelegacion()));
				ActivoProveedorDireccion delegacion = genericDao.get(ActivoProveedorDireccion.class, direccionFilter);
				beanUtilNotNull.copyProperty(personaContacto, "delegacion", delegacion);
			}
			beanUtilNotNull.copyProperty(personaContacto, "nombre", dtoPersonaContacto.getNombre());
			beanUtilNotNull.copyProperty(personaContacto, "apellido1", dtoPersonaContacto.getApellido1());
			beanUtilNotNull.copyProperty(personaContacto, "apellido2", dtoPersonaContacto.getApellido2());
			beanUtilNotNull.copyProperty(personaContacto, "telefono1", dtoPersonaContacto.getTelefono());
			beanUtilNotNull.copyProperty(personaContacto, "email", dtoPersonaContacto.getEmail());
			beanUtilNotNull.copyProperty(personaContacto, "direccion", dtoPersonaContacto.getDireccion());
			beanUtilNotNull.copyProperty(personaContacto, "fechaAlta", dtoPersonaContacto.getFechaAlta());
			beanUtilNotNull.copyProperty(personaContacto, "fechaBaja", dtoPersonaContacto.getFechaBaja());
			beanUtilNotNull.copyProperty(personaContacto, "observaciones", dtoPersonaContacto.getObservaciones());
			
			genericDao.save(ActivoProveedorContacto.class, personaContacto);
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
			return false;
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
			return false;
		}
		
		return true;
	}
	
	@Transactional(readOnly=false)
	@Override
	public boolean updatePersonasContacto(DtoPersonaContacto dtoPersonaContacto) throws Exception {
		Filter personaIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoPersonaContacto.getId()));
		ActivoProveedorContacto personaContacto = genericDao.get(ActivoProveedorContacto.class, personaIDFilter);
		if(Checks.esNulo(personaContacto)) {
			return false;
		}

		try {
			ActivoProveedor proveedor = proveedoresDao.getProveedorById(Long.parseLong(dtoPersonaContacto.getProveedorID()));
			
			if(!Checks.esNulo(proveedor)) {
				beanUtilNotNull.copyProperty(personaContacto, "proveedor", proveedor);
				if(!Checks.esNulo(proveedor.getTipoProveedor())){
					if(!Checks.esNulo(proveedor.getTipoProveedor().getTipoEntidadProveedor())){
						if(DDEntidadProveedor.TIPO_ENTIDAD_CODIGO.equals(proveedor.getTipoProveedor().getTipoEntidadProveedor().getCodigo())) {
							beanUtilNotNull.copyProperty(personaContacto, "direccion", dtoPersonaContacto.getDireccion());
							if(!Checks.esNulo(dtoPersonaContacto.getCargoCombobox())) {
								DDCargoProveedorContacto cargo = (DDCargoProveedorContacto) utilDiccionarioApi.dameValorDiccionarioByCod(DDCargoProveedorContacto.class, dtoPersonaContacto.getCargoCombobox());
								beanUtilNotNull.copyProperty(personaContacto, "cargoProveedorContacto", cargo);
							}
							beanUtilNotNull.copyProperty(personaContacto, "docIdentificativo", dtoPersonaContacto.getNif());
						} else {
							beanUtilNotNull.copyProperty(personaContacto, "cargo", dtoPersonaContacto.getCargoTexto());
						}
					}
				}
			}
			
			if(!Checks.esNulo(dtoPersonaContacto.getCodigoUsuario())) {
				Filter usuFilter = genericDao.createFilter(FilterType.EQUALS, "username", dtoPersonaContacto.getCodigoUsuario());
				Usuario usuario = genericDao.get(Usuario.class, usuFilter);
				if(Checks.esNulo(usuario)){
					throw new Exception(ProveedoresManager.USUARIO_NOT_EXISTS_EXCEPTION_CODE);
				}
				beanUtilNotNull.copyProperty(personaContacto, "usuario", usuario);
			}
			beanUtilNotNull.copyProperty(personaContacto, "nombre", dtoPersonaContacto.getNombre());
			beanUtilNotNull.copyProperty(personaContacto, "apellido1", dtoPersonaContacto.getApellido1());
			beanUtilNotNull.copyProperty(personaContacto, "apellido2", dtoPersonaContacto.getApellido2());
			beanUtilNotNull.copyProperty(personaContacto, "telefono1", dtoPersonaContacto.getTelefono());
			beanUtilNotNull.copyProperty(personaContacto, "email", dtoPersonaContacto.getEmail());
			beanUtilNotNull.copyProperty(personaContacto, "direccion", dtoPersonaContacto.getDireccion());
			beanUtilNotNull.copyProperty(personaContacto, "fechaAlta", dtoPersonaContacto.getFechaAlta());
			beanUtilNotNull.copyProperty(personaContacto, "fechaBaja", dtoPersonaContacto.getFechaBaja());
			beanUtilNotNull.copyProperty(personaContacto, "observaciones", dtoPersonaContacto.getObservaciones());
			
			genericDao.save(ActivoProveedorContacto.class, personaContacto);
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
			return false;
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
			return false;
		}
		
		return true;
	}

	@Transactional(readOnly=false)
	@Override
	public boolean deletePersonasContacto(DtoPersonaContacto dtoPersonaContacto) {
		Filter personaID = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoPersonaContacto.getId()));
		ActivoProveedorContacto personaContacto = genericDao.get(ActivoProveedorContacto.class, personaID);

		if(!Checks.esNulo(personaContacto)) {
			personaContacto.getAuditoria().setBorrado(true);
			genericDao.save(ActivoProveedorContacto.class, personaContacto);
			return true;
		} else {
			return false;
		}
	}

	@Transactional(readOnly=false)
	@Override
	public boolean setPersonaContactoPrincipal(DtoPersonaContacto dtoPersonaContacto) {
		// Eliminar de principal cualquier persona que sea principal para el proveedor dado.
		Filter proveedorID = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", Long.parseLong(dtoPersonaContacto.getProveedorID()));
		Filter principal = genericDao.createFilter(FilterType.EQUALS, "principal", 1);
		List<ActivoProveedorContacto> personasContactos = genericDao.getList(ActivoProveedorContacto.class, proveedorID, principal);
		boolean algunaPersonaPrincipal = false;
		ActivoProveedorContacto personaPrincipal = null;
		
		if(!Checks.estaVacio(personasContactos)) {
			for(ActivoProveedorContacto persona : personasContactos){
				if(persona.getPrincipal()!=0){
					algunaPersonaPrincipal=true;
					personaPrincipal = persona;
				}
				persona.setPrincipal(0);
				genericDao.save(ActivoProveedorContacto.class, persona);
			}
		}
		
		// Establecer la persona actual como principal.
		Filter personaID = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoPersonaContacto.getId()));
		ActivoProveedorContacto personaContacto = genericDao.get(ActivoProveedorContacto.class, personaID);
		if(!algunaPersonaPrincipal || !personaPrincipal.equals(personaContacto)){
			if(!Checks.esNulo(personaContacto)) {
				personaContacto.setPrincipal(1);
				genericDao.save(ActivoProveedorContacto.class, personaContacto);
				return true;
			} else {
				return false;
			}
		}
		return true;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoDireccionDelegacion> getDireccionesDelegacionesByProveedor(DtoDireccionDelegacion dtoDireccionDelegacion) {
		List<DtoDireccionDelegacion> dtoList = new ArrayList<DtoDireccionDelegacion>();
		
		if(!Checks.esNulo(dtoDireccionDelegacion.getId())) {
			Filter proveedorIDFilter = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", Long.parseLong(dtoDireccionDelegacion.getId()));
			Page page = genericDao.getPage(ActivoProveedorDireccion.class, dtoDireccionDelegacion, proveedorIDFilter);
			List<ActivoProveedorDireccion> delegaciones = (List<ActivoProveedorDireccion>) page.getResults();
			
			for(ActivoProveedorDireccion delegacion : delegaciones) {
				DtoDireccionDelegacion dto = new DtoDireccionDelegacion();
				try {
					beanUtilNotNull.copyProperty(dto, "id", delegacion.getId());
					if(!Checks.esNulo(delegacion.getProveedor())) {
						beanUtilNotNull.copyProperty(dto, "proveedorID", delegacion.getProveedor().getId());
					}
					if(!Checks.esNulo(delegacion.getTipoDireccion())) {
						beanUtilNotNull.copyProperty(dto, "tipoDireccion", delegacion.getTipoDireccion().getCodigo());
					}
					beanUtilNotNull.copyProperty(dto, "localAbiertoPublicoCodigo", delegacion.getLocalAbiertoPublico());
					beanUtilNotNull.copyProperty(dto, "referencia", delegacion.getReferencia());
					if(!Checks.esNulo(delegacion.getTipoVia())) {
						beanUtilNotNull.copyProperty(dto, "tipoViaCodigo", delegacion.getTipoVia().getCodigo());
					}
					beanUtilNotNull.copyProperty(dto, "nombreVia", delegacion.getNombreVia());
					beanUtilNotNull.copyProperty(dto, "numeroVia", delegacion.getNumeroVia());
					beanUtilNotNull.copyProperty(dto, "puerta", delegacion.getPuerta());
					if(!Checks.esNulo(delegacion.getLocalidad())) {
						beanUtilNotNull.copyProperty(dto, "localidadCodigo", delegacion.getLocalidad().getCodigo());
					}
					if(!Checks.esNulo(delegacion.getProvincia())) {
					beanUtilNotNull.copyProperty(dto, "provincia", delegacion.getProvincia().getCodigo());
					}
					beanUtilNotNull.copyProperty(dto, "codigoPostal", delegacion.getCodigoPostal());
					beanUtilNotNull.copyProperty(dto, "telefono", delegacion.getTelefono());
					beanUtilNotNull.copyProperty(dto, "email", delegacion.getEmail());
					beanUtilNotNull.copyProperty(dto, "totalCount", page.getTotalCount());
				} catch (IllegalAccessException e) {
					logger.error(e.getMessage());
				} catch (InvocationTargetException e) {
					logger.error(e.getMessage());
				}
				
				dtoList.add(dto);
			}
		}

		return dtoList;
	}
	
	@Transactional(readOnly=false)
	@Override
	public boolean createDireccionDelegacion(DtoDireccionDelegacion dtoDireccionDelegacion) {
		ActivoProveedorDireccion direccionDelegacion = new ActivoProveedorDireccion();
		
		try {
			if(!Checks.esNulo(dtoDireccionDelegacion.getProveedorID())) {
				ActivoProveedor proveedor = proveedoresDao.getProveedorById(Long.parseLong(dtoDireccionDelegacion.getProveedorID()));
				beanUtilNotNull.copyProperty(direccionDelegacion, "proveedor", proveedor);
			}
			if(!Checks.esNulo(dtoDireccionDelegacion.getTipoDireccion())) {
				DDTipoDireccionProveedor direccionProveedor = (DDTipoDireccionProveedor) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDireccionProveedor.class, dtoDireccionDelegacion.getTipoDireccion());
				beanUtilNotNull.copyProperty(direccionDelegacion, "tipoDireccion", direccionProveedor);
			}
			beanUtilNotNull.copyProperty(direccionDelegacion, "localAbiertoPublico", dtoDireccionDelegacion.getLocalAbiertoPublicoCodigo());
			beanUtilNotNull.copyProperty(direccionDelegacion, "referencia", dtoDireccionDelegacion.getReferencia());
			if(!Checks.esNulo(dtoDireccionDelegacion.getTipoViaCodigo())) {
				DDTipoVia tipoVia = (DDTipoVia) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoVia.class, dtoDireccionDelegacion.getTipoViaCodigo());
				beanUtilNotNull.copyProperty(direccionDelegacion, "tipoVia", tipoVia);
			}
			beanUtilNotNull.copyProperty(direccionDelegacion, "nombreVia", dtoDireccionDelegacion.getNombreVia());
			beanUtilNotNull.copyProperty(direccionDelegacion, "numeroVia", dtoDireccionDelegacion.getNumeroVia());
			beanUtilNotNull.copyProperty(direccionDelegacion, "puerta", dtoDireccionDelegacion.getPuerta());
			if(!Checks.esNulo(dtoDireccionDelegacion.getProvincia())) {
				DDProvincia provincia = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dtoDireccionDelegacion.getProvincia());
				beanUtilNotNull.copyProperty(direccionDelegacion, "provincia", provincia);
			}
			if(!Checks.esNulo(dtoDireccionDelegacion.getLocalidadCodigo())) {
				Filter filterLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoDireccionDelegacion.getLocalidadCodigo());
				Localidad localidad = genericDao.get(Localidad.class, filterLocalidad);
				beanUtilNotNull.copyProperty(direccionDelegacion, "localidad", localidad);
			}
			beanUtilNotNull.copyProperty(direccionDelegacion, "codigoPostal", dtoDireccionDelegacion.getCodigoPostal());
			beanUtilNotNull.copyProperty(direccionDelegacion, "telefono", dtoDireccionDelegacion.getTelefono());
			beanUtilNotNull.copyProperty(direccionDelegacion, "email", dtoDireccionDelegacion.getEmail());
			
			genericDao.save(ActivoProveedorDireccion.class, direccionDelegacion);
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
			return false;
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
			return false;
		}
		
		return true;
	}
	
	@Transactional(readOnly=false)
	@Override
	public boolean updateDireccionDelegacion(DtoDireccionDelegacion dtoDireccionDelegacion) {
		Filter direccionIDFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoDireccionDelegacion.getId()));
		ActivoProveedorDireccion direccionDelegacion = genericDao.get(ActivoProveedorDireccion.class, direccionIDFilter);
		
		try {
			if(!Checks.esNulo(dtoDireccionDelegacion.getProveedorID())) {
				ActivoProveedor proveedor = proveedoresDao.getProveedorById(Long.parseLong(dtoDireccionDelegacion.getProveedorID()));
				beanUtilNotNull.copyProperty(direccionDelegacion, "proveedor", proveedor);
			}
			if(!Checks.esNulo(dtoDireccionDelegacion.getTipoDireccion())) {
				DDTipoDireccionProveedor direccionProveedor = (DDTipoDireccionProveedor) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDireccionProveedor.class, dtoDireccionDelegacion.getTipoDireccion());
				beanUtilNotNull.copyProperty(direccionDelegacion, "tipoDireccion", direccionProveedor);
			}
			beanUtilNotNull.copyProperty(direccionDelegacion, "localAbiertoPublico", dtoDireccionDelegacion.getLocalAbiertoPublicoCodigo());
			beanUtilNotNull.copyProperty(direccionDelegacion, "referencia", dtoDireccionDelegacion.getReferencia());
			if(!Checks.esNulo(dtoDireccionDelegacion.getTipoViaCodigo())) {
				DDTipoVia tipoVia = (DDTipoVia) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoVia.class, dtoDireccionDelegacion.getTipoViaCodigo());
				beanUtilNotNull.copyProperty(direccionDelegacion, "tipoVia", tipoVia);
			}
			beanUtilNotNull.copyProperty(direccionDelegacion, "nombreVia", dtoDireccionDelegacion.getNombreVia());
			beanUtilNotNull.copyProperty(direccionDelegacion, "numeroVia", dtoDireccionDelegacion.getNumeroVia());
			beanUtilNotNull.copyProperty(direccionDelegacion, "puerta", dtoDireccionDelegacion.getPuerta());
			if(!Checks.esNulo(dtoDireccionDelegacion.getProvincia())) {
				DDProvincia provincia = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, dtoDireccionDelegacion.getProvincia());
				beanUtilNotNull.copyProperty(direccionDelegacion, "provincia", provincia);
			}
			if(!Checks.esNulo(dtoDireccionDelegacion.getLocalidadCodigo())) {
				Filter filterLocalidad = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoDireccionDelegacion.getLocalidadCodigo());
				Localidad localidad = genericDao.get(Localidad.class, filterLocalidad);
				beanUtilNotNull.copyProperty(direccionDelegacion, "localidad", localidad);
			}
			beanUtilNotNull.copyProperty(direccionDelegacion, "codigoPostal", dtoDireccionDelegacion.getCodigoPostal());
			beanUtilNotNull.copyProperty(direccionDelegacion, "telefono", dtoDireccionDelegacion.getTelefono());
			beanUtilNotNull.copyProperty(direccionDelegacion, "email", dtoDireccionDelegacion.getEmail());
			
			genericDao.save(ActivoProveedorDireccion.class, direccionDelegacion);
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
			return false;
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
			return false;
		}
		
		return true;
	}
	
	@Transactional(readOnly=false)
	@Override
	public boolean deleteDireccionDelegacion(DtoDireccionDelegacion dtoDireccionDelegacion) {
		Filter delegacionID = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoDireccionDelegacion.getId()));
		ActivoProveedorDireccion direccionDelegacion = genericDao.get(ActivoProveedorDireccion.class, delegacionID);

		if(!Checks.esNulo(direccionDelegacion)) {
			direccionDelegacion.getAuditoria().setBorrado(true);
			genericDao.save(ActivoProveedorDireccion.class, direccionDelegacion);
			return true;
		} else {
			return false;
		}
	}
		

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoActivoIntegrado> getActivoIntegradoByProveedor(DtoActivoIntegrado dtoActivoIntegrado) {
		Filter proveedorIDFilter = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", Long.parseLong(dtoActivoIntegrado.getId()));
		Page page = genericDao.getPage(ActivoIntegrado.class, dtoActivoIntegrado, proveedorIDFilter);
		List<ActivoIntegrado> activosIntegrados = (List<ActivoIntegrado>) page.getResults();
		List<DtoActivoIntegrado> dtoList = new ArrayList<DtoActivoIntegrado>();
		for(ActivoIntegrado activoIntegrado : activosIntegrados) {
			DtoActivoIntegrado dto = new DtoActivoIntegrado();
			try {
				beanUtilNotNull.copyProperty(dto, "id", activoIntegrado.getId());
				if(!Checks.esNulo(activoIntegrado.getActivo())) {
					beanUtilNotNull.copyProperty(dto, "idActivo", activoIntegrado.getActivo().getId());
					beanUtilNotNull.copyProperty(dto, "numActivo", activoIntegrado.getActivo().getNumActivo());
					beanUtilNotNull.copyProperty(dto, "direccion", activoIntegrado.getActivo().getDireccion());
					if(!Checks.esNulo(activoIntegrado.getActivo().getTipoActivo())) {
						beanUtilNotNull.copyProperty(dto, "tipoCodigo", activoIntegrado.getActivo().getTipoActivo().getCodigo());
					}
					if(!Checks.esNulo(activoIntegrado.getActivo().getSubtipoActivo())) {
						beanUtilNotNull.copyProperty(dto, "subtipoCodigo", activoIntegrado.getActivo().getSubtipoActivo().getCodigo());
					}
					if(!Checks.esNulo(activoIntegrado.getActivo().getCartera())) {
						beanUtilNotNull.copyProperty(dto, "carteraCodigo", activoIntegrado.getActivo().getCartera().getCodigo());
					}
				}
				beanUtilNotNull.copyProperty(dto, "participacion", activoIntegrado.getParticipacion());
				beanUtilNotNull.copyProperty(dto, "fechaInclusion", activoIntegrado.getFechaInclusion());
				beanUtilNotNull.copyProperty(dto, "fechaExclusion", activoIntegrado.getFechaExclusion());
				beanUtilNotNull.copyProperty(dto, "motivoExclusion", activoIntegrado.getMotivoExclusion());
				beanUtilNotNull.copyProperty(dto, "totalCount", page.getTotalCount());
			} catch (IllegalAccessException e) {
				logger.error(e.getMessage());
			} catch (InvocationTargetException e) {
				logger.error(e.getMessage());
			}
			
			dtoList.add(dto);
		}
		
		return dtoList;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = true;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		ActivoProveedor proveedor = proveedoresDao.get(dtoAdjunto.getIdEntidad());
		ActivoAdjuntoProveedor adjunto = null;
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {	
			try {
				adjunto = genericDao.get(ActivoAdjuntoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", dtoAdjunto.getId()));
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(adjunto.getIdDocRestClient(), usuarioLogado.getUsername());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			adjunto = genericDao.get(ActivoAdjuntoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoAdjunto.getId()));
		}
		
		if (borrado) {
			if (adjunto == null) { borrado = false; }
		    proveedor.getAdjuntos().remove(adjunto);
		    proveedoresDao.save(proveedor);
		}

	    return borrado;
	}

	@Override
	public List<DtoAdjunto> getAdjuntos(Long id, ActivoProveedorCartera actProvCar, String username) throws GestorDocumentalException {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		ActivoProveedor proveedor = proveedoresDao.getProveedorById(id);
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosProveedor(proveedor);
			} catch (GestorDocumentalException gex) {
				throw gex;
			}
		} else {
			try {
				Filter adjuntoFilter = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId());
				Filter adjuntoBorradoFilter = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				Filter adjuntoLocalFilter = genericDao.createFilter(FilterType.NOTNULL, "adjunto");
				List<ActivoAdjuntoProveedor> adjuntos = genericDao.getList(ActivoAdjuntoProveedor.class, adjuntoFilter, adjuntoBorradoFilter, adjuntoLocalFilter);

				if(!Checks.estaVacio(adjuntos)){
					for (ActivoAdjuntoProveedor adjunto : adjuntos) {
						DtoAdjunto dto = new DtoAdjunto();
						
						BeanUtils.copyProperties(dto, adjunto);
						beanUtilNotNull.copyProperty(dto, "idEntidad", adjunto.getProveedor().getId());
						beanUtilNotNull.copyProperty(dto, "descripcionTipo", adjunto.getTipoDocumentoProveedor().getDescripcion());
						beanUtilNotNull.copyProperty(dto, "gestor", adjunto.getAuditoria().getUsuarioCrear());				
						
						listaAdjuntos.add(dto);
					}
				}
			} catch(Exception ex){
				logger.error(ex.getMessage());
			}
		}
		
		return listaAdjuntos;
	}
	
	@Override
	public Boolean comprobarExisteAdjuntoProveedores(Long idActivo, String codigoDocumento){

		Boolean documentoEncontrado = false;
		// Recorre todos los proveedores de un activo para comprobar si existe el documento a comprobar
		for(ActivoProveedor proveedor : this.getProveedoresByActivoId(idActivo)){
			Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId());
			Filter filtroAdjuntoCodigo = genericDao.createFilter(FilterType.EQUALS, "tipoDocumentoProveedor.codigo", codigoDocumento);
			List<ActivoAdjuntoProveedor> adjuntos = genericDao.getList(ActivoAdjuntoProveedor.class, filtroProveedor, filtroAdjuntoCodigo);			
		
			if(!Checks.estaVacio(adjuntos))
				documentoEncontrado =  true;
		}
		
		return documentoEncontrado;		
	}
	
	@Override
	@Transactional(readOnly = false)
	public String upload(WebFileItem fileItem) throws Exception {
				
		DDCartera cartera = null;
		DDSubcartera subcartera = null;
		ActivoAdjuntoProveedor adjuntoProveedor = null;
		Adjunto adj = null;
		List<MapeoGestorDocumental> listaMapeoGD = new ArrayList<MapeoGestorDocumental>();
		Boolean todasCarteras = false;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		//Subida de adjunto al Proveedor.
		ActivoProveedor proveedor = proveedoresDao.get(Long.parseLong(fileItem.getParameter("idEntidad")));
		
		if ("on".equalsIgnoreCase(fileItem.getParameter("checkboxTodasCarteras"))) {
			List<DDSubcartera> listaSubcarterasProveedor = proveedoresDao.getSubcarteraPorProveedor(proveedor.getId(), null);
			for(DDSubcartera ddSubcartera : listaSubcarterasProveedor) {
				listaMapeoGD.addAll(proveedoresDao.getCarteraClientesProveedoresByCarteraYSubcartera(ddSubcartera.getCartera(), ddSubcartera));
			}
			todasCarteras = true;
		} else if (!Checks.esNulo(fileItem.getParameter("cartera")) && !Checks.esNulo(fileItem.getParameter("subcartera"))) {
			Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("cartera"));
			cartera = genericDao.get(DDCartera.class, filtroCartera);
			
			Filter filtroSubcartera = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("subcartera"));
			subcartera = genericDao.get(DDSubcartera.class, filtroSubcartera); 
		}
		
		Thread maestroPersona = new Thread( new MaestroDePersonas(proveedor, usuarioLogado.getUsername(), cartera, subcartera, listaMapeoGD));
	   	maestroPersona.start();
	   	maestroPersona.join();
	   	
	   	Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
	   	DDTipoContenedorProveedor tipoContenedor = genericDao.get(DDTipoContenedorProveedor.class, filtro);
		
	   	Filter filtroTipoDoc = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("subtipo"));
	   	DDTipoDocumentoProveedor tipoDocumentoProveedor = genericDao.get(DDTipoDocumentoProveedor.class, filtroTipoDoc);
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Long idDocRestClient = null;
			
			if(todasCarteras) {	
				List<ActivoProveedorCartera> listActProvCar = proveedoresDao.getProveedoresCarteraById(proveedor.getId());
				
				for(ActivoProveedorCartera actProvCar : listActProvCar) {
					/*
					 * Parte comentada: Creacion de contenedores para subir los documentos.
					 * Los contenedores esta vez no los creamos nosotros, por lo tanto se deja comentada porque
					 *  es necesario para realziar pruebas en local.
					 * 
					 * try {
						Integer idProveedor = gestorDocumentalAdapterApi.crearProveedor(actProvCar, usuarioLogado.getUsername());
						logger.error("GESTOR DOCUMENTAL [ crearProveedor para " + proveedor.getCodigoProveedorRem() + "]: ID PROVEEDOR RECIBIDO " + idProveedor);
					} catch (Exception e) {
						logger.error(e.getMessage());
					}*/
					
					if(!Checks.esNulo(actProvCar) && !Checks.esNulo(actProvCar.getClienteGestorDocumental())) {
						idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoProveedor(actProvCar, fileItem, usuarioLogado.getUsername(), tipoContenedor, tipoDocumentoProveedor.getMatricula());
						if(!Checks.esNulo(idDocRestClient)) {
							adjuntoProveedor = new ActivoAdjuntoProveedor();
							adjuntoProveedor.setProveedor(proveedor);
							
							if(!Checks.esNulo(tipoContenedor)) {
								adjuntoProveedor.setTipoContenedorProveedor(tipoContenedor);
							
								if(!Checks.esNulo(tipoDocumentoProveedor)) {
									adjuntoProveedor.setTipoDocumentoProveedor(tipoDocumentoProveedor);
					
									adjuntoProveedor.setContentType(fileItem.getFileItem().getContentType());
									adjuntoProveedor.setTamanyo(fileItem.getFileItem().getLength());
									adjuntoProveedor.setNombre(fileItem.getFileItem().getFileName());
									adjuntoProveedor.setDescripcion(fileItem.getParameter("descripcion"));			
									adjuntoProveedor.setFechaDocumento(new Date());
									adjuntoProveedor.setIdDocRestClient(idDocRestClient);
									Auditoria.save(adjuntoProveedor);
									genericDao.save(ActivoAdjuntoProveedor.class, adjuntoProveedor);
								} else {
									throw new Exception(ProveedoresManager.ERROR_SUBTIPO_DOCUMENTO_PROVEEDOR);
								}
							} else {
								throw new Exception(ProveedoresManager.ERROR_TIPO_DOCUMENTO_PROVEEDOR);
							}
						}
					}
					
				}
			} else {
				ActivoProveedorCartera activoProveedorCartera = null;
				if (!Checks.esNulo(cartera) || !Checks.esNulo(subcartera)) {
					activoProveedorCartera = genericDao.get(ActivoProveedorCartera.class, 
							genericDao.createFilter(FilterType.EQUALS, "proveedor", proveedor),
							genericDao.createFilter(FilterType.EQUALS, "cartera", cartera),
							genericDao.createFilter(FilterType.EQUALS, "subcartera", subcartera));
				} else {
					activoProveedorCartera = genericDao.get(ActivoProveedorCartera.class, 
							genericDao.createFilter(FilterType.EQUALS, "proveedor", proveedor),
							genericDao.createFilter(FilterType.EQUALS, "clienteGestorDocumental", ID_HAYA));
				}
				
				if (!Checks.esNulo(activoProveedorCartera)) {
					/*
					 * Parte comentada: Creacion de contenedores para subir los documentos.
					 * Los contenedores esta vez no los creamos nosotros, por lo tanto se deja comentada porque
					 *  es necesario para realziar pruebas en local.
					 * 
					 * try {
						Integer idProveedor = gestorDocumentalAdapterApi.crearProveedor(activoProveedorCartera, usuarioLogado.getUsername());
						logger.error("GESTOR DOCUMENTAL [ crearProveedor para " + proveedor.getCodigoProveedorRem() + "]: ID PROVEEDOR RECIBIDO " + idProveedor);
					} catch (Exception e) {
						logger.error(e.getMessage());
					}*/
					
					idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoProveedor(activoProveedorCartera, fileItem, 
							usuarioLogado.getUsername(), tipoContenedor, tipoDocumentoProveedor.getMatricula());
				}				
				
				if(!Checks.esNulo(idDocRestClient)) {
					adjuntoProveedor = new ActivoAdjuntoProveedor();
					adjuntoProveedor.setIdDocRestClient(idDocRestClient);
				}
			}

		} else {
			if(todasCarteras) {
				
				List<ActivoProveedorCartera> listActProvCar = proveedoresDao.getProveedoresCarteraById(proveedor.getId());
				
				for(ActivoProveedorCartera actProvCar : listActProvCar) {
					if(!Checks.esNulo(actProvCar) && !Checks.esNulo(actProvCar.getClienteGestorDocumental())) {
						adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
						if(!Checks.esNulo(adj)) {
							adjuntoProveedor = new ActivoAdjuntoProveedor();
							adjuntoProveedor.setProveedor(proveedor);
							
							if(!Checks.esNulo(tipoContenedor)) {
								adjuntoProveedor.setTipoContenedorProveedor(tipoContenedor);
							
								if(!Checks.esNulo(tipoDocumentoProveedor)) {
									adjuntoProveedor.setTipoDocumentoProveedor(tipoDocumentoProveedor);
					
									adjuntoProveedor.setContentType(fileItem.getFileItem().getContentType());
									adjuntoProveedor.setTamanyo(fileItem.getFileItem().getLength());
									adjuntoProveedor.setNombre(fileItem.getFileItem().getFileName());
									adjuntoProveedor.setDescripcion(fileItem.getParameter("descripcion"));			
									adjuntoProveedor.setFechaDocumento(new Date());
									adjuntoProveedor.setAdjunto(adj);
									Auditoria.save(adjuntoProveedor);
									genericDao.save(ActivoAdjuntoProveedor.class, adjuntoProveedor);
								} else {
									throw new Exception(ProveedoresManager.ERROR_SUBTIPO_DOCUMENTO_PROVEEDOR);
								}
							} else {
								throw new Exception(ProveedoresManager.ERROR_TIPO_DOCUMENTO_PROVEEDOR);
							}
						}
					}
				}
			} else {
				adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
				
				if(!Checks.esNulo(adj)) {
					adjuntoProveedor = new ActivoAdjuntoProveedor();
					adjuntoProveedor.setAdjunto(adj);
				}
			}
		}
		
		if(!todasCarteras) {
			adjuntoProveedor.setProveedor(proveedor);
			
			if(!Checks.esNulo(tipoContenedor)) {
				adjuntoProveedor.setTipoContenedorProveedor(tipoContenedor);
			
				if(!Checks.esNulo(tipoDocumentoProveedor)) {
					adjuntoProveedor.setTipoDocumentoProveedor(tipoDocumentoProveedor);
	
					adjuntoProveedor.setContentType(fileItem.getFileItem().getContentType());
					adjuntoProveedor.setTamanyo(fileItem.getFileItem().getLength());
					adjuntoProveedor.setNombre(fileItem.getFileItem().getFileName());
					adjuntoProveedor.setDescripcion(fileItem.getParameter("descripcion"));			
					adjuntoProveedor.setFechaDocumento(new Date());
					Auditoria.save(adjuntoProveedor);
					genericDao.save(ActivoAdjuntoProveedor.class, adjuntoProveedor);
				} else {
					throw new Exception(ProveedoresManager.ERROR_SUBTIPO_DOCUMENTO_PROVEEDOR);
				}
			} else {
				throw new Exception(ProveedoresManager.ERROR_TIPO_DOCUMENTO_PROVEEDOR);
			}
		}

		return null;
	}

	@Override
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto) {
		
		FileItem fileItem = null;
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Filter adjuntoFilter = genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", dtoAdjunto.getId());
			ActivoAdjuntoProveedor adjuntoProveedor = genericDao.get(ActivoAdjuntoProveedor.class, adjuntoFilter);
			if(!Checks.esNulo(adjuntoProveedor)) {
				try {
					fileItem = gestorDocumentalAdapterApi.getFileItem(adjuntoProveedor.getIdDocRestClient(), adjuntoProveedor.getNombre());
				} catch (Exception e) {
					logger.error(e.getMessage());
				}
			}
		} else {
			Filter adjuntoFilter = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdjunto.getId());
			ActivoAdjuntoProveedor adjuntoProveedor = genericDao.get(ActivoAdjuntoProveedor.class, adjuntoFilter);
			if(!Checks.esNulo(adjuntoProveedor)) {
				fileItem = adjuntoProveedor.getAdjunto().getFileItem();
				fileItem.setContentType(adjuntoProveedor.getContentType());
				fileItem.setFileName(adjuntoProveedor.getNombre());
			}
		}
		
		return fileItem;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createProveedor(DtoProveedorFilter dtoProveedorFilter) throws Exception {
		ActivoProveedor proveedor = null;
		
		if(!Checks.esNulo(dtoProveedorFilter.getNifProveedor())) { // Si se ha definido NIF.
			proveedor = proveedoresDao.getProveedorByNIFTipoSubtipo(dtoProveedorFilter);
			if (Checks.esNulo(proveedor)){ // Si no se ha encontrado proveedor por el NIF definido.
				proveedor = new ActivoProveedor();
			} else { // Si existe un proveedor con el NIF, tipo y subtipo definidos.
				throw new Exception(ProveedoresManager.PROVEEDOR_EXISTS_EXCEPTION_CODE);
			}
		} else { // Si no se ha definido NIF.
			proveedor = new ActivoProveedor();
		}
		
		try {
			beanUtilNotNull.copyProperty(proveedor, "docIdentificativo", dtoProveedorFilter.getNifProveedor());

			if(!Checks.esNulo(dtoProveedorFilter.getSubtipoProveedorDescripcion())) {
				// El Subtipo de proveedor (FASE 2) es el tipo de proveedor (FASE 1).
				DDTipoProveedor tipoProveedor = (DDTipoProveedor) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoProveedor.class, dtoProveedorFilter.getSubtipoProveedorDescripcion());
				beanUtilNotNull.copyProperty(proveedor, "tipoProveedor", tipoProveedor);
			}
			
			// Obtener un nuevo codigo REM para proveedor al generar un nuevo proveedor.
			beanUtilNotNull.copyProperty(proveedor, "codigoProveedorRem", proveedoresDao.getNextNumCodigoProveedor());
			
			// Se rellenan los campos de modificación para mostrar la fecha de actualización.
			Auditoria auditoria = new Auditoria();
			auditoria.setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
			auditoria.setFechaModificar(new Date());
			auditoria.setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
			auditoria.setFechaCrear(new Date());
			proveedor.setAuditoria(auditoria);
			
			proveedoresDao.save(proveedor);
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
			return false;
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
			return false;
		}
		
		return true;
	}
	
	@Override
	public List<DtoMediador> getMediadorListFiltered(DtoMediador dto){
		Filter actidoID = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdActivo());
		Activo activo = genericDao.get(Activo.class, actidoID);
		
		List<ActivoProveedor> listaProveedores = proveedoresDao.getMediadorListFiltered(activo, dto);
		
		List<DtoMediador> listaMapeada = new ArrayList<DtoMediador>();
		
		if(!Checks.esNulo(listaProveedores)) {
			for(ActivoProveedor proveedor : listaProveedores) {
				DtoMediador nuevoDto = new DtoMediador();
				try {
					beanUtilNotNull.copyProperty(nuevoDto, "idProveedor", proveedor.getId());
					beanUtilNotNull.copyProperty(nuevoDto, "nombreProveedor", proveedor.getNombre());
					beanUtilNotNull.copyProperty(nuevoDto, "codigoProveedor", proveedor.getCodProveedorUvem());
					
					listaMapeada.add(nuevoDto);
				} catch (IllegalAccessException e) {
					logger.error(e.getMessage());
				} catch (InvocationTargetException e) {
					logger.error(e.getMessage());
				}
			}
		}
		
		return listaMapeada;
	}

	@Override
	public String getNifProveedorByUsuarioLogado() {
		
		Usuario usuario = genericAdapter.getUsuarioLogado();
		String nifProveedor= null;
		
		Filter idUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId());
		List<ActivoProveedorContacto> listaPersonasContacto = genericDao.getList(ActivoProveedorContacto.class, idUsuario);
		
		if(!Checks.estaVacio(listaPersonasContacto) && !Checks.esNulo(listaPersonasContacto.get(0).getProveedor())) {			
			nifProveedor = listaPersonasContacto.get(0).getProveedor().getDocIdentificativo();
		}

		return nifProveedor;
	}
	
	@Override
	public Long getIdProveedorByNif(String nif) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", nif);
		Order orden = new Order(OrderType.DESC,"auditoria.fechaCrear");
		ActivoProveedor proveedor = genericDao.getListOrdered(ActivoProveedor.class, orden, filtro).get(0);
		
		return proveedor.getId();
	}

	@Override
	public Long getCodigoProveedorByNif(String nif) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", nif);
		Order orden = new Order(OrderType.DESC,"auditoria.fechaCrear");
		ActivoProveedor proveedor = genericDao.getListOrdered(ActivoProveedor.class, orden, filtro).get(0);
		
		return proveedor.getCodigoProveedorRem();
	}

	@Override
	public Page getMediadoresEvaluar(DtoMediadorEvaluaFilter dtoMediadorEvaluaFilter) {
		
		return  mediadoresEvaluarDao.getListMediadoresEvaluar(dtoMediadorEvaluaFilter);
		
	}
	
	@Override
	public Page getStatsCarteraMediadores(DtoMediadorStats dtoMediadorStats) {
		
		return mediadoresCarteraDao.getStatsCarteraMediador(dtoMediadorStats);
		
	}
	
	@Override
	public Page getOfertasCarteraMediadores(DtoMediadorOferta dtoMediadorOferta) {
		
		return mediadoresOfertasDao.getListMediadorOfertas(dtoMediadorOferta);
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean updateMediadoresEvaluar(DtoMediadorEvalua dtoMediadorEvalua){
		
		ActivoProveedor proveedor = proveedoresDao.getProveedorById(dtoMediadorEvalua.getId());
		
		if(!Checks.esNulo(dtoMediadorEvalua.getId())){
			
			//Actualiza la calificacion propuesta
			if(!Checks.esNulo(dtoMediadorEvalua.getDesCalificacionPropuesta())){
				DDCalificacionProveedorRetirar calificacionPropuesta = 
						(DDCalificacionProveedorRetirar) utilDiccionarioApi.dameValorDiccionarioByCod(DDCalificacionProveedorRetirar.class, dtoMediadorEvalua.getDesCalificacionPropuesta());
				proveedor.setCalificacionProveedorPropuesta(calificacionPropuesta);
			} else
				proveedor.setCalificacionProveedorPropuesta(null);

			//Actualiza el Top150 propuesto
			if(!Checks.esNulo(dtoMediadorEvalua.getEsTopPropuesto()))
				if(comboOK.equals(dtoMediadorEvalua.getEsTopPropuesto()) )
					proveedor.setTopPropuesto(dtoMediadorEvalua.getEsTopPropuesto());
				else
					proveedor.setTopPropuesto(comboKO);
						
		}
		
		proveedoresDao.saveOrUpdate(proveedor);
		
		return true;		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean setVigentesConPropuestas(){

		mediadoresEvaluarDao.evaluarMediadoresConPropuestas();
		
		return true;
		
	}
	
	private DtoActivoProveedor proveedorToDto (ActivoProveedor proveedor) {
		
		DtoActivoProveedor dtoProveedor = new DtoActivoProveedor();
		
		try {
			
			beanUtilNotNull.copyProperty(dtoProveedor, "id", proveedor.getId());
			beanUtilNotNull.copyProperty(dtoProveedor, "codigo", proveedor.getCodigoProveedorRem());
			beanUtilNotNull.copyProperty(dtoProveedor, "nombreProveedor", proveedor.getNombre());
			if(!Checks.esNulo(proveedor.getTipoProveedor())) {
				beanUtilNotNull.copyProperty(dtoProveedor, "subtipoProveedorDescripcion", proveedor.getTipoProveedor().getDescripcion());
			}
			if(!Checks.esNulo(proveedor.getEstadoProveedor())){
				beanUtilNotNull.copyProperty(dtoProveedor, "estadoProveedorDescripcion", proveedor.getEstadoProveedor().getDescripcion());
			}
			beanUtilNotNull.copyProperty(dtoProveedor, "fechaBaja", proveedor.getFechaBaja());
			
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}
		
		return dtoProveedor;
		
	}

	@Override
	public ActivoProveedor searchProveedorCodigo(String codigoUnicoProveedor) {
		
		long codigoProveedor;
		try {
			codigoProveedor = Long.parseLong(codigoUnicoProveedor);
		}catch(NumberFormatException ex){
			return null;
		}
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", codigoProveedor);
		List<ActivoProveedor> listaProveedores = genericDao.getList(ActivoProveedor.class, filtro);

		if(!Checks.estaVacio(listaProveedores)){
			return listaProveedores.get(0);
		}

		return null;
	}
	
	@Override
	public ActivoProveedor searchProveedorCodigoUvem(String codigoProveedorUvem) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codProveedorUvem", codigoProveedorUvem);
		List<ActivoProveedor> listaProveedores = genericDao.getList(ActivoProveedor.class, filtro);

		if(!Checks.estaVacio(listaProveedores)){
			return listaProveedores.get(0);
		}

		return null;
	}

	@Override
	public List<ActivoProveedorContacto> getActivoProveedorContactoPorIdsUsuarioYCartera(List<Long> idUsuarios, Long idCartera) {
		return proveedoresDao.getActivoProveedorContactoPorIdsUsuarioYCartera(idUsuarios, idCartera);
	}

	@Override
	public Boolean esUsuarioConPerfilProveedor(Usuario usuario) {
		Boolean resultado = false;
		Perfil perfilProveedorHaya = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAPROV"));
		if(usuario != null && usuario.getPerfiles() != null && usuario.getPerfiles().size()>0){
			resultado = usuario.getPerfiles().contains(perfilProveedorHaya);
		}
		return resultado;
	}
	
	@Override
	public List<DDCartera> getCarteraPorProveedor(Long idProveedor){
		
		return proveedoresDao.getCarteraPorProveedor(idProveedor);
	}
	
	@Override
	public List<DDSubcartera> getSubcarteraPorProveedor(Long idProveedor, String codigoCartera){

		return proveedoresDao.getSubcarteraPorProveedor(idProveedor, codigoCartera);

	}
	
	@Override
	public Boolean cambiaMediador(String numActivo, String pveCodRem, String userName) {
		Boolean resultado = false;
		if (!Checks.esNulo(numActivo) && !Checks.esNulo(pveCodRem) && !Checks.esNulo(userName) 
				&& NumberUtils.isNumber(numActivo) && NumberUtils.isNumber(pveCodRem)) {
			Long nActivo = Long.parseLong(numActivo);
			resultado = proveedoresDao.cambiaMediador(nActivo, pveCodRem, userName);
		}
		return resultado;
	}
}
