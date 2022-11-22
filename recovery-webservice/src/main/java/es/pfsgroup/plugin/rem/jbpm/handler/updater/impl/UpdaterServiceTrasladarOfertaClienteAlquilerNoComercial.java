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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoTareaPbc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;

@Component
public class UpdaterServiceTrasladarOfertaClienteAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
  
    protected static final Log logger = LogFactory.getLog(UpdaterServiceTrasladarOfertaClienteAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String FECHA_RESOLUCION = "fechaResolucion";

	private static final String CODIGO_T018_TRASLADAR_OFERTA_CLIENTE = "T018_TrasladarOfertaCliente";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		
		String estadoExpedienteComercial = null;
		String estadoExpedienteBc = null;

		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					estadoExpedienteComercial =  DDEstadosExpedienteComercial.PTE_PBC_ALQUILER_HRE;
					// estadoExpedienteBc = DDEstadoExpedienteBc.PTE_PBC_ALQUILER_HRE;

				}else {
					estadoExpedienteComercial = DDEstadosExpedienteComercial.PTE_REVISAR_CONDICIONES_BC;
					estadoExpedienteBc = DDEstadoExpedienteBc.PTE_REVISAR_CONDICIONES_BC;
				}
				
				expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", estadoExpedienteComercial)));

				if (estadoExpedienteBc != null) {
					expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExpedienteBc)));
				}
			}
		}

		Filter filterOferta =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", expedienteComercial.getOferta().getId());
		Filter filterTipoPbc =  genericDao.createFilter(FilterType.EQUALS, "tipoTareaPbc.codigo", DDTipoTareaPbc.CODIGO_PBC);
		Filter filterActiva =  genericDao.createFilter(FilterType.EQUALS, "activa", true);
		HistoricoTareaPbc historico = genericDao.get(HistoricoTareaPbc.class, filterOferta, filterTipoPbc, filterActiva);

		if (historico != null) {
			historico.setActiva(false);

			genericDao.save(HistoricoTareaPbc.class, historico);
		}

		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTareaPbc.CODIGO_PBC);
		DDTipoTareaPbc tpb = genericDao.get(DDTipoTareaPbc.class, filtroTipo);

		HistoricoTareaPbc htp = new HistoricoTareaPbc();
		htp.setOferta(expedienteComercial.getOferta());
		htp.setTipoTareaPbc(!Checks.esNulo(tpb) ? tpb : null);

		genericDao.save(HistoricoTareaPbc.class, htp);

		genericDao.save(ExpedienteComercial.class, expedienteComercial);
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_TRASLADAR_OFERTA_CLIENTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
