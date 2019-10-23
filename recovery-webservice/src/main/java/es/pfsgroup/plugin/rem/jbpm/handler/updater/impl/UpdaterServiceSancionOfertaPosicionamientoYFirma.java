package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPlusvalia;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGestionPlusv;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.plusvalia.NotificationPlusvaliaManager;

@Component
public class UpdaterServiceSancionOfertaPosicionamientoYFirma implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
    private ActivoDao activoDao;

    @Autowired
    private ActivoAdapter activoAdapter;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private NotificationPlusvaliaManager notificationPlusvaliaManager;

    @Resource
    private MessageService messageServices;

    protected final Log logger = LogFactory.getLog(getClass());

    private static final String COMBO_FIRMA = "comboFirma";
    private static final String FECHA_FIRMA = "fechaFirma";
    private static final String MOTIVO_NO_FIRMA = "motivoNoFirma";
    private static final String ASISTENCIA_PBC = "asistenciaPBC";
    private static final String ASISTENCIA_PBC_OBSERVACIONES = "obsAsisPBC";
    private static final String CODIGO_T013_POSICIONAMIENTOYFIRMA = "T013_PosicionamientoYFirma";
    private static final String CODIGO_T017_POSICIONAMIENTOYFIRMA = "T017_PosicionamientoYFirma";
    	
	private SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		    ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();
			Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
			if(!Checks.esNulo(ofertaAceptada)) {
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
	
				for(TareaExternaValor valor :  valores) {
	
					if(COMBO_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						Filter filtro;
						if(DDSiNo.SI.equals(valor.getValor())){
							String codCartera = ofertaAceptada.getActivoPrincipal().getCartera().getCodigo();
							if(DDCartera.CODIGO_CARTERA_LIBERBANK.equals(codCartera)  
									|| (Checks.esNulo(expediente.getFechaContabilizacionPropietario()) && DDCartera.CODIGO_CARTERA_BANKIA.equals(codCartera))
									|| DDCartera.CODIGO_CARTERA_CERBERUS.equals(codCartera)) {
								// Si el activo es de la cartera Bankia y no se ha hecho el ingreso de la compraventa (campo fecha ingreso cheque vacío).
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.FIRMADO);
							} else {
								// Si el activo es de cualquier otra cartera o si se ha hecho el ingreso de la compraventa  (campo fecha ingreso cheque informado).
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
							}
	
							for(ActivoOferta activoOferta : ofertaAceptada.getActivosOferta()) {
								Activo activo = activoOferta.getPrimaryKey().getActivo();
	
								PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
								perimetro.setAplicaComercializar(0);
								perimetro.setAplicaFormalizar(0);
								perimetro.setAplicaPublicar(false);
								//TODO: Cuando esté el motivo de no comercialización como texto libre, poner el texto: "Vendido".
								genericDao.save(PerimetroActivo.class, perimetro);
	
								//Marcamos el activo como vendido
								Filter filtroSituacionComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
								activo.setSituacionComercial(genericDao.get(DDSituacionComercial.class, filtroSituacionComercial));
	
								activo.setBloqueoPrecioFechaIni(new Date());

								//activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
								idActivoActualizarPublicacion.add(activo.getId());
								
								ActivoPlusvalia activoPlusvalia = activoDao.getPlusvaliaByIdActivo(activo.getId());
								if(!Checks.esNulo(activoPlusvalia)) {
								Filter filtroEstadoGestionPlusc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoGestionPlusv.COD_EN_CURSO);
								activoPlusvalia.setEstadoGestion(genericDao.get(DDEstadoGestionPlusv.class, filtroEstadoGestionPlusc));								
								genericDao.save(ActivoPlusvalia.class, activoPlusvalia);
								
								notificationPlusvaliaManager.sendNotificationPlusvaliaLiquidacion(activo, expediente);
								}
								
	
								activoApi.saveOrUpdate(activo);
							}

							List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
	
							//Rechazamos el resto de ofertas
							for(Oferta oferta : listaOfertas) {
								if(DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo())){
									ofertaApi.rechazarOferta(oferta);
								}
							}
	
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
						} else {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							expediente.setFechaVenta(null);
						}
					}
	
					//La fecha de firma la guardamos como la fecha de toma de posesión
					if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						for(ActivoOferta activoOferta : ofertaAceptada.getActivosOferta()) {
							Activo activo = activoOferta.getPrimaryKey().getActivo();

							PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
							perimetro.setAplicaComercializar(0);
							//TODO: Cuando esté el motivo de no comercialización como texto libre, poner el texto: "Vendido".
							genericDao.save(PerimetroActivo.class, perimetro);

							//Marcamos el activo como vendido (siempre y cuando no pertenezca a la cartera Liberbank)
							if(!DDCartera.CODIGO_CARTERA_LIBERBANK.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
								Filter filtroSituacionComercial = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
								activo.setSituacionComercial(genericDao.get(DDSituacionComercial.class, filtroSituacionComercial));
							}
							
							ActivoPlusvalia activoPlusvalia = activoDao.getPlusvaliaByIdActivo(activo.getId());
							if(!Checks.esNulo(activoPlusvalia)) {
							Filter filtroEstadoGestionPlusc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoGestionPlusv.COD_EN_CURSO);
							activoPlusvalia.setEstadoGestion(genericDao.get(DDEstadoGestionPlusv.class, filtroEstadoGestionPlusc));								
							genericDao.save(ActivoPlusvalia.class, activoPlusvalia);
							
							notificationPlusvaliaManager.sendNotificationPlusvaliaLiquidacion(activo, expediente);
							}
							
							activo.setBloqueoPrecioFechaIni(new Date());
							
														
							ActivoSituacionPosesoria situacionPosesoria = activo.getSituacionPosesoria();
							
							Filter tituloActivo;
							DDTipoTituloActivoTPA tipoTitulo;
							tituloActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
							tipoTitulo = genericDao.get(DDTipoTituloActivoTPA.class, tituloActivo);
							
							if(!Checks.esNulo(situacionPosesoria) && !Checks.esNulo(situacionPosesoria.getConTitulo()) && (DDTipoTituloActivoTPA.tipoTituloSi.equals(situacionPosesoria.getConTitulo().getCodigo()) && situacionPosesoria.getOcupado() == 1)){
								situacionPosesoria.setConTitulo(tipoTitulo);
								situacionPosesoria.setFechaUltCambioTit(new Date());
								situacionPosesoria.setOcupado(1);
							}else if(!Checks.esNulo(situacionPosesoria) && !Checks.esNulo(situacionPosesoria.getConTitulo()) && (DDTipoTituloActivoTPA.tipoTituloNo.equals(situacionPosesoria.getConTitulo().getCodigo()) && situacionPosesoria.getOcupado() == 1)) {
								//si esta okupado ilegalmente no se modifica la situación posesoria
							}else{
								situacionPosesoria.setConTitulo(tipoTitulo);
								situacionPosesoria.setFechaUltCambioTit(new Date());
								situacionPosesoria.setOcupado(0);
							}
							
							try {
								situacionPosesoria.setFechaTomaPosesion(ft.parse(valor.getValor()));
							} catch (ParseException e) {
								logger.error("Error en la tarea '" + CODIGO_T013_POSICIONAMIENTOYFIRMA + "', mensaje: " + e.getMessage());
								e.printStackTrace();
							}
							activo.setSituacionPosesoria(situacionPosesoria);
						}

						try {
							expediente.setFechaVenta(ft.parse(valor.getValor()));
						} catch (ParseException e) {
							logger.error("Error en la tarea '" + CODIGO_T013_POSICIONAMIENTOYFIRMA + "', mensaje: " + e.getMessage());
							e.printStackTrace();
						}
					}
	
					if(MOTIVO_NO_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						// Se incluye un motivo de anulacion del expediente, si se indico en la tarea
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
						DDMotivoAnulacionExpediente motivoAnulacion = genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
						expediente.setMotivoAnulacion(motivoAnulacion);
					}
					
					if(ASISTENCIA_PBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						if(DDSiNo.SI.equals(valor.getValor())){
							expediente.setAsistenciaPbc(true);
						}else{
							expediente.setAsistenciaPbc(false);
						}
					}
					
					if(ASISTENCIA_PBC_OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						expediente.setObsAsisPbc(valor.getValor());
					}
				}
			}
			activoAdapter.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion,true);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_POSICIONAMIENTOYFIRMA, CODIGO_T017_POSICIONAMIENTOYFIRMA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
