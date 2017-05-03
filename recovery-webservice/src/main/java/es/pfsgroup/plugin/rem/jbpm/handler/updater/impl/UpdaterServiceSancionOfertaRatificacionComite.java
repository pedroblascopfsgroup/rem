package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;

@Component
public class UpdaterServiceSancionOfertaRatificacionComite implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaRatificacionComite.class);
    
    private static final String COMBO_RESOLUCION = "comboResolucion";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
   	private static final String CODIGO_T013_RATIFICACION_COMITE = "T013_RatificacionComite";
   	private static final String MOTIVO_NO_RATIFICADA = "604"; //NO RATIFICADA
//   	private static final String MOTIVO_ANULACION = "Bankia no ratifica la oferta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
//			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RPTA_OFERTANTE);
//			DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
//			expediente.setEstado(estado);
			
			if(!Checks.esNulo(expediente)){
				
				for(TareaExternaValor valor :  valores){
					
					if(COMBO_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
					{
						Filter filtro;
						if(DDSiNo.SI.equals(valor.getValor())){
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
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
						else{
							//Resuelve el expediente
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							
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
							
							// Motivo anulacion: NO RATIFICADA
							DDMotivoAnulacionExpediente motivoAnulacionExpediente = 
									(DDMotivoAnulacionExpediente) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoAnulacionExpediente.class, MOTIVO_NO_RATIFICADA);
							expediente.setMotivoAnulacion(motivoAnulacionExpediente);
	
	
						}
						
						genericDao.save(ExpedienteComercial.class, expediente);
					}
					
				}
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RATIFICACION_COMITE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
