package es.pfsgroup.plugin.rem.gastoProveedor;

import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
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
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoConfiguracionCuentasContables;
import es.pfsgroup.plugin.rem.model.ActivoConfiguracionPtdasPrep;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;
import es.pfsgroup.plugin.rem.model.ConfigPdaPresupuestaria;
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
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoImpugnacion;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoPrinex;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedorActivo;
import es.pfsgroup.plugin.rem.model.GastoProveedorTrabajo;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ProvisionGastos;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;
import es.pfsgroup.plugin.rem.model.VFacturasProveedores;
import es.pfsgroup.plugin.rem.model.VGastosProveedor;
import es.pfsgroup.plugin.rem.model.VGastosRefacturados;
import es.pfsgroup.plugin.rem.model.VTasasImpuestos;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioPago;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOperacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPagador;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.provisiongastos.dao.ProvisionGastosDao;
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
	
	private static final String COD_SI = "1";
	private static final String COD_NO = "0";

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
	private ActivoDao activoDao;

	@Override
	public GastoProveedor findOne(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		
		return genericDao.get(GastoProveedor.class, filtro );
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
		
		// HREOS-2179 - Búsqueda carterizada
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if (!Checks.esNulo(usuarioCartera)){
			if(!Checks.esNulo(usuarioCartera.getSubCartera())){
				dtoGastosFilter.setEntidadPropietariaCodigo(usuarioCartera.getCartera().getCodigo());
				dtoGastosFilter.setSubentidadPropietariaCodigo(usuarioCartera.getSubCartera().getCodigo());
			}else{
				dtoGastosFilter.setEntidadPropietariaCodigo(usuarioCartera.getCartera().getCodigo());
			}
		}
		
		
		// Comprobar si el usuario es externo y de tipo proveedor y, en tal caso, seteamos proveedores contacto del
		// usuario logado para filtrar los gastos en los que esté como emisor
		// Ademas si es un tipo de gestoria concreto, se filtrará los gastos que le pertenezcan como gestoria.
		if (gestorActivoDao.isUsuarioGestorExternoProveedor(usuarioLogado.getId())) {
			Boolean isGestoria = genericAdapter.tienePerfil(COD_PEF_GESTORIA_ADMINISTRACION, usuarioLogado) 
					|| genericAdapter.tienePerfil(COD_PEF_GESTORIA_PLUSVALIA, usuarioLogado) || genericAdapter.tienePerfil(COD_PEF_GESTORIA_POSTVENTA, usuarioLogado)
					|| genericAdapter.tienePerfil(COD_PEF_USUARIO_CERTIFICADOR, usuarioLogado);
			return gastoDao.getListGastosFilteredByProveedorContactoAndGestoria(dtoGastosFilter, usuarioLogado.getId(), isGestoria, false);
		}

		return gastoDao.getListGastos(dtoGastosFilter);
	}
	
	@Override
	public DtoPage getListGastosExcel(DtoGastosFilter dtoGastosFilter) {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		// HREOS-2179 - Búsqueda carterizada
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if (!Checks.esNulo(usuarioCartera)){
			if(!Checks.esNulo(usuarioCartera.getSubCartera())){
				dtoGastosFilter.setEntidadPropietariaCodigo(usuarioCartera.getCartera().getCodigo());
				dtoGastosFilter.setSubentidadPropietariaCodigo(usuarioCartera.getSubCartera().getCodigo());
			}else{
				dtoGastosFilter.setEntidadPropietariaCodigo(usuarioCartera.getCartera().getCodigo());
			}
		}
		
		
		// Comprobar si el usuario es externo y de tipo proveedor y, en tal caso, seteamos proveedores contacto del
		// usuario logado para filtrar los gastos en los que esté como emisor
		// Ademas si es un tipo de gestoria concreto, se filtrará los gastos que le pertenezcan como gestoria.
		if (gestorActivoDao.isUsuarioGestorExternoProveedor(usuarioLogado.getId())) {
			Boolean isGestoria = genericAdapter.tienePerfil(COD_PEF_GESTORIA_ADMINISTRACION, usuarioLogado) 
					|| genericAdapter.tienePerfil(COD_PEF_GESTORIA_PLUSVALIA, usuarioLogado) || genericAdapter.tienePerfil(COD_PEF_GESTORIA_POSTVENTA, usuarioLogado)
					|| genericAdapter.tienePerfil(COD_PEF_USUARIO_CERTIFICADOR, usuarioLogado);
			return gastoDao.getListGastosFilteredByProveedorContactoAndGestoria(dtoGastosFilter, usuarioLogado.getId(), isGestoria, true);
		}

		return gastoDao.getListGastosExcel(dtoGastosFilter);
	}

	private DtoFichaGastoProveedor gastoToDtoFichaGasto(GastoProveedor gasto) {

		DtoFichaGastoProveedor dto = new DtoFichaGastoProveedor();

		if (!Checks.esNulo(gasto)) {

			dto.setIdGasto(gasto.getId());
			dto.setNumGastoHaya(gasto.getNumGastoHaya());
			dto.setNumGastoGestoria(gasto.getNumGastoGestoria());
			dto.setReferenciaEmisor(gasto.getReferenciaEmisor());
			
			if(gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null){
				dto.setCartera(gasto.getPropietario().getCartera().getCodigo());
			}else if(gasto.getCartera() != null){
				dto.setCartera(gasto.getCartera().getCodigo());
			}else{
				dto.setCartera(null);
			}
			dto.setSubcartera(gasto.getSubcartera() == null ? null : gasto.getSubcartera().getCodigo());

			if (!Checks.esNulo(gasto.getTipoGasto())) {
				dto.setTipoGastoCodigo(gasto.getTipoGasto().getCodigo());
				dto.setTipoGastoDescripcion(gasto.getTipoGasto().getDescripcion());
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
			dto.setAsignadoATrabajos(!Checks.estaVacio(gasto.getGastoProveedorTrabajos()));
			dto.setAsignadoAActivos(!Checks.estaVacio(gasto.getGastoProveedorTrabajos())
					|| (Checks.estaVacio(gasto.getGastoProveedorTrabajos()) && !Checks.estaVacio(gasto.getGastoProveedorActivos())));

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

			if (!Checks.esNulo(gasto.getGastoSinActivos())) {
				dto.setGastoSinActivos(BooleanUtils.toBoolean(gasto.getGastoSinActivos()));
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
					dto.setImporteTotal(gasto.getGastoDetalleEconomico().getImporteTotal()+gastoTotal);
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
			
//			if (gasto.getGastoLineaDetalle() != null && gasto.getGastoLineaDetalle().getTipoImpuesto() != null) {
//				dto.setCodigoImpuestoIndirecto(gasto.getGastoLineaDetalle().getTipoImpuesto().getCodigo());
//			}			
			
			
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
			
			if (!Checks.esNulo(listaGastosRefacturables) && listaGastosRefacturables.size() > 0) {
				if (!Checks.esNulo(dto.getCartera())
						&& (DDCartera.CODIGO_CARTERA_SAREB.equals(dto.getCartera())
								|| DDCartera.CODIGO_CARTERA_BANKIA.equals(dto.getCartera()))) {
					dto.setTieneGastosRefacturables(true);
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
				|| DDEstadoGasto.PENDIENTE.equals(gasto.getEstadoGasto().getCodigo()))
			) {
				dto.setEstadoModificarLineasDetalleGasto(true);
			}else {
				dto.setEstadoModificarLineasDetalleGasto(false);
			}
			
			dto.setIsGastoRefacturadoPorOtroGasto(this.isGastoRefacturadoPorOtroGasto(gasto.getId()));
			
		}

		return dto;
	}

	@SuppressWarnings("deprecation")
	@Override
	@Transactional(readOnly = false)
	public GastoProveedor createGastoProveedor(DtoFichaGastoProveedor dto) {

		GastoProveedor gastoProveedor = new GastoProveedor();
		Usuario usuario = genericAdapter.getUsuarioLogado();
		Double importeGastosRefacturables = 0.0;
		
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
					gastoRefacturable.setGastoProveedor(gastoRefacturableHaya.getId());
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

		if (!Checks.esNulo(dto.getGastoSinActivos())) {
			gastoProveedor.setGastoSinActivos(BooleanUtils.toIntegerObject(dto.getGastoSinActivos()));
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
			//updaterStateApi.updaterStates(gastoProveedor, gastoProveedor.getEstadoGasto().getCodigo());
		}else {
			updaterStateApi.updaterStates(gastoProveedor, null);
		}
		/*
		if(!Checks.estaVacio(gastoProveedor.getGastoProveedorActivos())
				&& DDCartera.CODIGO_CARTERA_CERBERUS.equals(gastoProveedor.getGastoProveedorActivos().get(0).getActivo().getCartera().getCodigo())
				&& (DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(gastoProveedor.getGastoProveedorActivos().get(0).getActivo().getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(gastoProveedor.getGastoProveedorActivos().get(0).getActivo().getSubcartera().getCodigo())
					|| DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(gastoProveedor.getGastoProveedorActivos().get(0).getActivo().getSubcartera().getCodigo()))) 
		{
			gastoProveedor = asignarCuentaContableYPartidaGasto(gastoProveedor);
		}*/
		
		genericDao.update(GastoProveedor.class, gastoProveedor);

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
			List<GastoProveedorActivo> gastoProveedorActivo = new ArrayList<GastoProveedorActivo>();;
			Long idGastoProveedor = gastoProveedor.getId();
			
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id",idGastoProveedor);
			gastoProveedorActivo = genericDao.getList(GastoProveedorActivo.class, filtro2);
		if(!Checks.estaVacio(gastoProveedorActivo)) {
			for (GastoProveedorActivo gastoProveedorObject : gastoProveedorActivo) {
				if(!Checks.esNulo(gastoProveedorObject)) {
					Activo activo = new Activo();
					activo = gastoProveedorObject.getActivo();
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
					
					String result = rawDao.getExecuteSQL("SELECT SUM(GPL_IMPORTE_GASTO) FROM GPL_GASTOS_PRINEX_LBK WHERE GPV_ID = " + idGasto);	
					gastoTotal = Double.valueOf(result);
					for (GastoPrinex gastoPrinex : listGastoPrinex) {
						if(!Checks.esNulo(gastoPrinex.getIdActivo())) {
							GastoProveedorActivo gastoProveedorActivos = null;
							
							Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id",idGasto);
							Filter filtro4 = genericDao.createFilter(FilterType.EQUALS, "activo.id",gastoPrinex.getIdActivo());

							gastoProveedorActivos = genericDao.get(GastoProveedorActivo.class, filtro2,filtro4);
							Float participacionGasto = (float) ((gastoPrinex.getImporteGasto()*100)/gastoTotal);

							DecimalFormat df = new DecimalFormat("##.####");
							df.setRoundingMode(RoundingMode.HALF_DOWN);
							
							//truncamos a 4 decimales
							participacionGasto = Float.valueOf(df.format(participacionGasto).replace(',', '.'));
							
							if(!Checks.esNulo(gastoProveedorActivos)) {
								gastoProveedorActivos.setParticipacionGasto(participacionGasto);
								genericDao.update(GastoProveedorActivo.class, gastoProveedorActivos);
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
					List<GastoProveedorActivo> gastosActivosList = gasto.getGastoProveedorActivos();
					this.calculaPorcentajeEquitativoGastoActivos(gastosActivosList);
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
			
			/*if(!Checks.esNulo(detalleGasto.getGastoProveedor())) {
				GastoPrinex gastoPrinex = new GastoPrinex();
				List<GastoPrinex> listGastoPrinex = new ArrayList<GastoPrinex>();
				Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "idGasto",gasto.getId());
				Order order = new Order(OrderType.ASC, "id");
				listGastoPrinex = genericDao.getListOrdered(GastoPrinex.class,order,filtro3);
				if(!Checks.estaVacio(listGastoPrinex)) {
					gastoPrinex = listGastoPrinex.get(0);
					if(!Checks.esNulo(gastoPrinex)) {
						Double importePromocion = 0.0;
						Double diarioBase = 0.0;
						Double diarioCuota = 0.0;
						Double diario2Base = 0.0;
						
						if(!Checks.esNulo(gastoPrinex.getDiario2())) {
							if(("60").equals(gastoPrinex.getDiario2())){
								dto.setExencionlbk(gastoPrinex.getDiario2Base());
								if("20".equals(gastoPrinex.getDiario1())){
									dto.setProrrata(true);
								}else {
									dto.setProrrata(false);
								}
							}										
						}						
						for (GastoProveedorActivo gastoActivo : gasto.getGastoProveedorActivos()) {
							if(!Checks.esNulo(gastoActivo.getParticipacionGasto()) && Checks.esNulo(gastoActivo.getActivo())) {
							importePromocion+=gastoActivo.getParticipacionGasto()/100*detalleGasto.getImporteTotal();
							}
						}		
						dto.setTotalImportePromocion(importePromocion);
					
						if(!Checks.esNulo(gastoPrinex.getDiario1())) {
							if(!Checks.esNulo(gastoPrinex.getDiario1Base())) {
								//diarioBase=gastoPrinex.getDiario1Base();
								if(!Checks.esNulo(detalleGasto.getImportePrincipalSujeto())) {
									diarioBase = detalleGasto.getImportePrincipalSujeto();
								}
								
							}
							if(!Checks.esNulo(gastoPrinex.getDiario1Cuota())) {
								//diarioCuota=gastoPrinex.getDiario1Cuota();
								if(!Checks.esNulo(detalleGasto.getImpuestoIndirectoCuota())) {
									diarioCuota = detalleGasto.getImpuestoIndirectoCuota();
								}
							}
							
							if(!Checks.esNulo(gastoPrinex.getDiario2())) {
								if(!Checks.esNulo(gastoPrinex.getDiario2Base())) {
									diario2Base=gastoPrinex.getDiario2Base();
								}									
							}
							Double importeTotalPrinex = diarioBase+diarioCuota+diario2Base+importePromocion;							
							dto.setImporteTotalPrinex(importeTotalPrinex);							
						}					
					}
				}					
			}*/
			
			dto.setIrpfTipoImpositivo(detalleGasto.getIrpfTipoImpositivo());
			dto.setIrpfCuota(detalleGasto.getIrpfCuota());
			dto.setBaseImpI(detalleGasto.getIrpfBase());
			dto.setClave(detalleGasto.getIrpfClave());
			dto.setSubclave(detalleGasto.getIrpfSubclave());
			
			
			dto.setIrpfTipoImpositivoRetG(detalleGasto.getRetencionGarantiaTipoImpositivo());
			dto.setBaseRetG(detalleGasto.getRetencionGarantiaBase());
			dto.setRetencionGarantiaAplica(detalleGasto.getRetencionGarantiaAplica());
			dto.setIrpfCuotaRetG(detalleGasto.getRetencionGarantiaCuota());
			
		
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
			
			/* Anyadimos el importe de los gastos refacturables asociados */
			/*Double importeGastosRefacturables = 0.0;
			
			for (GastoProveedor gastoRefactu : getGastosRefacturablesGasto(gasto.getId())) {
				if(!Checks.esNulo(gastoRefactu.getGastoDetalleEconomico()) && !Checks.esNulo(gastoRefactu.getGastoDetalleEconomico().getImporteTotal())) {
					importeGastosRefacturables += gastoRefactu.getGastoDetalleEconomico().getImporteTotal();
				}
			}
			*/
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
				DtoDetalleEconomicoGasto dtoFin = detalleEconomicoToDtoDetalleEconomico(gasto);
				
				if(!Checks.esNulo(dto.getGastoRefacturableB())) {
					detalleGasto.setGastoRefacturable(dto.getGastoRefacturableB());					
				}
				
				if(DDDestinatarioGasto.CODIGO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo()) && gasto.getGastoDetalleEconomico().getGastoRefacturable()) {
					gasto = asignarCuentaContableYPartidaGasto(gasto);
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
				if( dto.getBaseRetG() != null) {
					detalleGasto.setRetencionGarantiaBase(dto.getBaseRetG());
				}
				if( dto.getRetencionGarantiaAplica() != null) {
					detalleGasto.setRetencionGarantiaAplica(dto.getRetencionGarantiaAplica());
				}
				if(dto.getIrpfCuotaRetG() != null) {
					detalleGasto.setRetencionGarantiaCuota(dto.getIrpfCuotaRetG());
				}
				
				
				Double importeTotal = recalcularImporteTotalGasto(detalleGasto);
				detalleGasto.setImporteTotal(importeTotal);
				
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
//		List<GastoProveedorTrabajo> gastosTrabajosActivos;

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idGasto", idGasto);
		gastosActivos = genericDao.getList(VBusquedaGastoActivo.class, filtro);
//		Filter filtroGastosTrabajos = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
//		gastosTrabajosActivos = genericDao.getList(GastoProveedorTrabajo.class, filtroGastosTrabajos);
//		for (VBusquedaGastoActivo vBusquedaGastoActivo : gastosActivos) {
//			for (GastoProveedorTrabajo gastoProveedorTrabajo : gastosTrabajosActivos) {
//				Activo activo = gastoProveedorTrabajo.getTrabajo().getActivo();
//				if (!Checks.esNulo(activo) && activoDao.isUnidadAlquilable(activo.getId()) && activoDao.isActivoMatriz(vBusquedaGastoActivo.getIdActivo())) {
//					Long idAM = activoDao.getIdActivoMatriz(activoDao.getAgrupacionPAByIdActivo(activo.getId()).getId());
//					if (vBusquedaGastoActivo.getIdActivo().equals(idAM)) {
//						vBusquedaGastoActivo.setIdActivo(activo.getId());
//						vBusquedaGastoActivo.setNumActivo(activo.getNumActivo());
//					}
//				}
//			}
//		}

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

			Filter filtroG = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
			Filter filtroA = genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", numActivo);
			GastoProveedorActivo gastoActivo = genericDao.get(GastoProveedorActivo.class, filtroG, filtroA);

			if (Checks.esNulo(gastoActivo)) {

				if (DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())
						&& Checks.esNulo(activo.getNumInmovilizadoBnk())) {
					throw new JsonViewerException("El activo carece de nº inmovilizado Bankia");
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

					GastoProveedorActivo gastoProveedorActivo = new GastoProveedorActivo();
					gastoProveedorActivo.setActivo(activo);
					gastoProveedorActivo.setGastoProveedor(gasto);
					if (!Checks.estaVacio(activosCatastro)) {
						gastoProveedorActivo.setReferenciaCatastral(activosCatastro.get(0).getRefCatastral());
					}

					List<GastoProveedorActivo> gastosActivosList = gasto.getGastoProveedorActivos();
					if( gastosActivosList == null) {
						gastosActivosList = new ArrayList<GastoProveedorActivo>();
					}
					gastosActivosList.add(gastoProveedorActivo);

				
					this.calculaPorcentajeEquitativoGastoActivos(gastosActivosList);	
						
					genericDao.save(GastoProveedorActivo.class, gastoProveedorActivo);
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

									GastoProveedorActivo gastoProveedorActivo = new GastoProveedorActivo();
									gastoProveedorActivo.setActivo(activoAgrupacion.getActivo());
									gastoProveedorActivo.setGastoProveedor(gasto);
									if (!Checks.estaVacio(activosCatastro)) {
										gastoProveedorActivo.setReferenciaCatastral(activosCatastro.get(0).getRefCatastral());
									}

									List<GastoProveedorActivo> gastosActivosList = gasto.getGastoProveedorActivos();
									gastosActivosList.add(gastoProveedorActivo);

									this.calculaPorcentajeEquitativoGastoActivos(gastosActivosList);

									genericDao.save(GastoProveedorActivo.class, gastoProveedorActivo);
								
							
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
	private void calculaPorcentajeEquitativoGastoActivos(List<GastoProveedorActivo> gastosActivosList) {
		if (gastosActivosList == null || gastosActivosList.size() == 0) {
			return;
		}
		
		List<GastoPrinex> gastoPrinexList = new ArrayList<GastoPrinex>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idGasto",gastosActivosList.get(0).getGastoProveedor().getId());
		gastoPrinexList = genericDao.getList(GastoPrinex.class, filtro);
		if(!Checks.estaVacio(gastoPrinexList)) {
		GastoPrinex gastoPrinex = new GastoPrinex();
		int contador = 0;
		Float porcentajePrinex = 0f;
		for (GastoProveedorActivo gastoProveedorItem : gastosActivosList) {
			Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "idActivo",gastoProveedorItem.getActivo().getId());
			gastoPrinex = genericDao.get(GastoPrinex.class, filtro,filtro3);
			if(!Checks.esNulo(gastoPrinex)) {
				contador++;
				porcentajePrinex+=gastoProveedorItem.getParticipacionGasto();
			}
		}
		
		DecimalFormat df = new DecimalFormat("##.####");
		df.setRoundingMode(RoundingMode.HALF_DOWN);
		// Calcular porcentaje equitativo.
		Float numActivos = (float) gastosActivosList.size() - contador;
		
		Float porcentaje =(float)0;
		if(numActivos > 0) {
			porcentaje = (100f-porcentajePrinex) / numActivos;
		}		
		
		//truncamos a 4 decimales
		porcentaje = Float.valueOf(df.format(porcentaje).replace(',', '.'));
		
		
		
		for (GastoProveedorActivo gastoProveedor : gastosActivosList) {
			Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "idActivo",gastoProveedor.getActivo().getId());
			gastoPrinex = genericDao.get(GastoPrinex.class, filtro,filtro3);
			if(Checks.esNulo(gastoPrinex)) {
				gastoProveedor.setParticipacionGasto(porcentaje);
			}
		}
		
		}else{
		
			DecimalFormat df = new DecimalFormat("##.##");
			df.setRoundingMode(RoundingMode.DOWN);
			// Calcular porcentaje equitativo.
			Float numActivos = (float) gastosActivosList.size();
			
			Float porcentaje = 100f / numActivos;
			
			//truncamos a dos decimales
			porcentaje = Float.valueOf(df.format(porcentaje).replace(',', '.'));
			
			
			Float resto = 100f - (porcentaje * numActivos);
	
			for (GastoProveedorActivo gastoProveedor : gastosActivosList) {
				gastoProveedor.setParticipacionGasto(porcentaje);
			}
			
			//si la divisón de gastos no es exacta añadimos el resto a el ultimo activo
			if(resto > 0 && gastosActivosList.size() > 0){
				GastoProveedorActivo elUltimoActivo = gastosActivosList.get(gastosActivosList.size()-1);
				elUltimoActivo.setParticipacionGasto(elUltimoActivo.getParticipacionGasto()+resto);
			}
		}
	}
	
	public float regulaPorcentajeUltimoGasto(List<GastoProveedorActivo> gastosActivosList, Float ultimoPorcentaje){
		if(Checks.esNulo(gastosActivosList) || Checks.estaVacio(gastosActivosList)){
			return ultimoPorcentaje;
		}
		
		Float porcentajeTotal = 0f;
		
		for (GastoProveedorActivo gastoProveedor : gastosActivosList){
			porcentajeTotal += gastoProveedor.getParticipacionGasto();
		}
		
		Float resto = 100f - porcentajeTotal;
		if(resto != 0){
			ultimoPorcentaje = ultimoPorcentaje + resto;
		}
		
		return ultimoPorcentaje;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateGastoActivo(DtoActivoGasto dtoActivoGasto) {

		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoGasto.getId());
			GastoProveedorActivo gastoActivo = genericDao.get(GastoProveedorActivo.class, filtro);

			if (!Checks.esNulo(dtoActivoGasto.getParticipacion())) {
				gastoActivo.setParticipacionGasto(dtoActivoGasto.getParticipacion());
			}

			if (!Checks.esNulo(dtoActivoGasto.getReferenciaCatastral())) {
				gastoActivo.setReferenciaCatastral(dtoActivoGasto.getReferenciaCatastral());
			}

			genericDao.update(GastoProveedorActivo.class, gastoActivo);

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
			GastoProveedorActivo gastoActivo = genericDao.get(GastoProveedorActivo.class, filtro);
			if (gastoActivo == null) {
				return false;
			}

			GastoProveedor gasto = gastoActivo.getGastoProveedor();

			// Borramos la asignación del activo.
			genericDao.deleteById(GastoProveedorActivo.class, dtoActivoGasto.getId());

			if (gasto == null) {
				return false;
			}
			List<GastoProveedorActivo> gastosActivosList = gasto.getGastoProveedorActivos();
			gastosActivosList.remove(gastoActivo);

			this.calculaPorcentajeEquitativoGastoActivos(gastosActivosList);

			// Volvemos a establecer propietario.
			// gasto = asignarPropietarioGasto(gasto); HREOS-7939 se solicita que no se recalcule el propietario al borrar un activo afectado.


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
				if (!Checks.esNulo(contabilidadGasto.getContabilizadoPor())) {
					dto.setContabilizadoPorDescripcion(contabilidadGasto.getContabilizadoPor().getDescripcion());
				}
				if(!Checks.esNulo(contabilidadGasto.getActivable())){
					dto.setComboActivable(contabilidadGasto.getActivable().getCodigo());
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
				/*
				if(dtoContabilidadGasto.getIdSubpartidaPresupuestaria() != null) {
					Filter filtroSubpartidaPresupuestaria = genericDao.createFilter(FilterType.EQUALS, "id", dtoContabilidadGasto.getIdSubpartidaPresupuestaria());
					ConfiguracionSubpartidasPresupuestarias cps = genericDao.get(ConfiguracionSubpartidasPresupuestarias.class, filtroSubpartidaPresupuestaria);
					
					contabilidadGasto.setConfiguracionSubpartidasPresupuestarias(cps);
				}
				*/

				if(!Checks.esNulo(dtoContabilidadGasto.getComboActivable())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoContabilidadGasto.getComboActivable());
					codSiNo = (DDSinSiNo) genericDao.get(DDSinSiNo.class, filtro);
					contabilidadGasto.setActivable(codSiNo);
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

						List<GastoProveedorTrabajo> listaGastoTrabajo = gasto.getGastoProveedorTrabajos();
						for (GastoProveedorTrabajo gastoTrabajo : listaGastoTrabajo) {
							Trabajo trabajo = gastoTrabajo.getTrabajo();
							trabajo.setFechaEmisionFactura(null);
							genericDao.save(Trabajo.class, trabajo);
							genericDao.deleteById(GastoProveedorTrabajo.class, gastoTrabajo.getId());
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
			
			List<GastoProveedorTrabajo> gastosTrabajo = genericDao.getList(GastoProveedorTrabajo.class, 
					genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId()),
					genericDao.createFilter(FilterType.EQUALS, "trabajo.id", idTrabajo));
			
			if(Checks.estaVacio(gastosTrabajo)) {
				Trabajo trabajo = trabajoApi.findOne(idTrabajo);
				// Marcamos la fecha de emisión de factura en el trabajo
				trabajo.setFechaEmisionFactura(gasto.getFechaEmision());
				genericDao.save(Trabajo.class, trabajo);
	
				// Asignamos el trabajo al gasto
				GastoProveedorTrabajo gastoTrabajo = new GastoProveedorTrabajo();
				gastoTrabajo.setTrabajo(trabajo);
				gastoTrabajo.setGastoProveedor(gasto);
	
				genericDao.save(GastoProveedorTrabajo.class, gastoTrabajo);
				gasto.getGastoProveedorTrabajos().add(gastoTrabajo);
	
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

			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getActivo().getId());
			Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoProveedorActivo gastoActivo = genericDao.get(GastoProveedorActivo.class, filtroActivo, filtroGasto);

			// Si no existe ya
			if (Checks.esNulo(gastoActivo)) {
				gastoActivo = new GastoProveedorActivo();
				gastoActivo.setActivo(activo.getActivo());
				gastoActivo.setGastoProveedor(gasto);
				gastoActivo.setParticipacionGasto(activo.getParticipacion());

				genericDao.save(GastoProveedorActivo.class, gastoActivo);
				gasto.getGastoProveedorActivos().add(gastoActivo);
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
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
			GastoProveedorTrabajo gastoTrabajoEliminado = genericDao.get(GastoProveedorTrabajo.class, filtro, filtro2);
			if (!Checks.esNulo(gastoTrabajoEliminado)) {
				gastoDao.deleteGastoTrabajoById(gastoTrabajoEliminado.getId());
			}

			Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "id", id);
			Trabajo trabajo = genericDao.get(Trabajo.class, filtroTrabajo);
			trabajo.setFechaEmisionFactura(null);
			genericDao.save(Trabajo.class, trabajo);
		}

		// Desasignamos TODOS los activos
		for (GastoProveedorActivo gastoActivo : gasto.getGastoProveedorActivos()) {
			genericDao.deleteById(GastoProveedorActivo.class, gastoActivo.getId());
		}
		gasto.getGastoProveedorActivos().clear();

		// Volvemos a asignar los activos de los trabajos que queden
		for (GastoProveedorTrabajo gastoTrabajo : gasto.getGastoProveedorTrabajos()) {

			asignarActivos(gasto, gastoTrabajo.getTrabajo());
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
		
		for (GastoProveedorTrabajo gastoTrabajo : gasto.getGastoProveedorTrabajos()) {
			if (!Checks.esNulo(gastoTrabajo.getTrabajo().getImporteTotal())) {
				importeGasto += gastoTrabajo.getTrabajo().getImporteTotal();
			}
			if (!Checks.esNulo(gastoTrabajo.getTrabajo().getImporteProvisionesSuplidos())) {
				importeProvisionesSuplidos += gastoTrabajo.getTrabajo().getImporteProvisionesSuplidos();
			}
		}

		//gasto.getGastoLineaDetalle().setPrincipalSujeto(importeGasto);
		//gasto.getGastoLineaDetalle().setProvSuplidos(importeProvisionesSuplidos);
		gasto.getGastoDetalleEconomico().setImporteTotal(importeGasto + importeProvisionesSuplidos);

		return gasto;
	}

	private GastoProveedor calcularParticipacionActivosGasto(GastoProveedor gasto) {

		Double importeTotal = gastoLineaDetalleApi.calcularPrincipioSujetoLineasDetalle(gasto);
		importeTotal = Checks.esNulo(importeTotal) ? new Double("0L") : importeTotal;
		Map<Long, Double> mapa = new HashMap<Long, Double>();

		for (GastoProveedorTrabajo gastoTrabajo : gasto.getGastoProveedorTrabajos()) {
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

		for (GastoProveedorActivo gastoActivo : gasto.getGastoProveedorActivos()) {
			Long idActivo = gastoActivo.getActivo().getId();
			if (!mapa.isEmpty() && !Checks.esNulo(mapa.get(idActivo))) {
				gastoActivo.setParticipacionGasto((float) (mapa.get(idActivo) * 100 / importeTotal));
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
			String error = updaterStateApi.validarCamposMinimos(gasto);
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
		gasto.setGastoGestion(gastoGestion);
		updaterStateApi.updaterStates(gasto, DDEstadoGasto.AUTORIZADO_ADMINISTRACION);
		gasto.setProvision(null);
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
			}else if(DDEstadoGasto.SUBSANADO.equals(gasto.getEstadoGasto().getCodigo())){
				gastoInfoContabilidad.setFechaContabilizacion(miFechaConta);
				gastoDetalleEconomico.setFechaPago(miFechaPago);
				gasto.setGastoDetalleEconomico(gastoDetalleEconomico);
				gasto.setGastoInfoContabilidad(gastoInfoContabilidad);
				gasto.setEstadoGasto(pagado);
			}else if(DDEstadoGasto.CONTABILIZADO.equals(gasto.getEstadoGasto().getCodigo())){
				gastoDetalleEconomico.setFechaPago(miFechaPago);
				gasto.setGastoDetalleEconomico(gastoDetalleEconomico);
				gasto.setEstadoGasto(pagado);
			}
		}else if(!Checks.esNulo(miFechaConta) && Checks.esNulo(miFechaPago)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoGasto.CONTABILIZADO);
			DDEstadoGasto contabilizado = genericDao.get(DDEstadoGasto.class, filtro);
			
			if(DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())){
				GastoInfoContabilidad gastoInfoContabilidad = gasto.getGastoInfoContabilidad();
				gastoInfoContabilidad.setFechaContabilizacion(miFechaConta);
				gasto.setGastoInfoContabilidad(gastoInfoContabilidad);
				gasto.setEstadoGasto(contabilizado);
			}else if(DDEstadoGasto.SUBSANADO.equals(gasto.getEstadoGasto().getCodigo())){
				GastoInfoContabilidad gastoInfoContabilidad = gasto.getGastoInfoContabilidad();
				gastoInfoContabilidad.setFechaContabilizacion(miFechaConta);
				gasto.setGastoInfoContabilidad(gastoInfoContabilidad);
				gasto.setEstadoGasto(contabilizado);
			}
		}else if(Checks.esNulo(miFechaConta) && !Checks.esNulo(miFechaPago)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoGasto.PAGADO);
			DDEstadoGasto estadoGasto = genericDao.get(DDEstadoGasto.class, filtro);
			
			if(DDEstadoGasto.CONTABILIZADO.equals(gasto.getEstadoGasto().getCodigo())){
				GastoDetalleEconomico gastoDetalleEconomico = gasto.getGastoDetalleEconomico();
				gastoDetalleEconomico.setFechaPago(miFechaPago);
				gasto.setGastoDetalleEconomico(gastoDetalleEconomico);
				gasto.setEstadoGasto(estadoGasto);
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
		
		String error = updaterStateApi.validarCamposMinimos(gasto);
		if (!Checks.esNulo(error)) {
			throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede rechazar: " + error);
		}
		

		// Se activa el borrado de los gastos-trabajo, y dejamos el trabajo como diponible para un
		// futuro nuevo gasto
		this.reactivarTrabajoParaGastos(gasto.getGastoProveedorTrabajos());

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
				String error = updaterStateApi.validarCamposMinimos(gasto);
				if (!Checks.esNulo(error)) {
					throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede rechazar: " + error);
				}
				
				// Se activa el borrado de los gastos-trabajo, y dejamos el trabajo como diponible para un
				// futuro nuevo gasto
				this.reactivarTrabajoParaGastos(gasto.getGastoProveedorTrabajos());

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
	private void reactivarTrabajoParaGastos(List<GastoProveedorTrabajo> listaGastoTrabajo) {

		if (!Checks.estaVacio(listaGastoTrabajo)) {
			for (GastoProveedorTrabajo gpvTrabajo : listaGastoTrabajo) {

				Trabajo trabajo = gpvTrabajo.getTrabajo();
				if (!Checks.esNulo(trabajo)) {
					trabajo.setFechaEmisionFactura(null);
					genericDao.update(Trabajo.class, trabajo);
				}

				//genericDao.deleteById(GastoProveedorTrabajo.class, gpvTrabajo.getId());
			}
		}
	}

	public GastoProveedor asignarPropietarioGasto(GastoProveedor gasto) {

		if (!Checks.estaVacio(gasto.getGastoProveedorActivos()) && gasto.getPropietario() == null) {

			GastoProveedorActivo gastoActivo = gasto.getGastoProveedorActivos().get(0);
			gasto.setPropietario(gastoActivo.getActivo().getPropietarioPrincipal());

		}

		return gasto;
	}
	
	@Override
	public boolean estanTodosActivosAlquilados(GastoProveedor gasto) {
		boolean todosActivoAlquilados = false;
		boolean auxiliarSalir = true;
		
		List<Activo> activos = gastoLineaDetalleApi.devolverActivosDeLineasDeGasto(gasto);

		if(activos != null && !activos.isEmpty()) {
			for (Activo activo : activos) {
				
				if(activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getOcupado() != null
						&& activo.getSituacionPosesoria().getConTitulo() != null &&  activo.getSituacionPosesoria().getOcupado() == 1
						&& DDTipoTituloActivoTPA.tipoTituloSi.equals(activo.getSituacionPosesoria().getConTitulo().getCodigo())
						&& activo.getSituacionPosesoria().getTipoTituloPosesorio() != null 
						&&  DDTipoTituloPosesorio.CODIGO_ARRENDAMIENTO.equals(activo.getSituacionPosesoria().getTipoTituloPosesorio().getCodigo())) {
							todosActivoAlquilados = true;
							auxiliarSalir = false;
				}
				if(auxiliarSalir) {
					todosActivoAlquilados = false;
					break;
				}
				
				auxiliarSalir = true;
			}
		}

		return todosActivoAlquilados;
	}

	public GastoProveedor asignarCuentaContableYPartidaGasto(GastoProveedor gasto) {

		//ConfigCuentaContable cuenta = buscarCuentaContable(gasto);		
		//ConfigPdaPresupuestaria partida = buscarPartidaPresupuestaria(gasto);
		//GastoLineaDetalle gastoLineaDetalle = gasto.getGastoLineaDetalle();
		GastoInfoContabilidad gastoInfoContabilidad = gasto.getGastoInfoContabilidad();
		boolean todosActivoAlquilados= false;
		DDCartera cartera = null;
		
		if (!Checks.esNulo(gasto.getPropietario())) {
			cartera = gasto.getPropietario().getCartera();
		}else{
			//si no hay propietario es sareb
			cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, DDCartera.CODIGO_CARTERA_SAREB);
		}
		
		if (/*!Checks.esNulo(gastoLineaDetalle) &&*/ !Checks.esNulo(cartera) && !Checks.esNulo(gastoInfoContabilidad)) {

			Ejercicio ejercicio = gastoInfoContabilidad.getEjercicio();
			
			Filter filtroBorrado= genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroEjercicioCuentaContable= genericDao.createFilter(FilterType.EQUALS, "ejercicio.id", ejercicio.getId());
			//Filter filtroSubtipoGasto= genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", gasto.getGastoLineaDetalle().getSubtipoGasto().getId());
			Filter filtroCartera= genericDao.createFilter(FilterType.EQUALS, "cartera.id", cartera.getId());
			Filter filtroSubcartera = null;
			if(!Checks.esNulo(gasto.getSubcartera())) {
				filtroSubcartera= genericDao.createFilter(FilterType.EQUALS, "subcartera.id", gasto.getSubcartera().getId());
			}
			Filter filtroSubcarteraNull= genericDao.createFilter(FilterType.NULL, "subcartera.id");
			Filter filtroCuentaArrendamiento= genericDao.createFilter(FilterType.EQUALS, "arrendamiento", 1);
			Filter filtroCuentaNoArrendamiento= genericDao.createFilter(FilterType.EQUALS, "arrendamiento", 0);
			
			/*HREOS-7241. Calculamos si tenemos que filtrar por REFACTURABLE 0 (si el gasto no es refacturable) /1 (si el gasto es facturable)*/
			int filtrarRefacturar = 0;
			if(this.esGastoRefacturable(gasto)) {
				filtrarRefacturar = 1;
			} 
			
			Filter filtroRefacturablePP = genericDao.createFilter(FilterType.EQUALS, "refacturable", filtrarRefacturar);
			Filter filtroRefacturableCC = genericDao.createFilter(FilterType.EQUALS, "refacturable", filtrarRefacturar);
			/*HREOS*/
			
			/* HREOS-7241 Se quita el filtro propietario a peticion de Daniel Albert (39/07/19)
			 * Filter filtroPropietario =  genericDao.createFilter(FilterType.NULL, "propietario.id");
			if(DDDestinatarioGasto.CODIGO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo()) && gasto.getGastoDetalleEconomico().getGastoRefacturable()) {
				if(DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo()))
					filtroPropietario =  genericDao.createFilter(FilterType.EQUALS, "propietario.nombre", "Refacturación Sareb");
				if(DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo()))
					filtroPropietario =  genericDao.createFilter(FilterType.EQUALS, "propietario.nombre", "Central técnica Bankia");
			}*/
			
			todosActivoAlquilados = estanTodosActivosAlquilados(gasto);
			
				//Obtener la configuracion de la Partida Presupuestaria a nivel de subcartera
				//A raiz de HREOS-7241, se anyade un nuevo filtro en el caso que sea gasto refacturable. CPP_REFACTURABLE = 1
				
			ActivoConfiguracionPtdasPrep	partidaArrendada = null;
			ActivoConfiguracionPtdasPrep partidaNoArrendada = null;
				
				if(!Checks.esNulo(gasto.getSubcartera())) {
					partidaArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroSubcartera,filtroCuentaArrendamiento/*,filtroPropietario*/ ,filtroBorrado, filtroRefacturablePP);
					partidaNoArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroSubcartera,filtroCuentaNoArrendamiento/*,filtroPropietario*/,filtroBorrado, filtroRefacturablePP);
				}else {
					partidaArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroCuentaArrendamiento/*,filtroPropietario*/ ,filtroBorrado, filtroRefacturablePP);
					partidaNoArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroCuentaNoArrendamiento/*,filtroPropietario*/,filtroBorrado, filtroRefacturablePP);

				}
				
				if(!Checks.esNulo(partidaArrendada) || !Checks.esNulo(partidaNoArrendada)){
					if(!todosActivoAlquilados){
						if(!Checks.esNulo(partidaNoArrendada)){
							//gastoLineaDetalle.setCppBase(partidaNoArrendada.getPartidaPresupuestaria());
						}
					} else {
						if(!Checks.esNulo(partidaArrendada)){
							//gastoLineaDetalle.setCppBase(partidaArrendada.getPartidaPresupuestaria());

						}
					}
				} else {
					if(Checks.esNulo(partidaArrendada) || Checks.esNulo(partidaNoArrendada)){
						if(!todosActivoAlquilados){
							if(Checks.esNulo(partidaNoArrendada)){

								partidaNoArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroSubcarteraNull,filtroCuentaNoArrendamiento, /*filtroPropietario,*/filtroBorrado, filtroRefacturablePP);
								if(!Checks.esNulo(partidaNoArrendada)){
									//gastoLineaDetalle.setCppBase(partidaNoArrendada.getPartidaPresupuestaria());	
								} else {
									//gastoLineaDetalle.setCppBase(null);
								}
							}
						} else {
							if(Checks.esNulo(partidaArrendada)){
								partidaArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroSubcarteraNull,filtroCuentaArrendamiento, /*filtroPropietario,*/filtroBorrado, filtroRefacturablePP);
								if(!Checks.esNulo(partidaArrendada)){
									//gastoLineaDetalle.setCppBase(partidaArrendada.getPartidaPresupuestaria());		
								} else {
									//gastoLineaDetalle.setCppBase(null);
								}
							}
						}			
					}
				}
				//Obtener la configuracion de la Cuenta Contable a nivel de subcartera
				//A raiz de HREOS-7241, se anyade un nuevo filtro en el caso que sea gasto refacturable. CCC_REFACTURABLE = 1
				ActivoConfiguracionCuentasContables cuentaArrendada= null;
				ActivoConfiguracionCuentasContables cuentaNoArrendada= null;
					
				if(!Checks.esNulo(gasto.getSubcartera())) {

					cuentaArrendada= genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroSubcartera,filtroCuentaArrendamiento,/*filtroPropietario,*/filtroBorrado, filtroRefacturableCC);
					cuentaNoArrendada= genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroSubcartera,filtroCuentaNoArrendamiento,/*filtroPropietario,*/filtroBorrado, filtroRefacturableCC);
				}else {
					cuentaArrendada= genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroCuentaArrendamiento/*,filtroPropietario*/,filtroBorrado, filtroRefacturableCC, filtroSubcarteraNull);
					cuentaNoArrendada= genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroCuentaNoArrendamiento/*,filtroPropietario*/,filtroBorrado, filtroRefacturableCC, filtroSubcarteraNull);
				}
				
				if(!Checks.esNulo(cuentaArrendada) || !Checks.esNulo(cuentaNoArrendada)){
					if(!todosActivoAlquilados){
						if(!Checks.esNulo(cuentaNoArrendada)){
							//gastoLineaDetalle.setCccBase(cuentaNoArrendada.getCuentaContable());
						}
					} else {
						if(!Checks.esNulo(cuentaArrendada)){
							//gastoLineaDetalle.setCccBase(cuentaArrendada.getCuentaContable());
						}
					}
				} else {
					if(Checks.esNulo(cuentaArrendada) || Checks.esNulo(cuentaNoArrendada)){
						if(!todosActivoAlquilados){
							if(Checks.esNulo(cuentaNoArrendada)){
								cuentaNoArrendada = genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroSubcarteraNull,filtroCuentaNoArrendamiento/*,filtroPropietario*/,filtroBorrado, filtroRefacturableCC);
								if(!Checks.esNulo(cuentaNoArrendada)){
									//gastoLineaDetalle.setCccBase(cuentaNoArrendada.getCuentaContable());	
								} else {
									//gastoLineaDetalle.setCccBase(null);	
								}
							}
						} else {
							if(Checks.esNulo(cuentaArrendada)){
								cuentaArrendada = genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,/*filtroSubtipoGasto,*/filtroCartera,filtroSubcarteraNull,filtroCuentaArrendamiento/*,filtroPropietario*/,filtroBorrado, filtroRefacturableCC);
								if(!Checks.esNulo(cuentaArrendada)){
									//gastoLineaDetalle.setCccBase(cuentaArrendada.getCuentaContable());
								} else {
									//gastoLineaDetalle.setCccBase(null);
								}
							}
						}		
					}
				}
			//gasto.setGastoLineaDetalle(gastoLineaDetalle);


		}// else if (!Checks.esNulo(gastoLineaDetalle)) {
			//gastoLineaDetalle.setCccBase(null);
			//gastoLineaDetalle.setCppBase(null);
			//gasto.setGastoLineaDetalle(gastoLineaDetalle);;
		//}
		return gasto;
	}

	public ActivoConfiguracionCuentasContables buscarCuentaContable(GastoProveedor gasto) {

		List<ActivoConfiguracionCuentasContables> configuracion = null;
		DDCartera cartera = null;
		DDSubtipoGasto subtipoGasto = null;

		cartera = gasto.getCartera();
		//subtipoGasto = gasto.getGastoLineaDetalle().getSubtipoGasto();
		
		if (!Checks.esNulo(cartera) && !Checks.esNulo(subtipoGasto)) {

			// filtros para encontrar la cuenta contable y la partida presupuestaria.
			//Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", subtipoGasto.getId());
			Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.id", cartera.getId());


			configuracion = genericDao.getList(ActivoConfiguracionCuentasContables.class, /*filtroSubtipoGasto,*/ filtroCartera);


			if (!Checks.estaVacio(configuracion) && configuracion.size() == 1) {

				return configuracion.get(0);
			} else {
				return buscarCuentaContableEspecial(gasto, configuracion);
			}

		} else {
			logger.info("Datos insuficientes para determinar cuenta contable");
		}

		return null;
	}

	public ConfigPdaPresupuestaria buscarPartidaPresupuestaria(GastoProveedor gasto) {

		List<ConfigPdaPresupuestaria> configuracion = null;
		DDCartera cartera = null;
		DDSubtipoGasto subtipoGasto = null;
		Ejercicio ejercicio = null;

		cartera = gasto.getCartera();
		//subtipoGasto = gasto.getGastoLineaDetalle().getSubtipoGasto();
		if (gasto.getGastoInfoContabilidad() != null) {
			ejercicio = gasto.getGastoInfoContabilidad().getEjercicio();
		}

		if (ejercicio != null && cartera != null && subtipoGasto != null) {

			// filtros para encontrar la cuenta contable y la partida presupuestaria.
			Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "ejercicio.id", ejercicio.getId());
			//Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", subtipoGasto.getId());
			Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.id", cartera.getId());

			configuracion = genericDao.getList(ConfigPdaPresupuestaria.class, filtroEjercicio,/* filtroSubtipo.*/ filtroCartera);

			if (configuracion != null && configuracion.size() == 1) {

				return configuracion.get(0);

			} else {
				return buscarPartidaPresupuestariaEspecial(gasto, configuracion);
			}

		} else {
			logger.info("Datos insuficientes para determinar partida presupuestaria");
		}

		return null;
	}

	public ConfigPdaPresupuestaria buscarPartidaPresupuestariaEspecial(GastoProveedor gasto, List<ConfigPdaPresupuestaria> configuracion) {

		ConfigPdaPresupuestaria configuracionEspecial = null;
		List<GastoProveedorActivo> listaActivos = gasto.getGastoProveedorActivos();

		if (!Checks.estaVacio(listaActivos)) {

			Activo activo = listaActivos.get(0).getActivo();

			if (DDCartera.CODIGO_CARTERA_BANKIA.equals(gasto.getCartera().getCodigo())) {

				for (ConfigPdaPresupuestaria config : configuracion) {

					if (!Checks.esNulo(config.getSubcartera()) && !Checks.esNulo(activo.getSubcartera())) {
						if (config.getSubcartera().getCodigo().equals(activo.getSubcartera().getCodigo())) {
							configuracionEspecial = config;
						}
					}
				}
			}
		}

		return configuracionEspecial;
	}

	private ActivoConfiguracionCuentasContables buscarCuentaContableEspecial(GastoProveedor gasto, List<ActivoConfiguracionCuentasContables> configuracion) {

		ActivoConfiguracionCuentasContables configuracionEspecial = null;
		ActivoConfiguracionCuentasContables configuracionPorDefecto = null;
		List<GastoProveedorActivo> listaActivos = gasto.getGastoProveedorActivos();

		if (!Checks.estaVacio(listaActivos)) {

			Activo activo = listaActivos.get(0).getActivo();

			if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(gasto.getCartera().getCodigo())) {

				for (ActivoConfiguracionCuentasContables config : configuracion) {

					if (!Checks.esNulo(config.getActivoPropietario())) {
						if (config.getActivoPropietario().equals(activo.getPropietarioPrincipal())) {
							configuracionEspecial = config;
						}
					} else {
						configuracionPorDefecto = config;
					}

					if (Checks.esNulo(configuracionEspecial)) {
						configuracionEspecial = configuracionPorDefecto;
					}
				}
			}
		}

		return configuracionEspecial;
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

		if (factPattern.matcher(matriculaTipoDoc).matches() && Checks.esNulo(updaterStateApi.validarCamposMinimos(gasto)) && DDEstadoGasto.INCOMPLETO.equals(codigoEstado)) {
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
		Filter filterGastoId = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
		GastoProveedorActivo gpa = genericDao.get(GastoProveedorActivo.class, filterActivoId, filterGastoId);
		if(gpa != null) {
			gpa.setParticipacionGasto(porcentajeParticipacion);
		}

		genericDao.save(GastoProveedorActivo.class, gpa);
	}

	@Override

	public GastoProveedorActivo buscarRelacionPorActivoYGasto(Activo activo, GastoProveedor gasto) {
		
		return genericDao.get(GastoProveedorActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo", activo),
				genericDao.createFilter(FilterType.EQUALS, "gastoProveedor", gasto));
		
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
	public void anyadirGastosRefacturadosAGastoExistente(String idGasto, List<String> gastosRefacturablesLista) {
		Long idPadre = Long.valueOf(idGasto);
		GastoProveedor gastoProveedorPadre = genericDao.get(GastoProveedor.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idPadre));
		List<VBusquedaGastoActivo> listaActivos = new ArrayList<VBusquedaGastoActivo>();
		Boolean esSareb = null;
		Double importeGastosRefacturables = 0.0;
		
		importeGastosRefacturables = gastoLineaDetalleApi.calcularPrincipioSujetoLineasDetalle(gastoProveedorPadre);
		
		for (String gasto : gastosRefacturablesLista) {
			GastoProveedor gastoProveedorRefacturable = genericDao.get(GastoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(gasto)));
			if (esSareb == null) {
				esSareb = gastoProveedorRefacturable.getPropietario() != null
						&& gastoProveedorRefacturable.getPropietario().getCartera() != null
						&& DDCartera.CODIGO_CARTERA_SAREB
								.equals(gastoProveedorRefacturable.getPropietario().getCartera().getCodigo());
			}
			
			listaActivos.addAll(this.getListActivosGastos(gastoProveedorRefacturable.getId()));
			if (!Checks.esNulo(gastoProveedorRefacturable)) {
				if (!gastoDao.updateGastosRefacturablesSiExiste(gastoProveedorRefacturable.getId(), idPadre,
						usuarioApi.getUsuarioLogado().getUsername())) {
					GastoRefacturable gastoRefacturableNuevo = new GastoRefacturable();
					gastoRefacturableNuevo.setGastoProveedor(idPadre);
					gastoRefacturableNuevo.setGastoProveedorRefacturado(gastoProveedorRefacturable.getId());
					genericDao.save(GastoRefacturable.class, gastoRefacturableNuevo);
					
				}
				importeGastosRefacturables += gastoLineaDetalleApi.calcularPrincipioSujetoLineasDetalle(gastoProveedorRefacturable);
				
			}
		}
		// añadimos los activos del hijo al padre, solo sareb
		if(esSareb) {
			for (VBusquedaGastoActivo vGastoActivo : listaActivos) {
				this.createGastoActivo(idPadre, vGastoActivo.getNumActivo(), null);
				
			}
			
			if(gastoProveedorPadre != null && gastoProveedorPadre.getGastoDetalleEconomico() != null) {
				//gastoProveedorPadre.getGastoLineaDetalle().setPrincipalSujeto(importeGastosRefacturables);
				genericDao.save(GastoProveedor.class, gastoProveedorPadre);
			}
		}
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean eliminarGastoRefacturado(Long idGasto, Long numGastoRefacturado) {
		List<GastoRefacturable> listaDeGastosRefacturablesDelGasto = new ArrayList<GastoRefacturable>();
		Boolean noTieneGastosRefacturados = false;
		Boolean esSareb = null;
		Double importeGastosRefacturables = 0.0;
		GastoProveedor gastoProveedorPadre = genericDao.get(GastoProveedor.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idGasto));
		
		importeGastosRefacturables = gastoLineaDetalleApi.calcularPrincipioSujetoLineasDetalle(gastoProveedorPadre);
		
		esSareb = gastoProveedorPadre.getPropietario() != null
				&& gastoProveedorPadre.getPropietario().getCartera() != null
				&& DDCartera.CODIGO_CARTERA_SAREB
						.equals(gastoProveedorPadre.getPropietario().getCartera().getCodigo());
		
		Filter gastoRefacturadoNum = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", numGastoRefacturado);
		GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, gastoRefacturadoNum);
		
		Filter gastoId = genericDao.createFilter(FilterType.EQUALS, "idGastoProveedor", idGasto);
		Filter gastoRefacturadoId = genericDao.createFilter(FilterType.EQUALS, "idGastoProveedorRefacturado", gastoProveedor.getId());
		GastoRefacturable gastoRefacturable = genericDao.get(GastoRefacturable.class, gastoId, gastoRefacturadoId);
		
		gastoRefacturable.getAuditoria().setBorrado(true);
		genericDao.update(GastoRefacturable.class, gastoRefacturable);
		
		//eliminimos los activos hijos del gasto padre
		if(esSareb) {
			List<VBusquedaGastoActivo> listaActivosHijo = this.getListActivosGastos(gastoProveedor.getId());
			List<VBusquedaGastoActivo> listaActivosPadre = this.getListActivosGastos(gastoProveedorPadre.getId());
			List<VBusquedaGastoActivo> listaActivosABorrar = new ArrayList<VBusquedaGastoActivo>();
			for (VBusquedaGastoActivo vGastoActivo : listaActivosHijo) {
				for (VBusquedaGastoActivo vGastoActivoPadre : listaActivosPadre) {
					if(vGastoActivo.getIdActivo().equals(vGastoActivoPadre.getIdActivo())) {
						listaActivosABorrar.add(vGastoActivoPadre);
					}
					
				}
			}
			
			for (VBusquedaGastoActivo vGastoActivo : listaActivosABorrar) {
				DtoActivoGasto dtoActivoGasto = new DtoActivoGasto();
				dtoActivoGasto.setId(vGastoActivo.getId());
				this.deleteGastoActivo(dtoActivoGasto);
			}
			
			importeGastosRefacturables -= gastoLineaDetalleApi.calcularPrincipioSujetoLineasDetalle(gastoProveedor);
			if(importeGastosRefacturables >= 0) {
				//gastoProveedorPadre.getGastoLineaDetalleList().setPrincipalSujeto(importeGastosRefacturables);
				genericDao.save(GastoProveedor.class, gastoProveedorPadre);
			}
			
		}
		
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
					&& (DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo()) || DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo()))) {
				if(DDDestinatarioGasto.CODIGO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo())) {
					if(!(DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(estadoGasto)
						||	DDEstadoGasto.AUTORIZADO_PROPIETARIO.equals(estadoGasto)
						||	DDEstadoGasto.PAGADO.equals(estadoGasto)
						||	DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC.equals(estadoGasto)  
						||	DDEstadoGasto.CONTABILIZADO.equals(estadoGasto))
						&& Checks.esNulo(gastoPadre) && Checks.esNulo(gastoRefacturado)) {
						isPosibleRefacturable = true;
					}
				}
			}
		}
		return isPosibleRefacturable;
	}
	
	@Override
	public Double recalcularImporteTotalGasto(GastoDetalleEconomico gasto) {
		
		Double importeTotal = 0.0;
		
		if(gasto.getGastoProveedor() != null) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getGastoProveedor().getId());
			List<GastoLineaDetalle> gastoLineaDetalleList = genericDao.getList(GastoLineaDetalle.class,filtro);
	
			if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()){
				for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
					importeTotal+= gastoLineaDetalle.getImporteTotal();
				}
				if(gasto.getIrpfCuota() != null) {
					importeTotal = importeTotal - gasto.getIrpfCuota();
				}
				if(gasto.getRetencionGarantiaCuota() != null && gasto.getRetencionGarantiaAplica() != null && gasto.getRetencionGarantiaAplica()) {
					importeTotal = importeTotal - gasto.getRetencionGarantiaCuota();
				}
			}

		}		
		return importeTotal;
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
	

}
