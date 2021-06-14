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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.oferta.NotificationOfertaManager;

@Component
public class UpdaterServiceSancionOfertaAlquileresResolucionExpediente implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private NotificationOfertaManager notificatorOfertaManager;
    
    @Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
        
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresResolucionExpediente.class);
			
    private static final String RESOLUCION_EXPEDIENTE = "resolucionExpediente";
	private static final String FECHA_RESOLUCION = "fechaResolucion";
	private static final String MOTIVO = "motivo";
	private static final String IMPORTE_CONTRAOFERTA = "importeContraoferta";
	
	private static final String CODIGO_T015_RESOLUCION_EXPEDIENTE = "T015_ResolucionExpediente";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoOferta estadoOferta = null;
	
		for(TareaExternaValor valor :  valores){

			if(RESOLUCION_EXPEDIENTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				
				if(DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_PBC));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

					estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_ACEPTADA);
					oferta.setEstadoOferta(estadoOferta);
					
					notificatorOfertaManager.enviarMailAprobacion(oferta);
					
					//comprobamos si existen más ofertas para ese activo en estado pendiente. Si es así, las pasamos a congeladas
					List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
					for (Oferta ofertaB : listaOfertas) {
						if (!ofertaB.getId().equals(oferta.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(ofertaB.getEstadoOferta().getCodigo())) {
							ofertaApi.congelarOferta(ofertaB);
						}
					}

				}else if(DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.ANULADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

					estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA);
					oferta.setEstadoOferta(estadoOferta);

				}else if(DDResolucionComite.CODIGO_CONTRAOFERTA.equals(valor.getValor())) {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.CONTRAOFERTADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

				}
			}
			
			if(FECHA_RESOLUCION.equals(valor.getNombre())) {
				try {
					if (!Checks.esNulo(valor.getValor())) {
						expedienteComercial.setFechaSancion(ft.parse(valor.getValor()));
					} else {
						expedienteComercial.setFechaSancion(new Date());
					}
				} catch (ParseException e) {
					logger.error("Error insertando Fecha Sancion Comite.", e);
				}
			}
			
			if(MOTIVO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				String peticionario = null;
			
				Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
				DDMotivoRechazoExpediente motivoAnulacion = genericDao.get(DDMotivoRechazoExpediente.class, filtroMotivo);
				expedienteComercial.setMotivoRechazo(motivoAnulacion);
				
				// Guardamos el usuario que realiza la tarea
				TareaExterna tex = valor.getTareaExterna();
				if (!Checks.esNulo(tex)) {
					TareaNotificacion tar = tex.getTareaPadre();
					peticionario = tar.getAuditoria().getUsuarioBorrar();
				}
				expedienteComercial.setPeticionarioAnulacion(peticionario);
			}
			
			if(IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				oferta.setImporteContraOferta(Double.parseDouble(valor.getValor()));
			}
		}
		expedienteComercial.setOferta(oferta);
		expedienteComercialApi.update(expedienteComercial,false);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_RESOLUCION_EXPEDIENTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
