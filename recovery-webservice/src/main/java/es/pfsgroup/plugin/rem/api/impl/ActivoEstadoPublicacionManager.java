package es.pfsgroup.plugin.rem.api.impl;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
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
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.*;
import es.pfsgroup.plugin.rem.validate.validator.DtoPublicacionValidaciones;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Service("activoEstadoPublicacionManager")
public class ActivoEstadoPublicacionManager implements ActivoEstadoPublicacionApi{
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	private static final Integer ESTADO_PUBLICACION_NARANJA = 0;
	private static final Integer ESTADO_PUBLICACION_AZUL = 1;
	private static final Integer ESTADO_PUBLICACION_AMARILLO = 2;

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

    private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

    public DtoCambioEstadoPublicacion getState(Long idActivo){ // TODO: eliminar.
    	DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion = new DtoCambioEstadoPublicacion();
    	Activo activo = activoApi.get(idActivo);
    	dtoCambioEstadoPublicacion.setActivo(idActivo);

    	// Si el activo NO tiene estado, se toma como "no publicado"
    	DDEstadoPublicacion estadoPublicacion = null;
    	if(!Checks.esNulo(activo.getEstadoPublicacion())){
    		estadoPublicacion = activo.getEstadoPublicacion();
    	} else {
    		estadoPublicacion = (DDEstadoPublicacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacion.class, DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
    	}

    	if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    	} else if(!Checks.esNulo(activo.getFechaPublicable())){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    	} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionForzada(true);
    	} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    		dtoCambioEstadoPublicacion.setOcultacionForzada(true);
    	} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    		dtoCambioEstadoPublicacion.setOcultacionPrecio(true);
    	}else if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionForzada(true);
    		dtoCambioEstadoPublicacion.setOcultacionPrecio(true);
    	} else if(DDEstadoPublicacion.CODIGO_DESPUBLICADO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setDespublicacionForzada(true);
    	} else if(DDEstadoPublicacion.CODIGO_NO_PUBLICADO.equals(estadoPublicacion.getCodigo())){
    		//Se quedaría todo a false en este estado
    	}

    	return dtoCambioEstadoPublicacion;
    }

    @Override
    @Deprecated
    @Transactional(readOnly = false)
    public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion) throws SQLException, JsonViewerException { // TODO: eliminar.
    	return publicacionChangeState(dtoCambioEstadoPublicacion, null);
    }

    @Override
    @Transactional(readOnly = false)
    public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion, DtoPublicacionValidaciones dtoValidacionesPublicacion) throws SQLException, JsonViewerException{  // TODO: eliminar.
    	Boolean OkPublicacionSinPublicar= false;
    	Boolean publicacionForzadaSinOrdinario= false;
		Activo activo = activoApi.get(dtoCambioEstadoPublicacion.getIdActivo());
		Filter filtro = null;
		DDEstadoPublicacion estadoPublicacionActual = null;
		String motivo = null;


		//Para hacer un cambio en estados de publicacion es necesario saber que validaciones es necesario aplicar
		//Si no se indicaron por parametro, por defecto se aplican todas las validaciones de publicacion
		if(Checks.esNulo(dtoValidacionesPublicacion) || Checks.esNulo(dtoValidacionesPublicacion.getActivo())){
			dtoValidacionesPublicacion = new DtoPublicacionValidaciones(); // Todas las condiciones necesarias para T. de publicacion
			dtoValidacionesPublicacion.setActivo(activo);
			dtoValidacionesPublicacion.setValidacionesTodas();
		}

		boolean cumpleCondicionesPublicar = verificaValidacionesPublicacion(dtoValidacionesPublicacion);

		//Iniciativa: Si el activo no tuviera estado de publicación (null), debe tomarse como "NO PUBLICADO"
		estadoPublicacionActual = activo.getEstadoPublicacion();
		if(Checks.esNulo(estadoPublicacionActual)){
			estadoPublicacionActual = (DDEstadoPublicacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacion.class, DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
		}

		// PUBLICACION OCULTA
		if(!Checks.esNulo(dtoCambioEstadoPublicacion.getOcultacionForzada()) && dtoCambioEstadoPublicacion.getOcultacionForzada()) { // Publicación oculto.
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO);
			motivo = getMotivo(dtoCambioEstadoPublicacion);

		// PUBLICACION PRECIO OCULTO
		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getOcultacionPrecio()) && dtoCambioEstadoPublicacion.getOcultacionPrecio()) { // Publicación precio oculto.
			// DE PUBLICACION FORZADA
			if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(estadoPublicacionActual.getCodigo())){ // Si viene de publicación forzada.
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO);
			// DE PUBLICACION ORDINARIA
			} else if(estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO) || estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO)){
				if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionForzada()) && !dtoCambioEstadoPublicacion.getPublicacionForzada())
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
			} else {
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO);
			}
			motivo = getMotivo(dtoCambioEstadoPublicacion);

			if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) && !dtoCambioEstadoPublicacion.getPublicacionOrdinaria() && Checks.esNulo(filtro)){
				activo.setFechaPublicable(null);
				activoApi.saveOrUpdate(activo);
				publicacionForzadaSinOrdinario= true;
				//OkPublicacionSinPublicar= true;
			}
			if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) && dtoCambioEstadoPublicacion.getPublicacionOrdinaria() && Checks.esNulo(filtro)){
				activo.setFechaPublicable(new Date());
				activoApi.saveOrUpdate(activo);
				publicacionForzadaSinOrdinario= true;
				//OkPublicacionSinPublicar= true;
			}

		// DESOCULTAR PRECIO
		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getDesOcultacionPrecio()) && dtoCambioEstadoPublicacion.getDesOcultacionPrecio()){
			if(!Checks.esNulo(activo.getEstadoPublicacion())){
				if(activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO)){
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO);
					motivo = getMotivo(dtoCambioEstadoPublicacion);
				}else if(activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO)){
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO);
					motivo = getMotivo(dtoCambioEstadoPublicacion);
				}
			}

		// DESPUBLICACION FORZADA
		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getDespublicacionForzada()) && dtoCambioEstadoPublicacion.getDespublicacionForzada()) { // Despublicación forzada.
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_DESPUBLICADO);
			motivo = getMotivo(dtoCambioEstadoPublicacion);

		// PUBLICACION FORZADA
		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionForzada()) && dtoCambioEstadoPublicacion.getPublicacionForzada()) { // Publicación forzada.
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO);
			motivo = getMotivo(dtoCambioEstadoPublicacion);
			if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) && !dtoCambioEstadoPublicacion.getPublicacionOrdinaria()){
				activo.setFechaPublicable(null);
				activoApi.saveOrUpdate(activo);
			}
			if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) && dtoCambioEstadoPublicacion.getPublicacionOrdinaria()){
				activo.setFechaPublicable(new Date());
				activoApi.saveOrUpdate(activo);
			}


		// PUBLICACION ORDINARIA
		} else if (!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionOrdinaria())
				&& dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) { // Publicación
																			// ordinaria.

			if (Checks.esNulo(activo.getFechaPublicable())) {
				activo.setFechaPublicable(new Date());
				activoApi.saveOrUpdate(activo);
				OkPublicacionSinPublicar= true;
			}

			//HREOS-3710
			//Si el campo del dto Ocultacion Forzada llega a false es que viene del metodo desocultarActivoOferta
			if(!Checks.esNulo(dtoCambioEstadoPublicacion.getOcultacionForzada()) && !dtoCambioEstadoPublicacion.getOcultacionForzada()){
				ActivoHistoricoEstadoPublicacion ultimoHistoricoPublicacion = activoApi.getUltimoHistoricoEstadoPublicacion(dtoCambioEstadoPublicacion.getIdActivo());
				if(!Checks.esNulo(activo.getEstadoPublicacion()) && !Checks.esNulo(ultimoHistoricoPublicacion) &&
						DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(activo.getEstadoPublicacion().getCodigo())) {
					ActivoHistoricoEstadoPublicacion penultimoHistoricoPublicacion = activoApi.getPenultimoHistoricoEstadoPublicacion(dtoCambioEstadoPublicacion.getIdActivo());

					if(!Checks.esNulo(penultimoHistoricoPublicacion)){
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", penultimoHistoricoPublicacion.getEstadoPublicacion().getCodigo());
					}
					motivo = getMotivo(dtoCambioEstadoPublicacion);
				}
			}
			else{

			if(DDEstadoPublicacion.CODIGO_DESPUBLICADO.equals(activo.getEstadoPublicacion().getCodigo())){
			// Si se publica por primera vez (no historico) o el estado anterior
			// no era ya "publicado ordinario"
			// Si cumple condiciones de publicar, se publica el activo en el
			// ultimo estado en que se encontraba
			// (ordinario, oculto, precio oculto)
			ActivoHistoricoEstadoPublicacion ultimoHistoricoPublicado = activoApi
					.getUltimoHistoricoEstadoPublicado(dtoCambioEstadoPublicacion.getIdActivo());

			// Ultimo historico: PUBLICADO ORDINARIO ó NO hay historico
			if (Checks.esNulo(ultimoHistoricoPublicado) || DDEstadoPublicacion.CODIGO_PUBLICADO
					.equals(ultimoHistoricoPublicado.getEstadoPublicacion().getCodigo())) {
				// Si el activo NO tenia "Fecha publicable"(indicador), se
				// le asigna una
				// Se marca el activo con el indicador de publicable porque
				// va a publicarse

				if (cumpleCondicionesPublicar) {


					// Ademas, se publica el activo lanzando el procedure para
					// este
					publicarActivoProcedure(activo.getId(), genericAdapter.getUsuarioLogado().getNombre(), null);

					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO); // Cambiar
																															// estado
																															// activo
					motivo = getMotivo(dtoCambioEstadoPublicacion);
					OkPublicacionSinPublicar= false;
					// Si en publicacion ordinaria no se cumplen condiciones,
					// devuelve error
				}
				else{
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
				}

				// Ultimo historico: PUBLICADO OCULTO o PUBLICADO PRECIO OCULTO
			} else {

				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
						ultimoHistoricoPublicado.getEstadoPublicacion().getCodigo());
				motivo = getMotivo(dtoCambioEstadoPublicacion);
			}

			// NO PUBLICADO: Deseleccionada cualquier opción DTO (ni ordinaria,
			// ni forzada, ni precio oculto, ni despublicar).
			}
			else{
				if(DDEstadoPublicacion.CODIGO_NO_PUBLICADO.equals(activo.getEstadoPublicacion().getCodigo())){
					// Si cumple condiciones de publicar o ya estaba como Publicable, se publica el activo
					if(cumpleCondicionesPublicar && !Checks.esNulo(activo.getFechaPublicable())){
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO); // Cambiar estado activo obligatoriamente.
						motivo = dtoCambioEstadoPublicacion.getMotivoPublicacion();

						// Ademas, se publica el activo lanzando el procedure para este
						OkPublicacionSinPublicar= false;
					} else {
					// Si no cumple condiciones, se pasa a NO PUBLICADO
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
						if (Checks.esNulo(activo.getFechaPublicable())) {
							activo.setFechaPublicable(new Date());
							activoApi.saveOrUpdate(activo);
						}
					}
				}
				else if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(activo.getEstadoPublicacion().getCodigo()) ||
						DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO.equals(activo.getEstadoPublicacion().getCodigo())){

					if(cumpleCondicionesPublicar && !Checks.esNulo(activo.getFechaPublicable())){
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO); // Cambiar estado activo obligatoriamente.
						motivo = getMotivo(dtoCambioEstadoPublicacion);

					} else {
					// Si no cumple condiciones, se pasa a NO PUBLICADO
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
					}

				}
				else if(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(activo.getEstadoPublicacion().getCodigo()) ||
						DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO.equals(activo.getEstadoPublicacion().getCodigo())){

					if(cumpleCondicionesPublicar && !Checks.esNulo(activo.getFechaPublicable())){
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO); // Cambiar estado activo obligatoriamente.
						motivo = getMotivo(dtoCambioEstadoPublicacion);

					}

				}

			}
			}
		} else {
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
			activo.setFechaPublicable(null);
			activoApi.saveOrUpdate(activo);
			motivo = getMotivo(dtoCambioEstadoPublicacion);
		}

		if(OkPublicacionSinPublicar || publicacionForzadaSinOrdinario){
			return true;
		}
		else{
			if(filtro == null && dtoCambioEstadoPublicacion.getPublicacionOrdinaria()){
				return true;
			}else {
				// Cambia al NUEVO ESTADO DE PUBLICACION y REGISTRA EN EL HISTORICO DE PUBLICACION -------------
				return this.cambiarEstadoPublicacionAndRegistrarHistorico(activo, motivo, filtro, estadoPublicacionActual,
							dtoCambioEstadoPublicacion.getPublicacionForzada(), dtoCambioEstadoPublicacion.getPublicacionOrdinaria());
			}
		}
    }


    private String getMotivo(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion) {  // TODO: eliminar.
    	String motivo = null;
    	if(!Checks.esNulo(dtoCambioEstadoPublicacion.getMotivoPublicacion())) {
			motivo = dtoCambioEstadoPublicacion.getMotivoPublicacion();
		}else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getMotivoOcultacionPrecio())) {
			motivo = dtoCambioEstadoPublicacion.getMotivoOcultacionPrecio();
		}else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getMotivoOcultacionForzada())) {
			motivo = dtoCambioEstadoPublicacion.getMotivoOcultacionForzada();
		}else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getMotivoDespublicacionForzada())){
			motivo = dtoCambioEstadoPublicacion.getMotivoDespublicacionForzada();
		}else {
			motivo = "";
		}
    	return motivo;
    }

    /**
     * Cambia al NUEVO ESTADO DE PUBLICACION y REGISTRA EN EL HISTORICO DE PUBLICACION
     */
    @Override
    @Transactional(readOnly = false)
    public boolean cambiarEstadoPublicacionAndRegistrarHistorico(Activo activo, String motivo, Filter filtro, DDEstadoPublicacion estadoPublicacionActual, Boolean isPublicacionForzada,
                                                                 Boolean isPublicacionOrdinaria) throws SQLException, JsonViewerException{  // TODO: eliminar.

		// 1.) Comprueba si hay NUEVO ESTADO al que cambiar (filtro != null)
		if(!Checks.esNulo(filtro)){

	    	if(Checks.esNulo(estadoPublicacionActual))
				estadoPublicacionActual = (DDEstadoPublicacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacion.class, DDEstadoPublicacion.CODIGO_NO_PUBLICADO);

		// 2.) Comprueba si el NUEVO ESTADO al que cambiar es el MISMO QUE el ACTUAL
		//     Solo realiza cambios si el estado de cambio es distinto al actual
	    	if (Checks.esNulo(activo.getEstadoPublicacion()) || !estadoPublicacionActual.getCodigo().equals(filtro.getPropertyValue())){
	    		ActivoHistoricoEstadoPublicacion activoHistoricoEstadoPublicacion = new ActivoHistoricoEstadoPublicacion();
	    		DDEstadoPublicacion estadoPublicacion= null;

	    		// ANTERIOR <> ACTUAL
					estadoPublicacion = genericDao.get(DDEstadoPublicacion.class, filtro);
					activo.setEstadoPublicacion(estadoPublicacion);

					// Registra el cambio de estado de publicacion en el HISTORICO de PUBLICACION
					// - Debe registrar cualquier cambio de estado a excepcion del cambio a estado PUBLICADO
					//   el cual ya se ha registrado por el procedure de publicacion
					try {
						//if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(filtro.getPropertyValue())){
							// Si existen otros registros en historico
							ActivoHistoricoEstadoPublicacion ultimoHistorico = activoApi.getUltimoHistoricoEstadoPublicacion(activo.getId());
							if(!Checks.esNulo(ultimoHistorico) ){

								// Establecer la fecha de hoy en el campo 'Fecha Hasta' del anterior/último histórico y el usuario que lo ha modificado.
								// Situado al principio en caso de que todavía no existan historicos para el el Activo en concreto.
								if(!Checks.esNulo(ultimoHistorico)) {
									Date ahora = new Date(System.currentTimeMillis());
									ultimoHistorico.setFechaHasta(ahora);
									Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
									ultimoHistorico.getAuditoria().setUsuarioModificar(usuarioLogado.getUsername());
								}
							// Se registra en el historico por primera vez
							} else {
								activoHistoricoEstadoPublicacion.setEstadoPublicacion(estadoPublicacion);
							}

							// Calcula el DDPortal en relación a los condicionantes
							Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
							VCondicionantesDisponibilidad condicionantesDisponibilidad = (VCondicionantesDisponibilidad) genericDao.get(VCondicionantesDisponibilidad.class, filtroActivo);
							if(!Checks.esNulo(condicionantesDisponibilidad)) {
								if(!condicionantesDisponibilidad.getIsCondicionado()){
									activoHistoricoEstadoPublicacion.setPortal((DDPortal) utilDiccionarioApi.dameValorDiccionarioByCod(DDPortal.class, DDPortal.CODIGO_HAYA));
								} else {
									activoHistoricoEstadoPublicacion.setPortal((DDPortal) utilDiccionarioApi.dameValorDiccionarioByCod(DDPortal.class, DDPortal.CODIGO_INVERSORES));
								}
							} else {
								activoHistoricoEstadoPublicacion.setPortal((DDPortal) utilDiccionarioApi.dameValorDiccionarioByCod(DDPortal.class, DDPortal.CODIGO_HAYA));
							}



							activoHistoricoEstadoPublicacion.setActivo(activo);
							beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "motivo", motivo);
							beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "fechaDesde" , new Date());
							beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "estadoPublicacion", estadoPublicacion);
							if(filtro.getPropertyValue().equals(DDEstadoPublicacion.CODIGO_NO_PUBLICADO) ||
							   filtro.getPropertyValue().equals(DDEstadoPublicacion.CODIGO_DESPUBLICADO)){
								activoHistoricoEstadoPublicacion.setPortal(null);
							}


							if(!Checks.esNulo(isPublicacionForzada) && isPublicacionForzada) {
								Filter filtroTpu = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoPublicacion.CODIGO_FORZADA);
								DDTipoPublicacion tipoPublicacion = genericDao.get(DDTipoPublicacion.class, filtroTpu);
								beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "tipoPublicacion", tipoPublicacion);
							} else if(!Checks.esNulo(isPublicacionOrdinaria) && isPublicacionOrdinaria) {
								Filter filtroTpu = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoPublicacion.CODIGO_ORDINARIA);
								DDTipoPublicacion tipoPublicacion = genericDao.get(DDTipoPublicacion.class, filtroTpu);
								beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "tipoPublicacion", tipoPublicacion);
							}

							activoApi.saveOrUpdate(activo);
							genericDao.save(ActivoHistoricoEstadoPublicacion.class, activoHistoricoEstadoPublicacion);

						//} // Cierra if ... CODIGO_PUBLICADO.equals
					} catch (IllegalAccessException e) {
						logger.error(e);
						e.printStackTrace();
						throw new JsonViewerException("No ha sido posible realizar el cambio de publicación con este activo. Se ha producido un error interno.");
					} catch (InvocationTargetException e) {
						logger.error(e);
						e.printStackTrace();
						throw new JsonViewerException("No ha sido posible realizar el cambio de publicación con este activo. Se ha producido un error interno.");
					}
	    	}

		// filtro = null (Detectado un cambio de estado NO CONTROLADO (valores DTO no corresponden con nuevo estado))
		} else {
			throw new JsonViewerException("No ha sido posible realizar el cambio de publicación con este activo. Estado de publicación inexistente.");
		} // Cierra if(!Checks.esNulo(filtro))
		return true;
    }

	@Override
	public DtoDatosPublicacionActivo getDatosPublicacionActivo(Long idActivo) {
    	ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);
    	DtoDatosPublicacionActivo dto = activoPublicacionDao.convertirEntidadTipoToDto(activoPublicacion);
		dto.setPrecioWebVenta(activoValoracionDao.getImporteValoracionVentaWebPorIdActivo(idActivo));
		dto.setPrecioWebAlquiler(activoValoracionDao.getImporteValoracionRentaWebPorIdActivo(idActivo));
		DDAdecuacionAlquiler adecuacionAlquiler = activoPatrimonioDao.getAdecuacionAlquilerFromPatrimonioByIdActivo(idActivo);
		if(!Checks.esNulo(adecuacionAlquiler)) {
			dto.setAdecuacionAlquilerCodigo(adecuacionAlquiler.getCodigo());
		}
		dto.setTotalDiasPublicadoVenta(this.obtenerTotalDeDiasEnEstadoPublicadoVenta(idActivo));
		dto.setTotalDiasPublicadoAlquiler(this.obtenerTotalDeDiasEnEstadoPublicadoAlquiler(idActivo));
		dto.setDeshabilitarCheckPublicarVenta(this.deshabilitarCheckPublicarVenta(idActivo));
		dto.setDeshabilitarCheckOcultarVenta(this.deshabilitarCheckOcultarVenta(idActivo));
		dto.setDeshabilitarCheckPublicarAlquiler(this.deshabilitarCheckPublicarAlquiler(idActivo));
		dto.setDeshabilitarCheckOcultarAlquiler(this.deshabilitarCheckOcultarAlquiler(idActivo));

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
		return !isPublicable(idActivo) || !isComercializable(idActivo) || isVendido(idActivo) || isReservado(idActivo) || isPublicadoVenta(idActivo) || isOcultoVenta(idActivo) ||
				isFueraDePerimetro(idActivo) || (!isInformeAprobado(idActivo) && (!tienePrecioVenta(idActivo) && !isPublicarSinPrecioVentaActivado(idActivo)));
	}

	/**
	 * Este método calcula si el check de ocultar activo venta se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check de ocultar activo para la venta debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckOcultarVenta(Long idActivo) {
		return !isPublicable(idActivo) || !isComercializable(idActivo) || isVendido(idActivo) || !isPublicadoVenta(idActivo) || isOcultoAutomaticoVenta(idActivo) || isFueraDePerimetro(idActivo);
	}

	/**
	 * Este método calcula si el check de publicar activo alquiler se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check de publicar activo para el alquiler debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckPublicarAlquiler(Long idActivo) {
		return !isPublicable(idActivo) || !isComercializable(idActivo) || isVendido(idActivo) || isReservado(idActivo) || isPublicadoAlquiler(idActivo) || isOcultoAlquiler(idActivo) ||
				isFueraDePerimetro(idActivo) || (!isInformeAprobado(idActivo) && (!tienePrecioRenta(idActivo) && !isPublicarSinPrecioAlquilerActivado(idActivo)));
	}

	/**
	 * Este método calcula si el check de ocultar activo alquiler se ha de deshabilitar en base a unas reglas.
	 *
	 * @param idActivo: ID del activo del que obtener los datos para verificar las reglas.
	 * @return Devuelve True si el check de ocultar activo para el alquiler debe estar deshabilitado.
	 */
	private Boolean deshabilitarCheckOcultarAlquiler(Long idActivo) {
		return !isPublicable(idActivo) || !isComercializable(idActivo) || isVendido(idActivo) || !isPublicadoAlquiler(idActivo) || isOcultoAutomaticoAlquiler(idActivo) || isFueraDePerimetro(idActivo);
	}

	// Comprobación mínima.
	private Boolean isInformeAprobado(Long idActivo) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "idActivo", idActivo);
		VCondicionantesDisponibilidad vcd = genericDao.get(VCondicionantesDisponibilidad.class, filter);

		return !Checks.esNulo(vcd) && !vcd.getSinInformeAprobado();
	}

	// Comprobación mínima.
	private Boolean tienePrecioVenta(Long idActivo) {
		return !Checks.esNulo(activoValoracionDao.getImporteValoracionVentaWebPorIdActivo(idActivo));
	}

	// Comprobación mínima.
	private Boolean tienePrecioRenta(Long idActivo) {
		return !Checks.esNulo(activoValoracionDao.getImporteValoracionRentaWebPorIdActivo(idActivo));
	}

	// Comprobación mínima.
	private Boolean isPublicable(Long idActivo) {
    	PerimetroActivo perimetro = perimetroDao.getPerimetroActivoByIdActivo(idActivo);

    	return !Checks.esNulo(perimetro) && perimetro.getAplicaPublicar();
	}

	// Comprobación mínima.
	private Boolean isFueraDePerimetro(Long idActivo) {
		PerimetroActivo perimetro = perimetroDao.getPerimetroActivoByIdActivo(idActivo);

		return Checks.esNulo(perimetro) || perimetro.getIncluidoEnPerimetro() == 0;
	}

	// Comprobación mínima.
	private Boolean isComercializable(Long idActivo) {
		PerimetroActivo perimetro = perimetroDao.getPerimetroActivoByIdActivo(idActivo);

		return !Checks.esNulo(perimetro) && perimetro.getAplicaComercializar() == 1;

	}

	// Comprobación mínima.
	private Boolean isVendido(Long idActivo) {
    	Activo activo = activoDao.get(idActivo);
		Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(activoDao.get(idActivo));

		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			if(DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())) {
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
			return !Checks.esNulo(expediente.getReserva()) && DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo());
		}

		return false;
	}

	// Comprobación mínima.
	private Boolean isPublicarSinPrecioVentaActivado(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && activoPublicacion.getCheckSinPrecioVenta();
	}

	// Comprobación mínima.
	private Boolean isPublicarSinPrecioAlquilerActivado(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && activoPublicacion.getCheckSinPrecioAlquiler();
	}

	// Comprobación mínima.
	private Boolean isPublicadoVenta(Long idActivo) {
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);

		return !Checks.esNulo(activoPublicacion) && !Checks.esNulo(activoPublicacion.getEstadoPublicacionVenta()) &&
				(DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA.equals(activoPublicacion.getEstadoPublicacionVenta().getCodigo())
						|| DDEstadoPublicacionVenta.CODIGO_OCULTO_VENTA.equals(activoPublicacion.getEstadoPublicacionVenta().getCodigo()));
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
				(DDEstadoPublicacionAlquiler.CODIGO_PUBLICADO_ALQUILER.equals(activoPublicacion.getEstadoPublicacionAlquiler().getCodigo())
				|| DDEstadoPublicacionAlquiler.CODIGO_OCULTO_ALQUILER.equals(activoPublicacion.getEstadoPublicacionAlquiler().getCodigo()));
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

	// Comprobación mínima.
	private Boolean isInformeComercialTiposIguales(Long idActivo) {
		Activo activo = activoDao.get(idActivo);

		return !activoApi.checkTiposDistintos(activo);
	}

	@Override
	@Transactional
	public Boolean setDatosPublicacionActivo(DtoDatosPublicacionActivo dto) throws JsonViewerException{
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(dto.getIdActivo());

		if(this.registrarHistoricoPublicacion(activoPublicacion, dto)) {
			if(this.actualizarDatosEstadoActualPublicacion(dto, activoPublicacion)) {
				return this.publicarActivoProcedure(dto.getIdActivo(), genericAdapter.getUsuarioLogado().getUsername(), dto.getEleccionUsuarioTipoPublicacionAlquiler());
			}
		}

		return false;
	}

	@Override
	@Transactional
	public Boolean setDatosPublicacionAgrupacion(Long id, DtoDatosPublicacionActivo dto) throws JsonViewerException{
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();

		for(ActivoAgrupacionActivo aga : activos) {
			ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(aga.getActivo().getId());
			if(this.registrarHistoricoPublicacion(activoPublicacion, dto)) {
				this.actualizarDatosEstadoActualPublicacion(dto, activoPublicacion);
			}
		}

		activoDao.publicarAgrupacionSinHistorico(id, genericAdapter.getUsuarioLogado().getUsername(), dto.getEleccionUsuarioTipoPublicacionAlquiler());
		return true;
	}

	@Override
	public Boolean isPublicadoVentaByIdActivo(Long idActivo) {
		return this.isPublicadoVenta(idActivo);
	}

	@Override
	public void validarPublicacionTramiteYPublicar(Long idActivo) {
		if(this.isAdmisionOK(idActivo) && this.isGestionOK(idActivo) && this.tienePrecioVenta(idActivo) && this.isInformeComercialTiposIguales(idActivo)) {
			DtoDatosPublicacionActivo dto = new DtoDatosPublicacionActivo();
			dto.setIdActivo(idActivo);
			dto.setPublicarVenta(true);
			this.setDatosPublicacionActivo(dto);
		}
	}

	/**
	 * Este método actualiza el registro del estado actual de publicación del activo con los datos del dto
	 * que se recibe.
	 *
	 * @param dto : dto con los datos a guardar en el estado actual de publicación.
	 * @param activoPublicacion : entidad del estado actual de publicación en la que persistir los datos nuevos.
	 * @return Devuelve True si el proceso ha sido satisfactorio, False si no lo ha sido.
	 */
	private Boolean actualizarDatosEstadoActualPublicacion(DtoDatosPublicacionActivo dto, ActivoPublicacion activoPublicacion) {
		try {
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


			if(!Checks.esNulo(dto.getMotivoOcultacionVentaCodigo()) || !Checks.esNulo(dto.getMotivoOcultacionManualVenta()) || !Checks.esNulo(dto.getPublicarVenta()) ||
					!Checks.esNulo(dto.getOcultarVenta()) || !Checks.esNulo(dto.getPublicarSinPrecioVenta()) || !Checks.esNulo(dto.getNoMostrarPrecioVenta())) {
				activoPublicacion.setFechaInicioVenta(new Date());
			}

			if(!Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo()) || !Checks.esNulo(dto.getMotivoOcultacionManualAlquiler()) || !Checks.esNulo(dto.getPublicarAlquiler()) ||
					!Checks.esNulo(dto.getOcultarAlquiler()) || !Checks.esNulo(dto.getPublicarSinPrecioAlquiler()) || !Checks.esNulo(dto.getNoMostrarPrecioAlquiler())) {
				activoPublicacion.setFechaInicioAlquiler(new Date());
			}

			activoPublicacionDao.save(activoPublicacion);

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
		ActivoPublicacionHistorico activoPublicacionHistorico = new ActivoPublicacionHistorico();

		try {
			beanUtilNotNull.copyProperties(activoPublicacionHistorico, activoPublicacion);

			if(Arrays.asList(DDTipoComercializacion.CODIGOS_VENTA).contains(activoPublicacion.getTipoComercializacion().getCodigo()) &&
					(!Checks.esNulo(dto.getMotivoOcultacionVentaCodigo()) || !Checks.esNulo(dto.getMotivoOcultacionManualVenta()) || !Checks.esNulo(dto.getPublicarVenta()) ||
					!Checks.esNulo(dto.getOcultarVenta()) || !Checks.esNulo(dto.getPublicarSinPrecioVenta()) || !Checks.esNulo(dto.getNoMostrarPrecioVenta()))) {
				activoPublicacionHistorico.setFechaFinVenta(new Date());
			}

			if(Arrays.asList(DDTipoComercializacion.CODIGOS_ALQUILER).contains(activoPublicacion.getTipoComercializacion().getCodigo()) &&
					(!Checks.esNulo(dto.getMotivoOcultacionAlquilerCodigo()) || !Checks.esNulo(dto.getMotivoOcultacionManualAlquiler()) || !Checks.esNulo(dto.getPublicarAlquiler()) ||
					!Checks.esNulo(dto.getOcultarAlquiler()) || !Checks.esNulo(dto.getPublicarSinPrecioAlquiler()) || !Checks.esNulo(dto.getNoMostrarPrecioAlquiler()))) {
				activoPublicacion.setFechaInicioAlquiler(new Date());
			}

		} catch (IllegalAccessException e) {
			logger.error("Error al registrar en el historico el estado actual de publicacion, error: ", e);
			return false;
		} catch (InvocationTargetException e) {
			logger.error("Error al registrar en el historico el estado actual de publicacion, error: ", e);
			return false;
		}

		activoPublicacionHistoricoDao.save(activoPublicacionHistorico);

		return true;
	}

	/**
	 * Este método suma el total de días que ha estado un activo publicado para el tipo comercial venta.
	 * Los días obtenidos son referentes a los periodos que ha estado el activo en el estado publicado.
	 * La suma incluye los días de estados anteriores, histórico, y el estado actual, si éste es publicado.
	 *
	 * @param idActivo: ID del activo para obtener los días.
	 * @return Devuelve el total de días que ha estado el activo publicado.
	 */
	private Integer obtenerTotalDeDiasEnEstadoPublicadoVenta(Long idActivo) {
		Integer dias = 0;

		dias = dias + activoPublicacionHistoricoDao.getTotalDeDiasEnEstadoPublicadoVentaPorIdActivo(idActivo);
		dias = dias + activoPublicacionDao.getDiasEnEstadoActualPublicadoVentaPorIdActivo(idActivo);

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
	private Integer obtenerTotalDeDiasEnEstadoPublicadoAlquiler(Long idActivo) {
		Integer dias = 0;

		dias = dias + activoPublicacionHistoricoDao.getTotalDeDiasEnEstadoPublicadoAlquilerPorIdActivo(idActivo);
		dias = dias + activoPublicacionDao.getDiasEnEstadoActualPublicadoAlquilerPorIdActivo(idActivo);

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
		if(activoDao.publicarActivoSinHistorico(idActivo, username, eleccionUsuarioTipoPublicacionAlquiler)) {
			logger.info(messageServices.getMessage("activo.publicacion.OK.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
			return true;
		} else {
			logger.error(messageServices.getMessage("activo.publicacion.error.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
			throw new JsonViewerException(messageServices.getMessage("activo.publicacion.error.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
		}
	}

	private boolean verificaValidacionesPublicacion(DtoPublicacionValidaciones dtoPublicacionValidaciones){  // TODO: eliminar.
		if(!Checks.esNulo(dtoPublicacionValidaciones) && !Checks.esNulo(dtoPublicacionValidaciones.getActivo())){
			boolean tieneOkAdmision = Checks.esNulo(dtoPublicacionValidaciones.getActivo().getAdmision()) ? false :  dtoPublicacionValidaciones.getActivo().getAdmision(); // Tiene OK de admision
			boolean tieneOkGestion = Checks.esNulo(dtoPublicacionValidaciones.getActivo().getGestion()) ? false :  dtoPublicacionValidaciones.getActivo().getGestion(); // Tiene OK de gestion
			Boolean tieneOkPrecios = activoApi.getDptoPrecio(dtoPublicacionValidaciones.getActivo()); // Tiene OK de precios
			boolean tieneInfComercialTiposIguales = !activoApi.checkTiposDistintos(dtoPublicacionValidaciones.getActivo()); // Tipos activo Inf. comercial iguales
			boolean tieneInfComercialAceptado = activoApi.isInformeComercialAceptado(dtoPublicacionValidaciones.getActivo()); // Tiene Inf. comercial aceptado
			if(Checks.esNulo(tieneOkGestion) || Checks.esNulo(tieneOkAdmision) || Checks.esNulo(tieneOkPrecios) || Checks.esNulo(tieneInfComercialAceptado)
					|| Checks.esNulo(tieneInfComercialTiposIguales))
				return false;
			return
					(!dtoPublicacionValidaciones.isValidarOKGestion() || tieneOkGestion) &&
					(!dtoPublicacionValidaciones.isValidarOKAdmision() || tieneOkAdmision) &&
					(dtoPublicacionValidaciones.isValidarOKPrecio() ? tieneOkPrecios : true) &&
					(!dtoPublicacionValidaciones.isValidarInfComercialTiposIguales() || tieneInfComercialTiposIguales) &&
					(!dtoPublicacionValidaciones.isValidarInfComercialAceptado() || tieneInfComercialAceptado);
		}

		return false;
	}

	@Override
	public DtoDatosPublicacionActivo getPublicarSinPrecioVentaAlquilerByIdActivo(Long idActivo){
		ActivoPublicacion activoPublicacion = activoPublicacionDao.getActivoPublicacionPorIdActivo(idActivo);
		DtoDatosPublicacionActivo dto = new DtoDatosPublicacionActivo();

		if(!Checks.esNulo(activoPublicacion)){
			dto.setPublicarSinPrecioVenta(activoPublicacion.getCheckSinPrecioVenta());
			dto.setPublicarSinPrecioAlquiler(activoPublicacion.getCheckSinPrecioAlquiler());
		}

		return dto;
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
		boolean esVivienda = DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo());

		for(DtoAdmisionDocumento aListDtoAdmisionDocumento : listDtoAdmisionDocumento) {
			if (DDTipoDocumentoActivo.CODIGO_CEE.equals(aListDtoAdmisionDocumento.getCodigoTipoDocumentoActivo())) {
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
	public Integer getEstadoIndicadorPublicacionAgrupacionVenta(List<ActivoAgrupacionActivo> listaActivos) {
		Integer estado = 0;

		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Activo activo = listaActivo.getActivo();

			if (getEstadoIndicadorPublicacionVenta(activo) == 0) {
				estado = ESTADO_PUBLICACION_NARANJA;
				break;
			} else if (getEstadoIndicadorPublicacionVenta(activo) == 2) {
				estado = ESTADO_PUBLICACION_AMARILLO;
			} else if (getEstadoIndicadorPublicacionVenta(activo) == 1 && !ESTADO_PUBLICACION_AMARILLO.equals(estado)) {
				estado = ESTADO_PUBLICACION_AZUL;
			}
		}

		return estado;
	}

	@Override
	public Integer getEstadoIndicadorPublicacionAgrupacionAlquiler(List<ActivoAgrupacionActivo> listaActivos) {
		Integer estado = 0;

		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Activo activo = listaActivo.getActivo();

			if (getEstadoIndicadorPublicacionAlquiler(activo) == 0) {
				estado = ESTADO_PUBLICACION_NARANJA;
				break;
			} else if (getEstadoIndicadorPublicacionAlquiler(activo) == 2) {
				estado = ESTADO_PUBLICACION_AMARILLO;
			} else if (getEstadoIndicadorPublicacionAlquiler(activo) == 1 && !ESTADO_PUBLICACION_AMARILLO.equals(estado)) {
				estado = ESTADO_PUBLICACION_AZUL;
			}
		}

		return estado;
	}

	@Override
	public Boolean getCheckPublicacionDeshabilitarAgrupacionVenta(List<ActivoAgrupacionActivo> listaActivos) {
		boolean checkPublicarVenta = false;

		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Long activoid = listaActivo.getActivo().getId();

			if (!Checks.esNulo(deshabilitarCheckPublicarVenta(activoid))) {
				if (deshabilitarCheckPublicarVenta(activoid)) {
					checkPublicarVenta = true;
					break;

				} else {
					return checkPublicarVenta;
				}
			}
		}

		return checkPublicarVenta;
	}

	@Override
	public Boolean getCheckOcultarDeshabilitarAgrupacionVenta(List<ActivoAgrupacionActivo> listaActivos) {
  		boolean checkOcultarVenta = false;

		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Long activoid = listaActivo.getActivo().getId();

			if (!Checks.esNulo(deshabilitarCheckOcultarVenta(activoid))) {
				if (deshabilitarCheckOcultarVenta(activoid)) {
					checkOcultarVenta = true;
					break;

				} else {
					return checkOcultarVenta;
				}
			}
		}

		return checkOcultarVenta;
	}

	@Override
	public Boolean getCheckPublicacionDeshabilitarAgrupacionAlquiler(List<ActivoAgrupacionActivo> listaActivos) {
  		boolean checkPublicarAlquiler = false;

		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Long activoid = listaActivo.getActivo().getId();

			if (!Checks.esNulo(deshabilitarCheckPublicarAlquiler(activoid))) {
				if (deshabilitarCheckPublicarAlquiler(activoid)) {
					checkPublicarAlquiler = true;
					break;

				} else {
					return checkPublicarAlquiler;
				}
			}
		}

		return checkPublicarAlquiler;
	}

	@Override
	public Boolean getCheckOcultarDeshabilitarAgrupacionAlquiler(List<ActivoAgrupacionActivo> listaActivos) {
  		boolean checkOcultarAlquiler = false;

		for (ActivoAgrupacionActivo listaActivo : listaActivos) {
			Long activoid = listaActivo.getActivo().getId();

			if (!Checks.esNulo(deshabilitarCheckOcultarAlquiler(activoid))) {
				if (deshabilitarCheckOcultarAlquiler(activoid)) {
					checkOcultarAlquiler = true;
					break;

				} else {
					return checkOcultarAlquiler;
				}
			}
		}

		return checkOcultarAlquiler;
	}

	@Override
	public Boolean tienePrecioVentaByIdActivo(Long idActivo) {
		return this.tienePrecioVenta(idActivo);
	}

	@Override
	public Boolean tienePrecioRentaByIdActivo(Long idActivo) {
		return this.tienePrecioRenta(idActivo);
	}
}