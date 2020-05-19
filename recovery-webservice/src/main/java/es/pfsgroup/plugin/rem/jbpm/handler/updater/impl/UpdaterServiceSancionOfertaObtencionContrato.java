package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import es.pfsgroup.plugin.rem.model.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;

@Component
public class UpdaterServiceSancionOfertaObtencionContrato implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private GencatApi gencatApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;

	@Autowired
	private ActivoAdapter activoAdapter;

	private static final String CODIGO_T013_OBTENCION_CONTRATO_RESERVA = "T013_ObtencionContratoReserva";
	private static final String CODIGO_T017_OBTENCION_CONTRATO_RESERVA = "T017_ObtencionContratoReserva";
	
	private static final String CODIGO_T017_ADVISORY_NOTE = "T017_AdvisoryNote";
	private static final String CODIGO_T017_RECOMENDACION_ADVISORY = "T017_RecomendCES";
	private static final String CODIGO_T017_RESOLUCION_PRO_MANZANA = "T017_ResolucionPROManzana";	
	
	private static final String FECHA_FIRMA = "fechaFirma";
	private static final String T017 = "T017";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaObtencionContrato.class);

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if (ofertaAceptada != null) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			Integer diasVencimiento = expediente.getCondicionante().getPlazoFirmaReserva();
			Filter filtro = null;
			Activo activo = null;
			Boolean proManzanaFinalizada = null;
			Boolean solicitaReserva = ofertaApi.checkReserva(ofertaAceptada);
			
			if(ofertaApi.tieneTarea(tramite, CODIGO_T017_ADVISORY_NOTE) == 0 
					&& ofertaApi.tieneTarea(tramite, CODIGO_T017_RECOMENDACION_ADVISORY) == 0 
					&& ofertaApi.tieneTarea(tramite, CODIGO_T017_RESOLUCION_PRO_MANZANA) == 0) {
				proManzanaFinalizada = true;
			}else {				
				proManzanaFinalizada = ofertaApi.tieneTarea(tramite, CODIGO_T017_RESOLUCION_PRO_MANZANA) == 2;
			}
			
			for (TareaExternaValor valor : valores) {
	
				if (FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					Reserva reserva = expediente.getReserva();
					if (!Checks.esNulo(reserva)) {
						// Si hay reserva y firma, se desbloquea la tarea ResultadoPBC
						activoTramiteApi.reactivarTareaResultadoPBC(valor.getTareaExterna(), expediente);
						try {
							reserva.setFechaFirma(ft.parse(valor.getValor()));
							genericDao.save(Reserva.class, reserva);
						} catch (ParseException e) {
							e.printStackTrace();
						}
					}
				}
			}
			
			if (!Checks.esNulo(ofertaAceptada)) {
				List<ActivoOferta> listActivosOferta = expediente.getOferta().getActivosOferta();
				for (ActivoOferta activoOferta : listActivosOferta) {
					ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(activoOferta.getPrimaryKey().getActivo().getId());
					if (activoApi.isAfectoGencat(activoOferta.getPrimaryKey().getActivo())) {
						Oferta oferta = expediente.getOferta();
						OfertaGencat ofertaGencat = null;
						if (!Checks.esNulo(comunicacionGencat)) {
							ofertaGencat = genericDao.get(OfertaGencat.class,
									genericDao.createFilter(FilterType.EQUALS, "oferta", oferta),
									genericDao.createFilter(FilterType.EQUALS, "comunicacion", comunicacionGencat));
						}
						if (!Checks.esNulo(ofertaGencat)) {
							if (Checks.esNulo(ofertaGencat.getIdOfertaAnterior()) && !ofertaGencat.getAuditoria().isBorrado()) {
								gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
							}
						} else {
							gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
						}
					}
				}
	
				activo = ofertaAceptada.getActivoPrincipal();
				
				if(!T017.equals(tramite.getTipoTramite().getCodigo()) || (T017.equals(tramite.getTipoTramite().getCodigo()) && proManzanaFinalizada)) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESERVADO);
				}else if(T017.equals(tramite.getTipoTramite().getCodigo())){
					if(solicitaReserva && !Checks.esNulo(expediente.getReserva()) && !Checks.esNulo(expediente.getReserva().getEstadoReserva()) 
						&& DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo())) {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESERVADO_PTE_PRO_MANZANA);
	
					}else {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO_CES_PTE_PRO_MANZANA);
					}				
				}
				if(!Checks.esNulo(filtro)) {
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expediente.setEstado(estado);
				}
	
				// actualizamos el estado de la reserva a firmada
				if (!Checks.esNulo(expediente.getReserva())) {
					DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_FIRMADA));
					expediente.getReserva().setEstadoReserva(estadoReserva);
	
					// Si ningun activo esta sujeto a tanteo, se informa el campo "Fecha vencimiento
					// reserva" con Fecha firma + plazo para firmar
					if (!Checks.esNulo(expediente.getReserva().getFechaFirma()) && !ofertaApi.checkDerechoTanteo(tramite.getTrabajo())) {
						Calendar calendar = Calendar.getInstance();
						calendar.setTime(expediente.getReserva().getFechaFirma());
						if(!Checks.esNulo(diasVencimiento)){
							calendar.add(Calendar.DAY_OF_YEAR, diasVencimiento);
						}
						expediente.getReserva().setFechaVencimiento(calendar.getTime());
					}
	
					// Si algún activo esta sujeto a tanteo y todos tienen la resolucion Renunciada,
					// se informa el campo "Fecha vencimiento reserva" con la mayor fecha de
					// resolucion de los tanteos
					if (ofertaApi.checkDerechoTanteo(tramite.getTrabajo())) {
						List<TanteoActivoExpediente> tanteosExpediente = expediente.getTanteoActivoExpediente();
						if (!Checks.estaVacio(tanteosExpediente)) {
							// HREOS-2686 Punto 2
							expedienteComercialApi.actualizarFVencimientoReservaTanteosRenunciados(null, tanteosExpediente);
						}
					}
				}
	
				genericDao.save(ExpedienteComercial.class, expediente);
				
	//			//Si es T017, revisamos GENCAT
	//			if(T017.equals(tramite.getTipoTramite().getCodigo()) && proManzanaFinalizada) {
	//				for (ActivoOferta activoOferta : listActivosOferta) {
	//					ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(activoOferta.getPrimaryKey().getActivo().getId());
	//					if(!Checks.esNulo(expediente.getReserva()) && DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo()) && activoApi.isAfectoGencat(activoOferta.getPrimaryKey().getActivo())){
	//						Oferta oferta = expediente.getOferta();	
	//						OfertaGencat ofertaGencat = null;
	//						if (!Checks.esNulo(comunicacionGencat)) {
	//							ofertaGencat = genericDao.get(OfertaGencat.class,genericDao.createFilter(FilterType.EQUALS,"oferta", oferta), genericDao.createFilter(FilterType.EQUALS,"comunicacion", comunicacionGencat));
	//						}
	//						if(!Checks.esNulo(ofertaGencat)) {
	//								if(Checks.esNulo(ofertaGencat.getIdOfertaAnterior()) && !ofertaGencat.getAuditoria().isBorrado()) {
	//									gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
	//								}
	//						}else{	
	//							gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
	//						}					
	//					}
	//				}
	//			}
	
				//Actualizar el estado comercial de los activos de la oferta
				ofertaApi.updateStateDispComercialActivosByOferta(ofertaAceptada);
	
				if (!Checks.esNulo(tramite.getActivo())) {
					activoAdapter.actualizarEstadoPublicacionActivo(tramite.getActivo().getId(), true);
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_OBTENCION_CONTRATO_RESERVA, CODIGO_T017_OBTENCION_CONTRATO_RESERVA };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
