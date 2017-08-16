package es.pfsgroup.plugin.rem.gastoProveedor;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
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
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;
import es.pfsgroup.plugin.rem.model.ConfigCuentaContable;
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
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoImpugnacion;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedorActivo;
import es.pfsgroup.plugin.rem.model.GastoProveedorTrabajo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioPago;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAutorizacionPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencionPago;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOperacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPagador;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateGastoApi;

@Service("gastoProveedorManager")
public class GastoProveedorManager implements GastoProveedorApi {

	private final Log logger = LogFactory.getLog(getClass());

	public final String PESTANA_FICHA = "ficha";
	public final String PESTANA_DETALLE_ECONOMICO = "detalleEconomico";
	public final String PESTANA_CONTABILIDAD = "contabilidad";
	public final String PESTANA_GESTION = "gestion";
	public final String PESTANA_IMPUGNACION = "impugnacion";

	private static final String EXCEPTION_EXPEDIENT_NOT_FOUND_COD = "ExceptionExp";
	private static final String COD_PEF_GESTORIA_ADMINISTRACION = "HAYAGESTADMT";
	private static final String COD_PEF_GESTORIA_PLUSVALIA = "GESTOPLUS";
	private static final String COD_PEF_USUARIO_CERTIFICADOR = "HAYACERTI";

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
	private GestorActivoDao gestorActivoDao;

	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Resource
	MessageService messageServices;

	@Override
	public GastoProveedor findOne(Long id) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		GastoProveedor gasto = genericDao.get(GastoProveedor.class, filtro);

		return gasto;
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
			logger.error(e.getMessage());
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
		if (!Checks.esNulo(usuarioCartera)) {
			dtoGastosFilter.setEntidadPropietariaCodigo(usuarioCartera.getCartera().getCodigo());
		}
		
		
		// Comprobar si el usuario es externo y de tipo proveedor y, en tal caso, seteamos proveedores contacto del
		// usuario logado para filtrar los gastos en los que esté como emisor
		// Ademas si es un tipo de gestoria concreto, se filtrará los gastos que le pertenezcan como gestoria.
		if (gestorActivoDao.isUsuarioGestorExternoProveedor(usuarioLogado.getId())) {
			Boolean isGestoria = genericAdapter.tienePerfil(COD_PEF_GESTORIA_ADMINISTRACION, usuarioLogado) 
					|| genericAdapter.tienePerfil(COD_PEF_GESTORIA_PLUSVALIA, usuarioLogado)
					|| genericAdapter.tienePerfil(COD_PEF_USUARIO_CERTIFICADOR, usuarioLogado);
			return gastoDao.getListGastosFilteredByProveedorContactoAndGestoria(dtoGastosFilter, usuarioLogado.getId(), isGestoria);
		}

		return gastoDao.getListGastos(dtoGastosFilter);
	}

	private DtoFichaGastoProveedor gastoToDtoFichaGasto(GastoProveedor gasto) {

		DtoFichaGastoProveedor dto = new DtoFichaGastoProveedor();

		if (!Checks.esNulo(gasto)) {

			dto.setIdGasto(gasto.getId());
			dto.setNumGastoHaya(gasto.getNumGastoHaya());
			dto.setNumGastoGestoria(gasto.getNumGastoGestoria());
			dto.setReferenciaEmisor(gasto.getReferenciaEmisor());

			if (!Checks.esNulo(gasto.getTipoGasto())) {
				dto.setTipoGastoCodigo(gasto.getTipoGasto().getCodigo());
				dto.setTipoGastoDescripcion(gasto.getTipoGasto().getDescripcion());
			}
			if (!Checks.esNulo(gasto.getSubtipoGasto())) {
				dto.setSubtipoGastoCodigo(gasto.getSubtipoGasto().getCodigo());
				dto.setSubtipoGastoDescripcion(gasto.getSubtipoGasto().getDescripcion());
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
			}

			if (!Checks.esNulo(gasto.getPropietario())) {
				dto.setNifPropietario(gasto.getPropietario().getDocIdentificativo());
				dto.setBuscadorNifPropietario(gasto.getPropietario().getDocIdentificativo());
				dto.setNombrePropietario(gasto.getPropietario().getNombre());
			}

			if (!Checks.esNulo(gasto.getDestinatarioGasto())) {
				dto.setDestinatario(gasto.getDestinatarioGasto().getCodigo());
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

			if (!Checks.esNulo(gasto.getGastoDetalleEconomico())) {
				dto.setImporteTotal(gasto.getGastoDetalleEconomico().getImporteTotal());
			}

			if (!Checks.esNulo(gasto.getGestoria())) {
				dto.setNombreGestoria(gasto.getGestoria().getNombre());
			}

		}

		return dto;
	}

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
		genericDao.save(GastoDetalleEconomico.class, detalleEconomico);

		GastoGestion gestion = new GastoGestion();
		DDEstadoAutorizacionHaya estadoAutorizacionHaya = (DDEstadoAutorizacionHaya) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionHaya.class,
				DDEstadoAutorizacionHaya.CODIGO_PENDIENTE);
		gestion.setEstadoAutorizacionHaya(estadoAutorizacionHaya);
		gestion.setGastoProveedor(gastoProveedor);
		gestion.setFechaAlta(new Date());
		gestion.setUsuarioAlta(usuario);
		genericDao.save(GastoGestion.class, gestion);

		GastoInfoContabilidad contabilidad = new GastoInfoContabilidad();
		Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "anyo", String.valueOf(new GregorianCalendar().get(GregorianCalendar.YEAR)));
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
		if (!Checks.esNulo(dto.getSubtipoGastoCodigo())) {
			DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, dto.getSubtipoGastoCodigo());
			gastoProveedor.setSubtipoGasto(subtipoGasto);
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

		try {

			beanUtilNotNull.copyProperties(gastoProveedor, dto);

		} catch (Exception ex) {
			logger.error(ex.getCause());
		}

		if (!Checks.esNulo(dto.getCodigoProveedorRem())) {
			Filter filtroCodigoEmisorRem = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", dto.getCodigoProveedorRem());
			ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroCodigoEmisorRem);
			gastoProveedor.setProveedor(proveedor);
		}

		if (!Checks.esNulo(dto.getBuscadorNifPropietario())) {
			Filter filtroNifPropietario = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dto.getBuscadorNifPropietario());
			ActivoPropietario propietario = genericDao.get(ActivoPropietario.class, filtroNifPropietario);
			gastoProveedor.setPropietario(propietario);
		}

		if (!Checks.esNulo(dto.getTipoGastoCodigo())) {
			DDTipoGasto tipoGasto = (DDTipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoGasto.class, dto.getTipoGastoCodigo());
			gastoProveedor.setTipoGasto(tipoGasto);
		}
		if (!Checks.esNulo(dto.getSubtipoGastoCodigo())) {
			DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, dto.getSubtipoGastoCodigo());
			gastoProveedor.setSubtipoGasto(subtipoGasto);
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

		if (!Checks.esNulo(dto.getGastoSinActivos())) {
			gastoProveedor.setGastoSinActivos(BooleanUtils.toIntegerObject(dto.getGastoSinActivos()));
		}

		updaterStateApi.updaterStates(gastoProveedor, null);
		genericDao.update(GastoProveedor.class, gastoProveedor);

		return true;
	}

	public boolean existeGasto(DtoFichaGastoProveedor dto) {

		boolean existeGasto = false;

		Filter filtroReferencia = genericDao.createFilter(FilterType.EQUALS, "referenciaEmisor", dto.getReferenciaEmisor());
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "tipoGasto.codigo", dto.getTipoGastoCodigo());
		Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.codigo", dto.getSubtipoGastoCodigo());
		Filter filtroEmisor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", dto.getIdEmisor());
		Filter filtroFechaEmision = genericDao.createFilter(FilterType.EQUALS, "fechaEmision", dto.getFechaEmision());
		Filter filtroDestinatario = genericDao.createFilter(FilterType.EQUALS, "destinatarioGasto.codigo", dto.getDestinatarioGastoCodigo());

		List<GastoProveedor> lista = genericDao.getList(GastoProveedor.class, filtroReferencia, filtroTipo, filtroSubtipo, filtroEmisor, filtroFechaEmision, filtroDestinatario);

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

	private DtoDetalleEconomicoGasto detalleEconomicoToDtoDetalleEconomico(GastoProveedor gasto) {

		DtoDetalleEconomicoGasto dto = new DtoDetalleEconomicoGasto();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
		GastoDetalleEconomico detalleGasto = genericDao.get(GastoDetalleEconomico.class, filtro);

		if (!Checks.esNulo(detalleGasto)) {

			dto.setImportePrincipalSujeto(detalleGasto.getImportePrincipalSujeto());
			dto.setImportePrincipalNoSujeto(detalleGasto.getImportePrincipalNoSujeto());
			dto.setImporteRecargo(detalleGasto.getImporteRecargo());
			dto.setImporteInteresDemora(detalleGasto.getImporteInteresDemora());
			dto.setImporteCostas(detalleGasto.getImporteCostas());
			dto.setImporteOtrosIncrementos(detalleGasto.getImporteOtrosIncrementos());
			dto.setImporteProvisionesSuplidos(detalleGasto.getImporteProvisionesSuplidos());

			if (!Checks.esNulo(detalleGasto.getImpuestoIndirectoTipo())) {
				dto.setImpuestoIndirectoTipoCodigo(detalleGasto.getImpuestoIndirectoTipo().getCodigo());
			}

			if (!Checks.esNulo(detalleGasto.getImpuestoIndirectoExento())) {
				if (detalleGasto.getImpuestoIndirectoExento().equals(1)) {
					dto.setImpuestoIndirectoExento(true);
				}
				if (detalleGasto.getImpuestoIndirectoExento().equals(0)) {
					dto.setImpuestoIndirectoExento(false);
				}

			}

			if (!Checks.esNulo(detalleGasto.getRenunciaExencionImpuestoIndirecto())) {
				if (detalleGasto.getRenunciaExencionImpuestoIndirecto().equals(1)) {
					dto.setRenunciaExencionImpuestoIndirecto(true);
				}
				if (detalleGasto.getRenunciaExencionImpuestoIndirecto().equals(0)) {
					dto.setRenunciaExencionImpuestoIndirecto(false);
				}

			}

			dto.setImpuestoIndirectoTipoImpositivo(detalleGasto.getImpuestoIndirectoTipoImpositivo());
			dto.setImpuestoIndirectoCuota(detalleGasto.getImpuestoIndirectoCuota());

			dto.setIrpfTipoImpositivo(detalleGasto.getIrpfTipoImpositivo());
			dto.setIrpfCuota(detalleGasto.getIrpfCuota());
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

			if (!Checks.esNulo(detalleGasto.getPagadoConexionBankia())) {
				dto.setPagadoConexionBankia(detalleGasto.getPagadoConexionBankia() == 1 ? true : false);
			}
			dto.setOficina(detalleGasto.getOficinaBankia());
			dto.setNumeroConexion(detalleGasto.getNumeroConexionBankia());
			dto.setFechaConexion(detalleGasto.getFechaConexion());

			if (!Checks.esNulo(gasto.getProveedor().getCriterioCajaIVA())) {
				dto.setOptaCriterioCaja(BooleanUtils.toBooleanObject(gasto.getProveedor().getCriterioCajaIVA()));
			}

		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean saveDetalleEconomico(DtoDetalleEconomicoGasto dto, Long idGasto) {

		GastoProveedor gasto = findOne(idGasto);
		GastoDetalleEconomico detalleGasto = gasto.getGastoDetalleEconomico();

		try {
			if (!Checks.esNulo(detalleGasto)) {
				try {
					beanUtilNotNull.copyProperties(detalleGasto, dto);

					if (!Checks.esNulo(dto.getImpuestoIndirectoExento())) {
						if (dto.getImpuestoIndirectoExento()) {
							detalleGasto.setImpuestoIndirectoExento(1);
						}
						if (!dto.getImpuestoIndirectoExento()) {
							detalleGasto.setImpuestoIndirectoExento(0);
						}
					}

					if (!Checks.esNulo(dto.getRenunciaExencionImpuestoIndirecto())) {
						if (dto.getRenunciaExencionImpuestoIndirecto()) {
							detalleGasto.setRenunciaExencionImpuestoIndirecto(1);
						}
						if (!dto.getRenunciaExencionImpuestoIndirecto()) {
							detalleGasto.setRenunciaExencionImpuestoIndirecto(0);
						}
					}

					if (!Checks.esNulo(dto.getImpuestoIndirectoTipoCodigo())) {
						DDTiposImpuesto tipoImpuesto = (DDTiposImpuesto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposImpuesto.class, dto.getImpuestoIndirectoTipoCodigo());
						detalleGasto.setImpuestoIndirectoTipo(tipoImpuesto);
					}

					if (!Checks.esNulo(dto.getDestinatariosPagoCodigo())) {
						DDDestinatarioPago destinatarioPago = (DDDestinatarioPago) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioPago.class,
								dto.getDestinatariosPagoCodigo());
						detalleGasto.setDestinatariosPago(destinatarioPago);
					}
					if (!Checks.esNulo(dto.getTipoPagadorCodigo())) {
						DDTipoPagador tipoPagador = (DDTipoPagador) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPagador.class, dto.getTipoPagadorCodigo());
						detalleGasto.setTipoPagador(tipoPagador);
					}

					if (!Checks.esNulo(dto.getReembolsoTercero()) && dto.getReembolsoTercero()) {
						detalleGasto.setReembolsoTercero(1);

						if (!Checks.esNulo(dto.getIncluirPagoProvision())) {
							detalleGasto.setIncluirPagoProvision(dto.getIncluirPagoProvision() ? 1 : 0);
						}

						if (!Checks.esNulo(dto.getAbonoCuenta()) && dto.getAbonoCuenta()) {
							detalleGasto.setAbonoCuenta(1);
							if (!Checks.esNulo(dto.getIban())) {
								detalleGasto.setIbanAbonar(dto.getIban());
							}
							if (!Checks.esNulo(dto.getTitularCuenta())) {
								detalleGasto.setTitularCuentaAbonar(dto.getTitularCuenta());
							}
							if (!Checks.esNulo(dto.getNifTitularCuenta())) {
								detalleGasto.setNifTitularCuentaAbonar(dto.getNifTitularCuenta());
							}
						} else {
							detalleGasto.setAbonoCuenta(0);
							detalleGasto.setIbanAbonar(null);
							detalleGasto.setTitularCuentaAbonar(null);
							detalleGasto.setNifTitularCuentaAbonar(null);
						}

						if (!Checks.esNulo(dto.getPagadoConexionBankia()) && dto.getPagadoConexionBankia()) {
							detalleGasto.setPagadoConexionBankia(1);
							if (!Checks.esNulo(dto.getOficina())) {
								detalleGasto.setOficinaBankia(dto.getOficina());
							}
							if (!Checks.esNulo(dto.getNumeroConexion())) {
								detalleGasto.setNumeroConexionBankia(dto.getNumeroConexion());
							}

						} else {
							detalleGasto.setPagadoConexionBankia(0);
							detalleGasto.setOficinaBankia(null);
							detalleGasto.setNumeroConexionBankia(null);
							detalleGasto.setFechaConexion(null);
						}

					} else if (!Checks.esNulo(dto.getReembolsoTercero()) && !dto.getReembolsoTercero()) {
						detalleGasto.setReembolsoTercero(0);
						detalleGasto.setIbanAbonar(null);
						detalleGasto.setTitularCuentaAbonar(null);
						detalleGasto.setNifTitularCuentaAbonar(null);
						detalleGasto.setOficinaBankia(null);
						detalleGasto.setNumeroConexionBankia(null);
						detalleGasto.setFechaConexion(null);
						detalleGasto.setIncluirPagoProvision(0);
						detalleGasto.setAbonoCuenta(0);
						detalleGasto.setPagadoConexionBankia(0);
					}

					updaterStateApi.updaterStates(gasto, null);

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
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

		List<VBusquedaGastoActivo> gastosActivos = new ArrayList<VBusquedaGastoActivo>();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idGasto", idGasto);
		gastosActivos = genericDao.getList(VBusquedaGastoActivo.class, filtro);

		return gastosActivos;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean createGastoActivo(Long idGasto, Long numActivo, Long numAgrupacion) {

		GastoProveedor gasto = null;

		if (!Checks.esNulo(idGasto) && !Checks.esNulo(numActivo)) {

			Filter filtroG = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
			Filter filtroA = genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", numActivo);
			GastoProveedorActivo gastoActivo = genericDao.get(GastoProveedorActivo.class, filtroG, filtroA);

			if (Checks.esNulo(gastoActivo)) {

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
				Activo activo = genericDao.get(Activo.class, filtro);

				if (Checks.esNulo(activo)) {
					throw new JsonViewerException("Este activo no existe");
				} else {

					Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
					gasto = genericDao.get(GastoProveedor.class, filtroGasto);

					if (!Checks.esNulo(gasto.getPropietario())) {

						if (!Checks.esNulo(gasto.getPropietario().getDocIdentificativo())){
							ActivoPropietario propietario = activo.getPropietarioPrincipal();
							if (!gasto.getPropietario().getDocIdentificativo().equals(propietario.getDocIdentificativo())) {
								throw new JsonViewerException("Propietario diferente al propietario actual del gasto");
							}
						}else{
							throw new JsonViewerException("Propietario del gasto sin documento");
						}
						
					}

					Filter filtroCatastro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					Order order = new Order(OrderType.DESC, "fechaRevValorCatastral");
					List<ActivoCatastro> activosCatastro = genericDao.getListOrdered(ActivoCatastro.class, order, filtroCatastro);

					GastoProveedorActivo gastoProveedorActivo = new GastoProveedorActivo();
					gastoProveedorActivo.setActivo(activo);
					gastoProveedorActivo.setGastoProveedor(gasto);
					if (!Checks.estaVacio(activosCatastro)) {
						gastoProveedorActivo.setReferenciaCatastral(activosCatastro.get(0).getRefCatastral());
					}

					List<GastoProveedorActivo> gastosActivosList = gasto.getGastoProveedorActivos();
					gastosActivosList.add(gastoProveedorActivo);

					this.calculaPorcentajeEquitativoGastoActivos(gastosActivosList);

					genericDao.save(GastoProveedorActivo.class, gastoProveedorActivo);
				}
			} else {
				throw new JsonViewerException("Este activo ya está asignado");
			}

		} else if (!Checks.esNulo(idGasto) && !Checks.esNulo(numAgrupacion)) {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", numAgrupacion);
			ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);

			if (Checks.esNulo(agrupacion)) {
				throw new JsonViewerException("Esta agrupación no existe");
			} else {

				Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
				gasto = genericDao.get(GastoProveedor.class, filtroGasto);

				if (!Checks.estaVacio(agrupacion.getActivos())) {

					Activo activo = agrupacion.getActivos().get(0).getActivo();
					ActivoPropietario propietario = activo.getPropietarioPrincipal();
					if (!Checks.esNulo(gasto.getPropietario()) && !Checks.esNulo(propietario)) {
						if (!gasto.getPropietario().getDocIdentificativo().equals(propietario.getDocIdentificativo())) {
							throw new JsonViewerException("Propietario diferente al propietario actual del gasto");
						}
					}

					for (ActivoAgrupacionActivo activoAgrupacion : agrupacion.getActivos()) {
						Filter filtroG = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
						Filter filtroA = genericDao.createFilter(FilterType.EQUALS, "activo.numActivo", activoAgrupacion.getActivo().getNumActivo());
						GastoProveedorActivo gastoActivo = genericDao.get(GastoProveedorActivo.class, filtroG, filtroA);

						if (Checks.esNulo(gastoActivo)) {

							filtro = genericDao.createFilter(FilterType.EQUALS, "numActivo", activoAgrupacion.getActivo().getNumActivo());
							activo = genericDao.get(Activo.class, filtro);

							if (Checks.esNulo(activo)) {
								throw new JsonViewerException("Este activo no existe");
							} else {

								filtroGasto = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
								gasto = genericDao.get(GastoProveedor.class, filtroGasto);

								Filter filtroCatastro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
								Order order = new Order(OrderType.DESC, "fechaRevValorCatastral");
								List<ActivoCatastro> activosCatastro = genericDao.getListOrdered(ActivoCatastro.class, order, filtroCatastro);

								GastoProveedorActivo gastoProveedorActivo = new GastoProveedorActivo();
								gastoProveedorActivo.setActivo(activo);
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
					}
				}
			}
		} else {
			return false;
		}

		if (!Checks.esNulo(gasto)) {
			// establecemos propietario si es necesario
			gasto = asignarPropietarioGasto(gasto);
			// volvemos a establecer la cuenta contable y partida;
			gasto = asignarCuentaContableYPartidaGasto(gasto);
			// Comprobamos si el estado del gasto cambia.
			updaterStateApi.updaterStates(gasto, null);

			genericDao.save(GastoProveedor.class, gasto);
		}

		return true;
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

		// Calcular porcentaje equitativo.
		Float numActivos = (float) gastosActivosList.size();
		Float porcentaje = 100f / numActivos;

		for (GastoProveedorActivo gastoProveedor : gastosActivosList) {
			gastoProveedor.setParticipacionGasto(porcentaje);
		}
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
			gasto = asignarPropietarioGasto(gasto);
			// Volvemos a establecer la cuenta contable y partida.
			gasto = asignarCuentaContableYPartidaGasto(gasto);

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

	public DtoInfoContabilidadGasto infoContabilidadToDtoInfoContabilidad(GastoProveedor gasto) {

		DtoInfoContabilidadGasto dto = new DtoInfoContabilidadGasto();

		if (!Checks.esNulo(gasto)) {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoInfoContabilidad contabilidadGasto = genericDao.get(GastoInfoContabilidad.class, filtro);

			if (!Checks.esNulo(contabilidadGasto)) {
				if (!Checks.esNulo(contabilidadGasto.getEjercicio())) {
					dto.setEjercicioImputaGasto(contabilidadGasto.getEjercicio().getId());
				}
				if (!Checks.esNulo(gasto.getTipoPeriocidad())) {
					dto.setPeriodicidadDescripcion(gasto.getTipoPeriocidad().getDescripcion());
				}
				if (!Checks.esNulo(contabilidadGasto.getPartidaPresupuestaria())) {
					dto.setPartidaPresupuestaria(contabilidadGasto.getPartidaPresupuestaria());
				}
				if (!Checks.esNulo(contabilidadGasto.getCuentaContable())) {
					dto.setCuentaContable(contabilidadGasto.getCuentaContable());
				}

				dto.setFechaDevengoEspecial(contabilidadGasto.getFechaDevengoEspecial());
				if (!Checks.esNulo(contabilidadGasto.getTipoPeriocidadEspecial())) {
					dto.setPeriodicidadEspecialDescripcion(contabilidadGasto.getTipoPeriocidadEspecial().getDescripcion());
				}
				if (!Checks.esNulo(contabilidadGasto.getPartidaPresupuestariaEspecial())) {
					dto.setPartidaPresupuestariaEspecial(contabilidadGasto.getPartidaPresupuestariaEspecial());
				}
				if (!Checks.esNulo(contabilidadGasto.getCuentaContableEspecial())) {
					dto.setCuentaContableEspecial(contabilidadGasto.getCuentaContableEspecial());
				}

				dto.setFechaContabilizacion(contabilidadGasto.getFechaContabilizacion());
				dto.setFechaDevengoEspecial(contabilidadGasto.getFechaDevengoEspecial());
				if (!Checks.esNulo(contabilidadGasto.getContabilizadoPor())) {
					dto.setContabilizadoPorDescripcion(contabilidadGasto.getContabilizadoPor().getDescripcion());
				}
			}

		}

		return dto;
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateGastoContabilidad(DtoInfoContabilidadGasto dtoContabilidadGasto, Long idGasto) {

		try {
			GastoProveedor gasto = findOne(idGasto);
			GastoInfoContabilidad contabilidadGasto = gasto.getGastoInfoContabilidad();

			if (!Checks.esNulo(contabilidadGasto)) {

				beanUtilNotNull.copyProperties(contabilidadGasto, dtoContabilidadGasto);

				if (!Checks.esNulo(dtoContabilidadGasto.getEjercicioImputaGasto())) {
					Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "id", dtoContabilidadGasto.getEjercicioImputaGasto());
					Ejercicio ejercicio = genericDao.get(Ejercicio.class, filtroEjercicio);

					contabilidadGasto.setEjercicio(ejercicio);
				}

				gasto.setGastoInfoContabilidad(contabilidadGasto);
			}

			updaterStateApi.updaterStates(gasto, null);

			genericDao.update(GastoProveedor.class, gasto);

			return true;

		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}
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
				if (!Checks.esNulo(gastoGestion.getMotivoRechazoAutorizacionHaya())) {
					dtoGestion.setComboMotivoRechazoHaya(gastoGestion.getMotivoRechazoAutorizacionHaya().getCodigo());
					;
				}
				////

				if (!Checks.esNulo(gastoGestion.getEstadoAutorizacionPropietario())) {
					dtoGestion.setComboEstadoAutorizacionPropietario(gastoGestion.getEstadoAutorizacionPropietario().getCodigo());
				}

				dtoGestion.setFechaAutorizacionPropietario(gastoGestion.getFechaEstadoAutorizacionPropietario());

				if (!Checks.esNulo(gastoGestion.getMotivoRechazoAutorizacionPropietario())) {
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
					} else if (("").equals(dtoGestionGasto.getComboMotivoRetenerPago())) {
						// Si borro el campo eliminamos los detalles de retencion y ponemos el gasto en estado incompleto o pendiente.
						gestionGasto.setMotivoRetencionPago(null);
						gestionGasto.setFechaRetencionPago(null);
						gestionGasto.setUsuarioRetencionPago(null);
						gasto.setGastoGestion(gestionGasto);
						// HREOS-1927: si se quita la retención en el estado vuelve a ser Pendiente
						updaterStateApi.updaterStates(gasto, null);
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

		for (Long idTrabajo : trabajos) {

			Trabajo trabajo = trabajoApi.findOne(idTrabajo);
			// Marcamos la fecha de emisión de factura en el trabajo
			trabajo.setFechaEmisionFactura(new Date());
			genericDao.save(Trabajo.class, trabajo);

			// Asignamos el trabajo al gasto
			GastoProveedorTrabajo gastoTrabajo = new GastoProveedorTrabajo();
			gastoTrabajo.setTrabajo(trabajo);
			gastoTrabajo.setGastoProveedor(gasto);

			genericDao.save(GastoProveedorTrabajo.class, gastoTrabajo);
			gasto.getGastoProveedorTrabajos().add(gastoTrabajo);

			// Asignamos los activos del trabajo al gasto

			gasto = asignarActivos(gasto, trabajo);
		}

		gasto = calcularImportesDetalleEconomicoGasto(gasto);

		gasto = calcularParticipacionActivosGasto(gasto);

		gasto = asignarPropietarioGasto(gasto);

		gasto = asignarCuentaContableYPartidaGasto(gasto);

		updaterStateApi.updaterStates(gasto, null);

		genericDao.save(GastoProveedor.class, gasto);

		return true;
	}

	private GastoProveedor asignarActivos(GastoProveedor gasto, Trabajo trabajo) {

		for (ActivoTrabajo activo : trabajo.getActivosTrabajo()) {

			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getPrimaryKey().getActivo().getId());
			Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoProveedorActivo gastoActivo = genericDao.get(GastoProveedorActivo.class, filtroActivo, filtroGasto);

			// Si no existe ya
			if (Checks.esNulo(gastoActivo)) {
				gastoActivo = new GastoProveedorActivo();
				gastoActivo.setActivo(activo.getPrimaryKey().getActivo());
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

					for (DtoAdjunto adj : listaAdjuntos) {

						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", adj.getMatricula());
						DDTipoDocumentoGasto tipoDocumento = (DDTipoDocumentoGasto) genericDao.get(DDTipoDocumentoGasto.class, filtro);

						// Esta es la única información que tenemos en el gestor documental.
						if (!Checks.esNulo(tipoDocumento)) {
							adj.setCodigoTipo(tipoDocumento.getDescripcion());
							adj.setDescripcionTipo(tipoDocumento.getDescripcion());
						}
					}
				}

			} catch (GestorDocumentalException gex) {
				String[] error = gex.getMessage().split("-");

				// Si no existe el expediente lo creamos
				if (error.length > 0 &&  EXCEPTION_EXPEDIENT_NOT_FOUND_COD.equals(error[0].trim())) {

					Integer idExpediente;
					try {
						idExpediente = gestorDocumentalAdapterApi.crearGasto(gasto, usuario.getUsername());
						logger.debug("GESTOR DOCUMENTAL [ crearGasto para " + gasto.getNumGastoHaya() + "]: ID EXPEDIENTE RECIBIDO " + idExpediente);
					} catch (GestorDocumentalException gexc) {
						gexc.printStackTrace();
						logger.debug(gexc.getMessage());
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
					gestorDocumentalAdapterApi.uploadDocumentoGasto(gasto, fileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());
				} catch (GestorDocumentalException gex) {
					String[] error = gex.getMessage().split("-");
					// Si no existe el expediente lo creamos
					if (EXCEPTION_EXPEDIENT_NOT_FOUND_COD.equals(error[0])) {
						return "No existe el expediente en el gestor documental";
					} else {
						logger.error(gex.getMessage());
						return gex.getMessage();
					}
				}

			} else {
				AdjuntoGasto adjuntoGasto = createAdjuntoGasto(fileItem, gasto);
				gasto.getAdjuntos().add(adjuntoGasto);
			}

			boolean tieneIva = Checks.esNulo(gasto.getGestoria());
			String nuevoEstado = checkReglaCambioEstado(gasto.getEstadoGasto().getCodigo(), tieneIva,
  					tipoDocumento.getMatricula());
			updateExisteDocumentoGasto(gasto, 1);
  			if (!Checks.esNulo(nuevoEstado)) {
  				updaterStateApi.updaterStates(gasto, nuevoEstado);
  			}
			
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

	public AdjuntoGasto createAdjuntoGasto(WebFileItem fileItem, GastoProveedor gasto) throws Exception {

		AdjuntoGasto adjuntoGasto = new AdjuntoGasto();
		Adjunto adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
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
				fileItem = gestorDocumentalAdapterApi.getFileItem(dtoAdjunto.getId());
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

		gasto = asignarPropietarioGasto(gasto);

		gasto = asignarCuentaContableYPartidaGasto(gasto);

		updaterStateApi.updaterStates(gasto, null);

		genericDao.save(GastoProveedor.class, gasto);

		return true;
	}

	@Override
	public List<VBusquedaGastoTrabajos> getListTrabajosGasto(Long idGasto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idGasto", idGasto);
		List<VBusquedaGastoTrabajos> gastoTrabajos = genericDao.getList(VBusquedaGastoTrabajos.class, filtro);

		return gastoTrabajos;
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

		gasto.getGastoDetalleEconomico().setImportePrincipalSujeto(importeGasto);
		gasto.getGastoDetalleEconomico().setImporteProvisionesSuplidos(importeProvisionesSuplidos);
		gasto.getGastoDetalleEconomico().setImporteTotal(importeGasto + importeProvisionesSuplidos);

		return gasto;
	}

	private GastoProveedor calcularParticipacionActivosGasto(GastoProveedor gasto) {

		Double importeTotal = gasto.getGastoDetalleEconomico().getImportePrincipalSujeto();
		importeTotal = Checks.esNulo(importeTotal) ? new Double("0L") : importeTotal;
		Map<Long, Double> mapa = new HashMap<Long, Double>();

		for (GastoProveedorTrabajo gastoTrabajo : gasto.getGastoProveedorTrabajos()) {
			Double importeTrabajo = gastoTrabajo.getTrabajo().getImporteTotal();
			if (!Checks.esNulo(importeTrabajo)) {
				for (ActivoTrabajo activoTrabajo : gastoTrabajo.getTrabajo().getActivosTrabajo()) {
					Activo activo = activoTrabajo.getPrimaryKey().getActivo();
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
			if (!mapa.isEmpty()) {
				gastoActivo.setParticipacionGasto((float) (mapa.get(idActivo) * 100 / importeTotal));
			}
		}

		return gasto;
	}

	public boolean esGastoEditable(GastoProveedor gasto) {

		Usuario usuario = genericAdapter.getUsuarioLogado();

		// NO ES EDITABLE SI....

		if (!Checks.esNulo(gasto.getEstadoGasto())) {

			// Si es proveedor y...
			if (genericAdapter.isProveedor(usuario)) {
				// el estado no está incompleto o no es pendiente o no es rechazado por gestor
				if (!DDEstadoGasto.INCOMPLETO.equals(gasto.getEstadoGasto().getCodigo()) && !DDEstadoGasto.PENDIENTE.equals(gasto.getEstadoGasto().getCodigo())
						&& !DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())) {
					return false;
				}

			} else {

				if (DDEstadoGasto.ANULADO.equals(gasto.getEstadoGasto().getCodigo())) {
					return false;
				}
			}
		}

		return true;
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

		if (validarAutorizacion) {
			String error = updaterStateApi.validarAutorizacionGasto(gasto);
			if (!Checks.esNulo(error)) {
				throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya() + " no se puede autorizar: " + error);
			}
		}

		GastoGestion gastoGestion = gasto.getGastoGestion();
		gastoGestion.setEstadoAutorizacionHaya(estadoAutorizacionHaya);
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

		// Se activa el borrado de los gastos-trabajo, y dejamos el trabajo como diponible para un
		// futuro nuevo gasto
		this.reactivarTrabajoParaGastos(gasto.getGastoProveedorTrabajos());

		GastoGestion gastoGestion = gasto.getGastoGestion();
		gastoGestion.setEstadoAutorizacionHaya(estadoAutorizacionHaya);
		gastoGestion.setUsuarioEstadoAutorizacionHaya(genericAdapter.getUsuarioLogado());
		gastoGestion.setFechaEstadoAutorizacionHaya(new Date());
		gastoGestion.setMotivoRechazoAutorizacionHaya(motivo);

		gasto.setGastoGestion(gastoGestion);
		updaterStateApi.updaterStates(gasto, DDEstadoGasto.RECHAZADO_ADMINISTRACION);
		gasto.setProvision(null);

		genericDao.update(GastoProveedor.class, gasto);

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

				genericDao.deleteById(GastoProveedorTrabajo.class, gpvTrabajo.getId());
			}
		}
	}

	public GastoProveedor asignarPropietarioGasto(GastoProveedor gasto) {

		if (!Checks.estaVacio(gasto.getGastoProveedorActivos())) {

			GastoProveedorActivo gastoActivo = gasto.getGastoProveedorActivos().get(0);
			gasto.setPropietario(gastoActivo.getActivo().getPropietarioPrincipal());

		} else {
			gasto.setPropietario(null);
		}

		return gasto;
	}

	public GastoProveedor asignarCuentaContableYPartidaGasto(GastoProveedor gasto) {

		//ConfigCuentaContable cuenta = buscarCuentaContable(gasto);		
		ConfigPdaPresupuestaria partida = buscarPartidaPresupuestaria(gasto);
		GastoInfoContabilidad gastoInfoContabilidad = gasto.getGastoInfoContabilidad();
		boolean todosActivoAlquilados= false;

		if (!Checks.esNulo(partida) && !Checks.esNulo(gastoInfoContabilidad)) {

			Ejercicio ejercicio = gastoInfoContabilidad.getEjercicio();
			
			Filter filtroBorrado= genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroEjercicioCuentaContable= genericDao.createFilter(FilterType.EQUALS, "ejercicio.id", ejercicio.getId());
			Filter filtroSubtipoGasto= genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", gasto.getSubtipoGasto().getId());
			Filter filtroCartera= genericDao.createFilter(FilterType.EQUALS, "cartera.id", gasto.getPropietario().getCartera().getId());
			Filter filtroCuentaArrendamiento= genericDao.createFilter(FilterType.EQUALS, "cuentaArrendamiento", 1);
			Filter filtroCuentaNoArrendamiento= genericDao.createFilter(FilterType.EQUALS, "cuentaArrendamiento", 0);
			
			ConfigCuentaContable cuentaArrendada= genericDao.get(ConfigCuentaContable.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroCuentaArrendamiento,filtroBorrado);
			ConfigCuentaContable cuentaNoArrendada= genericDao.get(ConfigCuentaContable.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroCuentaNoArrendamiento,filtroBorrado);
			
			if(!Checks.esNulo(cuentaArrendada) || !Checks.esNulo(cuentaNoArrendada)){
				
				Filter filtroGastoActivo= genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
				List<GastoProveedorActivo> gastosActivos= genericDao.getList(GastoProveedorActivo.class,filtroGastoActivo);
				for(GastoProveedorActivo gastoActivo: gastosActivos){
					Activo activo= gastoActivo.getActivo();
					
					if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getSituacionPosesoria())){
						if(activo.getSituacionPosesoria().getOcupado()==1 && activo.getSituacionPosesoria().getConTitulo()==1){
							if(!Checks.esNulo(activo.getSituacionPosesoria().getTipoTituloPosesorio()) &&
									activo.getSituacionPosesoria().getTipoTituloPosesorio().getCodigo().equals(DDTipoTituloPosesorio.CODIGO_ARRENDAMIENTO)){
								todosActivoAlquilados= true;								
							}
							else{
								todosActivoAlquilados= false;
								break;
							}
						}
						else{
							todosActivoAlquilados= false;
							break;
						}
					}
				}
				
				if(!todosActivoAlquilados){
					if(!Checks.esNulo(cuentaNoArrendada)){
						gastoInfoContabilidad.setCuentaContable(cuentaNoArrendada.getCuentaContable());
					}
				}
				else{
					if(!Checks.esNulo(cuentaArrendada)){
						gastoInfoContabilidad.setCuentaContable(cuentaArrendada.getCuentaContable());
					}
					else{
						gastoInfoContabilidad.setCuentaContable(cuentaNoArrendada.getCuentaContable());
					}
				}
				
			}

			gastoInfoContabilidad.setPartidaPresupuestaria(partida.getPartidaPresupuestaria());
			gasto.setGastoInfoContabilidad(gastoInfoContabilidad);

		} else if (!Checks.esNulo(gastoInfoContabilidad)) {
			gastoInfoContabilidad.setCuentaContable(null);
			gastoInfoContabilidad.setPartidaPresupuestaria(null);
			gasto.setGastoInfoContabilidad(gastoInfoContabilidad);
		}

		return gasto;
	}

	public ConfigCuentaContable buscarCuentaContable(GastoProveedor gasto) {

		List<ConfigCuentaContable> configuracion = null;
		DDCartera cartera = null;
		DDSubtipoGasto subtipoGasto = null;

		cartera = gasto.getCartera();
		subtipoGasto = gasto.getSubtipoGasto();

		if (!Checks.esNulo(cartera) && !Checks.esNulo(subtipoGasto)) {

			// filtros para encontrar la cuenta contable y la partida presupuestaria.
			Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", subtipoGasto.getId());
			Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.id", cartera.getId());

			configuracion = genericDao.getList(ConfigCuentaContable.class, filtroSubtipo, filtroCartera);

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
		subtipoGasto = gasto.getSubtipoGasto();
		if (!Checks.esNulo(gasto.getGastoInfoContabilidad())) {
			ejercicio = gasto.getGastoInfoContabilidad().getEjercicio();
		}

		if (!Checks.esNulo(ejercicio) && !Checks.esNulo(cartera) && !Checks.esNulo(subtipoGasto)) {

			// filtros para encontrar la cuenta contable y la partida presupuestaria.
			Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "ejercicio.id", ejercicio.getId());
			Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", subtipoGasto.getId());
			Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.id", cartera.getId());

			configuracion = genericDao.getList(ConfigPdaPresupuestaria.class, filtroEjercicio, filtroSubtipo, filtroCartera);

			if (!Checks.estaVacio(configuracion) && configuracion.size() == 1) {

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

	private ConfigCuentaContable buscarCuentaContableEspecial(GastoProveedor gasto, List<ConfigCuentaContable> configuracion) {

		ConfigCuentaContable configuracionEspecial = null;
		ConfigCuentaContable configuracionPorDefecto = null;
		List<GastoProveedorActivo> listaActivos = gasto.getGastoProveedorActivos();

		if (!Checks.estaVacio(listaActivos)) {

			Activo activo = listaActivos.get(0).getActivo();

			if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(gasto.getCartera().getCodigo())) {

				for (ConfigCuentaContable config : configuracion) {

					if (!Checks.esNulo(config.getPropietario())) {
						if (config.getPropietario().equals(activo.getPropietarioPrincipal())) {
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

		gasto.setExisteDocumento(i);
		genericDao.update(GastoProveedor.class, gasto);
	}
	
	public String checkReglaCambioEstado(String codigoEstado, boolean coniva, String matriculaTipoDoc) {
		Pattern factPattern = Pattern.compile(".*-FACT-.*");
		Pattern justPattern = Pattern.compile(".*-CERA-.*");

		if (factPattern.matcher(matriculaTipoDoc).matches() && DDEstadoGasto.INCOMPLETO.equals(codigoEstado)) {
			return DDEstadoGasto.PENDIENTE;

		} else if (justPattern.matcher(matriculaTipoDoc).matches()
				&& DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC.equals(codigoEstado) && (!coniva)) {
			return DDEstadoGasto.PAGADO;
		} else {
			return "no_cambiar";
		}
	}
}
