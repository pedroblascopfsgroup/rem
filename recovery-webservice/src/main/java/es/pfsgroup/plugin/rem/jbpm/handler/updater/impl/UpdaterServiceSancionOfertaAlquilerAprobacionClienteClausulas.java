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
    	
	private static final String COMBO_CLIENTE_ACEPTA = "comboAcepta";
	private static final String COMBO_CONTRAOFERTA = "comboContraoferta";
	private static final String CAMPO_OBSERVACIONES = "observaciones";
	private static final String CAMPO_JUSTIFICACION = "justificacion";

	private static final String CODIGO_T015_APROBACION_CLIENTE_CLAUSULAS = "T015_AprobacionClienteClausulas";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		
		boolean anulacion = false;
		String estadoBc = null;
		String codigoMotivo = null;
		String observaciones = null;
		
		for(TareaExternaValor valor :  valores) {
			
			if(COMBO_CLIENTE_ACEPTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()) && DDSiNo.SI.equals(valor.getValor())) {
				estadoBc =  DDEstadoExpedienteBc.CODIGO_BORRADOR_ACEPTADO;
			}
			
		
			if(COMBO_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.NO.equals(valor.getValor())) {
					anulacion = true;
					estadoBc =  DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
				} else if (DDSiNo.SI.equals(valor.getValor())) {
					estadoBc = DDEstadoExpedienteBc.CODIGO_PTE_VALIDACION_CAMBIOS_CLAUSURADO;
				}
			}
			
			
			if(CAMPO_OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				observaciones = valor.getValor();
			}
			
			if(CAMPO_JUSTIFICACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				codigoMotivo = valor.getValor();
			}
		}
		

		
		if(anulacion) {
			Oferta oferta = expedienteComercial.getOferta();
			expedienteComercial.setFechaAnulacion(new Date());
			//expedienteComercial.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoMotivo)));
			expedienteComercial.setDetalleAnulacionCntAlquiler(observaciones);
			
			if(oferta != null) {
				ofertaApi.finalizarOferta(oferta);
			}
			
		}
		
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));
		genericDao.save(ExpedienteComercial.class, expedienteComercial);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_APROBACION_CLIENTE_CLAUSULAS};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
}
