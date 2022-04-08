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
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaAlquilerEnvioContrato implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquilerEnvioContrato.class);
    
	
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String FECHA_ENVIO = "fechaEnvio";

	private static final String CODIGO_T015_ENVIO_CONTRATO = "T015_EnvioContrato";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		boolean estadoBcModificado = false;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		
		DDEstadosExpedienteComercial estadoExp = null;
		DDEstadoExpedienteBc estadoBc = null;
		String fechaEnvio = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {					
					estadoExp = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_AGENDAR));
					estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO));
					estadoBcModificado = true;
				}else if (DDSiNo.NO.equals(valor.getValor())) {				
					estadoExp = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_ENVIO));
					estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_PTE_SANCION_PATRIMONIO));
					estadoBcModificado = true;

				}
				if(estadoBcModificado) {
					expedienteComercial.setEstadoBc(estadoBc);	
				}
				expedienteComercial.setEstado(estadoExp);
			}
			if(FECHA_ENVIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				fechaEnvio = valor.getValor();
			}
		}

		expedienteComercialApi.update(expedienteComercial,false);

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_ENVIO_CONTRATO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}


}
