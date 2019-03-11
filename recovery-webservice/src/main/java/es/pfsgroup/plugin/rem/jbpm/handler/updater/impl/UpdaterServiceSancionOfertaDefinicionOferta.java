package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.NotificacionApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaDefinicionOferta implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private NotificacionApi notificacionApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GencatApi gencatApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ComunicacionGencatApi comunicacionGencatApi;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaDefinicionOferta.class);

	private static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
	//private static final String FECHA_ENVIO_COMITE = "fechaEnvio";
	private static final String COMBO_CONFLICTO = "comboConflicto";
	private static final String COMBO_RIESGO = "comboRiesgo";
	private static final String COMBO_COMITE_SUPERIOR = "comiteSuperior";
	//private static final String CAMPO_COMITE = "comite";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {		
		/*
		 * Si tiene atribuciones guardamos la fecha de aceptación de la tarea
		 * como fecha de sanción, en caso contrario, la fecha de sanción será la
		 * de resolución del comité externo.
		 */
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi
				.expedienteComercialPorOferta(ofertaAceptada.getId());
		if (!Checks.esNulo(ofertaAceptada) && !Checks.esNulo(expediente)) {
			List<ActivoOferta> listActivosOferta = expediente.getOferta().getActivosOferta();
			for (ActivoOferta activoOferta : listActivosOferta) {
				ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivo(activoOferta.getPrimaryKey().getActivo().getId());
				if(Checks.esNulo(expediente.getReserva()) && DDEstadosExpedienteComercial.EN_TRAMITACION.equals(expediente.getEstado().getCodigo()) && activoApi.isAfectoGencat(activoOferta.getPrimaryKey().getActivo())){
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
			
			if (ofertaApi.checkAtribuciones(tramite.getTrabajo())) {
				expediente.setFechaSancion(new Date());
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
						DDEstadosExpedienteComercial.APROBADO);
				DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				expediente.setEstado(estado);

				
				// Una vez aprobado el expediente, se congelan el resto de
				// ofertas que no estén rechazadas (aceptadas y pendientes)
				List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
				for (Oferta oferta : listaOfertas) {
					if (!oferta.getId().equals(ofertaAceptada.getId())
							&& !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())) {
						ofertaApi.congelarOferta(oferta);
					}
				}

				// Se comprueba si cada activo tiene KO de admisión o de gestión
				// y se envía una notificación
				notificacionApi.enviarNotificacionPorActivosAdmisionGestion(expediente);
			} else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
						DDEstadosExpedienteComercial.PTE_SANCION);
				Filter filtroSinFormalizacion = genericDao.createFilter(FilterType.EQUALS, "codigo",
						DDEstadosExpedienteComercial.APROBADO);
				
				PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(expediente.getOferta().getActivoPrincipal().getId());
				
				DDEstadosExpedienteComercial estado;

				
				if(perimetro.getAplicaFormalizar() == 0){
					estado = genericDao.get(DDEstadosExpedienteComercial.class, filtroSinFormalizacion);	
				}else{
					estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				}
				 
				expediente.setEstado(estado);
			}
			
			for (TareaExternaValor valor : valores) {
				if (COMBO_RIESGO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if (DDSiNo.SI.equals(valor.getValor())) {
						expediente.setRiesgoReputacional(1);
					} else {
						if (DDSiNo.NO.equals(valor.getValor())) {
							expediente.setRiesgoReputacional(0);
						}
					}
				}
				if (COMBO_CONFLICTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if (DDSiNo.SI.equals(valor.getValor())) {
						expediente.setConflictoIntereses(1);
					} else {
						if (DDSiNo.NO.equals(valor.getValor())) {
							expediente.setConflictoIntereses(0);
						}
					}
				}
				if(COMBO_COMITE_SUPERIOR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if (DDSiNo.SI.equals(valor.getValor())){
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDComiteSancion.CODIGO_BANKIA_DGVIER);
						DDComiteSancion comiteSuperior = genericDao.get(DDComiteSancion.class, filtro);
						if(!Checks.esNulo(comiteSuperior)) {
							expediente.setComiteSuperior(comiteSuperior);
							expediente.setComiteSancion(comiteSuperior);
						}
						
					}
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T013_DEFINICION_OFERTA };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
