package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
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
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionOferta;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionOferta;
import es.pfsgroup.plugin.rem.model.dd.DDRespuestaOfertante;

@Component
public class UpdaterServiceSancionOfertaAlquileresElevarASancion implements UpdaterService {

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
        
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresElevarASancion.class);
			
    private static final String RESOLUCION_OFERTA = "resolucionOferta";
	private static final String FECHA_SANCION = "fechaSancion";
	private static final String MOTIVO_ANULACION = "motivoAnulacion";
	private static final String COMITE = "comite";
	private static final String REF_CIRCUITO_CLIENTE = "refCircuitoCliente";
	private static final String FECHA_ELEVACION = "fechaElevacion";
	
	private static final String CODIGO_T015_ELEVAR_A_SANCION = "T015_ElevarASancion";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		String peticionario = null;
		
		for(TareaExternaValor valor :  valores){

			if(RESOLUCION_OFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				this.ponerEstadosExpediente(expedienteComercial, valor.getValor(), oferta);
			}
			
			if(FECHA_SANCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					if(!Checks.esNulo(expedienteComercial))
						expedienteComercial.setFechaSancion(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha Sancion Comite.", e);
				}
			}
			
			if(MOTIVO_ANULACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				DDMotivoAnulacionOferta motivoAnulacion = genericDao.get(DDMotivoAnulacionOferta.class, genericDao.createFilter(FilterType.EQUALS,"codigo", valor.getValor()));
				expedienteComercial.setMotivoAnulacionAlquiler(motivoAnulacion);
				
				// Guardamos el usuario que realiza la tarea
				TareaExterna tex = valor.getTareaExterna();
				if (!Checks.esNulo(tex)) {
					TareaNotificacion tar = tex.getTareaPadre();
					peticionario = tar.getAuditoria().getUsuarioBorrar();
				}
				
				expedienteComercial.setFechaAnulacion(new Date());
				expedienteComercial.setPeticionarioAnulacion(peticionario);
			}
			
			if(COMITE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) { 
				DDComiteAlquiler comiteAlquiler = (DDComiteAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(
						DDComiteAlquiler.class, valor.getValor());
				expedienteComercial.setComiteAlquiler(comiteAlquiler);
			}
				
			if(REF_CIRCUITO_CLIENTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				oferta.setRefCircuitoCliente(valor.getValor());
			}
				
			if(FECHA_ELEVACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					expedienteComercial.setFechaSancionComite(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha elevación.", e);
				}
			}
		}
		
		expedienteComercial.setOferta(oferta);
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), expedienteComercial.getEstado());

		expedienteComercialApi.update(expedienteComercial,false);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_ELEVAR_A_SANCION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	
	private void ponerEstadosExpediente(ExpedienteComercial eco, String resolucion, Oferta oferta) {
		boolean estadoBcModificado = false;
		String codigoEstadoExpediente = null;
		String codigoEstadoBc = null;
	
		
		if(DDRespuestaOfertante.CODIGO_ACEPTA.equals(resolucion)) {
			codigoEstadoExpediente =  DDEstadosExpedienteComercial.PTE_SANCION_COMITE;
		
			DDEstadosExpedienteComercial estadoExpComercial =  (DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class, DDEstadosExpedienteComercial.PTE_SANCION_COMITE);
			eco.setEstado(estadoExpComercial);
			codigoEstadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_PDTE_SCORING;


		}else if(DDRespuestaOfertante.CODIGO_RECHAZA.equals(resolucion)) {
			codigoEstadoExpediente =  DDEstadosExpedienteComercial.ANULADO;

			DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA);
			oferta.setEstadoOferta(estadoOferta);
			codigoEstadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;


		}else if(DDRespuestaOfertante.CODIGO_CONTRAOFERTA.equals(resolucion)){
			codigoEstadoExpediente = DDEstadosExpedienteComercial.CONTRAOFERTADO;
			codigoEstadoBc = DDEstadoExpedienteBc.CODIGO_CONTRAOFERTADO;
		}
		
		if(codigoEstadoExpediente != null) {
			eco.setEstado((DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class, codigoEstadoExpediente));
		}
		
		if(oferta.getActivoPrincipal() !=null && DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera()) && codigoEstadoBc != null) {
			eco.setEstadoBc((DDEstadoExpedienteBc) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoExpedienteBc.class, codigoEstadoBc));
			estadoBcModificado = true;
		}
		
		if(estadoBcModificado) {
			ofertaApi.replicateOfertaFlushDto(eco.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(eco));
		}
	}

}
