package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
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
    
    private static final String COMBO_PROCEDE = "comboProcede";
    private static final String MOTIVO_ANULACION = "motivoAnulacion";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    private static final String CODIGO_T013_RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			
			for(TareaExternaValor valor :  valores){
				
				if(COMBO_PROCEDE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					Filter filtro;
				
					
					if(DDSiNo.NO.equals(valor.getValor())){

						//Anula el expediente
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
						
						expediente.setFechaAnulacion(new Date());
						
						//Finaliza el trámite
						Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
						tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
						genericDao.save(ActivoTramite.class, tramite);

						//Rechaza la oferta y descongela el resto
						ofertaApi.rechazarOferta(ofertaAceptada);
						List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
						for(Oferta oferta : listaOfertas){
							if((DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo()))){
								ofertaApi.descongelarOferta(oferta);
							}
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
							genericDao.save(Reserva.class, reserva);
						}
					}

				}
				
				if(MOTIVO_ANULACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					Reserva reserva = expediente.getReserva();
					if(!Checks.esNulo(reserva)){
						reserva.setMotivoAnulacion(valor.getValor());
						genericDao.save(Reserva.class, reserva);
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

}
