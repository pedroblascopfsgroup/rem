package es.pfsgroup.plugin.rem.gastoProveedor;

import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
//import es.capgemini.devon.utils.PropertyUtils;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GastoLineaDetalleApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.gasto.linea.detalle.GastoLineaDetalleManager;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoGenerico;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoSareb;
import es.pfsgroup.plugin.rem.model.ActivoSubtipoGastoProveedorTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;
import es.pfsgroup.plugin.rem.model.ConfiguracionSubpartidasPresupuestarias;
import es.pfsgroup.plugin.rem.model.ConfiguracionSuplidos;
import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionGasto;
import es.pfsgroup.plugin.rem.model.DtoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.DtoVImporteGastoLbk;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.ErrorDiariosLbk;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoImpugnacion;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleTrabajo;
import es.pfsgroup.plugin.rem.model.GastoPrinex;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.GastoSuplido;
import es.pfsgroup.plugin.rem.model.GastosDiariosLBK;
import es.pfsgroup.plugin.rem.model.GastosImportesLBK;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ProvisionGastos;
import es.pfsgroup.plugin.rem.model.SubTipoGpvTrabajo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;
import es.pfsgroup.plugin.rem.model.VDiarioCalculoLbk;
import es.pfsgroup.plugin.rem.model.VFacturasProveedores;
import es.pfsgroup.plugin.rem.model.VGastosProveedor;
import es.pfsgroup.plugin.rem.model.VGastosRefacturados;
import es.pfsgroup.plugin.rem.model.VImporteBrutoGastoLBK;
import es.pfsgroup.plugin.rem.model.VTasasImpuestos;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioPago;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProvisionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAutorizacionPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencionPago;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComisionado;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOperacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPagador;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.provisiongastos.dao.ProvisionGastosDao;
import es.pfsgroup.plugin.rem.thread.ActualizaSuplidosAsync;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateGastoApi;

@Service("gastoProveedorManager")
public class GastoProveedorManager implements GastoProveedorApi {

	private final Log logger = LogFactory.getLog(getClass());

	private static final String PESTANA_FICHA = "ficha";
	private static final String PESTANA_DETALLE_ECONOMICO = "detalleEconomico";
	private static final String PESTANA_CONTABILIDAD = "contabilidad";
	private static final String PESTANA_GESTION = "gestion";
	private static final String PESTANA_IMPUGNACION = "impugnacion";

	private static final String COD_PEF_GESTORIA_ADMINISTRACION = "HAYAGESTADMT";
	private static final String COD_PEF_GESTORIA_PLUSVALIA = "GESTOPLUS";
	private static final String COD_PEF_GESTORIA_POSTVENTA = "GTOPOSTV";
	private static final String COD_PEF_USUARIO_CERTIFICADOR = "HAYACERTI";
	private static final String RESULTADO_OK = "OK";
	private static final String MENSAJE_OK = "Diarios actualizados correctamente";
	private static final String COD_HONORARIOS_GESTION_ACTIVOS = DDSubtipoGasto.COD_HONORARIOS_GESTION_ACTIVOS;
	private static final String COD_REGISTRO = DDSubtipoGasto.COD_REGISTRO;
	private static final String COD_NOTARIA = DDSubtipoGasto.COD_NOTARIA;
	private static final String COD_ABOGADO = DDSubtipoGasto.COD_ABOGADO;
	private static final String COD_PROCURADOR = DDSubtipoGasto.COD_PROCURADOR;
	private static final String COD_OTROS_SERVICIOS_JURIDICOS = DDSubtipoGasto.COD_OTROS_SERVICIOS_JURIDICOS;
	private static final String COD_ADMINISTRADOR_COMUNIDAD_PROPIETARIOS = DDSubtipoGasto.COD_ADMINISTRADOR_COMUNIDAD_PROPIETARIOS;
	private static final String COD_ASESORIA = DDSubtipoGasto.COD_ASESORIA;
	private static final String COD_TECNICO = DDSubtipoGasto.COD_TECNICO;
	private static final String COD_TASACION = DDSubtipoGasto.COD_TASACION;
	private static final String COD_OTROS = DDSubtipoGasto.COD_OTROS;
	private static final String COD_GESTION_DE_SUELO = DDSubtipoGasto.COD_GESTION_DE_SUELO;
	private static final String COD_ABOGADO_OCUPACIONAL = DDSubtipoGasto.COD_ABOGADO_OCUPACIONAL;
	private static final String COD_ABOGADO_ASUNTOS_GENERALES = DDSubtipoGasto.COD_ABOGADO_ASUNTOS_GENERALES;
	private static final String COD_ABOGADO_ASISTENCIA_JURIDiCA = DDSubtipoGasto.COD_ABOGADO_ASISTENCIA_JURIDiCA;
	

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ProveedoresApi proveedores;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private GastoDao gastoDao;

	@Autowired
	private UpdaterStateGastoApi updaterStateApi;

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	
	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Autowired
	private GestorActivoDao gestorActivoDao;

	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Resource
	private MessageService messageServices;
	
	@Autowired
	private ProvisionGastosDao provisionGastosDao;
	
	@Autowired
	private UsuarioApi usuarioApi;

	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Autowired
	private GastoLineaDetalleApi gastoLineaDetalleApi;
	
	@Autowired
	private GastoLineaDetalleManager gastoLineaDetalleManager;
	
	@Autowired
	private ActivoDao activoDao;

	@Override
	public GastoProveedor findOne(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		
		return genericDao.get(GastoProveedor.class, filtro );
	}
	
	@Override
	public Long getIdGasto(Long numGasto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", numGasto);
		
		return genericDao.get(GastoProveedor.class, filtro ).getId();
	}

	@Override
	public Object getTabGasto(Long id, String tab) throws Exception {

		GastoProveedor gasto = findOne(id);

		WebDto dto = null;

		try {

			if (PESTANA_FICHA.equals(tab)) {
				dto = gastoToDtoFichaGasto(gasto);
			}
			if (PESTANA_DETALLE_ECONOMICO.equals(tab)) {
				dto = detalleEconomicoToDtoDetalleEconomico(gasto);
			}
			if (PESTANA_CONTABILIDAD.equals(tab)) {
				dto = infoContabilidadToDtoInfoContabilidad(gasto);
			}
			if (PESTANA_GESTION.equals(tab)) {
				dto = gestionToDtoGestion(gasto);
			}
			if (PESTANA_IMPUGNACION.equals(tab)) {
				dto = impugnaciontoDtoImpugnacion(gasto);
			}

		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			throw new Exception(e.getMessage());
		}

		return dto;
	}

	@Override
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		// Comprobar si el usuario es externo y de tipo proveedor y, en tal caso, seteamos proveedores contacto del
		// usuario logado para filtrar los gastos en los que esté como emisor
		// Ademas si es un tipo de gestoria concreto, se filtrará los gastos que le pertenezcan como gestoria.
		if (gestorActivoDao.isUsuarioGestorExternoProveedor(usuarioLogado.getId())) {
			Boolean isGestoria = genericAdapter.tienePerfil(COD_PEF_GESTORIA_ADMINISTRACION, usuarioLogado) 
					|| genericAdapter.tienePerfil(COD_PEF_GESTORIA_PLUSVALIA, usuarioLogado) || genericAdapter.tienePerfil(COD_PEF_GESTORIA_POSTVENTA, usuarioLogado)
					|| genericAdapter.tienePerfil(COD_PEF_USUARIO_CERTIFICADOR, usuarioLogado);
			return gastoDao.getListGastosFilteredByProveedorContactoAndGestoria(dtoGastosFilter, usuarioLogado.getId(), isGestoria, false);
		}

		return gastoDao.getListGastos(dtoGastosFilter, usuarioLogado.getId());
	}
	
	@Override
	public DtoPage getListGastosExcel(DtoGastosFilter dtoGastosFilter) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		// Comprobar si el usuario es externo y de tipo proveedor y, en tal caso, seteamos proveedores contacto del
		// usuario logado para filtrar los gastos en los que esté como emisor
		// Ademas si es un tipo de gestoria concreto, se filtrará los gastos que le pertenezcan como gestoria.
		if (gestorActivoDao.isUsuarioGestorExternoProveedor(usuarioLogado.getId())) {
			Boolean isGestoria = genericAdapter.tienePerfil(COD_PEF_GESTORIA_ADMINISTRACION, usuarioLogado) 
					|| genericAdapter.tienePerfil(COD_PEF_GESTORIA_PLUSVALIA, usuarioLogado) || genericAdapter.tienePerfil(COD_PEF_GESTORIA_POSTVENTA, usuarioLogado)
					|| genericAdapter.tienePerfil(COD_PEF_USUARIO_CERTIFICADOR, usuarioLogado);
			return gastoDao.getListGastosFilteredByProveedorContactoAndGestoria(dtoGastosFilter, usuarioLogado.getId(), isGestoria, true);
		}

		return gastoDao.getListGastosExcel(dtoGastosFilter, usuarioLogado.getId());
	}

	@SuppressWarnings("unused")
	private DtoFichaGastoProveedor gastoToDtoFichaGasto(GastoProveedor gasto) {

		DtoFichaGastoProveedor dto = new DtoFichaGastoProveedor();
		String[] subtiposGasto = new String[]{COD_HONORARIOS_GESTION_ACTIVOS,COD_REGISTRO,COD_NOTARIA,COD_ABOGADO,COD_PROCURADOR,COD_OTROS_SERVICIOS_JURIDICOS,COD_ADMINISTRADOR_COMUNIDAD_PROPIETARIOS,COD_ASESORIA,COD_TECNICO,COD_TASACION,COD_OTROS,COD_GESTION_DE_SUELO,COD_ABOGADO_OCUPACIONAL,COD_ABOGADO_ASUNTOS_GENERALES,COD_ABOGADO_ASISTENCIA_JURIDiCA};
		List<String> codigosSubtipoGasto = new ArrayList<String>(Arrays.asList(subtiposGasto));
		Boolean filtroGastosB = false;
		if (!Checks.esNulo(gasto)) {

			dto.setVisibleSuplidos(false);
			dto.setIdGasto(gasto.getId());
			dto.setNumGastoHaya(gasto.getNumGastoHaya());
			dto.setNumGastoGestoria(gasto.getNumGastoGestoria());
			dto.setReferenciaEmisor(gasto.getReferenciaEmisor());
			
		 if(gasto.getCartera() != null){
				dto.setCartera(gasto.getCartera().getCodigo());
			}else{
				dto.setCartera(null);
			}

			if (!Checks.esNulo(gasto.getTipoGasto())) {
				dto.setTipoGastoCodigo(gasto.getTipoGasto().getCodigo());
				dto.setTipoGastoDescripcion(gasto.getTipoGasto().getDescripcion());
			}
	
			dto.setVisibleSuplidos(true);
			if(gasto.getGastoLineaDetalleList() != null && !gasto.getGastoLineaDetalleList().isEmpty()){
				for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id",gastoLinea.getId());
					Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "entidadGasto.codigo",DDEntidadGasto.CODIGO_ACTIVO);
					List <GastoLineaDetalleEntidad> gastoLineaEntidadList= genericDao.getList(GastoLineaDetalleEntidad.class,filter,filterAct);
					if(gastoLineaEntidadList==null || gastoLineaEntidadList.isEmpty()) {
						dto.setVisibleSuplidos(false);
						break;
					}else {
						for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLineaEntidadList) {
							Activo activo = activoDao.getActivoById(gastoLineaDetalleEntidad.getEntidad());
							if(activo == null || gasto.getCartera()==null || activo.getSubcartera()==null || gasto.getTipoGasto()==null) {
								dto.setVisibleSuplidos(false);
								break;
							}
							ConfiguracionSuplidos config = genericDao.get(ConfiguracionSuplidos.class,
									genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", gasto.getCartera().getCodigo()),
									genericDao.createFilter(FilterType.EQUALS, "subCartera.codigo", activo.getSubcartera().getCodigo()),
									genericDao.createFilter(FilterType.EQUALS, "tipoGasto.codigo", gasto.getTipoGasto().getCodigo()),
									genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.codigo",gastoLinea.getSubtipoGasto().getCodigo()));
							if(config==null) {
								dto.setVisibleSuplidos(false);
								break;
							}
						}
					}			
				}
			}else {
				dto.setVisibleSuplidos(false);
			}

				
			if (!Checks.esNulo(gasto.getEstadoGasto())) {
				dto.setEstadoGastoCodigo(gasto.getEstadoGasto().getCodigo());
				dto.setEstadoGastoDescripcion(gasto.getEstadoGasto().getDescripcion());
			}

			if (!Checks.esNulo(gasto.getProveedor())) {
				dto.setNifEmisor(gasto.getProveedor().getDocIdentificativo());
				dto.setBuscadorNifEmisor(gasto.getProveedor().getDocIdentificativo());
				dto.setNombreEmisor(gasto.getProveedor().getNombre());
				dto.setIdEmisor(gasto.getProveedor().getId());
				dto.setCodigoEmisor(gasto.getProveedor().getCodProveedorUvem());
				dto.setBuscadorCodigoProveedorRem(gasto.getProveedor().getCodigoProveedorRem());
				dto.setCodigoProveedorRem(gasto.getProveedor().getCodigoProveedorRem());
				dto.setEstadoEmisor(Checks.esNulo(gasto.getProveedor().getEstadoProveedor()) ? null : gasto.getProveedor().getEstadoProveedor().getDescripcion());
			}

			if (!Checks.esNulo(gasto.getPropietario())) {
				dto.setNifPropietario(gasto.getPropietario().getDocIdentificativo());
				dto.setBuscadorNifPropietario(gasto.getPropietario().getDocIdentificativo());
				dto.setNombrePropietario(gasto.getPropietario().getNombre());
			}

			if (!Checks.esNulo(gasto.getDestinatarioGasto())) {
				dto.setDestinatario(gasto.getDestinatarioGasto().getCodigo());
			}

			if (!Checks.esNulo(gasto.getIdentificadorUnico())) {
				dto.setIdentificadorUnico(gasto.getIdentificadorUnico());
			}
			
			dto.setFechaEmision(gasto.getFechaEmision());

			if (!Checks.esNulo(gasto.getTipoPeriocidad())) {
				dto.setPeriodicidad(gasto.getTipoPeriocidad().getCodigo());
			}
			dto.setConcepto(gasto.getConcepto());
			if (!Checks.esNulo(gasto.getGastoGestion()) && !Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya())) {
				dto.setAutorizado(DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo()));
			}
			if (!Checks.esNulo(gasto.getGastoGestion()) && !Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya())) {
				dto.setRechazado(DDEstadoAutorizacionHaya.CODIGO_RECHAZADO.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo()));
			}
			dto.setAsignadoATrabajos(false);
			if(gasto.getGastoLineaDetalleList() != null && !gasto.getGastoLineaDetalleList().isEmpty()){
				for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
					if(gastoLinea.getGastoLineaTrabajoList() != null && !gastoLinea.getGastoLineaTrabajoList().isEmpty()) {
						dto.setAsignadoATrabajos(true);
						break;
					}
				}
			}
			dto.setAsignadoAActivos(Boolean.FALSE);

			if(!Checks.estaVacio(gasto.getGastoLineaDetalleList())){
				for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
					if (!Checks.esNulo(gastoLinea.getGastoLineaEntidadList())){
						for(GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLinea.getGastoLineaEntidadList()) {
							dto.setAsignadoAActivos(Boolean.TRUE);
							break;
						}
					}
				}
			}
			
			dto.setEsGastoEditable(esGastoEditable(gasto));
			dto.setEsGastoAgrupado(!Checks.esNulo(gasto.getProvision()));

			dto.setNumGastoDestinatario(gasto.getNumGastoDestinatario());

			if (!Checks.esNulo(gasto.getTipoOperacion())) {
				dto.setTipoOperacionCodigo(gasto.getTipoOperacion().getCodigo());
				dto.setTipoOperacionDescripcion(gasto.getTipoOperacion().getDescripcion());
			}
			if (!Checks.esNulo(gasto.getGastoProveedorAbonado())) {
				dto.setNumGastoAbonado(gasto.getGastoProveedorAbonado().getNumGastoHaya());
			}

			if (!Checks.esNulo(gasto.getGastoGestion())
					&& (!Checks.esNulo(gasto.getGastoGestion().getFechaEnvioGestoria()) || !Checks.esNulo(gasto.getGastoGestion().getFechaEnvioPropietario()))) {
				dto.setEnviado(true);
			} else {
				dto.setEnviado(false);
			}

			
			/*Double gastoTotal = 0.0;
			List<GastoPrinex> listGastoPrinex = new ArrayList<GastoPrinex>();
			Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "idGasto",gasto.getId());
			listGastoPrinex = genericDao.getList(GastoPrinex.class, filtro3);
					
			if(!Checks.estaVacio(listGastoPrinex)) {
						for (GastoPrinex gastoPrinexList : listGastoPrinex) {
				
				if(!Checks.esNulo(gastoPrinexList.getIdActivo())  && !Checks.esNulo(gastoPrinexList.getImporteGasto())) {
					gastoTotal+=gastoPrinexList.getImporteGasto();
				}
						}
			}

			if (!Checks.esNulo(gasto.getGastoDetalleEconomico())) {
				if(!Checks.esNulo(gasto.getGastoDetalleEconomico().getImporteTotal())){
					dto.setImporteTotal(gasto.getGastoDetalleEconomico().getImporteTotal());
				}else{
					dto.setImporteTotal(gastoTotal);
				}
			}*/
			
			if(gasto.getGastoDetalleEconomico() != null) {
				dto.setImporteTotal(gasto.getGastoDetalleEconomico().getImporteTotal());
			}

			if (!Checks.esNulo(gasto.getGestoria())) {
				dto.setNombreGestoria(gasto.getGestoria().getNombre());
			}
						
			if(!Checks.esNulo(gasto.getNumeroPrimerGastoSerie())) {
				Filter filtroNumGs = genericDao.createFilter(FilterType.EQUALS, "id",gasto.getNumeroPrimerGastoSerie());
				GastoProveedor gsPrim = genericDao.get(GastoProveedor.class, filtroNumGs);
				dto.setNumeroPrimerGastoSerie(gsPrim.getNumGastoHaya());
			}
				
			if (!Checks.esNulo(gasto.getFechaRecPropiedad())) { 
				dto.setFechaRecPropiedad(gasto.getFechaRecPropiedad());	
			}
			
			if (!Checks.esNulo(gasto.getFechaRecGestoria())) { 
				dto.setFechaRecGestoria(gasto.getFechaRecGestoria()); 
			}			
			
			if (!Checks.esNulo(gasto.getFechaRecHaya())) { 
				dto.setFechaRecHaya(gasto.getFechaRecHaya()); 
			}
			
 			List<GastoRefacturable> listaGastosRefacturables = gastoDao.getGastosRefacturablesDelGasto(gasto.getId());
 			
 			dto.setIsGastoRefacturadoPadre(false);
			if (listaGastosRefacturables != null && !listaGastosRefacturables.isEmpty() && dto.getCartera() != null 
			&& (DDCartera.CODIGO_CARTERA_SAREB.equals(dto.getCartera()) || DDCartera.CODIGO_CARTERA_BANKIA.equals(dto.getCartera()))) {
				dto.setTieneGastosRefacturables(true);//?
				if(DDCartera.CODIGO_CARTERA_SAREB.equals(dto.getCartera())) {
					dto.setIsGastoRefacturadoPadre(true);
				}
			}
			
			dto.setBloquearDestinatario(!Checks.estaVacio(this.getGastosRefacturablesGasto(gasto.getId())));
			
			if (!Checks.esNulo(gasto.getNumGastoGestoria())) {
				dto.setBloquearEdicionFechasRecepcion(true);
			} else {
				dto.setBloquearEdicionFechasRecepcion(false);
			}
			
			if(gasto.getEstadoGasto() != null && 
				(DDEstadoGasto.INCOMPLETO.equals(gasto.getEstadoGasto().getCodigo()) 
				|| DDEstadoGasto.PENDIENTE.equals(gasto.getEstadoGasto().getCodigo())
				|| DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())
				|| DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo()))
			) {
				dto.setEstadoModificarLineasDetalleGasto(true);
			}else {
				dto.setEstadoModificarLineasDetalleGasto(false);
			}
			
			List<GastoLineaDetalle> gastoLineaDetalleList = gasto.getGastoLineaDetalleList();
			boolean tieneTrabajos = false;
			boolean tieneLineas = false;
			if(!gastoLineaDetalleList.isEmpty()) {
				tieneLineas = true;
				for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
					if(gastoLineaDetalle.getGastoLineaTrabajoList() != null && !gastoLineaDetalle.getGastoLineaTrabajoList().isEmpty()) {
						tieneTrabajos = true;
						break;
					}
				}
			}
			dto.setTieneTrabajos(tieneTrabajos);
			
			if((tieneLineas && tieneTrabajos) || (!tieneLineas)) {
				dto.setLineasNoDeTrabajos(false);
			}else {
				dto.setLineasNoDeTrabajos(true);
			}
			
			dto.setIsGastoRefacturadoPorOtroGasto(this.isGastoRefacturadoPorOtroGasto(gasto.getId()));
			
			if(gasto.getSuplidosVinculados() != null) {
				dto.setSuplidosVinculadosCod(gasto.getSuplidosVinculados().getCodigo());
			} else {
				dto.setSuplidosVinculadosCod(DDSinSiNo.CODIGO_NO);
			}
			
			dto.setFacturaPrincipalSuplido(gasto.getNumeroFacturaPrincipal());
			
			if (!Checks.esNulo(gasto.getSolicitudPagoUrgente())) {
				if (gasto.getSolicitudPagoUrgente() == 1) {
					dto.setSolicitudPagoUrgente(true);
				} else {
					dto.setSolicitudPagoUrgente(false);
				}
			}
		}

		return dto;
	}

	@SuppressWarnings("deprecation")
	@Override
	@Transactional(readOnly = false)
	public GastoProveedor createGastoProveedor(DtoFichaGastoProveedor dto) {

		GastoProveedor gastoProveedor = new GastoProveedor();
		Usuario usuario = genericAdapter.getUsuarioLogado();
		
		gastoProveedor = dtoToGastoProveedor(dto, gastoProveedor);

		updaterStateApi.updaterStates(gastoProveedor, DDEstadoGasto.INCOMPLETO);
		// Creamos el gasto y las entidades relacionadas
		genericDao.save(GastoProveedor.class, gastoProveedor);

		GastoDetalleEconomico detalleEconomico = new GastoDetalleEconomico();
		detalleEconomico.setGastoProveedor(gastoProveedor);

		if(gastoProveedor.getGestoria() == null && dto.getGastoRefacturable() != null) {
			detalleEconomico.setGastoRefacturable(dto.getGastoRefacturable());		
		}
		
		genericDao.save(GastoDetalleEconomico.class, detalleEconomico);

		GastoGestion gestion = new GastoGestion();

		gestion.setGastoProveedor(gastoProveedor);
		gestion.setFechaAlta(new Date());
		gestion.setUsuarioAlta(usuario);
		genericDao.save(GastoGestion.class, gestion);

		GastoInfoContabilidad contabilidad = new GastoInfoContabilidad();
		Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "anyo", String.valueOf(gastoProveedor.getFechaEmision().getYear() + 1900));
		Ejercicio ejercicio = genericDao.get(Ejercicio.class, filtroEjercicio);
		
		contabilidad.setEjercicio(ejercicio);	
		contabilidad.setGastoProveedor(gastoProveedor);
		genericDao.save(GastoInfoContabilidad.class, contabilidad);

		GastoImpugnacion impugnacion = new GastoImpugnacion();
		impugnacion.setGastoProveedor(gastoProveedor);
		genericDao.save(GastoImpugnacion.class, impugnacion);

		gastoProveedor.setGastoDetalleEconomico(detalleEconomico);
		gastoProveedor.setGastoGestion(gestion);
		gastoProveedor.setGastoInfoContabilidad(contabilidad);
		
		if(dto.getSuplidosVinculadosCod() != null) {
			DDSinSiNo suplidoVinculado = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getSuplidosVinculadosCod()));
			gastoProveedor.setSuplidosVinculados(suplidoVinculado);
		}
		
		if(dto.getFacturaPrincipalSuplido() != null) {
			
			GastoSuplido gastoSuplido = new GastoSuplido();
			
			GastoProveedor gastoPrincipal = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "referenciaEmisor", dto.getFacturaPrincipalSuplido()));
			
			gastoSuplido.setGastoProveedorPadre(gastoPrincipal);
			gastoSuplido.setGastoProveedorSuplido(gastoProveedor);
			
			genericDao.save(GastoSuplido.class, gastoSuplido);
			
			
			gastoProveedor.setNumeroFacturaPrincipal(dto.getFacturaPrincipalSuplido());
		}
		
		//creamos el contenedor en el gestor documental
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Integer idExpediente;
			try {
				idExpediente = gestorDocumentalAdapterApi.crearGasto(gastoProveedor, usuario.getUsername());
				logger.debug("GESTOR DOCUMENTAL [ crearGasto para " + gastoProveedor.getNumGastoHaya() + "]: ID EXPEDIENTE RECIBIDO " + idExpediente);
			} catch (GestorDocumentalException gexc) {
				logger.error("error creando el contenedor del gasto",gexc);
			}
		}
		
		HashSet<String>  tipoGastoImpuestoHash = new HashSet<String>();
		List<String> listaNumerosGasto = dto.getGastoRefacturadoGrid();
		if(listaNumerosGasto != null && !listaNumerosGasto.isEmpty()) {
			for (String numGasto : listaNumerosGasto) {				
			
				Filter filtraGastos = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.valueOf(numGasto));
				GastoProveedor gastoRefacturableHaya = genericDao.get(GastoProveedor.class, filtraGastos);
				
				if(gastoRefacturableHaya != null) {
					GastoRefacturable gastoRefacturable = new GastoRefacturable();
					gastoRefacturable.setGastoProveedor(gastoProveedor.getId());
					gastoRefacturable.setGastoProveedorRefacturado(gastoRefacturableHaya.getId());
					genericDao.save(GastoRefacturable.class, gastoRefacturable);
		
					List<GastoLineaDetalle> gastoLineaDetalleList = gastoRefacturableHaya.getGastoLineaDetalleList();
	
					if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()) {
						tipoGastoImpuestoHash = gastoLineaDetalleApi.devolverNumeroLineas(gastoLineaDetalleList, tipoGastoImpuestoHash);
					}

				}	
			}
			List<String> tipoGastoImpuestoList = new ArrayList<String>(tipoGastoImpuestoHash);
			if(!listaNumerosGasto.isEmpty() && !tipoGastoImpuestoList.isEmpty()) {
				gastoLineaDetalleApi.createLineasDetalleGastosRefacturados(tipoGastoImpuestoList, listaNumerosGasto, gastoProveedor);
			}

		}
		return gastoProveedor;
	}

	private GastoProveedor dtoToGastoProveedor(DtoFichaGastoProveedor dto, GastoProveedor gastoProveedor) {

		if (Checks.esNulo(dto.getNumGastoHaya())) {
			gastoProveedor.setNumGastoHaya(gastoDao.getNextNumGasto());
		} else {
			gastoProveedor.setNumGastoHaya(dto.getNumGastoHaya());
		}

		if (!Checks.esNulo(dto.getCodigoEmisor())) {
			ActivoProveedor proveedor = searchProveedorCodigo(dto.getCodigoEmisor().toString());
			gastoProveedor.setProveedor(proveedor);
		}

		if (!Checks.esNulo(dto.getIdEmisor())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdEmisor());
			ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtro);
			gastoProveedor.setProveedor(proveedor);
		}

		if (!Checks.esNulo(dto.getNifPropietario())) {
			ActivoPropietario propietario = searchPropietarioNif(dto.getNifPropietario());
			gastoProveedor.setPropietario(propietario);
		}

		if (!Checks.esNulo(dto.getDestinatarioGastoCodigo())) {
			DDDestinatarioGasto destinatarioGasto = (DDDestinatarioGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioGasto.class, dto.getDestinatarioGastoCodigo());
			gastoProveedor.setDestinatarioGasto(destinatarioGasto);
		}

		if (!Checks.esNulo(dto.getTipoGastoCodigo())) {
			DDTipoGasto tipoGasto = (DDTipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoGasto.class, dto.getTipoGastoCodigo());
			gastoProveedor.setTipoGasto(tipoGasto);
		}
//		if (!Checks.esNulo(dto.getSubtipoGastoCodigo())) {
//			DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, dto.getSubtipoGastoCodigo());
//			gastoProveedor.getGastoLineaDetalle().setSubtipoGasto(subtipoGasto);
//		}
		
		if (!Checks.esNulo(dto.getIdentificadorUnico())) {
			gastoProveedor.setIdentificadorUnico(dto.getIdentificadorUnico());
		}

		gastoProveedor.setFechaEmision(dto.getFechaEmision());
		gastoProveedor.setReferenciaEmisor(dto.getReferenciaEmisor());

		return gastoProveedor;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveGastosProveedor(DtoFichaGastoProveedor dto, Long id) {
		
		validacionPreviaSaveUpdateGasto(dto, id);

		Boolean actualizaSuplidos = false;
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, filtro);
		DtoFichaGastoProveedor dtoIni = gastoToDtoFichaGasto(gastoProveedor);
		
		Filter facturadosGastoId = genericDao.createFilter(FilterType.EQUALS, "idGastoProveedorRefacturado", id);
		GastoRefacturable gastoRefacturable = genericDao.get(GastoRefacturable.class, facturadosGastoId);
		Boolean esGastoHijo = false;
		Long idGastoPadre = null;
		Long numGastoPadre = null;
		if (!Checks.esNulo(gastoRefacturable)) {
			esGastoHijo = true;
			idGastoPadre = gastoRefacturable.getGastoProveedor();
			if (!Checks.esNulo(idGastoPadre)) {
				Filter gastoProveedorId = genericDao.createFilter(FilterType.EQUALS, "id", idGastoPadre);
				GastoProveedor gastoPadre = genericDao.get(GastoProveedor.class, gastoProveedorId);
				numGastoPadre = gastoPadre.getNumGastoHaya();
			}
		}
		
		if(gastoProveedor != null && gastoProveedor.getSuplidosVinculados() != null &&
				DDSinSiNo.CODIGO_SI.equals(gastoProveedor.getSuplidosVinculados().getCodigo()) && 
				(dto.getReferenciaEmisor() != null && !dto.getReferenciaEmisor().equals(gastoProveedor.getReferenciaEmisor()))) {
			actualizaSuplidos = true;
		}
		
		try {
			beanUtilNotNull.copyProperties(gastoProveedor, dto);

		} catch (Exception ex) {
			logger.error(ex.getCause());
		}
		
		if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
			if (!esGastoHijo) {
				Filter filtroCodigoEmisorRem = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", dto.getCodigoProveedorRem());
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroCodigoEmisorRem);
				gastoProveedor.setProveedor(proveedor);
				if(gastoProveedor != null && gastoProveedor.getSuplidosVinculados() != null &&
						DDSinSiNo.CODIGO_SI.equals(gastoProveedor.getSuplidosVinculados().getCodigo())) {
					actualizaSuplidos = true;
				}
			} else {
				throw new JsonViewerException("No se puede cambiar el emisor, este gasto refacturable está incluido en el gasto: "+numGastoPadre);
			}
		}

		if (!Checks.esNulo(dto.getBuscadorNifPropietario())) {
			if (!esGastoHijo) {
				Filter filtroNifPropietario = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dto.getBuscadorNifPropietario());
				ActivoPropietario propietario = genericDao.get(ActivoPropietario.class, filtroNifPropietario);
				gastoProveedor.setPropietario(propietario);
			} else {
				throw new JsonViewerException("No se puede cambiar el propietario, este gasto refacturable está incluido en el gasto: "+numGastoPadre);
			}
		}

		if (!Checks.esNulo(dto.getTipoGastoCodigo())) {
			DDTipoGasto tipoGasto = (DDTipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoGasto.class, dto.getTipoGastoCodigo());
			gastoProveedor.setTipoGasto(tipoGasto);
		}
		
		if (!Checks.esNulo(dto.getDestinatario())) {
			DDDestinatarioGasto destinatario = (DDDestinatarioGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioGasto.class, dto.getDestinatario());
			gastoProveedor.setDestinatarioGasto(destinatario);
		}
		if (!Checks.esNulo(dto.getPeriodicidad())) {
			DDTipoPeriocidad periodicidad = (DDTipoPeriocidad) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPeriocidad.class, dto.getPeriodicidad());
			gastoProveedor.setTipoPeriocidad(periodicidad);
		}
		if (!Checks.esNulo(dto.getTipoOperacionCodigo())) {
			DDTipoOperacionGasto tipoOperacion = (DDTipoOperacionGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoOperacionGasto.class, dto.getTipoOperacionCodigo());
			gastoProveedor.setTipoOperacion(tipoOperacion);
		}
		if (!Checks.esNulo(dto.getNumGastoAbonado())) {
			List<GastoProveedor> listaGastos = new ArrayList<GastoProveedor>();
			Filter filtroGastoAbonado = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", dto.getNumGastoAbonado());
			listaGastos = genericDao.getList(GastoProveedor.class, filtroGastoAbonado);

			if (!Checks.estaVacio(listaGastos)) {
				GastoProveedor gasto = listaGastos.get(0);
				if (!Checks.esNulo(gasto.getProveedor()) && !Checks.esNulo(gastoProveedor.getProveedor())) {
					if (gasto.getProveedor().getCodigoProveedorRem().equals(gastoProveedor.getProveedor().getCodigoProveedorRem())
							&& gasto.getDestinatarioGasto().equals(gastoProveedor.getDestinatarioGasto())) {
						gastoProveedor.setGastoProveedorAbonado(gasto);
					} else {
						throw new JsonViewerException("Destinatario o proveedor del gasto abonado son diferentes");
					}
				}

			} else {
				throw new JsonViewerException("El numero de gasto abonado no existe");
			}

		}
		if(!Checks.esNulo(dto.getDestinatario()) && !DDDestinatarioGasto.CODIGO_HAYA.equals(dto.getDestinatario())){
			if (!esGastoHijo) {
				gastoProveedor.getGastoDetalleEconomico().setGastoRefacturable(false);
			} else {
				throw new JsonViewerException("No se puede cambiar el destinatario, este gasto refacturable está incluido en el gasto: "+numGastoPadre);
			}
		}
		
		if (!Checks.esNulo(dto.getIdentificadorUnico())) {
			gastoProveedor.setIdentificadorUnico(dto.getIdentificadorUnico());
		}
		
		updateEjercicio(gastoProveedor);
		
		DtoFichaGastoProveedor dtoFin = gastoToDtoFichaGasto(gastoProveedor);

		boolean cambios = hayCambiosGasto(dtoIni, dtoFin, gastoProveedor);
		
		if(!cambios && (DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gastoProveedor.getEstadoGasto().getCodigo()) 
				|| DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gastoProveedor.getEstadoGasto().getCodigo()) 
				|| DDEstadoGasto.SUBSANADO.equals(gastoProveedor.getEstadoGasto().getCodigo()))) {
		}else {
			updaterStateApi.updaterStates(gastoProveedor, null);
		}
		GastoSuplido gastoSuplido = genericDao.get(GastoSuplido.class, genericDao.createFilter(FilterType.EQUALS, "gastoProveedorSuplido", gastoProveedor), filtroBorrado);
		
		if(gastoSuplido != null && DDSinSiNo.CODIGO_NO.equals(gastoSuplido)) {
			gastoDao.deleteGastoSuplido(gastoSuplido.getId());
			
			gastoProveedor.setNumeroFacturaPrincipal(null);
		}
		
		
		if(dto.getSuplidosVinculadosCod() != null) {
			DDSinSiNo suplidoVinculado = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getSuplidosVinculadosCod()));
			gastoProveedor.setSuplidosVinculados(suplidoVinculado);
		}else if(gastoProveedor.getSuplidosVinculados() == null) {
			DDSinSiNo suplidoVinculado = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO));
			gastoProveedor.setSuplidosVinculados(suplidoVinculado);
		}
		
		if(dto.getFacturaPrincipalSuplido() != null && !dto.getFacturaPrincipalSuplido().isEmpty() 
				&& !dto.getFacturaPrincipalSuplido().equals(gastoProveedor.getNumeroFacturaPrincipal())) {
				
			if(gastoSuplido == null) {
				gastoSuplido = new GastoSuplido();
					
				gastoSuplido.setGastoProveedorSuplido(gastoProveedor);
			}
			
			Filter filtroSuplidos = genericDao.createFilter(FilterType.EQUALS,"suplidosVinculados.codigo", DDSinSiNo.CODIGO_SI);				
			GastoProveedor gastoPrincipal = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "referenciaEmisor", dto.getFacturaPrincipalSuplido()), filtroSuplidos);
			
			if(esGastoAutorizado(gastoPrincipal)) {
				throw new JsonViewerException("No se puede añadir como suplido al gasto "+gastoPrincipal.getNumGastoHaya()+ ", ya que este se encuentra autorizado.");
			}
			
			gastoSuplido.setGastoProveedorPadre(gastoPrincipal);
			genericDao.save(GastoSuplido.class, gastoSuplido);
			
			gastoProveedor.setNumeroFacturaPrincipal(dto.getFacturaPrincipalSuplido());
		}else if(dto.getFacturaPrincipalSuplido() == null || dto.getFacturaPrincipalSuplido().isEmpty()) {
			
			if(gastoSuplido != null) {
				gastoDao.deleteGastoSuplido(gastoSuplido.getId());
				
				gastoProveedor.setNumeroFacturaPrincipal(null);
			}
		}
		
		if (!Checks.esNulo(dto.getSolicitudPagoUrgente())) {
			if (dto.getSolicitudPagoUrgente()) {
				gastoProveedor.setSolicitudPagoUrgente(1);
			} else {
				gastoProveedor.setSolicitudPagoUrgente(0);
			}
		}
		
		genericDao.update(GastoProveedor.class, gastoProveedor);
		
		if(actualizaSuplidos) {
			Thread actualizaSuplidosAsync = new Thread(new ActualizaSuplidosAsync(gastoProveedor.getId(),
					dto.getCodigoProveedorRem(), dto.getReferenciaEmisor(), genericAdapter.getUsuarioLogado().getUsername()));

			actualizaSuplidosAsync.start();
		}

		return true;
	}

	private void updateEjercicio(GastoProveedor gasto) {
		
		Filter filtroGIC = genericDao.createFilter(FilterType.EQUALS, "GPV_ID", gasto.getId());
		GastoInfoContabilidad gastoInfoContabilidad = genericDao.get(GastoInfoContabilidad.class, filtroGIC);
		
		
		if(Checks.esNulo(gastoInfoContabilidad.getFechaDevengoEspecial())) {
			if(!Checks.esNulo(gasto.getFechaEmision())){
				SimpleDateFormat sdf  = new SimpleDateFormat("yyyy");
				Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "anyo", sdf.format(gasto.getFechaEmision()));
				Ejercicio ejercicio = genericDao.get(Ejercicio.class, filtroEjercicio);
				gastoInfoContabilidad.setEjercicio(ejercicio);
			}
		}else {
			SimpleDateFormat sdf  = new SimpleDateFormat("yyyy");
			Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "anyo", sdf.format(gasto.getGastoInfoContabilidad().getFechaDevengoEspecial()));
			Ejercicio ejercicio = genericDao.get(Ejercicio.class, filtroEjercicio);
			gastoInfoContabilidad.setEjercicio(ejercicio);
		}

	}

	public boolean existeGasto(DtoFichaGastoProveedor dto) {

		boolean existeGasto = false;

		Filter filtroReferencia = genericDao.createFilter(FilterType.EQUALS, "referenciaEmisor", dto.getReferenciaEmisor());
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "tipoGasto.codigo", dto.getTipoGastoCodigo());
		Filter filtroEmisor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", dto.getIdEmisor());
		Filter filtroFechaEmision = genericDao.createFilter(FilterType.EQUALS, "fechaEmision", dto.getFechaEmision());
		Filter filtroDestinatario = genericDao.createFilter(FilterType.EQUALS, "destinatarioGasto.codigo", dto.getDestinatarioGastoCodigo());

		List<GastoProveedor> lista = genericDao.getList(GastoProveedor.class, filtroReferencia, filtroTipo, filtroEmisor, filtroFechaEmision, filtroDestinatario);

		if (!Checks.esNulo(lista) && !lista.isEmpty()) {
			for (int i = 0; !existeGasto && i < lista.size(); i++) {
				GastoProveedor g = lista.get(i);
				if (!Checks.esNulo(g.getEstadoGasto())) {
					if (!DDEstadoGasto.ANULADO.equals(g.getEstadoGasto().getCodigo()) && !DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(g.getEstadoGasto().getCodigo())) {
						existeGasto = true;
					}
				} else {
					existeGasto = true;
				}
			}
		}

		return existeGasto;
	}

	@Override
	public ActivoProveedor searchProveedorCodigo(String codigoUnicoProveedor) {

		List<ActivoProveedor> listaProveedores = new ArrayList<ActivoProveedor>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", Long.parseLong(codigoUnicoProveedor));
		listaProveedores = genericDao.getList(ActivoProveedor.class, filtro);

		if (!Checks.estaVacio(listaProveedores)) {
			return listaProveedores.get(0);
		}
		return null;
	}

	@Override
	public ActivoPropietario searchPropietarioNif(String nifPropietario) {

		List<ActivoPropietario> listaPropietarios = new ArrayList<ActivoPropietario>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", nifPropietario);
		listaPropietarios = genericDao.getList(ActivoPropietario.class, filtro);

		if (!Checks.estaVacio(listaPropietarios)) {
			return listaPropietarios.get(0);
		}

		return null;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean searchActivoCarteraAndGastoPrinex(String numGastoHaya) {

		GastoProveedor gastoProveedor = new GastoProveedor();
		Long numGastoHayaLong = Long.valueOf(numGastoHaya);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", numGastoHayaLong);
		gastoProveedor = genericDao.get(GastoProveedor.class, filtro);

		if (!Checks.esNulo(gastoProveedor)) {
			List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidad = new ArrayList<GastoLineaDetalleEntidad>();;
			Long idGastoProveedor = gastoProveedor.getId();
			
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.gastoProveedor.id",idGastoProveedor);
			gastoLineaDetalleEntidad = genericDao.getList(GastoLineaDetalleEntidad.class, filtro2);
		if(!Checks.estaVacio(gastoLineaDetalleEntidad)) {
			for (GastoLineaDetalleEntidad gastoProveedorObject : gastoLineaDetalleEntidad) {
				if(!Checks.esNulo(gastoProveedorObject)) {
					Filter filtroId = genericDao.createFilter(FilterType.EQUALS, "id",gastoProveedorObject.getEntidad());
					Activo activo =  genericDao.get(Activo.class, filtroId);
					if((DDCartera.CODIGO_CARTERA_LIBERBANK).equals(activo.getCartera().getCodigo())) {
						List<GastoPrinex> gastoPrinex = new ArrayList<GastoPrinex>();
						Long activoId = activo.getId();
						Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "idActivo",activoId);
						gastoPrinex = genericDao.getList(GastoPrinex.class, filtro3);
						if(!Checks.estaVacio(gastoPrinex)) {
							return true;
						}
					}
				}
			
			}	
		}
		}

		return false;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean updateGastoByPrinexLBK(Long idGasto) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idGasto", idGasto);
		
		rawDao.addParams(params);

		Double gastoTotal = 0.0;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
		GastoDetalleEconomico detalleGasto = genericDao.get(GastoDetalleEconomico.class, filtro);
		GastoLineaDetalle lineaDetalle = genericDao.get(GastoLineaDetalle.class, filtro);

		if (!Checks.esNulo(detalleGasto)) {
			if(!Checks.esNulo(detalleGasto.getGastoProveedor())) {
				List<GastoPrinex> listGastoPrinex = new ArrayList<GastoPrinex>();
				Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "idGasto",idGasto);
				listGastoPrinex = genericDao.getList(GastoPrinex.class, filtro3);

				if(!Checks.estaVacio(listGastoPrinex)) {					
					
					String result = rawDao.getExecuteSQL("SELECT SUM(GPL_IMPORTE_GASTO) FROM GPL_GASTOS_PRINEX_LBK WHERE GPV_ID =  :idGasto ");	
					gastoTotal = Double.valueOf(result);
					for (GastoPrinex gastoPrinex : listGastoPrinex) {
						if(!Checks.esNulo(gastoPrinex.getIdActivo())) {
							GastoLineaDetalleEntidad gastoProveedorActivos = null;
							
							Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.gastoProveedor.id",idGasto);
							Filter filtro4 = genericDao.createFilter(FilterType.EQUALS, "activo.id",gastoPrinex.getIdActivo());

							gastoProveedorActivos = genericDao.get(GastoLineaDetalleEntidad.class, filtro2,filtro4);
							Double participacionGasto = (double) ((gastoPrinex.getImporteGasto()*100)/gastoTotal);

							DecimalFormat df = new DecimalFormat("##.####");
							df.setRoundingMode(RoundingMode.HALF_DOWN);
							
							//truncamos a 4 decimales
							participacionGasto = Double.valueOf(df.format(participacionGasto).replace(',', '.'));
							
							if(!Checks.esNulo(gastoProveedorActivos)) {
								gastoProveedorActivos.setParticipacionGasto(participacionGasto);
								genericDao.update(GastoLineaDetalleEntidad.class, gastoProveedorActivos);
							}
						}
						if(!Checks.esNulo(gastoPrinex.getDiario1())) {
							Double diarioBase = gastoPrinex.getDiario1Base();
							Double diarioTipo = gastoPrinex.getDiario1Tipo();
							Double diarioCuota = gastoPrinex.getDiario1Cuota();
							Double diario2Base = gastoPrinex.getDiario2Base();
							lineaDetalle.setImporteIndirectoTipoImpositivo(diarioTipo);
							lineaDetalle.setImporteIndirectoCuota(diarioCuota);
							detalleGasto.setIrpfTipoImpositivo(gastoPrinex.getPorcentajeIrpf());
							detalleGasto.setIrpfCuota(gastoPrinex.getImporteIrpf());
							if("1".equals(gastoPrinex.getDiario1()) || "20".equals(gastoPrinex.getDiario1()) || "2".equals(gastoPrinex.getDiario1())) {							
								lineaDetalle.setPrincipalSujeto(diarioBase);
								detalleGasto.setImporteTotal(diarioBase + diarioCuota);
								if("60".equals(gastoPrinex.getDiario2())) {	
									lineaDetalle.setPrincipalNoSujeto(diario2Base);
									detalleGasto.setImporteTotal(diarioBase + diarioCuota + diario2Base);
								}								
							}else {
								lineaDetalle.setPrincipalNoSujeto(diarioBase);							
								lineaDetalle.setEsImporteIndirectoExento(true);
								detalleGasto.setImporteTotal(diarioBase);								
							}							
							genericDao.update(GastoLineaDetalle.class, lineaDetalle);
							genericDao.update(GastoDetalleEconomico.class, detalleGasto);
						}	
					}
				}
				GastoProveedor gasto = null;
				gasto = gastoDao.getGastoById(idGasto);
				if(!Checks.esNulo(gasto)) {
					
					if(!Checks.estaVacio(gasto.getGastoLineaDetalleList())){
						for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
							if (!Checks.esNulo(gastoLinea.getGastoLineaEntidadList()) && !Checks.estaVacio(gastoLinea.getGastoLineaEntidadList())){
								List<GastoLineaDetalleEntidad> gastosLineaDetalleEntidadList = gastoLinea.getGastoLineaEntidadList();
								this.calculaPorcentajeEquitativoGastoActivos(gastosLineaDetalleEntidadList);
							}
						}
					}
					if(DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo())) {
						updaterStateApi.updaterStates(gasto, DDEstadoGasto.SUBSANADO);
						gasto.getGastoGestion().setEstadoAutorizacionPropietario(genericDao.get(DDEstadoAutorizacionPropietario.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE)));
						gasto.getGastoGestion().setMotivoRechazoAutorizacionPropietario(null);
						gasto.getGastoGestion().setFechaEstadoAutorizacionPropietario(null);
						genericDao.update(GastoProveedor.class, gasto);
					}
				}				
				return true;
			}
		}		
		return false;		
	}
	
	
	private DtoDetalleEconomicoGasto detalleEconomicoToDtoDetalleEconomico(GastoProveedor gasto) {

		DtoDetalleEconomicoGasto dto = new DtoDetalleEconomicoGasto();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
		GastoDetalleEconomico detalleGasto = genericDao.get(GastoDetalleEconomico.class, filtro);

		if (!Checks.esNulo(detalleGasto)) {			
			if(!Checks.esNulo(gasto.getPropietario())) {
				if(!Checks.esNulo(gasto.getPropietario().getCartera())) {
					if(!Checks.esNulo(gasto.getPropietario().getCartera().getCodigo())) {
						dto.setCartera(gasto.getPropietario().getCartera().getCodigo());
					}
				}
			}
			
			dto.setIrpfTipoImpositivo(detalleGasto.getIrpfTipoImpositivo());
			dto.setIrpfCuota(detalleGasto.getIrpfCuota());
			dto.setBaseImpI(detalleGasto.getIrpfBase());
			dto.setClave(detalleGasto.getIrpfClave());
			dto.setSubclave(detalleGasto.getIrpfSubclave());
			
			
			dto.setIrpfTipoImpositivoRetG(detalleGasto.getRetencionGarantiaTipoImpositivo());
			dto.setBaseRetG(detalleGasto.getRetencionGarantiaBase());
			dto.setRetencionGarantiaAplica(detalleGasto.getRetencionGarantiaAplica());
			dto.setIrpfCuotaRetG(detalleGasto.getRetencionGarantiaCuota());
			if(detalleGasto.getTipoRetencion() != null) {
				dto.setTipoRetencionCodigo(detalleGasto.getTipoRetencion().getCodigo());
			}
			// TIPO IMPUESTO DIRECTO

			dto.setImporteTotal(detalleGasto.getImporteTotal());

			dto.setFechaTopePago(detalleGasto.getFechaTopePago());
			dto.setRepercutibleInquilino(detalleGasto.getRepercutibleInquilino());
			dto.setImportePagado(detalleGasto.getImportePagado());
			dto.setFechaPago(detalleGasto.getFechaPago());
			if (!Checks.esNulo(detalleGasto.getTipoPagador())) {
				dto.setTipoPagadorCodigo(detalleGasto.getTipoPagador().getCodigo());
			}
			if (!Checks.esNulo(detalleGasto.getDestinatariosPago())) {
				dto.setDestinatariosPagoCodigo(detalleGasto.getDestinatariosPago().getCodigo());
			}

			if (!Checks.esNulo(detalleGasto.getReembolsoTercero())) {
				dto.setReembolsoTercero(detalleGasto.getReembolsoTercero() == 1 ? true : false);
			}
			if (!Checks.esNulo(detalleGasto.getIncluirPagoProvision())) {
				dto.setIncluirPagoProvision(detalleGasto.getIncluirPagoProvision() == 1 ? true : false);
			}
			if (!Checks.esNulo(detalleGasto.getAbonoCuenta())) {
				dto.setAbonoCuenta(detalleGasto.getAbonoCuenta() == 1 ? true : false);
			}

			if (!Checks.esNulo(detalleGasto.getIbanAbonar())) {
				String ibanCompleto = detalleGasto.getIbanAbonar();
				String iban1 = "";
				String iban2 = "";
				String iban3 = "";
				String iban4 = "";
				String iban5 = "";
				String iban6 = "";
				for (int i = 0; i < ibanCompleto.length(); i++) {
					if (i <= 3) {
						iban1 = iban1 + ibanCompleto.charAt(i);
					} else if (i > 3 && i <= 7) {
						iban2 = iban2 + ibanCompleto.charAt(i);
					} else if (i > 7 && i <= 11) {
						iban3 = iban3 + ibanCompleto.charAt(i);
					} else if (i > 11 && i <= 15) {
						iban4 = iban4 + ibanCompleto.charAt(i);
					} else if (i > 15 && i <= 19) {
						iban5 = iban5 + ibanCompleto.charAt(i);
					} else if (i > 19 && i <= 23) {
						iban6 = iban6 + ibanCompleto.charAt(i);
					}

				}
				dto.setIban1(iban1);
				dto.setIban2(iban2);
				dto.setIban3(iban3);
				dto.setIban4(iban4);
				dto.setIban5(iban5);
				dto.setIban6(iban6);
			}

			dto.setIban(detalleGasto.getIbanAbonar());
			dto.setTitularCuenta(detalleGasto.getTitularCuentaAbonar());
			dto.setNifTitularCuenta(detalleGasto.getNifTitularCuentaAbonar());
			dto.setImporteGastosRefacturables(0.0);
			
			
			if(Checks.esNulo(detalleGasto.getGastoRefacturable()) || (!Checks.esNulo(detalleGasto.getGastoRefacturable()) && detalleGasto.getGastoRefacturable())) { 
				dto.setGastoRefacturableB(detalleGasto.getGastoRefacturable());
			}else {
				dto.setGastoRefacturableB(false);
			}
			
			dto.setBloquearCheckRefacturado(!isPosibleRefacturable(gasto));
			
			if (!Checks.esNulo(detalleGasto.getPagadoConexionBankia())) {
				dto.setPagadoConexionBankia(detalleGasto.getPagadoConexionBankia() == 1 ? true : false);
			}
			dto.setOficina(detalleGasto.getOficinaBankia());
			dto.setNumeroConexion(detalleGasto.getNumeroConexionBankia());
			dto.setFechaConexion(detalleGasto.getFechaConexion());
			
			if (!Checks.esNulo(detalleGasto.getAnticipo())) {
				dto.setAnticipo(detalleGasto.getAnticipo() == 1 ? true : false);
			}
			dto.setFechaAnticipo(detalleGasto.getFechaAnticipo());			

			if (!Checks.esNulo(gasto.getProveedor().getCriterioCajaIVA())) {
				dto.setOptaCriterioCaja(BooleanUtils.toBooleanObject(gasto.getProveedor().getCriterioCajaIVA()));
			}
			
			if(!Checks.esNulo(gasto.getEstadoGasto())) {
					String estadoGasto = gasto.getEstadoGasto().getCodigo();
				if(DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(estadoGasto)
 					||	DDEstadoGasto.AUTORIZADO_PROPIETARIO.equals(estadoGasto)
 					||	DDEstadoGasto.PAGADO.equals(estadoGasto)
					||	DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC.equals(estadoGasto)
					||	DDEstadoGasto.CONTABILIZADO.equals(estadoGasto)) {
 						dto.setNoAnyadirEliminarGastosRefacturados(true);
 				}else {
 					dto.setNoAnyadirEliminarGastosRefacturados(false);
 				}
			}
			
			Filter filtroImporteBruto = genericDao.createFilter(FilterType.EQUALS, "id", gasto.getId());
			VImporteBrutoGastoLBK importeBrutoLbk = genericDao.get(VImporteBrutoGastoLBK.class, filtroImporteBruto);
			
			if(importeBrutoLbk != null && importeBrutoLbk.getImporteBrutoLbk() != null) {
				dto.setImporteBrutoLbk(importeBrutoLbk.getImporteBrutoLbk());
			}
			
		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveDetalleEconomico(DtoDetalleEconomicoGasto dto, Long idGasto) {

		GastoProveedor gasto = findOne(idGasto);
		GastoDetalleEconomico detalleGasto = gasto.getGastoDetalleEconomico();
		DtoDetalleEconomicoGasto dtoIni = detalleEconomicoToDtoDetalleEconomico(gasto);
		try {
			if (!Checks.esNulo(detalleGasto)) {
				
				beanUtilNotNull.copyProperties(detalleGasto, dto);

				if (!Checks.esNulo(dto.getDestinatariosPagoCodigo())) {
					DDDestinatarioPago destinatarioPago = (DDDestinatarioPago) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioPago.class,
							dto.getDestinatariosPagoCodigo());
					detalleGasto.setDestinatariosPago(destinatarioPago);
				}
				if (!Checks.esNulo(dto.getTipoPagadorCodigo())) {
					DDTipoPagador tipoPagador = (DDTipoPagador) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPagador.class, dto.getTipoPagadorCodigo());
					detalleGasto.setTipoPagador(tipoPagador);
				}

				if (!Checks.esNulo(dto.getIncluirPagoProvision())) {
					detalleGasto.setIncluirPagoProvision(dto.getIncluirPagoProvision() ? 1 : 0);
					if(dto.getIncluirPagoProvision()) {							
						detalleGasto.setAbonoCuenta(0);
						detalleGasto.setPagadoConexionBankia(0);
						detalleGasto.setAnticipo(0);
						
						detalleGasto.setIbanAbonar(null);
						detalleGasto.setTitularCuentaAbonar(null);
						detalleGasto.setNifTitularCuentaAbonar(null);
						detalleGasto.setOficinaBankia(null);
						detalleGasto.setNumeroConexionBankia(null);
						detalleGasto.setFechaConexion(null);
						detalleGasto.setFechaAnticipo(null);
					}
				}

				if (!Checks.esNulo(dto.getAbonoCuenta())) {
						detalleGasto.setAbonoCuenta(dto.getAbonoCuenta() ? 1 : 0);
						if (!Checks.esNulo(dto.getIban())) {
							detalleGasto.setIbanAbonar(dto.getIban());
						}
						if (!Checks.esNulo(dto.getTitularCuenta())) {
							detalleGasto.setTitularCuentaAbonar(dto.getTitularCuenta());
						}
						if (!Checks.esNulo(dto.getNifTitularCuenta())) {
							detalleGasto.setNifTitularCuentaAbonar(dto.getNifTitularCuenta());
						}
						
						if(dto.getAbonoCuenta()) {
							
							detalleGasto.setIncluirPagoProvision(0);
							detalleGasto.setPagadoConexionBankia(0);
							detalleGasto.setAnticipo(0);
							detalleGasto.setOficinaBankia(null);
							detalleGasto.setNumeroConexionBankia(null);
							detalleGasto.setFechaConexion(null);
							detalleGasto.setFechaAnticipo(null);							
						} else {
							detalleGasto.setIbanAbonar(null);					
							detalleGasto.setTitularCuentaAbonar(null);
							detalleGasto.setNifTitularCuentaAbonar(null);
						}
						
				}
				
				if (!Checks.esNulo(dto.getPagadoConexionBankia())) {
					detalleGasto.setPagadoConexionBankia(dto.getPagadoConexionBankia() ? 1 : 0);
					if (!Checks.esNulo(dto.getOficina())) {
						detalleGasto.setOficinaBankia(dto.getOficina());
					}
					if (!Checks.esNulo(dto.getNumeroConexion())) {
						detalleGasto.setNumeroConexionBankia(dto.getNumeroConexion());
					}
					
					if(dto.getPagadoConexionBankia()) {
						
						detalleGasto.setAbonoCuenta(0);
						detalleGasto.setIncluirPagoProvision(0);
						detalleGasto.setAnticipo(0);
						
						detalleGasto.setIbanAbonar(null);
						detalleGasto.setTitularCuentaAbonar(null);
						detalleGasto.setNifTitularCuentaAbonar(null);
						detalleGasto.setFechaAnticipo(null);				
					} else {
						detalleGasto.setOficinaBankia(null);
						detalleGasto.setNumeroConexionBankia(null);
						detalleGasto.setFechaConexion(null);
					}
				}
				
				if(!Checks.esNulo(dto.getAnticipo())) {
					
					detalleGasto.setAnticipo(dto.getAnticipo() ? 1 : 0);
					
					if(dto.getAnticipo()) {							
					
						detalleGasto.setAbonoCuenta(0);
						detalleGasto.setPagadoConexionBankia(0);
						detalleGasto.setIncluirPagoProvision(0);
						
						detalleGasto.setIbanAbonar(null);
						detalleGasto.setTitularCuentaAbonar(null);
						detalleGasto.setNifTitularCuentaAbonar(null);
						detalleGasto.setOficinaBankia(null);
						detalleGasto.setNumeroConexionBankia(null);
						detalleGasto.setFechaConexion(null);
					} else {
						detalleGasto.setFechaAnticipo(null);
					}
				}
				
				if(dto.getRetencionGarantiaAplica() != null) {
					if(dto.getRetencionGarantiaAplica()) {
						DDTipoRetencion tipoRetencion = (DDTipoRetencion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRetencion.class, dto.getTipoRetencionCodigo());
						if(tipoRetencion != null) {
							detalleGasto.setTipoRetencion(tipoRetencion);
						}
					}else {
						detalleGasto.setTipoRetencion(null);			
					}
					detalleGasto.setRetencionGarantiaAplica(dto.getRetencionGarantiaAplica());
				}else if(detalleGasto.getRetencionGarantiaAplica() != null) {
					if(detalleGasto.getRetencionGarantiaAplica()) {
						DDTipoRetencion tipoRetencion = (DDTipoRetencion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRetencion.class, dto.getTipoRetencionCodigo());
						if(tipoRetencion != null) {
							detalleGasto.setTipoRetencion(tipoRetencion);
						}
					}else {
						detalleGasto.setTipoRetencion(null);
					}
				}
				
				DtoDetalleEconomicoGasto dtoFin = detalleEconomicoToDtoDetalleEconomico(gasto);
				
				if(!Checks.esNulo(dto.getGastoRefacturableB())) {
					detalleGasto.setGastoRefacturable(dto.getGastoRefacturableB());					
				}
				
				boolean cambios = hayCambiosGasto(dtoIni, dtoFin, gasto);
				if(!cambios && (DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo()) 
						|| DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo()) 
						|| DDEstadoGasto.SUBSANADO.equals(gasto.getEstadoGasto().getCodigo()))) {
					//updaterStateApi.updaterStates(gasto, gasto.getEstadoGasto().getCodigo());
				}else {
					updaterStateApi.updaterStates(gasto, null);
				}
				
				Usuario usuario = genericAdapter.getUsuarioLogado();
				if(!Checks.esNulo(detalleGasto.getAuditoria())) {
					detalleGasto.getAuditoria().setUsuarioModificar(usuario.getUsername());
					detalleGasto.getAuditoria().setFechaModificar(new Date());
				}	
				
				if(dto.getBaseImpI() != null) {
					detalleGasto.setIrpfBase(dto.getBaseImpI());
				}
				if(dto.getClave() !=null) { 
					detalleGasto.setIrpfClave(dto.getClave());
				}
				if( dto.getSubclave() !=null) {
					detalleGasto.setIrpfSubclave(dto.getSubclave());
				}
				if(dto.getIrpfTipoImpositivoRetG() != null) {
					detalleGasto.setRetencionGarantiaTipoImpositivo(dto.getIrpfTipoImpositivoRetG());
				}

				if(dto.getBaseRetG() !=null) {
					detalleGasto.setRetencionGarantiaBase(dto.getBaseRetG());
				}
				
				if(dto.getIrpfCuotaRetG()!=null) {
					gasto.getGastoDetalleEconomico().setRetencionGarantiaCuota(dto.getIrpfCuotaRetG());
				}
				
				if(dto.getImporteTotal()!=null) {
					detalleGasto.setImporteTotal(dto.getImporteTotal());
				}
				
				if((dto.getRetencionGarantiaAplica() != null || dto.getTipoRetencionCodigo() != null || dto.getIrpfTipoImpositivoRetG() != null) 
				&& (gasto != null && gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null &&
					DDCartera.CODIGO_CARTERA_LIBERBANK.equalsIgnoreCase(gasto.getPropietario().getCartera().getCodigo()))) {
						gastoLineaDetalleApi.actualizarDiariosLbk(gasto.getId());
				}
						
				
				genericDao.update(GastoDetalleEconomico.class, detalleGasto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}

	@Override
	public List<VBusquedaGastoActivo> getListActivosGastos(Long idGasto) {

		List<VBusquedaGastoActivo> gastosActivos;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idGasto", idGasto);
		gastosActivos = genericDao.getList(VBusquedaGastoActivo.class, filtro);
		return gastosActivos;
	}

	
	@Transactional(readOnly = false)
	public boolean createGastoActivo(Long idGasto, Long numActivo, Long numAgrupacion) {

		if (Checks.esNulo(idGasto)) {
			throw new JsonViewerException("El gasto debe informarse");
		}

		Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
		GastoProveedor gasto = genericDao.get(GastoProveedor.class, filtroGasto);
		
		if (Checks.esNulo(gasto)) {
			throw new JsonViewerException("Este gasto no existe");
		}

		if (!Checks.esNulo(numActivo)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
			Activo activo = genericDao.get(Activo.class, filtro);
			if (Checks.esNulo(activo)) {
				throw new JsonViewerException("Este activo no existe");
			}

			
			Filter filtroSareb = genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", numActivo);
			ActivoSareb activoSareb  = genericDao.get(ActivoSareb.class, filtroSareb);
			
			
			if (activoSareb != null && activoSareb.getReoContabilizado() != null && activoSareb.getReoContabilizado().getCodigo().equals(DDSinSiNo.CODIGO_NO)) {
				throw new JsonViewerException("No se puede generar un gasto para un activo no contabilizado");
			}
			
			GastoLineaDetalleEntidad gastoActivo = null;
			

			Filter filtroA = genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", numActivo);
			Activo act = genericDao.get(Activo.class,filtroA);
			if(!Checks.esNulo(act)) {
				Filter filtroG = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.gastoProveedor.id", idGasto);
				Filter filtroE = genericDao.createFilter(FilterType.EQUALS, "entidad", act.getId());
				Filter filtroD = genericDao.createFilter(FilterType.EQUALS, "entidadGasto.codigo", DDEntidadGasto.CODIGO_ACTIVO);
				gastoActivo = genericDao.get(GastoLineaDetalleEntidad.class, filtroG, filtroE, filtroD);
			}
			if (Checks.esNulo(gastoActivo)) {

				if (DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())
						&& Checks.esNulo(activo.getNumInmovilizadoBnk())) {
					throw new JsonViewerException("El activo carece de nº inmovilizado CaixaBank");
				}

				if (!Checks.esNulo(gasto.getPropietario())) {

					if (!Checks.esNulo(gasto.getPropietario().getDocIdentificativo())) {
						ActivoPropietario propietario = activo.getPropietarioPrincipal();
						if (!Checks.esNulo(propietario)) {
							if (!gasto.getPropietario().getDocIdentificativo()
									.equals(propietario.getDocIdentificativo())) {
								throw new JsonViewerException("Propietario diferente al propietario actual del gasto");
							}
						} else {
							throw new JsonViewerException("Propietario diferente al propietario actual del gasto");
						}
					} else {
						throw new JsonViewerException("Propietario del gasto sin documento");
					}

				}

				Filter filtroNumAct = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
				Filter filtroTram = genericDao.createFilter(FilterType.EQUALS, "enTramite", 1);
				Activo actTram = genericDao.get(Activo.class, filtroNumAct, filtroTram);

				if (!Checks.esNulo(actTram)) {
					throw new JsonViewerException("Este activo se encuentra en trámite");
				} else {
					Filter filtroCatastro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Order order = new Order(OrderType.DESC, "fechaRevValorCatastral");
					List<ActivoCatastro> activosCatastro = genericDao.getListOrdered(ActivoCatastro.class, order,
							filtroCatastro);
					
					//TODO GASTO
					GastoLineaDetalle gastoLineaDetalle = new GastoLineaDetalle();
					gastoLineaDetalle.setGastoProveedor(gasto);
					DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class,DDSubtipoGasto.OTROS);
					gastoLineaDetalle.setSubtipoGasto(subtipoGasto);
					genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
					GastoLineaDetalleEntidad gastoProveedorActivo = new GastoLineaDetalleEntidad();
					gastoProveedorActivo.setEntidad(activo.getId());
					gastoProveedorActivo.setGastoLineaDetalle(gastoLineaDetalle);
					
					if (!Checks.estaVacio(activosCatastro)) {
						gastoProveedorActivo.setReferenciaCatastral(activosCatastro.get(0).getRefCatastral());
					}
					
					if(!Checks.estaVacio(gasto.getGastoLineaDetalleList())){
						for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
							if (!Checks.esNulo(gastoLinea.getGastoLineaEntidadList()) && !Checks.estaVacio(gastoLinea.getGastoLineaEntidadList())){
								List<GastoLineaDetalleEntidad> gastosLineaDetalleEntidadList = gastoLinea.getGastoLineaEntidadList();
								if(gastosLineaDetalleEntidadList == null) {
									gastosLineaDetalleEntidadList = new ArrayList<GastoLineaDetalleEntidad>();
								}
								gastosLineaDetalleEntidadList.add(gastoProveedorActivo);
								this.calculaPorcentajeEquitativoGastoActivos(gastosLineaDetalleEntidadList);	
							}
						}
					}
	
					genericDao.save(GastoLineaDetalleEntidad.class, gastoProveedorActivo);
				}

			} else {
				throw new JsonViewerException("Este activo ya está asignado");
			}

		} else if (!Checks.esNulo(numAgrupacion)) {

			Filter filtroAgr = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", numAgrupacion);
			ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtroAgr);
			if (Checks.esNulo(agrupacion)) {
				throw new JsonViewerException("Esta agrupación no existe");
			}

			validarAgrupacion(agrupacion, gasto);

			if (!Checks.estaVacio(agrupacion.getActivos())) {	
						for (ActivoAgrupacionActivo activoAgrupacion : agrupacion.getActivos()) {
																
									filtroGasto = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
									gasto = genericDao.get(GastoProveedor.class, filtroGasto);

									Filter filtroCatastro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoAgrupacion.getActivo().getId());
									Order order = new Order(OrderType.DESC, "fechaRevValorCatastral");
									List<ActivoCatastro> activosCatastro = genericDao.getListOrdered(ActivoCatastro.class, order, filtroCatastro);

									GastoLineaDetalleEntidad gastoProveedorActivo = new GastoLineaDetalleEntidad();
									gastoProveedorActivo.setEntidad(activoAgrupacion.getActivo().getId());
									//TODO GASTO
									GastoLineaDetalle gastoLineaDetalle = new GastoLineaDetalle();
									gastoLineaDetalle.setGastoProveedor(gasto);
									DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class,DDSubtipoGasto.OTROS);
									gastoLineaDetalle.setSubtipoGasto(subtipoGasto);
									genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
									gastoProveedorActivo.setGastoLineaDetalle(gastoLineaDetalle);
									
									if (!Checks.estaVacio(activosCatastro)) {
										gastoProveedorActivo.setReferenciaCatastral(activosCatastro.get(0).getRefCatastral());
									}
									
									if(!Checks.estaVacio(gasto.getGastoLineaDetalleList())){
										for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
											if (!Checks.esNulo(gastoLinea.getGastoLineaEntidadList()) && !Checks.estaVacio(gastoLinea.getGastoLineaEntidadList())){
												List<GastoLineaDetalleEntidad> gastosLineaDetalleEntidadList = gastoLinea.getGastoLineaEntidadList();
												gastosLineaDetalleEntidadList.add(gastoProveedorActivo);
												this.calculaPorcentajeEquitativoGastoActivos(gastosLineaDetalleEntidadList);
											}
										}
									}

									genericDao.save(GastoLineaDetalleEntidad.class, gastoProveedorActivo);
						}
	
					}					
		} else {
			throw new JsonViewerException("Se debe pasar un activo o una agrupación");
		}

		// establecemos propietario si es necesario
		gasto = asignarPropietarioGasto(gasto);
		// volvemos a establecer la cuenta contable y partida;

		// Comprobamos si el estado del gasto cambia.
		updaterStateApi.updaterStates(gasto, null);

		genericDao.save(GastoProveedor.class, gasto);

		return true;
	}
	
	/**
	 * Valida si la agr a añadir tiene algun activo en trámite
	 * 
	 * @param agrupacion
	 * @param gasto
	 */
	private void validarAgrupacion(ActivoAgrupacion agrupacion, GastoProveedor gasto) {
		if (!Checks.estaVacio(agrupacion.getActivos())) {

			Activo activo = agrupacion.getActivos().get(0).getActivo();
			ActivoPropietario propietario = activo.getPropietarioPrincipal();
			if (!Checks.esNulo(gasto.getPropietario()) && !Checks.esNulo(propietario)) {
				if (!gasto.getPropietario().getDocIdentificativo().equals(propietario.getDocIdentificativo())) {
					throw new JsonViewerException("Propietario diferente al propietario actual del gasto");
				}
			} else {
				throw new JsonViewerException("Propietario diferente al propietario actual del gasto");
			}

			for (ActivoAgrupacionActivo activoAgrupacion : agrupacion.getActivos()) {
				if (activoAgrupacion.getActivo().getEnTramite() != null
						&& activoAgrupacion.getActivo().getEnTramite().equals(1)) {
					throw new JsonViewerException("Esta agrupación contiene activos en trámite");
				}

			}
		}
	}
	
	/**
	 * Este método recibe el activo o la agrupación de activos que se quiere asociar con el gasto
	 * y valida que no haya ningún activo de la cartera de BANKIA y de las subcarteras de
	 * Solvia, Sareb y SAREB Pre-IBERO que tenga una fecha de traspaso posterior a la fecha de 
	 * devengo del gasto.
	 * 
	 * @param idGasto: ID del gasto que se asociará con los activos.
	 * @param activo: El activo que se va a asociar con el gasto anterior.
	 * @param ActivoAgrupacion: La agrupación de activos que se quiere asociar con el gasto
	 */
	public boolean fechaDevengoPosteriorFechaTraspaso(Long idGasto, Long idActivo, Long idAgrupacion) {
		
		boolean fechaDevengoSuperior = false;
		
		GastoProveedor gasto = findOne(idGasto);
		Date gasto_fechaDevengo = gasto.getFechaEmision();
		
		if (idActivo != -1) {
			
			Activo activo = activoApi.getByNumActivo(idActivo);
			String cartera_activo = activo.getSubcartera().getCarteraCodigo();
			String subcartera_activo = activo.getSubcartera().getCodigo();
			
			if (	DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera_activo) &&
					(DDSubcartera.CODIGO_BANKIA_SOLVIA.equals(subcartera_activo) ||
					DDSubcartera.CODIGO_BANKIA_SAREB.equals(subcartera_activo) ||
					DDSubcartera.CODIGO_BANKIA_SAREB_PRE_IBERO.equals(subcartera_activo))) {
				
				Date activo_fechaTraspaso = activo.getFechaVentaExterna();
				
				if(gasto_fechaDevengo.after(activo_fechaTraspaso)){
					fechaDevengoSuperior = true;
	            }
				
			}
			
		}
		else {
			
			ActivoAgrupacion agrupacion = activoAgrupacionApi.get(activoAgrupacionApi.getAgrupacionIdByNumAgrupRem(idAgrupacion));
			List <ActivoAgrupacionActivo> activos = agrupacion.getActivos();
			
			String cartera_activo = activos.get(0).getActivo().getSubcartera().getCarteraCodigo();
			String subcartera_activo = activos.get(0).getActivo().getSubcartera().getCodigo();
			
			if (	DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera_activo) &&
					(DDSubcartera.CODIGO_BANKIA_SOLVIA.equals(subcartera_activo) ||
					DDSubcartera.CODIGO_BANKIA_SAREB.equals(subcartera_activo) ||
					DDSubcartera.CODIGO_BANKIA_SAREB_PRE_IBERO.equals(subcartera_activo))) {
				
				Date activo_fechaTraspaso = null;
				if(Checks.esNulo(activos.get(0).getActivo().getFechaVentaExterna())){
					// Obtener oferta aceptada. Si tiene, establecer expediente
					// comercial vivo a true.
					Oferta oferta = activoApi.tieneOfertaAceptada(activos.get(0).getActivo());
					if (!Checks.esNulo(oferta)) {
						// Obtener expediente comercial de la oferta aprobado.
						ExpedienteComercial exp = genericDao.get(ExpedienteComercial.class,
								genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId()));
						// Obtener datos de venta en REM.
						if (!Checks.esNulo(exp)) {
							activo_fechaTraspaso = exp.getFechaVenta();
						}
					}
				
				}else{
						
					for (int i = 0 ; i < activos.size() ; i++) {
						
						Activo act = activos.get(i).getActivo();	
						activo_fechaTraspaso = act.getFechaVentaExterna();
						
						if(gasto_fechaDevengo.after(activo_fechaTraspaso)){
							break;
			            }
						
					}
				}
				if(!Checks.esNulo(activo_fechaTraspaso) && gasto_fechaDevengo.after(activo_fechaTraspaso)){
					fechaDevengoSuperior = true;

	            }
				
			}
			
		}
		
		return fechaDevengoSuperior;
		
	}

	/**
	 * Este método recibe un listado de asociaciones de activos a un gasto y recalcula el porcentaje
	 * de participación en el gasto para cada activo de forma equitativa.
	 * 
	 * @param gastosActivosList: listado con las asociaciones de los activos y el gasto.
	 */
	private void calculaPorcentajeEquitativoGastoActivos(List<GastoLineaDetalleEntidad> gastosActivosList) {
		if (gastosActivosList == null || gastosActivosList.size() == 0) {
			return;
		}
		
		List<GastoPrinex> gastoPrinexList = new ArrayList<GastoPrinex>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idGasto",gastosActivosList.get(0).getGastoLineaDetalle().getGastoProveedor().getId());
		gastoPrinexList = genericDao.getList(GastoPrinex.class, filtro);
		if(!Checks.estaVacio(gastoPrinexList)) {
		GastoPrinex gastoPrinex = null;
		int contador = 0;
		Double porcentajePrinex = 0d;
		for (GastoLineaDetalleEntidad gastoProveedorItem : gastosActivosList) {
			
			Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "idActivo",gastoProveedorItem.getEntidad());
			gastoPrinex = genericDao.get(GastoPrinex.class, filtro,filtro3);
			if(!Checks.esNulo(gastoPrinex)) {
				contador++;
				porcentajePrinex+=gastoProveedorItem.getParticipacionGasto();
			}
		}
		
		DecimalFormat df = new DecimalFormat("##.####");
		df.setRoundingMode(RoundingMode.HALF_DOWN);
		// Calcular porcentaje equitativo.
		Double numActivos = (double) gastosActivosList.size() - contador;
		
		Double porcentaje =(double)0;
		if(numActivos > 0) {
			porcentaje = (100d-porcentajePrinex) / numActivos;
		}		
		
		//truncamos a 4 decimales
		porcentaje = Double.valueOf(df.format(porcentaje).replace(',', '.'));
		
		
		
		for (GastoLineaDetalleEntidad gastoProveedor : gastosActivosList) {
			Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "idActivo",gastoProveedor.getEntidad());
			gastoPrinex = genericDao.get(GastoPrinex.class, filtro,filtro3);
			if(Checks.esNulo(gastoPrinex)) {
				gastoProveedor.setParticipacionGasto(porcentaje);
			}
		}
		
		}else{
		
			DecimalFormat df = new DecimalFormat("##.##");
			df.setRoundingMode(RoundingMode.DOWN);
			// Calcular porcentaje equitativo.
			Double numActivos = (double) gastosActivosList.size();
			
			Double porcentaje = 100d / numActivos;
			
			//truncamos a dos decimales
			porcentaje = Double.valueOf(df.format(porcentaje).replace(',', '.'));
			
			
			Double resto = 100d - (porcentaje * numActivos);
	
			for (GastoLineaDetalleEntidad gastoProveedor : gastosActivosList) {
				gastoProveedor.setParticipacionGasto(porcentaje);
			}
			
			//si la divisón de gastos no es exacta añadimos el resto a el ultimo activo
			if(resto > 0 && gastosActivosList.size() > 0){
				GastoLineaDetalleEntidad elUltimoActivo = gastosActivosList.get(gastosActivosList.size()-1);
				elUltimoActivo.setParticipacionGasto(elUltimoActivo.getParticipacionGasto()+resto);
			}
		}
	}
	
	public float regulaPorcentajeUltimoGasto(List<GastoLineaDetalleEntidad> gastosActivosList, Float ultimoPorcentaje){
		if(Checks.esNulo(gastosActivosList) || Checks.estaVacio(gastosActivosList)){
			return ultimoPorcentaje;
		}
		
		Double porcentajeTotal = 0d;
		
		for (GastoLineaDetalleEntidad gastoProveedor : gastosActivosList){
			porcentajeTotal += gastoProveedor.getParticipacionGasto();
		}
		
		Double resto = 100d - porcentajeTotal;
		if(resto != 0){
			ultimoPorcentaje = (float) (ultimoPorcentaje + resto);
		}
		
		return ultimoPorcentaje;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateGastoActivo(DtoActivoGasto dtoActivoGasto) {

		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoGasto.getId());
			GastoLineaDetalleEntidad gastoActivo = genericDao.get(GastoLineaDetalleEntidad.class, filtro);

			if (!Checks.esNulo(dtoActivoGasto.getParticipacion())) {
				gastoActivo.setParticipacionGasto((double) dtoActivoGasto.getParticipacion());
			}

			if (!Checks.esNulo(dtoActivoGasto.getReferenciaCatastral())) {
				gastoActivo.setReferenciaCatastral(dtoActivoGasto.getReferenciaCatastral());
			}

			genericDao.update(GastoLineaDetalleEntidad.class, gastoActivo);

		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteGastoActivo(DtoActivoGasto dtoActivoGasto) {
		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoGasto.getId());
			GastoLineaDetalleEntidad gastoActivo = genericDao.get(GastoLineaDetalleEntidad.class, filtro);
			if (gastoActivo == null) {
				return false;
			}

			GastoProveedor gasto = gastoActivo.getGastoLineaDetalle().getGastoProveedor();

			// Borramos la asignación del activo.
			genericDao.deleteById(GastoLineaDetalleEntidad.class, dtoActivoGasto.getId());

			if (gasto == null) {
				return false;
			}
			 
			for(GastoLineaDetalle gastoLineaDetalle: gasto.getGastoLineaDetalleList()) {
				List <GastoLineaDetalleEntidad> gastosActivosList= gastoLineaDetalle.getGastoLineaEntidadList();
				gastosActivosList.remove(gastoActivo);
				this.calculaPorcentajeEquitativoGastoActivos(gastosActivosList);
			}
		
			genericDao.save(GastoProveedor.class, gasto);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean deleteGastoProveedor(Long id) {

		// TODO en el caso de utilizarse, se deberá tener en cuenta si se borran todas las
		// referencias del gasto.
		try {
			genericDao.deleteById(GastoProveedor.class, id);

		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}

		return true;
	}

	@SuppressWarnings("deprecation")
	public DtoInfoContabilidadGasto infoContabilidadToDtoInfoContabilidad(GastoProveedor gasto) {

		DtoInfoContabilidadGasto dto = new DtoInfoContabilidadGasto();
		if (!Checks.esNulo(gasto)) {
			DDCartera cartera = null;
			if(gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null){
				cartera = gasto.getPropietario().getCartera();
			}else if(gasto.getCartera() != null){
				cartera = gasto.getCartera();
			}
			dto.setResultadoDiarios(true);
			if(cartera != null && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(cartera.getCodigo())) {				
				gastosDiariosLbkToDto(dto, gasto);	
				ErrorDiariosLbk  errorDiariosLbk =  genericDao.get(ErrorDiariosLbk.class, genericDao.createFilter(FilterType.EQUALS, "id", gasto.getId()));
				if(errorDiariosLbk != null) {
					if(RESULTADO_OK.equalsIgnoreCase(errorDiariosLbk.getResultado())) {
						dto.setErrorDiarios(MENSAJE_OK);
					}else{
						dto.setErrorDiarios(errorDiariosLbk.getMensajeError());
						dto.setResultadoDiarios(false);
					}
					
				}
			}
			
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoInfoContabilidad contabilidadGasto = genericDao.get(GastoInfoContabilidad.class, filtro);
			
			if (!Checks.esNulo(contabilidadGasto)) {
				if (!Checks.esNulo(contabilidadGasto.getEjercicio())) {
					dto.setEjercicioImputaGasto(contabilidadGasto.getEjercicio().getId());
					if(!Checks.esNulo(contabilidadGasto.getFechaDevengoEspecial())) {
						Filter filtroFecha = genericDao.createFilter(FilterType.EQUALS, "anyo", String.valueOf(contabilidadGasto.getFechaDevengoEspecial().getYear() + 1900));
						Ejercicio ej = genericDao.get(Ejercicio.class, filtroFecha);
						dto.setEjercicioImputaGasto(ej.getId());
					}
				}
				if (!Checks.esNulo(gasto.getTipoPeriocidad())) {
					dto.setPeriodicidadDescripcion(gasto.getTipoPeriocidad().getDescripcion());
				}
				
				dto.setFechaDevengoEspecial(contabilidadGasto.getFechaDevengoEspecial());
				if (!Checks.esNulo(contabilidadGasto.getTipoPeriocidadEspecial())) {
					dto.setPeriodicidadEspecialDescripcion(contabilidadGasto.getTipoPeriocidadEspecial().getDescripcion());
				}
				
				dto.setFechaContabilizacion(contabilidadGasto.getFechaContabilizacion());
				dto.setFechaDevengoEspecial(contabilidadGasto.getFechaDevengoEspecial());
				dto.setExcluirEnvioLbk(contabilidadGasto.getExcluirEnvioLbk());
				if (!Checks.esNulo(contabilidadGasto.getContabilizadoPor())) {
					dto.setContabilizadoPorDescripcion(contabilidadGasto.getContabilizadoPor().getDescripcion());
				}
				if(!Checks.esNulo(contabilidadGasto.getActivable())){
					dto.setComboActivable(contabilidadGasto.getActivable().getCodigo());
				}
				
				if (contabilidadGasto.getGicPlanVisitas() != null) {
					if(DDSinSiNo.CODIGO_SI.equals(contabilidadGasto.getGicPlanVisitas().getCodigo())){
						dto.setGicPlanVisitasBoolean(true);
					}else {
						dto.setGicPlanVisitasBoolean(false);
					}
				}
				
				if (contabilidadGasto.getInversionSujetoPasivo() != null) {
					if(DDSinSiNo.CODIGO_SI.equals(contabilidadGasto.getInversionSujetoPasivo().getCodigo())){
						dto.setInversionSujetoPasivoBoolean(true);
					}else {
						dto.setInversionSujetoPasivoBoolean(false);
					}
				}
				
				
				
				if (contabilidadGasto.getTipoComisionadoHre() != null) {
					dto.setTipoComisionadoHreCodigo(contabilidadGasto.getTipoComisionadoHre().getCodigo());
					dto.setTipoComisionadoHreDescripcion(contabilidadGasto.getTipoComisionadoHre().getDescripcion());
				}
				
			}

		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateGastoContabilidad(DtoInfoContabilidadGasto dtoContabilidadGasto, Long idGasto) {
		
		try {
			DDSinSiNo codSiNo = new DDSinSiNo();

			GastoProveedor gasto = findOne(idGasto);
			GastoInfoContabilidad contabilidadGasto = gasto.getGastoInfoContabilidad();

			DtoInfoContabilidadGasto dtoIni = infoContabilidadToDtoInfoContabilidad(gasto);

			if (!Checks.esNulo(contabilidadGasto)) {
				
				beanUtilNotNull.copyProperties(contabilidadGasto, dtoContabilidadGasto);

				if (!Checks.esNulo(dtoContabilidadGasto.getEjercicioImputaGasto())) {
					Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "id", dtoContabilidadGasto.getEjercicioImputaGasto());
					Ejercicio ejercicio = genericDao.get(Ejercicio.class, filtroEjercicio);

					contabilidadGasto.setEjercicio(ejercicio);
				}

				if(!Checks.esNulo(dtoContabilidadGasto.getComboActivable())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoContabilidadGasto.getComboActivable());
					codSiNo = (DDSinSiNo) genericDao.get(DDSinSiNo.class, filtro);
					contabilidadGasto.setActivable(codSiNo);
				}
				
				if(dtoContabilidadGasto.getGicPlanVisitasBoolean() != null) {
					if (dtoContabilidadGasto.getGicPlanVisitasBoolean() == true) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI);
						codSiNo = genericDao.get(DDSinSiNo.class, filtro);
						contabilidadGasto.setGicPlanVisitas(codSiNo);
					} else {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO);
						codSiNo = genericDao.get(DDSinSiNo.class, filtro);
						contabilidadGasto.setGicPlanVisitas(codSiNo);
					}
				}
				
				if(dtoContabilidadGasto.getInversionSujetoPasivoBoolean() != null) {
					if (dtoContabilidadGasto.getInversionSujetoPasivoBoolean() == true) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI);
						codSiNo = genericDao.get(DDSinSiNo.class, filtro);
						contabilidadGasto.setInversionSujetoPasivo(codSiNo);
					} else {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO);
						codSiNo = genericDao.get(DDSinSiNo.class, filtro);
						contabilidadGasto.setInversionSujetoPasivo(codSiNo);
					}
				}
				if(dtoContabilidadGasto.getIdSubpartidaPresupuestaria() != null) {
					Filter filtroSubpartidaPresupuestaria = genericDao.createFilter(FilterType.EQUALS, "id", dtoContabilidadGasto.getIdSubpartidaPresupuestaria());
					ConfiguracionSubpartidasPresupuestarias cps = genericDao.get(ConfiguracionSubpartidasPresupuestarias.class, filtroSubpartidaPresupuestaria);
					
					contabilidadGasto.setConfiguracionSubpartidasPresupuestarias(cps);
				}
				
				if(dtoContabilidadGasto.getTipoComisionadoHreCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoContabilidadGasto.getTipoComisionadoHreCodigo());
					DDTipoComisionado tipoComision = genericDao.get(DDTipoComisionado.class, filtro);
					contabilidadGasto.setTipoComisionadoHre(tipoComision);
				}
				


				gasto.setGastoInfoContabilidad(contabilidadGasto);
			}			
			
			updateEjercicio(gasto);
			DtoInfoContabilidadGasto dtoFin = infoContabilidadToDtoInfoContabilidad(gasto);
			
			boolean cambios = hayCambiosGasto(dtoIni, dtoFin, gasto);
		
			if(!cambios && (DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo()) 
					|| DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo()) 
					|| DDEstadoGasto.SUBSANADO.equals(gasto.getEstadoGasto().getCodigo()))) {
				//updaterStateApi.updaterStates(gasto, gasto.getEstadoGasto().getCodigo());
			}else {
				updaterStateApi.updaterStates(gasto, null);
			}
			
			genericDao.update(GastoProveedor.class, gasto);

			return true;

		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}
	}


	@SuppressWarnings("unchecked")
	private boolean hayCambiosGasto(Object dtoIni, Object dtoFin, GastoProveedor gasto) {
		String[] camposMinimos = new String[]{"numGastoHaya", "numGastoGestoria", "referenciaEmisor", "tipoGastoCodigo", "subtipoGastoCodigo", "idEmisor", "destinatario", "propietario", "fechaEmision", "periodicidad", "concepto", "tipoOperacionCodigo", "importeTotal", "impuestoIndirectoTipoCodigo", "asignadoAActivos", "gestoria", "fechaAltaRem"};
		List<String> campos = new ArrayList<String>(Arrays.asList(camposMinimos));
		boolean coniva = Checks.esNulo(gasto.getGestoria());
		boolean cambios = false;
		if(coniva) {
			campos.remove("numGastoGestoria");
			campos.remove("gestoria");
		}else {
			campos.remove("concepto");
			campos.remove("impuestoIndirectoTipoCodigo");
		}
		PropertyDescriptor[] objDescriptors = PropertyUtils.getPropertyDescriptors(dtoIni);
		for (PropertyDescriptor objDescriptor : objDescriptors) {
            try {
            	
                String propertyName = objDescriptor.getName();
                Object propValueIni = PropertyUtils.getProperty(dtoIni, propertyName);
                Object propValueFin = PropertyUtils.getProperty(dtoFin, propertyName);
                if(campos.contains(propertyName)) {
	                if(!Checks.esNulo(propValueIni) && !propValueIni.equals(propValueFin))
	                	cambios = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
		return cambios;
	}
	
	public DtoGestionGasto gestionToDtoGestion(GastoProveedor gasto) {
		DtoGestionGasto dtoGestion = new DtoGestionGasto();

		if (!Checks.esNulo(gasto)) {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoGestion gastoGestion = genericDao.get(GastoGestion.class, filtro);

			if (!Checks.esNulo(gastoGestion)) {

				dtoGestion.setNecesariaAutorizacionPropietario(gastoGestion.getAutorizaPropietario());
				if (!Checks.esNulo(gastoGestion.getMotivoAutorizacionPropietario())) {
					dtoGestion.setComboMotivoAutorizacionPropietario(gastoGestion.getMotivoAutorizacionPropietario().getCodigo());
				}
				if (!Checks.esNulo(gasto.getGestoria())) {
					dtoGestion.setGestoria(gasto.getGestoria().getNombre());
				}
				if (!Checks.esNulo(gasto.getProvision())) {
					dtoGestion.setNumProvision(gasto.getProvision().getNumProvision());
				}
				dtoGestion.setObservaciones(gastoGestion.getObservaciones());
				//////
				dtoGestion.setFechaAltaRem(gastoGestion.getFechaAlta());

				if (!Checks.esNulo(gastoGestion.getUsuarioAlta())) {
					dtoGestion.setGestorAltaRem(gastoGestion.getUsuarioAlta().getApellidoNombre());
				}
				////

				if (!Checks.esNulo(gastoGestion.getEstadoAutorizacionHaya())) {
					dtoGestion.setComboEstadoAutorizacionHaya(gastoGestion.getEstadoAutorizacionHaya().getCodigo());
				}

				dtoGestion.setFechaAutorizacionHaya(gastoGestion.getFechaEstadoAutorizacionHaya());

				if (!Checks.esNulo(gastoGestion.getUsuarioEstadoAutorizacionHaya())) {
					dtoGestion.setGestorAutorizacionHaya(gastoGestion.getUsuarioEstadoAutorizacionHaya().getApellidoNombre());
				}
				if (!Checks.esNulo(gastoGestion.getMotivoRechazoAutorizacionHaya()) && gastoGestion.getEstadoAutorizacionHaya().getCodigo().equals(DDEstadoAutorizacionHaya.CODIGO_RECHAZADO)) {
					dtoGestion.setComboMotivoRechazoHaya(gastoGestion.getMotivoRechazoAutorizacionHaya().getCodigo());
				}
				////

				if (!Checks.esNulo(gastoGestion.getEstadoAutorizacionPropietario())) {
					dtoGestion.setComboEstadoAutorizacionPropietario(gastoGestion.getEstadoAutorizacionPropietario().getCodigo());
				}
				
				if(!Checks.esNulo(gastoGestion.getEstadoAutorizacionPropietario()) && !DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE.equals(gastoGestion.getEstadoAutorizacionPropietario().getCodigo())) {
					dtoGestion.setFechaAutorizacionPropietario(gastoGestion.getFechaEstadoAutorizacionPropietario());
				}
				
				if (!Checks.esNulo(gastoGestion.getMotivoRechazoAutorizacionPropietario()) && !DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE.equals(gastoGestion.getEstadoAutorizacionPropietario().getCodigo())) {
					dtoGestion.setMotivoRechazoAutorizacionPropietario(gastoGestion.getMotivoRechazoAutorizacionPropietario());
				}

				////////////////

				dtoGestion.setFechaAnulado(gastoGestion.getFechaAnulacionGasto());

				if (!Checks.esNulo(gastoGestion.getUsuarioAnulacion())) {
					dtoGestion.setGestorAnulado(gastoGestion.getUsuarioAnulacion().getApellidoNombre());
				}
				if (!Checks.esNulo(gastoGestion.getMotivoAnulacion())) {
					dtoGestion.setComboMotivoAnulado(gastoGestion.getMotivoAnulacion().getCodigo());
				}
				////////////////

				dtoGestion.setFechaRetenerPago(gastoGestion.getFechaRetencionPago());

				if (!Checks.esNulo(gastoGestion.getUsuarioRetencionPago())) {
					dtoGestion.setGestorRetenerPago(gastoGestion.getUsuarioRetencionPago().getApellidoNombre());
				}
				if (!Checks.esNulo(gastoGestion.getMotivoRetencionPago())) {
					dtoGestion.setComboMotivoRetenerPago(gastoGestion.getMotivoRetencionPago().getCodigo());
				}
			}
		}

		return dtoGestion;
	}

	@Transactional(readOnly = false)
	public boolean updateGestionGasto(DtoGestionGasto dtoGestionGasto, Long idGasto) {
		try {
			Usuario usuario = genericAdapter.getUsuarioLogado();

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
			GastoProveedor gasto = genericDao.get(GastoProveedor.class, filtro);

			if (!Checks.esNulo(gasto)) {

				GastoGestion gestionGasto = gasto.getGastoGestion();

				if (!Checks.esNulo(gestionGasto)) {

					beanUtilNotNull.copyProperties(gestionGasto, dtoGestionGasto);

					if (!Checks.esNulo(dtoGestionGasto.getNecesariaAutorizacionPropietario())) {
						gestionGasto.setAutorizaPropietario(dtoGestionGasto.getNecesariaAutorizacionPropietario());
					}
					if (("").equals(dtoGestionGasto.getComboMotivoAutorizacionPropietario())) {
						gestionGasto.setMotivoAutorizacionPropietario(null);
					}
					if (!Checks.esNulo(dtoGestionGasto.getComboMotivoAutorizacionPropietario()) && !dtoGestionGasto.getComboMotivoAutorizacionPropietario().equals("")) {
						DDMotivoAutorizacionPropietario motivoAutoPro = (DDMotivoAutorizacionPropietario) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDMotivoAutorizacionPropietario.class, dtoGestionGasto.getComboMotivoAutorizacionPropietario());
						gestionGasto.setMotivoAutorizacionPropietario(motivoAutoPro);

					}
					if (!Checks.esNulo(dtoGestionGasto.getComboEstadoAutorizacionHaya())) {
						DDEstadoAutorizacionHaya estadoAutoHaya = (DDEstadoAutorizacionHaya) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionHaya.class,
								dtoGestionGasto.getComboEstadoAutorizacionHaya());
						gestionGasto.setEstadoAutorizacionHaya(estadoAutoHaya);
						gestionGasto.setFechaEstadoAutorizacionHaya(new Date());
						gestionGasto.setUsuarioEstadoAutorizacionHaya(usuario);
					}
					if (!Checks.esNulo(dtoGestionGasto.getComboMotivoRechazoHaya())) {
						DDMotivoRechazoAutorizacionHaya motivoAutoHaya = (DDMotivoRechazoAutorizacionHaya) utilDiccionarioApi
								.dameValorDiccionarioByCod(DDMotivoRechazoAutorizacionHaya.class, dtoGestionGasto.getComboMotivoRechazoHaya());
						gestionGasto.setMotivoRechazoAutorizacionHaya(motivoAutoHaya);
					}
					if (!Checks.esNulo(dtoGestionGasto.getComboMotivoAnulado())) {
						
						if(!Checks.esNulo(gasto.getEstadoGasto()) && DDEstadoGasto.RETENIDO.equals(gasto.getEstadoGasto().getCodigo())){
							throw new JsonViewerException("El gasto no se puede anular porque está retenido");
						}
						
						DDMotivoAnulacionGasto motivoAnulacion = (DDMotivoAnulacionGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoAnulacionGasto.class,
								dtoGestionGasto.getComboMotivoAnulado());
						gestionGasto.setMotivoAnulacion(motivoAnulacion);
						gestionGasto.setFechaAnulacionGasto(new Date());
						gestionGasto.setUsuarioAnulacion(usuario);

						// Al anular el gasto borro los estados de autorización y retener pago
						gestionGasto.setEstadoAutorizacionHaya(null);
						gestionGasto.setFechaEstadoAutorizacionHaya(null);
						gestionGasto.setUsuarioEstadoAutorizacionHaya(null);
						gestionGasto.setMotivoRechazoAutorizacionHaya(null);

						gestionGasto.setEstadoAutorizacionPropietario(null);
						gestionGasto.setFechaEstadoAutorizacionPropietario(null);
						gestionGasto.setMotivoRechazoAutorizacionPropietario(null);

						gestionGasto.setFechaRetencionPago(null);
						gestionGasto.setUsuarioRetencionPago(null);
						gestionGasto.setMotivoRetencionPago(null);
						// Actualizamos el estado del gasto a anulado
						updaterStateApi.updaterStates(gasto, DDEstadoGasto.ANULADO);

						List <GastoLineaDetalle> listaLineasGasto = gasto.getGastoLineaDetalleList();
						for(GastoLineaDetalle linea : listaLineasGasto) {
							List<GastoLineaDetalleTrabajo> listaGastoTrabajo =linea.getGastoLineaTrabajoList();
							for(GastoLineaDetalleTrabajo gastoTrabajo :listaGastoTrabajo) {
								Trabajo trabajo = gastoTrabajo.getTrabajo();
								trabajo.setFechaEmisionFactura(null);
								genericDao.save(Trabajo.class, trabajo);
								genericDao.deleteById(GastoLineaDetalleTrabajo.class, gastoTrabajo.getId());
							}
						}
					}
					
					if (!Checks.esNulo(dtoGestionGasto.getComboMotivoRetenerPago())) {
						DDMotivoRetencionPago retenerPago = (DDMotivoRetencionPago) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRetencionPago.class,
								dtoGestionGasto.getComboMotivoRetenerPago());
						gestionGasto.setMotivoRetencionPago(retenerPago);
						gestionGasto.setFechaRetencionPago(new Date());
						gestionGasto.setUsuarioRetencionPago(usuario);
						updaterStateApi.updaterStates(gasto, DDEstadoGasto.RETENIDO);
					} else if (Checks.esNulo(dtoGestionGasto.getComboMotivoRetenerPago())) {
						// Si borro el campo eliminamos los detalles de retencion y ponemos el gasto en estado incompleto o pendiente.
						gestionGasto.setMotivoRetencionPago(null);
						gestionGasto.setFechaRetencionPago(null);
						gestionGasto.setUsuarioRetencionPago(null);
						gasto.setGastoGestion(gestionGasto);
						// HREOS-1927: si se quita la retención en el estado vuelve a ser Pendiente
						
						if(DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo()) 
								|| DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo()) 
								|| DDEstadoGasto.SUBSANADO.equals(gasto.getEstadoGasto().getCodigo())) {
							updaterStateApi.updaterStates(gasto, gasto.getEstadoGasto().getCodigo());
						}else {
							updaterStateApi.updaterStates(gasto, null);
						}
					}

					gasto.setGastoGestion(gestionGasto);
				}
				genericDao.update(GastoProveedor.class, gasto);

				return true;
			}
		}catch (JsonViewerException ex) {
			throw new JsonViewerException(ex.getMessage());
		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}

		return false;
	}

	public DtoImpugnacionGasto impugnaciontoDtoImpugnacion(GastoProveedor gasto) {

		DtoImpugnacionGasto dtoImpugnacion = new DtoImpugnacionGasto();

		if (!Checks.esNulo(gasto)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoImpugnacion gastoImpugnacion = genericDao.get(GastoImpugnacion.class, filtro);

			if (!Checks.esNulo(gastoImpugnacion)) {
				dtoImpugnacion.setFechaTope(gastoImpugnacion.getFechaTope());
				dtoImpugnacion.setFechaPresentacion(gastoImpugnacion.getFechaPresentacion());
				dtoImpugnacion.setFechaResolucion(gastoImpugnacion.getFechaResolucion());

				if (!Checks.esNulo(gastoImpugnacion.getResultadoImpugnacion())) {
					dtoImpugnacion.setResultadoCodigo(gastoImpugnacion.getResultadoImpugnacion().getCodigo());
				}
				dtoImpugnacion.setObservaciones(gastoImpugnacion.getObservaciones());
			}
		}

		return dtoImpugnacion;
	}

	@Transactional(readOnly = false)
	public boolean updateImpugnacionGasto(DtoImpugnacionGasto dto, Long idGasto) {

		try {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
			GastoImpugnacion gastoImpugnacion = genericDao.get(GastoImpugnacion.class, filtro);

			if (Checks.esNulo(gastoImpugnacion)) {
				gastoImpugnacion = new GastoImpugnacion();
			}

			beanUtilNotNull.copyProperties(gastoImpugnacion, dto);
			
			if(Checks.esNulo(gastoImpugnacion.getGastoProveedor())){
				Filter filtroGasto= genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
				GastoProveedor gasto= genericDao.get(GastoProveedor.class, filtroGasto);
				gastoImpugnacion.setGastoProveedor(gasto);
			}
			

			if (!Checks.esNulo(dto.getResultadoCodigo())) {
				DDResultadoImpugnacionGasto resultado = (DDResultadoImpugnacionGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoImpugnacionGasto.class,
						dto.getResultadoCodigo());
				gastoImpugnacion.setResultadoImpugnacion(resultado);
			}

			if (Checks.esNulo(gastoImpugnacion.getId())) {
				genericDao.save(GastoImpugnacion.class, gastoImpugnacion);
			} else {
				genericDao.update(GastoImpugnacion.class, gastoImpugnacion);
			}
			return true;

		} catch (Exception e) {
			return false;
		}
	}

	@Transactional(readOnly = false)
	public boolean asignarTrabajos(Long idGasto, Long[] trabajos) {

		GastoProveedor gasto = findOne(idGasto);
		int cont = 0;

		for (Long idTrabajo : trabajos) {			
			
			List<GastoLineaDetalleTrabajo> gastosTrabajo = genericDao.getList(GastoLineaDetalleTrabajo.class, 
					genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.gastoProveedor.id", gasto.getId()),
					genericDao.createFilter(FilterType.EQUALS, "trabajo.id", idTrabajo));
			
			if(Checks.estaVacio(gastosTrabajo)) {
				Trabajo trabajo = trabajoApi.findOne(idTrabajo);
				// Marcamos la fecha de emisión de factura en el trabajo
				trabajo.setFechaEmisionFactura(gasto.getFechaEmision());
				genericDao.save(Trabajo.class, trabajo);
	
				// Asignamos el trabajo al gasto
				GastoLineaDetalleTrabajo gastoTrabajo = new GastoLineaDetalleTrabajo();
				gastoTrabajo.setTrabajo(trabajo);
	
				genericDao.save(GastoLineaDetalleTrabajo.class, gastoTrabajo);
				for(GastoLineaDetalle lineaDetalle : gasto.getGastoLineaDetalleList()) {
					lineaDetalle.getGastoLineaTrabajoList().add(gastoTrabajo);
				}
	
				// Asignamos los activos del trabajo al gasto
	
				gasto = asignarActivos(gasto, trabajo);
				cont++;
			}
		}
		if(cont > 0) {
			gasto = calcularImportesDetalleEconomicoGasto(gasto);
	
			gasto = calcularParticipacionActivosGasto(gasto);
	
			gasto = asignarPropietarioGasto(gasto);
	
			//gasto = asignarCuentaContableYPartidaGasto(gasto);
	
			updaterStateApi.updaterStates(gasto, null);
	
			genericDao.save(GastoProveedor.class, gasto);
		}

		return true;
	}

	private GastoProveedor asignarActivos(GastoProveedor gasto, Trabajo trabajo) {

		for (ActivoTrabajo activo : trabajo.getActivosTrabajo()) {

			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "entidad", activo.getActivo().getId());
			Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoLineaDetalleEntidad gastoActivo = genericDao.get(GastoLineaDetalleEntidad.class, filtroActivo, filtroGasto);

			// Si no existe ya
			if (Checks.esNulo(gastoActivo)) {
				gastoActivo = new GastoLineaDetalleEntidad();
				gastoActivo.setEntidad(activo.getActivo().getId());
				//TODO GASTO
				GastoLineaDetalle gastoLineaDetalle = new GastoLineaDetalle();
				gastoLineaDetalle.setGastoProveedor(gasto);
				DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class,DDSubtipoGasto.OTROS);
				gastoLineaDetalle.setSubtipoGasto(subtipoGasto);
				genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
				
				gastoActivo.setGastoLineaDetalle(gastoLineaDetalle);
				gastoActivo.setParticipacionGasto((double)activo.getParticipacion());

				genericDao.save(GastoLineaDetalleEntidad.class, gastoActivo);
				if(!Checks.estaVacio(gasto.getGastoLineaDetalleList())){
					for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
						if (!Checks.esNulo(gastoLinea.getGastoLineaEntidadList()) && !Checks.estaVacio(gastoLinea.getGastoLineaEntidadList())){
							gastoLinea.getGastoLineaEntidadList().add(gastoActivo);
						}
					}
				}
			}
		}

		return gasto;
	}

	@Override
	@BusinessOperationDefinition("gastoProveedorManager.getAdjuntosGasto")
	@Transactional(readOnly = false)
	public List<DtoAdjunto> getAdjuntos(Long id) throws GestorDocumentalException {

		GastoProveedor gasto = findOne(id);
		Usuario usuario = genericAdapter.getUsuarioLogado();

		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();

		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {

			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosGasto(gasto.getNumGastoHaya().toString());

				if (listaAdjuntos.isEmpty()) {
					updateExisteDocumentoGasto(gasto, 0);
				} else {
					
					updateExisteDocumentoGasto(gasto, 1);
					
					for (DtoAdjunto adj : listaAdjuntos) {

						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", adj.getMatricula());
						DDTipoDocumentoGasto tipoDocumento = (DDTipoDocumentoGasto) genericDao.get(DDTipoDocumentoGasto.class, filtro);

						// Esta es la única información que tenemos en el gestor documental.
						if (!Checks.esNulo(tipoDocumento)) {
							adj.setCodigoTipo(tipoDocumento.getDescripcion());
							adj.setDescripcionTipo(tipoDocumento.getDescripcion());
						}
						adj.setFechaDocumento(adj.getFechaDocumento());
					}
				}

			} catch (GestorDocumentalException gex) {
				
				// Si no existe el expediente lo creamos
				if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {

					Integer idExpediente;
					try {
						idExpediente = gestorDocumentalAdapterApi.crearGasto(gasto, usuario.getUsername());
						logger.debug("GESTOR DOCUMENTAL [ crearGasto para " + gasto.getNumGastoHaya() + "]: ID EXPEDIENTE RECIBIDO " + idExpediente);
					} catch (GestorDocumentalException gexc) {
						logger.debug(gexc.getMessage(),gexc);
					}
				}

				throw gex;
			}

		} else {

			List<AdjuntoGasto> adjuntosGasto = gasto.getAdjuntos();

			for (AdjuntoGasto adjunto : adjuntosGasto) {
				DtoAdjunto dto = new DtoAdjunto();

				try {
					BeanUtils.copyProperties(dto, adjunto);
				} catch (IllegalAccessException e) {
					logger.error(e.getMessage());

				} catch (InvocationTargetException e) {
					logger.error(e.getMessage());
				}
				dto.setIdEntidad(gasto.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoGasto().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());
				dto.setFechaDocumento(adjunto.getFechaDocumento());

				listaAdjuntos.add(dto);
			}
		}

		return listaAdjuntos;
	}

	@Override
	@BusinessOperation(overrides = "gastoProveedorManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem fileItem) {

		GastoProveedor gasto = findOne(Long.parseLong(fileItem.getParameter("idEntidad")));

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
		DDTipoDocumentoGasto tipoDocumento = (DDTipoDocumentoGasto) genericDao.get(DDTipoDocumentoGasto.class, filtro);

		try {

			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				try {
					Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoGasto(gasto, fileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());
					AdjuntoGasto adjuntoGasto = createAdjuntoGasto(fileItem, gasto, idDocRestClient);
					gasto.getAdjuntos().add(adjuntoGasto);
				} catch (GestorDocumentalException gex) {
					// Si no existe el expediente lo creamos
					if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {
						return "No existe el expediente en el gestor documental";
					} else {
						logger.error(gex.getMessage());
						return gex.getMessage();
					}
				}

			} else {
				AdjuntoGasto adjuntoGasto = createAdjuntoGasto(fileItem, gasto, null);
				gasto.getAdjuntos().add(adjuntoGasto);
			}

			boolean tieneIva = Checks.esNulo(gasto.getGestoria());
			String nuevoEstado = checkReglaCambioEstado(gasto.getEstadoGasto().getCodigo(), tieneIva,
  					tipoDocumento.getMatricula(), gasto);
			updateExisteDocumentoGasto(gasto, 1);
  			//if (!Checks.esNulo(nuevoEstado)) {
  				updaterStateApi.updaterStates(gasto, nuevoEstado);
  			//}
			
			// TODO Falta definir que tipo de documento provoca marcar el campo existeDocumento.
			

			// Comprobamos si ha cambiado el estado del gasto.
			//updaterStateApi.updaterStates(gasto, null);
			genericDao.save(GastoProveedor.class, gasto);

		} catch (Exception e) {
			logger.error(e.getMessage());
			return e.getMessage();
		}

		return null;
	}
	@Override
	public AdjuntoGasto createAdjuntoGasto(WebFileItem fileItem, GastoProveedor gasto, Long idDocRestClient) throws Exception {

		AdjuntoGasto adjuntoGasto = new AdjuntoGasto();
		Adjunto adj = null;
		if (Checks.esNulo(idDocRestClient))
			adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
		else {
			adjuntoGasto.setIdDocRestClient(idDocRestClient);
		}
		adjuntoGasto.setAdjunto(adj);

		adjuntoGasto.setGastoProveedor(gasto);

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
		DDTipoDocumentoGasto tipoDocumento = (DDTipoDocumentoGasto) genericDao.get(DDTipoDocumentoGasto.class, filtro);
		adjuntoGasto.setTipoDocumentoGasto(tipoDocumento);

		adjuntoGasto.setContentType(fileItem.getFileItem().getContentType());

		adjuntoGasto.setTamanyo(fileItem.getFileItem().getLength());

		adjuntoGasto.setNombre(fileItem.getFileItem().getFileName());

		adjuntoGasto.setDescripcion(fileItem.getParameter("descripcion"));

		adjuntoGasto.setFechaDocumento(new Date());

		Auditoria.save(adjuntoGasto);

		return adjuntoGasto;
	}

	@Override
	@BusinessOperation(overrides = "gastoProveedorManager.deleteAdjunto")
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {

		boolean borrado = false;
		GastoProveedor gasto = findOne(dtoAdjunto.getIdEntidad());
		AdjuntoGasto adjuntoGasto;

		try {
			// Borramos en el gestor documental si hay, y buscamos el adjunto de BBDD para borrarlo
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());

			} else {
				adjuntoGasto = gasto.getAdjunto(dtoAdjunto.getId());
				if (adjuntoGasto == null) {
					return false;
				}
				gasto.getAdjuntos().remove(adjuntoGasto);

				if (gasto.getAdjuntos().isEmpty()) {
					updateExisteDocumentoGasto(gasto, 0);
				}
				updaterStateApi.updaterStates(gasto, null);
				genericDao.save(GastoProveedor.class, gasto);
			}
			borrado = true;

		} catch (Exception ex) {
			logger.debug(ex.getMessage());
			borrado = false;
		}

		return borrado;
	}

	@Override
	@BusinessOperationDefinition("gastoProveedorManager.getFileItemAdjunto")
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto) {

		AdjuntoGasto adjuntoGasto = null;
		FileItem fileItem = null;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				// adjuntoGasto= gasto.getAdjuntoGD(dtoAdjunto.getId());
				fileItem = gestorDocumentalAdapterApi.getFileItem(dtoAdjunto.getId(),dtoAdjunto.getNombre());//MODIFICAR
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		} else {
			GastoProveedor gasto = findOne(dtoAdjunto.getIdEntidad());
			adjuntoGasto = gasto.getAdjunto(dtoAdjunto.getId());
			fileItem = adjuntoGasto.getAdjunto().getFileItem();
			fileItem.setContentType(adjuntoGasto.getContentType());
			fileItem.setFileName(adjuntoGasto.getNombre());
		}

		return fileItem;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean desasignarTrabajos(Long idGasto, Long[] ids) {

		GastoProveedor gasto = findOne(idGasto);

		// Desasignamos los trabajo del gasto
		for (Long id : ids) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", id);
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.gastoProveedor.id", gasto.getId());
			GastoLineaDetalleTrabajo gastoTrabajoEliminado = genericDao.get(GastoLineaDetalleTrabajo.class, filtro, filtro2);
			if (!Checks.esNulo(gastoTrabajoEliminado)) {
				gastoDao.deleteGastoTrabajoById(gastoTrabajoEliminado.getId());
			}

			Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "id", id);
			Trabajo trabajo = genericDao.get(Trabajo.class, filtroTrabajo);
			trabajo.setFechaEmisionFactura(null);
			genericDao.save(Trabajo.class, trabajo);
		}

		// Desasignamos TODOS los activos
		
		if(!Checks.estaVacio(gasto.getGastoLineaDetalleList())){
			for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
				if (!Checks.esNulo(gastoLinea.getGastoLineaEntidadList())){
					for (GastoLineaDetalleEntidad gastoActivo : gastoLinea.getGastoLineaEntidadList()) {
						genericDao.deleteById(GastoLineaDetalleEntidad.class, gastoActivo.getId());
					}
					gastoLinea.getGastoLineaEntidadList().clear();
				}
			}
		}


		// Volvemos a asignar los activos de los trabajos que queden
		for(GastoLineaDetalle gastoLinea : gasto.getGastoLineaDetalleList()) {
			for(GastoLineaDetalleTrabajo gastoTrabajo: gastoLinea.getGastoLineaTrabajoList()) {
				asignarActivos(gasto, gastoTrabajo.getTrabajo());
			}
		}

		// Calculamos importe y participación
		gasto = calcularImportesDetalleEconomicoGasto(gasto);

		gasto = calcularParticipacionActivosGasto(gasto);

		//gasto = asignarPropietarioGasto(gasto);

		//gasto = asignarCuentaContableYPartidaGasto(gasto);

		updaterStateApi.updaterStates(gasto, null);

		genericDao.save(GastoProveedor.class, gasto);

		return true;
	}

	@Override
	public List<VBusquedaGastoTrabajos> getListTrabajosGasto(Long idGasto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idGasto", idGasto);

		return genericDao.getList(VBusquedaGastoTrabajos.class, filtro);
	}

	private GastoProveedor calcularImportesDetalleEconomicoGasto(GastoProveedor gasto) {

		Double importeGasto = new Double(0);
		Double importeProvisionesSuplidos = new Double(0);
		
		for(GastoLineaDetalle gastoLinea : gasto.getGastoLineaDetalleList()) {
			for(GastoLineaDetalleTrabajo gastoTrabajo: gastoLinea.getGastoLineaTrabajoList()) {
				if (!Checks.esNulo(gastoTrabajo.getTrabajo().getImporteTotal())) {
					importeGasto += gastoTrabajo.getTrabajo().getImporteTotal();
				}
				if (!Checks.esNulo(gastoTrabajo.getTrabajo().getImporteProvisionesSuplidos())) {
					importeProvisionesSuplidos += gastoTrabajo.getTrabajo().getImporteProvisionesSuplidos();
				}
			}
		}
		
		gasto.getGastoDetalleEconomico().setImporteTotal(importeGasto + importeProvisionesSuplidos);

		return gasto;
	}

	public GastoProveedor calcularParticipacionActivosGasto(GastoProveedor gasto) {

		Double importeTotal = gastoLineaDetalleApi.calcularPrincipioSujetoLineasDetalle(gasto);
		importeTotal = Checks.esNulo(importeTotal) ? new Double("0L") : importeTotal;
		Map<Long, Double> mapa = new HashMap<Long, Double>();

		for(GastoLineaDetalle gastoLinea : gasto.getGastoLineaDetalleList()) {
			for(GastoLineaDetalleTrabajo gastoTrabajo: gastoLinea.getGastoLineaTrabajoList()) {
				Double importeTrabajo = gastoTrabajo.getTrabajo().getImporteTotal();
				if (!Checks.esNulo(importeTrabajo)) {
					for (ActivoTrabajo activoTrabajo : gastoTrabajo.getTrabajo().getActivosTrabajo()) {
						Activo activo = activoTrabajo.getActivo();
						Float participacion = activoTrabajo.getParticipacion();
						if (mapa.containsKey(activo.getId())) {
							Double importe = mapa.get(activo.getId());
							mapa.put(activo.getId(), importe + importeTrabajo * participacion / 100);
						} else {
							mapa.put(activo.getId(), importeTrabajo * participacion / 100);
						}
					}
				}
			}
		}
		if(!Checks.estaVacio(gasto.getGastoLineaDetalleList())){
			for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
				if (!Checks.esNulo(gastoLinea.getGastoLineaEntidadList())){
					for (GastoLineaDetalleEntidad gastoActivo : gastoLinea.getGastoLineaEntidadList()) {
						Long idActivo = gastoActivo.getEntidad();
						if (!mapa.isEmpty() && !Checks.esNulo(mapa.get(idActivo))) {
							gastoActivo.setParticipacionGasto((double) (mapa.get(idActivo) * 100d / importeTotal));
						}
					}
				}
			}
		}

		return gasto;
	}

	public boolean esGastoEditable(GastoProveedor gasto) {

		Usuario usuario = genericAdapter.getUsuarioLogado();
		
		Boolean esGastoEditable = true;

		if (!genericAdapter.tienePerfil("HAYASADM", usuario)) {	
			
			if(!Checks.esNulo(gasto.getEstadoGasto()) && (
					DDEstadoGasto.RETENIDO.equals(gasto.getEstadoGasto().getCodigo()) ||
					DDEstadoGasto.ANULADO.equals(gasto.getEstadoGasto().getCodigo()) )){
				
				esGastoEditable =  false;
			}		

		}

		return esGastoEditable;
	}

	public Object searchProveedorCodigoByTipoEntidad(String codigoUnicoProveedor, String codigoTipoProveedor) {
		DtoActivoProveedor dto = new DtoActivoProveedor();
		List<ActivoProveedor> listaProveedores = new ArrayList<ActivoProveedor>();
		Filter filtroCodigo = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", Long.parseLong(codigoUnicoProveedor));
		// DDTipoEntidad tipoEntidad = (DDTipoEntidad)
		// utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoEntidad.class, codigoTipoEntidad);
		Filter filtroEntidad = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.tipoEntidadProveedor.codigo", codigoTipoProveedor);

		listaProveedores = genericDao.getList(ActivoProveedor.class, filtroCodigo, filtroEntidad);

		if (!Checks.estaVacio(listaProveedores)) {
			ActivoProveedor activoProveedor = listaProveedores.get(0);

			dto.setId(activoProveedor.getId());
			dto.setNombreProveedor(activoProveedor.getNombre());
			dto.setNifProveedor(activoProveedor.getDocIdentificativo());
			if (!Checks.esNulo(activoProveedor.getTipoProveedor()) && !Checks.esNulo(activoProveedor.getTipoProveedor().getTipoEntidadProveedor())) {
				dto.setSubtipoProveedorDescripcion(activoProveedor.getTipoProveedor().getTipoEntidadProveedor().getDescripcion());
			}

			return dto;
		}

		return null;
	}

	public Object searchGastoNumHaya(String numeroGastoHaya, String proveedorEmisor, String destinatario) {

		List<GastoProveedor> listaGastos = new ArrayList<GastoProveedor>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(numeroGastoHaya));
		listaGastos = genericDao.getList(GastoProveedor.class, filtro);

		DDDestinatarioGasto destinatarioGasto = (DDDestinatarioGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioGasto.class, destinatario);

		if (!Checks.estaVacio(listaGastos)) {
			GastoProveedor gasto = listaGastos.get(0);
			if (!Checks.esNulo(gasto.getProveedor()) && !Checks.esNulo(proveedorEmisor)) {
				if (gasto.getProveedor().getCodigoProveedorRem().equals(Long.parseLong(proveedorEmisor)) && gasto.getDestinatarioGasto().equals(destinatarioGasto)) {
					return gasto;
				}
			}

		}

		return null;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean autorizarGastos(Long[] idsGastos) {

		for (Long id : idsGastos) {

			autorizarGasto(id, true);
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean autorizarGasto(Long idGasto, boolean validarAutorizacion) {

		GastoProveedor gasto = findOne(idGasto);
		DDEstadoAutorizacionHaya estadoAutorizacionHaya = (DDEstadoAutorizacionHaya) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionHaya.class,
				DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO);
		
		DDEstadoAutorizacionPropietario estadoAutorizacionPropietario= (DDEstadoAutorizacionPropietario) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionPropietario.class,
				DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);

		if (validarAutorizacion) {
			String error = updaterStateApi.validarCamposMinimos(gasto,true);
			
			if(error == null && updaterStateApi.isGastoSuplido(gasto)) {
				error = updaterStateApi.validarDatosPagoGastoPrincipal(gasto);
			}
			
			if (!Checks.esNulo(error)) {
				throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede autorizar: " + error);
			}
		}

		GastoGestion gastoGestion = gasto.getGastoGestion();
		gastoGestion.setEstadoAutorizacionHaya(estadoAutorizacionHaya);
		//Poner el estado autorizado propietario pendiente
		gastoGestion.setEstadoAutorizacionPropietario(estadoAutorizacionPropietario);
		gastoGestion.setUsuarioEstadoAutorizacionHaya(genericAdapter.getUsuarioLogado());
		gastoGestion.setFechaEstadoAutorizacionHaya(new Date());
		gastoGestion.setMotivoRechazoAutorizacionHaya(null);
		gastoGestion.getAuditoria().setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
		gastoGestion.getAuditoria().setFechaModificar(new Date());
		gasto.setGastoGestion(gastoGestion);
		updaterStateApi.updaterStates(gasto, DDEstadoGasto.AUTORIZADO_ADMINISTRACION);
		gasto.setProvision(null);
		gasto.getAuditoria().setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
		gasto.getAuditoria().setFechaModificar(new Date());
		genericDao.update(GastoProveedor.class, gasto);

		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean autorizarGastosContabilidad(Long[] idsGastos, String fechaConta, String fechaPago, Boolean individual) {

		for (Long id : idsGastos) {

			autorizarGastoContabilidad(id, fechaConta, fechaPago, individual);
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean autorizarGastoContabilidad(Long idGasto, String fechaConta, String fechaPago, Boolean individual) {
		
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		
		Date miFechaConta = null;
		
		Date miFechaPago = null;
		
		if(!Checks.esNulo(fechaConta) && !("").equals(fechaConta)){
			try {
				miFechaConta = formatter.parse(fechaConta);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		if(!Checks.esNulo(fechaPago) && !("").equals(fechaPago)){
			try {
				miFechaPago = formatter.parse(fechaPago);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		GastoProveedor gasto = findOne(idGasto);
		
		if(!Checks.esNulo(gasto.getProvision()) && individual){
			throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede autorizar individualmente: pertenece a una agrupación.");
		}else{
		DDEstadoAutorizacionPropietario estadoAutorizacionPropietario= (DDEstadoAutorizacionPropietario) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionPropietario.class,
				DDEstadoAutorizacionPropietario.CODIGO_AUTORIZADO_POR_CONTABILIDAD);

		GastoGestion gastoGestion = gasto.getGastoGestion();
		
		if(!Checks.esNulo(miFechaConta) && !Checks.esNulo(miFechaPago)){
			GastoInfoContabilidad gastoInfoContabilidad = gasto.getGastoInfoContabilidad();
			GastoDetalleEconomico gastoDetalleEconomico = gasto.getGastoDetalleEconomico();
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoGasto.PAGADO);
			DDEstadoGasto pagado = genericDao.get(DDEstadoGasto.class, filtro);
			
			if(DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())){
				gastoInfoContabilidad.setFechaContabilizacion(miFechaConta);
				gastoDetalleEconomico.setFechaPago(miFechaPago);
				gasto.setGastoDetalleEconomico(gastoDetalleEconomico);
				gasto.setGastoInfoContabilidad(gastoInfoContabilidad);
				gasto.setEstadoGasto(pagado);
				//saveGastosDiariosLbk(gasto.getId());
				//saveGastosImportesLbk(gasto.getId());
				
			}else if(DDEstadoGasto.SUBSANADO.equals(gasto.getEstadoGasto().getCodigo())){
				gastoInfoContabilidad.setFechaContabilizacion(miFechaConta);
				gastoDetalleEconomico.setFechaPago(miFechaPago);
				gasto.setGastoDetalleEconomico(gastoDetalleEconomico);
				gasto.setGastoInfoContabilidad(gastoInfoContabilidad);
				gasto.setEstadoGasto(pagado);
				//saveGastosDiariosLbk(gasto.getId());
				//saveGastosImportesLbk(gasto.getId());
			}else if(DDEstadoGasto.CONTABILIZADO.equals(gasto.getEstadoGasto().getCodigo())){
				gastoDetalleEconomico.setFechaPago(miFechaPago);
				gasto.setGastoDetalleEconomico(gastoDetalleEconomico);
				gasto.setEstadoGasto(pagado);
				//saveGastosDiariosLbk(gasto.getId());
				//saveGastosImportesLbk(gasto.getId());
			}
		}else if(!Checks.esNulo(miFechaConta) && Checks.esNulo(miFechaPago)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoGasto.CONTABILIZADO);
			DDEstadoGasto contabilizado = genericDao.get(DDEstadoGasto.class, filtro);
			
			if(DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())){
				GastoInfoContabilidad gastoInfoContabilidad = gasto.getGastoInfoContabilidad();
				gastoInfoContabilidad.setFechaContabilizacion(miFechaConta);
				gasto.setGastoInfoContabilidad(gastoInfoContabilidad);
				gasto.setEstadoGasto(contabilizado);
				//saveGastosDiariosLbk(gasto.getId());
				//saveGastosDiariosLbk(gasto.getId());
			}else if(DDEstadoGasto.SUBSANADO.equals(gasto.getEstadoGasto().getCodigo())){
				GastoInfoContabilidad gastoInfoContabilidad = gasto.getGastoInfoContabilidad();
				gastoInfoContabilidad.setFechaContabilizacion(miFechaConta);
				gasto.setGastoInfoContabilidad(gastoInfoContabilidad);
				gasto.setEstadoGasto(contabilizado);
				//saveGastosDiariosLbk(gasto.getId());
				//saveGastosImportesLbk(gasto.getId());
			}
		}else if(Checks.esNulo(miFechaConta) && !Checks.esNulo(miFechaPago)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoGasto.PAGADO);
			DDEstadoGasto estadoGasto = genericDao.get(DDEstadoGasto.class, filtro);
			
			if(DDEstadoGasto.CONTABILIZADO.equals(gasto.getEstadoGasto().getCodigo())){
				GastoDetalleEconomico gastoDetalleEconomico = gasto.getGastoDetalleEconomico();
				gastoDetalleEconomico.setFechaPago(miFechaPago);
				gasto.setGastoDetalleEconomico(gastoDetalleEconomico);
				gasto.setEstadoGasto(estadoGasto);
				//saveGastosDiariosLbk(gasto.getId());
				//saveGastosImportesLbk(gasto.getId());
			}
		}
		
		gastoGestion.setFechaEstadoAutorizacionPropietario(new Date());
		gastoGestion.setEstadoAutorizacionPropietario(estadoAutorizacionPropietario);
		gastoGestion.setMotivoRechazoAutorizacionHaya(null);
		genericDao.update(GastoGestion.class, gastoGestion);
		genericDao.update(GastoProveedor.class, gasto);
		}
		
		return true;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean autorizarGastosContabilidadAgrupacion(Long[] idsGastos, Long idAgrupacion, String fechaConta, String fechaPago, Boolean individual) {
		
		
		//Setamos el estado de la agrupación
		ProvisionGastos agrupGasto = provisionGastosDao.get(idAgrupacion);
		
		DDEstadoProvisionGastos estadoProvisionGastos = (DDEstadoProvisionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoProvisionGastos.class,
				DDEstadoProvisionGastos.CODIGO_AUTORIZADO);
		
		if(!Checks.esNulo(agrupGasto)) {
			
			agrupGasto.setEstadoProvision(estadoProvisionGastos);
			
			agrupGasto.getAuditoria().setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
			agrupGasto.getAuditoria().setFechaModificar(new Date());
			
			genericDao.update(ProvisionGastos.class, agrupGasto);
		}
		
		//Seteamos el estado y las fechas a los gastos de la agrupación
		for (Long id : idsGastos) {
			autorizarGastoContabilidad(id, fechaConta, fechaPago, individual);
		}

		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean rechazarGastos(Long[] idsGastos, String motivoRechazo) {

		for (Long id : idsGastos) {
			rechazarGasto(id, motivoRechazo);
		}

		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean rechazarGasto(Long idGasto, String motivoRechazo) {

		
		
		DDEstadoAutorizacionHaya estadoAutorizacionHaya = (DDEstadoAutorizacionHaya) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionHaya.class,
				DDEstadoAutorizacionHaya.CODIGO_RECHAZADO);
		DDMotivoRechazoAutorizacionHaya motivo = null;
		if (!Checks.esNulo(motivoRechazo)) {
			motivo = (DDMotivoRechazoAutorizacionHaya) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoAutorizacionHaya.class, motivoRechazo);
		}
		GastoProveedor gasto = findOne(idGasto);
		
		Filter filtroBorrado= genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		GastoRefacturable gastoRefacturado = genericDao.get(GastoRefacturable.class,filtroBorrado,  genericDao.createFilter(FilterType.EQUALS, "idGastoProveedorRefacturado", idGasto));
		if(!Checks.esNulo(gastoRefacturado)) {
			GastoProveedor gastoPadre = findOne(gastoRefacturado.getGastoProveedor());
			
			throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede rechazar: Hay que desvincularlo primero del gasto" + gastoPadre.getNumGastoHaya());
		}
		
		String error = updaterStateApi.validarCamposMinimos(gasto,false);
		if (!Checks.esNulo(error)) {
			throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede rechazar: " + error);
		}
		

		// Se activa el borrado de los gastos-trabajo, y dejamos el trabajo como diponible para un
		// futuro nuevo gasto
		for(GastoLineaDetalle gastoLinea : gasto.getGastoLineaDetalleList()) {
			this.reactivarTrabajoParaGastos(gastoLinea.getGastoLineaTrabajoList());
		}

		GastoGestion gastoGestion = gasto.getGastoGestion();
		gastoGestion.setEstadoAutorizacionHaya(estadoAutorizacionHaya);
		gastoGestion.setUsuarioEstadoAutorizacionHaya(genericAdapter.getUsuarioLogado());
		gastoGestion.setFechaEstadoAutorizacionHaya(new Date());
		gastoGestion.setMotivoRechazoAutorizacionHaya(motivo);

		gasto.setGastoGestion(gastoGestion);
		
		if(Checks.esNulo(gastoGestion.getEstadoAutorizacionPropietario())){
			updaterStateApi.updaterStates(gasto, DDEstadoGasto.RECHAZADO_ADMINISTRACION);
		}
		else{
			updaterStateApi.updaterStates(gasto, DDEstadoGasto.RECHAZADO_PROPIETARIO);
		}
		
		gasto.setProvision(null);

		genericDao.update(GastoProveedor.class, gasto);

		return true;
	}
	
	@Override 
	@Transactional(readOnly = false)
	public boolean rechazarGastosContabilidad(Long[] idsGastos, String motivoRechazo, Boolean individual) {

		DDEstadoAutorizacionPropietario estadoAutorizacionPropietario = (DDEstadoAutorizacionPropietario) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionPropietario.class,
				DDEstadoAutorizacionPropietario.CODIGO_RECHAZADO_CONTABILIDAD);
		
		for (Long id : idsGastos) {
			GastoProveedor gasto = findOne(id);
			
			if(!Checks.esNulo(gasto.getProvision()) && individual){
				throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede rechazar individualmente: pertenece a una agrupación.");
			}else{
				String error = updaterStateApi.validarCamposMinimos(gasto,false);
				if (!Checks.esNulo(error)) {
					throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede rechazar: " + error);
				}
				
				// Se activa el borrado de los gastos-trabajo, y dejamos el trabajo como diponible para un
				// futuro nuevo gasto
				for(GastoLineaDetalle gastoLinea : gasto.getGastoLineaDetalleList()) {
					this.reactivarTrabajoParaGastos(gastoLinea.getGastoLineaTrabajoList());
				}

				GastoGestion gastoGestion = gasto.getGastoGestion();
				gastoGestion.setEstadoAutorizacionPropietario(estadoAutorizacionPropietario);
				gastoGestion.setFechaEstadoAutorizacionPropietario(new Date());
				gastoGestion.setMotivoRechazoAutorizacionPropietario(motivoRechazo);

				gasto.setGastoGestion(gastoGestion);
				updaterStateApi.updaterStates(gasto, DDEstadoGasto.RECHAZADO_PROPIETARIO);

				
				gasto.setProvision(null);

				genericDao.update(GastoProveedor.class, gasto);
			}
		}

		return true;
	}


	/*
	 * Deja el Trabajo disponible para que sea asignable a un gasto, y activa el borrado lógico de
	 * la relación gastoProveedor-Trabajo
	 */
	private void reactivarTrabajoParaGastos(List<GastoLineaDetalleTrabajo> listaGastoTrabajo) {
		if (!Checks.estaVacio(listaGastoTrabajo)) {
			for (GastoLineaDetalleTrabajo gpvTrabajo : listaGastoTrabajo) {

				Trabajo trabajo = gpvTrabajo.getTrabajo();
				if (!Checks.esNulo(trabajo)) {
					trabajo.setFechaEmisionFactura(null);
					genericDao.update(Trabajo.class, trabajo);
				}
			}
		}
	}

	public GastoProveedor asignarPropietarioGasto(GastoProveedor gasto) {
		
		if(!Checks.estaVacio(gasto.getGastoLineaDetalleList()) && gasto.getPropietario() == null){
			for (GastoLineaDetalle gastoLinea: gasto.getGastoLineaDetalleList()) {
				if (!Checks.esNulo(gastoLinea.getGastoLineaEntidadList()) && !Checks.estaVacio(gastoLinea.getGastoLineaEntidadList())){
					GastoLineaDetalleEntidad gastoActivo = gastoLinea.getGastoLineaEntidadList().get(0);
					Filter filtroA = genericDao.createFilter(FilterType.EQUALS, "id", gastoActivo.getEntidad());
					Activo activo = genericDao.get(Activo.class, filtroA);
					if(Checks.esNulo(activo)) {
						gasto.setPropietario(activo.getPropietarioPrincipal());
					}
				}
			}
		}

		return gasto;
	}
	
	@Override
	public List<DtoActivoProveedor> searchProveedoresByNif(DtoProveedorFilter dto) {
		List<DtoActivoProveedor> lista = null;
		lista = proveedores.getProveedoresByNif(dto.getNifProveedor());

		return lista;
	}

	@Transactional(readOnly = false)
	private void updateExisteDocumentoGasto(GastoProveedor gasto, Integer i) {
		
		Integer existeDocumento = gasto.getExisteDocumento();
		
		if (existeDocumento != i || Checks.esNulo(existeDocumento)) {
			gasto.setExisteDocumento(i);
			genericDao.update(GastoProveedor.class, gasto);
		}
	}
	
	public String checkReglaCambioEstado(String codigoEstado, boolean coniva, String matriculaTipoDoc, GastoProveedor gasto) {
		Pattern factPattern = Pattern.compile(".*-FACT-.*");
		Pattern justPattern = Pattern.compile(".*-CERA-.*");

		if (factPattern.matcher(matriculaTipoDoc).matches() && Checks.esNulo(updaterStateApi.validarCamposMinimos(gasto,false)) && DDEstadoGasto.INCOMPLETO.equals(codigoEstado)) {
			return DDEstadoGasto.PENDIENTE;

		} else if (justPattern.matcher(matriculaTipoDoc).matches()
				&& DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC.equals(codigoEstado) && (!coniva)) {
			return DDEstadoGasto.PAGADO;
		} else {
			return null;
		}
	}
	
	@Override
	public DtoPage getListGastosProvision(DtoGastosFilter dtoGastosFilter) {

		return gastoDao.getListGastosProvision(dtoGastosFilter);
	}

	@Override
	public void actualizarPorcentajeParticipacionGastoProveedorActivo(Long idActivo, Long idGasto, Float porcentajeParticipacion) {
		if(idActivo == null || idGasto == null) {
			return;
		}

		Filter filterActivoId = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filterGastoId = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.gastoProveedor.id", idGasto);
		GastoLineaDetalleEntidad gpa = genericDao.get(GastoLineaDetalleEntidad.class, filterActivoId, filterGastoId);
		if(gpa != null) {
			gpa.setParticipacionGasto((double) porcentajeParticipacion);
		}

		genericDao.save(GastoLineaDetalleEntidad.class, gpa);
	}

	@Override

	public GastoLineaDetalleEntidad buscarRelacionPorActivoYGasto(Activo activo, GastoProveedor gasto) {
		
		return genericDao.get(GastoLineaDetalleEntidad.class, genericDao.createFilter(FilterType.EQUALS, "activo", activo),
				genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.gastoProveedor", gasto));
		
	}

	@Transactional(readOnly = false)
	public boolean rechazarGastosContabilidadAgrupGastos(Long idAgrupGasto,Long[] idsGasto, String motivoRechazo, Boolean individual) {
		
		if(Checks.esNulo(idAgrupGasto)) {
			return false;
		}
		
		boolean resultadoFinal = false;
		boolean resultadoGastos = false;
		boolean resultadoAgrupGastos = false;
		
		DDEstadoProvisionGastos estadoProvisionGastos = (DDEstadoProvisionGastos) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoProvisionGastos.class,
				DDEstadoProvisionGastos.CODIGO_RECHAZADO_NO_SUBSANABLE);
		
		resultadoAgrupGastos = rechazarAgrupacionGastoContabilidad(idAgrupGasto, motivoRechazo, estadoProvisionGastos);

		resultadoGastos = rechazarGastosContabilidad(idsGasto, motivoRechazo, individual);
		
		if(resultadoGastos && resultadoAgrupGastos) {
			resultadoFinal = true;
		}

		return resultadoFinal;
	}

	/** Rechaza una agrupacion gasto
	 * @param idAgrupGasto
	 * @param motivoRechazo
	 * @param estadoProvisionGastos
	 * @return 
	 */
	@Transactional(readOnly = false)
	private boolean rechazarAgrupacionGastoContabilidad(Long idAgrupGasto, String motivoRechazo,
			DDEstadoProvisionGastos estadoProvisionGastos) {
		ProvisionGastos agrupGasto = provisionGastosDao.get(idAgrupGasto);
		
		if(!Checks.esNulo(agrupGasto)) {
			
			agrupGasto.setEstadoProvision(estadoProvisionGastos);
			
			agrupGasto.getAuditoria().setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
			agrupGasto.getAuditoria().setFechaModificar(new Date());
			
			genericDao.update(ProvisionGastos.class, agrupGasto);
		}else {
			return false;
		}

		return true;
	}

	@Override
	public List<VGastosProveedor> getListGastosProvisionAgrupGastos(Long idProvision) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "idProvision", idProvision);
		
		return genericDao.getList(VGastosProveedor.class, filter);

	}
	
	@Override
	public List<VFacturasProveedores> getListFacturas(){
		List<VFacturasProveedores> listFacturas = new ArrayList<VFacturasProveedores>();
		listFacturas = genericDao.getList(VFacturasProveedores.class);
		return listFacturas;
	}
	
	@Override
	public List<VTasasImpuestos> getListTasasImpuestos(){
		List<VTasasImpuestos>  listTasasImpuestos = new ArrayList<VTasasImpuestos>();
		listTasasImpuestos = genericDao.getList(VTasasImpuestos.class);
		return listTasasImpuestos;
	}

	@Override
	public List<String> getGastosRefacturados(String listaGastos, String nifPropietario, String tipoGasto) {
		List<VGastosRefacturados>  listaVistaGastos = new ArrayList<VGastosRefacturados>();
		List<String> listaGastosFinales = new ArrayList<String>();

		if(!Checks.esNulo(listaGastos)) {
			listaVistaGastos = gastoDao.getGastosRefacturados(listaGastos);
			if(!Checks.estaVacio(listaVistaGastos)) {
				String mismosDatos = null;
				for (VGastosRefacturados vGastosRefacturado : listaVistaGastos) {
					GastoProveedor gastoProveedorRefacturable = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(vGastosRefacturado.getNumGastoHaya())));
					if(gastoProveedorRefacturable.getTipoGasto() != null 
						&& tipoGasto.equals(gastoProveedorRefacturable.getTipoGasto().getCodigo())
						&& gastoLineaDetalleApi.tieneLineaDetalle(gastoProveedorRefacturable)
						&& nifPropietario != null && this.gastoMismoPropietario(nifPropietario, gastoProveedorRefacturable)
						&& gastoProveedorRefacturable.getPropietario().getCartera() != null) {
					
						if(DDCartera.CODIGO_CARTERA_BANKIA.equals(gastoProveedorRefacturable.getPropietario().getCartera().getCodigo())) {
							
							String mismosDatosAux = gastoLineaDetalleApi.devolverSubGastoImpuestImpositivo(gastoLineaDetalleApi.devolverLineaBk(gastoProveedorRefacturable));
							if(mismosDatos == null) {
								mismosDatos = mismosDatosAux;
							}	
							if(!mismosDatos.equals(mismosDatosAux)) {
								listaGastosFinales.clear();
								break;
							}
						}
						listaGastosFinales.add(vGastosRefacturado.getNumGastoHaya());
					}	
				}
			}
		}
		
		return listaGastosFinales;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<String> getGastosNoRefacturados(String gastos, List<String> gastosRefacturables) {
		List<String> gastosTotales = new ArrayList<String>();
		List<String> gastosNoRefacturables = new ArrayList<String>();
			gastosTotales= Arrays.asList(gastos.split(","));
			for (String gasto : gastosTotales) {
				 if(!gastosRefacturables.contains(gasto)){
					 gastosNoRefacturables.add(gasto);
				 }
			}

		return gastosNoRefacturables;
	}
	
	
	@Override
	public Boolean isCarteraPropietarioBankiaSareb(ActivoPropietario propietario) {
		Boolean isCarteraPropietarioBankiaSareb = false;
		if(!Checks.esNulo(propietario) && !Checks.esNulo(propietario.getCartera())) {
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(propietario.getCartera().getCodigo())
				|| DDCartera.CODIGO_CARTERA_SAREB.equals(propietario.getCartera().getCodigo())) {
				isCarteraPropietarioBankiaSareb = true;
			}
		}
		return isCarteraPropietarioBankiaSareb;
	}
	
	@Override
	public List<Long> getGastosRefacturablesGastoCreado(Long id) {
		List<GastoRefacturable> listaDeGastosRefacturablesDelGasto = new ArrayList<GastoRefacturable>();
		GastoProveedor gastoProveedor = new GastoProveedor();
		List<Long> listaNumGastoHayaGastosRefacurables = new ArrayList<Long>();
		listaDeGastosRefacturablesDelGasto = gastoDao.getGastosRefacturablesDelGasto(id);
		
		for (GastoRefacturable gastoRefacturable : listaDeGastosRefacturablesDelGasto) {
			if(!Checks.esNulo(gastoRefacturable.getGastoProveedorRefacturado())) {
				gastoProveedor = gastoDao.getGastoById(gastoRefacturable.getGastoProveedorRefacturado());
				if(!Checks.esNulo(gastoProveedor)) {
					listaNumGastoHayaGastosRefacurables.add(gastoProveedor.getNumGastoHaya());
				}
			}	
		}
				
		return listaNumGastoHayaGastosRefacurables;
	}
	
	@Override
	public List<GastoProveedor> getGastosRefacturablesGasto(Long id) {
		List<GastoRefacturable> listaDeGastosRefacturablesDelGasto = new ArrayList<GastoRefacturable>();
		GastoProveedor gastoProveedor = new GastoProveedor();
		List<GastoProveedor> listaGastosRefacturables = new ArrayList<GastoProveedor>();
		listaDeGastosRefacturablesDelGasto = gastoDao.getGastosRefacturablesDelGasto(id);
		
		for (GastoRefacturable gastoRefacturable : listaDeGastosRefacturablesDelGasto) {
			if(!Checks.esNulo(gastoRefacturable.getGastoProveedorRefacturado())) {
				gastoProveedor = gastoDao.getGastoById(gastoRefacturable.getGastoProveedorRefacturado());
				if(!Checks.esNulo(gastoProveedor)) {
					listaGastosRefacturables.add(gastoProveedor);
				}
			}	
		}
				
		return listaGastosRefacturables;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void anyadirGastosRefacturadosAGastoExistente(String idGasto, List<String> gastosRefacturablesLista) throws IllegalAccessException, InvocationTargetException {
		Long idPadre = Long.valueOf(idGasto);
		GastoProveedor gastoProveedorPadre = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", idPadre));

		boolean esSareb = false;
		
		esSareb = isGastoSareb(gastoProveedorPadre);

		for (String gasto : gastosRefacturablesLista) {
			GastoProveedor gastoProveedorRefacturable = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(gasto)));
			if (gastoProveedorRefacturable != null) {
				if(!gastoDao.updateGastosRefacturablesSiExiste(gastoProveedorRefacturable.getId(), idPadre, usuarioApi.getUsuarioLogado().getUsername())) {
					GastoRefacturable gastoRefacturableNuevo = new GastoRefacturable();
					gastoRefacturableNuevo.setGastoProveedor(idPadre);
					gastoRefacturableNuevo.setGastoProveedorRefacturado(gastoProveedorRefacturable.getId());
					genericDao.save(GastoRefacturable.class, gastoRefacturableNuevo);			
				}
			}
		}		

		if(esSareb) {
			gastoLineaDetalleApi.eliminarLineasRefacturadas(idPadre);
		}
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean eliminarGastoRefacturado(Long idGasto, Long numGastoRefacturado) {
		List<GastoRefacturable> listaDeGastosRefacturablesDelGasto = new ArrayList<GastoRefacturable>();
		Boolean noTieneGastosRefacturados = false;

		Filter gastoRefacturadoNum = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", numGastoRefacturado);
		GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, gastoRefacturadoNum);
		
		Filter gastoId = genericDao.createFilter(FilterType.EQUALS, "idGastoProveedor", idGasto);
		Filter gastoRefacturadoId = genericDao.createFilter(FilterType.EQUALS, "idGastoProveedorRefacturado", gastoProveedor.getId());
		GastoRefacturable gastoRefacturable = genericDao.get(GastoRefacturable.class, gastoId, gastoRefacturadoId);
		
		gastoRefacturable.getAuditoria().setBorrado(true);
		gastoRefacturable.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
		gastoRefacturable.getAuditoria().setFechaBorrar(new Date());
		genericDao.update(GastoRefacturable.class, gastoRefacturable);
		
		listaDeGastosRefacturablesDelGasto = gastoDao.getGastosRefacturablesDelGasto(idGasto);
		if(Checks.estaVacio(listaDeGastosRefacturablesDelGasto)) {
			noTieneGastosRefacturados = true;
			
			Filter filterGastoId = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
			GastoDetalleEconomico gastoDetalleEconomico = genericDao.get(GastoDetalleEconomico.class, filterGastoId);
			
			gastoDetalleEconomico.setGastoRefacturable(false);
			
			genericDao.update(GastoDetalleEconomico.class, gastoDetalleEconomico);
		}
		
		return noTieneGastosRefacturados;
		
	}
	
	/*HREOS-7241*/
	public boolean esGastoRefacturable(GastoProveedor gasto) {
		
		if(!Checks.esNulo(gasto.getGastoDetalleEconomico())) {
			if(!Checks.esNulo(gasto.getGastoDetalleEconomico().getGastoRefacturable())) {
				return gasto.getGastoDetalleEconomico().getGastoRefacturable();//Devolvemos el valor del campo, ya que puede ser true o false
			} else { //No tiene informado el campo gasto refacturable en el detalle del gasto
				return false;
			}
		} else { //No tiene detalle de gasto
			return false;
		}
		
	}
	
	private boolean gastoMismoPropietario(String nifPropietario, GastoProveedor gastoProveedorRefacturable) {
		boolean mismoPropietario = false;
		if(!Checks.esNulo(nifPropietario)) {	
			if (!Checks.esNulo(gastoProveedorRefacturable) && !Checks.esNulo(gastoProveedorRefacturable.getPropietario())) {
				mismoPropietario = nifPropietario.equals(gastoProveedorRefacturable.getPropietario().getDocIdentificativo());
			}
		}
		return mismoPropietario;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public void validarGastosARefacturar(String idGasto, String listaGastos) {
		List<String> listaGastosRefacturables = Arrays.asList(listaGastos.split("\\s*,\\s*"));
		Filter gastoPadreId = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(idGasto));
		GastoProveedor gastoPadre = genericDao.get(GastoProveedor.class, gastoPadreId);
		
		for (String numGastoRefacturable : listaGastosRefacturables) {
			Filter gastoHijoId = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.valueOf(numGastoRefacturable));
			GastoProveedor gastoHijo = genericDao.get(GastoProveedor.class, gastoHijoId);
			
			Filter gastoLineaDetalle = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gastoHijo.getId());
			List<GastoLineaDetalle> gastoLineaDetalleList = genericDao.getList(GastoLineaDetalle.class, gastoLineaDetalle);
			
			if(gastoLineaDetalleList == null || gastoLineaDetalleList.isEmpty()) {
				throw new JsonViewerException("El gasto "+numGastoRefacturable+" no tiene niguna línea de detalle.");
			}
			
			Filter detalleEconomicoGastoId = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gastoHijo.getId());
			GastoDetalleEconomico gastoDetalleEconomico = genericDao.get(GastoDetalleEconomico.class, detalleEconomicoGastoId);
			
			Filter facturadosGastoId = genericDao.createFilter(FilterType.EQUALS, "idGastoProveedorRefacturado", gastoHijo.getId());
			GastoRefacturable gastoRefacturable = genericDao.get(GastoRefacturable.class, facturadosGastoId);
			
			if (!Checks.esNulo(gastoDetalleEconomico) && (!Checks.esNulo(gastoDetalleEconomico.getGastoRefacturable()) && !gastoDetalleEconomico.getGastoRefacturable())) {
				throw new JsonViewerException("El gasto "+numGastoRefacturable+" no es refacturable, por favor corrija el listado de gastos");
			}
			
			if (!Checks.esNulo(gastoRefacturable)) {
				Filter gastoPadreActualId = genericDao.createFilter(FilterType.EQUALS, "id", gastoRefacturable.getGastoProveedor());
				GastoProveedor gastoPadreActual = genericDao.get(GastoProveedor.class, gastoPadreActualId);
				
				throw new JsonViewerException("El gasto "+gastoHijo.getNumGastoHaya()+" ya está refacturado en el gasto "+gastoPadreActual.getNumGastoHaya()+", por favor corrija el listado de gastos");
			}
			
			if (!Checks.esNulo(gastoPadre) && !Checks.esNulo(gastoHijo) && !Checks.esNulo(gastoPadre.getPropietario()) && !Checks.esNulo(gastoHijo.getPropietario())
					&& !gastoPadre.getPropietario().equals(gastoHijo.getPropietario())) {
				throw new JsonViewerException("El gasto "+numGastoRefacturable+" no tiene el mismo propietario que el gasto "+gastoPadre.getNumGastoHaya());
			}
		}
		
	}
	
	@Override
	public boolean isPosibleRefacturable(GastoProveedor gasto) {
		boolean isPosibleRefacturable = false;
		
		if (!Checks.esNulo(gasto) && !Checks.esNulo(gasto.getEstadoGasto()) && !Checks.esNulo(gasto.getEstadoGasto().getCodigo()) 
				&& !Checks.esNulo(gasto.getPropietario()) && !Checks.esNulo(gasto.getPropietario().getCartera()) && !Checks.esNulo(gasto.getPropietario().getCartera().getCodigo())) {
			DDCartera cartera = gasto.getPropietario().getCartera(); 
			String estadoGasto = gasto.getEstadoGasto().getCodigo();
			List<GastoRefacturable> gastosPadres = genericDao.getList(GastoRefacturable.class, genericDao.createFilter(FilterType.EQUALS, "idGastoProveedor", gasto.getId()),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
			GastoRefacturable gastoPadre = null;
			if(!Checks.estaVacio(gastosPadres)) {
				gastoPadre = gastosPadres.get(0);
			}
			
			GastoRefacturable gastoRefacturado = genericDao.get(GastoRefacturable.class, genericDao.createFilter(FilterType.EQUALS, "idGastoProveedorRefacturado", gasto.getId()),genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
			if (!Checks.esNulo(cartera) 
					&& (DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo()) || DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo())
						|| DDCartera.CODIGO_CARTERA_BBVA.equals(cartera.getCodigo()))) {
				if(DDDestinatarioGasto.CODIGO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo())) {
					if(!(DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(estadoGasto)
						||	DDEstadoGasto.AUTORIZADO_PROPIETARIO.equals(estadoGasto)
						||	DDEstadoGasto.PAGADO.equals(estadoGasto)
						||	DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC.equals(estadoGasto)  
						||	DDEstadoGasto.CONTABILIZADO.equals(estadoGasto))) {
						
						if(DDCartera.CODIGO_CARTERA_BBVA.equals(cartera.getCodigo()) 
							|| (Checks.esNulo(gastoPadre) && Checks.esNulo(gastoRefacturado)))
							isPosibleRefacturable = true;
						
					}
				}
			}
		}
		return isPosibleRefacturable;
	}
	
	@Override
	public Double recalcularImporteTotalGasto(GastoDetalleEconomico gasto) {
		
		Double importeTotal = 0.0, cuotaIvaRetenida = 0.0;
		boolean retencionAntes = false;

		if(gasto.getGastoProveedor() != null) {
			DDCartera carteraGasto = gasto.getGastoProveedor().getCartera();
			retencionAntes = gasto.getTipoRetencion() != null && DDTipoRetencion.CODIGO_TRE_ANTES.equals(gasto.getTipoRetencion().getCodigo());
			
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getGastoProveedor().getId());
			List<GastoLineaDetalle> gastoLineaDetalleList = genericDao.getList(GastoLineaDetalle.class, filter);
	
			if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()){
				for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
					importeTotal = sumaImportesLineaDetalle(importeTotal, gastoLineaDetalle);					
					
					if (gastoLineaDetalle.getImporteIndirectoTipoImpositivo() != null && gastoLineaDetalle.getPrincipalSujeto() != null && 
							//op exenta no y rellena
							((gastoLineaDetalle.getEsImporteIndirectoExento() !=null && !gastoLineaDetalle.getEsImporteIndirectoExento()) ||
							//op exenta si y rellena y renuncia si y rellena
							(gastoLineaDetalle.getEsImporteIndirectoExento() !=null && gastoLineaDetalle.getEsImporteIndirectoExento() 
							&& gastoLineaDetalle.getEsImporteIndirectoRenunciaExento() !=null && gastoLineaDetalle.getEsImporteIndirectoRenunciaExento()) ||
							//op exenta vacia
							(gastoLineaDetalle.getEsImporteIndirectoExento() == null))) {
						
						cuotaIvaRetenida += (gastoLineaDetalle.getPrincipalSujeto() * gastoLineaDetalle.getImporteIndirectoTipoImpositivo()) / 100;
						
						importeTotal += (gastoLineaDetalle.getPrincipalSujeto() * gastoLineaDetalle.getImporteIndirectoTipoImpositivo()) / 100;
						
					}
				}
			}
			
			if(gasto.getIrpfBase() != null && gasto.getIrpfTipoImpositivo() != null) {
				importeTotal = importeTotal - ((gasto.getIrpfBase() * gasto.getIrpfTipoImpositivo()) / 100);
			}
			
			if(gasto.getRetencionGarantiaBase() != null && gasto.getRetencionGarantiaTipoImpositivo() != null && gasto.getRetencionGarantiaAplica() != null && gasto.getRetencionGarantiaAplica()) {				
				importeTotal = importeTotal - ((gasto.getRetencionGarantiaBase() * gasto.getRetencionGarantiaTipoImpositivo()) / 100);
			}
			
			if (retencionAntes && gasto.getRetencionGarantiaTipoImpositivo() != null 
					&& carteraGasto != null && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(carteraGasto.getCodigo())) {
				try {
					importeTotal = importeTotal - (cuotaIvaRetenida / 100 * gasto.getRetencionGarantiaTipoImpositivo());
					
				} catch (ArithmeticException e) {
					e.printStackTrace();
				}
				
			}

		}		
		return importeTotal;
	}
	
	private Double sumaImportesLineaDetalle(Double importeTotal,GastoLineaDetalle gastoLineaDetalle) {
		Double importeFinal=importeTotal;
		
		if(gastoLineaDetalle.getPrincipalSujeto() != null) {
			importeFinal+=gastoLineaDetalle.getPrincipalSujeto();
		}
		if(gastoLineaDetalle.getPrincipalNoSujeto() != null) {
			importeFinal+=gastoLineaDetalle.getPrincipalNoSujeto();
		}
		if(gastoLineaDetalle.getProvSuplidos() != null) {
			importeFinal+=gastoLineaDetalle.getProvSuplidos();
		}
		if(gastoLineaDetalle.getRecargo() != null) {
			importeFinal+=gastoLineaDetalle.getRecargo();
		}
		if(gastoLineaDetalle.getInteresDemora() != null) {
			importeFinal+=gastoLineaDetalle.getInteresDemora();
		}
		if(gastoLineaDetalle.getCostas() != null) {
			importeFinal+=gastoLineaDetalle.getCostas();
		}
		if(gastoLineaDetalle.getOtrosIncrementos() != null) {
			importeFinal+=gastoLineaDetalle.getOtrosIncrementos();
		}
		return importeFinal;
	}
	
	public boolean isGastoRefacturadoPorOtroGasto(Long idGasto) {
		boolean isRefacturado = false;
		
		Filter detalleEconomicoGastoId = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
		GastoDetalleEconomico gastoDetalleEconomico = genericDao.get(GastoDetalleEconomico.class, detalleEconomicoGastoId);
		
		Filter facturadosGastoId = genericDao.createFilter(FilterType.EQUALS, "idGastoProveedorRefacturado", idGasto);
		GastoRefacturable gastoRefacturable = genericDao.get(GastoRefacturable.class, facturadosGastoId);
		
		if(gastoDetalleEconomico != null && gastoDetalleEconomico.getGastoRefacturable() != null 
				&& gastoDetalleEconomico.getGastoRefacturable() &&  gastoRefacturable != null) {
			isRefacturado = true;
		}
		
		return isRefacturado;
	}
	
	public boolean isGastoSareb(GastoProveedor gastoProveedor) {
		boolean isSareb = false;
		
		if(gastoProveedor.getPropietario() != null&& gastoProveedor.getPropietario().getCartera() != null
			&& DDCartera.CODIGO_CARTERA_SAREB.equals(gastoProveedor.getPropietario().getCartera().getCodigo())) {
			isSareb = true;
		}
		return isSareb;
	}

	@Override
	@Transactional(readOnly = false)
	public void anyadirGastosRefacturablesSiCumplenCondiciones(String idGasto, String gastosRefacturables, String nifPropietario) throws IllegalAccessException, InvocationTargetException,Exception {
		List<String> gastosRefacturablesLista = new ArrayList<String>();
		boolean gastoSinLineas = true;

		this.validarGastosARefacturar(idGasto, gastosRefacturables);
		GastoProveedor gastoProveedor = this.findOne(Long.valueOf(idGasto));
		
		Filter filtroRefPadre = genericDao.createFilter(FilterType.EQUALS, "idGastoProveedor", Long.valueOf(idGasto));
		List<GastoRefacturable> listaGastosRefacturables = genericDao.getList(GastoRefacturable.class, filtroRefPadre);
		if(gastoProveedor.getGastoLineaDetalleList() != null && !gastoProveedor.getGastoLineaDetalleList().isEmpty()
				&& (gastoProveedor.getCartera() != null && gastoProveedor.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_SAREB)) 
				&& (listaGastosRefacturables == null || listaGastosRefacturables.isEmpty())) {
			gastoSinLineas = false;
			throw new Exception("No se puede añadir un gasto refacturable a un gasto que ya tiene lineas de detalle");
		}
		
		if(gastosRefacturables != null && gastoProveedor != null && gastoProveedor.getTipoGasto() != null && gastoSinLineas) {
			gastosRefacturablesLista = this.getGastosRefacturados(gastosRefacturables, nifPropietario, gastoProveedor.getTipoGasto().getCodigo());
		}
		
		if(!Checks.estaVacio(gastosRefacturablesLista)){
			this.anyadirGastosRefacturadosAGastoExistente(idGasto, gastosRefacturablesLista);
		}
	}
	
	@Override
	public List<DtoVImporteGastoLbk> getVImporteGastoLbk(Long idGasto){
		List<DtoVImporteGastoLbk> dtoVistaImportesGastoLbk = new ArrayList <DtoVImporteGastoLbk>();
		
		Filter filtroTabla = genericDao.createFilter(FilterType.EQUALS, "idGastos", idGasto);
		
		List<GastosImportesLBK> gastosImportesGastoLBK = genericDao.getList(GastosImportesLBK.class, filtroTabla);
		
		if (gastosImportesGastoLBK != null && !gastosImportesGastoLBK.isEmpty()) {
			for (GastosImportesLBK gastoImportesGastoLBK : gastosImportesGastoLBK) {
				DtoVImporteGastoLbk dto = new DtoVImporteGastoLbk();				
				Filter idTipoEnt = genericDao.createFilter(FilterType.EQUALS, "id", gastoImportesGastoLBK.getEntidadGasto());
				DDEntidadGasto tipoEntidad = genericDao.get(DDEntidadGasto.class, idTipoEnt);
				if(DDEntidadGasto.CODIGO_ACTIVO.equals(tipoEntidad.getCodigo())) {
					Activo activo = activoDao.getActivoById(gastoImportesGastoLBK.getIdEntidad());
					if(activo != null) {
						dto.setIdElemento(activo.getNumActivo());
					}
				}else if(DDEntidadGasto.CODIGO_ACTIVO_GENERICO.equals(tipoEntidad.getCodigo())) {
					Filter filterId = genericDao.createFilter(FilterType.EQUALS, "id", gastoImportesGastoLBK.getIdEntidad());
					ActivoGenerico activoGenerico =  genericDao.get(ActivoGenerico.class, filterId);
					if(activoGenerico != null) {
						dto.setIdElemento(Long.parseLong(activoGenerico.getNumActivoGenerico()));
					}
				}else {
					dto.setIdElemento(gastoImportesGastoLBK.getIdEntidad());
				}
				
				dto.setImporteGasto(gastoImportesGastoLBK.getImporteActivo());
				dto.setTipoElemento(tipoEntidad.getDescripcion());
				dtoVistaImportesGastoLbk.add(dto);
			} 
		} 

		return dtoVistaImportesGastoLbk;
		
	}
	
	
	
	@Override
	public List<DDTipoTrabajo> getTiposTrabajoByIdGasto(Long idGasto){
		GastoProveedor gastoProveedor = this.findOne(Long.valueOf(idGasto));
		List<DDTipoTrabajo> listaTipoTrabajo = new ArrayList<DDTipoTrabajo>();
		
		Filter filterTipoGasto = genericDao.createFilter(FilterType.EQUALS, "tipoGasto.id", gastoProveedor.getTipoGasto().getId());
		List <DDSubtipoGasto> subTiposGastos = genericDao.getList(DDSubtipoGasto.class, filterTipoGasto);
		
		for(DDSubtipoGasto subTipoGasto : subTiposGastos ) {
			Filter filterSubTipoGasto = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", subTipoGasto.getId());
			List <SubTipoGpvTrabajo> ListGpv = genericDao.getList(SubTipoGpvTrabajo.class, filterSubTipoGasto);
			for(SubTipoGpvTrabajo gpv : ListGpv) {
				if(!listaTipoTrabajo.contains(gpv.getSubtipoTrabajo().getTipoTrabajo())) {
					listaTipoTrabajo.add(gpv.getSubtipoTrabajo().getTipoTrabajo());
				}
			}
		}
		
		return listaTipoTrabajo;
	}
	
	@Override
	public List<DDSubtipoTrabajo> getSubTiposTrabajoByIdGasto(Long idGasto){
		
		GastoProveedor gastoProveedor = this.findOne(Long.valueOf(idGasto));
		List<DDSubtipoTrabajo> listaSubTipoTrabajo = new ArrayList<DDSubtipoTrabajo>();
		
		Filter filterTipoGasto = genericDao.createFilter(FilterType.EQUALS, "tipoGasto.id", gastoProveedor.getTipoGasto().getId());
		List <DDSubtipoGasto> subTiposGastos = genericDao.getList(DDSubtipoGasto.class, filterTipoGasto);
		
		for(DDSubtipoGasto subTipoGasto : subTiposGastos ) {
			Filter filterSubTipoGasto = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", subTipoGasto.getId());
			List <SubTipoGpvTrabajo> ListGpv = genericDao.getList(SubTipoGpvTrabajo.class, filterSubTipoGasto);
			for(SubTipoGpvTrabajo gpv : ListGpv) {
				if(!listaSubTipoTrabajo.contains(gpv.getSubtipoTrabajo())) {
					listaSubTipoTrabajo.add(gpv.getSubtipoTrabajo());

				}
			}
		}
		
		return listaSubTipoTrabajo;
	}
					

	private void validacionPreviaSaveUpdateGasto(DtoFichaGastoProveedor dto, Long id) {
		
		GastoProveedor gastoProveedor = null;
		List<GastoSuplido> gastosSuplidos = null;	
		Filter filtroProveedorPadre = null;
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		//Codigos de Tipo de gasto Servicios profesionales independientes y 'Subtipo' honorarios gestión activos.
		String[] subtiposGasto = new String[]{COD_HONORARIOS_GESTION_ACTIVOS,COD_REGISTRO,COD_NOTARIA,COD_ABOGADO,COD_PROCURADOR,COD_OTROS_SERVICIOS_JURIDICOS,COD_ADMINISTRADOR_COMUNIDAD_PROPIETARIOS,COD_ASESORIA,COD_TECNICO,COD_TASACION,COD_OTROS,COD_GESTION_DE_SUELO,COD_ABOGADO_OCUPACIONAL,COD_ABOGADO_ASUNTOS_GENERALES,COD_ABOGADO_ASISTENCIA_JURIDiCA};
		List<String> codigosSubtipoGasto = new ArrayList<String>(Arrays.asList(subtiposGasto));
		if(id != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
			gastoProveedor = genericDao.get(GastoProveedor.class, filtro);
		}
		
		if(dto.getFacturaPrincipalSuplido() != null && !dto.getFacturaPrincipalSuplido().isEmpty()) {
			
			Filter filtroFactura = genericDao.createFilter(FilterType.EQUALS, "referenciaEmisor", dto.getFacturaPrincipalSuplido());
			Filter filtroSuplidos = genericDao.createFilter(FilterType.EQUALS,"suplidosVinculados.codigo", DDSinSiNo.CODIGO_SI);
			List<GastoProveedor> gastosProveedor = genericDao.getList(GastoProveedor.class, filtroFactura, filtroSuplidos);
			
			if(gastosProveedor == null || gastosProveedor.isEmpty()) {
				throw new JsonViewerException("No existe ninguna factura " + dto.getFacturaPrincipalSuplido() + " en un gasto con 'Suplido vinculado'");
			} else if(gastosProveedor != null && !gastosProveedor.isEmpty() && gastosProveedor.size() > 1) {
				throw new JsonViewerException("No se puede dar de alta un 'Suplido vinculado' cuyo numero de factura esta en más de un gasto");
			} else {
				gastoProveedor = gastosProveedor.get(0);
				
				if(gastoProveedor != null && (gastoProveedor.getSuplidosVinculados() == null || DDSinSiNo.CODIGO_NO.equals(gastoProveedor.getSuplidosVinculados().getCodigo()))) {
					throw new JsonViewerException("No se puede dar de alta ya que el gasto de la factura indicada tiene 'Suplido vinculado' a 'No'");
				}
				
			}
			
		}
		
		if(dto.getSuplidosVinculadosCod() != null) {
			
			if(DDSinSiNo.CODIGO_SI.equals(dto.getSuplidosVinculadosCod())) {
				if(gastoProveedor != null && gastoProveedor.getNumeroFacturaPrincipal() != null) {
					throw new JsonViewerException("No se puede actualizar el campo 'Suplidos vinculados' a 'Si' si tiene factura principal");
				}
			} else {
				if(gastoProveedor != null) {
					
					filtroProveedorPadre = genericDao.createFilter(FilterType.EQUALS, "gastoProveedorPadre", gastoProveedor);
					gastosSuplidos = genericDao.getList(GastoSuplido.class, filtroProveedorPadre, filtroBorrado);
					
					if(gastosSuplidos != null && !gastosSuplidos.isEmpty()) {
						throw new JsonViewerException("No se puede actualizar el campo 'Suplidos vinculados' a 'No' si tiene suplidos vinculados");
					}
				}
			}
		}
		
		if(dto.getFacturaPrincipalSuplido() != null && !dto.getFacturaPrincipalSuplido().isEmpty() || dto.getSuplidosVinculadosCod() != null) {
			if(gastoProveedor.getGastoLineaDetalleList() != null && !gastoProveedor.getGastoLineaDetalleList().isEmpty()){
				for (GastoLineaDetalle gastoLinea: gastoProveedor.getGastoLineaDetalleList()) {
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id",gastoLinea.getId());
					Filter filterAct = genericDao.createFilter(FilterType.EQUALS, "entidadGasto.codigo",DDEntidadGasto.CODIGO_ACTIVO);
					List <GastoLineaDetalleEntidad> gastoLineaEntidadList= genericDao.getList(GastoLineaDetalleEntidad.class,filter,filterAct);
					if(gastoLineaEntidadList==null || gastoLineaEntidadList.isEmpty()) {
						throw new JsonViewerException("Hay lineas sin activos asociados");
					}else {
						for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLineaEntidadList) {
							Activo activo = activoDao.getActivoById(gastoLineaDetalleEntidad.getEntidad());
							if(activo == null || gastoProveedor.getCartera()==null || activo.getSubcartera()==null || gastoProveedor.getTipoGasto()==null) {
								throw new JsonViewerException("No hay datos");						
							}
							ConfiguracionSuplidos config = genericDao.get(ConfiguracionSuplidos.class,
									genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", gastoProveedor.getCartera().getCodigo()),
									genericDao.createFilter(FilterType.EQUALS, "subCartera.codigo", activo.getSubcartera().getCodigo()),
									genericDao.createFilter(FilterType.EQUALS, "tipoGasto.codigo", gastoProveedor.getTipoGasto().getCodigo()),
									genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.codigo",gastoLinea.getSubtipoGasto().getCodigo()));
							if(config==null) {
								throw new JsonViewerException("El gasto no puede ser o tener Suplidos");							
							}
						}
					}
				}			
			}else {
				throw new JsonViewerException("El gasto no puede ser o tener Suplidos");
			}
		}
		
	}

	
	public void gastosDiariosLbkToDto(DtoInfoContabilidadGasto dtoInfoContabilidadGasto, GastoProveedor gasto) {
				
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());

		GastosDiariosLBK tablaGastos = genericDao.get(GastosDiariosLBK.class, filter);
		//Si la tabla no esta vacía cargamos los datos de la tabla
		if(tablaGastos != null) {
			dtoInfoContabilidadGasto.setDiario1(tablaGastos.getDiario1());
			dtoInfoContabilidadGasto.setDiario1Base(tablaGastos.getDiario1Base());
			dtoInfoContabilidadGasto.setDiario1Tipo(tablaGastos.getDiario1Tipo());
			dtoInfoContabilidadGasto.setDiario1Cuota(tablaGastos.getDiario1Cuota());
			dtoInfoContabilidadGasto.setDiario2(tablaGastos.getDiario2());
			if(tablaGastos.getDiario2() != null) {
				dtoInfoContabilidadGasto.setIsEmpty(false);
				dtoInfoContabilidadGasto.setDiario2Base(tablaGastos.getDiario2Base());
				dtoInfoContabilidadGasto.setDiario2Tipo(tablaGastos.getDiario2Tipo());
				dtoInfoContabilidadGasto.setDiario2Cuota(tablaGastos.getDiario2Cuota());	
			}else {
				dtoInfoContabilidadGasto.setIsEmpty(true);
			}	
		}else {
			dtoInfoContabilidadGasto.setIsEmpty(true);
		}

	}
	
	public void vGastosDiariosLbkToDto(DtoInfoContabilidadGasto dtoInfoContabilidadGasto, GastoProveedor gasto) {
		Filter filtroVista = genericDao.createFilter(FilterType.EQUALS, "id", gasto.getId());
		VDiarioCalculoLbk vDiarioCalculoLbk = genericDao.get(VDiarioCalculoLbk.class, filtroVista);
		if(vDiarioCalculoLbk != null) {
			dtoInfoContabilidadGasto.setDiario1(vDiarioCalculoLbk.getDiario1());
			dtoInfoContabilidadGasto.setDiario1Base(vDiarioCalculoLbk.getDiario1Base());
			dtoInfoContabilidadGasto.setDiario1Tipo(vDiarioCalculoLbk.getDiario1Tipo());
			dtoInfoContabilidadGasto.setDiario1Cuota(vDiarioCalculoLbk.getDiario1Cuota());
			dtoInfoContabilidadGasto.setDiario2(vDiarioCalculoLbk.getDiario2());
			if(vDiarioCalculoLbk.getDiario2() != null) {
				dtoInfoContabilidadGasto.setIsEmpty(false);
			}else {
				dtoInfoContabilidadGasto.setIsEmpty(true);
			}
			dtoInfoContabilidadGasto.setDiario2Base(vDiarioCalculoLbk.getDiario2Base());
			dtoInfoContabilidadGasto.setDiario2Tipo(vDiarioCalculoLbk.getDiario2Tipo());
			dtoInfoContabilidadGasto.setDiario2Cuota(vDiarioCalculoLbk.getDiario2Cuota());				
		}
	}
	
	public boolean isEstadosGastosLiberbankParaLecturaDirectaDeTabla(GastoProveedor gasto) {
		//True si el estado pertenece a alguno de los siguientes
		DDEstadoGasto estadoGasto = gasto.getEstadoGasto();
		return DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(estadoGasto.getCodigo()) || 
				  DDEstadoGasto.AUTORIZADO_PROPIETARIO.equals(estadoGasto.getCodigo()) ||
				  DDEstadoGasto.CONTABILIZADO.equals(estadoGasto.getCodigo()) ||
				  DDEstadoGasto.PAGADO.equals(estadoGasto.getCodigo()) ||
				  DDEstadoGasto.SUBSANADO.equals(estadoGasto.getCodigo()) ||
				  DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC.equals(estadoGasto.getCodigo());
	}
			
	
	@Override
	public boolean actualizarReparto(Long idLinea){
		
		 return gastoLineaDetalleManager.actualizarReparto(idLinea);
		
	}
	
	@Override
	public boolean actualizarRepartoTrabajo(Long idLinea){
		
		return gastoLineaDetalleManager.actualizarRepartoTrabajo(idLinea);
		
	}
	
	@Override
	public ActivoSubtipoGastoProveedorTrabajo getSubtipoGastoBySubtipoTrabajo(Trabajo trabajo) {
		if(trabajo == null || trabajo.getSubtipoTrabajo() == null) {
			return null;
		}
		
		Filter subtipoTrabajo = genericDao.createFilter(FilterType.EQUALS, "subtipoTrabajo.id", trabajo.getSubtipoTrabajo().getId());
		ActivoSubtipoGastoProveedorTrabajo subtipoGastoTrabajo = genericDao.get(ActivoSubtipoGastoProveedorTrabajo.class,subtipoTrabajo);
	
		
		return subtipoGastoTrabajo;
	}

	@Override
	public String getCodigoCarteraGastoByIdGasto(Long idGasto) {
		if (idGasto != null) {
			GastoProveedor gasto = this.findOne(idGasto);
			if (gasto != null && gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null) {
				return  gasto.getPropietario().getCartera().getCodigo();
			}
		}
		return null;
	}
	
	@Override
	public String validarAutorizacionSuplido(long idGasto) {
		
		GastoProveedor gasto = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", idGasto));
		String state = updaterStateApi.validarAutorizacionSuplido(gasto);
		
		if (!Checks.esNulo(state)) {
			throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede autorizar: " + state);
		}
		
		return state;
	}
	
	private Boolean esGastoAutorizado(GastoProveedor gasto) {
		
		if(gasto != null && gasto.getEstadoGasto() != null) {
			return DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo()) || DDEstadoGasto.AUTORIZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo())
					|| DDEstadoGasto.CONTABILIZADO.equals(gasto.getEstadoGasto().getCodigo()) || DDEstadoGasto.PAGADO.equals(gasto.getEstadoGasto().getCodigo());
		}
		
		return false;
	}
	
	@Override
	public String validacionNifEmisorFactura(DtoFichaGastoProveedor dto, Long idGasto) {
		
		GastoProveedor gastoProveedor = null;
		String error = null;
		
		if(idGasto != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
			gastoProveedor = genericDao.get(GastoProveedor.class, filtro);
		}
		
		if(gastoProveedor != null && gastoProveedor.getSuplidosVinculados() != null	&& DDSinSiNo.CODIGO_SI.equals(gastoProveedor.getSuplidosVinculados().getCodigo())
				&& ((dto.getReferenciaEmisor() != null && !dto.getReferenciaEmisor().equals(gastoProveedor.getReferenciaEmisor())) 
						|| (dto.getCodigoProveedorRem() != null && !dto.getCodigoProveedorRem().equals(gastoProveedor.getProveedor().getCodigoProveedorRem())))) {
			
			Filter filtroProveedorPadre = genericDao.createFilter(FilterType.EQUALS, "gastoProveedorPadre", gastoProveedor);
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			List<GastoSuplido> gastosSuplidos = genericDao.getList(GastoSuplido.class, filtroProveedorPadre, filtroBorrado);
			
			if(gastosSuplidos != null && !gastosSuplidos.isEmpty()) {
				if(error == null) {
					error = "";
				}
				error = "- No se debe modificar los campos 'Nº Factura / liquidacion' y 'NIF Emisor' mientras el gasto tenga suplidos";
			}
		}
		
		return error;
	}
	
	@Transactional
	public void actualizaSuplidosAsync(Long idGasto, Long codProveedorRem, String referenciaEmisor) {
		
		if(idGasto != null) {
			GastoProveedor gastoPrincipal = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", idGasto));
			
			if(gastoPrincipal != null) {
				
				List<GastoSuplido> gastosSuplidos = genericDao.getList(GastoSuplido.class, genericDao.createFilter(FilterType.EQUALS, "gastoProveedorPadre", gastoPrincipal));
				
				for(GastoSuplido suplido: gastosSuplidos) {
					
					GastoProveedor gastoSuplido = suplido.getGastoProveedorSuplido();
					
					if(codProveedorRem != null) {
						Filter filtroCodigoEmisorRem = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", codProveedorRem);
						ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroCodigoEmisorRem);
						
						GastoDetalleEconomico detalleGasto = genericDao.get(GastoDetalleEconomico.class, genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gastoSuplido.getId()));
						
						if(detalleGasto != null && detalleGasto.getAbonoCuenta() != null && detalleGasto.getAbonoCuenta() == 1
								&& proveedor != null && proveedor.getDocIdentificativo() != null) {
							detalleGasto.setNifTitularCuentaAbonar(proveedor.getDocIdentificativo());
							
							genericDao.update(GastoDetalleEconomico.class, detalleGasto);
						}
						
					}
					if(referenciaEmisor != null) {
						gastoSuplido.setNumeroFacturaPrincipal(referenciaEmisor);
					}
					genericDao.update(GastoProveedor.class, gastoSuplido);
				}
			}
		}
		
	}
	
	@Override
	public Double recalcularImporteRetencionGarantia(GastoDetalleEconomico gasto) {
		
		BigDecimal importeRetencionGarantia = new BigDecimal(0);
		boolean esDespues = false;
		if(gasto.getRetencionGarantiaAplica()==null || !gasto.getRetencionGarantiaAplica()) {
			return importeRetencionGarantia.doubleValue();
		}
		if(gasto.getTipoRetencion() != null && DDTipoRetencion.CODIGO_TRE_DESPUES.equals(gasto.getTipoRetencion().getCodigo())) {
			esDespues = true;
		}
		
		if(gasto.getGastoProveedor() != null) {
			DDCartera carteraGasto = gasto.getGastoProveedor().getCartera();
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getGastoProveedor().getId());
			List<GastoLineaDetalle> gastoLineaDetalleList = genericDao.getList(GastoLineaDetalle.class, filter);
	
			if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()){
				for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
					if(gastoLineaDetalle.getPrincipalSujeto() != null) {
						importeRetencionGarantia = importeRetencionGarantia.add(new BigDecimal(gastoLineaDetalle.getPrincipalSujeto()));
					}
					if(gastoLineaDetalle.getPrincipalNoSujeto() != null) {
						importeRetencionGarantia = importeRetencionGarantia.add(new BigDecimal(gastoLineaDetalle.getPrincipalNoSujeto()));
					}

					if(esDespues && gastoLineaDetalle.getImporteIndirectoCuota() != null
							&& carteraGasto != null && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(carteraGasto.getCodigo())) {
						importeRetencionGarantia = importeRetencionGarantia.add(new BigDecimal(gastoLineaDetalle.getImporteIndirectoCuota()));
					}
				}
			}
		}	
		
		return importeRetencionGarantia.doubleValue();
	}
	
	@Override 
	public Double recalcularCuotaRetencionGarantia(GastoDetalleEconomico detalleGasto, Double importeGarantiaBase) {
		BigDecimal importeCuotaBig  = new BigDecimal(0);
		if(detalleGasto.getRetencionGarantiaTipoImpositivo() != null) {
			Double importeCuota = (detalleGasto.getRetencionGarantiaTipoImpositivo() * importeGarantiaBase) / 100;
			importeCuotaBig = new BigDecimal(importeCuota);
			importeCuotaBig = importeCuotaBig.round(new MathContext(16, RoundingMode.HALF_UP)); 
		}
		
		return importeCuotaBig.doubleValue();
	}
	
	@Override
	public Long getIdByNumGasto(Long numGasto) {
		Long idGasto = null;
		try {
			idGasto = Long.parseLong(rawDao.getExecuteSQL("SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = " + numGasto + " AND BORRADO = 0"));
		} catch (Exception e) {
				return null;
		}			
			return idGasto;
	}
	
}
