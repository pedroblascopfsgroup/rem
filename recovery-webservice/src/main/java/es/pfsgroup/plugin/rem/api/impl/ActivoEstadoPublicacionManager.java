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
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoDatosDq;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPropietarioActivo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTransicionesFasesPublicacion;
import es.pfsgroup.plugin.rem.model.DtoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.DtoCalidadDatoPublicacionActivo;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.notificacion.NotificationActivoManager;
import es.pfsgroup.plugin.rem.usuarioRem.UsuarioRemApi;
import es.pfsgroup.recovery.api.UsuarioApi;

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
		}
		
		if(!Checks.esNulo(dto.getFechaRevisionPublicacionesVenta())) {
			dto.setFechaRevisionPublicacionesVenta(dto.getFechaRevisionPublicacionesVenta());
		}
		
		if(!Checks.esNulo(dto.getFechaRevisionPublicacionesAlquiler())) {
			dto.setFechaRevisionPublicacionesAlquiler(dto.getFechaRevisionPublicacionesAlquiler());
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
		VCondicionantesDisponibilidad vcd = genericDao.get(VCondicionantesDisponibilidad.class, filter);

		return !Checks.esNulo(vcd) && !vcd.getSinInformeAprobadoREM();
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
			for(ActivoPublicacion activoPublicacion : activosPublicacion) {
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
				
				activoPublicacionDao.save(activoPublicacion);
				
				if(Checks.esNulo(dto.getOcultarVenta()) && !Checks.esNulo(dto.getMotivoOcultacionVentaCodigo())) {
					ActivoPublicacionHistorico activoPublicacionHistorico = new ActivoPublicacionHistorico();
					BeanUtils.copyProperties(activoPublicacionHistorico, activoPublicacion);
					activoPublicacionHistorico.setFechaInicioVenta(new Date(System.currentTimeMillis() + 3600 * 1000));
					activoPublicacionHistorico.setFechaInicioAlquiler(null);
					activoPublicacionHistorico.setAuditoria(null);
					activoPublicacionHistoricoDao.save(activoPublicacionHistorico);
				}
				
				if(Checks.esNulo(dto.getOcultarAlquiler()) && !Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo())) {
					ActivoPublicacionHistorico activoPublicacionHistorico = new ActivoPublicacionHistorico();
					BeanUtils.copyProperties(activoPublicacionHistorico, activoPublicacion);
					activoPublicacionHistorico.setFechaInicioVenta(null);
					activoPublicacionHistorico.setFechaInicioAlquiler(new Date(System.currentTimeMillis() + 3600 * 1000));
					activoPublicacionHistorico.setAuditoria(null);
					activoPublicacionHistoricoDao.save(activoPublicacionHistorico);
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

			}
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

		if (getEstadoIndicadorPublicacionVenta(activoPrincipal) == 0) {
			estado = ESTADO_PUBLICACION_NARANJA;
		} else if (getEstadoIndicadorPublicacionVenta(activoPrincipal) == 2) {
			estado = ESTADO_PUBLICACION_AMARILLO;
		} else if (getEstadoIndicadorPublicacionVenta(activoPrincipal) == 1 && !ESTADO_PUBLICACION_AMARILLO.equals(estado)) {
			estado = ESTADO_PUBLICACION_AZUL;
		}

		return estado;
	}

	@Override
	public Integer getEstadoIndicadorPublicacionAgrupacionAlquiler(Activo activoPrincipal) {
		Integer estado = 0;

		
		if (getEstadoIndicadorPublicacionAlquiler(activoPrincipal) == 0) {
			estado = ESTADO_PUBLICACION_NARANJA;
		} else if (getEstadoIndicadorPublicacionAlquiler(activoPrincipal) == 2) {
			estado = ESTADO_PUBLICACION_AMARILLO;
		} else if (getEstadoIndicadorPublicacionAlquiler(activoPrincipal) == 1 && !ESTADO_PUBLICACION_AMARILLO.equals(estado)) {
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
	public Boolean actualizarEstadoPublicacionDelActivoOrAgrupacionRestringidaSiPertenece(Long idActivo,boolean doFlush) {
		Activo activo = activoApi.get(idActivo);

		if(activoApi.isActivoIntegradoAgrupacionRestringida(idActivo)) {
			activoDao.publicarAgrupacionConHistorico(activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(idActivo).getAgrupacion().getId(), genericAdapter.getUsuarioLogado().getUsername(), null, doFlush);
		} else {
			activoDao.publicarActivoConHistorico(activo.getId(), genericAdapter.getUsuarioLogado().getUsername(), null, doFlush);
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
	@Transactional
	public Boolean saveFasePublicacionActivo(DtoFasePublicacionActivo dto){
		HistoricoFasePublicacionActivo fasePublicacionActivoVigente = activoPublicacionDao.getFasePublicacionVigentePorIdActivo(dto.getIdActivo());
		DDFasePublicacion fasePublicacion = new DDFasePublicacion();


		
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
				enviarCorreoFasePublicacion(dto);
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

	private void enviarCorreoFasePublicacion(DtoFasePublicacionActivo dto) {
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
				mailsPara.add(activo.getInfoComercial().getMediadorInforme().getEmail());
			}
			if(!Checks.estaVacio(mailsPara) || !Checks.estaVacio(mailsCC)) {
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
		if(actDatosDq != null) {
			
			HistoricoFasePublicacionActivo fasePublicacion =  activoPublicacionDao.getFasePublicacionVigentePorIdActivo(idActivo);
			
			if(fasePublicacion.getFasePublicacion() != null) {
				if(DDFasePublicacion.CODIGO_FASE_0_CALIDAD_PENDIENTE.equals(fasePublicacion.getFasePublicacion().getCodigo())
						|| DDFasePublicacion.CODIGO_FASE_I_PENDIENTE_ACTUACIONES_PREVIAS.equals(fasePublicacion.getFasePublicacion().getCodigo())
						|| DDFasePublicacion.CODIGO_FASE_II_PENDIENTE_LLAVES.equals(fasePublicacion.getFasePublicacion().getCodigo())
				){
					dto.setDesplegable0Collapsed(false);
					dto = setDataFase0a2(actDatosDq, activo, dto);
					
				}else if(DDFasePublicacion.CODIGO_FASE_III_PENDIENTE_INFORMACION.equals(fasePublicacion.getFasePublicacion().getCodigo())
						) {
					dto.setDesplegable1Collapsed(false);
					setDataFase3(dto, activo, actDatosDq);
					
				}else if(DDFasePublicacion.CODIGO_FASE_IV_PENDIENTE_PRECIO.equals(fasePublicacion.getFasePublicacion().getCodigo())
								|| DDFasePublicacion.CODIGO_FASE_V_INCIDENCIAS_PUBLICACION.equals(fasePublicacion.getFasePublicacion().getCodigo())
								|| DDFasePublicacion.CODIGO_FASE_VI_CALIDAD_COMPROBADA.equals(fasePublicacion.getFasePublicacion().getCodigo())
						) {
							dto.setDesplegable2Collapsed(false);
							dto = setDataFase4(actDatosDq, activo, dto);
				}
			}
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
			dto.setDrIdufirFase1(activo.getInfoRegistral().getIdufir());
			dto.setDrFincaRegistralFase1(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
			dto.setDrLibroFase1(activo.getInfoRegistral().getInfoRegistralBien().getLibro());
			dto.setDrTomoFase1(activo.getInfoRegistral().getInfoRegistralBien().getTomo());
			dto.setDrFolioFase1(activo.getInfoRegistral().getInfoRegistralBien().getFolio());
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
		
		if(actDatosDq.getTipoUsoDestino() != null) {
			dto.setDqUsoDominanteFase1(actDatosDq.getTipoUsoDestino().getDescripcion());
		}
		if(activo.getTipoUsoDestino() !=null ) {
			dto.setDrUsoDominanteFase1(activo.getTipoUsoDestino().getDescripcion());
		}

		if(activo.getInfoRegistral() != null 
				&& activo.getInfoRegistral().getInfoRegistralBien() != null) {
			
			dto.setDrNumeroDelRegistroFase1(activo.getInfoRegistral().getInfoRegistralBien().getNumRegistro());
			
			if(activo.getInfoRegistral().getInfoRegistralBien().getProvincia() != null) {
				dto.setDrProvinciaDelRegistroFase1(activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getDescripcion());
			}
		}
		//numero de registro
		if(actDatosDq.getNumRegistroDdq()!=null) {
			dto.setDqNumeroDelRegistroFase1(actDatosDq.getNumRegistroDdq());
		}
		
		//Municipio del registro
		if(actDatosDq.getLocalidadReg()!=null) {
			dto.setDqMunicipioDelRegistroFase1(actDatosDq.getLocalidadReg().getDescripcion());
		}
		if(activo.getLocalidad() !=null ) {
			dto.setDrMunicipioDelRegistroFase1(activo.getLocalidad().getDescripcionLarga());
		}
		
		//Provincia del registro
		if(actDatosDq.getProvincia() !=null ) {
			dto.setDqProvinciaDelRegistroFase1(actDatosDq.getProvincia().getDescripcion());
		}
		if(activo.getProvincia()!=null) {
			dto.setDrProvinciaDelRegistroFase1(activo.getProvincia());
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
			dto.setDqAnyoConstruccionFase1(actDatosDq.getAnyoConstruccion());
		}	
		
		if(activo.getInfoComercial() !=null ) {
			dto.setDrAnyoConstruccionFase1(activo.getInfoComercial().getAnyoConstruccion().toString());
		}
		if(actDatosDq.getDescripcionCargas()!=null) {
			dto.setDescripcionCargasInformacionCargasFase1(actDatosDq.getDescripcionCargas());
		}
		//Tipologia
		if(activo.getTipoActivo() !=null ) {
			dto.setDrTipologianFase1(activo.getTipoActivo().getDescripcion());
		}
		if(actDatosDq.getTipoActivo() !=null) {
			dto.setDqTipologiaFase1(actDatosDq.getTipoActivo().getDescripcion());
		}
		//Subtipologia
		if(activo.getSubtipoTitulo() !=null ) {
			dto.setDrSubtipologianFase1(activo.getSubtipoTitulo().getDescripcion());
		}
		if(actDatosDq.getSubtipoTitulo() !=null ) {
			dto.setDqSubtipologiaFase1(actDatosDq.getSubtipoTitulo().getDescripcion());
			
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
		
		
		return dto;
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
		if(activo.getInfoComercial() != null) {
			dto.setDrFase4Descripcion(activo.getInfoComercial().getDescripcionComercial());
		}
		
		if(activoDatosDq.getDescripcion() != null) {
			dto.setDqFase4Descripcion(activoDatosDq.getDescripcion());
		}
		
		// LOCALIZACION
		// FALTA LATITUD REM
		if(activoDatosDq.getLatitudDdq() != null) 
			dto.setDqF4Localizacionlatitud(activoDatosDq.getLatitudDdq().toString());
		
		//FALTA LONGITUD REM
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
		
		return dto;
	}

	private void setDataFase3(DtoCalidadDatoPublicacionActivo dto, Activo activo, ActivoDatosDq actDatosDq) {
		
		if(activo.getInfoRegistral() != null && activo.getInfoRegistral().getInfoRegistralBien() != null) {
			dto.setDrF3ReferenciaCatastral(activo.getInfoRegistral().getInfoRegistralBien().getReferenciaCatastralBien());
			dto.setDrF3SuperficieConstruida(activo.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida());
			if(activo.getInfoRegistral().getSuperficieUtil() != null) {
				dto.setDrF3SuperficieUtil(new BigDecimal(activo.getInfoRegistral().getSuperficieUtil()));
			}
			
		}
		if(activo.getInfoComercial() != null) {
			
			dto.setDrF3AnyoConstruccion(new Long(activo.getInfoComercial().getAnyoConstruccion()));
		}
			
		dto.setDqF3ReferenciaCatastral(actDatosDq.getReferenciaCatastralDdq());
		
		if(actDatosDq.getSuperficieConstruidaDdq() != null) {
			dto.setDqF3SuperficieConstruida(new BigDecimal(actDatosDq.getSuperficieConstruidaDdq()));	
		}
		
		if(actDatosDq.getSuperficieUtilDdq() != null) {
			dto.setDqF3SuperficieUtil(new BigDecimal(actDatosDq.getSuperficieUtilDdq()));	
		}
		
		dto.setDqF3AnyoConstruccion(actDatosDq.getAnyoConstruccion());
		
		if(activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null) {
			dto.setDrF3TipoVia(activo.getLocalizacion().getLocalizacionBien().getTipoVia().getDescripcion());
			dto.setDrF3NomCalle(activo.getLocalizacion().getLocalizacionBien().getNombreVia());
			dto.setDrF3CP(activo.getLocalizacion().getLocalizacionBien().getCodPostal());
			dto.setDrF3Municipio(activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion());
			dto.setDrF3Provincia(activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion());
		}
		
		dto.setDqF3TipoVia(actDatosDq.getTipoVia().getDescripcion());
		dto.setDqF3NomCalle(actDatosDq.getNombreViaDdq());

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
		
		dto.setDqF3CP(actDatosDq.getCodigoPostalDdq());
		
		if(actDatosDq.getLocalidad() != null) {
			dto.setDqF3Municipio(actDatosDq.getLocalidad().getDescripcion());
		}
		
		if(actDatosDq.getProvincia() != null) {
			dto.setDqF3Provincia(actDatosDq.getProvincia().getDescripcion());
		}
	
		//COMPROBACIONES DE LOS BLOQUES
		setCorrectoFase3(dto);
		
	}

	private void setCorrectoFase3(DtoCalidadDatoPublicacionActivo dto) {

		boolean interrogante = false, cruzroja = false;
			
		//bloque ref catastral
		if(dto.getDqF3ReferenciaCatastral() == null) {
			dto.setCorrectoF3ReferenciaCatastral(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else if(dto.getDrF3ReferenciaCatastral() != null 
				&& (dto.getDrF3ReferenciaCatastral().equals(dto.getDqF3ReferenciaCatastral()))) {
			dto.setCorrectoF3ReferenciaCatastral(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3ReferenciaCatastral(ICONO_TICK_KO);
			cruzroja = true;
		}
		
		//superficie construida ESPECIAL
		if(dto.getDqF3SuperficieConstruida() == null) {
			dto.setCorrectoF3SuperficieConstruida(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else{
			BigDecimal calcSupConstruida = dto.getDrF3SuperficieConstruida().divide(dto.getDqF3SuperficieConstruida(), 2, RoundingMode.HALF_UP); 
			DecimalFormat df = new DecimalFormat("#.##");
			Double supConstruida = new Double(df.format(calcSupConstruida));
			
			if(supConstruida >= 0.8 && supConstruida <= 1.2 ) {
				dto.setCorrectoF3SuperficieConstruida(ICONO_TICK_OK);
			}else {
				dto.setCorrectoF3SuperficieConstruida(ICONO_TICK_KO);
				cruzroja = true;	
			}
		}
		
		//superficie util ESPECIAL
		
		if(dto.getDqF3SuperficieUtil() == null) {
			dto.setCorrectoF3SuperficieUtil(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else{
			BigDecimal calcSupUtil = dto.getDrF3SuperficieUtil().divide(dto.getDqF3SuperficieUtil(), 2, RoundingMode.HALF_UP); 
			DecimalFormat df = new DecimalFormat("#.##");
			Double supUtil = new Double(df.format(calcSupUtil));
			
			if(supUtil >= 0.8 && supUtil <= 1.2 ) {
				dto.setCorrectoF3SuperficieUtil(ICONO_TICK_OK);
			}else {
				dto.setCorrectoF3SuperficieUtil(ICONO_TICK_KO);
				cruzroja = true;	
			}
		}
		
		//ANYO CONSTRUCCION
		if(dto.getDqF3AnyoConstruccion() == null) {
			dto.setCorrectoF3AnyoConstruccion(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else if(dto.getDrF3AnyoConstruccion() != null 
				&& (dto.getDrF3AnyoConstruccion() == dto.getDqF3AnyoConstruccion())) {
			dto.setCorrectoF3AnyoConstruccion(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3AnyoConstruccion(ICONO_TICK_KO);
			cruzroja = true;
		}
		
		//TIPO VIA
		if(dto.getDqF3TipoVia() == null) {
			dto.setCorrectoF3TipoVia(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else if(dto.getDrF3TipoVia() != null 
				&& (dto.getDrF3TipoVia().equals(dto.getDqF3TipoVia()))) {
			dto.setCorrectoF3TipoVia(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3TipoVia(ICONO_TICK_KO);
			cruzroja = true;
		}
		
		//NOMBRE CALLE ESPECIAL
		if(dto.getDqF3NomCalle() == null) {
			dto.setCorrectoF3NomCalle(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else if(dto.getDrF3NomCalle() != null 
				&& (dto.getDrF3NomCalle().equals(dto.getDqF3NomCalle()))) {
			dto.setCorrectoF3TipoVia(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3TipoVia(ICONO_TICK_KO);
			cruzroja = true;
		}
		
		//CP
		if(dto.getDqF3CP() == null) {
			dto.setCorrectoF3CP(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else if(dto.getDrF3CP() != null 
				&& (dto.getDrF3CP().equals(dto.getDqF3CP()))) {
			dto.setCorrectoF3CP(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3CP(ICONO_TICK_KO);
			cruzroja = true;
		}
		
		//MUNICIPIO
		if(dto.getDqF3Municipio() == null) {
			dto.setCorrectoF3Municipio(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else if(dto.getDrF3Municipio() != null 
				&& (dto.getDrF3Municipio().equals(dto.getDqF3Municipio()))) {
			dto.setCorrectoF3Municipio(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3Municipio(ICONO_TICK_KO);
			cruzroja = true;
		}
		
		//PROVINCIA
		if(dto.getDqF3Provincia() == null) {
			dto.setCorrectoF3Provincia(ICONO_TICK_INTERROGANTE);
			interrogante = true;
		}else if(dto.getDrF3Provincia() != null 
				&& (dto.getDrF3Provincia().equals(dto.getDqF3Provincia()))) {
			dto.setCorrectoF3Provincia(ICONO_TICK_OK);
		}else {
			dto.setCorrectoF3Provincia(ICONO_TICK_KO);
			cruzroja = true;
		}
		
		if(cruzroja) {
			dto.setCorrectoF3BloqueFase3(ICONO_TICK_KO);
		}else if(interrogante) {
			dto.setCorrectoF3BloqueFase3(ICONO_TICK_INTERROGANTE);
		}else {
			dto.setCorrectoF3BloqueFase3(ICONO_TICK_OK);
		}

	}
}
