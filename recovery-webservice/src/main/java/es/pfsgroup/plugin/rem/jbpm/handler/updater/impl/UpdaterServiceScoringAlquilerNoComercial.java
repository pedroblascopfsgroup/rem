package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoExpedienteScoring;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.ScoringAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDRatingScoringServicer;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoScoring;

@Component
public class UpdaterServiceScoringAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;


    protected static final Log logger = LogFactory.getLog(UpdaterServiceScoringAlquilerNoComercial.class);
    
	
    private class CamposScoringNoComercial{
    	private static final String COMBO_RESULTADO = "comboResultado";
    	private static final String FECHA_RESOLUCION = "fechaResolucion";
    	private static final String MOTIVO_ANULACION = "motivoAnulacion";
    	private static final String NUM_EXPEDIENTE_EXT = "numExpediente";
    	private static final String RATING_HAYA = "ratingHaya";
    }

	private static final String CODIGO_T018_SCORING = "T018_Scoring";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		String estadoEcoCodigo = null;
		String estadoEcoBcCodigo = null;
		DtoExpedienteScoring dto = new DtoExpedienteScoring();
		
		try {
			for(TareaExternaValor valor :  valores){
				
				if(CamposScoringNoComercial.COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					if(DDResultadoScoring.RESULTADO_APROBADO.equals(valor.getValor())) {
						 estadoEcoCodigo =  DDEstadosExpedienteComercial.PTE_PBC_ALQUILER_HRE;
						 estadoEcoBcCodigo = DDEstadoExpedienteBc.PTE_PBC_ALQUILER_HRE;
					}else {
						estadoEcoCodigo =  DDEstadosExpedienteComercial.PTE_SCORING;
						estadoEcoBcCodigo = DDEstadoExpedienteBc.CODIGO_SCORING_A_REVISAR_POR_BC;
					}
					
					dto.setEstadoEscoring(valor.getValor());
				}
			
				
				if(CamposScoringNoComercial.FECHA_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaResolucion(ft.parse(valor.getValor()));
				} 
				if(CamposScoringNoComercial.MOTIVO_ANULACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setMotivoRechazo(valor.getValor());
				}
				
				if(CamposScoringNoComercial.NUM_EXPEDIENTE_EXT.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setNumExpedienteExterno(valor.getValor());			
				}
				
				if(CamposScoringNoComercial.RATING_HAYA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setCodigoRating(valor.getValor());
				}
			}
			
	
			expedienteComercial.getCondicionante().setScoringBc(true);
			this.updateScoring(dto, expedienteComercial);
			
			genericDao.save(CondicionanteExpediente.class, expedienteComercial.getCondicionante());
			
			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoEcoCodigo)));
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoEcoBcCodigo)));
	
			expedienteComercialApi.update(expedienteComercial,false);	
			
			ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));
	

		}catch(ParseException e) {
			
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_SCORING};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	private void updateScoring(DtoExpedienteScoring dto, ExpedienteComercial expedienteComercial) {
		ScoringAlquiler scoring = genericDao.get(ScoringAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", expedienteComercial.getId()));
		if(scoring == null) {
			scoring = new ScoringAlquiler();
			scoring.setAuditoria(Auditoria.getNewInstance());
			scoring.setExpediente(expedienteComercial);
		}
		
		if(dto.getEstadoEscoring() != null) {
			scoring.setResultadoScoringBc(genericDao.get(DDResultadoScoring.class, genericDao.createFilter(FilterType.EQUALS, "codigo",  dto.getEstadoEscoring())));
		}
		scoring.setFechaSancionBc(dto.getFechaResolucion());
		scoring.setMotivoRechazo(dto.getMotivoRechazo());
		if(dto.getCodigoRating() != null) {
			scoring.setRatingScoringServicer(genericDao.get(DDRatingScoringServicer.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoRating())));
		}
		scoring.setNumeroExpedienteBc(dto.getNumExpedienteExterno());
		
		
		genericDao.save(ScoringAlquiler.class, scoring);
	}
}
