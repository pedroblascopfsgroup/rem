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
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;

@Component
public class UpdaterServiceSancionOfertaAlquileresSancionPatrimonio implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresSancionPatrimonio.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";

	private static final String CODIGO_T015_SANCION_PATRIMONIO = "T015_SancionPatrimonio";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		boolean estadoBcModificado = false;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.NO.equals(valor.getValor())) {
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
					
				} else if(DDSiNo.SI.equals(valor.getValor())) {
					//Cambiar estado ANULADO del expediente por el que toca en el ítem
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADO);
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expedienteComercial.setEstado(estado);
					
					//Cambiar estado ANULADO del expedienteBc por el que toca en el ítem
					Filter filtroBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA);
					DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, filtroBc);
					expedienteComercial.setEstadoBc(estadoBc);
					
					estadoBcModificado = true;
					
					genericDao.save(ExpedienteComercial.class, expedienteComercial);
				}
			}
		}
		
		expedienteComercialApi.update(expedienteComercial,false);
		
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlush(expedienteComercial.getOferta());
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_SANCION_PATRIMONIO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		// TODO Auto-generated method stub
		
	}

}
