package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;

@Component
public class UpdaterServiceSancionOfertaAlquileresAceptacionCliente implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresAceptacionCliente.class);
    
    private static final String ACEPTACION_CONTRAOFERTA = "aceptacionContraoferta";
    private static final String FECHA_ACEPTACION_DENEGACION = "fechaAceptaDenega"; 
    private static final String MOTIVO = "motivoAC";
	
	private static final String CODIGO_T015_ACEPTACION_CLIENTE= "T015_AceptacionCliente";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		boolean estadoBcModificado = false;
		Boolean aceptacionContraoferta = false;
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoOferta estadoOferta = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(ACEPTACION_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				
				if(DDSiNo.SI.equals(valor.getValor())) {
					aceptacionContraoferta = true;
					if(oferta != null && oferta.getActivoPrincipal() != null && !DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera())) {
					
						for(TareaActivo tareaActivo : tramite.getTareas()) {
							if("T015_VerificarScoring".equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) {
								estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,
										genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_SCORING));
								break;
							} else if("T015_VerificarSeguroRentas".equals(tareaActivo.getTareaExterna().getTareaProcedimiento().getCodigo())) {
								estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,
										genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_SEGURO_RENTAS));
								break;
							} 
						}
						
						if(Checks.esNulo(estadoExpedienteComercial)) {
							estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,
									genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_SANCION));
						}					
						
						expedienteComercial.setEstado(estadoExpedienteComercial);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);
					}else if(oferta != null && oferta.getActivoPrincipal() != null && DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera())){
						estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_SCORING));
						DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO));
						
						expedienteComercial.setEstado(estadoExpedienteComercial);
						expedienteComercial.setEstadoBc(estadoBc);		
						estadoBcModificado = true;
					}	
					List<ActivoOferta> activosOferta = oferta.getActivosOferta();
					
					Double importeContraoferta = oferta.getImporteContraOferta();
					
					if(!Checks.estaVacio(activosOferta)) {
						if(activosOferta.size() == 1) {
							activosOferta.get(0).setImporteActivoOferta(importeContraoferta);
						}else {
							for(ActivoOferta actOfr: activosOferta) {
								Double porcentaje = actOfr.getPorcentajeParticipacion();
								Double importeActivo = importeContraoferta * (porcentaje / 100);
								actOfr.setImporteActivoOferta(importeActivo);
							}
						}
					}
				}else {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.ANULADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

					estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA);
					oferta.setEstadoOferta(estadoOferta);
					expedienteComercial.setOferta(oferta);
					
					if(oferta != null && oferta.getActivoPrincipal() != null && !DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera())) {
						DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA));
						expedienteComercial.setEstadoBc(estadoBc);	
						estadoBcModificado = true;
					}
				}
			}
			
			if(FECHA_ACEPTACION_DENEGACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(aceptacionContraoferta) {
					try {
						expedienteComercial.setFechaAlta(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						logger.error("Error insertando Fecha alta.", e);
					}
				}else {
					try {
						expedienteComercial.setFechaAnulacion(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						logger.error("Error insertando Fecha anulación.", e);
					}
				}
				try {
					expedienteComercial.setFechaSancion(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha anulación.", e);
				}
			}
			
			if(MOTIVO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
				DDMotivoAnulacionExpediente motivoAnulacion = genericDao.get(DDMotivoAnulacionExpediente.class, filtroMotivo);
				expedienteComercial.setMotivoAnulacion(motivoAnulacion);
			}
		}
		expedienteComercialApi.update(expedienteComercial,false);
		
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_ACEPTACION_CLIENTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
