package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaExclusionBulk;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.thread.TransaccionExclusionBulk;

@Component
public class UpdaterServiceSancionOfertaRespuestaOfertanteCES implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private OfertaDao ofertaDao;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaRespuestaOfertanteCES.class);
	 
 	private static final String CODIGO_T017_RESPUESTA_OFERTANTE_CES = "T017_RespuestaOfertanteCES";
 	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
 	private static final String COMBO_RESPUESTA = "comboRespuesta";
 	private static final String FECHA_RESPUESTA = "fechaRespuesta";
 	private static final String IMPORTE_CONTRAOFERTA_OFERTANTE = "importeContraofertaOfertante";
 
 	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
 
 	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {	
	 	try {
	 		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
	 		ExpedienteComercial expediente = expedienteComercialApi
	 				.expedienteComercialPorOferta(ofertaAceptada.getId());
	 		
	 		Activo activo = ofertaAceptada.getActivoPrincipal();
	 		OfertaExclusionBulk ofertaExclusionBulkNew = null;
	 		
	 		for (TareaExternaValor valor : valores) {			
	 			if (FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
	 				SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");
	 				ofertaAceptada.setFechaRespuestaCES(formatter.parse(valor.getValor()));
	 				genericDao.save(Oferta.class, ofertaAceptada);
	 			}else if (COMBO_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
	 				if (DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
	 					Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadosExpedienteComercial.APROBADO_CES_PTE_PRO_MANZANA);
	 					DDEstadosExpedienteComercial aprobado = genericDao.get(DDEstadosExpedienteComercial.class, f1);
	 					expediente.setEstado(aprobado);
	 				}else if (DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
	 					ofertaApi.rechazarOferta(ofertaAceptada);
	 					Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADA_OFERTA_CES);
	 					DDEstadosExpedienteComercial denegado = genericDao.get(DDEstadosExpedienteComercial.class, f1);
	 					expediente.setEstado(denegado);
	 					Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
	 					tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
	 					genericDao.save(ActivoTramite.class, tramite);
	 				}else if(DDResolucionComite.CODIGO_CONTRAOFERTA.equals(valor.getValor())) {
	 					Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_SANCION_CES);
	 					DDEstadosExpedienteComercial contraoferta = genericDao.get(DDEstadosExpedienteComercial.class, f1);
	 					expediente.setEstado(contraoferta);
	 				}
	 			}else if(IMPORTE_CONTRAOFERTA_OFERTANTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
	 				String doubleValue = valor.getValor();
					doubleValue = doubleValue.replace(',', '.');
					Double nuevoImporte = Double.valueOf(doubleValue);
					
					ofertaAceptada.setImporteContraofertaOfertanteCES(nuevoImporte);
					ofertaAceptada.setImporteContraOferta(nuevoImporte);
					
					if(activo != null && activo.getSubcartera() != null &&
							(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo())
							|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
						String codigoBulk = nuevoImporte > 750000d ? DDSinSiNo.CODIGO_SI : DDSinSiNo.CODIGO_NO;
						
						OfertaExclusionBulk ofertaExclusionBulk = genericDao.get(OfertaExclusionBulk.class, 
								genericDao.createFilter(FilterType.EQUALS, "oferta", ofertaAceptada),
								genericDao.createFilter(FilterType.NULL, "fechaFin"));
						
						Usuario usuarioModificador = genericAdapter.getUsuarioLogado();
						
						if(ofertaExclusionBulk != null && ofertaExclusionBulk.getExclusionBulk() != null
								&& !ofertaExclusionBulk.getExclusionBulk().getCodigo().equals(codigoBulk)) {
							
							Thread thread = new Thread(new TransaccionExclusionBulk(ofertaExclusionBulk.getId(),
									usuarioModificador.getUsername(), usuarioModificador.getId()));
							thread.start();
							try {
								thread.join();
							} catch (InterruptedException e) {
								logger.error("Error generando registro exclsion bulk", e);
							}
							
						}
						
						if(ofertaExclusionBulk == null || !ofertaExclusionBulk.getExclusionBulk().getCodigo().equals(codigoBulk)) {
							ofertaExclusionBulkNew = new OfertaExclusionBulk();
							DDSinSiNo sino = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoBulk));
							
							ofertaExclusionBulkNew.setOferta(ofertaAceptada);
							ofertaExclusionBulkNew.setExclusionBulk(sino);
							ofertaExclusionBulkNew.setFechaInicio(new Date());
							ofertaExclusionBulkNew.setUsuarioAccion(usuarioModificador);
						}
					}

					// Actualizar honorarios para el nuevo importe de contraoferta.
					expedienteComercialApi.actualizarHonorariosPorExpediente(expediente.getId());

					// Actualizamos la participación de los activos en la oferta;
					expedienteComercialApi.updateParticipacionActivosOferta(ofertaAceptada);
					expedienteComercialApi.actualizarImporteReservaPorExpediente(expediente);
	 			}
	 		}
	 		if(ofertaExclusionBulkNew != null) {
				genericDao.save(OfertaExclusionBulk.class, ofertaExclusionBulkNew);
			}
	 		genericDao.save(Oferta.class, ofertaAceptada);
	 		genericDao.save(ExpedienteComercial.class, expediente);
	 	}catch(ParseException e) {
	 		 e.printStackTrace();
	 	}
 	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_RESPUESTA_OFERTANTE_CES };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
