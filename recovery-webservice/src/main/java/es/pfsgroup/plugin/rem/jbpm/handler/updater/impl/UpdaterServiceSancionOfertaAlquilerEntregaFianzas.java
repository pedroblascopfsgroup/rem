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
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaAlquilerEntregaFianzas implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquilerEntregaFianzas.class);
    	
	private static final String COMBO_FIANZA = "comboFianza";
	private static final String COMBO_FECHA_ABONO = "fechaAbono";
	private static final String COMBO_JUSTIFICACION = "justificacion";
	private static final String CAMPO_OBSERVACIONES = "observaciones";

	private static final String CODIGO_T015_ENTREGA_FIANZAS = "T015_EntregaFianzas";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		boolean estadoBcModificado = false;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean aprueba = false;
		String estadoExp = null;
		String estadoBc = null;
		String observaciones = null;
		DDEstadoExpedienteBc estadoExpBC = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {					
					aprueba = true;
				}
			}
			if(CAMPO_OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				observaciones = valor.getValor();
			}
			
		}
		
		if (aprueba) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "740");
			estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			/*estadoExp =  DDEstadosExpedienteComercial.PTE_ENVIO;
			estadoBc =  DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO;*/
		} else{
			boolean reagendaMas2Veces = tramiteAlquilerApi.getRespuestaHistReagendacionMayor(tareaExternaActual);
			if(reagendaMas2Veces) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "120");
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			}else {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoC4C", "100");
				estadoExpBC = genericDao.get(DDEstadoExpedienteBc.class,filtro);
			}
			//estadoExp =  DDEstadosExpedienteComercial.DENEGADO;
			//estadoBc =  DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
			/*Oferta oferta = expedienteComercial.getOferta();
			expedienteComercial.setFechaAnulacion(new Date());
			expedienteComercial.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoAnulacionExpediente.COD_CAIXA_RECHAZADO_PBC)));
			expedienteComercial.setDetalleAnulacionCntAlquiler(observaciones);
			
			if(oferta != null) {
				ofertaApi.finalizarOferta(oferta);
			}*/
		}
		
		/*expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExp)));*/
		expedienteComercial.setEstadoBc(estadoExpBC);
		estadoBcModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_ENTREGA_FIANZAS};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
}
