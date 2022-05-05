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
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
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
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoIntegrado;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoProveedorDireccion;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.BloqueoApis;
import es.pfsgroup.plugin.rem.model.BloqueoApisCartera;
import es.pfsgroup.plugin.rem.model.BloqueoApisEspecialidad;
import es.pfsgroup.plugin.rem.model.BloqueoApisHistorico;
import es.pfsgroup.plugin.rem.model.BloqueoApisLineaNegocio;
import es.pfsgroup.plugin.rem.model.BloqueoApisProvincia;
import es.pfsgroup.plugin.rem.model.ConductasInapropiadas;
import es.pfsgroup.plugin.rem.model.ConfigEspecialidad;
import es.pfsgroup.plugin.rem.model.DtoActivoIntegrado;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoBloqueoApis;
import es.pfsgroup.plugin.rem.model.DtoConductasInapropiadas;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.DtoDireccionDelegacion;
import es.pfsgroup.plugin.rem.model.DtoInterlocutorBC;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvalua;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvaluaFilter;
import es.pfsgroup.plugin.rem.model.DtoMediadorOferta;
import es.pfsgroup.plugin.rem.model.DtoMediadorStats;
import es.pfsgroup.plugin.rem.model.DtoPersonaContacto;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.EntidadProveedor;
import es.pfsgroup.plugin.rem.model.ProveedorEspecialidad;
import es.pfsgroup.plugin.rem.model.ProveedorIdioma;
import es.pfsgroup.plugin.rem.model.ProveedorTerritorial;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedoresActivo;
import es.pfsgroup.plugin.rem.model.VHistoricoBloqueosApis;
import es.pfsgroup.plugin.rem.model.dd.DDBloqueDocumentoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedorRetirar;
import es.pfsgroup.plugin.rem.model.dd.DDCargoProveedorContacto;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCategoriaConductaInapropiada;
import es.pfsgroup.plugin.rem.model.dd.DDCodigoPostal;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEspecialidad;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDIdioma;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDOperativa;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenPeticionHomologacion;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoProcesoBlanqueo;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivosCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoBloqueoApi;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDireccionProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresCarteraDao;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresEvaluarDao;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresOfertasDao;
import es.pfsgroup.plugin.rem.service.InterlocutorCaixaService;
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
	public static final String ERROR_TIPO_UNICO_DOCUMENTO_PROVEEDOR = "Ya existe un documento del mismo tipo";
	public static final String ERROR_NOMBRE_DOCUMENTO_PROVEEDOR = "Ya existe un documento con el mismo nombre";
	private static final String ERROR_BLOQUEO_CARTERA = "api.bloqueado.cartera";
	private static final String ERROR_BLOQUEO_TIPO_COMERCIALIZACION = "api.bloqueado.tipo.comercializacion";
	private static final String ERROR_BLOQUEO_PROVINCIA = "api.bloqueado.provincia";
	private static final String ERROR_BLOQUEO_ESPECIALIDAD = "api.bloqueado.especialidad";


	public static final Integer comboOK = 1;
	public static final Integer comboKO = 0;
	public static final String VALOR_POR_DEFECTO = "VALOR_POR_DEFECTO";

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

	@Autowired
	private InterlocutorCaixaService interlocutorCaixaService;
	
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
			if (proveedor.getIdPersonaHaya() == null) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				Thread maestroPersona = new Thread( new MaestroDePersonas(proveedor.getDocIdentificativo(), proveedor.getCodigoProveedorRem(), usuarioLogado.getUsername()));
				maestroPersona.start();
			}
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
				if(proveedor.getCodigoApiProveedor()!=null) {
					beanUtilNotNull.copyProperty(dto, "codigoApiProveedor", proveedor.getCodigoApiProveedor());
				}
				if(proveedor.getMediadorRelacionado()!=null) {
					beanUtilNotNull.copyProperty(dto, "idMediadorRelacionado", proveedor.getMediadorRelacionado().getCodigoProveedorRem());
				}
					
				
				if(proveedor.getOrigenPeticionHomologacion()!=null) {
					beanUtilNotNull.copyProperty(dto, "origenPeticionHomologacionCodigo", proveedor.getOrigenPeticionHomologacion().getCodigo());
				}
				if(proveedor.getPeticionario()!=null) {
					beanUtilNotNull.copyProperty(dto, "peticionario", proveedor.getPeticionario());
				}
				if(proveedor.getLineaNegocio()!=null) {
					beanUtilNotNull.copyProperty(dto, "lineaNegocioCodigo", proveedor.getLineaNegocio().getCodigo());
				}		
				if(proveedor.getGestionClientesNoResidentes()!=null) {
					beanUtilNotNull.copyProperty(dto, "gestionClientesNoResidentesCodigo", proveedor.getGestionClientesNoResidentes().getCodigo());
				}
				if(proveedor.getNumeroComerciales()!=null) {
					beanUtilNotNull.copyProperty(dto, "numeroComerciales", proveedor.getNumeroComerciales());
				}
				if(proveedor.getFechaUltimoContratoVigente()!=null) {
					beanUtilNotNull.copyProperty(dto, "fechaUltimoContratoVigente", proveedor.getFechaUltimoContratoVigente());
				}
				if(proveedor.getMotivoBaja()!=null) {
					beanUtilNotNull.copyProperty(dto, "motivoBaja", proveedor.getMotivoBaja());
				}
								
				List<ProveedorEspecialidad> proveedorEspecialidad = genericDao.getList(ProveedorEspecialidad.class, proveedorIdFiltro);
				if(!Checks.estaVacio(proveedorEspecialidad)) {
					StringBuffer codigos = new StringBuffer();
					for(ProveedorEspecialidad pe : proveedorEspecialidad) {
						if(!Checks.esNulo(pe.getEspecialidad())) {
							codigos.append(pe.getEspecialidad().getCodigo()).append(",");
						}
					}
					beanUtilNotNull.copyProperty(dto, "especialidadCodigo", codigos.substring(0, (codigos.length()-1)));
				}
				
				List<ProveedorIdioma> proveedorIdioma = genericDao.getList(ProveedorIdioma.class, proveedorIdFiltro);
				if(!Checks.estaVacio(proveedorIdioma)) {
					StringBuffer codigos = new StringBuffer();
					for(ProveedorIdioma pi : proveedorIdioma) {
						if(!Checks.esNulo(pi.getIdioma())) {
							codigos.append(pi.getIdioma().getCodigo()).append(",");
						}
					}
					beanUtilNotNull.copyProperty(dto, "idiomaCodigo", codigos.substring(0, (codigos.length()-1)));
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
		DtoInterlocutorBC oldData = new DtoInterlocutorBC();
		DtoInterlocutorBC newData = new DtoInterlocutorBC();
		boolean relevanteBC = interlocutorCaixaService.isProveedorInvolucradoBC(proveedor);

		try {
			if (relevanteBC){
				oldData.proveedorToDto(proveedor);
			}

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
				if(dto.getCarteraCodigo().equals("VALOR_POR_DEFECTO")) {					
					Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId());
					genericDao.delete(EntidadProveedor.class, filtroProveedor);
				} else {
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
			if(!Checks.esNulo(dto.getEstadoProveedorCodigo()) ) { 
				if(DDEstadoProveedor.ESTADO_BAJA_PROVEEDOR.equals(dto.getEstadoProveedorCodigo())) {
					beanUtilNotNull.copyProperty(proveedor, "fechaBaja", new Date());
				} else if (DDEstadoProveedor.ESTADO_BIGENTE.equals(dto.getEstadoProveedorCodigo())) {
					proveedor.setFechaBaja(null);
				}
				
			}
			if(!Checks.esNulo(dto.getCodProveedorUvem())) {
				beanUtilNotNull.copyProperty(proveedor, "codProveedorUvem", dto.getCodProveedorUvem());
			} else {
				proveedor.setCodProveedorUvem(null);
			}	
			
			if(dto.getCodigoApiProveedor()!=null) {
				beanUtilNotNull.copyProperty(proveedor, "codigoApiProveedor", dto.getCodigoApiProveedor());
			}
			
			if(dto.getIdMediadorRelacionado()!=null) {
				ActivoProveedor mediadorRelacionado = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem",dto.getIdMediadorRelacionado()));
				
				if(mediadorRelacionado!=null) {
					beanUtilNotNull.copyProperty(proveedor, "mediadorRelacionado", mediadorRelacionado);	
				}
				
			}
			
			if(!Checks.esNulo(dto.getPeticionario())) {
				proveedor.setPeticionario(dto.getPeticionario());
			}
			
			if(!Checks.esNulo(dto.getOrigenPeticionHomologacionCodigo())) {
				DDOrigenPeticionHomologacion origenPeticion = genericDao.get(DDOrigenPeticionHomologacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getOrigenPeticionHomologacionCodigo()));
				proveedor.setOrigenPeticionHomologacion(origenPeticion);			
			}
			
			if(!Checks.esNulo(dto.getLineaNegocioCodigo())) {
				DDTipoComercializacion lineaNegocio = genericDao.get(DDTipoComercializacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getLineaNegocioCodigo()));
				proveedor.setLineaNegocio(lineaNegocio);			
			}
			
			if(!Checks.esNulo(dto.getGestionClientesNoResidentesCodigo())) {
				DDSinSiNo gestClientesNoResidentes = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getGestionClientesNoResidentesCodigo()));
				proveedor.setGestionClientesNoResidentes(gestClientesNoResidentes);			
			}
			
			if(!Checks.esNulo(dto.getNumeroComerciales())) {
				proveedor.setNumeroComerciales(dto.getNumeroComerciales());
			}
			
			if(!Checks.esNulo(dto.getFechaUltimoContratoVigente())) {
				proveedor.setFechaUltimoContratoVigente(dto.getFechaUltimoContratoVigente());
			}
			
			if(!Checks.esNulo(dto.getMotivoBaja())) {
				proveedor.setMotivoBaja(dto.getMotivoBaja());
			}
			
			if(!Checks.esNulo(dto.getEspecialidadCodigo())) {
				List<String> codigosEspecialidad = Arrays.asList(dto.getEspecialidadCodigo().split(","));
				
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId());
				List<ProveedorEspecialidad> proveedorEspecialidadByProvID = genericDao.getList(ProveedorEspecialidad.class, filtroProveedor);
				
				// Borrar los elementos que no vengan en la lista y existan en la DDBB.
				for(ProveedorEspecialidad pe : proveedorEspecialidadByProvID){
					if(!codigosEspecialidad.contains(pe.getEspecialidad().getCodigo())){
						Filter filtroEspecialidad = genericDao.createFilter(FilterType.EQUALS, "especialidad.codigo", pe.getEspecialidad().getCodigo());
						ProveedorEspecialidad especialidadABorrar = genericDao.get(ProveedorEspecialidad.class, filtroEspecialidad, filtroProveedor);
						if(!Checks.esNulo(especialidadABorrar)) {
							genericDao.deleteById(ProveedorEspecialidad.class, especialidadABorrar.getId());
						}
					}
				}
				
				// Almacenar los elementos que vengan en la lista y no existan en la DDBB.
				// Dejar los elementos que vangan en la lista y exista en la DDBB.
				for(String codigo : codigosEspecialidad) {
					DDEspecialidad especialidad = (DDEspecialidad) utilDiccionarioApi.dameValorDiccionarioByCod(DDEspecialidad.class, codigo);
					if(!Checks.esNulo(especialidad)) {
						Filter filtroEspecialidad = genericDao.createFilter(FilterType.EQUALS, "especialidad.codigo", especialidad.getCodigo());
						List<ProveedorEspecialidad> proveedorEspecialidad = genericDao.getList(ProveedorEspecialidad.class, filtroProveedor, filtroEspecialidad);
						if(Checks.estaVacio(proveedorEspecialidad)) {
							ProveedorEspecialidad pveEspecialidad = new ProveedorEspecialidad();
							pveEspecialidad.setEspecialidad(especialidad);
							pveEspecialidad.setProveedor(proveedor);						
							genericDao.save(ProveedorEspecialidad.class, pveEspecialidad);
						}
					}
				}
				
			}
			
			if(!Checks.esNulo(dto.getIdiomaCodigo())) {
				List<String> codigosIdioma = Arrays.asList(dto.getIdiomaCodigo().split(","));
				
				Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId());
				List<ProveedorIdioma> proveedorIdiomaByProvID = genericDao.getList(ProveedorIdioma.class, filtroProveedor);
				
				// Borrar los elementos que no vengan en la lista y existan en la DDBB.
				for(ProveedorIdioma pi : proveedorIdiomaByProvID){
					if(!codigosIdioma.contains(pi.getIdioma().getCodigo())){
						Filter filtroIdioma = genericDao.createFilter(FilterType.EQUALS, "idioma.codigo", pi.getIdioma().getCodigo());
						ProveedorIdioma idiomaABorrar = genericDao.get(ProveedorIdioma.class, filtroIdioma, filtroProveedor);
						if(!Checks.esNulo(idiomaABorrar)) {
							genericDao.deleteById(ProveedorIdioma.class, idiomaABorrar.getId());
						}
					}
				}
				
				// Almacenar los elementos que vengan en la lista y no existan en la DDBB.
				// Dejar los elementos que vangan en la lista y exista en la DDBB.
				for(String codigo : codigosIdioma) {
					DDIdioma idioma = (DDIdioma) utilDiccionarioApi.dameValorDiccionarioByCod(DDIdioma.class, codigo);
					if(!Checks.esNulo(idioma)) {
						Filter filtroIdioma = genericDao.createFilter(FilterType.EQUALS, "idioma.codigo", idioma.getCodigo());
						List<ProveedorIdioma> proveedorIdioma = genericDao.getList(ProveedorIdioma.class, filtroProveedor, filtroIdioma);
						if(Checks.estaVacio(proveedorIdioma)) {
							ProveedorIdioma pveIdioma = new ProveedorIdioma();
							pveIdioma.setIdioma(idioma);
							pveIdioma.setProveedor(proveedor);						
							genericDao.save(ProveedorIdioma.class, pveIdioma);
						}
					}
				}
				
			}

		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
			return false;
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
			return false;
		}

		proveedoresDao.save(proveedor);

		if (relevanteBC){
			newData.proveedorToDto(proveedor);
			interlocutorCaixaService.callReplicateClientAsync(oldData,newData,proveedor);
		}

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
			genericDao.deleteById(ActivoProveedorContacto.class, personaContacto.getId());
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
					beanUtilNotNull.copyProperty(dto, "piso", delegacion.getPiso());
					beanUtilNotNull.copyProperty(dto, "otros", delegacion.getOtros());
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
				logger.error(e.getMessage());
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
	public List<DtoAdjunto> getAdjuntos(Long id) throws Exception {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		ActivoProveedor proveedor = proveedoresDao.getProveedorById(id);
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosProveedor(proveedor);
			} catch (GestorDocumentalException gex) {
				logger.error(gex.getMessage());
				throw gex;
			}
		} else {		
			Filter adjuntoFilter = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId());
			Filter adjuntoBorradoFilter = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter adjuntoLocalFilter = genericDao.createFilter(FilterType.NOTNULL, "adjunto");
			List<ActivoAdjuntoProveedor> adjuntos = genericDao.getList(ActivoAdjuntoProveedor.class, adjuntoFilter, adjuntoBorradoFilter, adjuntoLocalFilter);

			for (ActivoAdjuntoProveedor adjunto : adjuntos) {
				if (DDBloqueDocumentoProveedor.COD_DOCUMENTOS.equals(adjunto.getTipoDocumentoProveedor().getBloque().getCodigo())) {
					DtoAdjunto dto = new DtoAdjunto();
					BeanUtils.copyProperties(dto, adjunto);
					beanUtilNotNull.copyProperty(dto, "idEntidad", adjunto.getProveedor().getId());
					beanUtilNotNull.copyProperty(dto, "descripcionTipo", adjunto.getTipoDocumentoProveedor().getDescripcion());
					beanUtilNotNull.copyProperty(dto, "gestor", adjunto.getAuditoria().getUsuarioCrear());									
					listaAdjuntos.add(dto);
				}
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
				
		Adjunto adj = null;
		Long idDocRestClient = null;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		ActivoAdjuntoProveedor adjuntoProveedor = new ActivoAdjuntoProveedor();
		ActivoProveedor proveedor = proveedoresDao.get(Long.parseLong(fileItem.getParameter("idEntidad")));
		
	   	Filter filtroTipoDoc = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
	   	DDTipoDocumentoProveedor tipoDocumentoProveedor = genericDao.get(DDTipoDocumentoProveedor.class, filtroTipoDoc, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
	   	
	   	if(!Checks.esNulo(tipoDocumentoProveedor)) {
		   	if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
		   		idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoProveedor(proveedor, fileItem, usuarioLogado.getUsername(), tipoDocumentoProveedor.getMatricula());
		   		if (!Checks.esNulo(idDocRestClient)) adjuntoProveedor.setIdDocRestClient(idDocRestClient);
		   	} else {
		   		adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
		   		if (!Checks.esNulo(adj)) adjuntoProveedor.setAdjunto(adj);
		   	}
		   	
		   	if (!Checks.esNulo(idDocRestClient) || !Checks.esNulo(adj)) {
					adjuntoProveedor.setTipoDocumentoProveedor(tipoDocumentoProveedor);
					adjuntoProveedor.setProveedor(proveedor);
					adjuntoProveedor.setContentType(fileItem.getFileItem().getContentType());
					adjuntoProveedor.setTamanyo(fileItem.getFileItem().getLength());
					adjuntoProveedor.setNombre(fileItem.getFileItem().getFileName());
					adjuntoProveedor.setDescripcion(fileItem.getParameter("descripcion"));			
					adjuntoProveedor.setFechaDocumento(new Date());
					adjuntoProveedor.setIdDocRestClient(idDocRestClient);
					adjuntoProveedor.setAdjunto(adj);
					Auditoria.save(adjuntoProveedor);
					genericDao.save(ActivoAdjuntoProveedor.class, adjuntoProveedor);
		   	}
	   	} else {
			throw new Exception(ProveedoresManager.ERROR_TIPO_DOCUMENTO_PROVEEDOR);
		}
	   	
	   	return null;
	}

	@Override
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto) {
		
		FileItem fileItem = null;
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {		
			try {
				fileItem = gestorDocumentalAdapterApi.getFileItem(dtoAdjunto.getId(), dtoAdjunto.getNombre());
			} catch (Exception e) {
				logger.error(e.getMessage());
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
			
			proveedor.setFechaAlta(new Date());			
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
	public Boolean cambiaMediador(String numActivo, String pveCodRem, String userName) {
		Boolean resultado = false;
		if (!Checks.esNulo(numActivo) && !Checks.esNulo(pveCodRem) && !Checks.esNulo(userName) 
				&& NumberUtils.isNumber(numActivo) && NumberUtils.isNumber(pveCodRem)) {
			Long nActivo = Long.parseLong(numActivo);
			resultado = proveedoresDao.cambiaMediador(nActivo, pveCodRem, userName);
		}
		return resultado;
	}
	
	@Override
	public List<ActivoProveedor> getMediadoresActivos() {		
		
		return proveedoresDao.getMediadoresActivos();
	}
	
	@Override
	public List<DtoConductasInapropiadas> getConductasInapropiadasByProveedor(Long id) {

		List<DtoConductasInapropiadas> dtoConductas = new ArrayList<DtoConductasInapropiadas>();
		ActivoProveedor proveedor = proveedoresDao.getProveedorById(id);
		List<ConductasInapropiadas> conductasList = genericDao.getList(ConductasInapropiadas.class, 
				genericDao.createFilter(FilterType.EQUALS, "proveedor", proveedor));
		
		if(!Checks.esNulo(conductasList) && !conductasList.isEmpty()) {
			for (ConductasInapropiadas conducta : conductasList) {
				dtoConductas.add(objectToDtoConductasInapropiadas(conducta));
			}
		}
		
		return dtoConductas;
	}
	
	private DtoConductasInapropiadas objectToDtoConductasInapropiadas(ConductasInapropiadas conducta) {
		DtoConductasInapropiadas dto = new DtoConductasInapropiadas();
		dto.setId(conducta.getId());
		dto.setIdProveedor(conducta.getProveedor().getId());
		
		Date fechaAlta = !Checks.esNulo(conducta.getAuditoria().getFechaModificar()) 
				? conducta.getAuditoria().getFechaModificar() : conducta.getAuditoria().getFechaCrear(); 
		dto.setFechaAlta(fechaAlta);
		
		String username = !Checks.esNulo(conducta.getAuditoria().getUsuarioModificar()) 
				? conducta.getAuditoria().getUsuarioModificar() : conducta.getAuditoria().getUsuarioCrear(); 
		Usuario usuario = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", username));
		dto.setUsuarioAlta(usuario.getApellidoNombre());
		
		dto.setCategoriaConductaCodigo(conducta.getCategoriaConducta().getCodigo());
		dto.setCategoriaConducta(conducta.getCategoriaConducta().getDescripcion());
		dto.setTipoConducta(conducta.getCategoriaConducta().getTipoConducta().getDescripcion());
		dto.setNivelConducta(conducta.getCategoriaConducta().getNivelConducta().getDescripcion());
	
		dto.setComentarios(conducta.getComentarios());
		if (!Checks.esNulo(conducta.getDelegacion()))
			dto.setDelegacion(conducta.getDelegacion().getId().toString());
		
		if (!Checks.esNulo(conducta.getAdjunto())) {
			dto.setIdAdjunto(!Checks.esNulo(conducta.getAdjunto().getIdDocRestClient()) ? 
					conducta.getAdjunto().getIdDocRestClient().toString() : conducta.getAdjunto().getId().toString());
			dto.setAdjunto(!Checks.esNulo(conducta.getAdjunto().getDescripcion()) ? conducta.getAdjunto().getDescripcion() : conducta.getAdjunto().getNombre());
			dto.setTamanyoAdjunto(!Checks.esNulo(conducta.getAdjunto().getTamanyo()) ? conducta.getAdjunto().getTamanyo().toString() : "0");
		}
		
		return dto;
	}
	
	@Override
	@Transactional()
	public boolean saveConductasInapropiadas(DtoConductasInapropiadas dto) {
		ConductasInapropiadas conducta = new ConductasInapropiadas();
		ActivoProveedor proveedor = proveedoresDao.getProveedorById(dto.getIdProveedor());
		
		if (!Checks.esNulo(dto.getId())) {
			conducta = genericDao.get(ConductasInapropiadas.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
		}
		
		conducta.setProveedor(proveedor);
		conducta.setCategoriaConducta(genericDao.get(DDCategoriaConductaInapropiada.class, 
				genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCategoriaConductaCodigo())));
		
		conducta.setComentarios(dto.getComentarios());
		
		if (!Checks.esNulo(dto.getDelegacion())) {
			conducta.setDelegacion(genericDao.get(ActivoProveedorDireccion.class, 
					genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getDelegacion()))));
		} else conducta.setDelegacion(null);
		
		genericDao.save(ConductasInapropiadas.class, conducta);
		
		return true;
	}

	@Override
	public List<DtoDiccionario> getDelegacionesByProveedor(String id) {
		List<DtoDiccionario> dtoList = new ArrayList<DtoDiccionario>();
		ActivoProveedor proveedor = proveedoresDao.getProveedorById(Long.parseLong(id));
		List<ActivoProveedorDireccion> delegacionesList = genericDao.getList(ActivoProveedorDireccion.class, 
				genericDao.createFilter(FilterType.EQUALS, "proveedor", proveedor));
		
		if(!Checks.esNulo(delegacionesList) && !delegacionesList.isEmpty()) {
			for (ActivoProveedorDireccion delegacion : delegacionesList) {
				DtoDiccionario dto = new DtoDiccionario();
				dto.setId(delegacion.getId());
				dto.setCodigo(delegacion.getId().toString());
				dtoList.add(dto);
			}
		}
		
		return dtoList;
	}

	@Override
	@Transactional()
	public boolean deleteConductasInapropiadas(String id) {

		if(!Checks.esNulo(id)) {
			genericDao.deleteById(ConductasInapropiadas.class, Long.parseLong(id));
			return true;
		}
		return false;
	}


	@Override
	public DtoBloqueoApis getBloqueoApiByProveedorId(Long id) {
		BloqueoApis bloqueo = genericDao.get(BloqueoApis.class, genericDao.createFilter(FilterType.EQUALS, "proveedor.id", id));
		DtoBloqueoApis dto = new DtoBloqueoApis();
		if(bloqueo != null) {
			dto =  this.bloqueoApiToDtoBloqueoApi(bloqueo);
		}
	
		return dto;
	}
	
	
	private DtoBloqueoApis bloqueoApiToDtoBloqueoApi (BloqueoApis bloqueo) {
		DtoBloqueoApis dto = new DtoBloqueoApis();
		
		dto.setIdBloqueo(bloqueo.getId());
		dto.setMotivo(bloqueo.getMotivoBloqueo());
		dto.setMotivoAnterior(bloqueo.getMotivoBloqueo());
		List<BloqueoApisCartera> bloqueoApisCarteraList = bloqueo.getBloqueoApisCartera();
		if(bloqueoApisCarteraList != null && !bloqueoApisCarteraList.isEmpty()) {
			dto.setCarteraCodigo(this.devolverCodigoCarterasBloqueadasApi(bloqueoApisCarteraList));
		}
		List<BloqueoApisEspecialidad> bloqueoApisEspecialidadList = bloqueo.getBloqueoApisEspecialidad();
		if(bloqueoApisEspecialidadList != null && !bloqueoApisEspecialidadList.isEmpty()) {
			dto.setEspecialidadCodigo(this.devolverCodigoEspecialidadBloqueadasApi(bloqueoApisEspecialidadList));
		}
		List<BloqueoApisLineaNegocio> bloqueoApisLineaNegocioList = bloqueo.getBloqueoApisLineaNegocio();
		if(bloqueoApisLineaNegocioList != null && !bloqueoApisLineaNegocioList.isEmpty()) {
			dto.setLineaNegocioCodigo(this.devolverCodigoLineaNegocioBloqueadasApi(bloqueoApisLineaNegocioList));
		}
		List<BloqueoApisProvincia> bloqueoApisProvinciaList = bloqueo.getBloqueoApisProvincia();
		if(bloqueoApisProvinciaList != null && !bloqueoApisProvinciaList.isEmpty()) {
			dto.setProvinciaCodigo(this.devolverCodigoProvinciaBloqueadasApi(bloqueoApisProvinciaList));
		}
	
		return dto;
	}
	
	private String devolverCodigoCarterasBloqueadasApi(List<BloqueoApisCartera> bloqueoApisCarteraList) {
		StringBuffer lista = new StringBuffer();
		for (BloqueoApisCartera bloqueo : bloqueoApisCarteraList) {
			if(bloqueo.getCartera() != null) {
				lista.append(bloqueo.getCartera().getCodigo()).append(",");
			}
		}
		String listString = lista.toString();
		if(!listString.isEmpty()) {
			listString = lista.substring(0, (listString.length()-1));
		}
		
		return this.returnStringFromList(lista);
	}
	
	private String devolverCodigoEspecialidadBloqueadasApi(List<BloqueoApisEspecialidad> bloqueoApisEspecialidadList) {
		StringBuffer lista = new StringBuffer();
		for (BloqueoApisEspecialidad bloqueo : bloqueoApisEspecialidadList) {
			if(bloqueo.getEspecialidad() != null) {
				lista.append(bloqueo.getEspecialidad().getCodigo()).append(",");
			}
		}
		String listString = lista.toString();
		if(!listString.isEmpty()) {
			listString = lista.substring(0, (listString.length()-1));
		}
		
		return this.returnStringFromList(lista);
	}
	
	private String devolverCodigoLineaNegocioBloqueadasApi(List<BloqueoApisLineaNegocio> bloqueoApisLineaNegocioList) {
		StringBuffer lista = new StringBuffer();
		for (BloqueoApisLineaNegocio bloqueo : bloqueoApisLineaNegocioList) {
			if(bloqueo.getTipoComercializacion() != null) {
				lista.append(bloqueo.getTipoComercializacion().getCodigo()).append(",");
			}
		}
		String listString = lista.toString();
		if(!listString.isEmpty()) {
			listString = lista.substring(0, (listString.length()-1));
		}
		
		return this.returnStringFromList(lista);
	}
	
	private String devolverCodigoProvinciaBloqueadasApi(List<BloqueoApisProvincia> bloqueoApisProvinciaList) {
		StringBuffer lista = new StringBuffer();
		for (BloqueoApisProvincia bloqueo : bloqueoApisProvinciaList) {
			if(bloqueo.getProvincia() != null) {
				lista.append(bloqueo.getProvincia().getCodigo()).append(",");
			}
		}
		String listString = lista.toString();
		if(!listString.isEmpty()) {
			listString = lista.substring(0, (listString.length()-1));
		}
		
		return this.returnStringFromList(lista);
	}
	
	private String returnStringFromList(StringBuffer lista) {
		String listString = lista.toString();
		if(!listString.isEmpty()) {
			listString = lista.substring(0, (listString.length()-1));
		}
		
		return listString;
	}
	
	@Override
	public List<VHistoricoBloqueosApis> getHistoricoBloqueos(Long id) {
		List<VHistoricoBloqueosApis> hBAHList = genericDao.getList(VHistoricoBloqueosApis.class, genericDao.createFilter(FilterType.EQUALS, "idPve", id)); 
		return hBAHList;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void saveBloqueoProveedorById (Long id, DtoBloqueoApis dto) {
		BloqueoApis bloqueo = genericDao.get(BloqueoApis.class, genericDao.createFilter(FilterType.EQUALS, "proveedor.id", id));
		DtoBloqueoApis bloqueoAntiguo = this.bloqueoApiToDtoBloqueoApi(bloqueo);
		if(bloqueo != null && bloqueo.getProveedor()!= null) {
			this.createRegistroHistoricoBloqueoApis(id, dto, bloqueoAntiguo);
			this.modificarRegistrosAnteriores(id, dto, bloqueoAntiguo);
			Auditoria.delete(bloqueo);
			genericDao.save(BloqueoApis.class, bloqueo);
		}
		
		bloqueo = new BloqueoApis();
		ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		bloqueo.setProveedor(proveedor);
		bloqueo.setMotivoBloqueo(dto.getMotivo());
		genericDao.save(BloqueoApis.class, bloqueo);

		if(!VALOR_POR_DEFECTO.equals(dto.getCarteraCodigo())) {
			if(dto.getCarteraCodigo() != null && !dto.getCarteraCodigo().isEmpty()) {
				this.saveBloqueosCartera(bloqueo,Arrays.asList(dto.getCarteraCodigo().split(",")));
			}else if(bloqueoAntiguo.getCarteraCodigo() != null && !bloqueoAntiguo.getCarteraCodigo().isEmpty()) {
				this.saveBloqueosCartera(bloqueo,Arrays.asList(bloqueoAntiguo.getCarteraCodigo().split(",")));
			}
		}
		
		if(!VALOR_POR_DEFECTO.equals(dto.getEspecialidadCodigo())) {
			if(dto.getEspecialidadCodigo() != null && !dto.getEspecialidadCodigo().isEmpty() && !VALOR_POR_DEFECTO.equals(dto.getCarteraCodigo())) {
				this.saveBloqueosEspecialidad(bloqueo,Arrays.asList(dto.getEspecialidadCodigo().split(",")));
			}else if(bloqueoAntiguo.getEspecialidadCodigo() != null && !bloqueoAntiguo.getEspecialidadCodigo().isEmpty()) {
				this.saveBloqueosEspecialidad(bloqueo,Arrays.asList(bloqueoAntiguo.getEspecialidadCodigo().split(",")));
			}
		}
		
		if(!VALOR_POR_DEFECTO.equals(dto.getLineaNegocioCodigo())) {
			if(dto.getLineaNegocioCodigo() != null && !dto.getLineaNegocioCodigo().isEmpty()) {
				this.saveBloqueosLineaNegocio(bloqueo,Arrays.asList(dto.getLineaNegocioCodigo().split(",")));
			}else if(bloqueoAntiguo.getLineaNegocioCodigo() != null && !bloqueoAntiguo.getLineaNegocioCodigo().isEmpty()) {
				this.saveBloqueosLineaNegocio(bloqueo,Arrays.asList(bloqueoAntiguo.getLineaNegocioCodigo().split(",")));
			}
		}
		
		if(!VALOR_POR_DEFECTO.equals(dto.getProvinciaCodigo())) {
			if(dto.getProvinciaCodigo() != null && !dto.getProvinciaCodigo().isEmpty()) {
				this.saveBloqueosProvincia(bloqueo,Arrays.asList(dto.getProvinciaCodigo().split(",")));
			}else if(bloqueoAntiguo.getProvinciaCodigo() != null && !bloqueoAntiguo.getProvinciaCodigo().isEmpty()) {
				this.saveBloqueosProvincia(bloqueo,Arrays.asList(bloqueoAntiguo.getProvinciaCodigo().split(",")));
			}
		}
		
		
	}
	
	private void saveBloqueosCartera(BloqueoApis bloqueo, List<String> listaCodigos) {
		for (String codigo : listaCodigos) {
			BloqueoApisCartera bl = new BloqueoApisCartera();
			bl.setAuditoria(Auditoria.getNewInstance());
			bl.setBloqueoApis(bloqueo);
			bl.setCartera(genericDao.get(DDCartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigo)));
			genericDao.save(BloqueoApisCartera.class, bl);
			
		}
	}
	
	private void saveBloqueosEspecialidad(BloqueoApis bloqueo, List<String> listaCodigos) {
		for (String codigo : listaCodigos) {
			BloqueoApisEspecialidad bl = new BloqueoApisEspecialidad();
			bl.setAuditoria(Auditoria.getNewInstance());
			bl.setBloqueoApis(bloqueo);
			bl.setEspecialidad(genericDao.get(DDEspecialidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigo)));
			genericDao.save(BloqueoApisEspecialidad.class, bl);
			
		}
	}

	private void saveBloqueosLineaNegocio(BloqueoApis bloqueo, List<String> listaCodigos) {
		for (String codigo : listaCodigos) {
			BloqueoApisLineaNegocio bl = new BloqueoApisLineaNegocio();
			bl.setAuditoria(Auditoria.getNewInstance());
			bl.setBloqueoApis(bloqueo);
			bl.setTipoComercializacion(genericDao.get(DDTipoComercializacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigo)));
			genericDao.save(BloqueoApisLineaNegocio.class, bl);
		}
	}
	
	private void saveBloqueosProvincia(BloqueoApis bloqueo, List<String> listaCodigos) {
		for (String codigo : listaCodigos) {
			BloqueoApisProvincia bl = new BloqueoApisProvincia();
			bl.setAuditoria(Auditoria.getNewInstance());
			bl.setBloqueoApis(bloqueo);
			bl.setProvincia(genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigo)));
			genericDao.save(BloqueoApisProvincia.class, bl);
			
		}
	}
	
	
	@Transactional(readOnly = false)
	private void createRegistroHistoricoBloqueoApis(Long id, DtoBloqueoApis dto, DtoBloqueoApis bloqueoAntiguo) {
		
		
		ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
	
		List<DDTipoBloqueoApi> tiposBloqueoList = genericDao.getList(DDTipoBloqueoApi.class);
		for (DDTipoBloqueoApi ddTipoBloqueoApi : tiposBloqueoList) {
			List<String> nuevosCodigos = this.devolverCodigos(ddTipoBloqueoApi.getCodigo(), dto, bloqueoAntiguo);
			DDTipoBloqueoApi tpC = genericDao.get(DDTipoBloqueoApi.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ddTipoBloqueoApi.getCodigo()));
			for (String codigo : nuevosCodigos) {
				BloqueoApisHistorico bah = new BloqueoApisHistorico();
				bah.setTipoBloqueo(tpC);
				bah = this.saveBloqueo(bah, tpC, codigo);
				bah.setProveedor(proveedor);
				bah.setMotivoBloqueo(dto.getMotivo());
				genericDao.save(BloqueoApisHistorico.class, bah);
			}
		}
		
		
	}
	
	
	private BloqueoApisHistorico saveBloqueo(BloqueoApisHistorico bah, DDTipoBloqueoApi tipoBloqueo, String codigo) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		if(DDTipoBloqueoApi.CARTERA.equals(tipoBloqueo.getCodigo())) {
			bah.setBloqueoApisCartera(genericDao.get(DDCartera.class, filtro));
		}else if(DDTipoBloqueoApi.LINEA_NEGOCIO.equals(tipoBloqueo.getCodigo())) {
			bah.setBloqueoApisLineaNegocio(genericDao.get(DDTipoComercializacion.class, filtro));
		}else if(DDTipoBloqueoApi.ESPECIALIDAD.equals(tipoBloqueo.getCodigo())) {
			bah.setBloqueoApisEspecialidad(genericDao.get(DDEspecialidad.class, filtro));
		}else if(DDTipoBloqueoApi.PROVINCIA.equals(tipoBloqueo.getCodigo())) {
			bah.setBloqueoApisProvincia(genericDao.get(DDProvincia.class, filtro));
		}
		
		
		return bah;
	}
	
	private List<String> devolverCodigos(String codigoTipo, DtoBloqueoApis dto, DtoBloqueoApis bloqueoAntiguo){
		List<String> codigosNuevos = new ArrayList<String>();
		List<String> codigosAntiguos= new ArrayList<String>();
		List<String> anyadirCodigo = new ArrayList<String>();
		
		if(DDTipoBloqueoApi.CARTERA.equals(codigoTipo)) {
			if(dto.getCarteraCodigo() != null && !dto.getCarteraCodigo().isEmpty()) {
				codigosNuevos=  Arrays.asList(dto.getCarteraCodigo().split(","));
			}
			if(bloqueoAntiguo.getCarteraCodigo() != null && !bloqueoAntiguo.getCarteraCodigo().isEmpty()) {
				codigosAntiguos = Arrays.asList(bloqueoAntiguo.getCarteraCodigo().split(","));
			}
		}
		if(DDTipoBloqueoApi.LINEA_NEGOCIO.equals(codigoTipo)) {
			if(dto.getLineaNegocioCodigo() != null && !dto.getLineaNegocioCodigo().isEmpty()) {
				codigosNuevos=  Arrays.asList(dto.getLineaNegocioCodigo().split(","));
			}
			if(bloqueoAntiguo.getLineaNegocioCodigo() != null && !bloqueoAntiguo.getLineaNegocioCodigo().isEmpty()) {
				codigosAntiguos = Arrays.asList(bloqueoAntiguo.getLineaNegocioCodigo().split(","));
			}
		}
		if(DDTipoBloqueoApi.ESPECIALIDAD.equals(codigoTipo)) {
			if(dto.getEspecialidadCodigo() != null && !dto.getEspecialidadCodigo().isEmpty()) {
				codigosNuevos=  Arrays.asList(dto.getEspecialidadCodigo().split(","));
			}
			if(bloqueoAntiguo.getEspecialidadCodigo() != null && !bloqueoAntiguo.getEspecialidadCodigo().isEmpty()) {
				codigosAntiguos = Arrays.asList(bloqueoAntiguo.getEspecialidadCodigo().split(","));
			}
		}
		if(DDTipoBloqueoApi.PROVINCIA.equals(codigoTipo)) {
			if(dto.getProvinciaCodigo() != null && !dto.getProvinciaCodigo().isEmpty()) {
				codigosNuevos=  Arrays.asList(dto.getProvinciaCodigo().split(","));
			}
			if(bloqueoAntiguo.getProvinciaCodigo() != null && !bloqueoAntiguo.getProvinciaCodigo().isEmpty()) {
				codigosAntiguos = Arrays.asList(bloqueoAntiguo.getProvinciaCodigo().split(","));
			}
		}
			
		for (String codigoNuevo : codigosNuevos) {
			if(!codigosAntiguos.contains(codigoNuevo)) {
				anyadirCodigo.add(codigoNuevo);
			}
		}
		
		anyadirCodigo.remove(VALOR_POR_DEFECTO);
		
		return anyadirCodigo;
	}
	
	
	
	@Transactional(readOnly = false)
	private void modificarRegistrosAnteriores(Long id, DtoBloqueoApis dto, DtoBloqueoApis bloqueoAntiguo) {
		
		Filter filtroProveedor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", id);
		Filter filtroMotivoDesbloqueoNull = genericDao.createFilter(FilterType.NULL, "motivoDesbloqueo");
		String motivo = dto.getMotivo();
		
		List<DDTipoBloqueoApi> tiposBloqueoList = genericDao.getList(DDTipoBloqueoApi.class);
		for (DDTipoBloqueoApi ddTipoBloqueoApi : tiposBloqueoList) {
			if(this.seHaModificadoRegistro(ddTipoBloqueoApi.getCodigo(), dto)) {
				List<String> codigosBorrar = this.devolverCodigos(ddTipoBloqueoApi.getCodigo(), bloqueoAntiguo, dto);
				for (String codigo : codigosBorrar) {
					this.actualizarRegistros(ddTipoBloqueoApi.getCodigo(), codigo, motivo, filtroProveedor, filtroMotivoDesbloqueoNull);
				}
			}
		}
	}
	
	
	@Transactional(readOnly = false)
	private void actualizarRegistros(String codigoBloqueo, String codigo, String motivo, Filter filtroProveedor, Filter filtroMotivoDesbloqueoNull) {
		Filter filtro = this.devolverFiltro(codigoBloqueo, codigo);
		if(filtro != null) {
			BloqueoApisHistorico bah = genericDao.get(BloqueoApisHistorico.class, filtroProveedor, filtroMotivoDesbloqueoNull,filtro);
			if(bah != null) {
				bah.setMotivoDesbloqueo(motivo);
				genericDao.save(BloqueoApisHistorico.class, bah);
			}
		}
	}
	
	private boolean seHaModificadoRegistro(String codigoTipo, DtoBloqueoApis dto) {
		boolean registroModificado = false;
		
		if(DDTipoBloqueoApi.CARTERA.equals(codigoTipo)) {
			if(dto.getCarteraCodigo() != null && !dto.getCarteraCodigo().isEmpty()) {
				registroModificado = true;
			}
		}else if(DDTipoBloqueoApi.LINEA_NEGOCIO.equals(codigoTipo)) {
			if(dto.getLineaNegocioCodigo() != null && !dto.getLineaNegocioCodigo().isEmpty()) {
				registroModificado = true;
			}
		}else if(DDTipoBloqueoApi.ESPECIALIDAD.equals(codigoTipo)) {
			if(dto.getEspecialidadCodigo() != null && !dto.getEspecialidadCodigo().isEmpty()) {
				registroModificado = true;
			}
		}else if(DDTipoBloqueoApi.PROVINCIA.equals(codigoTipo)) {
			if(dto.getProvinciaCodigo() != null && !dto.getProvinciaCodigo().isEmpty()) {
				registroModificado = true;
			}
		}
		
		return registroModificado;
	}
	private Filter  devolverFiltro(String codigoTipo, String codigo){
		Filter filter = null;
		
		if(DDTipoBloqueoApi.CARTERA.equals(codigoTipo)) {
			filter = genericDao.createFilter(FilterType.EQUALS, "bloqueoApisCartera.codigo", codigo);
		}else if(DDTipoBloqueoApi.LINEA_NEGOCIO.equals(codigoTipo)) {
			filter = genericDao.createFilter(FilterType.EQUALS, "bloqueoApisLineaNegocio.codigo", codigo);
		}else if(DDTipoBloqueoApi.ESPECIALIDAD.equals(codigoTipo)) {
			filter = genericDao.createFilter(FilterType.EQUALS, "bloqueoApisEspecialidad.codigo", codigo);
		}else if(DDTipoBloqueoApi.PROVINCIA.equals(codigoTipo)) {
			filter = genericDao.createFilter(FilterType.EQUALS, "bloqueoApisProvincia.codigo", codigo);
		}
		
		return filter;
	}
	
	
	
	@Override
	@Transactional(readOnly = false)
	public String uploadConducta(WebFileItem fileItem) throws Exception {
				
		Adjunto adj = null;
		Long idDocRestClient = null;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		ActivoAdjuntoProveedor adjuntoProveedor = new ActivoAdjuntoProveedor();
		ConductasInapropiadas conducta = genericDao.get(ConductasInapropiadas.class, 
				genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(fileItem.getParameter("idEntidad"))));
		ActivoProveedor proveedor = proveedoresDao.get(conducta.getProveedor().getId());
		
	   	Filter filtroTipoDoc = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
	   	DDTipoDocumentoProveedor tipoDocumentoProveedor = genericDao.get(DDTipoDocumentoProveedor.class, filtroTipoDoc, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
	   	
	   	if(!Checks.esNulo(tipoDocumentoProveedor)) {
		   	if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
		   		idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoProveedor(proveedor, fileItem, usuarioLogado.getUsername(), tipoDocumentoProveedor.getMatricula());
		   	} else {
		   		adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
		   	}
		   	
		   	if (!Checks.esNulo(idDocRestClient) || !Checks.esNulo(adj)) {
					adjuntoProveedor.setTipoDocumentoProveedor(tipoDocumentoProveedor);
					adjuntoProveedor.setProveedor(proveedor);
					adjuntoProveedor.setContentType(fileItem.getFileItem().getContentType());
					adjuntoProveedor.setTamanyo(fileItem.getFileItem().getLength());
					adjuntoProveedor.setNombre(fileItem.getFileItem().getFileName());
					adjuntoProveedor.setDescripcion(fileItem.getParameter("descripcion"));			
					adjuntoProveedor.setFechaDocumento(new Date());
					adjuntoProveedor.setIdDocRestClient(idDocRestClient);
					adjuntoProveedor.setAdjunto(adj);
					genericDao.save(ActivoAdjuntoProveedor.class, adjuntoProveedor);
					
					conducta.setAdjunto(adjuntoProveedor);
					genericDao.save(ConductasInapropiadas.class, conducta);
		   	}
	   	} else {
			throw new Exception(ProveedoresManager.ERROR_TIPO_DOCUMENTO_PROVEEDOR);
		}
	   	
	   	return null;
	}
	
	@Override
	public void isProveedorValidoParaActivo(ActivoProveedor proveedor, Activo activo) throws JsonViewerException {
		
		
		BloqueoApis bloqueo = genericDao.get(BloqueoApis.class, genericDao.createFilter(FilterType.EQUALS, "proveedor.id", proveedor.getId()));
		
		if(bloqueo != null) {
			Filter bloqueoFilter = genericDao.createFilter(FilterType.EQUALS, "id", bloqueo.getId());
			Filter carteraFilter = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", activo.getCartera().getCodigo());
			List<BloqueoApisCartera> bloqueoCartera =  genericDao.getList(BloqueoApisCartera.class, bloqueoFilter,carteraFilter);
			if(bloqueoCartera != null || !bloqueoCartera.isEmpty()) {
				throw new JsonViewerException(messageServices.getMessage(ERROR_BLOQUEO_CARTERA));
			}
			
			ActivoPublicacion apu = activo.getActivoPublicacion();
			if(apu != null && apu.getTipoComercializacion() != null) {
				Filter destinoComercialFilter = genericDao.createFilter(FilterType.EQUALS, "tipoComercializacion.codigo", apu.getTipoComercializacion().getCodigo());
				List<BloqueoApisLineaNegocio> bloqueoLineaNegocio =  genericDao.getList(BloqueoApisLineaNegocio.class, bloqueoFilter,destinoComercialFilter);
				if(bloqueoLineaNegocio != null || !bloqueoLineaNegocio.isEmpty()) {
					throw new JsonViewerException(messageServices.getMessage(ERROR_BLOQUEO_TIPO_COMERCIALIZACION));
				}
			}
			
			if(activo.getProvincia() != null) {
				Filter provinciaFilter = genericDao.createFilter(FilterType.EQUALS, "tipoComercializacion.codigo", activo.getProvincia());
				List<BloqueoApisProvincia> bloqueoProvincia =  genericDao.getList(BloqueoApisProvincia.class, bloqueoFilter,provinciaFilter);
				if(bloqueoProvincia != null || !bloqueoProvincia.isEmpty()) {
					throw new JsonViewerException(messageServices.getMessage(ERROR_BLOQUEO_PROVINCIA));
				}
			}
			
			if(activo.getSubtipoActivo() != null && activo.getTipoActivo() != null) {
				Filter configTipoActivo = genericDao.createFilter(FilterType.EQUALS, "tipoActivo.codigo", activo.getTipoActivo().getCodigo());
				Filter configSubtipoActivo = genericDao.createFilter(FilterType.EQUALS, "subtipoActivo.codigo", activo.getSubtipoActivo().getCodigo());	
				List<ConfigEspecialidad>  configEspecialidadList = genericDao.getList(ConfigEspecialidad.class, configTipoActivo, configSubtipoActivo);
				
				if(configEspecialidadList != null && !configEspecialidadList.isEmpty()) {
					List<String> listEspecialidad = new ArrayList<String>();
					for (ConfigEspecialidad configEspecialidad : configEspecialidadList) {
						listEspecialidad.add(configEspecialidad.getEspecialidad().getCodigo());
					}
					Filter configEspecialidadFilter = genericDao.createFilter(FilterType.SIMILARY, "especialidad.codigo", listEspecialidad);
					List<BloqueoApisEspecialidad> bloqueoApisEspecialidad =  genericDao.getList(BloqueoApisEspecialidad.class, bloqueoFilter,configEspecialidadFilter);
					if(bloqueoApisEspecialidad != null || !bloqueoApisEspecialidad.isEmpty()) {
						throw new JsonViewerException(messageServices.getMessage(ERROR_BLOQUEO_ESPECIALIDAD));
					}
				}
			}
		}
	}
		

	@Override
	public Object getDatosContactoById(Long id) {
		
		DtoDatosContacto dto = new DtoDatosContacto();
		
		Filter idFilter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		
		Filter idFilterMultiple = genericDao.createFilter(FilterType.EQUALS, "direccion.id", id);
		
		ActivoProveedorDireccion delegacion = genericDao.get(ActivoProveedorDireccion.class, idFilter);
		
		try {
			if(delegacion.getLineaNegocio() != null) {
				DDTipoComercializacion tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, delegacion.getLineaNegocio().getCodigo());
				beanUtilNotNull.copyProperty(dto, "tipoLineaDeNegocioDescripcion", tipoComercializacion.getDescripcion());
				beanUtilNotNull.copyProperty(dto, "tipoLineaDeNegocioCodigo", tipoComercializacion.getCodigo());
			}
			
			if(delegacion.getGestionClientes() != null) {
				DDSinSiNo gestionClientes = (DDSinSiNo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, delegacion.getGestionClientes().getCodigo());
				beanUtilNotNull.copyProperty(dto, "gestionClientesDescripcion", gestionClientes.getDescripcion());
				beanUtilNotNull.copyProperty(dto, "gestionClientesCodigo", gestionClientes.getCodigo());
			}
			
			if(delegacion.getNumeroComerciales() != null) {
				beanUtilNotNull.copyProperty(dto, "numeroComerciales", delegacion.getNumeroComerciales());
			}
			
			List<ProveedorEspecialidad> proveedorEspecialidad = genericDao.getList(ProveedorEspecialidad.class, idFilterMultiple);
			if(!Checks.estaVacio(proveedorEspecialidad)) {
				StringBuffer codigos = new StringBuffer();
				for(ProveedorEspecialidad pe : proveedorEspecialidad) {
					if(!Checks.esNulo(pe.getEspecialidad())) {
						codigos.append(pe.getEspecialidad().getCodigo()).append(",");
					}
				}
				beanUtilNotNull.copyProperty(dto, "especialidadCodigo", codigos.substring(0, (codigos.length()-1)));
			}
			
			List<ProveedorIdioma> proveedorIdioma = genericDao.getList(ProveedorIdioma.class, idFilterMultiple);
			if(!Checks.estaVacio(proveedorIdioma)) {
				StringBuffer codigos = new StringBuffer();
				for(ProveedorIdioma pi : proveedorIdioma) {
					if(!Checks.esNulo(pi.getIdioma())) {
						codigos.append(pi.getIdioma().getCodigo()).append(",");
					}
				}
				beanUtilNotNull.copyProperty(dto, "idiomaCodigo", codigos.substring(0, (codigos.length()-1)));
			}
			
			List<DelegacionesLocalidad> delegacionMunicipio = genericDao.getList(DelegacionesLocalidad.class, idFilterMultiple);
			if(!Checks.estaVacio(delegacionMunicipio)) {
				StringBuffer codigos = new StringBuffer();
				for(DelegacionesLocalidad pi : delegacionMunicipio) {
					if(!Checks.esNulo(pi.getLocalidad())) {
						codigos.append(pi.getLocalidad().getCodigo()).append(",");
					}
				}
				beanUtilNotNull.copyProperty(dto, "municipioCodigo", codigos.substring(0, (codigos.length()-1)));
			}
			
			List<DelegacionesProvincia> delegacionProvincia = genericDao.getList(DelegacionesProvincia.class, idFilterMultiple);
			if(!Checks.estaVacio(delegacionProvincia)) {
				StringBuffer codigos = new StringBuffer();
				for(DelegacionesProvincia dp : delegacionProvincia) {
					if(!Checks.esNulo(dp.getProvincia())) {
						codigos.append(dp.getProvincia().getCodigo()).append(",");
					}
				}
				beanUtilNotNull.copyProperty(dto, "provinciaCodigo", codigos.substring(0, (codigos.length()-1)));
			}
			
			List<DelegacionesCodigoPostal> delegacionCodigoPostal = genericDao.getList(DelegacionesCodigoPostal.class, idFilterMultiple);
			if(!Checks.estaVacio(delegacionCodigoPostal)) {
				StringBuffer codigos = new StringBuffer();
				for(DelegacionesCodigoPostal cp : delegacionCodigoPostal) {
					if(!Checks.esNulo(cp.getCodigoPostal())) {
						codigos.append(cp.getCodigoPostal().getCodigo()).append(",");
					}
				}
				beanUtilNotNull.copyProperty(dto, "codigoPostalCodigo", codigos.substring(0, (codigos.length()-1)));
			}
			
		}catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveDatosContactoById(DtoDatosContacto dto) {
		
		Filter idFilter = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dto.getId()));
				
		ActivoProveedorDireccion delegacion = genericDao.get(ActivoProveedorDireccion.class, idFilter);

		if(dto.getTipoLineaDeNegocioCodigo() != null) {
			DDTipoComercializacion tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, dto.getTipoLineaDeNegocioCodigo());
			delegacion.setLineaNegocio(tipoComercializacion);
		}
		
		if(dto.getGestionClientesCodigo() != null) {
			DDSinSiNo gestionClientes = (DDSinSiNo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSinSiNo.class, dto.getGestionClientesCodigo());
			delegacion.setGestionClientes(gestionClientes);
		}
		
		if(dto.getNumeroComerciales() != null) {
			delegacion.setNumeroComerciales(dto.getNumeroComerciales());
		}
		
		if(!Checks.esNulo(dto.getEspecialidadCodigo())) {
			if(dto.getEspecialidadCodigo().equals("VALOR_POR_DEFECTO")) {					
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				genericDao.delete(ProveedorEspecialidad.class, filtroDelegacion);
			} else {
				List<String> codigosEspecialidad = Arrays.asList(dto.getEspecialidadCodigo().split(","));
				
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				List<ProveedorEspecialidad> proveedorEspecialidadByProvID = genericDao.getList(ProveedorEspecialidad.class, filtroDelegacion);
				
				// Borrar los elementos que no vengan en la lista y existan en la DDBB.
				for(ProveedorEspecialidad pe : proveedorEspecialidadByProvID){
					if(!codigosEspecialidad.contains(pe.getEspecialidad().getCodigo())){
						Filter filtroEspecialidad = genericDao.createFilter(FilterType.EQUALS, "especialidad.codigo", pe.getEspecialidad().getCodigo());
						ProveedorEspecialidad especialidadABorrar = genericDao.get(ProveedorEspecialidad.class, filtroEspecialidad, filtroDelegacion);
						if(!Checks.esNulo(especialidadABorrar)) {
							genericDao.deleteById(ProveedorEspecialidad.class, especialidadABorrar.getId());
						}
					}
				}
				
				// Almacenar los elementos que vengan en la lista y no existan en la DDBB.
				// Dejar los elementos que vangan en la lista y exista en la DDBB.
				for(String codigo : codigosEspecialidad) {
					DDEspecialidad especialidad = (DDEspecialidad) utilDiccionarioApi.dameValorDiccionarioByCod(DDEspecialidad.class, codigo);
					if(!Checks.esNulo(especialidad)) {
						Filter filtroEspecialidad = genericDao.createFilter(FilterType.EQUALS, "especialidad.codigo", especialidad.getCodigo());
						List<ProveedorEspecialidad> proveedorEspecialidad = genericDao.getList(ProveedorEspecialidad.class, filtroDelegacion, filtroEspecialidad);
						if(Checks.estaVacio(proveedorEspecialidad)) {
							ProveedorEspecialidad pveEspecialidad = new ProveedorEspecialidad();
							pveEspecialidad.setEspecialidad(especialidad);
							pveEspecialidad.setDireccion(delegacion);
							pveEspecialidad.setProveedor(delegacion.getProveedor());
							genericDao.save(ProveedorEspecialidad.class, pveEspecialidad);
						}
					}
				}
			}
			
		}
		
		if(!Checks.esNulo(dto.getIdiomaCodigo())) {
			if(dto.getIdiomaCodigo().equals("VALOR_POR_DEFECTO")) {					
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				genericDao.delete(ProveedorIdioma.class, filtroDelegacion);
			} else {
				List<String> codigosIdioma = Arrays.asList(dto.getIdiomaCodigo().split(","));
				
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				List<ProveedorIdioma> proveedorIdiomaByProvID = genericDao.getList(ProveedorIdioma.class, filtroDelegacion);
				
				// Borrar los elementos que no vengan en la lista y existan en la DDBB.
				for(ProveedorIdioma pi : proveedorIdiomaByProvID){
					if(!codigosIdioma.contains(pi.getIdioma().getCodigo())){
						Filter filtroIdioma = genericDao.createFilter(FilterType.EQUALS, "idioma.codigo", pi.getIdioma().getCodigo());
						ProveedorIdioma idiomaABorrar = genericDao.get(ProveedorIdioma.class, filtroIdioma, filtroDelegacion);
						if(!Checks.esNulo(idiomaABorrar)) {
							genericDao.deleteById(ProveedorIdioma.class, idiomaABorrar.getId());
						}
					}
				}
				
				// Almacenar los elementos que vengan en la lista y no existan en la DDBB.
				// Dejar los elementos que vangan en la lista y exista en la DDBB.
				for(String codigo : codigosIdioma) {
					DDIdioma idioma = (DDIdioma) utilDiccionarioApi.dameValorDiccionarioByCod(DDIdioma.class, codigo);
					if(!Checks.esNulo(idioma)) {
						Filter filtroIdioma = genericDao.createFilter(FilterType.EQUALS, "idioma.codigo", idioma.getCodigo());
						List<ProveedorIdioma> proveedorIdioma = genericDao.getList(ProveedorIdioma.class, filtroDelegacion, filtroIdioma);
						if(Checks.estaVacio(proveedorIdioma)) {
							ProveedorIdioma pveIdioma = new ProveedorIdioma();
							pveIdioma.setIdioma(idioma);
							pveIdioma.setDireccion(delegacion);
							pveIdioma.setProveedor(delegacion.getProveedor());
							genericDao.save(ProveedorIdioma.class, pveIdioma);
						}
					}
				}
			}
			
		}
		
		if(!Checks.esNulo(dto.getProvinciaCodigo())) {
			if(dto.getProvinciaCodigo().equals("VALOR_POR_DEFECTO")) {					
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				genericDao.delete(DelegacionesProvincia.class, filtroDelegacion);
			} else {
				List<String> codigosProvincia = Arrays.asList(dto.getProvinciaCodigo().split(","));
				
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				List<DelegacionesProvincia> delegacionProvinciaByProvID = genericDao.getList(DelegacionesProvincia.class, filtroDelegacion);
				
				// Borrar los elementos que no vengan en la lista y existan en la DDBB.
				for(DelegacionesProvincia dp : delegacionProvinciaByProvID){
					if(!codigosProvincia.contains(dp.getProvincia().getCodigo())){
						Filter filtroProvincia = genericDao.createFilter(FilterType.EQUALS, "provincia.codigo", dp.getProvincia().getCodigo());
						DelegacionesProvincia provinciaABorrar = genericDao.get(DelegacionesProvincia.class, filtroProvincia, filtroDelegacion);
						if(!Checks.esNulo(provinciaABorrar)) {
							genericDao.deleteById(DelegacionesProvincia.class, provinciaABorrar.getId());
						}
					}
				}
				
				// Almacenar los elementos que vengan en la lista y no existan en la DDBB.
				// Dejar los elementos que vangan en la lista y exista en la DDBB.
				for(String codigo : codigosProvincia) {
					DDProvincia provincia = (DDProvincia) utilDiccionarioApi.dameValorDiccionarioByCod(DDProvincia.class, codigo);
					if(!Checks.esNulo(provincia)) {
						Filter filtroProvincia = genericDao.createFilter(FilterType.EQUALS, "provincia.codigo", provincia.getCodigo());
						List<DelegacionesProvincia> delegacionProvincia = genericDao.getList(DelegacionesProvincia.class, filtroDelegacion, filtroProvincia);
						if(Checks.estaVacio(delegacionProvincia)) {
							DelegacionesProvincia dlgProvincia = new DelegacionesProvincia();
							dlgProvincia.setProvincia(provincia);
							dlgProvincia.setDireccion(delegacion);
							genericDao.save(DelegacionesProvincia.class, dlgProvincia);
						}
					}
				}
			}
			
		}
		
		if(!Checks.esNulo(dto.getMunicipioCodigo())) {
			if(dto.getMunicipioCodigo().equals("VALOR_POR_DEFECTO")) {					
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				genericDao.delete(DelegacionesLocalidad.class, filtroDelegacion);
			} else {
				List<String> codigosMuncicipio = Arrays.asList(dto.getMunicipioCodigo().split(","));
				
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				List<DelegacionesLocalidad> delegacionMunicipioByProvID = genericDao.getList(DelegacionesLocalidad.class, filtroDelegacion);
				
				// Borrar los elementos que no vengan en la lista y existan en la DDBB.
				for(DelegacionesLocalidad dl : delegacionMunicipioByProvID){
					if(!codigosMuncicipio.contains(dl.getLocalidad().getCodigo())){
						Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "localidad.codigo", dl.getLocalidad().getCodigo());
						DelegacionesLocalidad localidadABorrar = genericDao.get(DelegacionesLocalidad.class, filtroLocalidad, filtroDelegacion);
						if(!Checks.esNulo(localidadABorrar)) {
							genericDao.deleteById(DelegacionesLocalidad.class, localidadABorrar.getId());
						}
					}
				}
				
				// Almacenar los elementos que vengan en la lista y no existan en la DDBB.
				// Dejar los elementos que vangan en la lista y exista en la DDBB.
				for(String codigo : codigosMuncicipio) {
					Filter filtroMunicipio = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
					Localidad municipio = genericDao.get(Localidad.class, filtroMunicipio);
					if(!Checks.esNulo(municipio)) {
						Filter filtroLocalidad = genericDao.createFilter(FilterType.EQUALS, "localidad.codigo", municipio.getCodigo());
						List<DelegacionesLocalidad> delegacionLocalidad = genericDao.getList(DelegacionesLocalidad.class, filtroDelegacion, filtroLocalidad);
						if(Checks.estaVacio(delegacionLocalidad)) {
							DelegacionesLocalidad dlgLocalidad = new DelegacionesLocalidad();
							dlgLocalidad.setLocalidad(municipio);
							dlgLocalidad.setDireccion(delegacion);
							genericDao.save(DelegacionesLocalidad.class, dlgLocalidad);
						}
					}
				}
			}
			
		}
		
		if(!Checks.esNulo(dto.getCodigoPostalCodigo())) {
			if(dto.getCodigoPostalCodigo().equals("VALOR_POR_DEFECTO")) {					
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				genericDao.delete(DelegacionesCodigoPostal.class, filtroDelegacion);
			} else {
				List<String> codigosCodigoPostal = Arrays.asList(dto.getCodigoPostalCodigo().split(","));
				
				Filter filtroDelegacion = genericDao.createFilter(FilterType.EQUALS, "direccion.id", delegacion.getId());
				List<DelegacionesCodigoPostal> delegacionCodigoPostalByProvID = genericDao.getList(DelegacionesCodigoPostal.class, filtroDelegacion);
				
				// Borrar los elementos que no vengan en la lista y existan en la DDBB.
				for(DelegacionesCodigoPostal dcp : delegacionCodigoPostalByProvID){
					if(!codigosCodigoPostal.contains(dcp.getCodigoPostal().getCodigo())){
						Filter filtroCodigoPostal = genericDao.createFilter(FilterType.EQUALS, "codigoPostal.codigo", dcp.getCodigoPostal().getCodigo());
						DelegacionesCodigoPostal codigoPostalABorrar = genericDao.get(DelegacionesCodigoPostal.class, filtroCodigoPostal, filtroDelegacion);
						if(!Checks.esNulo(codigoPostalABorrar)) {
							genericDao.deleteById(DelegacionesCodigoPostal.class, codigoPostalABorrar.getId());
						}
					}
				}
				
				// Almacenar los elementos que vengan en la lista y no existan en la DDBB.
				// Dejar los elementos que vangan en la lista y exista en la DDBB.
				for(String codigo : codigosCodigoPostal) {
					Filter filtroCP = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
					DDCodigoPostal codigoPostal = genericDao.get(DDCodigoPostal.class, filtroCP);
					if(!Checks.esNulo(codigoPostal)) {
						Filter filtroCodigoPostal = genericDao.createFilter(FilterType.EQUALS, "codigoPostal.codigo", codigoPostal.getCodigo());
						List<DelegacionesCodigoPostal> delegacionCodigoPostal = genericDao.getList(DelegacionesCodigoPostal.class, filtroDelegacion, filtroCodigoPostal);
						if(Checks.estaVacio(delegacionCodigoPostal)) {
							DelegacionesCodigoPostal dlgCodigoPostal = new DelegacionesCodigoPostal();
							dlgCodigoPostal.setCodigoPostal(codigoPostal);
							dlgCodigoPostal.setDireccion(delegacion);
							genericDao.save(DelegacionesCodigoPostal.class, dlgCodigoPostal);
						}
					}
				}
			}
			
		}

		genericDao.save(ActivoProveedorDireccion.class, delegacion);

		return true;
	}
	
	@Override
	public List<Localidad> getComboMunicipioMultiple(String codigoProvincia) {
		
		List<Localidad> municipiosADevolver = new ArrayList<Localidad>();
		
		List<Localidad> municipiosBusqueda = new ArrayList<Localidad>();
		
		if(!"VALOR_POR_DEFECTO".equals(codigoProvincia) && codigoProvincia != null) {
		
			String[] codigoProvinciaSplit = codigoProvincia.split(",");
			
			ArrayList<String> list = new ArrayList<String>(Arrays.asList(codigoProvinciaSplit));
		
			for(String provincia : list) {
				
				municipiosBusqueda = proveedoresDao.getMunicipiosList(provincia);
				
				municipiosADevolver.addAll(municipiosBusqueda);
			}
		}
		
		return municipiosADevolver;
	}
	
	@Override
	public List<DtoCodigoPostalCombo> getComboCodigoPostalMultiple(String codigoMunicipio) {
				
		List<DDCodigoPostal> codigosPostalesBusqueda = new ArrayList<DDCodigoPostal>();
		
		DtoCodigoPostalCombo codigosPostalesIndividuales = new DtoCodigoPostalCombo();
		
		List<DtoCodigoPostalCombo> codigosPostalesADevolver = new ArrayList<DtoCodigoPostalCombo>();
		
		if(!"VALOR_POR_DEFECTO".equals(codigoMunicipio) && codigoMunicipio != null) {
		
			String[] codigoMunicipioSplit = codigoMunicipio.split(",");
			
			ArrayList<String> list = new ArrayList<String>(Arrays.asList(codigoMunicipioSplit));
		
			for(String municipio : list) {
				
				codigosPostalesBusqueda = proveedoresDao.getCodigosPostalesList(municipio);
				
				for(DDCodigoPostal codigosPostalesFinal : codigosPostalesBusqueda) {
					
					codigosPostalesIndividuales.setId(codigosPostalesFinal.getId());
					codigosPostalesIndividuales.setCodigo(codigosPostalesFinal.getCodigo());
					codigosPostalesIndividuales.setDescripcion(codigosPostalesFinal.getCodigo());

					codigosPostalesADevolver.add(codigosPostalesIndividuales);
				}
				
			}
		}
		
		return codigosPostalesADevolver;
	}
}
