package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.TanteoActivoExpediente;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.tareasactivo.TareaActivoManager;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

@Component
public class UpdaterServiceSancionOfertaObtencionContrato implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private TareaActivoManager tareaActivoManager;

	private static int NUMERO_DIAS_VENCIMIENTO = 40;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	private static final String CODIGO_T013_OBTENCION_CONTRATO_RESERVA = "T013_ObtencionContratoReserva";
	private static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
	
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

			for (TareaExternaValor valor : valores) {

				if (FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					Reserva reserva = expediente.getReserva();
					if (!Checks.esNulo(reserva)) {
						try {
							//Si hay reserva y firma, se desbloquea la tarea ResultadoPBC
							reactivarTareaResultadoPBC(valor.getTareaExterna(), expediente);
							
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
	
	private void reactivarTareaResultadoPBC(TareaExterna tareaExterna, ExpedienteComercial expediente){
		ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();

		List<TareaActivo> tareas = tareaActivoManager.getTareasActivoByIdTramite(tramite.getId());
		TareaActivo tareaPBC = null;
		
		// En el tramite, se busca tarea "Resultado PBC" y se reactiva
		for (TareaActivo tarea : tareas) {
			if (CODIGO_T013_RESULTADO_PBC.equals(tarea.getTareaExterna().getTareaProcedimiento().getCodigo())) {
				if(!tarea.getTareaFinalizada() && tarea.getAuditoria().isBorrado()){
					tarea.getAuditoria().setBorrado(false);
					tareaPBC = tarea;
				}
			}

		}

		if (!Checks.esNulo(tareaPBC)){
			// Se recalculan plazos en funcion de si existe tanteo
			boolean tieneTanteo = false;
			Date ultimaFechaTanteo = new Date(0);
			if(new Integer(1).equals(expediente.getCondicionante().getSujetoTanteoRetracto()))//Comprueba si tiene tanteo
			{
				List<TanteoActivoExpediente> tanteos = expediente.getTanteoActivoExpediente();
				for(TanteoActivoExpediente tanteo : tanteos){
					if(!Checks.esNulo(tanteo.getFechaResolucion()) &&
							tanteo.getFechaResolucion().compareTo(ultimaFechaTanteo) > 0){
						ultimaFechaTanteo = tanteo.getFechaResolucion();
						tieneTanteo = true;
					}
				}
			}
			
			// Si no se ha actualizado la ultima fecha de tanteo, se establece Hoy
			if ((new Date(0)).compareTo(ultimaFechaTanteo) == 0){
				ultimaFechaTanteo = new Date();
			}
			
			// CON tanteo: F.Resolucion Tanteo + 30 dias
			// SIN tanteo: Hoy + 30 dias
			Date fechaFinTarea = new Date();
			if (tieneTanteo){
				fechaFinTarea = addDays(ultimaFechaTanteo, 30);
			} else {			
				fechaFinTarea = addDays(new Date(), 30);
			}
			
			tareaPBC.setFechaFin(fechaFinTarea);
		}
		
	}
	
    public Date addDays(Date d, int days){
        d.setTime(d.getTime() + days * 1000 * 60 * 60 * 24);
        return d;
    }

}
