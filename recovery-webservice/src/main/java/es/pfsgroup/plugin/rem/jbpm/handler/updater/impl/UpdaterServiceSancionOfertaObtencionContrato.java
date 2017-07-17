package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;

@Component
public class UpdaterServiceSancionOfertaObtencionContrato implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private TrabajoApi trabajoApi;
	
	private static int NUMERO_DIAS_VENCIMIENTO = 40;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	private static final String CODIGO_T013_OBTENCION_CONTRATO_RESERVA = "T013_ObtencionContratoReserva";
	private static final String FECHA_FIRMA = "fechaFirma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Filter filtro;
		if (!Checks.esNulo(ofertaAceptada)) {
			if (ofertaApi.checkDerechoTanteo(tramite.getTrabajo()))
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.BLOQUEO_ADM);
			else
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESERVADO);

			DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
			expediente.setEstado(estado);

			// actualizamos el estado de la reserva a firmada
			if (!Checks.esNulo(expediente.getReserva())) {
				DDEstadosReserva estadoReserva = genericDao.get(DDEstadosReserva.class,
						genericDao.createFilter(FilterType.EQUALS, DDEstadosReserva.CODIGO_FIRMADA));
				expediente.getReserva().setEstadoReserva(estadoReserva);
				
				//Si ningun activo esta sujeto a tanteo, se informa el campo "Fecha vencimiento reserva" con Fecha firma + 40 dias
				if(!Checks.esNulo(expediente.getReserva().getFechaFirma()) && !ofertaApi.checkDerechoTanteo(tramite.getTrabajo())){
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(expediente.getReserva().getFechaFirma());
				    calendar.add(Calendar.DAY_OF_YEAR, UpdaterServiceSancionOfertaObtencionContrato.NUMERO_DIAS_VENCIMIENTO);
				    expediente.getReserva().setFechaVencimiento(calendar.getTime());
				}
				
				
			}

			genericDao.save(ExpedienteComercial.class, expediente);

			for (TareaExternaValor valor : valores) {

				if (FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					Reserva reserva = expediente.getReserva();
					if (!Checks.esNulo(reserva)) {
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
		}

	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_OBTENCION_CONTRATO_RESERVA };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
