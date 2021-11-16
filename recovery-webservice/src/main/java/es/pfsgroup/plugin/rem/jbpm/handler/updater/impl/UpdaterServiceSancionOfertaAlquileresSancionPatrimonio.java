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
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoSancionesBc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDComiteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaAlquileresSancionPatrimonio implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresSancionPatrimonio.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	
	private static final String OBSERVACIONESBC = "observacionesBC";

	private static final String CODIGO_T015_SANCION_PATRIMONIO = "T015_SancionPatrimonio";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		boolean estadoBcModificado = false;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		
		DtoRespuestaBCGenerica dtoHistoricoBC = new DtoRespuestaBCGenerica();
		dtoHistoricoBC.setComiteBc(DDComiteBc.CODIGO_COMITE_COMERCIAL);
		dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_APRUEBA);
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					//Cambiar estado ANULADO del expediente por el que toca en el ítem
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_ENVIO);
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expedienteComercial.setEstado(estado);
					
					//Cambiar estado ANULADO del expedienteBc por el que toca en el ítem
					Filter filtroBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_PTE_ENVIO);
					DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, filtroBc);
					expedienteComercial.setEstadoBc(estadoBc);

					estadoBcModificado = true;
					
					genericDao.save(ExpedienteComercial.class, expedienteComercial);
					
				} else if(DDSiNo.NO.equals(valor.getValor())) {
					//Cambiar estado ANULADO del expediente por el que toca en el ítem
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADO);
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expedienteComercial.setEstado(estado);
					
					//Cambiar estado ANULADO del expedienteBc por el que toca en el ítem
					Filter filtroBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO);
					DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, filtroBc);
					expedienteComercial.setEstadoBc(estadoBc);
					ofertaApi.finalizarOferta(oferta);
					
					estadoBcModificado = true;
					
					genericDao.save(ExpedienteComercial.class, expedienteComercial);
				}
			}
			
			if(OBSERVACIONESBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				dtoHistoricoBC.setObservacionesBC(valor.getValor());
			}
		}
		
		expedienteComercialApi.update(expedienteComercial,false);
		
		HistoricoSancionesBc historico = expedienteComercialApi.dtoRespuestaToHistoricoSancionesBc(dtoHistoricoBC, expedienteComercial);
		
		genericDao.save(HistoricoSancionesBc.class, historico);

		
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expedienteComercial));
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_SANCION_PATRIMONIO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
