package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

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
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoOfertaAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOfertaAlquiler;

@Component
public class UpdaterServiceDefinicionOfertaAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceDefinicionOfertaAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_DEFINICION_OFERTA = "T018_DefinicionOferta";
	private static final String TIPO_OFERTA_ALQUILER = "tipoOfertaAlquiler";
	private static final String VULNERABLE = "isVulnerable";
	private static final String CONTRATO_ANTERIOR = "numContratoAnterior";
	private static final String FECHA_CONTRATO_ANTERIOR = "fechaContratoAnt";
	private static final String RIESGO_REPUTACIONAL = "riesgoReputacional";
	private static final String CONFLICTO_INTERESES = "conflictoIntereses";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		String codigoOfertaAlquiler = null;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		CondicionanteExpediente coe = expedienteComercial.getCondicionante();

		
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		
		for(TareaExternaValor valor :  valores){

			if(TIPO_OFERTA_ALQUILER.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				codigoOfertaAlquiler = valor.getValor();
			}
			if(VULNERABLE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Boolean vulnerabilidadDetectada = DDSinSiNo.cambioStringtoBooleano(valor.getValor());
				coe.setVulnerabilidadDetectada(vulnerabilidadDetectada);
			}
			if(CONTRATO_ANTERIOR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				expedienteComercial.setNumContratoAnterior(valor.getValor());
			}
			try {
				if(FECHA_CONTRATO_ANTERIOR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					expedienteComercial.setFechaFinContratoAnterior(ft.parse(valor.getValor()));
				}
			}catch (ParseException pe){
				logger.error("error parseando fecha contrato anterior");
			}
			if (RIESGO_REPUTACIONAL.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				expedienteComercial.setRiesgoReputacional(DDSinSiNo.cambioStringToIntger(valor.getValor()));
			}
			if (CONFLICTO_INTERESES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				expedienteComercial.setConflictoIntereses(DDSinSiNo.cambioStringToIntger(valor.getValor()));
			}
		}
		
		estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_SCREENING_Y_ANALISIS_BC));
		estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.PTE_SCREENING_Y_ANALISIS_BC));
		
		DDSubtipoOfertaAlquiler subtipoOfertaAlquiler = genericDao.get(DDSubtipoOfertaAlquiler.class,genericDao.createFilter(FilterType.EQUALS,"codigo", codigoOfertaAlquiler));
		
		DDTipoOfertaAlquiler tipoOfertaAlquiler = subtipoOfertaAlquiler.getTipoOfertaAlquiler();
		
		oferta.setTipoOfertaAlquiler(tipoOfertaAlquiler);
		
		expedienteComercial.setEstado(estadoExpedienteComercial);
		expedienteComercial.setEstadoBc(estadoExpedienteBc);

		genericDao.save(Oferta.class, oferta);
		expedienteComercialApi.update(expedienteComercial,false);	

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_DEFINICION_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
