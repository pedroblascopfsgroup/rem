package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaDefinicionOferta implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
   	private static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
    private static final String FECHA_ENVIO_COMITE = "fechaEnvio";
    private static final String COMBO_CONFLICTO = "comboConflicto";
    private static final String COMBO_RIESGO = "comboRiesgo";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		/* Si tiene atribuciones guardamos la fecha de aceptación de la tarea como fecha de sanción,
			en caso contrario, la fecha de sanción será la de resolución del comité externo.
		*/
		if(ofertaApi.checkAtribuciones(tramite.getTrabajo())){
			Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
			if(!Checks.esNulo(ofertaAceptada)){
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				expediente.setFechaSancion(new Date());
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
				DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				expediente.setEstado(estado);
				
				//Una vez aprobado el expediente, se congelan el resto de ofertas que no estén rechazadas (aceptadas y pendientes)
				List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
				for(Oferta oferta : listaOfertas){
					if(!oferta.getId().equals(ofertaAceptada.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())){
						ofertaApi.congelarOferta(oferta);
					}
				}
			}
		}else{
			Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
			if(!Checks.esNulo(ofertaAceptada)){
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_SANCION);
				DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				expediente.setEstado(estado);
			}
		}
		for(TareaExternaValor valor :  valores){
			Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
			if(!Checks.esNulo(ofertaAceptada)){
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				if(COMBO_RIESGO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
					if(DDSiNo.SI.equals(valor.getValor())){
						expediente.setRiesgoReputacional(1);
					}
					else{
						if(DDSiNo.NO.equals(valor.getValor())){
							expediente.setRiesgoReputacional(0);
						}
					}
				}
				if(COMBO_CONFLICTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
					if(DDSiNo.SI.equals(valor.getValor())){
						expediente.setConflictoIntereses(1);
					}
					else{
						if(DDSiNo.NO.equals(valor.getValor())){
							expediente.setConflictoIntereses(0);
						}
					}
				}
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_DEFINICION_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
