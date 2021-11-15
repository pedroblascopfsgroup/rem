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
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
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
	private TramiteAlquilerApi tramiteAlquilerApi;
	
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
	private ActivoAdapter activoAdapter;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarYFirmarAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_AGENDAR_Y_FIRMAR = "T018_AgendarYFirmar";
	private static final String FECHA = "fecha";
	
	private static final String COMBO_IRCLROD = "comboIrClRod";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		boolean firmado = false;

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Activo activo = tramite.getActivo();
		
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		String fechaFirma = null;
		
		for(TareaExternaValor valor :  valores) {
			if(COMBO_IRCLROD.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					tramiteAlquilerApi.irClRod(expedienteComercial);	
				}else {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.FIRMADO));
					estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					expedienteComercial.setEstadoBc(estadoExpedienteBc);		
					firmado = true;
				}
			}

			if(FECHA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				fechaFirma = valor.getValor();
			}
		}

		if(firmado) {

			if(!Checks.esNulo(activo)) {
				activo.setSituacionComercial(genericDao.get(DDSituacionComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_ALQUILADO)));
				activoApi.saveOrUpdate(activo);
				
				activoApi.actualizarOfertasTrabajosVivos(activo);
				activoAdapter.actualizarEstadoPublicacionActivo(tramite.getActivo().getId(), false);
				
				if(activoDao.isActivoMatriz(activo.getId())){
					ActivoAgrupacion activoAgrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
					List<ActivoAgrupacionActivo> listaActivosAgrupacion = activoAgrupacion.getActivos();
					for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivosAgrupacion) {	
						activoAdapter.actualizarEstadoPublicacionActivo(activoAgrupacionActivo.getActivo().getId());
					}
				}
			}
		}
		
		
		ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpedienteAndFechaFirma(expedienteComercial, fechaFirma));
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_AGENDAR_Y_FIRMAR};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
