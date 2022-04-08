package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.model.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceContabilidadBbva;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;

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
		
	@Autowired
	private NotificatorServiceContabilidadBbva notificatorServiceContabilidadBbva;
	
	@Autowired
    private ReservaApi reservaApi;
	
	@Autowired
	private BoardingComunicacionApi boardingComunicacionApi;
	
	@Autowired
	private NotificationOfertaManager notificationOfertaManager;

	private static final String CODIGO_T013_OBTENCION_CONTRATO_RESERVA = "T013_ObtencionContratoReserva";
	private static final String CODIGO_T017_OBTENCION_CONTRATO_RESERVA = "T017_ObtencionContratoReserva";
	
	private static final String CODIGO_T017_ADVISORY_NOTE = "T017_AdvisoryNote";
	private static final String CODIGO_T017_RECOMENDACION_ADVISORY = "T017_RecomendCES";
	private static final String CODIGO_T017_RESOLUCION_PRO_MANZANA = "T017_ResolucionPROManzana";	
	
	
    private static final String motivoAplazamiento = "Suspensión proceso arras";
	private static final String T017 = "T017";
	
	   private class CamposObtencionContrato{
		   private static final String FECHA_FIRMA = "fechaFirma";
			private static final String COMBO_RESULTADO = "comboResultado";
		    private static final String MOTIVO_APLAZAMIENTO = "motivoAplazamiento";
		    private static final String COMBO_QUITAR = "comboQuitar";
	    }
	  
	private static final String TIPO_OPERACION = "tipoOperacion";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaObtencionContrato.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		boolean estadoBcModificado = false;
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		String estadoArras = null;
		try {
			if (ofertaAceptada != null) {
				Activo activo = ofertaAceptada.getActivoPrincipal();
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				Integer diasVencimiento = expediente.getCondicionante().getPlazoFirmaReserva();
	
				Boolean proManzanaFinalizada = null;
				Boolean solicitaReserva = ofertaApi.checkReserva(ofertaAceptada);
				
				String estadoExpedienteComercial = null;
				String estadoBc = null;
				boolean aplazarArras = false;
				boolean quitarArras = false;
				boolean aprueba = false;
				Date fechaFirma = null;
				
				DtoGridFechaArras dtoArras = new DtoGridFechaArras();
				Map<String, Boolean> campos = new HashMap<String,Boolean>();
				
				if(ofertaApi.tieneTarea(tramite, CODIGO_T017_ADVISORY_NOTE) == 0 
						&& ofertaApi.tieneTarea(tramite, CODIGO_T017_RECOMENDACION_ADVISORY) == 0 
						&& ofertaApi.tieneTarea(tramite, CODIGO_T017_RESOLUCION_PRO_MANZANA) == 0) {
					proManzanaFinalizada = true;
				}else {				
					proManzanaFinalizada = ofertaApi.tieneTarea(tramite, CODIGO_T017_RESOLUCION_PRO_MANZANA) == 2;
				}
				
				for (TareaExternaValor valor : valores) {
		
					if (CamposObtencionContrato.FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						fechaFirma = ft.parse(valor.getValor());	
					}
									
					if(CamposObtencionContrato.COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						if (DDSiNo.SI.equals(valor.getValor())) {	
							aplazarArras = true;
						}
					}
					
					if(CamposObtencionContrato.MOTIVO_APLAZAMIENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						aplazarArras = true;
						dtoArras.setValidacionBC(DDMotivosEstadoBC.CODIGO_APLAZADA);
						dtoArras.setMotivoAnulacion(valor.getValor());
					}
					
					if (CamposObtencionContrato.COMBO_QUITAR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (DDSiNo.SI.equals(valor.getValor())) {
							quitarArras = true;
						}
					}
				}
				Reserva reserva = genericDao.get(Reserva.class, genericDao.createFilter(FilterType.EQUALS,  "expediente.id", expediente.getId()));
				
				if(quitarArras || aplazarArras) {
					if(quitarArras) {
						campos.put(TIPO_OPERACION, false);
						estadoExpedienteComercial = DDEstadosExpedienteComercial.PTE_PBC_VENTAS;
						estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA;
						
						if (reserva != null) {
							Auditoria.delete(reserva);
							genericDao.save(Reserva.class, reserva);
						}
		
						dtoArras.setValidacionBC(DDMotivosEstadoBC.CODIGO_ANULADA);
						dtoArras.setMotivoAnulacion(motivoAplazamiento);

						CondicionanteExpediente condicionanteExpediente = expediente.getCondicionante();
						condicionanteExpediente.setSolicitaReserva(0);
						condicionanteExpediente.setTipoCalculoReserva(null);
						condicionanteExpediente.setPorcentajeReserva(null);
						condicionanteExpediente.setPlazoFirmaReserva(null);
						condicionanteExpediente.setImporteReserva(null);
						genericDao.save(CondicionanteExpediente.class, condicionanteExpediente);


					}else {
						estadoExpedienteComercial = DDEstadosExpedienteComercial.PTE_AGENDAR_ARRAS;
						estadoBc = DDEstadoExpedienteBc.CODIGO_ARRAS_APROBADAS;
					}
					expedienteComercialApi.createOrUpdateUltimaPropuesta(expediente.getId(), dtoArras, ofertaAceptada);		
					
				}else if(ofertaAceptada.getActivoPrincipal() != null && DDCartera.isCarteraBk(ofertaAceptada.getActivoPrincipal().getCartera())){
					estadoExpedienteComercial =  DDEstadosExpedienteComercial.PTE_PBC_VENTAS;
					estadoBc =  DDEstadoExpedienteBc.CODIGO_ARRAS_FIRMADAS;
					
				}else {
					if(!T017.equals(tramite.getTipoTramite().getCodigo()) || (T017.equals(tramite.getTipoTramite().getCodigo()) && (proManzanaFinalizada))) {
						estadoExpedienteComercial =  DDEstadosExpedienteComercial.RESERVADO;
					}else if(T017.equals(tramite.getTipoTramite().getCodigo())){
						if(solicitaReserva && !Checks.esNulo(expediente.getReserva()) && !Checks.esNulo(expediente.getReserva().getEstadoReserva()) 
							&& DDEstadosReserva.CODIGO_FIRMADA.equals(expediente.getReserva().getEstadoReserva().getCodigo())) {
							estadoExpedienteComercial = DDEstadosExpedienteComercial.RESERVADO_PTE_PRO_MANZANA;
						}else {
							estadoExpedienteComercial =  DDEstadosExpedienteComercial.APROBADO_CES_PTE_PRO_MANZANA;
						}				
					}
				}
				
				
				expediente.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExpedienteComercial)));
				if(estadoBc != null) {
					estadoBcModificado = true;
					expediente.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));
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
				
					
					if (!Checks.esNulo(reserva) && !quitarArras && !aplazarArras) {
						
						DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_FIRMADA));
						estadoArras = estadoReserva.getCodigoC4C();
						reserva.setEstadoReserva(estadoReserva);
						if(!Checks.isFechaNula(fechaFirma)) {
							reserva.setFechaFirma(fechaFirma);
							activoTramiteApi.reactivarTareaResultadoPBC(tareaExternaActual, expediente);
						}

						genericDao.save(Reserva.class, reserva);
						
						if (ofertaApi.checkDerechoTanteo(tramite.getTrabajo())) {
							List<TanteoActivoExpediente> tanteosExpediente = expediente.getTanteoActivoExpediente();
							if (!Checks.estaVacio(tanteosExpediente)) {
								expedienteComercialApi.actualizarFVencimientoReservaTanteosRenunciados(null, tanteosExpediente);
							}
						}
					}
		
					genericDao.save(ExpedienteComercial.class, expediente);
					
	
					//Actualizar el estado comercial de los activos de la oferta
					ofertaApi.updateStateDispComercialActivosByOferta(ofertaAceptada);
		
//					if (!Checks.esNulo(tramite.getActivo())) {
//						activoAdapter.actualizarEstadoPublicacionActivo(tramite.getActivo().getId(), true);
//					}
					if (expediente.getOferta() != null &&
							DDCartera.CODIGO_CARTERA_BBVA.equals(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo())) {
						try {
							notificatorServiceContabilidadBbva.notificatorFinTareaConValores(expediente,true);
						} catch (GestorDocumentalException e) {
							e.printStackTrace();
						}
					}
				}
				
				if (!campos.isEmpty() && boardingComunicacionApi.modoRestClientBloqueoCompradoresActivado())
					boardingComunicacionApi.enviarBloqueoCompradoresCFV(ofertaAceptada, campos ,BoardingComunicacionApi.TIMEOUT_1_MINUTO);
				

				
				if (DDCartera.isCarteraBk(activo.getCartera())){
					
					Filter filterOferta =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaAceptada.getId());
					Filter filterTipoPbc =  genericDao.createFilter(FilterType.EQUALS, "tipoTareaPbc.codigo", DDTipoTareaPbc.CODIGO_PBC);
					Filter filterActiva =  genericDao.createFilter(FilterType.EQUALS, "activa", true);
					HistoricoTareaPbc historico = genericDao.get(HistoricoTareaPbc.class, filterOferta, filterTipoPbc, filterActiva);
					
					if (historico != null) {
						historico.setActiva(false);
						
						genericDao.save(HistoricoTareaPbc.class, historico);
					}
					
					Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTareaPbc.CODIGO_PBC);
					DDTipoTareaPbc tpb = genericDao.get(DDTipoTareaPbc.class, filtroTipo);
					
					HistoricoTareaPbc htp = new HistoricoTareaPbc();
					htp.setOferta(ofertaAceptada);
					htp.setTipoTareaPbc(!Checks.esNulo(tpb) ? tpb : null);
					
					genericDao.save(HistoricoTareaPbc.class, htp);
				}
				
				if (!Checks.esNulo(ofertaAceptada.getVentaSobrePlano()) && ofertaAceptada.getVentaSobrePlano() 
						&& (DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo()) 
						|| DDEstadosExpedienteComercial.RESERVADO_PTE_PRO_MANZANA.equals(expediente.getEstado().getCodigo())))
					notificationOfertaManager.notificationReservaVentaSobrePlano(ofertaAceptada);
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_OBTENCION_CONTRATO_RESERVA, CODIGO_T017_OBTENCION_CONTRATO_RESERVA };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
