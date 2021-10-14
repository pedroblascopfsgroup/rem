package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceAnalisisTecnicoAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceAnalisisTecnicoAlquilerNoComercial.class);
    
	private static final String COMBO_CERTIFICACIONES_OBTENIDAS = "certificacionesObtenidas";
	private static final String COMBO_ADECUACIONES = "requiereAdecuaciones";

	private static final String CODIGO_T018_ANALISIS_TECNICO = "T018_AnalisisTecnico";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		CondicionanteExpediente coe = expedienteComercial.getCondicionante();
		
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		
		estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_NEGOCIACION));
		estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.PTE_SANCION_BC));
		
		expedienteComercial.setEstado(estadoExpedienteComercial);
		expedienteComercial.setEstadoBc(estadoExpedienteBc);

		for(TareaExternaValor valor :  valores){
			if(COMBO_CERTIFICACIONES_OBTENIDAS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				coe.setCertificaciones(DDSiNo.SI.equals(valor.getValor()));
			}else if(COMBO_ADECUACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				coe.setAdecuaciones(DDSiNo.SI.equals(valor.getValor()));
			}
		}
		
		genericDao.save(CondicionanteExpediente.class, coe);
		
		expedienteComercialApi.update(expedienteComercial,false);	
		
		ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_ANALISIS_TECNICO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
