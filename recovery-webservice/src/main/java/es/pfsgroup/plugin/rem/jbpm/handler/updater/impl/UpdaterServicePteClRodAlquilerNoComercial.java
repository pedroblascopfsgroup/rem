package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
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
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoSancionesBc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.RespuestaComiteBC;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDComiteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;

@Component
public class UpdaterServicePteClRodAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServicePteClRodAlquilerNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String SANCION_CL_ROD = "sancionCLROD";
	private static final String FECHA_RESOLUCION = "fechaResolucion";
	private static final String OBSERVACIONES = "observaciones";
	private static final String OBSERVACIONESBC = "observacionesBC";
	private static final String CODIGO_T018_PTE_CL_ROD = "T018_PteClRod";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoExpedienteBc estadoExpedienteBc = null;
		DDResolucionComite resolucionComite = null;
		String sancionCLROD = null;
		RespuestaComiteBC respuestaComiteBc = new RespuestaComiteBC();
		
		DtoRespuestaBCGenerica dtoHistoricoBC = new DtoRespuestaBCGenerica();
		dtoHistoricoBC.setComiteBc(DDComiteBc.CODIGO_PTCLROD);
		
		for(TareaExternaValor valor :  valores){
			
			if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())) {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_TRASLADAR_OFERTA_AL_CLIENTE));
					estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.PTE_TRASLADAR_OFERTA_AL_CLIENTE));
					
					resolucionComite = genericDao.get(DDResolucionComite.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDResolucionComite.CODIGO_APRUEBA));
					dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_APRUEBA);
				} else {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.ANULADO));
					estadoExpedienteBc = genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA));
					ofertaApi.rechazarOferta(oferta);
					
					resolucionComite = genericDao.get(DDResolucionComite.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDResolucionComite.CODIGO_RECHAZA));
					dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
				}
								
				expedienteComercial.setEstado(estadoExpedienteComercial);
				expedienteComercial.setEstadoBc(estadoExpedienteBc);
				
				if (resolucionComite != null) {
					respuestaComiteBc.setValidacionBcRBC(resolucionComite);
				}
			}
			
			if(SANCION_CL_ROD.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				sancionCLROD = valor.getValor();
				respuestaComiteBc.setSancionClRod(sancionCLROD);
			}
			
			if(OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				respuestaComiteBc.setObservacionesBcRBC(valor.getValor());
			}
			
			if(OBSERVACIONESBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				dtoHistoricoBC.setObservacionesBC(valor.getValor());	
			}
			
			if(FECHA_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					respuestaComiteBc.setFechaRespuestaBcRBC(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha Resolucion. ", e);
				}
			}
			
			if (oferta != null && DDTipoOferta.CODIGO_ALQUILER_NO_COMERCIAL.equals(oferta.getTipoOferta().getCodigo())) {
				respuestaComiteBc.setComiteRBC(false);
			} else {
				respuestaComiteBc.setComiteRBC(true);
			}
			
			if (expedienteComercial != null) {
				respuestaComiteBc.setExpedienteComercial(expedienteComercial);
			}
			
		}
		
		HistoricoSancionesBc historico = expedienteComercialApi.dtoRespuestaToHistoricoSancionesBc(dtoHistoricoBC, expedienteComercial);
		
		genericDao.save(HistoricoSancionesBc.class, historico);
		
		genericDao.save(RespuestaComiteBC.class, respuestaComiteBc);
		
		expedienteComercialApi.update(expedienteComercial, false);	
		
		ofertaApi.replicateOfertaFlushDto(expedienteComercial.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpedienteAndSancionCLROD(expedienteComercial, sancionCLROD));

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_PTE_CL_ROD};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
