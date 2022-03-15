package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceContabilidadBbva;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.rest.dao.impl.GenericaRestDaoImp;

@Component
public class UpdaterServiceSancionOfertaCierreEconomico implements UpdaterService {

   	private static final String CODIGO_T013_CIERRE_ECONOMICO = "T013_CierreEconomico";
   	private static final String CODIGO_T017_CIERRE_ECONOMICO = "T017_CierreEconomico";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_SUBCARTERA_OMEGA = "65";
	private static final String CODIGO_T013_DOCUMENTOS_POST_VENTA = "T013_DocumentosPostVenta";
	private static final String CODIGO_T017_DOCUMENTOS_POST_VENTA = "T017_DocsPosVenta";
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaCierreEconomico.class);
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	ActivoApi activoApi;
	
	@Autowired
	ActivoDao activoDao;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private NotificatorServiceContabilidadBbva notificatorServiceContabilidadBbva;
	
	@Autowired
	private GenericaRestDaoImp genericaRestDaoImp;
    
    
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Activo activo = ofertaAceptada.getActivoPrincipal();
		Filter filtro = null;
		boolean pasaAVendido = false;
		boolean updateEstadoExp = true;
		
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			DDEstadosExpedienteComercial estado = null;

			if (!Checks.esNulo(expediente)) { 
				String codSubCartera = null;
				if (!Checks.esNulo(activo.getSubcartera())) {
					codSubCartera = activo.getSubcartera().getCodigo();
				}
				if (CODIGO_SUBCARTERA_OMEGA.equals(codSubCartera)) {
					filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
					estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expediente.setEstado(estado);
					pasaAVendido = true;
					// Finaliza el trámite
					Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
					tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
					genericDao.save(ActivoTramite.class, tramite);
				} else {
					
					List<TareaExterna> tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(tramite.getId());
					for (TareaExterna tarea : tareasTramite) {
						if (CODIGO_T013_DOCUMENTOS_POST_VENTA.equals(tarea.getTareaProcedimiento().getCodigo())
								|| CODIGO_T017_DOCUMENTOS_POST_VENTA.equals(tarea.getTareaProcedimiento().getCodigo())) {
							updateEstadoExp = false;
						}
					}
					if(ofertaAceptada.getActivoPrincipal() != null && DDCartera.CODIGO_CARTERA_LIBERBANK.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.FIRMADO);
					} else if (ofertaAceptada.getActivoPrincipal() != null && DDCartera.isCarteraBk(ofertaAceptada.getActivoPrincipal().getCartera())) {
						if (expediente != null && expediente.getFechaContabilizacion() != null) {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
							pasaAVendido = updateEstadoExp;
						} else {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.FIRMADO);
						}
					} else {
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
						pasaAVendido = updateEstadoExp;
					}
					
					estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					if (updateEstadoExp) {
						expediente.setEstado(estado);
						// Finaliza el trámite
						Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
						tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
						genericDao.save(ActivoTramite.class, tramite);
					}

				}
				if (updateEstadoExp && !Checks.esNulo(estado)) recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

				expedienteComercialApi.update(expediente, pasaAVendido);
				
				if (pasaAVendido && !CODIGO_SUBCARTERA_OMEGA.equals(codSubCartera)) {
					for (ActivoOferta activoOferta : ofertaAceptada.getActivosOferta()) {
						Activo act = activoOferta.getPrimaryKey().getActivo();
		
						PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(act.getId());
						perimetro.setAplicaComercializar(0);
						perimetro.setAplicaPublicar(false);
						perimetro.setFechaAplicaPublicar(new Date());
						perimetro.setFechaAplicaComercializar(new Date());
						genericDao.save(PerimetroActivo.class, perimetro);
		
						// Marcamos el activo como vendido
						Filter filtroSituacionComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
						act.setSituacionComercial(genericDao.get(DDSituacionComercial.class, filtroSituacionComercial));
		
						act.setBloqueoPrecioFechaIni(new Date());
						activoApi.saveOrUpdate(act);
						
						
					}
		
					// Rechazamos el resto de ofertas
					List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
					Filter filtroMotivo;
					
					for (Oferta oferta : listaOfertas) {
						if (DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())) {
							filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "codigo",
									DDMotivoRechazoOferta.CODIGO_ACTIVO_VENDIDO);
							DDMotivoRechazoOferta motivo = genericDao.get(DDMotivoRechazoOferta.class,
									filtroMotivo);
							
							oferta.setMotivoRechazo(motivo);
							ofertaApi.rechazarOferta(oferta);
						}
					}
					if (expediente.getOferta() != null && DDCartera.isCarteraBBVA(expediente.getOferta().getActivoPrincipal().getCartera())) {
						try {
							notificatorServiceContabilidadBbva.notificatorFinTareaConValores(expediente,false);
						} catch (GestorDocumentalException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
		
		genericaRestDaoImp.doFlush();
		
		if (pasaAVendido) activoApi.actualizarOfertasTrabajosVivos(tramite.getActivo());
		
		if(!Checks.esNulo(tramite.getActivo())){
			activoAdapter.actualizarEstadoPublicacionActivo(tramite.getActivo().getId(), true);
		}
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_CIERRE_ECONOMICO, CODIGO_T017_CIERRE_ECONOMICO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
