package es.pfsgroup.plugin.rem.api.impl;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.perimetro.dao.PerimetroDao;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionDao;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionHistoricoDao;
import es.pfsgroup.plugin.rem.activo.valoracion.dao.ActivoValoracionDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCargas;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoDatosDq;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTransicionesFasesPublicacion;
import es.pfsgroup.plugin.rem.model.DtoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.DtoCalidadDatoPublicacionActivo;
import es.pfsgroup.plugin.rem.model.DtoCalidadDatoPublicacionGrid;
import es.pfsgroup.plugin.rem.model.DtoCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.DtoHistoricoFasesDePublicacion;
import es.pfsgroup.plugin.rem.model.DtoPaginadoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.VFechasPubCanales;
import es.pfsgroup.plugin.rem.model.VPreciosVigentes;
import es.pfsgroup.plugin.rem.model.VSinInformeAprobadoRem;
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDFasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosOcultacion;
import es.pfsgroup.plugin.rem.model.dd.DDPortal;
import es.pfsgroup.plugin.rem.model.dd.DDSubfasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.notificacion.NotificationActivoManager;
import es.pfsgroup.plugin.rem.usuarioRem.UsuarioRemApi;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.plugin.rem.service.TabActivoService;

@Service("activoEstadoPublicacionManager")
public class ActivoEstadoPublicacionManager implements ActivoEstadoPublicacionApi{
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	private static final Integer ESTADO_PUBLICACION_NARANJA = 0;
	private static final Integer ESTADO_PUBLICACION_AZUL = 1;
	private static final Integer ESTADO_PUBLICACION_AMARILLO = 2;
	private static final String SI = "Si";
	private static final String NO = "No";
	private static final String INSCRITO = "Inscrito";
	private static final String NO_INSCRITO = "No Inscrito";
	private static final String ICONO_TICK_OK = "0";
	private static final String ICONO_TICK_KO = "1";
	private static final String ICONO_TICK_INTERROGANTE = "2";
	
	private static final String PROB_MUY_BAJA = "Muy baja";
	private static final String PROB_BAJA = "Baja";
	private static final String PROB_MEDIA = "Media";
	private static final String PROB_ALTA = "Alta";
	private static final String PROB_MUY_ALTA = "Muy alta";
	
	
	private static final String CALIDADDATO_REGISRALES = "01";
	private static final String CALIDADDATO_REGISTRO = "02";
	private static final String CALIDADDATO_FASE03 = "03";
	private static final String CALIDADDATO_DIRECCION = "04";
	
	
	@Resource
	private MessageService messageServices;
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired 
	private ActivoDao activoDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private PerimetroDao perimetroDao;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;

	@Autowired
	private ActivoPublicacionDao activoPublicacionDao;

	@Autowired
	private ActivoPublicacionHistoricoDao activoPublicacionHistoricoDao;

	@Autowired
	private ActivoValoracionDao activoValoracionDao;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

    private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Autowired
	private NotificationActivoManager notificationActivoManager;
	
	@Autowired
	private UsuarioRemApi usuarioRemApiImpl;
	
	@Autowired
	private ActivoAgrupacionDao activoAgrupacionDao;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Override
	public DtoDatosPublicacionActivo getDatosPublicacionActivo(Long idActivo) {
    	ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);
    	DtoDatosPublicacionActivo dto = activoPublicacionDao.convertirEntidadTipoToDto(activoPublicacion);
		dto.setPrecioWebVenta(activoValoracionDao.getImporteValoracionVentaWebPorIdActivo(idActivo));

		if(!Checks.esNulo(activoPublicacion.getFechaCambioValorVenta())) {
			
			Date fechaInicial=activoPublicacion.getFechaCambioValorVenta();
			Date fechaFinal=new Date();
			Integer dias=(int) (((long)fechaFinal.getTime()-(long)fechaInicial.getTime())/86400000);
			
			dto.setDiasCambioPrecioVentaWeb(dias);
		}
		dto.setPrecioWebAlquiler(activoValoracionDao.getImporteValoracionRentaWebPorIdActivo(idActivo));

		if(!Checks.esNulo(activoPublicacion.getFechaCambioValorVenta())) {
			Date fechaInicial=activoPublicacion.getFechaCambioValorVenta();
			Date fechaFinal=new Date();
			Integer dias=(int) (((long)fechaFinal.getTime()-(long)fechaInicial.getTime())/86400000);
			dto.setDiasCambioPrecioAlqWeb(dias);
		}

		DDAdecuacionAlquiler adecuacionAlquiler = activoPatrimonioDao.getAdecuacionAlquilerFromPatrimonioByIdActivo(idActivo);
		if(!Checks.esNulo(adecuacionAlquiler)) {
			dto.setAdecuacionAlquilerCodigo(adecuacionAlquiler.getCodigo());
			dto.setAdecuacionAlquilerDescripcion(adecuacionAlquiler.getDescripcion());
		}
		
		if(!Checks.esNulo(dto.getFechaRevisionPublicacionesVenta())) {
			dto.setFechaRevisionPublicacionesVenta(dto.getFechaRevisionPublicacionesVenta());
		}
		
		if(!Checks.esNulo(dto.getFechaRevisionPublicacionesAlquiler())) {
			dto.setFechaRevisionPublicacionesAlquiler(dto.getFechaRevisionPublicacionesAlquiler());
		}
		
		if(activoPublicacion.getMotivoOcultacionVenta() != null) {
			dto.setMotivoOcultacionVentaDescripcion(activoPublicacion.getMotivoOcultacionVenta().getDescripcion());
		}
		
		if(activoPublicacion.getMotivoOcultacionAlquiler() != null) {
			dto.setMotivoOcultacionAlquilerDescripcion(activoPublicacion.getMotivoOcultacionAlquiler().getDescripcion());
		}
		
		if(activoPublicacion.getPortal() != null) {
			dto.setCanalDePublicacionDescripcion(activoPublicacion.getPortal().getDescripcion());
		}
		
		dto.setTotalDiasPublicadoVenta(this.obtenerTotalDeDiasEnEstadoPublicadoVenta(idActivo));
		dto.setTotalDiasPublicadoAlquiler(this.obtenerTotalDeDiasEnEstadoPublicadoAlquiler(idActivo));
		dto.setTotalDiasPublicadoHistoricoVenta(this.obtenerTotalDeDiasEnEstadoPublicadoHistoricoVenta(idActivo));
		dto.setTotalDiasPublicadoHistoricoAlquiler(this.obtenerTotalDeDiasEnEstadoPublicadoHistoricoAlquiler(idActivo));
		dto.setDeshabilitarCheckPublicarVenta(this.deshabilitarCheckPublicarVenta(idActivo));
		dto.setDeshabilitarCheckOcultarVenta(this.deshabilitarCheckOcultarVenta(idActivo));
		dto.setDeshabilitarCheckPublicarAlquiler(this.deshabilitarCheckPublicarAlquiler(idActivo));
		dto.setDeshabilitarCheckOcultarAlquiler(this.deshabilitarCheckOcultarAlquiler(idActivo));
		dto.setDeshabilitarCheckPublicarSinPrecioVenta(this.deshabilitarCheckPublicarSinPrecioVenta(idActivo));
		dto.setDeshabilitarCheckPublicarSinPrecioAlquiler(this.deshabilitarCheckPublicarSinPrecioAlquiler(idActivo));
		dto.setDeshabilitarCheckNoMostrarPrecioVenta(this.deshabilitarCheckNoMostrarPrecioVenta(idActivo));
		dto.setDeshabilitarCheckNoMostrarPrecioAlquiler(this.deshabilitarCheckNoMostrarPrecioAlquiler(idActivo));
		if(activoDao.isActivoMatriz(idActivo)) {
			if(DDEstadoPublicacionAlquiler.CODIGO_NO_PUBLICADO_ALQUILER.equals(activoPublicacion.getEstadoPublicacionAlquiler().getCodigo())) {
				dto.setPublicarAlquiler(false);
				dto.setDeshabilitarCheckPublicarAlquiler(true);
				
			}
		}
		
		VFechasPubCanales canal = genericDao.get(VFechasPubCanales.class, genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo));
		if ( canal != null ) {
			if ( canal.getFechaPrimeraPublicacionMin() != null ) {
				dto.setFechaPrimeraPublicacionMin(canal.getFechaPrimeraPublicacionMin());
			}
			if ( canal.getFechaUltimaPublicacionMin() != null ) {
				dto.setFechaUltimaPublicacionMin(canal.getFechaUltimaPublicacionMin());
			}
			if ( canal.getFechaPrimeraPublicacionMay() != null ) {
				dto.setFechaPrimeraPublicacionMay(canal.getFechaPrimeraPublicacionMay());
			}
			if ( canal.getFechaUltimaPublicacionMay() != null ) {
				dto.setFechaUltimaPublicacionMay(canal.getFechaUltimaPublicacionMay());
			}
		}
		
		if(activoPublicacion != null && activoDao.isActivoMatriz(activoPublicacion.getId())) {	
			dto.setCamposPropagablesUas(TabActivoService.TAB_DATOS_PUBLICACION);
		}else {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			dto.setCamposPropagables(TabActivoService.TAB_DATOS_PUBLICACION);
		}
    	return dto;
	}

	@Override
	public DtoDatosPublicacionAgrupacion getDatosPublicacionAgrupacion(Long idActivo) {
		DtoDatosPublicacionAgrupacion dto = new DtoDatosPublicacionAgrupacion(getDatosPublicacionActivo(idActivo));

		Activo activoPrincipal = activoDao.get(idActivo);

		if(!Checks.esNulo(activoPrincipal)) {
			try {
				BeanUtils.copyProperty(dto, "idActivoPrincipal", activoPrincipal.getId());

				PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(idActivo);
				ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(idActivo);

				if(!Checks.esNulo(perimetroActivo)) {
					BeanUtils.copyProperty(dto, "incluidoEnPerimetro", perimetroActivo.getIncluidoEnPerimetro() == 1);
				}

				if(!Checks.esNulo(activoBancario)) {
					if(!Checks.esNulo(activoBancario.getClaseActivo())) {
						BeanUtils.copyProperty(dto, "claseActivoCodigo", activoBancario.getClaseActivo().getCodigo());
					}
				}
			} catch (IllegalAccessException e) {
				logger.error("error en activoEstadoPublicacionManager", e);
			} catch (InvocationTargetException e) {
				logger.error("error en activoEstadoPublicacionManager", e);
			}
		}

    	return dto;
	}

	/**
	 * Este método calcula si el check de publicar activo venta se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check de publicar activo para la venta debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckPublicarVenta(Long idActivo) {
		boolean resultado = false;

		try {
			resultado = !isPublicable(idActivo) || !isComercializable(idActivo) || isVendido(idActivo) || isReservado(idActivo) || isPublicadoVenta(idActivo) || isOcultoVenta(idActivo) ||
					isFueraDePerimetro(idActivo) || (!isInformeAprobado(idActivo) && (!tienePrecioVenta(idActivo) && !isPublicarSinPrecioVentaActivado(idActivo)));
		} catch(Exception e) {
			logger.error("Error en el método deshabilitarCheckPublicarVenta" , e);
		}

		return resultado;	
	}
	
	/**
	 * Este método calcula si el check de publicar sin precio venta se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check de publicar sin precio venta debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckPublicarSinPrecioVenta(Long idActivo) {
		boolean resultado = false;

		try{
			resultado = !isPublicable(idActivo) || isPublicadoVenta(idActivo) || isOcultoVentaVendidoOSalidaSinperimetro(idActivo) || isVendido(idActivo);
		}catch(Exception e){
			logger.error("Error en el método deshabilitarCheckPublicarSinPrecioVenta" , e);
		}

		return resultado;	
	}

	/**
	 * Este método calcula si el check de publicar sin precio venta se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check de publicar sin precio venta debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckPublicarSinPrecioAlquiler(Long idActivo) {
		boolean resultado = false;

		try{
			resultado = !isPublicable(idActivo) || isPublicadoAlquiler(idActivo) || isOcultoAlquilerVendidoOSalidaSinperimetro(idActivo) || isVendido(idActivo) || isFueraDePerimetro(idActivo);
		}catch(Exception e){
			logger.error("Error en el método deshabilitarCheckPublicarSinPrecioAlquiler" , e);
		}
		
		return resultado;
	}
	
	/**
	 * Este método calcula si el check de no mostrar precio venta se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check no mostrar precio para la venta debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckNoMostrarPrecioVenta(Long idActivo) {
		Boolean resultado = false;
		try {
			resultado = !isPublicable(idActivo);
		} catch(Exception e) {
			logger.error("Error en el método deshabilitarCheckNoMostrarPrecioVenta" , e);
		}
		
		return resultado;
	}
	
	/**
	 * Este método calcula si el check de no mostrar precio alquiler se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check no mostrar precio para el alquiler debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckNoMostrarPrecioAlquiler(Long idActivo) {
		Boolean resultado = false;
		try {
			resultado = !isPublicable(idActivo);
		} catch(Exception e) {
			logger.error("Error en el método deshabilitarCheckNoMostrarPrecioAlquiler" , e);
		}
		
		return resultado;
	}

	/**
	 * Este método calcula si el check de ocultar activo venta se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check de ocultar activo para la venta debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckOcultarVenta(Long idActivo) {

		Boolean resultado = false;
		try {
			resultado = !isPublicable(idActivo) || !isComercializable(idActivo) || isVendido(idActivo)
					|| (!isPublicadoVenta(idActivo) && !isOcultoVenta(idActivo)) || isOcultoAutomaticoVenta(idActivo)
					|| isFueraDePerimetro(idActivo);
		} catch (Exception e) {
			logger.error("Error en el método deshabilitarCheckOcultarVenta", e);
		}

		return resultado;
	}
	
	/**
	 * Este método calcula si el check de ocultar activo alquiler se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check de ocultar activo para el alquiler debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckOcultarAlquiler(Long idActivo) {
		Boolean resultado = false;
		try {
			resultado = !isPublicable(idActivo) || !isComercializable(idActivo) || isVendido(idActivo)
					|| (!isPublicadoAlquiler(idActivo) && !isOcultoAlquiler(idActivo)) || isOcultoAutomaticoAlquiler(idActivo)
					|| isFueraDePerimetro(idActivo);
		} catch (Exception e) {
			logger.error("Error en el método deshabilitarCheckOcultarAlquiler", e);
		}

		return resultado;
	}

	/**
	 * Este método calcula si el check de publicar activo alquiler se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check de publicar activo para el alquiler debe estar deshabilitado.
	 */
	@Transactional(readOnly=false)
	public Boolean deshabilitarCheckPublicarAlquiler(Long idActivo) {
		Boolean resultado = false;
		Boolean hagoElRestoComprobaciones = true;
		try{
			if(activoDao.isActivoMatriz(idActivo)) {
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
				ActivoPublicacion activoPublicacion  = genericDao.get(ActivoPublicacion.class, filter);
				
				if(DDEstadoPublicacionAlquiler.CODIGO_NO_PUBLICADO_ALQUILER.equals(activoPublicacion.getEstadoPublicacionAlquiler().getCodigo())) {
					hagoElRestoComprobaciones = false;
					resultado = true;
				}
			}
			if(hagoElRestoComprobaciones) {
				resultado = !isPublicable(idActivo) || !isComercializable(idActivo) || isVendido(idActivo) || isReservado(idActivo) || isPublicadoAlquiler(idActivo) || isOcultoAlquiler(idActivo) ||
				!isAdecuacionAlquilerNotNull(idActivo) || isFueraDePerimetro(idActivo) || (!isInformeAprobado(idActivo) && (!tienePrecioRenta(idActivo) && !isPublicarSinPrecioAlquilerActivado(idActivo)));
			}
		}catch(Exception e){
			logger.error("Error en el método deshabilitarCheckPublicarAlquiler",e);
		}
		
		return resultado;
	}

	// Comprobación mínima.
	private Boolean isAdecuacionAlquilerNotNull(Long idActivo) {
		DDAdecuacionAlquiler adecuacionAlquiler = activoPatrimonioDao.getAdecuacionAlquilerFromPatrimonioByIdActivo(idActivo);
		if(!Checks.esNulo(adecuacionAlquiler)) {
			return DDAdecuacionAlquiler.CODIGO_ADA_SI.equals(adecuacionAlquiler.getCodigo()) 
					|| DDAdecuacionAlquiler.CODIGO_ADA_NO_APLICA.equals(adecuacionAlquiler.getCodigo())
					|| DDAdecuacionAlquiler.CODIGO_ADA_NO.equals(adecuacionAlquiler.getCodigo());
		}

		return false;
	}

	// Comprobación mínima.
	private Boolean isInformeAprobado(Long idActivo) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		VSinInformeAprobadoRem vsi = genericDao.get(VSinInformeAprobadoRem.class, filter);

		return !Checks.esNulo(vsi) && !vsi.getSinInformeAprobadoREM();
	}

	// Comprobación mínima.
	private Boolean tienePrecioVenta(Long idActivo) {
		Double tienePrecioVenta = activoValoracionDao.getImporteValoracionVentaWebPorIdActivo(idActivo);
		return !Checks.esNulo(tienePrecioVenta) && tienePrecioVenta != 0.0;
	}

	// Comprobación mínima.
	private Boolean tienePrecioRenta(Long idActivo) {
		Double tienePrecioRenta = activoValoracionDao.getImporteValoracionRentaWebPorIdActivo(idActivo);
		return !Checks.esNulo(tienePrecioRenta) && tienePrecioRenta != 0.0;
	}

	// Comprobación mínima.
	private Boolean isPublicable(Long idActivo) {
		PerimetroActivo perimetro = perimetroDao.getPerimetroActivoByIdActivo(idActivo);

		if(!Checks.esNulo(perimetro) && !Checks.esNulo(perimetro.getAplicaPublicar())) {
			return perimetro.getAplicaPublicar();
		}

		return true;
	}

	// Comprobación mínima.
	private Boolean isFueraDePerimetro(Long idActivo) {
		PerimetroActivo perimetro = perimetroDao.getPerimetroActivoByIdActivo(idActivo);

		return Checks.esNulo(perimetro) || perimetro.getIncluidoEnPerimetro() == 0;
	}

	// Comprobación mínima.
	private Boolean isComercializable(Long idActivo) {
		PerimetroActivo perimetro = perimetroDao.getPerimetroActivoByIdActivo(idActivo);
		if (!Checks.esNulo(perimetro) && !Checks.esNulo(perimetro.getAplicaComercializar())){
			return perimetro.getAplicaComercializar() == 1;
		}
		return false;
	}

	// Comprobación mínima.
	private Boolean isVendido(Long idActivo) {
    	Activo activo = activoDao.get(idActivo);
		Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(activoDao.get(idActivo));

		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getEstado()) && DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())) {
				return true;
			}
		}

		return !Checks.esNulo(activo.getFechaVentaExterna());
	}

	// Comprobación mínima.
	private Boolean isReservado(Long idActivo) {
		Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(activoDao.get(idActivo));

		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			
			
			if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getReserva()) && !Checks.esNulo(expediente.getReserva().getEstadoReserva().getCodigo())){
				
				return DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo());
			}
		}

		return false;
	}

	// Comprobación mínima.
	private Boolean isPublicarSinPrecioVentaActivado(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		if (!Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getCheckSinPrecioVenta())){
			return activoPublicacion.getCheckSinPrecioVenta();
		}
		
		return false;
	}

	// Comprobación mínima.
	private Boolean isPublicarSinPrecioAlquilerActivado(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && activoPublicacion.getCheckSinPrecioAlquiler();
	}
	
	// Comprobación mínima.
	private Boolean isOcultoVentaVendidoOSalidaSinperimetro(Long idActivo){
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);
		
		return !Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getEstadoPublicacionVenta()) &&
			   !Checks.esNulo(activoPublicacion.getMotivoOcultacionVenta()) &&
			   ((DDMotivosOcultacion.CODIGO_VENDIDO).equals(activoPublicacion.getMotivoOcultacionVenta().getCodigo())
						|| (DDMotivosOcultacion.CODIGO_SALIDA_PERIMETRO).equals(activoPublicacion.getMotivoOcultacionVenta().getCodigo()));
	}
	
	// Comprobación mínima.
	private Boolean isOcultoAlquilerVendidoOSalidaSinperimetro(Long idActivo){
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);
			
		return !Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getEstadoPublicacionAlquiler()) &&
				  !Checks.esNulo(activoPublicacion.getMotivoOcultacionAlquiler()) &&
				  ((DDMotivosOcultacion.CODIGO_VENDIDO).equals(activoPublicacion.getMotivoOcultacionAlquiler().getCodigo())
						|| (DDMotivosOcultacion.CODIGO_SALIDA_PERIMETRO).equals(activoPublicacion.getMotivoOcultacionAlquiler().getCodigo()));
	}
	
	// Comprobación mínima.
	private Boolean isPublicadoVenta(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getEstadoPublicacionVenta()) &&
				(DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA.equals(activoPublicacion.getEstadoPublicacionVenta().getCodigo()));
	}

	// Comprobación mínima.
	private Boolean isOcultoVenta(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getEstadoPublicacionVenta()) &&
				DDEstadoPublicacionVenta.CODIGO_OCULTO_VENTA.equals(activoPublicacion.getEstadoPublicacionVenta().getCodigo());
	}

	// Comprobación mínima.
	private Boolean isOcultoAutomaticoVenta(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getEstadoPublicacionVenta()) &&
				DDEstadoPublicacionVenta.CODIGO_OCULTO_VENTA.equals(activoPublicacion.getEstadoPublicacionVenta().getCodigo()) && !Checks.esNulo(activoPublicacion.getMotivoOcultacionVenta()) &&
				!activoPublicacion.getMotivoOcultacionVenta().getEsMotivoManual();
	}

	// Comprobación mínima.
	private Boolean isPublicadoAlquiler(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getEstadoPublicacionAlquiler()) &&
				(DDEstadoPublicacionAlquiler.CODIGO_PUBLICADO_ALQUILER.equals(activoPublicacion.getEstadoPublicacionAlquiler().getCodigo()));
	}

	// Comprobación mínima.
	private Boolean isOcultoAlquiler(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getEstadoPublicacionAlquiler()) &&
				DDEstadoPublicacionAlquiler.CODIGO_OCULTO_ALQUILER.equals(activoPublicacion.getEstadoPublicacionAlquiler().getCodigo());
	}

	// Comprobación mínima.
	private Boolean isOcultoAutomaticoAlquiler(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getEstadoPublicacionAlquiler()) &&
				DDEstadoPublicacionAlquiler.CODIGO_OCULTO_ALQUILER.equals(activoPublicacion.getEstadoPublicacionAlquiler().getCodigo()) &&
				!Checks.esNulo(activoPublicacion.getMotivoOcultacionAlquiler()) && !activoPublicacion.getMotivoOcultacionAlquiler().getEsMotivoManual();
	}

	// Comprobación mínima.
	private Boolean isAdmisionOK(Long idActivo) {
		Activo activo = activoDao.get(idActivo);

		return !Checks.esNulo(activo.getAdmision()) && activo.getAdmision();
	}

	// Comprobación mínima.
	private Boolean isGestionOK(Long idActivo) {
		Activo activo = activoDao.get(idActivo);

		return !Checks.esNulo(activo.getGestion()) && activo.getGestion();
	}

	@Override
	@Transactional
	public Boolean setDatosPublicacionActivo(DtoDatosPublicacionActivo dto) throws JsonViewerException{
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(dto.getIdActivo());
		
		List <ActivoPublicacion> activosPublicacion = new ArrayList <ActivoPublicacion>();
		activosPublicacion.add(activoPublicacion);
		
		if(this.actualizarDatosEstadoActualPublicaciones(dto, activosPublicacion)) {
			this.publicarActivoProcedure(dto.getIdActivo(), genericAdapter.getUsuarioLogado().getUsername(), dto.getEleccionUsuarioTipoPublicacionAlquiler());

			enviarCorreoAlPublicarActivo(dto);
		}

		return false;
	}

	@Override
	@Transactional
	public Boolean setDatosPublicacionAgrupacion(Long id, DtoDatosPublicacionAgrupacion dto) throws JsonViewerException{
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
		List<ActivoPublicacion> activosPublicacion = new ArrayList<ActivoPublicacion>();

		for(ActivoAgrupacionActivo aga : activos) {
			ActivoPublicacion activoPublicacion = new ActivoPublicacion();
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", aga.getActivo().getId());
			ActivoSituacionPosesoria condicionantesDisponibilidad = genericDao.get(ActivoSituacionPosesoria.class, filtro);
			
			// Registrar el condicionante de disponibilidad 'otros' si se ha modificado.
			if(!Checks.esNulo(dto.getComboOtro()) || (!Checks.esNulo(dto.getOtro()) && !Checks.esNulo(condicionantesDisponibilidad.getOtro()) && !dto.getOtro().equals(condicionantesDisponibilidad.getOtro()))) {
				DtoCondicionantesDisponibilidad dtoCondicionateDisponibilidad = new DtoCondicionantesDisponibilidad();
				dtoCondicionateDisponibilidad.setOtro(dto.getOtro());
				dtoCondicionateDisponibilidad.setComboOtro(dto.getComboOtro());
				activoApi.saveCondicionantesDisponibilidad(aga.getActivo().getId(), dtoCondicionateDisponibilidad);
			}

			// Registrar los cambios en la publicación.
			activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(aga.getActivo().getId());
			activosPublicacion.add(activoPublicacion);
		}
		this.actualizarDatosEstadoActualPublicaciones(dto, activosPublicacion);

		activoDao.publicarAgrupacionConHistorico(id, genericAdapter.getUsuarioLogado().getUsername(), dto.getEleccionUsuarioTipoPublicacionAlquiler(), true);
		return true;
	}
	
	@Override
	@Transactional
	public Boolean setDatosPublicacionAgrupacionMasivo(Long id, DtoDatosPublicacionAgrupacion dto) throws JsonViewerException{
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();

		for(ActivoAgrupacionActivo aga : activos) {
			// Registrar el condicionante de disponibilidad 'otros' si se ha modificado.
			if(!Checks.esNulo(dto.getOtro())) {
				DtoCondicionantesDisponibilidad dtoCondicionateDisponibilidad = new DtoCondicionantesDisponibilidad();
				dtoCondicionateDisponibilidad.setOtro(dto.getOtro());
				activoApi.saveCondicionantesDisponibilidad(aga.getActivo().getId(), dtoCondicionateDisponibilidad);
			}
						
			// Registrar los cambios en la publicación.
			ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(aga.getActivo().getId());
			List <ActivoPublicacion> activosPublicacion = new ArrayList <ActivoPublicacion>();
			activosPublicacion.add(activoPublicacion);
			
			this.actualizarDatosEstadoActualPublicaciones(dto, activosPublicacion);
		}
		
		return true;
	}

	@Override
	public Boolean isPublicadoVentaByIdActivo(Long idActivo) {
		return this.isPublicadoVenta(idActivo);
	}

	@Override
	public Boolean isPublicadoAlquilerByIdActivo(Long idActivo) {
		return this.isPublicadoAlquiler(idActivo);
	}

	/**
	 * Este método actualiza el registro del estado actual de publicación del activo con los datos del dto
	 * que se recibe.
	 *
	 * @param dto : dto con los datos a guardar en el estado actual de publicación.
	 * @param lista activoPublicacion : entidad del estado actual de publicación en la que persistir los datos nuevos.
	 * @return Devuelve True si el proceso ha sido satisfactorio, False si no lo ha sido.
	 */
	
	@Transactional
	public Boolean actualizarDatosEstadoActualPublicaciones(DtoDatosPublicacionActivo dto, List<ActivoPublicacion> activosPublicacion) { //
		try {
			List<Long> listaIdActivos = new ArrayList<Long>();
			for(ActivoPublicacion activoPublicacion : activosPublicacion) {
				listaIdActivos.add(activoPublicacion.getActivo().getId());
				if(!Checks.esNulo(dto.getMotivoOcultacionVentaCodigo())) {
					beanUtilNotNull.copyProperty(activoPublicacion, "motivoOcultacionVenta", utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivosOcultacion.class,
							dto.getMotivoOcultacionVentaCodigo()));
				}
				if(!Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo())) {
					beanUtilNotNull.copyProperty(activoPublicacion, "motivoOcultacionAlquiler", utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivosOcultacion.class,
							dto.getMotivoOcultacionAlquilerCodigo()));
				}
				beanUtilNotNull.copyProperty(activoPublicacion, "motivoOcultacionManualVenta", dto.getMotivoOcultacionManualVenta());
				beanUtilNotNull.copyProperty(activoPublicacion, "motivoOcultacionManualAlquiler", dto.getMotivoOcultacionManualAlquiler());
				beanUtilNotNull.copyProperty(activoPublicacion, "checkPublicarVenta", dto.getPublicarVenta());
				beanUtilNotNull.copyProperty(activoPublicacion, "checkOcultarVenta", dto.getOcultarVenta());
				if(!Checks.esNulo(dto.getOcultarVenta()) && !dto.getOcultarVenta()) {
					// Si el check de ocultar viene implícitamente a false vaciar motivos de ocultación.
					activoPublicacion.setMotivoOcultacionVenta(null);
					activoPublicacion.setMotivoOcultacionManualVenta(null);
				}
				beanUtilNotNull.copyProperty(activoPublicacion, "checkOcultarPrecioVenta", dto.getNoMostrarPrecioVenta());
				beanUtilNotNull.copyProperty(activoPublicacion, "checkSinPrecioVenta", dto.getPublicarSinPrecioVenta());
				beanUtilNotNull.copyProperty(activoPublicacion, "checkPublicarAlquiler", dto.getPublicarAlquiler());
				beanUtilNotNull.copyProperty(activoPublicacion, "checkOcultarAlquiler", dto.getOcultarAlquiler());
				if(!Checks.esNulo(dto.getOcultarAlquiler()) && !dto.getOcultarAlquiler()) {
					// Si el check de ocultar viene implícitamente a false vaciar motivos de ocultación.
					activoPublicacion.setMotivoOcultacionAlquiler(null);
					activoPublicacion.setMotivoOcultacionManualAlquiler(null);
				}
				beanUtilNotNull.copyProperty(activoPublicacion, "checkOcultarPrecioAlquiler", dto.getNoMostrarPrecioAlquiler());
				beanUtilNotNull.copyProperty(activoPublicacion, "checkSinPrecioAlquiler", dto.getPublicarSinPrecioAlquiler());
				activoPublicacion.getAuditoria().setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
	
	
				if(!Checks.esNulo(dto.getMotivoOcultacionVentaCodigo()) 
						|| !Checks.esNulo(dto.getMotivoOcultacionManualVenta()) 
						|| !Checks.esNulo(dto.getPublicarVenta()) 
						|| !Checks.esNulo(dto.getOcultarVenta()) 
						|| (!Checks.esNulo(dto.getPublicarSinPrecioVenta()) && !Checks.esNulo(activoPublicacion.getMotivoOcultacionVenta()) 
								&& DDMotivosOcultacion.CODIGO_SIN_PRECIO.equals(activoPublicacion.getMotivoOcultacionVenta().getCodigo()))) {
					activoPublicacion.setFechaInicioVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
				}
				
				if(!Checks.esNulo(dto.getMotivoOcultacionVentaCodigo()) 
						|| !Checks.esNulo(dto.getMotivoOcultacionManualVenta()) 
						|| !Checks.esNulo(dto.getPublicarVenta()) 
						|| !Checks.esNulo(dto.getOcultarVenta())) {
					activoPublicacion.setFechaCambioPubVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
				}
				
				if(!Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo()) 
						|| !Checks.esNulo(dto.getMotivoOcultacionManualAlquiler()) 
						|| !Checks.esNulo(dto.getPublicarAlquiler()) 
						|| !Checks.esNulo(dto.getOcultarAlquiler()) 
						|| (!Checks.esNulo(dto.getPublicarSinPrecioAlquiler()) && !Checks.esNulo(activoPublicacion.getMotivoOcultacionAlquiler()) 
								&& DDMotivosOcultacion.CODIGO_SIN_PRECIO.equals(activoPublicacion.getMotivoOcultacionAlquiler().getCodigo()))) {
					activoPublicacion.setFechaInicioAlquiler(new Date(System.currentTimeMillis() + 3600 * 1000));
				}
				
				if(!Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo()) 
						|| !Checks.esNulo(dto.getMotivoOcultacionManualAlquiler()) 
						|| !Checks.esNulo(dto.getPublicarAlquiler()) 
						|| !Checks.esNulo(dto.getOcultarAlquiler())) {
					activoPublicacion.setFechaCambioPubAlq(new Date(System.currentTimeMillis() + 3600 * 1000));
				}
				
				if(!Checks.esNulo(dto.getNoMostrarPrecioVenta())){
					activoPublicacion.setFechaCambioValorVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
				}
				
				if(!Checks.esNulo(dto.getNoMostrarPrecioAlquiler())){
					activoPublicacion.setFechaCambioValorAlq(new Date(System.currentTimeMillis() + 3600 * 1000));
						
				}
				
				if(!Checks.esNulo(dto.getMotivoOcultacionVentaCodigo())
						&& (!DDMotivosOcultacion.CODIGO_OTROS.equals(dto.getMotivoOcultacionVentaCodigo()))) {
						activoPublicacion.setMotivoOcultacionManualVenta(null);
				}
				
				if(!Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo())
					&& (!DDMotivosOcultacion.CODIGO_OTROS.equals(dto.getMotivoOcultacionAlquilerCodigo()))) {
					activoPublicacion.setMotivoOcultacionManualAlquiler(null);
				}
				
				if(!Checks.esNulo(dto.getPublicarVenta()) && !dto.getPublicarVenta()) {
					activoPublicacion.setMotivoPublicacion(dto.getMotivoPublicacion());
				}else {
					beanUtilNotNull.copyProperty(activoPublicacion, "motivoPublicacion", dto.getMotivoPublicacion());
				}
				
				
				if(!Checks.esNulo(dto.getPublicarAlquiler()) && !dto.getPublicarAlquiler()) {
					activoPublicacion.setMotivoPublicacionAlquiler(dto.getMotivoPublicacionAlquiler());
				}else {
					beanUtilNotNull.copyProperty(activoPublicacion, "motivoPublicacionAlquiler", dto.getMotivoPublicacionAlquiler());
				}
				
				if(!Checks.esNulo(dto.getFechaRevisionPublicacionesVenta())) {
					activoPublicacion.setFechaRevisionPublicacionesVenta(dto.getFechaRevisionPublicacionesVenta());
				}
				
				if(!Checks.esNulo(dto.getFechaRevisionPublicacionesAlquiler())) {
					activoPublicacion.setFechaRevisionPublicacionesAlquiler(dto.getFechaRevisionPublicacionesAlquiler());
				}
				if (dto.getCanalDePublicacion() != null) {
					DDPortal portal = genericDao.get(DDPortal.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCanalDePublicacion()));
					activoPublicacion.setPortal(portal);
				}
				
				DDEstadoPublicacionAlquiler estadoPublicacionAlquiler= null;
				if(activoPublicacion.getCheckPublicarAlquiler() != null && activoPublicacion.getCheckPublicarAlquiler()) {
					if(activoPublicacion.getCheckOcultarAlquiler() != null && activoPublicacion.getCheckOcultarAlquiler()) {
						estadoPublicacionAlquiler = (DDEstadoPublicacionAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacionAlquiler.class,  DDEstadoPublicacionAlquiler.CODIGO_OCULTO_ALQUILER);
					} else {
						estadoPublicacionAlquiler = (DDEstadoPublicacionAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacionAlquiler.class,  DDEstadoPublicacionAlquiler.CODIGO_PUBLICADO_ALQUILER);
					}				
				}else {
					estadoPublicacionAlquiler = (DDEstadoPublicacionAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacionAlquiler.class,  DDEstadoPublicacionAlquiler.CODIGO_NO_PUBLICADO_ALQUILER);
				}
				
				DDEstadoPublicacionVenta estadoPublicacionVenta= null;
				if(activoPublicacion.getCheckPublicarVenta() != null && activoPublicacion.getCheckPublicarVenta()) {
					if(activoPublicacion.getCheckOcultarVenta() != null && activoPublicacion.getCheckOcultarVenta()) {
						estadoPublicacionVenta = (DDEstadoPublicacionVenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacionVenta.class,  DDEstadoPublicacionVenta.CODIGO_OCULTO_VENTA);
					}else {
						estadoPublicacionVenta = (DDEstadoPublicacionVenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacionVenta.class,  DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA);
					}
				}else {
					estadoPublicacionVenta = (DDEstadoPublicacionVenta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacionVenta.class,  DDEstadoPublicacionVenta.CODIGO_NO_PUBLICADO_VENTA);
				}
				
				activoPublicacion.setEstadoPublicacionAlquiler(estadoPublicacionAlquiler);
				activoPublicacion.setEstadoPublicacionVenta(estadoPublicacionVenta);
				
				activoPublicacionDao.save(activoPublicacion);
				
				if(!Checks.esNulo(dto.getMotivoOcultacionVentaCodigo()) || !Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo())) {
					registrarHistoricoPublicacion(activoPublicacion, dto);
					
					if(!Checks.esNulo(dto.getMotivoOcultacionVentaCodigo())) {
						ActivoPublicacionHistorico activoPublicacionHistorico = new ActivoPublicacionHistorico();
						BeanUtils.copyProperties(activoPublicacionHistorico, activoPublicacion);
						activoPublicacionHistorico.setFechaInicioVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
						activoPublicacionHistorico.setFechaInicioAlquiler(null);
						activoPublicacionHistorico.setAuditoria(null);
						activoPublicacionHistoricoDao.save(activoPublicacionHistorico);
					}
					if(!Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo())) {
						ActivoPublicacionHistorico activoPublicacionHistorico = new ActivoPublicacionHistorico();
						BeanUtils.copyProperties(activoPublicacionHistorico, activoPublicacion);
						activoPublicacionHistorico.setFechaInicioVenta(null);
						activoPublicacionHistorico.setFechaInicioAlquiler(new Date(System.currentTimeMillis() + 3600 * 1000));
						activoPublicacionHistorico.setAuditoria(null);
						activoPublicacionHistoricoDao.save(activoPublicacionHistorico);
					}
				}
			}
			
			recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(listaIdActivos);
		} catch (IllegalAccessException e) {
			logger.error("Error al actualizar el estado actual de publicacion, error: ", e);
			return false;
		} catch (InvocationTargetException e) {
			logger.error("Error al actualizar el estado actual de publicacion, error: ", e);
			return false;
		}

		return true;
	}

	/**
	 * Este método coge los datos de publicación actuales del activo y los copia en el histórico.
	 * Añade la fecha de fin para el tipo de comercialización en la cual se encuentre el activo.
	 *
	 * @param activoPublicacion: registro de publicación actual del activo.
	 * @return Devuelve True si el proceso ha sido satisfactorio, False si no lo ha sido.
	 */
	private Boolean registrarHistoricoPublicacion(ActivoPublicacion activoPublicacion, DtoDatosPublicacionActivo dto) {
		try {
			if(Arrays.asList(DDTipoComercializacion.CODIGOS_VENTA).contains(activoPublicacion.getTipoComercializacion().getCodigo()) &&
					(!Checks.esNulo(dto.getMotivoOcultacionVentaCodigo()) || !Checks.esNulo(dto.getMotivoOcultacionManualVenta()) || 
					!Checks.esNulo(dto.getPublicarVenta()) || !Checks.esNulo(dto.getOcultarVenta()))) {
				ActivoPublicacionHistorico activoPublicacionHistoricoVenta = activoPublicacionHistoricoDao.getActivoPublicacionHistoricoActualVenta(activoPublicacion.getActivo().getId());
				activoPublicacionHistoricoVenta.setFechaFinVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
				activoPublicacionHistoricoDao.saveOrUpdate(activoPublicacionHistoricoVenta);
			}
			if(Arrays.asList(DDTipoComercializacion.CODIGOS_ALQUILER).contains(activoPublicacion.getTipoComercializacion().getCodigo()) &&
					(!Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo()) || !Checks.esNulo(dto.getMotivoOcultacionManualAlquiler()) || 
					!Checks.esNulo(dto.getPublicarAlquiler()) || !Checks.esNulo(dto.getOcultarAlquiler()) || 
					(!Checks.esNulo(dto.getEleccionUsuarioTipoPublicacionAlquiler()) && (DDEstadoPublicacionAlquiler.CODIGO_PRE_PUBLICADO_ALQUILER.equals(activoPublicacion.getEstadoPublicacionAlquiler().getCodigo()) && !dto.getEleccionUsuarioTipoPublicacionAlquiler().equals("0"))) )) {
				ActivoPublicacionHistorico activoPublicacionHistoricoAlquiler = activoPublicacionHistoricoDao.getActivoPublicacionHistoricoActualAlquiler(activoPublicacion.getActivo().getId());
				activoPublicacionHistoricoAlquiler.setFechaFinAlquiler(new Date(System.currentTimeMillis() + 3600 * 1000));
				activoPublicacionHistoricoDao.saveOrUpdate(activoPublicacionHistoricoAlquiler);
			}
		} catch (Exception e) {
			logger.error("Error al registrar en el historico el estado actual de publicacion, error: ", e);
			return false;
		}

		return true;
	}

	/**
	 * Este método suma el total de días que ha estado un activo publicado para el tipo comercial venta.
	 * Los días obtenidos son referentes a los periodos que ha estado el activo en el estado publicado.
	 * La suma incluye los días desde su última publicación.
	 *
	 * @param idActivo: ID del activo para obtener los días.
	 * @return Devuelve el total de días que ha estado el activo publicado desde la última publicación.
	 */
	private Integer obtenerTotalDeDiasEnEstadoPublicadoVenta(Long idActivo) {
		Integer dias = 0;

		Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filterEstadoPublicacion = genericDao.createFilter(FilterType.EQUALS, "estadoPublicacionVenta.codigo", DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA);
		Filter filterAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filterFecha = genericDao.createFilter(FilterType.NULL, "fechaFinVenta");
		Order orden = new Order(OrderType.DESC, "id");
		
		List<ActivoPublicacionHistorico> listaActivoPublicacionesHistoricas = 
				genericDao.getListOrdered(ActivoPublicacionHistorico.class, orden, filterActivo, filterEstadoPublicacion, filterAuditoria, filterFecha);
		
		if(!Checks.estaVacio(listaActivoPublicacionesHistoricas)){
			ActivoPublicacionHistorico ultimaPublicacion = listaActivoPublicacionesHistoricas.get(0);
			try {
				dias = (int)(long)activoPublicacionHistoricoDao.obtenerDiasPorEstadoPublicacionVentaActivo(ultimaPublicacion);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		return dias;
	}
	
	/**
	 * Este método suma el total de días que ha estado un activo publicado para el tipo comercial venta.
	 * Los días obtenidos son referentes a los periodos que ha estado el activo en el estado publicado.
	 * La suma incluye los días de estados anteriores, histórico, y el estado actual, si éste es publicado.
	 *
	 * @param idActivo: ID del activo para obtener los días.
	 * @return Devuelve el total de días que ha estado el activo publicado.
	 */
	private Integer obtenerTotalDeDiasEnEstadoPublicadoHistoricoVenta(Long idActivo) {
		Integer dias = 0;

		Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filterEstadoPublicacion = genericDao.createFilter(FilterType.EQUALS, "estadoPublicacionVenta.codigo", DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA);
		Filter filterAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orden = new Order(OrderType.DESC, "id");
		
		List<ActivoPublicacionHistorico> listaActivoPublicacionesHistoricas = 
				genericDao.getListOrdered(ActivoPublicacionHistorico.class, orden, filterActivo, filterEstadoPublicacion, filterAuditoria);
		
		if(!Checks.estaVacio(listaActivoPublicacionesHistoricas)){
			for(int i=0; i<listaActivoPublicacionesHistoricas.size(); i++) {
				ActivoPublicacionHistorico primeraPublicacion = listaActivoPublicacionesHistoricas.get(i);
				try {
					dias = dias + (int)(long)activoPublicacionHistoricoDao.obtenerDiasPorEstadoPublicacionVentaActivo(primeraPublicacion);
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			
		}
		
		return dias;
	}

	/**
	 * Este método suma el total de días que ha estado un activo publicado para el tipo comercial alquiler.
	 * Los días obtenidos son referentes a los periodos que ha estado el activo en el estado publicado.
	 * La suma incluye los días desde su últma publicación.
	 *
	 * @param idActivo: ID del activo para obtener los días.
	 * @return Devuelve el total de días que ha estado el activo publicado.
	 */
	private Integer obtenerTotalDeDiasEnEstadoPublicadoAlquiler(Long idActivo) {
		Integer dias = 0;

		Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filterEstadoPublicacion = genericDao.createFilter(FilterType.EQUALS, "estadoPublicacionAlquiler.codigo", DDEstadoPublicacionAlquiler.CODIGO_PUBLICADO_ALQUILER);
		Filter filterAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filterFecha = genericDao.createFilter(FilterType.NULL, "fechaFinAlquiler");
		Order orden = new Order(OrderType.DESC, "id");
		
		List<ActivoPublicacionHistorico> listaActivoPublicacionesHistoricas = 
				genericDao.getListOrdered(ActivoPublicacionHistorico.class, orden, filterActivo, filterEstadoPublicacion, filterAuditoria, filterFecha);
		
		if(!Checks.estaVacio(listaActivoPublicacionesHistoricas)){
			ActivoPublicacionHistorico ultimaPublicacion = listaActivoPublicacionesHistoricas.get(0);
			try {
				dias = (int)(long)activoPublicacionHistoricoDao.obtenerDiasPorEstadoPublicacionAlquilerActivo(ultimaPublicacion);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		return dias;
	}
	
	/**
	 * Este método suma el total de días que ha estado un activo publicado para el tipo comercial alquiler.
	 * Los días obtenidos son referentes a los periodos que ha estado el activo en el estado publicado.
	 * La suma incluye los días de estados anteriores, histórico, y el estado actual, si éste es publicado.
	 *
	 * @param idActivo: ID del activo para obtener los días.
	 * @return Devuelve el total de días que ha estado el activo publicado.
	 */
	private Integer obtenerTotalDeDiasEnEstadoPublicadoHistoricoAlquiler(Long idActivo) {
		Integer dias = 0;

		Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filterEstadoPublicacion = genericDao.createFilter(FilterType.EQUALS, "estadoPublicacionAlquiler.codigo", DDEstadoPublicacionAlquiler.CODIGO_PUBLICADO_ALQUILER);
		Filter filterAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orden = new Order(OrderType.DESC, "id");
		
		List<ActivoPublicacionHistorico> listaActivoPublicacionesHistoricas = 
				genericDao.getListOrdered(ActivoPublicacionHistorico.class, orden, filterActivo, filterEstadoPublicacion, filterAuditoria);
		
		if(!Checks.estaVacio(listaActivoPublicacionesHistoricas)){
			for(int i=0; i<listaActivoPublicacionesHistoricas.size(); i++) {
				ActivoPublicacionHistorico primeraPublicacion = listaActivoPublicacionesHistoricas.get(i);
				try {
					dias = dias + (int)(long)activoPublicacionHistoricoDao.obtenerDiasPorEstadoPublicacionAlquilerActivo(primeraPublicacion);
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
		}
		
		return dias;
	}

	@Override
	public DtoPaginadoHistoricoEstadoPublicacion getHistoricoEstadosPublicacionVentaByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto) {

		return activoPublicacionHistoricoDao.getListadoPaginadoHistoricoEstadosPublicacionVentaByIdActivo(dto);
	}

	@Override
	public DtoPaginadoHistoricoEstadoPublicacion getHistoricoEstadosPublicacionAlquilerByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto) {

		return activoPublicacionHistoricoDao.getListadoHistoricoEstadosPublicacionAlquilerByIdActivo(dto);
	}

	/**
	 * Este método actualiza el estado de publicación del activo llamando a un Procedure, el cual, realiza
	 * unos cálculos para determinar el nuevo estado de publicación del activo indicado en base a sus nuevos
	 * datos de publicación. La operación se registra con el nombre de usuario que recibe.
	 *
	 * @param idActivo: Id del activo sobre el que realizar la actualización del estado de publicación.
	 * @param username: Nombre del usuario que realiza la acción de guardar el nuevo estado de publicación.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 * @throws JsonViewerException Provoca una excepción cuando el proceso del SP ha tenido algún error. De
	 * este modo, se informa hacia la interfaz.
	 */
	private Boolean publicarActivoProcedure(Long idActivo, String username, String eleccionUsuarioTipoPublicacionAlquiler) throws JsonViewerException{
		if(activoDao.publicarActivoConHistorico(idActivo, username, eleccionUsuarioTipoPublicacionAlquiler, true)) {
			Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			Filter filterAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			if (!Checks.esNulo(eleccionUsuarioTipoPublicacionAlquiler) && "0".equals(eleccionUsuarioTipoPublicacionAlquiler)){
				ActivoPublicacion activoPublicacion = genericDao.get(ActivoPublicacion.class, filterActivo, filterAuditoria);
				ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filterActivo, filterAuditoria);
				if (!Checks.esNulo(activoPatrimonio) && !Checks.esNulo(activoPublicacion)){
					
					if (Checks.esNulo(activoPatrimonio.getAdecuacionAlquiler())){
						enviarCorreoAdecuacion(activoPublicacion);
					} else if (DDAdecuacionAlquiler.CODIGO_ADA_NO.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo()) || DDAdecuacionAlquiler.CODIGO_ADA_NULO.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())){
						enviarCorreoAdecuacion(activoPublicacion);		
					}
				}
			}else if(Checks.esNulo(eleccionUsuarioTipoPublicacionAlquiler)){
				ActivoPublicacion activoPublicacion = genericDao.get(ActivoPublicacion.class, filterActivo, filterAuditoria);
				ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filterActivo, filterAuditoria);
				Double aprobadoVentaWeb = null;
				Double aprobadoRentaWeb = null;
				if (!Checks.esNulo(activoPatrimonio) && !Checks.esNulo(activoPublicacion)){
					List<VPreciosVigentes> listaPrecios = activoApi.getPreciosVigentesById(idActivo);
					for (VPreciosVigentes listaPrecio : listaPrecios) {
						if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA)) {
							aprobadoVentaWeb = listaPrecio.getImporte();
						} else if (listaPrecio.getCodigoTipoPrecio().equals(DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA)) {
							aprobadoRentaWeb = listaPrecio.getImporte();
						}
					}

			     	if(Checks.esNulo(aprobadoVentaWeb) && Checks.esNulo(aprobadoRentaWeb)) {
			     		if (this.isInformeAprobado(idActivo)){
			     			if (Checks.esNulo(activoPatrimonio.getAdecuacionAlquiler())){
								enviarCorreoAdecuacion(activoPublicacion);
							} else if (DDAdecuacionAlquiler.CODIGO_ADA_NO.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo()) || DDAdecuacionAlquiler.CODIGO_ADA_NULO.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())){
								enviarCorreoAdecuacion(activoPublicacion);		
							}
						}
			     	}
					
					
				}
			}
			
			logger.info(messageServices.getMessage("activo.publicacion.OK.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
			return true;
		} else {
			logger.error(messageServices.getMessage("activo.publicacion.error.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
			throw new JsonViewerException(messageServices.getMessage("activo.publicacion.error.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
		}
	}

	@Override
	public Integer getEstadoIndicadorPublicacionVenta(Activo activo) {
		Boolean checkPublicarSinPrecio = activoPublicacionDao.getCheckSinPrecioVentaPorIdActivo(activo.getId());

		if(isAdmisionOK(activo.getId())
				&& isGestionOK(activo.getId())
				&& this.isInformeAprobado(activo.getId())
				&& (this.tienePrecioVentaByIdActivo(activo.getId()) || (!Checks.esNulo(checkPublicarSinPrecio) && checkPublicarSinPrecio))
				){
			return ESTADO_PUBLICACION_AZUL;
		}else if(!isAdmisionOK(activo.getId())
				&& !isGestionOK(activo.getId())
				&& !this.isInformeAprobado(activo.getId())
				&& !(this.tienePrecioVentaByIdActivo(activo.getId()) || (!Checks.esNulo(checkPublicarSinPrecio) && checkPublicarSinPrecio))
				){
			return ESTADO_PUBLICACION_NARANJA;
		}else{
			return ESTADO_PUBLICACION_AMARILLO;
		}
	}

	@Override
	public Integer getEstadoIndicadorPublicacionAlquiler(Activo activo) {
		Boolean checkPublicarSinPrecio = activoPublicacionDao.getCheckSinPrecioAlquilerPorIdActivo(activo.getId());
		ActivoPatrimonio activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
		List<DtoAdmisionDocumento> listDtoAdmisionDocumento = activoAdapter.getListDocumentacionAdministrativaById(activo.getId());
		boolean conCee = false;
		boolean esVivienda = false;
		
		if (activo.getTipoActivo() != null) {
			esVivienda = DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo());
		}

		for(DtoAdmisionDocumento aListDtoAdmisionDocumento : listDtoAdmisionDocumento) {
			if (DDTipoDocumentoActivo.CODIGO_CEE_ACTIVO.equals(aListDtoAdmisionDocumento.getCodigoTipoDocumentoActivo())) {
				conCee = true;
			}
		}

		if(esVivienda){
			if(isAdmisionOK(activo.getId())
					&& isGestionOK(activo.getId())
					&& this.isInformeAprobado(activo.getId())
					&& (!Checks.esNulo(activoPatrimonio)
					&& !Checks.esNulo(activoPatrimonio.getAdecuacionAlquiler())
					&& (DDAdecuacionAlquiler.CODIGO_ADA_SI.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())
					|| DDAdecuacionAlquiler.CODIGO_ADA_NO_APLICA.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())))
					&& conCee
					&& (this.tienePrecioRentaByIdActivo(activo.getId()) || (!Checks.esNulo(checkPublicarSinPrecio) && checkPublicarSinPrecio))
					) {
				return ESTADO_PUBLICACION_AZUL;

			} else if(!isAdmisionOK(activo.getId())
					&& !isGestionOK(activo.getId())
					&& !this.isInformeAprobado(activo.getId())
					&& (!Checks.esNulo(activoPatrimonio)
					&& !Checks.esNulo(activoPatrimonio.getAdecuacionAlquiler())
					&& !(DDAdecuacionAlquiler.CODIGO_ADA_SI.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())
					|| DDAdecuacionAlquiler.CODIGO_ADA_NO_APLICA.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())))
					&& conCee
					&& !(this.tienePrecioRentaByIdActivo(activo.getId()) || (!Checks.esNulo(checkPublicarSinPrecio) && checkPublicarSinPrecio))
					) {
				return ESTADO_PUBLICACION_NARANJA;

			} else {
				return ESTADO_PUBLICACION_AMARILLO;
			}

		}else{
			if(isAdmisionOK(activo.getId())
					&& isGestionOK(activo.getId())
					&& this.isInformeAprobado(activo.getId())
					&& (!Checks.esNulo(activoPatrimonio)
					&& !Checks.esNulo(activoPatrimonio.getAdecuacionAlquiler())
					&& (DDAdecuacionAlquiler.CODIGO_ADA_SI.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())
					|| DDAdecuacionAlquiler.CODIGO_ADA_NO_APLICA.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())))
					&& (this.tienePrecioRentaByIdActivo(activo.getId()) || (!Checks.esNulo(checkPublicarSinPrecio) && checkPublicarSinPrecio))
					) {
				return ESTADO_PUBLICACION_AZUL;

			} else if(!isAdmisionOK(activo.getId())
					&& !isGestionOK(activo.getId())
					&& !this.isInformeAprobado(activo.getId())
					&& (!Checks.esNulo(activoPatrimonio)
					&& !Checks.esNulo(activoPatrimonio.getAdecuacionAlquiler())
					&& !(DDAdecuacionAlquiler.CODIGO_ADA_SI.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())
					|| DDAdecuacionAlquiler.CODIGO_ADA_NO_APLICA.equals(activoPatrimonio.getAdecuacionAlquiler().getCodigo())))
					&& !(this.tienePrecioRentaByIdActivo(activo.getId()) || (!Checks.esNulo(checkPublicarSinPrecio) && checkPublicarSinPrecio))
					) {
				return ESTADO_PUBLICACION_NARANJA;

			} else {
				return ESTADO_PUBLICACION_AMARILLO;
			}
		}
	}

	@Override
	public Integer getEstadoIndicadorPublicacionAgrupacionVenta(Activo activoPrincipal) {
		Integer estado = 0;
		int respuesta = getEstadoIndicadorPublicacionVenta(activoPrincipal);
		if (respuesta == 0) {
			estado = ESTADO_PUBLICACION_NARANJA;
		} else if (respuesta == 2) {
			estado = ESTADO_PUBLICACION_AMARILLO;
		} else if (respuesta == 1 && !ESTADO_PUBLICACION_AMARILLO.equals(estado)) {
			estado = ESTADO_PUBLICACION_AZUL;
		}

		return estado;
	}

	@Override
	public Integer getEstadoIndicadorPublicacionAgrupacionAlquiler(Activo activoPrincipal) {
		Integer estado = 0;

		int respuesta = getEstadoIndicadorPublicacionAlquiler(activoPrincipal);
		
		if (respuesta == 0) {
			estado = ESTADO_PUBLICACION_NARANJA;
		} else if (respuesta == 2) {
			estado = ESTADO_PUBLICACION_AMARILLO;
		} else if (respuesta == 1 && !ESTADO_PUBLICACION_AMARILLO.equals(estado)) {
			estado = ESTADO_PUBLICACION_AZUL;
		}

		return estado;
	}

	@Override
	public Boolean getCheckPublicacionDeshabilitarAgrupacionVenta(List<ActivoAgrupacionActivo> listaActivos) {
		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Long activoid = listaActivo.getActivo().getId();

			if (!Checks.esNulo(deshabilitarCheckPublicarVenta(activoid))) {
				return deshabilitarCheckPublicarVenta(activoid);
			}
		}

		return false;
	}

	@Override
	public Boolean getCheckOcultarDeshabilitarAgrupacionVenta(List<ActivoAgrupacionActivo> listaActivos) {
		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Long activoid = listaActivo.getActivo().getId();

			if (!Checks.esNulo(deshabilitarCheckOcultarVenta(activoid))) {
				return deshabilitarCheckOcultarVenta(activoid);
			}
		}

		return false;
	}

	@Override
	public Boolean getCheckPublicacionDeshabilitarAgrupacionAlquiler(List<ActivoAgrupacionActivo> listaActivos) {
		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Long activoid = listaActivo.getActivo().getId();

			if (!Checks.esNulo(deshabilitarCheckPublicarAlquiler(activoid))) {
				return deshabilitarCheckPublicarAlquiler(activoid);
			}
		}

		return false;
	}

	@Override
	public Boolean getCheckOcultarDeshabilitarAgrupacionAlquiler(List<ActivoAgrupacionActivo> listaActivos) {
		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Long activoid = listaActivo.getActivo().getId();

			if (!Checks.esNulo(deshabilitarCheckOcultarAlquiler(activoid))) {
				return deshabilitarCheckOcultarAlquiler(activoid);
			}
		}

		return false;
	}

	@Override
	public Boolean tienePrecioVentaByIdActivo(Long idActivo) {
		return this.tienePrecioVenta(idActivo);
	}

	@Override
	public Boolean tienePrecioRentaByIdActivo(Long idActivo) {
		return this.tienePrecioRenta(idActivo);
	}

	@Override
	@Transactional
	public Boolean actualizarEstadoPublicacionDelActivoOrAgrupacionRestringidaSiPertenece(List<Long> idsActivos,boolean doFlush) {
		List<Long> idsAgrupacionesRestringidas = new ArrayList<Long>();
		for(Long idActivo : idsActivos) {
			if(activoApi.get(idActivo) != null) {
				if(activoApi.isActivoIntegradoAgrupacionRestringida(idActivo)) {
					Long idAgrupacion = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(idActivo).getAgrupacion().getId();
					if(!idsAgrupacionesRestringidas.contains(idAgrupacion)) {
						idsAgrupacionesRestringidas.add(idAgrupacion);
					}
				}else {
					activoDao.publicarActivoConHistorico(idActivo, genericAdapter.getUsuarioLogado().getUsername(), null, doFlush);
				}
			}
		}
		for(Long idAgrupacion : idsAgrupacionesRestringidas) {
			activoDao.publicarAgrupacionConHistorico(idAgrupacion, genericAdapter.getUsuarioLogado().getUsername(), null, doFlush);
		}

		return true;
	}

	@Override
	public Date getFechaInicioEstadoActualPublicacionVenta(Long idActivo) {
		return activoPublicacionDao.getFechaInicioEstadoActualPublicacionVenta(idActivo);
	}
	
	@Override
	public Boolean enviarCorreoAdecuacion(ActivoPublicacion activoPublicacion) {
		boolean resultado = false;

		Activo activo = activoPublicacion.getActivo();

		try {
			ArrayList<String> mailsPara = new ArrayList<String>();
			mailsPara.add(usuarioManager.getByUsername("vhernandezi").getEmail());
			String asunto = "Adecuación del activo "+ activo.getNumActivo() +" por publicación en www.haya.es";
			String cuerpo = "<p>Se ha pre-publicado en alquiler el activo "
			+ activo.getNumActivo() +" que NO está adecuado, por favor revíselo y actualice el dato correspondiente para que se pueda publicar el activo en la web</p> Muchas gracias y un saludo";

			genericAdapter.sendMail(mailsPara, new ArrayList<String>(),asunto,cuerpo);
			resultado = true;
		} catch (Exception e) {
			logger.error("No se ha podido notificar la adecuación del activo.", e);
		}
		return resultado;
	}
	
	@Override
	@Transactional
	public Boolean actualizarPublicacionActivoCambioTipoComercializacion(Activo activo, String tcoNuevo) {
		try {
			ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(activo.getId());
			ActivoPublicacionHistorico activoPublicacionHistorico = null;
			ActivoPublicacionHistorico activoPublicacionHistoricoActual = null;
			String tcoAnterior = activoPublicacion.getTipoComercializacion().getCodigo();
			DDTipoComercializacion tipoComercializacion = (DDTipoComercializacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class,  tcoNuevo);
			activoPublicacion.setTipoComercializacion(tipoComercializacion);
			activo.setTipoComercializacion(tipoComercializacion);
			
			if (DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(tcoAnterior)) {				
				if (DDTipoComercializacion.CODIGO_VENTA.equals(tcoNuevo)) {
					activoPublicacionHistorico = activoPublicacionHistoricoDao.getActivoPublicacionHistoricoActualAlquiler(activo.getId());
					activoPublicacionHistorico.setFechaFinAlquiler(new Date(System.currentTimeMillis() + 3600 * 1000));
				} else if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tcoNuevo)) {
					activoPublicacionHistorico = activoPublicacionHistoricoDao.getActivoPublicacionHistoricoActualVenta(activo.getId());
					activoPublicacionHistorico.setFechaFinVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
				}
			} else if (DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(tcoNuevo)) {
				activoPublicacionHistoricoActual = new ActivoPublicacionHistorico();
				BeanUtils.copyProperties(activoPublicacionHistoricoActual, activoPublicacion);
				
				if (DDTipoComercializacion.CODIGO_VENTA.equals(tcoAnterior)) {
					activoPublicacion.setFechaInicioAlquiler(new Date(System.currentTimeMillis() + 3600 * 1000));
					activoPublicacionHistoricoActual.setFechaInicioAlquiler(new Date(System.currentTimeMillis() + 3600 * 1000));
					activoPublicacionHistoricoActual.setFechaInicioVenta(null);
				} else if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tcoAnterior)) {
					activoPublicacion.setFechaInicioVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
					activoPublicacionHistoricoActual.setFechaInicioVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
					activoPublicacionHistoricoActual.setFechaInicioAlquiler(null);
				}
			} else {
				if (DDTipoComercializacion.CODIGO_VENTA.equals(tcoAnterior) && DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tcoNuevo)){
					activoPublicacionHistorico = activoPublicacionHistoricoDao.getActivoPublicacionHistoricoActualVenta(activo.getId());
					activoPublicacionHistorico.setFechaFinVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
					activoPublicacion.setFechaInicioVenta(null);
					activoPublicacion.setFechaInicioAlquiler(new Date(System.currentTimeMillis() + 3600 * 1000));
				} else if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tcoAnterior) && DDTipoComercializacion.CODIGO_VENTA.equals(tcoNuevo)){
					activoPublicacionHistorico = activoPublicacionHistoricoDao.getActivoPublicacionHistoricoActualAlquiler(activo.getId());
					activoPublicacionHistorico.setFechaFinAlquiler(new Date(System.currentTimeMillis() + 3600 * 1000));
					activoPublicacion.setFechaInicioAlquiler(null);
					activoPublicacion.setFechaInicioVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
				}
				activoPublicacionHistoricoActual = new ActivoPublicacionHistorico();
				BeanUtils.copyProperties(activoPublicacionHistoricoActual, activoPublicacion);	
			}
			
			if (activoPublicacionHistorico != null) {
				activoPublicacionHistoricoDao.saveOrUpdate(activoPublicacionHistorico);
			}
			
			if (activoPublicacionHistoricoActual != null) {
				activoPublicacionHistoricoActual.setAuditoria(null);
				activoPublicacionHistoricoDao.save(activoPublicacionHistoricoActual);
			}
		} catch (Exception e) {
			logger.error("Error al actualizar el estado de publicación del activo tras modificar el destino comercial, error: ", e);
			return false;
		}
		
		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean saveFasePublicacionActivo(DtoFasePublicacionActivo dto){
		HistoricoFasePublicacionActivo fasePublicacionActivoVigente = activoPublicacionDao.getFasePublicacionVigentePorIdActivo(dto.getIdActivo());
		DDFasePublicacion fasePublicacion = new DDFasePublicacion();
		List<Long> activosPropagados = new ArrayList<Long>();

	
		if (!Checks.esNulo(dto.getFasePublicacionCodigo()) || !Checks.esNulo(dto.getSubfasePublicacionCodigo())) {
			ActivoTransicionesFasesPublicacion transicion = null;
			
			if (!Checks.esNulo(fasePublicacionActivoVigente)) {
				DDSubfasePublicacion subFaseActual = fasePublicacionActivoVigente.getSubFasePublicacion();
				if (!Checks.esNulo(subFaseActual)) {
					Filter filtroOrigenCod = genericDao.createFilter(FilterType.EQUALS, "origen.codigo", subFaseActual.getCodigo());
					Filter filtroDestinoCod = null;
					if (!Checks.esNulo(dto.getSubfasePublicacionCodigo()) && !"null".equals(dto.getSubfasePublicacionCodigo())) {
						filtroDestinoCod = genericDao.createFilter(FilterType.EQUALS, "destino.codigo", dto.getSubfasePublicacionCodigo());
					} else {
						filtroDestinoCod = genericDao.createFilter(FilterType.NULL, "destino");
					}
					
					transicion = genericDao.get(ActivoTransicionesFasesPublicacion.class, filtroOrigenCod, filtroDestinoCod);
				} else {
					Filter filtroOrigenCod = genericDao.createFilter(FilterType.NULL, "origen");
					Filter filtroDestinoCod = genericDao.createFilter(FilterType.EQUALS, "destino.codigo", dto.getSubfasePublicacionCodigo());
					transicion = genericDao.get(ActivoTransicionesFasesPublicacion.class, filtroOrigenCod, filtroDestinoCod); 
				}
			} else {
				throw new JsonViewerException("El activo no tiene una fase inicial vigente");
			}
			
			//La transicion que intenta hacer existe en la tabla de transiciones
			if (!Checks.esNulo(transicion)) {
				fasePublicacionActivoVigente.setFechaFin(new Date());
				genericDao.save(HistoricoFasePublicacionActivo.class, fasePublicacionActivoVigente);
				
				//Si solo se cambia la subfase manteniendo la misma fase
				Filter filtroFase = genericDao.createFilter(FilterType.EQUALS, "codigo", fasePublicacionActivoVigente.getFasePublicacion().getCodigo());
				fasePublicacion = genericDao.get(DDFasePublicacion.class, filtroFase);
				
				//Si se cambia la fase
				if (!Checks.esNulo(dto.getFasePublicacionCodigo())) {
					Filter filtroFaseNueva = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getFasePublicacionCodigo());
					fasePublicacion = genericDao.get(DDFasePublicacion.class, filtroFaseNueva);
				}
				
				HistoricoFasePublicacionActivo nuevaFasePublicacionActivo = new HistoricoFasePublicacionActivo();
				Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
				Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdActivo());
				Activo activo = genericDao.get(Activo.class, filtroActivo);
				
				nuevaFasePublicacionActivo.setActivo(activo);
				nuevaFasePublicacionActivo.setFechaInicio(new Date());
				nuevaFasePublicacionActivo.setUsuario(usu);
				nuevaFasePublicacionActivo.setFasePublicacion(fasePublicacion);
				
				if (!Checks.esNulo(dto.getSubfasePublicacionCodigo())) {
					Filter filtroSubfaseNueva = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getSubfasePublicacionCodigo());
					DDSubfasePublicacion subfasePublicacionNueva = genericDao.get(DDSubfasePublicacion.class, filtroSubfaseNueva);
					nuevaFasePublicacionActivo.setSubFasePublicacion(subfasePublicacionNueva);		
				}
				
				if (!Checks.esNulo(dto.getComentario())) {
					nuevaFasePublicacionActivo.setComentario(dto.getComentario());
				}
				
				genericDao.save(HistoricoFasePublicacionActivo.class, nuevaFasePublicacionActivo);
				
				
				recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(activo, null, null, false);
				
				if(activoApi.isActivoPrincipalAgrupacionRestringida(dto.getIdActivo())){
					ActivoAgrupacionActivo actAgr = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId());
					if(actAgr != null && actAgr.getAgrupacion() != null) {
						List<ActivoAgrupacionActivo> activoAgrList = activoAgrupacionActivoDao.getListActivoAgrupacionActivoByAgrupacionID(actAgr.getAgrupacion().getId());
						List<Activo> activos = new ArrayList<Activo>();
						for (ActivoAgrupacionActivo activoAgr : activoAgrList) {
							if (activoAgr.getActivo() != activo) {
								activos.add(activoAgr.getActivo());
							}
						}
						
						String numAgr = actAgr.getAgrupacion().getNumAgrupRem().toString();
						dto.setNumAgrupacionRestringida(numAgr);
						activosPropagados = propagarFasesPublicacionYRecalcularPerimetroVisibilidad(nuevaFasePublicacionActivo, activos, numAgr);
					}
				}
				
				enviarCorreoFasePublicacion(dto, activosPropagados);
			} else {
				throw new JsonViewerException("Esta transición no está permitida");
			}
			
		//No hace falta comprobar si es nula la fasePublicacionActivoVigente
		//ya que es imposible realizar save sin rellenar el campo fase (restrinccion en front, allowBlank = false)
		} else if (!Checks.esNulo(dto.getComentario())) {
			fasePublicacionActivoVigente.setComentario(dto.getComentario());
			genericDao.save(HistoricoFasePublicacionActivo.class, fasePublicacionActivoVigente);
		}
		
		return true;
	}

	private void enviarCorreoFasePublicacion(DtoFasePublicacionActivo dto, List<Long> activosPropagados) {
		String fasePublicacionCod = dto.getFasePublicacionCodigo();
		String subFasePublicacionCod = dto.getSubfasePublicacionCodigo();
		Activo activo = activoApi.get(dto.getIdActivo());
		String asunto = "El activo ha entrado en la siguiente fase de publicación";
		String cuerpo = "";
		ArrayList<String> mailsPara = new ArrayList<String>();
		ArrayList<String> mailsCC = new ArrayList<String>();
		
		if( !Checks.esNulo(activo)) {
			if(DDFasePublicacion.CODIGO_FASE_0_CALIDAD_PENDIENTE.equals(fasePublicacionCod) && DDSubfasePublicacion.CODIGO_CALIDAD_PENDIENTE.equals(subFasePublicacionCod)) {
				cuerpo = String.format("El activo "+activo.getNumActivo()+" ha entrado en la siguiente fase de publicación: Fase 0: Calidad pendiente.");
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_PUBLICACION, mailsPara, mailsCC, false);
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL, mailsPara, mailsCC, false);
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_ACTIVO, mailsPara, mailsCC, false);
				
			} else if(DDFasePublicacion.CODIGO_FASE_III_PENDIENTE_INFORMACION.equals(fasePublicacionCod) && DDSubfasePublicacion.CODIGO_PENDIENTE_DE_INFORMACION.equals(subFasePublicacionCod) ) {
				cuerpo = String.format("El activo "+activo.getNumActivo()+" ha entrado en la siguiente fase de publicación: Fase III: Pendiente de información.");
				if (activo.getInfoComercial() != null && activo.getInfoComercial().getMediadorInforme() != null) {
					mailsPara.add(activo.getInfoComercial().getMediadorInforme().getEmail());
				}
			}
			if(!Checks.estaVacio(mailsPara) || !Checks.estaVacio(mailsCC)) {
				cuerpo = cuerpo + crearCuerpoCorreoPropagarFase(activosPropagados, dto.getNumAgrupacionRestringida());
				notificationActivoManager.sendMailFasePublicacion(activo, asunto,cuerpo,mailsPara,mailsCC);
			}			
		}
			
	}
	
	private void enviarCorreoAlPublicarActivo(DtoDatosPublicacionActivo dto) {
		
		Activo activo = activoApi.get(dto.getIdActivo());
		String asunto = "Notificación de activo publicado";
		String cuerpo = "";
		ArrayList<String> mailsPara = new ArrayList<String>();
		ArrayList<String> mailsCC = new ArrayList<String>();
		if(!Checks.esNulo(activo)) {
			if((!Checks.esNulo(dto.getPublicarAlquiler()) && dto.getPublicarAlquiler()) || 
					(!Checks.esNulo( dto.getPublicarVenta()) && dto.getPublicarVenta())) {
				cuerpo = String.format("El activo "+activo.getNumActivo()+" ha sido publicado.");
				
				usuarioRemApiImpl.rellenaListaCorreos(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL, mailsPara, mailsCC, false);
				if(!Checks.esNulo(activo.getInfoComercial()) 
						&& !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
					mailsPara.add(activo.getInfoComercial().getMediadorInforme().getEmail());
				}
				
				notificationActivoManager.sendMailFasePublicacion(activo, asunto,cuerpo,mailsPara,mailsCC);
			}
		}
	}
	
	@Override
	public DtoFasePublicacionActivo getFasePublicacionActivo(Long idActivo) {
		DtoFasePublicacionActivo dto = new DtoFasePublicacionActivo();
		HistoricoFasePublicacionActivo fasePublicacionActivoVigente = activoPublicacionDao.getFasePublicacionVigentePorIdActivo(idActivo);
		Activo activo = activoDao.getActivoById(idActivo);
		if (Checks.esNulo(fasePublicacionActivoVigente)) {
			return dto;
		}
		
		dto.setIdActivo(fasePublicacionActivoVigente.getActivo().getId());
		dto.setFasePublicacionCodigo(fasePublicacionActivoVigente.getFasePublicacion().getCodigo());
		DDSubfasePublicacion subfasePublicacion = fasePublicacionActivoVigente.getSubFasePublicacion();
		if (!Checks.esNulo(subfasePublicacion)) {
			dto.setSubfasePublicacionCodigo(subfasePublicacion.getCodigo());
		}
		if (!Checks.esNulo(fasePublicacionActivoVigente.getComentario())) {
			dto.setComentario(fasePublicacionActivoVigente.getComentario());
		}
//	HREOS-13592 Se bloquea el evolutivo de ocultación de activos para la subida 		
//		if(!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {	
//			dto.setCamposPropagablesUas(TabActivoService.TAB_FASE_PUBLICACION);
//		}else {
//			// Buscamos los campos que pueden ser propagados para esta pestaña
//			dto.setCamposPropagables(TabActivoService.TAB_FASE_PUBLICACION);
//		}
		
		return dto;
	}
	
	@Override
	public List<DtoHistoricoFasesDePublicacion> getHistoricoFasesDePublicacionActivo(Long idActivo) {
		List<DtoHistoricoFasesDePublicacion> listaDtoHistoricoFasesDePublicacion = new ArrayList<DtoHistoricoFasesDePublicacion>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Order order = new Order(OrderType.DESC, "id");
		List<HistoricoFasePublicacionActivo> listaHistoricoFasePublicacionActivo = genericDao.getListOrdered(HistoricoFasePublicacionActivo.class, order, filtro);
		
		for (HistoricoFasePublicacionActivo historicoFasePublicacionActivo : listaHistoricoFasePublicacionActivo) {
			DtoHistoricoFasesDePublicacion dtoHistoricoFasesDePublicacion = new DtoHistoricoFasesDePublicacion();
			try {
				beanUtilNotNull.copyProperty(dtoHistoricoFasesDePublicacion, "id", historicoFasePublicacionActivo.getId());
				beanUtilNotNull.copyProperty(dtoHistoricoFasesDePublicacion, "fasePublicacion", historicoFasePublicacionActivo.getFasePublicacion().getDescripcion());
				if (!Checks.esNulo(historicoFasePublicacionActivo.getSubFasePublicacion())) {
					beanUtilNotNull.copyProperty(dtoHistoricoFasesDePublicacion, "subfasePublicacion", historicoFasePublicacionActivo.getSubFasePublicacion().getDescripcion());
				}
				if (!Checks.esNulo(historicoFasePublicacionActivo.getUsuario())) {
					beanUtilNotNull.copyProperty(dtoHistoricoFasesDePublicacion, "usuario", historicoFasePublicacionActivo.getUsuario().getUsername());
				}
				beanUtilNotNull.copyProperty(dtoHistoricoFasesDePublicacion, "fechaInicio", historicoFasePublicacionActivo.getFechaInicio());
				beanUtilNotNull.copyProperty(dtoHistoricoFasesDePublicacion, "fechaFin", historicoFasePublicacionActivo.getFechaFin());
				beanUtilNotNull.copyProperty(dtoHistoricoFasesDePublicacion, "comentario", historicoFasePublicacionActivo.getComentario());
				
				listaDtoHistoricoFasesDePublicacion.add(dtoHistoricoFasesDePublicacion);
			} catch (Exception e) {
				logger.error("Error en activoManager, getHistoricoFasesDePublicacionActivo()", e);
			}
		}
		return listaDtoHistoricoFasesDePublicacion;
	}

	@Override
	public DtoCalidadDatoPublicacionActivo getCalidadDatoPublicacionActivo(Long idActivo) {
		DtoCalidadDatoPublicacionActivo dto = new DtoCalidadDatoPublicacionActivo();
		Activo activo = activoDao.get(idActivo);
		ActivoDatosDq actDatosDq = activoPublicacionDao.getActivoDatosDqPorIdActivo(idActivo);
		dto.setDesplegable0Collapsed(true);
		dto.setDesplegable1Collapsed(true);
		dto.setDesplegable2Collapsed(true);

		HistoricoFasePublicacionActivo fasePublicacion =  activoPublicacionDao.getFasePublicacionVigentePorIdActivo(idActivo);
		if(fasePublicacion != null && fasePublicacion.getFasePublicacion() != null) {
			if(DDFasePublicacion.CODIGO_FASE_0_CALIDAD_PENDIENTE.equals(fasePublicacion.getFasePublicacion().getCodigo())
				|| DDFasePublicacion.CODIGO_FASE_I_PENDIENTE_ACTUACIONES_PREVIAS.equals(fasePublicacion.getFasePublicacion().getCodigo())
				|| DDFasePublicacion.CODIGO_FASE_II_PENDIENTE_LLAVES.equals(fasePublicacion.getFasePublicacion().getCodigo())){
				dto.setDesplegable0Collapsed(false);

								
			}else if(DDFasePublicacion.CODIGO_FASE_III_PENDIENTE_INFORMACION.equals(fasePublicacion.getFasePublicacion().getCodigo())) {
				dto.setDesplegable1Collapsed(false);
													
			}else if(DDFasePublicacion.CODIGO_FASE_IV_PENDIENTE_PRECIO.equals(fasePublicacion.getFasePublicacion().getCodigo())
					|| DDFasePublicacion.CODIGO_FASE_V_INCIDENCIAS_PUBLICACION.equals(fasePublicacion.getFasePublicacion().getCodigo())
					|| DDFasePublicacion.CODIGO_FASE_VI_CALIDAD_COMPROBADA.equals(fasePublicacion.getFasePublicacion().getCodigo())) {
				dto.setDesplegable2Collapsed(false);

			}
		}
		if(actDatosDq != null) {
			 setDataFase0a2(actDatosDq, activo, dto);
			 setDataFase3(dto, activo, actDatosDq);
			 setDataFase4(actDatosDq, activo, dto);
		}else {
			getDatosActivoSinDQ(dto,activo);
		}
		
		return dto;
	}
	
	private DtoCalidadDatoPublicacionActivo setDataFase0a2(ActivoDatosDq actDatosDq, Activo activo, DtoCalidadDatoPublicacionActivo dto) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoPropietarioActivo activoPropietario  = genericDao.get(ActivoPropietarioActivo.class, filter);
		
		if(actDatosDq.getIdufirDdq()!=null) {
			dto.setDqIdufirFase1(actDatosDq.getIdufirDdq());
		}
		
		if(actDatosDq.getFolioDdq()!=null) {
			dto.setDqFolioFase1(actDatosDq.getFolioDdq());
		}
		
		if(activo.getInfoRegistral()!=null && activo.getInfoRegistral().getInfoRegistralBien() != null){
			if (activo.getInfoRegistral().getIdufir() != null) {
				dto.setDrIdufirFase1(activo.getInfoRegistral().getIdufir());
			}
			if (activo.getInfoRegistral().getInfoRegistralBien().getNumFinca() != null) {
				dto.setDrFincaRegistralFase1(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
			}	
			if (activo.getInfoRegistral().getInfoRegistralBien().getLibro() != null) {
				dto.setDrLibroFase1(activo.getInfoRegistral().getInfoRegistralBien().getLibro());
			}
			if (activo.getInfoRegistral().getInfoRegistralBien().getTomo() != null) {
				dto.setDrTomoFase1(activo.getInfoRegistral().getInfoRegistralBien().getTomo());
			}
			if (activo.getInfoRegistral().getInfoRegistralBien().getFolio() != null) {
				dto.setDrFolioFase1(activo.getInfoRegistral().getInfoRegistralBien().getFolio());
			}			
			if(activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion()!=null) {
				dto.setDrInscripcionCorrectaFase1(INSCRITO);
			}else {
				dto.setDrInscripcionCorrectaFase1(NO_INSCRITO);
			}
			
		}
		
		if(actDatosDq.getNumFincaDdq()!=null) {
			dto.setDqFincaRegistralFase1(actDatosDq.getNumFincaDdq());
		}
		
		if(actDatosDq.getTomoDdq()!=null) {
			dto.setDqTomoFase1(actDatosDq.getTomoDdq());
		}
	
		if(actDatosDq.getLibroDdq()!=null){
			dto.setDqLibroFase1(actDatosDq.getLibroDdq());
		}
		
		if(actDatosDq.getFolioDdq()!=null) {
			dto.setDqFolioFase1(actDatosDq.getFolioDdq());
		}
		
		if(actDatosDq.getTipoUsoDestino() != null && actDatosDq.getTipoUsoDestino().getDescripcion() != null) {
			dto.setDqUsoDominanteFase1(actDatosDq.getTipoUsoDestino().getDescripcion());
		}
		if(activo.getTipoUsoDestino() !=null && activo.getTipoUsoDestino().getDescripcion() != null) {
			dto.setDrUsoDominanteFase1(activo.getTipoUsoDestino().getDescripcion());
		}

		if(activo.getInfoRegistral() != null 
				&& activo.getInfoRegistral().getInfoRegistralBien() != null) {
			if (activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro() != null) {
				dto.setDrNumeroDelRegistroFase1(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro());
			}
			
			
			if(activo.getInfoRegistral().getInfoRegistralBien().getProvincia() != null
					&& activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getDescripcion() != null) {
				dto.setDrProvinciaDelRegistroFase1(activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getDescripcion());
			}
		}
		//numero de registro
		if(actDatosDq.getNumRegistroDdq()!=null) {
			dto.setDqNumeroDelRegistroFase1(actDatosDq.getNumRegistroDdq());
		}
		
		//Municipio del registro
		if(actDatosDq.getLocalidadReg()!=null && actDatosDq.getLocalidadReg().getDescripcion() != null) {
			dto.setDqMunicipioDelRegistroFase1(actDatosDq.getLocalidadReg().getDescripcion());
		}
		if(activo.getLocalidad() !=null && activo.getLocalidad().getDescripcion() != null) {
			dto.setDrMunicipioDelRegistroFase1(activo.getLocalidad().getDescripcion());
		}
		
		//Provincia del registro
		if(actDatosDq.getProvinciaReg() !=null && actDatosDq.getProvinciaReg().getDescripcion() != null) {
			dto.setDqProvinciaDelRegistroFase1(actDatosDq.getProvinciaReg().getDescripcion());
		}
				
		if(actDatosDq.getVpo()!=null) {
			if(actDatosDq.getVpo().booleanValue()) {
				dto.setDqVpoFase1(SI);
				
			}else {
				dto.setDqVpoFase1(NO);
			}
		}
		if(activo.getVpo()!=null) {
			if(activo.getVpo().equals(1)) {
				dto.setDrVpoFase1(SI);
			}else if(activo.getVpo().equals(0)) {
				dto.setDrVpoFase1(NO);
			}
		}
		
		if(actDatosDq.getAnyoConstruccion()!=null) {
			dto.setDqAnyoConstruccionFase1(actDatosDq.getAnyoConstruccion().toString());
		}	
		
		if(activo.getInfoComercial() !=null && activo.getInfoComercial().getAnyoConstruccion() != null) {
			dto.setDrAnyoConstruccionFase1(activo.getInfoComercial().getAnyoConstruccion().toString());
		}
		if(actDatosDq.getDescripcionCargas()!=null) {
			dto.setDescripcionCargasInformacionCargasFase1(actDatosDq.getDescripcionCargas());
		}
		//Tipologia
		if(activo.getTipoActivo() !=null && activo.getTipoActivo().getDescripcion() != null) {
			dto.setDrTipologianFase1(activo.getTipoActivo().getDescripcion());
		}
		if(actDatosDq.getTipoActivo() !=null && actDatosDq.getTipoActivo().getDescripcion() != null) {
			dto.setDqTipologiaFase1(actDatosDq.getTipoActivo().getDescripcion());
		}
		//Subtipologia
		if(activo.getSubtipoActivo() !=null && activo.getSubtipoActivo().getDescripcion() != null) {
			dto.setDrSubtipologianFase1(activo.getSubtipoActivo().getDescripcion());
		}
		if(actDatosDq.getSubtipoActivo() !=null && actDatosDq.getSubtipoActivo().getDescripcion() != null) {
			dto.setDqSubtipologiaFase1(actDatosDq.getSubtipoActivo().getDescripcion());
			
		}
		//Informacion Cargas
		if(actDatosDq.getCargas()!=null) {
			if(actDatosDq.getCargas().booleanValue()==true) {
				dto.setDqInformacionCargasFase1(SI);				
			}else {
				dto.setDqInformacionCargasFase1(NO);
			}
		}
		if(activo.getConCargas()!=null) {
			if(activo.getConCargas().equals(1)) {
				dto.setDrInformacionCargasFase1(SI);
			}else if(activo.getConCargas().equals(0)) {
				dto.setDrInformacionCargasFase1(NO);
			}
			
			
		}
		//Inscripcion Correcta
		if(actDatosDq.getInscripcion()!=null) {
				if(actDatosDq.getInscripcion().booleanValue()==true) {
					dto.setDqInscripcionCorrectaFase1(INSCRITO);
				}else {
					dto.setDqInscripcionCorrectaFase1(NO_INSCRITO);
				}
		}
		
		
		//Propiedad
		if(actDatosDq.getPropiedadDdq()!=null) {
			dto.setDqPor100PropiedadFase1(actDatosDq.getPropiedadDdq().toString());
		}
		
		if(activoPropietario!=null) {
			if(activoPropietario.getPorcPropiedad()!=null) {
				dto.setDrPor100PropiedadFase1(activoPropietario.getPorcPropiedad().toString());
			}
		}
		
		//Comprobaciones Correcto
		boolean interrogante=false;
		boolean ko = false;
		int countKo = 0;
		int countInterrogante =0;
		//IDUFIR
		if(dto.getDqIdufirFase1()==null) {
			dto.setCorrectoIdufirFase1(ICONO_TICK_OK);			
		}else {
			dto.setCorrectoIdufirFase1(ICONO_TICK_KO);
			countKo++;
			ko=true;
		}
		//FINCA REGISTRAL
		if(dto.getDqFincaRegistralFase1()==null) {
			dto.setCorrectoFincaRegistralFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante=true;
		}else if(dto.getDrFincaRegistralFase1()!=null
				&& (dto.getDrFincaRegistralFase1().equals(dto.getDqFincaRegistralFase1()))) {
			dto.setCorrectoFincaRegistralFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoFincaRegistralFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		
		if (dto.getDqFincaRegistralFase1() == null && dto.getDrFincaRegistralFase1() == null) {
			ko=false;
			interrogante=false;
			//El count interrogante es porque esta añadiendo 1 al ser dq null, por eso le quitamos en caso de que los 2 campos dr y dq sean nuls.
			countInterrogante--;
		}
		//TOMO
		if(dto.getDqTomoFase1()==null) {
			dto.setCorrectoTomoFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante=true;
		}else if(dto.getDrFincaRegistralFase1()!=null
				&& (dto.getDrTomoFase1().equals(dto.getDqTomoFase1()))) {
			dto.setCorrectoTomoFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoTomoFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		if (dto.getDqTomoFase1() == null && dto.getDrTomoFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//LIBRO
		if(dto.getDqLibroFase1()==null) {
			dto.setCorrectoLibroFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante = true;
		}else if(dto.getDrLibroFase1()!=null
				&& (dto.getDrLibroFase1().equals(dto.getDqLibroFase1()))) {
			dto.setCorrectoLibroFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoLibroFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;

		}
		
		if (dto.getDqLibroFase1() == null && dto.getDrLibroFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//FOLIO
		if(dto.getDqFolioFase1()==null) {
			dto.setCorrectoFolioFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante= true;
		}else if(dto.getDrFolioFase1()!=null
				&& (dto.getDrFolioFase1().equals(dto.getDqFolioFase1()))) {
			dto.setCorrectoFolioFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoFolioFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		
		if (dto.getDqFolioFase1() == null && dto.getDrFolioFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//USO DOMINANTE
		if(dto.getDqUsoDominanteFase1()==null) {
			dto.setCorrectoUsoDominanteFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante=true;
		}else if(dto.getDrUsoDominanteFase1()!=null
				&& (dto.getDrUsoDominanteFase1().equals(dto.getDqUsoDominanteFase1()))) {
			dto.setCorrectoUsoDominanteFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoUsoDominanteFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		
		if (dto.getDqUsoDominanteFase1() == null && dto.getDrUsoDominanteFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//MUNICIPIO DEL REGISTRO
		if(dto.getDqMunicipioDelRegistroFase1()==null) {
			dto.setCorrectoUsoDominanteFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante = true;
		}else if(dto.getDrMunicipioDelRegistroFase1()!=null
				&& (dto.getDrMunicipioDelRegistroFase1().equals(dto.getDqMunicipioDelRegistroFase1()))) {
			dto.setCorrectoMunicipioDelRegistroFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoMunicipioDelRegistroFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		
		if (dto.getDqMunicipioDelRegistroFase1() == null && dto.getDrMunicipioDelRegistroFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//PROVINCIA DEL REGISTRO
		if(dto.getDqProvinciaDelRegistroFase1()==null) {
			dto.setCorrectoProvinciaDelRegistroFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante=true;
		}else if(dto.getDrProvinciaDelRegistroFase1()!=null
				&& (dto.getDrProvinciaDelRegistroFase1().equals(dto.getDqProvinciaDelRegistroFase1()))) {
			dto.setCorrectoProvinciaDelRegistroFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoProvinciaDelRegistroFase1(ICONO_TICK_KO);
			ko = true;
			countKo++;
		}
		
		if (dto.getDqProvinciaDelRegistroFase1() == null && dto.getDrProvinciaDelRegistroFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//NUMERO DE REGISTRO
		if(dto.getDqNumeroDelRegistroFase1()==null) {
			dto.setCorrectoNumeroDelRegistroFase1(ICONO_TICK_INTERROGANTE);
			interrogante= true;
			countInterrogante++;
		}else if(dto.getDrNumeroDelRegistroFase1()!=null 
				&& (dto.getDrNumeroDelRegistroFase1().equals(dto.getDqNumeroDelRegistroFase1()))) {
			dto.setCorrectoNumeroDelRegistroFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoNumeroDelRegistroFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		
		if (dto.getDqNumeroDelRegistroFase1() == null && dto.getDrNumeroDelRegistroFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//VPO
		if(dto.getDqVpoFase1()==null) {
			interrogante= true;
			dto.setCorrectoVpoFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
		}else if(dto.getDrVpoFase1()!=null 
				&& (dto.getDrVpoFase1().equals(dto.getDqVpoFase1()))) {
			dto.setCorrectoVpoFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoVpoFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		
		if (dto.getDqVpoFase1() == null && dto.getDrVpoFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//ANYO CONSTRUCCION
		
		if(dto.getDqAnyoConstruccionFase1()==null) {
			countInterrogante++;
			interrogante=true;
			dto.setCorrectoAnyoConstruccionFase1(ICONO_TICK_INTERROGANTE);
		}else if(dto.getDrAnyoConstruccionFase1()!=null && 
				(dto.getDrAnyoConstruccionFase1().equals(dto.getDqAnyoConstruccionFase1()))) {
			dto.setCorrectoAnyoConstruccionFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoAnyoConstruccionFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		if (dto.getDqAnyoConstruccionFase1() == null && dto.getDrAnyoConstruccionFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//TIPOLOGIA
		
		if(dto.getDqTipologiaFase1()==null) {
			interrogante=true;
			countInterrogante++;
			dto.setCorrectoTipologiaFase1(ICONO_TICK_INTERROGANTE);
		}else if(dto.getDrTipologianFase1()!=null 
				&& (dto.getDrTipologianFase1().equals(dto.getDqTipologiaFase1()))) {
			dto.setCorrectoTipologiaFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoTipologiaFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		if (dto.getDqTipologiaFase1() == null && dto.getDrTipologianFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
				
		//SUBTIPOLOGIA
		if(dto.getDqSubtipologiaFase1()==null) {
			dto.setCorrectoSubtipologiaFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante=true;
		}else if(dto.getDrSubtipologianFase1()!=null 
				&& (dto.getDrSubtipologianFase1().equals(dto.getDqSubtipologiaFase1()))) {
			dto.setCorrectoSubtipologiaFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoSubtipologiaFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		if (dto.getDqSubtipologiaFase1() == null && dto.getDrSubtipologianFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}		
		//INFORMACION CARGAS
		if(dto.getDqInformacionCargasFase1()==null) {
			dto.setCorrectoInformacionCargasFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante=true;
		}else if(dto.getDrInformacionCargasFase1()!=null && (dto.getDrInformacionCargasFase1().equals(dto.getDqInformacionCargasFase1()))) {
			dto.setCorrectoInformacionCargasFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoInformacionCargasFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		if (dto.getDqInformacionCargasFase1() == null && dto.getDrInformacionCargasFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}		
		//INSCRIPCION CORRECTA
		if(dto.getDqInscripcionCorrectaFase1()==null) {
			dto.setCorrectoInscripcionCorrectaFase1(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante=true;
		}else if(dto.getDrInscripcionCorrectaFase1()!=null &&
				(dto.getDrInscripcionCorrectaFase1().equals(dto.getDqInscripcionCorrectaFase1()))) {
			dto.setCorrectoInscripcionCorrectaFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoInscripcionCorrectaFase1(ICONO_TICK_KO);
			ko=true;
			countKo++;
		}
		if (dto.getDqInscripcionCorrectaFase1() == null && dto.getDrInscripcionCorrectaFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		//% PROPIEDAD
		
		if(dto.getDqPor100PropiedadFase1()==null) {
			dto.setCorrectoPor100PropiedadFase1(ICONO_TICK_INTERROGANTE);
			interrogante=true;
			countInterrogante++;

		}else if(dto.getDrPor100PropiedadFase1()!=null && 
				(dto.getDrPor100PropiedadFase1().equals(dto.getDqPor100PropiedadFase1()))) {
			dto.setCorrectoPor100PropiedadFase1(ICONO_TICK_OK);
		}else {
			dto.setCorrectoPor100PropiedadFase1(ICONO_TICK_KO);
			ko =true;
			countKo++;
		}
		
		if (dto.getDqPor100PropiedadFase1() == null && dto.getDrPor100PropiedadFase1() == null) {
			ko=false;
			interrogante=false;
			countInterrogante--;
		}
		if(ko || countKo > 0 ) {
			dto.setCorrectoDatosRegistralesFase1(ICONO_TICK_KO);
		}else if(interrogante || countInterrogante > 0) {
			dto.setCorrectoDatosRegistralesFase1(ICONO_TICK_INTERROGANTE);
		}else {
			dto.setCorrectoDatosRegistralesFase1(ICONO_TICK_OK);
		}
				
		return dto;
	}
	private void getDatosActivoSinDQ(DtoCalidadDatoPublicacionActivo dto, Activo activo) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoPropietarioActivo activoPropietario  = genericDao.get(ActivoPropietarioActivo.class, filter);
		ActivoCatastro activoCatastro = null;
		Order order = new Order(OrderType.DESC,"id");
		List <ActivoCatastro> actCatastroList = genericDao.getListOrdered(ActivoCatastro.class, order, filter);

		if(actCatastroList != null && !actCatastroList.isEmpty()) {
			activoCatastro = actCatastroList.get(0);
		}
		
		if(activo.getInfoRegistral()!=null && activo.getInfoRegistral().getInfoRegistralBien() != null){
			if (activo.getInfoRegistral().getIdufir() != null) {
				dto.setDrIdufirFase1(activo.getInfoRegistral().getIdufir());
			}
			if (activo.getInfoRegistral().getInfoRegistralBien().getNumFinca() != null) {
				dto.setDrFincaRegistralFase1(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
			}
			if (activo.getInfoRegistral().getInfoRegistralBien().getLibro() != null) {
				dto.setDrLibroFase1(activo.getInfoRegistral().getInfoRegistralBien().getLibro());
			}
			if (activo.getInfoRegistral().getInfoRegistralBien().getTomo() != null) {
				dto.setDrTomoFase1(activo.getInfoRegistral().getInfoRegistralBien().getTomo());
			}
			if (activo.getInfoRegistral().getInfoRegistralBien().getFolio() != null) {
				dto.setDrFolioFase1(activo.getInfoRegistral().getInfoRegistralBien().getFolio());
			}
			if (activoCatastro != null && activoCatastro.getRefCatastral() != null) {
				dto.setDrF3ReferenciaCatastral(activoCatastro.getRefCatastral());
			}
			if (activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida() != null) {
				dto.setDrF3SuperficieConstruida(String.valueOf(activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida().doubleValue()));
			}
			
			if(activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion()!=null) {
				dto.setDrInscripcionCorrectaFase1(INSCRITO);
			}else {
				dto.setDrInscripcionCorrectaFase1(NO_INSCRITO);
			}
			if(activo.getInfoRegistral().getSuperficieUtil() != null) {
				dto.setDrF3SuperficieUtil(String.valueOf(activo.getInfoRegistral().getSuperficieUtil()));
			}
		}
		if(activo.getInfoRegistral() != null 
				&& activo.getInfoRegistral().getInfoRegistralBien() != null) {
			dto.setDrNumeroDelRegistroFase1(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro());
			if(activo.getInfoRegistral().getInfoRegistralBien().getProvincia() != null) {
				dto.setDrProvinciaDelRegistroFase1(activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getDescripcion());
			}
		}
		if(activo.getTipoUsoDestino() !=null ) {
			dto.setDrUsoDominanteFase1(activo.getTipoUsoDestino().getDescripcion());
		}
		if(activo.getLocalizacion() != null) {
			if (activo.getLocalizacion().getLatitud() != null) {
				dto.setDrf4LocalizacionLatitud(activo.getLocalizacion().getLatitud().toString());
			}
			if (activo.getLocalizacion().getLongitud() != null) {
				dto.setDrf4LocalizacionLongitud(activo.getLocalizacion().getLongitud().toString());
			}			
		}
		if(activo.getLocalidad() !=null ) {
			dto.setDrMunicipioDelRegistroFase1(activo.getLocalidad().getDescripcion());
		}
		if(activo.getSubtipoTitulo() !=null ) {
			dto.setDrSubtipologianFase1(activo.getSubtipoTitulo().getDescripcion());
		}
		if(activo.getConCargas()!=null) {
			if(activo.getConCargas().equals(1)) {
				dto.setDrInformacionCargasFase1(SI);
			}else if(activo.getConCargas().equals(0)) {
				dto.setDrInformacionCargasFase1(NO);
			}
		}
		if(activoPropietario!=null) {
			if(activoPropietario.getPorcPropiedad()!=null) {
				dto.setDrPor100PropiedadFase1(activoPropietario.getPorcPropiedad().toString());
			}
		}
		if(activo.getTipoActivo() !=null ) {
			dto.setDrTipologianFase1(activo.getTipoActivo().getDescripcion());
		}		
		if(activo.getInfoComercial() != null) {
			if (activo.getInfoComercial().getAnyoConstruccion() != null) {
				dto.setDrF3AnyoConstruccion(new Long(activo.getInfoComercial().getAnyoConstruccion()));
			}
			if (activo.getInfoComercial().getAnyoConstruccion() != null) {
				dto.setDrAnyoConstruccionFase1(activo.getInfoComercial().getAnyoConstruccion().toString());
			}
			Filter infoComercialFilter = genericDao.createFilter(FilterType.EQUALS, "infoComercial.id",activo.getInfoComercial().getId());
			ActivoEdificio edificio = genericDao.get(ActivoEdificio.class, infoComercialFilter);
			if (!Checks.esNulo(edificio)) {
				dto.setDrFase4Descripcion(edificio.getEdiDescripcion());
			}
			
			
		}
		if(activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null) {
			if(activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
				dto.setDrF3TipoVia(activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion());	
			}
			if (activo.getLocalizacion().getLocalizacionBien().getNombreVia() != null) {
				dto.setDrF3NomCalle(activo.getLocalizacion().getLocalizacionBien().getNombreVia());
			}
			if (activo.getLocalizacion().getLocalizacionBien().getCodPostal() != null) {
				dto.setDrF3CP(activo.getLocalizacion().getLocalizacionBien().getCodPostal());
			}
			
			if(activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null) {
				dto.setDrF3Municipio(activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion());	
			}
			if(activo.getLocalizacion().getLocalizacionBien().getProvincia() != null) {
				dto.setDrF3Provincia(activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion());	
			}
		}
		if(activo.getVpo()!=null) {
			if(activo.getVpo().equals(1)) {
				dto.setDrVpoFase1(SI);
			}else if(activo.getVpo().equals(0)) {
				dto.setDrVpoFase1(NO);
			}
		}
	}

	private DtoCalidadDatoPublicacionActivo setDataFase4(ActivoDatosDq activoDatosDq, Activo activo, DtoCalidadDatoPublicacionActivo dto) {
		
		//FOTOS
		if(activoDatosDq.getNumImagenes() != null)
			dto.setNumFotos(activoDatosDq.getNumImagenes().toString());
		if(activoDatosDq.getNumImagenesExt() != null)
			dto.setNumFotosExterior(activoDatosDq.getNumImagenesExt().toString());
		if(activoDatosDq.getNumImagenesInt() != null)
			dto.setNumFotosInterior(activoDatosDq.getNumImagenesInt().toString());
		if(activoDatosDq.getNumImagenesObra() != null)
			dto.setNumFotosObra(activoDatosDq.getNumImagenesObra().toString());
		if(activoDatosDq.getNumImagenesMinRes() != null)
			dto.setNumFotosMinimaResolucion(activoDatosDq.getNumImagenesMinRes().toString());
		if(activoDatosDq.getNumImagenesMinResY() != null)
			dto.setNumFotosMinimaResolucionY(activoDatosDq.getNumImagenesMinResY().toString());
		if(activoDatosDq.getNumImagenesMinResX() != null)
			dto.setNumFotosMinimaResolucionX(activoDatosDq.getNumImagenesMinResX().toString());
		if(activoDatosDq.getImagenesMensaje() != null)
			dto.setMensajeDQFotos(activoDatosDq.getImagenesMensaje());
		
		// Descripcion
		if(activo.getInfoComercial() != null ) {
			Filter infoComercialFilter = genericDao.createFilter(FilterType.EQUALS, "infoComercial.id",activo.getInfoComercial().getId());
			ActivoEdificio edificio = genericDao.get(ActivoEdificio.class, infoComercialFilter);
			if (!Checks.esNulo(edificio)) {
				dto.setDrFase4Descripcion(edificio.getEdiDescripcion());
			}
		}
		
		if(activoDatosDq.getDescripcion() != null) {
			dto.setDqFase4Descripcion(activoDatosDq.getDescripcion());
		}
		
		// LOCALIZACION
		if(activo.getLocalizacion() != null) {
			if (activo.getLocalizacion().getLatitud() != null) {
				dto.setDrf4LocalizacionLatitud(activo.getLocalizacion().getLatitud().toString());
			}
			if (activo.getLocalizacion().getLongitud() != null) {
				dto.setDrf4LocalizacionLongitud(activo.getLocalizacion().getLongitud().toString());
			}			
		}
		
		if(activoDatosDq.getLatitudDdq() != null) 
			dto.setDqF4Localizacionlatitud(activoDatosDq.getLatitudDdq().toString());
		
		if(activoDatosDq.getLongitudDdq() != null) 
			dto.setDqf4LocalizacionLongitud(activoDatosDq.getLongitudDdq().toString());
		
		if(activoDatosDq.getGeodistancia() != null)
			dto.setGeodistanciaDQ(activoDatosDq.getGeodistancia().toString());
		
		//CEE
		if(activoDatosDq.getEstCee() != null)
			dto.setEtiquetaCEERem(activoDatosDq.getEstCee());
		if(activoDatosDq.getEtiCeeA() != null)
			dto.setNumEtiquetaA(activoDatosDq.getEtiCeeA());
		if(activoDatosDq.getEtiCeeB() != null)
			dto.setNumEtiquetaB(activoDatosDq.getEtiCeeB());
		if(activoDatosDq.getEtiCeeC() != null)
			dto.setNumEtiquetaC(activoDatosDq.getEtiCeeC());
		if(activoDatosDq.getEtiCeeD() != null)
			dto.setNumEtiquetaD(activoDatosDq.getEtiCeeD());
		if(activoDatosDq.getEtiCeeE() != null)
			dto.setNumEtiquetaE(activoDatosDq.getEtiCeeE());
		if(activoDatosDq.getEtiCeeF() != null)
			dto.setNumEtiquetaF(activoDatosDq.getEtiCeeF());
		if(activoDatosDq.getEtiCeeG() != null)
			dto.setNumEtiquetaG(activoDatosDq.getEtiCeeG());
		if(activoDatosDq.getMensajeCee() != null)
			dto.setMensajeDQCEE(activoDatosDq.getMensajeCee());
		
		
		//COMPROBACION CAMPOS CORRECTO

		setCorrectoFase4(activoDatosDq, dto);
		
		
		return dto;
	}

	private void setCorrectoFase4(ActivoDatosDq activoDatosDq, DtoCalidadDatoPublicacionActivo dto) {
		boolean interrogante = false, cruzroja = false;
		
		//FOTOS
		if(activoDatosDq.getImagenesEst() == null) {
			dto.setCorrectoFotos(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else if(activoDatosDq.getImagenesEst() != null 
				&& (ICONO_TICK_OK.equals(activoDatosDq.getImagenesEst()))) {
			dto.setCorrectoFotos(ICONO_TICK_OK);
		}else {
			dto.setCorrectoFotos(ICONO_TICK_KO);
			cruzroja = true;
		}
		
		//DESCRIPCION
		if(dto.getDqFase4Descripcion() == null) {
			dto.setCorrectoDescripcion(ICONO_TICK_INTERROGANTE);
			interrogante = true;
			dto.setDisableDescripcion(true);
		}else if(dto.getDrFase4Descripcion() != null 
				&& (dto.getDrFase4Descripcion().equals(dto.getDqFase4Descripcion()))) {
			dto.setCorrectoDescripcion(ICONO_TICK_OK);
			dto.setDisableDescripcion(true);
		}else {				
			dto.setCorrectoDescripcion(ICONO_TICK_KO);
			cruzroja = true;
			dto.setDisableDescripcion(false);
		}
		
		//LOCALIZACION
		if(dto.getGeodistanciaDQ() == null) {
			dto.setCorrectoLocalizacion(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else{
			if(Double.valueOf(dto.getGeodistanciaDQ()) <= 0.3) {
				dto.setCorrectoLocalizacion(ICONO_TICK_OK);	
			}else {
				dto.setCorrectoLocalizacion(ICONO_TICK_KO);
				cruzroja = true;
			}
		}
		
		//CEE
		if(dto.getEtiquetaCEERem() == null) {
			dto.setCorrectoCEE(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else if(dto.getEtiquetaCEERem() != null 
				&& (ICONO_TICK_OK.equals(dto.getEtiquetaCEERem()))) {
			dto.setCorrectoCEE(ICONO_TICK_OK);
		}else {
			dto.setCorrectoCEE(ICONO_TICK_KO);
			cruzroja = true;
		}
		
		if(cruzroja) {
			dto.setCorrectoF4BloqueFase4(ICONO_TICK_KO);
		}else if(interrogante) {
			dto.setCorrectoF4BloqueFase4(ICONO_TICK_INTERROGANTE);
		}else {
			dto.setCorrectoF4BloqueFase4(ICONO_TICK_OK);
		}
		
		
	}
	private void setDataFase3(DtoCalidadDatoPublicacionActivo dto, Activo activo, ActivoDatosDq actDatosDq) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());		
		Order order = new Order(OrderType.DESC,"id");
		List <ActivoCatastro> actCatastroList = genericDao.getListOrdered(ActivoCatastro.class, order, filter);
		ActivoCatastro activoCatastro =null;

		if(actCatastroList != null && !actCatastroList.isEmpty()) {
			activoCatastro = actCatastroList.get(0);
		}
		
		
		if(activo.getInfoRegistral() != null && activo.getInfoRegistral().getInfoRegistralBien() != null) {	
			if (activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida() != null) {
				dto.setDrF3SuperficieConstruida(String.valueOf(activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida().doubleValue()));
			}			
			if(activo.getInfoRegistral().getSuperficieUtil() != null) {
				dto.setDrF3SuperficieUtil(String.valueOf((activo.getInfoRegistral().getSuperficieUtil()).doubleValue()));
			}
			
		}
		if (activoCatastro != null && activoCatastro.getRefCatastral() != null) {
			dto.setDrF3ReferenciaCatastral(activoCatastro.getRefCatastral());
		}
		if(activo.getInfoComercial() != null && activo.getInfoComercial().getAnyoConstruccion() != null){
			
			dto.setDrF3AnyoConstruccion(new Long(activo.getInfoComercial().getAnyoConstruccion()));
		}
		if (actDatosDq.getReferenciaCatastralDdq() != null) {
			dto.setDqF3ReferenciaCatastral(actDatosDq.getReferenciaCatastralDdq());
		}	
		
		
		if(actDatosDq.getSuperficieConstruidaDdq() != null) {
			dto.setDqF3SuperficieConstruida(String.valueOf(actDatosDq.getSuperficieConstruidaDdq().doubleValue()));	
		}
		
		if(actDatosDq.getSuperficieUtilDdq() != null) {
			dto.setDqF3SuperficieUtil(String.valueOf(actDatosDq.getSuperficieUtilDdq().doubleValue()));	
		}
		if (actDatosDq.getAnyoConstruccion() != null) {
			dto.setDqF3AnyoConstruccion(actDatosDq.getAnyoConstruccion());
		}
		
		
		if(activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null) {
			if(activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
				dto.setDrF3TipoVia(activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion());	
			}
			if (activo.getLocalizacion().getLocalizacionBien().getNombreVia() != null) {
				dto.setDrF3NomCalle(activo.getLocalizacion().getLocalizacionBien().getNombreVia());
			}
			if (activo.getLocalizacion().getLocalizacionBien().getCodPostal() != null) {
				dto.setDrF3CP(activo.getLocalizacion().getLocalizacionBien().getCodPostal());
			}
			
			if(activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null) {
				dto.setDrF3Municipio(activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion());	
			}
			if(activo.getLocalizacion().getLocalizacionBien().getProvincia() != null) {
				dto.setDrF3Provincia(activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion());	
			}
			
		}
		if(actDatosDq.getTipoVia() != null) {
			dto.setDqF3TipoVia(actDatosDq.getTipoVia().getDescripcion());
		}
		if (actDatosDq.getNombreViaDdq() != null) {
			dto.setDqF3NomCalle(actDatosDq.getNombreViaDdq());
		}
		

		if(actDatosDq.getCalleCorrectaProb() == null) {
			dto.setProbabilidadCalleCorrecta(null);	
		}else if(actDatosDq.getCalleCorrectaProb() >= 0 && actDatosDq.getCalleCorrectaProb() <= 0.2){
			dto.setProbabilidadCalleCorrecta(PROB_MUY_BAJA);
		}else if(actDatosDq.getCalleCorrectaProb() > 0.2 && actDatosDq.getCalleCorrectaProb() <= 0.4) {
			dto.setProbabilidadCalleCorrecta(PROB_BAJA);			
		}else if(actDatosDq.getCalleCorrectaProb() > 0.4 && actDatosDq.getCalleCorrectaProb() <= 0.6) {
			dto.setProbabilidadCalleCorrecta(PROB_MEDIA);
		}else if(actDatosDq.getCalleCorrectaProb() > 0.6 && actDatosDq.getCalleCorrectaProb() <= 0.8) {
			dto.setProbabilidadCalleCorrecta(PROB_ALTA);
		}else if(actDatosDq.getCalleCorrectaProb() > 0.8 && actDatosDq.getCalleCorrectaProb() <= 1) {
			dto.setProbabilidadCalleCorrecta(PROB_MUY_ALTA);
		}
		if (actDatosDq.getCodigoPostalDdq() != null) {
			dto.setDqF3CP(actDatosDq.getCodigoPostalDdq());
		}
		
		
		if(actDatosDq.getLocalidad() != null) {
			dto.setDqF3Municipio(actDatosDq.getLocalidad().getDescripcion());
		}
		
		if(actDatosDq.getProvincia() != null) {
			dto.setDqF3Provincia(actDatosDq.getProvincia().getDescripcion());
		}
	
		//COMPROBACIONES DE LOS BLOQUES
		setCorrectoFase3(dto,actDatosDq);
		
	}

	private void setCorrectoFase3(DtoCalidadDatoPublicacionActivo dto,ActivoDatosDq actDatosDq) {

		boolean interrogante = false, cruzroja = false;
		int countKo = 0;
		int countInterrogante =0;
			
		//bloque ref catastral
		if(dto.getDqF3ReferenciaCatastral() == null) {
			dto.setCorrectoF3ReferenciaCatastral(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante = true;
		}else if(dto.getDrF3ReferenciaCatastral() != null 
				&& (dto.getDrF3ReferenciaCatastral().equals(dto.getDqF3ReferenciaCatastral()))) {
			dto.setCorrectoF3ReferenciaCatastral(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3ReferenciaCatastral(ICONO_TICK_KO);
			countKo++;
			cruzroja = true;
		}
		if (dto.getDqF3ReferenciaCatastral() == null && dto.getDrF3ReferenciaCatastral() == null) {
			interrogante = false;
			cruzroja= false;
			countInterrogante--;
		}
		
		//superficie construida ESPECIAL
		if(dto.getDqF3SuperficieConstruida() == null) {
			dto.setCorrectoF3SuperficieConstruida(ICONO_TICK_INTERROGANTE);
			interrogante = true;
			countInterrogante++;
		}else{
			if (dto.getDqF3SuperficieConstruida() != null && dto.getDrF3SuperficieConstruida() != null) {
				BigDecimal dqF3SuperficieConstruida = new BigDecimal(dto.getDqF3SuperficieConstruida());
				BigDecimal drF3SuperficieConstruida = new BigDecimal(dto.getDrF3SuperficieConstruida());
				if(dqF3SuperficieConstruida.compareTo(BigDecimal.ZERO) > 0) {
					BigDecimal calcSupConstruida = drF3SuperficieConstruida.divide(dqF3SuperficieConstruida,2,RoundingMode.HALF_UP);				 
					Double supConstruida = calcSupConstruida.doubleValue();
					
					if(supConstruida >= 0.8 && supConstruida <= 1.2 ) {
						dto.setCorrectoF3SuperficieConstruida(ICONO_TICK_OK);
					}else {
						dto.setCorrectoF3SuperficieConstruida(ICONO_TICK_KO);
						cruzroja = true;
						countKo++;
					}
				}else {
					dto.setCorrectoF3SuperficieConstruida(ICONO_TICK_KO);
					cruzroja = true;
					countKo++;
				}
			}else {
				dto.setCorrectoF3SuperficieConstruida(ICONO_TICK_INTERROGANTE);
				interrogante = true;
				countInterrogante++;
			}
			
			
		}
		if (dto.getDqF3SuperficieConstruida() == null && dto.getDrF3SuperficieConstruida() == null) {
			interrogante = false;
			cruzroja= false;
			countInterrogante--;
		}
		
		
		//superficie util ESPECIAL
		
		if(dto.getDqF3SuperficieUtil() == null) {
			dto.setCorrectoF3SuperficieUtil(ICONO_TICK_INTERROGANTE);
			interrogante = true;
			countInterrogante++;
		}else{
			if (dto.getDqF3SuperficieUtil() != null && dto.getDrF3SuperficieUtil() != null) {
				BigDecimal dqF3SuperficieUtil = new BigDecimal(dto.getDqF3SuperficieUtil());
				BigDecimal drF3SuperficieUtil = new BigDecimal(dto.getDrF3SuperficieUtil());
				if (dqF3SuperficieUtil.compareTo(BigDecimal.ZERO) > 0) {
					BigDecimal calcSupUtil = drF3SuperficieUtil.divide(dqF3SuperficieUtil, 2, RoundingMode.HALF_UP); 
					Double supUtil = calcSupUtil.doubleValue();
					
					if(supUtil >= 0.8 && supUtil <= 1.2 ) {
						dto.setCorrectoF3SuperficieUtil(ICONO_TICK_OK);
					}else {
						dto.setCorrectoF3SuperficieUtil(ICONO_TICK_KO);
						cruzroja = true;
						countKo++;
					}
				}else {
					dto.setCorrectoF3SuperficieUtil(ICONO_TICK_KO);
					cruzroja = true;
					countKo++;
				}
				
			}else {
				dto.setCorrectoF3SuperficieUtil(ICONO_TICK_INTERROGANTE);
				interrogante = true;
				countInterrogante++;

			}			
		}
		if (dto.getDqF3SuperficieUtil() == null && dto.getDrF3SuperficieUtil() == null) {
			interrogante = false;
			cruzroja= false;
			countInterrogante--;
		}
		//ANYO CONSTRUCCION
		if(dto.getDqF3AnyoConstruccion() == null) {
			dto.setCorrectoF3AnyoConstruccion(ICONO_TICK_INTERROGANTE);
			interrogante = true;
			countInterrogante++;
		}else if(dto.getDrF3AnyoConstruccion() != null) {
			if(dto.getDrF3AnyoConstruccion().compareTo(dto.getDqF3AnyoConstruccion()) == 0) {
				dto.setCorrectoF3AnyoConstruccion(ICONO_TICK_OK);	
			}else {
				dto.setCorrectoF3AnyoConstruccion(ICONO_TICK_KO);
				cruzroja = true;
				countKo++;
			}
		}else {
			dto.setCorrectoF3AnyoConstruccion(ICONO_TICK_KO);
			cruzroja = true;
			countKo++;

		}
		if (dto.getDqF3AnyoConstruccion() == null && dto.getDrF3AnyoConstruccion() == null) {
			interrogante = false;
			cruzroja= false;
			countInterrogante--;
		}
		//TIPO VIA
		if(dto.getDqF3TipoVia() == null) {
			dto.setCorrectoF3TipoVia(ICONO_TICK_INTERROGANTE);
			interrogante = true;
			countInterrogante++;

		}else if(dto.getDrF3TipoVia() != null 
				&& (dto.getDrF3TipoVia().equals(dto.getDqF3TipoVia()))) {
			dto.setCorrectoF3TipoVia(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3TipoVia(ICONO_TICK_KO);
			cruzroja = true;
			countKo++;
		}
		if (dto.getDqF3TipoVia() == null && dto.getDrF3TipoVia() == null) {
			interrogante = false;
			cruzroja= false;
			countInterrogante--;
		}
		//NOMBRE CALLE ESPECIAL
		if (dto.getDqF3NomCalle() == null) {
			interrogante = true;
			countInterrogante++;

		}else if(dto.getDqF3NomCalle().equals(dto.getDrF3NomCalle())) {
			dto.setCorrectoF3NomCalle(ICONO_TICK_OK);
		}else {
			countKo++;
			cruzroja = true;
		}
		
		if(actDatosDq.getCalleCorrectaProb() == null) {
			dto.setCorrectoF3NomCalle(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante = true;
		}else if(actDatosDq.getCalleCorrectaProb() > 0.8) {
			dto.setCorrectoF3NomCalle(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3NomCalle(ICONO_TICK_KO);
			countKo++;
			cruzroja = true;
		}
		
		//CP
		if(dto.getDqF3CP() == null) {
			dto.setCorrectoF3CP(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante = true;
		}else if(dto.getDrF3CP() != null 
				&& (dto.getDrF3CP().equals(dto.getDqF3CP()))) {
			dto.setCorrectoF3CP(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3CP(ICONO_TICK_KO);
			cruzroja = true;
			countKo++;

		}
		if (dto.getDqF3CP() == null && dto.getDrF3CP() == null) {
			interrogante = false;
			cruzroja= false;
			countInterrogante--;
		}
		//MUNICIPIO
		if(dto.getDqF3Municipio() == null) {
			dto.setCorrectoF3Municipio(ICONO_TICK_INTERROGANTE);
			countInterrogante++;
			interrogante = true;
		}else if(dto.getDrF3Municipio() != null 
				&& (dto.getDrF3Municipio().equals(dto.getDqF3Municipio()))) {
			dto.setCorrectoF3Municipio(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3Municipio(ICONO_TICK_KO);
			countKo++;
			cruzroja = true;
		}
		if (dto.getDqF3Municipio() == null && dto.getDrF3Municipio() == null) {
			interrogante = false;
			cruzroja= false;
			countInterrogante--;
		}
		//PROVINCIA
		if(dto.getDqF3Provincia() == null) {
			dto.setCorrectoF3Provincia(ICONO_TICK_INTERROGANTE);
			interrogante = true;
			countInterrogante++;
		}else if(dto.getDrF3Provincia() != null 
				&& (dto.getDrF3Provincia().equals(dto.getDqF3Provincia()))) {
			dto.setCorrectoF3Provincia(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3Provincia(ICONO_TICK_KO);
			countKo++;
			cruzroja = true;
		}
		
		if (dto.getDqF3Provincia() == null && dto.getDrF3Provincia() == null) {
			interrogante = false;
			cruzroja= false;
			countInterrogante--;
		}
		
		if(cruzroja || countKo > 0) {
			dto.setCorrectoF3BloqueFase3(ICONO_TICK_KO);
		}else if(interrogante || countInterrogante > 0) {
			dto.setCorrectoF3BloqueFase3(ICONO_TICK_INTERROGANTE);
		}else {
			dto.setCorrectoF3BloqueFase3(ICONO_TICK_OK);
		}

	}
	
	@Transactional
	@Override
	public Boolean saveDatoRemCalidadDatoPublicacion(List<Long> idList, String datoDq, boolean quieroActualizar) {
		
		if(idList == null || datoDq == null || idList.isEmpty()) {
			return false;
		}
		if(idList.size() == 1 && quieroActualizar) {
			Activo activo = activoDao.get(idList.get(0));
			Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			List<ActivoAgrupacionActivo> agList = genericDao.getList(ActivoAgrupacionActivo.class, filterActivo);
			
			for (ActivoAgrupacionActivo activoAgrupacionActivo : agList) {
				if(activoAgrupacionActivo.getAgrupacion() != null && activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion() != null
						&& DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					List<ActivoAgrupacionActivo> agListRestringida = activoAgrupacionActivo.getAgrupacion().getActivos();
					for (ActivoAgrupacionActivo activoAgrupacionActivo2 : agListRestringida) {
						Activo activoSub = activoAgrupacionActivo2.getActivo();
						ActivoInfoComercial actInfoComercial = activoSub.getInfoComercial(); 
						if(actInfoComercial != null) {
							Filter infoComercialFilter = genericDao.createFilter(FilterType.EQUALS, "infoComercial.id", actInfoComercial.getId());
							ActivoEdificio edificio = (ActivoEdificio) genericDao.get(ActivoEdificio.class, infoComercialFilter);
							if (edificio != null) {
								edificio.setEdiDescripcion(datoDq);
								genericDao.save(ActivoEdificio.class, edificio);
							} 
						}	
					}
				}				
			}
		}
		else {
			for (Long id : idList) {
				Activo activo = activoDao.get(id);
				ActivoInfoComercial actInfoComercial = activo.getInfoComercial(); 
				if(actInfoComercial != null) {
					Filter infoComercialFilter = genericDao.createFilter(FilterType.EQUALS, "infoComercial.id", actInfoComercial.getId());
					ActivoEdificio edificio = (ActivoEdificio) genericDao.get(ActivoEdificio.class, infoComercialFilter);
					if (edificio != null) {
						edificio.setEdiDescripcion(datoDq);
						genericDao.save(ActivoEdificio.class, edificio);
					} 
					
				}			
			}
		}

	
		return true;
	}
	
	@Override
	public List <DtoCalidadDatoPublicacionGrid> getCalidadDatoPublicacionActivoGrid(Long idActivo) {
		
		List <DtoCalidadDatoPublicacionGrid> listCalidadDatoPub = new ArrayList<DtoCalidadDatoPublicacionGrid>();
		DtoCalidadDatoPublicacionActivo dto = new DtoCalidadDatoPublicacionActivo();
		Activo activo = activoDao.get(idActivo);
		ActivoDatosDq actDatosDq = activoPublicacionDao.getActivoDatosDqPorIdActivo(idActivo);
		
		
		if(actDatosDq != null) {
			listCalidadDatoPub = getDtoCalidadDatoPublicacionFases(activo, actDatosDq);
		}else {
			listCalidadDatoPub = getDtoCalidadDatoPublicFasesAct(activo);
		}
		
		return listCalidadDatoPub;
	}
	
	public List <DtoCalidadDatoPublicacionGrid> getDtoCalidadDatoPublicacionFases(Activo activo, ActivoDatosDq actDatosDq){
		List <DtoCalidadDatoPublicacionGrid> listCalidadDatoPub = new ArrayList<DtoCalidadDatoPublicacionGrid>();
		String valorBooleanActivoVpo = "";
		String valorBooleanActivoDqVpo = "";
		String valorBooleanActivoInfoCargas = "";
		String valorBooleanActivoDqInfoCargas = "";
		String valorIncripcionCorrectaActivo = "";
		String valorIncripcionCorrectaActivoDq = "";
		
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Order order = new Order(OrderType.DESC,"id");
		ActivoPropietarioActivo activoPropietario  = genericDao.get(ActivoPropietarioActivo.class, filter);
		List <ActivoCargas> cargasList = activo.getCargas();
		List <ActivoCatastro> actCatastroList = genericDao.getListOrdered(ActivoCatastro.class, order, filter);
		ActivoCargas cargas = null;
		ActivoCatastro activoCatastro =null;
		
		
		if(cargasList != null && !cargasList.isEmpty()) {
			cargas = cargasList.get(0);
		}
		if(actCatastroList != null && !actCatastroList.isEmpty()) {
			activoCatastro = actCatastroList.get(0);
		}
		
		
		//FASE 2
		if (activo.getInfoRegistral() != null) {
			if (activo.getInfoRegistral().getIdufir() != null && actDatosDq.getIdufirDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Idufir", activo.getInfoRegistral().getIdufir(), actDatosDq.getIdufirDdq(), CALIDADDATO_REGISRALES));
			}else {
				if (activo.getInfoRegistral().getIdufir() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Idufir", activo.getInfoRegistral().getIdufir(), "", CALIDADDATO_REGISRALES));
				}else if(actDatosDq.getIdufirDdq() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Idufir", "", actDatosDq.getIdufirDdq(), CALIDADDATO_REGISRALES));
				} else {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Idufir", "", "", CALIDADDATO_REGISRALES));
				}
			}
			if (activo.getInfoRegistral().getInfoRegistralBien() != null 
					&& activo.getInfoRegistral().getInfoRegistralBien().getNumFinca() != null
					&& actDatosDq.getNumFincaDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Finca Registral", activo.getInfoRegistral().getInfoRegistralBien().getNumFinca(), actDatosDq.getNumFincaDdq(), CALIDADDATO_REGISRALES));
			} else {
				if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getNumFinca() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Finca Registral", activo.getInfoRegistral().getInfoRegistralBien().getNumFinca(), "", CALIDADDATO_REGISRALES));
				}else if(actDatosDq.getNumFincaDdq() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Finca Registral", "", actDatosDq.getNumFincaDdq(), CALIDADDATO_REGISRALES));
				
				} else {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Finca Registral", "", "", CALIDADDATO_REGISRALES));
				}
			}
			if (activo.getInfoRegistral().getInfoRegistralBien() != null 
					&& activo.getInfoRegistral().getInfoRegistralBien().getTomo() != null
					&& actDatosDq.getTomoDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tomo", activo.getInfoRegistral().getInfoRegistralBien().getTomo(), actDatosDq.getTomoDdq(), CALIDADDATO_REGISRALES));
			} else {
				if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getTomo() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tomo", activo.getInfoRegistral().getInfoRegistralBien().getTomo(), "", CALIDADDATO_REGISRALES));
				}else if(actDatosDq.getTomoDdq() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tomo", "", actDatosDq.getTomoDdq(), CALIDADDATO_REGISRALES));
				
				} else {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tomo", "", "", CALIDADDATO_REGISRALES));
				}
			}
			if (activo.getInfoRegistral().getInfoRegistralBien() != null 
					&& activo.getInfoRegistral().getInfoRegistralBien().getLibro() != null
					&& actDatosDq.getLibroDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Libro", activo.getInfoRegistral().getInfoRegistralBien().getLibro(), actDatosDq.getLibroDdq(), CALIDADDATO_REGISRALES));
			} else {
				if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getLibro() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Libro", activo.getInfoRegistral().getInfoRegistralBien().getLibro(), "", CALIDADDATO_REGISRALES));
				}else if(actDatosDq.getLibroDdq() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Libro", "", actDatosDq.getLibroDdq(), CALIDADDATO_REGISRALES));
				
				} else {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Libro", "", "", CALIDADDATO_REGISRALES));
				}
			}
			if (activo.getInfoRegistral().getInfoRegistralBien() != null 
					&& activo.getInfoRegistral().getInfoRegistralBien().getFolio() != null
					&& actDatosDq.getFolioDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Folio", activo.getInfoRegistral().getInfoRegistralBien().getFolio(), actDatosDq.getFolioDdq(), CALIDADDATO_REGISRALES));
			} else {
				if (activo.getInfoRegistral().getInfoRegistralBien() != null 
						&& activo.getInfoRegistral().getInfoRegistralBien().getFolio() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Folio", activo.getInfoRegistral().getInfoRegistralBien().getFolio(), "", CALIDADDATO_REGISRALES));
				}else if(actDatosDq.getFolioDdq() != null) {	
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Folio", "", actDatosDq.getFolioDdq(), CALIDADDATO_REGISRALES));
				} else {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Folio", "", "", CALIDADDATO_REGISRALES));
				}
			}			

			if (activo.getInfoRegistral().getInfoRegistralBien().getProvincia() != null && actDatosDq.getProvinciaReg() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia del registro", activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getDescripcion(), actDatosDq.getProvinciaReg().getDescripcion(), CALIDADDATO_REGISTRO)); 
			}else {
				if (activo.getInfoRegistral().getInfoRegistralBien().getProvincia() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia del registro", activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getDescripcion(), "", CALIDADDATO_REGISTRO));
				}else if(actDatosDq.getProvinciaReg() != null) {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia del registro", "", actDatosDq.getProvinciaReg().getDescripcion(), CALIDADDATO_REGISTRO));
				}else {
					listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia del registro", "", "", CALIDADDATO_REGISTRO));
				}
			}
			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Número del registro", activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro(), actDatosDq.getNumRegistroDdq(), CALIDADDATO_REGISTRO));
			
		}
		if(activo.getTipoUsoDestino() !=null && actDatosDq.getTipoUsoDestino() != null) {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Uso dominante", activo.getTipoUsoDestino().getDescripcion(), actDatosDq.getTipoUsoDestino().getDescripcion(), CALIDADDATO_REGISRALES));
		}else {
			if (activo.getTipoUsoDestino() !=null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Uso dominante", activo.getTipoUsoDestino().getDescripcion(), "", CALIDADDATO_REGISRALES));
			}else if(actDatosDq.getTipoUsoDestino() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Uso dominante", "", actDatosDq.getTipoUsoDestino().getDescripcion(), CALIDADDATO_REGISRALES));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Uso dominante", "", "", CALIDADDATO_REGISRALES));
			}
		}
		if (activo.getInfoRegistral() != null 
				&& activo.getInfoRegistral().getInfoRegistralBien() != null 
				&& activo.getInfoRegistral().getInfoRegistralBien().getLocalidad() !=null
				&& actDatosDq.getLocalidadReg() != null) {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio del registro", activo.getInfoRegistral().getInfoRegistralBien().getLocalidad().getDescripcion(), actDatosDq.getLocalidadReg().getDescripcion(), CALIDADDATO_REGISTRO));			
		}else {
			if (activo.getInfoRegistral() != null 
					&& activo.getInfoRegistral().getInfoRegistralBien() != null 
					&& activo.getInfoRegistral().getInfoRegistralBien().getLocalidad() !=null) {			
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio del registro", activo.getInfoRegistral().getInfoRegistralBien().getLocalidad().getDescripcion(), "", CALIDADDATO_REGISTRO));
			}else if (actDatosDq.getLocalidadReg() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio del registro", "", actDatosDq.getLocalidadReg().getDescripcion(), CALIDADDATO_REGISTRO));
			}else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio del registro", "", "", CALIDADDATO_REGISTRO));
			}
		}
		if(activo.getVpo()!=null) {
			if(activo.getVpo().equals(1)) {
				valorBooleanActivoVpo = SI;
			}else if(activo.getVpo().equals(0)) {
				valorBooleanActivoVpo = NO;
			}
		}
		
		if(actDatosDq.getVpo()!=null) {
			if(actDatosDq.getVpo().booleanValue()) {
				valorBooleanActivoDqVpo = SI;
				
			}else {
				valorBooleanActivoDqVpo = NO;
			}
		}
		
		listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("VPO", valorBooleanActivoVpo, valorBooleanActivoDqVpo, CALIDADDATO_REGISTRO));
		
		if (activo.getInfoComercial() != null && activo.getInfoComercial().getAnyoConstruccion() != null && actDatosDq.getAnyoConstruccion() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", activo.getInfoComercial().getAnyoConstruccion().toString(), actDatosDq.getAnyoConstruccion().toString(), CALIDADDATO_REGISTRO));
		}else {
			if (activo.getInfoComercial() != null && activo.getInfoComercial().getAnyoConstruccion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", activo.getInfoComercial().getAnyoConstruccion().toString(), "", CALIDADDATO_REGISTRO));
			}else if(actDatosDq.getAnyoConstruccion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", "", actDatosDq.getAnyoConstruccion().toString(), CALIDADDATO_REGISTRO));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", "", "", CALIDADDATO_REGISTRO));
			}
		}
		if (activo.getTipoActivo() != null && actDatosDq.getTipoActivo() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipologia", activo.getTipoActivo().getDescripcion(), actDatosDq.getTipoActivo().getDescripcion(), CALIDADDATO_REGISTRO));				
		}else {
			if (activo.getTipoActivo() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipologia", activo.getTipoActivo().getDescripcion(), "", CALIDADDATO_REGISTRO));
			}else if(actDatosDq.getTipoActivo() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipologia", "", actDatosDq.getTipoActivo().getDescripcion(), CALIDADDATO_REGISTRO));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipologia", "", "", CALIDADDATO_REGISRALES));
			}
		}
		
		if(activo.getSubtipoActivo() !=null && actDatosDq.getSubtipoActivo() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Subtipologia", activo.getSubtipoActivo().getDescripcion(), actDatosDq.getSubtipoActivo().getDescripcion(), CALIDADDATO_REGISTRO));
		}else {
			if (activo.getSubtipoActivo() !=null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Subtipologia", activo.getSubtipoActivo().getDescripcion(), "", CALIDADDATO_REGISTRO));
			}else if(actDatosDq.getSubtipoActivo() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Subtipologia", "", actDatosDq.getSubtipoActivo().getDescripcion(), CALIDADDATO_REGISTRO));
			}else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Subtipologia", "", "", CALIDADDATO_REGISTRO));
			}
		}
		
		if(activo.getConCargas()!=null) {
			if(activo.getConCargas().equals(1)) {
				valorBooleanActivoInfoCargas = SI;
			}else if(activo.getConCargas().equals(0)) {
				valorBooleanActivoInfoCargas = NO;
			}	
		}		
		if(actDatosDq.getCargas()!=null) {
			if(actDatosDq.getCargas().booleanValue()==true) {
				valorBooleanActivoDqInfoCargas = SI;								
			}else {
				valorBooleanActivoDqInfoCargas = NO;
			}
		}
		
		listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Información Cargas", valorBooleanActivoInfoCargas, valorBooleanActivoDqInfoCargas, CALIDADDATO_REGISTRO));
		
		if (actDatosDq.getDescripcionCargas()!=null && cargas !=null && cargas.getDescripcionCarga()!=null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Descripción Cargas", cargas.getDescripcionCarga().toString(), actDatosDq.getDescripcionCargas().toString(), CALIDADDATO_REGISTRO ,2));
		}else if(actDatosDq.getDescripcionCargas()!=null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Descripción Cargas", "", actDatosDq.getDescripcionCargas().toString(), CALIDADDATO_REGISTRO,2));
		}
		else {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Descripción Cargas", "", "", CALIDADDATO_REGISTRO,2));
		}
		
		if(activo.getInfoRegistral() != null 
				&& activo.getInfoRegistral().getInfoRegistralBien() != null 
				&& activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion()!=null) {
			valorIncripcionCorrectaActivo=INSCRITO;				
		}else {
			valorIncripcionCorrectaActivo=NO_INSCRITO;				
		}			
		if(actDatosDq.getInscripcion()!=null) {
			if(actDatosDq.getInscripcion().booleanValue()==true) {
				valorIncripcionCorrectaActivoDq=INSCRITO;
			}else {
				valorIncripcionCorrectaActivoDq=NO_INSCRITO;					
			}
		}
		listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Inscripción correcta", valorIncripcionCorrectaActivo, valorIncripcionCorrectaActivoDq, CALIDADDATO_REGISTRO));
		
		if (activoPropietario.getPorcPropiedad() != null && actDatosDq.getPropiedadDdq() != null) {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("% propiedad", activoPropietario.getPorcPropiedad().toString(), actDatosDq.getPropiedadDdq().toString(), CALIDADDATO_REGISTRO));
		}else {
			if (activoPropietario.getPorcPropiedad() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("% propiedad", activoPropietario.getPorcPropiedad().toString(), "", CALIDADDATO_REGISTRO));
			}else if(actDatosDq.getPropiedadDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("% propiedad", "", actDatosDq.getPropiedadDdq().toString(), CALIDADDATO_REGISTRO));
			}else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("% propiedad", "", "", CALIDADDATO_REGISTRO));
			}
		}
			
		//FASE 3
		
		if (activoCatastro != null && activoCatastro.getRefCatastral() != null && actDatosDq.getReferenciaCatastralDdq() != null) {
		//if (activo.getInfoRegistral().getInfoRegistralBien()!= null && activo.getInfoRegistral().getInfoRegistralBien().getReferenciaCatastralBien() != null && actDatosDq.getReferenciaCatastralDdq() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Referencia Catastral", activoCatastro.getRefCatastral(), actDatosDq.getReferenciaCatastralDdq(), CALIDADDATO_FASE03));
			//listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Referencia Catastral", activo.getInfoRegistral().getInfoRegistralBien().getReferenciaCatastralBien(), actDatosDq.getReferenciaCatastralDdq(), CALIDADDATO_FASE03));
		}else {
			if (activoCatastro != null && activoCatastro.getRefCatastral() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Referencia Catastral", activoCatastro.getRefCatastral(),"", CALIDADDATO_FASE03));
			} else if (actDatosDq.getReferenciaCatastralDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Referencia Catastral", "",actDatosDq.getReferenciaCatastralDdq(), CALIDADDATO_FASE03));

			}else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Referencia Catastral", "","", CALIDADDATO_FASE03));
			}
		}
		if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida() != null && actDatosDq.getSuperficieConstruidaDdq() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie Construida", 
					String.valueOf(activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida().doubleValue()), 
					String.valueOf(actDatosDq.getSuperficieConstruidaDdq().doubleValue()), 
					CALIDADDATO_FASE03));
		}else {
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie Construida", 
						String.valueOf(activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida().doubleValue()), 
						"",
						CALIDADDATO_FASE03));
			}else if(actDatosDq.getSuperficieConstruidaDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie Construida", "", 
						String.valueOf(actDatosDq.getSuperficieConstruidaDdq().doubleValue()),
						CALIDADDATO_FASE03));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie Construida", "", "", CALIDADDATO_FASE03));
			}
		}
		if (activo.getInfoRegistral()!= null && activo.getInfoRegistral().getSuperficieUtil() != null && actDatosDq.getSuperficieUtilDdq() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie útil",
					String.valueOf(activo.getInfoRegistral().getSuperficieUtil()),
					String.valueOf(actDatosDq.getSuperficieUtilDdq().doubleValue()),
					CALIDADDATO_FASE03));
		}else {
			if (activo.getInfoRegistral()!= null && activo.getInfoRegistral().getSuperficieUtil() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie útil",
						String.valueOf(activo.getInfoRegistral().getSuperficieUtil()),
						"",
						CALIDADDATO_FASE03));
			}else if(actDatosDq.getSuperficieUtilDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie útil", 
						"", 
						String.valueOf(actDatosDq.getSuperficieUtilDdq().doubleValue()),
						CALIDADDATO_FASE03));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie útil", "", "", CALIDADDATO_FASE03));
			}
		}
		if (activo.getInfoComercial() != null && activo.getInfoComercial().getAnyoConstruccion() != null && actDatosDq.getAnyoConstruccion() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", String.valueOf(activo.getInfoComercial().getAnyoConstruccion()), String.valueOf(actDatosDq.getAnyoConstruccion()),CALIDADDATO_FASE03));
		}else {
			if (activo.getInfoComercial() != null && activo.getInfoComercial().getAnyoConstruccion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", String.valueOf(activo.getInfoComercial().getAnyoConstruccion()),"", CALIDADDATO_FASE03));
			}else if(actDatosDq.getAnyoConstruccion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", "", String.valueOf(actDatosDq.getAnyoConstruccion()), CALIDADDATO_FASE03));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", "", "", CALIDADDATO_FASE03));
			}
		}		
			//Bloque dirección
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion() != null) 
				&& actDatosDq.getTipoVia() != null && actDatosDq.getTipoVia().getDescripcion() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipo vía", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion(), actDatosDq.getTipoVia().getDescripcion(), CALIDADDATO_DIRECCION));
		}else {
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipo vía", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion(), "", CALIDADDATO_DIRECCION));
			}else if(actDatosDq.getTipoVia() != null && actDatosDq.getTipoVia().getDescripcion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipo vía", "", actDatosDq.getTipoVia().getDescripcion(), CALIDADDATO_DIRECCION));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipo vía", "", "", CALIDADDATO_DIRECCION));
			}
		}
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getNombreVia() != null) && actDatosDq.getNombreViaDdq() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Nombre calle", activo.getLocalizacion().getLocalizacionBien().getNombreVia(), actDatosDq.getNombreViaDdq(), CALIDADDATO_DIRECCION));			
		}else {
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getNombreVia() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Nombre calle", activo.getLocalizacion().getLocalizacionBien().getNombreVia(), "", CALIDADDATO_DIRECCION));
			}else if(actDatosDq.getNombreViaDdq() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Nombre calle", "", actDatosDq.getNombreViaDdq(), CALIDADDATO_DIRECCION));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Nombre calle", "", "", CALIDADDATO_DIRECCION));
			}
		}
				
		if(actDatosDq.getCalleCorrectaProb() == null) {	
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Probabilidad calle correcta", "", "", CALIDADDATO_DIRECCION,2));
		}else if(actDatosDq.getCalleCorrectaProb() >= 0 && actDatosDq.getCalleCorrectaProb() <= 0.2){
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Probabilidad calle correcta", "", PROB_MUY_BAJA, CALIDADDATO_DIRECCION,2));
		}else if(actDatosDq.getCalleCorrectaProb() > 0.2 && actDatosDq.getCalleCorrectaProb() <= 0.4) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Probabilidad calle correcta", "", PROB_BAJA, CALIDADDATO_DIRECCION,2));
		}else if(actDatosDq.getCalleCorrectaProb() > 0.4 && actDatosDq.getCalleCorrectaProb() <= 0.6) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Probabilidad calle correcta", "", PROB_MEDIA, CALIDADDATO_DIRECCION,2));
		}else if(actDatosDq.getCalleCorrectaProb() > 0.6 && actDatosDq.getCalleCorrectaProb() <= 0.8) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Probabilidad calle correcta", "", PROB_ALTA, CALIDADDATO_DIRECCION,2));
		}else if(actDatosDq.getCalleCorrectaProb() > 0.8 && actDatosDq.getCalleCorrectaProb() <= 1) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Probabilidad calle correcta", "", PROB_MUY_ALTA, CALIDADDATO_DIRECCION,2));
		}
		
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getCodPostal() != null) && actDatosDq.getCodigoPostalDdq() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("CP", activo.getLocalizacion().getLocalizacionBien().getCodPostal(), actDatosDq.getCodigoPostalDdq(), CALIDADDATO_DIRECCION));
		}else {
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getCodPostal() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("CP", activo.getLocalizacion().getLocalizacionBien().getCodPostal(), "", CALIDADDATO_DIRECCION));
			}else if(actDatosDq.getCodigoPostalDdq() != null) {
				
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("CP", "", actDatosDq.getCodigoPostalDdq(), CALIDADDATO_DIRECCION));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("CP", "", "", CALIDADDATO_DIRECCION));
			}
		}
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() !=null 
				&& activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null 
				&& activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion() != null)
				&& (actDatosDq.getLocalidad() != null && actDatosDq.getLocalidad().getDescripcion() != null)) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion(), actDatosDq.getLocalidad().getDescripcion(), CALIDADDATO_DIRECCION));
		}else {
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() !=null 
					&& activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null 
					&& activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion(), "", CALIDADDATO_DIRECCION));
			}else if(actDatosDq.getLocalidad() != null && actDatosDq.getLocalidad().getDescripcion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio", "", actDatosDq.getLocalidad().getDescripcion(), CALIDADDATO_DIRECCION));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio", "", "", CALIDADDATO_DIRECCION));
			}
		}
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null 
				&& activo.getLocalizacion().getLocalizacionBien().getProvincia() != null 
				&& activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion() != null)
				&& (actDatosDq.getProvincia() != null && actDatosDq.getProvincia().getDescripcion() != null)) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia", activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion(), actDatosDq.getProvincia().getDescripcion(), CALIDADDATO_DIRECCION));
		}else {
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null 
					&& activo.getLocalizacion().getLocalizacionBien().getProvincia() != null 
					&& activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia", activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion(), "", CALIDADDATO_DIRECCION));
			}else if(actDatosDq.getProvincia() != null && actDatosDq.getProvincia().getDescripcion() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia", "", actDatosDq.getProvincia().getDescripcion(), CALIDADDATO_DIRECCION));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia", "", "", CALIDADDATO_DIRECCION));
			}
		}
		

		return listCalidadDatoPub;
	}
	
	public List <DtoCalidadDatoPublicacionGrid> getDtoCalidadDatoPublicFasesAct(Activo activo){
		List <DtoCalidadDatoPublicacionGrid> listCalidadDatoPub = new ArrayList<DtoCalidadDatoPublicacionGrid>();
		
		String valorBooleanActivoVpo = "";
		String valorBooleanActivoDqVpo = "";
		String valorBooleanActivoInfoCargas = "";
		String valorBooleanActivoDqInfoCargas = "";
		String valorIncripcionCorrectaActivo = "";
		String valorIncripcionCorrectaActivoDq = "";
		
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Order order = new Order(OrderType.DESC,"id");
		ActivoPropietarioActivo activoPropietario  = genericDao.get(ActivoPropietarioActivo.class, filter);
		List <ActivoCatastro> actCatastroList = genericDao.getListOrdered(ActivoCatastro.class, order, filter);
		ActivoCatastro activoCatastro =null;

		if(actCatastroList != null && !actCatastroList.isEmpty()) {
			activoCatastro = actCatastroList.get(0);
		}

		
		//FASE 2
		if (activo.getInfoRegistral() != null) {
			if (activo.getInfoRegistral().getIdufir() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Idufir", activo.getInfoRegistral().getIdufir(), CALIDADDATO_REGISRALES));
			}else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Idufir", "", CALIDADDATO_REGISRALES));
			}
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getNumFinca() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Finca Registral", activo.getInfoRegistral().getInfoRegistralBien().getNumFinca(), CALIDADDATO_REGISRALES));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Finca Registral", "", CALIDADDATO_REGISRALES));
			}
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getTomo() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tomo", activo.getInfoRegistral().getInfoRegistralBien().getTomo(), CALIDADDATO_REGISRALES));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tomo", "", CALIDADDATO_REGISRALES));

			}
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getLibro() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Libro", activo.getInfoRegistral().getInfoRegistralBien().getLibro(), CALIDADDATO_REGISRALES));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Libro", "", CALIDADDATO_REGISRALES));
			}
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getFolio() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Folio", activo.getInfoRegistral().getInfoRegistralBien().getFolio(), CALIDADDATO_REGISRALES));
			} else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Folio", "", CALIDADDATO_REGISRALES));
			}			

			if (activo.getInfoRegistral().getInfoRegistralBien().getProvincia() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia del registro", activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getDescripcion(), CALIDADDATO_REGISTRO)); 
			}else {				
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia del registro", "",CALIDADDATO_REGISTRO));				
			}
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro() != null) {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Número del registro", activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro(), CALIDADDATO_REGISTRO));
			}else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Número del registro", "", CALIDADDATO_REGISTRO));
			}
			
			
			
			
		}
		
		if(activo.getTipoUsoDestino() !=null) {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Uso dominante", activo.getTipoUsoDestino().getDescripcion(), CALIDADDATO_REGISRALES));
		}else {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Uso dominante", "", CALIDADDATO_REGISRALES));			
		}
		if (activo.getLocalidad() != null ) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio del registro", activo.getLocalidad().getDescripcion(), CALIDADDATO_REGISTRO));
		}else {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio del registro", "", CALIDADDATO_REGISTRO));			
		}
				
		if(activo.getVpo()!=null) {
			if(activo.getVpo().equals(1)) {
				valorBooleanActivoVpo = SI;
			}else if(activo.getVpo().equals(0)) {
				valorBooleanActivoVpo = NO;
			}
		}
		
		listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("VPO", valorBooleanActivoVpo, CALIDADDATO_REGISTRO));
		
		if (activo.getInfoComercial() != null && activo.getInfoComercial().getAnyoConstruccion() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", activo.getInfoComercial().getAnyoConstruccion().toString(), CALIDADDATO_REGISTRO));
		}else {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", "", CALIDADDATO_REGISTRO));			
		}
		if (activo.getTipoActivo() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipologia", activo.getTipoActivo().getDescripcion(), CALIDADDATO_REGISTRO));				
		}else {
				listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipologia", "", CALIDADDATO_REGISTRO));
		}
		
		if(activo.getSubtipoActivo() !=null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Subtipologia", activo.getSubtipoActivo().getDescripcion(), CALIDADDATO_REGISTRO));
		}else {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Subtipologia", "",CALIDADDATO_REGISTRO));		
		}
		
		if(activo.getConCargas()!=null) {
			if(activo.getConCargas().equals(1)) {
				valorBooleanActivoInfoCargas = SI;
			}else if(activo.getConCargas().equals(0)) {
				valorBooleanActivoInfoCargas = NO;
			}	
		}						
		listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Información Cargas", valorBooleanActivoInfoCargas,CALIDADDATO_REGISTRO));
		
		if(activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion()!=null) {
			valorIncripcionCorrectaActivo=INSCRITO;				
		}else {
			valorIncripcionCorrectaActivo=NO_INSCRITO;				
		}			
		
		listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Inscripción correcta", valorIncripcionCorrectaActivo, CALIDADDATO_REGISTRO));
		if (activoPropietario.getPorcPropiedad() != null) {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("% propiedad", activoPropietario.getPorcPropiedad().toString(),CALIDADDATO_REGISTRO));
		}else {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("% propiedad", "",CALIDADDATO_REGISTRO));			
		}				
		//FASE 3
		if (activoCatastro!= null && activoCatastro.getRefCatastral() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Referencia Catastral", activoCatastro.getRefCatastral(), CALIDADDATO_FASE03));
		}else {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Referencia Catastral", "",CALIDADDATO_FASE03));
		}
		if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie Construida", 
					String.valueOf(activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida().doubleValue()), 
					CALIDADDATO_FASE03));
		}else {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie Construida", "", CALIDADDATO_FASE03));
		}
		if (activo.getInfoRegistral()!= null && activo.getInfoRegistral().getSuperficieUtil() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie útil",
					String.valueOf(activo.getInfoRegistral().getSuperficieUtil()),
					CALIDADDATO_FASE03));
		}else {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Superficie útil", "", CALIDADDATO_FASE03));			
		}
		if (activo.getInfoComercial() != null && activo.getInfoComercial().getAnyoConstruccion() != null) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", String.valueOf(activo.getInfoComercial().getAnyoConstruccion()),CALIDADDATO_FASE03));
		}else {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Año construcción", "",CALIDADDATO_FASE03));
		}		
			//Bloque dirección
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion() != null)) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipo vía", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion(), CALIDADDATO_DIRECCION));
		}else {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Tipo vía", "", CALIDADDATO_DIRECCION));
			
		}
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getNombreVia() != null)) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Nombre calle", activo.getLocalizacion().getLocalizacionBien().getNombreVia(), CALIDADDATO_DIRECCION));			
		}else {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Nombre calle", "",CALIDADDATO_DIRECCION));			
		}
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getCodPostal() != null)) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("CP", activo.getLocalizacion().getLocalizacionBien().getCodPostal(), CALIDADDATO_DIRECCION));
		}else {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("CP", "", CALIDADDATO_DIRECCION));
			
		}
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() !=null 
				&& activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null 
				&& activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion() != null)) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion(), CALIDADDATO_DIRECCION));
		}else {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Municipio", "", CALIDADDATO_DIRECCION));			
		}
		if ((activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null 
				&& activo.getLocalizacion().getLocalizacionBien().getProvincia() != null 
				&& activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion() != null)) {
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia", activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion(),CALIDADDATO_DIRECCION));
		}else {			
			listCalidadDatoPub.add(new DtoCalidadDatoPublicacionGrid("Provincia", "", CALIDADDATO_DIRECCION));			
		}
		
		return listCalidadDatoPub;
	}
	
	private List<Long> propagarFasesPublicacionYRecalcularPerimetroVisibilidad(HistoricoFasePublicacionActivo nuevaFasePublicacionActivo,  List<Activo> activos, String numAgr) {
		
		List<Long> numeroActivosApropagar = new ArrayList<Long>();
		String numActivoPStr = nuevaFasePublicacionActivo.getActivo().getNumActivo().toString();
		String comentario = this.crearComentarioPropagarFase(numActivoPStr, numAgr, nuevaFasePublicacionActivo.getComentario());
		PerimetroActivo perimetroActivoP = genericDao.get(PerimetroActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", nuevaFasePublicacionActivo.getActivo().getId()));
		
		for (Activo activo : activos) {
			HistoricoFasePublicacionActivo faseActivoAgr = activoPublicacionDao.getFasePublicacionVigentePorIdActivo(activo.getId());
			if(faseActivoAgr != null) {
				faseActivoAgr.setFechaFin(new Date());
				genericDao.save(HistoricoFasePublicacionActivo.class, faseActivoAgr);
			}
				
			HistoricoFasePublicacionActivo nuevaFasePublicacionActivoR = new HistoricoFasePublicacionActivo();
			
			nuevaFasePublicacionActivoR.setActivo(activo);
			nuevaFasePublicacionActivoR.setFechaInicio(nuevaFasePublicacionActivo.getFechaInicio());
			nuevaFasePublicacionActivoR.setUsuario(nuevaFasePublicacionActivo.getUsuario());
			nuevaFasePublicacionActivoR.setFasePublicacion(nuevaFasePublicacionActivo.getFasePublicacion());
			nuevaFasePublicacionActivoR.setSubFasePublicacion(nuevaFasePublicacionActivo.getSubFasePublicacion());		
			nuevaFasePublicacionActivoR.setComentario(comentario);
			genericDao.save(HistoricoFasePublicacionActivo.class, nuevaFasePublicacionActivoR);
			
			PerimetroActivo perimetroActivo = genericDao.get(PerimetroActivo.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			
			perimetroActivo.setCheckGestorComercial( perimetroActivoP.getCheckGestorComercial());	
			perimetroActivo.setFechaGestionComercial(perimetroActivoP.getFechaGestionComercial());
			perimetroActivo.setExcluirValidaciones(perimetroActivoP.getExcluirValidaciones());
			perimetroActivo.setMotivoGestionComercial(perimetroActivoP.getMotivoGestionComercial());
			
			genericDao.save(PerimetroActivo.class, perimetroActivo);
			
			numeroActivosApropagar.add(activo.getNumActivo());
		}
			
		return numeroActivosApropagar;	
	}
	
	private String crearComentarioPropagarFase(String numActPr, String numAgr, String comentarioP) {
		StringBuilder sb =  new StringBuilder("Cambio realizado por la propagación de los cambios del activo ");
		sb.append(numActPr);
		sb.append(", activo principal de la agrupación restringida ");
		sb.append(numAgr);
		if(comentarioP != null && !comentarioP.isEmpty()) {
			sb.append(": " + comentarioP);
		}
		
		return sb.toString();
	}
	
	private String crearCuerpoCorreoPropagarFase(List<Long> activosPropagados, String numAgrupacion) {
		StringBuilder sb = new StringBuilder("");
		
		if(activosPropagados != null && !activosPropagados.isEmpty()) {
			sb.append("Este cambio se ha propagado a los siguientes activos:");
			for (int i = 0; i<= activosPropagados.size(); i++) {
				sb.append(activosPropagados.get(i).toString());
				if(i != activosPropagados.size()-1) {
					sb.append(", ");
				}
			}
			sb.append(". Pertenecientes a la agrupación: ");
			sb.append(numAgrupacion);
		}
		
		return sb.toString();
	}
}
