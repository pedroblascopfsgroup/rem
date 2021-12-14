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
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceContabilidadBbva;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Formalizacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.rest.dao.impl.GenericaRestDaoImp;

@Component
public class UpdaterServiceSancionOfertaDocumentosPostVenta implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private NotificatorServiceContabilidadBbva notificatorServiceContabilidadBbva;

	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private GenericaRestDaoImp genericaRestDaoImp;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaDocumentosPostVenta.class);
	private static final String FECHA_INGRESO = "fechaIngreso";
	private static final String CHECKBOX_VENTA_DIRECTA = "checkboxVentaDirecta";
	private static final String COMBO_VENTA_SUPENSIVA = "comboVentaSupensiva";
	private static final String FECHA_CONTABILIZACION = "fechaContabilizacion";
	private static final String CODIGO_T013_DOCUMENTOS_POST_VENTA = "T013_DocumentosPostVenta";
	private static final String CODIGO_T017_DOCUMENTOS_POST_VENTA = "T017_DocsPosVenta";
	private static final String CODIGO_T013_CIERRE = "T013_CierreEconomico";
	private static final String CODIGO_T017_CIERRE = "T017_CierreEconomico";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		Date fechaContabilizacion = null;
		try {
			for (TareaExternaValor valor : valores) {
	
				// fecha ingreso cheque
				if (FECHA_INGRESO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					Oferta oferta = ofertaApi.trabajoToOferta(tramite.getTrabajo());
					ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
					
					if (!Checks.esNulo(expediente)) {
						expediente.setFechaContabilizacionPropietario(ft.parse(valor.getValor()));
					}
				}
	
				if (CHECKBOX_VENTA_DIRECTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					Oferta oferta = ofertaApi.trabajoToOferta(tramite.getTrabajo());
					Activo activo = oferta.getActivoPrincipal();
					activo.setVentaDirectaBankia("true".equals(valor.getValor()) ? true : false);
					genericDao.save(Activo.class, activo);
				}
				
				if (COMBO_VENTA_SUPENSIVA.equals(valor.getNombre()) && valor.getValor() != null) {
					Oferta oferta = ofertaApi.trabajoToOferta(tramite.getTrabajo());
					ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
					Formalizacion formalizacion = expedienteComercialApi.formalizacionPorExpedienteComercial(expediente.getId());
					formalizacion.setVentaCondicionSupensiva("true".equals(valor.getValor()) ? true : false);
					genericDao.save(Formalizacion.class, formalizacion);
				}
				
				if (FECHA_CONTABILIZACION.equals(valor.getNombre()) && valor.getValor() != null) {
					fechaContabilizacion = ft.parse(valor.getValor());
				}
			}
	
			Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
			if (!Checks.esNulo(ofertaAceptada)) {
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
	
				// Expediente se marca a vendido.
				Filter filtro = null;
				boolean pasaAVendido = false;
				boolean updateEstadoExp = true;
				List<TareaExterna> tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(tramite.getId());
				for (TareaExterna tarea : tareasTramite) {
					if (CODIGO_T013_CIERRE.equals(tarea.getTareaProcedimiento().getCodigo())
							|| CODIGO_T017_CIERRE.equals(tarea.getTareaProcedimiento().getCodigo())) {
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
				
				DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				if (updateEstadoExp) {
					expediente.setEstado(estado);
					// Finaliza el trámite
					Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
					tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
					genericDao.save(ActivoTramite.class, tramite);
				}
				
				if(!Checks.isFechaNula(fechaContabilizacion)) {
					expediente.setFechaContabilizacion(fechaContabilizacion);
				}
				
				if (updateEstadoExp) recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);
	
				expedienteComercialApi.update(expediente, pasaAVendido);
				
				if (pasaAVendido) {
					for (ActivoOferta activoOferta : ofertaAceptada.getActivosOferta()) {
						Activo activo = activoOferta.getPrimaryKey().getActivo();
		
						PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
						perimetro.setAplicaComercializar(0);
						perimetro.setAplicaPublicar(false);
						perimetro.setFechaAplicaPublicar(new Date());
						perimetro.setFechaAplicaComercializar(new Date());
						genericDao.save(PerimetroActivo.class, perimetro);
		
						// Marcamos el activo como vendido
						Filter filtroSituacionComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
						activo.setSituacionComercial(genericDao.get(DDSituacionComercial.class, filtroSituacionComercial));
		
						activo.setBloqueoPrecioFechaIni(new Date());
						activoApi.saveOrUpdate(activo);
						
						
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
	
				genericDao.save(Oferta.class, ofertaAceptada);
				
				genericaRestDaoImp.doFlush();
				
				if (pasaAVendido) activoApi.actualizarOfertasTrabajosVivos(tramite.getActivo());
				
				if(!Checks.esNulo(tramite.getActivo())){
					activoAdapter.actualizarEstadoPublicacionActivo(tramite.getActivo().getId(), true);
				}
	
			}
		}catch (ParseException e) {
			logger.error(e);
		}
	}

	public String[] getCodigoTarea() {
		return new String[] {CODIGO_T013_DOCUMENTOS_POST_VENTA, CODIGO_T017_DOCUMENTOS_POST_VENTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
