package es.pfsgroup.plugin.rem.api.impl;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.InvalidDataAccessResourceUsageException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
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
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDPortal;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPublicacion;
import es.pfsgroup.plugin.rem.validate.validator.DtoPublicacionValidaciones;

@Service("activoEstadoPublicacionManager")
public class ActivoEstadoPublicacionManager implements ActivoEstadoPublicacionApi{
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);

	@Resource
	private MessageService messageServices;
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired 
	private ActivoDao activoDao;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
    
    public DtoCambioEstadoPublicacion getState(Long idActivo){
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
    @Transactional(readOnly = false)

    
    public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion) throws SQLException, JsonViewerException {
    	return publicacionChangeState(dtoCambioEstadoPublicacion, null);
    }
    		
    @Override
    @Transactional(readOnly = false)
    public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion, DtoPublicacionValidaciones dtoValidacionesPublicacion) throws SQLException, JsonViewerException{
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
						DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(activo.getEstadoPublicacion().getCodigo())){
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
					publicarActivoProcedure(activo.getId(), genericAdapter.getUsuarioLogado().getNombre());

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
				//else {
//					new JsonViewerException(
//							"No es posible publicar el activo. Revise condiciones (Gestion, Admision, Inf. Comercial, Precio venta Web)");
//					return false;
//				}

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
						//publicarActivoProcedure(activo.getId(), genericAdapter.getUsuarioLogado().getNombre());
					} else {
					// Si no cumple condiciones, se pasa a NO PUBLICADO
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
						if (Checks.esNulo(activo.getFechaPublicable())) {
							activo.setFechaPublicable(new Date());
							activoApi.saveOrUpdate(activo);
						}
					}
				}
				else if(/*DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(activo.getEstadoPublicacion().getCodigo()) || 
						DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO.equals(activo.getEstadoPublicacion().getCodigo()) ||*/
						DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(activo.getEstadoPublicacion().getCodigo()) ||
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
			
			// Si cumple condiciones de publicar o ya estaba como Publicable, se publica el activo
//			if(cumpleCondicionesPublicar && !Checks.esNulo(activo.getFechaPublicable())){
//				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO); // Cambiar estado activo obligatoriamente.
//				motivo = dtoCambioEstadoPublicacion.getMotivoPublicacion();
//				
//				// Ademas, se publica el activo lanzando el procedure para este
//				publicarActivoProcedure(activo.getId(), genericAdapter.getUsuarioLogado().getNombre());
//			} else {
//			// Si no cumple condiciones, se pasa a NO PUBLICADO
//				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
//				activo.setFechaPublicable(null);
//				activoApi.saveOrUpdate(activo);
//			}
		}

		
		if(OkPublicacionSinPublicar || publicacionForzadaSinOrdinario){
			return true;
		}
		else{
			if(filtro == null && dtoCambioEstadoPublicacion.getPublicacionOrdinaria()){
				//filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO);
				return true;
			}else {
				// Cambia al NUEVO ESTADO DE PUBLICACION y REGISTRA EN EL HISTORICO DE PUBLICACION -------------
				return this.cambiarEstadoPublicacionAndRegistrarHistorico(activo, motivo, filtro, estadoPublicacionActual, 
							dtoCambioEstadoPublicacion.getPublicacionForzada(), dtoCambioEstadoPublicacion.getPublicacionOrdinaria());
			}
		}
    }
    
    
    private String getMotivo(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion) {
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
    public boolean cambiarEstadoPublicacionAndRegistrarHistorico(Activo activo, String motivo, Filter filtro, DDEstadoPublicacion estadoPublicacionActual,
    			Boolean isPublicacionForzada, Boolean isPublicacionOrdinaria) throws SQLException, JsonViewerException{
    	
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
								/*if(!condicionantesDisponibilidad.getRuina() &&
										!condicionantesDisponibilidad.getPendienteInscripcion() &&
										!condicionantesDisponibilidad.getObraNuevaSinDeclarar() &&
										!condicionantesDisponibilidad.getSinTomaPosesionInicial() &&
										!condicionantesDisponibilidad.getProindiviso() &&
										!condicionantesDisponibilidad.getObraNuevaEnConstruccion() &&
										!condicionantesDisponibilidad.getOcupadoConTitulo() &&
										!condicionantesDisponibilidad.getTapiado() &&
										!condicionantesDisponibilidad.getPortalesExternos() &&
										!condicionantesDisponibilidad.getOcupadoSinTitulo() &&
										!condicionantesDisponibilidad.getDivHorizontalNoInscrita()) {*/
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
	public DtoCambioEstadoPublicacion getHistoricoEstadoPublicacionByActivo(Long id) {
		DtoCambioEstadoPublicacion dto = new DtoCambioEstadoPublicacion();
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
		Order order = new Order(OrderType.DESC, "id");
		Activo activo = activoApi.get(id);
		List<ActivoHistoricoEstadoPublicacion> list = genericDao.getListOrdered(ActivoHistoricoEstadoPublicacion.class, order, filtroActivo, filtroBorrado);
		if(!Checks.estaVacio(list)){
			// Obtener el último estado o estado actual.
			ActivoHistoricoEstadoPublicacion activoHistoricoEstadoPublicacion = list.get(0);
			String tipoPublicacionInicial = null;

			// Obtener el tipo de publicación de la que viene, si la hubiera, y su motivo si viene de publicación forzada.
			for(ActivoHistoricoEstadoPublicacion estado: list){

				if(!Checks.esNulo(estado.getEstadoPublicacion()) && DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(estado.getEstadoPublicacion().getCodigo())) {
					tipoPublicacionInicial = DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO;
					dto.setMotivoPublicacion(estado.getMotivo());
					break;
				} else if(!Checks.esNulo(estado.getEstadoPublicacion()) && DDEstadoPublicacion.CODIGO_PUBLICADO.equals(estado.getEstadoPublicacion().getCodigo())) {
					tipoPublicacionInicial = DDEstadoPublicacion.CODIGO_PUBLICADO;
					break;
				}
				
			}
			
			if(!Checks.esNulo(activoHistoricoEstadoPublicacion)){
				dto.setActivo(id);
				if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getEstadoPublicacion())){
					if(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())){
						dto.setOcultacionForzada(true);
						dto.setPublicacionOrdinaria(true); // Se marca este check para indicar de que estado inicial viene.
						if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getMotivo())){
							dto.setMotivoOcultacionForzada(activoHistoricoEstadoPublicacion.getMotivo());
						}
					} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo()) ||
							DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())) {
						dto.setOcultacionPrecio(true);
						
						if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(tipoPublicacionInicial)){
							dto.setPublicacionOrdinaria(true); // Se marca este check para indicar de que estado inicial viene.
						} else {
							dto.setPublicacionForzada(true); // Se marca este check para indicar de que estado inicial viene.
							// Si estaba activado el indicador de publicable, tambien debe activarse publicacion ordinaria
							if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getFechaPublicable())){
								dto.setPublicacionOrdinaria(true);
							}
						}
						
						if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getMotivo())){
							dto.setMotivoOcultacionPrecio(activoHistoricoEstadoPublicacion.getMotivo());
						}
						// El campo observaciones está en el funcional pero no en la DDBB.
						//if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getObservaciones())) {
							//dto.setObservaciones(activoHistoricoEstadoPublicacion.getObservaciones());
						//}
					} else if(DDEstadoPublicacion.CODIGO_DESPUBLICADO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())) {
						dto.setDespublicacionForzada(true);
						dto.setPublicacionOrdinaria(true); // Se marca este check para indicar de que estado inicial viene.
						
					} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())) {
						dto.setPublicacionForzada(true);
						if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getMotivo())){
							dto.setMotivoPublicacion(activoHistoricoEstadoPublicacion.getMotivo());
						}
						// Si estaba activado el indicador de publicable, tambien debe activarse publicacion ordinaria
						if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getFechaPublicable())){
							dto.setPublicacionOrdinaria(true);
						}
					} else if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())) {
						dto.setPublicacionOrdinaria(true);
						if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getMotivo())){
							dto.setMotivoPublicacion(activoHistoricoEstadoPublicacion.getMotivo());
						}
					}
				}
			}
		}// else {
			// Si la lista de historico viene vacia, aun así, comprobar la fecha de publicación del activo. Si está rellena poner estado publicación ordinaria.
			if(!Checks.esNulo(activo.getFechaPublicable())) {
				dto.setPublicacionOrdinaria(true);
			}
		//}

		return dto;
	}
	
	private boolean publicarActivoProcedure(Long idActivo, String username) throws SQLException, JsonViewerException{

		int esError = activoDao.publicarActivo(idActivo, username);
		if (esError != 1){
			logger.error(messageServices.getMessage("activo.publicacion.error.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
			throw new SQLException(messageServices.getMessage("activo.publicacion.error.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
		}
		
		logger.info(messageServices.getMessage("activo.publicacion.OK.publicar.ordinario.server").concat(" ").concat(String.valueOf(idActivo)));
		return true;
		
	}
	
	@Override
	public String getMensajeExceptionProcedure(InvalidDataAccessResourceUsageException e){
		
		// En este tipo de excepción se pueden esconder errores del procedure de BBDD de publicacion ACTIVO_PUBLICACION_AUTO
		// Hay que mostrar un mensaje de error concreto para uno de los errores (no cumplir condiciones para publicar)
		Throwable causa = e.getCause();
		String mensajeError = null;
		int contador = 0;
		while (!Checks.esNulo(causa) && Checks.esNulo(mensajeError) && contador < 100){
			if(causa.getMessage().contains("ACTIVO_PUBLICACION_AUTO") && causa.getMessage().contains("ORA-06510")){
				mensajeError = messageServices.getMessage("activo.publicacion.KO.condiciones.publicar.ordinario.server"); 
			}
			causa = causa.getCause();
			contador++;
		}

		// Para el resto de errores, se muestra un mensaje generico
		if(Checks.esNulo(mensajeError))
			mensajeError = messageServices.getMessage("activo.publicacion.error.publicar.ordinario");

		return mensajeError;
	}
	
	public boolean verificaValidacionesPublicacion(DtoPublicacionValidaciones dtoPublicacionValidaciones){

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
					(dtoPublicacionValidaciones.isValidarOKGestion() ? tieneOkGestion : true) &&
					(dtoPublicacionValidaciones.isValidarOKAdmision() ? tieneOkAdmision : true) &&
					(dtoPublicacionValidaciones.isValidarOKPrecio() ? tieneOkPrecios : true) &&
					(dtoPublicacionValidaciones.isValidarInfComercialTiposIguales() ? tieneInfComercialTiposIguales : true) &&
					(dtoPublicacionValidaciones.isValidarInfComercialAceptado() ? tieneInfComercialAceptado : true);
		}
		return false;
	}
}