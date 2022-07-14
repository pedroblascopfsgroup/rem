package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;

@Component
public class UpdaterServiceSancionOfertaAlquilerAprobacionClienteClausulas implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquilerAprobacionClienteClausulas.class);
    	
	private static final String COMBO_CLIENTE_ACEPTA_BORRADOR = "comboClienteAceptaBor";
	private static final String FECHA_ACEPTACION = "fechaFirma";
	private static final String COMBO_BC_RENEGOCIA = "comboBcRenegocia";
	private static final String CAMPO_JUSTIFICACION = "justificacion";
	private static final String CAMPO_OBSERVACIONES = "observaciones";

	private static final String CODIGO_T015_APROBACION_CLIENTE_CLAUSULAS = "T015_AprobacionClienteClausulas";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		boolean estadoBcModificado = false;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean aprueba = false;
		boolean apruebaBcReneg = false;
		String estadoExp = null;
		String estadoBc = null;
		String comboClienteAceptaBor = null;
		String fechaFirma = null;
		String comboBcRenegocia = null;
		String justificacion = null;
		String observaciones = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_CLIENTE_ACEPTA_BORRADOR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {					
					aprueba = true;
					comboClienteAceptaBor = valor.getValor();
				}
			}
			if(FECHA_ACEPTACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				fechaFirma = valor.getValor();
			}
			if(COMBO_BC_RENEGOCIA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if (DDSiNo.SI.equals(valor.getValor())) {					
					apruebaBcReneg = true;
					comboClienteAceptaBor = valor.getValor();
				}
			}
			if(CAMPO_OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				observaciones = valor.getValor();
			}
			
		}
		
		if (aprueba) {
			/*estadoExp =  DDEstadosExpedienteComercial.PTE_ENVIO;
			estadoBc =  DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO;*/
		} else if(!aprueba && !apruebaBcReneg) {
			estadoExp =  DDEstadosExpedienteComercial.DENEGADO;
			estadoBc =  DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
			Oferta oferta = expedienteComercial.getOferta();
			expedienteComercial.setFechaAnulacion(new Date());
			expedienteComercial.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoAnulacionExpediente.COD_CAIXA_RECHAZADO_PBC)));
			expedienteComercial.setDetalleAnulacionCntAlquiler(observaciones);
			
			if(oferta != null) {
				ofertaApi.finalizarOferta(oferta);
			}
			
			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExp)));
			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));
			estadoBcModificado = true;
			genericDao.save(ExpedienteComercial.class, expedienteComercial);
		} else if(!aprueba && apruebaBcReneg) {
			/*estadoExp =  DDEstadosExpedienteComercial.DENEGADO;
			estadoBc =  DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
			Oferta oferta = expedienteComercial.getOferta();
			expedienteComercial.setFechaAnulacion(new Date());
			expedienteComercial.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoAnulacionExpediente.COD_CAIXA_RECHAZADO_PBC)));
			expedienteComercial.setDetalleAnulacionCntAlquiler(observaciones);
			
			if(oferta != null) {
				ofertaApi.finalizarOferta(oferta);
			}*/
		} 
		
		/*expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExp)));
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));
		estadoBcModificado = true;
		genericDao.save(ExpedienteComercial.class, expedienteComercial);*/
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_APROBACION_CLIENTE_CLAUSULAS};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
}
