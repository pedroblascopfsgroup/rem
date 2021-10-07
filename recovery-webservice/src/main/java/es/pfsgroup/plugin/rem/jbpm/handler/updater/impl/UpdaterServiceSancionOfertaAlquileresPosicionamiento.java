package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoListadoGestores;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;

@Component
public class UpdaterServiceSancionOfertaAlquileresPosicionamiento implements UpdaterService {
	
	private static final String DESCRIPCION_TRABAJO_LIMPIEZA = "msg.trabajo.automatico.actuacion.tecnica.limpieza.descripcion";
	private static final String MSG_ERROR_FALTA_GESTOR_COMERCIAL_ALQUILER = "msg.trabajo.automatico.actuacion.tecnica.limpieza.error.gestor.comercial.alquiler";
	

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private GestorActivoApi gestorActivoApi;
    
    @Autowired
    private MessageService messageService;
    
	@Autowired
	private OfertaApi ofertaApi;
    
    @Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresPosicionamiento.class);
    
	private static final String FECHA_FIRMA = "fechaFirmaContrato";
	private static final String LUGAR_FIRMA = "lugarFirma";
	
	
	private static final String CODIGO_T015_POSICIONAMIENTO = "T015_Posicionamiento";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Posicionamiento posicionamiento = new Posicionamiento();
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		if(!Checks.esNulo(expedienteComercial)) {
			posicionamiento.setExpediente(expedienteComercial);
		}
		estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_FIRMA));
		expedienteComercial.setEstado(estadoExpedienteComercial);
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

		for(TareaExternaValor valor :  valores){
			
			if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					posicionamiento.setFechaPosicionamiento(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha anulación.", e);
				}
			}
			
			if(LUGAR_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				posicionamiento.setLugarFirma(valor.getValor());
			}
				
		}
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		
		// Una vez aprobado el expediente, se congelan el resto de
		// ofertas que no estén rechazadas (aceptadas y pendientes)
		List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
		for (Oferta oferta : listaOfertas) {
			if (!oferta.getId().equals(ofertaAceptada.getId())
					&& !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())) {
				ofertaApi.congelarOferta(oferta);
			}
		}
		
		// Crear trabajo de Adecuacion técnica tipo limpieza 
		
		crearTrabajoLimpieza(tramite,posicionamiento, expedienteComercial);
		
		genericDao.save(Posicionamiento.class, posicionamiento);
		
		expedienteComercialApi.enviarCorreoGestionLlaves(expedienteComercial.getId(), posicionamiento, 0);
		expedienteComercialApi.enviarCorreoPosicionamientoFirma(expedienteComercial.getId(), posicionamiento);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_POSICIONAMIENTO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private void crearTrabajoLimpieza(ActivoTramite tramite, Posicionamiento posicionamiento, ExpedienteComercial expedienteComercial) {

		boolean validado = false;

		DtoFichaTrabajo dto = new DtoFichaTrabajo();
		
		dto.setEstadoCodigo(DDEstadoTrabajo.ESTADO_SOLICITADO);

		dto.setTipoTrabajoCodigo(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA);

		dto.setSubtipoTrabajoCodigo(DDSubtipoTrabajo.CODIGO_AT_LIMPIEZA);

		dto.setFechaTope(posicionamiento.getFechaPosicionamiento());

		dto.setDescripcion(messageService.getMessage(DESCRIPCION_TRABAJO_LIMPIEZA));

		// El responsable del trabajo se asigna al Gestor de Mantenimiento en trabajoManager.create
		// Cuando se detecte que el responsable del trabajo es este
		
		//HREOS-5061
		Activo act=tramite.getActivo();
		Usuario gestor_activo_alquiler = gestorActivoApi.getGestorByActivoYTipo(act, GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
		Usuario gestor_mantenimiento= gestorActivoApi.getGestorByActivoYTipo(act, GestorActivoApi.CODIGO_GESTOR_ACTIVO);
		
		if(!Checks.esNulo(gestor_mantenimiento)) { 
			if(!Checks.esNulo(gestor_activo_alquiler)) {
				dto.setResponsableTrabajo(GestorActivoApi.CODIGO_GESTOR_ALQUILERES);
			}else {
				dto.setResponsableTrabajo(GestorActivoApi.CODIGO_GESTOR_ACTIVO);
			} 
		}

		// Si el expediente contiene más de un activo se crea un único trabajo englobando todos los activos.
		
		List<ActivoAgrupacionActivo> listaActivos = new ArrayList<ActivoAgrupacionActivo>();
		
		if (!Checks.esNulo(expedienteComercial.getOferta().getAgrupacion())) {
			 listaActivos = expedienteComercial.getOferta().getAgrupacion().getActivos();
		}

		if (!Checks.esNulo(listaActivos) && listaActivos.size() > 1) {

			StringBuilder idsActivos = new StringBuilder();

			dto.setEsSolicitudConjunta(true);

			for (int i = 0; i < listaActivos.size() - 1; i++) {
				idsActivos.append(listaActivos.get(i).getActivo().getId() + ",");
			}

			idsActivos.append(listaActivos.get(listaActivos.size() - 1).getActivo().getId());

			dto.setIdsActivos(idsActivos.toString());

			Activo activo = listaActivos.get(0).getActivo();

			if(!Checks.esNulo(activo)) {
				
				Usuario solicitante = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);

				if (!Checks.esNulo(solicitante)) {

					dto.setIdSolicitante(solicitante.getId());

				} else {
				
					List<DtoListadoGestores> gestores = activoAdapter.getGestores(activo.getId());
					for(DtoListadoGestores gestor: gestores){
						if(gestor.getCodigo().equals(GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES)){
							if(Checks.esNulo(gestor.getFechaHasta())){
								dto.setIdSolicitante(gestor.getIdUsuario());
							}
						}
					}

				}
			}

			if (Checks.esNulo(dto.getIdSolicitante())) {
				throw new JsonViewerException(messageService.getMessage(MSG_ERROR_FALTA_GESTOR_COMERCIAL_ALQUILER));
			}

			dto.setIdAgrupacion(expedienteComercial.getOferta().getAgrupacion().getId());

			validado = true;

		} else {

			Activo activo = null;
			validado = true;

			if (!Checks.esNulo(tramite.getActivo())) {
				activo = tramite.getActivo();
			} else if (!listaActivos.isEmpty()) {
				activo = listaActivos.get(0).getActivo();
			} else if (!Checks.esNulo(expedienteComercial.getOferta().getActivoPrincipal())) {
				activo = expedienteComercial.getOferta().getActivoPrincipal();
			} else {
				validado = false;
			}

			if (validado) {

				dto.setEsSolicitudConjunta(false);

				dto.setIdActivo(activo.getId());

				Usuario solicitante = gestorActivoApi.getGestorByActivoYTipo(activo, GestorActivoApi.CODIGO_GESTOR_COMERCIAL_ALQUILERES);

				if (!Checks.esNulo(solicitante)) {

					dto.setIdSolicitante(solicitante.getId());

				} else {
					throw new JsonViewerException(messageService.getMessage(MSG_ERROR_FALTA_GESTOR_COMERCIAL_ALQUILER));
				}

			}

		}

		if (validado) {
			trabajoApi.create(dto);
		}

	}

}
