package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.TanteoActivoExpediente;
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

	private static final Integer NUMERO_DIAS_VENCIMIENTO = 45;
	private static final Integer NUMERO_DIAS_VENCIMIENTO_SAREB = 40;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
    private GencatApi gencatApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;

	private static final String CODIGO_T013_OBTENCION_CONTRATO_RESERVA = "T013_ObtencionContratoReserva";
	private static final String FECHA_FIRMA = "fechaFirma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaObtencionContrato.class);

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Filter filtro;
		Activo activo = null;
		

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
			List<ActivoOferta> listActivosOferta = expediente.getOferta().getActivosOferta();
			for (ActivoOferta activoOferta : listActivosOferta) {
				ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(activoOferta.getPrimaryKey().getActivo().getId());
				if(!Checks.esNulo(expediente.getReserva()) && DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo()) && activoApi.isAfectoGencat(activoOferta.getPrimaryKey().getActivo())){
					Oferta oferta = expediente.getOferta();	
					OfertaGencat ofertaGencat = null;
					if (!Checks.esNulo(comunicacionGencat)) {
						ofertaGencat = genericDao.get(OfertaGencat.class,genericDao.createFilter(FilterType.EQUALS,"oferta", oferta), genericDao.createFilter(FilterType.EQUALS,"comunicacion", comunicacionGencat));
					}
					if(!Checks.esNulo(ofertaGencat)) {
							if(Checks.esNulo(ofertaGencat.getIdOfertaAnterior()) && !ofertaGencat.getAuditoria().isBorrado()) {
								gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
							}
					}else{	
						gencatApi.bloqueoExpedienteGENCAT(expediente, activoOferta.getPrimaryKey().getActivo().getId());
					}					
				}
			}

			activo = ofertaAceptada.getActivoPrincipal();
			
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
					if(!Checks.esNulo(activo) && DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo())) {
						calendar.add(Calendar.DAY_OF_YEAR, NUMERO_DIAS_VENCIMIENTO_SAREB);
					}else {
						calendar.add(Calendar.DAY_OF_YEAR, UpdaterServiceSancionOfertaObtencionContrato.NUMERO_DIAS_VENCIMIENTO);
					}
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
