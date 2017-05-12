package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDDevolucionReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;

@Component
public class UpdaterServiceSancionOfertaResolucionExpediente implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionExpediente.class);
    
    private static final String COMBO_PROCEDE = "comboProcede";
    private static final String MOTIVO_ANULACION = "motivoAnulacion";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    private static final String CODIGO_T013_RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			
			if(!Checks.esNulo(expediente)){

				for(TareaExternaValor valor :  valores){
					
					if(COMBO_PROCEDE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
					{
						Filter filtro;
					
						
						if(DDDevolucionReserva.CODIGO_NO.equals(valor.getValor())){
	
							//Anula el expediente
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
							
							expediente.setFechaAnulacion(new Date());
							
							//Finaliza el trámite
							Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
							tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
							genericDao.save(ActivoTramite.class, tramite);
	
							//Rechaza la oferta y descongela el resto
							ofertaApi.rechazarOferta(ofertaAceptada);
							try {
								ofertaApi.descongelarOfertas(expediente);
							} catch (Exception e) {
								logger.error("Error descongelando ofertas.", e);
							}
							Filter filtroTanteo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoTanteo.CODIGO_EJERCIDO);
							ofertaAceptada.setResultadoTanteo(genericDao.get(DDResultadoTanteo.class, filtroTanteo));
							
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							genericDao.save(ExpedienteComercial.class, expediente);
							
							Reserva reserva = expediente.getReserva();
							if(!Checks.esNulo(reserva)){
								reserva.setIndicadorDevolucionReserva(0);
								Filter filtroEstadoReserva = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_RESUELTA_POSIBLE_REINTEGRO);
								DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class, filtroEstadoReserva);
								reserva.setEstadoReserva(estadoReserva);
								reserva.setDevolucionReserva(this.getDevolucionReserva(valor.getValor()));
								
								genericDao.save(Reserva.class, reserva);
							}
						}else{
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.EN_DEVOLUCION);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							genericDao.save(ExpedienteComercial.class, expediente);
							
							Reserva reserva = expediente.getReserva();
							if(!Checks.esNulo(reserva)){
								reserva.setIndicadorDevolucionReserva(1);
								Filter filtroEstadoReserva = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION);
								DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class, filtroEstadoReserva);
								reserva.setEstadoReserva(estadoReserva);
								reserva.setDevolucionReserva(this.getDevolucionReserva(valor.getValor()));
								
								genericDao.save(Reserva.class, reserva);
							}
						}
	
					}
					
					if(MOTIVO_ANULACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
	// TODO: En caso de anulacion (en esta tarea, Resolucion expediente - Procede = NO), las reservas en principio no hay que anularlas
	// se anula solo el expediente. Ya que el estado de las reservas se ha definido por el valor del campo "procede" y el 
	// y el indicador de "devolucion" (ya tratado en la logica de arriba). En ningun caso deben las reservas. Bankia lo hara por WS.
						/* Codigo anterior de anulacion de reservas
						Reserva reserva = expediente.getReserva();
						if(!Checks.esNulo(reserva)){
							reserva.setMotivoAnulacion(valor.getValor());
							genericDao.save(Reserva.class, reserva);
						}
						*/
						
						// Se incluye un motivo de anulacion del expediente, si se indico en la tarea
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
						DDMotivoAnulacionExpediente motivoAnulacion = (DDMotivoAnulacionExpediente) genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
						expediente.setMotivoAnulacion(motivoAnulacion);
					}
					
				}
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESOLUCION_EXPEDIENTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private DDDevolucionReserva getDevolucionReserva(String codigo) {
		Filter filtroDevolucionReserva = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		DDDevolucionReserva devolucionReserva = genericDao.get(DDDevolucionReserva.class, filtroDevolucionReserva);
		
		return devolucionReserva;
	}

}
