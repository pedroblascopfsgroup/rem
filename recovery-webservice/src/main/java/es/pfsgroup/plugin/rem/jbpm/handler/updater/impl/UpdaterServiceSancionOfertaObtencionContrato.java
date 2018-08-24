package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.TanteoActivoExpediente;
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

	private static int NUMERO_DIAS_VENCIMIENTO = 45;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	private static final String CODIGO_T013_OBTENCION_CONTRATO_RESERVA = "T013_ObtencionContratoReserva";
	private static final String FECHA_FIRMA = "fechaFirma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaObtencionContrato.class);

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Filter filtro;
		
// Se comenta por errores en el merge c9d4164588f764216e0eeaf20836605357cf6b24

//		for (TareaExternaValor valor : valores) {
//
//			if (FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
//				Reserva reserva = expediente.getReserva();
//				if (!Checks.esNulo(reserva)) {
//					//Si hay reserva y firma, se desbloquea la tarea ResultadoPBC
//					reactivarTareaResultadoPBC(valor.getTareaExterna(), expediente);
//					activoTramiteApi.reactivarTareaResultadoPBC(valor.getTareaExterna(), expediente);
//					try {			
//						reserva.setFechaFirma(ft.parse(valor.getValor()));
//						genericDao.save(Reserva.class, reserva);
//					} catch (ParseException e) {
//						e.printStackTrace();
//					}
//				}
//			}
//			
//			genericDao.save(ExpedienteComercial.class, expediente);
		

		for (TareaExternaValor valor : valores) {

			if (FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Reserva reserva = expediente.getReserva();
				if (!Checks.esNulo(reserva)) {
					//Si hay reserva y firma, se desbloquea la tarea ResultadoPBC
					activoTramiteApi.reactivarTareaResultadoPBC(valor.getTareaExterna(), expediente);
					try {			
						reserva.setFechaFirma(ft.parse(valor.getValor()));
						genericDao.save(Reserva.class, reserva);
					} catch (ParseException e) {
						e.printStackTrace();
					}
				}
			}
			genericDao.save(ExpedienteComercial.class, expediente);
			
			
		}		
//		}
//			genericDao.save(ExpedienteComercial.class, expediente);
//		
		
		if (!Checks.esNulo(ofertaAceptada)) {
			
			Boolean finalizado = false;
			
			List<TareaExterna> listaTareas = activoTramiteApi
					.getListaTareaExternaByIdTramite(tramite.getId());
			for (int i = 0; i < listaTareas.size(); i++) {
				TareaExterna tarea = listaTareas.get(i);
				if (!Checks.esNulo(tarea)) {
					if (tarea.getTareaProcedimiento().getCodigo().equalsIgnoreCase("T013_ResolucionTanteo")) {
						finalizado = !Checks.esNulo(tarea.getTareaPadre().getFechaFin());
						break;
					}
				}
			}
			
			if (ofertaApi.checkDerechoTanteo(tramite.getTrabajo()) && !finalizado)
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.BLOQUEO_ADM);
			else
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESERVADO);

			DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
			expediente.setEstado(estado);

			// actualizamos el estado de la reserva a firmada
			if (!Checks.esNulo(expediente.getReserva())) {
				DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosReserva.CODIGO_FIRMADA));
				expediente.getReserva().setEstadoReserva(estadoReserva);
				
				//Si ningun activo esta sujeto a tanteo, se informa el campo "Fecha vencimiento reserva" con Fecha firma + 40 dias
				if(!Checks.esNulo(expediente.getReserva().getFechaFirma()) && !ofertaApi.checkDerechoTanteo(tramite.getTrabajo())){
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(expediente.getReserva().getFechaFirma());
				    calendar.add(Calendar.DAY_OF_YEAR, UpdaterServiceSancionOfertaObtencionContrato.NUMERO_DIAS_VENCIMIENTO);
				    expediente.getReserva().setFechaVencimiento(calendar.getTime());
				}
				
				//Si algún activo esta sujeto a tanteo y todos tienen la resolucion Renunciada, se informa el campo "Fecha vencimiento reserva" con la mayor fecha de resolucion de los tanteos
				if(ofertaApi.checkDerechoTanteo(tramite.getTrabajo())){
					List<TanteoActivoExpediente> tanteosExpediente= expediente.getTanteoActivoExpediente();
					if(!Checks.estaVacio(tanteosExpediente)){
						//HREOS-2686 Punto 2
						expedienteComercialApi.actualizarFVencimientoReservaTanteosRenunciados(null, tanteosExpediente);
					}
				}
			}

			genericDao.save(ExpedienteComercial.class, expediente);


			//Actualizar el estado comercial de los activos de la oferta y, consecuentemente, el estado de publicación.
			for (TareaExternaValor valor : valores) {

				if (FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					Reserva reserva = expediente.getReserva();
					if (!Checks.esNulo(reserva)) {
						//Si hay reserva y firma, se desbloquea la tarea ResultadoPBC
						activoTramiteApi.reactivarTareaResultadoPBC(valor.getTareaExterna(), expediente);
						try {			
							reserva.setFechaFirma(ft.parse(valor.getValor()));
							genericDao.save(Reserva.class, reserva);
						} catch (ParseException e) {
							e.printStackTrace();
						}
					}
				}
				genericDao.save(ExpedienteComercial.class, expediente);
				
				
			}
			
			//Actualizar el estado comercial de los activos de la oferta
			ofertaApi.updateStateDispComercialActivosByOferta(ofertaAceptada);
		}

	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_OBTENCION_CONTRATO_RESERVA };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
