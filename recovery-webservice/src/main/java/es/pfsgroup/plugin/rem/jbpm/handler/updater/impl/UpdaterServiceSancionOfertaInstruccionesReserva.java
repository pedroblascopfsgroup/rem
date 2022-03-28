package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;

@Component
public class UpdaterServiceSancionOfertaInstruccionesReserva implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private UvemManagerApi uvemManagerApi;
    
    @Autowired
  	private ActivoTramiteApi activoTramiteApi;
    
    @Autowired
	private BoardingComunicacionApi boardingComunicacionApi;
    
    private static final String FECHA_ENVIO = "fechaEnvio";
    private static final String TIPO_ARRAS = "tipoArras";
    private static final String COMBO_RESULTADO = "comboResultado";
    private static final String MOTIVO_APLAZAMIENTO = "motivoAplazamiento";
    private static final String COMBO_QUITAR = "comboQuitar";
   	private static final String motivoAplazamiento = "Suspensión proceso arras";
   	public static final String CODIGO_T013_INSTRUCCIONES_RESERVA = "T013_InstruccionesReserva";
   	public static final String CODIGO_T017_INSTRUCCIONES_RESERVA = "T017_InstruccionesReserva";
   	public static final String CODIGO_T017 = "T017";
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	private static final String TIPO_OPERACION = "tipoOperacion";
	
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaInstruccionesReserva.class);
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		boolean estadoBcModificado = false;
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		boolean comboQuitar = false;
		boolean reagendar = false;
		String tipoArras = "";
		Date fechaEnvio = null;
		DtoGridFechaArras dtoArras = new DtoGridFechaArras();
		Map<String, Boolean> campos = new HashMap<String,Boolean>();
		

		try {
			if(!Checks.esNulo(ofertaAceptada)){
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				String estadoExpediente = null;
				String estadoBc = null;
					
			
				for(TareaExternaValor valor :  valores){
					if(FECHA_ENVIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						fechaEnvio = ft.parse(valor.getValor());
					}else if(TIPO_ARRAS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						tipoArras = valor.getValor();
					}else if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						if (DDSiNo.SI.equals(valor.getValor())) {			
							reagendar = true;
						}
					}else if(MOTIVO_APLAZAMIENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						dtoArras.setValidacionBC(DDMotivosEstadoBC.CODIGO_APLAZADA);
						dtoArras.setMotivoAnulacion(valor.getValor());
					}else if (COMBO_QUITAR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (DDSiNo.SI.equals(valor.getValor())) {
							comboQuitar = true;
						}
					}
				}
				Reserva reserva = expediente.getReserva();
				if(comboQuitar || reagendar) {
					if(comboQuitar) {
						campos.put(TIPO_OPERACION, false);
						estadoExpediente = DDEstadosExpedienteComercial.PTE_PBC_VENTAS;
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
						estadoExpediente = DDEstadosExpedienteComercial.PTE_AGENDAR_ARRAS;
						estadoBc = DDEstadoExpedienteBc.CODIGO_ARRAS_APROBADAS;
					}
					expedienteComercialApi.createOrUpdateUltimaPropuesta(expediente.getId(), dtoArras, ofertaAceptada);
				}else {
					if(reserva != null) {
						reserva.setFechaEnvio(fechaEnvio);
						reserva.setTipoArras( genericDao.get(DDTiposArras.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoArras)));
						genericDao.save(Reserva.class, reserva);
					}
				}

				if(estadoExpediente != null) {
					expediente.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExpediente)));
				}
				if(estadoBc != null && expediente.getOferta() != null && expediente.getOferta().getActivoPrincipal() != null && DDCartera.isCarteraBk(expediente.getOferta().getActivoPrincipal().getCartera())){
					estadoBcModificado = true;
					expediente.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));

				}
				genericDao.save(ExpedienteComercial.class, expediente);
				
				// LLamada servicio web Bankia para modificaciones según tipo
				// propuesta (MOD3)
				
				if(!Checks.estaVacio(valores) && ofertaAceptada.getActivoPrincipal() != null){
					String codigoTarea = null;
					if(activoTramiteApi.isTramiteVenta(tramite.getTipoTramite())) {
						codigoTarea = UpdaterServiceSancionOfertaInstruccionesReserva.CODIGO_T013_INSTRUCCIONES_RESERVA;
					}else if(activoTramiteApi.isTramiteVentaApple(tramite.getTipoTramite())) {
						codigoTarea = UpdaterServiceSancionOfertaInstruccionesReserva.CODIGO_T017_INSTRUCCIONES_RESERVA;
					}
					
					if( codigoTarea != null && DDCartera.isCarteraBk(ofertaAceptada.getActivoPrincipal().getCartera()) 
						&& !DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
						&& !CODIGO_T017.equals(tramite.getTipoTramite().getCodigo())){
						if (!uvemManagerApi.esTramiteOffline(codigoTarea,expediente)) {
							uvemManagerApi.modificacionesSegunPropuesta(valores.get(0).getTareaExterna());
						}					
						
					}
				}
				
				if(estadoBcModificado) {
					ofertaApi.replicateOfertaFlushDto(expediente.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
				}
				
				if (!campos.isEmpty() && boardingComunicacionApi.modoRestClientBloqueoCompradoresActivado())
					boardingComunicacionApi.enviarBloqueoCompradoresCFV(ofertaAceptada, campos ,BoardingComunicacionApi.TIMEOUT_1_MINUTO);
	
			}
		}catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
	
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_INSTRUCCIONES_RESERVA,CODIGO_T017_INSTRUCCIONES_RESERVA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
