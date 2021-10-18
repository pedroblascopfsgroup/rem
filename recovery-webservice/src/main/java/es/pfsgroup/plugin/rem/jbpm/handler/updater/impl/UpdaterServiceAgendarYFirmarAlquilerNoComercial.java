package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

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
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;

@Component
public class UpdaterServiceAgendarYFirmarAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private ActivoDao activoDao;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarYFirmarAlquilerNoComercial.class);
    

	private static final String CODIGO_T018_AGENDAR_Y_FIRMAR = "T018_AgendarYFirmar";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		
		
		estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.FIRMADO));
		estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO));
		expedienteComercial.setEstado(estadoExpedienteComercial);
		expedienteComercial.setEstadoBc(estadoExpedienteBc);		 		
		
		genericDao.save(ExpedienteComercial.class, expedienteComercial);

		ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_AGENDAR_Y_FIRMAR};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
