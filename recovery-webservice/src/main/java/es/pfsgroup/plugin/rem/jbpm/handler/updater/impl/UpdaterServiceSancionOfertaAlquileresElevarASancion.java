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
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoSancionesBc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDComiteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionOferta;
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
	private static final String IMPORTE_CONTRAOFERTA = "importeContraoferta";
	private static final String OBSERVACIONESBC = "observacionesBC";
	
	private static final String CODIGO_T015_ELEVAR_A_SANCION = "T015_ElevarASancion";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		String peticionario = null;
		DtoRespuestaBCGenerica dtoHistoricoBC = new DtoRespuestaBCGenerica();
		dtoHistoricoBC.setComiteBc(DDComiteBc.CODIGO_COMITE_COMERCIAL);
		String fechaSancion = null;
		boolean aprobado = true;
		
		for(TareaExternaValor valor :  valores){

			if(RESOLUCION_OFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				aprobado = this.ponerEstadosExpediente(expedienteComercial, valor.getValor(), oferta, tramite);
			}
			
			if(FECHA_SANCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				fechaSancion = valor.getValor();
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
				ofertaApi.finalizarOferta(oferta);
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
			
			if(IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				oferta.setImporteContraOferta(Double.parseDouble(valor.getValor().replace(",",".")));
			}
			
			if(OBSERVACIONESBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				dtoHistoricoBC.setObservacionesBC(valor.getValor());
			}
		}
		
		if(fechaSancion != null) {
			try {
				expedienteComercial.setFechaSancion(ft.parse(fechaSancion));
			} catch (ParseException e) {
				logger.error("Error insertando Fecha Sancion.", e);
			}
		}else {
			expedienteComercial.setFechaSancion(new Date());
		}
		
		expedienteComercial.setOferta(oferta);
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), expedienteComercial.getEstado());

		expedienteComercialApi.update(expedienteComercial,false);
		
		if(aprobado) {
			dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_APRUEBA);
		}else {
			dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
		}

		HistoricoSancionesBc historico = expedienteComercialApi.dtoRespuestaToHistoricoSancionesBc(dtoHistoricoBC, expedienteComercial);
				
		genericDao.save(HistoricoSancionesBc.class, historico);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_ELEVAR_A_SANCION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	
	private boolean ponerEstadosExpediente(ExpedienteComercial eco, String resolucion, Oferta oferta, ActivoTramite tramite) {
		String codigoEstadoExpediente = null;
		String codigoEstadoBc = null;
		boolean aprobado = true;
		
		if(DDRespuestaOfertante.CODIGO_ACEPTA.equals(resolucion)) {
			codigoEstadoExpediente =  DDEstadosExpedienteComercial.PTE_SCORING;
			aprobado = true;
		
			DDEstadosExpedienteComercial estadoExpComercial =  (DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class, DDEstadosExpedienteComercial.PTE_SANCION_COMITE);
			eco.setEstado(estadoExpComercial);
			codigoEstadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_PDTE_SCORING;

			// Una vez aprobado el expediente, se congelan el resto de ofertas que no
			// estén rechazadas (aceptadas y pendientes)
			List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
			for (Oferta ofertaCongelar : listaOfertas) {
				if (!ofertaCongelar.getId().equals(oferta.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(ofertaCongelar.getEstadoOferta().getCodigo())) {
					ofertaApi.congelarOferta(ofertaCongelar);
				}
			}

		}else if(DDRespuestaOfertante.CODIGO_RECHAZA.equals(resolucion)) {
			codigoEstadoExpediente =  DDEstadosExpedienteComercial.ANULADO;
			aprobado = false;
			DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA);
			oferta.setEstadoOferta(estadoOferta);
			codigoEstadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_CANCELADA;

		}else if(DDRespuestaOfertante.CODIGO_CONTRAOFERTA.equals(resolucion)){
			codigoEstadoExpediente = DDEstadosExpedienteComercial.CONTRAOFERTADO;
			codigoEstadoBc = DDEstadoExpedienteBc.CODIGO_CONTRAOFERTADO;
			aprobado = false;
		}
		
		if(codigoEstadoExpediente != null) {
			eco.setEstado((DDEstadosExpedienteComercial) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadosExpedienteComercial.class, codigoEstadoExpediente));
		}
		
		if(oferta.getActivoPrincipal() !=null && DDCartera.isCarteraBk(oferta.getActivoPrincipal().getCartera()) && codigoEstadoBc != null) {
			eco.setEstadoBc((DDEstadoExpedienteBc) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoExpedienteBc.class, codigoEstadoBc));
		}

		return aprobado;
	}

}
